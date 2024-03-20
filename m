Return-Path: <kvm+bounces-12197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2439880873
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 01:16:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7617284129
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 00:16:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 236C733D0;
	Wed, 20 Mar 2024 00:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dft+e1h4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC67801
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 00:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710893749; cv=none; b=E3LLfv68wSDiOGbmk0+7FMDPskNc4M1DH1/qzCpSLjnYs0fPmcNH71vj5W2NUK7QHdAOVs95aFftxP2g5C3YpnDZRGOm1J/QJMHd7oofSPKJbqj3NTgSC33o8V7xPyyztv147wnNloPYoUcLVt1RE9qthHSp3of4jv09ORG9LLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710893749; c=relaxed/simple;
	bh=YyvaQnQJdiY8Q7R4CiMT+UezwhRShOi5cPHWawz2f9s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=liQClu3iyTuzo7sgUT/iTU89HwOaQln5S1cpgEeQUKCEZZ0ot1uADdAqkHuv28AhQghhNmPfN1cEPHi/DnmTUIOtWRPrWXyiSheD3TqG066QLFbDCRU3c31GTkLlwQZYdvXI51NrmZI4KV4ydBHP5nBqmPmOdmm4ShynJfrmem0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dft+e1h4; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60cbba6f571so118210057b3.1
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 17:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710893746; x=1711498546; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=i9kVuQFqGWveMSm1GQ8GItZlMlvWOz6Hx+yWjI9J9D0=;
        b=dft+e1h4Nh8crW2PYZK9Wc/PQ3LW8gKEhxHBn0x64lcmPtwmgTIW21PgdkJ5S42sS/
         Pmlcadj0i4zwmPC1fx5sFT3boRtHkaV3jogEkosH/84RWf1nGwB9Sr6xtk3vHuO2dmLO
         WNyCeHEgy/5Be4Tl9LzRkX1AuVXcnAGwhsw2ezspFv0MFKQavvxySNpZzQlAmF6KbhQu
         JF46oCgdu5DbrC3IbFadILDqW6xUnfXjqw6zcBY40NCxmm8ey6DUaQkgvLXPIYnesBEL
         UUfbP8gv/yVvEyBij/bRHX3ejd96LVCEv79BVUyBaTKGlaP4EL8eAHlEtuk9DHgIlTGu
         DzEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710893746; x=1711498546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i9kVuQFqGWveMSm1GQ8GItZlMlvWOz6Hx+yWjI9J9D0=;
        b=BDgPzy/AeyHg6J06sDe1YVX8oI4omEBxPnrBgOIYmpkpqR8xzFaMOrdxRFg95FJW8P
         zAglyb10Qo3X64tbU/ASSgbw5NEPpZq2bH3K/Sy85YD3fBjyBat1bqO8xmQoD4BrYBUB
         EIjRq+lWdRlzdpaKOml0sLTwEknBq/MeYzKx3ybz11tT4dRJd0ddLPA73DT1tBrmxtSb
         xGf8837ODpWaW2LfnUVFPDVNvc3YGOefTsXUVGtAbJV3RabJNwAcMatdGZF8Y9ACWCWk
         9T9Kkj5icNuDku5sK5echR0ESTeB8KLknPK733YXHdebvn1DqL/qZhm2ZYhvLxjL35EG
         dIog==
X-Gm-Message-State: AOJu0YyrsoIPCN81gIOGCVvPBuTfLPL/+ajkmv0xRZNhUrNdoV/1Hr7w
	453E4BSu+ZDDae03q6SpWZ8QJgMEJtqCcRDKolCDcdjp5eu9jQsUZDDMq4An9h1xz7yKBop6H38
	VFg==
X-Google-Smtp-Source: AGHT+IF0fWCYk6aKjKkWi7E/zeckbR9RpV3kVXyudQGGVegRGO/dQ5GmRozoHp9hQmE7pRVxq/v7aqYk34A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1507:b0:dcd:ad52:6932 with SMTP id
 q7-20020a056902150700b00dcdad526932mr4330305ybu.5.1710893746735; Tue, 19 Mar
 2024 17:15:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 19 Mar 2024 17:15:40 -0700
