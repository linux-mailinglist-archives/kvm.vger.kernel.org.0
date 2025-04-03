Return-Path: <kvm+bounces-42614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 89A61A7B005
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 23:06:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D49907A6E7E
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 21:05:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1BA7262EE2;
	Thu,  3 Apr 2025 20:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O2YRnHGM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547E425E816
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 20:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743711115; cv=none; b=NkgjSo8uS2gYVVxBii55/8gpxB1w0wYxvcu4YXzXrPEBdix/C8d6miK7X+Z1oMgOZRrBTwVf2Um5RryP/ojIWrb64DT43SwunyZf+l+wdTq79I1u9S6jA2OI7aqjFxBOc9a6VErhLrq3FchVuwfCPLW6jvan3wLFe+h7TkhG2Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743711115; c=relaxed/simple;
	bh=ttNlm+gSJEcJOq5rABNpckTqxwtMmPs7GEXQ+yUg8PI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DroUsAtFio1EYyiFrT88MZbq2PWZWgcb7yVjnrXuhkKg4fjbO9ltYWA38tTSPgVb3UBQdUgnTMpkDXs0s8a/I3ha9IV1+bPB43LczjlteSvB+46n9RTvgG167dYPuUHa+1wQMvN5wthoYNW4EQN9AtHLM5P+Sy4oqXXqTfuSs2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O2YRnHGM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743711112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2JjK2lSJyzrBkcD3tmnBpQOWlUj6xEy7/a1BNny+0HM=;
	b=O2YRnHGMGY9JQR+BSi6LY1NDfHYuX+MhDD3bdNi+fw3vczutC61lapCLY97j0ki9REKkLV
	NDjrlkDHTwONd+EFqpjaQAdQwN0Ne6egzcxfh22e0AnzixrBPWWWhPiJ1ZGcGt6j00lFIr
	grqPY+BqGHPTzXEMJgPRQ0GBipjX68g=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-5-VAuS1OK2N12c5PTR7pRiJQ-1; Thu, 03 Apr 2025 16:11:49 -0400
X-MC-Unique: VAuS1OK2N12c5PTR7pRiJQ-1
X-Mimecast-MFC-AGG-ID: VAuS1OK2N12c5PTR7pRiJQ_1743711109
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c5b9333642so129794585a.3
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 13:11:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743711109; x=1744315909;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2JjK2lSJyzrBkcD3tmnBpQOWlUj6xEy7/a1BNny+0HM=;
        b=g1LF/GRaK9IVWwBtEccZFs2qAsYfK3afKK8TtWPi//PEjh/gHdc9or1je98B8ZFAS7
         hQ3ewBZPqHcz9y0dWUfkvhypl8c4OMod5RS2AzJYE0B88UJYS8reexHTdi3xS6agAfIy
         vJv/v5bAc1PMYdThOmg5TuOyKHJYXKmMFesGs1QfBQ2PzoKJR4keMqHXco0eLAmSyIQl
         Ee8ppNyrNb99uPGf9YMLbcjxM+wjGcd7G+W3rtIyryyygf6G+JcLbg+PbvlP1W7pY6WX
         wbKKGh4i2+i1Iu83z9JvtSf7VjGmO900HrNFdqO8ozp5H7xH5qdmBJzxQaP//wPUMPnw
         3BHg==
X-Forwarded-Encrypted: i=1; AJvYcCWpPjprzP5EKh020v6OfTbJOtXu8HUhuCmoTf1nelM7LTsyNnDQdCFls54oaboYnxms1Sw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAgk1ULCYLpklXd2/c28QILRDZJ06dC8+d0VcgNKL1i+cUwXCm
	3PIbsm2hQW9s19ZXIfIjTcwgoL6wHM5JnRr4vDruxKqTStYzALjvxhyUeM6xOYUBpPXIrYdmtcn
	CkjeqrM7rIe+3zZ9HvsLTSaOLBHZZDZjyzPhnbWVXbhH+M7Mfkg==
X-Gm-Gg: ASbGncvVNhv/SOKiTihbJREYZ2Muz6Ho8Vx3xvBX+rsr43wPcMNlBPZfDae2ZSP/B4o
	DnpY1mkR90UC94qtq3Lg2OJ7yu4eaHqDJN/b5sRqdU47VPwMSAr/B1p9hB+hIsSloe7RvX/oz0L
	nTwvDowfJ6trHwbFMTVFi6KG8yPTxHxcVXLRaDZGyulr9Gwh7BTRsnp+CRk3kgSdfUUk+iyUbYm
	IPydttMVHmMs1G2xLJyNQeX1/S0F0L4XUUJAwPTYNUP2df2WSNCJ3Vlo9sw5YsLqfGsHxQJ8CO2
	QUjwNQJdoilXzOc=
