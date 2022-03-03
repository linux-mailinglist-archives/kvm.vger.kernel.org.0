Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A58F54CC75E
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 21:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235403AbiCCUze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 15:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbiCCUzd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 15:55:33 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA01179A1E
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 12:54:47 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 6so1195336pgg.0
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 12:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6923d+EbNGffBmTjO7FcrS9VUBDOu0Kmo8rJe583zys=;
        b=DEt21+vizmsV5J7JlPjzR0qTlrTRkcIgNQWhUO+KoAmDX9j2B3R8Ej50Y6cIOcZweG
         VMXviUaMJwwzOLOBm1JMaLKWwIVGZhILZiGRD8rXhpYG9C/hShdhXGXWX5nfdGMFfsKm
         HeG1g26bQxvfHTrjDTe0yByRYEF3r/XNMTPdCJnOGLiGQbc1kEtOS4vTdJRPiyQVTOfc
         ASTsXyKk2MF1R8uT8/H8U5DtId0Pfv7SibZWvVF+859+mwKC1Oi2uz3VulBhIK8+Jbx+
         lJDyAmq8VIRr2RssT68m43zgRi8nOsUevk7FWPmB8M5JzjIIy00IZKGbwt1VwwhQMt3I
         woGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6923d+EbNGffBmTjO7FcrS9VUBDOu0Kmo8rJe583zys=;
        b=Oln0+tIbRVRIYNUUu+NAqZc86IsJnX6CO9YUCvKq+H6CgJ5E9UshaowGbZfTX5zLFx
         K9v92J23fsqjD/vfrvE82V3ap97U1uKGICCep+re21ZFX/Cyulw3lDUvvY5ZqrT+LQag
         5MjCYE2vW/k/v6UmVZXdghK2Ni+IBlfeBEQt1j9I7hdqPVTJhWOS0VKHwwDzSJhXLojU
         LJ+Tsd4gd0MxViKsvh6uqwk4nEoox+oxu6bXUHMCdh5zRHQYJ9B8i7dxaqs1qr0eBoVy
         F7rgMpv3PWFWG9RaYaN5WTjczglkb5DyHoQ9wF9s99NswahcSXewTePSAfvggCQCoj3H
         KM2g==
X-Gm-Message-State: AOAM530YC1PS3QQcGmxbvDlk8rTsAEsmBNbGm7FhtdyKNuIQAln3AEKC
        xs5U3Y6NkB4rLKGASWk927bhIw==
X-Google-Smtp-Source: ABdhPJwphEFlRz2K8gGOLNm/3+DPAnRBurotvjAumMgfUtpoQB4L3p/uZhR5sLjyTj4yloQ1mZsXvg==
X-Received: by 2002:a05:6a00:1889:b0:4f6:ae19:130d with SMTP id x9-20020a056a00188900b004f6ae19130dmr1205057pfh.28.1646340886828;
        Thu, 03 Mar 2022 12:54:46 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id lx7-20020a17090b4b0700b001b7d5b6d10asm2788129pjb.48.2022.03.03.12.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 12:54:46 -0800 (PST)
Date:   Thu, 3 Mar 2022 20:54:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v4 21/30] KVM: x86/mmu: Zap invalidated roots via
 asynchronous worker
Message-ID: <YiErEoIMDZy94HIH@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-22-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303193842.370645-22-pbonzini@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022, Paolo Bonzini wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0b88592495f8..9287ee078c49 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5730,7 +5730,6 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>  	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS);
>  
>  	kvm_zap_obsolete_pages(kvm);
> -

Spurious whitespace deletion.

>  	write_unlock(&kvm->mmu_lock);
>  
>  	/*
> @@ -5741,11 +5740,8 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>  	 * Deferring the zap until the final reference to the root is put would
>  	 * lead to use-after-free.
>  	 */
> -	if (is_tdp_mmu_enabled(kvm)) {
> -		read_lock(&kvm->mmu_lock);
> +	if (is_tdp_mmu_enabled(kvm))
>  		kvm_tdp_mmu_zap_invalidated_roots(kvm);
> -		read_unlock(&kvm->mmu_lock);
> -	}
>  }
>  
>  static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)

...

> +static void tdp_mmu_schedule_zap_root(struct kvm *kvm, struct kvm_mmu_page *root)
> +{

Definitely worth doing (I'll provide more info in the "Zap defunct roots" patch):

	WARN_ON_ONCE(!root->role.invalid || root->tdp_mmu_async_data);

The assertion on role.invalid is a little overkill, but might help document when
and how this is used.

> +	root->tdp_mmu_async_data = kvm;
> +	INIT_WORK(&root->tdp_mmu_async_work, tdp_mmu_zap_root_work);
> +	queue_work(kvm->arch.tdp_mmu_zap_wq, &root->tdp_mmu_async_work);
> +}
> +
> +static inline bool kvm_tdp_root_mark_invalid(struct kvm_mmu_page *page)
> +{
> +	union kvm_mmu_page_role role = page->role;
> +	role.invalid = true;
> +
> +	/* No need to use cmpxchg, only the invalid bit can change.  */
> +	role.word = xchg(&page->role.word, role.word);
> +	return role.invalid;

This helper is unused.  It _could_ be used here, but I think it belongs in the
next patch.  Critically, until zapping defunct roots creates the invariant that
invalid roots are _always_ zapped via worker, kvm_tdp_mmu_invalidate_all_roots()
must not assume that an invalid root is queued for zapping.  I.e. doing this
before the "Zap defunct roots" would be wrong:

	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
		if (kvm_tdp_root_mark_invalid(root))
			continue;

		if (WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root)));
			continue;

		tdp_mmu_schedule_zap_root(kvm, root);
	}
