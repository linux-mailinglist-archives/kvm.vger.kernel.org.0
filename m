Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0936D7CAA73
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbjJPNvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbjJPNu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:50:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD98010E2
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 06:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697464176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YXe+mQW0pTV5oVfh6cfViZgZF7m1E/frZhuzYunB9mU=;
        b=dqIVih/u+ZDiDGX8NGg3AGIXQZUVgN0IJinddtCDLDhJb8dLR8d+MZIQCdBJJKZh7OUsw7
        LJmqGjRzZKJv6vCqvKCjWmwYKyKv9hIxTHTHEL8XQZ6RjY/4tKv3X7A2zyz5Goqp8QLwrb
        gVJFtdIB9QFNpk2oXDiTE6mwr9xPpss=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-K8Tj2V-HNXWRw6mKbn738g-1; Mon, 16 Oct 2023 09:49:35 -0400
X-MC-Unique: K8Tj2V-HNXWRw6mKbn738g-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-993eeb3a950so292042466b.2
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 06:49:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697464174; x=1698068974;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YXe+mQW0pTV5oVfh6cfViZgZF7m1E/frZhuzYunB9mU=;
        b=WFiIdNMjolHqzG2QhBiMH4F93sktSbjHnxEajVdJ/3PLYS3IYJM4uQsOQW+yeFkA+g
         g2WljTqWz2GO2+M09ZfCKJUlaedM1CgUmMYhl+gMykRzqkUkmXvg9Ol+LKcw1OcV7NgV
         Pg9gIxjwp6n1hffBQyj0xfGHLEeZZONvrmWgUhyb9kERSkRXdXVfkE7gvB2eEhOqjtxh
         p2TceW7OMwGSruB7BSU+xzpudQM/qS2DeX4QYnBFreIsJ2KknU0RBdlZU7iHZAgHK7zt
         otVGyFbg4EfEnwRFS0X/LGrxoHNQXQct5faP8P1gKyGXG+xr3bO8XUgLQrgtWfOO69ie
         5GIQ==
X-Gm-Message-State: AOJu0YyyFxrDGezmQ7Gf1fiNiHCnNindrrefUfLBj8wLR0DZLVf4ZyZB
        UlR8DsjxCx6Ql7qD+3F0UfuNlaMzZArAtp59L30sUnZyataaSaRGvZa5eXZ2xhlc8t94qOJqdEr
        zmwPqI0pEMag4
X-Received: by 2002:a17:907:7f90:b0:9c2:2d0a:3211 with SMTP id qk16-20020a1709077f9000b009c22d0a3211mr4097096ejc.38.1697464174014;
        Mon, 16 Oct 2023 06:49:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFxpblagiUxZ9lOWovHCtZGO3a2CkLxxUZumhn42s9UUu1Uz/RIztnyuPSrkqOOQR1yZ8Nqtw==
X-Received: by 2002:a17:907:7f90:b0:9c2:2d0a:3211 with SMTP id qk16-20020a1709077f9000b009c22d0a3211mr4097069ejc.38.1697464173608;
        Mon, 16 Oct 2023 06:49:33 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id l17-20020a170906645100b009b97aa5a3aesm4101945ejn.34.2023.10.16.06.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 06:49:33 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 08/11] KVM: nVMX: hyper-v: Introduce
 nested_vmx_evmptr() accessor
In-Reply-To: <406f20dc55db24dffda2e01a1ccf7a7135c61604.camel@redhat.com>
References: <20231010160300.1136799-1-vkuznets@redhat.com>
 <20231010160300.1136799-9-vkuznets@redhat.com>
 <406f20dc55db24dffda2e01a1ccf7a7135c61604.camel@redhat.com>
