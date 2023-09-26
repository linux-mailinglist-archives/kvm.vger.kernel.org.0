Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBAA57AF510
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 22:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235840AbjIZU1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 16:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234245AbjIZU1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 16:27:37 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1119B136
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 13:27:31 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59f8134ec00so96265327b3.3
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 13:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695760050; x=1696364850; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EdU4ik3Tu4D+QwzpIlWNvwrHhBoMHXPt/qFjpNSs+BU=;
        b=r5gZQuvgtOa92Je7jWNmHORi3S8iCWLY++wgRBSa6bMVvN7EQm0SaOkKP1oJNdwPf9
         x2oVpkMEVwwA3PWN1LgVV7CPvGGl836kBmFrcX35i61LpE4n39PjiuaqTC0O1tt0kFu/
         0Ipp7EwvoykDpAX1FD7q7v4zRPer448+MxmTQBjq3cDvFRSwYzueZwDymtkW1lDkf9h5
         CMLCD/9OYIQGG2/gtukKiNz4Q8o1+ZD5ZDl/+Cf/gazuCqO4D2hLm7PMTrI9vYaiYqTh
         Zc43oeS1DxuJ0Xji7zHGjSYL1Gl19Rc/cLLhhFojdDna5ajIdVYtudwXfI+D/6YJsnWY
         8HVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695760050; x=1696364850;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EdU4ik3Tu4D+QwzpIlWNvwrHhBoMHXPt/qFjpNSs+BU=;
        b=U8fKdJNEHQNY72qYasJHuWKer0218XyAOXYEHcrQfB6NauXezALp6ZDh/SVE4QoZK5
         IHyS1gPzW59jtA1UvsWuiEcnDbeDmhb7Cjiuh4c4Z/pBL/Dhw8Ol2MvUpzcW86tSKFGe
         Hgqtiq6OToseMkkSojFBOWkB+g7KtgX7UHQ8BGdEZgpl26gOoE1TcWk0pMXU9DGk4kkZ
         rtStOZaRy9guKPmmx/dIk5cbV/bGmqbRRNrM34P363xCe4oTgfeFRB+sb20jSZXsebua
         20wWIgdZRsC8RngB2xWNV1QyqspQNe07ajat1idXgHc/se0me1CZXSt4izhnHxQ1Nijf
         gSYQ==
X-Gm-Message-State: AOJu0YyiFPtzCKC7jno3m7Yie1Y+QCStbOUZmGP1jWQ06R437l3m6lm+
        88cK0NI9NzadsP7FiBimyuiCcRaYY2k=
X-Google-Smtp-Source: AGHT+IFPOQAdc8TRe/tImSYB9Fu0OTGHqt/zZjOX/Assxkqq9ECMf/QKfiMqacQf21wAW/sGgFNTh0KJYa8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:e345:0:b0:59b:db15:498c with SMTP id
 w5-20020a81e345000000b0059bdb15498cmr572ywl.10.1695760050193; Tue, 26 Sep
 2023 13:27:30 -0700 (PDT)
Date:   Tue, 26 Sep 2023 13:27:28 -0700
In-Reply-To: <ZRMvd7ZKT6PXDLeK@google.com>
Mime-Version: 1.0
References: <ZQKzKkDEsY1n9dB1@redhat.com> <ZQLOVjLtFnGESG0S@luigi.stachecki.net>
 <93592292-ab7e-71ac-dd72-74cc76e97c74@oracle.com> <ZQOsQjsa4bEfB28H@luigi.stachecki.net>
 <ZQQKoIEgFki0KzxB@redhat.com> <ZQRNmsWcOM1xbNsZ@luigi.stachecki.net>
 <ZRH7F3SlHZEBf1I2@google.com> <ZRJJtWC4ch0RhY/Y@luigi.stachecki.net>
 <ZRMHY83W/VPjYyhy@google.com> <ZRMvd7ZKT6PXDLeK@google.com>
Message-ID: <ZRM-sI_KSghTGXYP@google.com>
Subject: Re: [PATCH] x86/kvm: Account for fpstate->user_xfeatures changes
From:   Sean Christopherson <seanjc@google.com>
To:     Tyler Stachecki <stachecki.tyler@gmail.com>
Cc:     Leonardo Bras <leobras@redhat.com>,
        Dongli Zhang <dongli.zhang@oracle.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, dgilbert@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com, bp@alien8.de,
        Tyler Stachecki <tstachecki@bloomberg.net>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023, Sean Christopherson wrote:
> There's another related oddity that will be fixed by my approach, assuming the realloc
> change is also reverted (I missed that in my pasted patch).  Userspace *must* do
> KVM_SET_CPUID{2} in order to load off-by-default state, whereas there is no such
> requirement for on-by-default state.

Scratch that, KVM explicitly requires KVM_SET_CPUID2 to grant the guest access to
off-by-default features, e.g. so that the kernel/KVM doesn't need to context AMX
state if it's not exposed to the guest.  Thankfully, that has always been true for
XFD-based features, i.e. AMX, so it's safe to keep that behavior even though it
diverges from on-by-default features.
