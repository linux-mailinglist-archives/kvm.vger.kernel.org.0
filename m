Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADDA67886F3
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 14:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243600AbjHYMR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 08:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244709AbjHYMQ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 08:16:57 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA622694;
        Fri, 25 Aug 2023 05:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692965793; x=1724501793;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+1L5eIEbdOcaZFw+ir5wi59yVHqxRQIx4yLVLKJMSdc=;
  b=djvDpGYfNNzZtyNA1P/wOf/mG2qEpKc8ReA1RqqT86wl8hyUUZGGafsk
   OttKIIwv15PVQeJZj7yhzQsa4357rOGEMtLqg7pBbrs7S5ksp6AiCqe9s
   z0fCxCMcmaave3UB1QTUuoy4uzsDK9MdjiJ3TbdpCl8l4QwDIiejNEOpE
   aQuyuMcUNSVobKSetdYzOto21l8NNnCeABW/+rk9wNMDw8phsW0TYu7DO
   zKYNS/O6mGSUorlhjNjdQHnzb53wZ7q4PcHBua2rbaY56XTdNs/xuqqlN
   H75yW9Hi/PE+brRmbBouKy3RFoK7EhW+5xeYKhDrl1xzpBitvOrBPpPRm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="438639433"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="438639433"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:16:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="881158826"
Received: from vnaikawa-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.185.177])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:16:32 -0700
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
Subject: [PATCH v13 17/22] x86/kexec: Flush cache of TDX private memory
Date:   Sat, 26 Aug 2023 00:14:36 +1200
Message-ID: <1fa1eb80238dc19b4c732706b40604169316eb34.1692962263.git.kai.huang@intel.com>
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

There are two problems in terms of using kexec() to boot to a new kernel
when the old kernel has enabled TDX: 1) Part of the memory pages are
still TDX private pages; 2) There might be dirty cachelines associated
with TDX private pages.

The first problem doesn't matter on the platforms w/o the "partial write
machine check" erratum.  KeyID 0 doesn't have integrity check.  If the
new kernel wants to use any non-zero KeyID, it needs to convert the
memory to that KeyID and such conversion would work from any KeyID.

However the old kernel needs to guarantee there's no dirty cacheline
left behind before booting to the new kernel to avoid silent corruption
from later cacheline writeback (Intel hardware doesn't guarantee cache
coherency across different KeyIDs).

There are two things that the old kernel needs to do to achieve that:

1) Stop accessing TDX private memory mappings:
   a. Stop making TDX module SEAMCALLs (TDX global KeyID);
   b. Stop TDX guests from running (per-guest TDX KeyID).
2) Flush any cachelines from previous TDX private KeyID writes.

For 2), use wbinvd() to flush cache in stop_this_cpu(), following SME
support.  And in this way 1) happens for free as there's no TDX activity
between wbinvd() and the native_halt().

Flushing cache in stop_this_cpu() only flushes cache on remote cpus.  On
the rebooting cpu which does kexec(), unlike SME which does the cache
flush in relocate_kernel(), flush the cache right after stopping remote
cpus in machine_shutdown().

There are two reasons to do so: 1) For TDX there's no need to defer
cache flush to relocate_kernel() because all TDX activities have been
stopped.  2) On the platforms with the above erratum the kernel must
convert all TDX private pages back to normal before booting to the new
kernel in kexec(), and flushing cache early allows the kernel to convert
memory early rather than having to muck with the relocate_kernel()
assembly.

Theoretically, cache flush is only needed when the TDX module has been
initialized.  However initializing the TDX module is done on demand at
runtime, and it takes a mutex to read the module status.  Just check
whether TDX is enabled by the BIOS instead to flush cache.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/kernel/process.c |  8 +++++++-
 arch/x86/kernel/reboot.c  | 15 +++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 72015dba72ab..7e85bd9e5f15 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -811,8 +811,14 @@ void __noreturn stop_this_cpu(void *dummy)
 	 *
 	 * Test the CPUID bit directly because the machine might've cleared
 	 * X86_FEATURE_SME due to cmdline options.
+	 *
+	 * The TDX module or guests might have left dirty cachelines
+	 * behind.  Flush them to avoid corruption from later writeback.
+	 * Note that this flushes on all systems where TDX is possible,
+	 * but does not actually check that TDX was in use.
 	 */
-	if (c->extended_cpuid_level >= 0x8000001f && (cpuid_eax(0x8000001f) & BIT(0)))
+	if ((c->extended_cpuid_level >= 0x8000001f && (cpuid_eax(0x8000001f) & BIT(0)))
+			|| platform_tdx_enabled())
 		native_wbinvd();
 
 	/*
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 3adbe97015c1..ae7480a213a6 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -32,6 +32,7 @@
 #include <asm/realmode.h>
 #include <asm/x86_init.h>
 #include <asm/efi.h>
+#include <asm/tdx.h>
 
 /*
  * Power off function, if any
@@ -695,6 +696,20 @@ void native_machine_shutdown(void)
 	local_irq_disable();
 	stop_other_cpus();
 #endif
+	/*
+	 * stop_other_cpus() has flushed all dirty cachelines of TDX
+	 * private memory on remote cpus.  Unlike SME, which does the
+	 * cache flush on _this_ cpu in the relocate_kernel(), flush
+	 * the cache for _this_ cpu here.  This is because on the
+	 * platforms with "partial write machine check" erratum the
+	 * kernel needs to convert all TDX private pages back to normal
+	 * before booting to the new kernel in kexec(), and the cache
+	 * flush must be done before that.  If the kernel took SME's way,
+	 * it would have to muck with the relocate_kernel() assembly to
+	 * do memory conversion.
+	 */
+	if (platform_tdx_enabled())
+		native_wbinvd();
 
 	lapic_shutdown();
 	restore_boot_irq_mode();
-- 
2.41.0

