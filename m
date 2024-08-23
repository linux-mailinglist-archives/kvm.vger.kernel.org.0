Return-Path: <kvm+bounces-24960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BD89B95D952
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 00:38:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4CD9F1F23A9F
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 22:38:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C848F1C8FD4;
	Fri, 23 Aug 2024 22:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yt6aVqzW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2E2195
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 22:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724452689; cv=none; b=dSbk21OleqOPFNB+TeN0ga3AdwaO7hHramSODrCSE6HHXFVNdgP1OzNJiqFz5Up77zoGD3mLm9yNUq2X+jdxO5C8GCGezNVwCsyBqfFI6B3FpOz3AFXZw/UwChPoBEz3DeXgBqyxut+1NMW8YzCxd6hd1woePHvpvd5oUi6tuSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724452689; c=relaxed/simple;
	bh=YhT6sdc4+kGrsxvXVGZjTuTgwTTR6fDKBgQ74KqzVrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WLAbXmse9Mi0UTXNvxNXVB8E4rZ1mG3+Hok2HF5OiPwIXlxTp5HSbdF5F75JKu9nsfcykx/OabLenDv7rLyyuRtyxEpxA43UKOB0mu7JvLNbEeq67cZKxKcNX3e2qn0vAgk9xaeFc+rG/bZ7bR+Bq1ISuPp1XufBb2FBWpoSB4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yt6aVqzW; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-202018541afso31655ad.1
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 15:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724452687; x=1725057487; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=67SkyJsl/iWoGiV4vOIFiOAGuN0Lng8flO08TUKRykU=;
        b=yt6aVqzW/WJ4EY0VU/T40zGL5lNQ8O+OCg17R5d1P1UG08ujZdiFko90voaYzdIGNT
         x/D5pStyAxmlJCWrXXl2GtsI7NygYB5h3kj1pudG8PNQxo6i5a6d3HoyGEMjwU/1GW5Y
         pl0ku75uVjrZAw2Q2e+4mwVbwJwL3XCGtu3y2YO9GeCFSzFNKMrkS+BIMWIXAOI7xw3K
         I5W2EeohaNxbluIF/MPxmjy8CNq1dT7SgnG7EZ1CcQbUQbR3lX75rec1De5HcSL38yBW
         qqUoALVqHK15IN4/EKAkSSAFl9CWrzxpBn+ZuyNCuFvuXl/E2ryaCvw5hrKmmEK4G7U2
         ZSLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724452687; x=1725057487;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=67SkyJsl/iWoGiV4vOIFiOAGuN0Lng8flO08TUKRykU=;
        b=Tb3ZrW1I3+7vpx9lZ/pcTSCVS/JV9m0VmWYZtCsymgC+Bqw9TB9D11n9mPZuiXYHuf
         HZ82FVRdCH/mvgM1qqhKa7cjDB/FT21fknE8ONfWBu2mvHnea0SwOfec7SvdEBbmH4cY
         39e0MAKZK869+PNPoDavypx2LS1q7qFsqgtYwnlUsigtShxq+bCHDI4uBWfCX6ujxxAI
         wEjaSWiFp/zAjL/bCPeYG2fDcVPFwkgor0t1vM6jaXylRg9jXYSEXwV4YakOpMMZjbTc
         zNpmg4DmjJE8YNXFjA1+bzZ3pnoT0IT/jijWledmcgXVlsgsVFfr4pgWs24ilvt1KOen
         w0hQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGyO4BiUwUxNJeiSOzbRYiQtFgUdcUS0mTfYQKcyjScPPobNUsGTV12LCEq0T1hHMx5To=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhGNaLnhfjXMeBuxHe/a6Cf4diH8ThBDbUxufnUf1eFMl97fyW
	igoz9+8NyNS/+zyoHxtg+4+c7Fzkq5MeUM8YrF8Pf+dJ+2a2FiV6Zh1+g1NbMxwqKs+EWvW+Skg
	shQ==
X-Google-Smtp-Source: AGHT+IFpfavPcBPprGtWGC73E5dDeBeGQmqT4yNrvSoTORu6KeMugQQYzHlHE+HxJGyoCV4tG78cZA==
X-Received: by 2002:a17:902:e74e:b0:202:445:3c82 with SMTP id d9443c01a7336-203b2bf6c7amr1003465ad.4.1724452686407;
        Fri, 23 Aug 2024 15:38:06 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7143422ebe7sm3633392b3a.14.2024.08.23.15.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2024 15:38:05 -0700 (PDT)
Date: Fri, 23 Aug 2024 15:38:00 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, dmatlack@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Recover NX Huge pages belonging to TDP
 MMU under MMU read lock
Message-ID: <20240823223800.GB678289.vipinsh@google.com>
References: <20240812171341.1763297-1-vipinsh@google.com>
 <20240812171341.1763297-3-vipinsh@google.com>
 <Zr_i3caXmIZgQL0t@google.com>
 <20240819173453.GB2210585.vipinsh@google.com>
 <ZsPDWqOiv_g7Wh_H@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsPDWqOiv_g7Wh_H@google.com>

On 2024-08-19 15:12:42, Sean Christopherson wrote:
> On Mon, Aug 19, 2024, Vipin Sharma wrote:
> > On 2024-08-16 16:38:05, Sean Christopherson wrote:
> > In this patch, tdp_mmu_zap_sp() has been modified to retry failures,
> > which is similar to other retry mechanism in TDP MMU. Won't it be the
> > same issue with other TDP MMU retry flows?
> 
> Similar, but not exactly the same.  The other flows are guarnateed to make forward
> progress, as they'll never revisit a SPTE.  I.e. once a SPTE is observed to be
> !shadow-present, that SPTE will never again be processed.
> 
> This is spinning on a pre-computed variable, and waiting until that many SPs have
> been zapped.  The early break if the list is empty mostly protects against an
> infinite loop, but it's theoretically possible other tasks could keep adding and
> deleting from the list, in perpetuity.

