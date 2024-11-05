Return-Path: <kvm+bounces-30775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F4BD9BD534
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:47:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 068B91F2679C
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CDB51EF08D;
	Tue,  5 Nov 2024 18:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ae95Zujj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE281EC015
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 18:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730832228; cv=none; b=XmJ8DS/XhB1lX8ZoDrpOh9YukN+vCykVB5F4vUg1tb2D2sDNb+j777u4vj4w16CitZdRwUKFSwVL7u5wLmbwTHexJnASAvvjVSo/tuFLvZrM/1bCrO7qL25JaiApP8i1RnimACqb2UH8Z7IAUkxTx4FXOhGG54OXAZHTolmpKQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730832228; c=relaxed/simple;
	bh=/iQ+9SFHr3+eSC4MwdAWPvkjN09yEjcpMjdI5J7/Kp8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FOZTWA/R12Q6Wepc3usEyzdJ8+1ybXBWvwQjXd6+2YNj99KLmNQ0B1IpPrPQRX2QxULt+mHX+U29IQFlumtXeAwi+TYpxow3Trs++JGdcLLuf3EskAIr83qK0QiDzftgIPioHPVkJpYJbDdxVGqxrTCVM7inc74I6wrrioN73hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ae95Zujj; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e5bdb9244eso93983947b3.2
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 10:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730832226; x=1731437026; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6eFxuwycLsLAbgeJ2mfRY/GmSrQy75uRCa7WJGSthvA=;
        b=ae95ZujjfyW78zQnIBmR5OUT0kRdRx/L4PsTlm6rDh0wwlRfBX3jUUzpDY7rUTFAYj
         zFzR2IiCdf/T/wGVnvhjq11fhh97u2EZxOdvZ5cM2fT6vd6Y3NMTIDs2QgqIiAC01EK5
         FBPGuA83J4/uRbiipCteE5Sm7IP8DAlU248Orq9qrhjIv8XJzC3SiPrzLAayil06Xwzt
         R4i2dHlOCxTggHiHEmlo9VPhviO3RgBQtqtNcM5pro5aHRioLZVBiG7dphG8cDYzDVh+
         YJYQKzp24sbV/dIgN+yfxNCIQUAgoozMDoeRXr6vXSz4Unv1xGgwkELeEL8SHkEoq1Pu
         MTxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730832226; x=1731437026;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6eFxuwycLsLAbgeJ2mfRY/GmSrQy75uRCa7WJGSthvA=;
        b=wS1g9/qY4PdlTQgcIBNc/f8JIQpghDYK3ognuLIzeCGRGBV/y9dnnzKdhKk34niuxl
         DucLCcEfDd5ttwoa41OGBwe86cpa51MSVZAxuU76dZHCuexCxg3yVJf6KcGvASu4GfRe
         vwSPKFD7XTbEOB9Fv2q5noDN7WHyQvFoEFvG+9JdMS4xyyCajJelgWRuUhqAn4/G3CD4
         5d+QzLIeLXOlMbBcPa2RbVoOFrXXRsMUlrTsfT7fsxZ6OgH4vEI1x5A0O5Ee40AOmK7S
         msIC0W2GzackPJrwhzFqcGEF+cJ09Pr5YIWOQQfG9o8JL6oeLDT3rB1ehKKTBBn1BMA4
         EMFg==
X-Forwarded-Encrypted: i=1; AJvYcCV4CcsdQoT03dmGOkCP7I9NOgSYKnc76z4wAW1L0uP4dQbY4N1FF28oBfkAgaxFx5CtFu0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7HALPxsAY79nE1Y/xIQwGjEEMQFJ9w3p0VDEWImI6bv0jGUSB
	vwHVkiMciclkTDc6Pu4LhEgvxyqIh/EgJyvzbOKTqJTYhhyPmnSSdb9a+GJENy/1zwoXOYviEL/
	313P8ioRyTSPnXyo4DQ==
X-Google-Smtp-Source: AGHT+IENfGBOOxiMAGivPRvdHYCFkRZ7cQKI8lrn9MmMEy60InS9mwDJ6R0bcKfhRAeslM5j1SEZ1ph/hIA93Day
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:13d:fb22:ac12:a84b])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:4512:b0:6e2:1b8c:39bf with
 SMTP id 00721157ae682-6e9d88ad8b5mr10038697b3.2.1730832225710; Tue, 05 Nov
 2024 10:43:45 -0800 (PST)
Date: Tue,  5 Nov 2024 18:43:25 +0000
In-Reply-To: <20241105184333.2305744-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241105184333.2305744-4-jthoughton@google.com>
Subject: [PATCH v8 03/11] KVM: x86/mmu: Factor out spte atomic bit clearing routine
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

This new function, tdp_mmu_clear_spte_bits_atomic(), will be used in a
follow-up patch to enable lockless Accessed and R/W/X bit clearing.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/mmu/tdp_iter.h | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 2880fd392e0c..a24fca3f9e7f 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -25,6 +25,13 @@ static inline u64 kvm_tdp_mmu_write_spte_atomic(tdp_ptep_t sptep, u64 new_spte)
 	return xchg(rcu_dereference(sptep), new_spte);
 }
 
+static inline u64 tdp_mmu_clear_spte_bits_atomic(tdp_ptep_t sptep, u64 mask)
+{
+	atomic64_t *sptep_atomic = (atomic64_t *)rcu_dereference(sptep);
+
+	return (u64)atomic64_fetch_and(~mask, sptep_atomic);
+}
+
 static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_spte)
 {
 	KVM_MMU_WARN_ON(is_ept_ve_possible(new_spte));
@@ -63,12 +70,8 @@ static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
 static inline u64 tdp_mmu_clear_spte_bits(tdp_ptep_t sptep, u64 old_spte,
 					  u64 mask, int level)
 {
-	atomic64_t *sptep_atomic;
-
-	if (kvm_tdp_mmu_spte_need_atomic_write(old_spte, level)) {
-		sptep_atomic = (atomic64_t *)rcu_dereference(sptep);
-		return (u64)atomic64_fetch_and(~mask, sptep_atomic);
-	}
+	if (kvm_tdp_mmu_spte_need_atomic_write(old_spte, level))
+		return tdp_mmu_clear_spte_bits_atomic(sptep, mask);
 
 	__kvm_tdp_mmu_write_spte(sptep, old_spte & ~mask);
 	return old_spte;
-- 
2.47.0.199.ga7371fff76-goog


