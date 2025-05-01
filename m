Return-Path: <kvm+bounces-45017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14AD0AA59D1
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 04:59:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A95519C04FF
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 02:59:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 095B3230BC0;
	Thu,  1 May 2025 02:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CemDA3RC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A435C22D7BF
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 02:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746068360; cv=none; b=sHSi1B+EfgCfmSo22inB29DVe4k1MhishZHIrcQNxfwYgIP2f0z3cZozpPyUqwwdWw4htjam8u9UBikYmWg1UyaZw6CG4xBgXX/gwf+MjKJWClBsDYUYdgbRUKD5vf0y4dmpS4iQYsPtdPN7HJeJ75tUPSf8PrHTqN25xBUNWfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746068360; c=relaxed/simple;
	bh=Zko5+xN7riZiMuZ1pSKeoiFEaqg2+CWZlT1tk47iQVs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tWV9TBtf+UM/FhYgs3nZn3TXj2BgsYvjN5/utAx1spU1zyUBWSkdiVyxI27BF/gpatJgRlkLqkCflQW48ysEnSH2rcVSJz9FRSjNY9OX4XamhjLLY3TJPSBBpr+NZ5oaGVxRxdfDdrrHjF4KY7ex5M0eZZMcvrk2bu1bvsnWOMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CemDA3RC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746068355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yWDv7QgtWpFRbFd8EFQQNhSn0JvkvImiDgitgfxQfQw=;
	b=CemDA3RCJqzjnvq1R/Ye6HurinvNIG5G7yzcUTdfBiekUfwjq6jMmW8IdyBZYe59bDN2Gj
	qm+A8FuPJXBgDNDNVuzLsa0ImVCmxWI/zSy45Xu1BwycZj1TUQkX63NNgg4d9BAcj9j8vv
	77RmAVxexsMv2ufQR/zjbEaAZN0K37o=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-575-zU7lkWV6OB-gQ0JRp6o3Bw-1; Wed, 30 Apr 2025 22:59:13 -0400
X-MC-Unique: zU7lkWV6OB-gQ0JRp6o3Bw-1
X-Mimecast-MFC-AGG-ID: zU7lkWV6OB-gQ0JRp6o3Bw_1746068353
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-73917303082so397062b3a.3
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 19:59:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746068353; x=1746673153;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yWDv7QgtWpFRbFd8EFQQNhSn0JvkvImiDgitgfxQfQw=;
        b=bIJrjPgETjAClcKlOTJKxI+Qlb/6m9bYA9NwDwQV5WfBYt2saP5O7QyIniXYe+IDmW
         PSl2sCsu4W9e6epwaqNrECykvDiZrUZJzezXXbStY2HzfD7if53mSrrD+uLjwdtrz/Wu
         Yhxgk4oj9qqJgN4Wd2r6Ki9NzvZzPXsUK/Y2fD6BKRi5dGY/LPdkH1/THGi7VUTPOCth
         GGpakG/z8r8ZT/CpSCcHJOGm9fckdbsM9VgPLzBrAvnRMdXae15j28h3lFnvWQsoHOt5
         tlAZ4S1VGT5x7Bd7LK3BnHxRty9xWaO03MEQ5I8ioBmLptlQAgXK+jEEY931uPaJFIq0
         m5Gw==
X-Forwarded-Encrypted: i=1; AJvYcCW0CAV7U7ircCtKGrb9qgok09E+Cm2HDDTsrC8aRPSrafvGP7EhJCDma5vKMD4hLoYjy5Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5CsMvjzmEqejT0+trABpB5yytHTkKXLt/s+XdseqYVCoEyWpW
	iZ5tzCUGzaPG3enHe9LCeHFyREXS8obA57vKW2QsmwOph0AaPYSNFVSRbIbPX1CZK4NtfY/ArnK
	yw3pwCQmIOqJ+vW4AwCPUDry67eCHiahk1Ae7HkJRURCGrgA8yA==
X-Gm-Gg: ASbGncuB2vgM09x1/9TZoCrnQ9tecW00Ivirhhklc7KFnr7HR9X7V1w3g1OEWWmsU6l
	dSnNuE9rAnmx2HqDNCCIAoJvl9KNZXYdUx97y8S8Yi7bDDmnV6aXqneqgPnY0qTlBAY5ONmsTyH
	HoWDuqoDvv+IOqnyKNjkGTOsMDUAK4wjG3UhddoIDQ+VDWyjGDmpRnYF4EZZlc0fiRt1qdludZ4
	FGUZxvw28pX1paC7Qp75eYXP9Qug6FJdaM4x1B3YfonlycPdz9s1QkYOeO+LJA4Vh0LHVA033Ud
	X88JdcasRjis
X-Received: by 2002:a05:6a00:3a25:b0:73e:10ea:1196 with SMTP id d2e1a72fcca58-7403a77bf00mr7642181b3a.8.1746068352824;
        Wed, 30 Apr 2025 19:59:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG0SD+HY6HsoDRs4fU8wKvcmnTLQD3iURrjVjXooMLHosKIAp3vt2EoNdzvtsz4Y2FqbqtOvg==
X-Received: by 2002:a05:6a00:3a25:b0:73e:10ea:1196 with SMTP id d2e1a72fcca58-7403a77bf00mr7642161b3a.8.1746068352436;
        Wed, 30 Apr 2025 19:59:12 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7403991fcbfsm2480425b3a.49.2025.04.30.19.59.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 19:59:11 -0700 (PDT)
Message-ID: <0cd3d811-1e05-4cdc-aaea-b45fddfc9e2d@redhat.com>
Date: Thu, 1 May 2025 12:59:03 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 29/43] arm64: RME: Always use 4k pages for realms
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-30-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-30-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
> Guest_memfd doesn't yet natively support huge pages, and there are
> currently difficulties for a VMM to manage huge pages efficiently so for
> now always split up mappings to PTE (4k).
> 
> The two issues that need progressing before supporting huge pages for
> realms are:
> 
>   1. guest_memfd needs to be able to allocate from an appropriate
>      allocator which can provide huge pages.
> 
>   2. The VMM needs to be able to repurpose private memory for a shared
>      mapping when the guest VM requests memory is transitioned. Because
>      this can happen at a 4k granularity it isn't possible to
>      free/reallocate while huge pages are in use. Allowing the VMM to
>      mmap() the shared portion of a huge page would allow the huge page
>      to be recreated when the memory is unshared and made protected again.
> 
> These two issues are not specific to realms and don't affect the realm
> API, so for now just break everything down to 4k pages in the RMM
> controlled stage 2. Future work can add huge page support without
> changing the uAPI.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v7:
>   * Rewritten commit message
> ---
>   arch/arm64/kvm/mmu.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 

One nitpick below.

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 02b66ee35426..29bab7a46033 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1653,6 +1653,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	if (logging_active || is_protected_kvm_enabled()) {
>   		force_pte = true;
>   		vma_shift = PAGE_SHIFT;
> +	} else if (vcpu_is_rec(vcpu)) {
> +		// Force PTE level mappings for realms
> +		force_pte = true;
> +		vma_shift = PAGE_SHIFT;

		/* Force PTE level mappings for realms */

>   	} else {
>   		vma_shift = get_vma_page_shift(vma, hva);
>   	}

Thanks,
Gavin


