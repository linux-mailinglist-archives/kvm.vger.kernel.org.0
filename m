Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F8218589A
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 03:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgCOCOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 22:14:24 -0400
Received: from mga14.intel.com ([192.55.52.115]:41895 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727735AbgCOCNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Mar 2020 22:13:38 -0400
IronPort-SDR: 8e8FIJ24Dzk4cpFyuHm3hy/CunTSuXhjbwEymkE68PzLvc/6v18+eC05K6luOSfws0pjOq+pbv
 T9HwKN8YQiCg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2020 00:51:55 -0700
IronPort-SDR: xFLMCsQOnVowPuCzZ86YJndKxfljywKlb7iR1Vj3Q0MbySU6B2XW7r8HjrUygPy8rzC5TSMUgn
 JercIOJwz/2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,551,1574150400"; 
   d="scan'208";a="416537546"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.160])
  by orsmga005.jf.intel.com with ESMTP; 14 Mar 2020 00:51:51 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>, tony.luck@intel.com
Cc:     peterz@infradead.org, fenghua.yu@intel.com,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v4 02/10] x86/split_lock: Avoid runtime reads of the TEST_CTRL MSR
Date:   Sat, 14 Mar 2020 15:34:06 +0800
Message-Id: <20200314073414.184213-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200314073414.184213-1-xiaoyao.li@intel.com>
References: <20200314073414.184213-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In a context switch from a task that is detecting split locks
to one that is not (or vice versa) we need to update the TEST_CTRL
MSR. Currently this is done with the common sequence:
	read the MSR
	flip the bit
	write the MSR
in order to avoid changing the value of any reserved bits in the MSR.

Cache the value of the TEST_CTRL MSR when we read it during initialization
so we can avoid an expensive RDMSR instruction during context switch.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Originally-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kernel/cpu/intel.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 064ba12defc8..4b3245035b5a 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1020,6 +1020,14 @@ static void __init split_lock_setup(void)
 	}
 }
 
+/*
+ * Soft copy of MSR_TEST_CTRL initialized when we first read the
+ * MSR. Used at runtime to avoid using rdmsr again just to collect
+ * the reserved bits in the MSR. We assume reserved bits are the
+ * same on all CPUs.
+ */
+static u64 test_ctrl_val;
+
 /*
  * Locking is not required at the moment because only bit 29 of this
  * MSR is implemented and locking would not prevent that the operation
@@ -1027,16 +1035,14 @@ static void __init split_lock_setup(void)
  */
 static void __sld_msr_set(bool on)
 {
-	u64 test_ctrl_val;
-
-	rdmsrl(MSR_TEST_CTRL, test_ctrl_val);
+	u64 val = test_ctrl_val;
 
 	if (on)
-		test_ctrl_val |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
+		val |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
 	else
-		test_ctrl_val &= ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
+		val &= ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
 
-	wrmsrl(MSR_TEST_CTRL, test_ctrl_val);
+	wrmsrl(MSR_TEST_CTRL, val);
 }
 
 /*
@@ -1048,11 +1054,13 @@ static void __sld_msr_set(bool on)
  */
 static void split_lock_init(struct cpuinfo_x86 *c)
 {
-	u64 test_ctrl_val;
+	u64 val;
 
-	if (rdmsrl_safe(MSR_TEST_CTRL, &test_ctrl_val))
+	if (rdmsrl_safe(MSR_TEST_CTRL, &val))
 		goto msr_broken;
 
+	test_ctrl_val = val;
+
 	switch (sld_state) {
 	case sld_off:
 		if (wrmsrl_safe(MSR_TEST_CTRL, test_ctrl_val & ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT))
-- 
2.20.1

