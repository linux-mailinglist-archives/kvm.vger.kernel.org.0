Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79FE253CD5F
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 18:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343839AbiFCQmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 12:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242741AbiFCQmU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 12:42:20 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27FB1EC62
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 09:42:18 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id x65so6400565qke.2
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 09:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pZiq+DaP0uIJbqmhpHEQocGuha+dXUbZZZqTwIB2IaE=;
        b=rrQxT3vbT7GMAWiBE8NKh82hTKWmXoBOIgjSoB8gWHlxJCtpicQfJi6YHcKEu0Skmg
         abttTcfRqmTOcz4L3ohQC6WWhlA31fuHxoEfeuJpbUAg7kX6/vtplGcJ9j4IrzJVxD9O
         vdLoYfObodGls9T269h7hJyDm997n4snH1eyk5q8lGm0DuwzVfKoDQFEQSeKxajjX2Yz
         5TiL9zM/J27+HT1KqOA1cB9necDYn5jb3A6o3ARG7LxeA2ES2j5uBkLAZdLyHaiO4lvt
         ER/oF7LY8Hxyq/pFtt8IclZxYPm5bLZuRep0Ojk6gIJnuU/og9qHiw7H4aRy54/0OtvI
         pIJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pZiq+DaP0uIJbqmhpHEQocGuha+dXUbZZZqTwIB2IaE=;
        b=7Z3gpl/mx62TlJDbVfCZCPjwXp7k9k9fy+/aH97M94piJ1sDzPTLdx/bBKJH0K7jO0
         PeahqvkW+AfDbYmmuL4b2XvtMKcAXqYEBDds5F3NMlLB2IHEy676fM8CWiNvzJBA81mN
         vBHYfrfAuGJH0vBdxn/PBF1rHcchQ2Oy7Kor+YvhS3ZsFp8dcHvEnZppfYKxAdllU7PM
         iwo0T27j+OznbW+2JI80bJz+LwrMrYe0AQM8MAcEcny83Ne5kB/Pk0nhJSXQRbVcxa6U
         gtqtVeaLnHvDLecniZ3vcjFz1IxyAllM/7eBCSjQYrN2qAkwoQnQ/g6t53I75VBQg7fp
         Q9eQ==
X-Gm-Message-State: AOAM532/EWGkFkGMPPtssW/U8SRnbcBurefsdfXRIC3rkyZT/Fn6/x6Z
        jXrfkgrzFcSXKR7UxzFLSgtF6Q==
X-Google-Smtp-Source: ABdhPJwD1IT8PgvyiFpaFJ0oQgGHCzkg9tknn5j7X5fVKzbiMKtPXk1vgrTU2p+vhNcLbOMRztlAVw==
X-Received: by 2002:a05:620a:2845:b0:6a3:646f:9ba8 with SMTP id h5-20020a05620a284500b006a3646f9ba8mr7509475qkp.56.1654274537770;
        Fri, 03 Jun 2022 09:42:17 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:1d66])
        by smtp.gmail.com with ESMTPSA id w184-20020a3794c1000000b006a098381abcsm5550650qkd.114.2022.06.03.09.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 09:42:17 -0700 (PDT)
Date:   Fri, 3 Jun 2022 12:42:15 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
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
        Oliver Upton <oupton@google.com>,
        Cgroups <cgroups@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Message-ID: <Ypo550pGxmnJnGBe@cmpxchg.org>
References: <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org>
 <Yn6DeEGLyR4Q0cDp@google.com>
 <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
 <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ@mail.gmail.com>
 <YoeoLJNQTam5fJSu@cmpxchg.org>
 <CAJD7tkYjcmwBeUx-=MTQeUf78uqFDvfpy7OuKy4OvoS7HiVO1Q@mail.gmail.com>
 <Yo4Ze+DZrLqn0PeU@cmpxchg.org>
 <Yo7MHA2aUaprvgl8@google.com>
 <CAJD7tkYoz=rYvBV3tcp4aLgiyEtr-sBwbncFduZsOq+c8wk5sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tkYoz=rYvBV3tcp4aLgiyEtr-sBwbncFduZsOq+c8wk5sA@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 27, 2022 at 11:33:27AM -0700, Yosry Ahmed wrote:
> On Wed, May 25, 2022 at 5:39 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, May 25, 2022, Johannes Weiner wrote:
> > > On Tue, May 24, 2022 at 03:31:52PM -0700, Yosry Ahmed wrote:
> > > > I don't have enough context to say whether we should piggyback KVM MMU
> > > > pages to the existing NR_PAGETABLE item, but from a high level it
> > > > seems like it would be more helpful if they are a separate stat.
> > > > Anyway, I am willing to go with whatever Sean thinks is best.
> > >
> > > Somebody should work this out and put it into a changelog. It's
> > > permanent ABI.
> >
> > After a lot of waffling, my vote is to add a dedicated NR_SECONDARY_PAGETABLE.
> >
> > It's somewhat redundant from a KVM perspective, as NR_SECONDARY_PAGETABLE will
> > scale with KVM's per-VM pages_{4k,2m,1g} stats unless the guest is doing something
> > bizarre, e.g. accessing only 4kb chunks of 2mb pages so that KVM is forced to
> > allocate a large number of page tables even though the guest isn't accessing that
> > much memory.
> >
> > But, someone would need to either understand how KVM works to make that connection,
> > or know (or be told) to go look at KVM's stats if they're running VMs to better
> > decipher the stats.
> >
> > And even in the little bit of time I played with this, I found having
> > nr_page_table_pages side-by-side with nr_secondary_page_table_pages to be very
> > informative.  E.g. when backing a VM with THP versus HugeTLB,
> > nr_secondary_page_table_pages is roughly the same, but nr_page_table_pages is an
> > order of a magnitude higher with THP.  I'm guessing the THP behavior is due to
> > something triggering DoubleMap, but now I want to find out why that's happening.
> >
> > So while I'm pretty sure a clever user could glean the same info by cross-referencing
> > NR_PAGETABLE stats with KVM stats, I think having NR_SECONDARY_PAGETABLE will at the
> > very least prove to be helpful for understanding tradeoffs between VM backing types,
> > and likely even steer folks towards potential optimizations.
> >
> > Baseline:
> >   # grep page_table /proc/vmstat
> >   nr_page_table_pages 2830
> >   nr_secondary_page_table_pages 0
> >
> > THP:
> >   # grep page_table /proc/vmstat
> >   nr_page_table_pages 7584
> >   nr_secondary_page_table_pages 140
> >
> > HugeTLB:
> >   # grep page_table /proc/vmstat
> >   nr_page_table_pages 3153
> >   nr_secondary_page_table_pages 153
> >
> 
> Interesting findings! Thanks for taking the time to look into this, Sean!
> I will refresh this patchset and summarize the discussion in the
> commit message, and also fix some nits on the KVM side. Does this
> sound good to everyone?

Yes, thanks for summarizing this. Sounds good to me!

