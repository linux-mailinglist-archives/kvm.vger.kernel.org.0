Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B50D4F6464
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 18:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237163AbiDFQHO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 12:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237146AbiDFQG3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 12:06:29 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E93244DCFE;
        Tue,  5 Apr 2022 21:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649220594; x=1680756594;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q3oI3RrMki7HmPelaPOBTibAYke76Zj7jDIb9uCW4Yw=;
  b=gS2G5Tv4+nSfbp5z4HW1CN4WQ2GrXS66evZ5F/yQLoDUiuKNVnGO/dYA
   9yjJr4Yb6rqmMc1AnJXtWYoFg8tsNDGxxh8+I1wu7fndb9QI5W/3GfE7C
   BXA8Tjr8NRXHjdzeQhe1e7MY3G+vg0zp6LdjHi7zK2ap8hz6GoMbEaTdw
   EG6VaqKj7v/55oV5Zx9tucE95UmtwvfVHyqdO6EhQ36voZbsZXisUex2R
   XmF9WY5SX3W/9jqwqLgm4sCbnKzEM8qk9oDEOXAQg9ykR1V3Ydbcbhcei
   N5aoI0Z91ZhOU41ve3KRl4NbLXKCd72L0sH5E8cajinV0cEyDgtihxsuF
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="243089771"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="243089771"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:49:53 -0700
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="524302102"
Received: from dchang1-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.17])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:49:49 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v3 02/21] x86/virt/tdx: Detect TDX private KeyIDs
Date:   Wed,  6 Apr 2022 16:49:14 +1200
Message-Id: <2fb62e93734163d2f367fd44e3335cd8a2bf2995.1649219184.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649219184.git.kai.huang@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pre-TDX Intel hardware has support for a memory encryption architecture
called MKTME.  The memory encryption hardware underpinning MKTME is also
used for Intel TDX.  TDX ends up "stealing" some of the physical address
space from the MKTME architecture for crypto-protection to VMs.

A new MSR (IA32_MKTME_KEYID_PARTITIONING) helps to enumerate how MKTME-
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
 arch/x86/virt/vmx/tdx/tdx.c | 72 +++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 03f35c75f439..ba2210001ea8 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
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
2.35.1

