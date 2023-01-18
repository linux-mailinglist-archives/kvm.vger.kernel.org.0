Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3545672244
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 16:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjARP6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 10:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbjARP6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 10:58:21 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DAAFD568B8;
        Wed, 18 Jan 2023 07:55:02 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1112)
        id 8613820E09F3; Wed, 18 Jan 2023 07:55:02 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8613820E09F3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1674057302;
        bh=xuNrvowv2hcTLI73DVnfkxQ84AfOWijeQN8uwU3Si1Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ObVnY1z16hV8Et/ISM7DC3DNl7fd26Br85inzvm5NFmAc8yKfZWjJ7ISaNaA4lyG5
         A1aGLyzLLfrYr92nIAwp/Kzo+b4sjvBilvYYPR7ERfuX8VZMjJv2gCVVKawfzDq91B
         bibjjoDuStwIzDNCzKXh8ibeu4pHTnqm/UfbXViQ=
Date:   Wed, 18 Jan 2023 07:55:02 -0800
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        harald@profian.com, Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v7 14/64] x86/sev: Add the host SEV-SNP
 initialization support
Message-ID: <20230118155502.GB24742@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-15-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214194056.161492-15-michael.roth@amd.com>
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

On Wed, Dec 14, 2022 at 01:40:06PM -0600, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The memory integrity guarantees of SEV-SNP are enforced through a new
> structure called the Reverse Map Table (RMP). The RMP is a single data
> structure shared across the system that contains one entry for every 4K
> page of DRAM that may be used by SEV-SNP VMs. The goal of RMP is to
> track the owner of each page of memory. Pages of memory can be owned by
> the hypervisor, owned by a specific VM or owned by the AMD-SP. See APM2
> section 15.36.3 for more detail on RMP.
> 
> The RMP table is used to enforce access control to memory. The table itself
> is not directly writable by the software. New CPU instructions (RMPUPDATE,
> PVALIDATE, RMPADJUST) are used to manipulate the RMP entries.
> 
> Based on the platform configuration, the BIOS reserves the memory used
> for the RMP table. The start and end address of the RMP table must be
> queried by reading the RMP_BASE and RMP_END MSRs. If the RMP_BASE and
> RMP_END are not set then disable the SEV-SNP feature.
> 
> The SEV-SNP feature is enabled only after the RMP table is successfully
> initialized.
> 
> Also set SYSCFG.MFMD when enabling SNP as SEV-SNP FW >= 1.51 requires
> that SYSCFG.MFMD must be se
> 
> RMP table entry format is non-architectural and it can vary by processor
> and is defined by the PPR. Restrict SNP support on the known CPU model
> and family for which the RMP table entry format is currently defined for.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-b: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/include/asm/disabled-features.h |   8 +-
>  arch/x86/include/asm/msr-index.h         |  11 +-
>  arch/x86/kernel/sev.c                    | 180 +++++++++++++++++++++++
>  3 files changed, 197 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
> index 33d2cd04d254..9b5a2cc8064a 100644
> --- a/arch/x86/include/asm/disabled-features.h
> +++ b/arch/x86/include/asm/disabled-features.h
> @@ -87,6 +87,12 @@
>  # define DISABLE_TDX_GUEST	(1 << (X86_FEATURE_TDX_GUEST & 31))
>  #endif
>  
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +# define DISABLE_SEV_SNP	0
> +#else
> +# define DISABLE_SEV_SNP	(1 << (X86_FEATURE_SEV_SNP & 31))
> +#endif
> +
>  /*
>   * Make sure to add features to the correct mask
>   */
> @@ -110,7 +116,7 @@
>  			 DISABLE_ENQCMD)
>  #define DISABLED_MASK17	0
>  #define DISABLED_MASK18	0
> -#define DISABLED_MASK19	0
> +#define DISABLED_MASK19	(DISABLE_SEV_SNP)
>  #define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
>  
>  #endif /* _ASM_X86_DISABLED_FEATURES_H */
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 10ac52705892..35100c630617 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -565,6 +565,8 @@
>  #define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
>  #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
>  #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
> +#define MSR_AMD64_RMP_BASE		0xc0010132
> +#define MSR_AMD64_RMP_END		0xc0010133
>  
>  #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
>  
> @@ -649,7 +651,14 @@
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
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index a428c62330d3..687a91284506 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -22,6 +22,9 @@
>  #include <linux/efi.h>
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
> +#include <linux/cpumask.h>
> +#include <linux/iommu.h>
> +#include <linux/amd-iommu.h>
>  
>  #include <asm/cpu_entry_area.h>
>  #include <asm/stacktrace.h>
> @@ -38,6 +41,7 @@
>  #include <asm/apic.h>
>  #include <asm/cpuid.h>
>  #include <asm/cmdline.h>
> +#include <asm/iommu.h>
>  
>  #define DR7_RESET_VALUE        0x400
>  
> @@ -57,6 +61,12 @@
>  #define AP_INIT_CR0_DEFAULT		0x60000010
>  #define AP_INIT_MXCSR_DEFAULT		0x1f80
>  
> +/*
> + * The first 16KB from the RMP_BASE is used by the processor for the
> + * bookkeeping, the range needs to be added during the RMP entry lookup.
> + */
> +#define RMPTABLE_CPU_BOOKKEEPING_SZ	0x4000
> +
>  /* For early boot hypervisor communication in SEV-ES enabled guests */
>  static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
>  
> @@ -69,6 +79,9 @@ static struct ghcb *boot_ghcb __section(".data");
>  /* Bitmap of SEV features supported by the hypervisor */
>  static u64 sev_hv_features __ro_after_init;
>  
> +static unsigned long rmptable_start __ro_after_init;
> +static unsigned long rmptable_end __ro_after_init;
> +
>  /* #VC handler runtime per-CPU data */
>  struct sev_es_runtime_data {
>  	struct ghcb ghcb_page;
> @@ -2260,3 +2273,170 @@ static int __init snp_init_platform_device(void)
>  	return 0;
>  }
>  device_initcall(snp_init_platform_device);
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
> +static bool get_rmptable_info(u64 *start, u64 *len)
> +{
> +	u64 calc_rmp_sz, rmp_sz, rmp_base, rmp_end;
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
> +	 * address the whole RAM. The reserved memory should also cover the
> +	 * RMP table itself.
> +	 */
> +	calc_rmp_sz = (((rmp_sz >> PAGE_SHIFT) + totalram_pages()) << 4) + RMPTABLE_CPU_BOOKKEEPING_SZ;

Since the rmptable is indexed by page number, I believe this check should be
using max_pfn:

    calc_rmp_sz = (max_pfn << 4) + RMPTABLE_CPU_BOOKKEEPING_SZ;

This accounts for holes/offsets in the memory map which lead to the top of
memory having pfn > totalram_pages().

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
> +	pr_info("RMP table physical address [0x%016llx - 0x%016llx]\n", rmp_base, rmp_end);
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
> +	if (!get_rmptable_info(&rmp_base, &sz))
> +		return 1;
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
> +	if (family != 0x19 || model > 0xaf)
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
> -- 
> 2.25.1
> 
