Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E8D750DB6
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbjGLQM0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbjGLQMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:12:25 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87651BF1
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:11:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ca48836fec5so715640276.3
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689178302; x=1691770302;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jUTKveXRPyLPHLkVKvmFTziE4B+NDus/75xf0DkHGe0=;
        b=LXQXMaFMV7pPyOMePG4Vf89vY4jUnQXjuSq2D27W5tED/0cZpSK/S5xod8YmliJe8i
         4YihG5B1pEKqxQeQfyWLBovG1Ov71fagz0sok8Ng+h7DXqVEexClbCd+HVrFHsiCwEyJ
         ApWw3btGejBn8ymD4TUY1sXer4CRs1jp936OfV82x/jXM9NexwTarEZ4TEJv7ngMbRyP
         i6rS3K2mVGrv0Ge6c+Z3UztxgJ+7t64OmQ+2aFsif76IO9T7MsCnQSQvqRZqzyo4ffbK
         5F7NMTu22lQPV+eqB1O5IXO7XGGIhMFcXd9IPdfqiRxmNbdVG4KwrZcqQbicRlmU1RL+
         InpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689178302; x=1691770302;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jUTKveXRPyLPHLkVKvmFTziE4B+NDus/75xf0DkHGe0=;
        b=Xqm1NY0H3PPbrNZTVNsgcER0McpJThzs7efbARP5HxmRmBH7gIAxEEMq/x6W3x865q
         ds/bGZiBfaXSsJ2Aj6MwJoYf52vQqCkLWRus1cZ8z98X2Swn13ZzGBYji/phLPcN5iy8
         5c34UG9Ae91Bnpy+YRgQixiTAhTUEbndH1UewTow2MpXQ6+rR0eFOlcHMYDe12lpo7OQ
         97bMNyp3SHDY7jEvn5WTG3AByMIN1LWeuAREMuEyKcUr9VsSjRZi7msJxMniaGOJC9fi
         qrw3iT9G1NqFIMO0p9tEUXf1RI8JFT4qfe46PrFbk/xLbdG8pYgYA43xxOlhON4KtLM2
         kQlA==
X-Gm-Message-State: ABy/qLZ0DAP0xvZ2coPJE4Kx1xuCIqt/7qnJKNm2HFzLqng7vD5CVbT+
        riJi25BZoJ75hwUlXdxz8VzbeSQjNhw=
X-Google-Smtp-Source: APBJJlFVcvLQkVS45NrzBmJkFvBrCw7Xlwqb87hH0td+AdvTOe3wWR2jdpyyygwxI2MOPFdnkRZWvaIrTS8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ccc2:0:b0:c41:4696:e879 with SMTP id
 l185-20020a25ccc2000000b00c414696e879mr165043ybf.7.1689178302438; Wed, 12 Jul
 2023 09:11:42 -0700 (PDT)
Date:   Wed, 12 Jul 2023 09:11:40 -0700
In-Reply-To: <81c32ae2-ff21-131f-e498-f87b1e7fe3b5@gmail.com>
Mime-Version: 1.0
References: <20230607010206.1425277-1-seanjc@google.com> <20230607010206.1425277-5-seanjc@google.com>
 <81c32ae2-ff21-131f-e498-f87b1e7fe3b5@gmail.com>
Message-ID: <ZK7QvMrGJ9HzJLPG@google.com>
Subject: Re: [PATCH 4/4] KVM: x86/pmu: Move .hw_event_available() check out of
 PMC filter helper
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 12, 2023, Like Xu wrote:
> On 2023/6/7 09:02, Sean Christopherson wrote:
> > Move the call to kvm_x86_pmu.hw_event_available(), which has nothing to
> > with the userspace PMU filter, out of check_pmu_event_filter() and into
> > its sole caller pmc_event_is_allowed().  pmc_event_is_allowed() didn't
> > exist when commit 7aadaa988c5e ("KVM: x86/pmu: Drop amd_event_mapping[]
> > in the KVM context"), so presumably the motivation for invoking
> > .hw_event_available() from check_pmu_event_filter() was to avoid having
> > to add multiple call sites.
> 
> The event unavailability check based on intel cpuid is, in my opinion,
> part of our pmu_event_filter mechanism. Unavailable events can be
> defined either by KVM userspace or by architectural cpuid (if any).
> 
> The bigger issue here is what happens when the two rules conflict, and
> the answer can be found more easily by putting the two parts in one
> function (the architectural cpuid rule takes precedence).

I want to clearly differentiate between what KVM allows and what userspace allows,
and specifically I want to use "filter" only to describe userspace intervention as
much as possible.

Outside of kvm_get_filtered_xcr0(), which I would classify as userspace-defined
behavior (albeit rather indirectly), and a few architecturally defined "filter"
terms from Intel and AMD, we don't use "filter" in KVM to describe KVM behavior.

IMO, there's a lot of value in being able to associate "filter" with userspace
desires, e.g. just mentioning "filtering" immediately frames a conversation as
dealing with userspace's wants, not internal KVM behavior.
