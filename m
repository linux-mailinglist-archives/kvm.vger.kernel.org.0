Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320877CC057
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 12:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234877AbjJQKPv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 06:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343669AbjJQKPg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 06:15:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B5A114;
        Tue, 17 Oct 2023 03:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697537728; x=1729073728;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9eWwv81lMEyDh8uBfXs//Bh+mi0iS4thcECNF/TDgtQ=;
  b=NtafQfAfZGAqe6Ija1JKZuWQDCm/ZlcB7TL2TqAzCbvlYiDhOIt/UYoz
   nsVmPGSKMIvZOu1OhxNzXcn7EKQsgVgqRX6CaXloS5QZdk59AuFouE0Do
   KxxCq7+tSqR5aw3c4wwj0IgyndYRhwugog8HOCoA1KecrhnVMYenKSFKn
   pExNWWhVDM1TJhGSR46zOonsvBTD20PM+4UUaCTUKLGmaVrZKc3JnJLlO
   aCysr7p8xBNd+sOxSAcouMK8py5DUx0e0o4eiKnm5k/C14jUziRe1Fe9X
   Ni9uni4sDX1CIrThdNEJ8sJzsVqm52vVlRBrrRhRvibTelx010w3GSmac
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="452226747"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="452226747"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 03:15:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="872503413"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="872503413"
Received: from chowe-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.64])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 03:15:22 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, rafael@kernel.org, david@redhat.com,
        dan.j.williams@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v14 04/23] x86/cpu: Detect TDX partial write machine check erratum
Date:   Tue, 17 Oct 2023 23:14:28 +1300
Message-ID: <3191588b67c04bdac682e12dab67499f7bde0a3c.1697532085.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1697532085.git.kai.huang@intel.com>
References: <cover.1697532085.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDX memory has integrity and confidentiality protections.  Violations of
this integrity protection are supposed to only affect TDX operations and
are never supposed to affect the host kernel itself.  In other words,
the host kernel should never, itself, see machine checks induced by the
TDX integrity hardware.

Alas, the first few generations of TDX hardware have an erratum.  A
partial write to a TDX private memory cacheline will silently "poison"
the line.  Subsequent reads will consume the poison and generate a
machine check.  According to the TDX hardware spec, neither of these
things should have happened.

Virtually all kernel memory accesses operations happen in full
cachelines.  In practice, writing a "byte" of memory usually reads a 64
byte cacheline of memory, modifies it, then writes the whole line back.
Those operations do not trigger this problem.

This problem is triggered by "partial" writes where a write transaction
of less than cacheline lands at the memory controller.  The CPU does
these via non-temporal write instructions (like MOVNTI), or through
UC/WC memory mappings.  The issue can also be triggered away from the
CPU by devices doing partial writes via DMA.

With this erratum, there are additional things need to be done.  To
prepare for those changes, add a CPU bug bit to indicate this erratum.
Note this bug reflects the hardware thus it is detected regardless of
whether the kernel is built with TDX support or not.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
---

v13 -> v14:
 - Use "To prepare for ___, add ___" in changelog (Dave)
 - Added Dave's tag.

v12 -> v13:
 - Added David's tag.

v11 -> v12:
 - Added Kirill's tag
 - Changed to detect the erratum in early_init_intel() (Kirill)

v10 -> v11:
 - New patch

---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kernel/cpu/intel.c        | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 58cb9495e40f..f11cfc3cdf81 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -494,6 +494,7 @@
 #define X86_BUG_EIBRS_PBRSB		X86_BUG(28) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
 #define X86_BUG_SMT_RSB			X86_BUG(29) /* CPU is vulnerable to Cross-Thread Return Address Predictions */
 #define X86_BUG_GDS			X86_BUG(30) /* CPU is affected by Gather Data Sampling */
+#define X86_BUG_TDX_PW_MCE		X86_BUG(31) /* CPU may incur #MC if non-TD software does partial write to TDX private memory */
 
 /* BUG word 2 */
 #define X86_BUG_SRSO			X86_BUG(1*32 + 0) /* AMD SRSO bug */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index be4045628fd3..4e229265e596 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -184,6 +184,21 @@ static bool bad_spectre_microcode(struct cpuinfo_x86 *c)
 	return false;
 }
 
+static void check_tdx_erratum(struct cpuinfo_x86 *c)
+{
+	/*
+	 * These CPUs have an erratum.  A partial write from non-TD
+	 * software (e.g. via MOVNTI variants or UC/WC mapping) to TDX
+	 * private memory poisons that memory, and a subsequent read of
+	 * that memory triggers #MC.
+	 */
+	switch (c->x86_model) {
+	case INTEL_FAM6_SAPPHIRERAPIDS_X:
+	case INTEL_FAM6_EMERALDRAPIDS_X:
+		setup_force_cpu_bug(X86_BUG_TDX_PW_MCE);
+	}
+}
+
 static void early_init_intel(struct cpuinfo_x86 *c)
 {
 	u64 misc_enable;
@@ -335,6 +350,8 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 	 */
 	if (detect_extended_topology_early(c) < 0)
 		detect_ht_early(c);
+
+	check_tdx_erratum(c);
 }
 
 static void bsp_init_intel(struct cpuinfo_x86 *c)
-- 
2.41.0

