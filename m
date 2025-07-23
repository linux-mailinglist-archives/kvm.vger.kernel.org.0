Return-Path: <kvm+bounces-53314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA151B0FB99
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 22:36:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 806127BA083
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 20:34:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4897E238150;
	Wed, 23 Jul 2025 20:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Co0wzGkI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B3F236453
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 20:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753302903; cv=none; b=dbsPDmZeBfj3xgFy49pN4sw60Fmr32vFi+B5mteyo35vvrgDvVBqXi5hq3jXlcNgeg34LZ8ZZ+7IZhQLbrFiFIe4NTaCp2O6FrDMi7SmwkEGZ6oju2n29jnJ17KeoW2AnAH2QQIuYdPN2QDoFAGrmEoFUIH6wLv2WWyAxcxiJSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753302903; c=relaxed/simple;
	bh=WTZXIXoDsiyMHH7jLVN7/heBJWOZLBzitc9MnX4fESk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MsQgeQUFDdjWlTnyKFdx72dYovMwlflTUlXSwJs90IBiUR8LLmt99XJtyaUSIpj0DEl4KvV0wOLxge+RfHsEmjh9VUD5PuNLjjvpbWNdjsIeugXvyOS1Jg5wuDDOLzh6rcapGAY9SExgQ3SYPAsrn72GeP0B4F2l81uh6wmu8F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Co0wzGkI; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313ff01d2a6so209571a91.3
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 13:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753302901; x=1753907701; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QnR7w9stPdKm98nKrJQNM9+YNaTPwRCkK6LNcC2wLbg=;
        b=Co0wzGkIGFdyRgIKDioE5QfAlzl09kQtRI0cjx0oQhAAJyCvvZSNh4GrdzQKkaVkSY
         SN+6SmeWEi2vdEJxKp2gbuB+vgfHW64zQvDO/PyAx+elpala3EnGMdxtBZSBCR3wZo7j
         eIWLNwqcjVwTg9K0+ocq4mCfuJGyeshpwnE8yX4Je0Ny6dRT7viu8oChchHUMPblvvL7
         /CeoWSmu9soNFUqpQkS4JFwZB8lvdBykUOlOqC3mTuQhxtLkZAc1nkv88MPWKWj1gfMg
         Oo3osTtyV5m6ZgHnbSVMr5Sc4SwWvSFdiFX0LXtZf7EL3WcMDo0PunuBwPos6J9r58Mq
         YD1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753302901; x=1753907701;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QnR7w9stPdKm98nKrJQNM9+YNaTPwRCkK6LNcC2wLbg=;
        b=wQ/7yD5XhTwxI8tWhgA/KYrAzOKs8XIUN4RgZ15Pj9SACf1+0TCh1VRLnTUTQV/CHb
         D/nEoeWRsKEp6uRZyjTe1vxB0v0hyVskc8nenxvD2A6VQUYlcO4usO3ZbzcHcocZYd/k
         esHnH3rRJ9v/CO56Xh0U7cpHjvi1J0YVVDYAhI4QskfkoOFNxMMKM/Oz4LpZIINPSbhS
         LGdT3zwdS4WVcZ6BedyjQUakuJJzLb8h27gJYuYTOEO9cDodDQ2qZgdmvFP3KGBFJNXC
         hEfiYtF2bBOgXEu/dZ6zZlC4yrBfvXLn8e5MoxLbDzwtl9a4Ius28WXCIMbRsEmDEIRU
         kiaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgkc0iXxwpkIFKF/fAUr9u35E7tE4VbvFzoJhmT3P92nHWwDpGilwIViqK4VmdlVuMzU0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNUCwwi7Eb/nwZ5eiqTZnzIMqrcsMBfgsoSf9zFdnxPQrc165/
	9xDxxftiqxSBMFV4nsE3m5ZkZwonhzgVw9ghpEnsPwJwGjVM4H0jkv9swrKGZF+8IIkmCvd6Q+C
	dceMFbA==