Got it.

> What about something like this?  If the shadow page can't be zapped because
> something else was modifying it, just move on and deal with it next time.

This sounds good. I was trying to force zapping "to_zap" times
shadow pages to make it similar to existing NX huge page recovery
approach.

> But jumping back to the "we actually can [hold tdp_mmu_pages_lock]", if the zap
> is split into the actually CMPXCHG vs. handle_removed_pt() call, then the lock
> can be held while walking+zapping.  And it's quite straightforward, if we're
> willing to forego the sanity checks on the old_spte, which would require wrapping
> the sp in a struct to create a tuple.
> 
> The only part that gives me pause is the fact that it's not super obvious that,
> ignoring the tracepoint, handle_changed_spte() is just a fat wrapper for
> handle_removed_pt() when zapping a SP.
> 
> Huh.  Actually, after a lot of fiddling and staring, there's a simpler solution,
> and it would force us to comment/document an existing race that's subly ok.
> 
> For the dirty logging case, the result of kvm_mmu_sp_dirty_logging_enabled() is
> visible to the NX recovery thread before the memslot update task is guaranteed
> to finish (or even start) kvm_mmu_zap_collapsible_sptes().  I.e. KVM could
> unaccount an NX shadow page before it is zapped, and that could lead to a vCPU
> replacing the shadow page with an NX huge page.
> 
> Functionally, that's a-ok, because the accounting doesn't provide protection
> against iTLB multi-hit bug, it's there purely to prevent KVM from bouncing a gfn
> between an NX hugepage and an execute small page.  The only downside to the vCPU
> doing the replacement is that the vCPU will get saddle with tearing down all the
> child SPTEs.  But this should be a very rare race, so I can't imagine that would
> be problematic in practice.

I am worried that whenever this happens it might cause guest jitter
which we are trying to avoid as handle_changed_spte() might be keep a
vCPU busy for sometime.

> static bool tdp_mmu_zap_possible_nx_huge_page(struct kvm *kvm,
> 					      struct kvm_mmu_page *sp)
> {
> 	/*
> 	 * If a different task modified the SPTE, then it should be impossible
> 	 * for the SPTE to still be used for the to-be-zapped SP.  Non-leaf
> 	 * SPTEs don't have Dirty bits, KVM always sets the Accessed bit when
> 	 * creating non-leaf SPTEs, and all other bits are immutable for non-
> 	 * leaf SPTEs, i.e. the only legal operations for non-leaf SPTEs are
> 	 * zapping and replacement.
> 	 */
> 	if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE)) {
> 		WARN_ON_ONCE(sp->spt == spte_to_child_pt(iter.old_spte, iter.level));

I responded in another patch before reading all this here. This looks
good.

> void kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm, unsigned long to_zap)
> 
> 		/*
> 		 * Unaccount the shadow page before zapping its SPTE so as to
> 		 * avoid bouncing tdp_mmu_pages_lock() more than is necessary.
> 		 * Clearing nx_huge_page_disallowed before zapping is safe, as
> 		 * the flag doesn't protect against iTLB multi-hit, it's there
> 		 * purely to prevent bouncing the gfn between an NX huge page
> 		 * and an X small spage.  A vCPU could get stuck tearing down
> 		 * the shadow page, e.g. if it happens to fault on the region
> 		 * before the SPTE is zapped and replaces the shadow page with
> 		 * an NX huge page and get stuck tearing down the child SPTEs,
> 		 * but that is a rare race, i.e. shouldn't impact performance.
> 		 */
> 		unaccount_nx_huge_page(kvm, sp);

Might cause jitter. A long jitter might cause an escalation.

What if I do not unaccount in the beginning, and  move page to the end
of the list only if it is still in the list? If zapping failed because
some other flow might be removing this page but it still in the
possible_nx_huge_pages list, then just move it to the end. The thread
which is removing will remove it from the list eventually.

for ( ; to_zap; --to_zap) {
	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
	if (list_empty(&kvm->arch.possible_tdp_mmu_nx_huge_pages)) {
		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
		break;
	}

	sp = list_first_entry(&kvm->arch.possible_tdp_mmu_nx_huge_pages,
			      struct kvm_mmu_page,
			      possible_nx_huge_page_link);

	WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
	WARN_ON_ONCE(!sp->role.direct);

	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);


	/*
	 * Don't bother zapping shadow pages if the memslot is being
	 * dirty logged, as the relevant pages would just be faulted
	 * back in as 4KiB pages.  Potential NX Huge Pages in this slot
	 * will be recovered, along with all the other huge pages in
	 * the slot, when dirty logging is disabled.
	 */
	if (kvm_mmu_sp_dirty_logging_enabled(kvm, sp)) {
		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
		unaccount_nx_huge_page(kvm, sp);
		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
		WARN_ON_ONCE(sp->nx_huge_page_disallowed);
	} else if (tdp_mmu_zap_possible_nx_huge_page(kvm, sp)) {
		flush = true;
		WARN_ON_ONCE(sp->nx_huge_page_disallowed);
	} else {
		/*
		 * Try again in future if the page is still in the
		 * list
		 */
		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
		if (!list_empty(&sp->possible_nx_huge_page_link))
			list_move_tail(&sp->possible_nx_huge_page_link,
			kvm-> &kvm->arch.possible_nx_huge_pages);
		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
	}

	/* Resched code below */
}

