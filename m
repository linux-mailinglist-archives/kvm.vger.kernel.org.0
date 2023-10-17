Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625327CC078
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 12:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343771AbjJQKSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 06:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343758AbjJQKRk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 06:17:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D38D71;
        Tue, 17 Oct 2023 03:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697537808; x=1729073808;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e3OEQmPhdi+AgT8pJCWMf8X2DtqH5+9i6q9MakSExHE=;
  b=S9SvJbfBHyKlevzndwoJmJJnsH2TysUbY2MH+P1pSmSbwKw8dHynAwhN
   ajd/R6UuQWjLIZKvLF5qJN3hH1a4jw2VBVgPTw+wEBX7iMtwpzgUUkM/A
   1PZuUT+ixe+gEU1r/u4hov0c3Nt17JllNORw7CHm2+s9yolHSaM+N6aNZ
   wip1aJI25rpEjm5u8/cL1vcSajUsCaEBNmvNnH/DnhmvM/sCWLys9bNGU
   hcfbjfu2uQ1gZQqIvZDBIqnOR/b4Gb3DzuVyv18yiG6Lho80hd7m9VDCG
   6vY42QwzsrvyKAts6eDXeOpzj0nTCgP/TwN0dnw1RXVzhQTvXRWL0EXiW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="471972528"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="471972528"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 03:16:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="872503821"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="872503821"
Received: from chowe-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.64])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 03:16:42 -0700
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
Subject: [PATCH v14 17/23] x86/kexec: Flush cache of TDX private memory
Date:   Tue, 17 Oct 2023 23:14:41 +1300
Message-ID: <da8c976d1fd2530d55ab4164429b513aca1b9efc.1697532085.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1697532085.git.kai.huang@intel.com>
References: <cover.1697532085.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

v13 -> v14:
 - No change

---
 arch/x86/kernel/process.c |  8 +++++++-
 arch/x86/kernel/reboot.c  | 15 +++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 9f0909142a0a..c197be03ea06 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -830,8 +830,14 @@ void __noreturn stop_this_cpu(void *dummy)
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
index 830425e6d38e..e1a4fa8de11d 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -31,6 +31,7 @@
 #include <asm/realmode.h>
 #include <asm/x86_init.h>
 #include <asm/efi.h>
+#include <asm/tdx.h>
 
 /*
  * Power off function, if any
@@ -741,6 +742,20 @@ void native_machine_shutdown(void)
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

