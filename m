Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67470593170
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 17:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbiHOPOa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 11:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240704AbiHOPOR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 11:14:17 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7707127149
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 08:13:54 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id u10so5520436qvp.12
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 08:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=SVpUVzPm5W0Voyj60yN9H262DjM/0dmmT6CafgD5LQQ=;
        b=gOOWpTPZwiM17WF4f5gKOhDCSLU9Xa7Ddw5htxLmCf1V9e6337lrTGD7E89v0QfRVJ
         UKtYdBjRPV+SoEPNaViOMhRD3539K1N9epXUdaYog0Ghqr9Hz/q4svAJMLG3UwT6sWxo
         +VuEzH2WqgtjnVrw0RSEk1ZZzuVg1Iu9u/y7a/XQdVWZSk6nHZ6e0lHT1onclU+0r7hJ
         Q5W7083KTKmB0O6AdzaftKfJMa8rGq92lENKSy6Nq4zRtkJGrMxpmyvJ4DecH3ziV2yY
         aiceCwnsy9e7wohTT0MQGWEDNlpX9jUl/3N9hIGAEaDitMSoD3owjEMqWgSnWOXKWzKG
         oZdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=SVpUVzPm5W0Voyj60yN9H262DjM/0dmmT6CafgD5LQQ=;
        b=7K8+LuN8Omc1jQfn8eaJtpNXoATnpnGq4xNKId125Nj0+SxdAIzGX1kz9IEWm2S9XM
         /P2/diPPsak3AszqaN4GTfO9/yRj8b6u9jnfavSPDO5emdDahahOk0q/ncHdWQis7qVj
         +u+iPvnt3KFFOwHEDK4BstQDoFJF37ul0SF9Q+/5otdd9rJToAFHuXG+NkzSTF0p73TC
         EkGYln7lGDXspxExqMpW8/sXs8Jae1MX+ovXPDlz0fq3PlAd+yBO3x/+tXpaExLDI6y5
         bAvWf+ezZjpCeo/7vmugNCQQ5XmGioKT+XrKph+HCxa6LAyp/3qoAdST+HpSnuwbupGO
         hIpg==
X-Gm-Message-State: ACgBeo1L7Ra2LME9n2yrnhDaSerXNquYCMzzjlM6czpFdjAa37vvXdvS
        olafWn9xraZv8gHkL/g/RR4q8g==
X-Google-Smtp-Source: AA6agR5vrCQlXB1uSwNPvBPyKCFf9sAWMWRn04guCYRZ/JGYECdgQAzs4QjOMDL0tMgKmgpjwr5NJQ==
X-Received: by 2002:a0c:b2c5:0:b0:47e:4f8e:f0ae with SMTP id d5-20020a0cb2c5000000b0047e4f8ef0aemr13992515qvf.9.1660576433584;
        Mon, 15 Aug 2022 08:13:53 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::a23e])
        by smtp.gmail.com with ESMTPSA id r5-20020ac87945000000b0031f0485aee0sm2014653qtt.88.2022.08.15.08.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 08:13:52 -0700 (PDT)
Date:   Mon, 15 Aug 2022 11:13:51 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, Tejun Heo <tj@kernel.org>,
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
Message-ID: <Yvpir0nWuTsXz322@cmpxchg.org>
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com>
 <YsdJPeVOqlj4cf2a@google.com>
 <CAJD7tkYE+pZdk=-psEP_Rq_1CmDjY7Go+s1LXm-ctryWvUdgLA@mail.gmail.com>
 <Ys3+UTTC4Qgbm7pQ@google.com>
 <CAJD7tkY91oiDWTj5FY2Upc5vabsjLk+CBMNzAepXLUdF_GS11w@mail.gmail.com>
 <CAJD7tkbc+E7f+ENRazf0SO7C3gR2bHiN4B0F1oPn8Pa6juAVfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tkbc+E7f+ENRazf0SO7C3gR2bHiN4B0F1oPn8Pa6juAVfg@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 08, 2022 at 01:06:15PM -0700, Yosry Ahmed wrote:
> On Mon, Jul 18, 2022 at 11:26 AM Yosry Ahmed <yosryahmed@google.com> wrote:
> >
> > On Tue, Jul 12, 2022 at 4:06 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Tue, Jul 12, 2022, Yosry Ahmed wrote:
> > > > Thanks for taking another look at this!
> > > >
> > > > On Thu, Jul 7, 2022 at 1:59 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > >
> > > > > On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> > > > > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > > > > index aab70355d64f3..13190d298c986 100644
> > > > > > --- a/include/linux/mmzone.h
> > > > > > +++ b/include/linux/mmzone.h
> > > > > > @@ -216,6 +216,7 @@ enum node_stat_item {
> > > > > >       NR_KERNEL_SCS_KB,       /* measured in KiB */
> > > > > >  #endif
> > > > > >       NR_PAGETABLE,           /* used for pagetables */
> > > > > > +     NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */
> > > > >
> > > > > Nit, s/kvm/KVM, and drop the "shadow", which might be misinterpreted as saying KVM
> > > > > pagetables are only accounted when KVM is using shadow paging.  KVM's usage of "shadow"
> > > > > is messy, so I totally understand why you included it, but in this case it's unnecessary
> > > > > and potentially confusing.
> > > > >
> > > > > And finally, something that's not a nit.  Should this be wrapped with CONFIG_KVM
> > > > > (using IS_ENABLED() because KVM can be built as a module)?  That could be removed
> > > > > if another non-KVM secondary MMU user comes along, but until then, #ifdeffery for
> > > > > stats the depend on a single feature seems to be the status quo for this code.
> > > > >
> > > >
> > > > I will #ifdef the stat, but I will emphasize in the docs that is
> > > > currently *only* used for KVM so that it makes sense if users without
> > > > KVM don't see the stat at all. I will also remove the stat from
> > > > show_free_areas() in mm/page_alloc.c as it seems like none of the
> > > > #ifdefed stats show up there.
> > >
> > > It's might be worth getting someone from mm/ to weigh in before going through the
> > > trouble, my suggestion/question is based purely on the existing code.
> >
> > Any mm folks with an opinion about this?
> >
> > Any preference on whether we should wrap NR_SECONDARY_PAGETABLE stats
> > with #ifdef CONFIG_KVM for now as it is currently the only source for
> > this stat?
> 
> Any input here?
> 
> Johannes, you have been involved in discussions in earlier versions of
> this series, any thoughts here?

No super strong feelings here. Most major distros have CONFIG_KVM=y/n,
so it'll be a common fixture anyway, and the ifdef is proooobably not
worth it for hiding it from people. OTOH, the ifdef is useful for
documenting the code.

If you've already ifdeffed it now, I'd say go ahead with
it. Otherwise, don't :) My 2c.
