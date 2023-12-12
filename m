Return-Path: <kvm+bounces-4183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F7E280EE8B
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 15:20:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E52A61F2160A
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 14:20:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41FD07317F;
	Tue, 12 Dec 2023 14:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BgNAEYJ2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647A28F;
	Tue, 12 Dec 2023 06:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702390791; x=1733926791;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EGhjL9ylhz8QR8pccKl4mwDgsSowp5n+VrAzEKgAVPg=;
  b=BgNAEYJ2HeZTsKck8OMBbxbqBObiZpGr49aoJeL1bgYF7JM72TE+6EuO
   aT62WMZZcBaS8IFFEEPAvyOZv4cOdK4TuMX2YmPzz7pWJhVmsF+Ym0Mjx
   NxvIsePukK0E2cFD6SwolyOyqrOP+0UnLJkY1Xso9ny/iWHuXNmEcowHR
   QmLO5b0dwCj7bFFii3UVSDa8IfDPVzBIsXx0CBgp+5Awub0rjxE8/TicZ
   3AFP41/enS3q7/hJc/pTktbS6SI9g4gAPCztKjcsraxj27Nd6wnKwQDWc
   45na2YsDXkiujiZ2HBKWcY62DAHV9HJpjRw9vW0T29pbl0jl/N2Ew+Ile
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="16364736"
X-IronPort-AV: E=Sophos;i="6.04,270,1695711600"; 
   d="scan'208";a="16364736"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 06:19:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="839450180"
X-IronPort-AV: E=Sophos;i="6.04,270,1695711600"; 
   d="scan'208";a="839450180"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.93.12.164]) ([10.93.12.164])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 06:19:47 -0800
