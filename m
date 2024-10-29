Return-Path: <kvm+bounces-29957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0767C9B4D51
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 16:15:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 391541C226DF
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 15:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9152192D62;
	Tue, 29 Oct 2024 15:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RO15ECDH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D092418DF86
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 15:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730214894; cv=none; b=E4ht8pDPi25/ASCBeAtXcxTeU9cBLoz47KtVsEHmmkSqqRYbqSA0qdC/p831tfq0EkDA40h/VtPULcaS/8XfWixFCfr4FYzuvQJoS3rpSlX7l3Lwo6iokKZV7ak6S/2/q9JXviVL5bk2FhwAN3SUHVzFev8JeFZ3751ZC+WM80U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730214894; c=relaxed/simple;
	bh=lJKtF9uyw57HcSU3i1U+ZzNYOAQwKTbClVh4WKhb1GI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TpSl+xpUV3Q/oocipPGcK5g6+z3FClPjPLEZg5kcyb0qmfuKBNZBGR3V8UN3jSo7484ZHufGILabEewPA7b9hOApCRFp1DRwVXbEO4Lk9o3rYb2bhUKoy+IyK4Sk8GfTrBxiQjoefFaZHQwGRom6nZRTSLGMINITuYTIIJgSx18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RO15ECDH; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e9e8978516so45310517b3.0
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 08:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730214892; x=1730819692; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KCP2Vn2Ng5zf73Gvn1yHJlAIc5fq6V4M6kVXt5RfLJM=;
        b=RO15ECDHxMZoZ16drfsTIUuxxzLSwDfPls1zDbnMcdfAu4uyrwoM5IV23V37DVpPNJ
         1vOag/4ATlLHIYK1wt2kH1BtpSPY/RvspwHFLY3tf/T4PqoJSN7jnFgP3GZuyffOKa1Z
         ZRWHoVjI3VWgxPIrHYAwaYh3t73wtNmy5mOlq/uwb34AB5lLHh3+M2D1tzinOI1k6I7+
         cHsO1whtw4SKLUi9clVNkmtV0ECSLn5bKa27JPAXvqHwE1tvnk8rAw4wDGDax35dBCRs
         C0S1v/RTifRTAYgoVCTXt53Xe1PrJQDRJq8L6UVqUV2wXpD6HoEfYV7kKjUQNP+V9FrU
         MSUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730214892; x=1730819692;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KCP2Vn2Ng5zf73Gvn1yHJlAIc5fq6V4M6kVXt5RfLJM=;
        b=dptkezJ2S0YmnrZDKLgA15ST7UkUTx20cSZ0Et7qJoDsWRHXMHU+qhkCt4opV8iCBH
         IcjEsewxvoEO4i/uB0MesrgojtWMltHOjnO/IMW28/q8BiEOVR2gai0Pac0DPThWCayB
         t1rgWgDVqWDZo7t/Im7AwRQrhCc0MlC8SZcjE47y2JUMeFol3ACLW5J6jh9OSPnb4V8o
         lxumsYfd60sZsWdyxUB11jnME+vctmQB/WxkBu66tJw+gXIDjKaPhUtVhDa8WP8HX7lW
         ESjFwVGzz8jFHMgJ0TE//koRQZDNBCx77J1KN8pZ2yErfyI5BHtJdAKm2f6NGdWmrHhx
         0Lgg==
X-Forwarded-Encrypted: i=1; AJvYcCUVGAL0WGGWQV3AaNA6eJTDjPb6vFlWqN9slWFv45MGAiJxAj/Jjrkhaxh3xI+RT0Ia/AQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIYff6OhPXuHpfOmhZc1M6hYLAHbh+ZkPA07HsoIZV7V0zM2WR
	SauPabgia+5zzVkPf8btZS/CEe/4BBSqq5Wy0lcMs7Pza7Vira1MvPLZPbFOOLFBFcuboPFt5Lh
	LDQ==
X-Google-Smtp-Source: AGHT+IElLOMAQKvJj1e8y35BEp+KK30WKxEW1tL1IHN4ETgeazCSYk9zCW8Wkj3atDVL2MvB3W+nt1s1Kkk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:d313:0:b0:e29:7479:402a with SMTP id
 3f1490d57ef6-e3087c2350dmr32167276.10.1730214891688; Tue, 29 Oct 2024
 08:14:51 -0700 (PDT)
Date: Tue, 29 Oct 2024 08:14:50 -0700
In-Reply-To: <20241029031400.622854-3-alexyonghe@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241029031400.622854-1-alexyonghe@tencent.com> <20241029031400.622854-3-alexyonghe@tencent.com>
Message-ID: <ZyD76t8kY3dvO6Yg@google.com>
Subject: Re: [PATCH 2/2] KVM: x86: introduce cache configurations for previous CR3s
From: Sean Christopherson <seanjc@google.com>
To: Yong He <zhuangel570@gmail.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, wanpengli@tencent.com, 
	alexyonghe@tencent.com, junaids@google.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 29, 2024, Yong He wrote:
> From: Yong He <alexyonghe@tencent.com>
> 
> Introduce prev_roots_num param, so that we use more cache of
> previous CR3/root_hpa pairs, which help us to reduce shadow
> page table evict and rebuild overhead.
> 
> Signed-off-by: Yong He <alexyonghe@tencent.com>
> ---

...

> +uint __read_mostly prev_roots_num = KVM_MMU_NUM_PREV_ROOTS;
> +EXPORT_SYMBOL_GPL(prev_roots_num);
> +module_param_cb(prev_roots_num, &prev_roots_num_ops,
> +		&prev_roots_num, 0644);

Allowing the variable to be changed while KVM is running is unsafe.

I also think a module param is the wrong way to try to allow for bigger caches.
The caches themselves are relatively cheap, at 16 bytes per entry.  And I doubt
the cost of searching a larger cache in fast_pgd_switch() would have a measurable
impact, since the most recently used roots will be at the front of the cache,
i.e. only near-misses and misses will be affected.

The only potential downside to larger caches I can think of, is that keeping
root_count elevated would make it more difficult to reclaim shadow pages from
roots that are no longer relevant to the guest.  kvm_mmu_zap_oldest_mmu_pages()
in particular would refuse to reclaim roots.  That shouldn't be problematic for
legacy shadow paging, because KVM doesn't recursively zap shadow pages.  But for
nested TDP, mmu_page_zap_pte() frees the entire tree, in the common case that
child SPTEs aren't shared across multiple trees (common in legacy shadow paging,
extremely uncommon in nested TDP).

And for the nested TDP issue, if it's actually a problem, I would *love* to
solve that problem by making KVM's forced reclaim more sophisticated.  E.g. one
idea would be to kick all vCPUs if the maximum number of pages has been reached,
have each vCPU purge old roots from prev_roots, and then reclaim unused roots.
It would be a bit more complicated than that, as KVM would need a way to ensure
forward progress, e.g. if the shadow pages limit has been reach with a single
root.  But even then, kvm_mmu_zap_oldest_mmu_pages() could be made a _lot_ smarter.

TL;DR: what if we simply bump the number of cached roots to ~16?

