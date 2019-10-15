Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E766D83A5
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 00:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389900AbfJOW3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 18:29:00 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:43367 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389897AbfJOW27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 18:28:59 -0400
Received: by mail-il1-f195.google.com with SMTP id t5so310127ilh.10
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 15:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Sr0MLJAR3k6Cpn9nIDdylwQmknY/uK9pUNNzZm5dCNg=;
        b=j3jG9gpFfvuPGHpDvCQga5VH5sv6h38PkGNu0AMIaUEyUPaaY0j1KQW/L4UG5gpwB8
         RbPVMJdNJYht8Rj9sob1hp+wSgCc/anS03rEhh3PXpMhDjYiCJ3npGrI/ZUoPMT41mfN
         HW/rnvS6QOylJsuxvkgD925mVVudvbrJQps2p3N+qL6uZ0928TmRX7WLDKBkQC+ZrogJ
         dStcDlWUkqTwLhnLGWYXnMfm64geNeQX4Y9J6OP8BC9X7BDnCTt4ER2F0CCN9Pg0mvx5
         duCJpeYzTGlFGP8+9RcXthM6n761PrteaU8cVsfFKwVTX7QFzuLwdXogiKpyKsTai9HR
         9g8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Sr0MLJAR3k6Cpn9nIDdylwQmknY/uK9pUNNzZm5dCNg=;
        b=TCldrHPehGi7NZxtd1TE+eN6t7Gnn+sjRA8baDEkQGhYU1AH/ZV9C6TGzRMHj/hEze
         VEn0jbanefv/MbY9G3CIAvu5Kxg9tZ7Zl6PNjiqB+WdRsOtevYk6Ez4PYkj97UXLb+Tm
         4l0gDgD4AsFqskvkrzKne2BFEHzw0LGQ2/jkDhC3BDoK/RSfmYykmYdFfyCv7R46TjOm
         GiMW1NMXYNNG/UEoteDI+84euIRbKHgxj0CZMGHZFyodUN35pnfH+6rtDFs+Lyv0dc6R
         ApijaroYOmMHKnuXoCjMM9bCrGQxqnqUJUh3eqEPZXqldhiMGm0j8DRrgfb0l/ZBA6Iz
         0U/g==
X-Gm-Message-State: APjAAAVo7OXgPzuBsWB+2ccvPY8Ds+b9CrbQuJscnWsaRylpJTQOSBx6
        z5mJWJr1+j3OL+Y8aHqcKLTJMitOW+EhTVzobyDUQQ==
X-Google-Smtp-Source: APXvYqzZZDBunTZxD8NXMHn3OjH7C8tBJkrlpV/pMbQ7bBtGUdc2JT5upcxM/ylDhlc7ftf3KX1P1+XHLECEC5nyekc=
X-Received: by 2002:a92:c147:: with SMTP id b7mr9273128ilh.108.1571178537971;
 Tue, 15 Oct 2019 15:28:57 -0700 (PDT)
MIME-Version: 1.0
References: <20191015000446.8099-1-krish.sadhukhan@oracle.com> <20191015000446.8099-3-krish.sadhukhan@oracle.com>
In-Reply-To: <20191015000446.8099-3-krish.sadhukhan@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 15 Oct 2019 15:28:46 -0700
Message-ID: <CALMp9eTZkY_E9AC_c-cdmdqksSZHiw4cMEtORvmxx4x=TNCBfw@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] KVM: nVMX: Rollback MSR-load if VM-entry fails due
 to VM-entry MSR-loading
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 14, 2019 at 5:40 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
> If VM-entry fails due to VM-entry MSR-loading, the MSRs of the nested gue=
sts
> need to be rolled back to their previous state in order for the guest to =
not
> be in an inconsistent state.

This change seems overly simplistic, and it also breaks the existing ABI.

> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 50 +++++++++++++++++++++++++++++++++++----
>  arch/x86/kvm/vmx/nested.h | 26 +++++++++++++++-----
>  arch/x86/kvm/vmx/vmx.h    |  8 +++++++
>  3 files changed, 74 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index cebdcb105ea8..bd8e7af5c1e5 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -191,7 +191,7 @@ static int nested_vmx_failValid(struct kvm_vcpu *vcpu=
,
>         return kvm_skip_emulated_instruction(vcpu);
>  }
>
> -static void nested_vmx_abort(struct kvm_vcpu *vcpu, u32 indicator)
> +void nested_vmx_abort(struct kvm_vcpu *vcpu, u32 indicator)
>  {
>         /* TODO: not to reset guest simply here. */
>         kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> @@ -894,11 +894,13 @@ static u32 nested_vmx_max_atomic_switch_msrs(struct=
 kvm_vcpu *vcpu)
>   * as possible, process all valid entries before failing rather than pre=
check
>   * for a capacity violation.
>   */
> -static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count=
)
> +static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count=
,
> +                              bool save)
>  {
>         u32 i;
>         struct vmx_msr_entry e;
>         u32 max_msr_list_size =3D nested_vmx_max_atomic_switch_msrs(vcpu)=
;
> +       struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>
>         for (i =3D 0; i < count; i++) {
>                 if (unlikely(i >=3D max_msr_list_size))
> @@ -917,6 +919,16 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu=
, u64 gpa, u32 count)
>                                 __func__, i, e.index, e.reserved);
>                         goto fail;
>                 }
> +               if (save) {
> +                       vmx->nested.vm_entry_msr_load_backup[i].index =3D=
 e.index;
> +                       if (kvm_get_msr(vcpu, e.index,
> +                           &(vmx->nested.vm_entry_msr_load_backup[i].dat=
a))) {
> +                               pr_debug_ratelimited(
> +                                       "%s cannot read MSR (%u, 0x%x)\n"=
,
> +                                       __func__, i, e.index);
> +                               goto fail;

This breaks the ABI, by requiring that all MSRs in the MSR-load list
have to be readable. Some, like IA32_PRED_CMD, are not.

> +                       }
> +               }
>                 if (kvm_set_msr(vcpu, e.index, e.value)) {
>                         pr_debug_ratelimited(
>                                 "%s cannot write MSR (%u, 0x%x, 0x%llx)\n=
",
> @@ -926,6 +938,7 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu,=
 u64 gpa, u32 count)
>         }
>         return 0;
>  fail:
> +       kfree(vmx->nested.vm_entry_msr_load_backup);
>         return i + 1;
>  }
>
> @@ -973,6 +986,26 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcp=
u, u64 gpa, u32 count)
>         return 0;
>  }
>
> +int nested_vmx_rollback_msr(struct kvm_vcpu *vcpu, u32 count)
> +{
> +       u32 i;
> +       struct msr_data msr;
> +       struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> +
> +       for (i =3D 0; i < count; i++) {

I wonder if this loop should go in the other direction, in case there
are dependencies among the MSR settings.

> +               msr.host_initiated =3D false;
> +               msr.index =3D vmx->nested.vm_entry_msr_load_backup[i].ind=
ex;
> +               msr.data =3D vmx->nested.vm_entry_msr_load_backup[i].data=
;
> +               if (kvm_set_msr(vcpu, msr.index, msr.data)) {
> +                       pr_debug_ratelimited(
> +                                       "%s WRMSR failed (%u, 0x%x, 0x%ll=
x)\n",
> +                                       __func__, i, msr.index, msr.data)=
;
> +                       return -EINVAL;

This doesn't work with time-related MSRs, like
IA32_TIME_STAMP_COUNTER. Rather than "rolling back" to an earlier
value, you need to be able to negate the effect of the load that
should never have happened. Similarly, I don't think this works with
IA32_TSC_DEADLINE, if the original deadline has passed before you
saved it. I believe that writing a deadline in the past will result in
a spurious interrupt.

> +               }
> +       }
> +       return 0;
> +}
> +
>  static bool nested_cr3_valid(struct kvm_vcpu *vcpu, unsigned long val)
>  {
>         unsigned long invalid_mask;
> @@ -3102,9 +3135,18 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu=
 *vcpu, bool from_vmentry)
