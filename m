Return-Path: <kvm+bounces-37989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 70F8DA33214
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 23:07:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 104DA188B206
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 22:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90F422040AD;
	Wed, 12 Feb 2025 22:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zqChrpn/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F132036E6
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 22:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739398023; cv=none; b=Ivig+0B2BgfGJ+7dGYd2NMxsi+Jin91LQ/aabgatu0uZkNi1qkD4OSdpjQumJaOFR7W5zTg4JvO9YMbHtJP5VD7YqvtM0n6fXg/ZAR+vi6iRsvxehmpsy+PDH2JvJUTJffyu9d1xa6uhP/hEygIjrbPjJpyqOtiA/hb5k6HPKkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739398023; c=relaxed/simple;
	bh=W3EI/JwSNPCRO8AUPEByM5MP57IzTM5+fEGnsedN1Ts=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gaM6qeec6wgdr/ZTtQ0/+OD+AjGxebfLbLyHKXJqmgPosc3Vm+I0MOefVjoe6adwHua2W3MgVG5Sj25QxMSvkQDoFVcfE9Zg0O/+/s43pKTJlRF8Ap99eZqbDSsPDOq0LnNFTg861Tjd2SskKcF2/lq0M1VAKocLCw41cF1IAt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zqChrpn/; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa57c42965so602767a91.1
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 14:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739398021; x=1740002821; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LGqR78gPCoFohz0E/LUFCYULs/zf/5PcEDAbIwIJG7o=;
        b=zqChrpn/YmDKUa67UCS4deAYBjUWUZ6angJCX0/BPXWzrghuC0+p1cf/drWY5jl2Qd
         PmIP2Ntr9elLU687zScTkpQv0hO+tqUM61C6cUG+pS5LYlC4rjAUwTl152S0CQHn+vMq
         mIu4jvkCsBFobgxNq7Y/l9jjY9LL3I6r8Tc+VjD1TXhUNKD0a3gFNlg86HSaXA32M7GD
         GIsgjbpV3NASsErTt0fWnvY5l2U5487RnKz+6pBunuCQzzl+g69X0mpWfKnEhy3SDAxu
         /MKdf0trrqLVJznxNbOD0Rhhay4y0KQjEZ33kNwFpsd5sxTf1NNxswDFL5qFsGDZL280
         qKHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739398021; x=1740002821;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LGqR78gPCoFohz0E/LUFCYULs/zf/5PcEDAbIwIJG7o=;
        b=nTdQtbZ3NADl4m6CPG/fZVDU1q/siDkuJ2oMdHrC1lNEb8diIwerJ5V1g8eVRftu0W
         DAfeo3xmbhANCnmu8TRAjOx/j2ibijwJ4HKtiLmsc4C1h0L+9rgIi2Tz4s14RGQb6bSu
         UBgNobxOf6R40ZQSjfd0MEAN6XtjzNAexHMBVq8Q2WReSL3zAd4BO1kp651GkGt8jd84
         1crsp6Fclm7zCXPkMyFfuquP639U94fyf2IOSQMugKwEqMtuMh6llOBPDIVKaukTOkC8
         dein0ephBm6OsAscm/oDHdIM397VcsS+AV5bjS6Tk/tkXep9CaLzwxQD7LssSlST00AL
         hbhw==
X-Forwarded-Encrypted: i=1; AJvYcCVTFaEBcWK6ZfrvnB0W+9lniP3VdaNWe/hlL6LX/jfb2fBQkLdWr5pigrcG+ufTAQUHjrA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5HK+l4+7k/YnnKt2k23N4HS7Z3ag4KtVdJ01JBUFefZ2namge
	G8l14/5BWCpqPtD3IQ4MNMSpCsEXrefKo8Brd7Y25KcrQUeJ3oUUBTtU/bnO3NB9/I2aPYvi+ux
	+OA==
X-Google-Smtp-Source: AGHT+IHKwOsGnli7OQRD04PJwE+8VS+SYu/aOMm+pcV1q2UPRiD3IUftLWbwfUqgVsLruaomYZD37oPEl7A=
X-Received: from pjtd15.prod.google.com ([2002:a17:90b:4f:b0:2fa:1771:e276])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:280b:b0:2f8:2c47:fb36
 with SMTP id 98e67ed59e1d1-2fbf5c6ea65mr8404846a91.33.1739398021418; Wed, 12
 Feb 2025 14:07:01 -0800 (PST)
