Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725EA443F5F
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 10:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhKCJaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 05:30:07 -0400
Received: from mga12.intel.com ([192.55.52.136]:14899 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231435AbhKCJaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 05:30:06 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10156"; a="211515370"
X-IronPort-AV: E=Sophos;i="5.87,205,1631602800"; 
   d="scan'208";a="211515370"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 02:27:29 -0700
X-IronPort-AV: E=Sophos;i="5.87,205,1631602800"; 
   d="scan'208";a="500965438"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 02:27:28 -0700
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] x86: Two minor fixes to apic code
Date:   Wed,  3 Nov 2021 17:24:25 +0800
Message-Id: <20211103092425.7361-1-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Apicid isn't guaranteed to be consecutive or starting from BSP's.
But there are many codes depending on BSP's apicid are smallest
among others. This patch makes it works in any case.

Bumping active_cpus in smp_reset_apic() isn't correct as it is
already bumped in smp_init(). This can cause on_cpus() in dead loop.
Fix it by removing that bumping in smp_reset_apic().

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
---
 lib/x86/apic.c | 6 ++++++
 lib/x86/smp.c  | 2 --
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index da8f301..562b3ec 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -237,8 +237,14 @@ extern unsigned char online_cpus[(MAX_TEST_CPUS + 7) / 8];
 void init_apic_map(void)
 {
 	unsigned int i, j = 0;
+	u32 bsp_apicid = apic_id();
+
+	/* BSP's logical id is 0 */
+	id_map[j++] = bsp_apicid;
 
 	for (i = 0; i < MAX_TEST_CPUS; i++) {
+		if (i == bsp_apicid)
+			continue;
 		if ((1ul << (i % 8)) & (online_cpus[i / 8]))
 			id_map[j++] = i;
 	}
diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index 2ac0ef7..46d2630 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -143,6 +143,4 @@ void smp_reset_apic(void)
     reset_apic();
     for (i = 1; i < cpu_count(); ++i)
         on_cpu(i, do_reset_apic, 0);
-
-    atomic_inc(&active_cpus);
 }
-- 
2.25.1

