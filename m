Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFC04CB5F2
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 05:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiCCEv1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 23:51:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiCCEv0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 23:51:26 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B8F11C7D0
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 20:50:40 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id e6so3529830pgn.2
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 20:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gze3j/1d/iOM5LmLeKWf8llBUc0y0bOeU/xT4taGqMg=;
        b=ZxCbPUL09Pt+l9ErS+6ngwAma8BpiET5p+DE0e1O4Xg3Y7dRLDoPMzn1gbjynvbZTA
         BiAK2ftZoebIbw0nNt1ud5EtdnMDO9fV8U7FHpfsWdTlPm4EvvuApPJR8vxMiPvlhRIm
         UqQ8TlSR1UHyZKX/z9k0rG/NKg7lW0ajDUP0VVWpRCfm88tV+TVcQnwA5B0ppU+UD95C
         9BGFhSA8VwtZ/0X2/B+Ct4upbbBwcu05fHLmQCnInnk4kD6SVQ5CBwCGiHW3o+3U1dIM
         6EhPwRGyEN22a1JKYqJAHhdGM4CZ3IDQwC1EXD/XGMPk9xzPpWGcW6zThLy6jfqfbYBK
         esbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gze3j/1d/iOM5LmLeKWf8llBUc0y0bOeU/xT4taGqMg=;
        b=oW+Q8qo6o1cLGPCmOsigJ7J3lSRPAbA7f6t3ug3gF53btZ97E47BsIE3Tx9rC9kzFc
         5wZF+E3x1qxQ+cj6qaM0QloujUfWmGm7Us7+iPG2Kpi4UUShq4vkJoYWoKwX3qdmMBSR
         YMl9m7g6EsKiCbxHCY/iPjkyeA63r3QH6aYJktV0UIyXlSvtw8OX3JWIxnnj5lY4OGGa
         3WFiXTgfnrnKcL51eiV1DeyC9Nj06YjdHWag4EMQ5QRB4ZSvnWSFbjgyWhv36ntyMmad
         eixVsk34USrjyOu2XZVJWKjFnkbGS2PqQux4L8OoMMaekqPzWH6F/MK3yBNHzhNgEc5R
         mfKA==
X-Gm-Message-State: AOAM533hBGpoyTLKifO2Ki84AhsZQI3d4gqxi6s/xacCok/2/OhnOrmu
        y88c35JJuuFR51pSnJ4aQscH+w==
X-Google-Smtp-Source: ABdhPJwWodNuB4r9bSMlgvX/oD3qX+/xQpSRDHfLXivnw/0qFhxbmQR32lNLjrsMGKanWnHE4EnV3g==
X-Received: by 2002:a05:6a00:1503:b0:4e1:d277:cca with SMTP id q3-20020a056a00150300b004e1d2770ccamr36394116pfu.4.1646283039264;
        Wed, 02 Mar 2022 20:50:39 -0800 (PST)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id ng11-20020a17090b1a8b00b001beefe9a1cbsm694005pjb.31.2022.03.02.20.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 20:50:38 -0800 (PST)
Date:   Thu, 3 Mar 2022 04:50:34 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
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
Message-ID: <YiBJGmFCdSZwkiTw@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-5-seanjc@google.com>
 <YiAE4ju0a3MWXr31@google.com>
 <YiAH6UfSDyHeMP+s@google.com>
 <YiAXy+I1GcyZ7iFJ@google.com>
 <YiAcvswAIrMi+iXS@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiAcvswAIrMi+iXS@google.com>
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

On Thu, Mar 03, 2022, Sean Christopherson wrote:
> On Thu, Mar 03, 2022, Mingwei Zhang wrote:
> > On Thu, Mar 03, 2022, Sean Christopherson wrote:
> > > On Wed, Mar 02, 2022, Mingwei Zhang wrote:
> > > > On Sat, Feb 26, 2022, Sean Christopherson wrote:
> > > > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > > > index 12866113fb4f..e35bd88d92fd 100644
> > > > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > > > @@ -93,7 +93,15 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
> > > > >  	list_del_rcu(&root->link);
> > > > >  	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> > > > >  
> > > > > -	zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);
> > > > > +	/*
> > > > > +	 * A TLB flush is not necessary as KVM performs a local TLB flush when
> > > > > +	 * allocating a new root (see kvm_mmu_load()), and when migrating vCPU
> > > > > +	 * to a different pCPU.  Note, the local TLB flush on reuse also
> > > > > +	 * invalidates any paging-structure-cache entries, i.e. TLB entries for
> > > > > +	 * intermediate paging structures, that may be zapped, as such entries
> > > > > +	 * are associated with the ASID on both VMX and SVM.
> > > > > +	 */
> > > > > +	(void)zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);
> > > > 
> > > > Understood that we could avoid the TLB flush here. Just curious why the
> > > > "(void)" is needed here? Is it for compile time reason?
> > > 
> > > Nope, no functional purpose, though there might be some "advanced" warning or
> > > static checkers that care.
> > > 
> > > The "(void)" is to communicate to human readers that the result is intentionally
> > > ignored, e.g. to reduce the probability of someone "fixing" the code by acting on
> > > the result of zap_gfn_range().  The comment should suffice, but it's nice to have
> > > the code be self-documenting as much as possible.
> > 
> > Right, I got the point. Thanks.
> > 
> > Coming back. It seems that I pretended to understand that we should
> > avoid the TLB flush without really knowing why.
> > 
> > I mean, leaving (part of the) stale TLB entries unflushed will still be
> > dangerous right? Or am I missing something that guarantees to flush the
> > local TLB before returning to the guest? For instance,
> > kvm_mmu_{re,}load()?
> 
> Heh, if SVM's ASID management wasn't a mess[*], it'd be totally fine.  The idea,
> and what EPT architectures mandates, is that each TDP root is associated with an
> ASID.  So even though there may be stale entries in the TLB for a root, because
> that root is no longer used those stale entries are unreachable.  And if KVM ever
> happens to reallocate the same physical page for a root, that's ok because KVM must
> be paranoid and flush that root (see code comment in this patch).
> 
> What we're missing on SVM is proper ASID handling.  If KVM uses ASIDs the way AMD
> intends them to be used, then this works as intended because each root is again
> associated with a specific ASID, and KVM just needs to flush when (re)allocating
> a root and when reusing an ASID (which it already handles).
> 
> [*] https://lore.kernel.org/all/Yh%2FJdHphCLOm4evG@google.com

Oh, putting AMD issues aside for now.

I think I might be too narrow down to the zapping logic previously. So,
I originally think anytime we want to zap, we have to do the following
things in strict order:

1) zap SPTEs.
2) flush TLBs.
3) flush cache (AMD SEV only).
4) deallocate shadow pages.

However, if you have already invalidated EPTP (pgd ptr), then step 2)
becomes optional, since those stale TLBs are no longer useable by the
guest due to the change of ASID.

Am I understanding the point correctly? So, for all invalidated roots,
the assumption is that we have already called "kvm_reload_rmote_mmus()",
which basically update the ASID.
