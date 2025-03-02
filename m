Return-Path: <kvm+bounces-39831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11910A4B582
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 00:36:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2220B16BD6E
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 23:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB6201DE8B3;
	Sun,  2 Mar 2025 23:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CgJjAi1S"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4618023F396
	for <kvm@vger.kernel.org>; Sun,  2 Mar 2025 23:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740958599; cv=none; b=lt/QeEciFGcNt/Ds8olcBMWJxijD2FqFABqxGqQ/iuW2QjdrQJ0u/MkZo5oQ0ycuYHciCkVzKSGDsHGj0K3qagpJYPwNU+PSpzGFbM7DX7Dt9Z0xw/gikL0YW+DSsR4vn07sc1DzmC0v0nyhXDInlvXCR0WdJkAnV2pJiIl7ffY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740958599; c=relaxed/simple;
	bh=elajwP5GiY+wTmstqYMZ4mmIAKlxv9c19P2Zh3OLnNc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MpNKbYvXcfjoXKm21hIj1deFve7X/5phFjGAUR0A4vlsRhOw/p4Dbw2I/eS8lVdPE1UO1AF+XVZm8I2ESinC8kclC5iORNmR/MRK2D1eeupiEsVk0UOcqDYkq2EjL/5GNQtAs7fjnqrLrKui6dhbvNnEGXM4qvgeOxgsF3Ys50E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CgJjAi1S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740958597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ejh1GDPAKVllO6gllmhAfMEyCPmPMUvWgSEqENGci+A=;
	b=CgJjAi1SGcu11WOs5qs8tCssJfuJSnclYAM9vYOTpahG5pUt7PfCNQmV2hxiv4HZIHZKif
	h7u5AQen+4CEsClydCxPaZnT1svWnlJK8HpTtpORyb6GoygPMIG3Yqg9YlLtZLsaK50djq
	pO9QZVvuVPHo2Ee51y4/tQib/Ff3CZc=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-jYONQBobNY6Zpv-G_IjJEQ-1; Sun, 02 Mar 2025 18:36:31 -0500
X-MC-Unique: jYONQBobNY6Zpv-G_IjJEQ-1
X-Mimecast-MFC-AGG-ID: jYONQBobNY6Zpv-G_IjJEQ_1740958590
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2233b764fc8so67783345ad.3
        for <kvm@vger.kernel.org>; Sun, 02 Mar 2025 15:36:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740958590; x=1741563390;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ejh1GDPAKVllO6gllmhAfMEyCPmPMUvWgSEqENGci+A=;
        b=AfyuQOfCMKnllUEYU6u9a9U9AcfD2p0koqQE8MFtLqA2FzwE/vid1RYm3Zj5kQIFM6
         DxqoTIVe5bjEVfreeIu+GOCiEpPUxsDnMGGDxw8wdX5+qeWwVjMy1TfjR/LOehKgJrAG
         9p19nAMVO9UYd9yEUIpczZE6722lyctOAin2cqJcLT8iR4rJ61N5wgREu28hpUCUeLJT
         LKibvc8n2sFijRo++sIziF7J5FsyRmxVFvy5mdD5mCuEGREHzJ+XLpZ+xRTqfYkO6g5T
         yovmtwwqIHf3DFr6V1hOWqWL+ZCKzD/Trzdt92I3YFjVK5br9HyJJMPvHoF/CGVhklMw
         eECA==
X-Forwarded-Encrypted: i=1; AJvYcCVjnPaRIp3W7cypgjgewdTiUumu03dWTY/ef5+xBbEosTlBytE9HxODgJzTY9ZBT75mkWg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1yt6KqJTYndtQ2aP6g/cvuIzcMJ9mtDu90kMkpX8V8gF2Eda3
	jKfxHjMFNW8bRmUTgN4jvWwfiKtbQl/RKAxJzjOhN9zf09Fz473o/qxzzjHsoASdQILo7PPIO3d
	o7SnfS+zlPbwqBQT9Ycf9fJ6iKKvRKyTQvtSp734sN/aXViNiSg==
