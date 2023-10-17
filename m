Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49FB07CC07E
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 12:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343904AbjJQKS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 06:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343809AbjJQKRo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 06:17:44 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76E3196;
        Tue, 17 Oct 2023 03:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697537827; x=1729073827;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8Da0/TJRBZ9wPF3PE/NTN7haiPXtXDy4AkrJyqo4+mE=;
  b=jtnNBUJLrkzcohh6Vjx4PE+jEUaiNUoyoBo4IFiNWGhK4L8YseE+490y
   NltntrMQAD+3olWRWNpMzzoID6VrZG53VM9j/gtr8nLjsyDEk2B7bK+be
   iELHHAshWmkt5rnHcsrOlU2Fqks7mN6VPvSViF+LDGdPPVgPcbFR2+Bn+
   QlPYOAN8LxlmKjI+9kj14hUlC6Y9Pr3vSTsMvFfTw14BFo8GQCSX6GETW
   6/4F9gztPlyeIU2uPSFXJDCDKJdq1I3UjIPbDXxqjsa6Cn6omCmZf+x+m
   5CBkX4AesHMuEHY5LsKeklk9gw0CmMaZTVoUnHjWpI73q93oOWCAX0Wzq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="471972624"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="471972624"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 03:17:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="872503947"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="872503947"
Received: from chowe-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.64])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 03:17:00 -0700
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
Subject: [PATCH v14 20/23] x86/kexec(): Reset TDX private memory on platforms with TDX erratum
Date:   Tue, 17 Oct 2023 23:14:44 +1300
Message-ID: <aa0ce1a91fd42b0663c286cb982f8b0bde6399a7.1697532085.git.kai.huang@intel.com>
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
here.  Other kernel components which use TDX need to do the conversion
on their own by intercepting the rebooting/shutdown notifier (KVM
already does that).

Note kexec() can happen at anytime, including when TDX module is being
initialized.  Register TDX reboot notifier callback to stop further TDX
module initialization.  If there's any ongoing module initialization,
wait until it finishes.  This makes sure the TDX module status is stable
after the reboot notifier callback, and the later kexec() code can read
module status to decide whether PAMTs are stable and available.

Also stop further TDX module initialization in case of machine shutdown
and halt, but not limited to kexec(), as there's no reason to do so in
these cases too.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---

v13 -> v14:
 - Skip resetting TDX private memory when preserve_context is true (Rick)
 - Use reboot notifier to stop TDX module initialization at early time of
   kexec() to make module status stable, to avoid using a new variable
   and memory barrier (which is tricky to review).
 - Added Kirill's tag

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
 arch/x86/kernel/machine_kexec_64.c | 16 ++++++
 arch/x86/virt/vmx/tdx/tdx.c        | 92 ++++++++++++++++++++++++++++++
 3 files changed, 110 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 3cfd64f8a2b5..417d98595903 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -112,10 +112,12 @@ static inline u64 sc_retry(sc_func_t func, u64 fn,
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
index 1a3e2c05a8a5..d55522902aa1 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -28,6 +28,7 @@
 #include <asm/setup.h>
 #include <asm/set_memory.h>
 #include <asm/cpu.h>
+#include <asm/tdx.h>
 
 #ifdef CONFIG_ACPI
 /*
@@ -301,9 +302,24 @@ void machine_kexec(struct kimage *image)
 	void *control_page;
 	int save_ftrace_enabled;
 
+	/*
+	 * For platforms with TDX "partial write machine check" erratum,
+	 * all TDX private pages need to be converted back to normal
+	 * before booting to the new kernel, otherwise the new kernel
+	 * may get unexpected machine check.
+	 *
+	 * But skip this when preserve_context is on.  The second kernel
+	 * shouldn't write to the first kernel's memory anyway.  Skipping
+	 * this also avoids killing TDX in the first kernel, which would
+	 * require more complicated handling.
+	 */
 #ifdef CONFIG_KEXEC_JUMP
 	if (image->preserve_context)
 		save_processor_state();
+	else
+		tdx_reset_memory();
+#else
+	tdx_reset_memory();
 #endif
 
 	save_ftrace_enabled = __ftrace_enabled_save();
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 3aaf8d8b4920..e82f0adeea4d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -27,6 +27,7 @@
 #include <linux/align.h>
 #include <linux/sort.h>
 #include <linux/log2.h>
+#include <linux/reboot.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/page.h>
@@ -48,6 +49,8 @@ static LIST_HEAD(tdx_memlist);
 
 static struct tdmr_info_list tdx_tdmr_list;
 
+static bool tdx_rebooting;
+
 typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
 
 static inline void seamcall_err(u64 fn, u64 err, struct tdx_module_args *args)
@@ -1184,6 +1187,9 @@ static int __tdx_enable(void)
 {
 	int ret;
 
+	if (tdx_rebooting)
+		return -EAGAIN;
+
 	ret = init_tdx_module();
 	if (ret) {
 		pr_err("module initialization failed (%d)\n", ret);
@@ -1242,6 +1248,69 @@ int tdx_enable(void)
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
+	 * tdx_reboot_notifier() waits until ongoing TDX module
+	 * initialization to finish, and module initialization is
+	 * rejected after that.  Therefore @tdx_module_status is
+	 * stable here and can be read w/o holding lock.
+	 */
+	if (tdx_module_status != TDX_MODULE_INITIALIZED)
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
+	 * TDX need to do the conversion on their own by intercepting the
+	 * rebooting/shutdown notifier (KVM already does that).
+	 */
+	tdmrs_reset_pamt_all(&tdx_tdmr_list);
+}
+
 static int __init record_keyid_partitioning(u32 *tdx_keyid_start,
 					    u32 *nr_tdx_keyids)
 {
@@ -1320,6 +1389,21 @@ static struct notifier_block tdx_memory_nb = {
 	.notifier_call = tdx_memory_notifier,
 };
 
+static int tdx_reboot_notifier(struct notifier_block *nb, unsigned long mode,
+			       void *unused)
+{
+	/* Wait ongoing TDX initialization to finish */
+	mutex_lock(&tdx_module_lock);
+	tdx_rebooting = true;
+	mutex_unlock(&tdx_module_lock);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block tdx_reboot_nb = {
+	.notifier_call = tdx_reboot_notifier,
+};
+
 static int __init tdx_init(void)
 {
 	u32 tdx_keyid_start, nr_tdx_keyids;
@@ -1350,6 +1434,14 @@ static int __init tdx_init(void)
 		return -ENODEV;
 	}
 
+	err = register_reboot_notifier(&tdx_reboot_nb);
+	if (err) {
+		pr_err("initialization failed: register_reboot_notifier() failed (%d)\n",
+				err);
+		unregister_memory_notifier(&tdx_memory_nb);
+		return -ENODEV;
+	}
+
 	/*
 	 * Just use the first TDX KeyID as the 'global KeyID' and
 	 * leave the rest for TDX guests.
-- 
2.41.0

