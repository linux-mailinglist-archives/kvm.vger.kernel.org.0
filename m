Return-Path: <kvm+bounces-28504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 86BDD999093
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:34:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2DD4287D43
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0D4F1FAC29;
	Thu, 10 Oct 2024 18:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lFnqB2HJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F261F9AB0
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584752; cv=none; b=UuSxXyZNZNeKKmtepk8HAZ5e3QF1HH58nBL5zFqd8EFhcFUepevLWeFd60UkPr117s1WyuPRywICvC58wBdLfOkORhJC9Abt4AExSXKptWLKTOihXKbknzVNnH0Y8R6EIQ0NxSCDgSQnbck/YlWHLTpUBLChsrGTFwKDT/bV/ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584752; c=relaxed/simple;
	bh=5U+Xe396ie07CWKh5LcgsN1ZYAsnCq4iDqWBxnyRpWQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sssgNPwZhxP072SNuNUJutTkTzH/HZwX8IGfMsRnTPFXnYuYNep6ir56FtQQD2R2rBwfJHf4Xx8+YU7RxUIHpCJxGpC7/57EKaLlSCq2k50Zk+DLyjm/ZPK/G3BpxVNE3HthakeX8EN08G6oL0crbP1yYFx6a4Plj/sYpjGj03U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lFnqB2HJ; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71e00a395b1so1476160b3a.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584749; x=1729189549; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=txhtY6exXDaGFQAWYGvmt09bjeoYz319F03IR2k/C3M=;
        b=lFnqB2HJNeC6aFRXmR03XZEiiImTYVHbWU/GkqwSXJ1GV6qh+onF9ea8pHau54nnJI
         JYMZo2Bdtnz9StiMiAh+3XeXwXPsCsBo4ISZ0LWerbxkuqPYHmQr81UeEuHQk2phaVBp
         K3Id19I5VP8U2GRXqNwXNPzdSdh7wcepp8PkASs/yhBCM17kjsTnGy8UkCWFYvjGO+kp
         nSgfjfAQrxTaWsofKYmr1+Cp2YVqzRjb56ONlO5cVt9OP7ILypd5IJCunw89Zzld0TPK
         EwYre895aXW+Dy/WBtL1VNQxnolmV9TTXJPy5ansjxuuDOLiuEvSknJMQiId1fkNjfnI
         McUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584749; x=1729189549;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=txhtY6exXDaGFQAWYGvmt09bjeoYz319F03IR2k/C3M=;
        b=I/Ej1oUiMwPcfb+qQinR9LiDjzkv5UWVi7YusF0CoDa0DBniy+bwC5hIKZoltHcE6G
         W0ASEIktiy1o5f6bxYTbkR2oGyUsv23rNfbGmhh4zCrcnZfjlkKPtwwiMQtstPS3pxAZ
         davK7SLsw5b3lt65xiHJUuC6UHJFnJLrMA9qLf6z6B8GirMDqupMpr/tZoVZY5je62vB
         ML6bIySYthiO3wX6shAZFWDczwMyLmweCDsQOAXdNrFwjUk6wWickYGya7QJmqEg72uL
         06So/Uu5obgtQU25W18T0G7T5f8dH7O61i4d4eE0Z4j/F21UFs74MJB3m5IWG24bz7X/
         mLkw==
X-Gm-Message-State: AOJu0Yxb+TgKR2S4Fw1W9OJOMVNJxKtq//W21W1yCc8Jorskbhj2gx8U
	ZNh1oEmZLfOH6OzrCY9uWjoHiu5MnU8kjA7D/50dTvW03CVCm97uEnuP5kZQ9ZeTQ812KVyU384
	DzQ==
