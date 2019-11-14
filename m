Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73815FCAC8
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 17:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfKNQeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 11:34:46 -0500
Received: from mga03.intel.com ([134.134.136.65]:27987 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbfKNQeq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 11:34:46 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Nov 2019 08:34:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,304,1569308400"; 
   d="scan'208";a="216798796"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga002.jf.intel.com with ESMTP; 14 Nov 2019 08:34:45 -0800
Date:   Thu, 14 Nov 2019 08:34:45 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 1/2] KVM: X86: Single target IPI fastpath
Message-ID: <20191114163444.GD24045@linux.intel.com>
References: <1573283135-5502-1-git-send-email-wanpengli@tencent.com>
 <6c2c7bbb-39f4-2a77-632e-7730e9887fc5@redhat.com>
 <20191114152235.GC24045@linux.intel.com>
 <857e6494-4ed8-be4a-c21a-577ab99a5711@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <857e6494-4ed8-be4a-c21a-577ab99a5711@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 14, 2019 at 04:44:33PM +0100, Paolo Bonzini wrote:
> On 14/11/19 16:22, Sean Christopherson wrote:
> >> Instead of a separate vcpu->fast_vmexit, perhaps you can set exit_reason
> >> to vmx->exit_reason to -1 if the fast path succeeds.
> > 
> > Actually, rather than make this super special case, what about moving the
> > handling into vmx_handle_exit_irqoff()?  Practically speaking that would
> > only add ~50 cycles (two VMREADs) relative to the code being run right
> > after kvm_put_guest_xcr0().  It has the advantage of restoring the host's
> > hardware breakpoints, preserving a semi-accurate last_guest_tsc, and
> > running with vcpu->mode set back to OUTSIDE_GUEST_MODE.  Hopefully it'd
> > also be more intuitive for people unfamiliar with the code.
> 
> Yes, that's a good idea.  The expensive bit between handle_exit_irqoff
> and handle_exit is srcu_read_lock, which has two memory barriers in it.

Preaching to the choir at this point, but it'd also eliminate latency
spikes due to interrupts.

> >>> +			if (ret == 0)
> >>> +				ret = kvm_skip_emulated_instruction(vcpu);
> >> Please move the "kvm_skip_emulated_instruction(vcpu)" to
> >> vmx_handle_exit, so that this basically is
> >>
> >> #define EXIT_REASON_NEED_SKIP_EMULATED_INSN -1
> >>
> >> 	if (ret == 0)
> >> 		vcpu->exit_reason = EXIT_REASON_NEED_SKIP_EMULATED_INSN;
> >>
> >> and handle_ipi_fastpath can return void.
> >
> > I'd rather we add a dedicated variable to say the exit has already been
> > handled.  Overloading exit_reason is bound to cause confusion, and that's
> > probably a best case scenario.
> 
> I proposed the fake exit reason to avoid a ternary return code from
> handle_ipi_fastpath (return to guest, return to userspace, call
> kvm_x86_ops->handle_exit), which Wanpeng's patch was mishandling.

For this case, I think we can get away with a WARN if kvm_lapic_reg_write()
fails since it (currently) can't fail for ICR.  That would allow us to keep
a void return for ->handle_exit_irqoff() and avoid an overloaded return
value.

And, if the fastpath is used for all ICR writes, not just FIXED+PHYSICAL,
and is implemented for SVM, then we don't even need a a flag, e.g.
kvm_x2apic_msr_write() can simply ignore ICR writes, similar to how
handle_exception() ignores #MC and NMIs.

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 87b0fcc23ef8..d7b79f7faac1 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2615,12 +2615,11 @@ int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
        if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(apic))
                return 1;

-       if (reg == APIC_ICR2)
+
+       /* ICR2 writes are ignored and ICR writes are handled early. */
+       if (reg == APIC_ICR2 || reg == APIC_ICR)
                return 1;

-       /* if this is ICR write vector before command */
-       if (reg == APIC_ICR)
-               kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
        return kvm_lapic_reg_write(apic, reg, (u32)data);
 }

Another bonus to this approach is that the refactoring for the
exit_reason can be done in a separate series.

> To ensure confusion does not become the best case scenario, perhaps it
> is worth trying to push exit_reason into vcpu_enter_guest's stack.
> vcpu_enter_guest can pass a pointer to it, and then it can be passed
> back into kvm_x86_ops->handle_exit{,_irqoff}.  It could be a struct too,
> instead of just a bare u32.

On the other hand, if it's a bare u32 then kvm_x86_ops->run can simply
return the value instead of doing out parameter shenanigans.

> This would ensure at compile-time that exit_reason is not accessed
> outside the short path from vmexit to kvm_x86_ops->handle_exit.

That would be nice.  Surprisingly, the code actually appears to be fairly
clean, I thought for sure the nested stuff would be using exit_reason all
over the place.  The only one that needs to be fixed is handle_vmfunc(),
which passes vmx->exit_reason when forwarding the VM-Exit instead of simply
hardcoding EXIT_REASON_VMFUNC.
