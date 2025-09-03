Return-Path: <kvm+bounces-56718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DFCEEB42D74
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 01:36:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 721791C213D8
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 23:36:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E4B127C178;
	Wed,  3 Sep 2025 23:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g5dgBiF4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FB732F744
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 23:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756942577; cv=none; b=eaYteSnoXx5ZOx0E1AG5hif/HM6Dj/FcF6CI2XmMXrBZEQBdgm0/57istLpraWHLKBePDtJzCxAS50BUzQhddEZ5wCbMCETTP8O4CApILsOSptQDIPtzt0ub9eoi9kCMDg7oEwYurjv/nDYwjHeD8JFIxU8K2PXXI3Av3e8s9gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756942577; c=relaxed/simple;
	bh=UQkBt8q+mpHkzeoBPwe+VU6jSJ9PJ/G13bT7jdZR32E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CJWkNC/DJEV0YfAde3voq8AGhdAdmxbhM2BGXHYqSmxD9gO7UMNIY9GSJLm80uh0rYtoWVF6yx95MgX3alWB9nS4XRJ8Zgbn+A/9G4BEPFNdua6tN4L1l8/LrRxqrk/RYXfhls1Jlh96DVHbSPDPrZoTFyIHtLu5uGJC6GiDUkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g5dgBiF4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756942574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0sXropmRvRzVq8QVYH11V1C2zJovVWTZHbdPqhav95Y=;
	b=g5dgBiF4ajtt6DapSfdrK+Z20ZqwrXleY2hCLbu4DNDPbm6sEMMc3NhhcFuCe/2ug+kjAC
	U0IxfY/kfX2BGctZbw7r3vfLUCwM6xqf9lrHYsIAh+RWL/iqrKIVyg+3oKvzZh+8UxU7+E
	jJEdsyRozCMMwR3DC5S8p8nR2Ggyw2A=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-3hx5ngNzP8GSdqKW2-aIjA-1; Wed, 03 Sep 2025 19:36:13 -0400
X-MC-Unique: 3hx5ngNzP8GSdqKW2-aIjA-1
X-Mimecast-MFC-AGG-ID: 3hx5ngNzP8GSdqKW2-aIjA_1756942572
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-244582bc5e4so5170925ad.2
        for <kvm@vger.kernel.org>; Wed, 03 Sep 2025 16:36:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756942572; x=1757547372;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0sXropmRvRzVq8QVYH11V1C2zJovVWTZHbdPqhav95Y=;
        b=glVFlbGW1Y2cK7a2R8U9qB34DVuGHDNxRZlNBE+3TVuxPHDUCaOhTrnBnE9EyT+W3W
         ZcQLJpBST4dM9T8MN+nWu0hzKRSMHOgV2jQTsT4MLG8S2Fyldjm36VnoKW/WT8nYEKAh
         DLQZ/j3LnDiPSVL8VIIadPDKMv5g6nc3V1DDw/PAJvodNnDcheI9GwkfGcoKD8q9R6HG
         Xn64sSUkagWnH3YKZAH6zdDnR5R7dmIvr7P+vb0Q7GNvekQNX348toxkY5XJwJIarXO/
         JtMgIrx+NWVE5JsPBAFXbOhHzi1znhnHiHmeFhSVfWgTgMh0r+24vU3JmrPTEeAu/IJo
         Go/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVZWGLYy6LcedBeTf0D9wAjbYXJ6k3peEAgs2WyRsWOi688Gr0M0fSh0PuqiGy53dRfxI4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJYMfyfmtXnExHyGjpFp1DrhsIiT5xb4vIDuJHgKzCWfdttlYB
	f7wH9O1OeobVxG4S9B72GQZwwke69KQrAEErYy+RrVUa88yN/+iUxc/JtR5lFkmK3H9l7uMUZut
	fPse6pFzrZdcXNOwkj85Q6RJAg4F/Pbgnsw5KnSGEDGQbbvgqtqrLuA==
X-Gm-Gg: ASbGncsEOgFl8HlvyuJrDrY3wCOgDMdlLKba2UVPOin+33iEPlgTs4PLImyARRsDZ93
	waEhFDBrSeKSpp1uG2zrJJ82555NHRhiAMEovCDoiWVU1C/2c4iziCzoxIj24KOfmrcGhj90GWm
	1eY7UGr/5a3bbvJibfXnvRwZSeXHBNJ9N9K4MKRxUDqzchTtEPsilpqX+CYPPYP0lEK2Un+w26w
	A4wsKnT50GRX51P8a9DekLCsQSgYc2DftEf9Wki8ig31o/R1p5LD1l278TGxAhgpREV2FYWQKW3
	bYd4W0VZ+YPBxlf4RqJRXI8pi8oJ4J6oSSss2pKKVBPIl+qJMPh/k+RhvHU9gARCZkC+yuy8SMX
	BulB+
