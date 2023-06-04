Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D3A7217CA
	for <lists+kvm@lfdr.de>; Sun,  4 Jun 2023 16:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbjFDObL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jun 2023 10:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbjFDOan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jun 2023 10:30:43 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF64B1BB;
        Sun,  4 Jun 2023 07:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685889035; x=1717425035;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2acFdh8Y1N4LJriSc5TNMCWEQYU2QM2INyk/4DortCw=;
  b=lFV04aG27CrLpu+xqyqeda9Gb4c4C9CP7PnQ7kaxIiQARDwXLxoIpDDi
   OgAXhmRTAn54XqGechHSha2MTFwpF61SQvhc1esLlL/mXco/q01qKvMtK
   kZpL0pVYgHoygab39U8qlDPMJFOtSlpsfPq31hfIsc1As0q+xYE8XqJVU
   Q95mbXD4fjQ8b3JmvUT7qPx6mOrmfumrsMNXgDWCo3q6ma1D0h7cQDqoj
   W57MpNAnVgY3LbNy2/ujoFiWNJtszfN1cHFg7h8mCKE4bJe2IewhQLWZk
   EnmZ38/lrk9EG2uJaBfuJxoTcvUA47b2fdrgAWsCOmvJMKYnTlozC+uf+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="353683686"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="353683686"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 07:29:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="1038501215"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="1038501215"
Received: from tdhastx-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.50.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 07:29:19 -0700
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
Subject: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private memory during kexec() and reboot
Date:   Mon,  5 Jun 2023 02:27:31 +1200
Message-Id: <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
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
after either a fast warm reset or kexec().

There's no existing infrastructure to track TDX private pages, which
could be PAMT pages, TDX guest private pages, or SEPT (secure EPT)
pages.  The latter two are yet to be implemented thus it's not certain
how to track them for now.

It's not feasible to query the TDX module either because VMX has already
been stopped when KVM receives the reboot notifier.

Another option is to blindly convert all memory pages.  But this may
bring non-trivial latency to machine reboot and kexec() on large memory
systems (especially when the number of TDX private pages is small).  A
final solution should be tracking TDX private pages and only converting
them.  Also, it's problematic to convert all memory pages because not
all pages are mapped as writable in the direct-mapping.  Thus to do so
would require switching to a new page table which maps all pages as
writable.  Such page table can either be a new page table, or the
identical mapping table built during kexec().  Using either seems too
dramatic, especially considering the kernel should eventually be able
to track all TDX private pages in which case the direct-mapping can be
directly used.

So for now just convert PAMT pages.  Converting TDX guest private pages
and SEPT pages can be added when supporting TDX guests is added to the
kernel.

Introduce a new "x86_platform_ops::memory_shutdown()" callback as a
placeholder to convert all TDX private memory, and call it at the end of
machine_shutdown() after all remote cpus have been stopped (thus no more
TDX activities) and all dirty cachelines of TDX private memory have been
flushed (thus no more later cacheline writeback).

Implement the default callback as a noop function.  Replace the callback
with TDX's own implementation when the platform has this erratum in TDX
early boot-time initialization.  In this way only the platforms with
this erratum carry this additional memory conversion burden.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v10 -> v11:
 - New patch

---
 arch/x86/include/asm/x86_init.h |  1 +
 arch/x86/kernel/reboot.c        |  1 +
 arch/x86/kernel/x86_init.c      |  2 ++
 arch/x86/virt/vmx/tdx/tdx.c     | 57 +++++++++++++++++++++++++++++++++
 4 files changed, 61 insertions(+)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 88085f369ff6..d2c6742b185a 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -299,6 +299,7 @@ struct x86_platform_ops {
 	void (*get_wallclock)(struct timespec64 *ts);
 	int (*set_wallclock)(const struct timespec64 *ts);
 	void (*iommu_shutdown)(void);
+	void (*memory_shutdown)(void);
 	bool (*is_untracked_pat_range)(u64 start, u64 end);
 	void (*nmi_init)(void);
 	unsigned char (*get_nmi_reason)(void);
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index b3d0e015dae2..6aadfec8df7a 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -720,6 +720,7 @@ void native_machine_shutdown(void)
 
 #ifdef CONFIG_X86_64
 	x86_platform.iommu_shutdown();
+	x86_platform.memory_shutdown();
 #endif
 }
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index d82f4fa2f1bf..344250b35a5d 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -31,6 +31,7 @@ void x86_init_noop(void) { }
 void __init x86_init_uint_noop(unsigned int unused) { }
 static int __init iommu_init_noop(void) { return 0; }
 static void iommu_shutdown_noop(void) { }