X-Google-Smtp-Source: AGHT+IE/uLa8aldzd4vJMnq+De69DiThAuVt+3q8zF6rqxlBj2/ZKo7+FHCoJyy45GpCD4mZjJfGV3U05Tk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d8a:b0:71d:f1f9:b982 with SMTP id
 d2e1a72fcca58-71e1dc00b9cmr38199b3a.6.1728584749206; Thu, 10 Oct 2024
 11:25:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:29 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-28-seanjc@google.com>
Subject: [PATCH v13 27/85] KVM: Provide refcounted page as output field in
 struct kvm_follow_pfn
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

Add kvm_follow_pfn.refcounted_page as an output for the "to pfn" APIs to
"return" the struct page that is associated with the returned pfn (if KVM
acquired a reference to the page).  This will eventually allow removing
KVM's hacky kvm_pfn_to_refcounted_page() code, which is error prone and
can't detect pfns that are valid, but aren't (currently) refcounted.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 99 +++++++++++++++++++++------------------------
 virt/kvm/kvm_mm.h   |  9 +++++
 2 files changed, 56 insertions(+), 52 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d3e48fcc4fb0..e29f78ed6f48 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2746,6 +2746,46 @@ unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vc=
pu *vcpu, gfn_t gfn, bool *w
 	return gfn_to_hva_memslot_prot(slot, gfn, writable);
 }
=20
+static kvm_pfn_t kvm_resolve_pfn(struct kvm_follow_pfn *kfp, struct page *=
page,
+				 struct follow_pfnmap_args *map, bool writable)
+{
+	kvm_pfn_t pfn;
+
+	WARN_ON_ONCE(!!page =3D=3D !!map);
+
+	if (kfp->map_writable)
+		*kfp->map_writable =3D writable;
+
+	/*
+	 * FIXME: Remove this once KVM no longer blindly calls put_page() on
+	 *	  every pfn that points at a struct page.
+	 *
+	 * Get a reference for follow_pte() pfns if they happen to point at a
+	 * struct page, as KVM will ultimately call kvm_release_pfn_clean() on
+	 * the returned pfn, i.e. KVM expects to have a reference.
+	 *
+	 * Certain IO or PFNMAP mappings can be backed with valid struct pages,
+	 * but be allocated without refcounting, e.g. tail pages of
+	 * non-compound higher order allocations.  Grabbing and putting a
+	 * reference to such pages would cause KVM to prematurely free a page
+	 * it doesn't own (KVM gets and puts the one and only reference).
+	 * Don't allow those pages until the FIXME is resolved.
+	 */
+	if (map) {
+		pfn =3D map->pfn;
+		page =3D kvm_pfn_to_refcounted_page(pfn);
+		if (page && !get_page_unless_zero(page))
+			return KVM_PFN_ERR_FAULT;
+	} else {
+		pfn =3D page_to_pfn(page);
+	}
+
+	if (kfp->refcounted_page)
+		*kfp->refcounted_page =3D page;
+
+	return pfn;
+}
+
 /*
  * The fast path to get the writable pfn which will be stored in @pfn,
  * true indicates success, otherwise false is returned.
@@ -2763,9 +2803,7 @@ static bool hva_to_pfn_fast(struct kvm_follow_pfn *kf=
p, kvm_pfn_t *pfn)
 		return false;
=20
 	if (get_user_page_fast_only(kfp->hva, FOLL_WRITE, &page)) {
-		*pfn =3D page_to_pfn(page);
-		if (kfp->map_writable)
-			*kfp->map_writable =3D true;
+		*pfn =3D kvm_resolve_pfn(kfp, page, NULL, true);
 		return true;
 	}
=20
@@ -2797,23 +2835,15 @@ static int hva_to_pfn_slow(struct kvm_follow_pfn *k=
fp, kvm_pfn_t *pfn)
 	if (npages !=3D 1)
 		return npages;
=20
-	if (!kfp->map_writable)
-		goto out;
-
-	if (kfp->flags & FOLL_WRITE) {
-		*kfp->map_writable =3D true;
-		goto out;
-	}
-
 	/* map read fault as writable if possible */
