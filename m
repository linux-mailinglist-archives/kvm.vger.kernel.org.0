Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92FF35A7038
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 23:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbiH3V5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 17:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiH3V5N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 17:57:13 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37B69E11C
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 14:52:57 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id bh13so11848303pgb.4
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 14:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=kmi765rhdWrzQirlOzDuA6v2AsLs7icy29dLcvjyZaY=;
        b=hWJ7zNlkecdEXTrVZ6wmkEknTN/2exZUrz57/hU7W4XRQNtZqa+j7DxnleUp3IhKBb
         sPjQfJCIpekxST95aTOvA6LRmjGl/9uM3t36fhzVjmgsHhFGbG/O8T0o1vgEyeLA5C0I
         EFGHin0OUfFk0fiXENOHWlBqiA7nVmwWjwoJSedO1iB8vWSr7VHZW2nPJIXqSCBO/+pl
         sOwVvJuTcV0RbXyJlpScwEsj8aMQTbBVhWXan+gXoZK5KecfX5JTb9nvfZqtbC+UjDPf
         k0jWJ+//LY8Te/xXhINDpZFf2p1eG1WkkfXxk1m7qr7C9e/izZw1Pye0n6Us513YUn22
         Sv0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=kmi765rhdWrzQirlOzDuA6v2AsLs7icy29dLcvjyZaY=;
        b=DVEWf9hQI6LkcZ77UI7cPF32MeetMfGTFH3czO99B1XfsEYgmMlTqah5Dq39Dp9NKb
         4tlRI+LGdVBSS0xSHG1sCYTqppmTSHkmM7Rxdqq1Yz9kmJ75CWfzBmnkry0m41yv/+tw
         kdz6YGDPfj7iDkKQeh11lwujJZtp++3FMEwr00aI1q58Mjjf0q/aN73n4HstBnVcTWAu
         4ToOhUs+6J16ZaLky7zrfcCovS72h3+CEPeYTiaTH6R4Wyx7a1BRl2n78tvWcA3IhI1Y
         LwmbnFNYiezBi1Ruj5tHdC6gJ4pMjERfNTUk7YFl0gKlNy4kBlbYuC08NDghxKe14lT/
         D9kg==
X-Gm-Message-State: ACgBeo31qLHSr3I2RtL0fXLI37jknKuoQDxbFzwIvMFUWDe71rezxwgl
        M830s8gzob8EcysbJCJVjuh8tg==
X-Google-Smtp-Source: AA6agR6asL5tWEMD9qdeUkMoP6zzYNAqZvPkbIyCF6qv1uEQUKWXuBujKh4awFSCPYR/F9Y2M19nxA==
X-Received: by 2002:aa7:8742:0:b0:537:ee75:601a with SMTP id g2-20020aa78742000000b00537ee75601amr17381844pfo.37.1661896357847;
        Tue, 30 Aug 2022 14:52:37 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k6-20020a170902ce0600b0015e8d4eb1dbsm10181118plg.37.2022.08.30.14.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 14:52:37 -0700 (PDT)
Date:   Tue, 30 Aug 2022 21:52:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>, Huang@google.com,
        Shaoqin <shaoqin.huang@intel.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v7 3/4] KVM: x86/mmu: count KVM mmu usage in secondary
 pagetable stats.
Message-ID: <Yw6GoWY411PrIRMx@google.com>
References: <20220823004639.2387269-1-yosryahmed@google.com>
 <20220823004639.2387269-4-yosryahmed@google.com>
 <Ywkq8HYyTI1eStSO@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ywkq8HYyTI1eStSO@google.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 26, 2022, Sean Christopherson wrote:
> On Tue, Aug 23, 2022, Yosry Ahmed wrote:
> > Count the pages used by KVM mmu on x86 in memory stats under secondary
> > pagetable stats (e.g. "SecPageTables" in /proc/meminfo) to give better
> > visibility into the memory consumption of KVM mmu in a similar way to
> > how normal user page tables are accounted.
> > 
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > Reviewed-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c     | 16 ++++++++++++++--
> >  arch/x86/kvm/mmu/tdp_mmu.c | 12 ++++++++++++
> >  2 files changed, 26 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index e418ef3ecfcb..4d38e4eba772 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1665,6 +1665,18 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
> >  	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
> >  }
> >  
> > +static void kvm_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> > +{
> > +	kvm_mod_used_mmu_pages(kvm, +1);
> > +	kvm_account_pgtable_pages((void *)sp->spt, +1);
> > +}
> > +
> > +static void kvm_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> > +{
> > +	kvm_mod_used_mmu_pages(kvm, -1);
> > +	kvm_account_pgtable_pages((void *)sp->spt, -1);
> > +}
> 
> Hrm, this is causing build on x86 issues for me.  AFAICT, modpost doesn't detect
> that this creates a new module dependency on __mod_lruvec_page_state() and so doesn't
> refresh vmlinux.symvers.
> 
>   ERROR: modpost: "__mod_lruvec_page_state" [arch/x86/kvm/kvm.ko] undefined!
>   make[2]: *** [scripts/Makefile.modpost:128: modules-only.symvers] Error 1
>   make[1]: *** [Makefile:1769: modules] Error 2
>   make[1]: *** Waiting for unfinished jobs....
>   Kernel: arch/x86/boot/bzImage is ready  (#128)
>   make[1]: Leaving directory '/usr/local/google/home/seanjc/build/kernel/vm'
>   make: *** [Makefile:222: __sub-make] Error 2
> 
> Both gcc and clang yield the same behavior, so I doubt it's the compiler doing
> something odd.  Cleaning the build makes the problem go away, but that's a poor
> band-aid.
> 
> If I squash this with the prior patch that adds kvm_account_pgtable_pages() to
> kvm_host.h, modpost detects the need to refresh and all is well.
> 
> Given that ARM doesn't support building KVM as a module, i.e. can't run afoul
> of whatever modpost weirdness I'm hitting, I'm inclined to squash this with the
> previous patch and punt on the modpost issue so that we can get this merged.
> 
> Any objections?  Or thoughts on what's going wrong?

Pushed the series with the squash to branch `for_paolo/6.1` at:

    https://github.com/sean-jc/linux.git

Unless you hear otherwise, it will make its way to kvm/queue "soon".

Please yell if there are objections.
