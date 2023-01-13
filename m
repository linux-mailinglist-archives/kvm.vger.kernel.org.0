Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56AE9669864
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 14:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241677AbjAMNWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 08:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240868AbjAMNVj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 08:21:39 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0110834D7F;
        Fri, 13 Jan 2023 05:13:02 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id j17so33094109lfr.3;
        Fri, 13 Jan 2023 05:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TBlJzsZuA+a1loUn/fbvBhtFxT11x5RUCF3xtlS0QKI=;
        b=kG5eQczXcKzSNuxH6XvYQkyXbVKWqzfNwE6hLu9qV9wLCRkzcd25AaBwTH3uRkKOgQ
         7OdE/fY9ocGPyvMsZ/pKofeCLAwzwPGIiouyPRH3XjuonwMmOkAk2VuLvXhA3Cejt6gh
         78GNWasTnEcmnbAqyPE9jS9i1d4L5WhGH3qXKYN8xl9rlqvcmoU9TSMr+KnCGEiZ19rY
         hooa/ikr5xwRZbWIwSwmo94iDJvnwzgzt20JhMA21ASHKeO5Jsd7koGl9yD2IBVCfNaP
         Xo0+PyJs3Gq6EnchLXNb3fApGcVadyeOtZKRWH239yaPKhkPdOUll4HNGkmgtohco1uB
         3/Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TBlJzsZuA+a1loUn/fbvBhtFxT11x5RUCF3xtlS0QKI=;
        b=QtMlH96d2dmXCCY7V/I2ZRpglwzfLdwTOOaBaQiO+kNrPnNq6M2T8A4xY4wWX7mBIN
         7cWnsUmU9QOiiSCpN67oo1NDJwzZI8lt3Qkv/3SlPkgRc/wSe8oEuF7XC3ue+S31Wnn4
         7yJXRp9RFwboTA8LYM9d0oiKcAjYBsMO143Na5q6iJv2CR2JNCTO3oWNM1gjB48NixLe
         k4VVKW0xxeBh29jqcgln1AiSYcduY6Lo71HWGlquRNIIj4z87kQSBX4hKjXlTAIuCP/k
         EJsKwtiKlvtE72Flgm4wjqowV5fqN5DlR5quAS7WxdB1SC0GSxC21qmVkQNVuuAoJFt1
         beWw==
X-Gm-Message-State: AFqh2kprxkzUolDhZPuTConNi9JVhWyRekTlHWs8nEnpLyoG0gwMvUPp
        WKCohyqEPDojAldBDL0fxng=
X-Google-Smtp-Source: AMrXdXuU8F6YP8m35VXGCN9vV5VdHSmEvyXMV9RZLB0JmQjOAL+bjFFb9vL1ocAsLojw5rvUMpxHMw==
X-Received: by 2002:ac2:43a4:0:b0:4cb:3a60:65c2 with SMTP id t4-20020ac243a4000000b004cb3a6065c2mr2461318lfl.1.1673615580180;
        Fri, 13 Jan 2023 05:13:00 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id k14-20020a05651210ce00b00498f67cbfa9sm3842577lfg.22.2023.01.13.05.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 05:12:59 -0800 (PST)
Date:   Fri, 13 Jan 2023 15:12:58 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Message-ID: <20230113151258.00006a6d@gmail.com>
In-Reply-To: <68fa413e61d7471657174bc7c83bde5c842e251f.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
        <68fa413e61d7471657174bc7c83bde5c842e251f.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Jan 2023 08:31:26 -0800
isaku.yamahata@intel.com wrote:

> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> As the first step to create TDX guest, create/destroy VM struct.  Assign
> TDX private Host Key ID (HKID) to the TDX guest for memory encryption and
> allocate extra pages for the TDX guest. On destruction, free allocated
> pages, and HKID.
> 
> Before tearing down private page tables, TDX requires some resources of
> the guest TD to be destroyed (i.e. HKID must have been reclaimed, etc).
> Add flush_shadow_all_private callback before tearing down private page
> tables for it.
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
> Changes v10 -> v11:
> - Fix doule free in tdx_vm_free() by setting NULL.
> - replace struct tdx_td_page tdr and tdcs from struct kvm_tdx with
>   unsigned long
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |   2 +
>  arch/x86/include/asm/kvm_host.h    |   2 +
>  arch/x86/kvm/vmx/main.c            |  34 ++-
>  arch/x86/kvm/vmx/tdx.c             | 415 +++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/tdx.h             |   6 +-
>  arch/x86/kvm/vmx/x86_ops.h         |   9 +
>  arch/x86/kvm/x86.c                 |   8 +
>  7 files changed, 472 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h
> b/arch/x86/include/asm/kvm-x86-ops.h index e6708bb3f4f6..552de893af75
> 100644 --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -22,7 +22,9 @@ KVM_X86_OP(has_emulated_msr)
>  KVM_X86_OP(vcpu_after_set_cpuid)
>  KVM_X86_OP(is_vm_type_supported)
>  KVM_X86_OP(vm_init)
> +KVM_X86_OP_OPTIONAL(flush_shadow_all_private)
>  KVM_X86_OP_OPTIONAL(vm_destroy)
> +KVM_X86_OP_OPTIONAL(vm_free)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
>  KVM_X86_OP(vcpu_create)
>  KVM_X86_OP(vcpu_free)
> diff --git a/arch/x86/include/asm/kvm_host.h
> b/arch/x86/include/asm/kvm_host.h index 234c28c8e6ee..e199ddf0bb00 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1540,7 +1540,9 @@ struct kvm_x86_ops {
>  	bool (*is_vm_type_supported)(unsigned long vm_type);
>  	unsigned int vm_size;
>  	int (*vm_init)(struct kvm *kvm);
> +	void (*flush_shadow_all_private)(struct kvm *kvm);
>  	void (*vm_destroy)(struct kvm *kvm);
> +	void (*vm_free)(struct kvm *kvm);
>  
>  	/* Create, but do not attach this VCPU */
>  	int (*vcpu_precreate)(struct kvm *kvm);
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 781fbc896120..c5f2515026e9 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -29,14 +29,40 @@ static __init int vt_hardware_setup(void)
>  	return 0;
>  }
>  
> +static void vt_hardware_unsetup(void)
> +{
> +	tdx_hardware_unsetup();
> +	vmx_hardware_unsetup();
> +}
> +
>  static int vt_vm_init(struct kvm *kvm)
>  {
>  	if (is_td(kvm))
> -		return -EOPNOTSUPP;	/* Not ready to create guest
> TD yet. */
> +		return tdx_vm_init(kvm);
>  
>  	return vmx_vm_init(kvm);
>  }
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
>  static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	if (!is_td(kvm))
> @@ -50,7 +76,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  
>  	.check_processor_compatibility = vmx_check_processor_compat,
>  
> -	.hardware_unsetup = vmx_hardware_unsetup,
> +	.hardware_unsetup = vt_hardware_unsetup,
>  
>  	.hardware_enable = vmx_hardware_enable,
>  	.hardware_disable = vmx_hardware_disable,
> @@ -59,7 +85,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.is_vm_type_supported = vt_is_vm_type_supported,
>  	.vm_size = sizeof(struct kvm_vmx),
>  	.vm_init = vt_vm_init,
> -	.vm_destroy = vmx_vm_destroy,
> +	.flush_shadow_all_private = vt_flush_shadow_all_private,
> +	.vm_destroy = vt_vm_destroy,
> +	.vm_free = vt_vm_free,
>  
>  	.vcpu_precreate = vmx_vcpu_precreate,
>  	.vcpu_create = vmx_vcpu_create,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 2bd1cc37abab..d11950d18226 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -6,6 +6,7 @@
>  #include "capabilities.h"
>  #include "x86_ops.h"
>  #include "tdx.h"
> +#include "tdx_ops.h"
>  #include "x86.h"
>  
>  #undef pr_fmt
> @@ -32,6 +33,250 @@ struct tdx_capabilities {
>  /* Capabilities of KVM + the TDX module. */
>  static struct tdx_capabilities tdx_caps;
>  
> +/*
> + * Some TDX SEAMCALLs (TDH.MNG.CREATE, TDH.PHYMEM.CACHE.WB,
> + * TDH.MNG.KEY.RECLAIMID, TDH.MNG.KEY.FREEID etc) tries to acquire a
> global lock
> + * internally in TDX module.  If failed, TDX_OPERAND_BUSY is returned
> without
> + * spinning or waiting due to a constraint on execution time.  It's
> caller's
> + * responsibility to avoid race (or retry on TDX_OPERAND_BUSY).  Use
> this mutex
> + * to avoid race in TDX module because the kernel knows better about
> scheduling.
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
> +	tdx_keyid_free(kvm_tdx->hkid);
> +	kvm_tdx->hkid = 0;
> +}
> +
> +static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
> +{
> +	return kvm_tdx->hkid > 0;
> +}
> +
> +static void tdx_clear_page(unsigned long page_pa)
> +{
> +	const void *zero_page = (const void *)
> __va(page_to_phys(ZERO_PAGE(0)));
> +	void *page = __va(page_pa);
> +	unsigned long i;
> +
> +	if (!static_cpu_has(X86_FEATURE_MOVDIR64B)) {
> +		clear_page(page);
> +		return;
> +	}
> +
> +	/*
> +	 * Zeroing the page is only necessary for systems with MKTME-i:
> +	 * when re-assign one page from old keyid to a new keyid,
> MOVDIR64B is
> +	 * required to clear/write the page with new keyid to prevent
> integrity
> +	 * error when read on the page with new keyid.
> +	 *
> +	 * clflush doesn't flush cache with HKID set.
> +	 * The cache line could be poisoned (even without MKTME-i),
> clear the
> +	 * poison bit.
> +	 */
> +	for (i = 0; i < PAGE_SIZE; i += 64)
> +		movdir64b(page + i, zero_page);
> +	/*
> +	 * MOVDIR64B store uses WC buffer.  Prevent following memory
> reads
> +	 * from seeing potentially poisoned cache.
> +	 */
> +	__mb();
> +}
> +
> +static int tdx_reclaim_page(hpa_t pa, bool do_wb, u16 hkid)
> +{
> +	struct tdx_module_output out;
> +	u64 err;
> +
> +	do {
> +		err = tdh_phymem_page_reclaim(pa, &out);
> +		/*
> +		 * TDH.PHYMEM.PAGE.RECLAIM is allowed only when TD is
> shutdown.
> +		 * state.  i.e. destructing TD.
> +		 * TDH.PHYMEM.PAGE.RECLAIM  requires TDR and target
> page.
> +		 * Because we're destructing TD, it's rare to contend
> with TDR.
> +		 */
> +	} while (err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX));
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err, &out);
> +		return -EIO;
> +	}
> +
> +	if (do_wb) {
> +		/*
> +		 * Only TDR page gets into this path.  No contention is
> expected
> +		 * because of the last page of TD.
> +		 */
> +		err = tdh_phymem_page_wbinvd(set_hkid_to_hpa(pa, hkid));
> +		if (WARN_ON_ONCE(err)) {
> +			pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
> +			return -EIO;
> +		}
> +	}
> +
> +	tdx_clear_page(pa);
> +	return 0;
> +}
> +
> +static void tdx_reclaim_td_page(unsigned long td_page_pa)
> +{
> +	if (!td_page_pa)
> +		return;
> +	/*
> +	 * TDCX are being reclaimed.  TDX module maps TDCX with HKID
> +	 * assigned to the TD.  Here the cache associated to the TD
> +	 * was already flushed by TDH.PHYMEM.CACHE.WB before here, So
> +	 * cache doesn't need to be flushed again.
> +	 */
> +	if (WARN_ON(tdx_reclaim_page(td_page_pa, false, 0)))
> +		/* If reclaim failed, leak the page. */

Better add a FIXME: here as this has to be fixed later.

> +		return;
> +	free_page((unsigned long)__va(td_page_pa));
> +}
> +
> +static int tdx_do_tdh_phymem_cache_wb(void *param)
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
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_PHYMEM_CACHE_WB, err, NULL);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +void tdx_mmu_release_hkid(struct kvm *kvm)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	cpumask_var_t packages;
> +	bool cpumask_allocated;
> +	u64 err;
> +	int ret;
> +	int i;
> +
> +	if (!is_hkid_assigned(kvm_tdx))
> +		return;
> +
> +	if (!is_td_created(kvm_tdx))
> +		goto free_hkid;
> +
> +	cpumask_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
> +	cpus_read_lock();
> +	for_each_online_cpu(i) {
> +		if (cpumask_allocated &&
> +
> cpumask_test_and_set_cpu(topology_physical_package_id(i),
> +						packages))
> +			continue;
> +
> +		/*
> +		 * We can destroy multiple the guest TDs simultaneously.
> +		 * Prevent tdh_phymem_cache_wb from returning TDX_BUSY
> by
> +		 * serialization.
> +		 */
> +		mutex_lock(&tdx_lock);
> +		ret = smp_call_on_cpu(i, tdx_do_tdh_phymem_cache_wb,
> NULL, 1);
> +		mutex_unlock(&tdx_lock);
> +		if (ret)
> +			break;
> +	}
> +	cpus_read_unlock();
> +	free_cpumask_var(packages);
> +
> +	mutex_lock(&tdx_lock);
> +	err = tdh_mng_key_freeid(kvm_tdx->tdr_pa);
> +	mutex_unlock(&tdx_lock);
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_KEY_FREEID, err, NULL);
> +		pr_err("tdh_mng_key_freeid failed. HKID %d is
> leaked.\n",
> +			kvm_tdx->hkid);
> +		return;
> +	}
> +
> +free_hkid:
> +	tdx_hkid_free(kvm_tdx);
> +}
> +
> +void tdx_vm_free(struct kvm *kvm)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	int i;
> +
> +	/* Can't reclaim or free TD pages if teardown failed. */
> +	if (is_hkid_assigned(kvm_tdx))
> +		return;
> +
> +	if (kvm_tdx->tdcs_pa) {
> +		for (i = 0; i < tdx_caps.tdcs_nr_pages; i++)
> +			tdx_reclaim_td_page(kvm_tdx->tdcs_pa[i]);
> +		kfree(kvm_tdx->tdcs_pa);
> +		kvm_tdx->tdcs_pa = NULL;
> +	}
> +
> +	if (!kvm_tdx->tdr_pa)
> +		return;
> +	/*
> +	 * TDX module maps TDR with TDX global HKID.  TDX module may
> access TDR
> +	 * while operating on TD (Especially reclaiming TDCS).  Cache
> flush with
> +	 * TDX global HKID is needed.
> +	 */
> +	if (tdx_reclaim_page(kvm_tdx->tdr_pa, true, tdx_global_keyid))
> +		return;
> +
> +	free_page((unsigned long)__va(kvm_tdx->tdr_pa));
> +	kvm_tdx->tdr_pa = 0;
> +}
> +
> +static int tdx_do_tdh_mng_key_config(void *param)
> +{
> +	hpa_t *tdr_p = param;
> +	u64 err;
> +
> +	do {
> +		err = tdh_mng_key_config(*tdr_p);
> +
> +		/*
> +		 * If it failed to generate a random key, retry it
> because this
> +		 * is typically caused by an entropy error of the CPU's
> random
> +		 * number generator.
> +		 */
> +	} while (err == TDX_KEY_GENERATION_FAILED);
> +
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_KEY_CONFIG, err, NULL);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __tdx_td_init(struct kvm *kvm);
> +
> +int tdx_vm_init(struct kvm *kvm)
> +{
> +	/* Place holder for now. */
> +	return __tdx_td_init(kvm);
> +}
> +
>  int tdx_dev_ioctl(void __user *argp)
>  {
>  	struct kvm_tdx_capabilities __user *user_caps;
> @@ -78,6 +323,160 @@ int tdx_dev_ioctl(void __user *argp)
>  	return 0;
>  }
>  
> +static int __tdx_td_init(struct kvm *kvm)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	cpumask_var_t packages;
> +	unsigned long *tdcs_pa = NULL;
> +	unsigned long tdr_pa = 0;
> +	unsigned long va;
> +	int ret, i;
> +	u64 err;
> +
> +	ret = tdx_keyid_alloc();
> +	if (ret < 0)
> +		return ret;
> +	kvm_tdx->hkid = ret;
> +
> +	va = __get_free_page(GFP_KERNEL_ACCOUNT);
> +	if (!va)
> +		goto free_hkid;
> +	tdr_pa = __pa(va);
> +
> +	tdcs_pa = kcalloc(tdx_caps.tdcs_nr_pages,
> sizeof(*kvm_tdx->tdcs_pa),
> +			  GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	if (!tdcs_pa)
> +		goto free_tdr;
> +	for (i = 0; i < tdx_caps.tdcs_nr_pages; i++) {
> +		va = __get_free_page(GFP_KERNEL_ACCOUNT);
> +		if (!va)
> +			goto free_tdcs;
> +		tdcs_pa[i] = __pa(va);
> +	}
> +
> +	if (!zalloc_cpumask_var(&packages, GFP_KERNEL)) {
> +		ret = -ENOMEM;
> +		goto free_tdcs;
> +	}
> +	cpus_read_lock();
> +	/*
> +	 * Need at least one CPU of the package to be online in order to
> +	 * program all packages for host key id.  Check it.
> +	 */
> +	for_each_present_cpu(i)
> +		cpumask_set_cpu(topology_physical_package_id(i),
> packages);
> +	for_each_online_cpu(i)
> +		cpumask_clear_cpu(topology_physical_package_id(i),
> packages);
> +	if (!cpumask_empty(packages)) {
> +		ret = -EIO;
> +		/*
> +		 * Because it's hard for human operator to figure out
> the
> +		 * reason, warn it.
> +		 */
> +		pr_warn("All packages need to have online CPU to create
> TD. Online CPU and retry.\n");
> +		goto free_packages;
> +	}
> +
> +	/*
> +	 * Acquire global lock to avoid TDX_OPERAND_BUSY:
> +	 * TDH.MNG.CREATE and other APIs try to lock the global Key
> Owner
> +	 * Table (KOT) to track the assigned TDX private HKID.  It
> doesn't spin
> +	 * to acquire the lock, returns TDX_OPERAND_BUSY instead, and
> let the
> +	 * caller to handle the contention.  This is because of time
> limitation
> +	 * usable inside the TDX module and OS/VMM knows better about
> process
> +	 * scheduling.
> +	 *
> +	 * APIs to acquire the lock of KOT:
> +	 * TDH.MNG.CREATE, TDH.MNG.KEY.FREEID, TDH.MNG.VPFLUSHDONE, and
> +	 * TDH.PHYMEM.CACHE.WB.
> +	 */
> +	mutex_lock(&tdx_lock);
> +	err = tdh_mng_create(tdr_pa, kvm_tdx->hkid);
> +	mutex_unlock(&tdx_lock);
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_CREATE, err, NULL);
> +		ret = -EIO;
> +		goto free_packages;
> +	}
> +	kvm_tdx->tdr_pa = tdr_pa;
> +
> +	for_each_online_cpu(i) {
> +		int pkg = topology_physical_package_id(i);
> +
> +		if (cpumask_test_and_set_cpu(pkg, packages))
> +			continue;
> +
> +		/*
> +		 * Program the memory controller in the package with an
> +		 * encryption key associated to a TDX private host key
> id
> +		 * assigned to this TDR.  Concurrent operations on same
> memory
> +		 * controller results in TDX_OPERAND_BUSY.  Avoid this
> race by
> +		 * mutex.
> +		 */
> +		mutex_lock(&tdx_mng_key_config_lock[pkg]);
> +		ret = smp_call_on_cpu(i, tdx_do_tdh_mng_key_config,
> +				      &kvm_tdx->tdr_pa, true);
> +		mutex_unlock(&tdx_mng_key_config_lock[pkg]);
> +		if (ret)
> +			break;
> +	}
> +	cpus_read_unlock();
> +	free_cpumask_var(packages);
> +	if (ret)
> +		goto teardown;
> +
> +	kvm_tdx->tdcs_pa = tdcs_pa;
> +	for (i = 0; i < tdx_caps.tdcs_nr_pages; i++) {
> +		err = tdh_mng_addcx(kvm_tdx->tdr_pa, tdcs_pa[i]);
> +		if (WARN_ON_ONCE(err)) {
> +			pr_tdx_error(TDH_MNG_ADDCX, err, NULL);
> +			for (i++; i < tdx_caps.tdcs_nr_pages; i++) {
> +				free_page((unsigned
> long)__va(tdcs_pa[i]));
> +				tdcs_pa[i] = 0;
> +			}
> +			ret = -EIO;
> +			goto teardown;
> +		}
> +	}
> +
> +	/*
> +	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT
> requires a dedicated
> +	 * ioctl() to define the configure CPUID values for the TD.
> +	 */
> +	return 0;
> +
> +	/*
> +	 * The sequence for freeing resources from a partially
> initialized TD
> +	 * varies based on where in the initialization flow failure
> occurred.
> +	 * Simply use the full teardown and destroy, which naturally
> play nice
> +	 * with partial initialization.
> +	 */
> +teardown:
> +	tdx_mmu_release_hkid(kvm);
> +	tdx_vm_free(kvm);
> +	return ret;
> +
> +free_packages:
> +	cpus_read_unlock();
> +	free_cpumask_var(packages);
> +free_tdcs:
> +	for (i = 0; i < tdx_caps.tdcs_nr_pages; i++) {
> +		if (tdcs_pa[i])
> +			free_page((unsigned long)__va(tdcs_pa[i]));
> +	}
> +	kfree(tdcs_pa);
> +	kvm_tdx->tdcs_pa = NULL;
> +
> +free_tdr:
> +	if (tdr_pa)
> +		free_page((unsigned long)__va(tdr_pa));
> +	kvm_tdx->tdr_pa = 0;
> +free_hkid:
> +	if (is_hkid_assigned(kvm_tdx))
> +		tdx_hkid_free(kvm_tdx);
> +	return ret;
> +}
> +
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_tdx_cmd tdx_cmd;
> @@ -152,6 +551,8 @@ bool tdx_is_vm_type_supported(unsigned long type)
>  
>  int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>  {
> +	int max_pkgs;
> +	int i;
>  	int r;
>  
>  	if (!enable_ept) {
> @@ -159,6 +560,14 @@ int __init tdx_hardware_setup(struct kvm_x86_ops
> *x86_ops) return -EINVAL;
>  	}
>  
> +	max_pkgs = topology_max_packages();
> +	tdx_mng_key_config_lock = kcalloc(max_pkgs,
> sizeof(*tdx_mng_key_config_lock),
> +				   GFP_KERNEL);
> +	if (!tdx_mng_key_config_lock)
> +		return -ENOMEM;
> +	for (i = 0; i < max_pkgs; i++)
> +		mutex_init(&tdx_mng_key_config_lock[i]);
> +
>  	/* TDX requires VMX. */
>  	r = vmxon_all();
>  	if (!r)
> @@ -167,3 +576,9 @@ int __init tdx_hardware_setup(struct kvm_x86_ops
> *x86_ops) 
>  	return r;
>  }
> +
> +void tdx_hardware_unsetup(void)
> +{
> +	/* kfree accepts NULL. */
> +	kfree(tdx_mng_key_config_lock);
> +}
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 473013265bd8..e78d72cf4c3a 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -5,7 +5,11 @@
>  #ifdef CONFIG_INTEL_TDX_HOST
>  struct kvm_tdx {
>  	struct kvm kvm;
> -	/* TDX specific members follow. */
> +
> +	unsigned long tdr_pa;
> +	unsigned long *tdcs_pa;
> +
> +	int hkid;
>  };
>  
>  struct vcpu_tdx {
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index bb4090dbae37..3d0f519727c6 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -139,15 +139,24 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
>  
>  #ifdef CONFIG_INTEL_TDX_HOST
>  int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
> +void tdx_hardware_unsetup(void);
>  bool tdx_is_vm_type_supported(unsigned long type);
>  int tdx_dev_ioctl(void __user *argp);
>  
> +int tdx_vm_init(struct kvm *kvm);
> +void tdx_mmu_release_hkid(struct kvm *kvm);
> +void tdx_vm_free(struct kvm *kvm);
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>  #else
>  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) {
> return 0; } +static inline void tdx_hardware_unsetup(void) {}
>  static inline bool tdx_is_vm_type_supported(unsigned long type) {
> return false; } static inline int tdx_dev_ioctl(void __user *argp) {
> return -EOPNOTSUPP; }; 
> +static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
> +static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
> +static inline void tdx_flush_shadow_all_private(struct kvm *kvm) {}
> +static inline void tdx_vm_free(struct kvm *kvm) {}
>  static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) {
> return -EOPNOTSUPP; } #endif
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1152a9dc6d84..0fa91a9708aa 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12337,6 +12337,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  	kvm_page_track_cleanup(kvm);
>  	kvm_xen_destroy_vm(kvm);
>  	kvm_hv_destroy_vm(kvm);
> +	static_call_cond(kvm_x86_vm_free)(kvm);
>  }
>  
>  static void memslot_rmap_free(struct kvm_memory_slot *slot)
> @@ -12647,6 +12648,13 @@ void kvm_arch_commit_memory_region(struct kvm
> *kvm, 
>  void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  {
> +	/*
> +	 * kvm_mmu_zap_all() zaps both private and shared page tables.
> Before
> +	 * tearing down private page tables, TDX requires some TD
> resources to
> +	 * be destroyed (i.e. keyID must have been reclaimed, etc).
> Invoke
> +	 * kvm_x86_flush_shadow_all_private() for this.
> +	 */
> +	static_call_cond(kvm_x86_flush_shadow_all_private)(kvm);
>  	kvm_mmu_zap_all(kvm);
>  }
>  

