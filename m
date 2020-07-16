Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5542D221AA5
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 05:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgGPDQ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 23:16:59 -0400
Received: from mga06.intel.com ([134.134.136.31]:8147 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726770AbgGPDQ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 23:16:57 -0400
IronPort-SDR: sgQybs7i+MF/9gGXs6AlB2uLUlkxnLrZq1je4JpvisQxg2b1bIiC6NYCrDsV/Df+fezVtcu7dS
 owPl2ZVdnqUg==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="210844831"
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="210844831"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 20:16:57 -0700
IronPort-SDR: bTOUrYvWWf/ceKqf+FwF8rnI090LMkr1t4DERq+nqOYbHvnvacPhaBW+Uyy5H01tvck1+gY4QK
 6+W9weU20zsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="360910412"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga001.jf.intel.com with ESMTP; 15 Jul 2020 20:16:55 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [RESEND v13 01/11] KVM: x86: Include CET definitions for KVM test purpose
Date:   Thu, 16 Jul 2020 11:16:17 +0800
Message-Id: <20200716031627.11492-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200716031627.11492-1-weijiang.yang@intel.com>
References: <20200716031627.11492-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These definitions are added by CET kernel patch and referenced by KVM,
if the CET KVM patches are tested without CET kernel patches, this patch
should be included.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 include/linux/kvm_host.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d564855243d8..aae1775a29ac 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -35,6 +35,38 @@
 
 #include <asm/kvm_host.h>
 
+#ifndef CONFIG_X86_INTEL_CET
+#define XFEATURE_CET_USER   11
+#define XFEATURE_CET_KERNEL 12
+
+#define XFEATURE_MASK_CET_USER         (1 << XFEATURE_CET_USER)
+#define XFEATURE_MASK_CET_KERNEL       (1 << XFEATURE_CET_KERNEL)
+
+/* Control-flow Enforcement Technology MSRs */
+#define MSR_IA32_U_CET         0x6a0 /* user mode cet setting */
+#define MSR_IA32_S_CET         0x6a2 /* kernel mode cet setting */
+#define MSR_IA32_PL0_SSP       0x6a4 /* kernel shstk pointer */
+#define MSR_IA32_PL1_SSP       0x6a5 /* ring-1 shstk pointer */
+#define MSR_IA32_PL2_SSP       0x6a6 /* ring-2 shstk pointer */
+#define MSR_IA32_PL3_SSP       0x6a7 /* user shstk pointer */
+#define MSR_IA32_INT_SSP_TAB   0x6a8 /* exception shstk table */
+
+#define X86_CR4_CET_BIT        23 /* enable Control-flow Enforcement */
+#define X86_CR4_CET            _BITUL(X86_CR4_CET_BIT)
+
+#define X86_FEATURE_SHSTK      (16*32+ 7) /* Shadow Stack */
+#define X86_FEATURE_IBT        (18*32+20) /* Indirect Branch Tracking */
+
+/* MSR_IA32_U_CET and MSR_IA32_S_CET bits */
+#define MSR_IA32_CET_SHSTK_EN          0x0000000000000001ULL
+#define MSR_IA32_CET_WRSS_EN           0x0000000000000002ULL
+#define MSR_IA32_CET_ENDBR_EN          0x0000000000000004ULL
+#define MSR_IA32_CET_LEG_IW_EN         0x0000000000000008ULL
+#define MSR_IA32_CET_NO_TRACK_EN       0x0000000000000010ULL
+#define MSR_IA32_CET_WAIT_ENDBR        0x00000000000000800UL
+#define MSR_IA32_CET_BITMAP_MASK       0xfffffffffffff000ULL
+#endif
+
 #ifndef KVM_MAX_VCPU_ID
 #define KVM_MAX_VCPU_ID KVM_MAX_VCPUS
 #endif
-- 
2.17.2

