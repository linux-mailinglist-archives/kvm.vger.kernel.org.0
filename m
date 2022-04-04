Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44EB14F0E32
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 06:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377131AbiDDErc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 00:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbiDDEr3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 00:47:29 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B9032EEB
        for <kvm@vger.kernel.org>; Sun,  3 Apr 2022 21:45:31 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id g15-20020a17090adb0f00b001caa9a230c7so512055pjv.5
        for <kvm@vger.kernel.org>; Sun, 03 Apr 2022 21:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EEBN46zG2gvj2WY3lcxbVjrOksL0c/6WsjgZKCCzd/I=;
        b=kO4FdgYOebV/t2yzqBUOJ9hdCnVOAE3BWF9Xy8r7hy5NcvqQG9Q59fB2bGDz3+c94d
         tzqJw1ebi1BVASe6U2F6kGGXnf8lsXzK3vuEkvTHitRwLEPwoilxOyk3Vk07cBPVgcbF
         ue4XLYc4quOAF2XEnzJm7J0Gv/svvXxIfc2fSdexbpx2QcdTBwR5rcljcYhLapjF/0Pf
         t44yEaWd3T89rgPU9PQCuCtS7eGl7rqKj5LfFqG4ovsi3qcjmGPiktdZU9tq6DqSzj7i
         7hcDvWP9+15F67X9PrYumh8bQaJy1B2Kx7moJbcJNCEk4aR6eaJnViNcNQmPbLuepjRS
         8iYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EEBN46zG2gvj2WY3lcxbVjrOksL0c/6WsjgZKCCzd/I=;
        b=sfHRKuWMJeYWkpPkLQxD2YQNKwORCF/K96YpuXbuX5qKCbMjnbufIOJEIQAEbTDQMa
         WdQGDZYy3utskEAxwKrzroGK0r7XNKJriws5Y96UTyIrdJGZghlzHq+Oc3vWeeJxKr9R
         YrlQvRJ0t+ijUHjoMNqsG/catDPgtYEH0QWfSxid3rByaUfsmE+BHxIkYB4EzJGrKjTq
         bQKWx0yzBxXzl4lvtcxEYL7XN3RSWaWLDrAsAnjZT+aNZzgxjRBmuknw/9IVvNeC5RXo
         SXCGOfuDjnRuyBr0kWLSyeOW/ylmAAn4kewHTCybdDvPcsiO0qiKmIyel+KPYpqslKFm
         yscA==
X-Gm-Message-State: AOAM532u0QBT9AomvDX/1PL+Je3cHh1e+Rl1fXZBm5/D4PNyySMxyJrp
        KkPWIMKXItnZ2tRX2cwnNbCvfg0OB1virkk23wuNPw==
X-Google-Smtp-Source: ABdhPJzDVFMCClRUsK6gQWVxwlJiuN5q5hN2bBgrZWH+gsR5sokMSlYJUr9RMO+e4xu5pPL/2GX8kvOJQQ01h2wlkk8=
X-Received: by 2002:a17:90b:2350:b0:1ca:23b5:69a6 with SMTP id
 ms16-20020a17090b235000b001ca23b569a6mr20934316pjb.9.1649047530910; Sun, 03
 Apr 2022 21:45:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220401010832.3425787-1-oupton@google.com> <20220401010832.3425787-4-oupton@google.com>
In-Reply-To: <20220401010832.3425787-4-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sun, 3 Apr 2022 21:45:15 -0700
Message-ID: <CAAeT=Fz4cB_SoZCMkOp9cEuMbY+M+ieQ6PTBcvCOQRwGkGv9pA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Start trapping ID registers for 32 bit guests
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>
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

On Thu, Mar 31, 2022 at 6:08 PM Oliver Upton <oupton@google.com> wrote:
>
> To date KVM has not trapped ID register accesses from AArch32, meaning
> that guests get an unconstrained view of what hardware supports. This
> can be a serious problem because we try to base the guest's feature
> registers on values that are safe system-wide. Furthermore, KVM does not
> implement the latest ISA in the PMU and Debug architecture, so we
> constrain these fields to supported values.
>
> Since KVM now correctly handles CP15 and CP10 register traps, we no
> longer need to clear HCR_EL2.TID3 for 32 bit guests and will instead
> emulate reads with their safe values.
>
> Signed-off-by: Oliver Upton <oupton@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>

BTW, due to this, on a system that supports PMUv3, ID_DFR0_E1 value will
become 0 for the aarch32 guest without PMUv3. This is the correct behavior,
but it affects migration.  I'm not sure how much we should care about
migration of the aarch32 guest though (and it will be resolved once ID
registers become configurable anyway).

Thanks,
Reiji
