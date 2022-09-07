Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBB95B086E
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 17:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiIGPXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 11:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbiIGPXm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 11:23:42 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E6BB5E7C
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 08:23:35 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id l65so14971475pfl.8
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 08:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=elOH+JLzsRj2hp7qpmu5hXAZbwrx+YYUSddUDllKjYI=;
        b=haTnwZ3R+RJ5ctOBFiNoavEV+gd/bFgTwIDiybIoO8CXQ4SBqk9IyvfetVBdhumftM
         Jm/G+b1UlzMIoGXIz3pB5kiDoH06iB1JNZkx0V46RfJ+TRHBf107+7WVBPKmAlEWDvEz
         QoXkosQWz6goE22Irj2o+z/FhV6NN6m3pvBms/tw7282ekHbcvBGBB2cbMPQDEhIKmeQ
         iiwg6ebCzNzMOGoGIW4hEijt6dAhW5pkM2KzkRANxeas+9xv/8waM+bMsa3ucU+cAiL+
         mTsdRXYDq5t8cfBvjbqYSCu5HY4T1OGItHXz7Jc7a7A7GdKgrzxek0x5VslTrl5FVYQB
         lcmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=elOH+JLzsRj2hp7qpmu5hXAZbwrx+YYUSddUDllKjYI=;
        b=mqUO1pYd4rt4Mq96zjKIpjR842P9yLO38/X6uTgcV+QQLEEJWGCeSPgA6rG2B5FWhT
         Zf36HOrh0kZKvUqrCTlNcaOSSpUky6jF9I7zrtSHIMRWEML5GFx8KPQfNDzUjKwI+z9M
         OaHSVRdC/xn/nogfaA4PFY34FDrd2YzAGwSLWr6tLBBmCx1UHcOrLExqX8Mmm3GFgUbZ
         EYenzeIXGR6N6iymg3p42DOGuOZoOtPaUA061JF/j9m4bIzj64hKJ9mNZ3EinPGKXyzz
         xmGzfJ6YOqqmnR/R+h2UdfcP71UQX4pAQgAJQkDJ1dvZUvwKnmhr3GBkpoFhXzTyyrXC
         XkbA==
X-Gm-Message-State: ACgBeo2TB+oeDDfBIG6fVw6XZyiTfIzZQW5cGMgyahd5tzkvVviv/Cdy
        62mBEimZ+pieIIUMw22I0K+hGq7W7Aoi1w==
X-Google-Smtp-Source: AA6agR7oc+nAM04Wa3IkXCXz7cLHY7kX/94tosfbrTixnkpwhZ+YR2aMsaAoY+kp2Ja908r3AR7FxA==
X-Received: by 2002:a63:484b:0:b0:41d:9ddd:ade with SMTP id x11-20020a63484b000000b0041d9ddd0ademr3718385pgk.540.1662564214728;
        Wed, 07 Sep 2022 08:23:34 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id lx8-20020a17090b4b0800b002002014039asm9169144pjb.6.2022.09.07.08.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 08:23:34 -0700 (PDT)
Date:   Wed, 7 Sep 2022 15:23:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     =?utf-8?B?RnJhbnRpxaFlayDFoHVtxaFhbA==?= <frantisek@sumsal.cz>
Cc:     kvm@vger.kernel.org
Subject: Re: BUG: soft lockup - CPU#0 stuck for 26s! with nested KVM on 5.19.x
Message-ID: <Yxi3cj6xKBlJ3IJV@google.com>
References: <a861d348-b3fd-fd1d-2427-0a89ae139948@sumsal.cz>
 <Yxiz3giU/WEftPp6@google.com>
 <a8fc728c-073c-2ff5-2436-40c84c3c62e1@sumsal.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a8fc728c-073c-2ff5-2436-40c84c3c62e1@sumsal.cz>
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

On Wed, Sep 07, 2022, František Šumšal wrote:
> On 9/7/22 17:08, Sean Christopherson wrote:
> > On Wed, Sep 07, 2022, František Šumšal wrote:
> > > Hello!
> > > 
> > > In our Arch Linux part of the upstream systemd CI I recently noticed an
> > > uptrend in CPU soft lockups when running one of our tests. This test runs
> > > several systemd-nspawn containers in succession and sometimes the underlying
> > > VM locks up due to a CPU soft lockup
> > 
> > By "underlying VM", do you mean L1 or L2?  Where
> > 
> >      L0 == Bare Metal
> >      L1 == Arch Linux (KVM, 5.19.5-arch1-1/5.19.7-arch1-1)
> >      L2 == Arch Linux (nested KVM or QEMU TCG, 5.19.5-arch1-1/5.19.7-arch1-1)
> 
> I mean L2.

Is there anything interesting in the L1 or L0 logs?  A failure in a lower level
can manifest as a soft lockup and/or stall in the VM, e.g. because a vCPU isn't
run by the host for whatever reason.

Does the bug repro with an older version of QEMU?  If it's difficult to roll back
the QEMU version, then we can punt on this question for now.

Is it possible to run the nspawn tests in L1?  If the bug repros there, that would
greatly shrink the size of the haystack.