Message-ID: <3d68f4db-0d9d-452f-b81d-dc94890207fa@linux.intel.com>
Date: Tue, 12 Dec 2023 22:19:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 020/116] KVM: TDX: create/destroy VM structure
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <997a92e4f667b497166ff8cc777ec8025b0f22bc.1699368322.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <997a92e4f667b497166ff8cc777ec8025b0f22bc.1699368322.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/7/2023 10:55 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> As the first step to create TDX guest, create/destroy VM struct.  Assign
> TDX private Host Key ID (HKID) to the TDX guest for memory encryption and
> allocate extra pages for the TDX guest. On destruction, free allocated
> pages, and HKID.
>
> Before tearing down private page tables, TDX requires some resources of the
> guest TD to be destroyed (i.e. HKID must have been reclaimed, etc).  Add
> mmu notifier release callback before tearing down private page tables for
> it.
>
> Add vm_free() of kvm_x86_ops hook at the end of kvm_arch_destroy_vm()
> because some per-VM TDX resources, e.g. TDR, need to be freed after other
> TDX resources, e.g. HKID, were freed.
>
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>
> ---
> v16:
> - Simplified tdx_reclaim_page()
> - Reorganize the locking of tdx_release_hkid(), and use smp_call_mask()
>    instead of smp_call_on_cpu() to hold spinlock to race with invalidation
>    on releasing guest memfd
> ---
>   arch/x86/include/asm/kvm-x86-ops.h |   2 +
>   arch/x86/include/asm/kvm_host.h    |   2 +
>   arch/x86/kvm/Kconfig               |   2 +
>   arch/x86/kvm/mmu/mmu.c             |   7 +
>   arch/x86/kvm/vmx/main.c            |  35 ++-
>   arch/x86/kvm/vmx/tdx.c             | 471 ++++++++++++++++++++++++++++-
>   arch/x86/kvm/vmx/tdx.h             |   6 +-
>   arch/x86/kvm/vmx/x86_ops.h         |   8 +
>   arch/x86/kvm/x86.c                 |   1 +
>   9 files changed, 528 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index b7b591f1ff72..d05a829254ea 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -24,7 +24,9 @@ KVM_X86_OP(is_vm_type_supported)
>   KVM_X86_OP_OPTIONAL(max_vcpus);
>   KVM_X86_OP_OPTIONAL(vm_enable_cap)
>   KVM_X86_OP(vm_init)
> +KVM_X86_OP_OPTIONAL(flush_shadow_all_private)
>   KVM_X86_OP_OPTIONAL(vm_destroy)
> +KVM_X86_OP_OPTIONAL(vm_free)
>   KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
>   KVM_X86_OP(vcpu_create)
>   KVM_X86_OP(vcpu_free)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f240c3d025b1..742ac63e1992 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1578,7 +1578,9 @@ struct kvm_x86_ops {
>   	unsigned int vm_size;
>   	int (*vm_enable_cap)(struct kvm *kvm, struct kvm_enable_cap *cap);
>   	int (*vm_init)(struct kvm *kvm);
> +	void (*flush_shadow_all_private)(struct kvm *kvm);
>   	void (*vm_destroy)(struct kvm *kvm);
> +	void (*vm_free)(struct kvm *kvm);
>   
>   	/* Create, but do not attach this VCPU */
>   	int (*vcpu_precreate)(struct kvm *kvm);
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index c1716e83d176..54377bdb6443 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -92,6 +92,8 @@ config KVM_SW_PROTECTED_VM
>   config KVM_INTEL
>   	tristate "KVM for Intel (and compatible) processors support"
>   	depends on KVM && IA32_FEAT_CTL
> +	select KVM_SW_PROTECTED_VM if INTEL_TDX_HOST
> +	select KVM_PRIVATE_MEM if INTEL_TDX_HOST
>   	help
>   	  Provides support for KVM on processors equipped with Intel's VT
>   	  extensions, a.k.a. Virtual Machine Extensions (VMX).
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 70088b6455a8..96490379ca60 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6795,6 +6795,13 @@ static void kvm_mmu_zap_all(struct kvm *kvm)
>   
>   void kvm_arch_flush_shadow_all(struct kvm *kvm)
>   {
> +	/*
> +	 * kvm_mmu_zap_all() zaps both private and shared page tables.  Before
> +	 * tearing down private page tables, TDX requires some TD resources to
> +	 * be destroyed (i.e. keyID must have been reclaimed, etc).  Invoke
> +	 * kvm_x86_flush_shadow_all_private() for this.
> +	 */
> +	static_call_cond(kvm_x86_flush_shadow_all_private)(kvm);
This Op name seems it related to flush pagetables, but actually it not.
Maybe  "flush_shadow_all_prepare" or other name having less confusion?

>   	kvm_mmu_zap_all(kvm);
>   }
>   
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 5a857c8defd9..7082e9ea8492 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -63,14 +63,41 @@ static int vt_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>   	return -EINVAL;
>   }
>   
> +static void vt_hardware_unsetup(void)
> +{
> +	if (enable_tdx)
> +		tdx_hardware_unsetup();
> +	vmx_hardware_unsetup();
> +}
> +
>   static int vt_vm_init(struct kvm *kvm)
>   {
>   	if (is_td(kvm))
> -		return -EOPNOTSUPP;	/* Not ready to create guest TD yet. */
> +		return tdx_vm_init(kvm);
>   
>   	return vmx_vm_init(kvm);
>   }
>   
> +static void vt_flush_shadow_all_private(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		tdx_mmu_release_hkid(kvm);
> +}
> +
> +static void vt_vm_destroy(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		return;
> +
> +	vmx_vm_destroy(kvm);
> +}
> +
> +static void vt_vm_free(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		tdx_vm_free(kvm);
> +}
> +
>   static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>   {
>   	if (!is_td(kvm))
> @@ -93,7 +120,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   
>   	.check_processor_compatibility = vmx_check_processor_compat,
>   
> -	.hardware_unsetup = vmx_hardware_unsetup,
> +	.hardware_unsetup = vt_hardware_unsetup,
>   
>   	.hardware_enable = vt_hardware_enable,
>   	.hardware_disable = vmx_hardware_disable,
> @@ -104,7 +131,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.vm_size = sizeof(struct kvm_vmx),
>   	.vm_enable_cap = vt_vm_enable_cap,
>   	.vm_init = vt_vm_init,
> -	.vm_destroy = vmx_vm_destroy,
> +	.flush_shadow_all_private = vt_flush_shadow_all_private,
> +	.vm_destroy = vt_vm_destroy,
> +	.vm_free = vt_vm_free,
>   
>   	.vcpu_precreate = vmx_vcpu_precreate,
>   	.vcpu_create = vmx_vcpu_create,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 331fbaa10d46..692619411da2 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -5,9 +5,10 @@
>   
>   #include "capabilities.h"
>   #include "x86_ops.h"
> -#include "x86.h"
>   #include "mmu.h"
>   #include "tdx.h"
> +#include "tdx_ops.h"
> +#include "x86.h"
>   
>   #undef pr_fmt
>   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> @@ -47,6 +48,289 @@ int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>   	return r;
>   }
>   
> +struct tdx_info {
> +	u8 nr_tdcs_pages;
> +};
> +
> +/* Info about the TDX module. */
> +static struct tdx_info tdx_info __ro_after_init;
> +
> +/*
> + * Some TDX SEAMCALLs (TDH.MNG.CREATE, TDH.PHYMEM.CACHE.WB,
> + * TDH.MNG.KEY.RECLAIMID, TDH.MNG.KEY.FREEID etc) tries to acquire a global lock
> + * internally in TDX module.  If failed, TDX_OPERAND_BUSY is returned without
> + * spinning or waiting due to a constraint on execution time.  It's caller's
> + * responsibility to avoid race (or retry on TDX_OPERAND_BUSY).  Use this mutex
> + * to avoid race in TDX module because the kernel knows better about scheduling.
> + */
> +static DEFINE_MUTEX(tdx_lock);
> +static struct mutex *tdx_mng_key_config_lock;
> +
> +static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
> +{
> +	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
> +}
> +
> +static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
> +{
> +	return kvm_tdx->tdr_pa;
> +}
> +
> +static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
> +{
> +	tdx_guest_keyid_free(kvm_tdx->hkid);
> +	kvm_tdx->hkid = -1;
> +}
> +
> +static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
> +{
> +	return kvm_tdx->hkid > 0;
> +}
> +
> +static void tdx_clear_page(unsigned long page_pa)
> +{
> +	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> +	void *page = __va(page_pa);
> +	unsigned long i;
> +
> +	/*
> +	 * When re-assign one page from old keyid to a new keyid, MOVDIR64B is
> +	 * required to clear/write the page with new keyid to prevent integrity
> +	 * error when read on the page with new keyid.
> +	 *
> +	 * clflush doesn't flush cache with HKID set.  The cache line could be
> +	 * poisoned (even without MKTME-i), clear the poison bit.
> +	 */
> +	for (i = 0; i < PAGE_SIZE; i += 64)
> +		movdir64b(page + i, zero_page);
> +	/*
> +	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
> +	 * from seeing potentially poisoned cache.
> +	 */
> +	__mb();
> +}
> +
> +static int __tdx_reclaim_page(hpa_t pa)
> +{
> +	struct tdx_module_args out;
> +	u64 err;
> +
> +	do {
> +		err = tdh_phymem_page_reclaim(pa, &out);
> +		/*
> +		 * TDH.PHYMEM.PAGE.RECLAIM is allowed only when TD is shutdown.
> +		 * state.  i.e. destructing TD.
> +		 * TDH.PHYMEM.PAGE.RECLAIM requires TDR and target page.
> +		 * Because we're destructing TD, it's rare to contend with TDR.
> +		 */
> +	} while (unlikely(err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX)));
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err, &out);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int tdx_reclaim_page(hpa_t pa)
> +{
> +	int r;
> +
> +	r = __tdx_reclaim_page(pa);
> +	if (!r)
> +		tdx_clear_page(pa);
> +	return r;
> +}
> +
> +static void tdx_reclaim_td_page(unsigned long td_page_pa)
> +{
> +	WARN_ON_ONCE(!td_page_pa);
> +
> +	/*
> +	 * TDCX are being reclaimed.  TDX module maps TDCX with HKID
> +	 * assigned to the TD.  Here the cache associated to the TD
> +	 * was already flushed by TDH.PHYMEM.CACHE.WB before here, So
> +	 * cache doesn't need to be flushed again.
> +	 */
> +	if (tdx_reclaim_page(td_page_pa))
> +		/*
> +		 * Leak the page on failure:
> +		 * tdx_reclaim_page() returns an error if and only if there's an
> +		 * unexpected, fatal error, e.g. a SEAMCALL with bad params,
> +		 * incorrect concurrency in KVM, a TDX Module bug, etc.
> +		 * Retrying at a later point is highly unlikely to be
> +		 * successful.
> +		 * No log here as tdx_reclaim_page() already did.
> +		 */
> +		return;
> +	free_page((unsigned long)__va(td_page_pa));
> +}
> +
> +static void tdx_do_tdh_phymem_cache_wb(void *unused)
> +{
> +	u64 err = 0;
> +
> +	do {
> +		err = tdh_phymem_cache_wb(!!err);
> +	} while (err == TDX_INTERRUPTED_RESUMABLE);
> +
> +	/* Other thread may have done for us. */
> +	if (err == TDX_NO_HKID_READY_TO_WBCACHE)
> +		err = TDX_SUCCESS;
> +	if (WARN_ON_ONCE(err))
> +		pr_tdx_error(TDH_PHYMEM_CACHE_WB, err, NULL);
> +}
> +
> +void tdx_mmu_release_hkid(struct kvm *kvm)
> +{
> +	bool packages_allocated, targets_allocated;
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	cpumask_var_t packages, targets;
> +	u64 err;
> +	int i;
> +
> +	if (!is_hkid_assigned(kvm_tdx))
> +		return;
> +
> +	if (!is_td_created(kvm_tdx)) {
> +		tdx_hkid_free(kvm_tdx);
> +		return;
> +	}
> +
> +	packages_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
> +	targets_allocated = zalloc_cpumask_var(&targets, GFP_KERNEL);
> +	cpus_read_lock();
> +
> +	/*
> +	 * We can destroy multiple the guest TDs simultaneously.  Prevent
I think there is an extra "the" here.

> +	 * tdh_phymem_cache_wb from returning TDX_BUSY by serialization.
> +	 */
> +	mutex_lock(&tdx_lock);
> +
> +	/*
> +	 * Go through multiple TDX HKID state transitions with three SEAMCALLs
> +	 * to make TDH.PHYMEM.PAGE.RECLAIM() usable.  Make the transition atomic
> +	 * to other functions to operate private pages and Secure-EPT pages.
> +	 *
> +	 * Avoid race for kvm_gmem_release() to call kvm_mmu_unmap_gfn_range().
> +	 * This function is called via mmu notifier, mmu_release().
> +	 * kvm_gmem_release() is called via fput() on process exit.
> +	 */
> +	write_lock(&kvm->mmu_lock);
> +
> +	for_each_online_cpu(i) {
> +		if (packages_allocated &&
> +		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
> +					     packages))
> +			continue;
> +		if (targets_allocated)
> +			cpumask_set_cpu(i, targets);
> +	}
> +	if (targets_allocated)
> +		on_each_cpu_mask(targets, tdx_do_tdh_phymem_cache_wb, NULL, 1);
Although in exist kernel code, there are a lot of such usages,
but for new code, is it better to use 'true' for bool type ?

> +	else
> +		on_each_cpu(tdx_do_tdh_phymem_cache_wb, NULL, 1);
ditto

> +	/*
> +	 * In the case of error in tdx_do_tdh_phymem_cache_wb(), the following
> +	 * tdh_mng_key_freeid() will fail.
> +	 */
> +
An extra white line?

> +	err = tdh_mng_key_freeid(kvm_tdx->tdr_pa);
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_KEY_FREEID, err, NULL);
> +		pr_err("tdh_mng_key_freeid() failed. HKID %d is leaked.\n",
> +		       kvm_tdx->hkid);
> +	} else
> +		tdx_hkid_free(kvm_tdx);
> +
> +	write_unlock(&kvm->mmu_lock);
> +	mutex_unlock(&tdx_lock);
> +	cpus_read_unlock();
> +	free_cpumask_var(targets);
> +	free_cpumask_var(packages);
> +}
> +
[...]

