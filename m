Return-Path: <kvm+bounces-20984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D5BB4927FAC
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:19:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04A8E1C216EA
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:19:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C53E1D53F;
	Fri,  5 Jul 2024 01:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f6U3xTnm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB37F505
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 01:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720142285; cv=none; b=ZXRzPVdZIkVwqzc7PLSBYtoUP0TJLRM0aFNhJ/2TrcXcbgV5lWJfgM4x/5FvRJAZCesYGRVwRqdz0ZMgFOuSjy3G/A35aiJ+VG01mlDv1UO4hf/dr6SZ1XaBIQy96ccUZS6X5yoEvFDZbPqn0BYrGPS8rg/IMwbsMZEmJhs+ZXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720142285; c=relaxed/simple;
	bh=EXG0vdXn9rII3D+KCAP3vDlEC4rngHU/vCdatspHQu4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GWeXUxyXAUO0nI6h83yhardCyx0fscAG35iUB/9G0sc/JKQJMdEse0lZOgFZjIhEyWanDv1zXQl7rjHuMggzQIMR1HXtvdVfYhNgLXZWHu1W4b3mwxml4JtQsbp+0vPaZXcsuERkJqMs/NOjm9Mt/CilXY84A5miizvVxxfKOhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f6U3xTnm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720142283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o1GmW0SxxDLUHNaUVBUQTGEySUGPhjAywrfZJc9ozqE=;
	b=f6U3xTnmR/LudmNTpO20doMawotucNeiRGHCM7FgSZi6VuSPTV9M9x7d/alJdZSMk8Yc1N
	nLb7HyKxUNnwzRL9LHpFReOZrOXY+e5DSaUNAN7A4wwap6NMPw9GhSVP43f3zSGTnvb2w6
	pLA9QYBe+mFBAqr/0sjIoVAoSxM2Ews=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-R5AZnfqmNb6JXmPjLWJHYg-1; Thu, 04 Jul 2024 21:18:01 -0400
X-MC-Unique: R5AZnfqmNb6JXmPjLWJHYg-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-79ee31dfec8so154896685a.2
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 18:18:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720142281; x=1720747081;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o1GmW0SxxDLUHNaUVBUQTGEySUGPhjAywrfZJc9ozqE=;
        b=xBoStkTev4XzNrKS/8mdVD3zkcHAPxJFkzgSekauYvzFKnsH4xPKZZDP92AlfA9B2N
         p9auvyMiZscclqGrQCyldNgN939SJXsrbbltYxQc1LCkUIUvmUe9oYUErHgx2pw6xYTd
         B3hpHh1Eg+r1GrFopDTwV8Ctp8mSg2FMcgoktuNrGK86j6K+U+9qmAb2/GAKzu7bFTHb
         nWAzTdGSiEONKGxhyiVVx4m9khCPewAvhT3CZYNKmCjdskFT6jgdWI2A/AjghHEf4rZ8
         wp66NpWIHdIdLDbFBzf++wwEz2zwAXV0maKBWx48fkp7UO7W2Nb1w4X65CMMrvDj8nuM
         VmaA==
X-Gm-Message-State: AOJu0Yz5HLLaO/fWvF4QUWEq7B7Aahe6vu4dCbxu+Nw9tgDmVQ6eOa9O
	r4g2Vga6r6gWGuGgehhzDXeblZvp2dzlvilmVysesbadA6DY5+T25A042J5WSwS0UpW7P3XM4ZZ
	5fM2X6HWvfZHk7uKQJlA8laErsiBKxSC15tQFXt0sKso3EcD7Sw==
X-Received: by 2002:a05:620a:468e:b0:79d:7793:ee3a with SMTP id af79cd13be357-79eee1de29bmr432421085a.15.1720142280864;
        Thu, 04 Jul 2024 18:18:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEK+3SG/MyXuNkvivY7dc3fj4eTvFPVjp1qSbuGQ9/Sojl5UK7crDBNQQMI0cZq9lKR5ID9Xw==
X-Received: by 2002:a05:620a:468e:b0:79d:7793:ee3a with SMTP id af79cd13be357-79eee1de29bmr432418785a.15.1720142280544;
        Thu, 04 Jul 2024 18:18:00 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79ef26f843dsm65413685a.136.2024.07.04.18.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 18:18:00 -0700 (PDT)
Message-ID: <5c7025e6558d9344e10cda6ccc3614e1cdc1b43b.camel@redhat.com>
Subject: Re: [PATCH v2 18/49] KVM: x86: Account for max supported CPUID leaf
 when getting raw host CPUID
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 21:17:59 -0400
In-Reply-To: <20240517173926.965351-19-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-19-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> Explicitly zero out the feature word in kvm_cpu_caps if the word's
> associated CPUID function is greater than the max leaf supported by the
> CPU.  For such unsupported functions, Intel CPUs return the output from
> the last supported leaf, not all zeros.
> 
> Practically speaking, this is likely a benign bug, as KVM uses the raw
> host CPUID to mask the kernel's computed capabilities, and the kernel does
> perform max leaf checks when populating boot_cpu_data.  The only way KVM's
> goof could be problematic is if the kernel force-set a feature in a leaf
> that is completely unsupported, _and_ the max supported leaf happened to
> return a value with '1' the same bit position.  Which is theoretically
> possible, but extremely unlikely.  And even if that did happen, it's
> entirely possible that KVM would still provide the correct functionality;
> the kernel did set the capability after all.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 29 ++++++++++++++++++++++++-----
>  1 file changed, 24 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index a51e48663f53..77625a5477b1 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -571,18 +571,37 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +static __always_inline u32 raw_cpuid_get(struct cpuid_reg cpuid)
> +{
> +	struct kvm_cpuid_entry2 entry;
> +	u32 base;
> +
> +	/*
> +	 * KVM only supports features defined by Intel (0x0), AMD (0x80000000),
> +	 * and Centaur (0xc0000000).  WARN if a feature for new vendor base is
> +	 * defined, as this and other code would need to be updated.
> +	 */
> +	base = cpuid.function & 0xffff0000;
> +	if (WARN_ON_ONCE(base && base != 0x80000000 && base != 0xc0000000))
> +		return 0;
> +
> +	if (cpuid_eax(base) < cpuid.function)
> +		return 0;
> +
> +	cpuid_count(cpuid.function, cpuid.index,
> +		    &entry.eax, &entry.ebx, &entry.ecx, &entry.edx);
> +
> +	return *__cpuid_entry_get_reg(&entry, cpuid.reg);
> +}
> +
>  /* Mask kvm_cpu_caps for @leaf with the raw CPUID capabilities of this CPU. */
>  static __always_inline void __kvm_cpu_cap_mask(unsigned int leaf)
>  {
>  	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
> -	struct kvm_cpuid_entry2 entry;
>  
>  	reverse_cpuid_check(leaf);
>  
> -	cpuid_count(cpuid.function, cpuid.index,
> -		    &entry.eax, &entry.ebx, &entry.ecx, &entry.edx);
> -
> -	kvm_cpu_caps[leaf] &= *__cpuid_entry_get_reg(&entry, cpuid.reg);
> +	kvm_cpu_caps[leaf] &= raw_cpuid_get(cpuid);
>  }
>  
>  static __always_inline

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Best regards,
	Maxim Levitsky