>                 goto vmentry_fail_vmexit_guest_mode;
>
>         if (from_vmentry) {
> +               u32 count =3D vmcs12->vm_entry_msr_load_count;
> +
> +               /* Save guest MSRs before we load them */
> +               vmx->nested.vm_entry_msr_load_backup =3D
> +                   kcalloc(count, sizeof(struct msr_data), GFP_KERNEL_AC=
COUNT);
> +               if (!vmx->nested.vm_entry_msr_load_backup)
> +                       goto vmentry_fail_vmexit_guest_mode;
> +

Should the backup memory be allocated in advance, so that we don't
have this unarchitected VM-entry failure? If not, should this be
deferred until after the attempted VM-entry to vmcs02, to avoid
introducing yet another priority inversion?

>                 exit_qual =3D nested_vmx_load_msr(vcpu,
>                                                 vmcs12->vm_entry_msr_load=
_addr,
> -                                               vmcs12->vm_entry_msr_load=
_count);
> +                                               vmcs12->vm_entry_msr_load=
_count,
> +                                               true);
>                 if (exit_qual) {
>                         /*
>                          * According to section =E2=80=9CVM Entries=E2=80=
=9D in Intel SDM
> @@ -3940,7 +3982,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu =
*vcpu,
>                 vmx_update_msr_bitmap(vcpu);
>
>         if (nested_vmx_load_msr(vcpu, vmcs12->vm_exit_msr_load_addr,
> -                               vmcs12->vm_exit_msr_load_count))
> +                               vmcs12->vm_exit_msr_load_count, false))
>                 nested_vmx_abort(vcpu, VMX_ABORT_LOAD_HOST_MSR_FAIL);
>  }
>
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index bb51ec8cf7da..f951b2b338d2 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -17,6 +17,8 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcp=
u, bool from_vmentry);
>  bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason);
>  void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
>                        u32 exit_intr_info, unsigned long exit_qualificati=
on);
> +void nested_vmx_abort(struct kvm_vcpu *vcpu, u32 indicator);
> +int nested_vmx_rollback_msr(struct kvm_vcpu *vcpu, u32 count);
>  void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu);
>  int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
>  int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pd=
ata);
> @@ -66,7 +68,6 @@ static inline int nested_vmx_reflect_vmexit(struct kvm_=
vcpu *vcpu,
>  {
>         u32 exit_qual;
>         u32 exit_intr_info =3D vmcs_read32(VM_EXIT_INTR_INFO);
> -       struct vmx_msr_entry *addr;
>
>         /*
>          * At this point, the exit interruption info in exit_intr_info
> @@ -85,11 +86,24 @@ static inline int nested_vmx_reflect_vmexit(struct kv=
m_vcpu *vcpu,
>
>         exit_qual =3D vmcs_readl(EXIT_QUALIFICATION);
>
> -       addr =3D __va(vmcs_read64(VM_ENTRY_MSR_LOAD_ADDR));
> -       if (addr && addr->index =3D=3D MSR_FS_BASE &&
> -           (exit_reason =3D=3D (VMX_EXIT_REASONS_FAILED_VMENTRY |
> -                           EXIT_REASON_MSR_LOAD_FAIL))) {
> -               exit_qual =3D (to_vmx(vcpu))->nested.invalid_msr_load_exi=
t_qual;
> +       if (exit_reason =3D=3D (VMX_EXIT_REASONS_FAILED_VMENTRY |
> +                           EXIT_REASON_MSR_LOAD_FAIL)) {
> +
> +               struct vmcs12 *vmcs12 =3D get_vmcs12(vcpu);
> +               struct vmx_msr_entry *addr;
> +
> +               if (nested_vmx_rollback_msr(vcpu,
> +                                           vmcs12->vm_entry_msr_load_cou=
nt)) {
> +                       nested_vmx_abort(vcpu,
> +                                       VMX_ABORT_SAVE_GUEST_MSR_FAIL);
> +
> +                       kfree(to_vmx(vcpu)->nested.vm_entry_msr_load_back=
up);
> +               }

Are we leaking the backup memory when the rollback succeeds?

> +
> +               addr =3D __va(vmcs_read64(VM_ENTRY_MSR_LOAD_ADDR));
> +               if (addr && addr->index =3D=3D MSR_FS_BASE)
> +                       exit_qual =3D
> +                           (to_vmx(vcpu))->nested.invalid_msr_load_exit_=
qual;
>         }
>
>         nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info, exit_qual);
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index ee7f40abd199..9a7c118036be 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -189,6 +189,14 @@ struct nested_vmx {
>          * due to invalid VM-entry MSR-load area in vmcs12.
>          */
>         u32 invalid_msr_load_exit_qual;
> +
> +       /*
> +        * This is used for backing up the MSRs of nested guests when
> +        * those MSRs are loaded from VM-entry MSR-load area on VM-entry.
> +        * If VM-entry fails due to VM-entry MSR-loading, we roll back
> +        * the MSRs to the values saved here.
> +        */
> +       struct msr_data *vm_entry_msr_load_backup;
>  };
>
>  struct vcpu_vmx {
> --
> 2.20.1
>
