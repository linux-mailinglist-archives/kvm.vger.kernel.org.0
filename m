Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B233746BFBA
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239041AbhLGPu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:50:26 -0500
Received: from foss.arm.com ([217.140.110.172]:35216 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238505AbhLGPuZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:50:25 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3422D13A1;
        Tue,  7 Dec 2021 07:46:55 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 717773F5A1;
        Tue,  7 Dec 2021 07:46:54 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH 1/4] arm: timer: Fix TVAL comparison for timer condition met
Date:   Tue,  7 Dec 2021 15:46:38 +0000
Message-Id: <20211207154641.87740-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211207154641.87740-1-alexandru.elisei@arm.com>
References: <20211207154641.87740-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ARM DDI 0487G.a states on page D13-4180 that, when the virtual timer is
enabled, the timer condition is met when CNTVCT_EL0 - CNTV_CVAL_EL0 >= 0.
Multiplying both sides of the inequality by -1, we get the equivalent
condition CNTV_CVAL_EL0 - CNTVCT_EL0 <= 0 for when the timer should fire.

On the same page, it states that a read of the CNTV_TVAL_EL0 register
returns CNTV_CVAL_EL0 - CNTVCT_EL0 if the virtual timer is enabled.
Putting the two together, the timer condition is met when the value of the
TVAL register is less than or *equal* to 0.

Same rules apply for the physical timer.

Fix the check for the timer expiring by treating a TVAL value equal to zero
as a valid condition for the timer to fire.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/timer.c b/arm/timer.c
index 09e3f8f6bd7d..2a6687f22874 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -277,7 +277,7 @@ static void test_timer(struct timer_info *info)
 	local_irq_enable();
 	left = info->read_tval();
 	report(info->irq_received, "interrupt received after TVAL/WFI");
-	report(left < 0, "timer has expired");
+	report(left <= 0, "timer has expired");
 	report_info("TVAL is %d ticks", left);
 }
 
-- 
2.34.1

