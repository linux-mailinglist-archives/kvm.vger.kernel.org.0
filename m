Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E498635A8D
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 11:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237218AbiKWKvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 05:51:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236264AbiKWKva (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 05:51:30 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8620125203;
        Wed, 23 Nov 2022 02:37:03 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id d6so27520208lfs.10;
        Wed, 23 Nov 2022 02:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kyum99AMsqCo57YsRMpi7A08rcCySZMNu0tPrjyALxA=;
        b=iwvox3Rd4/uQU0c3Y0iKY6QD5/Xt8pBMSrEwWUWnOd0w+Y5gx5/ArSX10+d7hPHk8O
         rQLjwtzFTfe5EJ4ay/bX6/q6NslbXBOoxxy9nfHYpzC2wFSVCuMUjYVbi1slSEmY6JRw
         9rHzwbkJ9LAlmDXynVVa7dzrIBQOYQaDAfszk8sqlCqsXXvemIEcDgsPONaw1oXVsdd7
         ORCzX8LodNgB85GAgEOTarPD1j4gGB1JX8TYt0cL4fPapGzfKE7XL66EJpg9pOsr0R0C
         4ysRiIJzL3xMowD1KyoDV5XGT+P0afA7qe5LfajfTuXG/VPxyBgEvlyDSW0PkowKqjCC
         kWFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kyum99AMsqCo57YsRMpi7A08rcCySZMNu0tPrjyALxA=;
        b=bC8NYXdUWZk1PLavsCPqYW3R/FrQzxB/ejHz3H4gI11s08PiN+qMOev8wOtUAw82+R
         AFwu4ekDPDF6qN9LMBIpHxyb2HdT5SP4QqwhjTnG2j3ckk8f5Ny7au0ZSMlfumeRz4KJ
         saC9fadcdRq5k3qdZskKmwu/JOqtnO0HHeFiTxYb+lWCQ1yOZGbM0Y00r2mMMArPCVg1
         hPLpbvrCU/f0jT6wxgAW/TICrYYDeYAyTAl3N9Y7pjzxkyTAYtbfYGNP5j4NDkaroQKE
         Z3ruSrxAdALKlSbc5zborv+wIbdsqrw16NELzad1E6k5ReITIgQKlSku3VQ8gioP4n3U
         NmaA==
X-Gm-Message-State: ANoB5pldapNjpH+BIdbaftSXXiOVCdVz3dL2sq25DnngXyNFr+iZUiaR
        0gIIN1wQzKJUoQyHQaFLucU=
X-Google-Smtp-Source: AA0mqf7fULllp4ZJ3PLG1lE8ntzvDoSRZwzzAFjkkjTonG20Gsr4/DmfjvIYEkS4XaffclKwTdiosw==
X-Received: by 2002:a05:6512:358e:b0:494:6440:5908 with SMTP id m14-20020a056512358e00b0049464405908mr4457413lfr.128.1669199821835;
        Wed, 23 Nov 2022 02:37:01 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id a23-20020a2eb557000000b002770f0a742bsm2149871ljn.41.2022.11.23.02.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 02:37:01 -0800 (PST)
From:   Zhi Wang <zhi.wang.linux@gmail.com>
X-Google-Original-From: Zhi Wang <zhi.a.wang@intel.com>
Date:   Wed, 23 Nov 2022 12:36:59 +0200
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [PATCH v10 016/108] KVM: TDX: create/destroy VM structure
Message-ID: <20221123123659.0000593c@gmail.com>
In-Reply-To: <fb337a67e17715977e46523d1344cb2a7f46a37a.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
        <fb337a67e17715977e46523d1344cb2a7f46a37a.1667110240.git.isaku.yamahata@intel.com>
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

On Sat, 29 Oct 2022 23:22:17 -0700
isaku.yamahata@intel.com wrote:

> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> As the first step to create TDX guest, create/destroy VM struct.
> Assign TDX private Host Key ID (HKID) to the TDX guest for memory
> encryption and allocate extra pages for the TDX guest. On
> destruction, free allocated pages, and HKID.
> 
> Before tearing down private page tables, TDX requires some resources
> of the guest TD to be destroyed (i.e. keyID must have been reclaimed,
> etc).  Add flush_shadow_all_private callback before tearing down
> private page tables for it.
> 
> Add a second kvm_x86_ops hook in kvm_arch_destroy_vm() to support
> TDX's destruction path, which needs to first put the VM into a
> teardown state, then free per-vCPU resources, and finally free per-VM
> resources.
> 
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |   2 +
>  arch/x86/include/asm/kvm_host.h    |   2 +
>  arch/x86/kvm/vmx/main.c            |  34 ++-
>  arch/x86/kvm/vmx/tdx.c             | 411
> +++++++++++++++++++++++++++++ arch/x86/kvm/vmx/tdx.h             |
> 2 + arch/x86/kvm/vmx/x86_ops.h         |  11 +
>  arch/x86/kvm/x86.c                 |   8 +
>  7 files changed, 467 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h
> b/arch/x86/include/asm/kvm-x86-ops.h index 8a5c5ae70bc5..3a29a6b31ee8
> 100644 --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -21,7 +21,9 @@ KVM_X86_OP(has_emulated_msr)
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
> b/arch/x86/include/asm/kvm_host.h index 2a41a93a80f3..2870155ce6fb
> 100644 --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1472,7 +1472,9 @@ struct kvm_x86_ops {
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
> index 0900ff2f2390..d01a946a18cf 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -29,18 +29,44 @@ static __init int vt_hardware_setup(void)
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
> -		return -EOPNOTSUPP;	/* Not ready to create
> guest TD yet. */
> +		return tdx_vm_init(kvm);
>  
>  	return vmx_vm_init(kvm);
>  }
>  
> +static void vt_flush_shadow_all_private(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		return tdx_mmu_release_hkid(kvm);
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
> +		return tdx_vm_free(kvm);
> +}
> +
>  struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.name = "kvm_intel",
>  
> -	.hardware_unsetup = vmx_hardware_unsetup,
> +	.hardware_unsetup = vt_hardware_unsetup,
>  	.check_processor_compatibility =
> vmx_check_processor_compatibility, 
>  	.hardware_enable = vmx_hardware_enable,
> @@ -50,7 +76,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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
> index 530e72f85762..ec88dde0d300 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -32,6 +32,401 @@ struct tdx_capabilities {
>  /* Capabilities of KVM + the TDX module. */
>  static struct tdx_capabilities tdx_caps;
>  
> +/*
> + * Some TDX SEAMCALLs (TDH.MNG.CREATE, TDH.PHYMEM.CACHE.WB,
> + * TDH.MNG.KEY.RECLAIMID, TDH.MNG.KEY.FREEID etc) tries to acquire a
> global lock
> + * internally in TDX module.  If failed, TDX_OPERAND_BUSY is
> returned without
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
> +	return kvm_tdx->tdr.added;
> +}
> +
> +static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
> +{
> +	tdx_keyid_free(kvm_tdx->hkid);
> +	kvm_tdx->hkid = -1;
> +}
> +
> +static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
> +{
> +	return kvm_tdx->hkid > 0;
> +}
> +
> +static void tdx_clear_page(unsigned long page)
> +{
> +	const void *zero_page = (const void *)
> __va(page_to_phys(ZERO_PAGE(0)));
> +	unsigned long i;
> +
> +	/*
> +	 * Zeroing the page is only necessary for systems with
> MKTME-i:
> +	 * when re-assign one page from old keyid to a new keyid,
> MOVDIR64B is
> +	 * required to clear/write the page with new keyid to
> prevent integrity
> +	 * error when read on the page with new keyid.
> +	 *
> +	 * The cache line could be poisoned (even without MKTME-i),
> clear the
> +	 * poison bit.
> +	 */
> +	for (i = 0; i < PAGE_SIZE; i += 64)
> +		movdir64b((void *)(page + i), zero_page);

In patch 11, the clflush is used on the movdir64b target. Should we
also use the clflush here?

I suppose the clflush is to prevent the unexpected cacheline writeback
after the movdir64b.

> +	/*
> +	 * MOVDIR64B store uses WC buffer.  Prevent following memory
> reads
> +	 * from seeing potentially poisoned cache.
> +	 */
> +	__mb();
> +}
> +
> +static int tdx_reclaim_page(unsigned long va, hpa_t pa, bool do_wb,
> u16 hkid) +{
> +	struct tdx_module_output out;
> +	u64 err;
> +
> +	do {
> +		err = tdh_phymem_page_reclaim(pa, &out);
> +		/*
> +		 * TDH.PHYMEM.PAGE.RECLAIM is allowed only when TD
> is shutdown.
> +		 * state.  i.e. destructing TD.
> +		 * TDH.PHYMEM.PAGE.RECLAIM  requires TDR and target
> page.
> +		 * Because we're destructing TD, it's rare to
> contend with TDR.
> +		 */
> +	} while (err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX));
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err, &out);
> +		return -EIO;
> +	}
> +
> +	if (do_wb) {
> +		/*
> +		 * Only TDR page gets into this path.  No contention
> is expected
> +		 * because the last page of TD.

because of

> +		 */
> +		err = tdh_phymem_page_wbinvd(set_hkid_to_hpa(pa,
> hkid));
> +		if (WARN_ON_ONCE(err)) {
> +			pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err,
> NULL);
> +			return -EIO;
> +		}
> +	}
> +
> +	tdx_clear_page(va);
> +	return 0;
> +}
> +
> +static int tdx_alloc_td_page(struct tdx_td_page *page)
> +{
> +	page->va = __get_free_page(GFP_KERNEL_ACCOUNT);
> +	if (!page->va)
> +		return -ENOMEM;
> +
> +	page->pa = __pa(page->va);
> +	return 0;
> +}
> +
> +static inline void tdx_mark_td_page_added(struct tdx_td_page *page)
> +{
> +	WARN_ON_ONCE(page->added);
> +	page->added = true;
> +}
> +
> +static void tdx_reclaim_td_page(struct tdx_td_page *page)
> +{
> +	if (page->added) {
> +		/*
> +		 * TDCX are being reclaimed.  TDX module maps TDCX
> with HKID
> +		 * assigned to the TD.  Here the cache associated to
> the TD
> +		 * was already flushed by TDH.PHYMEM.CACHE.WB before
> here, So
> +		 * cache doesn't need to be flushed again.
> +		 */
> +		if (tdx_reclaim_page(page->va, page->pa, false, 0))
> +			return;
> +
> +		page->added = false;
> +	}
> +	if (page->va) {
> +		free_page(page->va);
> +		page->va = 0;
> +	}
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
> +	cpumask_allocated = zalloc_cpumask_var(&packages,
> GFP_KERNEL);
> +	cpus_read_lock();
> +	for_each_online_cpu(i) {
> +		if (cpumask_allocated &&
> +
> cpumask_test_and_set_cpu(topology_physical_package_id(i),
> +						packages))
> +			continue;
> +
> +		/*
> +		 * We can destroy multiple the guest TDs
> simultaneously.
> +		 * Prevent tdh_phymem_cache_wb from returning
> TDX_BUSY by
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
> +	err = tdh_mng_key_freeid(kvm_tdx->tdr.pa);
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
> +	if (kvm_tdx->tdcs) {
> +		for (i = 0; i < tdx_caps.tdcs_nr_pages; i++)
> +			tdx_reclaim_td_page(&kvm_tdx->tdcs[i]);
> +		kfree(kvm_tdx->tdcs);
> +	}
> +
> +	/*
> +	 * TDX module maps TDR with TDX global HKID.  TDX module may
> access TDR
> +	 * while operating on TD (Especially reclaiming TDCS).
> Cache flush with
> +	 * TDX global HKID is needed.
> +	 */
> +	if (kvm_tdx->tdr.added &&
> +		tdx_reclaim_page(kvm_tdx->tdr.va, kvm_tdx->tdr.pa,
> true,
> +				tdx_global_keyid))
> +		return;
> +
> +	free_page(kvm_tdx->tdr.va);
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
> +		 * is typically caused by an entropy error of the
> CPU's random
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
> +int tdx_vm_init(struct kvm *kvm)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	cpumask_var_t packages;
> +	int ret, i;
> +	u64 err;
> +
> +	ret = tdx_keyid_alloc();
> +	if (ret < 0)
> +		return ret;
> +	kvm_tdx->hkid = ret;
> +
> +	ret = tdx_alloc_td_page(&kvm_tdx->tdr);
> +	if (ret)
> +		goto free_hkid;
> +
> +	kvm_tdx->tdcs = kcalloc(tdx_caps.tdcs_nr_pages,
> sizeof(*kvm_tdx->tdcs),
> +				GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	if (!kvm_tdx->tdcs)
> +		goto free_tdr;
> +	for (i = 0; i < tdx_caps.tdcs_nr_pages; i++) {
> +		ret = tdx_alloc_td_page(&kvm_tdx->tdcs[i]);
> +		if (ret)
> +			goto free_tdcs;
> +	}
> +
> +	if (!zalloc_cpumask_var(&packages, GFP_KERNEL)) {
> +		ret = -ENOMEM;
> +		goto free_tdcs;
> +	}
> +	cpus_read_lock();
> +	/*
> +	 * Need at least one CPU of the package to be online in
> order to
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
> +		 * Because it's hard for human operator to figure
> out the
> +		 * reason, warn it.
> +		 */
> +		pr_warn("All packages need to have online CPU to
> create TD. Online CPU and retry.\n");
> +		goto free_packages;
> +	}
> +
> +	/*
> +	 * Acquire global lock to avoid TDX_OPERAND_BUSY:
> +	 * TDH.MNG.CREATE and other APIs try to lock the global Key
> Owner
> +	 * Table (KOT) to track the assigned TDX private HKID.  It
> doesn't spin
> +	 * to acquire the lock, returns TDX_OPERAND_BUSY instead,
> and let the
> +	 * caller to handle the contention.  This is because of time
> limitation
> +	 * usable inside the TDX module and OS/VMM knows better
> about process
> +	 * scheduling.
> +	 *
> +	 * APIs to acquire the lock of KOT:
> +	 * TDH.MNG.CREATE, TDH.MNG.KEY.FREEID, TDH.MNG.VPFLUSHDONE,
> and
> +	 * TDH.PHYMEM.CACHE.WB.
> +	 */
> +	mutex_lock(&tdx_lock);
> +	err = tdh_mng_create(kvm_tdx->tdr.pa, kvm_tdx->hkid);
> +	mutex_unlock(&tdx_lock);
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_CREATE, err, NULL);
> +		ret = -EIO;
> +		goto free_packages;
> +	}
> +	tdx_mark_td_page_added(&kvm_tdx->tdr);
> +
> +	for_each_online_cpu(i) {
> +		int pkg = topology_physical_package_id(i);
> +
> +		if (cpumask_test_and_set_cpu(pkg, packages))
> +			continue;
> +
> +		/*
> +		 * Program the memory controller in the package with
> an
> +		 * encryption key associated to a TDX private host
> key id
> +		 * assigned to this TDR.  Concurrent operations on
> same memory
> +		 * controller results in TDX_OPERAND_BUSY.  Avoid
> this race by
> +		 * mutex.
> +		 */
> +		mutex_lock(&tdx_mng_key_config_lock[pkg]);
> +		ret = smp_call_on_cpu(i, tdx_do_tdh_mng_key_config,
> +				      &kvm_tdx->tdr.pa, true);
> +		mutex_unlock(&tdx_mng_key_config_lock[pkg]);
> +		if (ret)
> +			break;
> +	}
> +	cpus_read_unlock();
> +	free_cpumask_var(packages);
> +	if (ret)
> +		goto teardown;
> +
> +	for (i = 0; i < tdx_caps.tdcs_nr_pages; i++) {
> +		err = tdh_mng_addcx(kvm_tdx->tdr.pa,
> kvm_tdx->tdcs[i].pa);
> +		if (WARN_ON_ONCE(err)) {
> +			pr_tdx_error(TDH_MNG_ADDCX, err, NULL);
> +			ret = -EIO;
> +			goto teardown;
> +		}
> +		tdx_mark_td_page_added(&kvm_tdx->tdcs[i]);
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
> +		if (!kvm_tdx->tdcs[i].va)
> +			continue;
> +		free_page(kvm_tdx->tdcs[i].va);
> +	}
> +	kfree(kvm_tdx->tdcs);
> +	kvm_tdx->tdcs = NULL;
> +free_tdr:
> +	if (kvm_tdx->tdr.va) {
> +		free_page(kvm_tdx->tdr.va);
> +		kvm_tdx->tdr.added = false;
> +		kvm_tdx->tdr.va = 0;
> +		kvm_tdx->tdr.pa = 0;
> +	}
> +free_hkid:
> +	if (kvm_tdx->hkid != -1)
> +		tdx_hkid_free(kvm_tdx);
> +	return ret;
> +}
> +
>  static int __init tdx_module_setup(void)
>  {
>  	const struct tdsysinfo_struct *tdsysinfo;
> @@ -82,6 +477,8 @@ bool tdx_is_vm_type_supported(unsigned long type)
>  
>  int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>  {
> +	int max_pkgs;
> +	int i;
>  	int r;
>  
>  	if (!enable_ept) {
> @@ -95,6 +492,14 @@ int __init tdx_hardware_setup(struct kvm_x86_ops
> *x86_ops) return -ENODEV;
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
> @@ -103,3 +508,9 @@ int __init tdx_hardware_setup(struct kvm_x86_ops
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
> index 98999bf3f188..938314635b47 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -17,6 +17,8 @@ struct kvm_tdx {
>  
>  	struct tdx_td_page tdr;
>  	struct tdx_td_page *tdcs;
> +
> +	int hkid;
>  };
>  
>  struct vcpu_tdx {
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index ac1688b0b0e3..95da978c9aa9 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -133,9 +133,20 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
>  #ifdef CONFIG_INTEL_TDX_HOST
>  int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
>  bool tdx_is_vm_type_supported(unsigned long type);
> +void tdx_hardware_unsetup(void);
> +
> +int tdx_vm_init(struct kvm *kvm);
> +void tdx_mmu_release_hkid(struct kvm *kvm);
> +void tdx_vm_free(struct kvm *kvm);
>  #else
>  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) {
> return 0; } static inline bool tdx_is_vm_type_supported(unsigned long
> type) { return false; } +static inline void
> tdx_hardware_unsetup(void) {} +
> +static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP;
> } +static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
> +static inline void tdx_flush_shadow_all_private(struct kvm *kvm) {}
> +static inline void tdx_vm_free(struct kvm *kvm) {}
>  #endif
>  
>  #endif /* __KVM_X86_VMX_X86_OPS_H */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 91053fdc4512..4b22196cb12c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12702,6 +12702,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  	kvm_page_track_cleanup(kvm);
>  	kvm_xen_destroy_vm(kvm);
>  	kvm_hv_destroy_vm(kvm);
> +	static_call_cond(kvm_x86_vm_free)(kvm);
>  }
>  
>  static void memslot_rmap_free(struct kvm_memory_slot *slot)
> @@ -13012,6 +13013,13 @@ void kvm_arch_commit_memory_region(struct
> kvm *kvm, 
>  void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  {
> +	/*
> +	 * kvm_mmu_zap_all() zaps both private and shared page
> tables.  Before
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

