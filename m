Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D7F7886E1
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 14:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244613AbjHYMQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 08:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244546AbjHYMPq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 08:15:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD384199E;
        Fri, 25 Aug 2023 05:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692965744; x=1724501744;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wFATo1vXCFF04f9cqZGr40d26iOW22zDnQJ1GZLMmOQ=;
  b=jSYqHurrglRV3C1MuZIGnj1uI4M8syMYIPhBPaM1iZIwpGjJedby56KT
   GNluWjwm9J99k+LoRhVqKrpu41rqVa7g8b0a23wycZBbLUuNZ2tGmqfMC
   EQvhoINT1rh2hxXP+a69t/KErlT5Wct+zCiyCfb41VDo/PPhgPw2xSBGQ
   0N961aOt4nO/yTl3Hyx2MocrDXh/YyXPOq9hDRBWeAFBjj7/Q4+DcyXk/
   xoWDJd2jk3EwHZ9WLP19/PD0XFyDaPC5xxQOr0r8powujnzfRHLtjJFvQ
   BlTTCPp+CfqV1as0ohuzLpnT5ntP6zwwT0amQxz56swZE8g2W04ZkvrUH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="438639179"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="438639179"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:15:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="881158046"
Received: from vnaikawa-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.185.177])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:15:19 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v13 04/22] x86/cpu: Detect TDX partial write machine check erratum
Date:   Sat, 26 Aug 2023 00:14:23 +1200
Message-ID: <b089f93223958c168b5abd8eef0f810d616adb99.1692962263.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692962263.git.kai.huang@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
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

With this erratum, there are additional things need to be done.  Similar
to other CPU bugs, use a CPU bug bit to indicate this erratum, and
detect this erratum during early boot.  Note this bug reflects the
hardware thus it is detected regardless of whether the kernel is built
with TDX support or not.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---

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
index 1c4639588ff9..e6c3107adc15 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -358,6 +358,21 @@ int intel_microcode_sanity_check(void *mc, bool print_err, int hdr_type)
 }
 EXPORT_SYMBOL_GPL(intel_microcode_sanity_check);
 
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
@@ -509,6 +524,8 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 	 */
 	if (detect_extended_topology_early(c) < 0)
 		detect_ht_early(c);
+
+	check_tdx_erratum(c);
 }
 
 static void bsp_init_intel(struct cpuinfo_x86 *c)
-- 
2.41.0

