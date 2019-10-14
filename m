Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD24D69C5
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 20:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732674AbfJNSuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 14:50:50 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:43078 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730992AbfJNSut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 14:50:49 -0400
Received: by mail-io1-f65.google.com with SMTP id v2so40155326iob.10
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 11:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=84WasCH/AobEiT3sf/dTs4pGrj2UniP/dmFrgh2RvEk=;
        b=irv9+SoudGX2Pz4ivWgU6l83bOTlPX05ipDK+ojeOMAeFn6L3aaZfs3QTqY85/3Yuf
         K4TsuSr3FX/9dil54rGLglEVl3fPszKsynw9yrB/y7Aqfwia1KUEMyoM7oSYJgcqyl6I
         9vh3LmJnzo34+qkhFSprMaxoMThNaLaf/0vio57PvuWKz2z41XdPmuAME6Vgj5gace5x
         87YDa9aAFBvcnBB9y14SdZECI4Pg4fGaI01sioJO2aKGLIJfm2B9d9z2IkjbT6bimtlf
         nVirjtLHBLdMS/kU97ZPbYA2dJeBryXhv4cTkl+o7NhUcmMOmRvL1vsZcw2Vodr0SO1M
         69jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=84WasCH/AobEiT3sf/dTs4pGrj2UniP/dmFrgh2RvEk=;
        b=LfOBlkdQhfNi29kyWcTMkBHB92p+TBbrCOnQ0zSGhEVV/CowHskqT8ldUljkJSYPHn
         wOB7gey29mNe9KcR6opkuc2SkbEiKOmb3OcbDVJoQa3l9OK/kxtvgLLFMdL1701qkWsE
         O1+lksB+7w3uqDAcn2axUuaDeo4o9pF7cn23WEQMPDNjYVXMXH86dcty/pFc6PA7lb8q
         WnaDi/XcQ8o0kaCgv/1IsyA3/CDIITk7E0rdYxQe4LuS45tp9oJnCIVCxmgYa+CK4ufb
         3czDN8iViZQ2KhkZuU7OycFvIyvcLS+JXf1dslxG2uisoSIq7pPcb4EISS0R1C1L847M
         k7Vw==
X-Gm-Message-State: APjAAAVC+6b8uEA5dmII5mw6A0YznhMnMP0+jcnKh79iUENkpaCQMcHN
        g4EvHs7fnKo2ul7Bsir+b05Jm8+zGNLVBxn8EUEAQA==
X-Google-Smtp-Source: APXvYqzdkLnvuj5yN6DxriZnFyrtqQBib/T3Jx3CUZW/afEOSY9lERIdUq5O4BQ+9r+UpA+RDeW/SY5n5ExUGhPh1JM=
X-Received: by 2002:a92:c142:: with SMTP id b2mr2017717ilh.118.1571079048275;
 Mon, 14 Oct 2019 11:50:48 -0700 (PDT)