X-Google-Smtp-Source: AGHT+IElGF/a2fa0rRJVG8x7Wl025nPKxmm0Kd4MFuq7jeA062GW0ZiySl0PXMrGcapOCBE04uzxFXddxes=
X-Received: from pjbos14.prod.google.com ([2002:a17:90b:1cce:b0:30a:31eb:ec8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:da8f:b0:313:283e:e87c
 with SMTP id 98e67ed59e1d1-31e506eea04mr5481708a91.3.1753302901160; Wed, 23
 Jul 2025 13:35:01 -0700 (PDT)
Date: Wed, 23 Jul 2025 13:34:59 -0700
In-Reply-To: <20250707224720.4016504-4-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com> <20250707224720.4016504-4-jthoughton@google.com>
Message-ID: <aIFHc83PtfB9fkKB@google.com>
Subject: Re: [PATCH v5 3/7] KVM: x86/mmu: Recover TDP MMU NX huge pages using
 MMU read lock
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vipin Sharma <vipinsh@google.com>, 
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 07, 2025, James Houghton wrote:
> From: Vipin Sharma <vipinsh@google.com>
> 
> Use MMU read lock to recover TDP MMU NX huge pages. Iterate

Wrap at ~75 chars.

> over the huge pages list under tdp_mmu_pages_lock protection and
> unaccount the page before dropping the lock.
> 
> We must not zap an SPTE if:

No pronouns!

> - The SPTE is a root page.
> - The SPTE does not point at the SP's page table.
> 
> If the SPTE does not point at the SP's page table, then something else
> has change the SPTE, so we cannot safely zap it.
> 
> Warn if zapping SPTE fails and current SPTE is still pointing to same
> page table. This should never happen.
> 
> There is always a race between dirty logging, vCPU faults, and NX huge
> page recovery for backing a gfn by an NX huge page or an executable
> small page. Unaccounting sooner during the list traversal is increasing
> the window of that race. Functionally, it is okay, because accounting
> doesn't protect against iTLB multi-hit bug, it is there purely to
> prevent KVM from bouncing a gfn between two page sizes. The only
> downside is that a vCPU will end up doing more work in tearing down all
> the child SPTEs. This should be a very rare race.
> 
> Zapping under MMU read lock unblocks vCPUs which are waiting for MMU
> read lock. This optimizaion is done to solve a guest jitter issue on
> Windows VM which was observing an increase in network latency.

With slight tweaking:

Use MMU read lock to recover TDP MMU NX huge pages.  To prevent
concurrent modification of the list of potential huge pages, iterate over
the list under tdp_mmu_pages_lock protection and unaccount the page
before dropping the lock.

Zapping under MMU read lock unblocks vCPUs which are waiting for MMU
read lock, which solves a guest jitter issue on Windows VMs which were
observing an increase in network latency.

Do not zap an SPTE if:
- The SPTE is a root page.
- The SPTE does not point at the SP's page table.

If the SPTE does not point at the SP's page table, then something else
has change the SPTE, so KVM cannot safely zap it.

Warn if zapping SPTE fails and current SPTE is still pointing to same
page table, as it should be impossible for the CMPXCHG to fail due to all
other write scenarios being mutually exclusive.

There is always a race between dirty logging, vCPU faults, and NX huge
page recovery for backing a gfn by an NX huge page or an executable
small page.  Unaccounting sooner during the list traversal increases the
window of that race, but functionally, it is okay.  Accounting doesn't
protect against iTLB multi-hit bug, it is there purely to prevent KVM
from bouncing a gfn between two page sizes. The only  downside is that a
vCPU will end up doing more work in tearing down all  the child SPTEs.
This should be a very rare race.

> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Co-developed-by: James Houghton <jthoughton@google.com>
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     | 107 ++++++++++++++++++++++++-------------
>  arch/x86/kvm/mmu/tdp_mmu.c |  42 ++++++++++++---
>  2 files changed, 105 insertions(+), 44 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b074f7bb5cc58..7df1b4ead705b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7535,12 +7535,40 @@ static unsigned long nx_huge_pages_to_zap(struct kvm *kvm,
>  	return ratio ? DIV_ROUND_UP(pages, ratio) : 0;
>  }
>  
> +static bool kvm_mmu_sp_dirty_logging_enabled(struct kvm *kvm,
> +					     struct kvm_mmu_page *sp)
> +{
> +	struct kvm_memory_slot *slot = NULL;
> +
> +	/*
> +	 * Since gfn_to_memslot() is relatively expensive, it helps to skip it if
> +	 * it the test cannot possibly return true.  On the other hand, if any
> +	 * memslot has logging enabled, chances are good that all of them do, in
> +	 * which case unaccount_nx_huge_page() is much cheaper than zapping the
> +	 * page.

And largely irrelevant, because KVM should unaccount the NX no matter what.  I
kinda get what you're saying, but honestly it adds a lot of confusion, especially
since unaccount_nx_huge_page() is in the caller.

> +	 *
> +	 * If a memslot update is in progress, reading an incorrect value of
> +	 * kvm->nr_memslots_dirty_logging is not a problem: if it is becoming
> +	 * zero, gfn_to_memslot() will be done unnecessarily; if it is becoming
> +	 * nonzero, the page will be zapped unnecessarily.  Either way, this only
> +	 * affects efficiency in racy situations, and not correctness.
> +	 */
> +	if (atomic_read(&kvm->nr_memslots_dirty_logging)) {

Short-circuit the function to decrease indentation, and so that "slot" doesn't
need to be NULL-initialized.

> +		struct kvm_memslots *slots;
> +
> +		slots = kvm_memslots_for_spte_role(kvm, sp->role);
> +		slot = __gfn_to_memslot(slots, sp->gfn);

Then this can be:

	slot = __gfn_to_memslot(kvm_memslots_for_spte_role(kvm, sp->role), sp->gfn);

without creating a stupid-long line.

> +		WARN_ON_ONCE(!slot);

And then:

	if (WARN_ON_ONCE(!slot))
		return false;

	return kvm_slot_dirty_track_enabled(slot);

With a comment cleanup:

	struct kvm_memory_slot *slot;

	/*
	 * Skip the memslot lookup if dirty tracking can't possibly be enabled,
	 * as memslot lookups are relatively expensive.
	 *
	 * If a memslot update is in progress, reading an incorrect value of
	 * kvm->nr_memslots_dirty_logging is not a problem: if it is becoming
	 * zero, KVM will  do an unnecessary memslot lookup;  if it is becoming
	 * nonzero, the page will be zapped unnecessarily.  Either way, this
	 * only affects efficiency in racy situations, and not correctness.
	 */
	if (!atomic_read(&kvm->nr_memslots_dirty_logging))
		return false;

	slot = __gfn_to_memslot(kvm_memslots_for_spte_role(kvm, sp->role), sp->gfn);
	if (WARN_ON_ONCE(!slot))
		return false;

	return kvm_slot_dirty_track_enabled(slot);
> @@ -7559,8 +7590,17 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm,
>  	rcu_read_lock();
>  
>  	for ( ; to_zap; --to_zap) {
> -		if (list_empty(nx_huge_pages))
> +#ifdef CONFIG_X86_64

These #ifdefs still make me sad, but I also still think they're the least awful
solution.  And hopefully we will jettison 32-bit sooner than later :-)

