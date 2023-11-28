Return-Path: <kvm+bounces-2564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BA207FB258
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 08:08:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D1981C20B89
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 07:08:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB8BB12B88;
	Tue, 28 Nov 2023 07:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AJWReCRA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88362D41
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 23:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701155287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/uf+KIQMohmHryi8WcF8JWaeP3JqTeiI/tviURW9B+w=;
	b=AJWReCRAn/CPlAcbv3vzGHLhqSsHsCoTJIuxQlc0MHhsJrwOWp+scGWsVRYxAqiU5H6sEX
	7OFrQHSt/sAT8QVNausGP21idhoaBcpry9UUZ/Xi4H2qGyHR9TCPygqR8ipAjxGPl4bRuw
	LqUt3sPidE7ZuhLHWam49uyqpT51LrQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-tzPyzlkLO3O539D5rPngHw-1; Tue, 28 Nov 2023 02:08:06 -0500
X-MC-Unique: tzPyzlkLO3O539D5rPngHw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40b394c381bso25110615e9.0
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 23:08:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701155285; x=1701760085;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/uf+KIQMohmHryi8WcF8JWaeP3JqTeiI/tviURW9B+w=;
        b=b+lbBJFAgMEm+YRH/pWDBHb7IGnqdqqILdMJFNUpeePkVLTVJfSXkC0ehyYeOgYaLB
         B1jPokunjceqpIBuLQka3d4LRt5Nmi6anouSd9/0BWBW64KcGO9SBj9KeYyuXYMMK02r
         ttA174E/tHHNCRANPeZsNiGuaMzgClxRtcwyATiiJ2HOlvSd2ivdxDQEqKfksY2jLR3n
         QKwXu5XiaYGq0TixhiyU/TDMFGlufz1PyOrkGalEpzWxDgYSxaycVVzH91xOwyT+Uj4t
         7PjtyvduBgJV7Cq16aS/ZyIlsDZ2yGlZTCOf1PVmglhXcG/oz9sPdquU+FAOC2hhf5hd
         K6fA==
X-Gm-Message-State: AOJu0YwqOx0jrQKHx+OXlS5V+hihHr8MmF/uOUWEjco7XlRQ1m+e7s81
	X6t/M3LVq2vWoZrigOeK63UqqxZSusOO2FBs+K8Mj7IKmm8N2eh/lbDwJ55yEeUm9Dwy7843+8u
	eg2Ezd2PgJ/cP
X-Received: by 2002:a05:600c:3b04:b0:40b:27b4:b4eb with SMTP id m4-20020a05600c3b0400b0040b27b4b4ebmr14623263wms.4.1701155285236;
        Mon, 27 Nov 2023 23:08:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHdTgN4bUXPWY0w6S1SgRuzTvhr9Yu+FQg1/w5ilASNGnnb07efbRWXhEtxSzfxO7OVVytjFw==
X-Received: by 2002:a05:600c:3b04:b0:40b:27b4:b4eb with SMTP id m4-20020a05600c3b0400b0040b27b4b4ebmr14623238wms.4.1701155284837;
        Mon, 27 Nov 2023 23:08:04 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id s9-20020a05600c45c900b0040b3829eb50sm14834788wmo.20.2023.11.27.23.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 23:08:04 -0800 (PST)
Message-ID: <f4495d1f697cf9a7ddfb786eaeeac90f554fc6db.camel@redhat.com>
Subject: Re: [RFC 05/33] KVM: x86: hyper-v: Introduce VTL call/return
 prologues in hypercall page
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 anelkz@amazon.com,  graf@amazon.com, dwmw@amazon.co.uk, jgowans@amazon.com,
 corbert@lwn.net,  kys@microsoft.com, haiyangz@microsoft.com,
 decui@microsoft.com, x86@kernel.org,  linux-doc@vger.kernel.org
Date: Tue, 28 Nov 2023 09:08:02 +0200
In-Reply-To: <20231108111806.92604-6-nsaenz@amazon.com>
References: <20231108111806.92604-1-nsaenz@amazon.com>
	 <20231108111806.92604-6-nsaenz@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-11-08 at 11:17 +0000, Nicolas Saenz Julienne wrote:
