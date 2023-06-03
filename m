Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1271B720CB7
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 02:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236954AbjFCAxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 20:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236945AbjFCAxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 20:53:21 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B790E4C
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 17:53:06 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-babb79a17b8so3454029276.0
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 17:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685753585; x=1688345585;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=US4vHwNOcm3/zMnVF1blo1rgU4JeS0wRpb0+OG6CxyU=;
        b=n1aqXE43vnadMoQue8MwOBH7UzzRGNU4a7MYwWJEgxtSRqhEg3u2pTBB6HBu6ixRhc
         1z09YLLoFo6iFOIMmz4+V/8t6PUNqu3jcL5vagc4ijr6WBc33tXSMNEyI2Ru+To6zZxG
         4MXGazcSn/HjpZcvldbLNW1egIH4LJJW9WcMDqNUYHF11Nv+FJMbupqMEpBjvqSrHgO4
         c6elvg9n9pBKuXV8fBzGTQTerProyvnmFGqNZe1IiAS+eHPE9QgDcee8XF3cay1tz50e
         f5to9zAYA26RqCUL6bUvHnEDWNNhRelMvXrPrWgphncVBr5kC7uFJMU/rmIzvwwJGMsC
         Rpbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685753585; x=1688345585;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=US4vHwNOcm3/zMnVF1blo1rgU4JeS0wRpb0+OG6CxyU=;
        b=BVB9vcSDCAAx/CMpHLkF5+iBUsM+Qfw2XAFFmYNlKpDMj98Ak8zdsSLLRzNtFbQQap
         ImYeuAqub+zkpCtzhE2TGMeyihkIKbdTiNoL9iXklOmNsAamZm7k+MQiow4pr9u5cear
         N4narmmTnmmNbDeagNxuBnfg+P+e3f17aE5qNokykUEpA2hzt6en/iQ0oECYcWiFHFeR
         9bOGq4XtWgM0gMwABygqPOR3A2QbyST8XNUVdN2ZXVQmqOewXUlzbSk+sTVsNRSkQtR2
         JKNiCE7HJ0Jh57zglmmomEUqy5pdlUXAU6B9tyEXvkjk1MMT8/NVdzixR/LNOn17I8QZ
         +flA==
X-Gm-Message-State: AC+VfDwYssoHiZUdThupMzmzzOepMC7KgC4tYi+KAaZOVbsTUV5edx5D
        CON43X19bUWGmflT5MTaeSxZiQE1kA8=
X-Google-Smtp-Source: ACHHUZ7mLA1RGKqYc/9z4KiEVtFUM1M+06Ebd3MgrKbFHDLx1gYQ3SqMWbBe2PSpTk5HvI4USPTSP1oJluE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1009:b0:ba8:2e69:9e06 with SMTP id
 w9-20020a056902100900b00ba82e699e06mr2756914ybt.1.1685753585343; Fri, 02 Jun
 2023 17:53:05 -0700 (PDT)
Date:   Fri,  2 Jun 2023 17:52:26 -0700
In-Reply-To: <20230602011920.787844-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230602011920.787844-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <168574913785.1016961.3776399676561784984.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: x86: Fastpath accounting fixes
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 01 Jun 2023 18:19:18 -0700, Sean Christopherson wrote:
> Fix two bugs where KVM fails to account/trace exits that are handled
> in the super fast fastpath.  SVM doesn't actually utilize the super fast
> fastpath, i.e. patch 1 only affects VMX and the bug fixed by patch 2 is
> benign in the current code base.
> 
> Found by inspection, confirmed by hacking together a small selftest and
> manually verifying the stats via sysfs.
> 
> [...]

Applied patch 1 to kvm-x86 fixes (for 6.4), and patch 2 to kvm-x86 svm (for 6.5).
Should have posted these separately...

[1/2] KVM: x86: Account fastpath-only VM-Exits in vCPU stats
      https://github.com/kvm-x86/linux/commit/8b703a49c9df
[2/2] KVM: SVM: Invoke trace_kvm_exit() for fastpath VM-Exits
      https://github.com/kvm-x86/linux/commit/791a089861fc

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
https://github.com/kvm-x86/linux/tree/svm
