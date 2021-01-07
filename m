Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688262ED5D5
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 18:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbhAGRll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 12:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbhAGRll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 12:41:41 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07C4C0612F8
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 09:41:00 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id c13so1607246pfi.12
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 09:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ILMPwCwZrBJ1HMfYPpc9UDsKQwFZc17yoGrjxBe8NiI=;
        b=K9lAta31bHz+XI4lQJtLUqRu5RcufMnNjXJo+/bdjD0p9WrHHbUYeZQGmSZ1fAZz8B
         nvWIKhZnKvYhNujvKH6UslFurON7uXp5dU1M+l/QmGFyYlOMpjTpGytFXN9P2fKMgRel
         uyyjS7Y5Km6xgNzEZqqtIREQyVXfHGbVBOhODyO+Ym9Xq2hHXNci9WYpUShSWI1LyW0D
         u0AcR1XmNrj+xNIyE2rMUf8/SJ+L+LhHGCIRxqHpI++IQ3f0WjeIK/dQK1YkXfWIBT0q
         /gAU/0jlm+S+wsX0KeTdTxAWlRSOhVK/4n+2zvx2Ja62VUURI69aPsMrTTNB28VgV4aD
         luQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ILMPwCwZrBJ1HMfYPpc9UDsKQwFZc17yoGrjxBe8NiI=;
        b=X/J+uBWdlIwsKRREXEisViLokIsW3ggJ5zoRvfkRKWAa525O+qBXeALzUgbIOGdUQS
         fVTSlDzoh6y4zTup+S7MIN65U6w7m024dnQfVLKHjWHQppDPeLtSZYUkPEHwsEZ+dngz
         z7yQSrdPg0WHKifkmC7UGFsPMYq36ws65IY3n/qx9Eh9yy+Q3LBtob2c1HYlM6//GMg0
         Qg2eKg6kwlC8T60nDdODk9iGT+w4J+0GS/I8aaWv6KpNOTD7gi93Q4069eJRsOVrDR1M
         iGrgO8lLXwEV5tX/sIma2xAFZDiS8W4DOtbRDVjLnKXBFlTs/F15XQmBnP8CD+wIk+a+
         /YXA==
X-Gm-Message-State: AOAM530U7HVGu0j1kYp1EGRhXvAKxV3xN3eRnsaZKwuHekiOBTr3zowD
        +GZVpQe/VVJ5DX9QdctqS5p5MA==
X-Google-Smtp-Source: ABdhPJzeg8rKSRJuruFkRQ8suzf3GzFrW7d4yz50DhxnuoFnh3A9BYIV8IfaypxEpes87r4wapgiYw==
X-Received: by 2002:a65:5209:: with SMTP id o9mr2934295pgp.34.1610041260269;
        Thu, 07 Jan 2021 09:41:00 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id a12sm7145470pgq.5.2021.01.07.09.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 09:40:59 -0800 (PST)
Date:   Thu, 7 Jan 2021 09:40:53 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Leo Hou <leohou1402@gmail.com>
Subject: Re: [PATCH v3 1/2] KVM: x86/mmu: Ensure TDP MMU roots are freed
 after yield
Message-ID: <X/dHpSoi5AkPIrfc@google.com>
References: <20210107001935.3732070-1-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107001935.3732070-1-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the future, please document the changes in each revision, e.g. in a cover
letter or in the ignored part of the diff.

On Wed, Jan 06, 2021, Ben Gardon wrote:
> Many TDP MMU functions which need to perform some action on all TDP MMU
> roots hold a reference on that root so that they can safely drop the MMU
> lock in order to yield to other threads. However, when releasing the
> reference on the root, there is a bug: the root will not be freed even
> if its reference count (root_count) is reduced to 0.
> 
> To simplify acquiring and releasing references on TDP MMU root pages, and
> to ensure that these roots are properly freed, move the get/put operations
> into another TDP MMU root iterator macro.
> 
> Moving the get/put operations into an iterator macro also helps
> simplify control flow when a root does need to be freed. Note that using
> the list_for_each_entry_safe macro would not have been appropriate in
> this situation because it could keep a pointer to the next root across
> an MMU lock release + reacquire, during which time that root could be
> freed.
> 
> Reported-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Fixes: faaf05b00aec ("kvm: x86/mmu: Support zapping SPTEs in the TDP MMU")
> Fixes: 063afacd8730 ("kvm: x86/mmu: Support invalidate range MMU notifier for TDP MMU")
> Fixes: a6a0b05da9f3 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
> Fixes: 14881998566d ("kvm: x86/mmu: Support disabling dirty logging for the tdp MMU")
> Signed-off-by: Ben Gardon <bgardon@google.com>

Reviewed-by: Sean Christopherson <seanjc@google.com> 

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 104 +++++++++++++++++--------------------
>  1 file changed, 48 insertions(+), 56 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 75db27fda8f3..d4191ed193cd 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -44,7 +44,48 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>  	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
>  }
>  
> -#define for_each_tdp_mmu_root(_kvm, _root)			    \
> +static void tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
> +{
> +	if (kvm_mmu_put_root(kvm, root))
> +		kvm_tdp_mmu_free_root(kvm, root);
> +}
> +
> +static inline bool tdp_mmu_next_root_valid(struct kvm *kvm,
> +					   struct kvm_mmu_page *root)
> +{
> +	lockdep_assert_held(&kvm->mmu_lock);
> +
> +	if (list_entry_is_head(root, &kvm->arch.tdp_mmu_roots, link))
> +		return false;
> +
> +	kvm_mmu_get_root(kvm, root);
> +	return true;
> +
> +}
> +
> +static inline struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
> +						     struct kvm_mmu_page *root)
> +{
> +	struct kvm_mmu_page *next_root;
> +
> +	next_root = list_next_entry(root, link);
> +	tdp_mmu_put_root(kvm, root);
> +	return next_root;
> +}
> +
> +/*
> + * Note: this iterator gets and puts references to the roots it iterates over.

Maybe refer to it as "the yield_safe() variant" instead of "this" so that the
comment makes sense with minimal context?

> + * This makes it safe to release the MMU lock and yield within the loop, but
> + * if exiting the loop early, the caller must drop the reference to the most
> + * recent root. (Unless keeping a live reference is desirable.)
> + */

Rather than encourage manually dropping the reference, what adding about a scary
warning about not exiting the loop early?  At this point, it seems unlikely that
we'll end up with a legitimate use case for exiting yield_safe() early.  And if
we do, I think it'd be better to provide a macro to do the bookeeping instead of
open coding it in the caller.  And maybe throw a blurb into the changelog about
that so future developers understand that that scary warning isn't set in stone?

/*
 * The yield_safe() variant of the TDP root iterator gets and puts references to
 * the roots it iterates over.  This makes it safe to release the MMU lock and
 * yield within the loop, but the caller MUST NOT exit the loop early.
 */
