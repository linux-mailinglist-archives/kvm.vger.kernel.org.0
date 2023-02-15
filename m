Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424286980CE
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 17:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjBOQZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 11:25:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjBOQZR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 11:25:17 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501B539CC3
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 08:25:14 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id m12so22364270qth.4
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 08:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AFepK2rkB6ezD70sOO4MhlZcyxN8oS1icDWJsj/PPKQ=;
        b=Qhoq6nyimphHqRE5WzVN8RgkyLd4oDJPLhqmOaXFoUid4CPWPTXVbx5yfIcS/DOpDi
         Q66ZjIRewef/dTRmmUZgomkm9Zy1xH+8qmHVBQ8bgeRyLulUUHGdB6RbVOZ7mtVrdILk
         4N7yn9eJ/7b0IwZHWlL0nh9QjVDOJuijesSDZ/8rzE+ihdxXQwVLvCiFCgFTclMcaG5x
         RbqeniZ0qbfppXUI3yQWv6m5/JOGgE9m0961DBmvFhyq59PuPQ63p9Olt1BIvoED6GOo
         aaRL6rERcJQWqI+1IFfJ5Asu6m84awWlRbc3hzZ7WSly5iAsVvZGHX4C5K5mP8sGf5ZL
         GamQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AFepK2rkB6ezD70sOO4MhlZcyxN8oS1icDWJsj/PPKQ=;
        b=BTuis2EcF0k9eSNAbjTA5+3dG/aKXRzgrPAnEP0tIg2Nqqayqju0gPzbm7bM7OKV3K
         QwR6Rn4gk2mtplMmOUFDzJaWlxpsQaQuwONN+zBGj5/VkWeldkii/MLkXRnhKJF5zh5f
         S5ST/6hoRxfQnUImnLNpmWmPJLz9ldkAv0pOzeZDo5Gq/2Nme0w+W6mO92kN99+l7Wd8
         Pm3xbrF+lPsls0e1GuweRZu7pVjNu5+Y76VhYxR9v4c5GDcW3NiyGFFFkyBPevqbkgUi
         6ZoHJfSbgUGS+34FJTzve80Nu1JMawH74ylMZMqGZY/iiwMksqsLl6x6Udcl4OXPXGoL
         4IEg==
X-Gm-Message-State: AO0yUKXUe/xpkaA/0ZQXN13tZlbX6o5oSJsa/U0YzQ2XYLXjSeGQpxxn
        PrHG82c+mPYwPT4RKhXkBba+JjYfcsdF0bMUqN7HQTMfDwSrXiemJTM=
X-Google-Smtp-Source: AK7set9ikM4pL943zsnOf8yKyyR11BmkOt0tLqoP8fuVV3p3LRQ9jdICX6UpZLZ8msIH4DpPAMZoNgO+hZsONxK16LM=
X-Received: by 2002:ac8:58cb:0:b0:3ba:240b:99ad with SMTP id
 u11-20020ac858cb000000b003ba240b99admr355236qta.65.1676478313326; Wed, 15 Feb
 2023 08:25:13 -0800 (PST)
MIME-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com> <20230206165851.3106338-10-ricarkol@google.com>
 <9201764f-baa1-250a-39ac-0305bce789a3@redhat.com> <CAOHnOrzGXU29JK+8aRq0SnMe6Ske04YWffJhPU6iUXjGyyoQtA@mail.gmail.com>
In-Reply-To: <CAOHnOrzGXU29JK+8aRq0SnMe6Ske04YWffJhPU6iUXjGyyoQtA@mail.gmail.com>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Wed, 15 Feb 2023 08:25:02 -0800
Message-ID: <CAOHnOrwZGyzARsOqfgNGk9cH4rUoi-FyKXbbKa-fu=MzA+yO1g@mail.gmail.com>
Subject: Re: [PATCH v2 09/12] KVM: arm64: Split huge pages when dirty logging
 is enabled
To:     Gavin Shan <gshan@redhat.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > +
> > > +             next = __stage2_range_addr_end(addr, end, chunk_size);
> > > +             ret = kvm_pgtable_stage2_split(pgt, addr, next - addr,
> > > +                                            cache, cache_capacity);
> > > +             if (ret)
> > > +                     break;
> > > +     } while (addr = next, addr != end);
> > > +
> > > +     return ret;
> > > +}
> > > +
> > >   #define stage2_apply_range_resched(kvm, addr, end, fn)                      \
> > >       stage2_apply_range(kvm, addr, end, fn, true)
> > >
> >
> > I'm wandering if stage2_apply_range() can be reused to avoid invent another similar
> > function. the gap are the granularity and conditions to reschedule.
>
> Will try and see what it looks like and report back.
>

Tried and don't like the result very much:

static int _stage2_apply_range(struct kvm *kvm, phys_addr_t addr,
phys_addr_t end,
                               int (*fn)(struct kvm_pgtable *, u64,
u64),
                               bool fn_ignore_failures, bool
fn_drop_mmu_lock,
                               struct kvm_mmu_memory_cache *cache, int
cache_capacity,
                               bool resched)

The generic function would require too many arguments to work for all cases.

Thanks,
Ricardo
