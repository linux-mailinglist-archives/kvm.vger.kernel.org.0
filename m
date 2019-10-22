Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC02E0A0B
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 19:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732365AbfJVRFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 13:05:48 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40619 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730701AbfJVRFr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Oct 2019 13:05:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571763945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=nA8nfBaIKnnIEd6uuDHLvBIiuMrH2trezgQ1gwEXVgo=;
        b=Ow0HTKNQfo6Itehg9DaY7rg27H5lQqPFxR+NDsugrAZ7TN7HqBsozU3hGvTJmBGMtfQ+c9
        otgYzLvVJytVYkmxx9in5TSA7NsCLu/l/TgTTJS7G8eaUXGNJyHOVPDM/K97ae1w+QfBHt
        JwzLoxe0S3wqbkviPiZBZUtmW9GlhrY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-cWXwE1-jPcirMnojIEmUCQ-1; Tue, 22 Oct 2019 13:05:42 -0400
Received: by mail-wm1-f71.google.com with SMTP id k9so7775715wmb.0
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 10:05:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GVHMdZmqaa4bNpDE7T1bnFEDZBgBe11h6UGGSmw7ZaE=;
        b=Przm8NZsPRwZN3JCaxDaPYg87/HumYk6rg6OuaS005D/drzbtkIGDSbFTq0SRu0XLL
         FTgMyJ6TEKvi5MnCZC1U2JVswyJFNJiriddzho27e8+08nLqO/hFXIacRwmGUEGEOT5E
         KQE/Djd1qDwVB5M76vYOwRLKepPhE9bQuniWpp33PxkGl8aDcs28SCGrgDSCOAbYXr74
         pucDdF9/dmnxFIC4NyJi2yz+8ib9z2UQ1yFs0RJErRXc1F458/CbmC3jc/Xv9umLGOjQ
         yCPwa+IwnE8yc8syldWgIrvZE6UI98evRFze62wm9HO+GQEWOEa4glbbESaUFFz6syQb
         hDQA==
X-Gm-Message-State: APjAAAWH7kFmTqXw/rgR7ZEBOBsB/I8tm+5yjvZR558P2Io+mFWMC4SP
        7lm5hvmhkt8ZGLBx6/UIinQAlarhyRJQ4kqT7kc81r2AyM7FziGLpeEeKNL8d332u0iwqrY11R3
        QiKybFayUdnp8
X-Received: by 2002:a1c:38c3:: with SMTP id f186mr4027603wma.58.1571763940815;
        Tue, 22 Oct 2019 10:05:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxQ6d9hLxb7dqTt70oeVYNhInfJxLo0TCtjTNN5FdHp0SZ7oxXsZFBeDuhaF6BfN58ai8bXiA==
X-Received: by 2002:a1c:38c3:: with SMTP id f186mr4027572wma.58.1571763940345;
        Tue, 22 Oct 2019 10:05:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c0e4:dcf4:b543:ce19? ([2001:b07:6468:f312:c0e4:dcf4:b543:ce19])
        by smtp.gmail.com with ESMTPSA id b5sm16761524wmj.18.2019.10.22.10.05.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2019 10:05:39 -0700 (PDT)
