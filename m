Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C990C701259
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 01:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240507AbjELXOX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 19:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240400AbjELXOU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 19:14:20 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6DE6E89
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:14:19 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1aaff9c93a5so72719315ad.2
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683933259; x=1686525259;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1H6EM8xufaPPr5pdm8mWkIkZCckbo8Udd6AwnI/w9rs=;
        b=nHe4zvtAxi4WM1mYjs2UBLo1gDMH3BW/ksXqg8zMLX6Y/EWYjABNvMFzVUQU0SWgA6
         pp74bhrrU5bW738VpxWSPcWYURSO4DjJVhoTdxr4YYsnf7zFCxw0E2VTT0/PeACElv+r
         /4yW+yBIGFaqSqAvRJ5vtfpHx8cs4u89kJc7lhSn1xOF5TUb3zqkP3JF61lI41+aH0SG
         VqLhSMDN/mQNN8pV07wVuCFSmIvJEwUB0TadBoiduJ27ZzVtC/k1YzTH2iRNiTvmlK1t
         LRs/P3Y8tcCI4xAdAXrhxsxKJ8w2yZEHfwxb9GsOo2jv26GrLJ02WxZtY8tKPoPqb1Mq
         FsAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683933259; x=1686525259;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1H6EM8xufaPPr5pdm8mWkIkZCckbo8Udd6AwnI/w9rs=;
        b=GRTwo/usil7y2k1fpXARgs1H+UfXwt4ieETSy+sTrlJjKIi7PzupNlai2Vcon4j9AJ
         hQSrXdWQNCxcwHF9oY6fazq4cQhG2EHfaq19pN2i6QCBs3ktakpPpcq0MtSsjKJME+4q
         mBvt/pxswdjzJXoiqUbLfSzpIHfP2VgzAnef6+uH7bpZoktxyXINMYCz0x0XewieUkQU
         mqbKSOoHJ1WmC4+Qez9zZm3JSN0ABbp2nSN+KbwJIvt6NG33vkaYvtSvzrmF/B9P0gtN
         lf6xel6hZwq7c805uAm4ZWmfHv97+aeKXts7qcVIlDtKzxakMWWP82qO21PmKIvbOk92
         SJtg==
X-Gm-Message-State: AC+VfDykKU/OvxiFa4j0+PkiHmb0pTpkFJTjqKJk37EARL5tE8kb1FGL
        N9RhAptNzeCx2qd7HNxM2RWv7RshYYIOYtzPyn3xhA==
X-Google-Smtp-Source: ACHHUZ6MzVO+JGy2uy6SwJYKtJHHvOBosgAemLqSMpVXHZoKmk5/T31lD+xTJSstu6ChgbghLkJsrg==
X-Received: by 2002:a17:902:e88e:b0:1ac:451d:34b with SMTP id w14-20020a170902e88e00b001ac451d034bmr35777301plg.9.1683933258648;
        Fri, 12 May 2023 16:14:18 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id a10-20020a170902ee8a00b001a9873495f2sm8486981pld.233.2023.05.12.16.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 16:14:18 -0700 (PDT)
Date:   Fri, 12 May 2023 16:14:13 -0700
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 5/9] KVM: x86/mmu: Convert "runtime" WARN_ON() assertions
 to WARN_ON_ONCE()
Message-ID: <ZF7IRQZo8g7Lg46V@google.com>
References: <20230511235917.639770-1-seanjc@google.com>
 <20230511235917.639770-6-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511235917.639770-6-seanjc@google.com>
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

On Thu, May 11, 2023 at 04:59:13PM -0700, Sean Christopherson wrote:
> Convert all "runtime" assertions, i.e. assertions that can be triggered
> while running vCPUs, from WARN_ON() to WARN_ON_ONCE().  Every WARN in the
> MMU that is tied to running vCPUs, i.e. not contained to loading and
> initializing KVM, is likely to fire _a lot_ when it does trigger.  E.g. if
> KVM ends up with a bug that causes a root to be invalidated before the
> page fault handler is invoked, pretty much _every_ page fault VM-Exit
> triggers the WARN.
> 
> If a WARN is triggered frequently, the resulting spam usually causes a lot
> of damage of its own, e.g. consumes resources to log the WARN and pollutes
> the kernel log, often to the point where other useful information can be
> lost.  In many case, the damage caused by the spam is actually worse than
> the bug itself, e.g. KVM can almost always recover from an unexpectedly
> invalid root.
> 
> On the flip side, warning every time is rarely helpful for debug and
> triage, i.e. a single splat is usually sufficient to point a debugger in
> the right direction, and automated testing, e.g. syzkaller, typically runs
> with warn_on_panic=1, i.e. will never get past the first WARN anyways.

On the topic of syzkaller, we should get them to test with
CONFIG_KVM_PROVE_MMU once it's available.

> 
> Lastly, when an assertions fails multiple times, the stack traces in KVM
> are almost always identical, i.e. the full splat only needs to be captured
> once.  And _if_ there is value in captruing information about the failed
> assert, a ratelimited printk() is sufficient and less likely to rack up a
> large amount of collateral damage.

These are all good arguments and I think they apply to KVM_MMU_WARN_ON()
as well. Should we convert that to _ONCE() too?
