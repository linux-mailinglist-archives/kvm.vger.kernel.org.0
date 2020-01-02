Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBAE12E6EA
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2020 14:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbgABNrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jan 2020 08:47:19 -0500
Received: from foss.arm.com ([217.140.110.172]:47344 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728435AbgABNrS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jan 2020 08:47:18 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 31B541FB;
        Thu,  2 Jan 2020 05:47:18 -0800 (PST)
Received: from e121566-lin.arm.com,emea.arm.com,asiapac.arm.com,usa.arm.com (unknown [10.37.9.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BABBC3F68F;
        Thu,  2 Jan 2020 05:47:16 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com
Subject: [kvm-unit-tests RFC PATCH v3 7/7] arm64: timer: Run tests with VHE disabled
Date:   Thu,  2 Jan 2020 13:46:46 +0000
Message-Id: <1577972806-16184-8-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577972806-16184-1-git-send-email-alexandru.elisei@arm.com>
References: <1577972806-16184-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disable VHE if first command line parameter is "nvhe" and then test the
timers. Just like with VHE enabled, if no other parameter is given, all
four timers are tested; otherwise, only the timers specified by the user.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm64/asm/processor.h |  2 ++
 arm/timer.c               | 33 +++++++++++++++++++++++++++++----
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 70a5261dfe97..45a3176629e7 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -21,6 +21,8 @@
 #define HCR_EL2_TGE		(1 << 27)
 #define HCR_EL2_E2H_SHIFT	34
 #define HCR_EL2_E2H		(_UL(1) << 34)
+#define HCR_EL2_IMO		(1 << 4)
+#define HCR_EL2_FMO		(1 << 3)
 
 #define SCTLR_EL2_RES1		(3 << 28 | 3 << 22 | 1 << 18 |	\
 				 1 << 16 | 1 << 11 | 3 << 4)
diff --git a/arm/timer.c b/arm/timer.c
index 88de84bc1bcf..b35af189f857 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -465,19 +465,34 @@ static void test_hptimer(void)
 	report_prefix_pop();
 }
 
-static void test_init(void)
+static void test_init(bool nvhe)
 {
 	const struct fdt_property *prop;
 	const void *fdt = dt_fdt();
+	u64 hcr;
 	int node, len;
 	u32 *data;
 
+	if (nvhe) {
+		disable_vhe();
+		hcr = read_sysreg(hcr_el2);
+		/* KVM doesn't support different IMO/FMO settings */
+		hcr |= HCR_EL2_IMO | HCR_EL2_FMO;
+		write_sysreg(hcr, hcr_el2);
+		isb();
+	}
+
 	if (current_el == CurrentEL_EL1) {
 		vtimer = &vtimer_info;
 		ptimer = &ptimer_info;
 	} else {
-		vtimer = &vtimer_info_vhe;
-		ptimer = &ptimer_info_vhe;
+		if (nvhe) {
+			vtimer = &vtimer_info;
+			ptimer = &ptimer_info;
+		} else {
+			vtimer = &vtimer_info_vhe;
+			ptimer = &ptimer_info_vhe;
+		}
 		hvtimer = &hvtimer_info;
 		hptimer = &hptimer_info;
 	}
@@ -564,10 +579,20 @@ static void print_timer_info(void)
 int main(int argc, char **argv)
 {
 	int i;
+	bool nvhe = false;
 
 	current_el = current_level();
 
-	test_init();
+	if (argc > 1 && strcmp(argv[1], "nvhe") == 0) {
+		if (current_el == CurrentEL_EL1)
+			report_info("Skipping EL2 tests. Boot at EL2 to enable.");
+		else
+			nvhe = true;
+		argv = &argv[1];
+		argc--;
+	}
+
+	test_init(nvhe);
 
 	print_timer_info();
 
-- 
2.7.4

