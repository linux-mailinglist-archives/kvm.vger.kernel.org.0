Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4465F6D3658
	for <lists+kvm@lfdr.de>; Sun,  2 Apr 2023 10:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjDBImG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Apr 2023 04:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDBImD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Apr 2023 04:42:03 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF9811D;
        Sun,  2 Apr 2023 01:42:02 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-29bd5a3f8d6so748521fa.1;
        Sun, 02 Apr 2023 01:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680424920;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hx5Gw7WmryUXgI6LhQOTjsEvTmnrKOnK4uRhY0+VI64=;
        b=pzVrVRkBoyMyW9zVhurnb26Nox/xIsOcMjuP3potr/ml5U8FRg8pyIThwV/ZiT2K4N
         aC0PdgCWoE5Q8PBmo7Nsm8LdvxhWnsZ6N0yLQEcQOpbZlBPv7zik6xiVKmlc+W/l8WT+
         F6DIV3rj7h7pegdE1o9vIWj6R6y9Y52W6GwGbpGc7SkmlepMVEdXyGzYngnDTNl/w4L6
         Gp5MPMsSPw7dnlvpttDo3LbtGFgjv4EsEpHIdNuhRTLXuzq92omYRrLNgE5LJbjKoA8T
         WsRMH1T7pxPJT6K249JEO0iuSLZx2qPbPa9rFaJN1eoU2/ktJgXBWMRcFXUFgv9Ele7A
         gY5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680424920;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hx5Gw7WmryUXgI6LhQOTjsEvTmnrKOnK4uRhY0+VI64=;
        b=SVs6KdMvCHn3Rk1fcDiP0Xc12ueUBvqgL/kRePoU6lsUXdFEi1ECMdEJeE7IYTz2Ie
         Fb2Q6dQZg5qTHrtorUMLOCtC/Q1vfS3JsZACE54n9nykJwUbmGai95vqBEL/rPynxy8u
         9hyxZoC+RUQnQ6twegIAdR7veQI2cDpnEupOVAAaV2/oK42SzGGedZkQH6uSejqTMPuK
         w3HROCPwQ3vpC456iQXhNrbkLKt0pqmlfLxmL9pmtoSwAELPmptVbKZWENLJELtLhebA
         Jvto9WLDOjgCkMrvJN9vwMzONZFkS8abHZEEmQFyKcATnxhtnGiGZhtCCT16Bqdz28LU
         8oMw==
X-Gm-Message-State: AAQBX9dz+xmL1WgdtDS2+YLIxCuGOnRQ0wCzHY/fHZa14RmnAPc5jZ+1
        FNO9+Objo1Qn6+ibY9pLu9IjiXDj6uO0uw==
X-Google-Smtp-Source: AKy350alObyQd2UZ4MFok5ieHyILuYw2arlj+LLa/kUAtynh8FwBQ64QIHiXXMMJ0B2IBIy47pmkNQ==
X-Received: by 2002:a2e:be85:0:b0:298:a8bc:b4d4 with SMTP id a5-20020a2ebe85000000b00298a8bcb4d4mr4013958ljr.4.1680424920135;
        Sun, 02 Apr 2023 01:42:00 -0700 (PDT)
Received: from localhost (88-113-32-99.elisa-laajakaista.fi. [88.113.32.99])
        by smtp.gmail.com with ESMTPSA id i22-20020a2e9416000000b00298a7f8c4bfsm1113485ljh.67.2023.04.02.01.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 01:42:00 -0700 (PDT)
Date:   Sun, 2 Apr 2023 11:41:58 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v13 019/113] KVM: TDX: create/destroy VM structure
Message-ID: <20230402114158.00000543@gmail.com>
In-Reply-To: <20230330010153.GB1112017@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
        <7c011a5c9dd92cfb9074297af22d132a4e57fd11.1678643052.git.isaku.yamahata@intel.com>
        <20230326140936.00003397@gmail.com>
        <20230330010153.GB1112017@ls.amr.corp.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 Mar 2023 18:01:53 -0700
Isaku Yamahata <isaku.yamahata@gmail.com> wrote:

> Hi, thanks for review.
> 
> On Sun, Mar 26, 2023 at 02:09:36PM +0300,
> Zhi Wang <zhi.wang.linux@gmail.com> wrote:
> 
> > On Sun, 12 Mar 2023 10:55:43 -0700
> > isaku.yamahata@intel.com wrote:
> 
> > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > index 8b02e605cfb5..3ede8a726b47 100644
> > > --- a/arch/x86/kvm/vmx/tdx.c
> > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > @@ -5,8 +5,9 @@
> > >  
> > >  #include "capabilities.h"
> > >  #include "x86_ops.h"
> > > -#include "x86.h"
> > >  #include "tdx.h"
> > > +#include "tdx_ops.h"
> > > +#include "x86.h"
> > >  
> > >  #undef pr_fmt
> > >  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > > @@ -46,11 +47,276 @@ int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> > >  	return r;
> > >  }
> > >  
> > > +struct tdx_info {
> > > +	u8 nr_tdcs_pages;
> > > +};
> > > +
> > > +/* Info about the TDX module. */
> > > +static struct tdx_info tdx_info;
> > > +
> > > +/*
> > > + * Some TDX SEAMCALLs (TDH.MNG.CREATE, TDH.PHYMEM.CACHE.WB,
> > > + * TDH.MNG.KEY.RECLAIMID, TDH.MNG.KEY.FREEID etc) tries to acquire a global lock
> > > + * internally in TDX module.  If failed, TDX_OPERAND_BUSY is returned without
> > > + * spinning or waiting due to a constraint on execution time.  It's caller's
> > > + * responsibility to avoid race (or retry on TDX_OPERAND_BUSY).  Use this mutex
> > > + * to avoid race in TDX module because the kernel knows better about scheduling.
> > > + */
> > > +static DEFINE_MUTEX(tdx_lock);
> > > +static struct mutex *tdx_mng_key_config_lock;
> > > +
> > > +static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
> > > +{
> > > +	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
> > > +}
> > > +
> > > +static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
> > > +{
> > > +	return kvm_tdx->tdr_pa;
> > > +}
> > > +
> > > +static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
> > > +{
> > > +	tdx_guest_keyid_free(kvm_tdx->hkid);
> > > +	kvm_tdx->hkid = 0;
> > > +}
> > > +
> > > +static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
> > > +{
> > > +	return kvm_tdx->hkid > 0;
> > > +}
> > > +
> > >  int tdx_hardware_enable(void)
> > >  {
> > >  	return tdx_cpu_enable();
> > >  }
> > >  
> > > +static void tdx_clear_page(unsigned long page_pa)
> > > +{
> > > +	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> > > +	void *page = __va(page_pa);
> > > +	unsigned long i;
> > > +
> > > +	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
> > > +		clear_page(page);
> > > +		return;
> > > +	}
> > 
> > Is it possbile to have a TDX machine without MOVDIR64B support? I am not sure
> > if there is any other way for the kernel to clear the posioned cache line.
> > 
> > If not, there should be a warn/bug at least and check if MOVDIR64B support
> > when initializing the TDX.
> 
> Because the latest TDX specification uses movdir64b, it's safe for TDX
> to assume movdir64b.
> I'll add the check to TDX initialization part and drop it from here.
> 
> 
> > > +void tdx_mmu_release_hkid(struct kvm *kvm)
> > > +{
> > > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > > +	cpumask_var_t packages;
> > > +	bool cpumask_allocated;
> > > +	u64 err;
> > > +	int ret;
> > > +	int i;
> > > +
> > > +	if (!is_hkid_assigned(kvm_tdx))
> > > +		return;
> > > +
> > > +	if (!is_td_created(kvm_tdx))
> > > +		goto free_hkid;
> > > +
> > > +	cpumask_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
> > > +	cpus_read_lock();
> > > +	for_each_online_cpu(i) {
> > > +		if (cpumask_allocated &&
> > > +			cpumask_test_and_set_cpu(topology_physical_package_id(i),
> > > +						packages))
> > > +			continue;
> > 
> > Is this necessary to check cpumask_allocated in the while loop? if cpumask
> > is not succefully allocated, wouldn't it be better to bail out just after
> > it?
> 
> No because we can't return error here.  It's better to do in-efficiently freeing
> resources instead of leak.
> 
> We can move the check out of loop. But it would be ugly
> (if () {cpu loop} else {cpu loop} ) and this function isn't performance
> critical.  Also I think it's okay to depend on compiler optimization for loop
> invariant. My compiler didn't optimize it in this case, though.
> 

Do you mean the tdh_mng_key_freeid() is still required if failing to allocate
the cpumask var and do TDH.PHYMEM_CACHE_WB(WBINVD) on each CPU?

Out of curiosity, I took a look on the TDX module source code [1], it seems TDX
module has an additional check in TDH.MNG.KEY.FREEID. TDH.MNG.VPFLUSHDONE [2]
will mark the pending wbinvd in a bitmap:

...
/**
     * Create the WBINVD_BITMAP per-package.
     * Set to 1 num_of_pkgs bits from the LSB
     */
    global_data_ptr->kot.entries[curr_hkid].wbinvd_bitmap = global_data_ptr->pkg_config_bitmap; /* <----HERE */

    // Set new TD life cycle state
    tdr_ptr->management_fields.lifecycle_state = TD_BLOCKED;

    // Set the proper new KOT entry state
    global_data_ptr->kot.entries[curr_hkid].state = (uint8_t)KOT_STATE_HKID_FLUSHED; 
...

And TDH.MNG.KEY.FREEID [3] will check if the pending WBINVD has been performed:

...
    /**
     * If TDH_PHYMEM_CACHE_WB was executed on all packages/cores,
     * set the KOT entry, set the KOT entry state to HKID_FREE.
     */
    curr_hkid = tdr_ptr->key_management_fields.hkid;
    tdx_debug_assert(global_data_ptr->kot.entr/ies[curr_hkid].state == KOT_STATE_HKID_FLUSHED);
    if (global_data_ptr->kot.entries[curr_hkid].wbinvd_bitmap != 0) /* HERE */
    {
        TDX_ERROR("CACHEWB is not complete for this HKID (=%x)\n", curr_hkid);
        return_val = TDX_WBCACHE_NOT_COMPLETE;
        goto EXIT;
    }
...

Guess the conclusion is: if TDH.PHYMEM.CACHE.WB is not performed on each
required CPU correctly, TDH.MNG.KEY.FREEID will fail as well. A leak seems
the only option (none of us likes a leak, but...).

It would be better that:

1) Leave a comment about the finding above in the code to explain why leak
happens (It is always nice to explain the reason of a leak). One sentence
will be good enough.

2) If failing to allocate the cpumask, bail out (with the findings above)

