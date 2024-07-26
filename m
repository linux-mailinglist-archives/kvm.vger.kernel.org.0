Return-Path: <kvm+bounces-22390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BDD6293DB9E
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:02:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 55D89B21C51
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:02:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 973EA154449;
	Fri, 26 Jul 2024 23:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2QyKeXOX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0E817DE0B
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038016; cv=none; b=TQoWD7jDEXHt6RlUeA2y5AHfE87YOyXwXi+Vju1eOP6FQOz9e2J9XNkp29ltJ5GE/8ndJ+O7LXI2lxH7jNyJleLj9ZOls9Hh1wSV+kHTsIo4EN3Fr/WShi6CQnlRqy1jf/qM9TNTncLb7saFoau4CDC7icmC83DZuJIJV4vlBQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038016; c=relaxed/simple;
	bh=fPqYasQ0wmQSuuDUgdf/AR1cBeWS8t9kkwoIJqSn1qM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jjtJYtYpKyST8m7gbHOZq5DKuFndlky1Uipssk9sEctCN0tjneb91SNgqVYadsEQKR9vSWgwHYuxf4me78FpWx8v9A7oKkSqNHxRLRp4hNK7P73Wq3vqg6UyTRZuQiq1buYGVuBm8mk8ktlp/cNcBM0T0/4hzDSSOPRGQ8JN2EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2QyKeXOX; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc47634e3dso10321665ad.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038014; x=1722642814; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=o1vHCUb6CZ680r+o/spGyfXDOmfamym0Nonz9UARGME=;
        b=2QyKeXOXnCh+XHJP9nYUGOKSgpiL6EQDNDgn1ih6ODQHap2B0dFOCTY3PJu39ip54k
         yrgC/K9iJFV0Xr2pKrigk0zzZwbjLwdfQbSTk3sLKKzmtk5Zqgh7QVkwz/rC1KxpLJP7
         zf+byVELC/tX9wdDuGuxjKEbp+ObmqcV+G/idvtIP7VegpAqCKlV8T52QMPgGPHdamwW
         D2DCzKmZq52fJbXUKo706ysQTlPN5vVARbj4PE4+DBGWgX7ROMUlyobwVPztGMkx9iU8
         LhuEOl5AZXpbC1SOHJcI0E4HTsIolNEw9YaKgTfvlWyeHQqTrr/nMhyySXEEEyf6Wu9E
         o3IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038014; x=1722642814;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o1vHCUb6CZ680r+o/spGyfXDOmfamym0Nonz9UARGME=;
        b=KVZqb/KIVX6SPrU77IGhCQKi6j4o9G3q1gGpgPhGyf+zQ9MumJyTT7GwFHXp22JoUc
         xALvgSpQrKzrIQD5PmhwoKNaU6UvElmsZXoEOlW/b2XnBLj3Tit/dYvupnZj0d6wmqrr
         B1jIKOP/CuqCKwodElhFc7YHvQPlfbzaBla/OuS3n4PRnSUMn0t3brZZcQ03T7cfjYWP
         FxWqYZVXrOMS/aIL+1dBPADge9ZjncIkPeAK9N4ZrlAbWkLx91OFR6HouzW8FSYfpoyu
         ED8SlAxiQF95uRYidNmloapACl0XnZQ3TmW/ajWyYyDNv+s+l05MfROoN1dKwH9CIZBW
         RgdA==
X-Gm-Message-State: AOJu0YyDPjJRhvi2EiIqS7OsavAvv5E3fPH5T98/49bZlJVZ+RoZyIL6
	NHHSIhzlMsH2OtuOa9AdiXF/fgTFpkzlILiR91NvjhO+Vr938FLBRYyr2aFqmi2phz7WqPzgxCw
	h2A==
X-Google-Smtp-Source: AGHT+IEBaNygerYKF4xG2tivsYC4I+4KiNqX7pDiMNbM1xexlfLGsv92ykpFMstIuclC7BO9j6NqEQXsK1A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2c5:b0:1f9:b35f:a2b6 with SMTP id
 d9443c01a7336-1ff047dce33mr22915ad.1.1722038013079; Fri, 26 Jul 2024 16:53:33
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:36 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-28-seanjc@google.com>
Subject: [PATCH v12 27/84] KVM: pfncache: Precisely track refcounted pages
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

Track refcounted struct page memory using kvm_follow_pfn.refcounted_page
instead of relying on kvm_release_pfn_clean() to correctly detect that the
pfn is associated with a struct page.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/pfncache.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 067daf9ad6ef..728d2c1b488a 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -159,11 +159,14 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
 	void *new_khva = NULL;
 	unsigned long mmu_seq;
+	struct page *page;
+
 	struct kvm_follow_pfn kfp = {
 		.slot = gpc->memslot,
 		.gfn = gpa_to_gfn(gpc->gpa),
 		.flags = FOLL_WRITE,
 		.hva = gpc->uhva,
+		.refcounted_page = &page,
 	};
 
 	lockdep_assert_held(&gpc->refresh_lock);
@@ -198,7 +201,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 			if (new_khva != old_khva)
 				gpc_unmap(new_pfn, new_khva);
 
-			kvm_release_pfn_clean(new_pfn);
+			kvm_release_page_unused(page);
 
 			cond_resched();
 		}
@@ -218,7 +221,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 			new_khva = gpc_map(new_pfn);
 
 		if (!new_khva) {
-			kvm_release_pfn_clean(new_pfn);
+			kvm_release_page_unused(page);
 			goto out_error;
 		}
 
@@ -236,11 +239,11 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	gpc->khva = new_khva + offset_in_page(gpc->uhva);
 
 	/*
-	 * Put the reference to the _new_ pfn.  The pfn is now tracked by the
+	 * Put the reference to the _new_ page.  The page is now tracked by the
 	 * cache and can be safely migrated, swapped, etc... as the cache will
 	 * invalidate any mappings in response to relevant mmu_notifier events.
 	 */
-	kvm_release_pfn_clean(new_pfn);
+	kvm_release_page_clean(page);
 
 	return 0;
 
-- 
2.46.0.rc1.232.g9752f9e123-goog


