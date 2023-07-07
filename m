Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8DED74A99E
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 06:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjGGECD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 00:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjGGEBs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 00:01:48 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49E81FD7;
        Thu,  6 Jul 2023 21:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688702506; x=1720238506;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VZx8xHPedaTRV9qKZIweeiLjMoAAs5qAkOe10n7Tb9Y=;
  b=neXvGJ/OY4WMoBD50omoAvlbp0K/GGec+ezrLX9I5J/gzz3K7btippfH
   Hv89CSUd3dzKcL6upZ9/3GTbmen4xUrvZ6os5TyWEsEv+nzelgZjFpNQ9
   WOMgKs78+nOgPeLXMTySdv0qf5X8lMeanq+4r1IGyNHqBd8Rua7BM7qlv
   wyMDWoyuYd6uzYMRzWdrnBMp5/izsNuUemO1YVRLOLrRGDOB0ZQHBsgB7
   vSXkFJ9nu/DpPd7l0QGTpQQNdP53IQhPqEsnOVDW3A1Aa9xIs6061Ity8
   E8na/eDMicMhG+C+6iHPzfb77S49tV6X3aK9UMDBZ3dmXrrMLUb6GPeRc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10763"; a="394561177"
X-IronPort-AV: E=Sophos;i="6.01,187,1684825200"; 
   d="scan'208";a="394561177"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2023 21:01:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10763"; a="789805852"
X-IronPort-AV: E=Sophos;i="6.01,187,1684825200"; 
   d="scan'208";a="789805852"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga004.fm.intel.com with ESMTP; 06 Jul 2023 21:01:39 -0700
Date:   Fri, 7 Jul 2023 12:01:38 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v12 19/22] x86/kexec(): Reset TDX private memory on
 platforms with TDX erratum
Message-ID: <20230707040138.heqnc7ivonblejts@yy-desk-7060>
References: <cover.1687784645.git.kai.huang@intel.com>
 <28aece770321e307d58df77eddee2d3fa851d15a.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28aece770321e307d58df77eddee2d3fa851d15a.1687784645.git.kai.huang@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 02:12:49AM +1200, Kai Huang wrote:
> The first few generations of TDX hardware have an erratum.  A partial
> write to a TDX private memory cacheline will silently "poison" the
> line.  Subsequent reads will consume the poison and generate a machine
> check.  According to the TDX hardware spec, neither of these things
> should have happened.
>
> == Background ==
>
> Virtually all kernel memory accesses operations happen in full
> cachelines.  In practice, writing a "byte" of memory usually reads a 64
> byte cacheline of memory, modifies it, then writes the whole line back.
> Those operations do not trigger this problem.
>
> This problem is triggered by "partial" writes where a write transaction
> of less than cacheline lands at the memory controller.  The CPU does
> these via non-temporal write instructions (like MOVNTI), or through
> UC/WC memory mappings.  The issue can also be triggered away from the
> CPU by devices doing partial writes via DMA.
>
> == Problem ==
>
> A fast warm reset doesn't reset TDX private memory.  Kexec() can also
> boot into the new kernel directly.  Thus if the old kernel has enabled
> TDX on the platform with this erratum, the new kernel may get unexpected
> machine check.
>
> Note that w/o this erratum any kernel read/write on TDX private memory
> should never cause machine check, thus it's OK for the old kernel to
> leave TDX private pages as is.
>
> == Solution ==
>
> In short, with this erratum, the kernel needs to explicitly convert all
> TDX private pages back to normal to give the new kernel a clean slate
> after kexec().  The BIOS is also expected to disable fast warm reset as
> a workaround to this erratum, thus this implementation doesn't try to
> reset TDX private memory for the reboot case in the kernel but depend on
> the BIOS to enable the workaround.
>
> For now TDX private memory can only be PAMT pages.  It would be ideal to
> cover all types of TDX private memory here (TDX guest private pages and
> Secure-EPT pages are yet to be implemented when TDX gets supported in
> KVM), but there's no existing infrastructure to track TDX private pages.
> It's not feasible to query the TDX module about page type either because
> VMX has already been stopped when KVM receives the reboot notifier.
>
> Another option is to blindly convert all memory pages.  But this may
> bring non-trivial latency to kexec() on large memory systems (especially
> when the number of TDX private pages is small).  Thus even with this
> temporary solution, eventually it's better for the kernel to only reset
> TDX private pages.  Also, it's problematic to convert all memory pages
> because not all pages are mapped as writable in the direct-mapping.  The
> kernel needs to switch to another page table which maps all pages as
> writable (e.g., the identical-mapping table for kexec(), or a new page
> table) to do so, but this looks overkill.
>
> Therefore, rather than doing something dramatic, only reset PAMT pages
> for now.  Do it in machine_kexec() to avoid additional overhead to the
> machine reboot/shutdown as the kernel depends on the BIOS to disable
> fast warm reset as a workaround for the reboot case.
>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>
> v11 -> v12:
>  - Changed comment/changelog to say kernel doesn't try to handle fast
>    warm reset but depends on BIOS to enable workaround (Kirill)
>  - Added a new tdx_may_has_private_mem to indicate system may have TDX
>    private memory and PAMTs/TDMRs are stable to access. (Dave).
>  - Use atomic_t for tdx_may_has_private_mem for build-in memory barrier
>    (Dave)
>  - Changed calling x86_platform.memory_shutdown() to calling
>    tdx_reset_memory() directly from machine_kexec() to avoid overhead to
>    normal reboot case.
>
> v10 -> v11:
>  - New patch
>
>
> ---
>  arch/x86/include/asm/tdx.h         |  2 +
>  arch/x86/kernel/machine_kexec_64.c |  9 ++++
>  arch/x86/virt/vmx/tdx/tdx.c        | 79 ++++++++++++++++++++++++++++++
>  3 files changed, 90 insertions(+)
>
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 91416fd600cd..e95c9fbf52e4 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -100,10 +100,12 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
>  bool platform_tdx_enabled(void);
>  int tdx_cpu_enable(void);
>  int tdx_enable(void);
> +void tdx_reset_memory(void);
>  #else	/* !CONFIG_INTEL_TDX_HOST */
>  static inline bool platform_tdx_enabled(void) { return false; }
>  static inline int tdx_cpu_enable(void) { return -ENODEV; }
>  static inline int tdx_enable(void)  { return -ENODEV; }
> +static inline void tdx_reset_memory(void) { }
>  #endif	/* CONFIG_INTEL_TDX_HOST */
>
>  #endif /* !__ASSEMBLY__ */
> diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
> index 1a3e2c05a8a5..232253bd7ccd 100644
> --- a/arch/x86/kernel/machine_kexec_64.c
> +++ b/arch/x86/kernel/machine_kexec_64.c
> @@ -28,6 +28,7 @@
>  #include <asm/setup.h>
>  #include <asm/set_memory.h>
>  #include <asm/cpu.h>
> +#include <asm/tdx.h>
>
>  #ifdef CONFIG_ACPI
>  /*
> @@ -301,6 +302,14 @@ void machine_kexec(struct kimage *image)
>  	void *control_page;
>  	int save_ftrace_enabled;
>
> +	/*
> +	 * On the platform with "partial write machine check" erratum,
> +	 * all TDX private pages need to be converted back to normal
> +	 * before booting to the new kernel, otherwise the new kernel
> +	 * may get unexpected machine check.
> +	 */
> +	tdx_reset_memory();
> +
>  #ifdef CONFIG_KEXEC_JUMP
>  	if (image->preserve_context)
>  		save_processor_state();
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 85b24b2e9417..1107f4227568 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -51,6 +51,8 @@ static LIST_HEAD(tdx_memlist);
>
>  static struct tdmr_info_list tdx_tdmr_list;
>
> +static atomic_t tdx_may_has_private_mem;
> +
>  /*
>   * Wrapper of __seamcall() to convert SEAMCALL leaf function error code
>   * to kernel error code.  @seamcall_ret and @out contain the SEAMCALL
> @@ -1113,6 +1115,17 @@ static int init_tdx_module(void)
>  	 */
>  	wbinvd_on_all_cpus();
>
> +	/*
> +	 * Starting from this point the system may have TDX private
> +	 * memory.  Make it globally visible so tdx_reset_memory() only
> +	 * reads TDMRs/PAMTs when they are stable.
> +	 *
> +	 * Note using atomic_inc_return() to provide the explicit memory
> +	 * ordering isn't mandatory here as the WBINVD above already

WBINVD is serial instruction to make sure all things happen before
it must be committed before finish the exection of this instruction,
but it should not impact the instructions after it.
(SDM Vol.3 9.3 Jun 2023)

I think the atomic operation used below is to make sure the
change to tdx_may_has_private_mem becomes visible immediately
to other LPs which read it, e.g running tdx_reset_memory().
atomic_inc() should be enough for this case because the
locked Instructions are total order.
(SDM Vol.3 9.2.3.8 June 2023).

So per my understanding the key here is the atomic
operation's guarantee on memory changes visibility, not the
guarantee from WBINVD, the comment should be changed if
this is the correct understanding.

> +	 * does that.  Compiler barrier isn't needed here either.
> +	 */
> +	atomic_inc_return(&tdx_may_has_private_mem);
> +
>  	/* Config the key of global KeyID on all packages */
>  	ret = config_global_keyid();
>  	if (ret)
> @@ -1154,6 +1167,15 @@ static int init_tdx_module(void)
>  	 * as suggested by the TDX spec.
>  	 */
>  	tdmrs_reset_pamt_all(&tdx_tdmr_list);
> +	/*
> +	 * No more TDX private pages now, and PAMTs/TDMRs are
> +	 * going to be freed.  Make this globally visible so
> +	 * tdx_reset_memory() can read stable TDMRs/PAMTs.
> +	 *
> +	 * Note atomic_dec_return(), which is an atomic RMW with
> +	 * return value, always enforces the memory barrier.
> +	 */
> +	atomic_dec_return(&tdx_may_has_private_mem);
>  out_free_pamts:
>  	tdmrs_free_pamt_all(&tdx_tdmr_list);
>  out_free_tdmrs:
> @@ -1229,6 +1251,63 @@ int tdx_enable(void)
>  }
>  EXPORT_SYMBOL_GPL(tdx_enable);
>
> +/*
> + * Convert TDX private pages back to normal on platforms with
> + * "partial write machine check" erratum.
> + *
> + * Called from machine_kexec() before booting to the new kernel.
> + */
> +void tdx_reset_memory(void)
> +{
> +	if (!platform_tdx_enabled())
> +		return;
> +
> +	/*
> +	 * Kernel read/write to TDX private memory doesn't
> +	 * cause machine check on hardware w/o this erratum.
> +	 */
> +	if (!boot_cpu_has_bug(X86_BUG_TDX_PW_MCE))
> +		return;
> +
> +	/* Called from kexec() when only rebooting cpu is alive */
> +	WARN_ON_ONCE(num_online_cpus() != 1);
> +
> +	if (!atomic_read(&tdx_may_has_private_mem))
> +		return;
> +
> +	/*
> +	 * Ideally it's better to cover all types of TDX private pages,
> +	 * but there's no existing infrastructure to tell whether a page
> +	 * is TDX private memory or not.  Using SEAMCALL to query TDX
> +	 * module isn't feasible either because: 1) VMX has been turned
> +	 * off by reaching here so SEAMCALL cannot be made; 2) Even
> +	 * SEAMCALL can be made the result from TDX module may not be
> +	 * accurate (e.g., remote CPU can be stopped while the kernel
> +	 * is in the middle of reclaiming one TDX private page and doing
> +	 * MOVDIR64B).
> +	 *
> +	 * One solution could be just converting all memory pages, but
> +	 * this may bring non-trivial latency on large memory systems
> +	 * (especially when the number of TDX private pages is small).
> +	 * So even with this temporary solution, eventually the kernel
> +	 * should only convert TDX private pages.
> +	 *
> +	 * Also, not all pages are mapped as writable in direct mapping,
> +	 * thus it's problematic to do so.  It can be done by switching
> +	 * to the identical mapping table for kexec() or a new page table
> +	 * which maps all pages as writable, but the complexity looks
> +	 * overkill.
> +	 *
> +	 * Thus instead of doing something dramatic to convert all pages,
> +	 * only convert PAMTs as for now TDX private pages can only be
> +	 * PAMT.
> +	 *
> +	 * All other cpus are already dead.  TDMRs/PAMTs are stable when
> +	 * @tdx_may_has_private_mem reads true.
> +	 */
> +	tdmrs_reset_pamt_all(&tdx_tdmr_list);
> +}
> +
>  static int __init record_keyid_partitioning(u32 *tdx_keyid_start,
>  					    u32 *nr_tdx_keyids)
>  {
> --
> 2.40.1
>
