Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE864F41DA
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 23:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242339AbiDEOwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 10:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391048AbiDENq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 09:46:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EBD416C951
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 05:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649162649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NKUrN0tZsmCfj+VwfcTkujw1tWWwnH4oIbgR87FskkY=;
        b=dklVd40fu+xivzKVcMwNG54ZZ14rAseeMf56/AQ3y6oMAb+rKAM7TUPTVHbbApgJp1pYcy
        aNJ4HbU9b5ET5FaPpj/6N+w0B0XAeAPJ413rak+bvUMbjHUHVxET2Ea1uYxeSuY31zTw5s
        SoH+09JQeLpE+ZyaxslxaHsEWpkZn6k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-r7dDQnG5Md-4lVmEfeJbeQ-1; Tue, 05 Apr 2022 08:44:08 -0400
X-MC-Unique: r7dDQnG5Md-4lVmEfeJbeQ-1
Received: by mail-wm1-f72.google.com with SMTP id l7-20020a05600c1d0700b0038c9c48f1e7so1294590wms.2
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 05:44:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NKUrN0tZsmCfj+VwfcTkujw1tWWwnH4oIbgR87FskkY=;
        b=1oe/22lDXy9XSvmE2H2DRm5O5uzw4AL51+kiC01uQ/i2yDVUibnVUPNy5nnoLciGDm
         XrpM8InL06NYLuxbgBVooKZZPeCqBQmS5Dg5fhp5luwzpF4r2wTcAU0WSbI5KKaFsk4u
         8+Pq9DXec9KioMtCQa4wJQJ/X+YaVqEALP9e1ucCj8sf1ClLF9m0KiJarwzJTTwdio1S
         ++eYEVWPGyUQWfSHNvs/Ar1p4UyCPFjNdwLnX+OMk+m1aXs5y7pEsu4tvMA4BRpMTPgk
         9myYU8N7sP4XeqfOAdcpVt5/jJG62D9kSPVXkdsk3qEAeGAmCD/kg3sVZXmMfl/mz179
         4B1Q==
X-Gm-Message-State: AOAM532ttoqIFV8zuQ4cbwSiFWkUfSdznvnR45Sd/OtGNu5pB/58A+xZ
        a9n81D2Y18vCoq88K234px/5F6UN+mHRS85QZabr41Hgu5Wzel9ao5IHueCF49ttaKitm2PRC5D
        t7MTrt471oIch
X-Received: by 2002:a05:600c:3b89:b0:38c:c9d6:ff0e with SMTP id n9-20020a05600c3b8900b0038cc9d6ff0emr3002745wms.77.1649162646551;
        Tue, 05 Apr 2022 05:44:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmHeDpRbzdWkg7VcJOVGGFhx7Qk5Ijkesl3yJJqxx1YmL5kHBzj0U2dJWaY9emR7xHNxN3JQ==
X-Received: by 2002:a05:600c:3b89:b0:38c:c9d6:ff0e with SMTP id n9-20020a05600c3b8900b0038cc9d6ff0emr3002714wms.77.1649162646215;
        Tue, 05 Apr 2022 05:44:06 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id n66-20020a1ca445000000b0038e785baac7sm2049871wme.11.2022.04.05.05.44.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 05:44:05 -0700 (PDT)
Message-ID: <aa6afd32-8892-dc8d-3804-3d85dcb0b867@redhat.com>
Date:   Tue, 5 Apr 2022 14:44:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 024/104] KVM: TDX: create/destroy VM structure
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <36805b6b6b668669d5205183c338a4020df584dd.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <36805b6b6b668669d5205183c338a4020df584dd.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> As the first step to create TDX guest, create/destroy VM struct.  Assign
> Host Key ID (HKID) to the TDX guest for memory encryption and allocate
> extra pages for the TDX guest. On destruction, free allocated pages, and
> HKID.
> 
> Add a second kvm_x86_ops hook in kvm_arch_vm_destroy() to support TDX's
> destruction path, which needs to first put the VM into a teardown state,
> then free per-vCPU resources, and finally free per-VM resources.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c      |  16 +-
>   arch/x86/kvm/vmx/tdx.c       | 312 +++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/tdx.h       |   2 +
>   arch/x86/kvm/vmx/tdx_errno.h |   2 +-
>   arch/x86/kvm/vmx/tdx_ops.h   |   8 +
>   arch/x86/kvm/vmx/x86_ops.h   |   8 +
>   6 files changed, 346 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 6111c6485d8e..5c3a904a30e8 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -39,12 +39,24 @@ static int vt_vm_init(struct kvm *kvm)
>   		ret = tdx_module_setup();
>   		if (ret)
>   			return ret;
> -		return -EOPNOTSUPP;	/* Not ready to create guest TD yet. */
> +		return tdx_vm_init(kvm);
>   	}
>   
>   	return vmx_vm_init(kvm);
>   }
>   
> +static void vt_mmu_prezap(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		return tdx_mmu_prezap(kvm);
> +}