Subject: Re: [PATCH v5] KVM: nVMX: Don't leak L1 MMIO regions to L2
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Dan Cross <dcross@google.com>, Peter Shier <pshier@google.com>
References: <20191015174405.163723-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <354bcf56-114d-74da-d6d5-cc60bcd0d09a@redhat.com>
Date:   Tue, 22 Oct 2019 19:05:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191015174405.163723-1-jmattson@google.com>
Content-Language: en-US
X-MC-Unique: cWXwE1-jPcirMnojIEmUCQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/19 19:44, Jim Mattson wrote:
> If the "virtualize APIC accesses" VM-execution control is set in the
> VMCS, the APIC virtualization hardware is triggered when a page walk
> in VMX non-root mode terminates at a PTE wherein the address of the 4k
> page frame matches the APIC-access address specified in the VMCS. On
> hardware, the APIC-access address may be any valid 4k-aligned physical
> address.
>=20
> KVM's nVMX implementation enforces the additional constraint that the
> APIC-access address specified in the vmcs12 must be backed by
> a "struct page" in L1. If not, L0 will simply clear the "virtualize
> APIC accesses" VM-execution control in the vmcs02.
>=20
> The problem with this approach is that the L1 guest has arranged the
> vmcs12 EPT tables--or shadow page tables, if the "enable EPT"
> VM-execution control is clear in the vmcs12--so that the L2 guest
> physical address(es)--or L2 guest linear address(es)--that reference
> the L2 APIC map to the APIC-access address specified in the
> vmcs12. Without the "virtualize APIC accesses" VM-execution control in
> the vmcs02, the APIC accesses in the L2 guest will directly access the
> APIC-access page in L1.
>=20
> When there is no mapping whatsoever for the APIC-access address in L1,
> the L2 VM just loses the intended APIC virtualization. However, when
> the APIC-access address is mapped to an MMIO region in L1, the L2
> guest gets direct access to the L1 MMIO device. For example, if the
> APIC-access address specified in the vmcs12 is 0xfee00000, then L2
> gets direct access to L1's APIC.
>=20
> Since this vmcs12 configuration is something that KVM cannot
> faithfully emulate, the appropriate response is to exit to userspace
> with KVM_INTERNAL_ERROR_EMULATION.
>=20
> Fixes: fe3ef05c7572 ("KVM: nVMX: Prepare vmcs02 from vmcs01 and vmcs12")
> Reported-by: Dan Cross <dcross@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> v4 -> v5: Concatenated two lines
> v3 -> v4: Changed enum enter_vmx_status to enum nvmx_vmentry_status;
>           clarified debug message in nested_get_vmcs12_pages();
>           moved nested_vmx_enter_non_root_mode() error handling in
>           nested_vmx_run() out-of-line
> v2 -> v3: Added default case to new switch in nested_vmx_run
> v1 -> v2: Added enum enter_vmx_status
>=20
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/vmx/nested.c       | 64 ++++++++++++++++++---------------
>  arch/x86/kvm/vmx/nested.h       | 13 ++++++-
>  arch/x86/kvm/x86.c              |  8 +++--
>  4 files changed, 55 insertions(+), 32 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 50eb430b0ad8..24d6598dea29 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1189,7 +1189,7 @@ struct kvm_x86_ops {
>  =09int (*set_nested_state)(struct kvm_vcpu *vcpu,
>  =09=09=09=09struct kvm_nested_state __user *user_kvm_nested_state,
>  =09=09=09=09struct kvm_nested_state *kvm_state);
> -=09void (*get_vmcs12_pages)(struct kvm_vcpu *vcpu);
> +=09bool (*get_vmcs12_pages)(struct kvm_vcpu *vcpu);
> =20
>  =09int (*smi_allowed)(struct kvm_vcpu *vcpu);
>  =09int (*pre_enter_smm)(struct kvm_vcpu *vcpu, char *smstate);
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index e76eb4f07f6c..0e7c9301fe86 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2917,7 +2917,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_v=
cpu *vcpu)
>  static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>  =09=09=09=09=09=09 struct vmcs12 *vmcs12);
> =20
> -static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> +static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
>  {
>  =09struct vmcs12 *vmcs12 =3D get_vmcs12(vcpu);
>  =09struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> @@ -2937,19 +2937,18 @@ static void nested_get_vmcs12_pages(struct kvm_vc=
pu *vcpu)
>  =09=09=09vmx->nested.apic_access_page =3D NULL;
>  =09=09}
>  =09=09page =3D kvm_vcpu_gpa_to_page(vcpu, vmcs12->apic_access_addr);
> -=09=09/*
> -=09=09 * If translation failed, no matter: This feature asks
> -=09=09 * to exit when accessing the given address, and if it
> -=09=09 * can never be accessed, this feature won't do
> -=09=09 * anything anyway.
> -=09=09 */
>  =09=09if (!is_error_page(page)) {
>  =09=09=09vmx->nested.apic_access_page =3D page;
>  =09=09=09hpa =3D page_to_phys(vmx->nested.apic_access_page);
>  =09=09=09vmcs_write64(APIC_ACCESS_ADDR, hpa);
>  =09=09} else {
> -=09=09=09secondary_exec_controls_clearbit(vmx,
> -=09=09=09=09SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
> +=09=09=09pr_debug_ratelimited("%s: no backing 'struct page' for APIC-acc=
ess address in vmcs12\n",
> +=09=09=09=09=09     __func__);
> +=09=09=09vcpu->run->exit_reason =3D KVM_EXIT_INTERNAL_ERROR;
> +=09=09=09vcpu->run->internal.suberror =3D
> +=09=09=09=09KVM_INTERNAL_ERROR_EMULATION;
> +=09=09=09vcpu->run->internal.ndata =3D 0;
> +=09=09=09return false;
>  =09=09}
>  =09}
> =20
> @@ -2994,6 +2993,7 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu=
 *vcpu)
