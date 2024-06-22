Return-Path: <kvm+bounces-20327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E366913606
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2024 22:29:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B7B7B20927
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2024 20:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 362FA61674;
	Sat, 22 Jun 2024 20:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Aq6e104G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC78E441D;
	Sat, 22 Jun 2024 20:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719088128; cv=none; b=Uy+q7Da+Yp980IpOhjDit5Fexsx6PepevbnRVUxyxiwgHksqMEbagwh6mr3cPU/bFI1/UGjRRqjItoxMGQsVf1y4zW2Ruxu6gU4Vy8ENh6iZKuxnD6tNzteD72UIEsT9GmcOZkolsSuGtuIe8Q/Rc9W0nrSCFPr2eiEGdXPstrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719088128; c=relaxed/simple;
	bh=3naxbCWYWyb12WIaRMFMGCevr88ZJi3vnfvM+hQe39k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DZx16lfFPMJN9+nI2kTBTjrnsp9fE5RoKtK4bIQ+KHIvgaVRa84MP4fICdt+GIBww7xKNOzdT3/FFvrmQBWXKlR6QLwi6yu1cBpJ28GBbp3XDcP4v0Bpdytdh4b+ah/f4HVlhJoFZ2n3JVkV4n/lbWPa086JGLKtMv6GvpX5/nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Aq6e104G; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-5c1cabcb0c1so1456586eaf.0;
        Sat, 22 Jun 2024 13:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719088126; x=1719692926; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wz5Oa6/rWVrsFAb0cFynFRFfx1R/TSvc0ki+GhEz5L4=;
        b=Aq6e104Gu2jkw5ZdZv/fPChx3zS5WU/N5eEnydoel6QQV6FpmowmL+5jl2DLHXaDnC
         Y4N83drfF/Ve9oCocUOKVtTNEmBk+uirW/TNrnN0B+tBbiMcibRed+nBPtSnOh5sSUQR
         bLQXDWcZwbl7l4Dl1ZagjcRD/JGCyQy67zw6kqUUVhJilQQr+5z7rYd8MlpFeiln1kWe
         tEQWGX5to6oeaMVlHlvdH7cZjlpFOo0/gfusB7WJfPFkOOvXYdMBmeHli7Zya88ifjhg
         48HCzSrqbZCGmrDYd+WTnrJ8Gpow07yT1LWq3vbk69ZMtaKxw6G0vVx8m+RoZWX1BH+C
         kG6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719088126; x=1719692926;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wz5Oa6/rWVrsFAb0cFynFRFfx1R/TSvc0ki+GhEz5L4=;
        b=Q3Xzg8snB5TZKayV++qsczw0ZPG3p4I7GXKwUROE+FXrlFz8hfnAT7seJ29nZfWfh6
         Da4Xq48TDpC+iI7YV58pP1bRQRFRdNeOI3R8WyyRHFP1XdedZdIkPaNznH+XKYFNLswi
         ka+U6UJRpDcXeN9+C3V1/+koG5Heq4KS4ElecmYnKtNrESL7CEJ5FDRYocWG8DXS4c9R
         m6Vl4b0meJkwEpr8ykh0VGXDitK2TGi7lPvPwoqvB37YL4ynlzM2bK+Frcy/SkHT/vxl
         oZySHyo/21cCjOsDIJ/Kb0F6FDDkj1NC7cvwcrWNxPOPcHFonwQrpSfsYIMAZtLMFRMN
         5jNA==
X-Forwarded-Encrypted: i=1; AJvYcCWtimIIpmaRVbILWC11R4jOdzxG0hOZidAEX2Ye7uIlphThAbOvxRyWz2tBQ4ocwjfTeo/1VMIzXibSObnh73jIlm6lREiCx9KGNrCgRMPGO81WlfMpCFxITqyzdF6OKzHl
X-Gm-Message-State: AOJu0Yz5hsmddepJwZhKefkQYFAqUNjaneW2nOFBkMJdaTFjcmwhuh28
	QXVxsaczM14ZitQLJCQYVUbYOT9PL08ttC3fG400AiSj0kugm8AE
X-Google-Smtp-Source: AGHT+IE789iTevCzbZ7tRv7egdxCiedgWdhlftr81cGxwdKYHeUeTH4vqoVa4ggmavoKIxtlOnNaaw==
X-Received: by 2002:a4a:764b:0:b0:5ba:ffcb:c759 with SMTP id 006d021491bc7-5c1eed1072cmr847344eaf.4.1719088125891;
        Sat, 22 Jun 2024 13:28:45 -0700 (PDT)
