Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3A9718AE4
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 22:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjEaUPq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 16:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjEaUPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 16:15:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E747C13E
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 13:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685564097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X1+M7T6Odh2i5zf9nHT26H5Q4uJWOu5S7+RgtQe0rFw=;
        b=EfP2L8pFlwnDmWurU5OhcKtnO0ApW+O/laGP11kQ4F9gTiyFAsgLggFe8xyyYYCDMo+IKE
        yxQpheGsorhKNSjbkjEth2vREfB13lTPun69yc/y4qs/TcWwflYVhdvu4ha8jwyeRzpeau
        fa6x1WT4IUNG7Lltzrl/1JwckLneDko=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-F48u5WuFMAGitiHcgKRB_Q-1; Wed, 31 May 2023 16:14:54 -0400
X-MC-Unique: F48u5WuFMAGitiHcgKRB_Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22C3F1C03DB6;
        Wed, 31 May 2023 20:14:53 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08C98407DEC0;
        Wed, 31 May 2023 20:14:50 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, maz@kernel.org, will@kernel.org,
        oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com,
        alexandru.elisei@arm.com
Cc:     mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v2 4/6] arm: pmu: Fix chain counter enable/disable sequences
Date:   Wed, 31 May 2023 22:14:36 +0200
Message-Id: <20230531201438.3881600-5-eric.auger@redhat.com>
In-Reply-To: <20230531201438.3881600-1-eric.auger@redhat.com>
References: <20230531201438.3881600-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some ARM ARM ddi0487 revisions it is said that
disabling/enabling a pair of counters that are paired
by a CHAIN event should follow a given sequence:

Enable the high counter first, isb, enable low counter
Disable the low counter first, isb, disable the high counter

This was the case in Fc. However this is not written anymore
in subsequent revions such as Ia.

Anyway, just in case, and because it also makes the code a
little bit simpler, introduce 2 helpers to enable/disable chain
counters that execute those sequences and replace the existing
PMCNTENCLR/ENSET calls (at least this cannot do any harm).

Also fix 2 write_sysreg_s(0x0, PMCNTENSET_EL0) in subtest 5 & 6
and replace them by PMCNTENCLR writes since writing 0 in
PMCNTENSET_EL0 has no effect.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v1 -> v2:
- fix the enable_chain_counter()/disable_chain_counter()
  sequence, ie. swap n + 1 / n as reported by Alexandru.
- fix an other comment using the 'low' terminology
---
 arm/pmu.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 74dd4c10..74c9f6f9 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -731,6 +731,22 @@ static void test_chained_sw_incr(bool unused)
 		    read_regn_el0(pmevcntr, 0), \
 		    read_sysreg(pmovsclr_el0))
 
+static void enable_chain_counter(int even)
+{
+	write_sysreg_s(BIT(even + 1), PMCNTENSET_EL0); /* Enable the high counter first */
+	isb();
+	write_sysreg_s(BIT(even), PMCNTENSET_EL0); /* Enable the low counter */
+	isb();
+}
+
+static void disable_chain_counter(int even)
+{
+	write_sysreg_s(BIT(even), PMCNTENCLR_EL0); /* Disable the low counter first*/
+	isb();
+	write_sysreg_s(BIT(even + 1), PMCNTENCLR_EL0); /* Disable the high counter */
+	isb();
+}
+
 static void test_chain_promotion(bool unused)
 {
 	uint32_t events[] = {MEM_ACCESS, CHAIN};
@@ -769,16 +785,17 @@ static void test_chain_promotion(bool unused)
 	/* 1st COUNT with CHAIN enabled, next COUNT with CHAIN disabled */
 	report_prefix_push("subtest3");
 	pmu_reset();
-	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
-	isb();
+	enable_chain_counter(0);
 	PRINT_REGS("init");
 
 	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 1st loop");
 
 	/* disable the CHAIN event */
-	write_sysreg_s(0x2, PMCNTENCLR_EL0);
+	disable_chain_counter(0);
+	write_sysreg_s(0x1, PMCNTENSET_EL0); /* Enable the low counter */
+	isb();
 	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 2nd loop");
 	report(read_sysreg(pmovsclr_el0) == 0x1,
@@ -799,9 +816,11 @@ static void test_chain_promotion(bool unused)
 	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 1st loop");
 
-	/* enable the CHAIN event */
-	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	/* Disable the low counter first and enable the chain counter */
+	write_sysreg_s(0x1, PMCNTENCLR_EL0);
 	isb();
+	enable_chain_counter(0);
+
 	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 
 	PRINT_REGS("After 2nd loop");
@@ -825,10 +844,10 @@ static void test_chain_promotion(bool unused)
 	PRINT_REGS("After 1st loop");
 
 	/* 0 becomes CHAINED */
-	write_sysreg_s(0x0, PMCNTENSET_EL0);
+	write_sysreg_s(0x3, PMCNTENCLR_EL0);
 	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
-	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	write_regn_el0(pmevcntr, 1, 0x0);
+	enable_chain_counter(0);
 
 	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 2nd loop");
@@ -844,13 +863,13 @@ static void test_chain_promotion(bool unused)
 	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
 	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
-	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	enable_chain_counter(0);
 	PRINT_REGS("init");
 
 	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 1st loop");
 
-	write_sysreg_s(0x0, PMCNTENSET_EL0);
+	disable_chain_counter(0);
 	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 
-- 
2.38.1

