Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6526B9D53
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 18:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjCNRrG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 13:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjCNRrF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 13:47:05 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E566D9EC2
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 10:47:02 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-538116920c3so172504127b3.15
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 10:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678816022;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qRi9DieC6fI0xIFZnV2isMARrArMZFITNyhRbutkUcc=;
        b=J4PHjCO9DVOG2IIZLlEtu8iAXYlOcLbV7OLgpPQBQgsz1pAJ2C2wzdjLLf/1g9eqNo
         op+2aOnupfVtCdIDSr8M8ID795JGx5VRMC7EFRt19RrKe/E5mck5SseJLTH/G6ZJwztt
         c8b9gW0D17nzVNM/cEje5+rJUj3q2X+E+w5iM/CQn+goAzvYyxcGEetdW/aRREYr+5lD
         CHeSbkEjzLGMr3yQafJzkKBHQBE3JZcwTVfuHXPyc1EcyRSpvbuyjIyFFOV4gATWih2L
         /j2hP/hqEZOy8lSuGeUyoEMF1vH8a2bW1oUcw/c3Fxs2NkCvXGjtlQ9vgiwLtOhJXPxn
         g0Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678816022;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qRi9DieC6fI0xIFZnV2isMARrArMZFITNyhRbutkUcc=;
        b=B490xVgtEbXCf+mjLVKtUm/+mavJzPOOJGTEUkTaimxL/AfbqfxRClSLi+ReA23tDo
         pybaiLFABpbktOtgK7O2QYtSdVlukSsMIVZCJXEFvXc/GM13VgaEzN09nh8ynmAb5s2M
         S2UfqpWIyPa8+UhiKtt9uINMSDE9hfx8uv0B8+KOCdnYifOldia103TLgkSWsrTr+s+M
         Ed0qUIkKG/7apz2cyyiXN/B1okxdf1FC6mwvaQ7HVGXRxUd+k1GYmCNKO6y6lm/1CoyS
         V+ENEHpX3E0bv5juc4Dit6mkfTlUmXBZoc1Cc5kXMyuHcAkHwSZQPu3Tui9ttids4kmB
         Os/Q==
X-Gm-Message-State: AO0yUKWFhFFeDRH496B+Uzyclai4Fh5dCfmtkmeY4dCx44R26Y1Agjy8
        j/gOqtEBeQlY2pXieB4VCiPBINliDi3i0625gw==
X-Google-Smtp-Source: AK7set9HH+M89jKTZ9W9fEUUdg0sgyPEHK/9CryOqrq/dO1DXpdnhKzTTfYNX8+F3GqgglMaiuTDCdAXCZa0pbdFvw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a5b:38a:0:b0:ac9:cb97:bd0e with SMTP
 id k10-20020a5b038a000000b00ac9cb97bd0emr19014460ybp.5.1678816022162; Tue, 14
 Mar 2023 10:47:02 -0700 (PDT)
Date:   Tue, 14 Mar 2023 17:47:01 +0000
In-Reply-To: <86o7owyj0a.wl-maz@kernel.org> (message from Marc Zyngier on Mon,
 13 Mar 2023 11:43:01 +0000)
Mime-Version: 1.0
Message-ID: <gsnta60fcjje.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 15/16] KVM: arm64: selftests: Augment existing timer test
 to handle variable offsets
From:   Colton Lewis <coltonlewis@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de,
        dwmw2@infradead.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Marc Zyngier <maz@kernel.org> writes:

> On Fri, 10 Mar 2023 19:26:47 +0000,
> Colton Lewis <coltonlewis@google.com> wrote:

>> Marc Zyngier <maz@kernel.org> writes:

>> >> mvbbq9:/data/coltonlewis/ecv/arm64-obj/kselftest/kvm#
>> >> ./aarch64/arch_timer -O 0xffff
>> >> ==== Test Assertion Failure ====
>> >>    aarch64/arch_timer.c:239: false
>> >>    pid=48094 tid=48095 errno=4 - Interrupted system call
>> >>       1  0x4010fb: test_vcpu_run at arch_timer.c:239
>> >>       2  0x42a5bf: start_thread at pthread_create.o:0
>> >>       3  0x46845b: thread_start at clone.o:0
>> >>    Failed guest assert: xcnt >= cval at aarch64/arch_timer.c:151
>> >> values: 2500645901305, 2500645961845; 9939, vcpu 0; stage; 3; iter: 2

>> > The fun part is that you can see similar things without the series:

>> > ==== Test Assertion Failure ====
>> >    aarch64/arch_timer.c:239: false
>> >    pid=647 tid=651 errno=4 - Interrupted system call
>> >       1  0x00000000004026db: test_vcpu_run at arch_timer.c:239
>> >       2  0x00007fffb13cedd7: ?? ??:0
>> >       3  0x00007fffb1437e9b: ?? ??:0
>> >    Failed guest assert: config_iter + 1 == irq_iter at
>> > aarch64/arch_timer.c:188
>> > values: 2, 3; 0, vcpu 3; stage; 4; iter: 3

>> > That's on a vanilla kernel (6.2-rc4) on an M1 with the test run
>> > without any argument in a loop. After a few iterations, it blows.

> I finally got to the bottom of that one. This is yet another case of
> the test making the assumption that spurious interrupts don't exist...

That's great!

> Here, the timer interrupt has been masked at the source, but the GIC
> (or its emulation) can be slow to retire it. So we take it again,
> spuriously, and account it as a true interrupt. None of the asserts in
> the timer handler fire because they only check the *previous* state.

> Eventually, the interrupt retires and we progress to the next
> iteration. But in the meantime, we have incremented the irq counter by
> the number of spurious events, and the test fails.

> The obvious fix is to check for the timer state in the handler and
> exit early if the timer interrupt is masked or the timer disabled.
> With that, I don't see these failures anymore.

> I've folded that into the patch that already deals with some spurious
> events.

I'll be looking at it and will keep in mind your questions about my
hardware should I find any issues. Yes it has ECV and CNTPOFF but no I
didn't try turning it off for this because my issue occured only when
setting a physical offset and that can't be done without ECV.
