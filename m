Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F41770BC9
	for <lists+kvm@lfdr.de>; Sat,  5 Aug 2023 00:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjHDWNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 18:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjHDWNb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 18:13:31 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258D2E70
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 15:13:30 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bba5563cd6so22223945ad.3
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 15:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691187209; x=1691792009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bLXEZoOUsnNHXqyjOtZVO1kviAvs7+VEh7RjIbw2pVY=;
        b=JGKdP0TBOoAh4OTz3MaM2IVM7DNxpwffVrtvvm9L1o79RXyJJAtpHpBOvSgcwNdZX2
         vHXD6HINgJiiuqhmdNnnwrsvRAC5uXwbr4/yFPm5W55eHiXmAAQ+azo922WuaMeEHnwD
         GcFXe8chvE/OJA1hk3iiLxhDb/q7nW0Opovw9JghaSBACG/CIL++au9Wf+Sy6uFggGsS
         74vZWjiO8jTtvZQNWHk13gz+ww0O0agOHpetcqnEEQg/505syvmAKoAo9UvZQ01kgz/A
         ieoG4BvFz3Fl52WQpDm7sIF/AxiRpURNb8XYluL3Y4LD+4Ket+eZh1V3em5Ru9tcVeVD
         Cscg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691187209; x=1691792009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bLXEZoOUsnNHXqyjOtZVO1kviAvs7+VEh7RjIbw2pVY=;
        b=IAMp+bTfMcQJr1ifDvLc8F+z/6SNQrENWy/F/eU1Dixuf19yctd2TX09EAsyJMv2Y5
         Zhh9b/upZJHz0GrTVMOpYjiEDA33x0Y7Relyq/dvSFUY5fYjhqeRoLG+g3yXolJ1KjVO
         w5ynsXAngFP8BK93Ov3ULHYPK+N9Oos9CPRuczexJjUrKzkuJ4C4C1OUF9sGICqX5ZAL
         E2b+OozQUSyhf0Lky+qZvvbkfF0HbcHJRcmOZL6IP1nSw9ciQojahpSbmzz0aZupIwxy
         KuXjFCyAuhs+mlDCRJKu+Oaek/7Zbp/x0pbjuTd5ugkCYJ1GPH2BEyywQ5dcU9V3OYw8
         DgBw==
X-Gm-Message-State: AOJu0YygZcI4mCzeKDFvMN5sW92IjjfawsgLbOZT60DkgGD+UGONoJ7G
        K8XVooYtM2hUoo5KeQgUiKtISSIHiNA=
X-Google-Smtp-Source: AGHT+IFFa6OQWPgXCVghPOvFrLXoLg027dv5kKy0zEJuMmkaxG1AU5Kgm6Ipp0dVxLufrqFjcx7hU8Umd6E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2448:b0:1b8:3c5e:2289 with SMTP id
 l8-20020a170903244800b001b83c5e2289mr9543pls.2.1691187209565; Fri, 04 Aug
 2023 15:13:29 -0700 (PDT)
Date:   Fri, 4 Aug 2023 15:13:28 -0700
In-Reply-To: <20230704075054.3344915-3-stevensd@google.com>
Mime-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-3-stevensd@google.com>
Message-ID: <ZM14CHeY4DvjAlqG@google.com>
Subject: Re: [PATCH v7 2/8] KVM: Introduce __kvm_follow_pfn function
From:   Sean Christopherson <seanjc@google.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 04, 2023, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> Introduce __kvm_follow_pfn, which will replace __gfn_to_pfn_memslot.
> __kvm_follow_pfn refactors the old API's arguments into a struct and,
> where possible, combines the boolean arguments into a single flags
> argument.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  include/linux/kvm_host.h |  16 ++++
>  virt/kvm/kvm_main.c      | 171 ++++++++++++++++++++++-----------------
>  virt/kvm/kvm_mm.h        |   3 +-
>  virt/kvm/pfncache.c      |   8 +-
>  4 files changed, 122 insertions(+), 76 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 9d3ac7720da9..ef2763c2b12e 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -97,6 +97,7 @@
>  #define KVM_PFN_ERR_HWPOISON	(KVM_PFN_ERR_MASK + 1)
>  #define KVM_PFN_ERR_RO_FAULT	(KVM_PFN_ERR_MASK + 2)
>  #define KVM_PFN_ERR_SIGPENDING	(KVM_PFN_ERR_MASK + 3)
> +#define KVM_PFN_ERR_NEEDS_IO	(KVM_PFN_ERR_MASK + 4)

