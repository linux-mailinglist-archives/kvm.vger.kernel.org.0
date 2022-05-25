Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52346533C1D
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 13:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243175AbiEYL47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 07:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243270AbiEYL4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 07:56:49 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570A39FC3
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 04:56:46 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id x7so13512653qta.6
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 04:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lEk6v60gkjFT68Gj4bJNaNs7k2gNzwxPhiEY5nNwaQQ=;
        b=XXcCcSNfXU4ZumvEofzKMhDBd7cN4uUTScIpzCQEM+hzYYKUfsKNiF4P7UVF51FKtd
         5RMh2GAnDESjADbuXOd1AqGedzaXh0w5A9T12BqTWJPxR4mUsbYzVpqI1DeLqcj+jRCv
         g4Mbz8Isqpigexjq2xgBfxvEZ6XOCfbhrEWV/D3mKfrw49MZYSOCSMLcFNY4bPWoBIIQ
         R5QYWFwAz8og1bHFYOMrTQ4s+e/PEPEozRRHKxlX3pJQbF9dxpvlI9pbg9wJj7C5geki
         qkYRTvMTxuO0dTaFgb5ZebuX4LpE/ZIxHighxOWhBpx05saqXnbfuwd4MPhQ1tJOvxUj
         hZDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lEk6v60gkjFT68Gj4bJNaNs7k2gNzwxPhiEY5nNwaQQ=;
        b=Y55zWVnN3l71kY3LYk+8E1YsYcg8HsTb/Puh2uGxaDkN4Ivtf5+COMcuKPeTS+JIiP
         5sY+Ql4GbNWT3JXyQM+Wx5PLrE49i7iyliy/lM1T9bNZymcEtr9LdWcl1AGi7fYshNPM
         b04Jjc5PcbDJ9ss57i4kViazZ8gU7WmD3IDZr010XK6tO7sO9KFNkgPphk1BM+VHZ6YO
         6P0IXl6jzJgcS9nwRL1z4MhogKnnKaIVwJYypSFp2XaKGj8xiBeY7SpTbADAIFdH7YnN
         6JYPggGkRN0YGOLj4ZYZmPn0SVA8677zX52Mgscojzu5A2yalSuSfjT7XFE95N4UKUIa
         8/xw==
X-Gm-Message-State: AOAM531EwHmGOFD/fFJN4qIME8ftcPDokJGfOICL5/AHWv8wkYOAFCBu
        /S1B3mKxYYUU9iJVc4ZIgNOEURgsFSJWxA==
X-Google-Smtp-Source: ABdhPJwFHUkIBHNUiY22IoYqV5QV59CSwCqYRuCiU7sPHckigA3yOeAfSHjhUNo+n/aWFHPqKI7LJA==
X-Received: by 2002:ac8:4e81:0:b0:2f9:34e4:8955 with SMTP id 1-20020ac84e81000000b002f934e48955mr11600672qtp.459.1653479804938;
        Wed, 25 May 2022 04:56:44 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:741f])
        by smtp.gmail.com with ESMTPSA id m25-20020ac84459000000b002f94737333bsm1152559qtn.21.2022.05.25.04.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 04:56:44 -0700 (PDT)
Date:   Wed, 25 May 2022 07:56:43 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Sean Christopherson <seanjc@google.com>,
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
Message-ID: <Yo4Ze+DZrLqn0PeU@cmpxchg.org>
References: <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org>
 <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org>
 <Yn6DeEGLyR4Q0cDp@google.com>
 <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
 <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ@mail.gmail.com>
 <YoeoLJNQTam5fJSu@cmpxchg.org>
 <CAJD7tkYjcmwBeUx-=MTQeUf78uqFDvfpy7OuKy4OvoS7HiVO1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tkYjcmwBeUx-=MTQeUf78uqFDvfpy7OuKy4OvoS7HiVO1Q@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 24, 2022 at 03:31:52PM -0700, Yosry Ahmed wrote:
> On Fri, May 20, 2022 at 7:39 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > I agree that this memory should show up in vmstat/memory.stat in some
> > form or another.
> >
> > The arguments on whether this should be part of NR_PAGETABLE or a
> > separate entry seem a bit vague to me. I was hoping somebody more
> > familiar with KVM could provide a better picture of memory consumption
> > in that area.
> >
> > Sean had mentioned that these allocations already get tracked through
> > GFP_KERNEL_ACCOUNT. That's good, but if they are significant enough to
> > track, they should be represented in memory.stat in some form. Sean
> > also pointed out though that those allocations tend to scale rather
> > differently than the page tables, so it probably makes sense to keep
> > those two things separate at least.
> >
> > Any thoughts on putting shadow page tables and iommu page tables into
> > the existing NR_PAGETABLE item? If not, what are the cons?
> >
> > And creating (maybe later) a separate NR_VIRT for the other
> > GPF_KERNEL_ACCOUNT allocations in kvm?
> 
> I agree with Sean that a NR_VIRT stat would be inaccurate by omission,
> unless we account for all KVM allocations under this stat. This might
> be an unnecessary burden according to what Sean said, as most other
> allocations scale linearly with the number of vCPUs or the memory
> assigned to the VM.

I think it's fine to table the addition of NR_VIRT for now. My
conclusion from this discussion was just that if we do want to add
more KVM-related allocation sites later on, they likely would be
something separate and not share an item with the shadow tables. This
simplifies the discussion around how to present the shadow tables.

That said, stats can be incremental and still useful. memory.current
itself lies by ommission. It's more important to catch what's of
significance and allow users to narrow down pathological cases.

> I don't have enough context to say whether we should piggyback KVM MMU
> pages to the existing NR_PAGETABLE item, but from a high level it
> seems like it would be more helpful if they are a separate stat.
> Anyway, I am willing to go with whatever Sean thinks is best.

Somebody should work this out and put it into a changelog. It's
permanent ABI.