...
cpumask_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
if (!cpumask_allocated)
	return;
...

3) As the reason of the leak will be explained in tdx_mmu_release_hkid(),
leaving a pointer in the comment in tdx_vm_free() to refer to
tdx_mmu_release_hkid() would be enough, like: 

...
/* 
 * Can't reclaim or free TD pages if teardown failed in
 * tdx_mmu_release_hkid().
 */
if (is_hkid_assigned(kvm_tdx))
	return;
...

[1] https://downloadmirror.intel.com/738876/tdx-module-v1.0.01.01.zip
[2] tdx-module/src/vmm_dispatcher/api_calls/tdh_mng_vpflushdone.c
[3] tdx-module/src/vmm_dispatcher/api_calls/tdh_mng_key_freeid.c

> 
> > > +
> > > +		/*
> > > +		 * We can destroy multiple the guest TDs simultaneously.
> > > +		 * Prevent tdh_phymem_cache_wb from returning TDX_BUSY by
> > > +		 * serialization.
> > > +		 */
> > > +		mutex_lock(&tdx_lock);
> > > +		ret = smp_call_on_cpu(i, tdx_do_tdh_phymem_cache_wb, NULL, 1);
> > > +		mutex_unlock(&tdx_lock);
> > > +		if (ret)
> > > +			break;
> > > +	}
> > > +	cpus_read_unlock();
> > > +	free_cpumask_var(packages);
> > > +
> > > +	mutex_lock(&tdx_lock);
> > > +	err = tdh_mng_key_freeid(kvm_tdx->tdr_pa);
> > > +	mutex_unlock(&tdx_lock);
> > > +	if (WARN_ON_ONCE(err)) {
> > > +		pr_tdx_error(TDH_MNG_KEY_FREEID, err, NULL);
> > > +		pr_err("tdh_mng_key_freeid failed. HKID %d is leaked.\n",
> > > +			kvm_tdx->hkid);
> > > +		return;
> > > +	}
> > > +
> > > +free_hkid:
> > > +	tdx_hkid_free(kvm_tdx);
> > > +}
> > > +
> > > +void tdx_vm_free(struct kvm *kvm)
> > > +{
> > > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > > +	int i;
> > > +
> > > +	/* Can't reclaim or free TD pages if teardown failed. */
> > > +	if (is_hkid_assigned(kvm_tdx))
> > > +		return;
> > > +
> > 
> > Better to explain why, as it is common to think even the teardown failed, we
> > should still try to reclaim the pages as many as we can.
> 
> Ok, here is the updated comment.
>  /*
>   * tdx_mmu_release_hkid() failed to reclaim HKID.  Something went wrong
>   * heavily with TDX module.  Give up freeing TD pages.  As the function
>   * already warned, don't warn it again.
>   */

