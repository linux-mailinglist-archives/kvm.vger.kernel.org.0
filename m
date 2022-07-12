Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0159C5729A8
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 01:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbiGLXGA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 19:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiGLXF7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 19:05:59 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53CB60533
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 16:05:57 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id o3-20020a17090a744300b001ef8f7f3dddso718904pjk.3
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 16:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xf3o/FVcDrWTjqM4SU9OE71B6I+xuW/GFj0iZmpmQbg=;
        b=Z6IZzY9s3jOmwMJHCnOHfcd/X/fC5gga+f0/GnThBBONKEbR0I2NH1Ty6iOIdsZmZK
         aNZ+3HOLhzAiz/Mid2qzpPjGI4JFUuI7nGA4w+vhGU8t1Ok9afcoe/Jc3y3eYW+ViOab
         rveEgyZkqCy1hZZW8DMIBAUqyENo2A5JOeC+C7DZWne1sV1Bng0215Kup44rqee7ljzP
         3+jP61rUQdp8Ls05woP3XU1jDYEQHcMan6eZ/rjuZCWJI/jS6HIryjgTfUh27QyF+0Qr
         HwRYJrJFek+4g2OqMsbQb+YRG+J8VOZMzWxz6CtFgnDzWRb8c+R5L/pvuutOzNOqXTJT
         5rDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xf3o/FVcDrWTjqM4SU9OE71B6I+xuW/GFj0iZmpmQbg=;
        b=3SX98/XJ4z1nacZ2FcGWJ//yOXInQ0w4/Nq3y2Ts+tahYWUHFZkWXAVRXGcLCCP1Vn
         ZW94lO1uP+nuaAE37uxq0FvAibmu/qCsgwwTXAbtE4URWGJLHeoQNcHAq2ZH8NJO8/rS
         QwEd8EzNbrbTXoalrKIpH6oBcL+m/9Yl8Q/0pXUYsqvB3Au/rvVJAaimHdyJYcLWy41+
         Y6ckA8acwgcUh2fRZ4YPiZvFcVZTxOdqW9enQ2Hp59/zmOhidS1ih/2FABOPez2dBAR5
         WCgdOAgHmEeuK9T7Wr+DA9D8BoGRtdokpSr/I+5+sTxTbI3yLk58BzHkFt8XUIa2SwGR
         zZQA==
X-Gm-Message-State: AJIora82Y6D4AiUmCrW+xSytQmjhQx1hEcquFOiy5I/GrEK7jn45IRdv
        RhcLPHHBXwFW9Dqh6iOJuf/BQw==
X-Google-Smtp-Source: AGRyM1vgSDMytGaDjecq2tqtXq4s3MkrfSl0jPwry11NPVDZdGzL7EkgDGCSpo3Mk+AMiarqH+bA+Q==
X-Received: by 2002:a17:903:2cb:b0:14f:4fb6:2fb0 with SMTP id s11-20020a17090302cb00b0014f4fb62fb0mr555392plk.172.1657667157162;
        Tue, 12 Jul 2022 16:05:57 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id x4-20020a17090ad68400b001f069352d73sm121393pju.25.2022.07.12.16.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 16:05:56 -0700 (PDT)
Date:   Tue, 12 Jul 2022 23:05:53 +0000
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
        Shaoqin <shaoqin.huang@intel.com>,
        Cgroups <cgroups@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Message-ID: <Ys3+UTTC4Qgbm7pQ@google.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com>
 <YsdJPeVOqlj4cf2a@google.com>
 <CAJD7tkYE+pZdk=-psEP_Rq_1CmDjY7Go+s1LXm-ctryWvUdgLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tkYE+pZdk=-psEP_Rq_1CmDjY7Go+s1LXm-ctryWvUdgLA@mail.gmail.com>
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

On Tue, Jul 12, 2022, Yosry Ahmed wrote:
> Thanks for taking another look at this!
> 
> On Thu, Jul 7, 2022 at 1:59 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > index aab70355d64f3..13190d298c986 100644
> > > --- a/include/linux/mmzone.h
> > > +++ b/include/linux/mmzone.h
> > > @@ -216,6 +216,7 @@ enum node_stat_item {
> > >       NR_KERNEL_SCS_KB,       /* measured in KiB */
> > >  #endif
> > >       NR_PAGETABLE,           /* used for pagetables */
> > > +     NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */
> >
> > Nit, s/kvm/KVM, and drop the "shadow", which might be misinterpreted as saying KVM
> > pagetables are only accounted when KVM is using shadow paging.  KVM's usage of "shadow"
> > is messy, so I totally understand why you included it, but in this case it's unnecessary
> > and potentially confusing.
> >
> > And finally, something that's not a nit.  Should this be wrapped with CONFIG_KVM
> > (using IS_ENABLED() because KVM can be built as a module)?  That could be removed
> > if another non-KVM secondary MMU user comes along, but until then, #ifdeffery for
> > stats the depend on a single feature seems to be the status quo for this code.
> >
> 
> I will #ifdef the stat, but I will emphasize in the docs that is
> currently *only* used for KVM so that it makes sense if users without
> KVM don't see the stat at all. I will also remove the stat from
> show_free_areas() in mm/page_alloc.c as it seems like none of the
> #ifdefed stats show up there.

It's might be worth getting someone from mm/ to weigh in before going through the
trouble, my suggestion/question is based purely on the existing code.
