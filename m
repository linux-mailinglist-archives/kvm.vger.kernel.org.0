Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5E27217C5
	for <lists+kvm@lfdr.de>; Sun,  4 Jun 2023 16:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbjFDOay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jun 2023 10:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbjFDOam (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jun 2023 10:30:42 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6606B1B6;
        Sun,  4 Jun 2023 07:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685889035; x=1717425035;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NE9SvDWlxjKkJmtHRhd4yPtLD1ElHWnYUmIkHeViI64=;
  b=XE/Ab69+AA9PGSKzLOUBUSOjBPeaW1NA4RIq2zE404WXojVmIMYAh81D
   8Cpyb1CjJ+oQyAw4zAhB1ht0ypz+RglvAgTlQEmqwYTw1wjNE/jF0zopi
   rcHT21yceW3ikIFxtOfceYQ/Ohgf0i2ZGFbGgBUcmgzVZOodTUPRaoWlD
   xtACumEczz1xicYNJKUvHb21rBqmV0NmFGGYXHAxTcJgVEuQSU1bQjOom
   9d82TNjsJq4PQ3KyhGvcPa1ICLEji4i5r9UoyoopTGxk9vO/Sx/KNTwD0
   ZxUazmWa5obYJ474n1Vm5Qfc7vrW2Vm+mEJs9frRTI1skoOYaVUYZPEyW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="353683673"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="353683673"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 07:29:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="1038501199"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="1038501199"
Received: from tdhastx-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.50.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 07:29:14 -0700
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
Subject: [PATCH v11 17/20] x86/kexec: Flush cache of TDX private memory
Date:   Mon,  5 Jun 2023 02:27:30 +1200
Message-Id: <17bcbe3e154415ee7a4c77489809a3db0c5ddf3f.1685887183.git.kai.huang@intel.com>
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
the cpu which does kexec(), unlike SME which does the cache flush in
relocate_kernel(), do the cache flush right after stopping remote cpus
in machine_shutdown().  This is because on the platforms with above
erratum, the kernel needs to convert all TDX private pages back to
normal before a fast warm reset reboot or booting to the new kernel in
kexec().  Flushing cache in relocate_kernel() only covers the kexec()
but not the fast warm reset reboot.

Theoretically, cache flush is only needed when the TDX module has been
initialized.  However initializing the TDX module is done on demand at
runtime, and it takes a mutex to read the module status.  Just check
whether TDX is enabled by the BIOS instead to flush cache.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
---

v10 -> v11:
 - Fixed a bug that cache for rebooting cpu isn't flushed for TDX private
   memory.
 - Updated changelog accordingly.

v9 -> v10:
 - No change.

v8 -> v9:
 - Various changelog enhancement and fix (Dave).
 - Improved comment (Dave).

v7 -> v8:
 - Changelog:
   - Removed "leave TDX module open" part due to shut down patch has been
     removed.

v6 -> v7:
 - Improved changelog to explain why don't convert TDX private pages back
   to normal.


---
 arch/x86/kernel/process.c |  7 ++++++-
 arch/x86/kernel/reboot.c  | 15 +++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index dac41a0072ea..0ce66deb9bc8 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -780,8 +780,13 @@ void __noreturn stop_this_cpu(void *dummy)
 	 *
 	 * Test the CPUID bit directly because the machine might've cleared
 	 * X86_FEATURE_SME due to cmdline options.
+	 *
+	 * The TDX module or guests might have left dirty cachelines
+	 * behind.  Flush them to avoid corruption from later writeback.
+	 * Note that this flushes on all systems where TDX is possible,
+	 * but does not actually check that TDX was in use.
 	 */
-	if (cpuid_eax(0x8000001f) & BIT(0))
+	if (cpuid_eax(0x8000001f) & BIT(0) || platform_tdx_enabled())
 		native_wbinvd();
 	for (;;) {
 		/*
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 3adbe97015c1..b3d0e015dae2 100644
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
+	 * before a fast warm reset reboot or booting to the new kernel
+	 * in kexec(), and the cache flush must be done before that.
+	 * Flushing cache in relocate_kernel() only covers the kexec()
+	 * but not the fast warm reset reboot.
+	 */
+	if (platform_tdx_enabled())
+		native_wbinvd();
 
 	lapic_shutdown();
 	restore_boot_irq_mode();
-- 
2.40.1

