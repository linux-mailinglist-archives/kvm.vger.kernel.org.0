Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132FE1CBCB5
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 05:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgEIDD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 23:03:59 -0400
Received: from mga12.intel.com ([192.55.52.136]:55127 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728718AbgEIDD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 23:03:57 -0400
IronPort-SDR: 6vXjjzZfwAWo6AH0Zqhyntqwqy38ZTfpXgpPOh61vsZj708UkI2iyIAT4nAgqo6rBDxL+P+SIc
 dMwYBstv8ScQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 20:03:57 -0700
IronPort-SDR: IH3LtByqkiLmCjjX1nZJz2E2JCjchxKQZ7+/3LW8VOr8UgyRDKzILsAY+XQbuB5s3F1wZa3rVS
 bjGjBUsEVnWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,370,1583222400"; 
   d="scan'208";a="408311074"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga004.jf.intel.com with ESMTP; 08 May 2020 20:03:52 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>, peterz@infradead.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 5/8] x86/kvm: Introduce paravirt split lock detection enumeration
Date:   Sat,  9 May 2020 19:05:39 +0800
Message-Id: <20200509110542.8159-6-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200509110542.8159-1-xiaoyao.li@intel.com>
References: <20200509110542.8159-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce KVM_FEATURE_SPLIT_LOCK_DETECT, for which linux guest running
on KVM can enumerate the avaliablility of feature split lock detection.

Introduce KVM_HINTS_SLD_FATAL, which tells whether host is sld_fatal mode,
i.e., whether split lock detection is forced on for guest vcpu.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 Documentation/virt/kvm/cpuid.rst     | 29 ++++++++++++++++++++--------
 arch/x86/include/uapi/asm/kvm_para.h |  8 +++++---
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index 01b081f6e7ea..a7e85ac090a8 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -86,6 +86,12 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest checks this feature bit
                                               before using paravirtualized
                                               sched yield.
 
+KVM_FEATURE_SPLIT_LOCK_DETECT     14          guest checks this feature bit for
+                                              available of split lock detection.
+
+                                              KVM doesn't support enumerating
+					      split lock detection via CPU model
+
 KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                               per-cpu warps are expeced in
                                               kvmclock
@@ -97,11 +103,18 @@ KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
 
 Where ``flag`` here is defined as below:
 
-================== ============ =================================
-flag               value        meaning
-================== ============ =================================
-KVM_HINTS_REALTIME 0            guest checks this feature bit to
-                                determine that vCPUs are never
-                                preempted for an unlimited time
-                                allowing optimizations
-================== ============ =================================
+================================ ============ =================================
+flag                             value        meaning
+================================ ============ =================================
+KVM_HINTS_REALTIME               0            guest checks this feature bit to
+                                              determine that vCPUs are never
+                                              preempted for an unlimited time
+                                              allowing optimizations
+
+KVM_HINTS_SLD_FATAL              1            set if split lock detection is
+                                              forced on in the host, in which
+					      case KVM will kill the guest if it
+					      generates a split lock #AC with
+					      SLD disabled from guest's
+					      perspective
+================================ ============ =================================
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 2a8e0b6b9805..a8fe0221403a 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -31,14 +31,16 @@
 #define KVM_FEATURE_PV_SEND_IPI	11
 #define KVM_FEATURE_POLL_CONTROL	12
 #define KVM_FEATURE_PV_SCHED_YIELD	13
-
-#define KVM_HINTS_REALTIME      0
-
+#define KVM_FEATURE_SPLIT_LOCK_DETECT	14
 /* The last 8 bits are used to indicate how to interpret the flags field
  * in pvclock structure. If no bits are set, all flags are ignored.
  */
 #define KVM_FEATURE_CLOCKSOURCE_STABLE_BIT	24
 
+/* KVM feature hints in CPUID.0x40000001.EDX */
+#define KVM_HINTS_REALTIME	0
+#define KVM_HINTS_SLD_FATAL	1
+
 #define MSR_KVM_WALL_CLOCK  0x11
 #define MSR_KVM_SYSTEM_TIME 0x12
 
-- 
2.18.2

