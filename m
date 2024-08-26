Return-Path: <kvm+bounces-25055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69BDB95F3F3
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 16:35:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E94611F22569
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 14:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 815DF18FC7C;
	Mon, 26 Aug 2024 14:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LQYuqpY1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B47917279E
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 14:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724682884; cv=none; b=KUFH+PAZekea4QuoN5OdkdamCXZt2gUry3MCkDLnEXXiWJ2+Foh+s2pk/uuTfQiSZknvi+828VkKQOwgUysAe2Id7Yfx72kyuCxm2ws1qUzHMcwgGAVZ9vqT/suEXJKaX58fwgxQ2E6XQfVNM2pGC6n5uFZy8C95etzuw8PkAKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724682884; c=relaxed/simple;
	bh=NKmENQZd/I0OamIT6Wd0ddl1rtdBoHe6puFACr/5d84=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TSkYqJy6wDB/+7vDJ0WyGtEbgfIpNRuRwXjgZs+lL2g4YM7xqXQ6HjYnVGTlPdmm34XVO6SDpUr0/W45BgpKK/Gw8HSx+igSTgBpk3QxmTVIrHEwORN0gzavj16xMQiEIMWTHa4MV4zrQlPz15RibOaGGOWkvL6US5mO4hlgWWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LQYuqpY1; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6b1adbdbec9so85154317b3.0
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 07:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724682882; x=1725287682; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9XweLBpKE263oEy5QxtTcmCCOjmArflFgXe8Eq5cViM=;
        b=LQYuqpY1A3BGslGgQNVcstrBUQbjetJeTaOjUrd3waH8l7iVX2/Zjk2OjC2nKcQvxd
         SwR4SJs7K7sTYx5flLvTpSk8vQ5SAvHWk1NsuQnXW9b7+HU7ha5wQOQ2Wxo/S6QGHPRn
         fB8iiZUdFysDyGY4qgJqKK6TK97phIiQ6pg/0icpNKxr3kq3SPtMTj4X/LXBy9b7xtz+
         NHnuEw5AucgAe2s2T5ytIgjbcRMae6cbYKXnQ47u9daNbx0OrJWRRQAVLAGl5fhPK1/v
         Ss/JlrXLiSg6Fuhf7Bt2oVVVdVULMorHCnzeuxCQRl7hdP6j7MJFs0v5jeT1SMjgnL64
         GBCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724682882; x=1725287682;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9XweLBpKE263oEy5QxtTcmCCOjmArflFgXe8Eq5cViM=;
        b=MgfBySemhRz72uxdevq8z5dNHAIT806c2zAiNIMEkHy6hDXEKeOo3hAjOAVvM+u2V2
         nXHNUiQFrX0HqGo/ObeYMZwgUwOPrll0yv1XEL2/BPPEMRlE/RYApGKYA9WqKrXWeS1O
         RYToG77kU6hyHTSkzJDsyJPag6rYavFKN8nPciwweynI+lm13mF3DEOASKIDTbAilR3P
         RAVEuBMUvsrl6h1D4uh8yvr21lg4/xXTtxYz8L76PDWjc7B3cKkT5EFbjrIUTodg/YCm
         I5w7XACF3rMDgwmWcQQs1G00KDkEKXFdfn2kOn8JEA3WcR+FijK21Mk42CvKI+ZQTh5S
         elRQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9+oUyF45W9GU1HNLXAcjkG0ujh/aJxFll+F0Yk4oO65HXiIbXJVNRNE7vg9uGww+SjlM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyflg42iC4BXGW3FeNiYVr2OXCimPqLeWKnqxFTv16TsoOAFoMc
	wPnnVm6wzhuXagjZwnWfC/0v2GWvm1Br662a9DM3t6btKRPJdFJnPzpbDVvQ4nFZg9aYUIzy9Ii
	71g==
X-Google-Smtp-Source: AGHT+IF7LGVXL0BPqXys0c3S7QqlhU4D6PhBJbKwSJrijGqoCE6ICdmlx3a4u+ubcgJD9HeDtU/MHyRVAvU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3309:b0:6b0:d571:3540 with SMTP id
 00721157ae682-6c6289a64a5mr620947b3.6.1724682882008; Mon, 26 Aug 2024
 07:34:42 -0700 (PDT)
Date: Mon, 26 Aug 2024 07:34:35 -0700
In-Reply-To: <20240823223800.GB678289.vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240812171341.1763297-1-vipinsh@google.com> <20240812171341.1763297-3-vipinsh@google.com>
 <Zr_i3caXmIZgQL0t@google.com> <20240819173453.GB2210585.vipinsh@google.com>
 <ZsPDWqOiv_g7Wh_H@google.com> <20240823223800.GB678289.vipinsh@google.com>