Hmm, ideally KVM_PFN_ERR_NEEDS_IO would be introduced in a separate prep patch,
e.g. by changing "bool *async" to "bool no_wait".  At a glance, I can't tell if
that's feasible though, so consider it more of a "wish" than a request.

> @@ -2572,23 +2561,23 @@ static int kvm_try_get_pfn(kvm_pfn_t pfn)
>  	return get_page_unless_zero(page);
>  }
>  
> -static int hva_to_pfn_remapped(struct vm_area_struct *vma,
> -			       unsigned long addr, bool write_fault,
> -			       bool *writable, kvm_pfn_t *p_pfn)
> +static int hva_to_pfn_remapped(struct vm_area_struct *vma, struct kvm_follow_pfn *foll,
> +			       kvm_pfn_t *p_pfn)

Please wrap.  KVM still honors the 80 char soft limit unless there's a reason not
to, and in this case it's already wrapping

static int hva_to_pfn_remapped(struct vm_area_struct *vma,
			       struct kvm_follow_pfn *foll, kvm_pfn_t *p_pfn)

> @@ -2606,8 +2595,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>  		goto out;
>  	}
>  
> -	if (writable)
> -		*writable = pte_write(*ptep);
> +	foll->writable = pte_write(*ptep) && foll->allow_write_mapping;

Similar to feedback in my other response, don't condition this on try_map_writable,
i.e. just do:

	foll->writable = pte_write(...);

>  	pfn = pte_pfn(*ptep);
>  
>  	/*
> @@ -2652,24 +2640,22 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>   * 2): @write_fault = false && @writable, @writable will tell the caller
>   *     whether the mapping is writable.
>   */
> -kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
> -		     bool *async, bool write_fault, bool *writable)
> +kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *foll)
>  {
>  	struct vm_area_struct *vma;
>  	kvm_pfn_t pfn;
>  	int npages, r;
>  
>  	/* we can do it either atomically or asynchronously, not both */
> -	BUG_ON(atomic && async);
> +	BUG_ON(foll->atomic && (foll->flags & FOLL_NOWAIT));
>  
> -	if (hva_to_pfn_fast(addr, write_fault, writable, &pfn))
> +	if (hva_to_pfn_fast(foll, &pfn))
>  		return pfn;
>  
> -	if (atomic)
> +	if (foll->atomic)
>  		return KVM_PFN_ERR_FAULT;
>  
> -	npages = hva_to_pfn_slow(addr, async, write_fault, interruptible,
> -				 writable, &pfn);
> +	npages = hva_to_pfn_slow(foll, &pfn);
>  	if (npages == 1)
>  		return pfn;
>  	if (npages == -EINTR)
> @@ -2677,83 +2663,122 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
>  
>  	mmap_read_lock(current->mm);
>  	if (npages == -EHWPOISON ||
> -	      (!async && check_user_page_hwpoison(addr))) {
> +	      (!(foll->flags & FOLL_NOWAIT) && check_user_page_hwpoison(foll->hva))) {

Opportunistically align the indentation, as an added bonus that makes the line
length a few chars shorter, i.e.

	if (npages == -EHWPOISON ||
	    (!(foll->flags & FOLL_NOWAIT) && check_user_page_hwpoison(foll->hva))) {
		pfn = KVM_PFN_ERR_HWPOISON;
		goto exit;
	}
