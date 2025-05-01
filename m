Return-Path: <kvm+bounces-45019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B2B7AA59DB
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 05:04:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB3631C0098A
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 03:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 297D22309B0;
	Thu,  1 May 2025 03:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZAQyPRSW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD5D79C0
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 03:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746068674; cv=none; b=ncw3IJm/wuse67NO67H8DNqXwSZQMxN5qhso4hIYAsJ5Z58rUXcYoyJe4R1wbbXJi4PF2awxjF3SEdXRiGnjpgScMcxaTM/lWS0RjXxsk8jqDUG85l9xzSCSwQ4ZJTXVGx63C1WmI+97pWo1ri5MEHZBaE4HDRY5elYsqgV5rxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746068674; c=relaxed/simple;
	bh=tZi2NdvmQc65SnA/rYIjU5Jj7gqR962wW3qNHQ5VACU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZEIZPtV66XIPR03fHwwRXduvfqj3/pqbGddC3HqAYFd6bu1su5e5ZXAPceebE6aZeVQhoK04ta8ghYqt4HOzY9H7OHPxmMoO5OOOqXBNgGgyd3b58gLfGAH2FYcoIW8+EmOyl0hrvTHpwQaZtpINHe/Ej4+3sb28Ks3c7WZPUBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZAQyPRSW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746068672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pesLTZdr5/HKcumUkD4qePwEkxoOaQwmkc5fPPAZSRc=;
	b=ZAQyPRSWzL+i6DXL7RQ18HpJNvyfwboJn3YM1fxE98vL+6NdJZWnFu1ANphdcjC3siJ7CF
	/NWJ1uT2Unt/i5jg/ZpKLsmdp/usV3dz0S8E3vlN9KLpowsPIrlyM+8ouFrwu3AzqoJuOE
	8FiquvKi1jAGtp4U5Ywq+XeQQ3Cr0BU=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-q4n8ZjOeM4aYGLU5vNH1Hg-1; Wed, 30 Apr 2025 23:04:30 -0400
X-MC-Unique: q4n8ZjOeM4aYGLU5vNH1Hg-1
X-Mimecast-MFC-AGG-ID: q4n8ZjOeM4aYGLU5vNH1Hg_1746068669
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-225429696a9so7755205ad.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 20:04:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746068669; x=1746673469;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pesLTZdr5/HKcumUkD4qePwEkxoOaQwmkc5fPPAZSRc=;
        b=k7eRRSEzkeZJL2OqBe21I4u/jWzc5lVxPLZw3dTcwXFll3I1JQArnT1NpuErA0felu
         KcB2A398xSNYkRmct8RxQ9HvbSepzupG9fAdLPR6N7yf6pCfpV0x4TJ0peo9MmezmOoG
         84slQKnW0fuLTMnDfu8FyanDDIaZL1GBg18VBMKIa+QBmTOeOHL7jepoj2wF2FXSTs2J
         jjl3DPwo8AvhJ+45c+fbJhr4lyrJ6u1b2u8u5T+lgbMbIoa1xjRZSoSou36gZy/+g0Cg
         SbB2l7R2we2uGdGMQuWs+8gVAMlgXwYUUOm9lGMXAjrmwboB+kKWFM8IW0CrxdAGDF9o
         Pm5g==
X-Forwarded-Encrypted: i=1; AJvYcCWjXVST3Cw6g1lQNiswt3omkJfEHtOI/miXv7hX/DTFWr6IsRHUsPG8XC7D93F7nPqeCHw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzp8KM1B3gSfzCWSx6QSl3BDAE3mXPxl+P7swhCSpyYvip43LUz
	qS4hWoE8MXGjwITRbA0hUq1dOaGbJe0jRmWMg0Eyet+hIHa6PBtjqlDKXdsi29frg7QW+Zpl4E4
	eesKFXsMQRwGtIsAO9T/sLkoKNwiueE+bHUu60OK4r98JMG+JfQ==
X-Gm-Gg: ASbGncv/h+cjbU/kUxBUO0HvOw++mdr8laMPRjn6R4yTw0qGnP4euFs9fJY2bUGTHH7
	ImUYm8EBuN6QGGbLnzBuei1NO0VHUBYkZvkI6QuXNwvBwrgsuqxD2jgoESInxJJ5Y7UJZcLUrNM
	Z0xHMD5zqmXKsHJfVrVQMSks+34wW35joeOLwox698NwnMuUod+HAqR9yD6SKXmAivyc9rvFZxY
	JYbA0fu+Oqu9iYvZIjBbaaijavpjkNAjK6ORp6x9cboo3ZcHavEDJPjrvxHwDgJzxOzZYky9ip4
	eBm0nuzZuh1h
X-Received: by 2002:a17:902:ce92:b0:227:e6fe:2908 with SMTP id d9443c01a7336-22df5837638mr79119325ad.48.1746068669210;
        Wed, 30 Apr 2025 20:04:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBHru6AxoF/0GFxqHSMv5iJLveZy61hLLoLevsQlDtlaYL5OE3bmqNgmfr/Tilhp0TcTxL9w==
X-Received: by 2002:a17:902:ce92:b0:227:e6fe:2908 with SMTP id d9443c01a7336-22df5837638mr79119055ad.48.1746068668908;
        Wed, 30 Apr 2025 20:04:28 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db50e7a1dsm130579985ad.140.2025.04.30.20.04.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 20:04:28 -0700 (PDT)
Message-ID: <b1ac33d6-13ed-4870-aa60-36393516d593@redhat.com>
Date: Thu, 1 May 2025 13:04:19 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 41/43] KVM: arm64: Expose support for private memory
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
 <20250416134208.383984-42-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-42-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:42 PM, Steven Price wrote:
> Select KVM_GENERIC_PRIVATE_MEM and provide the necessary support
> functions.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v2:
>   * Switch kvm_arch_has_private_mem() to a macro to avoid overhead of a
>     function call.
>   * Guard definitions of kvm_arch_{pre,post}_set_memory_attributes() with
>     #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES.
>   * Early out in kvm_arch_post_set_memory_attributes() if the WARN_ON
>     should trigger.
> ---
>   arch/arm64/include/asm/kvm_host.h |  6 ++++++
>   arch/arm64/kvm/Kconfig            |  1 +
>   arch/arm64/kvm/mmu.c              | 24 ++++++++++++++++++++++++
>   3 files changed, 31 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


