Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1339BC3147
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 12:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730462AbfJAKYG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 06:24:06 -0400
Received: from foss.arm.com ([217.140.110.172]:46070 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730577AbfJAKYG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 06:24:06 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 161821000;
        Tue,  1 Oct 2019 03:24:06 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D075C3F739;
        Tue,  1 Oct 2019 03:24:04 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, andre.przywara@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests RFC PATCH v2 19/19] arm64: timer: Run tests with VHE disabled
Date:   Tue,  1 Oct 2019 11:23:23 +0100
Message-Id: <20191001102323.27628-20-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001102323.27628-1-alexandru.elisei@arm.com>
References: <20191001102323.27628-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index faab671d0fb1..6b9d5d57a658 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -464,19 +464,34 @@ static void test_hptimer(void)
 	report_prefix_pop();
 }
 
-static void test_init(void)
+static void test_init(bool without_vhe)
 {
 	const struct fdt_property *prop;
 	const void *fdt = dt_fdt();
+	u64 hcr;
 	int node, len;
 	u32 *data;
 
+	if (without_vhe) {
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
+		if (without_vhe) {
+			vtimer = &vtimer_info;
+			ptimer = &ptimer_info;
+		} else {
+			vtimer = &vtimer_info_vhe;
+			ptimer = &ptimer_info_vhe;
+		}
 		hvtimer = &hvtimer_info;
 		hptimer = &hptimer_info;
 	}
@@ -563,10 +578,20 @@ static void print_timer_info(void)
 int main(int argc, char **argv)
 {
 	int i;
+	bool without_vhe = false;
 
 	current_el = current_level();
 
-	test_init();
+	if (argc > 1 && strcmp(argv[1], "nvhe") == 0) {
+		if (current_el == CurrentEL_EL1)
+			report_info("Skipping EL2 tests. Boot at EL2 to enable.");
+		else
+			without_vhe = true;
+		argv = &argv[1];
+		argc--;
+	}
+
+	test_init(without_vhe);
 
 	print_timer_info();
 
-- 
2.20.1

