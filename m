Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD89B52EE56
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 16:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350406AbiETOjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 10:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350399AbiETOjo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 10:39:44 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E9A170F1B
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 07:39:42 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id n10so6795565qvi.5
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 07:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TTmi/1xkgT1AjVxJzskAr+COf/0zmPlsvxgfjW6STHE=;
        b=Gxvhl+k8BBXk02rLhNHh59M59iKaZySmrURL5ViwDbexkz4AQDcT1PrTxGRwwIA9b6
         /1f2ADWNgafFMzN43IhcFiyinqNnehHn/mS0YJbtMR6z731PyisnndoOkG4QNw19YD3d
         5k+xSboSMaMN7QvahZpDuaMGQOESeBd5F4Bx3mh8jgB1uyY3ssyoK0Xq2S2xeP72/K83
         PKpXip7h0Y+PpB3dm95FI4ngwmEccKM7+EXoqGyFtJ1eCsv33X6U8TW4FvS5JNrN09KR
         w9b5Y7kbJX4XTJASFVGfGrpW2a4CWNMPykU0xVE8Gyft/WvrlN09/Biji8rIPx+RUWjW
         tCtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TTmi/1xkgT1AjVxJzskAr+COf/0zmPlsvxgfjW6STHE=;
        b=V+mwiUfC6P9DplLgY6fsNG/J6Mw60OahV6HMCalAWEq9kONTHvaPPoCBaYb+1H3Tgx
         seAirkbYh+c8XfyOubhHpzEZCJbJXTghZyV9g/D27cg7ykEbwD5vYTRKXE45PqQmhdnC
         qHViA+Da2Q4I3sEBefn1yf2a39hQyhaL52a/eNHQu/FE7YPNOugmCTziAEsY8aM6Q4/i
         /Ezrt3bAIG+8rUre2XRPtwGGW47YkOttG/y4G3Q256Wg7AqH5znNU6s5bdpeyA51YTd0
         WbsZjDSdqOEqGeSSkXUk6vaxF2Yj7kn1AyWjVIzYNPEwLVkuM6GeJHwQP6ojvQgMeoeo
         jAEg==
X-Gm-Message-State: AOAM531hfzdZjmkPP3Byi561/965ST9vKfTQdVjsfWB9JoQzHS80Eyi3
        7oWfAlphfiun3Q2ul2u3c7EM7A==
X-Google-Smtp-Source: ABdhPJzkvB4GuJsVQAvtAye6NIsbWLxTJ8yuyfKdI6Dpev7Y/X++dkHVcr1QgV/boWcwi159jErlrw==
X-Received: by 2002:ad4:4208:0:b0:461:d262:7842 with SMTP id k8-20020ad44208000000b00461d2627842mr8117176qvp.113.1653057582042;
        Fri, 20 May 2022 07:39:42 -0700 (PDT)
Received: from localhost (cpe-98-15-154-102.hvc.res.rr.com. [98.15.154.102])
        by smtp.gmail.com with ESMTPSA id 196-20020a3706cd000000b0069fd12a957bsm3076730qkg.17.2022.05.20.07.39.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 07:39:41 -0700 (PDT)
Date:   Fri, 20 May 2022 10:39:40 -0400
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
Message-ID: <YoeoLJNQTam5fJSu@cmpxchg.org>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com>
 <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org>
 <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org>
 <Yn6DeEGLyR4Q0cDp@google.com>
 <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
 <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 19, 2022 at 06:56:54PM -0700, Yosry Ahmed wrote:
> On Fri, May 13, 2022 at 10:14 AM Shakeel Butt <shakeelb@google.com> wrote:
> >
> > On Fri, May 13, 2022 at 9:12 AM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > [...]
> > >
> > > It was mostly an honest question, I too am trying to understand what userspace
> > > wants to do with this information.  I was/am also trying to understand the benefits
> > > of doing the tracking through page_state and not a dedicated KVM stat.  E.g. KVM
> > > already has specific stats for the number of leaf pages mapped into a VM, why not
> > > do the same for non-leaf pages?
> >
> > Let me answer why a more general stat is useful and the potential
> > userspace reaction:
> >
> > For a memory type which is significant enough, it is useful to expose
> > it in the general interfaces, so that the general data/stat collection
> > infra can collect them instead of having workload dependent stat
> > collectors. In addition, not necessarily that stat has to have a
> > userspace reaction in an online fashion. We do collect stats for
> > offline analysis which greatly influence the priority order of
> > optimization workitems.
> >
> > Next the question is do we really need a separate stat item
> > (secondary_pagetable instead of just plain pagetable) exposed in the
> > stable API? To me secondary_pagetable is general (not kvm specific)
> > enough and can be significant, so having a separate dedicated stat
> > should be ok. Though I am ok with lump it with pagetable stat for now
> > but we do want it to be accounted somewhere.
> 
> Any thoughts on this? Johannes?

I agree that this memory should show up in vmstat/memory.stat in some
form or another.

The arguments on whether this should be part of NR_PAGETABLE or a
separate entry seem a bit vague to me. I was hoping somebody more
familiar with KVM could provide a better picture of memory consumption
in that area.

Sean had mentioned that these allocations already get tracked through
GFP_KERNEL_ACCOUNT. That's good, but if they are significant enough to
track, they should be represented in memory.stat in some form. Sean
also pointed out though that those allocations tend to scale rather
differently than the page tables, so it probably makes sense to keep
those two things separate at least.

Any thoughts on putting shadow page tables and iommu page tables into
the existing NR_PAGETABLE item? If not, what are the cons?

And creating (maybe later) a separate NR_VIRT for the other
GPF_KERNEL_ACCOUNT allocations in kvm?
