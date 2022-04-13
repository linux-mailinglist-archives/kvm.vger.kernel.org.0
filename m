Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284034FFD40
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 19:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237431AbiDMSA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 14:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237538AbiDMSAx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 14:00:53 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7B76E345
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 10:57:58 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 125so2456588pgc.11
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 10:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lKms+iLPtRUk5y/Weofi/PdQuKMWfU/nQ1UEwvdazkA=;
        b=VI7NuhMtE5n6hcf5o1lr6t8ZOQB244gh3vPkDR8/4kX00bX5l/+t/BORMexz0C9Bes
         3/+VhI2JSDj1pSNs/rZcBt0kNZ98jay4OW7PQUswSDsPYsmnplbhDAHnhd9ccPcL6HA2
         bmQOUc2THBOrC9SUGbSR2lqw2odxZDJZBefY1TRssGH1I4LZ8vvR6ruCc7lvPL5RlvII
         LTAGGfs1JLlpoJv12ISZimfV9ZbLvQbvTrNZ4H1zfbHsUo8c/G1DqsWrHyTwkajk0J0G
         iIIowf/+Gcy5EtdtVbGaFH9naZWCoETckHHj0fmkmEmVfd0vxoBEUQ+/kc+iYioZP19n
         /ajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lKms+iLPtRUk5y/Weofi/PdQuKMWfU/nQ1UEwvdazkA=;
        b=wDAPSGlEh4Mpm+8GT1ntRTLgoBaISRzKpff86qpwic0k2ndpJqP4D+2XgbGXnA2FG0
         RaJBxTb1pGoRxD1iiTHJ/7nkWVYQupSGZhCO14u3QF895ElqtmXs09cpk3wCG8qO9TZ3
         fL8WVvjbLoxvna5wu+atGLhPembwahZvRR/sKN6/r4tZKnxdMnR87I1AIpGpwvOAwbOg
         GUd+CfwwXjZFRmB/5LZ+eeRO1Ty+Rqcj6ZCldn7uJci9pJ2dPkPjafLXUvYI970t8vPH
         grHubmeCKx4KlsLrkSN9uosStOW7xQEuBT0/OtRBckx9ZC35atX+iGzdTTdt4Zx+kjA4
         TOAQ==
X-Gm-Message-State: AOAM530Pa2ct6O2YVARm9Q/DGwRcnLSHqEu3xAAHV/JaM2k39zYOwwk5
        LLMaIF+TICCId13n1EKUF9Uwow==
X-Google-Smtp-Source: ABdhPJzRyu8tHffHYzAcQVAnebPL6Cv2V5j7/xAO3BnBL9wlRay5v7Pxg+Hg4uOSbzo7Xo6auY8Wfg==
X-Received: by 2002:a63:4862:0:b0:385:fb1d:fc54 with SMTP id x34-20020a634862000000b00385fb1dfc54mr36295792pgk.57.1649872677704;
        Wed, 13 Apr 2022 10:57:57 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id br10-20020a17090b0f0a00b001cd4fb89d38sm3170813pjb.9.2022.04.13.10.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 10:57:56 -0700 (PDT)
Date:   Wed, 13 Apr 2022 17:57:53 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v3 00/23] KVM: Extend Eager Page Splitting to the shadow
 MMU
Message-ID: <YlcPIYJ0CB2qnfpT@google.com>
References: <20220401175554.1931568-1-dmatlack@google.com>
 <YlRhiF1O71TWQr5r@google.com>
 <CALzav=f_WY7xH_MV8-gJPAVmj1KjE_LvXupL7aA5n-vCjTETNw@mail.gmail.com>
 <YlSLuZphElMyF2sG@google.com>
 <CALzav=fGucZOZjbVE2+9PZVf1p+jP7GBYDpPph5PoU552LELsw@mail.gmail.com>
 <YlTKQz8HVPtyfwKe@google.com>
 <CALzav=dz8rSK6bs8pJ9Vv02Z7aWO+yZ5jAA8+nmLAtJe3SMAsA@mail.gmail.com>
 <YlYhO7GvjKY1cwHr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlYhO7GvjKY1cwHr@google.com>
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

