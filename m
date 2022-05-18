Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0838552BFAC
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 18:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239969AbiERQNO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239966AbiERQND (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:13:03 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FFF1D8656
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 09:13:02 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id y32so4495389lfa.6
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 09:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H6zF8B/ZSKV/Brh9eLFZw1hXLm47c36XIa6p1tImmdM=;
        b=q+ZpEruT+d1GpzFvdWqACxwEsITa0S5fGrMm0v+DNrEpLFJPPhTaVRr3v6Td+CT1xT
         yrfCPjOF8Qz28anp9If4YMUT3Ji2oUM6VmIilt6ie1hME1dSJVjofoWD3SZwQEWdqVtb
         1HM0rH7QAMjESaj4m2o1Y38AbzdABeHVXNNNQT1/gXDnPS+k4x2hGs8Wbh+2Ep2614nE
         KJI2bl7vo7g5SooTo76AMr7DEOupVc6OwLiRiKHFrw4FAQqS58xOmHP70ZzHtc1CPszB
         TJLQvkpg5LEo4dknOMAHGJp1SoiL6s+VvLLSl8NxBHDtA7xN8pFw0LIi65neeTbGZGly
         V69w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H6zF8B/ZSKV/Brh9eLFZw1hXLm47c36XIa6p1tImmdM=;
        b=V7xUUcL+rGfIfwMb5K4EBNn0g/r7fgXIsOXwWE/Q0JTFDYzC5J+o5NFwdSwrTVZpqa
         5dUxWazVPh2jZE34MOL6Cq7AYWVuCNrpG30f4AI29VjXeX+G6kwhXgEEIDLR0ynCKsgq
         s8F/RIZ4jigH9OtSd+4IxU1jjapShjLfEmA8WsJT+LdGjD0qxRJwtusADxFpjviY/94C
         laBVApV5QMLXMlRZrDyPkd1RKTFVXPoopfXc+e/eioUGB78PbvpT+FQaqCYLkJN3u6za
         FI/ub1v5H7FPdmoMrAv5eDvdrIoI7CiQ0XUQBy7gBanEk0KlKTf+kFhQ9+Z9hm4UfKLP
         u3Dg==
X-Gm-Message-State: AOAM533wmceQS+ZS/7U8REbgY0flfcnijzyB2ztBSms6u5KFMR80L6QP
        8bKeEBd+19ba15ab3IIYthDX5Zy+Ysj8wDhn8tFSqA==
X-Google-Smtp-Source: ABdhPJystWMw9ywhHUO0y68UaGPUmjNh9ytFLUX0K2lSVHAWKhSyw3Ny7W72qS88BZt8zVr/Yp3oYzYpbgksGEo8gTs=
X-Received: by 2002:a19:674c:0:b0:448:3f49:e6d5 with SMTP id
 e12-20020a19674c000000b004483f49e6d5mr184257lfj.518.1652890380187; Wed, 18
 May 2022 09:13:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220517190524.2202762-1-dmatlack@google.com> <20220517190524.2202762-11-dmatlack@google.com>
 <YoQDjx242f0AAUDS@xz-m1.local> <YoT5/TRyA/QKTsqL@xz-m1.local> <YoUPtB0KtRuWl4p7@google.com>
In-Reply-To: <YoUPtB0KtRuWl4p7@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 18 May 2022 09:12:33 -0700
Message-ID: <CALzav=crRhStBy8zouM964ygU7-n72LkMo0m0g4xc5un4Cp1mA@mail.gmail.com>
Subject: Re: [PATCH v2 10/10] KVM: selftests: Add option to run
 dirty_log_perf_test vCPUs in L2
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
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

On Wed, May 18, 2022 at 8:24 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, May 18, 2022, Peter Xu wrote:
> > On Tue, May 17, 2022 at 04:20:31PM -0400, Peter Xu wrote:
> > > On Tue, May 17, 2022 at 07:05:24PM +0000, David Matlack wrote:
> > > > +uint64_t perf_test_nested_pages(int nr_vcpus)
> > > > +{
> > > > + /*
> > > > +  * 513 page tables to identity-map the L2 with 1G pages, plus a few
> > > > +  * pages per-vCPU for data structures such as the VMCS.
> > > > +  */
> > > > + return 513 + 10 * nr_vcpus;
> > >
> > > Shouldn't that 513 magic value be related to vm->max_gfn instead (rather
> > > than assuming all hosts have 39 bits PA)?
> > >
> > > If my math is correct, it'll require 1GB here just for the l2->l1 pgtables
> > > on a 5-level host to run this test nested. So I had a feeling we'd better
> > > still consider >4 level hosts some day very soon..  No strong opinion, as
> > > long as this test is not run by default.
> >
> > I had a feeling that when I said N level I actually meant N-1 level in all
> > above, since 39 bits are for 3 level not 4 level?..
> >
> > Then it's ~512GB pgtables on 5 level?  If so I do think we'd better have a
> > nicer way to do this identity mapping..
>
> Agreed, mapping all theoretically possible gfns into L2 is doomed to fail for
> larger MAXPHYADDR systems.

Peter, I think your original math was correct. For 4-level we need 1
L4 + 512 L3 tables (i.e. ~2MiB) to map the entire address space. Each
of the L3 tables contains 512 PTEs that each points to a 1GiB page,
mapping in total 512 * 512 = 256 TiBd.

So for 5-level we need 1 L5 + 512 L4 + 262144 L3 table (i.e. ~1GiB).

>
> Page table allocations are currently hardcoded to come from memslot0.  memslot0
> is required to be in lower DRAM, and thus tops out at ~3gb for all intents and
> purposes because we need to leave room for the xAPIC.
>
> And I would strongly prefer not to plumb back the ability to specificy an alternative
> memslot for page table allocations, because except for truly pathological tests that
> functionality is unnecessary and pointless complexity.
>
> > I don't think it's very hard - walk the mem regions in kvm_vm.regions
> > should work for us?
>
> Yeah.  Alternatively, The test can identity map all of memory <4gb and then also
> map "guest_test_phys_mem - guest_num_pages".  I don't think there's any other memory
> to deal with, is there?

This isn't necessary for 4-level, but also wouldn't be too hard to
implement. I can take a stab at implementing in v3 if we think 5-level
selftests are coming soon.
