Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4256C3A01
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 20:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjCUTK2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 15:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbjCUTKZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 15:10:25 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA452367E
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 12:10:06 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54196bfcd5fso160705877b3.4
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 12:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679425805;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ziIf5zThrN86fZbzFwOMYWcl8suISOMT9uTHB4y+5bk=;
        b=RNpNO8B18Wi/4mJ5pSxEjZfri18Lf9W2FDB6NwSvXeN9RUdXlOEmQ3JvzUjso+s50V
         rHOP7MJTJ5LTEvW+Dbl5OwcpQuMuj76iwUV1kmI6/S9PNxnU4GbT5z2mxywrsdG9us3A
         obHoYoHiLTaDwh/tFhzGU8bsLN+d4066JYwUcMfZZVvQEqkq9OS3KPiXaykWEFH1Citd
         FHtTIrJklwEvabPsdXlzodkJ8dxTxtDnwxCxFsvbeBoZ/g1H5zpfayxVHu5oiL6cq87U
         RVpGUuPO+U+AQFetCx0SOsaq8GzjAUU+uP6otK/Gt3SulR7skufetl137pSKhPxJIv2w
         6L4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679425805;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ziIf5zThrN86fZbzFwOMYWcl8suISOMT9uTHB4y+5bk=;
        b=T2c9GjMvrmRsWzCX4aLpq3Sw8N7LoswF+TipQkuVphJGoIOriPD4nrkvedb/UPknUQ
         EwF3+aCYh8EDwH2yni8J9zFntfcDPXdz15UEyTLJtWud+tWG+S0xgoP/prLa3jHMcF5k
         si42rPiGhMpabmICFQBIrJR3T7fvKbcY1wjb7O7NNCHFObnwv/gOcPYNYeUB/cHeESOA
         eesPF3r7TgfjmRiZ31YspOnJF/olJNFa3kRADDMyFMEkGMThd3yKTBbydbatTaBF6eSH
         tRtIVKLbG95/e5Fa4NP5DzoKh51nOdkFBbUmJn8r8FoavPF5TWEvriS7DqFBd2akGjwC
         HeRA==
X-Gm-Message-State: AAQBX9eDkNZRmlcil+F1XknLWMjJGo+PkJ0l2M+FK7iqs/A3KJ2eT8gx
        0I5q+t85v6xxoJxY/gzxPPETMO7BapVNvclVTQ==
X-Google-Smtp-Source: AKy350aXBXPhLb4duV1Ik9+S84uCq7Z985ZUxTYbLrQsQRLvsYke33Iu6aFl0/CD7xUGKYVFDz/8i8ZUy3bRLfrB4A==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:1005:b0:a58:7139:cf85 with
 SMTP id w5-20020a056902100500b00a587139cf85mr2246812ybt.13.1679425805400;
 Tue, 21 Mar 2023 12:10:05 -0700 (PDT)
Date:   Tue, 21 Mar 2023 19:10:04 +0000
In-Reply-To: <87y1nvgv8s.wl-maz@kernel.org> (message from Marc Zyngier on Fri,
 17 Mar 2023 17:09:39 +0000)
Mime-Version: 1.0
Message-ID: <gsntfs9xdipf.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 1/2] KVM: selftests: Provide generic way to read system counter
From:   Colton Lewis <coltonlewis@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     pbonzini@redhat.com, shuah@kernel.org, seanjc@google.com,
        dmatlack@google.com, vipinsh@google.com, andrew.jones@linux.dev,
        bgardon@google.com, ricarkol@google.com, oliver.upton@linux.dev,
        kvm@vger.kernel.org
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

>> +#define MEASURE_CYCLES(x)			\
>> +	({					\
>> +		uint64_t start;			\
>> +		start = cycles_read();		\
>> +		x;				\

> You insert memory accesses inside a sequence that has no dependency
> with it. On a weakly ordered memory system, there is absolutely no
> reason why the memory access shouldn't be moved around. What do you
> exactly measure in that case?

cycles_read is built on another function timer_get_cntct which includes
its own barriers. Stripped of some abstraction, the sequence is:

timer_get_cntct (isb+read timer)
whatever is being measured
timer_get_cntct

I hadn't looked at it too closely before but on review of the manual
I think you are correct. Borrowing from example D7-2 in the manual, it
should be:

timer_get_cntct
isb
whatever is being measured
dsb
timer_get_cntct

>> +		cycles_read() - start;		\

> I also question the usefulness of this exercise. You're comparing the
> time it takes for a multi-GHz system to put a write in a store buffer
> (assuming it didn't miss in the TLBs) vs a counter that gets updated
> at a frequency of a few tens of MHz.

> My guts feeling is that this results in a big fat zero most of the
> time, but I'm happy to be explained otherwise.


In context, I'm trying to measure the time it takes to write to a buffer
*with dirty memory logging enabled*. What do you mean by zero? I can
confirm from running this code I am not measuring zero time.


> We already have all the required code to deal with ns conversions
> using a multiplier and a shift, avoiding floating point like the
> plague it is. Please reuse the kernel code for this, as you're quite
> likely to only measure the time it takes for KVM to trap the FP
> registers and perform a FP/SIMD switch...

Will do.
