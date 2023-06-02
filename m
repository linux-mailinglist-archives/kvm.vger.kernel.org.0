Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86CCB71FA74
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 09:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbjFBHA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 03:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233860AbjFBHAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 03:00:23 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D42B184;
        Fri,  2 Jun 2023 00:00:22 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e9e14a558f8ab-33cb82122c7so6292115ab.1;
        Fri, 02 Jun 2023 00:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685689221; x=1688281221;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dCHadHd9vWLr/cppVzhnLS35J8Z6M9qLM9BiJZIa57k=;
        b=M9L66BR4UFQVCX77NrhhhsT1PJMo0wISauOC1oGX3FqKRVK94zsUJgvW1yqytckBOz
         30ltYo0ItOxVeC9c8Pk/JfXoXfutNCxo7cswGkQ7Z/KMNMxmyL75I31kD1Qwa9xI4pdp
         07d3HdFEIHbsdNJb4KNRy1nAdL03PLl0+hdE3FRcxdVQj4ymZrYkvGl+WzPtwyWXExle
         32Pursln/+RdC9a+uXQdNSDsldVGmk0B5Rjsv9Ah2uMZRPLMXv40sN9QA6OFFrDterod
         A4Bf7wVByBSNCZfiZ6bIHxV6wD1qjKAU1P6vaXks8uYTBwZM04Tq6EeXLJurf37Mxh+4
         VkcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685689221; x=1688281221;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dCHadHd9vWLr/cppVzhnLS35J8Z6M9qLM9BiJZIa57k=;
        b=AAGMFi+lBbLuSZMaGngbJnPTEr2onM3ktdtUPQYtzEojhjmOrXMmAM10TZtMSHl+M4
         QF90EgA1PfFjNi5xCBH+sCtNYrY4FFvqKBFhHlbGCYdAzVT4vMXxD0r5z2p/exJsV/q0
         lAijHaHyGj1RJc1Auwe7xaVkEl9c6A/yS9ABRKE0FUTGqk3yH2Uj8tOJk/JBIljH9oq1
         4hbtLw3RjDVldBcFLnuxQ2ze8S0aZk+tWlGJvnJl93b5AJvkIImiBhp2ZDIZptRqPT/k
         R1g+NoUEQcE0WRxzh616Ha5hVI5XIONkCAQo4Oj6BhnJM+YtmvSScqqyB30SgxghddY0
         +pRw==
X-Gm-Message-State: AC+VfDxEoe5SqxFn/6OvDYTYduoKZzyVaVP69lfMbiGQlTk20uMQB8Fd
        Do2NhkquwreYrCw0OxyLvVo=
X-Google-Smtp-Source: ACHHUZ7ieQsC4HpU1I7aE3NSuPlPX3GB2yv4MQRbI/djDWEysITZWiZqB1pMVrx/lKaw6wTIdByYFw==
X-Received: by 2002:a92:de0e:0:b0:335:38b:e734 with SMTP id x14-20020a92de0e000000b00335038be734mr6306429ilm.28.1685689220926;
        Fri, 02 Jun 2023 00:00:20 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id t7-20020a654087000000b00520f4ecd71esm477999pgp.93.2023.06.02.00.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 00:00:20 -0700 (PDT)
Date:   Fri, 2 Jun 2023 00:00:19 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sagi Shahar <sagis@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH 4/5] KVM: TDX: Implement moving private pages between
 2 TDs
Message-ID: <20230602070019.GJ1234772@ls.amr.corp.intel.com>
References: <20230407201921.2703758-1-sagis@google.com>
 <20230407201921.2703758-5-sagis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230407201921.2703758-5-sagis@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 07, 2023 at 08:19:20PM +0000,
Sagi Shahar <sagis@google.com> wrote:

> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 327dee4f6170e..685528fdc0ad6 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -296,6 +296,23 @@ static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
>  	trace_kvm_mmu_get_page(sp, true);
>  }
>  
> +static struct kvm_mmu_page *
> +kvm_tdp_mmu_get_vcpu_root_no_alloc(struct kvm_vcpu *vcpu, union kvm_mmu_page_role role)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_mmu_page *root;
> +
> +	lockdep_assert_held_read(&kvm->mmu_lock);

