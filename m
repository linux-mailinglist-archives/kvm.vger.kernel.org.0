Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A45C176902
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgCCABg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 19:01:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:25520 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727306AbgCBX50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384662"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:22 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 13/66] KVM: x86: Consolidate CPUID array max num entries checking
Date:   Mon,  2 Mar 2020 15:56:16 -0800
Message-Id: <20200302235709.27467-14-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the nent vs. maxnent check and nent increment into do_host_cpuid()
to consolidate what is now identical code.  To signal success vs.
failure, return the entry and NULL respectively.  A future patch will
build on this to also move the entry retrieval into do_host_cpuid().

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 49 +++++++++++++++-----------------------------
 1 file changed, 17 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 52f0af4e10d5..1ae3b2502333 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -287,9 +287,14 @@ static __always_inline void cpuid_mask(u32 *word, int wordnum)
 	*word &= boot_cpu_data.x86_capability[wordnum];
 }
 
-static void do_host_cpuid(struct kvm_cpuid_entry2 *entry, u32 function,
-			   u32 index)
+static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_entry2 *entry,
+					      int *nent, int maxnent,
+					      u32 function, u32 index)
 {
+	if (*nent >= maxnent)
+		return NULL;
+	++*nent;
+
 	entry->function = function;
 	entry->index = index;
 	entry->flags = 0;
@@ -316,6 +321,8 @@ static void do_host_cpuid(struct kvm_cpuid_entry2 *entry, u32 function,
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		break;
 	}
+
+	return entry;
 }
 
 static int __do_cpuid_func_emulated(struct kvm_cpuid_entry2 *entry,
@@ -507,12 +514,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 
 	r = -E2BIG;
 
-	if (WARN_ON(*nent >= maxnent))
+	if (WARN_ON(!do_host_cpuid(entry, nent, maxnent, function, 0)))
 		goto out;
 
-	do_host_cpuid(entry, function, 0);
-	++*nent;
-
 	switch (function) {
 	case 0:
 		/* Limited to the highest leaf implemented in KVM. */
@@ -536,11 +540,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 
 		entry->flags |= KVM_CPUID_FLAG_STATE_READ_NEXT;
 		for (t = 1; t < times; ++t) {
-			if (*nent >= maxnent)
+			if (!do_host_cpuid(&entry[t], nent, maxnent, function, 0))
 				goto out;
-
-			do_host_cpuid(&entry[t], function, 0);
-			++*nent;
 		}
 		break;
 	}
@@ -555,10 +556,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 			if (!cache_type)
 				break;
 
-			if (*nent >= maxnent)
+			if (!do_host_cpuid(&entry[i], nent, maxnent, function, i))
 				goto out;
-			do_host_cpuid(&entry[i], function, i);
-			++*nent;
 		}
 		break;
 	}
@@ -575,12 +574,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		do_cpuid_7_mask(entry);
 
 		for (i = 1; i <= entry->eax; i++) {
-			if (*nent >= maxnent)
+			if (!do_host_cpuid(&entry[i], nent, maxnent, function, i))
 				goto out;
 
-			do_host_cpuid(&entry[i], function, i);
-			++*nent;
-
 			do_cpuid_7_mask(&entry[i]);
 		}
 		break;
@@ -633,11 +629,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		 * added entry is zero.
 		 */
 		for (i = 1; entry[i - 1].ecx & 0xff00; ++i) {
-			if (*nent >= maxnent)
+			if (!do_host_cpuid(&entry[i], nent, maxnent, function, i))
 				goto out;
-
-			do_host_cpuid(&entry[i], function, i);
-			++*nent;
 		}
 		break;
 	}
@@ -652,12 +645,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		if (!supported)
 			break;
 
-		if (*nent >= maxnent)
+		if (!do_host_cpuid(&entry[1], nent, maxnent, function, 1))
 			goto out;
 
-		do_host_cpuid(&entry[1], function, 1);
-		++*nent;
-
 		entry[1].eax &= kvm_cpuid_D_1_eax_x86_features;
 		cpuid_mask(&entry[1].eax, CPUID_D_1_EAX);
 		if (entry[1].eax & (F(XSAVES)|F(XSAVEC)))
@@ -672,12 +662,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 			if (!(supported & BIT_ULL(idx)))
 				continue;
 
-			if (*nent >= maxnent)
+			if (!do_host_cpuid(&entry[i], nent, maxnent, function, idx))
 				goto out;
 
-			do_host_cpuid(&entry[i], function, idx);
-			++*nent;
-
 			/*
 			 * The @supported check above should have filtered out
 			 * invalid sub-leafs as well as sub-leafs managed by
@@ -704,10 +691,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 			break;
 
 		for (t = 1; t <= times; ++t) {
-			if (*nent >= maxnent)
+			if (!do_host_cpuid(&entry[t], nent, maxnent, function, t))
 				goto out;
-			do_host_cpuid(&entry[t], function, t);
-			++*nent;
 		}
 		break;
 	}
-- 
2.24.1

