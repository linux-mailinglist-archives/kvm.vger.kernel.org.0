Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC421185886
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 03:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgCOCNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 22:13:40 -0400
Received: from mga14.intel.com ([192.55.52.115]:41895 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727740AbgCOCNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Mar 2020 22:13:38 -0400
IronPort-SDR: npGp+F9Wgxv+K+5FdaLHx6c5Q+wAKyWvtyTtvfJTUun6x16YUPTKjCU1Ld2kQmldZvAL/qmmEx
 B+j9u1bsgk1w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2020 00:52:00 -0700
IronPort-SDR: NqpETWF9PjHmdEwtXkD9iSSe6yB3S/7nAl9vxSwu7QqlFpCi5jPm2gjrrq1xiW4IW3rfMvdLvR
 NIABgARz6Yww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,551,1574150400"; 
   d="scan'208";a="416537556"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.160])
  by orsmga005.jf.intel.com with ESMTP; 14 Mar 2020 00:51:55 -0700
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
Subject: [PATCH v4 03/10] x86/split_lock: Re-define the kernel param option for split_lock_detect
Date:   Sat, 14 Mar 2020 15:34:07 +0800
Message-Id: <20200314073414.184213-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200314073414.184213-1-xiaoyao.li@intel.com>
References: <20200314073414.184213-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change sld_off to sld_disable, which means disabling feature split lock
detection and it cannot be used in kernel nor can kvm expose it guest.
Of course, the X86_FEATURE_SPLIT_LOCK_DETECT is not set.

Add a new optioin sld_kvm_only, which means kernel turns split lock
detection off, but kvm can expose it to guest.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 .../admin-guide/kernel-parameters.txt         |  5 ++++-
 arch/x86/kernel/cpu/intel.c                   | 22 ++++++++++++++-----
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 1ee2d1e6d89a..2b922061ff08 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4666,7 +4666,10 @@
 			instructions that access data across cache line
 			boundaries will result in an alignment check exception.
 
-			off	- not enabled
+			disable	- disabled, neither kernel nor kvm can use it.
+
+			kvm_only - off in kernel but kvm can expose it to
+				   guest for debug/testing scenario.
 
 			warn	- the kernel will emit rate limited warnings
 				  about applications triggering the #AC
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 4b3245035b5a..3eeab717a0d0 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -35,7 +35,8 @@
 
 enum split_lock_detect_state {
 	sld_not_exist = 0,
-	sld_off,
+	sld_disable,
+	sld_kvm_only,
 	sld_warn,
 	sld_fatal,
 };
@@ -973,7 +974,8 @@ static const struct {
 	const char			*option;
 	enum split_lock_detect_state	state;
 } sld_options[] __initconst = {
-	{ "off",	sld_off   },
+	{ "disable",	sld_disable },
+	{ "kvm_only",	sld_kvm_only },
 	{ "warn",	sld_warn  },
 	{ "fatal",	sld_fatal },
 };
@@ -1004,10 +1006,14 @@ static void __init split_lock_setup(void)
 	}
 
 	switch (sld_state) {
-	case sld_off:
+	case sld_disable:
 		pr_info("disabled\n");
 		break;
 
+	case sld_kvm_only:
+		pr_info("off in kernel, but kvm can expose it to guest\n");
+		break;
+
 	case sld_warn:
 		pr_info("warning about user-space split_locks\n");
 		break;
@@ -1062,7 +1068,13 @@ static void split_lock_init(struct cpuinfo_x86 *c)
 	test_ctrl_val = val;
 
 	switch (sld_state) {
-	case sld_off:
+	case sld_disable:
+		if (wrmsrl_safe(MSR_TEST_CTRL, test_ctrl_val & ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT))
+			goto msr_broken;
+		return;
+	case sld_kvm_only:
+		if (wrmsrl_safe(MSR_TEST_CTRL, test_ctrl_val | MSR_TEST_CTRL_SPLIT_LOCK_DETECT))
+			goto msr_broken;
 		if (wrmsrl_safe(MSR_TEST_CTRL, test_ctrl_val & ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT))
 			goto msr_broken;
 		break;
@@ -1087,7 +1099,7 @@ static void split_lock_init(struct cpuinfo_x86 *c)
 	 * funny things and you get to keep whatever pieces.
 	 */
 	pr_warn_once("MSR fail -- disabled\n");
-	sld_state = sld_off;
+	sld_state = sld_disable;
 }
 
 bool handle_user_split_lock(struct pt_regs *regs, long error_code)
-- 
2.20.1

