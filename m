Return-Path: <kvm+bounces-480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79F647E0024
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 11:02:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 647E71C21061
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 10:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EB9A134BC;
	Fri,  3 Nov 2023 10:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EmLHSsMF"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E1D125CC
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 10:01:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9034B191
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 03:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699005712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XqnoXVfWawq8QrClZNYW97zTnEotSmYZbTk5P8wdCbA=;
	b=EmLHSsMF/dlj/9tOIqXb1mp1BK7tVaauI/qS4FTUFRy9PqxRzrHYKlAUbRnRt5guWFEmhy
	susCsLvXW9mtwPae/wUjfKAzgqdmLqbcihx8eyNNLg945oEUCg27BC10yzjr4iGBnkSqCW
	+BDEt2HuCmlCDiiVBU5gjEXh1LqZ/zo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-331-UmZduIG_PUyEWgbnm3CRQA-1; Fri,
 03 Nov 2023 06:01:47 -0400
X-MC-Unique: UmZduIG_PUyEWgbnm3CRQA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFC7B3C0F668;
	Fri,  3 Nov 2023 10:01:46 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.192.57])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 187E01121308;
	Fri,  3 Nov 2023 10:01:44 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev,
	maz@kernel.org,
	oliver.upton@linux.dev,
	alexandru.elisei@arm.com
Cc: jarichte@redhat.com
Subject: [kvm-unit-tests PATCH] arm: pmu-overflow-interrupt: Increase count values
Date: Fri,  3 Nov 2023 11:01:39 +0100
Message-ID: <20231103100139.55807-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On some hardware, some pmu-overflow-interrupt failures can be observed.
Although the even counter overflows, the interrupt is not seen as
expected. This happens in the subtest after "promote to 64-b" comment.
After analysis, the PMU overflow interrupt actually hits, ie.
kvm_pmu_perf_overflow() gets called and KVM_REQ_IRQ_PENDING is set,
as expected. However the PMCR.E is reset by the handle_exit path, at
kvm_pmu_handle_pmcr() before the next guest entry and
kvm_pmu_flush_hwstate/kvm_pmu_update_state subsequent call.
There, since the enable bit has been reset, kvm_pmu_update_state() does
not inject the interrupt into the guest.

This does not seem to be a KVM bug but rather an unfortunate
scenario where the test disables the PMCR.E too closely to the
advent of the overflow interrupt.

Since it looks like a benign and inlikely case, let's resize the number
of iterations to prevent the PMCR enable bit from being resetted
at the same time as the actual overflow event.

COUNT_INT is introduced, arbitrarily set to 1000 iterations and is
used in this test.

Reported-by: Jan Richter <jarichte@redhat.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/pmu.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index a91a7b1f..acd88571 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -66,6 +66,7 @@
 #define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
 #define COUNT 250
 #define MARGIN 100
+#define COUNT_INT 1000
 /*
  * PRE_OVERFLOW2 is set so that 1st @COUNT iterations do not
  * produce 32b overflow and 2nd @COUNT iterations do. To accommodate
@@ -978,13 +979,13 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 
 	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
 
-	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
+	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	report(expect_interrupts(0), "no overflow interrupt after preset");
 
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	isb();
 
-	for (i = 0; i < 100; i++)
+	for (i = 0; i < COUNT_INT; i++)
 		write_sysreg(0x2, pmswinc_el0);
 
 	isb();
@@ -1002,15 +1003,15 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 	write_sysreg(ALL_SET_32, pmintenset_el1);
 	isb();
 
-	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
+	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	isb();
 
-	for (i = 0; i < 100; i++)
+	for (i = 0; i < COUNT_INT; i++)
 		write_sysreg(0x3, pmswinc_el0);
 
-	mem_access_loop(addr, 200, pmu.pmcr_ro);
+	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro);
 	report_info("overflow=0x%lx", read_sysreg(pmovsclr_el0));
 	report(expect_interrupts(0x3),
 		"overflow interrupts expected on #0 and #1");
@@ -1029,7 +1030,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
 	write_regn_el0(pmevcntr, 0, pre_overflow);
 	isb();
-	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
+	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	report(expect_interrupts(0x1), "expect overflow interrupt");
 
 	/* overflow on odd counter */
@@ -1037,7 +1038,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 	write_regn_el0(pmevcntr, 0, pre_overflow);
 	write_regn_el0(pmevcntr, 1, all_set);
 	isb();
-	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
+	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	if (overflow_at_64bits) {
 		report(expect_interrupts(0x1),
 		       "expect overflow interrupt on even counter");
-- 
2.41.0


