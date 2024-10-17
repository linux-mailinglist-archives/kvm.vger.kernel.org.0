Return-Path: <kvm+bounces-29098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A3249A29ED
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 19:01:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADF571C20A61
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 17:01:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 718B91E0DBD;
	Thu, 17 Oct 2024 16:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WAK1xX1v"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107F41E0DBF
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 16:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729184159; cv=none; b=GI9Q48buZcueizkcPNF2owHzfTtIJFcX/9nsR2PA1kuBuAwjMF0lSPCc0AfxX98qPgaPhopPIwgB1aKr4qPMxKVT6Ydycn6aZUYyYSor8lyrn/K+UJV1a9OfXdYow4tdS10vdP/UUA0VLPzICifnTw6jA1dpQcgMxpCl0r7e1I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729184159; c=relaxed/simple;
	bh=A3Bik+uED0TcCq0mhqgECk3LPeT4BajnICFHkP82o8E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZOGmndeEKK6WFQgOw8zjGuQVt+/QN9Sok98lXU/1mmbruxaREzn0EaZj1dSNoaXXgUoCFYfK/JGivoMogR4SoU4cBqeQJvkp7KrtCFJAvFjsz4RlP5ZaD9upCJYn642MvhY9h5LF0m23JujnIwW2kUEJvljGrUUUTqwA2qEs/ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WAK1xX1v; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729184157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+TF4EjUQe4akBV6YOBjHNWotRzFr1rk74khyhgxzXjA=;
	b=WAK1xX1vFin5xiHSQgZe2YtIPBMNlkHYCg76nC9a6fiXcmNFIc0YKHpDnJmjvrr3GlYoXH
	K2+J8jiQr+NEhO0Y6IkE8mL5vKME75E4RDSEfBdzTPS7BRYiVkYLJ64P5k+Y8LP+5F9tQ8
	pvU/Jdsc16/8kOmKkz1klNLcFFV88qQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-laEk7Jf6NuaoMSSa8pLOPg-1; Thu, 17 Oct 2024 12:55:56 -0400
X-MC-Unique: laEk7Jf6NuaoMSSa8pLOPg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-37d458087c0so1345437f8f.1
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 09:55:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729184154; x=1729788954;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+TF4EjUQe4akBV6YOBjHNWotRzFr1rk74khyhgxzXjA=;
        b=lA8VucmbNq01tWFHUamofSC2q88HPTyN1J03zF3kgn77yuy6q+5k7ykE63HvVb8gzX
         o94phSsstqKyeIGmCdq8ZSS1/qBvLW4tOS/oU2+BTgVQgEAP0h+ee7IxOb/F19iyc0AY
         IFq7WNf3HS2p9K7Ee4/2c6xDZFjSDntGgubJc9OVe2gYndu1cEn2TZIDqd8XrsPSXWpr
         jxY141xGlJ26FsfEuYM3cNXfAzaGNS9NhR4G5EMqHfvKYicIjLgSMHmFIDvrO6LW07HW
         kXfbp12PtUGPCQIBSbg/r4IpXxNxEw5YVbYHjXIXpAJiTESgQkrDOeYcBzfgmbn2CTPW
         tjww==
X-Gm-Message-State: AOJu0Yy4at7VTBb0inpUK+aYItVrzKG5l0zWXyHGtnONYkld25LJW9tq
	+WieZzVHBPeNol5rDGhwpErhXt2PuGcR5dtKVN++7V4KlYj272x1pHV22CnQ6pFtcf2fFuS+No5
	jdm2BTkTTOuCHpR/40AdxmDz5UzBCT/1VKURmeQyqx35DgwIxRHnGd4IaHd0d
X-Received: by 2002:a05:600c:46c7:b0:431:5475:3cd1 with SMTP id 5b1f17b1804b1-4315875fb2fmr24947555e9.17.1729184154475;
        Thu, 17 Oct 2024 09:55:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGftvJZcxEKWFhN/3/ufIEpcdyKySAIL5OLAG96TfSpAvg7JFTk4Yz8MPMsb+oJ1rNYefBfRw==