X-Received: by 2002:a17:902:d4cb:b0:249:3049:9748 with SMTP id d9443c01a7336-24944a98207mr213064205ad.35.1756942571810;
        Wed, 03 Sep 2025 16:36:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWxDvzz4guDF0h66h4LLb4oxiM+mn4RFSoqx9tFAX6Irf9VMfNEHKTbxRTX3+Sn09XeYBQ/A==
X-Received: by 2002:a17:902:d4cb:b0:249:3049:9748 with SMTP id d9443c01a7336-24944a98207mr213063695ad.35.1756942571216;
        Wed, 03 Sep 2025 16:36:11 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2490375b6d0sm172156625ad.62.2025.09.03.16.36.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 16:36:10 -0700 (PDT)
Message-ID: <cb387dcf-7ee0-4cf6-bf10-d043d20190f0@redhat.com>
Date: Thu, 4 Sep 2025 09:36:00 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 15/43] arm64: RME: Allow VMM to set RIPAS
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>
References: <20250820145606.180644-1-steven.price@arm.com>
 <20250820145606.180644-16-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250820145606.180644-16-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/25 12:55 AM, Steven Price wrote:
> Each page within the protected region of the realm guest can be marked
> as either RAM or EMPTY. Allow the VMM to control this before the guest
> has started and provide the equivalent functions to change this (with
> the guest's approval) at runtime.
> 
> When transitioning from RIPAS RAM (1) to RIPAS EMPTY (0) the memory is
> unmapped from the guest and undelegated allowing the memory to be reused
> by the host. When transitioning to RIPAS RAM the actual population of
> the leaf RTTs is done later on stage 2 fault, however it may be
> necessary to allocate additional RTTs to allow the RMM track the RIPAS
> for the requested range.
> 
> When freeing a block mapping it is necessary to temporarily unfold the
> RTT which requires delegating an extra page to the RMM, this page can
> then be recovered once the contents of the block mapping have been
> freed.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes from v9:
>   * Minor coding style fixes.
> Changes from v8:
>   * Propagate the 'may_block' flag to allow conditional calls to
>     cond_resched_rwlock_write().
>   * Introduce alloc_rtt() to wrap alloc_delegated_granule() and
>     kvm_account_pgtable_pages() and use when allocating RTTs.
>   * Code reorganisation to allow init_ipa_state and set_ipa_state to
>     share a common ripas_change() function,
>   * Other minor changes following review.
> Changes from v7:
>   * Replace use of "only_shared" with the upstream "attr_filter" field
>     of struct kvm_gfn_range.
>   * Clean up the logic in alloc_delegated_granule() for when to call
>     kvm_account_pgtable_pages().
>   * Rename realm_destroy_protected_granule() to
>     realm_destroy_private_granule() to match the naming elsewhere. Also
>     fix the return codes in the function to be descriptive.
>   * Several other minor changes to names/return codes.
> Changes from v6:
>   * Split the code dealing with the guest triggering a RIPAS change into
>     a separate patch, so this patch is purely for the VMM setting up the
>     RIPAS before the guest first runs.
>   * Drop the useless flags argument from alloc_delegated_granule().
>   * Account RTTs allocated for a guest using kvm_account_pgtable_pages().
>   * Deal with the RMM granule size potentially being smaller than the
>     host's PAGE_SIZE. Although note alloc_delegated_granule() currently
>     still allocates an entire host page for every RMM granule (so wasting
>     memory when PAGE_SIZE>4k).
> Changes from v5:
>   * Adapt to rebasing.
>   * Introduce find_map_level()
>   * Rename some functions to be clearer.
>   * Drop the "spare page" functionality.
> Changes from v2:
>   * {alloc,free}_delegated_page() moved from previous patch to this one.
>   * alloc_delegated_page() now takes a gfp_t flags parameter.
>   * Fix the reference counting of guestmem pages to avoid leaking memory.
>   * Several misc code improvements and extra comments.
> ---
>   arch/arm64/include/asm/kvm_rme.h |   6 +
>   arch/arm64/kvm/mmu.c             |   8 +-
>   arch/arm64/kvm/rme.c             | 446 +++++++++++++++++++++++++++++++
>   3 files changed, 457 insertions(+), 3 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


