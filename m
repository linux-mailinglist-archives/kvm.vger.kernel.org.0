Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE4A7886F1
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 14:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244794AbjHYMR7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 08:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244847AbjHYMRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 08:17:38 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289F1272A;
        Fri, 25 Aug 2023 05:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692965826; x=1724501826;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/cqmS68ebycfJgCtkYEok6KFCuj1npuij4P75uodgXg=;
  b=AhLjE7ZXPkFyvdMAfarIjqJEFVymXbRT675o34hND9yeMfxu9uUtm70T
   0vhHMD9eLXVNCsCP9zdveSGNX2DFFcQyqdE5sB4nkixhSfj0TwwyPs5Uh
   VdfOZb5DVM84oi+L8js57dyr1MQYXJMttOvWCdJkiMnefbmEJLXhKR/z2
   2sIvyzJn/8wSmjs1bC6Uz9bjddR9vr29lVZWrGmbRMRjyuUbQJqheBglz
   5RfSX1+Or/0hTVSwcS8pmJHGNNmhkn1uBzKgdRz4FC603vTv+m1kn5cVT
   Vz4Qn1FaMoFEzWXzfNRGVzAjKK4IJdUKwfwzB4rdND+9dAwolybZRC5Kj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="438639472"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="438639472"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:16:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="881158908"
Received: from vnaikawa-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.185.177])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:16:48 -0700
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
Subject: [PATCH v13 20/22] x86/kexec(): Reset TDX private memory on platforms with TDX erratum
Date:   Sat, 26 Aug 2023 00:14:39 +1200
Message-ID: <12c249371edcbad8fbb15af558715fb8ea1f1e05.1692962263.git.kai.huang@intel.com>
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

The first few generations of TDX hardware have an erratum.  A partial
write to a TDX private memory cacheline will silently "poison" the
line.  Subsequent reads will consume the poison and generate a machine
check.  According to the TDX hardware spec, neither of these things
should have happened.

== Background ==

Virtually all kernel memory accesses operations happen in full
cachelines.  In practice, writing a "byte" of memory usually reads a 64
byte cacheline of memory, modifies it, then writes the whole line back.
Those operations do not trigger this problem.

This problem is triggered by "partial" writes where a write transaction
of less than cacheline lands at the memory controller.  The CPU does
these via non-temporal write instructions (like MOVNTI), or through
UC/WC memory mappings.  The issue can also be triggered away from the
CPU by devices doing partial writes via DMA.

== Problem ==

A fast warm reset doesn't reset TDX private memory.  Kexec() can also
boot into the new kernel directly.  Thus if the old kernel has enabled
TDX on the platform with this erratum, the new kernel may get unexpected
machine check.

Note that w/o this erratum any kernel read/write on TDX private memory
should never cause machine check, thus it's OK for the old kernel to
leave TDX private pages as is.

== Solution ==

In short, with this erratum, the kernel needs to explicitly convert all
TDX private pages back to normal to give the new kernel a clean slate
after kexec().  The BIOS is also expected to disable fast warm reset as
a workaround to this erratum, thus this implementation doesn't try to
reset TDX private memory for the reboot case in the kernel but depend on
the BIOS to enable the workaround.

Convert TDX private pages back to normal after all remote cpus has been
stopped and cache flush has been done on all cpus, when no more TDX
activity can happen further.  Do it in machine_kexec() to avoid the
additional overhead to the normal reboot/shutdown as the kernel depends
on the BIOS to disable fast warm reset for the reboot case.

For now TDX private memory can only be PAMT pages.  It would be ideal to
cover all types of TDX private memory here, but there are practical
problems to do so:

1) There's no existing infrastructure to track TDX private pages;
2) It's not feasible to query the TDX module about page type because VMX
   has already been stopped when KVM receives the reboot notifier, plus
   the result from the TDX module may not be accurate (e.g., the remote
   CPU could be stopped right before MOVDIR64B).

One temporary solution is to blindly convert all memory pages, but it's
problematic to do so too, because not all pages are mapped as writable
in the direct mapping.  It can be done by switching to the identical
mapping created for kexec() or a new page table, but the complexity
looks overkill.

Therefore, rather than doing something dramatic, only reset PAMT pages
here.  Other kernel components which use TDX can do the conversion on
their own by intercepting the rebooting/shutdown notifier (KVM already
does that).

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v12 -> v13:
 - Improve comments to explain why barrier is needed and ignore WBINVD.
   (Dave)
 - Improve comments to document memory ordering. (Nikolay)
 - Made comments/changelog slightly more concise.

v11 -> v12:
 - Changed comment/changelog to say kernel doesn't try to handle fast
   warm reset but depends on BIOS to enable workaround (Kirill)
 - Added a new tdx_may_has_private_mem to indicate system may have TDX
   private memory and PAMTs/TDMRs are stable to access. (Dave).
 - Use atomic_t for tdx_may_has_private_mem for build-in memory barrier
   (Dave)
 - Changed calling x86_platform.memory_shutdown() to calling
   tdx_reset_memory() directly from machine_kexec() to avoid overhead to
   normal reboot case.

v10 -> v11:
 - New patch



---
 arch/x86/include/asm/tdx.h         |  2 +
 arch/x86/kernel/machine_kexec_64.c |  9 ++++
 arch/x86/virt/vmx/tdx/tdx.c        | 84 ++++++++++++++++++++++++++++++
 3 files changed, 95 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index fce7abc99bf5..97a68ced69dc 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -113,10 +113,12 @@ u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args);
 bool platform_tdx_enabled(void);
 int tdx_cpu_enable(void);
 int tdx_enable(void);
