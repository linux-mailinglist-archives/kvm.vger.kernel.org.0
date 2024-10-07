Return-Path: <kvm+bounces-28086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C285993B3C
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 01:33:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 634D5282B92
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 23:33:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70E7C19069B;
	Mon,  7 Oct 2024 23:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aZ8fMSAM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066C217279E
	for <kvm@vger.kernel.org>; Mon,  7 Oct 2024 23:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728344011; cv=none; b=u0IPB7E7eRUwiD55rO0rXTxeuCcsXsbkqkfFcOQA0hZvtu8QMYtDW7OU0Op1dHDN0iGZfJAPwvjb/uIKe7fpg9lkupf182SbikLmUHFEAKGP6CMSKjw4w4+6WSWxg4QCeAZ0WH1rGes1Iv4ZsXzATNH8aJqNN9oTy1ZthwB8iaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728344011; c=relaxed/simple;
	bh=MrDTR2RWvkLILCduhS7Qm7of3YNeohC1Y4ELsDjirfw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jaJv0XfVwaWoVdZXPFUngCwVzxq4lwCbtPpNiWsjbAyHcRlqXy59jbyWNMWoXwCl1ynYmuSpR5MmNFWqcdHH4npktGuHC1G/rADYtbF4dcJdGodP6bo5aPcHvkPRg2Z4bSb2F94WUI1ZZmJuuTNH2wH4wrIbSoD8NWvb49qgf9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aZ8fMSAM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728344009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oUAx6nXlr893COLcXh7JrWdAKfzazyJiQwKWV+hUdVA=;
	b=aZ8fMSAMHldM4i9J0+gRu+6h1y0EzhkR+Un5jspOdSNcErAg73ui2VnUwD6yL419FtwzjA
	J8O7nLuls83DwyBYTMvYW52AcD52MDJZL+Rd0CqrBobL13huvJEWxYr0/P94XgP2+m873x
	YmjUPiowI7DQdMg5Co8fCYK9RqZygk8=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-PJbdnYZqNMemLam_0Zk34w-1; Mon, 07 Oct 2024 19:33:28 -0400
X-MC-Unique: PJbdnYZqNMemLam_0Zk34w-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2e082ab2ad2so6656269a91.2
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2024 16:33:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728344007; x=1728948807;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oUAx6nXlr893COLcXh7JrWdAKfzazyJiQwKWV+hUdVA=;
        b=dxhS/j+uOgkb5GvsN+26/hX1yACRIYu8tv91mI0GtZsIwfhIGYV1EiIwT3/BOlQbH9
         XOnzcIFm0rjc9vtEpAP6k+r3cTq/v/Y5yuoWCMXbpve8+W1Krk4P8iQeWEn0XiNvA+EU
         zHY934IHCbibWGeHAZn5pxm23MHr7BUzkANe92R09eQsebzhhdbwNZXg1lqMo0hhpXkB
         UHukJwmA+IhGVYcYCugaKzJPK+WtcxTzeEwrGvaqcYj851GErvHMi5BB93JvdKbZ0ho+
         At1LrTuLh+9UHPhkBVjXC4N6Yi0I/0y3acBlG4vb4DknVbWTlViicK5xoobCwd+Rxq1C
         uFag==
X-Forwarded-Encrypted: i=1; AJvYcCUvvj2w84HdAW/o0yDu91MFPgu3KevewJF5zV6fOeWIChAi+eno6l+OKAcx3SXpC/IR8lM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbfoNl/UMqm0rbacLAIWvV4uxtmVSj+FbqDOjYyb/Ztxf4ofq6
	1NhSqcY370hJc58Kw44B7ggdcGHij+bg3O6ynLqlHF92EqkNCGNCxv8w5i3oxhnFv4h5ywd1kgs
	i2NCSYbTH4vufn7UzT05edE4HKxiJs9vJeOOoPXRIQKv0Z2GGrw==
X-Received: by 2002:a17:90b:302:b0:2d8:d098:4f31 with SMTP id 98e67ed59e1d1-2e1e626c06amr14188678a91.17.1728344007104;
        Mon, 07 Oct 2024 16:33:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3uOhYexO703NofjJ/K1+V6Z0EqfLIjrytFm7WskmOCohACxWBRCDtgqXpyOZ0bCoE9smNBQ==
X-Received: by 2002:a17:90b:302:b0:2d8:d098:4f31 with SMTP id 98e67ed59e1d1-2e1e626c06amr14188663a91.17.1728344006795;
        Mon, 07 Oct 2024 16:33:26 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e1e85d93b1sm7767761a91.25.2024.10.07.16.33.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 16:33:26 -0700 (PDT)
Message-ID: <07d1c00d-fcdc-4121-a766-2eb0c149bb8d@redhat.com>
Date: Tue, 8 Oct 2024 09:33:17 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/11] arm64: realm: Query IPA size from the RMM
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
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-4-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004144307.66199-4-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/24 12:42 AM, Steven Price wrote:
> The top bit of the configured IPA size is used as an attribute to
> control whether the address is protected or shared. Query the
> configuration from the RMM to assertain which bit this is.
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v4:
>   * Make PROT_NS_SHARED check is_realm_world() to reduce impact on
>     non-CCA systems.
> Changes since v2:
>   * Drop unneeded extra brackets from PROT_NS_SHARED.
>   * Drop the explicit alignment from 'config' as struct realm_config now
>     specifies the alignment.
> ---
>   arch/arm64/include/asm/pgtable-prot.h | 4 ++++
>   arch/arm64/include/asm/rsi.h          | 2 +-
>   arch/arm64/kernel/rsi.c               | 8 ++++++++
>   3 files changed, 13 insertions(+), 1 deletion(-)
> 

[...]

> diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
> index e4c01796c618..acba065eb00e 100644
> --- a/arch/arm64/include/asm/rsi.h
> +++ b/arch/arm64/include/asm/rsi.h
> @@ -27,7 +27,7 @@ static inline int rsi_set_memory_range(phys_addr_t start, phys_addr_t end,
>   
>   	while (start != end) {
>   		ret = rsi_set_addr_range_state(start, end, state, flags, &top);
> -		if (WARN_ON(ret || top < start || top > end))
> +		if (ret || top < start || top > end)
>   			return -EINVAL;
>   		start = top;
>   	}

I think the changes belong to PATCH[02/11] :)

Thanks,
Gavin


