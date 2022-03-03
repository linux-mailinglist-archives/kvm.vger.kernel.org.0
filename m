Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D306E4CB43E
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 02:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbiCCBVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 20:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbiCCBVB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 20:21:01 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A244C171EC7
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 17:20:16 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id n15so3139852plf.4
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 17:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4didxbKLG4XNzaJma8jM83OVANoq5pM7et3roh/HmzA=;
        b=POH7wfqmxq4XM8n/F5fE+DJHjjova7ou0x/O/BKD7X5ZMnqXOQgrCE1UeSQVSI+DW0
         mmq52jQU1X4J2fYWa+28ajwuW8ixox70uuYZu+tj7EnDjJ2gfnJUNfxWMTDoPVF2iRB7
         NIvbITGGAvZ0k4K1+WxUyfcveefjCc+ikAHknDbHeXf+oX/MOsJCs8qVkRDB9YdeJO44
         flTCQ+XFkt6G+B6bzaFVmmh58aZ6E2aqm1hEJ4V25kI7yQD6s6bRlGCN00bD4gcoShbu
         ea8TPH2KA/nDNIKlag9FTDhkugww/5ImSRRGmcH6gn6nnMyl5aChTlu1+kQqPKgZ1k4s
         FQNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4didxbKLG4XNzaJma8jM83OVANoq5pM7et3roh/HmzA=;
        b=WokS3KO1Y5jX9Ao2rsiG2a0YX9YOVcUhZgVsgQlPxGIZ592PeQux7qebWT7ysNHwG5
         W5jsGmNd6hcioxszLYuZxOb4xg1xQYLNEozJpIp4oVUQB+0ts1IXBRAYqXSGoji4S6hD
         kQB8wKFSuI7mXuoNqgRDNYcJLJHFQiLdz8kCtCVbSOg/DGazia+edDMEW5tcA4GYPZIT
         wSV4pDmPJt67MkOnfhZgUtp5YLJB2tWHUWCK9YrDaOgn/rTvYqacFv6JG2eKRZoKPX6E
         Uzc+9JAGIBH4HnSj+2PG4V5HKvCiTd0w9qxPumufJnsKcVj0iB3L/0+bIXTne5IuW3Ti
         0slA==
X-Gm-Message-State: AOAM530bSjQBCg2wmlUcGn1sHabwiDaIx5sTE83KsRIjDTzkWn3uRHeG
        1aNxPep66nId0E3kEPTJ4ZyxSA==
X-Google-Smtp-Source: ABdhPJyCwbbW+HsCI9aT0uO8bKkvf3II+lMiTQiv0dCpmNdi28CvDB4mBoO9s1sGkcYArnHXr3XHKQ==
X-Received: by 2002:a17:902:d48a:b0:151:3b2e:5c95 with SMTP id c10-20020a170902d48a00b001513b2e5c95mr26740568plg.140.1646270415715;
        Wed, 02 Mar 2022 17:20:15 -0800 (PST)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id j6-20020a056a00174600b004f3e5d344b9sm400148pfc.194.2022.03.02.17.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 17:20:14 -0800 (PST)
Date:   Thu, 3 Mar 2022 01:20:11 +0000
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
Message-ID: <YiAXy+I1GcyZ7iFJ@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-5-seanjc@google.com>
 <YiAE4ju0a3MWXr31@google.com>
 <YiAH6UfSDyHeMP+s@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiAH6UfSDyHeMP+s@google.com>
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
> On Wed, Mar 02, 2022, Mingwei Zhang wrote:
> > On Sat, Feb 26, 2022, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > index 12866113fb4f..e35bd88d92fd 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > @@ -93,7 +93,15 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
> > >  	list_del_rcu(&root->link);
> > >  	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> > >  
> > > -	zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);
> > > +	/*
> > > +	 * A TLB flush is not necessary as KVM performs a local TLB flush when
> > > +	 * allocating a new root (see kvm_mmu_load()), and when migrating vCPU
> > > +	 * to a different pCPU.  Note, the local TLB flush on reuse also
> > > +	 * invalidates any paging-structure-cache entries, i.e. TLB entries for
> > > +	 * intermediate paging structures, that may be zapped, as such entries
> > > +	 * are associated with the ASID on both VMX and SVM.
> > > +	 */
> > > +	(void)zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);
> > 
> > Understood that we could avoid the TLB flush here. Just curious why the
> > "(void)" is needed here? Is it for compile time reason?
> 
> Nope, no functional purpose, though there might be some "advanced" warning or
> static checkers that care.
> 
> The "(void)" is to communicate to human readers that the result is intentionally
> ignored, e.g. to reduce the probability of someone "fixing" the code by acting on
> the result of zap_gfn_range().  The comment should suffice, but it's nice to have
> the code be self-documenting as much as possible.

Right, I got the point. Thanks.

Coming back. It seems that I pretended to understand that we should
avoid the TLB flush without really knowing why.

I mean, leaving (part of the) stale TLB entries unflushed will still be
dangerous right? Or am I missing something that guarantees to flush the
local TLB before returning to the guest? For instance,
kvm_mmu_{re,}load()?