+void tdx_reset_memory(void);
 #else
 static inline bool platform_tdx_enabled(void) { return false; }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
 static inline int tdx_enable(void)  { return -ENODEV; }
+static inline void tdx_reset_memory(void) { }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 1a3e2c05a8a5..03d9689ef808 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -28,6 +28,7 @@
 #include <asm/setup.h>
 #include <asm/set_memory.h>
 #include <asm/cpu.h>
+#include <asm/tdx.h>
 
 #ifdef CONFIG_ACPI
 /*
@@ -301,6 +302,14 @@ void machine_kexec(struct kimage *image)
 	void *control_page;
 	int save_ftrace_enabled;
 
+	/*
+	 * For platforms with TDX "partial write machine check" erratum,
+	 * all TDX private pages need to be converted back to normal
+	 * before booting to the new kernel, otherwise the new kernel
+	 * may get unexpected machine check.
+	 */
+	tdx_reset_memory();
+
 #ifdef CONFIG_KEXEC_JUMP
 	if (image->preserve_context)
 		save_processor_state();
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 8ee9f94c0fa7..41c6a5acddc2 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -134,6 +134,8 @@ static LIST_HEAD(tdx_memlist);
 
 static struct tdmr_info_list tdx_tdmr_list;
 
+static atomic_t tdx_may_have_private_mem;
+
 /*
  * Do the module global initialization if not done yet.  It can be
  * done on any cpu.  It's always called with interrupts disabled.
@@ -1148,6 +1150,14 @@ static int init_tdx_module(void)
 	 */
 	wbinvd_on_all_cpus();
 
+	/*
+	 * Mark that the system may have TDX private memory starting
+	 * from this point.  Use atomic_inc_return() to enforce memory
+	 * ordering to make sure tdx_reset_memory() always reads stable
+	 * TDMRs/PAMTs when it sees @tdx_may_have_private_mem is true.
+	 */
+	atomic_inc_return(&tdx_may_have_private_mem);
+
 	/* Config the key of global KeyID on all packages */
 	ret = config_global_keyid();
 	if (ret)
@@ -1192,6 +1202,14 @@ static int init_tdx_module(void)
 	 * as suggested by the TDX spec.
 	 */
 	tdmrs_reset_pamt_all(&tdx_tdmr_list);
+
+	/*
+	 * No more TDX private pages now, and PAMTs/TDMRs are going to be
+	 * freed.  Use atomic_inc_return() to enforce memory ording to
+	 * make sure tdx_reset_memory() always reads stable TDMRs/PAMTs
+	 * when it sees @tdx_may_have_private_mem is true.
+	 */
+	atomic_dec_return(&tdx_may_have_private_mem);
 err_free_pamts:
 	tdmrs_free_pamt_all(&tdx_tdmr_list);
 err_free_tdmrs:
@@ -1264,6 +1282,72 @@ int tdx_enable(void)
 }
 EXPORT_SYMBOL_GPL(tdx_enable);
 
+/*
+ * Convert TDX private pages back to normal on platforms with
+ * "partial write machine check" erratum.
+ *
+ * Called from machine_kexec() before booting to the new kernel.
+ */
+void tdx_reset_memory(void)
+{
+	if (!platform_tdx_enabled())
+		return;
+
+	/*
+	 * Kernel read/write to TDX private memory doesn't
+	 * cause machine check on hardware w/o this erratum.
+	 */
+	if (!boot_cpu_has_bug(X86_BUG_TDX_PW_MCE))
+		return;
+
+	/* Called from kexec() when only rebooting cpu is alive */
+	WARN_ON_ONCE(num_online_cpus() != 1);
+
+	/*
+	 * Check whether it's possible to have any TDX private pages.
+	 *
+	 * Note init_tdx_module() guarantees memory ording of writing to
+	 * TDMRs/PAMTs and @tdx_may_have_private_mem.  Here only the
+	 * rebooting cpu is alive.  atomic_read() (which guarantees
+	 * relaxed ordering) guarantees when @tdx_may_have_private_mem
+	 * reads true TDMRs/PAMTs are stable.
+	 */
+	if (!atomic_read(&tdx_may_have_private_mem))
+		return;
+
+	/*
+	 * Convert PAMTs back to normal.  All other cpus are already
+	 * dead and TDMRs/PAMTs are stable.
+	 *
+	 * Ideally it's better to cover all types of TDX private pages
+	 * here, but it's impractical:
+	 *
+	 *  - There's no existing infrastructure to tell whether a page
+	 *    is TDX private memory or not.
+	 *
+	 *  - Using SEAMCALL to query TDX module isn't feasible either:
+	 *    - VMX has been turned off by reaching here so SEAMCALL
+	 *      cannot be made;
+	 *    - Even SEAMCALL can be made the result from TDX module may
+	 *      not be accurate (e.g., remote CPU can be stopped while
+	 *      the kernel is in the middle of reclaiming TDX private
+	 *      page and doing MOVDIR64B).
+	 *
+	 * One temporary solution could be just converting all memory
+	 * pages, but it's problematic too, because not all pages are
+	 * mapped as writable in direct mapping.  It can be done by
+	 * switching to the identical mapping for kexec() or a new page
+	 * table which maps all pages as writable, but the complexity is
+	 * overkill.
+	 *
+	 * Thus instead of doing something dramatic to convert all pages,
+	 * only convert PAMTs here.  Other kernel components which use
+	 * TDX can do the conversion on their own by intercepting the
+	 * rebooting/shutdown notifier (KVM already does that).
+	 */
+	tdmrs_reset_pamt_all(&tdx_tdmr_list);
+}
+
 static int __init record_keyid_partitioning(u32 *tdx_keyid_start,
 					    u32 *nr_tdx_keyids)
 {
-- 
2.41.0

