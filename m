Return-Path: <kvm+bounces-171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 919427DC955
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 10:22:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1EB91C20C25
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 09:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19E9A1802B;
	Tue, 31 Oct 2023 09:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VFYiVkBm"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686B815EB6
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:21:54 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78978B7;
	Tue, 31 Oct 2023 02:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698744113; x=1730280113;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JgrwofphKXeC1nxCQjenJBStSCQKow/wnGaMmvGi9t4=;
  b=VFYiVkBmBGD8kRqe+DrujLEQl94s4282pp2UDRfP6B+mCP3LPo4tEcEV
   LW5hdXni+qVAErm3OdSN23R2sk5rMjNhHsuYjAktL4i2G5Kk/Gs3S4Vuq
   ZzOjPX5QCUDdHQTj2/8dD8Nx0BgwdZZXFCLbMoZyz//YBH8dsrWa3rzDI
   rKwO/vt4e7nz8LdJ8wzyVZ76dG+PICJrJiAEcHHkVieSknL/7vMPJLU1t
   32JCw1K3H0cDiVxXy52XguuwVxMzhIHfjogyQr2fMoQNr9f9WzDkJx0AT
   +z5rzr3FuZjECeNXboDWwZ0ZODTX86w5iwb+k4fu2g3W+z/g6RXPk5oGg
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="385435968"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="385435968"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 02:21:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="877445524"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="877445524"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga002.fm.intel.com with ESMTP; 31 Oct 2023 02:21:50 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhang Xiong <xiong.y.zhang@intel.com>,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch v2 2/5] x86: pmu: Improve loop() to force to generate llc/branch misses
Date: Tue, 31 Oct 2023 17:29:18 +0800
Message-Id: <20231031092921.2885109-3-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231031092921.2885109-1-dapeng1.mi@linux.intel.com>
References: <20231031092921.2885109-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current loop() helper is a very simple adding loop function, it can't
garantee that LLC misses and branch misses would be always triggered in
the loop() running, especailly along with the larger and larger LLC size
and better and better branch predictor in new CPUs. In this situation
0 LLC/branch misses count would be seen more and more easily just like
what we see on Sapphire Rapids.

It's ambiguous to take 0 as a valid result in tests since we can't
confirm if the PMU function works correctly or it's just disabled.

So this patch improves current loop() function and introduces random
jump and clflush instructions to force to generate LLC and branch
misses. Since random jump and clflush instructions are involved, all
pre-defined valid count ranges are also update accordingly.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 0def28695c70..1df5794b7ef8 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -11,7 +11,7 @@
 #include "libcflat.h"
 #include <stdint.h>
 
-#define N 1000000
+#define N 1000000ULL
 
 // These values match the number of instructions and branches in the
 // assembly block in check_emulated_instr().
@@ -28,25 +28,25 @@ typedef struct {
 struct pmu_event {
 	const char *name;
 	uint32_t unit_sel;
-	int min;
-	int max;
+	uint64_t min;
+	uint64_t max;
 } intel_gp_events[] = {
-	{"core cycles", 0x003c, 1*N, 50*N},
+	{"core cycles", 0x003c, 1*N, 500*N},
 	{"instructions", 0x00c0, 10*N, 10.2*N},
-	{"ref cycles", 0x013c, 1*N, 30*N},
-	{"llc references", 0x4f2e, 1, 2*N},
-	{"llc misses", 0x412e, 1, 1*N},
-	{"branches", 0x00c4, 1*N, 1.1*N},
-	{"branch misses", 0x00c5, 0, 0.1*N},
+	{"ref cycles", 0x013c, 1*N, 300*N},
+	{"llc references", 0x4f2e, 0.1*N, 2*N},
+	{"llc misses", 0x412e, 0.1*N, 1*N},
+	{"branches", 0x00c4, 3*N, 3.3*N},
+	{"branch misses", 0x00c5, 0.1*N, 0.3*N},
 }, amd_gp_events[] = {
-	{"core cycles", 0x0076, 1*N, 50*N},
+	{"core cycles", 0x0076, 1*N, 500*N},
 	{"instructions", 0x00c0, 10*N, 10.2*N},
-	{"branches", 0x00c2, 1*N, 1.1*N},
-	{"branch misses", 0x00c3, 0, 0.1*N},
+	{"branches", 0x00c2, 3*N, 3.3*N},
+	{"branch misses", 0x00c3, 0.1*N, 0.3*N},
 }, fixed_events[] = {
 	{"fixed 1", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
-	{"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 30*N},
-	{"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
+	{"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 500*N},
+	{"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 300*N},
 };
 
 char *buf;
@@ -56,10 +56,15 @@ static unsigned int gp_events_size;
 
 static inline void loop(void)
 {
-	unsigned long tmp, tmp2, tmp3;
+	unsigned long tmp, tmp2, tmp3, tmp4;
 
-	asm volatile("1: mov (%1), %2; add $64, %1; nop; nop; nop; nop; nop; nop; nop; loop 1b"
-			: "=c"(tmp), "=r"(tmp2), "=r"(tmp3): "0"(N), "1"(buf));
+	asm volatile("1: dec %0; jz 3f; mov (%1), %2; add $64, %1; nop; \n"
+		     "   rdrand %3; and $7, %3; jnz 2f; clflush (%1); jmp 1b\n"
+		     "2: nop; jmp 1b;"
+		     "3: nop"
+		     : "=c"(tmp), "=r"(tmp2), "=r"(tmp3), "=r"(tmp4)
+		     : "0"(N), "1"(buf)
+		     : "memory");
 
 }
 
@@ -202,7 +207,7 @@ static noinline void __measure(pmu_counter_t *evt, uint64_t count)
 
 static bool verify_event(uint64_t count, struct pmu_event *e)
 {
-	// printf("%d <= %ld <= %d\n", e->min, count, e->max);
+	// printf("%ld <= %ld <= %ld\n", e->min, count, e->max);
 	return count >= e->min  && count <= e->max;
 
 }
-- 
2.34.1


