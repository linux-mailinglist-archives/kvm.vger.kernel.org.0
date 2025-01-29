Return-Path: <kvm+bounces-36891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E62F4A226BC
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 00:07:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55306163FCA
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 23:07:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFD611B415F;
	Wed, 29 Jan 2025 23:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W67kCPEP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB85A19F487
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 23:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738192022; cv=none; b=r8E85FXX+lXSUXO4BK/tgLniDdhaOVptxxBRYxI3Frimy756UZZfttN/ggnkFPI+f5b5e0QCUouilsjNn5p8qCOAMUuhctMJbf0seFJy4o1+EVM3Fqo/Ap/tsEmEN/cemT7LV2TJbPZ3X8aoVdY4BMqte/QEJ0dTAD1ZAs82O7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738192022; c=relaxed/simple;
	bh=zUh44u3xHyFvSH3tS0Wr7/FzaJHez2vFFdMcDL88fsI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PvWtd4r5gAOSj0sjYlZE4zjWQGMb6pHtwElNatJfvO9dVhPbt4sgOJ6PV0vbGcRA794UPdL0o6e/WigubwoX7iFRR3gLHD3Lb/KE1Oibi3MkYtvFLznn2E4YXwuswqsY3UcHdA7wd0u1urWQJVQy1OVGc3SV49bq4MuZrYJnKjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W67kCPEP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738192018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KyHbZ+Pwxh06r8uU1Lo24oDU5q1mx0zS6wBE1H4R6WI=;
	b=W67kCPEP/yZdGQkg2Gmrl9fEB9XzKOwBLbXJIhk9Os0f8qMBtek1zkD+XA3iOhMuAILlXy
	h5sFNKx82O7x8WknJ+ZIrHqIybOeMf/bWPFVfaUdNZITyiXPkFAhrnVPlzBVWZev9OrVq7
	wApN7rU+ttxP4aRYg4qNTUcvfbOqfEk=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-146-kSkj4AOTPfq4uDKZoOG68Q-1; Wed, 29 Jan 2025 18:06:57 -0500
X-MC-Unique: kSkj4AOTPfq4uDKZoOG68Q-1
X-Mimecast-MFC-AGG-ID: kSkj4AOTPfq4uDKZoOG68Q
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2efa0eb9dacso268352a91.1
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 15:06:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738192016; x=1738796816;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KyHbZ+Pwxh06r8uU1Lo24oDU5q1mx0zS6wBE1H4R6WI=;
        b=JzAjoH+D6Rb3U3BXhQcdCWS7vmRHPajNk6c1CRZdU9XfMqyjRHviVtYW3ysDMTMzmA
         4gvECp80gb4iHgWvQjcBCq+K1Fk4QVyOb/0OzZ82m1poa0ssLwa7lbOqN0YOhuWuvOMA
         WxMOY28URmuInBPBfgMcn1Dspp18X+3NXUtZC7sHthQtMoOrYoWKHqBlFlPbH5IcD5bb
         Bzi3TViSziWL91yH5G8Ic6UIIj1qeZmh87NT8rS06LnNcYEjMGh1L0m5K0+sxr2K2Nfv
         JhEGhyC79697LtTnx41EmL9Fbb8yV/l62D8uSQojwZYwlOLOL1YBzMF+dE7ln1wihjoF
         7eJA==
X-Forwarded-Encrypted: i=1; AJvYcCXFc6kUX2C+LQ0mzym5TbyJMvvoiHlTypilboPFZlN3VXBRsXd7DriXuxeWnnwlpQWxOsw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdPAxrFtH6RaPY4q5MdXVAN2dZQloMeLCXWKK3IYtkee19ysCD
	Wg2Ta0Sm9JJnYoW+FQQrEWpNvm17Y5pr9w+hHYDlpqeXTZeh0x3Sb2OpLhhf9e5zze1flLgkA1z
	ixAz+l/E7AxwxRRpTy5tO04QZEr/WlYNLrndRx1onHjJs6hlIOg==
