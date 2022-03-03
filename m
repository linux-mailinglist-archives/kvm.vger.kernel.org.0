Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225374CB46B
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 02:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiCCBmI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 20:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbiCCBmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 20:42:07 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB511B5120
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 17:41:23 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id s1so3151321plg.12
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 17:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ECPY2rXs0gj3ZMmKf1ZVTljD0jLnkN0k48s4x2qcO38=;
        b=PUNnxzMxpSFabi/9CdWyQIWtepUkWGHx6ZZ3CkeKQhscGAuM5uGHPfE++wPJvpyxmA
         iLtzRMTJlF0Yp5b8Tc6dpABJxKBLyU5qNxRJJCww8OtC9Dq+1P24VVmU7Jx6iyvDAa6U
         JJELAb8jqSKUOmuZfn3Px0gqTxGqHKGr/twCLzRb5SbEsgc+nE6Ze+RcKYM2Y/oHrkr6
         t8gFHqxjZTemPlhXm+xUEUPX035fKE8KJDr1po7YBU3hlRFJPD6XvqugIVGHEA6xjJ9G
         q0eO2Ej12fMySEyh9Cd3ipzTaziiKoFmZGJNqZf5+tN4doooPAHHZ0vyZhD8eRalgKJB
         q1vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ECPY2rXs0gj3ZMmKf1ZVTljD0jLnkN0k48s4x2qcO38=;
        b=vkd83fIBhL3SbE8B3V/QnJhuAWtYy5ZEUVf/tPBt1sgwdWBzcYzumhD0DExZBKSJQr
         n4aiqjLlFYs3m0NJrJHmMwfNkdd4MC+Hh4VQE8+WnbK4jymRoJCGFH2hEyknKbO3a2zs
         Y00SMLp5Lb16dUMF9FGlkJvzWpkkmQhN+aeib0DrHzsF/N/nSdfZ0WcsxaV12wGliolc
         aM0uDmnn7O3x2hNU8gNIEt8IlUZQivEjfrudDItV4kLSVXZKEZLGdCtEhX5KRoFv7a7x
         Yhm9h6fVVdq70pIln10JmDxmPRYG8V11QLoKSMfuskOENqUHgQ+mm75uIi2Qs/tFrn2X
         Rozw==
X-Gm-Message-State: AOAM531e7iSjxjT+2wPPECmjaY+7fNUoLeQ+5jtv7iw718geR2eYaCkB
        EeJ9a+4Ihbr1e3YlqGDnl2YPSw==
X-Google-Smtp-Source: ABdhPJxOLeM9XsiJ3USmANfCGbc7ENEa9TQMGB4uIoaABrEWH9g0mEsUPBYh0PDa+Sy1fo13QN9krA==
X-Received: by 2002:a17:90a:67c9:b0:1b9:51d5:6c13 with SMTP id g9-20020a17090a67c900b001b951d56c13mr2734061pjm.216.1646271682558;
        Wed, 02 Mar 2022 17:41:22 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ip3-20020a17090b314300b001b9cb7ab96fsm309872pjb.8.2022.03.02.17.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 17:41:21 -0800 (PST)
Date:   Thu, 3 Mar 2022 01:41:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 04/28] KVM: x86/mmu: Formalize TDP MMU's (unintended?)
 deferred TLB flush logic
Message-ID: <YiAcvswAIrMi+iXS@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-5-seanjc@google.com>
 <YiAE4ju0a3MWXr31@google.com>
 <YiAH6UfSDyHeMP+s@google.com>
 <YiAXy+I1GcyZ7iFJ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiAXy+I1GcyZ7iFJ@google.com>
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

On Thu, Mar 03, 2022, Mingwei Zhang wrote:
> On Thu, Mar 03, 2022, Sean Christopherson wrote:
> > On Wed, Mar 02, 2022, Mingwei Zhang wrote:
> > > On Sat, Feb 26, 2022, Sean Christopherson wrote:
> > > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > > index 12866113fb4f..e35bd88d92fd 100644
> > > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > > @@ -93,7 +93,15 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
> > > >  	list_del_rcu(&root->link);
> > > >  	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> > > >  
> > > > -	zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);
> > > > +	/*
> > > > +	 * A TLB flush is not necessary as KVM performs a local TLB flush when
> > > > +	 * allocating a new root (see kvm_mmu_load()), and when migrating vCPU
> > > > +	 * to a different pCPU.  Note, the local TLB flush on reuse also
> > > > +	 * invalidates any paging-structure-cache entries, i.e. TLB entries for
> > > > +	 * intermediate paging structures, that may be zapped, as such entries
> > > > +	 * are associated with the ASID on both VMX and SVM.
> > > > +	 */
> > > > +	(void)zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);
> > > 
> > > Understood that we could avoid the TLB flush here. Just curious why the
> > > "(void)" is needed here? Is it for compile time reason?
> > 
> > Nope, no functional purpose, though there might be some "advanced" warning or
> > static checkers that care.
> > 
> > The "(void)" is to communicate to human readers that the result is intentionally
> > ignored, e.g. to reduce the probability of someone "fixing" the code by acting on
> > the result of zap_gfn_range().  The comment should suffice, but it's nice to have
> > the code be self-documenting as much as possible.
> 
> Right, I got the point. Thanks.
> 
> Coming back. It seems that I pretended to understand that we should
> avoid the TLB flush without really knowing why.
> 
> I mean, leaving (part of the) stale TLB entries unflushed will still be
> dangerous right? Or am I missing something that guarantees to flush the
> local TLB before returning to the guest? For instance,
> kvm_mmu_{re,}load()?

Heh, if SVM's ASID management wasn't a mess[*], it'd be totally fine.  The idea,
and what EPT architectures mandates, is that each TDP root is associated with an
ASID.  So even though there may be stale entries in the TLB for a root, because
that root is no longer used those stale entries are unreachable.  And if KVM ever
happens to reallocate the same physical page for a root, that's ok because KVM must
be paranoid and flush that root (see code comment in this patch).

What we're missing on SVM is proper ASID handling.  If KVM uses ASIDs the way AMD
intends them to be used, then this works as intended because each root is again
associated with a specific ASID, and KVM just needs to flush when (re)allocating
a root and when reusing an ASID (which it already handles).

[*] https://lore.kernel.org/all/Yh%2FJdHphCLOm4evG@google.com