X-Received: by 2002:a05:600c:46c7:b0:431:5475:3cd1 with SMTP id 5b1f17b1804b1-4315875fb2fmr24947435e9.17.1729184154064;
        Thu, 17 Oct 2024 09:55:54 -0700 (PDT)
Received: from [192.168.10.28] ([151.95.144.54])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-431606c64b8sm899815e9.38.2024.10.17.09.55.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Oct 2024 09:55:53 -0700 (PDT)
Message-ID: <1012877d-1a99-4d0c-92bc-53025dfaf489@redhat.com>
Date: Thu, 17 Oct 2024 18:55:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/18] KVM: x86/mmu: A/D cleanups (on top of
 kvm_follow_pfn)
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yan Zhao <yan.y.zhao@intel.com>, Sagi Shahar <sagis@google.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>
References: <20241011021051.1557902-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241011021051.1557902-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/11/24 04:10, Sean Christopherson wrote:
> This is effectively an extensive of the kvm_follow_pfn series[*] (and
> applies on top of said series), but is x86-specific and is *almost*
> entirely related to Accessed and Dirty bits.
> 
> There's no central theme beyond cleaning up things that were discovered
> when digging deep for the kvm_follow_pfn overhaul, and to a lesser extent
> the series to add MGLRU support in KVM x86.

Very nice - looks obvious in retrospect, as it often happens.

Paolo

> [*] https://lore.kernel.org/all/20241010182427.1434605-1-seanjc@google.com
> 
> Sean Christopherson (18):
>    KVM: x86/mmu: Flush remote TLBs iff MMU-writable flag is cleared from
>      RO SPTE
>    KVM: x86/mmu: Always set SPTE's dirty bit if it's created as writable
>    KVM: x86/mmu: Fold all of make_spte()'s writable handling into one
>      if-else
>    KVM: x86/mmu: Don't force flush if SPTE update clears Accessed bit
>    KVM: x86/mmu: Don't flush TLBs when clearing Dirty bit in shadow MMU
>    KVM: x86/mmu: Drop ignored return value from
>      kvm_tdp_mmu_clear_dirty_slot()
>    KVM: x86/mmu: Fold mmu_spte_update_no_track() into mmu_spte_update()
>    KVM: x86/mmu: WARN and flush if resolving a TDP MMU fault clears
>      MMU-writable
>    KVM: x86/mmu: Add a dedicated flag to track if A/D bits are globally
>      enabled
>    KVM: x86/mmu: Set shadow_accessed_mask for EPT even if A/D bits
>      disabled
>    KVM: x86/mmu: Set shadow_dirty_mask for EPT even if A/D bits disabled
>    KVM: x86/mmu: Use Accessed bit even when _hardware_ A/D bits are
>      disabled
>    KVM: x86/mmu: Process only valid TDP MMU roots when aging a gfn range
>    KVM: x86/mmu: Stop processing TDP MMU roots for test_age if young SPTE
>      found
>    KVM: x86/mmu: Dedup logic for detecting TLB flushes on leaf SPTE
>      changes
>    KVM: x86/mmu: Set Dirty bit for new SPTEs, even if _hardware_ A/D bits
>      are disabled
>    KVM: Allow arch code to elide TLB flushes when aging a young page
>    KVM: x86: Don't emit TLB flushes when aging SPTEs for mmu_notifiers
> 
>   arch/x86/kvm/Kconfig       |   1 +
>   arch/x86/kvm/mmu/mmu.c     |  72 +++++++-----------------
>   arch/x86/kvm/mmu/spte.c    |  59 ++++++++------------
>   arch/x86/kvm/mmu/spte.h    |  72 ++++++++++++------------
>   arch/x86/kvm/mmu/tdp_mmu.c | 109 +++++++++++++++++--------------------
>   arch/x86/kvm/mmu/tdp_mmu.h |   2 +-
>   virt/kvm/Kconfig           |   4 ++
>   virt/kvm/kvm_main.c        |  20 ++-----
>   8 files changed, 142 insertions(+), 197 deletions(-)
> 
> 
> base-commit: 3f9cf3d569fdf7fb451294b636991291965573ce


