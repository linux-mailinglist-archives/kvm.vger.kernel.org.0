Return-Path: <kvm+bounces-35579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C8A41A12907
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 17:45:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 10FA37A22B8
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 16:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 738511BD012;
	Wed, 15 Jan 2025 16:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HthoU3XH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A951632FB
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 16:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736959442; cv=none; b=ZLHWC4LTBlmj3Y8vj00zSqzLASIgFORC28neIqKgnI3wDyPpI1c8ZmlWCh8NXYBIdZSdhUrGnaJoJzj3Px/rBk950Xq09tYNnwomOMvM9qpobwkMvV40TjbrDsfOB2B9nlrSrIk1oyAmbGTaT+3gYQ1b6mS5U4d6gfskY1yCFcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736959442; c=relaxed/simple;
	bh=YBCII7m2QG2Z01GuDiQ37ab8q7KbSegnOadUdf34yxY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o3n0yEAmf20J+IPxLEVx589kcqf6RrVkHlF4FQ/xRU1G3Vv2jef3CiYQ+CDluCz3tviHO831WNIE43rycysAOT/skYxIB0uQJZv6fn8/2epx6Sdke5v9kBqpQ9ywVKCKabZgUZGrvk6VjMlWpTDJOdiUu1xQoyqp6IHC1EZElvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HthoU3XH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736959439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3fZCJNCvAUov8mnoKPx1ga4i2K1yxkPtJErEtwG0/7A=;
	b=HthoU3XHVVGhqNV/pA0VRWrG/bvuLCvng9loQyy6mA1O3usT0qX3L8DV4SwSuyWy2O/uO+
	yjFcAmhDg3zSHPKvlHE53/omFhsQN62A6TDeEYcNq1PJjngu8+6zB3S4cFbZNayCT0rJLB
	wwUWh1SNoGSV7bgVdnkEwFIC/9fN1tk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-257-FpIJXQdUMoiiwDrctl-_Qg-1; Wed, 15 Jan 2025 11:43:58 -0500
X-MC-Unique: FpIJXQdUMoiiwDrctl-_Qg-1
X-Mimecast-MFC-AGG-ID: FpIJXQdUMoiiwDrctl-_Qg
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43624b08181so127255e9.0
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 08:43:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736959437; x=1737564237;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3fZCJNCvAUov8mnoKPx1ga4i2K1yxkPtJErEtwG0/7A=;
        b=cYThqU0yD6dQLgFYOzxIYUOVxOvUYAegndCeg/pcYkgef+ASSQ1ojo6oO4Rzx4FARZ
         ShzJvZJZht6Ql9b4oE+OJiQ5F5m1vWN99yYYrY79OAr3IOxlnN4V2epei5LjZ0eI+rJ/
         OgohTRd9YyzaLglYH+L9CpNGXpMQxoc6nrTeiG+yqUUVBg3JPGQasy+no3BT65uXFyzL
         BYpE9QYl8Eqx/K6IXZzjWLL29WAh39JQbAYs+4J8P4bTaFkixv7pGHxbYpoVMYw0N5+u
         qvLT3eV58X4nRyvJRZrd8qI9hheOuNIN5aTs9/b9VVOq41SkwTuVupjG0ZoNkg8uTgBz
         gb6A==
X-Forwarded-Encrypted: i=1; AJvYcCX+CVn01imSNbCuEUbizLYCKLI/MypqEGv0MGSsLSadt4h7yFM/BD0jLp2euAwayLlxfMc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRn65vqcLyPF0fOEb4w6nFR49Yi+lN6xVikkKWzgVf6KS86+XF
	M516YKZTLI3lyCyWNmrdd5xWtH7/G2zOfPi3xR+FABDrtf6enqbKlIibmOamzVZnW7lke/17eiF
	b96hVxn7DuNieQiwhIFSIbuxF9/4jmBTYlEXlpPKxZiJJ/XoxPA==
X-Gm-Gg: ASbGnct6R9GcDGPrJga/yUvYEdpvlGvdbR+Z8HERy4UW3n+9py1GYxgvMMThpwTT9gI
	OXAhxA1g27v17/kIyGV6qlTLEcNzWaPbj6XZJVoeO3G9tQuVyjs0QBWT032iDsikDY9618gbi6U
	icJAF/uUM/zs5NQ9AlCk5jIXaX9fPYf1lrfAqj8VBfN7jPqYXbHBcpnjnV/e0V9Ei+U1Wsw1Toy
	riJwGcQuUcTxG6NWqVcSdh/AuzKSZj6wu/PAq+afWrjefD/BlAl8Kk/9L67
X-Received: by 2002:a05:600c:1395:b0:434:fc5d:179c with SMTP id 5b1f17b1804b1-437c6b2790dmr33620015e9.13.1736959436862;
        Wed, 15 Jan 2025 08:43:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE/gWbNGFL7nH3yitI3RAFRrwfJVwgsJ38ePGT+8PXwW7OWiczcRmDnSgAL2bMg5xCWSN2U3Q==
X-Received: by 2002:a05:600c:1395:b0:434:fc5d:179c with SMTP id 5b1f17b1804b1-437c6b2790dmr33619465e9.13.1736959436426;
        Wed, 15 Jan 2025 08:43:56 -0800 (PST)
