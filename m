Return-Path: <kvm+bounces-5634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4079682403B
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 12:05:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC9B3B23C39
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 11:05:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00FB4210F5;
	Thu,  4 Jan 2024 11:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="VheHODcc"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBF99210E6;
	Thu,  4 Jan 2024 11:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [192.168.178.49] (dynamic-adsl-84-220-28-122.clienti.tiscali.it [84.220.28.122])
	by linux.microsoft.com (Postfix) with ESMTPSA id 4CEB620ACF06;
	Thu,  4 Jan 2024 03:05:30 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4CEB620ACF06
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1704366338;
	bh=yMRk+YWs/fCt+vxfI4WRzBXKcMpCD+On2t7pPFbnC1E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VheHODccQjYRlDw768oEU15RPYoypo/bxnmhqWquqF727K92rusOj4qboqs4h8wUo
	 RdIRBW9Tl2lcCbUOVJBjkxrH/K9/cfn6B+v75pXaU/5dZDysbfyINTx95NV+9H70rW
	 DrKgfr3lsSyAU5pHjT54BAJmH8TmScx30Jx4gpw4=
Message-ID: <f60c5fe0-9909-468d-8160-34d5bae39305@linux.microsoft.com>
Date: Thu, 4 Jan 2024 12:05:27 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 04/26] x86/sev: Add the host SEV-SNP initialization
 support
To: Michael Roth <michael.roth@amd.com>, x86@kernel.org
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
 slp@redhat.com, pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com, tobin@ibm.com,
 bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com,
 zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-5-michael.roth@amd.com>
Content-Language: en-US
From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <20231230161954.569267-5-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 30/12/2023 17:19, Michael Roth wrote:
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
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Co-developed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Co-developed-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/Kbuild                  |   2 +
>  arch/x86/include/asm/msr-index.h |  11 +-
>  arch/x86/include/asm/sev.h       |   6 +
>  arch/x86/kernel/cpu/amd.c        |  15 +++
>  arch/x86/virt/svm/Makefile       |   3 +
>  arch/x86/virt/svm/sev.c          | 219 +++++++++++++++++++++++++++++++
>  6 files changed, 255 insertions(+), 1 deletion(-)
>  create mode 100644 arch/x86/virt/svm/Makefile
>  create mode 100644 arch/x86/virt/svm/sev.c
> 
> diff --git a/arch/x86/Kbuild b/arch/x86/Kbuild
> index 5a83da703e87..6a1f36df6a18 100644
> --- a/arch/x86/Kbuild
> +++ b/arch/x86/Kbuild
> @@ -28,5 +28,7 @@ obj-y += net/
>  
>  obj-$(CONFIG_KEXEC_FILE) += purgatory/
>  
> +obj-y += virt/svm/
> +
>  # for cleaning
>  subdir- += boot tools
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index f1bd7b91b3c6..15ce1269f270 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -599,6 +599,8 @@
>  #define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
>  #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
>  #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
> +#define MSR_AMD64_RMP_BASE		0xc0010132
> +#define MSR_AMD64_RMP_END		0xc0010133
>  
>  /* SNP feature bits enabled by the hypervisor */
>  #define MSR_AMD64_SNP_VTOM			BIT_ULL(3)
> @@ -709,7 +711,14 @@
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
> index 5b4a1ce3d368..1f59d8ba9776 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -243,4 +243,10 @@ static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
>  static inline u64 sev_get_status(void) { return 0; }
>  #endif
>  
> +#ifdef CONFIG_KVM_AMD_SEV
> +bool snp_probe_rmptable_info(void);
> +#else
> +static inline bool snp_probe_rmptable_info(void) { return false; }
> +#endif
> +
>  #endif
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 9a17165dfe84..0f0d425f0440 100644
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
> @@ -574,6 +575,20 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
>  		break;
>  	}
>  
> +	if (cpu_has(c, X86_FEATURE_SEV_SNP)) {
> +		/*
> +		 * RMP table entry format is not architectural and it can vary by processor
> +		 * and is defined by the per-processor PPR. Restrict SNP support on the
> +		 * known CPU model and family for which the RMP table entry format is
> +		 * currently defined for.
> +		 */
> +		if (!(c->x86 == 0x19 && c->x86_model <= 0xaf) &&
> +		    !(c->x86 == 0x1a && c->x86_model <= 0xf))
> +			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
> +		else if (!snp_probe_rmptable_info())
> +			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);

Is there a really good reason to perform the snp_probe_smptable_info() check at this
point (instead of in snp_rmptable_init). snp_rmptable_init will also clear the cap
on failure, and bsp_init_amd() runs too early to allow for the kernel to allocate the
rmptable itself. I pointed out in the previous review that kernel allocation of rmptable
is necessary in SNP-host capable VMs in Azure.

