Return-Path: <kvm+bounces-19364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 370BD9046BA
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 00:05:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C6ED0B24715
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 22:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F82515532C;
	Tue, 11 Jun 2024 22:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TbYe9r6L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3423F1552E3
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 22:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718143525; cv=none; b=CCySOFwh8cUPgI4pTKKBUMtAi002YiZy+5rpjQ0XG4EHUbGlDpkQaY7rXE41eGUeW3XJ9t/cUMAfXnA2N8e9J1eaXPsAwINGL3+nRvCnaCW7HNwEEaMF09MByttHi6G1xrToTfxN6otXEq+uYUHDipZnWcCxYpDgNCaj18TjSC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718143525; c=relaxed/simple;
	bh=kMarZ5D/P8bfyIYmQRXdOL1MNPG84ZeZ1Mp5KuBlhhA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TDRPfYFmuxszUtZumVEMi+KsUBWG7eTvb00DBKr61CXn9Ca3iVY7kHOVbMJGI1IGcqF0X+BWHGbyCQz+crIJNM9jCv3upTpQp/bd2QDkvnZZ8y4MOSX3SSpZgEPld9WXvlQD89oJwjxCXwzKjA4vrhDA7jEl9XKvu0HyiThaYak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TbYe9r6L; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62a088faef7so3244827b3.0
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 15:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718143523; x=1718748323; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5Siu/KDRE6dW5TN6w90WfnqseJSDZUhC+eUsxP9R36Q=;
        b=TbYe9r6LqYYkfyNNi8tPI0050k6RAgRYMV28+RVXFpForqFwL1hks/ztWpvyvO+gQM
         DWAh/PC4YRJ9cl3PLRqqiX+8HhLg+3Gjy5MBhbAS5LZCfF0iLcGa74Wq53oH6Z7aIkey
         Zk89oik38AdVdFEZncvNVJlc7jpqVDbgyHDLXf1tF7O+UaTidAWkQsuOgFw6P6oGrYst
         UIpC94iiMQ3gdOBj1GFH0uKvLkvbaJwV2HzuxdF5HkHsbgK/+ryuV6UI7oIyi0AETZjp
         uDI33pjFf0pFFrXRHLKc3y1wwlH0JJYjHtZ3mQRpMDcUiqO6/FG8zG0VPy8MkBmjsEKa
         Q+3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718143523; x=1718748323;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5Siu/KDRE6dW5TN6w90WfnqseJSDZUhC+eUsxP9R36Q=;
        b=msgC2xmxT8+h+IpPGUwgFUjDTxyO9yHPZAkY+FlrQpQMD5QFNN8t+8FHZMJoY+ccsw
         tkrp1khr283/WvKn6D0vkx4J4pCaklTOI4FS7gOWvVwhbDnObvJ9Ax9ziMqnitgL0Qw2
         QtoNCELru59xqJRWA/XPFmu0CeENavg8kIfSysT4k2gea7+RR9tbn++FSjhaQwMKXQgq
         +8xSSJy3weGjfLTFe1Hh/poi/Ir85zLBPrMtscc/rziOP+ek+dSDMJeS62hGtruxHbyv
         oJY15RRcrgmT3dP/cRIKxolm9yGqmXOca0txa3IaambeUGMaMKvEC/OYT0+J3TRbaXaJ
         1u0A==
X-Gm-Message-State: AOJu0YyzIVUwP05DRm2sxl1/Nuc5s90eumkVTaDY1s/PDA/hAt7frWDM
	W0w0R8TLjIGj6TyrXUYpPM23CpSHc7GsE5599XAThWadyXy3sdyTSNhtMZabTqrX2Lj/KwOWF+k
	soMdS3SxqCw==
X-Google-Smtp-Source: AGHT+IEeJOGaERGrbjAgR+SjU4vJym2g+HYlDduBmzN0PvflaZq6Mt3HRl6LoKLhf3j1/gUuS/7bx+ndZQN6rw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:690c:fc3:b0:620:32ea:e1d4 with SMTP
 id 00721157ae682-62fa26ff1c1mr566577b3.0.1718143523145; Tue, 11 Jun 2024
 15:05:23 -0700 (PDT)
Date: Tue, 11 Jun 2024 15:05:10 -0700
In-Reply-To: <20240611220512.2426439-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240611220512.2426439-1-dmatlack@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240611220512.2426439-3-dmatlack@google.com>
Subject: [PATCH v4 2/4] KVM: x86/mmu: Hard code GFP flags for TDP MMU eager
 split allocations
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Bibo Mao <maobibo@loongson.cn>
Content-Type: text/plain; charset="UTF-8"

Hard code GFP_KERNEL_ACCOUNT when allocating shadow pages during eager
page splitting in the TDP MMU. Opportunistically replace use of
__GFP_ZERO with allocations that zero to improve readability.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c1f3b3798764..09c6b16630ac 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1339,17 +1339,15 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 	return spte_set;
 }
 
-static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
+static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(void)
 {
 	struct kvm_mmu_page *sp;
 
-	gfp |= __GFP_ZERO;
-
-	sp = kmem_cache_alloc(mmu_page_header_cache, gfp);
+	sp = kmem_cache_zalloc(mmu_page_header_cache, GFP_KERNEL_ACCOUNT);
 	if (!sp)
 		return NULL;
 
-	sp->spt = (void *)__get_free_page(gfp);
+	sp->spt = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!sp->spt) {
 		kmem_cache_free(mmu_page_header_cache, sp);
 		return NULL;
@@ -1374,7 +1372,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 
 	iter->yielded = true;
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT);
+	sp = __tdp_mmu_alloc_sp_for_split();
 
 	if (shared)
 		read_lock(&kvm->mmu_lock);
-- 
2.45.2.505.gda0bf45e8d-goog


