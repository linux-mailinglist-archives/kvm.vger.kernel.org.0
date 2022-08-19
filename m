Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8895759A907
	for <lists+kvm@lfdr.de>; Sat, 20 Aug 2022 01:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241522AbiHSW7e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 18:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbiHSW7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 18:59:32 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B3713CC7
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 15:59:32 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id r15-20020a17090a1bcf00b001fabf42a11cso6141417pjr.3
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 15:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=QKWjYXFerma2OlVk5dsGDZjSEP28S8+hN7GuH8FnvhQ=;
        b=d1jJCRYGOv1yf1Eu0czHJiIo2g8CpEQ/7DQVIywWMD0fpQ2pZPznVBPILhtzVdNfol
         jlEz8U3FaF4njxzFl6Km4vxqwIkGEUrS5hBbzljafkSVB1zSBgsmnwnHb/n7x8MDsr7F
         9dUqKa3X9kUKFM5J57HAD78RD0Ae3uhnbGQLwQ69UglWEGDzigxtE9MXZi+aA9KUWHIH
         YlotjzQoF89T4F7BYt2ND5zdlWmRf7+qUsEaruTn2GvvspnCOZNM9nbgMcpm+2fn8uB6
         o48x13Q/fEZoA5NbT58rmShHkQbjcyRft2D/RgqwHd3drOlBO2Oom3DT8qiw4fzMZNVu
         7Y2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=QKWjYXFerma2OlVk5dsGDZjSEP28S8+hN7GuH8FnvhQ=;
        b=rT7TBTrqdYVueKhOD6GXHLQ+iq2vNLXxAaR2xhznUwXEhZEWpEqw5pJkr9+rtwtNSB
         Np7YLx5xmArih0+2zW64pMdC1YD6WLfm+P9/is0cGIRdRClmkNWVt3DmcfwXTs4kPihL
         jPCg/OUh56rdU8JdbNZ9HJZnNYvmU1EB0pcbqOP9VgylmJj8gqdOfht8IAMwEbYKtdkP
         9n6YOgry31+yT1LLbaokgwYAlsTO816x/4H1KDcef8D1ip4MyhEHaQnBYuPafO6/RMuB
         P7wMi9g3C4norB2hJvoIX0J5g0bitS5nXIXFCcHIu5QHGVwRWc3uhf6VzYr17M7QwGkd
         AAUw==
X-Gm-Message-State: ACgBeo0Q4pefjbTMAPiBunKA/wi/JCpNCEN/w1N2uqwu24wjp/dhVGK2
        l67Wko/Fj9RinNLSjD5eDP9VZA==
X-Google-Smtp-Source: AA6agR5imnWtDnH5pfSCBTLZjvuN+2i90LICw8y9XU8+0RpdU9Pjk8egWeQerk2OPCbALnVOtY7qfw==
X-Received: by 2002:a17:903:2452:b0:172:cf0a:d137 with SMTP id l18-20020a170903245200b00172cf0ad137mr1119670pls.95.1660949971336;
        Fri, 19 Aug 2022 15:59:31 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a4-20020a1709027e4400b0016d6420691asm3614985pln.207.2022.08.19.15.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 15:59:30 -0700 (PDT)
Date:   Fri, 19 Aug 2022 22:59:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Vipin Sharma <vipinsh@google.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: selftests: Run dirty_log_perf_test on specific
 cpus
Message-ID: <YwAVzzF2dZ2tKOUh@google.com>
References: <20220819210737.763135-1-vipinsh@google.com>
 <YwAC1f5wTYpTdeh+@google.com>
 <CAHVum0ecr7S9QS4+3kS3Yd-eQJ5ZY_GicQWurVFnAif6oOYhOg@mail.gmail.com>
 <YwAP2dM/9vfjlAMb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwAP2dM/9vfjlAMb@google.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 19, 2022, David Matlack wrote:
> On Fri, Aug 19, 2022 at 03:20:06PM -0700, Vipin Sharma wrote:
> > On Fri, Aug 19, 2022 at 2:38 PM David Matlack <dmatlack@google.com> wrote:
> > > I think we should move all the logic to pin threads to perf_test_util.c.
> > > The only thing dirty_log_perf_test.c should do is pass optarg into
> > > perf_test_util.c. This will make it trivial for any other test based on
> > > pef_test_util.c to also use pinning.
> > >
> > > e.g. All a test needs to do to use pinning is add a flag to the optlist
> > > and add a case statement like:
> > >
> > >         case 'c':
> > >                 perf_test_setup_pinning(optarg);
> > >                 break;
> > >
> > > perf_test_setup_pinning() would:
> > >  - Parse the list and populate perf_test_vcpu_args with each vCPU's
> > >    assigned pCPU.
> > >  - Pin the current thread to it's assigned pCPU if one is provided.
> > >
> > 
> > This will assume all tests have the same pinning requirement and
> > format. What if some tests have more than one worker threads after the
> > vcpus?
> 
> Even if a test has other worker threads, this proposal would still be
> logically consistent. The flag is defined to only control the vCPU
> threads and the main threads. If some test has some other threads
> besides that, this flag will not affect them (which is exactly how it's
> defined to behave). If such a test wants to pin those other threads, it
> would make sense to have a test-specific flag for that pinning (and we
> can figure out the right way to do that if/when we encounter that
> situation).

...

> Yeah and I also realized perf_test_setup_pinning() will need to know how
> many vCPUs there are so it can determine which element is the main
> thread's pCPU assignment.

The "how many workers you got?" conundrum can be solved in the same way, e.g. just
have the caller pass in the number of workers it will create.

	perf_test_setup_pinning(pin_string, nr_vcpus, NR_WORKERS);

The only question is what semantics we should support for workers, e.g. do we
want to force an all-or-none approach or can the user pin a subset.  All-or-none
seems like it'd be the simplest to maintain and understand.  I.e. if -c is used,
then all vCPUs must be pinned, and either all workers or no workers are pinned.
