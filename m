Return-Path: <kvm+bounces-62571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 756E1C48940
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:33:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E33684F2C3F
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:31:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ADD632C921;
	Mon, 10 Nov 2025 18:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b2OGkEzi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055FD3396FE;
	Mon, 10 Nov 2025 18:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799113; cv=none; b=geHReUcoU1eVsEAnjuCUfRJ5yv9AtPH9RCP48cwOGEPg8iuBi566EN+2Sjp7bcmfy/2HmKnFNwW6zv3zU98/Nq1L8aBGgWhhGwLTlB6qbUXVKZVKmU/oM4Oi16bVqZd5vFlHPlLK9KwVd1fVPnr0M1kqrAxJC47alY/pI9L28Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799113; c=relaxed/simple;
	bh=nttrs9kXJEruBtJDkTL/ZkXBCpbVD+Se2fR40WktCw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diplprWOjx7fqicQ7Q8ybqCjAj7vIMg9qopbXov/o6OHx0fC4zbQDuhqI7xUpRjXnEzY7nLG0z57Zow629Wntl38Fy4Qp514tf5L284i3UOucH2oXBqGAUgNnE+1AgEA7+2gFpl4x9zqVys5/ByCyQHbc/369NeDA5iwgWWf/xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b2OGkEzi; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762799112; x=1794335112;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nttrs9kXJEruBtJDkTL/ZkXBCpbVD+Se2fR40WktCw4=;
  b=b2OGkEziBuVCBmILT3O6HopGHpN86odXwZcQWIAJURL07xDbPMoALBQm
   945vXUL1kjj9DYLrpsWEOgjSSA/Anx3Dbq7aK5VZeucyHRJ6cdCROxAv8
   C8pSzs3BQA5ELXiKb+ZVf+D59ywvppv9tWmIzKL9YE6Lkj02aEUiRFkTb
   7GeVA8hbVvfEo9/Ke4KIW8A/9wkIafRfy/c5LrUfRpMWCN2KoSVpy01xf
   zXYBBfmBAD1DXZUS3GFp+5pNObGMaZD4tZnbamubtuxNbZ/e9kGHrgN8c
   gnujfNI2SD0w4TGT2rp248R43Te/LRLwH5tQRr4hK1xDU/hiUDQL6CaHX
   g==;
X-CSE-ConnectionGUID: Loa790ghSMaJfHPMpf34sw==
X-CSE-MsgGUID: 7bGlQ0hKSX6HC817Ms9Y3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76305555"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="76305555"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:25:12 -0800
X-CSE-ConnectionGUID: vJb1HY+jRJiswqjNK2PQzg==
X-CSE-MsgGUID: DvjLWkxdSlqFhlv4UCNEBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="219396288"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 10 Nov 2025 10:25:12 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	chao.gao@intel.com,
	zhao1.liu@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH RFC v1 20/20] KVM: selftests: Add APX state handling and XCR0 sanity checks
Date: Mon, 10 Nov 2025 18:01:31 +0000
Message-ID: <20251110180131.28264-21-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251110180131.28264-1-chang.seok.bae@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that KVM exposes the APX feature to guests on APX-capable systems,
extend the selftests to validate XCR0 configuration and state management.

Since APX repurposes the XSAVE area previously used by MPX in the
non-compacted format, add a check to ensure that MPX states are not set
when APX is enabled.

Also, load non-init APX state data in the guest so that XSTATE_BV[APX] is
set, allowing validation of APX state testing.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
 .../selftests/kvm/include/x86/processor.h     |  1 +
 tools/testing/selftests/kvm/x86/state_test.c  |  6 ++++++
 .../selftests/kvm/x86/xcr0_cpuid_test.c       | 20 +++++++++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 51cd84b9ca66..dde7af40584e 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -88,6 +88,7 @@ struct xstate {
 #define XFEATURE_MASK_LBR		BIT_ULL(15)
 #define XFEATURE_MASK_XTILE_CFG		BIT_ULL(17)
 #define XFEATURE_MASK_XTILE_DATA	BIT_ULL(18)
+#define XFEATURE_MASK_APX		BIT_ULL(19)
 
 #define XFEATURE_MASK_AVX512		(XFEATURE_MASK_OPMASK | \
 					 XFEATURE_MASK_ZMM_Hi256 | \
diff --git a/tools/testing/selftests/kvm/x86/state_test.c b/tools/testing/selftests/kvm/x86/state_test.c
index 141b7fc0c965..6d1dc575b22b 100644
--- a/tools/testing/selftests/kvm/x86/state_test.c
+++ b/tools/testing/selftests/kvm/x86/state_test.c
@@ -167,6 +167,12 @@ static void __attribute__((__flatten__)) guest_code(void *arg)
 			asm volatile ("vmovupd %0, %%zmm16" :: "m" (buffer));
 		}
 
+		if (supported_xcr0 & XFEATURE_MASK_APX) {
+			/* mov $0xcccccccc, %r16 */
+			asm volatile (".byte 0xd5, 0x18, 0xb8, 0xcc, 0xcc,"
+				      "0xcc, 0xcc, 0x00, 0x00, 0x00, 0x00");
+		}
+
 		if (this_cpu_has(X86_FEATURE_MPX)) {
 			uint64_t bounds[2] = { 10, 0xffffffffull };
 			uint64_t output[2] = { };
diff --git a/tools/testing/selftests/kvm/x86/xcr0_cpuid_test.c b/tools/testing/selftests/kvm/x86/xcr0_cpuid_test.c
index d038c1571729..6e4f2f83c831 100644
--- a/tools/testing/selftests/kvm/x86/xcr0_cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86/xcr0_cpuid_test.c
@@ -46,6 +46,21 @@ do {									\
 		       __supported, (xfeatures));			\
 } while (0)
 
+/*
+ * Verify that mutually exclusive architectural features do not overlap.
+ * For example, APX and MPX must never be reported as supported together.
+ */
+#define ASSERT_XFEATURE_CONFLICT(supported_xcr0, xfeatures, conflicts)			\
+do {											\
+	uint64_t __supported = (supported_xcr0) & ((xfeatures) | (conflicts));		\
+											\
+	__GUEST_ASSERT((__supported & (xfeatures)) != (xfeatures) ||			\
+		       !(__supported & (conflicts)),					\
+		       "supported = 0x%lx, xfeatures = 0x%llx, conflicts = 0x%llx",	\
+		       __supported, (xfeatures), (conflicts));				\
+} while (0)
+
+
 static void guest_code(void)
 {
 	uint64_t initial_xcr0;
@@ -79,6 +94,11 @@ static void guest_code(void)
 	ASSERT_ALL_OR_NONE_XFEATURE(supported_xcr0,
 				    XFEATURE_MASK_XTILE);
 
+	/* Check APX by ensuring MPX is not exposed concurrently */
+	ASSERT_XFEATURE_CONFLICT(supported_xcr0,
+				 XFEATURE_MASK_APX,
+				 XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
+
 	vector = xsetbv_safe(0, XFEATURE_MASK_FP);
 	__GUEST_ASSERT(!vector,
 		       "Expected success on XSETBV(FP), got %s",
-- 
2.51.0


