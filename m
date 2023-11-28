Return-Path: <kvm+bounces-2571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E80157FB2B9
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 08:28:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A010B21028
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 07:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61FB412E57;
	Tue, 28 Nov 2023 07:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V3PTo1N2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53561BD
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 23:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701156523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y5BdmHDgt38rlTrgeOjpNrZmrPx70EBF4G1nvkRBLTc=;
	b=V3PTo1N2BoCkYCW9YBPspEbQS7VEAm6gC3uJqzyt1WNkFreYuh4yJPBQ9qTqYWWuJUbGj2
	GtdHAf9rPdPTUkKoa/dxxNEw+ZDeE8D4i4DAdFwJxkuCBhaGf2K20o/OnNOpTSIvi3gbtb
	9TZOiSA5gVVhv/xqrS7Eciz+bP2Q+nw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-3JSn9j5NM1i7_snUIZv3RA-1; Tue, 28 Nov 2023 02:28:41 -0500
X-MC-Unique: 3JSn9j5NM1i7_snUIZv3RA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-332f5ac9f49so2075741f8f.2
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 23:28:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701156520; x=1701761320;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y5BdmHDgt38rlTrgeOjpNrZmrPx70EBF4G1nvkRBLTc=;
        b=SnAisd0dvQ3xPDonvuNJlWpXka81SKoQ/xB6zcWydPgLSCZxCO+1nB/nDIgtBwPw4L
         mMfUZENwZzkoNRtem8gS685qqdeevSDOV/tUq1O3flp1PQrWd4xYDufrvLyFDX4AL+C/
         0/GUR48jNENC2uSFuViSgkAj3YrWhxM1K8JzQ+iKdnyijHV0XwbfIxhuO/qPTaIhl2Gr
         sLmF1XwjPOKoEfm8rxnYSixc9PLcdfkPOcjdBtNwTq0pqUsv55Ly1qm6uZMedCOTI7J0
         44wpA3lI5JuzfLN0g5OTO85Kt3LmaJ/6t4T0arRvwWE00tU6+0w/OJG5Ghg9vTQdkUmw
         S2ew==
X-Gm-Message-State: AOJu0YxG2oXiUzquViUXzJb+G38AxqhiQ1DUhAr8w9jX5j2TSbeOjF+4
	dXaxOUv7w6eIQrrsGj6T2heX9K1QhaoJy8J57upkO7+GE7j2oNguls+2gZ4llgGAZtVk92fsHdN
	x0crW2Drmh3m+
X-Received: by 2002:a5d:424a:0:b0:332:c5f8:a082 with SMTP id s10-20020a5d424a000000b00332c5f8a082mr10166405wrr.13.1701156520347;
        Mon, 27 Nov 2023 23:28:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFZq3ysto0FjKshj9voU9tQJ6efJmJfszdfClmLvNLefhFl6RycgLDTK4Zz2uTRdBk65VFnUg==
X-Received: by 2002:a5d:424a:0:b0:332:c5f8:a082 with SMTP id s10-20020a5d424a000000b00332c5f8a082mr10166397wrr.13.1701156520034;
        Mon, 27 Nov 2023 23:28:40 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id w21-20020a05600c475500b0040b2976eb02sm16296878wmo.10.2023.11.27.23.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 23:28:39 -0800 (PST)
Message-ID: <70d51e5f3b202a059009913f165b133265ea4cc2.camel@redhat.com>
Subject: Re: [RFC 12/33] KVM: x86: hyper-v: Handle VSM hcalls in user-space
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 anelkz@amazon.com,  graf@amazon.com, dwmw@amazon.co.uk, jgowans@amazon.com,
 corbert@lwn.net,  kys@microsoft.com, haiyangz@microsoft.com,
 decui@microsoft.com, x86@kernel.org,  linux-doc@vger.kernel.org
