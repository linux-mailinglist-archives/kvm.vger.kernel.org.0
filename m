Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264A639DBE2
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 14:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhFGMGW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 08:06:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27280 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230127AbhFGMGV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 08:06:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623067470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CkmIMBTswpMckTxaSmzOXas4B5NdqZPOqbb/j4xAsLc=;
        b=NCU8sg/5pmmNb16k6UU6F/kICYQbPg4dGTl2nIB8qYCP7XOm3pyhJrYty5DEOsjhZlq4AR
        d/0/gEyUUsJ0PePDWxSYwuM9qdcEDC+xChjku11hLZAkZaV2H+yRZ4nYGjLbuvlw3Qm4VF
        CU+I/UCOZvyOme/OInWMKhPgHaZr1qQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-4fNwt0xsPWe4eCGDB_s_fQ-1; Mon, 07 Jun 2021 08:04:29 -0400
X-MC-Unique: 4fNwt0xsPWe4eCGDB_s_fQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E24418C35BE;
        Mon,  7 Jun 2021 12:04:26 +0000 (UTC)
Received: from starship (unknown [10.40.194.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E4D018F0A;
        Mon,  7 Jun 2021 12:04:22 +0000 (UTC)
Message-ID: <fc7af00f4b4e75dfd67539602caed71e1e035154.camel@redhat.com>
Subject: Re: [PATCH v5 09/11] KVM: X86: Add vendor callbacks for writing the
 TSC multiplier
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Stamatis, Ilias" <ilstam@amazon.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc:     "jmattson@google.com" <jmattson@google.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Date:   Mon, 07 Jun 2021 15:04:21 +0300
In-Reply-To: <9caefa1ad707fdb61448234b37716f89643aca86.camel@amazon.com>
References: <20210528105745.1047-1-ilstam@amazon.com>
         <630c273d554b422b9caacb0b82995ead0b7e2dbd.camel@redhat.com>
         <9caefa1ad707fdb61448234b37716f89643aca86.camel@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-06-07 at 10:25 +0000, Stamatis, Ilias wrote:
> On Sun, 2021-05-30 at 12:51 +0300, Maxim Levitsky wrote:
> > On Fri, 2021-05-28 at 11:57 +0100, Ilias Stamatis wrote:
> > > Currently vmx_vcpu_load_vmcs() writes the TSC_MULTIPLIER field of the
> > > VMCS every time the VMCS is loaded. Instead of doing this, set this
> > > field from common code on initialization and whenever the scaling ratio
> > > changes.
> > > 
> > > Additionally remove vmx->current_tsc_ratio. This field is redundant as
> > > vcpu->arch.tsc_scaling_ratio already tracks the current TSC scaling
> > > ratio. The vmx->current_tsc_ratio field is only used for avoiding
> > > unnecessary writes but it is no longer needed after removing the code
> > > from the VMCS load path.
> > > 
> > > Suggested-by: Sean Christopherson <seanjc@google.com>
> > > Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> > > ---
> > >  arch/x86/include/asm/kvm-x86-ops.h |  1 +
> > >  arch/x86/include/asm/kvm_host.h    |  1 +
> > >  arch/x86/kvm/svm/svm.c             |  6 ++++++
> > >  arch/x86/kvm/vmx/nested.c          |  9 ++++-----
> > >  arch/x86/kvm/vmx/vmx.c             | 11 ++++++-----
> > >  arch/x86/kvm/vmx/vmx.h             |  8 --------
> > >  arch/x86/kvm/x86.c                 | 30 +++++++++++++++++++++++-------
> > >  7 files changed, 41 insertions(+), 25 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > > index 029c9615378f..34ad7a17458a 100644
> > > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > > @@ -90,6 +90,7 @@ KVM_X86_OP_NULL(has_wbinvd_exit)
> > >  KVM_X86_OP(get_l2_tsc_offset)
> > >  KVM_X86_OP(get_l2_tsc_multiplier)
> > >  KVM_X86_OP(write_tsc_offset)
> > > +KVM_X86_OP(write_tsc_multiplier)
> > >  KVM_X86_OP(get_exit_info)
> > >  KVM_X86_OP(check_intercept)
> > >  KVM_X86_OP(handle_exit_irqoff)
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index f099277b993d..a334ce7741ab 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1308,6 +1308,7 @@ struct kvm_x86_ops {
> > >       u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
> > >       u64 (*get_l2_tsc_multiplier)(struct kvm_vcpu *vcpu);
> > >       void (*write_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
> > > +     void (*write_tsc_multiplier)(struct kvm_vcpu *vcpu, u64 multiplier);
> > > 
> > >       /*
> > >        * Retrieve somewhat arbitrary exit information.  Intended to be used
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index 8dfb2513b72a..cb701b42b08b 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -1103,6 +1103,11 @@ static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
> > >       vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
> > >  }
> > > 
> > > +static void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
> > > +{
> > > +     wrmsrl(MSR_AMD64_TSC_RATIO, multiplier);
> > > +}
> > > +
> > >  /* Evaluate instruction intercepts that depend on guest CPUID features. */
> > >  static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu,
> > >                                             struct vcpu_svm *svm)
> > > @@ -4528,6 +4533,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> > >       .get_l2_tsc_offset = svm_get_l2_tsc_offset,
> > >       .get_l2_tsc_multiplier = svm_get_l2_tsc_multiplier,
> > >       .write_tsc_offset = svm_write_tsc_offset,
> > > +     .write_tsc_multiplier = svm_write_tsc_multiplier,
> > > 
> > >       .load_mmu_pgd = svm_load_mmu_pgd,
> > > 
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index 6058a65a6ede..239154d3e4e7 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -2533,9 +2533,8 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
> > >       }
> > > 
> > >       vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_offset);
> > > -
> > >       if (kvm_has_tsc_control)
> > > -             decache_tsc_multiplier(vmx);
> > > +             vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);
> > 
> > We still end up writing the TSC_MULTIPLIER in the vmcs02 on each nested VM entry
> > almost always for nothing since for the vast majority of the entries we will
> > write the same value.
> > 
> 
> Yes, I already addressed this but as per Sean's response this should be alright
> for now and it can be "fixed" in a separate series. 
> 
> This patch completely removes the vmwrite from the VMCS01 load path which is
> called more frequently anyway.

