Return-Path: <kvm+bounces-28822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CBA099DA12
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 01:22:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C17B282DDE
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 23:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEB361D968A;
	Mon, 14 Oct 2024 23:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="itOo1THQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88D31CBE82
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 23:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728948135; cv=none; b=CC9mYIU+qw2AaX7hxjVFZlFDZsZfVWPHziI91bKvlogoFjFR8Mhwtf5fqRPdOKWO6EFRX0yH7XP42lll6XIqYtjn4rg7bQ7juOHnnismTOeRkbPixo3pOItVle+GMlzhDncYlFKALBRzDjIB6ZfTcvaDLOcoHKvCERTWAn+LD3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728948135; c=relaxed/simple;
	bh=YXFCO4bccdJ+7ry4pV8c5kyf+HA7OBNn4Yy/sBqUDuo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RsNlRSAAE52UB2D4+fJjlDKHmE+1tQ4gdjPSpIIamvBjgIkX4gVry/j9oT4Vi9EhMvIH2VNGeenBHq20eqmzhjrv5TMCfBEYbJ0U/wV+zUWG3pnDxMjNcJdHQMpmtYx4AFbaw4F7ugXdApW19sM+FI2E5mM0gg5Yha4CnQ0Xfso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=itOo1THQ; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7ea70bcc4a2so1599701a12.2
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 16:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728948133; x=1729552933; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VAu7m51SVxmU1exE3wy3lzahRBBLAty9XHzwNKyTXnk=;
        b=itOo1THQIZKCxeEhoyZJu0ctcJbNb4NX1uJWAp+Wma3/DJgmeZF1IFtg81Cfo6w3eX
         jjhZXBmraENnVWOw6UlJvucRrm6Qfb26CSnKpRyAiaWb+L6o5vAME5sutUNUb++XRGsg
         WX6FG+JY1RQCLDK9smYLF3Zmujanv0u7NwdqqQCxtDs3BELlj5yngHB9JDfz6+Ri/ubL
         OpzaAelZ5dUTSK8D2LMVVIcLzVDAFW4htTH4UucXg8SxvCyinNvcApEh8J+ChQK8W64u
         Exxg/gBQPo1Ps3PIG3a1uHLKSGWOH1Y35zUBYt12mtCIunddRsSVZGITUODS0ypY1iVt
         ZQAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728948133; x=1729552933;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VAu7m51SVxmU1exE3wy3lzahRBBLAty9XHzwNKyTXnk=;
        b=a4yhylLc7rq3s6rg29UkOKs7EipIF8bGpbkwOG3Bwazp9v/LKX/Z9nJfUKBLbiDLs2
         LHoT/Iz0tL/pVwzNSQvBcLBNOSIaiBzw6kesw7/V/DMt6VAyzXNOHFNKVJxBLTMKSx0S
         vbuZzMEmn4xpUftYM4jf2ZfQsqCP0YYuS5bm0k9/NgSe2Jm9/vl6jIoB5KxOqr8mBxqd
         NGt+rY106eG/AgsAv3m7klKSQIXgrhvG3QC48/4LtZq3Cj6985OCiZDR8xzS1BGCjevO
         Sng/fMn9RtxtoGBXq+2tDccAqYqalnf/LhJWzy11EOgtAN4gSjPOjnHSDa/HH9PvAkul
         RCjA==
X-Forwarded-Encrypted: i=1; AJvYcCXGjG/Spu/0G5aKtY0I+7bjwHki1KurNA5rf6U4VFJwJO6Gp70aBK5aPvAczzmL4kpKDHs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjaF/l2y7TxFxBRfmI1Hl8tpvwRxZNcrTPkgBzDr6qfOTVxshT
	av6sKPUAVsUjKjJGOvA1NZoYxmkCouc+M83cp1XYTztUIklbfYG4yvLRDno0b2DNrV5iJqv5Ge2
	yHg==
X-Google-Smtp-Source: AGHT+IEKOSgRz9DiX0LTECtalJA9o5kHyI4bzVItB0t5QtRGcyAmOXJ+lxLiO/PhBoXndkle9dQfPQy7mvE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:c25:0:b0:694:4311:6eb4 with SMTP id
 41be03b00d2f7-7ea5358e4e2mr17001a12.8.1728948132929; Mon, 14 Oct 2024
 16:22:12 -0700 (PDT)
Date: Mon, 14 Oct 2024 16:22:11 -0700
In-Reply-To: <20240926013506.860253-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240926013506.860253-1-jthoughton@google.com>
Message-ID: <Zw2no4OGDVK7m8QR@google.com>
Subject: Re: [PATCH v7 00/18] mm: multi-gen LRU: Walk secondary MMU page
 tables while aging
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 26, 2024, James Houghton wrote:
> This patchset makes it possible for MGLRU to consult secondary MMUs
> while doing aging, not just during eviction. This allows for more
> accurate reclaim decisions, which is especially important for proactive
> reclaim.

...

> James Houghton (14):
>   KVM: Remove kvm_handle_hva_range helper functions
>   KVM: Add lockless memslot walk to KVM
>   KVM: x86/mmu: Factor out spte atomic bit clearing routine
>   KVM: x86/mmu: Relax locking for kvm_test_age_gfn and kvm_age_gfn
>   KVM: x86/mmu: Rearrange kvm_{test_,}age_gfn
>   KVM: x86/mmu: Only check gfn age in shadow MMU if
>     indirect_shadow_pages > 0
>   mm: Add missing mmu_notifier_clear_young for !MMU_NOTIFIER
>   mm: Add has_fast_aging to struct mmu_notifier
>   mm: Add fast_only bool to test_young and clear_young MMU notifiers

Per offline discussions, there's a non-zero chance that fast_only won't be needed,
because it may be preferable to incorporate secondary MMUs into MGLRU, even if
they don't support "fast" aging.

What's the status on that front?  Even if the status is "TBD", it'd be very helpful
to let others know, so that they don't spend time reviewing code that might be
completely thrown away.

>   KVM: Pass fast_only to kvm_{test_,}age_gfn
>   KVM: x86/mmu: Locklessly harvest access information from shadow MMU
>   KVM: x86/mmu: Enable has_fast_aging
>   mm: multi-gen LRU: Have secondary MMUs participate in aging
>   KVM: selftests: Add multi-gen LRU aging to access_tracking_perf_test
> 
> Sean Christopherson (4):
>   KVM: x86/mmu: Refactor low level rmap helpers to prep for walking w/o
>     mmu_lock
>   KVM: x86/mmu: Add infrastructure to allow walking rmaps outside of
>     mmu_lock
>   KVM: x86/mmu: Add support for lockless walks of rmap SPTEs
>   KVM: x86/mmu: Support rmap walks without holding mmu_lock when aging
>     gfns