X-Gm-Gg: ASbGncuSxxJt2Mgohaw4KQVul/rlS4CrC5IsMXRIOyPPIx+q2gwTnFodaNa0S2gt2Ga
	3ezNwDdxwY+qwA7FEu6tsnhVpai3LtOjl8rxbZKeUosCyVjbT4sWqHtg6yCFzBwehecC53iR4YL
	xWhc4uN13AsZl5KmPH8HPkqmUDYsFgD5ETugsj7goURlXItLWPhBTqG2NWPBxK9dm3eMcCRsV6C
	UgOHWlVdpSdiNLc+dmZI1cAy9jVYvGg6FYxh+F9PCdzKuMPZOIr65yyYvT0bisdOgVyFLcRvJIi
	/lFev2DX8WyO5RcnTw==
X-Received: by 2002:a17:902:d48c:b0:21a:8300:b9ce with SMTP id d9443c01a7336-2236926a62emr202778585ad.49.1740958590125;
        Sun, 02 Mar 2025 15:36:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEddAUa+nONgsuM9Tynj/Y7d+u/KE8b7znylUvPdW2+N+R2Tk2a3TFLdpAdjVAFLYlLTeS4vg==
X-Received: by 2002:a17:902:d48c:b0:21a:8300:b9ce with SMTP id d9443c01a7336-2236926a62emr202778335ad.49.1740958589841;
        Sun, 02 Mar 2025 15:36:29 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223501fbd47sm65995365ad.67.2025.03.02.15.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 15:36:28 -0800 (PST)
Message-ID: <8bf9ba6c-a8b2-42aa-9802-8e968bec1cd5@redhat.com>
Date: Mon, 3 Mar 2025 09:36:20 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 01/45] KVM: Prepare for handling only shared mappings
 in mmu_notifier events
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Sean Christopherson <seanjc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
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
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-2-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-2-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:13 AM, Steven Price wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Add flags to "struct kvm_gfn_range" to let notifier events target only
> shared and only private mappings, and write up the existing mmu_notifier
> events to be shared-only (private memory is never associated with a
> userspace virtual address, i.e. can't be reached via mmu_notifiers).
> 
> Add two flags so that KVM can handle the three possibilities (shared,
> private, and shared+private) without needing something like a tri-state
> enum.
> 
> Link: https://lore.kernel.org/all/ZJX0hk+KpQP0KUyB@google.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   include/linux/kvm_host.h | 2 ++
>   virt/kvm/kvm_main.c      | 7 +++++++
>   2 files changed, 9 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 3cb9a32a6330..0de1e485452c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -266,6 +266,8 @@ struct kvm_gfn_range {
>   	gfn_t end;
>   	union kvm_mmu_notifier_arg arg;
>   	enum kvm_gfn_range_filter attr_filter;
> +	bool only_private;
> +	bool only_shared;
>   	bool may_block;
>   };

The added members (only_private and only_shared) looks duplicated to the
member of attr_filter, which can be set to KVM_FILTER_SHARED, KVM_FILTER_PRIVATE,
or both of them. More details can be found from the following commit where
attr_filter was by dca6c88532322 ("KVM: Add member to struct kvm_gfn_range
to indicate private/shared").

I'm guessing Sean's suggestion was given before dca6c88532322 showed up.

>   bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index faf10671eed2..4f0136094fac 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -593,6 +593,13 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
>   			 * the second or later invocation of the handler).
>   			 */
>   			gfn_range.arg = range->arg;
> +
> +			/*
> +			 * HVA-based notifications aren't relevant to private
> +			 * mappings as they don't have a userspace mapping.
> +			 */
> +			gfn_range.only_private = false;
> +			gfn_range.only_shared = true;
>   			gfn_range.may_block = range->may_block;
>   			/*
>   			 * HVA-based notifications aren't relevant to private

Thanks,
Gavin