Please rename the function to explain what it does, for example 
tdx_mmu_release_hkid.

Paolo

> +static void vt_vm_free(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		return tdx_vm_free(kvm);
> +}

> +
>   struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.name = "kvm_intel",
>   
> @@ -58,6 +70,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.is_vm_type_supported = vt_is_vm_type_supported,
>   	.vm_size = sizeof(struct kvm_vmx),
>   	.vm_init = vt_vm_init,
> +	.mmu_prezap = vt_mmu_prezap,
> +	.vm_free = vt_vm_free,
>   
>   	.vcpu_create = vmx_vcpu_create,
>   	.vcpu_free = vmx_vcpu_free,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 1c8222f54764..702953fd365f 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -31,14 +31,324 @@ struct tdx_capabilities {
>   	struct tdx_cpuid_config cpuid_configs[TDX_MAX_NR_CPUID_CONFIGS];
>   };
>   
> +/* KeyID used by TDX module */
> +static u32 tdx_global_keyid __read_mostly;
> +
>   /* Capabilities of KVM + the TDX module. */
>   struct tdx_capabilities tdx_caps;
>   
> +static DEFINE_MUTEX(tdx_lock);
>   static struct mutex *tdx_mng_key_config_lock;
>   
>   static u64 hkid_mask __ro_after_init;
>   static u8 hkid_start_pos __ro_after_init;
>   
> +static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
> +{
> +	pa &= ~hkid_mask;
> +	pa |= (u64)hkid << hkid_start_pos;
> +
> +	return pa;
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
> +	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> +	unsigned long i;
> +
> +	/* Zeroing the page is only necessary for systems with MKTME-i. */
> +	if (!static_cpu_has(X86_FEATURE_MOVDIR64B))
> +		return;
> +
> +	for (i = 0; i < 4096; i += 64)
> +		/* MOVDIR64B [rdx], es:rdi */
> +		asm (".byte 0x66, 0x0f, 0x38, 0xf8, 0x3a"
> +		     : : "d" (zero_page), "D" (page + i) : "memory");
> +}
> +
> +static int __tdx_reclaim_page(unsigned long va, hpa_t pa, bool do_wb, u16 hkid)
> +{
> +	struct tdx_module_output out;
> +	u64 err;
> +
> +	err = tdh_phymem_page_reclaim(pa, &out);
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err, &out);
> +		return -EIO;
> +	}
> +
> +	if (do_wb) {
> +		err = tdh_phymem_page_wbinvd(set_hkid_to_hpa(pa, hkid));
> +		if (WARN_ON_ONCE(err)) {
> +			pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
> +			return -EIO;
> +		}
> +	}
> +
> +	tdx_clear_page(va);
> +	return 0;
> +}
> +
> +static int tdx_reclaim_page(unsigned long va, hpa_t pa)
> +{
> +	return __tdx_reclaim_page(va, pa, false, 0);
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
> +static void tdx_mark_td_page_added(struct tdx_td_page *page)
> +{
> +	WARN_ON_ONCE(page->added);
> +	page->added = true;
> +}
> +
> +static void tdx_reclaim_td_page(struct tdx_td_page *page)
> +{
> +	if (page->added) {
> +		if (tdx_reclaim_page(page->va, page->pa))
> +			return;
> +
> +		page->added = false;
> +	}
> +	free_page(page->va);
> +}
> +
> +static int tdx_do_tdh_phymem_cache_wb(void *param)
> +{
> +	u64 err = 0;
> +
> +	/*
> +	 * We can destroy multiple the guest TDs simultaneously.  Prevent
> +	 * tdh_phymem_cache_wb from returning TDX_BUSY by serialization.
> +	 */
> +	mutex_lock(&tdx_lock);
> +	do {
> +		err = tdh_phymem_cache_wb(!!err);
> +	} while (err == TDX_INTERRUPTED_RESUMABLE);
> +	mutex_unlock(&tdx_lock);
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
> +void tdx_mmu_prezap(struct kvm *kvm)
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
> +	mutex_lock(&tdx_lock);
> +	err = tdh_mng_key_reclaimid(kvm_tdx->tdr.pa);
> +	mutex_unlock(&tdx_lock);
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_KEY_RECLAIMID, err, NULL);
> +		return;
> +	}
> +
> +	cpumask_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
> +	for_each_online_cpu(i) {
> +		if (cpumask_allocated &&
> +			cpumask_test_and_set_cpu(topology_physical_package_id(i),
> +						packages))
> +			continue;
> +
> +		ret = smp_call_on_cpu(i, tdx_do_tdh_phymem_cache_wb, NULL, 1);
> +		if (ret)
> +			break;
> +	}
> +	free_cpumask_var(packages);
> +
> +	mutex_lock(&tdx_lock);
> +	err = tdh_mng_key_freeid(kvm_tdx->tdr.pa);
> +	mutex_unlock(&tdx_lock);
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_KEY_FREEID, err, NULL);
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
> +	for (i = 0; i < tdx_caps.tdcs_nr_pages; i++)
> +		tdx_reclaim_td_page(&kvm_tdx->tdcs[i]);
> +	kfree(kvm_tdx->tdcs);
> +
> +	if (kvm_tdx->tdr.added &&
> +		__tdx_reclaim_page(kvm_tdx->tdr.va, kvm_tdx->tdr.pa, true,
> +				tdx_global_keyid))
> +		return;
> +
> +	free_page(kvm_tdx->tdr.va);
> +}
> +
> +static int tdx_do_tdh_mng_key_config(void *param)
> +{
> +	hpa_t *tdr_p = param;
> +	int cpu, cur_pkg;
> +	u64 err;
> +
> +	cpu = raw_smp_processor_id();
> +	cur_pkg = topology_physical_package_id(cpu);
> +
> +	mutex_lock(&tdx_mng_key_config_lock[cur_pkg]);
> +	do {
> +		err = tdh_mng_key_config(*tdr_p);
> +	} while (err == TDX_KEY_GENERATION_FAILED);
> +	mutex_unlock(&tdx_mng_key_config_lock[cur_pkg]);
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
> +	/* vCPUs can't be created until after KVM_TDX_INIT_VM. */
> +	kvm->max_vcpus = 0;
> +
> +	kvm_tdx->hkid = tdx_keyid_alloc();
> +	if (kvm_tdx->hkid < 0)
> +		return -EBUSY;
> +
> +	ret = tdx_alloc_td_page(&kvm_tdx->tdr);
> +	if (ret)
> +		goto free_hkid;
> +
> +	kvm_tdx->tdcs = kcalloc(tdx_caps.tdcs_nr_pages, sizeof(*kvm_tdx->tdcs),
> +				GFP_KERNEL_ACCOUNT);
> +	if (!kvm_tdx->tdcs)
> +		goto free_tdr;
> +	for (i = 0; i < tdx_caps.tdcs_nr_pages; i++) {
> +		ret = tdx_alloc_td_page(&kvm_tdx->tdcs[i]);
> +		if (ret)
> +			goto free_tdcs;
> +	}
> +
> +	mutex_lock(&tdx_lock);
> +	err = tdh_mng_create(kvm_tdx->tdr.pa, kvm_tdx->hkid);
> +	mutex_unlock(&tdx_lock);
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_CREATE, err, NULL);
> +		ret = -EIO;
> +		goto free_tdcs;
> +	}
> +	tdx_mark_td_page_added(&kvm_tdx->tdr);
> +
> +	if (!zalloc_cpumask_var(&packages, GFP_KERNEL)) {
> +		ret = -ENOMEM;
> +		goto free_tdcs;
> +	}
> +	for_each_online_cpu(i) {
> +		if (cpumask_test_and_set_cpu(topology_physical_package_id(i),
> +						packages))
> +			continue;
> +
> +		ret = smp_call_on_cpu(i, tdx_do_tdh_mng_key_config,
> +				&kvm_tdx->tdr.pa, 1);
> +		if (ret)
> +			break;
> +	}
> +	free_cpumask_var(packages);
> +	if (ret)
> +		goto teardown;
> +
> +	for (i = 0; i < tdx_caps.tdcs_nr_pages; i++) {
> +		err = tdh_mng_addcx(kvm_tdx->tdr.pa, kvm_tdx->tdcs[i].pa);
> +		if (WARN_ON_ONCE(err)) {
> +			pr_tdx_error(TDH_MNG_ADDCX, err, NULL);
> +			ret = -EIO;
> +			goto teardown;
> +		}
> +		tdx_mark_td_page_added(&kvm_tdx->tdcs[i]);
> +	}
> +
> +	/*
> +	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
> +	 * ioctl() to define the configure CPUID values for the TD.
> +	 */
> +	return 0;
> +
> +	/*
> +	 * The sequence for freeing resources from a partially initialized TD
> +	 * varies based on where in the initialization flow failure occurred.
> +	 * Simply use the full teardown and destroy, which naturally play nice
> +	 * with partial initialization.
> +	 */
> +teardown:
> +	tdx_mmu_prezap(kvm);
> +	tdx_vm_free(kvm);
> +	return ret;
> +
> +free_tdcs:
> +	/* @i points at the TDCS page that failed allocation. */
> +	for (--i; i >= 0; i--)
> +		free_page(kvm_tdx->tdcs[i].va);
> +	kfree(kvm_tdx->tdcs);
> +free_tdr:
> +	free_page(kvm_tdx->tdr.va);
> +free_hkid:
> +	tdx_hkid_free(kvm_tdx);
> +	return ret;
> +}
> +
>   static int __tdx_module_setup(void)
>   {
>   	const struct tdsysinfo_struct *tdsysinfo;
> @@ -59,6 +369,8 @@ static int __tdx_module_setup(void)
>   		return ret;
>   	}
>   
> +	tdx_global_keyid = tdx_get_global_keyid();
> +
>   	tdsysinfo = tdx_get_sysinfo();
>   	if (tdx_caps.nr_cpuid_configs > TDX_MAX_NR_CPUID_CONFIGS)
>   		return -EIO;
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index e4bb8831764e..860136ed70f5 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -19,6 +19,8 @@ struct kvm_tdx {
>   
>   	struct tdx_td_page tdr;
>   	struct tdx_td_page *tdcs;
> +
> +	int hkid;
>   };
>   
>   struct vcpu_tdx {
> diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
> index 5c878488795d..590fcfdd1899 100644
> --- a/arch/x86/kvm/vmx/tdx_errno.h
> +++ b/arch/x86/kvm/vmx/tdx_errno.h
> @@ -12,11 +12,11 @@
>   #define TDX_SUCCESS				0x0000000000000000ULL
>   #define TDX_NON_RECOVERABLE_VCPU		0x4000000100000000ULL
>   #define TDX_INTERRUPTED_RESUMABLE		0x8000000300000000ULL
> -#define TDX_LIFECYCLE_STATE_INCORRECT		0xC000060700000000ULL
>   #define TDX_VCPU_NOT_ASSOCIATED			0x8000070200000000ULL
>   #define TDX_KEY_GENERATION_FAILED		0x8000080000000000ULL
>   #define TDX_KEY_STATE_INCORRECT			0xC000081100000000ULL
>   #define TDX_KEY_CONFIGURED			0x0000081500000000ULL
> +#define TDX_NO_HKID_READY_TO_WBCACHE		0x0000082100000000ULL
>   #define TDX_EPT_WALK_FAILED			0xC0000B0000000000ULL
>   
>   /*
> diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
> index 0bed43879b82..3dd5b4c3f04c 100644
> --- a/arch/x86/kvm/vmx/tdx_ops.h
> +++ b/arch/x86/kvm/vmx/tdx_ops.h
> @@ -6,6 +6,7 @@
>   
>   #include <linux/compiler.h>
>   
> +#include <asm/cacheflush.h>
>   #include <asm/asm.h>
>   #include <asm/kvm_host.h>
>   
> @@ -15,8 +16,14 @@
>   
>   #ifdef CONFIG_INTEL_TDX_HOST
>   
> +static inline void tdx_clflush_page(hpa_t addr)
> +{
> +	clflush_cache_range(__va(addr), PAGE_SIZE);
> +}
> +
>   static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
>   {
> +	tdx_clflush_page(addr);
>   	return kvm_seamcall(TDH_MNG_ADDCX, addr, tdr, 0, 0, 0, NULL);
>   }
>   
> @@ -56,6 +63,7 @@ static inline u64 tdh_mng_key_config(hpa_t tdr)
>   
>   static inline u64 tdh_mng_create(hpa_t tdr, int hkid)
>   {
> +	tdx_clflush_page(tdr);
>   	return kvm_seamcall(TDH_MNG_CREATE, tdr, hkid, 0, 0, 0, NULL);
>   }
>   
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index da32b4b86b19..2b2738c768d6 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -132,12 +132,20 @@ void __init tdx_pre_kvm_init(unsigned int *vcpu_size,
>   bool tdx_is_vm_type_supported(unsigned long type);
>   void __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
>   void tdx_hardware_unsetup(void);
> +
> +int tdx_vm_init(struct kvm *kvm);
> +void tdx_mmu_prezap(struct kvm *kvm);
> +void tdx_vm_free(struct kvm *kvm);
>   #else
>   static inline void tdx_pre_kvm_init(
>   	unsigned int *vcpu_size, unsigned int *vcpu_align, unsigned int *vm_size) {}
>   static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
>   static inline void tdx_hardware_setup(struct kvm_x86_ops *x86_ops) {}
>   static inline void tdx_hardware_unsetup(void) {}
> +
> +static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
> +static inline void tdx_mmu_prezap(struct kvm *kvm) {}
> +static inline void tdx_vm_free(struct kvm *kvm) {}
>   #endif
>   
>   #endif /* __KVM_X86_VMX_X86_OPS_H */

