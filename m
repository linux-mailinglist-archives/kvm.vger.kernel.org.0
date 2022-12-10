Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5C6648FAE
	for <lists+kvm@lfdr.de>; Sat, 10 Dec 2022 17:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiLJQS4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Dec 2022 11:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiLJQSx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Dec 2022 11:18:53 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F431837A;
        Sat, 10 Dec 2022 08:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670689132; x=1702225132;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+MOSPWIOY6Qewya/GY6hl3SXr1wDBdrmlGizJkgTazI=;
  b=WErpQeHG6JA2aMAgm1Wmy9JFBz4BpIE1inom/bY6CUm75BP0q4mEsZfH
   66YlsgCKSzw0LizUIT89S4CHmdCx87cng8c7Th9JJr1+H2C7ORcbcgaVY
   6cGWS32m76lnjtQAJg2I/+Hs5zMX7diUTKaIrM4dXvtIpdXwTLCFP0BXx
   cdibTRSmIzNgIJNtfNK6htB1WrvnPtULrrBEvgLOPMB/YN3R+mgPFWWyU
   x2j19+E2r6LuVnOH6lgpEjEn/n4141MnzVZiv3hIHFOwGCzq2ROp81DLF
   L9AAWtZFgqN3X3h3SYGH5GOPNb8Ix8HUVO8g8PneW3noBaIW7TDQUfu5q
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10557"; a="318780419"
X-IronPort-AV: E=Sophos;i="5.96,234,1665471600"; 
   d="scan'208";a="318780419"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2022 08:18:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10557"; a="711208616"
X-IronPort-AV: E=Sophos;i="5.96,234,1665471600"; 
   d="scan'208";a="711208616"
Received: from unknown (HELO localhost.localdomain) ([10.239.161.133])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2022 08:18:49 -0800
From:   Zhang Chen <chen.zhang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Zhang Chen <chen.zhang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 1/9] x86/speculation: Introduce Intel SPEC_CTRL BHI related definition
Date:   Sun, 11 Dec 2022 00:00:38 +0800
Message-Id: <20221210160046.2608762-2-chen.zhang@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221210160046.2608762-1-chen.zhang@intel.com>
References: <20221210160046.2608762-1-chen.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define BHI_NO bit and new control of BHI hardware mitigation in
IA32_SPEC_CTRL. These definitions are used by following KVM patches
to determine whether to enforce BHI hardware mitigiations for
guests transparently.

BHI_NO means the processor isn't vulnernable to BHI attacks. BHI_DIS_S
is a new indirect predictor control. Once enabled, BHI_DIS_S prevents
predicted targets of indirect branches executed in CPL0/1/2 from being
selected based on branch history from branches executed in CPL3.
While set in the VMX root, it also prevents predicted targets executed
in CPL0 from being selected based on branch history from branches
executed in a VMX non-root.

Branch History Injection (BHI) describes a specific form of intra-mode
BTI, where an attacker may manipulate branch history before transitioning
from user to supervisor mode (or from VMX non-root/guest to root mode)
in an effort to cause an indirect branch predictor to select a specific
predictor entry for an indirect branch, and a disclosure gadget at the
predicted target will transiently execute. This may be possible since
the relevant branch history may contain branches taken in previous
security contexts, and in particular, in other predictor modes.

Refer to below link for more information:
https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/branch-history-injection.html

Signed-off-by: Zhang Chen <chen.zhang@intel.com>
---
 arch/x86/include/asm/msr-index.h       | 6 ++++++
 tools/arch/x86/include/asm/msr-index.h | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 4a2af82553e4..1143ac9400c3 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -53,6 +53,8 @@
 #define SPEC_CTRL_SSBD			BIT(SPEC_CTRL_SSBD_SHIFT)	/* Speculative Store Bypass Disable */
 #define SPEC_CTRL_RRSBA_DIS_S_SHIFT	6	   /* Disable RRSBA behavior */
 #define SPEC_CTRL_RRSBA_DIS_S		BIT(SPEC_CTRL_RRSBA_DIS_S_SHIFT)
+#define SPEC_CTRL_BHI_DIS_S_SHIFT	10	   /* Enable BHI_DIS_S behavior */
+#define SPEC_CTRL_BHI_DIS_S		BIT(SPEC_CTRL_BHI_DIS_S_SHIFT)
 
 #define MSR_IA32_PRED_CMD		0x00000049 /* Prediction Command */
 #define PRED_CMD_IBPB			BIT(0)	   /* Indirect Branch Prediction Barrier */
@@ -150,6 +152,10 @@
 						 * are restricted to targets in
 						 * kernel.
 						 */
+#define ARCH_CAP_BHI_NO			BIT(20)	/*
+						 * Not susceptible to Branch History
+						 * Injection.
+						 */
 #define ARCH_CAP_PBRSB_NO		BIT(24)	/*
 						 * Not susceptible to Post-Barrier
 						 * Return Stack Buffer Predictions.
diff --git a/tools/arch/x86/include/asm/msr-index.h b/tools/arch/x86/include/asm/msr-index.h
index f17ade084720..aed18b76dee0 100644
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -53,6 +53,8 @@
 #define SPEC_CTRL_SSBD			BIT(SPEC_CTRL_SSBD_SHIFT)	/* Speculative Store Bypass Disable */
 #define SPEC_CTRL_RRSBA_DIS_S_SHIFT	6	   /* Disable RRSBA behavior */
 #define SPEC_CTRL_RRSBA_DIS_S		BIT(SPEC_CTRL_RRSBA_DIS_S_SHIFT)
+#define SPEC_CTRL_BHI_DIS_S_SHIFT	10         /* Enable BHI_DIS_S behavior */
+#define SPEC_CTRL_BHI_DIS_S		BIT(SPEC_CTRL_BHI_DIS_S_SHIFT)
 
 #define MSR_IA32_PRED_CMD		0x00000049 /* Prediction Command */
 #define PRED_CMD_IBPB			BIT(0)	   /* Indirect Branch Prediction Barrier */
@@ -150,6 +152,10 @@
 						 * are restricted to targets in
 						 * kernel.
 						 */
+#define ARCH_CAP_BHI_NO			BIT(20) /*
+						 * Not susceptible to Branch History
+						 * Injection.
+						 */
 #define ARCH_CAP_PBRSB_NO		BIT(24)	/*
 						 * Not susceptible to Post-Barrier
 						 * Return Stack Buffer Predictions.
-- 
2.25.1