Date:   Mon, 16 Oct 2023 15:49:32 +0200
Message-ID: <87edhu8yoj.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> =D0=A3 =D0=B2=D1=82, 2023-10-10 =D1=83 18:02 +0200, Vitaly Kuznetsov =D0=
=BF=D0=B8=D1=88=D0=B5:
>> 'vmx->nested.hv_evmcs_vmptr' accesses are all over the place so hiding
>> 'hv_evmcs_vmptr' under 'ifdef CONFIG_KVM_HYPERV' would take a lot of
>> ifdefs. Introduce 'nested_vmx_evmptr()' accessor instead.
>
>
> It might also make sense to have 'nested_evmptr_valid(vmx)'
> so that we could use it instead of 'evmptr_is_valid(nested_vmx_evmptr(vmx=
))'?
>

Makes sense, thanks!

>
>>=20
>> No functional change intended.
>>=20
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/vmx/hyperv.h |  5 +++++
>>  arch/x86/kvm/vmx/nested.c | 44 +++++++++++++++++++--------------------
>>  arch/x86/kvm/vmx/nested.h |  3 ++-
>>  3 files changed, 29 insertions(+), 23 deletions(-)
>>=20
>> diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
>> index 933ef6cad5e6..6ca5c8c5be9c 100644
>> --- a/arch/x86/kvm/vmx/hyperv.h
>> +++ b/arch/x86/kvm/vmx/hyperv.h
>> @@ -4,6 +4,7 @@
>>=20=20
>>  #include <linux/kvm_host.h>
>>  #include "vmcs12.h"
>> +#include "vmx.h"
>>=20=20
>>  #define EVMPTR_INVALID (-1ULL)
>>  #define EVMPTR_MAP_PENDING (-2ULL)
>> @@ -20,7 +21,10 @@ enum nested_evmptrld_status {
>>  	EVMPTRLD_ERROR,
>>  };
>>=20=20
>> +struct vcpu_vmx;
>> +
>>  #ifdef CONFIG_KVM_HYPERV
>> +static inline gpa_t nested_vmx_evmptr(struct vcpu_vmx *vmx) { return vm=
x->nested.hv_evmcs_vmptr; }
>>  u64 nested_get_evmptr(struct kvm_vcpu *vcpu);
>>  uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
>>  int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>> @@ -30,6 +34,7 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
>>  bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu);
>>  void vmx_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcp=
u);
>>  #else
>> +static inline gpa_t nested_vmx_evmptr(struct vcpu_vmx *vmx) { return EV=
MPTR_INVALID; };
>>  static inline u64 nested_get_evmptr(struct kvm_vcpu *vcpu) { return EVM=
PTR_INVALID; }
>>  static inline void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcp=
u, u32 msr_index, u64 *pdata) {}
>>  static inline bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *v=
cpu) { return false; }
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index ca7e06759aa3..e6476f8e2ccd 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -179,7 +179,7 @@ static int nested_vmx_failValid(struct kvm_vcpu *vcp=
u,
>>  	 * VM_INSTRUCTION_ERROR is not shadowed. Enlightened VMCS 'shadows' all
>>  	 * fields and thus must be synced.
>>  	 */
>> -	if (to_vmx(vcpu)->nested.hv_evmcs_vmptr !=3D EVMPTR_INVALID)
>> +	if (nested_vmx_evmptr(to_vmx(vcpu)) !=3D EVMPTR_INVALID)
>>  		to_vmx(vcpu)->nested.need_vmcs12_to_shadow_sync =3D true;
>>=20=20
>>  	return kvm_skip_emulated_instruction(vcpu);
>> @@ -194,7 +194,7 @@ static int nested_vmx_fail(struct kvm_vcpu *vcpu, u3=
2 vm_instruction_error)
>>  	 * can't be done if there isn't a current VMCS.
>>  	 */
>>  	if (vmx->nested.current_vmptr =3D=3D INVALID_GPA &&
>> -	    !evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
>> +	    !evmptr_is_valid(nested_vmx_evmptr(vmx)))
>>  		return nested_vmx_failInvalid(vcpu);
>>=20=20
>>  	return nested_vmx_failValid(vcpu, vm_instruction_error);
>> @@ -230,7 +230,7 @@ static inline void nested_release_evmcs(struct kvm_v=
cpu *vcpu)
>>  	struct kvm_vcpu_hv *hv_vcpu =3D to_hv_vcpu(vcpu);
>>  	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>>=20=20
>> -	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
>> +	if (evmptr_is_valid(nested_vmx_evmptr(vmx))) {
>>  		kvm_vcpu_unmap(vcpu, &vmx->nested.hv_evmcs_map, true);
>>  		vmx->nested.hv_evmcs =3D NULL;
>>  	}
>> @@ -2019,7 +2019,7 @@ static enum nested_evmptrld_status nested_vmx_hand=
le_enlightened_vmptrld(
>>  		return EVMPTRLD_DISABLED;
>>  	}
>>=20=20
>> -	if (unlikely(evmcs_gpa !=3D vmx->nested.hv_evmcs_vmptr)) {
>> +	if (unlikely(evmcs_gpa !=3D nested_vmx_evmptr(vmx))) {
>>  		vmx->nested.current_vmptr =3D INVALID_GPA;
>>=20=20
>>  		nested_release_evmcs(vcpu);
>> @@ -2097,7 +2097,7 @@ void nested_sync_vmcs12_to_shadow(struct kvm_vcpu =
*vcpu)
>>  {
>>  	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>>=20=20
>> -	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
>> +	if (evmptr_is_valid(nested_vmx_evmptr(vmx)))
>>  		copy_vmcs12_to_enlightened(vmx);
>>  	else
>>  		copy_vmcs12_to_shadow(vmx);
>> @@ -2251,7 +2251,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *=
vmx, struct loaded_vmcs *vmcs0
>>  	u32 exec_control;
>>  	u64 guest_efer =3D nested_vmx_calc_efer(vmx, vmcs12);
>>=20=20
>> -	if (vmx->nested.dirty_vmcs12 || evmptr_is_valid(vmx->nested.hv_evmcs_v=
mptr))
>> +	if (vmx->nested.dirty_vmcs12 || evmptr_is_valid(nested_vmx_evmptr(vmx)=
))
>>  		prepare_vmcs02_early_rare(vmx, vmcs12);
>
> There are some similarities between evmcs and shadow vmcs. I used to know=
 this, but it will probably
> take me time to recall all of the gory details.
>
> It might make sense to unify some of the logic, which can make it easier =
to #ifdef the hyperv support
> in less places.
>
>
>>=20=20
>>  	/*
>> @@ -2546,11 +2546,11 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu,=
 struct vmcs12 *vmcs12,
>>  	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>>  	bool load_guest_pdptrs_vmcs12 =3D false;
>>=20=20
>> -	if (vmx->nested.dirty_vmcs12 || evmptr_is_valid(vmx->nested.hv_evmcs_v=
mptr)) {
>> +	if (vmx->nested.dirty_vmcs12 || evmptr_is_valid(nested_vmx_evmptr(vmx)=
)) {
>>  		prepare_vmcs02_rare(vmx, vmcs12);
>>  		vmx->nested.dirty_vmcs12 =3D false;
>>=20=20
>> -		load_guest_pdptrs_vmcs12 =3D !evmptr_is_valid(vmx->nested.hv_evmcs_vm=
ptr) ||
>> +		load_guest_pdptrs_vmcs12 =3D !evmptr_is_valid(nested_vmx_evmptr(vmx))=
 ||
>>  			!(vmx->nested.hv_evmcs->hv_clean_fields &
>>  			  HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1);
>>  	}
>> @@ -2673,7 +2673,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, s=
truct vmcs12 *vmcs12,
>>  	 * bits when it changes a field in eVMCS. Mark all fields as clean
>>  	 * here.
>>  	 */
>> -	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
>> +	if (evmptr_is_valid(nested_vmx_evmptr(vmx)))
>>  		vmx->nested.hv_evmcs->hv_clean_fields |=3D
>>  			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
>>=20=20
>> @@ -3181,7 +3181,7 @@ static bool nested_get_evmcs_page(struct kvm_vcpu =
*vcpu)
>>  	 * properly reflected.
>>  	 */
>>  	if (guest_cpuid_has_evmcs(vcpu) &&
>> -	    vmx->nested.hv_evmcs_vmptr =3D=3D EVMPTR_MAP_PENDING) {
>> +	    nested_vmx_evmptr(vmx) =3D=3D EVMPTR_MAP_PENDING) {
>>  		enum nested_evmptrld_status evmptrld_status =3D
>>  			nested_vmx_handle_enlightened_vmptrld(vcpu, false);
>>=20=20
>> @@ -3551,7 +3551,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root=
_mode(struct kvm_vcpu *vcpu,
>>=20=20
>>  	load_vmcs12_host_state(vcpu, vmcs12);
>>  	vmcs12->vm_exit_reason =3D exit_reason.full;
>> -	if (enable_shadow_vmcs || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
>> +	if (enable_shadow_vmcs || evmptr_is_valid(nested_vmx_evmptr(vmx)))
>>  		vmx->nested.need_vmcs12_to_shadow_sync =3D true;
>>  	return NVMX_VMENTRY_VMEXIT;
>>  }
>> @@ -3584,7 +3584,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, b=
ool launch)
>>  	if (CC(evmptrld_status =3D=3D EVMPTRLD_VMFAIL))
>>  		return nested_vmx_failInvalid(vcpu);
>>=20=20
>> -	if (CC(!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr) &&
>> +	if (CC(!evmptr_is_valid(nested_vmx_evmptr(vmx)) &&
>>  	       vmx->nested.current_vmptr =3D=3D INVALID_GPA))
>>  		return nested_vmx_failInvalid(vcpu);
>>=20=20
>> @@ -3599,7 +3599,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, b=
ool launch)
>>  	if (CC(vmcs12->hdr.shadow_vmcs))
>>  		return nested_vmx_failInvalid(vcpu);
>>=20=20
>> -	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
>> +	if (evmptr_is_valid(nested_vmx_evmptr(vmx))) {
>>  		copy_enlightened_to_vmcs12(vmx, vmx->nested.hv_evmcs->hv_clean_fields=
);
>>  		/* Enlightened VMCS doesn't have launch state */
>>  		vmcs12->launch_state =3D !launch;
>> @@ -4344,11 +4344,11 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcp=
u *vcpu, struct vmcs12 *vmcs12)
>>  {
>>  	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>>=20=20
>> -	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
>> +	if (evmptr_is_valid(nested_vmx_evmptr(vmx)))
>>  		sync_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
>>=20=20
>>  	vmx->nested.need_sync_vmcs02_to_vmcs12_rare =3D
>> -		!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr);
>> +		!evmptr_is_valid(nested_vmx_evmptr(vmx));
>>=20=20
>>  	vmcs12->guest_cr0 =3D vmcs12_guest_cr0(vcpu, vmcs12);
>>  	vmcs12->guest_cr4 =3D vmcs12_guest_cr4(vcpu, vmcs12);
>> @@ -4869,7 +4869,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 =
vm_exit_reason,
>>  	}
>>=20=20
>>  	if ((vm_exit_reason !=3D -1) &&
>> -	    (enable_shadow_vmcs || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)=
))
>> +	    (enable_shadow_vmcs || evmptr_is_valid(nested_vmx_evmptr(vmx))))
>>  		vmx->nested.need_vmcs12_to_shadow_sync =3D true;
>>=20=20
>>  	/* in case we halted in L2 */
>> @@ -5335,7 +5335,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
>>  					   vmptr + offsetof(struct vmcs12,
>>  							    launch_state),
>>  					   &zero, sizeof(zero));
>> -	} else if (vmx->nested.hv_evmcs && vmptr =3D=3D vmx->nested.hv_evmcs_v=
mptr) {
>> +	} else if (vmx->nested.hv_evmcs && vmptr =3D=3D nested_vmx_evmptr(vmx)=
) {
>>  		nested_release_evmcs(vcpu);
>>  	}
>>=20=20
>> @@ -5375,7 +5375,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>>  	/* Decode instruction info and find the field to read */
>>  	field =3D kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));
>>=20=20
>> -	if (!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
>> +	if (!evmptr_is_valid(nested_vmx_evmptr(vmx))) {
>>  		/*
>>  		 * In VMX non-root operation, when the VMCS-link pointer is INVALID_G=
PA,
>>  		 * any VMREAD sets the ALU flags for VMfailInvalid.
>> @@ -5601,7 +5601,7 @@ static int handle_vmptrld(struct kvm_vcpu *vcpu)
>>  		return nested_vmx_fail(vcpu, VMXERR_VMPTRLD_VMXON_POINTER);
>>=20=20
>>  	/* Forbid normal VMPTRLD if Enlightened version was used */
>> -	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
>> +	if (evmptr_is_valid(nested_vmx_evmptr(vmx)))
>>  		return 1;
>>=20=20
>>  	if (vmx->nested.current_vmptr !=3D vmptr) {
>> @@ -5664,7 +5664,7 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
>>  	if (!nested_vmx_check_permission(vcpu))
>>  		return 1;
>>=20=20
>> -	if (unlikely(evmptr_is_valid(to_vmx(vcpu)->nested.hv_evmcs_vmptr)))
>> +	if (unlikely(evmptr_is_valid(nested_vmx_evmptr(to_vmx(vcpu)))))
>>  		return 1;
>>=20=20
>>  	if (get_vmx_mem_address(vcpu, exit_qual, instr_info,
>> @@ -6450,7 +6450,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *v=
cpu,
>>  			kvm_state.size +=3D sizeof(user_vmx_nested_state->vmcs12);
>>=20=20
>>  			/* 'hv_evmcs_vmptr' can also be EVMPTR_MAP_PENDING here */
>> -			if (vmx->nested.hv_evmcs_vmptr !=3D EVMPTR_INVALID)
>> +			if (nested_vmx_evmptr(vmx) !=3D EVMPTR_INVALID)
>>  				kvm_state.flags |=3D KVM_STATE_NESTED_EVMCS;
>>=20=20
>>  			if (is_guest_mode(vcpu) &&
>> @@ -6506,7 +6506,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *v=
cpu,
>>  	} else  {
>>  		copy_vmcs02_to_vmcs12_rare(vcpu, get_vmcs12(vcpu));
>>  		if (!vmx->nested.need_vmcs12_to_shadow_sync) {
>> -			if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
>> +			if (evmptr_is_valid(nested_vmx_evmptr(vmx)))
>>  				/*
>>  				 * L1 hypervisor is not obliged to keep eVMCS
>>  				 * clean fields data always up-to-date while
>> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
>> index b4b9d51438c6..b389312636e2 100644
>> --- a/arch/x86/kvm/vmx/nested.h
>> +++ b/arch/x86/kvm/vmx/nested.h
>> @@ -3,6 +3,7 @@
>>  #define __KVM_X86_VMX_NESTED_H
>>=20=20
>>  #include "kvm_cache_regs.h"
>> +#include "hyperv.h"
>
> ^ This fixes the build error introduced by patch 6.
>
>>  #include "vmcs12.h"
>>  #include "vmx.h"
>>=20=20
>> @@ -57,7 +58,7 @@ static inline int vmx_has_valid_vmcs12(struct kvm_vcpu=
 *vcpu)
>>=20=20
>>  	/* 'hv_evmcs_vmptr' can also be EVMPTR_MAP_PENDING here */
>>  	return vmx->nested.current_vmptr !=3D -1ull ||
>> -		vmx->nested.hv_evmcs_vmptr !=3D EVMPTR_INVALID;
>> +		nested_vmx_evmptr(vmx) !=3D EVMPTR_INVALID;
>
> However with my suggestion of nested_evmptr_valid(vmx) we=20
> can hide that check and avoid the include as well.
>
>>  }
>>=20=20
>>  static inline u16 nested_get_vpid02(struct kvm_vcpu *vcpu)
>
>
> Best regards,
> 	Maxim Levitsky
>
>
>
>
>

--=20
Vitaly

