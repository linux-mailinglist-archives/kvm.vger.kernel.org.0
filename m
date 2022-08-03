Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71794589006
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 18:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237831AbiHCQLB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 12:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236606AbiHCQLA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 12:11:00 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373AC32D92
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 09:10:59 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id x10so16119631plb.3
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 09:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=P8Kl/xKU4IYrDHB8lVGv34ItbSelul5121WYDgLOaI0=;
        b=AxI/+//w2k08IiKw07QSnQ9ESu4dwG+wQ2H1SGE72Li0sSxNMpJ1h74H0Sl4CJKqsa
         ih4rUvBv/IKrC+E+wGXXNKFxSl7R7LsDyo7QhY8j3ZKQFk/x5XOWF3SohPzArzZc4FId
         y0S0s1uCBL7zRxZmyrax7xPhctcK9wyQJl1iQa3qwhzZBZ1qUWh6cU1SwH23tg25LmC8
         jBcT2MqicnNp3pX3l51BnQDlLyL6gz89Z9nzF04zcjcJZEzZWF8b1I0ueoZnVcTP6M/F
         8B2+3QzRsv2P/2XqGNrJUbuo11iswfZMfh/VT12eZ01MuohkIatWG1v+qHWPimCnW99S
         FJPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=P8Kl/xKU4IYrDHB8lVGv34ItbSelul5121WYDgLOaI0=;
        b=i+i+atQmPtgtGxYEpH/ijm8HjdT4JO78hu2l6zD4z47WYRHe912TUkmWbJ4y00SEVS
         z3gJDdOzCCzEisNO3XjLcSdHuz8QuoXxjiuCHReX9IK53pIl1ZJ1IQZ+NRfnwFoyGf6Z
         gjZpPr+pz9xryfy3kRFPk7ZkkpojTYQjkesPGT7YH37jL65df8YM7y71TLeoVuOiJAOe
         IV08jpn0YBxxnWEhXKUD5Zxs2eZA3hcmKarc9cb9RcxMfOoDYECSO4bPO7/ii7BtLzps
         A2qgXF9o4GqS4IxsyDZ7BZ6BNItBgfWjHxSJU1s0mcRBUou+m0f+oTC/pMT6FrubMdoq
         SXtQ==
X-Gm-Message-State: ACgBeo0n1i8lme7ABiy2btO850yQgbo9Pn1H4H/4ycXdT3LfK/D/396s
        4jZGONgbR5oGrRiTUHMKbf2h9g==
X-Google-Smtp-Source: AA6agR5JGK8PeZUbKGzAWb+OwiWFpZoHLTuXqycARkDvNa2Nl3oOUNhgSpR3SKoJI1jAkIYufUZsSw==
X-Received: by 2002:a17:90a:b010:b0:1f3:161c:30a0 with SMTP id x16-20020a17090ab01000b001f3161c30a0mr5426664pjq.243.1659543058557;
        Wed, 03 Aug 2022 09:10:58 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d9-20020a170903230900b0016f057b88c9sm2226388plh.26.2022.08.03.09.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 09:10:57 -0700 (PDT)
Date:   Wed, 3 Aug 2022 16:10:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     Jinrong Liang <ljr.kernel@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: kvm: Fix a compile error in
 selftests/kvm/rseq_test.c
Message-ID: <YuqeDetNukKp9lyF@google.com>
References: <20220802071240.84626-1-cloudliang@tencent.com>
 <20220802150830.rgzeg47enbpsucbr@kamzik>
 <CAFg_LQWB5hV9CLnavsCmsLbQCMdj1wqe-gVP7vp_mRGt+Eh+nQ@mail.gmail.com>
 <20220803142637.3y5fj2cwyvbrwect@kamzik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220803142637.3y5fj2cwyvbrwect@kamzik>
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

On Wed, Aug 03, 2022, Andrew Jones wrote:
> On Wed, Aug 03, 2022 at 09:58:51PM +0800, Jinrong Liang wrote:
> > My ldd version is (GNU libc) 2.28, and I get a compilation error in this case.
> > But I use another ldd (Ubuntu GLIBC 2.31-0ubuntu9.2) 2.31 is compiling fine.
> > This shows that compilation errors may occur in different GNU libc environments.
> > Would it be more appropriate to use syscall for better compatibility?
> 
> OK, it's a pity, but no big deal to use syscall().

Ya, https://man7.org/linux/man-pages/man2/gettid.2.html says:

  The gettid() system call first appeared on Linux in kernel 2.4.11.  Library
  support was added in glibc 2.30.

But there are already two other instances of syscall(SYS_gettid) in KVM selftests,
tools/testing/selftests/kvm/lib/assert.c even adds a _gettid() wrapper.

So rather than having to remember (or discover) to use syscall(SYS_gettid), I wonder
if it's possible to conditionally define gettid()?  E.g. check for GLIBC version?
Or do

  #define gettid() syscall(SYS_gettid)

so that it's always available and simply overrides the library's gettid() if it's
provided?
