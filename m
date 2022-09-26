Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142A15EB48E
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 00:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiIZW3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 18:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiIZW3B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 18:29:01 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ACA08F977
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 15:29:00 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 129so6373688pgc.5
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 15:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=mPXFdIMVCv2Cxv26tfxCUrpA5sNoQa8+HwyBMNzBJkI=;
        b=dm9krbEW6dEXqzUFhbwRZq63ET+FkvrxR7kXg4IIAawzR/TuCfbLRQBhslSHZzbZah
         4pi/4U7YnAioxb98iiYtV1NnDsbz4CwaXOJ1KPGCOvnTrLprq41bxzN/lb5yxRXDVxiv
         Ou67S0AueIQaejlAAJAeL9DL3pBi0ATyzm/WH4TLGZvU7Ix7xMFQ+JGxmFfDhZHkA3xM
         XvXBCWhzT4kbVp9sP1GDn6qjKlGezZ8TeMn4yoTvAm1DbEcTvbd2aXW7jVgq6wl4WiqO
         HMjSg+7ik6f3xySdw4SqWELYfhTi8bo4F+vzurcVCTXMzHdAOcv2r3Vg6bPF9/b6Gwc5
         1eeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=mPXFdIMVCv2Cxv26tfxCUrpA5sNoQa8+HwyBMNzBJkI=;
        b=6SNGde7eNNbOFc71z+ujqgFTjQgtsp5s980tdTFlkglwkAwhUM2Dfcdagk/SnPzEI1
         hH1kbwodOKUY1OsiHRBZfG9xAnuCJYK+CshIl2vmEymqgnS1uIJ9nz331G8ou4ZgNEYl
         9RwbW+0mCqvzPGQnpUOlM+ICobGcR0Vl8kLDStaXVFh+vSLYsY4x9pU4tyN7W9Yy+Rd6
         NgIWdpMEs6dvJiuju8cQvH6oijZqA7P5XZ44xwWcWXqjf8wH2IIGxCZyxznQRdD7obcE
         kKVIXtfV6z8ASG4p9OJlLBztv2dmm6WDznrInuKHPef3jd+1z80HrDc19iPx/69P0pAe
         /vOg==
X-Gm-Message-State: ACrzQf16IA/bsjqNkWclOQLBUiMtrbdziL1OnJoN36iTA8gIWxLrav/O
        ckBdvZBvnUDR6jh9F5pJHU4X/Q==
X-Google-Smtp-Source: AMsMyM7UGajvB+k0Tfyk4ZPvRVB3YHBVNz0EPP2LcPWct3cqRpLHd41+Z4j3QJymMl9ZE62Et/hfAQ==
X-Received: by 2002:a62:8403:0:b0:540:c1e4:fb31 with SMTP id k3-20020a628403000000b00540c1e4fb31mr25652448pfd.85.1664231339542;
        Mon, 26 Sep 2022 15:28:59 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n9-20020a170902d2c900b00176a47e5840sm11799740plc.298.2022.09.26.15.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 15:28:58 -0700 (PDT)
Date:   Mon, 26 Sep 2022 22:28:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: selftests: Skip tests that require EPT when it is
 not available
Message-ID: <YzInp2jRH7Bq41gV@google.com>
References: <20220926171457.532542-1-dmatlack@google.com>
 <YzIdfkovobW3w/zk@google.com>
 <CALzav=d-4a8yPxPUuHNh1884Z4Pe_0ewMwnunGK_jAAvr9L-vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=d-4a8yPxPUuHNh1884Z4Pe_0ewMwnunGK_jAAvr9L-vw@mail.gmail.com>
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

On Mon, Sep 26, 2022, David Matlack wrote:
> On Mon, Sep 26, 2022 at 2:45 PM Sean Christopherson <seanjc@google.com> wrote:
> > I would much rather this be an assert, i.e. force the test to do TEST_REQUIRE(),
> > even if that means duplicate code.  One of the roles of TEST_REQUIRE() is to
> > document test requirements.
> 
> This gets difficult when you consider dirty_log_perf_test. Users can
> use dirty_log_perf_test in nested mode by passing "-n". But
> dirty_log_perf_test is an architecture-neutral test, so adding
> TEST_REQUIRE() there would require an ifdef, and then gets even more
> complicated if we add support for AMD or nested on non-x86
> architectures.

But you're going to have that problem regardless, e.g. perf_test_setup_nested()
already has

	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));

so why not also have the EPT requirement there?  IMO, it's far less confusing if
the hard requirements are collected together, even if that one location isn't ideal.

If someone wants to improve the memstress framework, a hook can be added for probing
nested requirements.  In other words, IMO this is a shortcoming of the memstress code,
not a valid reason to shove the requirement down in common code.

> Another option is to do nothing and let the test fail if running on
> hosts without EPT. I don't like this solution though

Neither do I.