Received: from [192.168.10.3] ([176.206.124.70])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38be942f405sm1375941f8f.41.2025.01.15.08.43.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2025 08:43:55 -0800 (PST)
Message-ID: <cd099216-5fc7-4a79-8d35-b87c356e122b@redhat.com>
Date: Wed, 15 Jan 2025 17:43:51 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] KVM: TDX SEPT SEAMCALL retry
To: Yan Zhao <yan.y.zhao@intel.com>, seanjc@google.com, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com,
 xiaoyao.li@intel.com, tony.lindgren@intel.com, binbin.wu@linux.intel.com,
 dmatlack@google.com, isaku.yamahata@intel.com, isaku.yamahata@gmail.com
References: <20250113020925.18789-1-yan.y.zhao@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250113020925.18789-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/25 03:09, Yan Zhao wrote:
> This series aims to provide a clean solution to avoid the blind retries in
> the previous hack [1] in "TDX MMU Part 2," following the initial
> discussions to [2], further discussions in the RFC, and the PUCK [3].
> 
> A full analysis of the lock status for each SEAMCALL relevant to KVM is
> available at [4].
> 
> This series categorizes the SEPT-related SEAMCALLs (used for page
> installation and uninstallation) into three groups:
> 
> Group 1: tdh_mem_page_add().
>         - Invoked only during TD build time.
>         - Proposal: Return -EBUSY on TDX_OPERAND_BUSY.
>         - Patch 1.
> 
> Group 2: tdh_mem_sept_add(), tdh_mem_page_aug().
>         - Invoked for TD runtime page installation.
>         - Proposal: Retry locally in the TDX EPT violation handler for
>           RET_PF_RETRY.
>         - Patches 2-3.
> 
> Group 3: tdh_mem_range_block(), tdh_mem_track(), tdh_mem_page_remove().
>         - Invoked for page uninstallation, with KVM mmu_lock held for write.
>         - Proposal: Kick off vCPUs and no vCPU entry on TDX_OPERAND_BUSY.
>         - Patch 4.
> 
> Patches 5/6/7 are fixup patches:
> Patch 5: Return -EBUSY instead of -EAGAIN when tdh_mem_sept_add() is busy.
> Patch 6: Remove the retry loop for tdh_phymem_page_wbinvd_hkid().
> Patch 7: Warn on force_immediate_exit in tdx_vcpu_run().
> 
> Code base: kvm-coco-queue 2f30b837bf7b.
> Applies to the tail since the dependence on
> commit 8e801e55ba8f ("KVM: TDX: Handle EPT violation/misconfig exit"),
> 
> Thanks
> Yan
> 
> RFC --> v1:
> - Split patch 1 in RFC into patches 1,2,3,5, and add new fixup patches 6/7.
> - Add contention analysis of tdh_mem_page_add() in patch 1 log.
> - Provide justification in patch 2 log and add checks for RET_PF_CONTINUE.
> - Use "a per-VM flag wait_for_sept_zap + KVM_REQ_OUTSIDE_GUEST_MODE"
>    instead of a arch-specific request to prevent vCPUs from TD entry in patch 4
>    (Sean).
> 
> RFC: https://lore.kernel.org/all/20241121115139.26338-1-yan.y.zhao@intel.com
> [1] https://lore.kernel.org/all/20241112073909.22326-1-yan.y.zhao@intel.com
> [2] https://lore.kernel.org/kvm/20240904030751.117579-10-rick.p.edgecombe@intel.com/
> [3] https://drive.google.com/drive/folders/1k0qOarKuZXpzRsKDtVeC5Lpl9-amJ6AJ?resourcekey=0-l9uVpVEBC34Uar1ReaqisQ
> [4] https://lore.kernel.org/kvm/ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com

Thanks, I applied this to kvm-coco-queue and patch 2 to kvm/queue.  It 
is spread all over the branch to make the dependencies clearer, so 
here's some ideas on how to include these.

Patches 6 and 7 should be squashed into the respective bases, as they 
have essentially no functional change.

For the rest, patch 1 can be treated as a fixup too, and I have two 
proposals.

First possibility, separate series:
* patches 1+5 are merged into a single patch.
* patches 3+4 become two more patches in this separate series

Second possibility, squash everything:
* patches 1+5 are squashed into the respective bases
* patches 3+4 are included in the EPT violation series

On the PUCK call I said that I prefer the first, mostly to keep track of 
who needs to handle TDX_OPERAND_BUSY, but if it makes it easier for Yan 
then feel free to go for the second.

Paolo

> Yan Zhao (7):
>    KVM: TDX: Return -EBUSY when tdh_mem_page_add() encounters
>      TDX_OPERAND_BUSY
>    KVM: x86/mmu: Return RET_PF* instead of 1 in kvm_mmu_page_fault()
>    KVM: TDX: Retry locally in TDX EPT violation handler on RET_PF_RETRY
>    KVM: TDX: Kick off vCPUs when SEAMCALL is busy during TD page removal
>    fixup! KVM: TDX: Implement hooks to propagate changes of TDP MMU
>      mirror page table
>    fixup! KVM: TDX: Implement hooks to propagate changes of TDP MMU
>      mirror page table
>    fixup! KVM: TDX: Implement TDX vcpu enter/exit path
> 
>   arch/x86/kvm/mmu/mmu.c          |  10 ++-
>   arch/x86/kvm/mmu/mmu_internal.h |  12 ++-
>   arch/x86/kvm/vmx/tdx.c          | 135 ++++++++++++++++++++++++++------
>   arch/x86/kvm/vmx/tdx.h          |   7 ++
>   4 files changed, 134 insertions(+), 30 deletions(-)
> 