On Wed, Apr 13, 2022 at 01:02:51AM +0000, Sean Christopherson wrote:
> On Tue, Apr 12, 2022, David Matlack wrote:
> > On Mon, Apr 11, 2022 at 5:39 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Mon, Apr 11, 2022, David Matlack wrote:
> > > >
> > > > One thing that would be helpful is if you can explain in a bit more
> > > > specifically what you'd like to see. Part of the reason why I prefer
> > > > to sequence your proposal after eager page splitting is that I do not
> > > > fully understand what you're proposing, and how complex it would be.
> > > > e.g. Forking FNAME(fetch), FNAME(page_fault), and kvm_mmu_get_page()
> > > > for nested MMUs does not sound like less churn.
> > >
> > > Oh, it's most definitely not less code, and probably more churn.  But, it's churn
> > > that pushes us in a more favorable direction and that is desirable long term.  I
> > > don't mind churning code, but I want the churn to make future life easier, not
> > > harder.  Details below.
> > 
> > Of course. Let's make sure we're on the same page about what churn
> > introduced by this series will make future life harder that we hope to
> > avoid. If I understand you correctly, it's the following 2 changes:
> > 
> >  (a.) Using separate functions to allocate SPs and initialize SPs.
> >  (b.) Separating kvm_mmu_find_shadow_page() from __kvm_mmu_find_shadow_page().
> > 
> > (a.) stems from the fact that SP allocation during eager page
> > splitting is made directly rather than through kvm_mmu_memory_caches,
> > which was what you pushed for in the TDP MMU implementation. We could
> > instead use kvm_mmu_memory_caches for the shadow MMU eager page
> 
> ...
> 
> > So even if we did everything you proposed (which seems like an awful
> > lot just to avoid __kvm_mmu_find_shadow_page()), there's a chance we
> > would still end up with the exact same code. i.e.
> > kvm_mmu_nested_tdp_find_sp() would be implemented by calling
> > __kvm_mmu_find_shadow_page(), because it would be a waste to
> > re-implement an almost identical function?
> 
> I went far enough down this path to know that my idea isn't completely awful,
> and wouldn't actually need to fork FNAME(page_fault) at this time, but sadly I
> still dislike the end result.

Thanks for looking into it so quickly so we could figure out a path
forward.

> 
> Your assessment that the we'd still end up with very similar (if not quite exact)
> code is spot on.  Ditto for your other assertion in (a) about using the caches.
> 
> My vote for this series is to go the cache route, e.g. wrap kvm_mmu_memory_caches
> in a struct and pass that into kvm_mmu_get_page().  I still think it was the right
> call to ignore the caches for the TDP MMU, it gives the TDP MMU more flexibility
> and it was trivial to bypass the caches since the TDP MMU was doing its own thing
> anyways.
> 
> But for the shadow MMU, IMO the cons outweigh the pros.  E.g. in addition to
> ending up with two similar but subtly different "get page" flows, passing around
> "struct kvm_mmu_page **spp" is a bit unpleasant.  Ditto for having a partially
> initialized kvm_mmu_page.  The split code also ends up in a wierd state where it
> uses the caches for the pte_list, but not the other allocations.

Sounds good. I will rework the series to use kvm_mmu_memory_cache
structs for the SP allocation during eager page splitting. That will
eliminate the separate allocation and initialization which will be a
nice cleanup. And it will be great to get rid of the spp crud.

And per your earlier feedback, I will also limit eager page splitting to
nested MMUs.

> 
> There will be one wart due to unsync pages needing @vcpu, but we can pass in NULL
> for the split case and assert that @vcpu is non-null since all of the children
> should be direct.

The NULL vcpu check will be a little gross, but it should never trigger
in practice since eager page splitting always requests direct SPs. My
preference has been to enforce that in code by splitting out
__kvm_mmu_find_shadow_page(), but I can see the advantage of your
proposal is that eager page splitting and faults will go through the
exact same code path to get a kvm_mmu_page.

> 
> 		if (sp->unsync) {
> 			if (WARN_ON_ONCE(!vcpu)) {
> 				kvm_mmu_prepare_zap_page(kvm, sp,
> 							 &invalid_list);
> 				continue;
> 			}
> 
> 			/*
> 			 * The page is good, but is stale.  kvm_sync_page does
> 			 * get the latest guest state, but (unlike mmu_unsync_children)
> 			 * it doesn't write-protect the page or mark it synchronized!
> 			 * This way the validity of the mapping is ensured, but the
> 			 * overhead of write protection is not incurred until the
> 			 * guest invalidates the TLB mapping.  This allows multiple
> 			 * SPs for a single gfn to be unsync.
> 			 *
> 			 * If the sync fails, the page is zapped.  If so, break
> 			 * in order to rebuild it.
> 			 */
> 			if (!kvm_sync_page(vcpu, sp, &invalid_list))
> 				break;
> 
> 			WARN_ON(!list_empty(&invalid_list));
> 			kvm_flush_remote_tlbs(kvm);
> 		}
