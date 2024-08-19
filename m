Return-Path: <kvm+bounces-24533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DE07956E4F
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 17:10:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D73FEB25E91
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 15:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8EDF17C233;
	Mon, 19 Aug 2024 15:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QoLpuYSu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9E6173355
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 15:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724080153; cv=none; b=YKM6haXfdRAqAW/AszwLHmLG4uklavLWX90bQzP+d/a23BFtPABD21nDrpRJ18bv4qniPMnYgI11+ghFfip6HMwKCGkKtR0icqjVYKTLd8/3SDeDKsBAJNyuWAfWmtuyDkTQ1I4a954rEjviNM4vU85oeR4AFpZQ4ok21A6nlq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724080153; c=relaxed/simple;
	bh=y0XSF0NisbbkaFQeED4S8cRsocv1dZdob/BaUW1EJF4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a7UEKff8UCED12F3M2kUcaXY54XbD+H++UC7NdK7gu7rFXGRvfVnZV9G7uD75D8mcpPkfzrDASe4VCmnlSxH2qDvXnBU9hOImssCj+x7zzgiZaP2Sf0Gx9W4revn5d/buv6ngLPdJPONXOh0aqaQwQyKJ0OU3z2XW+PKTZQEdCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QoLpuYSu; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a7abe5aa9d5so468173366b.1
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 08:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724080148; x=1724684948; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rCuddyNf+0ZBHgPNUo3DWqvGchoe0lCOn0I22CKBsbE=;
        b=QoLpuYSuX42+nbHD8vS17Qk05O7r7zGSfrB6xWcq4AZzaMGTcfix3h3vyXfLoCNXdn
         Fn/XCa430WewZLrfJKyU60UHBN3JIPOGAkc6MPMfE/WCfrjWxjK5u6ccqG6Kl/T3obGC
         rmo88CESff3B+XyDzEbID/cPNeXWcXLMwKtxJ47mK607tTQrASQn/FCtV2BN72yTlbt1
         Udqr1n+GKBMYtKfkIJdCnBD3OyiHIOrByhfAI1OmaJ5idnaIYlIsVPISXJkWaHh3psDf
         H8qaApxJ31pWy0p7+VngAGffcEFpvW7h+eb92ExD8N7nXJOPtp3nDD7H2OLyuxS+FY0o
         4M1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724080148; x=1724684948;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rCuddyNf+0ZBHgPNUo3DWqvGchoe0lCOn0I22CKBsbE=;
        b=VZgPPOZis7U5JK2NaHgVUp7z15VGmHBD+yc3rXMMmEYOtQd8sZfmsKjQPe7OqFylp5
         TcBHjVHJZ1NNoOz74hu9unfbWt7FxhZfFyh2Z7emncJE0z6OO9uMLFijGjBQp7rjLaui
         N+dy7JUEt/u4QqnPnI1mQU5SnCFiYLKkfY4OuMRkLB/9kmNFdGM56mypOGi3hJv67kPk
         QrsrZQ10mujvbjPJQgyRFd7u5W373EWgJjnPFXO+8WqfmIHAVN1sIlLSEe+JvH54/a8G
         TVRzO7F1H0WKgtr0pVmUsJ/f32CGtFFssrnlXMoToznYsZBF3sW1HkJFMBcq9GfreuOH
         sanw==
X-Forwarded-Encrypted: i=1; AJvYcCWdMXFm8PBClUKn3aAU2g1qlCEMW9Mu5qgz9/tsPoofckz1Mk3Ae1Vdt2Lglc5rqzst4W3SpiaGFYvrB9pKfAWUOlA8
X-Gm-Message-State: AOJu0YwLF7qLp3FqxChQaX2z3fRelx57RDPOqAcN29jxcmv/YqecP3yB
	3CXop7Zr//ZS92wznDn1VUykNA6cVJVcgPYF6zhrYKRUD5+ovGPnoCPIwisPLT8=
