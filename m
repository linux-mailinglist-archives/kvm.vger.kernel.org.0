Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D944249531
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 08:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgHSGrx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 02:47:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:36140 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbgHSGrn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 02:47:43 -0400
IronPort-SDR: YBoeRPkGjZux8V0MHK7tj89aAv8c0zD3+JvpG8MI0mwRgH0ha/u8nPOBm6IOYY+YjWh1JJ3wJX
 O1UYFIUkApiw==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="142873197"
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="142873197"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 23:47:30 -0700
IronPort-SDR: DD97qbrvMvnfMCugtvSOmZmm9sp1gG4VsnSOomXd7F2wkMw6M3wbDm8ufM/xfhizT/eopAgHhh
 CM4wDhAuBy1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="310679295"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga002.jf.intel.com with ESMTP; 18 Aug 2020 23:47:26 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>, peterz@infradead.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v10 5/9] x86/kvm: Introduce paravirt split lock detection enumeration
Date:   Wed, 19 Aug 2020 14:47:03 +0800
Message-Id: <20200819064707.1033569-6-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200819064707.1033569-1-xiaoyao.li@intel.com>
References: <20200819064707.1033569-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce KVM_FEATURE_SPLIT_LOCK_DETECT, with which guests running
on KVM can enumerate the avaliablility of feature split lock detection.

Introduce KVM_HINTS_SLD_FATAL, which tells whether host is sld_fatal mode,
i.e., whether split lock detection is forced on for guest vcpu.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 Documentation/virt/kvm/cpuid.rst     | 29 ++++++++++++++++++++--------
 arch/x86/include/uapi/asm/kvm_para.h |  8 +++++---
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index a7dff9186bed..c214f1c70703 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -92,6 +92,12 @@ KVM_FEATURE_ASYNC_PF_INT          14          guest checks this feature bit
                                               async pf acknowledgment msr
                                               0x4b564d07.
 
+KVM_FEATURE_SPLIT_LOCK_DETECT     15          guest checks this feature bit for
+                                              available of split lock detection.
+
+                                              KVM doesn't support enumerating
+					      split lock detection via CPU model
+
 KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                               per-cpu warps are expeced in
                                               kvmclock
@@ -103,11 +109,18 @@ KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
 
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
index 812e9b4c1114..328ddfaacd7b 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -32,14 +32,16 @@
 #define KVM_FEATURE_POLL_CONTROL	12
 #define KVM_FEATURE_PV_SCHED_YIELD	13
 #define KVM_FEATURE_ASYNC_PF_INT	14
-
-#define KVM_HINTS_REALTIME      0
-
+#define KVM_FEATURE_SPLIT_LOCK_DETECT	15
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
2.18.4

