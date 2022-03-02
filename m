Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373634CAC54
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 18:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244171AbiCBRob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 12:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244140AbiCBRoa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 12:44:30 -0500
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDE7CD5D4
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 09:43:46 -0800 (PST)
Received: by mail-vs1-xe29.google.com with SMTP id y4so2701335vsd.11
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 09:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/zlAls2ilGA7vb4iLAcEOEiXUP/bxHdwqPo5oKjWS3o=;
        b=Vi9wAeSCPzzn5ML9gdoCyqk5fLtdX2KwuO4dZk8miIPYlhrzueWyZx+dnAbnB7JxFu
         ot4b8mO4/eH4X+cv7rPMrKhC1KgkPWxGv2B5btCYyUs7zq7EFsugMpw2godPGaZm0Az5
         yHlbSEmL4Lw1rgXdasK0z4PH2oZXK0soNC1X5rR9tZ3Od28/+bNKHFN4qEh3OthyZofU
         CrzX3hp97L6o3/WjQSiOpUrdWne4z/ZJ/7HW2BBJHc1CW1bkOb9qvZ0u8xr+IpzAejkH
         0RJ9VnON/1W2v1Fg9vjxpj+8AwpeX3F5nvFnnqy3EOuiVldpaovErqFjFrIMJWgUet/3
         FyDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/zlAls2ilGA7vb4iLAcEOEiXUP/bxHdwqPo5oKjWS3o=;
        b=Iv9ldrdPqoeZd3wx+dEwiGtA/tycbV8oMQhpkGpBCY/GR1dmbqvsrWPOSYh6DmIgCY
         2KX3DYQLaj7jnNKly6aekqBUO5FEHMQT9f+gS7eyQd9nFbKLI59h/dN3eNFraouGAW2d
         XjreWnRsHkqrKuRtlvCyD6YtdK4SPVTFXbWlVze6/beorgYk4wW/+aHJv9RhcliLjrHT
         UyIbVIknGK4bPZlo7SOM+omP/zdIsM/CtMyDwxHoxcJ+GXEACUHCj90F8Tipl1CQ67hl
         +fElPkakExIB35W3KUhoVMwrTfn/A4iFpGktDwk1Mx8oga/HwwvKJt40l1vT3CXlwOZH
         CiBQ==
X-Gm-Message-State: AOAM532UrgkI6sA21UkjrIzvWCH0osbn2aF1O+lq+tqJBnrjOKCtkOky
        UknTbG/rh3xg63ceq/KN1jqwL6agn95uZg==
X-Google-Smtp-Source: ABdhPJwIgjkcy4oTiwohjWDGw0dbIOFf6HqKaSjr/SmswVp9rBsvLBiGCkwKLMCiwIvILKDlL3burQ==
X-Received: by 2002:a17:902:8a8a:b0:14d:bd69:e797 with SMTP id p10-20020a1709028a8a00b0014dbd69e797mr31420005plo.49.1646243014825;
        Wed, 02 Mar 2022 09:43:34 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s3-20020a056a00194300b004f6664d26eesm319562pfk.88.2022.03.02.09.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 09:43:34 -0800 (PST)
Date:   Wed, 2 Mar 2022 17:43:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v3 20/28] KVM: x86/mmu: Allow yielding when zapping GFNs
 for defunct TDP MMU root
Message-ID: <Yh+swiZDQ+KiSDCC@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-21-seanjc@google.com>
 <28276890-c90c-e9a9-3cab-15264617ef5a@redhat.com>
 <Yh53V23gSJ6jphnS@google.com>
 <f444790d-3bc7-9870-576e-29f30354a63b@redhat.com>
 <Yh7SwAR/H5dPrqLN@google.com>
 <2e856a9d-bef0-09ff-351a-113db9b36e2d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e856a9d-bef0-09ff-351a-113db9b36e2d@redhat.com>
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

