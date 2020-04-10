Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B77271A497E
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 19:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgDJRrG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 13:47:06 -0400
Received: from mga17.intel.com ([192.55.52.151]:60983 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbgDJRrG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 13:47:06 -0400
IronPort-SDR: FtmdiKKlcZlaITaleAASBm2RzQKpihY/d5i7WKT9TuiSADW/z2Xte70xROvJ82zCgsaRPFlB/t
 qW+Nzeg4K0jA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2020 10:47:06 -0700
IronPort-SDR: sAL192Ejy2Wak0bWXQKAg4Yf3uqBnFsPWlharKyDigt4rkyyhCh7ruAhcOAWDaOScxd92iYE5L
 W9hSH+uVXsEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,367,1580803200"; 
   d="scan'208";a="297857976"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Apr 2020 10:47:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Haiwei Li <lihaiwei@tencent.com>
Subject: Re: [PATCH v2] KVM: X86: Ultra fast single target IPI fastpath
Date:   Fri, 10 Apr 2020 10:47:01 -0700
Message-Id: <20200410174703.1138-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <f51251cc-885e-2f7a-b18d-faa76db15b87@redhat.com>
References: <f51251cc-885e-2f7a-b18d-faa76db15b87@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 10, 2020 at 05:50:35PM +0200, Paolo Bonzini wrote:
> On 10/04/20 17:35, Sean Christopherson wrote:
> > IMO, this should come at the very end of vmx_vcpu_run().  At a minimum, it
> > needs to be moved below the #MC handling and below
> >
> >     if (vmx->fail || (vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
> >             return;
>
> Why?  It cannot run in any of those cases, since the vmx->exit_reason
> won't match.

#MC and consistency checks should have "priority" over everything else.
That there isn't actually a conflict is irrelevant IMO.  And it's something
that will likely confuse newbies (to VMX and/or KVM) as it won't be obvious
that the motivation was to shave a few cycles, e.g. versus some corner case
where the fastpath handling does something meaningful even on failure.

> > KVM more or less assumes vmx->idt_vectoring_info is always valid, and it's
> > not obvious that a generic fastpath call can safely run before
> > vmx_complete_interrupts(), e.g. the kvm_clear_interrupt_queue() call.
>
> Not KVM, rather vmx.c.  You're right about a generic fastpath, but in
> this case kvm_irq_delivery_to_apic_fast is not touching VMX state; even
> if you have a self-IPI, the modification of vCPU state is only scheduled
> here and will happen later via either kvm_x86_ops.sync_pir_to_irr or
> KVM_REQ_EVENT.

I think what I don't like is that the fast-IPI code is buried in a helper
that masquerades as a generic fastpath handler.  If that's open-coded in
vmx_vcpu_run(), I'm ok with doing the fast-IPI handler immediately after
the failure checks.

And fast-IPI aside, the code could use a bit of optimization to prioritize
successful VM-Enter, which would slot in nicely as a prep patch.  Patches
(should be) following.

IMO, this is more logically correct:

	vmx->exit_reason = vmcs_read32(VM_EXIT_REASON);
	if (unlikely((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY))
		kvm_machine_check();

	if (unlikely(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
		return EXIT_FASTPATH_NONE;

	if (!is_guest_mode(vcpu) && vmx->exit_reason == EXIT_REASON_MSR_WRITE)
		exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
	else
		exit_fastpath = EXIT_FASTPATH_NONE;

And on my system, the compiler hoists fast-IPI above the #MC, e.g. moving
the fast-IPI down only adds a single macrofused uop, testb+jne for
FAILED_VMENTERY, to the code path.

   0xffffffff81067d1d <+701>:   vmread %rax,%rax
   0xffffffff81067d20 <+704>:   ja,pt  0xffffffff81067d2d <vmx_vcpu_run+717>
   0xffffffff81067d23 <+707>:   pushq  $0x0
   0xffffffff81067d25 <+709>:   push   %rax
   0xffffffff81067d26 <+710>:   callq  0xffffffff81071790 <vmread_error_trampoline>
   0xffffffff81067d2b <+715>:   pop    %rax
   0xffffffff81067d2c <+716>:   pop    %rax
   0xffffffff81067d2d <+717>:   test   %eax,%eax
   0xffffffff81067d2f <+719>:   mov    %eax,0x32b0(%rbp)
   0xffffffff81067d35 <+725>:   js     0xffffffff81067d5a <vmx_vcpu_run+762>
   0xffffffff81067d37 <+727>:   testb  $0x20,0x2dc(%rbp)
   0xffffffff81067d3e <+734>:   jne    0xffffffff81067d49 <vmx_vcpu_run+745>
   0xffffffff81067d40 <+736>:   cmp    $0x20,%eax
   0xffffffff81067d43 <+739>:   je     0xffffffff810686d4 <vmx_vcpu_run+3188> <-- fastpath handler
   0xffffffff81067d49 <+745>:   xor    %ebx,%ebx
   0xffffffff81067d4b <+747>:   jmpq   0xffffffff81067e65 <vmx_vcpu_run+1029>
