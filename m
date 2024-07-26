Return-Path: <kvm+bounces-22392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AE9193DBA4
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:03:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD9031C20835
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 094CA17E914;
	Fri, 26 Jul 2024 23:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zjHlT+Pi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4906717E47D
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038020; cv=none; b=oxQ28BdBJJjEJp1BxIKpTzrdSUYIbjL6AyGS4/+ZEGjuZExxJgf9JfUBIH33YZmj0kamvSlPVPbRusl+zWMLciQpnbt7ju7CgvLOwIPdQbYMvC1CdHPeHMeeDuLeM2HKVna1W2o6g9OPOCZnCS9fZhbJaNw97AGKsqacNgsUddw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038020; c=relaxed/simple;
	bh=4wtI3HrZftg8TSroI/LySwRU47K0urA1mYWFvNIe4WQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SUMQQEb1hqXxKBPRhvd/VTHUxvLvqvcIXp8Z7uUF3WRRr5RC7dxKYGdXedMTnwv1BJeNth/7kqMZTfFeRtujMVuhbgjuN+pEIh7a72b3HnIl6sQHSgGgUkop10TpzOwYdAqSD8kDfVR+5UOgBpMRS5iufjz874S12wW5ho76Dys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zjHlT+Pi; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70d1a9bad5dso1374026b3a.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038018; x=1722642818; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hlhq7We3LF/Ul7sqre1CZocM6x6KNUXlB6LyC83BMPc=;
        b=zjHlT+PiSk/ewkQKfyBiToa5r0MpkfLqGDNhDBXPJm+g7d4w1IsweBYssSUpPz1PUO
         nrvMfJio5ylilB+m1gQG8Jt+7cBeIcyeWslZa65P7tKknddIT31UnEYaMSnKL2u5sApG
         E/n7ybgopYkqzYzUb/vJNKECyzsXnDVzWyub3OL5vPnR+2pdFAJUJCjeQijSsFB8JHiW
         svFC9Cud5FcMPj4UGsmtJVvQiCwvJZi2r91YW1YxR5c/gRWgimWYR7YLSv9rRB8EpJA/
         t65QsrD80LKcVv5JBD13QVL/Q6RrX+Lq/NnuLv/Io6ZcbOhqJzINMIbLpeOlYCrLH8uV
         AFcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038018; x=1722642818;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hlhq7We3LF/Ul7sqre1CZocM6x6KNUXlB6LyC83BMPc=;
        b=MdDeJpbVmTfoAB2Ie4I3jdXr3X3EXggrwA61AvpkcLD+Ip47+iCWGKptgNsplKoGpo
         HFBMZFNAAi34U6BWdMzE3Aw40F2FQlV2zGxWy03SLaLrjUujwMHIFZUk+sl+9RvY4P3V
         IJ/9ZVSa71Y0Ukzo4pBwB1kSXtSzrT6fhD50HTJ9cDR3uJ8sB1O2WoCFAK7J1VJ8XALA
         XDPSRisFYAUbffVXVmKmwkrECx4uidM2RgA+nTHC7o8Txjrs+6FgCcM/J4zgmgHu2sdt
         BUAislAzH67nI+8sKo5VqQsY4ndATeEFx4zf9nt34KL2gX6boNiJRI2j1rAVRtH5n7R7
         /50A==
X-Gm-Message-State: AOJu0YzMdi6Kc+DsF4Vvpv+5y6MeukdHucP/jEmDLnbCWaD87UebkKf/
	+Tui9SAlQg72CNIFPjtaKiSZPJpQun7pVlDRcO13yfMVIs2eLSOJ2EUbaJdGmOSM8mEIdxfxWMR
	3hQ==
X-Google-Smtp-Source: AGHT+IHh1dyWiT0um9sPElrkv3mBIH4IG/eZ2ITHeKZHWjYM95v4ERaP3jgKxmY1KlRL2J6TSkYz8SuqfJg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2f10:b0:70e:9de1:9edf with SMTP id
 d2e1a72fcca58-70ece9fc2c1mr8667b3a.1.1722038017517; Fri, 26 Jul 2024 16:53:37
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:38 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-30-seanjc@google.com>
Subject: [PATCH v12 29/84] KVM: Pin (as in FOLL_PIN) pages during kvm_vcpu_map()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Pin, as in FOLL_PIN, pages when mapping them for direct access by KVM.
As per Documentation/core-api/pin_user_pages.rst, writing to a page that
was gotten via FOLL_GET is explicitly disallowed.

  Correct (uses FOLL_PIN calls):
      pin_user_pages()
      write to the data within the pages
      unpin_user_pages()

  INCORRECT (uses FOLL_GET calls):
      get_user_pages()
      write to the data within the pages
      put_page()

Unfortunately, FOLL_PIN is a "private" flag, and so kvm_follow_pfn must
use a one-off bool instead of being able to piggyback the "flags" field.

Link: https://lwn.net/Articles/930667
Link: https://lore.kernel.org/all/cover.1683044162.git.lstoakes@gmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  2 +-
 virt/kvm/kvm_main.c      | 54 +++++++++++++++++++++++++++++-----------
 virt/kvm/kvm_mm.h        |  7 ++++++
 3 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8b5ac3305b05..3d4094ece479 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -280,7 +280,7 @@ struct kvm_host_map {
 	 * can be used as guest memory but they are not managed by host
 	 * kernel).
 	 */
