Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C172814F9F2
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgBAS4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:56:31 -0500
Received: from mga05.intel.com ([192.55.52.43]:37509 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726992AbgBASw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075471"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 01 Feb 2020 10:52:25 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/61] KVM: x86: Hoist loop counter and terminator to top of __do_cpuid_func()
Date:   Sat,  1 Feb 2020 10:51:31 -0800
Message-Id: <20200201185218.24473-15-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Declare "i" and "max_idx" at the top of __do_cpuid_func() to consolidate
a handful of declarations in various case statements.

More importantly, establish the pattern of using max_idx instead of e.g.
entry->eax as the loop terminator in preparation for refactoring how
entry is handled in __do_cpuid_func().

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 37 +++++++++++++------------------------
 1 file changed, 13 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 1ae3b2502333..5044a595799f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -439,7 +439,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
 static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 				  int *nent, int maxnent)
 {
-	int r;
+	int r, i, max_idx;
 	unsigned f_nx = is_efer_nx() ? F(NX) : 0;
 #ifdef CONFIG_X86_64
 	unsigned f_gbpages = (kvm_x86_ops->get_lpage_level() == PT_PDPE_LEVEL)
@@ -535,20 +535,18 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 	 * may return different values. This forces us to get_cpu() before
 	 * issuing the first command, and also to emulate this annoying behavior
 	 * in kvm_emulate_cpuid() using KVM_CPUID_FLAG_STATE_READ_NEXT */
-	case 2: {
-		int t, times = entry->eax & 0xff;
-
+	case 2:
 		entry->flags |= KVM_CPUID_FLAG_STATE_READ_NEXT;
-		for (t = 1; t < times; ++t) {
-			if (!do_host_cpuid(&entry[t], nent, maxnent, function, 0))
+
+		for (i = 1, max_idx = entry->eax & 0xff; i < max_idx; ++i) {
+			if (!do_host_cpuid(&entry[i], nent, maxnent, function, 0))
 				goto out;
 		}
 		break;
-	}
 	/* functions 4 and 0x8000001d have additional index. */
 	case 4:
 	case 0x8000001d: {
-		int i, cache_type;
+		int cache_type;
 
 		/* read more entries until cache_type is zero */
 		for (i = 1; ; ++i) {
@@ -568,19 +566,16 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		entry->edx = 0;
 		break;
 	/* function 7 has additional index. */
-	case 7: {
-		int i;
-
+	case 7:
 		do_cpuid_7_mask(entry);
 
-		for (i = 1; i <= entry->eax; i++) {
+		for (i = 1, max_idx = entry->eax; i <= max_idx; i++) {
 			if (!do_host_cpuid(&entry[i], nent, maxnent, function, i))
 				goto out;
 
 			do_cpuid_7_mask(&entry[i]);
 		}
 		break;
-	}
 	case 9:
 		break;
 	case 0xa: { /* Architectural Performance Monitoring */
@@ -617,9 +612,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 	 * thus they can be handled by common code.
 	 */
 	case 0x1f:
-	case 0xb: {
-		int i;
-
+	case 0xb:
 		/*
 		 * We filled in entry[0] for CPUID(EAX=<function>,
 		 * ECX=00H) above.  If its level type (ECX[15:8]) is
@@ -633,9 +626,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 				goto out;
 		}
 		break;
-	}
 	case 0xd: {
-		int idx, i;
+		int idx;
 		u64 supported = kvm_supported_xcr0();
 
 		entry->eax &= supported;
@@ -684,18 +676,15 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		break;
 	}
 	/* Intel PT */
-	case 0x14: {
-		int t, times = entry->eax;
-
+	case 0x14:
 		if (!f_intel_pt)
 			break;
 
-		for (t = 1; t <= times; ++t) {
-			if (!do_host_cpuid(&entry[t], nent, maxnent, function, t))
+		for (i = 1, max_idx = entry->eax; i <= max_idx; ++i) {
+			if (!do_host_cpuid(&entry[i], nent, maxnent, function, i))
 				goto out;
 		}
 		break;
-	}
 	case KVM_CPUID_SIGNATURE: {
 		static const char signature[12] = "KVMKVMKVM\0\0";
 		const u32 *sigptr = (const u32 *)signature;
-- 
2.24.1

