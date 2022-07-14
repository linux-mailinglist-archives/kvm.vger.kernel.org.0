Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 200955754C6
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 20:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238579AbiGNSRC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 14:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbiGNSRA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 14:17:00 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7715068DDE
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 11:16:59 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id m16so3449180edb.11
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 11:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hK5ocrmgpve0PHNj3o4tIMSgRA6JbzmNbYxh+aYsl2k=;
        b=ZCnQcVQGg0nfALVvWkqkGriFOMCDXxk6m2CvS9WlJvQ5Scn8GJJrBt/WYG0OuGJ5tK
         rHkj30PPf39TjXc7DVh1SMiF5ndE1lqe4ZrZMbqaj1klcnvokOZK149gaK/RwqMZK3U6
         NPUauVqcy8ILPqpKTcOikT324FVRl/5HXS6Ik=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hK5ocrmgpve0PHNj3o4tIMSgRA6JbzmNbYxh+aYsl2k=;
        b=ZVuAePLO/faPf0CzphGbtJoWYWLx4AzbObLAy5fcMXBSdhxo9N2voB32ScrJTyxZYz
         nxB532MmlNAIV7YjncABENDK8Zx0JZghfmX1RtNqHDAYPE66YTuY6BfM/S5Rbg2xLlRz
         3kj9ppoi4em8rgWNT8e8qiZ/700dVhg6kEG9n6Z3sOPPM52OtDDkTsP2rc17HTCfY7kp
         pFbj/p4pcKdGcbSxQpYyOCtk/84JeDv+UesVEj7kEmHfsPoYtjqccJpbOR3OfmJlK9KS
         K/rZQEZUipxFDGwFIjWjF2+lnlMwWbm89KO3UleoP/mGBTNy5oj2Xu2b7OE1jpL/q8QT
         l0rQ==
X-Gm-Message-State: AJIora960PP8kQ7pzuiW/D7ikLJwEqcu2UJG2KYPO70aQPBaShXdmSDP
        px+oy7g9QbY8DRinqZB32X4ywj7YEmempKF0pUc=
X-Google-Smtp-Source: AGRyM1tXkV57qXREttfmyq4i73eeINx2rZ6Cgykp8c+aF7KsHtzbbfi2Gmz32j4fWKaA8LTqF7tT0A==
X-Received: by 2002:a05:6402:270b:b0:43a:d89e:8c2d with SMTP id y11-20020a056402270b00b0043ad89e8c2dmr13946420edd.413.1657822617668;
        Thu, 14 Jul 2022 11:16:57 -0700 (PDT)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com. [209.85.221.53])
        by smtp.gmail.com with ESMTPSA id cw11-20020a056402228b00b0043a8f40a038sm1456768edb.93.2022.07.14.11.16.56
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 11:16:57 -0700 (PDT)
Received: by mail-wr1-f53.google.com with SMTP id bu1so3622852wrb.9
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 11:16:56 -0700 (PDT)
X-Received: by 2002:a5d:69c2:0:b0:21d:807c:a892 with SMTP id
 s2-20020a5d69c2000000b0021d807ca892mr9469726wrw.274.1657822616453; Thu, 14
 Jul 2022 11:16:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220712183238.844813653@linuxfoundation.org> <CA+G9fYtntg7=zWSs-dm+n_AUr_u0eBOU0zrwWqMeXZ+SF6_bLw@mail.gmail.com>
 <eb63e4ce-843f-c840-060e-6e15defd3c4d@roeck-us.net> <CAHk-=wj5cOA+fbGeV15kvwe6YGT54Wsk8F2UGoekVQLTPJz_pw@mail.gmail.com>
 <CAHk-=wgq1soM4gudypWLVQdYuvJbXn38LtvJMtnLZX+RTypqLg@mail.gmail.com>
 <Ys/bYJ2bLVfNBjFI@nazgul.tnic> <6b4337f4-d1de-7ba3-14e8-3ad0f9b18788@redhat.com>
 <8BEC3365-FC09-46C5-8211-518657C0308E@alien8.de> <CAHk-=wj4vtoWZPMXJU-B9qW1zLHsoA1Qb2P0NW=UFhZmrCrf9Q@mail.gmail.com>
 <YtBQutgSh2j3mFNB@worktop.programming.kicks-ass.net> <CAHk-=wjAouqJQ=C4XZVUmWEV9kerNzbOkK9OeErpHshNkcR=gQ@mail.gmail.com>
In-Reply-To: <CAHk-=wjAouqJQ=C4XZVUmWEV9kerNzbOkK9OeErpHshNkcR=gQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 14 Jul 2022 11:16:40 -0700
X-Gmail-Original-Message-ID: <CAHk-=whYia1fnjJFiJ59xZv4ROqqTfG4crQNWxb71JYJf5B-Lg@mail.gmail.com>
Message-ID: <CAHk-=whYia1fnjJFiJ59xZv4ROqqTfG4crQNWxb71JYJf5B-Lg@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Boris Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        kvm list <kvm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>, patches@kernelci.org,
        Sean Christopherson <seanjc@google.com>,
        Shuah Khan <shuah@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        lkft-triage@lists.linaro.org,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Oh, btw, how bad would it be to just do

     #define FASTOP_SIZE 16
     static_assert(FASTOP_SIZE >= FASTOP_LENGTH)

and leave it at that?

Afaik both gcc and clang default to -falign-functions=16 *anyway*, and
while on 32-bit x86 we have options to minimize alignment, we don't do
that on x86-64 afaik.

In fact, we have an option to force *bigger* alignment
(DEBUG_FORCE_FUNCTION_ALIGN_64B) but not any way to make it less.

And we use

        .p2align 4

in most of our asm, aling with

    #define __ALIGN          .p2align 4, 0x90

So all the *normal* functions already get 16-byte alignment anyway.

So yeah, it would be less dense, but do we care? Wouldn't the "this is
really simple" be a nice thing? It's not like there are a ton of those
fastop functions anyway. 128 of them? Plus 16 of the "setCC" ones?

               Linus
