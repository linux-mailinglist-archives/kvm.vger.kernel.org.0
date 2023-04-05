Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792A86D8717
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 21:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjDETmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 15:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbjDETmV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 15:42:21 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64446EA6
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 12:41:58 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j11-20020a25230b000000b00b6871c296bdso36166448ybj.5
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 12:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680723715;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=D9Q4GD2QPGOva7RvqFAPDAkxNzlyH0URb79YtuVE0ig=;
        b=p6+bROWgidmq+3NmybkuWFFLsskbLz+KiwiS4NTI2dKXC/NHOtEdJMg34Nq90NO0Uk
         AISqQuG9e8nD1cx9MI3RcLk4q+wodqaLQ7zBJaVB3cncFsGl1pzTJiPTiwo59sQmUAiN
         KwaQsVqbe2YZq7lNiaCLN0tgS1sdV9qTh1xykrdsQP77KHcIgMWh6126I7ZXKhTxiA5C
         bQTXxoHuTV2l1pxYaNJwSp4A385pajmJzu6YCFya64pdM4laJ8QA+WyUhl5BG7XdQQgl
         2OyPvdmPwbuzUV5K5m5M/NqzUR/+ZEsX0A14le+vhdfOgkeaFf358jSNAJb8s6CyVfI8
         5FMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680723715;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D9Q4GD2QPGOva7RvqFAPDAkxNzlyH0URb79YtuVE0ig=;
        b=25Wzk/rstkwrKJbj8zosFJfaABFhjBXia6d6sdaZLZg6EYYqvNLZcsqUr+EIyOqire
         hoGm0YCJ45sLmZo6maLDwud9u6JBGME61agoFO6goPoXiN/WWgVTnf0EzoP3H7iGERyZ
         tKdY9hb/KygiQPDJpdmqmA/0FAwxZ76e4Pitl26V3NbJLttNN7QOvKGPNTC9HvN9zRG0
         ix0Q22Xbbn9c1JqVJkUq9cEAeKr9N8rxL91xl6ltjdYwqqdxWlPRTtEXF3lTt16QcM0E
         UVfZMSdg8ZxB7moSFcsAIi1VGFNEfnHbIpXCFKa+ijma5KwjiYTmV26qb3lwtes/vopc
         yqEA==
X-Gm-Message-State: AAQBX9fX45H1VuWFTew2GFwMTTqxDbWDxRMTH18VDSqObRF35ra5ALfO
        X3jPqFLvht432VarAaFcFAe88vzNvZc=
X-Google-Smtp-Source: AKy350bZCB4gaYe3OpokETo/h/8efH3hud6jt+UsWPpLLo+J2o5R6MCv4hpEKPhlaxlJJh81SHBrMh0TUnk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:12c7:b0:b26:884:c35e with SMTP id
 j7-20020a05690212c700b00b260884c35emr318170ybu.4.1680723715043; Wed, 05 Apr
 2023 12:41:55 -0700 (PDT)
Date:   Wed, 5 Apr 2023 12:41:53 -0700
In-Reply-To: <f8d26a55-2371-241e-6165-24b6a04c2243@grsecurity.net>
Mime-Version: 1.0
References: <20230404165341.163500-1-seanjc@google.com> <20230404165341.163500-7-seanjc@google.com>
 <6fcaf791-da24-fae7-af03-3e19a781fd26@grsecurity.net> <ZC2FwphMDTz3ESLQ@google.com>
 <f8d26a55-2371-241e-6165-24b6a04c2243@grsecurity.net>
