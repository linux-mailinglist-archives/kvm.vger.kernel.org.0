Return-Path: <kvm+bounces-24115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C732995168D
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 10:23:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECB291C2260D
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 08:23:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFFB713D8A0;
	Wed, 14 Aug 2024 08:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vv5ruUpW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8611422D8;
	Wed, 14 Aug 2024 08:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723623802; cv=none; b=ACwkk5okc5XbnDeHhSo+X5eKtYzLU6537wE3l7GXqXUPVneWBVppEbUye+BNE2+S2JF2GoO3T/5cafPwdLLAmEAUriNuwdpbsMzHsmZ3qytfsPh/+MJHVxgHbLpsl3qmgK5z93EFWpX3Im16dK8JpebBfjDaQHyfwy5fr3TfafU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723623802; c=relaxed/simple;
	bh=NYHmjSqazGNuLI4Cs5jcHxD7p9Fxj0pw/IkTnpgLrzI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rzvgAmCjWXTZ3IBE69D/5OJxl+z3shcYhm6pRBNdJ0qmLg7/1+3emw4bGs4+AGZbOeUALi6hlDN3xGm8RQ9Tk5DD0ImLijmKhrsBjvBta3+o2Ve8mbn80LktCho2k2DpMGEKuGhYh7n6bKNPL1lgWw2GmJQaM9wXuTiZ22nQg8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vv5ruUpW; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1fd70ba6a15so49258565ad.0;
        Wed, 14 Aug 2024 01:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723623800; x=1724228600; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2E37MCKNPZ2bWp0dIw8H8o+KwPbuvWT693efHvCJKdA=;
        b=Vv5ruUpWrSAQSgx6PdubgHCrcHim26GOIByBwogVd+24PPVUpnsTwjDcPPi8Orau2O
         yvardAQXWA+bBXarqqSuLCI4Oz+r0K2V8Ilc+kk5mZ22PKR3yGosWstBCStJJFQVKU/z
         IK8W2LakBksqf91Iah61C8h/oqwWpPQpvN3h3yGm6DaylA7fCeLLwP2zBg6EJJWTlqmA
         xnDW6YtnVaQ51YqEiZx8zHhN68WdkhDGN5e+PN0hYum7TjTCW0/sUbs+/59UWXxZBbxY
         bXyw0oGo/2u3AtWSvFOueQrQ8wFIBrWu/WpIyz1WSq5kLZZfhHltRf9mpn8Vzn68V0ud
         tnKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723623800; x=1724228600;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2E37MCKNPZ2bWp0dIw8H8o+KwPbuvWT693efHvCJKdA=;
        b=bPQkW2bRyDza9cZTV5NaGErWmkPGHYLjpDEa7+LVQD32fkl6ILpogDjav0tAnQ40UV
         PVbutjmJVFp8jca9M6Oq3b3ZvukTLFypXysb2qwhcaf5gzC/6UTRX7miKS522/IApwvN
         p9ub/j9+m2u1FjJR9BKXjhGOACHKEtDsmuTU0p1mh4Ion/xrIr3XTL/q8ADu5V8mumxI
         iMMuXR4wzoFzUke5snL5yZMmfE2fXxB/ro3GmeGdA+Ft7w49ZErxGcEawC7MNr5acpSc
         lwLIzZZOUHt9O8/D1nDi74fEmAwXYiDcbkBRsq4QY+YIsnH1kyMRPctg23w9fesHFxNu
         q2xA==
X-Forwarded-Encrypted: i=1; AJvYcCVh4KSwfUV1PNfc/h+CsdlVBUgimq2vbHO/wHOr/wtN7b5mCFGGzqr7+IdUwb4KqH35sVHwKyZYOrQLtUWM5PfJhOktk80eY9uj6F2Q
X-Gm-Message-State: AOJu0YzdMHlvMbeWFofqszqj29GsAWTSkVkb73b5pRXhyRh4AKtD/MuQ
	XHr9nord2o36aOdSdF0hnATpNhOoXqdNQQIjKvH0asj4/r5k8QMb
X-Google-Smtp-Source: AGHT+IFDp2vGElIG9u6RMPsszR0k4EpXAMEZW3XIeYTHMt4oiXBedAjxzLmtk80QD+ANtpttu8Uwnw==
X-Received: by 2002:a17:902:d2c4:b0:1fb:7b96:8467 with SMTP id d9443c01a7336-201d651f85emr20610505ad.63.1723623799666;
        Wed, 14 Aug 2024 01:23:19 -0700 (PDT)
