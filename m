Return-Path: <kvm+bounces-24980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A43D495D9FD
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:57:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 500B81F238F3
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:57:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CFD61CDA23;
	Fri, 23 Aug 2024 23:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1z0qKek+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F59A1C93AF
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724457422; cv=none; b=jDO4+0R9YB7upM8YHFwrUNW6f6/h9+3l2U57ptAjeM8ZnXDxxancYANYMhXpACDvpjX9LAN0sT986QRPSmlSo5a2dONFPNED9kmfCQE17e1hHGDXAyShn7i15giAFsNBXlx1EDjaz+BRKUeVPAgc56GAbcu2+Y3LXhNpETkaUc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724457422; c=relaxed/simple;
	bh=K8St3htyA6VVaDm3Rq0CK+oQp4eUSdBDL1g81zF2H9s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ozzTQ7e/mC1fb3aGHouHVQ+WALC8PN1qVjL2lzYYR+sO+1Q3n/gAkdmwMygpEq5MJ3DQHHDdbDjlgQ9Td6QLZQW20EgY/BSbq9i0baQ2J91kxwzyeU+8vUe1BFydxcx36HV5hmvNbOZGL7zBhAd6xL0piQL+UtK1LY1RWYS3S9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1z0qKek+; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6886cd07673so54236097b3.3
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724457420; x=1725062220; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UPk6JEKa91c+igfAZBjBchJ5c2y9lYQgDZNe4ht2PjQ=;
        b=1z0qKek+C0+0bKPc+Ba1bQ9BEsVmi0crwwRLoIfisESNbYsx3ydqqw7Hk8mgiRxNSh
         vkXD+1wA9LxAQVKQ6UKrzHF9WuloV8aENkmbwkigtYmX0Q9Tm8qh4D0mai33CgTnPb50
         +dWJSLl4BMwtbpRztpDwBIy7/INNsHJD++nRHbVZhHyQwmcyNm5nM/Ue3UbA3C90R8Oz
         oj0LRO6UFN4jMKBu3d4WbiofMi5dMCHYqZs+50Bbdffsaw+DjfhK52pyydWMnlkbiOyZ
         EgGvwOg5D7lrd2ehX8eh+61jmDuMV6DbxFvPy/5ImvIjv6gqgr4vfkfY5XohfbdeyeTY
         dung==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724457420; x=1725062220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UPk6JEKa91c+igfAZBjBchJ5c2y9lYQgDZNe4ht2PjQ=;
        b=JzC7f10bg5RPwcURErOWqiX8DB9UIhw8pZOU9AOtcC3QgPdfuFIO6Tz9Jq9x7teXsK
         kQPtH/psDax+y52XdP94SHXwKRWj11f0AaxqfYFPpJ53qI4PkV2le6Oq71Hzqx/U0Eud
         uKiMXHnEm5hOn+33eAE7/Y9q92lO6nAzjauYaR2qdrxujZzIkAvulFVypglB5dtaC+/M
         I9DjPrIo2jTvmjl4BABkBt4X4NMKPwklHO7sdfa8+m6idcsuaAobgikZZuolkplVD78u
         l7IHP8bPWndZFHiIJTcsp0sit3QHEed1OEZ2ZJZfVdHIhHhqu4/z5UPv0Ow+pID5N6bM
         bhgw==
X-Gm-Message-State: AOJu0Yx/2tzb8/Vr4nCdXhmiPRhquj7pL2oCzRZw4WDWgHRmktErI+BG
	b+NKs7nErFOueqtd5LjZnPKemwfGbNQ0AnRet6a2wDWk0CIHb2+gr5f3G2YfKzfaetQ8IBd/Imh
	cTOSlZVaURw==
X-Google-Smtp-Source: AGHT+IF/tzRAu8w+aKZnRjKU0gzVbU2/0JiVylPkSqCQdhpXHELsDZB8y+mBj5mOUio+yxo3cmB1sznySHRUGg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:bc8c:0:b0:e02:c06f:1db8 with SMTP id
 3f1490d57ef6-e17a83d5107mr6379276.4.1724457419913; Fri, 23 Aug 2024 16:56:59
 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:56:47 -0700
In-Reply-To: <20240823235648.3236880-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240823235648.3236880-1-dmatlack@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240823235648.3236880-6-dmatlack@google.com>
Subject: [PATCH v2 5/6] KVM: x86/mmu: Rename make_huge_page_split_spte() to make_small_spte()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Rename make_huge_page_split_spte() to make_small_spte(). This ensures
that the usage of "small_spte" and "huge_spte" are consistent between
make_huge_spte() and make_small_spte().

This should also reduce some confusion as make_huge_page_split_spte()
almost reads like it will create a huge SPTE, when in fact it is
creating a small SPTE to split the huge SPTE.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 2 +-
 arch/x86/kvm/mmu/spte.c    | 4 ++--
 arch/x86/kvm/mmu/spte.h    | 4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2f8b1ebcbe9c..8967508b63f9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6693,7 +6693,7 @@ static void shadow_mmu_split_huge_page(struct kvm *kvm,
 			continue;
 		}
 
-		spte = make_huge_page_split_spte(kvm, huge_spte, sp->role, index);
+		spte = make_small_spte(kvm, huge_spte, sp->role, index);
 		mmu_spte_set(sptep, spte);
 		__rmap_add(kvm, cache, slot, sptep, gfn, sp->role.access);
 	}
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index a12437bf6e0c..fe010e3404b1 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -300,8 +300,8 @@ static u64 make_spte_nonexecutable(u64 spte)
  * This is used during huge page splitting to build the SPTEs that make up the
  * new page table.
  */
-u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte,
-			      union kvm_mmu_page_role role, int index)
+u64 make_small_spte(struct kvm *kvm, u64 huge_spte,
+		    union kvm_mmu_page_role role, int index)
 {
 	u64 child_spte = huge_spte;
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 990d599eb827..3aee16e0a575 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -501,8 +501,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
-u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte,
-		      	      union kvm_mmu_page_role role, int index);
+u64 make_small_spte(struct kvm *kvm, u64 huge_spte,
+		    union kvm_mmu_page_role role, int index);
 u64 make_huge_spte(struct kvm *kvm, u64 small_spte, int level);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index be70f0f22550..4c1cd41750ad 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1334,7 +1334,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * not been linked in yet and thus is not reachable from any other CPU.
 	 */
 	for (i = 0; i < SPTE_ENT_PER_PAGE; i++)
-		sp->spt[i] = make_huge_page_split_spte(kvm, huge_spte, sp->role, i);
+		sp->spt[i] = make_small_spte(kvm, huge_spte, sp->role, i);
 
 	/*
 	 * Replace the huge spte with a pointer to the populated lower level
-- 
2.46.0.295.g3b9ea8a38a-goog