Date: Wed, 12 Feb 2025 14:07:00 -0800
In-Reply-To: <20250204004038.1680123-5-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250204004038.1680123-1-jthoughton@google.com> <20250204004038.1680123-5-jthoughton@google.com>
Message-ID: <Z60bhK96JnKIgqZQ@google.com>
Subject: Re: [PATCH v9 04/11] KVM: x86/mmu: Relax locking for
 kvm_test_age_gfn() and kvm_age_gfn()
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 04, 2025, James Houghton wrote:
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 22551e2f1d00..e984b440c0f0 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -142,8 +142,14 @@ bool spte_has_volatile_bits(u64 spte)
>  		return true;
>  
>  	if (spte_ad_enabled(spte)) {
> -		if (!(spte & shadow_accessed_mask) ||
> -		    (is_writable_pte(spte) && !(spte & shadow_dirty_mask)))
> +		/*
> +		 * Do not check the Accessed bit. It can be set (by the CPU)
> +		 * and cleared (by kvm_tdp_mmu_age_spte()) without holding

When possible, don't reference functions by name in comments.  There are situations
where it's unavoidable, e.g. when calling out memory barrier pairs, but for cases
like this, it inevitably leads to stale code.

> +		 * the mmu_lock, but when clearing the Accessed bit, we do
> +		 * not invalidate the TLB, so we can already miss Accessed bit

No "we" in comments or changelog.

> +		 * updates.
> +		 */
> +		if (is_writable_pte(spte) && !(spte & shadow_dirty_mask))
>  			return true;

This 100% belongs in a separate prepatory patch.  And if it's moved to a separate
patch, then the rename can/should happen at the same time.

And with the Accessed check gone, and looking forward to the below change, I think
this is the perfect opportunity to streamline the final check to:

	return spte_ad_enabled(spte) && is_writable_pte(spte) &&
	       !(spte & shadow_dirty_mask);

No need to send another version, I'll move things around when applying.

Also, as discussed off-list I'm 99% certain that with the lockless aging, KVM
must atomically update A/D-disabled SPTEs, as the SPTE can be access-tracked and
restored outside of mmu_lock.  E.g. a task that holds mmu_lock and is clearing
the writable bit needs to update it atomically to avoid its change from being
lost.

I'll slot this is in:

--
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 12 Feb 2025 12:58:39 -0800
Subject: [PATCH 03/10] KVM: x86/mmu: Always update A/D-disable SPTEs
 atomically

In anticipation of aging SPTEs outside of mmu_lock, force A/D-disabled
SPTEs to be updated atomically, as aging A/D-disabled SPTEs will mark them
for access-tracking outside of mmu_lock.  Coupled with restoring access-
tracked SPTEs in the fast page fault handler, the end result is that
A/D-disable SPTEs will be volatile at all times.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 9663ba867178..0f9f47b4ab0e 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -141,8 +141,11 @@ bool spte_needs_atomic_update(u64 spte)
 	if (!is_writable_pte(spte) && is_mmu_writable_spte(spte))
 		return true;
 
-	/* Access-tracked SPTEs can be restored by KVM's fast page fault handler. */
-	if (is_access_track_spte(spte))
+	/*
+	 * A/D-disabled SPTEs can be access-tracked by aging, and access-tracked
+	 * SPTEs can be restored by KVM's fast page fault handler.
+	 */
+	if (!spte_ad_enabled(spte))
 		return true;
 
 	/*
@@ -151,8 +154,7 @@ bool spte_needs_atomic_update(u64 spte)
 	 * invalidate TLBs when aging SPTEs, and so it's safe to clobber the
 	 * Accessed bit (and rare in practice).
 	 */
-	return spte_ad_enabled(spte) && is_writable_pte(spte) &&
-	       !(spte & shadow_dirty_mask);
+	return is_writable_pte(spte) && !(spte & shadow_dirty_mask);
 }
 
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
--

