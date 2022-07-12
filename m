Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F19857299D
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 01:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbiGLXDn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 19:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiGLXDk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 19:03:40 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB8DBC00
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 16:03:39 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id u68so2664740oie.0
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 16:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qHwuHViFSN86tj0ChYoibxcY4E2c7D4JyTppJFZI4so=;
        b=Lhh55GnSdOjPhbJGduTnxEGnWccw6kHOeEeY08jAZgJe0VqjmPoBdTPnONumi/pAun
         p+cHg4gHnhGSvibmw9wIMHwGbOMlbmWVVet0lyBNoQFKw49iIOLl44zlrlp+lgOkWr4N
         nI06n4Ji3hwluei1aEEzHQyZHr8WFbhVYRiJlwQVHmUD64NqpTZjoyhfvNHbS2GCc5aR
         uNpAcmjt7Eo2ZLV4iQ/jGK1hfJ4aVbxJui0znZqX9547wQXUukqWF8+PFEtZcDsj6osq
         cNrlBGb2ZoHRdeHJDRKTLI+onjdNABpheW4De5nAankciyk7viUqVbyzzoaaEs5liuGY
         qvhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qHwuHViFSN86tj0ChYoibxcY4E2c7D4JyTppJFZI4so=;
        b=fuIV6lbfjxFQA74Ghag9fGHMwH+iwDjOIRjpKwFzHI2RPvtr3NUKh7vDVZzMt3whZY
         f+wsLMOGfYx6vpOr/OZGW7gcQorHCEyPIR9wU0kAkALlaMM1Rysp4b+0CkrCbjMoxQfs
         9ipVBmp9dgLBdYpG0r0Nng1GWzO2KjA3eob0l9WD223/urnzGeTvCtuJWwIZgNtoAKz/
         KGAXGPXQoJ5V0MCibzE5RmCfmWcAuNytN7ENGr7Eiq++FenFu7B+0Ystl1JwTePdtIcK
         Hq3E4imE2Kvf1fGQhYWPo+LYM7QlgPFMpwPuK4B6cbC6us3f8eBG+M8jpSd9p+E1bMRF
         x5Vg==
X-Gm-Message-State: AJIora8FUbnKIm6UwfWA5LwVO0NWsHKTRl5QJq1Rmfjn7GUgYA0lgpzv
        iFyouPjKZLA2KKvtQvmh0k2o6DF/nDV1fJVBAAHuNQ==
X-Google-Smtp-Source: AGRyM1sv6/a3j0mcFzaoNZorrDTb4kx9QsLkQ7zFGrGqxGPqVxoEEPKoh5NgLCA2o5UhH33aMTJl+s4tUNJhAnFoewI=
X-Received: by 2002:aca:e043:0:b0:32e:1ad1:2d4 with SMTP id
 x64-20020acae043000000b0032e1ad102d4mr3357976oig.235.1657667018762; Tue, 12
 Jul 2022 16:03:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com> <YsdJPeVOqlj4cf2a@google.com>
In-Reply-To: <YsdJPeVOqlj4cf2a@google.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Tue, 12 Jul 2022 16:03:02 -0700
Message-ID: <CAJD7tkYE+pZdk=-psEP_Rq_1CmDjY7Go+s1LXm-ctryWvUdgLA@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To:     Sean Christopherson <seanjc@google.com>
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
        Shaoqin <shaoqin.huang@intel.com>,
        Cgroups <cgroups@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
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

Thanks for taking another look at this!

On Thu, Jul 7, 2022 at 1:59 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> > We keep track of several kernel memory stats (total kernel memory, page
> > tables, stack, vmalloc, etc) on multiple levels (global, per-node,
> > per-memcg, etc). These stats give insights to users to how much memory
> > is used by the kernel and for what purposes.
> >
> > Currently, memory used by kvm mmu is not accounted in any of those
>
> Nit, capitalize KVM (mainly to be consistent).
>
> > @@ -1085,6 +1086,9 @@ KernelStack
> >                Memory consumed by the kernel stacks of all tasks
> >  PageTables
> >                Memory consumed by userspace page tables
> > +SecPageTables
> > +              Memory consumed by secondary page tables, this currently
> > +           currently includes KVM mmu allocations on x86 and arm64.
>
> Nit, this line has a tab instead of eight spaces.  Not sure if it actually matters,
> there are plenty of tabs elsewhere in the file, but all the entries in this block
> use only spaces.
>

Will fix it.

> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index aab70355d64f3..13190d298c986 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -216,6 +216,7 @@ enum node_stat_item {
> >       NR_KERNEL_SCS_KB,       /* measured in KiB */
> >  #endif
> >       NR_PAGETABLE,           /* used for pagetables */
> > +     NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */
>
> Nit, s/kvm/KVM, and drop the "shadow", which might be misinterpreted as saying KVM
> pagetables are only accounted when KVM is using shadow paging.  KVM's usage of "shadow"
> is messy, so I totally understand why you included it, but in this case it's unnecessary
> and potentially confusing.
>
> And finally, something that's not a nit.  Should this be wrapped with CONFIG_KVM
> (using IS_ENABLED() because KVM can be built as a module)?  That could be removed
> if another non-KVM secondary MMU user comes along, but until then, #ifdeffery for
> stats the depend on a single feature seems to be the status quo for this code.
>

I will #ifdef the stat, but I will emphasize in the docs that is
currently *only* used for KVM so that it makes sense if users without
KVM don't see the stat at all. I will also remove the stat from
show_free_areas() in mm/page_alloc.c as it seems like none of the
#ifdefed stats show up there.

> >  #ifdef CONFIG_SWAP
> >       NR_SWAPCACHE,
> >  #endif
