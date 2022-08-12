Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53EBE5913DB
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 18:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239330AbiHLQ2g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 12:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239329AbiHLQ2e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 12:28:34 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA4AAE9C0
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:28:34 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id u3so1996970lfk.8
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ZABhkwMvQKj+s962sPzw3oj9UWUWwZfJSe6O7EgHJ7M=;
        b=MBOtKz2i2Ltmjflc2g5ihJdgjMppnGwI2RUQAXTPg5KLH0hpZH1HSBjywdN5cFJOHJ
         oAO44wBz0/ZyupYbczjALyhDN26U1mbCOgeXY2NvtDwcWEf3v9v4+yxyzU9Xlc67rSxQ
         cRAsabtb0itqhU/WRhhCTZeE+3yymwDnoLibxv/JXFr+gDJMqZoahAGB0dGfOWt0SBl3
         nr79r4pSOgV0+K3PeBdT4vnQbXjgVoJkh9uidcWrVfZ8G1P73ZK4dKpOqDikPlu2tQRz
         29/FyoJ/40NSjche+KN5Jeaqo8q5b1PBLQoCNV9kxcCTYgLbwWO6xIauTUyqV3FBF3ss
         z7sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ZABhkwMvQKj+s962sPzw3oj9UWUWwZfJSe6O7EgHJ7M=;
        b=7pCs+W1tTpRnm+D7aRYsWJolmQ0S/g7pIm6cFCpwFsfU/KN/sBuje3aMHyfpz61EXI
         h6HXVNT6BEgd/5Kkygf97hr2xW6A2yPDCCmyb7gX7KHSz/yHoG7oalbatS74U829Laqg
         xxsSmVpPfGKfRItVEEbHt1tlFt2DAltbF7ToGDGkl8iKXshGhdSh9qQcpiwGhoj3AAfa
         QinToyDmlxHGE5NJLTrghXcKLPw/0L0uo0MNc45k/41RC1EPq1TfYnxy4c6/sT7EGan5
         +oJzKQBRVSj+DSBI/qsR0jTXJen7EkLb3r16f0gWtWYAig5AhayVPt9KK3r5BrPnKSct
         5UFg==
X-Gm-Message-State: ACgBeo3jP143qnTIg3Qf84H0bVH33ApADPbQ8dIggYvK8C0MYIRQrIlV
        KoUZrrtjGarta1fsENvzoSg8jcSfQm6VyfCKPvaNfA==
X-Google-Smtp-Source: AA6agR6KpQXzpxNNZSiMhRT+Lyp6tpkAECzcO6T/SrIZvIsuofWnATdxcFbP6a7pOESj29y6Aymlgnwuf8+qq7HAKZ4=
X-Received: by 2002:ac2:4c4f:0:b0:48b:1358:67e3 with SMTP id
 o15-20020ac24c4f000000b0048b135867e3mr1471947lfk.441.1660321712200; Fri, 12
 Aug 2022 09:28:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220810175830.2175089-1-coltonlewis@google.com>
 <20220810175830.2175089-4-coltonlewis@google.com> <YvREA1VJA3ryF+io@google.com>
 <YvZ+rTKd8dmezzgu@google.com>
In-Reply-To: <YvZ+rTKd8dmezzgu@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 12 Aug 2022 09:28:05 -0700
Message-ID: <CALzav=d-_uiDBgcELbHCXT3aJ0jXu29p=HeYMaB+ngQQoHiVXw@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: selftests: Randomize page access order
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Ricardo Koller <ricarkol@google.com>
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

On Fri, Aug 12, 2022 at 9:24 AM Colton Lewis <coltonlewis@google.com> wrote:
>
> On Wed, Aug 10, 2022 at 04:49:23PM -0700, David Matlack wrote:
> > On Wed, Aug 10, 2022 at 05:58:30PM +0000, Colton Lewis wrote:
> > > diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > > index 3c7b93349fef..9838d1ad9166 100644
> > > --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> > > +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > > @@ -52,6 +52,9 @@ void perf_test_guest_code(uint32_t vcpu_idx)
> > >     struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_idx];
> > >     uint64_t gva;
> > >     uint64_t pages;
> > > +   uint64_t addr;
> > > +   bool random_access = pta->random_access;
> > > +   bool populated = false;
> > >     int i;
> > >
> > >     gva = vcpu_args->gva;
> > > @@ -62,7 +65,11 @@ void perf_test_guest_code(uint32_t vcpu_idx)
> > >
> > >     while (true) {
> > >             for (i = 0; i < pages; i++) {
> > > -                   uint64_t addr = gva + (i * pta->guest_page_size);
> > > +                   if (populated && random_access)
> >
> > Skipping the populate phase makes sense to ensure everything is
> > populated I guess. What was your rational?
>
> That's it. Wanted to ensure everything was populated. Random
> population won't hit every page, but those unpopulated pages might be
> hit on subsequent iterations. I originally let population be random
> too and suspect this was driving an odd behavior I noticed early in
> testing where later iterations would be much faster than earlier ones.
>
> > Either way I think this policy should be driven by the test, rather than
> > harde-coded in perf_test_guest_code(). i.e. Move the call
> > perf_test_set_random_access() in dirty_log_perf_test.c to just after the
> > population phase.
>
> That makes sense. Will do.

Ah but if you get rid of the table refill between iterations, each
vCPU will access the same pages every iteration. At that point there's
no reason to distinguish the populate phase from the other phases, so
perhaps just drop the special case for the populate phase altogether?
