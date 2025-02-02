Return-Path: <kvm+bounces-37080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D9C9A24CC5
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 07:53:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE5553A5B72
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 06:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E7501D5154;
	Sun,  2 Feb 2025 06:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IPRhCvdB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F02149DFA
	for <kvm@vger.kernel.org>; Sun,  2 Feb 2025 06:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738479181; cv=none; b=Vugcdp0kv8SA5dHac41kmzayPSjdX9itt7yNdoNus+Hc6dazoWmnWyyUGW2Fy4Cwxh5bk5HtRv849CqOr/YcIvwxeRmARR02SZ83Cptm/mq3aXIJYdp5efTH4UtzG/wlvHzt7k8FwdnDDNMk49QoV7tZ2JLz+qBmyHUABmf0W3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738479181; c=relaxed/simple;
	bh=+XQoM2eQ5of19S1D3GwOInAKkzoHqEfVZIdX70/L1xE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uzbStG+ExYB6WcbxFnsQpO6nFmlFLCG8yb0IsT9fJErjuaYi/rg1Ef4/0U2bGdJGGVR6gMg3WOdDIkSx9PSwmpuximSa8cOx3V3kjsBCyQBqPBA5KnSN2sjKR6MdsQbaJ5mNOK9fTdJUVzJSCMYa3M+bMCR6OIgQeuKMDXEEORY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IPRhCvdB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738479179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dmFZPr7vvicMrPdu+ITYGzZQ8FMqK4dGeuyKQ/HiL5g=;
	b=IPRhCvdBGl3kt8pW7g7KBwVgDuz6heMKARPBw48rB+MUhBp4lfApO9sOpb85tDj+uMbwHx
	XduBMqf85pTaKy6AzR7IHis+LYr5IQkL4xqCEplREzPcbZAQaSt6vX4Ipvo0ZoE3UcLs9J
	yvQKJI8O1J6ZOHYxp2wZ5RPhlBN10zg=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-270-VQkF4kXJNva4ZoJmmmOJKA-1; Sun, 02 Feb 2025 01:52:57 -0500
X-MC-Unique: VQkF4kXJNva4ZoJmmmOJKA-1
X-Mimecast-MFC-AGG-ID: VQkF4kXJNva4ZoJmmmOJKA
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2163d9a730aso69758385ad.1
        for <kvm@vger.kernel.org>; Sat, 01 Feb 2025 22:52:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738479176; x=1739083976;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dmFZPr7vvicMrPdu+ITYGzZQ8FMqK4dGeuyKQ/HiL5g=;
        b=ry7dBoIllk+8j0lWMoMoblINprXCeuWtAgWBQ8sZJWFupRm3NsfksUZ3gd2KfkaLlP
         x+PcZK1gZx4zOCrmOi++PfzVggUPB/w6MyOJTSFyNT878dpa1ttjxaLzqB8WuH4Vdsk2
         FCsc8Tk3v17H7iw6ZAzvpF1gtr7idBYpCD6nOK8UIbRPhFwMF/TdXFoSG9lRjPUDWKCJ
         HpdTzqvjj4Unbze+r7C2zZXz1ZOQQp2ovYtPDj5yuvb07ZDlB5ydVDPS2Ylh+ykLH+y7
         VHPNyoHsWr6u8QVcsUQs3lZYTBbtOwSOnQYhL6Yvs6TeRs7V0lYsTxqUYcchcEUQ4B5p
         JEWw==
X-Forwarded-Encrypted: i=1; AJvYcCUZIGbMRSbvizfsE5h/NT3NBoOBj3hTwMkU8AK8bJP2DCeXRkD1w16gHKwgTGEVD4VocKU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxULhJGX0qt/qzyg9gB5m0vyAR1qABTe9bI2Rvgaj+nTJm5V4iG
	JrXqnNT64O1GLHOV+2NE9U2Nn3iaSEW/e9HZj4XX5upejp3LtxwHp35QP24kEBPJzbt5Gd2Y+i5
	9CCK4NpnxOg8wuH16hDQnBw3JoD6qMbQRaWimdnIULiqdZ8ecVQ==
X-Gm-Gg: ASbGncvncoK9ecqG++ZVMNakeJbNBhL87uR3b1Z4FBQVc9m93vAZHG4r8zNbnmFKTEH
	2OAFCDOkgHWiQh5WrbgJIm2WS0RrCrlfD6mTGFsEs4bR++D4T1rwEMCS9Un9fVKxYLONOpUpkdM
	LEX+p+3n6AdRwddB4ExyLnMsxQkYXPFDkVYodiMPYOZMOCvVRh9XFN5MeBFHlTrxlDXcX55JBId
	QrZtlVQ3GF1Ol9ECf/ZF61BseR6ib/Zg2e6py0KGyNuIWJxmV8qYaE9ox8/IHJYPqwtmpawYF8n
	3N/7sw==
X-Received: by 2002:a17:903:246:b0:215:b1e3:c051 with SMTP id d9443c01a7336-21de1968f37mr191228225ad.11.1738479176582;
        Sat, 01 Feb 2025 22:52:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGr8YDEgf3AQME0gtW8Rc2bNGoGwAlcqKLbbyp/bsjze7Hnub47aEwGNl8h+IYW0bDy17/2PA==
X-Received: by 2002:a17:903:246:b0:215:b1e3:c051 with SMTP id d9443c01a7336-21de1968f37mr191227855ad.11.1738479176239;
        Sat, 01 Feb 2025 22:52:56 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de3335cc9sm54443775ad.258.2025.02.01.22.52.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 22:52:55 -0800 (PST)
Message-ID: <82659880-f7a6-48ad-bf54-8371fc3d41d8@redhat.com>
Date: Sun, 2 Feb 2025 16:52:47 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 29/43] arm64: RME: Always use 4k pages for realms
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
 <20241212155610.76522-30-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-30-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> Always split up huge pages to avoid problems managing huge pages. There
> are two issues currently:
> 
> 1. The uABI for the VMM allows populating memory on 4k boundaries even
>     if the underlying allocator (e.g. hugetlbfs) is using a larger page
>     size. Using a memfd for private allocations will push this issue onto
>     the VMM as it will need to respect the granularity of the allocator.
> 
> 2. The guest is able to request arbitrary ranges to be remapped as
>     shared. Again with a memfd approach it will be up to the VMM to deal
>     with the complexity and either overmap (need the huge mapping and add
>     an additional 'overlapping' shared mapping) or reject the request as
>     invalid due to the use of a huge page allocator.
> 
> For now just break everything down to 4k pages in the RMM controlled
> stage 2.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/mmu.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index e88714903ce5..9ede143ccef1 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1603,6 +1603,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	if (logging_active) {
>   		force_pte = true;
>   		vma_shift = PAGE_SHIFT;
> +	} else if (kvm_is_realm(kvm)) {
> +		// Force PTE level mappings for realms
> +		force_pte = true;
> +		vma_shift = PAGE_SHIFT;
>   	} else {
>   		vma_shift = get_vma_page_shift(vma, hva);
>   	}

Since a memory abort is specific to a vCPU instead of a VM, so vcpu_is_rec()
instead of kvm_is_realm() is more accurate for the check. Besides, it looks
duplicate to the check added by "PATCH[20/43] arm64: RME: Runtime faulting
of memory", which is as below.

        /* FIXME: We shouldn't need to disable this for realms */
        if (vma_pagesize == PAGE_SIZE && !(force_pte || device || kvm_is_realm(kvm))) {
                                                                  ^^^^^^^^^^^^^^^^^
                                                                  Can be dropped now.

Thanks,
Gavin
                  



