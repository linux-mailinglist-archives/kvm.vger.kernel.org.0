Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E35D1914DB
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 16:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgCXPhR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 11:37:17 -0400
Received: from mga05.intel.com ([192.55.52.43]:40198 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728502AbgCXPhO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 11:37:14 -0400
IronPort-SDR: WPyC0Du9Hnh7fNXWF29CLNN7SHTTXeR7Vcyo+TwlQF2OjxU9J1GNRR9kzdbDjqpJ/RkFiKX0Lv
 hTpyNNYWz10A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 08:37:14 -0700
IronPort-SDR: Z3bZaKdqfunIyJk74jB0FrpvptjSnU2+HOWLUfYCXXFuh1UV3+2PEqolDTZCLHfRvYRvF7YMfh
 XQsjcPNts3Kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,300,1580803200"; 
   d="scan'208";a="393319690"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.39])
  by orsmga004.jf.intel.com with ESMTP; 24 Mar 2020 08:37:10 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v6 2/8] x86/split_lock: Avoid runtime reads of the TEST_CTRL MSR
Date:   Tue, 24 Mar 2020 23:18:53 +0800
Message-Id: <20200324151859.31068-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324151859.31068-1-xiaoyao.li@intel.com>
References: <20200324151859.31068-1-xiaoyao.li@intel.com>
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

Cache unused and reserved bits of TEST_CTRL MSR with SPLIT_LOCK_DETECT
bit cleared during initialization, so we can avoid an expensive RDMSR
instruction during context switch.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Originally-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kernel/cpu/intel.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index a0a7d0ec170a..553b5855c32b 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -45,6 +45,7 @@ enum split_lock_detect_state {
  * split lock detect, unless there is a command line override.
  */
 static enum split_lock_detect_state sld_state __ro_after_init = sld_off;
+static u64 msr_test_ctrl_cache __ro_after_init;
 
 /*
  * Processors which have self-snooping capability can handle conflicting
@@ -1037,6 +1038,8 @@ static void __init split_lock_setup(void)
 		break;
 	}
 
+	rdmsrl(MSR_TEST_CTRL, msr_test_ctrl_cache);
+
 	if (!split_lock_verify_msr(true)) {
 		pr_info("MSR access failed: Disabled\n");
 		return;
@@ -1053,14 +1056,10 @@ static void __init split_lock_setup(void)
  */
 static void sld_update_msr(bool on)
 {
-	u64 test_ctrl_val;
-
-	rdmsrl(MSR_TEST_CTRL, test_ctrl_val);
+	u64 test_ctrl_val = msr_test_ctrl_cache;
 
 	if (on)
 		test_ctrl_val |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
-	else
-		test_ctrl_val &= ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
 
 	wrmsrl(MSR_TEST_CTRL, test_ctrl_val);
 }
-- 
2.20.1

