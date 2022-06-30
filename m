Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2CF561A2F
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 14:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbiF3MR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 08:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232946AbiF3MRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 08:17:54 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0282F25C79
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 05:17:54 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id y77so25777983oia.3
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 05:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u5tIsV8u+afIygl4LGgEyn31BQu6or2e1DFLWifTLb4=;
        b=jkzg5f2lhbm9TiiTnMcXrVL0ddpAEo0ONr55x2LPbQ7RwoW7IC5NcmcPHxSOzEHAow
         Ps2NxV7cVGZbfP5sdtkitqxI6vFndhWpt1/BzNLmL6h7wTK8qg4xT1+3ctkx/oxEOOlq
         DXQ25fVLXxUYW6UGY/sIS2clU66jysClPKkREMY/pm5IVcedyqRMXDC7j65wMVnC6xLN
         d7NbAmAofDZfK/XU6fkB89yvuhu/Xk/7+ukueh1sdIfCfWZ9b4Iyge88zeqMRnvkV7bJ
         OZCstgXDwLxwDsDa8MjcYM/Wb/mAf2U7ILmTTCpeJgpxYN/b4THAmM7jIC9txi015/TG
         sexg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u5tIsV8u+afIygl4LGgEyn31BQu6or2e1DFLWifTLb4=;
        b=PGUZbTvXaZkQtG/blUeGXKTUB3mEQPIHjenlcz7C8sZ7o1qs6oiu0UjZ4lMFSAbqTt
         vk2huF89SCAO75ocu50d5G0WS8ecvghAiff2Dt8UlJcELurnvy++fqTXRkXNLpgyEaO8
         dQV7VGuJmf2w3ssM1glkrYm3BTEkBHXOWrggIGdsGlqEYZd5qWssBvTwBytabvhHbedj
         gcN7254fbxnLW0GLcSw6Gr3spHdqHyoKCKyzqTAEmA5D5RroerB90NO8KmLsexxtyfpX
         yLnIkz5lM5H6S8W2nQH4BjOrmzgyd8nVZOqE5nTdj5g/Uc4BrE29FZPJPso3QfeWH2lC
         E+dQ==
X-Gm-Message-State: AJIora86g98sZHRKUWElNGluxGpHWOmaee/RCY1SRVKIOGZIo6QmK0/7
        8A90IFY4Nbmcxj0mXT/YIsRdSwrF7Bf/igsDNLYNPQ==
X-Google-Smtp-Source: AGRyM1ugUxFgtkvnaPkLMhDnfpFG/0QasMyvUj7YGbvR8PEB+1f1ON7P1y7gzi3xqGrRml6d/QTYQE9REm+Rf8+mCXY=
X-Received: by 2002:a05:6808:3089:b0:32e:f7fd:627d with SMTP id
 bl9-20020a056808308900b0032ef7fd627dmr4992399oib.181.1656591473130; Thu, 30
 Jun 2022 05:17:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220614204730.3359543-1-seanjc@google.com> <7e05e0befa13af05f1e5f0fd8658bc4e7bdf764f.camel@redhat.com>
 <CALMp9eSkdj=kwh=4WHPsWZ1mKr9+0VSB527D5CMEx+wpgEGjGw@mail.gmail.com> <f55889a50ba404381e3edc1a192770f2779d40f1.camel@redhat.com>
In-Reply-To: <f55889a50ba404381e3edc1a192770f2779d40f1.camel@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 30 Jun 2022 05:17:42 -0700
Message-ID: <CALMp9eQkA-YeUFd=6Q+bRbtDT+UZO0jtPkEoZbqU1uDqMGp+xw@mail.gmail.com>
Subject: Re: [PATCH v2 00/21] KVM: x86: Event/exception fixes and cleanups
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Jun 30, 2022 at 1:22 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:

> I can't access this document for some reason (from my redhat account, which is gmail as well).

Try this one: https://docs.google.com/spreadsheets/d/13Yp7Cdg3ZyKoeZ3Qebp3uWi7urlPNmo5CQU5zFlayzs