> VTL call/return hypercalls have their own entry points in the hypercall
> page because they don't follow normal hyper-v hypercall conventions.
> Move the VTL call/return control input into ECX/RAX and set the
> hypercall code into EAX/RCX before calling the hypercall instruction in
> order to be able to use the Hyper-V hypercall entry function.
> 
> Guests can read an emulated code page offsets register to know the
> offsets into the hypercall page for the VTL call/return entries.
> 
> Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> 
> ---
> 
> My tree has the additional patch, we're still trying to understand under
> what conditions Windows expects the offset to be fixed.
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 54f7f36a89bf..9f2ea8c34447 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -294,6 +294,7 @@ static int patch_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
> 
>         /* VTL call/return entries */
>         if (!kvm_xen_hypercall_enabled(kvm) && kvm_hv_vsm_enabled(kvm)) {
> +               i = 22;
>  #ifdef CONFIG_X86_64
>                 if (is_64_bit_mode(vcpu)) {
>                         /*
> ---
>  arch/x86/include/asm/kvm_host.h   |  2 +
>  arch/x86/kvm/hyperv.c             | 78 ++++++++++++++++++++++++++++++-
>  include/asm-generic/hyperv-tlfs.h | 11 +++++
>  3 files changed, 90 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a2f224f95404..00cd21b09f8c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1105,6 +1105,8 @@ struct kvm_hv {
>  	u64 hv_tsc_emulation_status;
>  	u64 hv_invtsc_control;
>  
> +	union hv_register_vsm_code_page_offsets vsm_code_page_offsets;
> +
>  	/* How many vCPUs have VP index != vCPU index */
>  	atomic_t num_mismatched_vp_indexes;
>  
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 78d053042667..d4b1b53ea63d 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -259,7 +259,8 @@ static void synic_exit(struct kvm_vcpu_hv_synic *synic, u32 msr)
>  static int patch_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> -	u8 instructions[9];
> +	struct kvm_hv *hv = to_kvm_hv(kvm);
> +	u8 instructions[0x30];
>  	int i = 0;
>  	u64 addr;
>  
> @@ -285,6 +286,81 @@ static int patch_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
>  	/* ret */
>  	((unsigned char *)instructions)[i++] = 0xc3;
>  
> +	/* VTL call/return entries */
> +	if (!kvm_xen_hypercall_enabled(kvm) && kvm_hv_vsm_enabled(kvm)) {
> +#ifdef CONFIG_X86_64
> +		if (is_64_bit_mode(vcpu)) {
> +			/*
> +			 * VTL call 64-bit entry prologue:
> +			 * 	mov %rcx, %rax
> +			 * 	mov $0x11, %ecx
> +			 * 	jmp 0:

This isn't really 'jmp 0' as I first wondered but actually backward jump 32 bytes back (if I did the calculation correctly).
This is very dangerous because code that was before can change and in fact I don't think that this
offset is even correct now, and on top of that it depends on support for xen hypercalls as well.

This can be fixed by calculating the offset in runtime, however I am thinking:


Since userspace will have to be aware of the offsets in this page, and since
pretty much everything else is done in userspace, it might make sense to create
the hypercall page in the userspace.

In fact, the fact that KVM currently overwrites the guest page, is a violation of
the HV spec.

It's more correct regardless of VTL to do userspace vm exit and let the userspace put a memslot ("overlay")
over the address, and put whatever userspace wants there, including the above code.

Then we won't need the new ioctl as well.

To support this I think that we can add a userspace msr filter on the HV_X64_MSR_HYPERCALL,
although I am not 100% sure if a userspace msr filter overrides the in-kernel msr handling.

Best regards,
	Maxim Levitsky


> +			 */
> +			hv->vsm_code_page_offsets.vtl_call_offset = i;
> +			instructions[i++] = 0x48;
> +			instructions[i++] = 0x89;
> +			instructions[i++] = 0xc8;
> +			instructions[i++] = 0xb9;
> +			instructions[i++] = 0x11;
> +			instructions[i++] = 0x00;
> +			instructions[i++] = 0x00;
> +			instructions[i++] = 0x00;
> +			instructions[i++] = 0xeb;
> +			instructions[i++] = 0xe0;
> +			/*
> +			 * VTL return 64-bit entry prologue:
> +			 * 	mov %rcx, %rax
> +			 * 	mov $0x12, %ecx
> +			 * 	jmp 0:
> +			 */
> +			hv->vsm_code_page_offsets.vtl_return_offset = i;
> +			instructions[i++] = 0x48;
> +			instructions[i++] = 0x89;
> +			instructions[i++] = 0xc8;
> +			instructions[i++] = 0xb9;
> +			instructions[i++] = 0x12;
> +			instructions[i++] = 0x00;
> +			instructions[i++] = 0x00;
> +			instructions[i++] = 0x00;
> +			instructions[i++] = 0xeb;
> +			instructions[i++] = 0xd6;
> +		} else
> +#endif
> +		{
> +			/*
> +			 * VTL call 32-bit entry prologue:
> +			 * 	mov %eax, %ecx
> +			 * 	mov $0x11, %eax
> +			 * 	jmp 0:
> +			 */
> +			hv->vsm_code_page_offsets.vtl_call_offset = i;
> +			instructions[i++] = 0x89;
> +			instructions[i++] = 0xc1;
> +			instructions[i++] = 0xb8;
> +			instructions[i++] = 0x11;
> +			instructions[i++] = 0x00;
> +			instructions[i++] = 0x00;
> +			instructions[i++] = 0x00;
> +			instructions[i++] = 0xeb;
> +			instructions[i++] = 0xf3;
> +			/*
> +			 * VTL return 32-bit entry prologue:
> +			 * 	mov %eax, %ecx
> +			 * 	mov $0x12, %eax
> +			 * 	jmp 0:
> +			 */
> +			hv->vsm_code_page_offsets.vtl_return_offset = i;
> +			instructions[i++] = 0x89;
> +			instructions[i++] = 0xc1;
> +			instructions[i++] = 0xb8;
> +			instructions[i++] = 0x12;
> +			instructions[i++] = 0x00;
> +			instructions[i++] = 0x00;
> +			instructions[i++] = 0x00;
> +			instructions[i++] = 0xeb;
> +			instructions[i++] = 0xea;
> +		}
> +	}
>  	addr = data & HV_X64_MSR_HYPERCALL_PAGE_ADDRESS_MASK;
>  	if (kvm_vcpu_write_guest(vcpu, addr, instructions, i))
>  		return 1;
> diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
> index fdac4a1714ec..0e7643c1ef01 100644
> --- a/include/asm-generic/hyperv-tlfs.h
> +++ b/include/asm-generic/hyperv-tlfs.h
> @@ -823,4 +823,15 @@ struct hv_mmio_write_input {
>  	u8 data[HV_HYPERCALL_MMIO_MAX_DATA_LENGTH];
>  } __packed;
>  
> +/*
> + * VTL call/return hypercall page offsets register
> + */
> +union hv_register_vsm_code_page_offsets {
> +	u64 as_u64;
> +	struct {
> +		u64 vtl_call_offset:12;
> +		u64 vtl_return_offset:12;
> +		u64 reserved:40;
> +	} __packed;
> +};
>  #endif






