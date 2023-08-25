Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADC7788F18
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 21:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjHYTDG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 15:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbjHYTCi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 15:02:38 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB4C2129
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 12:02:36 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-26d5970cbdbso1148991a91.0
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 12:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692990156; x=1693594956;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1uQBcA29mNosCv8SGMH5eY1mYNGPfU9Gh/X2jA13FnI=;
        b=D4CXpzzntvbuW2kul1V6/adtqvLb8fxpZJ5FhGOMP05Eocjn38ATqNfAfea9jr2qRl
         d1CeyO8v+9Bqmh3kkem+Mo7NwppCd4My5LH5slBNbO5q5kPfl0Q2vhDJt6einSWoM6sV
         vY2StzAJPJerS/hIhUJKogbIrVioWdLuDYOFKvPRw+GldJwgFxOm/nTTyKFxLE184qXT
         nGNduKM/RW8Gpcjgn9x9Egr5xS03CgnjMkNyShHwxzND8JU75MiSGJMOCwIXoDL3rmd6
         SdNRGBQxU1qaq796ddnYom0w+uiZ8JCjHcAU+qAnpn4OxSdGY4+CRW3VfLVruhifmmaB
         o5Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692990156; x=1693594956;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1uQBcA29mNosCv8SGMH5eY1mYNGPfU9Gh/X2jA13FnI=;
        b=PRxmxlN8bbKd/s/efNRI040oAcMhPXz2YdQmx2khjtb/wHML02imsoiBt8M3odpCKH
         AICIH8Fprp7LbVNitgUIAsca4kR/n9BVQfXxrycW6s1K5goQIK9ol1eTQhoDUxptfG3c
         80kmDX0WKejAorwEdTs3vzgRkJvWjFlNidtG5TbhwJBuVhKgPRmhMnyIJgtfFhmJ1ZF/
         s7Y7Q9d9Rye4WpAvuA6omL/2LmNNGdbsmk6YAgOImimNvGGLr44HdNRboF8egHc6dXJx
         eWiwrSC3rKbsEhn6NG8yqurPKrNc4IaMVDqaHiaHkjgkQesxlq8ZeJfBYiD+vddCDgOk
         rWUQ==
X-Gm-Message-State: AOJu0YxJXg94KyXARHRvx1oAZWvsj26rx6/Ur6CVtH+WvrTxhoAhQ+Ma
        MNixgwGfbh89oWPwoKkIa5vKDprpsbw=
X-Google-Smtp-Source: AGHT+IFK8EE90d4Xw8A+M7LnbkAZk4ZTB9AadIN8Ve3ePLDd9mPPK5DF64J7kl1Ci/rIEWsZo4eq+mHZUVc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1011:b0:268:5ad0:cdcc with SMTP id
 gm17-20020a17090b101100b002685ad0cdccmr4611067pjb.1.1692990156392; Fri, 25
 Aug 2023 12:02:36 -0700 (PDT)
Date:   Fri, 25 Aug 2023 12:02:09 -0700
In-Reply-To: <20230825013621.2845700-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230825013621.2845700-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <169297925407.2870848.7136723526525176171.b4-ty@google.com>
Subject: Re: [PATCH v2 0/4] KVM: SVM: Fix unexpected #UD on INT3 in SEV guests
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wu Zongyo <wuzongyo@mail.ustc.edu.cn>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Aug 2023 18:36:17 -0700, Sean Christopherson wrote:
> Fix a bug where KVM injects a bogus #UD for SEV guests when trying to skip
> an INT3 as part of re-injecting the associated #BP that got kinda sorta
> intercepted due to a #NPF occuring while vectoring/delivering the #BP.
> 
> Patch 1 is the main fix.  It's a little ugly, but suitable for backporting.
> 
> Patch 2 is a tangentially related cleanup to make NRIPS a requirement for
> enabling SEV, e.g. so that we don't ever get "bug" reports of SEV guests
> not working when NRIPS is disabled.
> 
> [...]

Applied 1 and 2 to kvm-x86 svm, the more aggressive cleanup can definitely wait
until 6.7.

[1/4] KVM: SVM: Don't inject #UD if KVM attempts to skip SEV guest insn
      https://github.com/kvm-x86/linux/commit/cb49631ad111
[2/4] KVM: SVM: Require nrips support for SEV guests (and beyond)
      https://github.com/kvm-x86/linux/commit/80d0f521d59e

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
