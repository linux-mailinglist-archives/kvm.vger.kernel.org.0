Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F4B5266CD
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 18:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235161AbiEMQMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 12:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbiEMQMr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 12:12:47 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A13369F3
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 09:12:45 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id h186so5284917pgc.3
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 09:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z141h5DooZE4FL3AcX+0cKxHlZQWL6e7O/2bq4FL5UY=;
        b=pMpyJUjUuK/7b/oFgsoqZPGJMcOKB+7c5car+thP1abZdX0Ernmov9vuFLaqKMGXn2
         rG8JUhF6WgH7lMygF4hmuRIwFoCrADaFG0pDWTQKNWoL6WLM69N4kM4KtTQkkoALHWrD
         mAeJQipbT6/IL+OPcmvLrWT3xFgMFLNWJ+O6dFPVj4sg1KmNHaULMm56Trm/hh8TOipy
         uhaRQ/7aUedXdd9J0nEfOtBBAWb0ZPzn5j4jRptmc960+ldd4gTqKw70bR33LbaLOe4i
         OR/28/FZmY9vcAYQkNkQbiAC8Sl0bxsa6t+sHaEyvc1goNVOfOnpsfXq5AH2VoYmLRhW
         N/PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z141h5DooZE4FL3AcX+0cKxHlZQWL6e7O/2bq4FL5UY=;
        b=5tx0sW34frmTBGUeCDXvWLrPIz54mozintu5r3s2WxqP9ZDsHacEA8xp5bsFWsYz+F
         Bl3bm7mR2C6nySttVUtZVnQu8BmWlWEo87vRFYx9SpfDchlWkgYyAVixKhYOktOej6ER
         I7kn0Jmoj3fRY7aleIpj+OFnTAwlPqHGhmm2bVjRkEFha5QZjE1Q6fTfaNi0zW/rx0ag
         8FO5FEYENtJ+OnA3mh07qDdiIRVAS+k10XT3Hgalcu44mJWU+HwFlG/kihJn/844XLGf
         /5t1HVtE8ZjkHQQjPQwLwxKG+bpKC+Lb48uepgUy2wsZ6OfIQ7o0sTGwfYrHGT227lAN
         9kBw==
X-Gm-Message-State: AOAM531pDjjYV9qgvamFU/GJRV0t6GaSUQeckrhfOEwIK87Ut2A1s4lA
        dRdI8c5Qa7xEEp9kCCPUqTisRw==
X-Google-Smtp-Source: ABdhPJxZZEiYRsI2RBdRgtXYc4csRnATqQp8IQ+ui/ozYpm8C71ZnCC99jhfyvA9CYU552pckX/xxw==
X-Received: by 2002:a63:190d:0:b0:3db:11ba:cdb3 with SMTP id z13-20020a63190d000000b003db11bacdb3mr4564735pgl.81.1652458365185;
        Fri, 13 May 2022 09:12:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c9-20020aa78e09000000b0050dc76281ebsm1952250pfr.197.2022.05.13.09.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 09:12:44 -0700 (PDT)
Date:   Fri, 13 May 2022 16:12:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Yosry Ahmed <yosryahmed@google.com>, Marc Zyngier <maz@kernel.org>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
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
        Oliver Upton <oupton@google.com>, cgroups@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Message-ID: <Yn6DeEGLyR4Q0cDp@google.com>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com>
 <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org>
 <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yn5+OtZSSUZZgTQj@cmpxchg.org>
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

On Fri, May 13, 2022, Johannes Weiner wrote:
> On Thu, May 12, 2022 at 11:29:38PM +0000, Sean Christopherson wrote:
> > On Thu, May 12, 2022, Johannes Weiner wrote:
> > > On Mon, May 02, 2022 at 11:46:26AM -0700, Yosry Ahmed wrote:
> > > > On Mon, May 2, 2022 at 3:01 AM Marc Zyngier <maz@kernel.org> wrote:
> > > > > What do you plan to do for IOMMU page tables? After all, they serve
> > > > > the exact same purpose, and I'd expect these to be handled the same
> > > > > way (i.e. why is this KVM specific?).
> > > > 
> > > > The reason this was named NR_SECONDARY_PAGTABLE instead of
> > > > NR_KVM_PAGETABLE is exactly that. To leave room to incrementally
> > > > account other types of secondary page tables to this stat. It is just
> > > > that we are currently interested in the KVM MMU usage.
> > > 
> > > Do you actually care at the supervisor level that this memory is used
> > > for guest page tables?
> > 
> > Hmm, yes?  KVM does have a decent number of large-ish allocations that aren't
> > for page tables, but except for page tables, the number/size of those allocations
> > scales linearly with either the number of vCPUs or the amount of memory assigned
> > to the VM (with no room for improvement barring KVM changes).
> > 
> > Off the top of my head, KVM's secondary page tables are the only allocations that
> > don't scale linearly, especially when nested virtualization is in use.
> 
> Thanks, that's useful information.
> 
> Are these other allocations accounted somewhere? If not, are they
> potential containment holes that will need fixing eventually?

All allocations that are tied to specific VM/vCPU are tagged GFP_KERNEL_ACCOUNT,
so we should be good on that front.
 
> > > It seems to me you primarily care that it is reported *somewhere*
> > > (hence the piggybacking off of NR_PAGETABLE at first). And whether
> > > it's page tables or iommu tables or whatever else allocated for the
> > > purpose of virtualization, it doesn't make much of a difference to the
> > > host/cgroup that is tracking it, right?
> > > 
> > > (The proximity to nr_pagetable could also be confusing. A high page
> > > table count can be a hint to userspace to enable THP. It seems
> > > actionable in a different way than a high number of kvm page tables or
> > > iommu page tables.)
> > 
> > I don't know about iommu page tables, but on the KVM side a high count can also
> > be a good signal that enabling THP would be beneficial.
> 
> Well, maybe.
> 
> It might help, but ultimately it's the process that's in control in
> all cases: it's unmovable kernel memory allocated to manage virtual
> address space inside the task.
> 
> So I'm still a bit at a loss whether these things should all be lumped
> in together or kept separately. meminfo and memory.stat are permanent
> ABI, so we should try to establish in advance whether the new itme is
> really a first-class consumer or part of something bigger.
> 
> The patch initially piggybacked on NR_PAGETABLE. I found an email of
> you asking why it couldn't be a separate item, but it didn't provide a
> reasoning for that decision. Could you share your thoughts on that?

It was mostly an honest question, I too am trying to understand what userspace
wants to do with this information.  I was/am also trying to understand the benefits
of doing the tracking through page_state and not a dedicated KVM stat.  E.g. KVM
already has specific stats for the number of leaf pages mapped into a VM, why not
do the same for non-leaf pages?