X-Google-Smtp-Source: AGHT+IGDU5mZ5AzwP0fXDOYNPfdvWhEp0ajZn5PNntcXvLi6kCPsCwyGkuVzzxEvykY8Qqa+GSXArQ==
X-Received: by 2002:a17:907:2d0f:b0:a7d:23e8:94e9 with SMTP id a640c23a62f3a-a839293ef04mr821074766b.34.1724080147872;
        Mon, 19 Aug 2024 08:09:07 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:7717:7285:c2ff:fedd:7e3a? ([2a10:bac0:b000:7717:7285:c2ff:fedd:7e3a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8383946a7dsm647544266b.181.2024.08.19.08.09.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2024 08:09:07 -0700 (PDT)
Message-ID: <e7c16241-100a-4830-9628-65edb44ca78d@suse.com>
Date: Mon, 19 Aug 2024 18:09:06 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/25] KVM: TDX: create/destroy VM structure
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 linux-kernel@vger.kernel.org, Isaku Yamahata <isaku.yamahata@intel.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Yan Zhao <yan.y.zhao@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-14-rick.p.edgecombe@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <20240812224820.34826-14-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 13.08.24 г. 1:48 ч., Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Implement managing the TDX private KeyID to implement, create, destroy
> and free for a TDX guest.
> 
> When creating at TDX guest, assign a TDX private KeyID for the TDX guest
> for memory encryption, and allocate pages for the guest. These are used
> for the Trust Domain Root (TDR) and Trust Domain Control Structure (TDCS).
> 
> On destruction, free the allocated pages, and the KeyID.
> 
> Before tearing down the private page tables, TDX requires the guest TD to
> be destroyed by reclaiming the KeyID. Do it at vm_destroy() kvm_x86_ops
> hook.
> 
> Add a call for vm_free() at the end of kvm_arch_destroy_vm() because the
> per-VM TDR needs to be freed after the KeyID.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---

<snip>


> @@ -19,14 +20,14 @@ static const struct tdx_sysinfo *tdx_sysinfo;
>   /* TDX KeyID pool */
>   static DEFINE_IDA(tdx_guest_keyid_pool);
>   
> -static int __used tdx_guest_keyid_alloc(void)
> +static int tdx_guest_keyid_alloc(void)
>   {
>   	return ida_alloc_range(&tdx_guest_keyid_pool, tdx_guest_keyid_start,
>   			       tdx_guest_keyid_start + tdx_nr_guest_keyids - 1,
>   			       GFP_KERNEL);
>   }
>   
> -static void __used tdx_guest_keyid_free(int keyid)
> +static void tdx_guest_keyid_free(int keyid)
>   {
>   	ida_free(&tdx_guest_keyid_pool, keyid);
>   }
> @@ -73,6 +74,305 @@ int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>   	return r;
>   }
>   
> +/*
> + * Some SEAMCALLs acquire the TDX module globally, and can fail with
> + * TDX_OPERAND_BUSY.  Use a global mutex to serialize these SEAMCALLs.
> + */
> +static DEFINE_MUTEX(tdx_lock);