X-Received: by 2002:a05:620a:f0e:b0:7c5:a435:8c98 with SMTP id af79cd13be357-7c7758951ecmr22338385a.0.1743711108702;
        Thu, 03 Apr 2025 13:11:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGKPkIPW1VJjqFtzQQY4BZDQKcp6b4iFxg0ZhjtfUFoqySucUdGhdETv+oO5Xe6MjAlU7r0vA==
X-Received: by 2002:a05:620a:f0e:b0:7c5:a435:8c98 with SMTP id af79cd13be357-7c7758951ecmr22335585a.0.1743711108355;
        Thu, 03 Apr 2025 13:11:48 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4791b07125asm11785871cf.20.2025.04.03.13.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 13:11:48 -0700 (PDT)
Message-ID: <5f714d7fb68aef92f1bea58a10deb4de1a10a5b8.camel@redhat.com>
Subject: Re: [RFC PATCH 23/24] KVM: nSVM: Allocate a new ASID for nested
 guests
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Rik van Riel <riel@surriel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,  x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2025 16:11:47 -0400
In-Reply-To: <20250326194423.3717668-4-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
	 <20250326194423.3717668-1-yosry.ahmed@linux.dev>
	 <20250326194423.3717668-4-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-03-26 at 19:44 +0000, Yosry Ahmed wrote:
> Now that nested TLB flushes are properly tracked, start allocating a
> separate ASID for nested guests. This allows dropping the unconditional
> TLB flushes on nested transitions and doing finer grained TLB flushing
> when necessary.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c | 11 +++++++++--
>  arch/x86/kvm/svm/svm.c    |  5 +++--
>  arch/x86/kvm/svm/svm.h    |  3 +++
>  3 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 544913461693c..0c887c91bd50d 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1204,6 +1204,7 @@ int svm_allocate_nested(struct vcpu_svm *svm)
>  {
>  	struct kvm_svm *kvm_svm = to_kvm_svm(svm->vcpu.kvm);
>  	struct page *vmcb02_page;
> +	unsigned int asid;
>  
>  	if (svm->nested.initialized)
>  		return 0;
> @@ -1221,8 +1222,14 @@ int svm_allocate_nested(struct vcpu_svm *svm)
>  
>  	svm->nested.initialized = true;
>  
> -	if (!kvm_svm->nested_asid)
> -		kvm_svm->nested_asid = kvm_svm->asid;
> +	if (!kvm_svm->nested_asid) {
> +		asid = kvm_tlb_tags_alloc(&svm_asids);
> +		if (asid && !svm_register_asid(asid)) {
> +			kvm_tlb_tags_free(&svm_asids, asid);
> +			asid = 0;
> +		}
> +		kvm_svm->nested_asid = asid ?: fallback_asid;
> +	}

Nitpick: AFAIK at least nested KVM doesn't enable EFER.SVME,
unless it actually runs a guest thus most of the time we will waste a ASID on a VM
which once did run a VM nested and since then doesn't run anything else.

So maybe we want to free the nested ASID in the svm_free_nested?

>  
>  	return 0;
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 4b95fd6b501e6..196f5bca57a0e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -249,8 +249,8 @@ static unsigned long iopm_base;
>  
>  DEFINE_PER_CPU(struct svm_cpu_data, svm_data);
>  
> -static struct kvm_tlb_tags svm_asids;
> -static unsigned int fallback_asid;
> +struct kvm_tlb_tags svm_asids;
> +unsigned int fallback_asid;
>  
>  /*
>   * Only MSR_TSC_AUX is switched via the user return hook.  EFER is switched via
> @@ -5127,6 +5127,7 @@ static void svm_vm_destroy(struct kvm *kvm)
>  	avic_vm_destroy(kvm);
>  	sev_vm_destroy(kvm);
>  	kvm_tlb_tags_free(&svm_asids, kvm_svm->asid);
> +	kvm_tlb_tags_free(&svm_asids, kvm_svm->nested_asid);
>  }
>  
>  static int svm_vm_init(struct kvm *kvm)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0c44133bc05ca..220d10d2b1a5c 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -630,6 +630,9 @@ static inline void svm_vmgexit_no_action(struct vcpu_svm *svm, u64 data)
>  
>  extern bool dump_invalid_vmcb;
>  
> +extern struct kvm_tlb_tags svm_asids;
> +extern unsigned int fallback_asid;
> +
>  u32 svm_msrpm_offset(u32 msr);
>  u32 *svm_vcpu_alloc_msrpm(void);
>  void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm);


Best regards,
	Maxim Levitsky