In-Reply-To: <20240320001542.3203871-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240320001542.3203871-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240320001542.3203871-2-seanjc@google.com>
Subject: [PATCH 1/3] KVM: Add helpers to consolidate gfn_to_pfn_cache's page
 split check
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, syzbot+106a4f72b0474e1d1b33@syzkaller.appspotmail.com, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Content-Type: text/plain; charset="UTF-8"

Add a helper to check that the incoming length for a gfn_to_pfn_cache is
valid with respect to the cache's GPA and/or HVA.  To avoid activating a
cache with a bogus GPA, a future fix will fork the page split check in
the inner refresh path into activate() and the public rerfresh() APIs, at
which point KVM will check the length in three separate places.

Deliberately keep the "page offset" logic open coded, as the only other
path that consumes the offset, __kvm_gpc_refresh(), already needs to
differentiate between GPA-based and HVA-based caches, and it's not obvious
that using a helper is a net positive in overall code readability.

Note, for GPA-based caches, this has a subtle side effect of using the GPA
instead of the resolved HVA in the check() path, but that should be a nop
as the HVA offset is derived from the GPA, i.e. the two offsets are
identical, barring a KVM bug.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/pfncache.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 4e07112a24c2..8f2121b5f2a0 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -57,6 +57,19 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 	spin_unlock(&kvm->gpc_lock);
 }
 
+static bool kvm_gpc_is_valid_len(gpa_t gpa, unsigned long uhva,
+				 unsigned long len)
+{
+	unsigned long offset = kvm_is_error_gpa(gpa) ? offset_in_page(uhva) :
+						       offset_in_page(gpa);
+
+	/*
+	 * The cached access must fit within a single page. The 'len' argument
+	 * to activate() and refresh() exists only to enforce that.
+	 */
+	return offset + len <= PAGE_SIZE;
+}
+
 bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsigned long len)
 {
 	struct kvm_memslots *slots = kvm_memslots(gpc->kvm);
@@ -74,7 +87,7 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsigned long len)
 	if (kvm_is_error_hva(gpc->uhva))
 		return false;
 
-	if (offset_in_page(gpc->uhva) + len > PAGE_SIZE)
+	if (!kvm_gpc_is_valid_len(gpc->gpa, gpc->uhva, len))
 		return false;
 
 	if (!gpc->valid)
@@ -247,13 +260,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 	if (WARN_ON_ONCE(kvm_is_error_gpa(gpa) == kvm_is_error_hva(uhva)))
 		return -EINVAL;
 
-	/*
-	 * The cached acces must fit within a single page. The 'len' argument
-	 * exists only to enforce that.
-	 */
-	page_offset = kvm_is_error_gpa(gpa) ? offset_in_page(uhva) :
-					      offset_in_page(gpa);
-	if (page_offset + len > PAGE_SIZE)
+	if (!kvm_gpc_is_valid_len(gpa, uhva, len))
 		return -EINVAL;
 
 	lockdep_assert_held(&gpc->refresh_lock);
@@ -270,6 +277,8 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 	old_uhva = PAGE_ALIGN_DOWN(gpc->uhva);
 
 	if (kvm_is_error_gpa(gpa)) {
+		page_offset = offset_in_page(uhva);
+
 		gpc->gpa = INVALID_GPA;
 		gpc->memslot = NULL;
 		gpc->uhva = PAGE_ALIGN_DOWN(uhva);
@@ -279,6 +288,8 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 	} else {
 		struct kvm_memslots *slots = kvm_memslots(gpc->kvm);
 
+		page_offset = offset_in_page(gpa);
+
 		if (gpc->gpa != gpa || gpc->generation != slots->generation ||
 		    kvm_is_error_hva(gpc->uhva)) {
 			gfn_t gfn = gpa_to_gfn(gpa);
-- 
2.44.0.291.gc1ea87d7ee-goog


