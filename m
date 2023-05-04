Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 431A46F6D48
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 15:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbjEDNt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 09:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbjEDNty (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 09:49:54 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E9583DD
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 06:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1683208177; x=1714744177;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=F30hz1eE8lBh7k7xqezWggJgXubuEGZI0QNZ58kRYho=;
  b=l1/rtzUiGzma/WvmBzocoQoraI1RTz1DAER0IRtiUd53Y4IUenKD99f8
   5rAo6ikSDa8pZ4Yyb2JKTHJ6aDTVVMUfSpu5NndolVNuncZHga+K0zbzz
   BG3SPe+uvr+gkSh8Kev+gxu+nWNbWtE/p4a5E5FNpaYACmsL/Vl/gLXR5
   U=;
X-IronPort-AV: E=Sophos;i="5.99,249,1677542400"; 
   d="scan'208";a="211102882"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-e7094f15.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2023 13:49:12 +0000
Received: from EX19MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-e7094f15.us-west-2.amazon.com (Postfix) with ESMTPS id 8BFD541511;
        Thu,  4 May 2023 13:49:11 +0000 (UTC)
Received: from EX19MTAUWA001.ant.amazon.com (10.250.64.204) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Thu, 4 May 2023 13:49:11 +0000
Received: from EX19MTAUWC001.ant.amazon.com (10.250.64.145) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 4 May 2023 13:49:10 +0000
Received: from u40bc5e070a0153.ant.amazon.com (10.1.212.8) by
 mail-relay.amazon.com (10.250.64.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25 via Frontend Transport; Thu, 4 May 2023 13:49:10 +0000
From:   Roman Kagan <rkagan@amazon.de>
To:     <kvm@vger.kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests] x86/pmu: add testcase for WRMSR to counter in PMI handler
Date:   Thu, 4 May 2023 15:49:08 +0200
Message-ID: <20230504134908.830041-1-rkagan@amazon.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a testcase where the PMI handler writes a negative value to the perf
counter whose overflow would trigger that PMI.

It's meant specifically to cover the KVM bug where every negative value
written to the counter caused an immediate overflow; in that case the
vCPU would never leave PMI loop.

The bug is addressed in
https://lore.kernel.org/kvm/20230504120042.785651-1-rkagan@amazon.de;
until this (or some alternative) fix is merged the test will hang on
this testcase.

Signed-off-by: Roman Kagan <rkagan@amazon.de>
---
 x86/pmu.c | 45 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 3 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 72c2c9cfd8b0..cdf9093722fb 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -74,6 +74,7 @@ static void cnt_overflow(isr_regs_t *regs)
 static bool check_irq(void)
 {
 	int i;
+	apic_write(APIC_LVTPC, PMI_VECTOR);
 	irq_received = 0;
 	irq_enable();
 	for (i = 0; i < 100000 && !irq_received; i++)
@@ -156,7 +157,6 @@ static void __start_event(pmu_counter_t *evt, uint64_t count)
 	    wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, ctrl);
     }
     global_enable(evt);
-    apic_write(APIC_LVTPC, PMI_VECTOR);
 }
 
 static void start_event(pmu_counter_t *evt)
@@ -474,6 +474,45 @@ static void check_running_counter_wrmsr(void)
 	report_prefix_pop();
 }
 
+static void cnt_overflow_with_wrmsr(isr_regs_t *regs)
+{
+	cnt_overflow(regs);
+	/* write negative value that won't cause immediate overflow */
+	wrmsr(MSR_GP_COUNTERx(0),
+	      ((-1ull) << 31) & ((1ull << pmu.gp_counter_width) - 1));
+}
+
+static void check_running_counter_wrmsr_in_pmi(void)
+{
+	pmu_counter_t evt = {
+		.ctr = MSR_GP_COUNTERx(0),
+		.config = EVNTSEL_OS | EVNTSEL_USR | EVNTSEL_INT |
+			  gp_events[1].unit_sel,
+	};
+
+	report_prefix_push("running counter wrmsr in PMI");
+
+	start_event(&evt);
+	apic_write(APIC_LVTPC, PMI_VECTOR + 1);
+
+	irq_received = 0;
+	irq_enable();
+	/*
+	 * the value written will be treated as -1 both for full-width and
+	 * non-full-width counters; for the latter upper 32 bits are ignored
+	 */
+	wrmsr(MSR_GP_COUNTERx(0),
+	      -1ull & ((1ull << pmu.gp_counter_width) - 1));
+
+	loop();
+	stop_event(&evt);
+	irq_disable();
+	report(evt.count >= gp_events[1].min, "cntr");
+	report(irq_received, "irq");
+
+	report_prefix_pop();
+}
+
 static void check_emulated_instr(void)
 {
 	uint64_t status, instr_start, brnch_start;
@@ -559,6 +598,7 @@ static void check_counters(void)
 	check_counter_overflow();
 	check_gp_counter_cmask();
 	check_running_counter_wrmsr();
+	check_running_counter_wrmsr_in_pmi();
 }
 
 static void do_unsupported_width_counter_write(void *index)
@@ -671,6 +711,7 @@ int main(int ac, char **av)
 {
 	setup_vm();
 	handle_irq(PMI_VECTOR, cnt_overflow);
+	handle_irq(PMI_VECTOR + 1, cnt_overflow_with_wrmsr);
 	buf = malloc(N*64);
 
 	check_invalid_rdpmc_gp();
@@ -697,8 +738,6 @@ int main(int ac, char **av)
 	printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
 	printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
 
-	apic_write(APIC_LVTPC, PMI_VECTOR);
-
 	check_counters();
 
 	if (pmu_has_full_writes()) {
-- 
2.34.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