>  =09=09exec_controls_setbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
>  =09else
>  =09=09exec_controls_clearbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
> +=09return true;
>  }
> =20
>  /*
> @@ -3032,13 +3032,15 @@ static void load_vmcs12_host_state(struct kvm_vcp=
u *vcpu,
>  /*
>   * If from_vmentry is false, this is being called from state restore (ei=
ther RSM
>   * or KVM_SET_NESTED_STATE).  Otherwise it's called from vmlaunch/vmresu=
me.
> -+ *
> -+ * Returns:
> -+ *   0 - success, i.e. proceed with actual VMEnter
> -+ *   1 - consistency check VMExit
> -+ *  -1 - consistency check VMFail
> + *
> + * Returns:
> + *=09NVMX_ENTRY_SUCCESS: Entered VMX non-root mode
> + *=09NVMX_ENTRY_VMFAIL:  Consistency check VMFail
> + *=09NVMX_ENTRY_VMEXIT:  Consistency check VMExit
> + *=09NVMX_ENTRY_KVM_INTERNAL_ERROR: KVM internal error
>   */
> -int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmen=
try)
> +enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu =
*vcpu,
> +=09=09=09=09=09=09=09bool from_vmentry)
>  {
>  =09struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>  =09struct vmcs12 *vmcs12 =3D get_vmcs12(vcpu);
> @@ -3081,11 +3083,12 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcp=
u *vcpu, bool from_vmentry)
>  =09prepare_vmcs02_early(vmx, vmcs12);
> =20
>  =09if (from_vmentry) {
> -=09=09nested_get_vmcs12_pages(vcpu);
> +=09=09if (unlikely(!nested_get_vmcs12_pages(vcpu)))
> +=09=09=09return NVMX_VMENTRY_KVM_INTERNAL_ERROR;
> =20
>  =09=09if (nested_vmx_check_vmentry_hw(vcpu)) {
>  =09=09=09vmx_switch_vmcs(vcpu, &vmx->vmcs01);
> -=09=09=09return -1;
> +=09=09=09return NVMX_VMENTRY_VMFAIL;
>  =09=09}
> =20
>  =09=09if (nested_vmx_check_guest_state(vcpu, vmcs12, &exit_qual))
> @@ -3149,7 +3152,7 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu =
*vcpu, bool from_vmentry)
>  =09 * returned as far as L1 is concerned. It will only return (and set
>  =09 * the success flag) when L2 exits (see nested_vmx_vmexit()).
>  =09 */
> -=09return 0;
> +=09return NVMX_VMENTRY_SUCCESS;
> =20
>  =09/*
>  =09 * A failed consistency check that leads to a VMExit during L1's
> @@ -3165,14 +3168,14 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcp=
u *vcpu, bool from_vmentry)
>  =09vmx_switch_vmcs(vcpu, &vmx->vmcs01);
> =20
>  =09if (!from_vmentry)
> -=09=09return 1;
> +=09=09return NVMX_VMENTRY_VMEXIT;
> =20
>  =09load_vmcs12_host_state(vcpu, vmcs12);
>  =09vmcs12->vm_exit_reason =3D exit_reason | VMX_EXIT_REASONS_FAILED_VMEN=
TRY;
>  =09vmcs12->exit_qualification =3D exit_qual;
>  =09if (enable_shadow_vmcs || vmx->nested.hv_evmcs)
>  =09=09vmx->nested.need_vmcs12_to_shadow_sync =3D true;
> -=09return 1;
> +=09return NVMX_VMENTRY_VMEXIT;
>  }
> =20
>  /*
> @@ -3182,9 +3185,9 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu =
*vcpu, bool from_vmentry)
>  static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  {
>  =09struct vmcs12 *vmcs12;
> +=09enum nvmx_vmentry_status status;
>  =09struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>  =09u32 interrupt_shadow =3D vmx_get_interrupt_shadow(vcpu);
> -=09int ret;
> =20
>  =09if (!nested_vmx_check_permission(vcpu))
>  =09=09return 1;
> @@ -3244,13 +3247,9 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, b=
ool launch)
>  =09 * the nested entry.
>  =09 */
>  =09vmx->nested.nested_run_pending =3D 1;
> -=09ret =3D nested_vmx_enter_non_root_mode(vcpu, true);
> -=09vmx->nested.nested_run_pending =3D !ret;
> -=09if (ret > 0)
> -=09=09return 1;
> -=09else if (ret)
> -=09=09return nested_vmx_failValid(vcpu,
> -=09=09=09VMXERR_ENTRY_INVALID_CONTROL_FIELD);
> +=09status =3D nested_vmx_enter_non_root_mode(vcpu, true);
> +=09if (unlikely(status !=3D NVMX_VMENTRY_SUCCESS))
> +=09=09goto vmentry_failed;
> =20
>  =09/* Hide L1D cache contents from the nested guest.  */
>  =09vmx->vcpu.arch.l1tf_flush_l1d =3D true;
> @@ -3281,6 +3280,15 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, b=
ool launch)
>  =09=09return kvm_vcpu_halt(vcpu);
>  =09}
>  =09return 1;
> +
> +vmentry_failed:
> +=09vmx->nested.nested_run_pending =3D 0;
> +=09if (status =3D=3D NVMX_VMENTRY_KVM_INTERNAL_ERROR)
> +=09=09return 0;
> +=09if (status =3D=3D NVMX_VMENTRY_VMEXIT)
> +=09=09return 1;
> +=09WARN_ON_ONCE(status !=3D NVMX_VMENTRY_VMFAIL);
> +=09return nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD)=
;
>  }
> =20
>  /*
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index 187d39bf0bf1..6280f33e5fa6 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -6,6 +6,16 @@
>  #include "vmcs12.h"
>  #include "vmx.h"
> =20
> +/*
> + * Status returned by nested_vmx_enter_non_root_mode():
> + */
> +enum nvmx_vmentry_status {
> +=09NVMX_VMENTRY_SUCCESS,=09=09/* Entered VMX non-root mode */
> +=09NVMX_VMENTRY_VMFAIL,=09=09/* Consistency check VMFail */
> +=09NVMX_VMENTRY_VMEXIT,=09=09/* Consistency check VMExit */
> +=09NVMX_VMENTRY_KVM_INTERNAL_ERROR,/* KVM internal error */
> +};
> +
>  void vmx_leave_nested(struct kvm_vcpu *vcpu);
>  void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_ca=
ps,
>  =09=09=09=09bool apicv);
> @@ -13,7 +23,8 @@ void nested_vmx_hardware_unsetup(void);
>  __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_v=
cpu *));
>  void nested_vmx_vcpu_setup(void);
>  void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu);
> -int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmen=
try);
> +enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu =
*vcpu,
> +=09=09=09=09=09=09     bool from_vmentry);
>  bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason);
>  void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
>  =09=09       u32 exit_intr_info, unsigned long exit_qualification);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 661e2bf38526..2cf26f159071 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7941,8 +7941,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  =09bool req_immediate_exit =3D false;
> =20
>  =09if (kvm_request_pending(vcpu)) {
> -=09=09if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu))
> -=09=09=09kvm_x86_ops->get_vmcs12_pages(vcpu);
> +=09=09if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu)) {
> +=09=09=09if (unlikely(!kvm_x86_ops->get_vmcs12_pages(vcpu))) {
> +=09=09=09=09r =3D 0;
> +=09=09=09=09goto out;
> +=09=09=09}
> +=09=09}
>  =09=09if (kvm_check_request(KVM_REQ_MMU_RELOAD, vcpu))
>  =09=09=09kvm_mmu_unload(vcpu);
>  =09=09if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
>=20

Queued, thanks.

Paolo

