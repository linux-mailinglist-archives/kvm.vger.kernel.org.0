Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2AD5A721C
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbiH3X6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbiH3X5y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:57:54 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9BC77E86
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:57:11 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id z3-20020a17090abd8300b001fd803e34f1so10909301pjr.1
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=wj9Ogpubfn7sKiJlOpNdbznld4d+/MiAheapIhALdO8=;
        b=ZhZuRfEdRcYdyl3IlhcxaYSUXCmyEOmawDagQi0Cwk5pB3ccn6wnUT6304eqc4b2kD
         bNV6zCxfph+70shDeG+DjB7luCg49EmpDeiCwOvnK7IB06PE35IGIxy+fm3ffrpWKx3r
         anD394HUBVfav2FoSmN7WN6rejeb9vPuia4TTgcBbmQ7DocD122VqE5f3KBmUTZPJrIW
         Xs1PNnYNTGhNZcRwexQerh5iYdmba9nw8rF+bSXS2mzIdXtq/x3LA4Ecg/eEClxrHojD
         HOPBT1HtMTut2j87/m6f0dMjTTKNU0pDTDn9sleO+1nP+glH9Mt2gwbaGzU5ZewpQHYX
         69lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=wj9Ogpubfn7sKiJlOpNdbznld4d+/MiAheapIhALdO8=;
        b=cHTfWgjLbaViSBjMLIkHAsIASQd0MpKDho00qdFagGFIfDvikVffNSTZnen7HAiwwu
         vZ01pQ7DCAauGDjvT/oUBok7W+4eNx7/CzW77AJogi3wntAqpQuPPhnrA2mS40hPuQVa
         IBQ34qzLcWmK0w5r6soUJUD6wlCpjKUSOtPqKAOVlKIyDJ6v20f8lZFse/Ixwyi9pwbN
         xaSzxkp6Mz0CFpYuvziC/r5Bk17/jmyXRGvwuygbBmCxixYUHkD5OFG6raOTPr66xMc2
         AsHfekxhjIq8ftmLEIr9FkQ0b3q6XDNShN0mH8P/wEXqWp4WJGvpomb4rGUJ8jPo4Jkf
         T4Rw==
X-Gm-Message-State: ACgBeo1pwTug1o2LT5A9/mqC9hQC9sQjgzSlfMlyoTJ/WCZWL/PBUpRI
        y1ClBb+yr2/n1Gdq1iXdiu4=
X-Google-Smtp-Source: AA6agR7DOFfaCJcZLD3qzkUePrmFjdRXHZEPEUtKVEccnfVOgpbK1c6BdmIG12Azrd245c0vxHg25A==
X-Received: by 2002:a17:902:a986:b0:172:fecb:103 with SMTP id bh6-20020a170902a98600b00172fecb0103mr23407958plb.28.1661903829457;
        Tue, 30 Aug 2022 16:57:09 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902d2c300b00174ea015ee2sm11108plc.38.2022.08.30.16.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 16:57:09 -0700 (PDT)
Date:   Tue, 30 Aug 2022 16:57:08 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>, Peter Xu <peterx@redhat.com>,
        isaku.yamahata@gmail.com
Subject: Re: [PATCH v2 08/10] KVM: x86/mmu: Split out TDP MMU page fault
 handling
Message-ID: <20220830235708.GB2711697@ls.amr.corp.intel.com>
References: <20220826231227.4096391-1-dmatlack@google.com>
 <20220826231227.4096391-9-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220826231227.4096391-9-dmatlack@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 26, 2022 at 04:12:25PM -0700,
David Matlack <dmatlack@google.com> wrote:

> Split out the page fault handling for the TDP MMU to a separate
> function.  This creates some duplicate code, but makes the TDP MMU fault
> handler simpler to read by eliminating branches and will enable future
> cleanups by allowing the TDP MMU and non-TDP MMU fault paths to diverge.
> 
> Only compile in the TDP MMU fault handler for 64-bit builds since
> kvm_tdp_mmu_map() does not exist in 32-bit builds.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 62 ++++++++++++++++++++++++++++++++----------
>  1 file changed, 48 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a185599f4d1d..8f124a23ab4c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4242,7 +4242,6 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
>  
>  static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
> -	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
>  	int r;
>  
>  	if (page_fault_handle_page_track(vcpu, fault))
> @@ -4261,11 +4260,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  		return r;
>  
>  	r = RET_PF_RETRY;
> -
> -	if (is_tdp_mmu_fault)
> -		read_lock(&vcpu->kvm->mmu_lock);
> -	else
> -		write_lock(&vcpu->kvm->mmu_lock);
> +	write_lock(&vcpu->kvm->mmu_lock);
>  
>  	if (is_page_fault_stale(vcpu, fault))
>  		goto out_unlock;
> @@ -4274,16 +4269,10 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	if (r)
>  		goto out_unlock;
>  
> -	if (is_tdp_mmu_fault)
> -		r = kvm_tdp_mmu_map(vcpu, fault);
> -	else
> -		r = __direct_map(vcpu, fault);
> +	r = __direct_map(vcpu, fault);
>  
>  out_unlock:
> -	if (is_tdp_mmu_fault)
> -		read_unlock(&vcpu->kvm->mmu_lock);
> -	else
> -		write_unlock(&vcpu->kvm->mmu_lock);
> +	write_unlock(&vcpu->kvm->mmu_lock);
>  	kvm_release_pfn_clean(fault->pfn);
>  	return r;
>  }
> @@ -4331,6 +4320,46 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>  }
>  EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
>  
> +#ifdef CONFIG_X86_64
> +int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
> +			   struct kvm_page_fault *fault)

nitpick: static

> +{
> +	int r;
> +
> +	if (page_fault_handle_page_track(vcpu, fault))
> +		return RET_PF_EMULATE;
> +
> +	r = fast_page_fault(vcpu, fault);
> +	if (r != RET_PF_INVALID)
> +		return r;
> +
> +	r = mmu_topup_memory_caches(vcpu, false);
> +	if (r)
> +		return r;
> +
> +	r = kvm_faultin_pfn(vcpu, fault, ACC_ALL);
> +	if (r != RET_PF_CONTINUE)
> +		return r;
> +
> +	r = RET_PF_RETRY;
> +	read_lock(&vcpu->kvm->mmu_lock);
> +
> +	if (is_page_fault_stale(vcpu, fault))
> +		goto out_unlock;
> +
> +	r = make_mmu_pages_available(vcpu);
> +	if (r)
> +		goto out_unlock;
> +
> +	r = kvm_tdp_mmu_map(vcpu, fault);
> +
> +out_unlock:
> +	read_unlock(&vcpu->kvm->mmu_lock);
> +	kvm_release_pfn_clean(fault->pfn);
> +	return r;
> +}
> +#endif
> +
>  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	/*
> @@ -4355,6 +4384,11 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  		}
>  	}
>  
> +#ifdef CONFIG_X86_64
> +	if (tdp_mmu_enabled)
> +		return kvm_tdp_mmu_page_fault(vcpu, fault);
> +#endif
> +
>  	return direct_page_fault(vcpu, fault);
>  }

Now we mostly duplicated page_fault method.  We can go one step further.
kvm->arch.mmu.page_fault can be set for each case.  Maybe we can do it later
if necessary.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
