Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113C8201B7D
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 21:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389877AbgFSTl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 15:41:26 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:5542 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389853AbgFSTl0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 15:41:26 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 19 Jun 2020 12:41:24 -0700
Received: from sc2-haas01-esx0118.eng.vmware.com (sc2-haas01-esx0118.eng.vmware.com [10.172.44.118])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 87C56B29F4;
        Fri, 19 Jun 2020 15:41:25 -0400 (EDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH] x86: pmu: fix failures on 32-bit due to wrong masks
Date:   Fri, 19 Jun 2020 12:39:09 -0700
Message-ID: <20200619193909.18949-1-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: namit@vmware.com does not
 designate permitted sender hosts)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some mask computation are using long constants instead of long long
constants, which causes test failures on x86-32.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/pmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 91a6fb4..5a3d55b 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -324,11 +324,11 @@ static void check_counter_overflow(void)
 
 		cnt.count = 1 - count;
 		if (gp_counter_base == MSR_IA32_PMC0)
-			cnt.count &= (1ul << eax.split.bit_width) - 1;
+			cnt.count &= (1ull << eax.split.bit_width) - 1;
 
 		if (i == num_counters) {
 			cnt.ctr = fixed_events[0].unit_sel;
-			cnt.count &= (1ul << edx.split.bit_width_fixed) - 1;
+			cnt.count &= (1ull << edx.split.bit_width_fixed) - 1;
 		}
 
 		if (i % 2)
@@ -456,7 +456,7 @@ static void check_running_counter_wrmsr(void)
 
 	count = -1;
 	if (gp_counter_base == MSR_IA32_PMC0)
-		count &= (1ul << eax.split.bit_width) - 1;
+		count &= (1ull << eax.split.bit_width) - 1;
 
 	wrmsr(gp_counter_base, count);
 
@@ -488,7 +488,7 @@ static void  check_gp_counters_write_width(void)
 {
 	u64 val_64 = 0xffffff0123456789ull;
 	u64 val_32 = val_64 & ((1ull << 32) - 1);
-	u64 val_max_width = val_64 & ((1ul << eax.split.bit_width) - 1);
+	u64 val_max_width = val_64 & ((1ull << eax.split.bit_width) - 1);
 	int i;
 
 	/*
-- 
2.20.1