Received: from localhost.localdomain ([111.196.36.229])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-201cd1ba209sm24933595ad.228.2024.08.14.01.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 01:23:18 -0700 (PDT)
From: Liang Chen <liangchen.linux@gmail.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liangchen.linux@gmail.com
Subject: [PATCH] KVM: x86/mmu: Register MMU shrinker only when necessary
Date: Wed, 14 Aug 2024 16:23:02 +0800
Message-Id: <20240814082302.50032-1-liangchen.linux@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The shrinker is allocated with TDP MMU, which is meaningless except for
nested VMs, and 'count_objects' is also called each time the reclaim
path tries to shrink slab caches. Let's allocate the shrinker only when
necessary.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
---
 arch/x86/kvm/mmu/mmu.c | 49 ++++++++++++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 928cf84778b0..d43d7548d801 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -69,11 +69,17 @@ static uint __read_mostly nx_huge_pages_recovery_ratio = 0;
 #else
 static uint __read_mostly nx_huge_pages_recovery_ratio = 60;
 #endif
+static struct shrinker *mmu_shrinker;
 
 static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp);
 static int set_nx_huge_pages(const char *val, const struct kernel_param *kp);
 static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel_param *kp);
 
+static unsigned long mmu_shrink_count(struct shrinker *shrink,
+				      struct shrink_control *sc);
+static unsigned long mmu_shrink_scan(struct shrinker *shrink,
+				     struct shrink_control *sc);
+
 static const struct kernel_param_ops nx_huge_pages_ops = {
 	.set = set_nx_huge_pages,
 	.get = get_nx_huge_pages,
@@ -5666,6 +5672,28 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu,
 	reset_guest_paging_metadata(vcpu, g_context);
 }
 
+static void kvm_mmu_shrinker_init(void)
+{
+	struct shrinker *shrinker = shrinker_alloc(0, "x86-mmu");
+
+	if (!shrinker) {
+		pr_warn_once("could not allocate shrinker\n");
+		return;
+	}
+
+	/* Ensure mmu_shrinker is assigned only once. */
+	if (cmpxchg(&mmu_shrinker, NULL, shrinker)) {
+		shrinker_free(shrinker);
+		return;
+	}
+
+	mmu_shrinker->count_objects = mmu_shrink_count;
+	mmu_shrinker->scan_objects = mmu_shrink_scan;
+	mmu_shrinker->seeks = DEFAULT_SEEKS * 10;
+
+	shrinker_register(mmu_shrinker);
+}
+
 void kvm_init_mmu(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
@@ -5677,6 +5705,13 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu)
 		init_kvm_tdp_mmu(vcpu, cpu_role);
 	else
 		init_kvm_softmmu(vcpu, cpu_role);
+
+	/*
+	 * Register MMU shrinker only if TDP MMU is disabled or
+	 * in nested VM scenarios.
+	 */
+	if (unlikely(!mmu_shrinker) && (!tdp_mmu_enabled || mmu_is_nested(vcpu)))
+		kvm_mmu_shrinker_init();
 }
 EXPORT_SYMBOL_GPL(kvm_init_mmu);
 
@@ -7092,8 +7127,6 @@ static unsigned long mmu_shrink_count(struct shrinker *shrink,
 	return percpu_counter_read_positive(&kvm_total_used_mmu_pages);
 }
 
-static struct shrinker *mmu_shrinker;
-
 static void mmu_destroy_caches(void)
 {
 	kmem_cache_destroy(pte_list_desc_cache);
@@ -7223,20 +7256,8 @@ int kvm_mmu_vendor_module_init(void)
 	if (percpu_counter_init(&kvm_total_used_mmu_pages, 0, GFP_KERNEL))
 		goto out;
 
-	mmu_shrinker = shrinker_alloc(0, "x86-mmu");
-	if (!mmu_shrinker)
-		goto out_shrinker;
-
-	mmu_shrinker->count_objects = mmu_shrink_count;
-	mmu_shrinker->scan_objects = mmu_shrink_scan;
-	mmu_shrinker->seeks = DEFAULT_SEEKS * 10;
-
-	shrinker_register(mmu_shrinker);
-
 	return 0;
 
-out_shrinker:
-	percpu_counter_destroy(&kvm_total_used_mmu_pages);
 out:
 	mmu_destroy_caches();
 	return ret;
-- 
2.40.1


