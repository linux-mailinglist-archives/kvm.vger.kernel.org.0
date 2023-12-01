Return-Path: <kvm+bounces-3133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EAC4A800EA4
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 16:32:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5562BB21378
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 15:32:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2CB94AF77;
	Fri,  1 Dec 2023 15:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V0tQfgPc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8F9194;
	Fri,  1 Dec 2023 07:32:46 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-40b4a8db331so21440865e9.3;
        Fri, 01 Dec 2023 07:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701444764; x=1702049564; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dRp6E9n1PpmFcNuEF+xwWPt12aMl6+EMhLFak8Z0XWM=;
        b=V0tQfgPcMwsVofxB7tF/PMo5GZBvBA39TQ7YpLFMfZDWIGcvJgm2gMMvk8scHolIXi
         Bxpg9g/EuuyNt9I5mGSbFeq4IDsSrKYh5zE6jLu1hkMd0bbu3qPh3myZ4GX4pR55QPqy
         7FoMveErcgjrRKsdgypqMikyly718Tk07zeTqPpHmzHgWpkIxYTLEbzfU8fDjaQWKgW8
         g9H+25g1TKwMoiT0eYw/vCTkMkLUGjTWLL/9AvPWqNzyDshorwNczAEuC5JckseXaezC
         4erHiDDsH9f+GG05ut4LwCHN+j07R3CHyFP3m3SsnBVutR/DCyifTSG8lp+bnWb2iaC1
         GcEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701444764; x=1702049564;
        h=content-transfer-encoding:in-reply-to:organization:references:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dRp6E9n1PpmFcNuEF+xwWPt12aMl6+EMhLFak8Z0XWM=;
        b=gP0wB9FBtKf8bssT/eVdanHe7n+VlfU2g5pQi4s1Co4nLQ8hQ2UAlqi+FuvNZtcV/p
         RsrGXDo2KrYuyJJUh34eeQxyOkULII35pNPXOX0EDexq5K9cG3o4wq5qJTSD1Xg2Xrvs
         rwmKbXQSo5dSgjHqA7XeQ+ia9trO1SEHbsdAWrPwdSYEAzVwOqWqK+8RReVr4S24B0Fy
         zyIjARIZGSZLYFJvlpyel/dQWNVXvS/TyRsEIQKAd769T0aBUi4kNGp9IqSg9NaYdINP
         ZGw2BrhmIokB+r38U5BD3nJyomo3eFVT3viIKWwXLqJuVlxrb8dYzF2NHSJMXDW6LK84
         yuJw==
X-Gm-Message-State: AOJu0Yzjt3QpncqZycOfm/KRPKFXewtsiNAlM9m/B6IN9hplTOxqqquf
	vKaydVLkiQPSh5UYF6aiAxs=
X-Google-Smtp-Source: AGHT+IHyHu37ZIqvjQD8gRxG/Xf6cc/VFe5a+Zw6YmS/qOk5OxLwxaySuqge8bA93Bnsjs5Saa2+hA==
X-Received: by 2002:a05:600c:1c9c:b0:40b:5e21:d374 with SMTP id k28-20020a05600c1c9c00b0040b5e21d374mr475213wms.125.1701444764330;
        Fri, 01 Dec 2023 07:32:44 -0800 (PST)
Received: from [192.168.17.41] (54-240-197-239.amazon.com. [54.240.197.239])
        by smtp.gmail.com with ESMTPSA id fs20-20020a05600c3f9400b0040b5517ae31sm8633529wmb.6.2023.12.01.07.32.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Dec 2023 07:32:43 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <00b3e1bf-4968-474a-ac45-9c8e9549346e@xen.org>
Date: Fri, 1 Dec 2023 15:32:40 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 2/2] KVM: xen: (re-)initialize shared_info if guest
 (32/64-bit) mode is set
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20231201104536.947-1-paul@xen.org>
 <20231201104536.947-3-paul@xen.org>
Organization: Xen Project
In-Reply-To: <20231201104536.947-3-paul@xen.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/12/2023 10:45, Paul Durrant wrote:
> From: Paul Durrant <pdurrant@amazon.com>
> 
> If the shared_info PFN cache has already been initialized then the content
> of the shared_info page needs to be (re-)initialized if the guest mode is
> set. It is no lnger done when the PFN cache is activated.
> Setting the guest mode is either done explicitly by the VMM via the
> KVM_XEN_ATTR_TYPE_LONG_MODE attribute, or implicitly when the guest writes
> the MSR to set up the hypercall page.
> 
> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
> ---
>   arch/x86/kvm/xen.c | 20 +++++++++++++++-----
>   1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 7bead3f65e55..bfc8f6698cbc 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -624,8 +624,15 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>   		} else {
>   			mutex_lock(&kvm->arch.xen.xen_lock);
>   			kvm->arch.xen.long_mode = !!data->u.long_mode;
> +
> +			/*
> +			 * If shared_info has already been initialized
> +			 * then re-initialize it with the new width.
> +			 */
> +			r = kvm->arch.xen.shinfo_cache.active ?
> +				kvm_xen_shared_info_init(kvm) : 0;
> +
>   			mutex_unlock(&kvm->arch.xen.xen_lock);
> -			r = 0;
>   		}
>   		break;
>   
> @@ -657,9 +664,6 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>   		}
>   		srcu_read_unlock(&kvm->srcu, idx);
>   
> -		if (!r && kvm->arch.xen.shinfo_cache.active)
> -			r = kvm_xen_shared_info_init(kvm);
> -
>   		mutex_unlock(&kvm->arch.xen.xen_lock);
>   		break;
>   	}
> @@ -1144,7 +1148,13 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
>   	bool lm = is_long_mode(vcpu);
>   
>   	/* Latch long_mode for shared_info pages etc. */
> -	vcpu->kvm->arch.xen.long_mode = lm;
> +	kvm->arch.xen.long_mode = lm;
> +
> +	if (kvm->arch.xen.shinfo_cache.active &&
> +	    kvm_xen_shared_info_init(kvm)) {
> +		mutex_unlock(&kvm->arch.xen.xen_lock);

This unlock is bogus; it should have been removed. I'll send a v2.

   Paul

> +		return 1;
> +	}
>   
>   	/*
>   	 * If Xen hypercall intercept is enabled, fill the hypercall