-	struct page *refcounted_page;
+	struct page *pinned_page;
 	struct page *page;
 	void *hva;
 	kvm_pfn_t pfn;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 255cbed83b40..4a9b99c11355 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2824,9 +2824,12 @@ static kvm_pfn_t kvm_resolve_pfn(struct kvm_follow_pfn *kfp, struct page *page,
 	 */
 	if (pte) {
 		pfn = pte_pfn(*pte);
-		page = kvm_pfn_to_refcounted_page(pfn);
-		if (page && !get_page_unless_zero(page))
-			return KVM_PFN_ERR_FAULT;
+
+		if (!kfp->pin) {
+			page = kvm_pfn_to_refcounted_page(pfn);
+			if (page && !get_page_unless_zero(page))
+				return KVM_PFN_ERR_FAULT;
+		}
 	} else {
 		pfn = page_to_pfn(page);
 	}
@@ -2845,16 +2848,24 @@ static kvm_pfn_t kvm_resolve_pfn(struct kvm_follow_pfn *kfp, struct page *page,
 static bool hva_to_pfn_fast(struct kvm_follow_pfn *kfp, kvm_pfn_t *pfn)
 {
 	struct page *page;
+	bool r;
 
 	/*
-	 * Fast pin a writable pfn only if it is a write fault request
-	 * or the caller allows to map a writable pfn for a read fault
-	 * request.
+	 * Try the fast-only path when the caller wants to pin/get the page for
+	 * writing.  If the caller only wants to read the page, KVM must go
+	 * down the full, slow path in order to avoid racing an operation that
+	 * breaks Copy-on-Write (CoW), e.g. so that KVM doesn't end up pointing
+	 * at the old, read-only page while mm/ points at a new, writable page.
 	 */
 	if (!((kfp->flags & FOLL_WRITE) || kfp->map_writable))
 		return false;
 
-	if (get_user_page_fast_only(kfp->hva, FOLL_WRITE, &page)) {
+	if (kfp->pin)
+		r = pin_user_pages_fast(kfp->hva, 1, FOLL_WRITE, &page) == 1;
+	else
+		r = get_user_page_fast_only(kfp->hva, FOLL_WRITE, &page);
+
+	if (r) {
 		*pfn = kvm_resolve_pfn(kfp, page, NULL, true);
 		return true;
 	}
@@ -2883,10 +2894,21 @@ static int hva_to_pfn_slow(struct kvm_follow_pfn *kfp, kvm_pfn_t *pfn)
 	struct page *page, *wpage;
 	int npages;
 
-	npages = get_user_pages_unlocked(kfp->hva, 1, &page, flags);
+	if (kfp->pin)
+		npages = pin_user_pages_unlocked(kfp->hva, 1, &page, flags);
+	else
+		npages = get_user_pages_unlocked(kfp->hva, 1, &page, flags);
 	if (npages != 1)
 		return npages;
 
+	/*
+	 * Pinning is mutually exclusive with opportunistically mapping a read
+	 * fault as writable, as KVM should never pin pages when mapping memory
+	 * into the guest (pinning is only for direct accesses from KVM).
+	 */
+	if (WARN_ON_ONCE(kfp->map_writable && kfp->pin))
+		goto out;
+
 	/* map read fault as writable if possible */
 	if (!(flags & FOLL_WRITE) && kfp->map_writable &&
 	    get_user_page_fast_only(kfp->hva, FOLL_WRITE, &wpage)) {
@@ -2895,6 +2917,7 @@ static int hva_to_pfn_slow(struct kvm_follow_pfn *kfp, kvm_pfn_t *pfn)
 		flags |= FOLL_WRITE;
 	}
 
+out:
 	*pfn = kvm_resolve_pfn(kfp, page, NULL, flags & FOLL_WRITE);
 	return npages;
 }
@@ -3119,10 +3142,11 @@ int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 		.slot = gfn_to_memslot(vcpu->kvm, gfn),
 		.gfn = gfn,
 		.flags = FOLL_WRITE,
-		.refcounted_page = &map->refcounted_page,
+		.refcounted_page = &map->pinned_page,
+		.pin = true,
 	};
 
-	map->refcounted_page = NULL;
+	map->pinned_page = NULL;
 	map->page = NULL;
 	map->hva = NULL;
 	map->gfn = gfn;
@@ -3159,16 +3183,16 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
 	if (dirty)
 		kvm_vcpu_mark_page_dirty(vcpu, map->gfn);
 
-	if (map->refcounted_page) {
+	if (map->pinned_page) {
 		if (dirty)
-			kvm_release_page_dirty(map->refcounted_page);
-		else
-			kvm_release_page_clean(map->refcounted_page);
+			kvm_set_page_dirty(map->pinned_page);
+		kvm_set_page_accessed(map->pinned_page);
+		unpin_user_page(map->pinned_page);
 	}
 
 	map->hva = NULL;
 	map->page = NULL;
-	map->refcounted_page = NULL;
+	map->pinned_page = NULL;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
 
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index d3ac1ba8ba66..acef3f5c582a 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -30,6 +30,13 @@ struct kvm_follow_pfn {
 	/* FOLL_* flags modifying lookup behavior, e.g. FOLL_WRITE. */
 	unsigned int flags;
 
+	/*
+	 * Pin the page (effectively FOLL_PIN, which is an mm/ internal flag).
+	 * The page *must* be pinned if KVM will write to the page via a kernel
+	 * mapping, e.g. via kmap(), mremap(), etc.
+	 */
+	bool pin;
+
 	/*
 	 * If non-NULL, try to get a writable mapping even for a read fault.
 	 * Set to true if a writable mapping was obtained.
-- 
2.46.0.rc1.232.g9752f9e123-goog