> +	}
> +
>  	return;
>  
>  warn:
> diff --git a/arch/x86/virt/svm/Makefile b/arch/x86/virt/svm/Makefile
> new file mode 100644
> index 000000000000..ef2a31bdcc70
> --- /dev/null
> +++ b/arch/x86/virt/svm/Makefile
> @@ -0,0 +1,3 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +obj-$(CONFIG_KVM_AMD_SEV) += sev.o
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> new file mode 100644
> index 000000000000..ce7ede9065ed
> --- /dev/null
> +++ b/arch/x86/virt/svm/sev.c
> @@ -0,0 +1,219 @@
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
> + * The RMP entry format is not architectural. The format is defined in PPR
> + * Family 19h Model 01h, Rev B1 processor.
> + */
> +struct rmpentry {
> +	u64	assigned	: 1,
> +		pagesize	: 1,
> +		immutable	: 1,
> +		rsvd1		: 9,
> +		gpa		: 39,
> +		asid		: 10,
> +		vmsa		: 1,
> +		validated	: 1,
> +		rsvd2		: 1;
> +	u64 rsvd3;
> +} __packed;
> +
> +/*
> + * The first 16KB from the RMP_BASE is used by the processor for the
> + * bookkeeping, the range needs to be added during the RMP entry lookup.
> + */
> +#define RMPTABLE_CPU_BOOKKEEPING_SZ	0x4000
> +
> +static u64 probed_rmp_base, probed_rmp_size;
> +static struct rmpentry *rmptable __ro_after_init;
> +static u64 rmptable_max_pfn __ro_after_init;
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
> +#define RMP_ADDR_MASK GENMASK_ULL(51, 13)
> +
> +bool snp_probe_rmptable_info(void)
> +{
> +	u64 max_rmp_pfn, calc_rmp_sz, rmp_sz, rmp_base, rmp_end;
> +
> +	rdmsrl(MSR_AMD64_RMP_BASE, rmp_base);
> +	rdmsrl(MSR_AMD64_RMP_END, rmp_end);
> +
> +	if (!(rmp_base & RMP_ADDR_MASK) || !(rmp_end & RMP_ADDR_MASK)) {
> +		pr_err("Memory for the RMP table has not been reserved by BIOS\n");
> +		return false;
> +	}
> +
> +	if (rmp_base > rmp_end) {
> +		pr_err("RMP configuration not valid: base=%#llx, end=%#llx\n", rmp_base, rmp_end);
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
> +	probed_rmp_base = rmp_base;
> +	probed_rmp_size = rmp_sz;
> +
> +	pr_info("RMP table physical range [0x%016llx - 0x%016llx]\n",
> +		probed_rmp_base, probed_rmp_base + probed_rmp_size - 1);
> +
> +	return true;
> +}
> +
> +static int __init __snp_rmptable_init(void)
> +{
> +	u64 rmptable_size;
> +	void *rmptable_start;
> +	u64 val;
> +
> +	if (!probed_rmp_size)
> +		return 1;
> +
> +	rmptable_start = memremap(probed_rmp_base, probed_rmp_size, MEMREMAP_WB);
> +	if (!rmptable_start) {
> +		pr_err("Failed to map RMP table\n");
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
> +	memset(rmptable_start, 0, probed_rmp_size);
> +
> +	/* Flush the caches to ensure that data is written before SNP is enabled. */
> +	wbinvd_on_all_cpus();
> +
> +	/* MtrrFixDramModEn must be enabled on all the CPUs prior to enabling SNP. */
> +	on_each_cpu(mfd_enable, NULL, 1);
> +
> +	on_each_cpu(snp_enable, NULL, 1);
> +
> +skip_enable:
> +	rmptable_start += RMPTABLE_CPU_BOOKKEEPING_SZ;
> +	rmptable_size = probed_rmp_size - RMPTABLE_CPU_BOOKKEEPING_SZ;
> +
> +	rmptable = (struct rmpentry *)rmptable_start;
> +	rmptable_max_pfn = rmptable_size / sizeof(struct rmpentry) - 1;
> +
> +	return 0;
> +}
> +
> +static int __init snp_rmptable_init(void)
> +{
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return 0;
> +
> +	if (!amd_iommu_snp_en)
> +		return 0;

Looks better - do you think it'll be OK to add a X86_FEATURE_HYPERVISOR check at this point
later to account for SNP-host capable VMs with no access to an iommu?

Jeremi

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
> + * This must be called after the IOMMU has been initialized.
> + */
> +device_initcall(snp_rmptable_init);