-	if (get_user_page_fast_only(kfp->hva, FOLL_WRITE, &wpage)) {
-		*kfp->map_writable =3D true;
+	if (!(flags & FOLL_WRITE) && kfp->map_writable &&
+	    get_user_page_fast_only(kfp->hva, FOLL_WRITE, &wpage)) {
 		put_page(page);
 		page =3D wpage;
+		flags |=3D FOLL_WRITE;
 	}
=20
-out:
-	*pfn =3D page_to_pfn(page);
+	*pfn =3D kvm_resolve_pfn(kfp, page, NULL, flags & FOLL_WRITE);
 	return npages;
 }
=20
@@ -2828,22 +2858,11 @@ static bool vma_is_valid(struct vm_area_struct *vma=
, bool write_fault)
 	return true;
 }
=20
-static int kvm_try_get_pfn(kvm_pfn_t pfn)
-{
-	struct page *page =3D kvm_pfn_to_refcounted_page(pfn);
-
-	if (!page)
-		return 1;
-
-	return get_page_unless_zero(page);
-}
-
 static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 			       struct kvm_follow_pfn *kfp, kvm_pfn_t *p_pfn)
 {
 	struct follow_pfnmap_args args =3D { .vma =3D vma, .address =3D kfp->hva =
};
 	bool write_fault =3D kfp->flags & FOLL_WRITE;
-	kvm_pfn_t pfn;
 	int r;
=20
 	r =3D follow_pfnmap_start(&args);
@@ -2867,37 +2886,13 @@ static int hva_to_pfn_remapped(struct vm_area_struc=
t *vma,
 	}
=20
 	if (write_fault && !args.writable) {
-		pfn =3D KVM_PFN_ERR_RO_FAULT;
+		*p_pfn =3D KVM_PFN_ERR_RO_FAULT;
 		goto out;
 	}
=20
-	if (kfp->map_writable)
-		*kfp->map_writable =3D args.writable;
-	pfn =3D args.pfn;
-
-	/*
-	 * Get a reference here because callers of *hva_to_pfn* and
-	 * *gfn_to_pfn* ultimately call kvm_release_pfn_clean on the
-	 * returned pfn.  This is only needed if the VMA has VM_MIXEDMAP
-	 * set, but the kvm_try_get_pfn/kvm_release_pfn_clean pair will
-	 * simply do nothing for reserved pfns.
-	 *
-	 * Whoever called remap_pfn_range is also going to call e.g.
-	 * unmap_mapping_range before the underlying pages are freed,
-	 * causing a call to our MMU notifier.
-	 *
-	 * Certain IO or PFNMAP mappings can be backed with valid
-	 * struct pages, but be allocated without refcounting e.g.,
-	 * tail pages of non-compound higher order allocations, which
-	 * would then underflow the refcount when the caller does the
-	 * required put_page. Don't allow those pages here.
-	 */
-	if (!kvm_try_get_pfn(pfn))
-		r =3D -EFAULT;
+	*p_pfn =3D kvm_resolve_pfn(kfp, NULL, &args, args.writable);
 out:
 	follow_pfnmap_end(&args);
-	*p_pfn =3D pfn;
-
 	return r;
 }
=20
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index d5a215958f06..d3ac1ba8ba66 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -35,6 +35,15 @@ struct kvm_follow_pfn {
 	 * Set to true if a writable mapping was obtained.
 	 */
 	bool *map_writable;
+
+	/*
+	 * Optional output.  Set to a valid "struct page" if the returned pfn
+	 * is for a refcounted or pinned struct page, NULL if the returned pfn
+	 * has no struct page or if the struct page is not being refcounted
+	 * (e.g. tail pages of non-compound higher order allocations from
+	 * IO/PFNMAP mappings).
+	 */
+	struct page **refcounted_page;
 };
=20
 kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *kfp);
--=20
2.47.0.rc1.288.g06298d1525-goog


