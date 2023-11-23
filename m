Return-Path: <kvm+bounces-2355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F30307F5880
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 07:43:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 926D4B210AA
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 06:43:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83F6313ACF;
	Thu, 23 Nov 2023 06:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BC3KbxyY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F6BDD
	for <kvm@vger.kernel.org>; Wed, 22 Nov 2023 22:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700721802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0Y6v5Xhwln7tu/9zxftOsUtL05MptTTj1UHVhZFfC54=;
	b=BC3KbxyY1cqWZHExLgz5VzrUmHGWFze0yQzZNNjt96zxXpMgdGteh1fzFufC++tZZI2v7d
	MZI2Zr8baoMJcwtrvTWetFhx8RZ37zeV84zS+IbUn1mlzHwNM9DS4iSkd1SGutJmJDl0hM
	vYy1yOpDvSJyvYFeUQ5aYBA5HINYyOY=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-134-Byq_AQ2AN5CUjtnIAdTnKA-1; Thu, 23 Nov 2023 01:43:20 -0500
X-MC-Unique: Byq_AQ2AN5CUjtnIAdTnKA-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1cf9577dd05so4835ad.0
        for <kvm@vger.kernel.org>; Wed, 22 Nov 2023 22:43:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700721799; x=1701326599;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Y6v5Xhwln7tu/9zxftOsUtL05MptTTj1UHVhZFfC54=;
        b=vjpIC/3xjUHfucmm6ag8IuXy11ea2GMC/2TTMoLmlIjPv8XVKHy/CMjpGtlmpNC3wP
         qNpKtsfZ4X2rVV5g7YCHX9Z8GSrHZAWl6hHD0dqaEj3hmSdiv6It0Wyyx2MEl7zUt0Fw
         ORPtsMFTnez+ionA3c50Kw1O5KhXyT7+s7Sc5V3pBqd5sfmOrFuCu8VGa/z5Fjn9N9IN
         p9h53Mo1UpcRDx5XDnR7eM/a/+CuN47mtsEpLdGsjJrYgv80haFV5A8USDJdQfCJNMDG
         qTbfaIg/WxqK5AgcQbkxNjt8ivRkSe8It3RhQlJ+ndalBfuR8P4pNoUvNMSyli9KBQ27
         k9Cw==
X-Gm-Message-State: AOJu0Yx4E9v6Lgp9EfwJs3vM2un1gtHAGQR8rcfN5eM65oK52u663My2
	mR7KKuOgZHuvIyEktKHJd7r7L0+6q9FIRBpt6vX5HST6uEOt2OujRu0kJx4Hi1Ypi1z8fj2jUXq
	3XOFuXnszqlFs
X-Received: by 2002:a17:902:d486:b0:1cc:3c2c:fa1a with SMTP id c6-20020a170902d48600b001cc3c2cfa1amr5191043plg.4.1700721799480;
        Wed, 22 Nov 2023 22:43:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGqJ7t5K0G/lG65L6yMQON3n741jzN2NtB/hlBiB4j/kh7OASHj0JQgIsOvheK+O1VEnunV1Q==
X-Received: by 2002:a17:902:d486:b0:1cc:3c2c:fa1a with SMTP id c6-20020a170902d48600b001cc3c2cfa1amr5191028plg.4.1700721799075;
        Wed, 22 Nov 2023 22:43:19 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a4-20020a1709027d8400b001c9d968563csm538754plm.79.2023.11.22.22.43.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Nov 2023 22:43:18 -0800 (PST)
Message-ID: <d5cc3cf1-7b39-9ca3-adf2-224007c751fe@redhat.com>
Date: Thu, 23 Nov 2023 14:43:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: selftests: aarch64: Remove unused functions from
 vpmu test
Content-Language: en-US
To: Raghavendra Rao Ananta <rananta@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20231122221526.2750966-1-rananta@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20231122221526.2750966-1-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Raghavendra,

Those functions might be useful for other pmu tests. Recently I just 
wrote a pmu_event_filter_test[1] and use the enable_counter().

There may have more pmu tests which can use the helper functions, so I 
think we can keep it now. And in my series[1], I have moved them into 
the lib/ as the helper function.

[1]https://lore.kernel.org/all/20231123063750.2176250-1-shahuang@redhat.com/

Thanks,
Shaoqin

On 11/23/23 06:15, Raghavendra Rao Ananta wrote:
> vpmu_counter_access's disable_counter() carries a bug that disables
> all the counters that are enabled, instead of just the requested one.
> Fortunately, it's not an issue as there are no callers of it. Hence,
> instead of fixing it, remove the definition entirely.
> 
> Remove enable_counter() as it's unused as well.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>   .../selftests/kvm/aarch64/vpmu_counter_access.c  | 16 ----------------
>   1 file changed, 16 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> index 5ea78986e665f..e2f0b720cbfcf 100644
> --- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> +++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> @@ -94,22 +94,6 @@ static inline void write_sel_evtyper(int sel, unsigned long val)
>   	isb();
>   }
>   
> -static inline void enable_counter(int idx)
> -{
> -	uint64_t v = read_sysreg(pmcntenset_el0);
> -
> -	write_sysreg(BIT(idx) | v, pmcntenset_el0);
> -	isb();
> -}
> -
> -static inline void disable_counter(int idx)
> -{
> -	uint64_t v = read_sysreg(pmcntenset_el0);
> -
> -	write_sysreg(BIT(idx) | v, pmcntenclr_el0);
> -	isb();
> -}
> -
>   static void pmu_disable_reset(void)
>   {
>   	uint64_t pmcr = read_sysreg(pmcr_el0);


