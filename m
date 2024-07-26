Return-Path: <kvm+bounces-22389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DCAB93DB97
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:02:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 510511C204FB
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA8D817DE1B;
	Fri, 26 Jul 2024 23:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="evPNA4QG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25ADD17D88F
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038013; cv=none; b=CAlQOJveDucwdeh1Npa8YNBsGVnWDebhBYALGfY7JpTX81mty8ERqUuSvNVpfJCK5IPGZapDeXseXGQakVGpOvu84357Z2dB469Ama4YwehLJRhB9SDKcmLj9smcdlxwu8++oesBM2aEnEVd80hyXOOmywBPCny84kZi3lz6prE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038013; c=relaxed/simple;
	bh=28S7/fmm9eTt7XEt9AeUCWuLsWPEg2sRA2JAT+HddFY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uSSQVF8e75E2Ft/sKyB7s1wzahxwL9YhY1UFdOkLdIAhedEGXD7ZQEcsu+u7iHpQ7RJvj/Qb3lpnhh4wSU4BBzcE2d+PwvBTAzMya2bgLK1YzgE2+R+FSWZ6iJfquvDj/tz8PNuukZzlX1+0q/yndpMXRDVy1V3iQH+0z9Sg2hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=evPNA4QG; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2cd72aa5328so1511969a91.2
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038011; x=1722642811; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=R2I4/1amdIANY6ZAXPe7SG9ch9BlLbSqRy3xqYz3ZKo=;
        b=evPNA4QG6jQ6i9b1z8dl8VtwP1xofFtqtzRLrKTt7sSJnjyxEbsEehEqd3QxrBb+2k
         cLw1gv4Oung8sLYbYTOTkvIR2O6NOBnupNW/Ghb2wIUm/WyRZdDGVFjKZisRaJgqOnyN
         DUYb5gUjyk+SXtu9xhgGITudefIW0ZDix0nJ9gIIRE3wlDvhHAKxScSJqAbUKzxKxHx9
         aGiqhCHNewdBAbBw2udgkdVe10FaYZCXLXN77v00E3xNw8FiAKwlVG6PIU4KPW6m+xQD
         lsO9M6H7+apwPFYn1GqXkQ4vK9tO/ThgLPPan4qLaOblfpac20SbSH2Gz9NKMrnwY7jP
         5EFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038011; x=1722642811;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R2I4/1amdIANY6ZAXPe7SG9ch9BlLbSqRy3xqYz3ZKo=;
        b=bw7v4JV/NsLdh8OGKDYwzxLPAMEKEuuA+euuduM9NlNwqMjx7rUaa+uEbcTSp2+FEd
         32DOCtp3CZ4ZKYGMvB57IxniN26Yljs6vzgBTF8UYjkwydcphsLoW/u57mimXJ6WdKNT
         iW5SwSQXaovgf8q7oLyrY3mSCvb4T9GLinZpYK7RlzjwY7kO1Ar634Syo2B1a/A6vXGa
         k3ZRGDbSyavsca5k2aglc2Lqla2JVAM4jO1ZJErPBhaygtPzQUSfAWh85t0EJQ0K/R5M
         9dhGqEqmas0AUPifshUq1dMYnYqdiRGvtFT8qRTgJ4deRC07UacvQaNfWyuouGQ7TW/G
         Cvgw==
X-Gm-Message-State: AOJu0Ywb3U/PqHhEViA2duX8NUZVM88j9uKiIGQXOx6QoFg19lwbngOi
	8oOW5OSLf4dQYcYYy7D6vd/My1Wp0POmqy0myZrTeGvCbj9QAOEC+HgbKbUOxWQQswYHDYhEwiY
	wJQ==
X-Google-Smtp-Source: AGHT+IHKOaCbBS38DB3+XV8s1t7JOWc+aANKzUQK49zxzSlWFwYOsfXU8rtGTN4QUDwCdEEeB4LXs+kD0Xc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:890d:b0:2c8:637:7390 with SMTP id
 98e67ed59e1d1-2cf7e97d380mr2244a91.6.1722038011380; Fri, 26 Jul 2024 16:53:31
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:35 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-27-seanjc@google.com>
Subject: [PATCH v12 26/84] KVM: Move kvm_{set,release}_page_{clean,dirty}()
 helpers up in kvm_main.c
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

Hoist the kvm_{set,release}_page_{clean,dirty}() APIs further up in
kvm_main.c so that they can be used by the kvm_follow_pfn family of APIs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 82 ++++++++++++++++++++++-----------------------
 1 file changed, 41 insertions(+), 41 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 31570c5627e3..48b626f1b5f3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2748,6 +2748,47 @@ unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, bool *w
 	return gfn_to_hva_memslot_prot(slot, gfn, writable);
 }
 
+static bool kvm_is_ad_tracked_page(struct page *page)
+{
+	/*
+	 * Per page-flags.h, pages tagged PG_reserved "should in general not be
+	 * touched (e.g. set dirty) except by its owner".
+	 */
+	return !PageReserved(page);
+}
+
+static void kvm_set_page_dirty(struct page *page)
+{
+	if (kvm_is_ad_tracked_page(page))
+		SetPageDirty(page);
+}
+
+static void kvm_set_page_accessed(struct page *page)
+{
+	if (kvm_is_ad_tracked_page(page))
+		mark_page_accessed(page);
+}
+
+void kvm_release_page_clean(struct page *page)
+{
+	if (!page)
+		return;
+
+	kvm_set_page_accessed(page);
+	put_page(page);
+}
+EXPORT_SYMBOL_GPL(kvm_release_page_clean);
+
+void kvm_release_page_dirty(struct page *page)
+{
+	if (!page)
+		return;
+
+	kvm_set_page_dirty(page);
+	kvm_release_page_clean(page);
+}
+EXPORT_SYMBOL_GPL(kvm_release_page_dirty);
+
 static inline int check_user_page_hwpoison(unsigned long addr)
 {
 	int rc, flags = FOLL_HWPOISON | FOLL_WRITE;
@@ -3125,37 +3166,6 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
 
-static bool kvm_is_ad_tracked_page(struct page *page)
-{
-	/*
-	 * Per page-flags.h, pages tagged PG_reserved "should in general not be
-	 * touched (e.g. set dirty) except by its owner".
-	 */
-	return !PageReserved(page);
-}
-
-static void kvm_set_page_dirty(struct page *page)
-{
-	if (kvm_is_ad_tracked_page(page))
-		SetPageDirty(page);
-}
-
-static void kvm_set_page_accessed(struct page *page)
-{
-	if (kvm_is_ad_tracked_page(page))
-		mark_page_accessed(page);
-}
-
-void kvm_release_page_clean(struct page *page)
-{
-	if (!page)
-		return;
-
-	kvm_set_page_accessed(page);
-	put_page(page);
-}
-EXPORT_SYMBOL_GPL(kvm_release_page_clean);
-
 void kvm_release_pfn_clean(kvm_pfn_t pfn)
 {
 	struct page *page;
@@ -3171,16 +3181,6 @@ void kvm_release_pfn_clean(kvm_pfn_t pfn)
 }
 EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);
 
-void kvm_release_page_dirty(struct page *page)
-{
-	if (!page)
-		return;
-
-	kvm_set_page_dirty(page);
-	kvm_release_page_clean(page);
-}
-EXPORT_SYMBOL_GPL(kvm_release_page_dirty);
-
 void kvm_release_pfn_dirty(kvm_pfn_t pfn)
 {
 	struct page *page;
-- 
2.46.0.rc1.232.g9752f9e123-goog


