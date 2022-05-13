Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A963D526680
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 17:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382216AbiEMPuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 11:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382193AbiEMPuX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 11:50:23 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462B41649BE
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 08:50:20 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id p3so6945862qvi.7
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 08:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kye4TfWEBKeNkvsN1Z8PpM0cIuVevPyfJP2pQ+b2OJ0=;
        b=ZZ/JJCRDz3yE4ILSty048bcbPErmsDUK3HlgCxPZevGvO0s7lKzzyxYdFDw1dJf9ph
         MIp+dwz/aXhjTfmLJaPj/lFR5KENnPsRIaVfRdKCuXnMx6qMaG0uPs9glvL+IiheyQV+
         I8N0k1bffzWgc5Xm+tBeTXdy8CbQJfgCaMsHgTm1sfLVt/+VGnsbnrEpzH2RKA967Lgp
         i0c6ZYtdpmtmfZZuTg2GnWU+ABJlGS07aIDJN1CLeOQkEF/JyGUWyE+RbOazEYEr/CaR
         3SpCLEHRQ4pi9gjxDfMWcHE6xNgzt5GERI+gy2A1oDXWEszhLZUV5HDLMnSPDj/P5+Pq
         xL0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Kye4TfWEBKeNkvsN1Z8PpM0cIuVevPyfJP2pQ+b2OJ0=;
        b=bsm+9SOxnWDSG4bVm888GeV1MNUbtYpGzXrLfc56HP1SqKMgW72LO/ENE8WkuJVdBl
         xGlL68tX9UC0kBGiL+truwn9LVKchHclZDOZwo6l6Ora5kWzLOXmH5v2lDrWsrgA/4VW
         xUSE9K95AeWyx3ZUEs26n6GqdqBzVN6nuyB99ZNZiKH/+kMNZ4lSYYDljI7BjuBcw4+F
         LyBxWmTUwkV3R+ntp7e/rXXTEyYsqSeVWlANU8pFEc5oS4QOH3T6WaZPfM3meBp7i2lu
         +wZ2ihmK2LC7iOxArBbBKzzPum8hT1sXQVzWnEdvNePHh4f8Ux7PNGYj1Viewz/ClZJP
         UIQQ==
X-Gm-Message-State: AOAM530bFV7HZB6aCvTHB0wRKLH/OAZ672nyOXGdj3MMa2kaTGa/G35D
        Tn60+OGMqcvvEeiFAt+VANvl4Q==
X-Google-Smtp-Source: ABdhPJyktZGo/sFqunY+AGQMbzOIwUczaPGJ0N+6rs6ilDbZkXUx75C2yJo+GV2MPE1GxzwaNcDQ8A==
X-Received: by 2002:a05:6214:401a:b0:459:5a57:ba6f with SMTP id kd26-20020a056214401a00b004595a57ba6fmr4923590qvb.96.1652457019420;
        Fri, 13 May 2022 08:50:19 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:14fe])
        by smtp.gmail.com with ESMTPSA id f6-20020a05622a114600b002f39b99f69esm1622685qty.56.2022.05.13.08.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 08:50:18 -0700 (PDT)
Date:   Fri, 13 May 2022 11:50:18 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Sean Christopherson <seanjc@google.com>
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
Message-ID: <Yn5+OtZSSUZZgTQj@cmpxchg.org>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com>
 <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org>
 <Yn2YYl98Vhh/UL0w@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yn2YYl98Vhh/UL0w@google.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022 at 11:29:38PM +0000, Sean Christopherson wrote:
> On Thu, May 12, 2022, Johannes Weiner wrote:
> > On Mon, May 02, 2022 at 11:46:26AM -0700, Yosry Ahmed wrote:
> > > On Mon, May 2, 2022 at 3:01 AM Marc Zyngier <maz@kernel.org> wrote:
> > > > What do you plan to do for IOMMU page tables? After all, they serve
> > > > the exact same purpose, and I'd expect these to be handled the same
> > > > way (i.e. why is this KVM specific?).
> > > 
> > > The reason this was named NR_SECONDARY_PAGTABLE instead of
> > > NR_KVM_PAGETABLE is exactly that. To leave room to incrementally
> > > account other types of secondary page tables to this stat. It is just
> > > that we are currently interested in the KVM MMU usage.
> > 
> > Do you actually care at the supervisor level that this memory is used
> > for guest page tables?
> 
> Hmm, yes?  KVM does have a decent number of large-ish allocations that aren't
> for page tables, but except for page tables, the number/size of those allocations
> scales linearly with either the number of vCPUs or the amount of memory assigned
> to the VM (with no room for improvement barring KVM changes).
> 
> Off the top of my head, KVM's secondary page tables are the only allocations that
> don't scale linearly, especially when nested virtualization is in use.

Thanks, that's useful information.

Are these other allocations accounted somewhere? If not, are they
potential containment holes that will need fixing eventually?

> > It seems to me you primarily care that it is reported *somewhere*
> > (hence the piggybacking off of NR_PAGETABLE at first). And whether
> > it's page tables or iommu tables or whatever else allocated for the
> > purpose of virtualization, it doesn't make much of a difference to the
> > host/cgroup that is tracking it, right?
> > 
> > (The proximity to nr_pagetable could also be confusing. A high page
> > table count can be a hint to userspace to enable THP. It seems
> > actionable in a different way than a high number of kvm page tables or
> > iommu page tables.)
> 
> I don't know about iommu page tables, but on the KVM side a high count can also
> be a good signal that enabling THP would be beneficial.

Well, maybe.

It might help, but ultimately it's the process that's in control in
all cases: it's unmovable kernel memory allocated to manage virtual
address space inside the task.

So I'm still a bit at a loss whether these things should all be lumped
in together or kept separately. meminfo and memory.stat are permanent
ABI, so we should try to establish in advance whether the new itme is
really a first-class consumer or part of something bigger.

The patch initially piggybacked on NR_PAGETABLE. I found an email of
you asking why it couldn't be a separate item, but it didn't provide a
reasoning for that decision. Could you share your thoughts on that?

Thanks
