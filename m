Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1B14AE88A
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 12:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbfIJKmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 06:42:24 -0400
Received: from mga04.intel.com ([192.55.52.120]:64085 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbfIJKmY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 06:42:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 03:42:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="196512145"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.44])
  by orsmga002.jf.intel.com with ESMTP; 10 Sep 2019 03:42:22 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: CPUID: Check limit first when emulating CPUID instruction
Date:   Tue, 10 Sep 2019 18:27:41 +0800
Message-Id: <20190910102742.47729-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190910102742.47729-1-xiaoyao.li@intel.com>
References: <20190910102742.47729-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When limit checking is required, it should be executed first, which is
consistent with the CPUID specification.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
v2:
  - correctly set entry_found in no limit checking case.

---
 arch/x86/kvm/cpuid.c | 51 ++++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 22c2720cd948..67fa44ab87af 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -952,23 +952,36 @@ struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
 
 /*
- * If no match is found, check whether we exceed the vCPU's limit
- * and return the content of the highest valid _standard_ leaf instead.
- * This is to satisfy the CPUID specification.
+ * Based on CPUID specification, if leaf number exceeds the vCPU's limit,
+ * it should return the content of the highest valid _standard_ leaf instead.
+ * Note: *found is set true only means the queried leaf number doesn't exceed
+ * the maximum leaf number of basic or extented leaf.
  */
-static struct kvm_cpuid_entry2* check_cpuid_limit(struct kvm_vcpu *vcpu,
-                                                  u32 function, u32 index)
+static struct kvm_cpuid_entry2* cpuid_check_limit(struct kvm_vcpu *vcpu,
+                                                  u32 function, u32 index,
+						  bool *found)
 {
 	struct kvm_cpuid_entry2 *maxlevel;
 
+	if (found)
+		*found = false;
+
 	maxlevel = kvm_find_cpuid_entry(vcpu, function & 0x80000000, 0);
-	if (!maxlevel || maxlevel->eax >= function)
+	if (!maxlevel)
 		return NULL;
-	if (function & 0x80000000) {
-		maxlevel = kvm_find_cpuid_entry(vcpu, 0, 0);
-		if (!maxlevel)
-			return NULL;
+
+	if (maxlevel->eax >= function) {
+		if (found)
+			*found = true;
+		return kvm_find_cpuid_entry(vcpu, function, index);
 	}
+
+	if (function & 0x80000000)
+		maxlevel = kvm_find_cpuid_entry(vcpu, 0, 0);
+
+	if (!maxlevel)
+		return NULL;
+
 	return kvm_find_cpuid_entry(vcpu, maxlevel->eax, index);
 }
 
@@ -979,24 +992,20 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 	struct kvm_cpuid_entry2 *best;
 	bool entry_found = true;
 
-	best = kvm_find_cpuid_entry(vcpu, function, index);
-
-	if (!best) {
-		entry_found = false;
-		if (!check_limit)
-			goto out;
-
-		best = check_cpuid_limit(vcpu, function, index);
-	}
+	if (check_limit)
+		best = cpuid_check_limit(vcpu, function, index, &entry_found);
+	else
+		best = kvm_find_cpuid_entry(vcpu, function, index);
 
-out:
 	if (best) {
 		*eax = best->eax;
 		*ebx = best->ebx;
 		*ecx = best->ecx;
 		*edx = best->edx;
-	} else
+	} else {
+		entry_found = false;
 		*eax = *ebx = *ecx = *edx = 0;
+	}
 	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, entry_found);
 	return entry_found;
 }
-- 
2.19.1