Because kvm_tdp_mmu_get_cpu_root() holds write lock, 
this should be lockdep_assert_held(&kvm->mmu_lock)

Thanks,

> +
> +	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
> +		if (root->role.word == role.word &&
> +		    kvm_tdp_mmu_get_root(root))
> +			return root;
> +	}
> +
> +	return NULL;
> +}
> +
>  static struct kvm_mmu_page *kvm_tdp_mmu_get_vcpu_root(struct kvm_vcpu *vcpu,
>  						      bool private)
>  {
> @@ -311,11 +328,9 @@ static struct kvm_mmu_page *kvm_tdp_mmu_get_vcpu_root(struct kvm_vcpu *vcpu,
>  	 */
>  	if (private)
>  		kvm_mmu_page_role_set_private(&role);
> -	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
> -		if (root->role.word == role.word &&
> -		    kvm_tdp_mmu_get_root(root))
> -			goto out;
> -	}
> +	root = kvm_tdp_mmu_get_vcpu_root_no_alloc(vcpu, role);
> +	if (!!root)
> +		goto out;
>  
>  	root = tdp_mmu_alloc_sp(vcpu, role);
>  	tdp_mmu_init_sp(root, NULL, 0);
> @@ -330,6 +345,58 @@ static struct kvm_mmu_page *kvm_tdp_mmu_get_vcpu_root(struct kvm_vcpu *vcpu,
>  	return root;
>  }
>  
> +hpa_t kvm_tdp_mmu_move_private_pages_from(struct kvm_vcpu *vcpu,
> +					  struct kvm_vcpu *src_vcpu)
> +{
> +	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm *src_kvm = src_vcpu->kvm;
> +	struct kvm_mmu_page *private_root = NULL;
> +	struct kvm_mmu_page *root;
> +	s64 num_private_pages, old;
> +
> +	lockdep_assert_held_write(&vcpu->kvm->mmu_lock);
> +	lockdep_assert_held_write(&src_vcpu->kvm->mmu_lock);
> +
> +	/* Find the private root of the source. */
> +	kvm_mmu_page_role_set_private(&role);
> +	for_each_tdp_mmu_root(src_kvm, root, kvm_mmu_role_as_id(role)) {
> +		if (root->role.word == role.word) {
> +			private_root = root;
> +			break;
> +		}
> +	}
> +	if (!private_root)
> +		return INVALID_PAGE;
> +
> +	/* Remove the private root from the src kvm and add it to dst kvm. */
> +	list_del_rcu(&private_root->link);
> +	list_add_rcu(&private_root->link, &kvm->arch.tdp_mmu_roots);
> +
> +	num_private_pages = atomic64_read(&src_kvm->arch.tdp_private_mmu_pages);
> +	old = atomic64_cmpxchg(&kvm->arch.tdp_private_mmu_pages, 0,
> +			       num_private_pages);
> +	/* The destination VM should have no private pages at this point. */
> +	WARN_ON(old);
> +	atomic64_set(&src_kvm->arch.tdp_private_mmu_pages, 0);
> +
> +	return __pa(private_root->spt);
> +}
> +
> +hpa_t kvm_tdp_mmu_get_vcpu_root_hpa_no_alloc(struct kvm_vcpu *vcpu, bool private)
> +{
> +	struct kvm_mmu_page *root;
> +	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
> +
> +	if (private)
> +		kvm_mmu_page_role_set_private(&role);
> +	root = kvm_tdp_mmu_get_vcpu_root_no_alloc(vcpu, role);
> +	if (!root)
> +		return INVALID_PAGE;
> +
> +	return __pa(root->spt);
> +}
> +
>  hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu, bool private)
>  {
>  	return __pa(kvm_tdp_mmu_get_vcpu_root(vcpu, private)->spt);

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
