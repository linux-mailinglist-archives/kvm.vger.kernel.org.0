Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6C6153F1F
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 08:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgBFHJa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 02:09:30 -0500
Received: from mga04.intel.com ([192.55.52.120]:56103 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbgBFHJ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 02:09:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 23:09:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,408,1574150400"; 
   d="scan'208";a="231957225"
Received: from lxy-dell.sh.intel.com ([10.239.13.109])
  by orsmga003.jf.intel.com with ESMTP; 05 Feb 2020 23:09:26 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>, tony.luck@intel.com
Cc:     peterz@infradead.org, fenghua.yu@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v3 3/8] x86/split_lock: Cache the value of MSR_TEST_CTRL in percpu data
Date:   Thu,  6 Feb 2020 15:04:07 +0800
Message-Id: <20200206070412.17400-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200206070412.17400-1-xiaoyao.li@intel.com>
References: <20200206070412.17400-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cache the value of MSR_TEST_CTRL in percpu data msr_test_ctrl_cache,
which will be used by KVM module.

It also avoids an expensive RDMSR instruction if SLD needs to be context
switched.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/include/asm/cpu.h  |  2 ++
 arch/x86/kernel/cpu/intel.c | 19 ++++++++++++-------
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index ff567afa6ee1..2b20829db450 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -27,6 +27,8 @@ struct x86_cpu {
 };
 
 #ifdef CONFIG_HOTPLUG_CPU
+DECLARE_PER_CPU(u64, msr_test_ctrl_cache);
+
 extern int arch_register_cpu(int num);
 extern void arch_unregister_cpu(int);
 extern void start_cpu0(void);
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 49535ed81c22..ff27d026cb4a 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -46,6 +46,9 @@ enum split_lock_detect_state {
  */
 static enum split_lock_detect_state sld_state = sld_off;
 
+DEFINE_PER_CPU(u64, msr_test_ctrl_cache);
+EXPORT_PER_CPU_SYMBOL_GPL(msr_test_ctrl_cache);
+
 /*
  * Processors which have self-snooping capability can handle conflicting
  * memory type across CPUs by snooping its own cache. However, there exists
@@ -1043,20 +1046,22 @@ static void __init split_lock_setup(void)
  */
 static void __sld_msr_set(bool on)
 {
-	u64 test_ctrl_val;
-
-	rdmsrl(MSR_TEST_CTRL, test_ctrl_val);
-
 	if (on)
-		test_ctrl_val |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
+		this_cpu_or(msr_test_ctrl_cache, MSR_TEST_CTRL_SPLIT_LOCK_DETECT);
 	else
-		test_ctrl_val &= ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
+		this_cpu_and(msr_test_ctrl_cache, ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT);
 
-	wrmsrl(MSR_TEST_CTRL, test_ctrl_val);
+	wrmsrl(MSR_TEST_CTRL, this_cpu_read(msr_test_ctrl_cache));
 }
 
 static void split_lock_init(void)
 {
+	u64 test_ctrl_val;
+
+	/* Cache MSR TEST_CTRL */
+	rdmsrl(MSR_TEST_CTRL, test_ctrl_val);
+	this_cpu_write(msr_test_ctrl_cache, test_ctrl_val);
+
 	if (sld_state == sld_off)
 		return;
 
-- 
2.23.0

