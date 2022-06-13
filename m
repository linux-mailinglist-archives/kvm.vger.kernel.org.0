Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14AD2549D31
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 21:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242079AbiFMTPe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 15:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349231AbiFMTNo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 15:13:44 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8160350E27
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 10:12:02 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id o8so7961518wro.3
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 10:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BwfpdGVZuLzhMRO0qDkUrzUSE4uGJ0s4izOa+gswkLc=;
        b=iyoFryyCEMOgC7rXLKu4nOmoJ4Ev3bSJmT6ed09FE5xCAAc5dBkkwtXxpcvvGQ+P+z
         ETT+TDFbc4w3QEtd0CSTtGopVeE/ROGO0WHkEbyE/LYwiv3H3TW3pyxouKMCLv+KqkYZ
         yNXDxA5s4wHBPNNleteRDWB0OVGKRy46fxusIatVg7fbsU3f8NuQHDDwXuooOAhihX5c
         apRzdEm4Qcxw1Vp4x8eHSJ0zk6RBYV1Jvu3JCqD8yM8Yczm4FlFHmh8FmzU3HH+SvYZl
         N0nY66gFj0te0BB1xSoY4rr990nbGbzyauUa8tb8y8DjQzQQuFKjHb8vPu4IK/5VClaZ
         mw/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BwfpdGVZuLzhMRO0qDkUrzUSE4uGJ0s4izOa+gswkLc=;
        b=16VnyUD9lmH16lwYyh70xDxU02F4KjZnmH9uh5xyhXl0oIUKzs/rhCTtU+sUWE3gvx
         /wz237c/8EBng8zkzK6dc92GpVvkO7pN1EMvdbmfAFFCkSNJaMBrmEPHyEloHxrGUyKr
         T7NcSe0X5BIcYwnsNv7/nR81wGvsRKDRPYCRvrLZUhWwPAwxDBQ86wgcayHXtMtQNatn
         sXLdpPAoS7dyT24wyUSoklCV+14ZyUGD0zZkAEvOfATs3S/6ZNAvvwH0eyxCGJJQnRmE
         s0xpplHCmUYTcJxREPK6XAyZY2qGxWkD68p2LyGsib9W4kDVmvmNFJctfnqsmrJN18cH
         S56Q==
X-Gm-Message-State: AJIora9DXvMrJXE3pxrPn/t1X1uBSOVflG9BKUZZENij80JDKKby79/1
        khG9XqkXF8PIKKBTC3MZMI248eIkpXdkluS+2pS8BQ==
X-Google-Smtp-Source: AGRyM1s6B0qb0T2WacCoWhhkywiiU+ZvFODg5mDtSwgELuEdOO1P7hQRTSX7NI4gasI6mKDBJY57NrqOabVTnciF7VA=
X-Received: by 2002:adf:f688:0:b0:215:6e4d:4103 with SMTP id
 v8-20020adff688000000b002156e4d4103mr802713wrp.372.1655140320646; Mon, 13 Jun
 2022 10:12:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220606222058.86688-1-yosryahmed@google.com> <20220606222058.86688-2-yosryahmed@google.com>
 <bdfea446-623c-d423-673f-496b3725ec2c@intel.com>
In-Reply-To: <bdfea446-623c-d423-673f-496b3725ec2c@intel.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Mon, 13 Jun 2022 10:11:23 -0700
Message-ID: <CAJD7tkbUXb7qBm1GAMDr29DcsC90_bPzwffkdtAu_Na+inVzVg@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To:     "Huang, Shaoqin" <shaoqin.huang@intel.com>
Cc:     Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>,
        Cgroups <cgroups@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 12, 2022 at 8:18 PM Huang, Shaoqin <shaoqin.huang@intel.com> wrote:
>
>
>
> On 6/7/2022 6:20 AM, Yosry Ahmed wrote:
> > Add NR_SECONDARY_PAGETABLE stat to count secondary page table uses, e.g.
> > KVM mmu. This provides more insights on the kernel memory used
> > by a workload.
> >
> > This stat will be used by subsequent patches to count KVM mmu
> > memory usage.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
> >   Documentation/admin-guide/cgroup-v2.rst | 5 +++++
> >   Documentation/filesystems/proc.rst      | 4 ++++
> >   drivers/base/node.c                     | 2 ++
> >   fs/proc/meminfo.c                       | 2 ++
> >   include/linux/mmzone.h                  | 1 +
> >   mm/memcontrol.c                         | 1 +
> >   mm/page_alloc.c                         | 6 +++++-
> >   mm/vmstat.c                             | 1 +
> >   8 files changed, 21 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > index 69d7a6983f781..307a284b99189 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1312,6 +1312,11 @@ PAGE_SIZE multiple when read back.
> >         pagetables
> >                   Amount of memory allocated for page tables.
> >
> > +       sec_pagetables
> > +             Amount of memory allocated for secondary page tables,
> > +             this currently includes KVM mmu allocations on x86
> > +             and arm64.
> > +
> >         percpu (npn)
> >               Amount of memory used for storing per-cpu kernel
> >               data structures.
> > diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> > index 061744c436d99..894d6317f3bdc 100644
> > --- a/Documentation/filesystems/proc.rst
> > +++ b/Documentation/filesystems/proc.rst
> > @@ -973,6 +973,7 @@ You may not have all of these fields.
> >       SReclaimable:   159856 kB
> >       SUnreclaim:     124508 kB
> >       PageTables:      24448 kB
> > +    SecPageTables:    0 kB
> >       NFS_Unstable:        0 kB
> >       Bounce:              0 kB
> >       WritebackTmp:        0 kB
> > @@ -1067,6 +1068,9 @@ SUnreclaim
> >   PageTables
> >                 amount of memory dedicated to the lowest level of page
> >                 tables.
> > +SecPageTables
> > +           amount of memory dedicated to secondary page tables, this
> > +           currently includes KVM mmu allocations on x86 and arm64.
>
> Just a notice. This patch in the latest 5.19.0-rc2+ have a conflict in
> Documentation/filesystems/proc.rst file. But that's not a problem.

Thanks for pointing this out. Let me know if a rebase and resend is necessary.

<snip>