All right then.

> 
> > It is probably OK for now to leave it like that, and then add some sort of 'dirty' tracking
> > to track if the userspace or L1 changed the TSC multiplier for L2 (L1 writes to vmcb12
> > are tracked by using the 'dirty_vmcs' flag, assuming that we don't shadow TSC_MULTIPLIER field)
> > 
> > So the above should later go to prepare_vmcs02_rare, and it should also be done if
> > host TSC multiplier changed (not a problem IMHO to have another piece of code doing that).
> > 
> > 
> > >       nested_vmx_transition_tlb_flush(vcpu, vmcs12, true);
> > > 
> > > @@ -4501,12 +4500,12 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
> > >       vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
> > >       vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
> > >       vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_offset);
> > > +     if (kvm_has_tsc_control)
> > > +             vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);
> > 
> > This I think isn't needed, since this write is done after we have already
> > switched to vmcs01, and it should have the L1 value it had prior
> > to the nested entry.
> > 
> 
> What if userspace changed L1's multiplier while L2 was active?

True point, but the userspace really has to be crazy to do this.
Currently even after a migration qemu sets the TSC multipliers
before it loads the nested state.
 
I guess this is fair to leave this vmwrite but if you respin this
patch I would appreciate a comment about this case, for the next
guy that wonders the same thing that I did.

Or it would also be a valid solution to remove this vmwrite still and
instead fails if the userspace adjusts tsc scaling while the guest is active.

