Return-Path: <kvm+bounces-28508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAF5D9990A2
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:35:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 753302871FD
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1699D1DF72A;
	Thu, 10 Oct 2024 18:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CYNUenPL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B1D1FBC91
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584760; cv=none; b=kKuisbsTimXJ7X6T8peB0HPu2oVSH11o67KlW2yadj5E27BwU8xyJRAx2M6I0LPnRajtSphKfsvaMwPrcQCKFAvRmytJJng9C6T1ZNsA1wO8lM4SpIt1i81gwD7mm0MJfCzswP1WwBDbnc2FK/fy3kxEhktT+QZvrOcLeLHgrf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584760; c=relaxed/simple;
	bh=M2NCneg/Pye+UyLI2GGt5shIez0MQF8LN4Gs0ecBwhw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=og/z64Nk4pl85YEIAvD/o8JenBdtyy9UmElST7tZu4z7yQ/bVjLrQJQTdGnhh694eUlZktVBY0ww65HWRX0VlanUo3vPqGWafHHoYF+6IzgvLPnt8/bDLbsPrflNpkvlp/0bqC8YwOlJG/uWaX4Q2SfYSUF5HwQEhIUsgRWXlAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CYNUenPL; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e290b8b69f8so2137706276.2
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584757; x=1729189557; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dQaiAwtn89tr8uPQzQfay17fvGV3F3WPslUlHA+BgDY=;
        b=CYNUenPLiXIvtTyD74D8imBRAdC50F3hM1AGdNct9/duav3eSxT08JrxuH4uXDnr2p
         GlywDJgMcirPnzaX/MzQmoAche5Jq/wQ+s2jZ8bLV0HN01jab8FA4Xyx+wz08gu7Ei/1
         aMZVlCmv09LzBHl5ILjwWuvSGgp907WUV3teWOwY2a5c3RZBVUymYlPJ+uSMbRo4gDHd
         BCHayDy3tx5zkYmvi0rcCgT1BlZperbNOxiXf9X2CrpcePe1UPYsgemnEtJcHtRrO8rT
         DTQAY2TnyFkSUZshaKMhikHuc//2hbWd69gYZuL5srQsImqM4AupFJHvu+dzaLsC46rc
         9Ypw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584757; x=1729189557;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dQaiAwtn89tr8uPQzQfay17fvGV3F3WPslUlHA+BgDY=;
        b=climkRUKHMTwtKrVoBohpDOqyjuZlPiXyl3SvKNl82YgBZRqO9jQpZolCkq3GkiQW2
         lPZa9CaNjEALGg2UJZ/v+pStikmir7guwrcgk7blZJ8La+G7Qnn5RrBV+W9+wRz1wv5F
         KBlnUfMq9eAOv5mlhkjRLpsK99UmcCUH+ag3LGJQaT+eOHSsdH89G099Gsm8NXv7eBBq
         aCJ1t/XHHfBEnVUWZ8OCmBwyiczANCEFRLokDolj1g+/nDAL+0+2dUjtoD86vpaZDNFJ
         mzyBtUMTpKw/AW+gVokDQIoHcR2aSofDAZHg6qBli82dxVXChBOwTfPeJZHp7BrRbvVw
         m9uQ==
X-Gm-Message-State: AOJu0YxxaaV63d+e9A0d/hkIoRv2zpxPN33HB6IHXv9Sb1U+pqXUuDUt
	mMStjQbHGtuzBrwznHNCt9p9lMCFiygxJCiQ9L+peDFS5di+6pFN1skDhzx9x3IFlFze7Ioa833
	oig==
