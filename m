Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98232776025
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 15:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbjHINDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 09:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjHINDu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 09:03:50 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D5A181FF6;
        Wed,  9 Aug 2023 06:03:48 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1112)
        id 4F30C20FC445; Wed,  9 Aug 2023 06:03:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4F30C20FC445
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1691586228;
        bh=ZOg04T6leFYaxYoAwcGJOglGojik2RqT8goiz+dSQms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m06ecmMP9oif+Mcm9fNOh1b1Wrcv9y3jxKVZSKgol5FB4rI72/8jroAGzELcLgte7
         YPjNtHh9x19m5vplrg+CB802eoDyZL+VQWLyZy4PjFwqE6xtOvoQQ9cl14Wn2y4jcU
         jsepLOwpcalspU2LUC+wOOvs5wQUjsVCoiV1frQs=
Date:   Wed, 9 Aug 2023 06:03:48 -0700
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v9 07/51] x86/sev: Add the host SEV-SNP
 initialization support
Message-ID: <20230809130348.GA12884@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-8-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612042559.375660-8-michael.roth@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 11, 2023 at 11:25:15PM -0500, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The memory integrity guarantees of SEV-SNP are enforced through a new
> structure called the Reverse Map Table (RMP). The RMP is a single data
> structure shared across the system that contains one entry for every 4K
> page of DRAM that may be used by SEV-SNP VMs. APM2 section 15.36 details
> a number of steps needed to detect/enable SEV-SNP and RMP table support
> on the host:
> 
>  - Detect SEV-SNP support based on CPUID bit
>  - Initialize the RMP table memory reported by the RMP base/end MSR
>    registers and configure IOMMU to be compatible with RMP access
>    restrictions
>  - Set the MtrrFixDramModEn bit in SYSCFG MSR
>  - Set the SecureNestedPagingEn and VMPLEn bits in the SYSCFG MSR
>  - Configure IOMMU
> 
> RMP table entry format is non-architectural and it can vary by
> processor. It is defined by the PPR. Restrict SNP support to CPU
> models/families which are compatible with the current RMP table entry
> format to guard against any undefined behavior when running on other
> system types. Future models/support will handle this through an
> architectural mechanism to allow for broader compatibility.
> 
> SNP host code depends on CONFIG_KVM_AMD_SEV config flag, which may be
> enabled even when CONFIG_AMD_MEM_ENCRYPT isn't set, so update the
> SNP-specific IOMMU helpers used here to rely on CONFIG_KVM_AMD_SEV
> instead of CONFIG_AMD_MEM_ENCRYPT.
> 
> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Co-developed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> [mdr: rework commit message to be clearer about what patch does, squash
>       in early_rmptable_check() handling from Tom]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/coco/Makefile                   |   1 +
>  arch/x86/coco/sev/Makefile               |   3 +
>  arch/x86/coco/sev/host.c                 | 212 +++++++++++++++++++++++
>  arch/x86/include/asm/disabled-features.h |   8 +-
>  arch/x86/include/asm/msr-index.h         |  11 +-
>  arch/x86/include/asm/sev.h               |   2 +
>  arch/x86/kernel/cpu/amd.c                |  19 ++
>  drivers/iommu/amd/init.c                 |   2 +-
>  include/linux/amd-iommu.h                |   2 +-
>  9 files changed, 256 insertions(+), 4 deletions(-)
>  create mode 100644 arch/x86/coco/sev/Makefile
>  create mode 100644 arch/x86/coco/sev/host.c
> 
> diff --git a/arch/x86/coco/Makefile b/arch/x86/coco/Makefile
> index 6aa52e719bf5..6a7d876130e2 100644
> --- a/arch/x86/coco/Makefile
> +++ b/arch/x86/coco/Makefile
> @@ -6,3 +6,4 @@ CFLAGS_core.o		+= -fno-stack-protector
>  obj-$(CONFIG_ARCH_HAS_CC_PLATFORM) += core.o
>  
>  obj-$(CONFIG_INTEL_TDX_GUEST)	+= tdx/
> +obj-$(CONFIG_KVM_AMD_SEV)	+= sev/
> diff --git a/arch/x86/coco/sev/Makefile b/arch/x86/coco/sev/Makefile
> new file mode 100644
> index 000000000000..27c0500d75c8
> --- /dev/null
> +++ b/arch/x86/coco/sev/Makefile
> @@ -0,0 +1,3 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +obj-y += host.o
> diff --git a/arch/x86/coco/sev/host.c b/arch/x86/coco/sev/host.c
> new file mode 100644
> index 000000000000..6907ce887b23
> --- /dev/null
> +++ b/arch/x86/coco/sev/host.c
> @@ -0,0 +1,212 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * AMD SVM-SEV Host Support.
> + *
> + * Copyright (C) 2023 Advanced Micro Devices, Inc.
> + *
> + * Author: Ashish Kalra <ashish.kalra@amd.com>
> + *
> + */
> +
> +#include <linux/cc_platform.h>
> +#include <linux/printk.h>
> +#include <linux/mm_types.h>
> +#include <linux/set_memory.h>
> +#include <linux/memblock.h>
> +#include <linux/kernel.h>
> +#include <linux/mm.h>
> +#include <linux/cpumask.h>
> +#include <linux/iommu.h>
> +#include <linux/amd-iommu.h>
> +
> +#include <asm/sev.h>
> +#include <asm/processor.h>
> +#include <asm/setup.h>
> +#include <asm/svm.h>
> +#include <asm/smp.h>
> +#include <asm/cpu.h>
> +#include <asm/apic.h>
> +#include <asm/cpuid.h>
> +#include <asm/cmdline.h>
> +#include <asm/iommu.h>
> +
> +/*
> + * The first 16KB from the RMP_BASE is used by the processor for the
> + * bookkeeping, the range needs to be added during the RMP entry lookup.
> + */
> +#define RMPTABLE_CPU_BOOKKEEPING_SZ	0x4000
> +
> +static unsigned long rmptable_start __ro_after_init;
> +static unsigned long rmptable_end __ro_after_init;
> +
> +#undef pr_fmt
> +#define pr_fmt(fmt)	"SEV-SNP: " fmt
> +
> +static int __mfd_enable(unsigned int cpu)
> +{
> +	u64 val;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return 0;
> +
> +	rdmsrl(MSR_AMD64_SYSCFG, val);
> +
> +	val |= MSR_AMD64_SYSCFG_MFDM;
> +
> +	wrmsrl(MSR_AMD64_SYSCFG, val);
> +
> +	return 0;
> +}
> +
> +static __init void mfd_enable(void *arg)
> +{
> +	__mfd_enable(smp_processor_id());
> +}
> +
> +static int __snp_enable(unsigned int cpu)
> +{
> +	u64 val;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return 0;
> +
> +	rdmsrl(MSR_AMD64_SYSCFG, val);
> +
> +	val |= MSR_AMD64_SYSCFG_SNP_EN;
> +	val |= MSR_AMD64_SYSCFG_SNP_VMPL_EN;
> +
> +	wrmsrl(MSR_AMD64_SYSCFG, val);
> +
> +	return 0;
> +}
> +
> +static __init void snp_enable(void *arg)
> +{
> +	__snp_enable(smp_processor_id());
> +}
> +
> +bool snp_get_rmptable_info(u64 *start, u64 *len)
> +{
> +	u64 max_rmp_pfn, calc_rmp_sz, rmp_sz, rmp_base, rmp_end;
> +
> +	rdmsrl(MSR_AMD64_RMP_BASE, rmp_base);
> +	rdmsrl(MSR_AMD64_RMP_END, rmp_end);
> +
> +	if (!rmp_base || !rmp_end) {
> +		pr_err("Memory for the RMP table has not been reserved by BIOS\n");
> +		return false;
> +	}
> +
> +	rmp_sz = rmp_end - rmp_base + 1;
> +
> +	/*
> +	 * Calculate the amount the memory that must be reserved by the BIOS to
> +	 * address the whole RAM, including the bookkeeping area. The RMP itself
> +	 * must also be covered.
> +	 */
> +	max_rmp_pfn = max_pfn;
> +	if (PHYS_PFN(rmp_end) > max_pfn)
> +		max_rmp_pfn = PHYS_PFN(rmp_end);
> +
> +	calc_rmp_sz = (max_rmp_pfn << 4) + RMPTABLE_CPU_BOOKKEEPING_SZ;
> +
> +	if (calc_rmp_sz > rmp_sz) {
> +		pr_err("Memory reserved for the RMP table does not cover full system RAM (expected 0x%llx got 0x%llx)\n",
> +		       calc_rmp_sz, rmp_sz);
> +		return false;
> +	}
> +
> +	*start = rmp_base;
> +	*len = rmp_sz;
> +
> +	return true;
> +}
> +
> +static __init int __snp_rmptable_init(void)
> +{
> +	u64 rmp_base, sz;
> +	void *start;
> +	u64 val;
> +
> +	if (!snp_get_rmptable_info(&rmp_base, &sz))
> +		return 1;
> +
> +	pr_info("RMP table physical address [0x%016llx - 0x%016llx]\n",
> +		rmp_base, rmp_base + sz - 1);
> +
> +	start = memremap(rmp_base, sz, MEMREMAP_WB);
> +	if (!start) {
> +		pr_err("Failed to map RMP table addr 0x%llx size 0x%llx\n", rmp_base, sz);
> +		return 1;
> +	}
> +
> +	/*
> +	 * Check if SEV-SNP is already enabled, this can happen in case of
> +	 * kexec boot.
> +	 */
> +	rdmsrl(MSR_AMD64_SYSCFG, val);
> +	if (val & MSR_AMD64_SYSCFG_SNP_EN)
> +		goto skip_enable;
> +
> +	/* Initialize the RMP table to zero */
> +	memset(start, 0, sz);
> +
> +	/* Flush the caches to ensure that data is written before SNP is enabled. */
> +	wbinvd_on_all_cpus();
> +
> +	/* MFDM must be enabled on all the CPUs prior to enabling SNP. */
> +	on_each_cpu(mfd_enable, NULL, 1);
> +
> +	/* Enable SNP on all CPUs. */
> +	on_each_cpu(snp_enable, NULL, 1);
> +
> +skip_enable:
> +	rmptable_start = (unsigned long)start;
> +	rmptable_end = rmptable_start + sz - 1;
> +
> +	return 0;
> +}
> +
> +static int __init snp_rmptable_init(void)
> +{
> +	int family, model;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return 0;
> +
> +	family = boot_cpu_data.x86;
> +	model  = boot_cpu_data.x86_model;
> +
> +	/*
> +	 * RMP table entry format is not architectural and it can vary by processor and
> +	 * is defined by the per-processor PPR. Restrict SNP support on the known CPU
> +	 * model and family for which the RMP table entry format is currently defined for.
> +	 */
> +	if (!(family == 0x19 && model <= 0xaf) && !(family == 0x1a && model <= 0xf))
> +		goto nosnp;
> +
> +	if (amd_iommu_snp_enable())
> +		goto nosnp;
> +
> +	if (__snp_rmptable_init())
> +		goto nosnp;
> +
> +	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/rmptable_init:online", __snp_enable, NULL);
> +
> +	return 0;
> +
> +nosnp:
> +	setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
> +	return -ENOSYS;
> +}
> +
> +/*
> + * This must be called after the PCI subsystem. This is because amd_iommu_snp_enable()
> + * is called to ensure the IOMMU supports the SEV-SNP feature, which can only be
> + * called after subsys_initcall().
> + *
> + * NOTE: IOMMU is enforced by SNP to ensure that hypervisor cannot program DMA
> + * directly into guest private memory. In case of SNP, the IOMMU ensures that
> + * the page(s) used for DMA are hypervisor owned.
> + */
> +fs_initcall(snp_rmptable_init);
> diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
> index 5dfa4fb76f4b..0a9938aea305 100644
> --- a/arch/x86/include/asm/disabled-features.h
> +++ b/arch/x86/include/asm/disabled-features.h
> @@ -99,6 +99,12 @@
>  # define DISABLE_TDX_GUEST	(1 << (X86_FEATURE_TDX_GUEST & 31))
>  #endif
>  
> +#ifdef CONFIG_KVM_AMD_SEV
> +# define DISABLE_SEV_SNP	0
> +#else
> +# define DISABLE_SEV_SNP	(1 << (X86_FEATURE_SEV_SNP & 31))
> +#endif
> +
>  /*
>   * Make sure to add features to the correct mask
>   */
> @@ -123,7 +129,7 @@
>  			 DISABLE_ENQCMD)
>  #define DISABLED_MASK17	0
>  #define DISABLED_MASK18	0
> -#define DISABLED_MASK19	0
> +#define DISABLED_MASK19	(DISABLE_SEV_SNP)
>  #define DISABLED_MASK20	0
>  #define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 21)
>  
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index ad35355ee43e..db0f3a041930 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -574,6 +574,8 @@
>  #define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
>  #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
>  #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
> +#define MSR_AMD64_RMP_BASE		0xc0010132
> +#define MSR_AMD64_RMP_END		0xc0010133
>  
>  /* SNP feature bits enabled by the hypervisor */
>  #define MSR_AMD64_SNP_VTOM			BIT_ULL(3)
> @@ -675,7 +677,14 @@
>  #define MSR_K8_TOP_MEM2			0xc001001d
>  #define MSR_AMD64_SYSCFG		0xc0010010
>  #define MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT	23
> -#define MSR_AMD64_SYSCFG_MEM_ENCRYPT	BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
> +#define MSR_AMD64_SYSCFG_MEM_ENCRYPT		BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
> +#define MSR_AMD64_SYSCFG_SNP_EN_BIT		24
> +#define MSR_AMD64_SYSCFG_SNP_EN		BIT_ULL(MSR_AMD64_SYSCFG_SNP_EN_BIT)
> +#define MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT	25
> +#define MSR_AMD64_SYSCFG_SNP_VMPL_EN		BIT_ULL(MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT)
> +#define MSR_AMD64_SYSCFG_MFDM_BIT		19
> +#define MSR_AMD64_SYSCFG_MFDM			BIT_ULL(MSR_AMD64_SYSCFG_MFDM_BIT)
> +
>  #define MSR_K8_INT_PENDING_MSG		0xc0010055
>  /* C1E active bits in int pending message */
>  #define K8_INTP_C1E_ACTIVE_MASK		0x18000000
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index ebc271bb6d8e..d34c46db7dd1 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -197,6 +197,7 @@ void snp_set_wakeup_secondary_cpu(void);
>  bool snp_init(struct boot_params *bp);
>  void __init __noreturn snp_abort(void);
>  int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, unsigned long *fw_err);
> +bool snp_get_rmptable_info(u64 *start, u64 *len);
>  #else
>  static inline void sev_es_ist_enter(struct pt_regs *regs) { }
>  static inline void sev_es_ist_exit(void) { }
> @@ -221,6 +222,7 @@ static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *in
>  {
>  	return -ENOTTY;
>  }
> +static inline bool snp_get_rmptable_info(u64 *start, u64 *len) { return false; }
>  #endif
>  
>  #endif
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index a79774181f22..1493ddf89fdf 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -20,6 +20,7 @@
>  #include <asm/delay.h>
>  #include <asm/debugreg.h>
>  #include <asm/resctrl.h>
> +#include <asm/sev.h>
>  
>  #ifdef CONFIG_X86_64
>  # include <asm/mmconfig.h>
> @@ -546,6 +547,20 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
>  	resctrl_cpu_detect(c);
>  }
>  
> +static bool early_rmptable_check(void)
> +{
> +	u64 rmp_base, rmp_size;
> +
> +	/*
> +	 * For early BSP initialization, max_pfn won't be set up yet, wait until
> +	 * it is set before performing the RMP table calculations.
> +	 */
> +	if (!max_pfn)
> +		return true;
> +
> +	return snp_get_rmptable_info(&rmp_base, &rmp_size);
> +}
> +

When CONFIG_AMD_MEM_ENCRYPT=y && CONFIG_KVM=n (=> CONFIG_KVM_AMD_SEV=n) this
results in an undefined reference to snp_get_rmptable_info when linking this
file. The header provides a stub when AMD_MEM_ENCRYPT=n but the definition is
only compiled in when KVM_AMD_SEV=y

Jeremi