+static void memory_shutdown_noop(void) { }
 bool __init bool_x86_init_noop(void) { return false; }
 void x86_op_int_noop(int cpu) { }
 int set_rtc_noop(const struct timespec64 *now) { return -EINVAL; }
@@ -142,6 +143,7 @@ struct x86_platform_ops x86_platform __ro_after_init = {
 	.get_wallclock			= mach_get_cmos_time,
 	.set_wallclock			= mach_set_cmos_time,
 	.iommu_shutdown			= iommu_shutdown_noop,
+	.memory_shutdown		= memory_shutdown_noop,
 	.is_untracked_pat_range		= is_ISA_range,
 	.nmi_init			= default_nmi_init,
 	.get_nmi_reason			= default_get_nmi_reason,
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 8ff07256a515..0aa413b712e8 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -587,6 +587,14 @@ static int tdmr_set_up_pamt(struct tdmr_info *tdmr,
 		tdmr_pamt_base += pamt_size[pgsz];
 	}
 
+	/*
+	 * tdx_memory_shutdown() also reads TDMR's PAMT during
+	 * kexec() or reboot, which could happen at anytime, even
+	 * during this particular code.  Make sure pamt_4k_base
+	 * is firstly set otherwise tdx_memory_shutdown() may
+	 * get an invalid PAMT base when it sees a valid number
+	 * of PAMT pages.
+	 */
 	tdmr->pamt_4k_base = pamt_base[TDX_PS_4K];
 	tdmr->pamt_4k_size = pamt_size[TDX_PS_4K];
 	tdmr->pamt_2m_base = pamt_base[TDX_PS_2M];
@@ -1318,6 +1326,46 @@ static struct notifier_block tdx_memory_nb = {
 	.notifier_call = tdx_memory_notifier,
 };
 
+static void tdx_memory_shutdown(void)
+{
+	/*
+	 * Convert all TDX private pages back to normal if the platform
+	 * has "partial write machine check" erratum.
+	 *
+	 * For now there's no existing infrastructure to tell whether
+	 * a page is TDX private memory.  Using SEAMCALL to query TDX
+	 * module isn't feasible either because: 1) VMX has been turned
+	 * off by reaching here so SEAMCALL cannot be made; 2) Even
+	 * SEAMCALL can be made the result from TDX module may not be
+	 * accurate (e.g., remote CPU can be stopped while the kernel
+	 * is in the middle of reclaiming one TDX private page and doing
+	 * MOVDIR64B).
+	 *
+	 * One solution could be just converting all memory pages, but
+	 * this may bring non-trivial latency on large memory systems
+	 * (especially when the number of TDX private pages is small).
+	 * Looks eventually the kernel should track TDX private pages and
+	 * only convert these.
+	 *
+	 * Also, not all pages are mapped as writable in direct mapping,
+	 * thus it's problematic to do so.  It can be done by switching
+	 * to the identical mapping page table built for kexec(), which
+	 * maps all pages as writable, but the complexity looks overkill.
+	 *
+	 * Thus instead of doing something dramatic to convert all pages,
+	 * only convert PAMTs for now as for now TDX private pages can
+	 * only be PAMT.  Converting TDX guest private pages and Secure
+	 * EPT pages can be added later when the kernel has a proper way
+	 * to track these pages.
+	 *
+	 * All other cpus are already dead, thus it's safe to read TDMRs
+	 * to find PAMTs w/o holding any kind of locking here.
+	 */
+	WARN_ON_ONCE(num_online_cpus() != 1);
+
+	tdmrs_reset_pamt_all(&tdx_tdmr_list);
+}
+
 static int __init tdx_init(void)
 {
 	u32 tdx_keyid_start, nr_tdx_keyids;
@@ -1356,6 +1404,15 @@ static int __init tdx_init(void)
 	tdx_guest_keyid_start = ++tdx_keyid_start;
 	tdx_nr_guest_keyids = --nr_tdx_keyids;
 
+	/*
+	 * On the platform with erratum all TDX private pages need to
+	 * be converted back to normal before rebooting (warm reset) or
+	 * before kexec() booting to the new kernel, otherwise the (new)
+	 * kernel may get unexpected SRAR machine check exception.
+	 */
+	if (boot_cpu_has_bug(X86_BUG_TDX_PW_MCE))
+		x86_platform.memory_shutdown = tdx_memory_shutdown;
+
 	return 0;
 no_tdx:
 	return -ENODEV;
-- 
2.40.1