> 
> > > +
> > >       if (vmx->nested.l1_tpr_threshold != -1)
> > >               vmcs_write32(TPR_THRESHOLD, vmx->nested.l1_tpr_threshold);
> > > 
> > > -     if (kvm_has_tsc_control)
> > > -             decache_tsc_multiplier(vmx);
> > > -
> > >       if (vmx->nested.change_vmcs01_virtual_apic_mode) {
> > >               vmx->nested.change_vmcs01_virtual_apic_mode = false;
> > >               vmx_set_virtual_apic_mode(vcpu);
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 4b70431c2edd..bf845a08995e 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -1390,11 +1390,6 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
> > > 
> > >               vmx->loaded_vmcs->cpu = cpu;
> > >       }
> > > -
> > > -     /* Setup TSC multiplier */
> > > -     if (kvm_has_tsc_control &&
> > > -         vmx->current_tsc_ratio != vcpu->arch.tsc_scaling_ratio)
> > > -             decache_tsc_multiplier(vmx);
> > >  }
> > > 
> > >  /*
> > > @@ -1813,6 +1808,11 @@ static void vmx_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
> > >       vmcs_write64(TSC_OFFSET, offset);
> > >  }
> > > 
> > > +static void vmx_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
> > > +{
> > > +     vmcs_write64(TSC_MULTIPLIER, multiplier);
> > > +}
> > > +
> > >  /*
> > >   * nested_vmx_allowed() checks whether a guest should be allowed to use VMX
> > >   * instructions and MSRs (i.e., nested VMX). Nested VMX is disabled for
> > > @@ -7707,6 +7707,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
> > >       .get_l2_tsc_offset = vmx_get_l2_tsc_offset,
> > >       .get_l2_tsc_multiplier = vmx_get_l2_tsc_multiplier,
> > >       .write_tsc_offset = vmx_write_tsc_offset,
> > > +     .write_tsc_multiplier = vmx_write_tsc_multiplier,
> > > 
> > >       .load_mmu_pgd = vmx_load_mmu_pgd,
> > > 
> > > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > > index aa97c82e3451..3eaa86a0ba3e 100644
> > > --- a/arch/x86/kvm/vmx/vmx.h
> > > +++ b/arch/x86/kvm/vmx/vmx.h
> > > @@ -322,8 +322,6 @@ struct vcpu_vmx {
> > >       /* apic deadline value in host tsc */
> > >       u64 hv_deadline_tsc;
> > > 
> > > -     u64 current_tsc_ratio;
> > > -
> > >       unsigned long host_debugctlmsr;
> > > 
> > >       /*
> > > @@ -532,12 +530,6 @@ static inline struct vmcs *alloc_vmcs(bool shadow)
> > >                             GFP_KERNEL_ACCOUNT);
> > >  }
> > > 
> > > -static inline void decache_tsc_multiplier(struct vcpu_vmx *vmx)
> > > -{
> > > -     vmx->current_tsc_ratio = vmx->vcpu.arch.tsc_scaling_ratio;
> > > -     vmcs_write64(TSC_MULTIPLIER, vmx->current_tsc_ratio);
> > > -}
> > > -
> > >  static inline bool vmx_has_waitpkg(struct vcpu_vmx *vmx)
> > >  {
> > >       return vmx->secondary_exec_control &
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 801fa1e8e915..c1e14dadad2d 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -2179,14 +2179,15 @@ static u32 adjust_tsc_khz(u32 khz, s32 ppm)
> > >       return v;
> > >  }
> > > 
> > > +static void kvm_vcpu_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 l1_multiplier);
> > > +
> > >  static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
> > >  {
> > >       u64 ratio;
> > > 
> > >       /* Guest TSC same frequency as host TSC? */
> > >       if (!scale) {
> > > -             vcpu->arch.l1_tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
> > > -             vcpu->arch.tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
> > > +             kvm_vcpu_write_tsc_multiplier(vcpu, kvm_default_tsc_scaling_ratio);
> > >               return 0;
> > >       }
> > > 
> > > @@ -2212,7 +2213,7 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
> > >               return -1;
> > >       }
> > > 
> > > -     vcpu->arch.l1_tsc_scaling_ratio = vcpu->arch.tsc_scaling_ratio = ratio;
> > > +     kvm_vcpu_write_tsc_multiplier(vcpu, ratio);
> > >       return 0;
> > >  }
> > > 
> > > @@ -2224,8 +2225,7 @@ static int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
> > >       /* tsc_khz can be zero if TSC calibration fails */
> > >       if (user_tsc_khz == 0) {
> > >               /* set tsc_scaling_ratio to a safe value */
> > > -             vcpu->arch.l1_tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
> > > -             vcpu->arch.tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
> > > +             kvm_vcpu_write_tsc_multiplier(vcpu, kvm_default_tsc_scaling_ratio);
> > >               return -1;
> > >       }
> > > 
> > > @@ -2383,6 +2383,23 @@ static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 l1_offset)
> > >       static_call(kvm_x86_write_tsc_offset)(vcpu, vcpu->arch.tsc_offset);
> > >  }
> > > 
> > > +static void kvm_vcpu_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 l1_multiplier)
> > > +{
> > > +     vcpu->arch.l1_tsc_scaling_ratio = l1_multiplier;
> > > +
> > > +     /* Userspace is changing the multiplier while L2 is active */
> > 
> > Nitpick about the comment:
> > On SVM, the TSC multiplier is a MSR, so a crazy L1 can give L2 access to it,
> > so L2 can in theory change its TSC multiplier as well
> > (I am not sure if this is even allowed by the SVM spec)
> > 
> 
> If L1 chooses not to trap a WRMSR to the multiplier this should still change
> L1's multiplier, not L2's, right? 

Yes, and my nitpick was about the fact that the comment states that userspace
is changing it, but the guest in theory can change it as well.


Best regards,
	Maxim Levitsky

> 
> It's the exact same case we have in kvm_vcpu_write_tsc_offset() too and the 
> comment there addresses exactly this.



> 
> > > +     if (is_guest_mode(vcpu))
> > > +             vcpu->arch.tsc_scaling_ratio = kvm_calc_nested_tsc_multiplier(
> > > +                     l1_multiplier,
> > > +                     static_call(kvm_x86_get_l2_tsc_multiplier)(vcpu));
> > > +     else
> > > +             vcpu->arch.tsc_scaling_ratio = l1_multiplier;
> > > +
> > > +     if (kvm_has_tsc_control)
> > > +             static_call(kvm_x86_write_tsc_multiplier)(
> > > +                     vcpu, vcpu->arch.tsc_scaling_ratio);
> > > +}
> > > +
> > >  static inline bool kvm_check_tsc_unstable(void)
> > >  {
> > >  #ifdef CONFIG_X86_64
> > > @@ -10343,8 +10360,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> > >       else
> > >               vcpu->arch.mp_state = KVM_MP_STATE_UNINITIALIZED;
> > > 
> > > -     kvm_set_tsc_khz(vcpu, max_tsc_khz);
> > > -
> > >       r = kvm_mmu_create(vcpu);
> > >       if (r < 0)
> > >               return r;
> > > @@ -10443,6 +10458,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
> > >       if (mutex_lock_killable(&vcpu->mutex))
> > >               return;
> > >       vcpu_load(vcpu);
> > > +     kvm_set_tsc_khz(vcpu, max_tsc_khz);
> > >       kvm_synchronize_tsc(vcpu, 0);
> > >       vcpu_put(vcpu);
> > > 
> > 
> > Best regards,
> >         Maxim Levitsky
> > 
> > 
> 
> 


