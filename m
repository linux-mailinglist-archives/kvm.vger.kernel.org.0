Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02305EB4AA
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 00:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiIZWk5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 18:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiIZWkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 18:40:47 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057F175CC6
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 15:40:47 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id 126so10132938ybw.3
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 15:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=leXokuawzjypYLVa8ZU3lk5dNqthGL+2jGid9OkBxF4=;
        b=QXmE7j/JeyuTutRio0vy3z1x/L/odiBMhiKt9OHw7Yi4xTjzTfZIEi5FgyMIlFeGKW
         UjqBJ0dG5+VSsljDKWXWzskger+/4hIRa+kN9+CBT5l6J/1wsCg42k04an2Ky5mzzV2R
         ftI4MIOIFDbeaGwC989pVNGQXk4w3pXYokgO4BsAqem5Z+tMRTfltefeAIVScQj2VNFT
         dJuY1yuq6B7qutP9+x0qWTlBd27rHgLMEGauaUgCRMkL/1nUGdTgyrZxrxzmE9nDpeT6
         7nkt4TKgzT1fkWMQLhmxYZHCV0xy1bcgDsQsEmrTHPHvDYNExIXFhAhvioeev+DbHoMZ
         DAwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=leXokuawzjypYLVa8ZU3lk5dNqthGL+2jGid9OkBxF4=;
        b=np8qHK0ypfi5aKSOtsyf1zt2nlecuFdVbSDTD3LvMWtQYUPQAT3MaZttkNFhkyTp0U
         ZrGeAjr+b5IEk6OdNfaE3s326HzvUN0wVzixzFsfdLUp9/ebVGr5WHsrl1er+rgdI+2D
         BPaTLiy20ve//M/a2ep5dkFyzXILWsabjVDvejPCjJZ0+fv6WteokfJr05M9/aO2hUkk
         uwC9uxiwIrre0g9uj0eEg/on42OEKANQrHxJkU7UmptYYF7CPch8xDkj8ENk0esnFczo
         wMdy8P29z3cNDLcYvhZSwb6F9SSodi2H5189VO4GAHSR7Sm/7OwFOgTGxTauyX/Iz47K
         WW7Q==
X-Gm-Message-State: ACrzQf0WiHSAoxhyF7qDKgGYGTY6owHZe85tlFnX/KWFgqkUQqf5n9Td
        wNWM6lecXNA7wdlS40QEusYEL60sk9kTyV3lPxpaHg==
X-Google-Smtp-Source: AMsMyM6F6zmApPMkiHh+Xwq60wD0O6zmdhQiT5NIt2BDTiOngxiseR79ZnVPlfUxlKO8dXetCvfXJEmUhLyB9ZAmBW4=
X-Received: by 2002:a25:e6d5:0:b0:6bc:8d4:d76f with SMTP id
 d204-20020a25e6d5000000b006bc08d4d76fmr2082808ybh.582.1664232046053; Mon, 26
 Sep 2022 15:40:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220926171457.532542-1-dmatlack@google.com> <YzIdfkovobW3w/zk@google.com>
 <CALzav=d-4a8yPxPUuHNh1884Z4Pe_0ewMwnunGK_jAAvr9L-vw@mail.gmail.com> <YzInp2jRH7Bq41gV@google.com>
In-Reply-To: <YzInp2jRH7Bq41gV@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 26 Sep 2022 15:40:20 -0700
Message-ID: <CALzav=dcFTB=ikZQH9OEZVT27iXSntuOH3NV1jr91JaYzVMVkA@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Skip tests that require EPT when it is
 not available
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        kvm list <kvm@vger.kernel.org>
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

On Mon, Sep 26, 2022 at 3:29 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Sep 26, 2022, David Matlack wrote:
> > On Mon, Sep 26, 2022 at 2:45 PM Sean Christopherson <seanjc@google.com> wrote:
> > > I would much rather this be an assert, i.e. force the test to do TEST_REQUIRE(),
> > > even if that means duplicate code.  One of the roles of TEST_REQUIRE() is to
> > > document test requirements.
> >
> > This gets difficult when you consider dirty_log_perf_test. Users can
> > use dirty_log_perf_test in nested mode by passing "-n". But
> > dirty_log_perf_test is an architecture-neutral test, so adding
> > TEST_REQUIRE() there would require an ifdef, and then gets even more
> > complicated if we add support for AMD or nested on non-x86
> > architectures.
>
> But you're going to have that problem regardless, e.g. perf_test_setup_nested()
> already has
>
>         TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
>
> so why not also have the EPT requirement there?  IMO, it's far less confusing if
> the hard requirements are collected together, even if that one location isn't ideal.

Ack, can do.

>
> If someone wants to improve the memstress framework, a hook can be added for probing
> nested requirements.  In other words, IMO this is a shortcoming of the memstress code,
> not a valid reason to shove the requirement down in common code.

Sorry I forgot to ask this in my previous reply... Why do you prefer
to decouple test requirements from the test setup code? There is a
maintenance burden to such an approach, so I want to understand the
benefit. e.g. I forsee myself having to send patches in the future to
add TEST_REQUIRE(kvm_cpu_has_ept()), because someone added a new VMX
test and forgot to test with ept=N.
