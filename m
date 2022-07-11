Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2C456D69B
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 09:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiGKHVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 03:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiGKHVI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 03:21:08 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E97E03F
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 00:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657524064; x=1689060064;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cnikltfeSBRS9smOfFHhCf4fnZaY8l5jMA+wrwO5ZyQ=;
  b=A29ccerZXxlUrcU1g7z92DBb06wjTGEgbLfL7DtvhUq0m2kq+A5q1z2E
   uexMNH2YtBtAaSY/ws/6n9l3uaonYwihgGUdCIOWcTzVbQ1RzUmlEK6kR
   B8HhGNHl3wPDZB7BU1fKc+HmL4lTMG63hcsz0WhC4tB7HZiRXz3Omalbx
   kWcJnzcVH4dFtFkqzN8rpKNlpTwpm31eWd64zfjwysPQC7iIneYt3NpkL
   6paxHOCsEJTSR8xQA1CBSclu88Io2tgVCCn+Ebouhr23XccBCCHBQ/3rd
   aUXmpUR+AxHiBvYPWsyo45GG06WiXt9H1Ltzp51NaqQe9Q/8QRTetqaFI
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="267636830"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="267636830"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 00:20:57 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="627392552"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 00:20:57 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH 2/4] x86: Use helpers to fetch supported perf capabilities
Date:   Mon, 11 Jul 2022 00:18:39 -0400
Message-Id: <20220711041841.126648-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220711041841.126648-1-weijiang.yang@intel.com>
References: <20220711041841.126648-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Platform pmu fixed counter and GP events info is enumerated
in CPUID(0xA). Add helpers to fetch the data, other apps can
also rely them to check underneath pmu capabilities.

No functional change intended.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 lib/x86/processor.h | 54 +++++++++++++++++++++++++++++++++++++++++++++
 x86/pmu.c           | 28 +++++++++++------------
 2 files changed, 67 insertions(+), 15 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 9a0dad6..d071aba 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -690,4 +690,58 @@ static inline bool cpuid_osxsave(void)
 	return cpuid(1).c & (1 << (X86_FEATURE_OSXSAVE % 32));
 }
 
+static inline u8 pmu_version(void)
+{
+	return cpuid(10).a & 0xff;
+}
+
+static inline u32 pmu_arch_info(void)
+{
+	return cpuid(10).a;
+}
+
+static inline u32 pmu_gp_events(void)
+{
+	return cpuid(10).b;
+}
+
+static inline u32 pmu_fixed_counters(void)
+{
+	return cpuid(10).d;
+}
+
+static inline u8 pmu_gp_counter_number(void)
+{
+	return (cpuid(10).a >> 8) & 0xff;
+}
+
+static inline u8 pmu_gp_counter_width(void)
+{
+	return (cpuid(10).a >> 16) & 0xff;
+}
+
+static inline u8 pmu_gp_counter_mask_length(void)
+{
+	return (cpuid(10).a >> 24) & 0xff;
+}
+
+static inline u8 pmu_fixed_counter_number(void)
+{
+	struct cpuid id = cpuid(10);
+
+	if ((id.a & 0xff) > 1)
+		return id.d & 0x1f;
+	else
+		return 0;
+}
+
+static inline u8 pmu_fixed_counter_width(void)
+{
+	struct cpuid id = cpuid(10);
+
+	if ((id.a & 0xff) > 1)
+		return (id.d >> 5) & 0xff;
+	else
+		return 0;
+}
 #endif
diff --git a/x86/pmu.c b/x86/pmu.c
index a46bdbf..0d72e5b 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -655,34 +655,32 @@ static void set_ref_cycle_expectations(void)
 
 int main(int ac, char **av)
 {
-	struct cpuid id = cpuid(10);
-
 	setup_vm();
 	handle_irq(PC_VECTOR, cnt_overflow);
 	buf = malloc(N*64);
 
-	eax.full = id.a;
-	ebx.full = id.b;
-	edx.full = id.d;
+	eax.full = pmu_arch_info();
+	ebx.full = pmu_gp_events();
+	edx.full = pmu_fixed_counters();
 
-	if (!eax.split.version_id) {
-		printf("No pmu is detected!\n");
+	if (!pmu_version()) {
+		report_skip("No pmu is detected!");
 		return report_summary();
 	}
 
-	if (eax.split.version_id == 1) {
-		printf("PMU version 1 is not supported\n");
+	if (pmu_version() == 1) {
+		report_skip("PMU version 1 is not supported.");
 		return report_summary();
 	}
 
 	set_ref_cycle_expectations();
 
-	printf("PMU version:         %d\n", eax.split.version_id);
-	printf("GP counters:         %d\n", eax.split.num_counters);
-	printf("GP counter width:    %d\n", eax.split.bit_width);
-	printf("Mask length:         %d\n", eax.split.mask_length);
-	printf("Fixed counters:      %d\n", edx.split.num_counters_fixed);
-	printf("Fixed counter width: %d\n", edx.split.bit_width_fixed);
+	printf("PMU version:         %d\n", pmu_version());
+	printf("GP counters:         %d\n", pmu_gp_counter_number());
+	printf("GP counter width:    %d\n", pmu_gp_counter_width());
+	printf("Mask length:         %d\n", pmu_gp_counter_mask_length());
+	printf("Fixed counters:      %d\n", pmu_fixed_counter_number());
+	printf("Fixed counter width: %d\n", pmu_fixed_counter_width());
 
 	num_counters = eax.split.num_counters;
 
-- 
2.31.1

