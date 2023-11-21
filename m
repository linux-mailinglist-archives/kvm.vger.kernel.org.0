Return-Path: <kvm+bounces-2178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EB6F7F2C31
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 12:55:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17197281A73
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 11:55:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAAE9495D1;
	Tue, 21 Nov 2023 11:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EJCR4V3I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE2918E;
	Tue, 21 Nov 2023 03:55:35 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id d9443c01a7336-1cc9b626a96so40037875ad.2;
        Tue, 21 Nov 2023 03:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700567735; x=1701172535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kGrm68QoMUrup/7Rp3nNNkMcX2hX6/h9dwhr7ZWgjH8=;
        b=EJCR4V3I+dsuU7B1YHri5Mr0Ew79yoP5mZnDWFtmoEieWIvBhXLRgzQE6NJrMc/6Yj
         8VLJbXtnKL0nnuxoxUubkO5oMoSOZ/3z7LcZUlBEPGgIV9aYyUGhM29peZAt4xBLCQMe
         dUN+axiqYEssRyELE4KjJpyNeBb9quX6bOG131ng3CXf+paKZUb2oLmUNl1TY3z50cp3
         6cFgSRUNTAR4Rtcb+vSWr2d9kUlJhg+LWUoH0FvtO8TofmnvdmXhrkteGZNKoOsj3jcI
         bVIK5wUZtymwVMGq8VLTcivAv2vi4Urb9pTHXe8OqcC06t6x2kE94AE45LNJP3st8oPj
         OYUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700567735; x=1701172535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kGrm68QoMUrup/7Rp3nNNkMcX2hX6/h9dwhr7ZWgjH8=;
        b=lZ+3tynVBr4EEI8CyznR8hR7H6M1rJGDeyDQ3YcCmjg2hVGGi293jqbLfjfFihGhSY
         n5HiBfeczRDMe0ZQd9s5c5HsSwxrVHtjO0vHWlcokiM/iXP1f83zukoeUj8IVaARKwRl
         PLj0I0j1u7IktBKcORk0EW4QZDUFIFCk7F9033/CYMflRqoanF3DW0fq25ahyShBzZqo
         zgQWQmuDgZNdlxtGliGs6HlsNG9sp/1A+z5p81nqm6p/Ly7ayweYoranZSyoLOaXnWgu
         6yQiyunVo57v/zMs1xhQZ/Go0XMKxFWlkUPpRlZAObd16no3/siUkftrVD66OlAa/rTX
         QoiA==
X-Gm-Message-State: AOJu0YwFPX6klCQNTg7syppjXZVmA+r6huIDb3wbNkt4/HJts6O2mSbb
	j01ht2tnkNg2BZgJQTtvnZ+mfaGo08usS8S7Eno=
X-Google-Smtp-Source: AGHT+IEP+yqOSLFwgBXDu3JDmfZuTRtjyupxZQFL9EKAjVcQUqw8SuzN7rkHWoNCrZLQKKVhJnp+mw==
X-Received: by 2002:a17:902:f7d1:b0:1cf:6e3d:d8e7 with SMTP id h17-20020a170902f7d100b001cf6e3dd8e7mr1445161plw.26.1700567734754;
        Tue, 21 Nov 2023 03:55:34 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id g10-20020a170902740a00b001cc1dff5b86sm7685431pll.244.2023.11.21.03.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Nov 2023 03:55:34 -0800 (PST)
From: Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Like Xu <likexu@tencent.com>,
	Jim Mattson <jmattson@google.com>,
	Aaron Lewis <aaronlewis@google.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Jinrong Liang <ljr.kernel@gmail.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] KVM: selftests: Add forced emulation check to fix #UD
Date: Tue, 21 Nov 2023 19:54:49 +0800
Message-Id: <20231121115457.76269-2-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231121115457.76269-1-cloudliang@tencent.com>
References: <20231121115457.76269-1-cloudliang@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Forced emulation uses a magic "prefix" to trigger a #UD, which KVM
intercepts. If forced emulation isn't enabled, KVM ignores the magic
prefix and reflects the #UD back into the guest.

Reported-by: Jinrong Liang <cloudliang@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Tested-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 41 ++++++++++++-------
 1 file changed, 26 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 248ebe8c0577..7d8094a27209 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -325,6 +325,26 @@ __GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,			\
 		       "Expected " #insn "(0x%x) to yield 0x%lx, got 0x%lx",	\
 		       msr, expected_val, val);
 
+static void guest_test_rdpmc(uint32_t rdpmc_idx, bool expect_success,
+			     uint64_t expected_val)
+{
+	uint8_t vector;
+	uint64_t val;
+
+	vector = rdpmc_safe(rdpmc_idx, &val);
+	GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, !expect_success, vector);
+	if (expect_success)
+		GUEST_ASSERT_PMC_VALUE(RDPMC, rdpmc_idx, val, expected_val);
+
+	if (!is_forced_emulation_enabled)
+		return;
+
+	vector = rdpmc_safe_fep(rdpmc_idx, &val);
+	GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, !expect_success, vector);
+	if (expect_success)
+		GUEST_ASSERT_PMC_VALUE(RDPMC, rdpmc_idx, val, expected_val);
+}
+
 static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters,
 				 uint8_t nr_counters, uint32_t or_mask)
 {
@@ -367,20 +387,15 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 		if (!expect_gp)
 			GUEST_ASSERT_PMC_VALUE(RDMSR, msr, val, expected_val);
 
+		/*
+		 * Redo the read tests with RDPMC, which has different indexing
+		 * semantics and additional capabilities.
+		 */
 		rdpmc_idx = i;
 		if (base_msr == MSR_CORE_PERF_FIXED_CTR0)
 			rdpmc_idx |= INTEL_RDPMC_FIXED;
 
-		/* Redo the read tests with RDPMC, and with forced emulation. */
-		vector = rdpmc_safe(rdpmc_idx, &val);
-		GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, !expect_success, vector);
-		if (expect_success)
-			GUEST_ASSERT_PMC_VALUE(RDPMC, rdpmc_idx, val, expected_val);
-
-		vector = rdpmc_safe_fep(rdpmc_idx, &val);
-		GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, !expect_success, vector);
-		if (expect_success)
-			GUEST_ASSERT_PMC_VALUE(RDPMC, rdpmc_idx, val, expected_val);
+		guest_test_rdpmc(rdpmc_idx, expect_success, expected_val);
 
 		/*
 		 * KVM doesn't support non-architectural PMUs, i.e. it should
@@ -390,11 +405,7 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 		GUEST_ASSERT(!expect_success || !pmu_has_fast_mode);
 		rdpmc_idx |= INTEL_RDPMC_FAST;
 
-		vector = rdpmc_safe(rdpmc_idx, &val);
-		GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, true, vector);
-
-		vector = rdpmc_safe_fep(rdpmc_idx, &val);
-		GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, true, vector);
+		guest_test_rdpmc(rdpmc_idx, false, -1ull);
 
 		vector = wrmsr_safe(msr, 0);
 		GUEST_ASSERT_PMC_MSR_ACCESS(WRMSR, msr, expect_gp, vector);
-- 
2.39.3