X-Google-Smtp-Source: AGHT+IHY0yNiFmgeAXsfVKl7EbEBY2R3q1IXvjRBHtSPoxXhe2HbHq4twyB0Huv0R+/OHvP6V1ZW3nZzpzQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:80cb:0:b0:e20:2502:be14 with SMTP id
 3f1490d57ef6-e28fe410672mr4860276.7.1728584757233; Thu, 10 Oct 2024 11:25:57
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:33 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-32-seanjc@google.com>
Subject: [PATCH v13 31/85] KVM: Pin (as in FOLL_PIN) pages during kvm_vcpu_map()
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
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

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
Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  2 +-
 virt/kvm/kvm_main.c      | 54 +++++++++++++++++++++++++++++-----------
 virt/kvm/kvm_mm.h        |  7 ++++++
 3 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 02ab3a657aa6..8739b905d85b 100644
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
index b1c1b7e4f33a..40a59526d466 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2814,9 +2814,12 @@ static kvm_pfn_t kvm_resolve_pfn(struct kvm_follow_p=
fn *kfp, struct page *page,
 	 */
 	if (map) {
 		pfn =3D map->pfn;
-		page =3D kvm_pfn_to_refcounted_page(pfn);
-		if (page && !get_page_unless_zero(page))
-			return KVM_PFN_ERR_FAULT;
+
+		if (!kfp->pin) {
+			page =3D kvm_pfn_to_refcounted_page(pfn);
+			if (page && !get_page_unless_zero(page))
+				return KVM_PFN_ERR_FAULT;
+		}
 	} else {
 		pfn =3D page_to_pfn(page);
 	}
@@ -2834,16 +2837,24 @@ static kvm_pfn_t kvm_resolve_pfn(struct kvm_follow_=
pfn *kfp, struct page *page,
 static bool hva_to_pfn_fast(struct kvm_follow_pfn *kfp, kvm_pfn_t *pfn)
 {
 	struct page *page;
+	bool r;
=20
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
=20
-	if (get_user_page_fast_only(kfp->hva, FOLL_WRITE, &page)) {
+	if (kfp->pin)
+		r =3D pin_user_pages_fast(kfp->hva, 1, FOLL_WRITE, &page) =3D=3D 1;
+	else
+		r =3D get_user_page_fast_only(kfp->hva, FOLL_WRITE, &page);
+
+	if (r) {
 		*pfn =3D kvm_resolve_pfn(kfp, page, NULL, true);
 		return true;
 	}
@@ -2872,10 +2883,21 @@ static int hva_to_pfn_slow(struct kvm_follow_pfn *k=
fp, kvm_pfn_t *pfn)
 	struct page *page, *wpage;
 	int npages;
=20
-	npages =3D get_user_pages_unlocked(kfp->hva, 1, &page, flags);
+	if (kfp->pin)
+		npages =3D pin_user_pages_unlocked(kfp->hva, 1, &page, flags);
+	else
+		npages =3D get_user_pages_unlocked(kfp->hva, 1, &page, flags);
 	if (npages !=3D 1)
 		return npages;
=20
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
@@ -2884,6 +2906,7 @@ static int hva_to_pfn_slow(struct kvm_follow_pfn *kfp=
, kvm_pfn_t *pfn)
 		flags |=3D FOLL_WRITE;
 	}
=20
+out:
 	*pfn =3D kvm_resolve_pfn(kfp, page, NULL, flags & FOLL_WRITE);
 	return npages;
 }
@@ -3099,10 +3122,11 @@ int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, =
struct kvm_host_map *map)
 		.slot =3D gfn_to_memslot(vcpu->kvm, gfn),
 		.gfn =3D gfn,
 		.flags =3D FOLL_WRITE,
-		.refcounted_page =3D &map->refcounted_page,
+		.refcounted_page =3D &map->pinned_page,
+		.pin =3D true,
 	};
=20
-	map->refcounted_page =3D NULL;
+	map->pinned_page =3D NULL;
 	map->page =3D NULL;
 	map->hva =3D NULL;
 	map->gfn =3D gfn;
@@ -3139,16 +3163,16 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct k=
vm_host_map *map, bool dirty)
 	if (dirty)
 		kvm_vcpu_mark_page_dirty(vcpu, map->gfn);
=20
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
=20
 	map->hva =3D NULL;
 	map->page =3D NULL;
-	map->refcounted_page =3D NULL;
+	map->pinned_page =3D NULL;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
=20
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index d3ac1ba8ba66..acef3f5c582a 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -30,6 +30,13 @@ struct kvm_follow_pfn {
 	/* FOLL_* flags modifying lookup behavior, e.g. FOLL_WRITE. */
 	unsigned int flags;
=20
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
--=20
2.47.0.rc1.288.g06298d1525-goog