Date: Tue, 28 Nov 2023 09:28:37 +0200
In-Reply-To: <20231108111806.92604-13-nsaenz@amazon.com>
References: <20231108111806.92604-1-nsaenz@amazon.com>
	 <20231108111806.92604-13-nsaenz@amazon.com>
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
> Let user-space handle all hypercalls that fall under the AccessVsm
> partition privilege flag. That is:
>  - HVCALL_MODIFY_VTL_PROTECTION_MASK:
>  - HVCALL_ENABLE_PARTITION_VTL:
>  - HVCALL_ENABLE_VP_VTL:
>  - HVCALL_VTL_CALL:
>  - HVCALL_VTL_RETURN:
> The hypercalls are processed through the KVM_EXIT_HYPERV_HVCALL exit.
> Additionally, expose the cpuid bit.
> 
> Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> ---
>  arch/x86/kvm/hyperv.c             | 15 +++++++++++++++
>  include/asm-generic/hyperv-tlfs.h |  7 ++++++-
>  2 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index a3970d52eef1..a266c5d393f5 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -2462,6 +2462,11 @@ static bool kvm_hv_is_xmm_output_hcall(u16 code)
>  	return false;
>  }
>  
> +static inline bool kvm_hv_is_vtl_call_return(u16 code)
> +{
> +	return code == HVCALL_VTL_CALL || code == HVCALL_VTL_RETURN;
> +}
> +
>  static int kvm_hv_hypercall_complete_userspace(struct kvm_vcpu *vcpu)
>  {
>  	bool fast = !!(vcpu->run->hyperv.u.hcall.input & HV_HYPERCALL_FAST_BIT);
> @@ -2471,6 +2476,9 @@ static int kvm_hv_hypercall_complete_userspace(struct kvm_vcpu *vcpu)
>  	if (kvm_hv_is_xmm_output_hcall(code) && hv_result_success(result) && fast)
>  		kvm_hv_write_xmm(vcpu->run->hyperv.u.hcall.xmm);
>  
> +	if (kvm_hv_is_vtl_call_return(code))
> +		return kvm_skip_emulated_instruction(vcpu);

Can you add justification for this?
If this is justified, does it make sense to move this code to kvm_hv_hypercall_complete
(which also calls kvm_skip_emulated_instruction())



> +
>  	return kvm_hv_hypercall_complete(vcpu, result);
>  }
>  
> @@ -2525,6 +2533,7 @@ static bool is_xmm_fast_hypercall(struct kvm_hv_hcall *hc)
>  	case HVCALL_SEND_IPI_EX:
>  	case HVCALL_GET_VP_REGISTERS:
>  	case HVCALL_SET_VP_REGISTERS:
> +	case HVCALL_MODIFY_VTL_PROTECTION_MASK:
>  		return true;
>  	}
>  
> @@ -2745,6 +2754,11 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  		goto hypercall_userspace_exit;
>  	case HVCALL_GET_VP_REGISTERS:
>  	case HVCALL_SET_VP_REGISTERS:
> +	case HVCALL_MODIFY_VTL_PROTECTION_MASK:
> +	case HVCALL_ENABLE_PARTITION_VTL:
> +	case HVCALL_ENABLE_VP_VTL:
> +	case HVCALL_VTL_CALL:
> +	case HVCALL_VTL_RETURN:
>  		goto hypercall_userspace_exit;
>  	default:

Also those new hypercalls also should be added to hv_check_hypercall_access.

>  		ret = HV_STATUS_INVALID_HYPERCALL_CODE;
> @@ -2912,6 +2926,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  			ent->ebx |= HV_SIGNAL_EVENTS;
>  			ent->ebx |= HV_ENABLE_EXTENDED_HYPERCALLS;
>  			ent->ebx |= HV_ACCESS_VP_REGISTERS;
> +			ent->ebx |= HV_ACCESS_VSM;
>  
>  			ent->edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
>  			ent->edx |= HV_X64_HYPERCALL_XMM_OUTPUT_AVAILABLE;

Best regards,
	Maxim Levitsky

> diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
> index 24ea699a3d8e..a8b5c8a84bbc 100644
> --- a/include/asm-generic/hyperv-tlfs.h
> +++ b/include/asm-generic/hyperv-tlfs.h
> @@ -89,6 +89,7 @@
>  #define HV_ACCESS_STATS				BIT(8)
>  #define HV_DEBUGGING				BIT(11)
>  #define HV_CPU_MANAGEMENT			BIT(12)
> +#define HV_ACCESS_VSM				BIT(16)
>  #define HV_ACCESS_VP_REGISTERS			BIT(17)
>  #define HV_ENABLE_EXTENDED_HYPERCALLS		BIT(20)
>  #define HV_ISOLATION				BIT(22)
> @@ -147,9 +148,13 @@ union hv_reference_tsc_msr {
>  /* Declare the various hypercall operations. */
>  #define HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE	0x0002
>  #define HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST	0x0003
> -#define HVCALL_ENABLE_VP_VTL			0x000f
>  #define HVCALL_NOTIFY_LONG_SPIN_WAIT		0x0008
>  #define HVCALL_SEND_IPI				0x000b
> +#define HVCALL_MODIFY_VTL_PROTECTION_MASK	0x000c
> +#define HVCALL_ENABLE_PARTITION_VTL		0x000d
> +#define HVCALL_ENABLE_VP_VTL			0x000f
> +#define HVCALL_VTL_CALL				0x0011
> +#define HVCALL_VTL_RETURN			0x0012
>  #define HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX	0x0013
>  #define HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX	0x0014
>  #define HVCALL_SEND_IPI_EX			0x0015





