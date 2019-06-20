Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B60AC4CCBE
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 13:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731491AbfFTLSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 07:18:05 -0400
Received: from mga07.intel.com ([134.134.136.100]:23975 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbfFTLSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 07:18:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 04:18:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,396,1557212400"; 
   d="scan'208";a="311627980"
Received: from liujing-dell.bj.intel.com ([10.238.145.70])
  by orsmga004.jf.intel.com with ESMTP; 20 Jun 2019 04:18:01 -0700
From:   Jing Liu <jing2.liu@linux.intel.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jing2.liu@intel.com,
        jing2.liu@linux.intel.com
Subject: [PATCH RFC] kvm: x86: Expose AVX512_BF16 feature to guest
Date:   Thu, 20 Jun 2019 19:21:52 +0800
Message-Id: <1561029712-11848-2-git-send-email-jing2.liu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1561029712-11848-1-git-send-email-jing2.liu@linux.intel.com>
References: <1561029712-11848-1-git-send-email-jing2.liu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AVX512 BFLOAT16 instructions support 16-bit BFLOAT16 floating-point
format (BF16) for deep learning optimization.

Intel adds AVX512 BFLOAT16 feature in CooperLake, which is CPUID.7.1.EAX[5].

Detailed information of the CPUID bit can be found here,
https://software.intel.com/sites/default/files/managed/c5/15/\
architecture-instruction-set-extensions-programming-reference.pdf.

Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e18a9f9..10be53f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -484,6 +484,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		entry->edx = 0;
 		break;
 	case 7: {
+		int i, times = entry->eax;
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		/* Mask ebx against host capability word 9 */
 		if (index == 0) {
@@ -507,12 +508,23 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			 * if the host doesn't support it.
 			 */
 			entry->edx |= F(ARCH_CAPABILITIES);
-		} else {
+		} else if (index > times) {
+			entry->eax = 0;
 			entry->ebx = 0;
 			entry->ecx = 0;
 			entry->edx = 0;
 		}
-		entry->eax = 0;
+		for (i = 1; i <= times; i++) {
+			if (*nent >= maxnent)
+				goto out;
+			do_cpuid_1_ent(&entry[i], function, i);
+			entry[i].eax &= F(AVX512_BF16);
+			entry[i].ebx = 0;
+			entry[i].ecx = 0;
+			entry[i].edx = 0;
+			entry[i].flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+			++*nent;
+		}
 		break;
 	}
 	case 9:
-- 
1.8.3.1