X-Gm-Gg: ASbGnctANAKp8Ul+9jLgVB4deX7PbVEDQu7TbJo1wdtsGO1GZAllVXz/vQ0iqHVN+KK
	qMiXN6W4OPXdl2IORK55SfBOUlRwJ0s60LcSnZK+/xYvV5K6VPGOiPQowjA6v76Bcom9xUdD9o1
	Cl12c98dgVAcQYgKybTJQfeTQyfwB05iDRSvG6HpoDqPuzMFFtVdiY/aXwMttC92XA4qAqiLjBN
	r0v99ALxI+1xseED1Jwv+aUxoWR5egfkwvWxpJP90KXvMlNXmgGPJtM1CI2GdHgaxf7TyOarcKR
	AjR3fw==
X-Received: by 2002:a05:6a00:1396:b0:725:db34:6a7d with SMTP id d2e1a72fcca58-72fd0c7c6c5mr7442931b3a.23.1738192016162;
        Wed, 29 Jan 2025 15:06:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHK+GFtKGuVAzhj66wtlYDvlWWvG3WVubkOllbBq8t3Ltf+GMVUhA51a8pFaMKDNQBYDvAy4Q==
X-Received: by 2002:a05:6a00:1396:b0:725:db34:6a7d with SMTP id d2e1a72fcca58-72fd0c7c6c5mr7442904b3a.23.1738192015836;
        Wed, 29 Jan 2025 15:06:55 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72fe631bfb0sm30521b3a.23.2025.01.29.15.06.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2025 15:06:55 -0800 (PST)
Message-ID: <dcb08082-4048-4573-9dd4-bf3b81a06bb9@redhat.com>
Date: Thu, 30 Jan 2025 09:06:47 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 11/43] arm64: RME: RTT tear down
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
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-12-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-12-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> The RMM owns the stage 2 page tables for a realm, and KVM must request
> that the RMM creates/destroys entries as necessary. The physical pages
> to store the page tables are delegated to the realm as required, and can
> be undelegated when no longer used.
> 
> Creating new RTTs is the easy part, tearing down is a little more
> tricky. The result of realm_rtt_destroy() can be used to effectively
> walk the tree and destroy the entries (undelegating pages that were
> given to the realm).
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes since v5:
>   * Rename some RME_xxx defines to do with page sizes as RMM_xxx - they are
>     a property of the RMM specification not the RME architecture.
> Changes since v2:
>   * Moved {alloc,free}_delegated_page() and ensure_spare_page() to a
>     later patch when they are actually used.
>   * Some simplifications now rmi_xxx() functions allow NULL as an output
>     parameter.
>   * Improved comments and code layout.
> ---
>   arch/arm64/include/asm/kvm_rme.h |  19 ++++++
>   arch/arm64/kvm/mmu.c             |   6 +-
>   arch/arm64/kvm/rme.c             | 112 +++++++++++++++++++++++++++++++
>   3 files changed, 134 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 209cd99f03dd..32bdedf1d866 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -71,5 +71,24 @@ u32 kvm_realm_ipa_limit(void);
>   int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>   int kvm_init_realm_vm(struct kvm *kvm);
>   void kvm_destroy_realm(struct kvm *kvm);
> +void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits);
> +
> +#define RMM_RTT_BLOCK_LEVEL	2
> +#define RMM_RTT_MAX_LEVEL	3
> +
> +#define RMM_PAGE_SHIFT		12
> +#define RMM_PAGE_SIZE		BIT(RMM_PAGE_SHIFT)
> +/* See ARM64_HW_PGTABLE_LEVEL_SHIFT() */
> +#define RMM_RTT_LEVEL_SHIFT(l)	\
> +	((RMM_PAGE_SHIFT - 3) * (4 - (l)) + 3)
> +#define RMM_L2_BLOCK_SIZE	BIT(RMM_RTT_LEVEL_SHIFT(2))
> +
> +static inline unsigned long rme_rtt_level_mapsize(int level)
> +{
> +	if (WARN_ON(level > RMM_RTT_MAX_LEVEL))
> +		return RMM_PAGE_SIZE;
> +
> +	return (1UL << RMM_RTT_LEVEL_SHIFT(level));
> +}
>   
>   #endif

All those definitions can be moved to rme.c since they're only used in rme.c

Thanks,
Gavin