On Wed, Mar 02, 2022, Paolo Bonzini wrote:
> On 3/2/22 03:13, Sean Christopherson wrote:
> > That would work, though I'd prefer to recurse on kvm_tdp_mmu_put_root() instead
> > of open coding refcount_dec_and_test() so that we get coverage of the xchg()
> > doing the right thing.
> > 
> > I still slightly prefer having the "free" path be inside the xchg().  To me, even
> > though the "free" path is the only one that's guaranteed to be reached for every root,
> > the fall-through to resetting the refcount and zapping the root is the "normal" path,
> > and the "free" path is the exception.
> 
> Hmm I can see how that makes especially sense once you add in the worker logic.
> But it seems to me that the "basic" logic should be "do both the xchg and the
> free", and coding the function with tail recursion obfuscates this.  Even with
> the worker, you grow an
> 
> +	if (kvm_get_kvm_safe(kvm)) {
> +		... let the worker do it ...
> +		return;
> +	}
> +
> 	tdp_mmu_zap_root(kvm, root, shared);
> 
> but you still have a downwards flow that matches what happens even if multiple
> threads pick up different parts of the job.
> 
> So, I tried a bunch of alternatives including with gotos and with if/else, but
> really the above one remains my favorite.

Works for me.

> My plan would be:
> 
> 1) splice the mini series I'm attaching before this patch, and
> remove patch 1 of this series.  next_invalidated_root() is a
> bit yucky, but notably it doesn't need to add/remove a reference
> in kvm_tdp_mmu_zap_invalidated_roots().
> 
> Together, these two steps ensure that readers never acquire a
> reference to either refcount=0/valid or invalid pages".  In other
> words, the three states of that kvm_tdp_mmu_put_root moves the root
> through (refcount=0/valid -> refcount=0/invalid -> refcount=1/invalid)
> are exactly the same to readers, and there are essentially no races
> to worry about.
> 
> In other other words, it's trading slightly uglier code for simpler
> invariants.

I'm glad you thought of the "immediately send to a worker" idea, I don't know if
I could stomach next_invalidated_root() continuing to live :-)

> @@ -879,7 +879,8 @@ bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
>  {
>  	struct kvm_mmu_page *root;
>  
> -	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, false)
> +	lockdep_assert_held_write(&kvm->mmu_lock);
> +	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
>  		flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, false);
>  
>  	return flush;
> @@ -895,8 +896,9 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>  	 * is being destroyed or the userspace VMM has exited.  In both cases,
>  	 * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
>  	 */
> +	lockdep_assert_held_write(&kvm->mmu_lock);
>  	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> -		for_each_tdp_mmu_root_yield_safe(kvm, root, i, false)
> +		for_each_tdp_mmu_root_yield_safe(kvm, root, i)
>  			tdp_mmu_zap_root(kvm, root, false);
>  	}
>  }
> -- 

If you hoist the patch "KVM: x86/mmu: Require mmu_lock be held for write in unyielding
root iter" to be the first in the series, then you can instead add the lockdep
assertion to the iterator itself.  Slotted in earlier in the series, it becomes...

From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 2 Mar 2022 09:25:30 -0800
Subject: [PATCH] KVM: x86/mmu: do not allow readers to acquire references to
 invalid roots

Remove the "shared" argument of for_each_tdp_mmu_root_yield_safe, thus
ensuring that readers do not ever acquire a reference to an invalid root.
After this patch, all readers except kvm_tdp_mmu_zap_invalidated_roots()
treat refcount=0/valid, refcount=0/invalid and refcount=1/invalid in
exactly the same way.  kvm_tdp_mmu_zap_invalidated_roots() is different
but it also does not acquire a reference to the invalid root, and it
cannot see refcount=0/invalid because it is guaranteed to run after
kvm_tdp_mmu_invalidate_all_roots().

Opportunistically add a lockdep assertion to the yield-safe iterator.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0cb834aa5406..46752093b79c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -158,14 +158,15 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 	for (_root = tdp_mmu_next_root(_kvm, NULL, _shared, _only_valid);	\
 	     _root;								\
 	     _root = tdp_mmu_next_root(_kvm, _root, _shared, _only_valid))	\
-		if (kvm_mmu_page_as_id(_root) != _as_id) {			\
+		if (kvm_lockdep_assert_mmu_lock_held(_kvm, _shared) &&		\
+		    kvm_mmu_page_as_id(_root) != _as_id) {			\
 		} else

 #define for_each_valid_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)	\
 	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, true)

-#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)		\
-	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, false)
+#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id)			\
+	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, false, false)

 /*
  * Iterate over all TDP MMU roots.  Requires that mmu_lock be held for write,
@@ -800,7 +801,7 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
 {
 	struct kvm_mmu_page *root;

-	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, false)
+	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
 		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush,
 				      false);


base-commit: 57352b7efee6b38eb9eb899b8f013652afe4e110
--