Received: from ?IPV6:2603:8080:2300:de:3d70:f8:6869:93de? ([2603:8080:2300:de:3d70:f8:6869:93de])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5c1d55cd91asm749144eaf.15.2024.06.22.13.28.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Jun 2024 13:28:45 -0700 (PDT)
Message-ID: <daee6ab7-7c1e-45e3-81a5-ea989cc1b099@gmail.com>
Date: Sat, 22 Jun 2024 15:28:43 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/5] KVM: SEV: Provide support for
 SNP_EXTENDED_GUEST_REQUEST NAE event
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, x86@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, jroedel@suse.de,
 thomas.lendacky@amd.com, pgonda@google.com, ashish.kalra@amd.com,
 bp@alien8.de, pankaj.gupta@amd.com, liam.merwick@oracle.com
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-4-michael.roth@amd.com>
Content-Language: en-US
From: Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
In-Reply-To: <20240621134041.3170480-4-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello folks,

On 6/21/24 08:40, Michael Roth wrote:
> Version 2 of GHCB specification added support for the SNP Extended Guest
> Request Message NAE event. This event serves a nearly identical purpose
> to the previously-added SNP_GUEST_REQUEST event, but for certain message
> types it allows the guest to supply a buffer to be used for additional
> information in some cases.
>
> Currently the GHCB spec only defines extended handling of this sort in
> the case of attestation requests, where the additional buffer is used to
> supply a table of certificate data corresponding to the attestion
> report's signing key. Support for this extended handling will require
> additional KVM APIs to handle coordinating with userspace.
>
> Whether or not the hypervisor opts to provide this certificate data is
> optional. However, support for processing SNP_EXTENDED_GUEST_REQUEST
> GHCB requests is required by the GHCB 2.0 specification for SNP guests,
> so for now implement a stub implementation that provides an empty
> certificate table to the guest if it supplies an additional buffer, but
> otherwise behaves identically to SNP_GUEST_REQUEST.
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 60 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 60 insertions(+)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7338b987cadd..b5dcf36b50f5 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3323,6 +3323,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>  			goto vmgexit_err;
>  		break;
>  	case SVM_VMGEXIT_GUEST_REQUEST:
> +	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
>  		if (!sev_snp_guest(vcpu->kvm))
>  			goto vmgexit_err;
>  		break;
> @@ -4005,6 +4006,62 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
>  	return ret;
>  }
>  
> +/*
> + * As per GHCB spec (see "SNP Extended Guest Request"), the certificate table
> + * is terminated by 24-bytes of zeroes.
> + */
> +static const u8 empty_certs_table[24];


Should this be:
staticconstu8 empty_certs_table[24] = { 0};
Besides that,
Reviewed-by: Carlos Bilbao <carlos.bilbao.osdev@gmail.com>


> +
> +static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
> +{
> +	struct kvm *kvm = svm->vcpu.kvm;
> +	u8 msg_type;
> +
> +	if (!sev_snp_guest(kvm) || !PAGE_ALIGNED(req_gpa) || !PAGE_ALIGNED(resp_gpa))
> +		return -EINVAL;
> +
> +	if (kvm_read_guest(kvm, req_gpa + offsetof(struct snp_guest_msg_hdr, msg_type),
> +			   &msg_type, 1))
> +		goto abort_request;
> +
> +	/*
> +	 * As per GHCB spec, requests of type MSG_REPORT_REQ also allow for
> +	 * additional certificate data to be provided alongside the attestation
> +	 * report via the guest-provided data pages indicated by RAX/RBX. The
> +	 * certificate data is optional and requires additional KVM enablement
> +	 * to provide an interface for userspace to provide it, but KVM still
> +	 * needs to be able to handle extended guest requests either way. So
> +	 * provide a stub implementation that will always return an empty
> +	 * certificate table in the guest-provided data pages.
> +	 */
> +	if (msg_type == SNP_MSG_REPORT_REQ) {
> +		struct kvm_vcpu *vcpu = &svm->vcpu;
> +		u64 data_npages;
> +		gpa_t data_gpa;
> +
> +		if (!kvm_ghcb_rax_is_valid(svm) || !kvm_ghcb_rbx_is_valid(svm))
> +			goto abort_request;
> +
> +		data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
> +		data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
> +
> +		if (!PAGE_ALIGNED(data_gpa))
> +			goto abort_request;
> +
> +		if (data_npages &&
> +		    kvm_write_guest(kvm, data_gpa, empty_certs_table,
> +				    sizeof(empty_certs_table)))
> +			goto abort_request;
> +	}
> +
> +	return snp_handle_guest_req(svm, req_gpa, resp_gpa);
> +
> +abort_request:
> +	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> +				SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_GENERIC, 0));
> +	return 1; /* resume guest */
> +}
> +
>  static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  {
>  	struct vmcb_control_area *control = &svm->vmcb->control;
> @@ -4282,6 +4339,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  	case SVM_VMGEXIT_GUEST_REQUEST:
>  		ret = snp_handle_guest_req(svm, control->exit_info_1, control->exit_info_2);
>  		break;
> +	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
> +		ret = snp_handle_ext_guest_req(svm, control->exit_info_1, control->exit_info_2);
> +		break;
>  	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>  		vcpu_unimpl(vcpu,
>  			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",


Thanks,
Carlos


