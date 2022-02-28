Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777F04C60DC
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 03:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbiB1COe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 21:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbiB1CO3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 21:14:29 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790384D9F0;
        Sun, 27 Feb 2022 18:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646014431; x=1677550431;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fgXEGKp0RjZkCxm5LYZEvtTeZrr3+f9V/9Le+k2NL8g=;
  b=dUK6AFn4XVxz0tt08QI/qZBAvfgQCMaDFaecXZTMA10WPPndOrSbJso4
   Z6sqiXSEXeBxNbfgiOdU98gIH7ZM4xNOyciTkxBIfVS0V7tKOdl7IL1//
   aHtxU6G3McDjog+OMrC3pd2FWfqooJ0w5kKyTc3fKsOMbka7BB8Q/tB3M
   RSIfNmxNrtYuxYlERGQEUtUWF+gkQ2+d1y9Gq5u0ZGtPW9Le3coELlv+K
   ze7B9f9i8GUZbO4HeMeJsHD7LHiZix0dJGZMF8PfJvPBaDAqBEneduzZ7
   UvG9hl48PEP5PN5/Ik3PxQAcMkCKi7+A96SGD/yzpdO8g0/5RcJlXbTwq
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="240191870"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="240191870"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:13:51 -0800
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="777936822"
Received: from jdpanhor-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.49.36])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:13:45 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     x86@kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@intel.com, luto@kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, hpa@zytor.com,
        peterz@infradead.org, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, tony.luck@intel.com,
        ak@linux.intel.com, dan.j.williams@intel.com,
        chang.seok.bae@intel.com, keescook@chromium.org,
        hengqi.arch@bytedance.com, laijs@linux.alibaba.com,
        metze@samba.org, linux-kernel@vger.kernel.org, kai.huang@intel.com
Subject: [RFC PATCH 02/21] x86/virt/tdx: Detect TDX private KeyIDs
Date:   Mon, 28 Feb 2022 15:12:50 +1300
Message-Id: <5e8daef8d5f061ce939d3a5581acba156138f2ee.1646007267.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1646007267.git.kai.huang@intel.com>
References: <cover.1646007267.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pre-TDX Intel hardware has support for a memory encryption architecture
called MKTME.  The memory encryption hardware underpinning MKTME is also
used for Intel TDX.  TDX ends up "stealing" some of the physical address
space from the MKTME architecture for crypto protection to VMs.

A new MSR (MSR_IA32_MKTME_KEYID_PART) helps to enumerate how MKTME-
enumerated "KeyID" space is distributed between TDX and legacy MKTME.
KeyIDs reserved for TDX are called 'TDX private KeyIDs' or 'TDX KeyIDs'
for short.

The new MSR is per package and BIOS is responsible for partitioning
MKTME KeyIDs and TDX KeyIDs consistently among all packages.

Detect TDX private KeyIDs as a preparation to initialize TDX.  Similar
to detecting SEAMRR, detect on all cpus to detect any potential BIOS
misconfiguration among packages.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx.c | 72 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index 03f35c75f439..ba2210001ea8 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -29,9 +29,28 @@
 #define SEAMRR_ENABLED_BITS	\
 	(SEAMRR_PHYS_MASK_ENABLED | SEAMRR_PHYS_MASK_LOCKED)
 
+/*
+ * Intel Trusted Domain CPU Architecture Extension spec:
+ *
+ * IA32_MKTME_KEYID_PARTIONING:
+ *
+ *   Bit [31:0]: number of MKTME KeyIDs.
+ *   Bit [63:32]: number of TDX private KeyIDs.
+ *
+ * TDX private KeyIDs start after the last MKTME KeyID.
+ */
+#define MSR_IA32_MKTME_KEYID_PARTITIONING	0x00000087
+
+#define TDX_KEYID_START(_keyid_part)	\
+		((u32)(((_keyid_part) & 0xffffffffull) + 1))
+#define TDX_KEYID_NUM(_keyid_part)	((u32)((_keyid_part) >> 32))
+
 /* BIOS must configure SEAMRR registers for all cores consistently */
 static u64 seamrr_base, seamrr_mask;
 
+static u32 tdx_keyid_start;
+static u32 tdx_keyid_num;
+
 static bool __seamrr_enabled(void)
 {
 	return (seamrr_mask & SEAMRR_ENABLED_BITS) == SEAMRR_ENABLED_BITS;
@@ -96,7 +115,60 @@ static void detect_seam(struct cpuinfo_x86 *c)
 		detect_seam_ap(c);
 }
 
+static void detect_tdx_keyids_bsp(struct cpuinfo_x86 *c)
+{
+	u64 keyid_part;
+
+	/* TDX is built on MKTME, which is based on TME */
+	if (!boot_cpu_has(X86_FEATURE_TME))
+		return;
+
+	if (rdmsrl_safe(MSR_IA32_MKTME_KEYID_PARTITIONING, &keyid_part))
+		return;
+
+	/* If MSR value is 0, TDX is not enabled by BIOS. */
+	if (!keyid_part)
+		return;
+
+	tdx_keyid_num = TDX_KEYID_NUM(keyid_part);
+	if (!tdx_keyid_num)
+		return;
+
+	tdx_keyid_start = TDX_KEYID_START(keyid_part);
+}
+
+static void detect_tdx_keyids_ap(struct cpuinfo_x86 *c)
+{
+	u64 keyid_part;
+
+	/*
+	 * Don't bother to detect this AP if TDX KeyIDs are
+	 * not detected or cleared after earlier detections.
+	 */
+	if (!tdx_keyid_num)
+		return;
+
+	rdmsrl(MSR_IA32_MKTME_KEYID_PARTITIONING, keyid_part);
+
+	if ((tdx_keyid_start == TDX_KEYID_START(keyid_part)) &&
+			(tdx_keyid_num == TDX_KEYID_NUM(keyid_part)))
+		return;
+
+	pr_err("Inconsistent TDX KeyID configuration among packages by BIOS\n");
+	tdx_keyid_start = 0;
+	tdx_keyid_num = 0;
+}
+
+static void detect_tdx_keyids(struct cpuinfo_x86 *c)
+{
+	if (c == &boot_cpu_data)
+		detect_tdx_keyids_bsp(c);
+	else
+		detect_tdx_keyids_ap(c);
+}
+
 void tdx_detect_cpu(struct cpuinfo_x86 *c)
 {
 	detect_seam(c);
+	detect_tdx_keyids(c);
 }
-- 
2.33.1

