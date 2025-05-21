Return-Path: <kvm+bounces-47210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E172ABE9EE
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 04:27:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09D0518902D1
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 02:27:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F6222D7A5;
	Wed, 21 May 2025 02:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OGbOwqGi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE8722154A
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 02:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747794332; cv=none; b=IE7YhIdaZ8eS3aKFCteKoDwp0MHoX3Jbp7AnjFcAAXD8jMVqh/v1o2hd7xSoq+0vLNxCSvsUbyi3nUlTJMokVsEt8vIsI4kyglh5wJWGgQcnN0WXPI+FuHRppnaqepvyTFgc38/HCkLZju8mmflqpuqq7dTH4Y0UqmR7v/0ri0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747794332; c=relaxed/simple;
	bh=tkPhK9LKALPm6nIelp3ZKXatSKhNAV0B1rYZZ8JKI28=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PqwLYCCLr15ngUv0FtJOs4CKRl6PqoPqn0AWtHxBnGj9C8aap3D5MAFIzdKzxMpG8OYzdcVbnTgWz+7AWoRszXM2/HakmWjJkkqwTRrY8HoubdMNjg58g25CP9OWNCzCGugsjMEAgu2PWhzKu+L3XU1RhVclye/xsg7p/v1ltvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OGbOwqGi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747794328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hkRmm/Yp4BUDonwE4Xac96Ss8wcLW7noonhF13pZKss=;
	b=OGbOwqGi5Ig/t4H+AZ9XB1ZEI9SQfT8CEIaUYkzsOaL6YXkli6DLjFUCxIimZ+c8LQjSi3
	WFJeLsRzn31ffS7j1qpIhcGLIWw+6YD9PXEsTCvwaufvYeSUbeCNkoPc2vDuzYeci0GrXt
	svYRhvyU7EJpa9CMiXa92Nppahw6Y/4=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-f5qYH7NhOHuttbqhsd1r9g-1; Tue, 20 May 2025 22:25:27 -0400
X-MC-Unique: f5qYH7NhOHuttbqhsd1r9g-1
X-Mimecast-MFC-AGG-ID: f5qYH7NhOHuttbqhsd1r9g_1747794326
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-742c03c0272so4681615b3a.1
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 19:25:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747794326; x=1748399126;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hkRmm/Yp4BUDonwE4Xac96Ss8wcLW7noonhF13pZKss=;
        b=UlXXxuTvfyvWs8ruDpu3VlkMaZt2fYNVv7FVnfbQOTJsa8VM5gUi0SOi/Agc57ATbH
         XyRZF7AH0Sjeln/JkKBoKnpJWUmn7bIyoIBk9itVjXX+CgKK+fXg9wVGDHujsWH4pEyA
         EyrPculad/V0WseFSRlBUP15Rx4UygJQNcJm51nHYES2npyg+3pKmKIcZk5+e11BLLfP
         6AhbiufnVrhcMAMpPSeNrkisnZ9l/HSdSdcJmk8jxDzXbvsFAF5rkON/0zzyHVtdVpVU
         wn3WtjN5Ijw8U+fSUfh8YTI0+ROJyHRbGnSxO5xRISSPt1mN6aDLz0DUJv+5sOOqMJHc
         1zlA==
X-Forwarded-Encrypted: i=1; AJvYcCXIbrD6YmAbNc1u644De4eREapvAwqOS+5vHkDYEBViGOkbQv3v021ObwsMGIh4KUivrEg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0Ta5KNcKdME/zme+IYhvQFxslGMeuayKp6CQxbXeJeiU9basS
	t76agRi/nfcKIByDYHvWj50yIROFrylnCgONaIJtFsMkz8Yruj54yxOEUd27F0okpfxpugmkiLc
	284TmRp9BUb3QThARVyYcsVueav7k18qZ+3UJAMPLbM4G/4wZvpSaoQ==
X-Gm-Gg: ASbGncsR8vwECPM/NiF/u3fYIIlZadIBiezl+qSZXupxzzWaOZ4tkVWi3RLuHfVxF+3
	HZ2/KJdw/I+PhVd7lvQihAFOxkqKEOf7Lopq/KnB30ITP7CZDRMdbomK1BW+fqrQd1+wt0n23Ar
	l9u1U9K3ZeTGEEObCZag7StX7UraGE8ZryAieR345puZpJsHRGJSIuM/cskfXvG4ST4/9TFqhXB
	6G7bWR2AmcuVMzAmZeKo/XsGxyN61SrgrXB8Ihgir/8pahk0fQMQoY/6Cflq7hJOaAX0Xy5JMSQ
	LAFno9S4scqi
X-Received: by 2002:a05:6a20:7d9c:b0:1f5:8e39:9470 with SMTP id adf61e73a8af0-216219b2560mr32316772637.31.1747794325919;
        Tue, 20 May 2025 19:25:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IELH1Nkj6QBFRo2UbjW4nbg/CMv3zHb63Laxsznz8iimJrWPxaDEgIYMLdZSM4BBQAJnQlmzw==
X-Received: by 2002:a05:6a20:7d9c:b0:1f5:8e39:9470 with SMTP id adf61e73a8af0-216219b2560mr32316707637.31.1747794325507;
        Tue, 20 May 2025 19:25:25 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b26eaf8e114sm8739609a12.44.2025.05.20.19.25.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 19:25:24 -0700 (PDT)
Message-ID: <fd84d609-936f-4ff2-b495-22d31391181d@redhat.com>
Date: Wed, 21 May 2025 12:25:04 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 12/17] KVM: arm64: Rename variables in user_mem_abort()
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250513163438.3942405-1-tabba@google.com>
 <20250513163438.3942405-13-tabba@google.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250513163438.3942405-13-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 5/14/25 2:34 AM, Fuad Tabba wrote:
> Guest memory can be backed by guest_memfd or by anonymous memory. Rename
> vma_shift to page_shift and vma_pagesize to page_size to ease
> readability in subsequent patches.
> 
> Suggested-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/arm64/kvm/mmu.c | 54 ++++++++++++++++++++++----------------------
>   1 file changed, 27 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9865ada04a81..d756c2b5913f 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1479,13 +1479,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	phys_addr_t ipa = fault_ipa;
>   	struct kvm *kvm = vcpu->kvm;
>   	struct vm_area_struct *vma;
> -	short vma_shift;
> +	short page_shift;
>   	void *memcache;
>   	gfn_t gfn;
>   	kvm_pfn_t pfn;
>   	bool logging_active = memslot_is_logging(memslot);
>   	bool force_pte = logging_active || is_protected_kvm_enabled();
> -	long vma_pagesize, fault_granule;
> +	long page_size, fault_granule;
>   	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>   	struct kvm_pgtable *pgt;
>   	struct page *page;

[...]

>   
>   	/*
> @@ -1600,9 +1600,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	 * ensure we find the right PFN and lay down the mapping in the right
>   	 * place.
>   	 */
> -	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE) {
> -		fault_ipa &= ~(vma_pagesize - 1);
> -		ipa &= ~(vma_pagesize - 1);
> +	if (page_size == PMD_SIZE || page_size == PUD_SIZE) {
> +		fault_ipa &= ~(page_size - 1);
> +		ipa &= ~(page_size - 1);
>   	}
>   

nit: since we're here for readability, ALIGN_DOWN() may be used:

		fault_ipa = ALIGN_DOWN(fault_ipa, page_size);
		ipa = ALIGN_DOWN(ipa, page_size);

Thanks,
Gavin