Message-ID: <ZsySe8tpDyZAvb6l@google.com>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Recover NX Huge pages belonging to TDP
 MMU under MMU read lock
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: pbonzini@redhat.com, dmatlack@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 23, 2024, Vipin Sharma wrote:
> On 2024-08-19 15:12:42, Sean Christopherson wrote:
> > On Mon, Aug 19, 2024, Vipin Sharma wrote:
> > Huh.  Actually, after a lot of fiddling and staring, there's a simpler solution,
> > and it would force us to comment/document an existing race that's subly ok.
> > 
> > For the dirty logging case, the result of kvm_mmu_sp_dirty_logging_enabled() is
> > visible to the NX recovery thread before the memslot update task is guaranteed
> > to finish (or even start) kvm_mmu_zap_collapsible_sptes().  I.e. KVM could
> > unaccount an NX shadow page before it is zapped, and that could lead to a vCPU
> > replacing the shadow page with an NX huge page.
> > 
> > Functionally, that's a-ok, because the accounting doesn't provide protection
> > against iTLB multi-hit bug, it's there purely to prevent KVM from bouncing a gfn
> > between an NX hugepage and an execute small page.  The only downside to the vCPU
> > doing the replacement is that the vCPU will get saddle with tearing down all the
> > child SPTEs.  But this should be a very rare race, so I can't imagine that would
> > be problematic in practice.
> 
> I am worried that whenever this happens it might cause guest jitter
> which we are trying to avoid as handle_changed_spte() might be keep a
> vCPU busy for sometime.

That race already exists today, and your series already extends the ways in which
the race can be hit.  My suggestion is to (a) explicit document that race and (b)
expand the window in which it can occur to also apply to dirty logging being off.

> > void kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm, unsigned long to_zap)
> > 
> > 		/*
> > 		 * Unaccount the shadow page before zapping its SPTE so as to
> > 		 * avoid bouncing tdp_mmu_pages_lock() more than is necessary.
> > 		 * Clearing nx_huge_page_disallowed before zapping is safe, as
> > 		 * the flag doesn't protect against iTLB multi-hit, it's there
> > 		 * purely to prevent bouncing the gfn between an NX huge page
> > 		 * and an X small spage.  A vCPU could get stuck tearing down
> > 		 * the shadow page, e.g. if it happens to fault on the region
> > 		 * before the SPTE is zapped and replaces the shadow page with
> > 		 * an NX huge page and get stuck tearing down the child SPTEs,
> > 		 * but that is a rare race, i.e. shouldn't impact performance.
> > 		 */
> > 		unaccount_nx_huge_page(kvm, sp);
> 
> Might cause jitter. A long jitter might cause an escalation.
> 
> What if I do not unaccount in the beginning, and  move page to the end
> of the list only if it is still in the list?

The race between kvm_mmu_sp_dirty_logging_enabled() vs. kvm_tdp_mmu_map() vs.
kvm_mmu_zap_collapsible_sptes() still exists.

> If zapping failed because some other flow might be removing this page but it
> still in the possible_nx_huge_pages list, then just move it to the end. The
> thread which is removing will remove it from the list eventually.
> 
> for ( ; to_zap; --to_zap) {
> 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> 	if (list_empty(&kvm->arch.possible_tdp_mmu_nx_huge_pages)) {
> 		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> 		break;
> 	}
> 
> 	sp = list_first_entry(&kvm->arch.possible_tdp_mmu_nx_huge_pages,
> 			      struct kvm_mmu_page,
> 			      possible_nx_huge_page_link);
> 
> 	WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
> 	WARN_ON_ONCE(!sp->role.direct);
> 
> 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> 
> 
> 	/*
> 	 * Don't bother zapping shadow pages if the memslot is being
> 	 * dirty logged, as the relevant pages would just be faulted
> 	 * back in as 4KiB pages.  Potential NX Huge Pages in this slot
> 	 * will be recovered, along with all the other huge pages in
> 	 * the slot, when dirty logging is disabled.
> 	 */
> 	if (kvm_mmu_sp_dirty_logging_enabled(kvm, sp)) {
> 		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> 		unaccount_nx_huge_page(kvm, sp);
> 		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> 		WARN_ON_ONCE(sp->nx_huge_page_disallowed);
> 	} else if (tdp_mmu_zap_possible_nx_huge_page(kvm, sp)) {
> 		flush = true;
> 		WARN_ON_ONCE(sp->nx_huge_page_disallowed);
> 	} else {
> 		/*
> 		 * Try again in future if the page is still in the
> 		 * list
> 		 */
> 		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> 		if (!list_empty(&sp->possible_nx_huge_page_link))
> 			list_move_tail(&sp->possible_nx_huge_page_link,
> 			kvm-> &kvm->arch.possible_nx_huge_pages);

This is unsafe.  The only thing that prevents a use-after-free of "sp" is the fact
that this task holds rcu_read_lock().  The sp could already been queued for freeing
via call_rcu().

> 		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> 	}
> 
> 	/* Resched code below */
> }

