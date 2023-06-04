Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97827217B0
	for <lists+kvm@lfdr.de>; Sun,  4 Jun 2023 16:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbjFDO3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jun 2023 10:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjFDO3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jun 2023 10:29:10 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF35FE41;
        Sun,  4 Jun 2023 07:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685888924; x=1717424924;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UZz39wU3nkSLEyvPp/lZdiQLQKlL0s0tg5Mp2CO0ROg=;
  b=H7gS+oIh3mqdrC9FDyBrHAafvnKxLjp5lon3/KAxP16tNwN7qP6VXvmS
   trACPil5+eYJn2Up4JhmFKKHyS3Qp7XR8ZDYYWBkjQsN574T+d1+wJuJh
   dGx+nXmvIb3vI3tU58BFbubymSihAlF/Gwhh/3Y3L3/hrBTWhy3HhufRO
   VaStTkhFqedStaaRP4NTNllOs6aym3GqEblUtTCY7LlNj8zlGPPHbDbOv
   piudyX8+2tX4aQvB3sVjCL0zYn2Csn+6P0wvW/WyivUOAIxocFzSTgujb
   vU/p6/lcpcLvMg4tj+Bla8TxoFfbNddZBGHXiUxOccUGin3VT44tEP9fc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="353683442"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="353683442"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 07:28:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="1038501045"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="1038501045"
Received: from tdhastx-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.50.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 07:28:13 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v11 04/20] x86/cpu: Detect TDX partial write machine check erratum
Date:   Mon,  5 Jun 2023 02:27:17 +1200
Message-Id: <86f2a8814240f4bbe850f6a09fc9d0b934979d1b.1685887183.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1685887183.git.kai.huang@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
"partial" write to a TDX private memory cacheline will silently "poison"
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

With this erratum, there are additional things need to be done around
machine check handler and kexec(), etc.  Similar to other CPU bugs, use
a CPU bug bit to indicate this erratum, and detect this erratum during
early boot.  Note this bug reflects the hardware thus it is detected
regardless of whether the kernel is built with TDX support or not.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v10 -> v11:
 - New patch

---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kernel/cpu/intel.c        | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index cb8ca46213be..dc8701f8d88b 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -483,5 +483,6 @@
 #define X86_BUG_RETBLEED		X86_BUG(27) /* CPU is affected by RETBleed */
 #define X86_BUG_EIBRS_PBRSB		X86_BUG(28) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
 #define X86_BUG_SMT_RSB			X86_BUG(29) /* CPU is vulnerable to Cross-Thread Return Address Predictions */
+#define X86_BUG_TDX_PW_MCE		X86_BUG(30) /* CPU may incur #MC if non-TD software does partial write to TDX private memory */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1c4639588ff9..251b333e53d2 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1552,3 +1552,24 @@ u8 get_this_hybrid_cpu_type(void)
 
 	return cpuid_eax(0x0000001a) >> X86_HYBRID_CPU_TYPE_ID_SHIFT;
 }
+
+/*
+ * These CPUs have an erratum.  A partial write from non-TD
+ * software (e.g. via MOVNTI variants or UC/WC mapping) to TDX
+ * private memory poisons that memory, and a subsequent read of
+ * that memory triggers #MC.
+ */
+static const struct x86_cpu_id tdx_pw_mce_cpu_ids[] __initconst = {
+	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X, NULL),
+	{ }
+};
+
+static int __init tdx_erratum_detect(void)
+{
+	if (x86_match_cpu(tdx_pw_mce_cpu_ids))
+		setup_force_cpu_bug(X86_BUG_TDX_PW_MCE);
+
+	return 0;
+}
+early_initcall(tdx_erratum_detect);
-- 
2.40.1

