Return-Path: <kvm+bounces-26227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6058973327
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:29:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63484288286
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 10:29:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BE7819755B;
	Tue, 10 Sep 2024 10:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AjIQ2mw7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2690418B488
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963913; cv=none; b=RfBRNkabS6CIQ2Lj97Xr/xhiIr72pCf943uVLPko/knjjiQa4NahjWb+LRrudlsRLp1fMBgV+SiugcwJq87mLsD0i7pC+paHphtwkNLkQAsItkfc8AeZ+XjdpMWG2/nwYyWnYt/uXUw+FBprlMvf0/SE2dVXHFx/7nBBzp5tNE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963913; c=relaxed/simple;
	bh=gWaFuPUqX0h4hai9x3sMNjvszFKB30agMtl48ateG8E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ejE54JCZGJr0wDddVxUYqL/gJqiVp6ABP2s+47ikl8LJhx/Y2cIYXY42BwL3fzF5xMXHAU2mNLQndilALQ8ADQXwThidWkFJ2z/5u0W1MvbDRwI1oat+RVLp7mpoBObfQvITvWG4N7PrZuKZ6pAr6QuCfKh8h9rjv/JpjOKO4WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AjIQ2mw7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725963909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WdBSvdERbANPcE2/9Ji227Jspb3Sq0DdRd0m6MPdrIw=;
	b=AjIQ2mw7yMJxNsYN2tBQJ2s3hB9R/+GRD4aVE25lDvVCO6iL1VVtxrh1sZE1zDPhnj5nKP
	r4s26GLY4+Uy9yzRitpIQDZsthIIuhHZkxmDf55/kEIaxvNpctECy0U6sItxoFnZBY77C+
	SweQROVoOp/b2mlQWx3n8Ivdbq2bVZ4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-uhxTtDyTNfCqyZuDx3t_TA-1; Tue, 10 Sep 2024 06:25:08 -0400
X-MC-Unique: uhxTtDyTNfCqyZuDx3t_TA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42cb99afa97so14269455e9.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 03:25:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725963907; x=1726568707;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WdBSvdERbANPcE2/9Ji227Jspb3Sq0DdRd0m6MPdrIw=;
        b=BhZ8MSjxOiiCvM0AQjQ56lXDwn0PN0/vIZr8CGfrfeXIRqVxnOSTLfxPEWY6wq0WFv
         gKpTiJbRIGLDlrD8YrkDromOFZPj2+7EEwVGRROY8keUyBLJlFEW0gSgwKacvz+qeLJS
         okiyfXpWKYcaVow+5xxokt7fPaqFxzVzyIfoM0m3UwkyrHLmTwD3E/iLiUxwb/B7NigG
         H/KQHEOI5+113CEqKj31AojRTPSsRb27dVo0MFqIF7wAAKtfqpytj8YuwUtK4J5FVCoH
         x6T4o7XyOn651yWditVIJgFO7e2rfdkoW1JxsARzW/yixzxiwRXBH3D/cqPAgEmzFLAm
         5K+g==
X-Forwarded-Encrypted: i=1; AJvYcCXMAv7JSIgHj6apqlrb40UvMiJxDvUV4cgWMBQvUcoxHefFHkGuIhk141WtDuWDTdA3o54=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz93v41drQYTa05N0Z/SErvK+2kHdcoRRsbCkbOUtYEdtLPMoFg
	U6sbkrma3bdzllFe5N7pf3voCWydygLkv2f0sndl0KyxTSJdz2qb4G0c0prdNStsht9jLZ5XqdP
	fHxAKAOHuV36hL1VfqOj2OD5iXU4t34+gd3IP8gRFHOBsWAKGsQ==
X-Received: by 2002:a5d:5452:0:b0:374:c0cc:a1fb with SMTP id ffacd0b85a97d-378896573fbmr9704626f8f.39.1725963907266;
        Tue, 10 Sep 2024 03:25:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHlQDm7IYowHDu5fxWW+REkhLpkeH4jz6Xq9AhtvVcKH0ZNTaBFd/AIwLmxH8ZfB4tepI2fQg==