MIME-Version: 1.0
References: <20191010232819.135894-1-jmattson@google.com> <20191014175936.GD22962@linux.intel.com>
In-Reply-To: <20191014175936.GD22962@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 14 Oct 2019 11:50:37 -0700
Message-ID: <CALMp9eS_fYjyTDG75316cdyCp6NRHAHmN2J+sTf9uxvUfiEsQA@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: nVMX: Don't leak L1 MMIO regions to L2
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>, Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Cross <dcross@google.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 14, 2019 at 10:59 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, Oct 10, 2019 at 04:28:19PM -0700, Jim Mattson wrote:
> > If the "virtualize APIC accesses" VM-execution control is set in the
> > VMCS, the APIC virtualization hardware is triggered when a page walk
> > in VMX non-root mode terminates at a PTE wherein the address of the 4k
> > page frame matches the APIC-access address specified in the VMCS. On
> > hardware, the APIC-access address may be any valid 4k-aligned physical
> > address.
> >
> > KVM's nVMX implementation enforces the additional constraint that the
> > APIC-access address specified in the vmcs12 must be backed by
> > cacheable memory in L1. If not, L0 will simply clear the "virtualize
> > APIC accesses" VM-execution control in the vmcs02.
> >
> > The problem with this approach is that the L1 guest has arranged the
> > vmcs12 EPT tables--or shadow page tables, if the "enable EPT"
> > VM-execution control is clear in the vmcs12--so that the L2 guest
> > physical address(es)--or L2 guest linear address(es)--that reference
> > the L2 APIC map to the APIC-access address specified in the
> > vmcs12. Without the "virtualize APIC accesses" VM-execution control in
> > the vmcs02, the APIC accesses in the L2 guest will directly access the
> > APIC-access page in L1.
> >
> > When there is no mapping whatsoever for the APIC-access address in L1,
> > the L2 VM just loses the intended APIC virtualization. However, when
> > the APIC-access address is mapped to an MMIO region in L1, the L2
> > guest gets direct access to the L1 MMIO device. For example, if the
> > APIC-access address specified in the vmcs12 is 0xfee00000, then L2
> > gets direct access to L1's APIC.
> >
> > Since this vmcs12 configuration is something that KVM cannot
> > faithfully emulate, the appropriate response is to exit to userspace
> > with KVM_INTERNAL_ERROR_EMULATION.
> >
> > Fixes: fe3ef05c7572 ("KVM: nVMX: Prepare vmcs02 from vmcs01 and vmcs12")
> > Reported-by: Dan Cross <dcross@google.com>
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Peter Shier <pshier@google.com>
> > Change-Id: Ib501fe63266c1d831ce4d1d55e8688bc34a6844a
> > ---
> > v2 -> v3: Added default case to new switch in nested_vmx_run
> > v1 -> v2: Added enum enter_vmx_status
> >
> >  arch/x86/include/asm/kvm_host.h |  2 +-
> >  arch/x86/kvm/vmx/nested.c       | 68 +++++++++++++++++++--------------
> >  arch/x86/kvm/vmx/nested.h       | 13 ++++++-
> >  arch/x86/kvm/x86.c              |  8 +++-
> >  4 files changed, 59 insertions(+), 32 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 5d8056ff7390..0dee68560437 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1186,7 +1186,7 @@ struct kvm_x86_ops {
> >       int (*set_nested_state)(struct kvm_vcpu *vcpu,
> >                               struct kvm_nested_state __user *user_kvm_nested_state,
> >                               struct kvm_nested_state *kvm_state);
> > -     void (*get_vmcs12_pages)(struct kvm_vcpu *vcpu);
> > +     bool (*get_vmcs12_pages)(struct kvm_vcpu *vcpu);
> >
> >       int (*smi_allowed)(struct kvm_vcpu *vcpu);
> >       int (*pre_enter_smm)(struct kvm_vcpu *vcpu, char *smstate);
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 5e231da00310..88b2f08aaaae 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -2927,7 +2927,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
> >  static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
> >                                                struct vmcs12 *vmcs12);
> >
> > -static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> > +static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> >  {
> >       struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> >       struct vcpu_vmx *vmx = to_vmx(vcpu);
> > @@ -2947,19 +2947,18 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> >                       vmx->nested.apic_access_page = NULL;
> >               }
> >               page = kvm_vcpu_gpa_to_page(vcpu, vmcs12->apic_access_addr);
> > -             /*
> > -              * If translation failed, no matter: This feature asks
> > -              * to exit when accessing the given address, and if it
> > -              * can never be accessed, this feature won't do
> > -              * anything anyway.
> > -              */
> >               if (!is_error_page(page)) {
> >                       vmx->nested.apic_access_page = page;
> >                       hpa = page_to_phys(vmx->nested.apic_access_page);
> >                       vmcs_write64(APIC_ACCESS_ADDR, hpa);
> >               } else {
> > -                     secondary_exec_controls_clearbit(vmx,
> > -                             SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
> > +                     pr_debug_ratelimited("%s: non-cacheable APIC-access address in vmcs12\n",
> > +                                          __func__);
>
> Hmm, "non-cacheable" is confusing, especially in the context of the APIC,
> which needs to be mapped "uncacheable".  Maybe just "invalid"?

"Invalid" is not correct. L1 MMIO addresses are valid; they're just
not cacheable. Perhaps:

"vmcs12 APIC-access address references a page not backed by a memslot in L1"?


> > +                     vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> > +                     vcpu->run->internal.suberror =
> > +                             KVM_INTERNAL_ERROR_EMULATION;
> > +                     vcpu->run->internal.ndata = 0;
> > +                     return false;
> >               }
> >       }
> >
> > @@ -3004,6 +3003,7 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> >               exec_controls_setbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
> >       else
> >               exec_controls_clearbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
> > +     return true;
> >  }
> >
> >  /*
> > @@ -3042,13 +3042,15 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
> >  /*
> >   * If from_vmentry is false, this is being called from state restore (either RSM
> >   * or KVM_SET_NESTED_STATE).  Otherwise it's called from vmlaunch/vmresume.
> > -+ *
> > -+ * Returns:
> > -+ *   0 - success, i.e. proceed with actual VMEnter
> > -+ *   1 - consistency check VMExit
> > -+ *  -1 - consistency check VMFail
> > + *
> > + * Returns:
> > + *   ENTER_VMX_SUCCESS: Successfully entered VMX non-root mode
>
> "Enter VMX" usually refers to VMXON, e.g. the title of VMXON in the SDM is
> "Enter VMX Operation".
>
> Maybe NVMX_ENTER_NON_ROOT_?

How about NESTED_VMX_ENTER_NON_ROOT_MODE_STATUS_?

> > + *   ENTER_VMX_VMFAIL:  Consistency check VMFail
> > + *   ENTER_VMX_VMEXIT:  Consistency check VMExit
> > + *   ENTER_VMX_ERROR:   KVM internal error
>
> Probably need to more explicit than VMX_ERROR, e.g. all of the VM-Fail
> defines are prefixed with VMXERR_##.
>
> May ENTER_VMX_KVM_ERROR?  (Or NVMX_ENTER_NON_ROOT_KVM_ERROR).

NESTED_VMX_ENTER_NON_ROOT_MODE_STATUS_KVM_INTERNAL_ERROR?

> >   */
> > -int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
> > +enum enter_vmx_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> > +                                                  bool from_vmentry)
> >  {
> >       struct vcpu_vmx *vmx = to_vmx(vcpu);
> >       struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> > @@ -3091,11 +3093,12 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
> >       prepare_vmcs02_early(vmx, vmcs12);
> >
> >       if (from_vmentry) {
> > -             nested_get_vmcs12_pages(vcpu);
> > +             if (unlikely(!nested_get_vmcs12_pages(vcpu)))
> > +                     return ENTER_VMX_ERROR;
> >
> >               if (nested_vmx_check_vmentry_hw(vcpu)) {
> >                       vmx_switch_vmcs(vcpu, &vmx->vmcs01);
> > -                     return -1;
> > +                     return ENTER_VMX_VMFAIL;
> >               }
> >
> >               if (nested_vmx_check_guest_state(vcpu, vmcs12, &exit_qual))
> > @@ -3159,7 +3162,7 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
> >        * returned as far as L1 is concerned. It will only return (and set
> >        * the success flag) when L2 exits (see nested_vmx_vmexit()).
> >        */
> > -     return 0;
> > +     return ENTER_VMX_SUCCESS;
> >
> >       /*
> >        * A failed consistency check that leads to a VMExit during L1's
> > @@ -3175,14 +3178,14 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
> >       vmx_switch_vmcs(vcpu, &vmx->vmcs01);
> >
> >       if (!from_vmentry)
> > -             return 1;
> > +             return ENTER_VMX_VMEXIT;
> >
> >       load_vmcs12_host_state(vcpu, vmcs12);
> >       vmcs12->vm_exit_reason = exit_reason | VMX_EXIT_REASONS_FAILED_VMENTRY;
> >       vmcs12->exit_qualification = exit_qual;
> >       if (enable_shadow_vmcs || vmx->nested.hv_evmcs)
> >               vmx->nested.need_vmcs12_to_shadow_sync = true;
> > -     return 1;
> > +     return ENTER_VMX_VMEXIT;
> >  }
> >
> >  /*
> > @@ -3192,9 +3195,9 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
> >  static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
> >  {
> >       struct vmcs12 *vmcs12;
> > +     enum enter_vmx_status status;
> >       struct vcpu_vmx *vmx = to_vmx(vcpu);
> >       u32 interrupt_shadow = vmx_get_interrupt_shadow(vcpu);
> > -     int ret;
> >
> >       if (!nested_vmx_check_permission(vcpu))
> >               return 1;
> > @@ -3254,13 +3257,22 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
> >        * the nested entry.
> >        */
> >       vmx->nested.nested_run_pending = 1;
> > -     ret = nested_vmx_enter_non_root_mode(vcpu, true);
> > -     vmx->nested.nested_run_pending = !ret;
> > -     if (ret > 0)
> > -             return 1;
> > -     else if (ret)
> > -             return nested_vmx_failValid(vcpu,
> > -                     VMXERR_ENTRY_INVALID_CONTROL_FIELD);
> > +     status = nested_vmx_enter_non_root_mode(vcpu, true);
>
> What if we use a goto to bury the error handling at the end?  That'd also
> provide some flexibility with respect to handling each failure, e.g.:
>
>         vmx->nested.nested_run_pending = 1;
>         status = nested_vmx_enter_non_root_mode(vcpu, true);
>         if (status != ENTER_VMX_SUCCESS)
>                 goto vmenter_failed;
>
>         ...
>
>         return 1;
>
> vmenter_failed:
>         vmx->nested.nested_run_pending = 0;
>         if (status == ENTER_VMX_VMFAIL)
>                 return nested_vmx_failValid(vcpu,
>                                             VMXERR_ENTRY_INVALID_CONTROL_FIELD);
>
>         return status == ENTER_VMX_ERROR ? 0 : 1;
>
> or
>
>         vmx->nested.nested_run_pending = 1;
>         status = nested_vmx_enter_non_root_mode(vcpu, true);
>         if (status != ENTER_VMX_SUCCESS)
>                 goto vmenter_failed;
>
>         ...
>
>         return 1;
>
> vmenter_failed:
>         vmx->nested.nested_run_pending = 0;
>         if (status == ENTER_VMX_ERROR)
>                 return 0;
>         if (status == ENTER_VMX_VMEXIT)
>                 return 1;
>
>         WARN_ON_ONCE(status != ENTER_VMX_VMFAIL);
>         return nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);

Sounds good. Thanks!

> > +     if (status != ENTER_VMX_SUCCESS) {
> > +             vmx->nested.nested_run_pending = 0;
> > +             switch (status) {
> > +             case ENTER_VMX_VMFAIL:
> > +                     return nested_vmx_failValid(vcpu,
> > +                             VMXERR_ENTRY_INVALID_CONTROL_FIELD);
> > +             case ENTER_VMX_VMEXIT:
> > +                     return 1;
> > +             case ENTER_VMX_ERROR:
> > +                     return 0;
> > +             default:
> > +                     WARN_ON_ONCE(1);
> > +                     break;
> > +             }
> > +     }
> >
> >       /* Hide L1D cache contents from the nested guest.  */
> >       vmx->vcpu.arch.l1tf_flush_l1d = true;
> > diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> > index 187d39bf0bf1..07cf5cef86f6 100644
> > --- a/arch/x86/kvm/vmx/nested.h
> > +++ b/arch/x86/kvm/vmx/nested.h
> > @@ -6,6 +6,16 @@
> >  #include "vmcs12.h"
> >  #include "vmx.h"
> >
> > +/*
> > + * Status returned by nested_vmx_enter_non_root_mode():
> > + */
> > +enum enter_vmx_status {
> > +     ENTER_VMX_SUCCESS,      /* Successfully entered VMX non-root mode */
> > +     ENTER_VMX_VMFAIL,       /* Consistency check VMFail */
> > +     ENTER_VMX_VMEXIT,       /* Consistency check VMExit */
> > +     ENTER_VMX_ERROR,        /* KVM internal error */
> > +};
> > +
> >  void vmx_leave_nested(struct kvm_vcpu *vcpu);
> >  void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
> >                               bool apicv);
> > @@ -13,7 +23,8 @@ void nested_vmx_hardware_unsetup(void);
> >  __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *));
> >  void nested_vmx_vcpu_setup(void);
> >  void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu);
> > -int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry);
> > +enum enter_vmx_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> > +                                                  bool from_vmentry);
> >  bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason);
> >  void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
> >                      u32 exit_intr_info, unsigned long exit_qualification);
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index f26f8be4e621..627fd7ff3a28 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7937,8 +7937,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >       bool req_immediate_exit = false;
> >
> >       if (kvm_request_pending(vcpu)) {
> > -             if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu))
> > -                     kvm_x86_ops->get_vmcs12_pages(vcpu);
> > +             if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu)) {
> > +                     if (unlikely(!kvm_x86_ops->get_vmcs12_pages(vcpu))) {
> > +                             r = 0;
> > +                             goto out;
> > +                     }
> > +             }
> >               if (kvm_check_request(KVM_REQ_MMU_RELOAD, vcpu))
> >                       kvm_mmu_unload(vcpu);
> >               if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
> > --
> > 2.23.0.581.g78d2f28ef7-goog
> >
