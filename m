Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB6D743BB
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 05:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389887AbfGYDMA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 23:12:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:24587 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389727AbfGYDLW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 23:11:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jul 2019 20:11:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,305,1559545200"; 
   d="scan'208";a="321537727"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga004.jf.intel.com with ESMTP; 24 Jul 2019 20:11:20 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, pbonzini@redhat.com
Cc:     mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v6 2/8] KVM: x86: Add a helper function for CPUID(0xD,n>=1) enumeration
Date:   Thu, 25 Jul 2019 11:12:40 +0800
Message-Id: <20190725031246.8296-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190725031246.8296-1-weijiang.yang@intel.com>
References: <20190725031246.8296-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To make the code look clean, wrap CPUID(0xD,n>=1) enumeration
code in a helper function now.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/cpuid.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 4992e7c99588..29cbde7538a3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -313,6 +313,50 @@ static int __do_cpuid_ent_emulated(struct kvm_cpuid_entry2 *entry,
 	return 0;
 }
 
+static inline int __do_cpuid_dx_leaf(struct kvm_cpuid_entry2 *entry, int *nent,
+				     int maxnent, u64 xss_mask, u64 xcr0_mask,
+				     u32 eax_mask)
+{
+	int idx, i;
+	u64 mask;
+	u64 supported;
+
+	for (idx = 1, i = 1; idx < 64; ++idx) {
+		mask = ((u64)1 << idx);
+		if (*nent >= maxnent)
+			return -EINVAL;
+
+		do_cpuid_1_ent(&entry[i], 0xD, idx);
+		if (idx == 1) {
+			entry[i].eax &= eax_mask;
+			cpuid_mask(&entry[i].eax, CPUID_D_1_EAX);
+			supported = xcr0_mask | xss_mask;
+			entry[i].ebx = 0;
+			entry[i].edx = 0;
+			entry[i].ecx &= xss_mask;
+			if (entry[i].eax & (F(XSAVES) | F(XSAVEC))) {
+				entry[i].ebx =
+					xstate_required_size(supported,
+							     true);
+			}
+		} else {
+			supported = (entry[i].ecx & 1) ? xss_mask :
+				     xcr0_mask;
+			if (entry[i].eax == 0 || !(supported & mask))
+				continue;
+			entry[i].ecx &= 1;
+			entry[i].edx = 0;
+			if (entry[i].ecx)
+				entry[i].ebx = 0;
+		}
+		entry[i].flags |=
+			KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+		++*nent;
+		++i;
+	}
+	return 0;
+}
+
 static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 				 u32 index, int *nent, int maxnent)
 {
-- 
2.17.2

