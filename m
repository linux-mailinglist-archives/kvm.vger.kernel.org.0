Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008304ACC27
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 23:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244779AbiBGWmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 17:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240195AbiBGWmU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 17:42:20 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAA1C0612A4
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 14:42:19 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v15-20020a17090a4ecf00b001b82db48754so703752pjl.2
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 14:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gVc/rSf8hc23i8BzLsnLzzxnzHxUect8vesEyQ0bjYQ=;
        b=MLap6RMLL02SXvhnBx0wvmT2F2aV1wjKwPElYKitbKZAPZebylvQ6QlI1JoNlHkXb0
         tvzYZtWSl5bGRdXPB/pr0Dj+XaVcJwI3TfKVnAX3zO4A53Gat1L3c8Qrq2FlwIPtRP2Q
         u0ZISa51pSr3EpXKj1wm5r3O4T5XMViJck0tHXU3wtaLxsKz1isy4mOTdXZ7NFGtpTSj
         Qc5txrvcRvFakKnTQVh0ikuIBtOCLS2P1R6REpZlnejbH05gTUnWPBa1LDXwTKsFIsop
         t0MkwIgF9AJvf7e3pBoPzo6bxzRSYAsXmL+E3za/GfwW2E+AvsrohXL3YQFrR9TNgJ5d
         vA1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gVc/rSf8hc23i8BzLsnLzzxnzHxUect8vesEyQ0bjYQ=;
        b=ZiJfrrgeyaznj53/FolZhAta2k7USxLMtJkzkUOOqo7S2eLInsAKPv30k4bHqds1bE
         hHW+9Q4mzsFTpm+w4fDwGlnZZOW8VV9E1XWxWccNIY3Fp/qQ8z7BDwtbyor1qGWVIvoU
         DxPwuabOD1BK802QLMHLImoeFUuHQS70FG4Z++jA5WWjoLCbgZNooeqUCV+Zq8/AWYSo
         lJ8te+AjslMyeX01PjtNkL+pkMG6Jq8+/KizNrE4l+62sZcaBeVtRPuhx66AvNuB508i
         Jg9wmTNsqV3lRU0S/avu4JE8bLtbp0VIOsOd3CQ8zZaBRz9xQ9MjTUpQrlTVUrHTULTz
         MUUQ==
X-Gm-Message-State: AOAM533lINrtdddD/9kVM83lqCaGsH8s0dIcpG0zqSlbWhEawLcr6tCV
        vwZ+PchQ6XWEvJjUpo5kvdUw1Q==
X-Google-Smtp-Source: ABdhPJzMYjbaLbphx31DbZWtfp6MdWr2uF1eeiUb9JpYVvgj7VltjPbnWheM7dxx9YcZ+xq5GF2nQg==
X-Received: by 2002:a17:902:e84c:: with SMTP id t12mr1715065plg.63.1644273739162;
        Mon, 07 Feb 2022 14:42:19 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id c7sm13039915pfp.164.2022.02.07.14.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 14:42:18 -0800 (PST)
Date:   Mon, 7 Feb 2022 22:42:14 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com
Subject: Re: [PATCH 20/23] KVM: MMU: pull CPU role computation to kvm_init_mmu
Message-ID: <YgGgRm/QNbordgqi@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-21-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204115718.14934-21-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 04, 2022 at 06:57:15AM -0500, Paolo Bonzini wrote:
> Do not lead init_kvm_*mmu into the temptation of poking
> into struct kvm_mmu_role_regs, by passing to it directly
> the CPU role.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 01027da82e23..6f9d876ce429 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4721,11 +4721,9 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
>  	return role;
>  }
>  
> -static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
> -			     const struct kvm_mmu_role_regs *regs)
> +static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_role cpu_role)
>  {
>  	struct kvm_mmu *context = &vcpu->arch.root_mmu;
> -	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
>  	union kvm_mmu_page_role mmu_role = kvm_calc_tdp_mmu_root_page_role(vcpu, cpu_role);
>  
>  	if (cpu_role.as_u64 == context->cpu_role.as_u64 &&
> @@ -4779,10 +4777,9 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
>  }
>  
>  static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
> -				const struct kvm_mmu_role_regs *regs)
> +				union kvm_mmu_role cpu_role)
>  {
>  	struct kvm_mmu *context = &vcpu->arch.root_mmu;
> -	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
>  	union kvm_mmu_page_role mmu_role;
>  
>  	mmu_role = cpu_role.base;
> @@ -4874,20 +4871,19 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
>  EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
>  
>  static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
> -			     const struct kvm_mmu_role_regs *regs)
> +			     union kvm_mmu_role cpu_role)
>  {
>  	struct kvm_mmu *context = &vcpu->arch.root_mmu;
>  
> -	kvm_init_shadow_mmu(vcpu, regs);
> +	kvm_init_shadow_mmu(vcpu, cpu_role);
>  
>  	context->get_guest_pgd     = get_cr3;
>  	context->get_pdptr         = kvm_pdptr_read;
>  	context->inject_page_fault = kvm_inject_page_fault;
>  }
>  
> -static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
> +static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_role new_role)
>  {
> -	union kvm_mmu_role new_role = kvm_calc_cpu_role(vcpu, regs);
>  	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
>  
>  	if (new_role.as_u64 == g_context->cpu_role.as_u64)
> @@ -4928,13 +4924,14 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, const struct kvm_mmu_role
>  void kvm_init_mmu(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
> +	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, &regs);

WDYT about also inlining vcpu_to_role_regs() in kvm_calc_cpu_role()?

>  
>  	if (mmu_is_nested(vcpu))
> -		init_kvm_nested_mmu(vcpu, &regs);
> +		init_kvm_nested_mmu(vcpu, cpu_role);
>  	else if (tdp_enabled)
> -		init_kvm_tdp_mmu(vcpu, &regs);
> +		init_kvm_tdp_mmu(vcpu, cpu_role);
>  	else
> -		init_kvm_softmmu(vcpu, &regs);
> +		init_kvm_softmmu(vcpu, cpu_role);
>  }
>  EXPORT_SYMBOL_GPL(kvm_init_mmu);
>  
> -- 
> 2.31.1
> 
> 