Message-ID: <ZC3PAX5SHkg/dxlU@google.com>
Subject: Re: [kvm-unit-tests PATCH v4 6/9] x86/access: Try forced emulation
 for CR0.WP test as well
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 05, 2023, Mathias Krause wrote:
> On 05.04.23 16:29, Sean Christopherson wrote:
> > On Wed, Apr 05, 2023, Mathias Krause wrote:
> >> On 04.04.23 18:53, Sean Christopherson wrote:
> >>> @@ -1127,6 +1128,10 @@ static int check_toggle_cr0_wp(ac_pt_env_t *pt_env)
> >>>  
> >>>  	err += do_cr0_wp_access(&at, 0);
> >>>  	err += do_cr0_wp_access(&at, AC_CPU_CR0_WP_MASK);
> >>
> >>> +	if (!(invalid_mask & AC_FEP_MASK)) {
> >>
> >> Can we *please* change this back to 'if (is_fep_available()) {'...? I
> >> really would like to get these tests exercised by default if possible.
> > 
> > "by default" is a bit misleading IMO.  The vast majority of developers almost
> > certainly do not do testing with FEP enabled.
> 
> Fair enough. But with "by default if possible" I meant, if kvm.ko was
> already loaded with force_emulation_prefix=1, the CR0.WP access tests
> should automatically make use of it -- much like it's done in other
> tests, like x86/emulator.c, x86/emulator64.c and x86/pmu.c. Or do you
> want to change these tests to get a new "force_emulation" parameter as
> well and disable the automatic detection and usage of FEP support in
> tests completely?

In an ideal world, the access test would use FEP if it's available, i.e. not make
it a separate test case.  The unfortunate reality is that the runtime is simply
too long to do that for the test as a whole.

> > The goal is to reach a balance between the cost of maintenance, principle of least
> > surprise, and test coverage.  Ease of debugging also factors in (if the FEP version
> > fails but the non-FEP versions does not), but that's largely a bonus.
> 
> It's a bonus on the test coverage side, IMHO. If the FEP version fails
> but the non-FEP one doesn't, apparently something is broken somewhere
> and should be fixed.

For sure.  What I'm saying is that on my end, I can skip a non-trivial amount of
triage/debug if "access" passes but "access_fep" fails.  That info _should_ also
be captured in the log, but not all CI setups actually do that, e.g. the "official"
gitlab based CI doesn't capture logs (and it's a giant pain).  But again, this is
not a primary motivator, it's just a happy bonus.

> > Defining a @force_emulation but then ignoring it for a one-off test violates the
> > principle of least suprise.
> 
> Do we need additional parameters for PKU / SMEP / SMAP / LA57 as well or
> leave the automatic detection in place? </rhetorical question>
> 
> We only need the "force_emulation" parameter because the ac_test_bump()
> loop is so much slower with forced emulation. That's the only reason for
> it to exists. We can rename it to "full" and do the force emulation
> tests for ac_test_exec() if FEP is available. But just excluding some
> (cheap) tests because some command line argument wasn't provided would
> be surprising to me. Tests should be simple to use, IMO.

Look at it from the perspective of someone who has never run these tests and has
no clue what the test does, let alone the gory details of FEP.  The most straightforward
interpretation of force_emulation=false is that the test does not force emulation,
thus having a one-off testcase that forces emulation anyways would be surprising.

E.g. imagine being the person that discovered the VMX #PF test failed because of
the KVM bug where the emulator barfs on a NOP for L2.  Before they even get near
the KVM bug itself, the person would be wondering why on earth a NOP is getting a
#UD.  They would likely then discover FEP and ask the obvious question of why the
test is trying to use FEP even though forced emulation is allegedly disabled.

That can obviously be solved by comments to explain what "full" means, but as below,
I would prefer to avoid that if possible.

> > Plumbing a second param/flag into check_toggle_cr0_wp() would, IMO, unnecessarily
> > increase the maintenance cost.  Ditto for creating a more complex param.
> 
> Fully agree, no need for additional parameters. The existing one should
> simply be renamed to "full" and just control ac_test_exec()'s behavior.
>
> > I doubt most CI setups that run KUT enable FEP either.  And if
> > CI/developers do automatically enable FEP, I would be shocked/saddened if
> > adding an additional configuration is more difficult than overiding a
> > module param.  E.g. I will soon be modifying my scripts to do both.
> 
> Well, the force emulation access tests take a significant amount of time
> to run, so will likely be disabled for CI systems that run on a free
> tier basis. But do we need to disable the possibility to run the corner
> case test as well? I don't think so. If some CI system already takes the
> effort to manually load kvm.ko with force_emulation_prefix=1, it should
> get these additional cheap tests automatically instead of having the
> need to carry additional patches to get them.

If that ends up being the case then I'm totally fine tweaking the param to gate
only the main loop, but my preference is to wait until it's actually a real
problem.  I.e. take on more complexity, even though it is minor, if and only if
we really need to.
