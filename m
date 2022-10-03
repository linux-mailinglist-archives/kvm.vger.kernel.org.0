Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209C15F3647
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 21:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiJCT2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 15:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiJCT2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 15:28:15 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F167B3DBEF
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 12:28:14 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id f21so2715054plb.13
        for <kvm@vger.kernel.org>; Mon, 03 Oct 2022 12:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=9a9y68kYBrnFgj6ZKUO52XEACOTAgJKdaK8Tsv2iR1U=;
        b=jqkYMsz+4pc7kP+kCgGKtliaZkk64q+19io3oREdLkRSBaQa43ooHa6hMtxwNmUXrI
         BQpU5Rhd6qm+KN5AqkwwjIiaR0KAWKyKKcDieXIaOY3Ix/WdBktb8RzAHJu6+/spjD8B
         JX/9DWExxXQVth20lU1tCdYcW093iTRsomkivut5b6YNPkcNIfxPCb4ug/T5NA2bN0IY
         MueJbmkBpST2XFjqV3Zxfp9AQNjEXuyKkbCi/vVf2WW13kne1dAC7hd+hbT5QXlW4+pj
         pfFGnlSa/jIfxs3NJluxegpxM7y7S+IV1bPjiC8j/go2DREU0oyIkveHJZCWsDrjHZTy
         ff3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=9a9y68kYBrnFgj6ZKUO52XEACOTAgJKdaK8Tsv2iR1U=;
        b=HcR9QGC5mS3UpQckVQf/ZK3YqgM5mswSUFjOC5BYPhLtMPvys2ULG9Z3zq8SrQI5Xg
         6JN78GpL6IYDMjS7EDmrZK+kwR5i8n45XVbDybAIKLLR1Ua219DRV3qofWnRT/0Yf9PF
         7rCk85DuhTcXNlw/XCdftcvrQI2oYoeGAkyOqgWYf12iGeN9HgZDbKPvmPsokiK0Ay+c
         9dERNEBVZDpCgtq/dsmTkefUjBHm3FJiYYj3/MnO+to1WcDQJt0x7Va/OWS6kSj6je58
         y0lGCXikIGIp0AF+VS50rd4wp2+Wp23FszY4PmcyqYwBKnIs/Ay9vihvBOSdZ4uSYAw9
         09uA==
X-Gm-Message-State: ACrzQf28iaYVtGfYtXiz6HOhktuvUtMSIoyGzzP+pbREA6p3omKDV5xe
        d0/m4PQP9Lt+eFfEnyWg44Q8oCdkQwk=
X-Google-Smtp-Source: AMsMyM7kNw1rzm8lBOnyq2+HAtQ2N5Uu1mgzN2922ZkYsg/7367U5mcVZYJ4bBnN3AUndgK5kq5a8A==
X-Received: by 2002:a17:902:e80b:b0:176:de36:f5a8 with SMTP id u11-20020a170902e80b00b00176de36f5a8mr23916830plg.127.1664825294419;
        Mon, 03 Oct 2022 12:28:14 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id b13-20020a1709027e0d00b00176c37f513dsm7497631plm.130.2022.10.03.12.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 12:28:14 -0700 (PDT)
Date:   Mon, 3 Oct 2022 12:28:13 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v3 08/10] KVM: x86/mmu: Split out TDP MMU page fault
 handling
Message-ID: <20221003192813.GF2414580@ls.amr.corp.intel.com>
References: <20220921173546.2674386-1-dmatlack@google.com>
 <20220921173546.2674386-9-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220921173546.2674386-9-dmatlack@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 10:35:44AM -0700,
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
> index dc203973de83..b36f351138f7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4238,7 +4238,6 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
>  
>  static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
> -	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
>  	int r;
>  
>  	if (page_fault_handle_page_track(vcpu, fault))
> @@ -4257,11 +4256,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
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
> @@ -4270,16 +4265,10 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
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
> @@ -4327,6 +4316,46 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>  }
>  EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
>  
> +#ifdef CONFIG_X86_64
> +static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
> +				  struct kvm_page_fault *fault)
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
> @@ -4351,6 +4380,11 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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
>  
> -- 
> 2.37.3.998.g577e59143f-goog
> 

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
