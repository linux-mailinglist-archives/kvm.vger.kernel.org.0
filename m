Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7950D4AE41
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 00:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731160AbfFRWwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 18:52:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:2939 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730850AbfFRWvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 18:51:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 15:51:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,390,1557212400"; 
   d="scan'208";a="358009362"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga005.fm.intel.com with ESMTP; 18 Jun 2019 15:51:11 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Radim Krcmar" <rkrcmar@redhat.com>,
        "Christopherson Sean J" <sean.j.christopherson@intel.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Dan Williams" <dan.j.williams@intel.com>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Sai Praneeth Prakhya" <sai.praneeth.prakhya@intel.com>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>
Cc:     "linux-kernel" <linux-kernel@vger.kernel.org>,
        "x86" <x86@kernel.org>, kvm@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v9 07/17] x86/split_lock: Enumerate split lock detection on Icelake mobile processor
Date:   Tue, 18 Jun 2019 15:41:09 -0700
Message-Id: <1560897679-228028-8-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Icelake mobile processor can detect split lock operations although
the processor doesn't have MSR IA32_CORE_CAP and split lock
detection bit in the MSR. Set split lock detection feature bit
X86_FEATURE_SPLIT_LOCK_DETECT on the processor based on its
family/model/stepping.

In the future, a few other processors may also have the split lock
detection feature but don't have MSR IA32_CORE_CAP. The feature
will be enumerated on those processors once their family/model/stepping
information is released.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/cpu/intel.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index d63a4ba203e1..7ae6cc22657d 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1005,8 +1005,18 @@ void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
 {
 	u64 ia32_core_cap = 0;
 
-	if (!cpu_has(c, X86_FEATURE_CORE_CAPABILITY))
+	if (!cpu_has(c, X86_FEATURE_CORE_CAPABILITY)) {
+		/*
+		 * The following processors have split lock detection feature.
+		 * But since they don't have MSR IA32_CORE_CAP, the
+		 * feature cannot be enumerated by the MSR. So enumerate the
+		 * feature by family/model/stepping.
+		 */
+		if (c->x86 == 6 && c->x86_model == INTEL_FAM6_ICELAKE_MOBILE)
+			split_lock_setup();
+
 		return;
+	}
 
 	/*
 	 * If MSR_IA32_CORE_CAP exists, enumerate features that are
-- 
2.19.1

