Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08E32851A7
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 20:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgJFSfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 14:35:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:9314 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgJFSfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 14:35:12 -0400
IronPort-SDR: cVd3o22uFl2/jQArJOob66txAh9DIsakqoWKNhn+VXk3XBgYyq2b8dCOQzgf32iOWzaMM6Mkf4
 fiDoO2bv6gzQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="164762015"
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="164762015"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 11:35:03 -0700
IronPort-SDR: SUEmG4YCC05mmETbutccpVDvJK8Y1GFbNiBcCARxE9UTi0TmmHIfGFxxVfO56PZYlSbH2xs9sP
 NXHktZWmKnzA==
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="315784611"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 11:35:03 -0700
Date:   Tue, 6 Oct 2020 11:35:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH] KVM: nVMX: Morph notification vector IRQ on nested
 VM-Enter to pending PI
Message-ID: <20201006183501.GD17610@linux.intel.com>
References: <20200812175129.12172-1-sean.j.christopherson@intel.com>
 <CALMp9eTc9opgQ4pU92wmKSM6gUv6AEKZRqSnv_Q+rzixOLOZiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eTc9opgQ4pU92wmKSM6gUv6AEKZRqSnv_Q+rzixOLOZiw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 06, 2020 at 10:36:09AM -0700, Jim Mattson wrote:
> On Wed, Aug 12, 2020 at 10:51 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On successful nested VM-Enter, check for pending interrupts and convert
> > the highest priority interrupt to a pending posted interrupt if it
> > matches L2's notification vector.  If the vCPU receives a notification
> > interrupt before nested VM-Enter (assuming L1 disables IRQs before doing
> > VM-Enter), the pending interrupt (for L1) should be recognized and
> > processed as a posted interrupt when interrupts become unblocked after
> > VM-Enter to L2.
> >
> > This fixes a bug where L1/L2 will get stuck in an infinite loop if L1 is
> > trying to inject an interrupt into L2 by setting the appropriate bit in
> > L2's PIR and sending a self-IPI prior to VM-Enter (as opposed to KVM's
> > method of manually moving the vector from PIR->vIRR/RVI).  KVM will
> > observe the IPI while the vCPU is in L1 context and so won't immediately
> > morph it to a posted interrupt for L2.  The pending interrupt will be
> > seen by vmx_check_nested_events(), cause KVM to force an immediate exit
> > after nested VM-Enter, and eventually be reflected to L1 as a VM-Exit.
> > After handling the VM-Exit, L1 will see that L2 has a pending interrupt
> > in PIR, send another IPI, and repeat until L2 is killed.
> >
> > Note, posted interrupts require virtual interrupt deliveriy, and virtual
> > interrupt delivery requires exit-on-interrupt, ergo interrupts will be
> > unconditionally unmasked on VM-Enter if posted interrupts are enabled.
> >
> > Fixes: 705699a13994 ("KVM: nVMX: Enable nested posted interrupt processing")
> > Cc: stable@vger.kernel.org
> > Cc: Liran Alon <liran.alon@oracle.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> I don't think this is the best fix.

I agree, even without any more explanantion :-)

> I believe the real problem is the way that external and posted
> interrupts are handled in vmx_check_nested_events().
> 
> First of all, I believe that the existing call to
> vmx_complete_nested_posted_interrupt() at the end of
> vmx_check_nested_events() is far too aggressive. Unless I am missing
> something in the SDM, posted interrupt processing is *only* triggered
> when the notification vector is received in VMX non-root mode. It is
> not triggered on VM-entry.

That's my understanding as well.  Virtual interrupt delivery is evaluated
on VM-Enter, but not posted interrupts.

  Evaluation of pending virtual interrupts is caused only by VM entry, TPR
  virtualization, EOI virtualization, self-IPI virtualization, and posted-
  interrupt processing. 

> Looking back one block, we have:
> 
> if (kvm_cpu_has_interrupt(vcpu) && !vmx_interrupt_blocked(vcpu)) {
>     if (block_nested_events)
>         return -EBUSY;
>     if (!nested_exit_on_intr(vcpu))
>         goto no_vmexit;
>     nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT, 0, 0);
>     return 0;
> }
> 
> If nested_exit_on_intr() is true, we should first check to see if
> "acknowledge interrupt on exit" is set. If so, we should acknowledge
> the interrupt right here, with a call to kvm_cpu_get_interrupt(),
> rather than deep in the guts of nested_vmx_vmexit(). If the vector we
> get is the notification vector from VMCS12, then we should call
> vmx_complete_nested_posted_interrupt(). Otherwise, we should call
> nested_vmx_vmexit(EXIT_REASON_EXTERNAL_INTERRUPT) as we do now.

That makes sense.  And we can pass in exit_intr_info instead of computing
it in nested_vmx_vmexit() since this is the only path that does a nested
exit with EXIT_REASON_EXTERNAL_INTERRUPT.

> Furthermore, vmx_complete_nested_posted_interrupt() should write to
> the L1 EOI register, as indicated in step 4 of the 7-step sequence
> detailed in section 29.6 of the SDM, volume 3. It skips this step
> today.

Yar.

Thanks Jim!  I'll get a series out.
