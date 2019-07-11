Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5045C65182
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 07:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbfGKFo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 01:44:27 -0400
Received: from mga17.intel.com ([192.55.52.151]:64295 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbfGKFo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 01:44:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 22:44:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,476,1557212400"; 
   d="scan'208";a="167929709"
Received: from liujing-dell.bj.intel.com ([10.238.145.70])
  by fmsmga007.fm.intel.com with ESMTP; 10 Jul 2019 22:44:25 -0700
From:   Jing Liu <jing2.liu@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@linux.intel.com>
Subject: [PATCH v1] KVM: x86: expose AVX512_BF16 feature to guest
Date:   Thu, 11 Jul 2019 13:49:57 +0800
Message-Id: <1562824197-13658-1-git-send-email-jing2.liu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
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

This patch depends on kernel patch https://lkml.org/lkml/2019/6/19/912
and Paolo's patch set https://lkml.org/lkml/2019/7/4/468.

 arch/x86/kvm/cpuid.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8fc6039..0c125dd 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -358,9 +358,13 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
 		F(MD_CLEAR);
 
+	/* cpuid 7.1.eax */
+	const u32 kvm_cpuid_7_1_eax_x86_features =
+		F(AVX512_BF16);
+
 	switch (index) {
 	case 0:
-		entry->eax = 0;
+		entry->eax = min(entry->eax, 1);
 		entry->ebx &= kvm_cpuid_7_0_ebx_x86_features;
 		cpuid_mask(&entry->ebx, CPUID_7_0_EBX);
 		/* TSC_ADJUST is emulated */
@@ -384,6 +388,12 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 		 */
 		entry->edx |= F(ARCH_CAPABILITIES);
 		break;
+	case 1:
+		entry->eax &= kvm_cpuid_7_1_eax_x86_features;
+		entry->ebx = 0;
+		entry->ecx = 0;
+		entry->edx = 0;
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		entry->eax = 0;
-- 
1.8.3.1