The way this lock is used is very ugly. So it essentially mimics a lock 
which already lives in the tdx module. So why not simply gracefully 
handle the TDX_OPERAND_BUSY return value or change the interface of the 
module (yeah, it's probably late for this now) so expose the lock. This 
lock breaks one of the main rules of locking - "Lock data and not code"

> +
> +/* Maximum number of retries to attempt for SEAMCALLs. */
> +#define TDX_SEAMCALL_RETRIES	10000
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
> +	 * The page could have been poisoned.  MOVDIR64B also clears
> +	 * the poison bit so the kernel can safely use the page again.
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
> +static u64 ____tdx_reclaim_page(hpa_t pa, u64 *rcx, u64 *rdx, u64 *r8)

Just inline this into its sole caller. Yes each specific function is 
rather small but if you have to go through several levels of indirection 
then there's no point in splitting it...


> +{
> +	u64 err;
> +	int i;
> +
> +	for (i = TDX_SEAMCALL_RETRIES; i > 0; i--) {
> +		err = tdh_phymem_page_reclaim(pa, rcx, rdx, r8);
> +		switch (err) {
> +		case TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX:
> +		case TDX_OPERAND_BUSY | TDX_OPERAND_ID_TDR:
> +			cond_resched();
> +			continue;
> +		default:
> +			goto out;
> +		}
> +	}
> +
> +out:
> +	return err;
> +}
> +

<snip>

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
> +	/* KeyID has been allocated but guest is not yet configured */
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
> +	 * TDH.PHYMEM.CACHE.WB tries to acquire the TDX module global lock
> +	 * and can fail with TDX_OPERAND_BUSY when it fails to get the lock.
> +	 * Multiple TDX guests can be destroyed simultaneously. Take the
> +	 * mutex to prevent it from getting error.
> +	 */
> +	mutex_lock(&tdx_lock);
> +
> +	/*
> +	 * We need three SEAMCALLs, TDH.MNG.VPFLUSHDONE(), TDH.PHYMEM.CACHE.WB(),
> +	 * and TDH.MNG.KEY.FREEID() to free the HKID. When the HKID is assigned,
> +	 * we need to use TDH.MEM.SEPT.REMOVE() or TDH.MEM.PAGE.REMOVE(). When
> +	 * the HKID is free, we need to use TDH.PHYMEM.PAGE.RECLAIM().  Get lock
> +	 * to not present transient state of HKID.
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
> +		on_each_cpu_mask(targets, smp_func_do_phymem_cache_wb, NULL, true);
> +	else
> +		on_each_cpu(smp_func_do_phymem_cache_wb, NULL, true);
> +	/*
> +	 * In the case of error in smp_func_do_phymem_cache_wb(), the following
> +	 * tdh_mng_key_freeid() will fail.
> +	 */
> +	err = tdh_mng_key_freeid(kvm_tdx);
> +	if (KVM_BUG_ON(err, kvm)) {
> +		pr_tdx_error(TDH_MNG_KEY_FREEID, err);
> +		pr_err("tdh_mng_key_freeid() failed. HKID %d is leaked.\n",
> +		       kvm_tdx->hkid);
> +	} else {
> +		tdx_hkid_free(kvm_tdx);
> +	}
> +
> +	write_unlock(&kvm->mmu_lock);
> +	mutex_unlock(&tdx_lock);
> +	cpus_read_unlock();
> +	free_cpumask_var(targets);
> +	free_cpumask_var(packages);
> +}
> +
> +static inline u8 tdx_sysinfo_nr_tdcs_pages(void)
> +{
> +	return tdx_sysinfo->td_ctrl.tdcs_base_size / PAGE_SIZE;
> +}

Just add a nr_tdcs_pages to struct tdx_sysinfo_td_ctrl and claculate 
this value in get_tdx_td_ctrl() rather than having this long-named 
non-sense. This value can't be calculated at compiletime anyway.

> +
> +void tdx_vm_free(struct kvm *kvm)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	u64 err;
> +	int i;
> +
> +	/*
> +	 * tdx_mmu_release_hkid() failed to reclaim HKID.  Something went wrong
> +	 * heavily with TDX module.  Give up freeing TD pages.  As the function
> +	 * already warned, don't warn it again.
> +	 */
> +	if (is_hkid_assigned(kvm_tdx))
> +		return;
> +
> +	if (kvm_tdx->tdcs_pa) {
> +		for (i = 0; i < tdx_sysinfo_nr_tdcs_pages(); i++) {
> +			if (!kvm_tdx->tdcs_pa[i])
> +				continue;
> +
> +			tdx_reclaim_control_page(kvm_tdx->tdcs_pa[i]);
> +		}
> +		kfree(kvm_tdx->tdcs_pa);
> +		kvm_tdx->tdcs_pa = NULL;
> +	}
> +
> +	if (!kvm_tdx->tdr_pa)
> +		return;

Use is_td_created() helper. Also isn't this check redundant since you've 
already executed is_hkid_assigned() and if the VM is not properly 
created i.e __tdx_td_init() has failed for whatever reason then the 
is_hkid_assigned check will also fail?

> +
> +	if (__tdx_reclaim_page(kvm_tdx->tdr_pa))
> +		return;
> +
> +	/*
> +	 * Use a SEAMCALL to ask the TDX module to flush the cache based on the
> +	 * KeyID. TDX module may access TDR while operating on TD (Especially
> +	 * when it is reclaiming TDCS).
> +	 */
> +	err = tdh_phymem_page_wbinvd(set_hkid_to_hpa(kvm_tdx->tdr_pa,
> +						     tdx_global_keyid));
> +	if (KVM_BUG_ON(err, kvm)) {
> +		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
> +		return;
> +	}
> +	tdx_clear_page(kvm_tdx->tdr_pa);
> +
> +	free_page((unsigned long)__va(kvm_tdx->tdr_pa));
> +	kvm_tdx->tdr_pa = 0;
> +}
> +

<snip>

