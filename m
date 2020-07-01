Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D972A2105C3
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 10:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbgGAIEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 04:04:25 -0400
Received: from mga14.intel.com ([192.55.52.115]:2413 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728420AbgGAIEY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 04:04:24 -0400
IronPort-SDR: EQuRO9IEuwjQqllaAo0u+uUjjoZfwcgp52vqoPoVMX8oqhbrYe79sNt8mksF++NHyJgVo8EYI5
 WmnqunQQTcGw==
X-IronPort-AV: E=McAfee;i="6000,8403,9668"; a="145581826"
X-IronPort-AV: E=Sophos;i="5.75,299,1589266800"; 
   d="scan'208";a="145581826"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 01:04:14 -0700
IronPort-SDR: mzze7toC3jy/njNgD0C5r2G7i7KN51Ncg/FUIQJ/VGZLtwgf3uyD8GtUFiz6aPiEgjP8/S09q3
 KHo7FeAbZ1zA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,299,1589266800"; 
   d="scan'208";a="455010225"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga005.jf.intel.com with ESMTP; 01 Jul 2020 01:04:12 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v13 01/11] KVM: x86: Include CET definitions for KVM test purpose
Date:   Wed,  1 Jul 2020 16:04:01 +0800
Message-Id: <20200701080411.5802-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200701080411.5802-1-weijiang.yang@intel.com>
References: <20200701080411.5802-1-weijiang.yang@intel.com>
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
index 01276e3d01b9..20e0fe70d3f7 100644
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