X-Received: by 2002:a5d:5452:0:b0:374:c0cc:a1fb with SMTP id ffacd0b85a97d-378896573fbmr9704603f8f.39.1725963906845;
        Tue, 10 Sep 2024 03:25:06 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-37895665553sm8541545f8f.39.2024.09.10.03.25.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 03:25:06 -0700 (PDT)
Message-ID: <acf52e41-e78c-479d-9736-419a86002982@redhat.com>
Date: Tue, 10 Sep 2024 12:25:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/21] KVM: TDX: Finalize VM initialization
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org,
 Adrian Hunter <adrian.hunter@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-21-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240904030751.117579-21-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/24 05:07, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add a new VM-scoped KVM_MEMORY_ENCRYPT_OP IOCTL subcommand,
> KVM_TDX_FINALIZE_VM, to perform TD Measurement Finalization.
> 
> Documentation for the API is added in another patch:
> "Documentation/virt/kvm: Document on Trust Domain Extensions(TDX)"
> 
> For the purpose of attestation, a measurement must be made of the TDX VM
> initial state. This is referred to as TD Measurement Finalization, and
> uses SEAMCALL TDH.MR.FINALIZE, after which:
> 1. The VMM adding TD private pages with arbitrary content is no longer
>     allowed
> 2. The TDX VM is runnable
> 
> Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> TDX MMU part 2 v1:
>   - Added premapped check.
>   - Update for the wrapper functions for SEAMCALLs. (Sean)
>   - Add check if nr_premapped is zero.  If not, return error.
>   - Use KVM_BUG_ON() in tdx_td_finalizer() for consistency.
>   - Change tdx_td_finalizemr() to take struct kvm_tdx_cmd *cmd and return error
>     (Adrian)
>   - Handle TDX_OPERAND_BUSY case (Adrian)
>   - Updates from seamcall overhaul (Kai)
>   - Rename error->hw_error
> 
> v18:
>   - Remove the change of tools/arch/x86/include/uapi/asm/kvm.h.
> 
> v15:
>   - removed unconditional tdx_track() by tdx_flush_tlb_current() that
>     does tdx_track().
> ---
>   arch/x86/include/uapi/asm/kvm.h |  1 +
>   arch/x86/kvm/vmx/tdx.c          | 28 ++++++++++++++++++++++++++++
>   2 files changed, 29 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 789d1d821b4f..0b4827e39458 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -932,6 +932,7 @@ enum kvm_tdx_cmd_id {
>   	KVM_TDX_INIT_VM,
>   	KVM_TDX_INIT_VCPU,
>   	KVM_TDX_INIT_MEM_REGION,
> +	KVM_TDX_FINALIZE_VM,
>   	KVM_TDX_GET_CPUID,
>   
>   	KVM_TDX_CMD_NR_MAX,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 796d1a495a66..3083a66bb895 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1257,6 +1257,31 @@ void tdx_flush_tlb_current(struct kvm_vcpu *vcpu)
>   	ept_sync_global();
>   }
>   
> +static int tdx_td_finalizemr(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +
> +	if (!is_hkid_assigned(kvm_tdx) || is_td_finalized(kvm_tdx))
> +		return -EINVAL;
> +	/*
> +	 * Pages are pending for KVM_TDX_INIT_MEM_REGION to issue
> +	 * TDH.MEM.PAGE.ADD().
> +	 */
> +	if (atomic64_read(&kvm_tdx->nr_premapped))
> +		return -EINVAL;

I suggest moving all of patch 16, plus the

+	WARN_ON_ONCE(!atomic64_read(&kvm_tdx->nr_premapped));
+	atomic64_dec(&kvm_tdx->nr_premapped);

lines of patch 19, into this patch.

> +	cmd->hw_error = tdh_mr_finalize(kvm_tdx);
> +	if ((cmd->hw_error & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY)
> +		return -EAGAIN;
> +	if (KVM_BUG_ON(cmd->hw_error, kvm)) {
> +		pr_tdx_error(TDH_MR_FINALIZE, cmd->hw_error);
> +		return -EIO;
> +	}
> +
> +	kvm_tdx->finalized = true;
> +	return 0;

This should also set pre_fault_allowed to true.

Paolo


