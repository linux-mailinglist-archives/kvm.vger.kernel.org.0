Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3BA575683
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 22:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240733AbiGNUpO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 16:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240895AbiGNUpJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 16:45:09 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6C167585
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 13:45:08 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 19so3544919ljz.4
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 13:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TExNSZ/s/035rcwvcGhKf8b3mCtg1+8MAx2E+0mZs0k=;
        b=QlimJt9jnXA9WGUrrQpsyCnanjLLw2jppJeg8tlDJyUjoU7EVZkhjwQfw1utPbJFYw
         V2J/VhZUmpGT/0AOkO/cGcOvDnr/166nGbtK/23TIpPRTkOHY0byi1fwM5PVz2v65CaC
         CGxmh6/85iCwDd/Ru/CPAYbK8QhOpNrWTrRyY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TExNSZ/s/035rcwvcGhKf8b3mCtg1+8MAx2E+0mZs0k=;
        b=hLNo4+84wGRLCdxw9cBXd556WMgLLkBmZXsBdTNQkbTTpV7FMb+1LGlIbW4EtrF6gv
         XKL1EPa2Tzz1vPEkn+0Wd+lnKPCmTXdgvs0c12mgyB+8s7vDE0D9rY1WcmPWwE7oPMli
         Q4P3viwMGlvAB+zHN1JAYu9G2bldOjKHqvO6guqh6sRXI0Thc0BnDe0vGx1ECt0BoB1v
         YxbmwxL09QpwWi2w4cgXNZ6bXDNp1lbNHDp8V73M9b/E/cnoo9SfSQRjUKM4EbWZqlS4
         UB6CoDiiV+oTeP5bQNnxJ2fPRmarXalspag1848yxpYnHt4ii2C5j6JHhcCfwHK9qes2
         0NJw==
X-Gm-Message-State: AJIora/LZT7N58id66Gh0bthPk4L8Ix7uR+nYtp7pB0Sul/NFwYsJeV8
        vDsE3TQru6Sgh2w4cXOuJ/GXtAZRQkAtHvgbkqY=
X-Google-Smtp-Source: AGRyM1u7Ji3ZLTym8jtECxnl0pfof5Bun8Gip8N4Y0osClN0iriSMm0fsde3goFLnvRwGrMHBu0xbw==
X-Received: by 2002:a2e:9ccc:0:b0:25d:96da:42c1 with SMTP id g12-20020a2e9ccc000000b0025d96da42c1mr2993559ljj.498.1657831506635;
        Thu, 14 Jul 2022 13:45:06 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id d25-20020a19e619000000b00489c7fb668dsm522014lfh.182.2022.07.14.13.45.06
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 13:45:06 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id x10so3072088ljj.11
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 13:45:06 -0700 (PDT)
X-Received: by 2002:a05:6000:1f8c:b0:21d:7e98:51ba with SMTP id
 bw12-20020a0560001f8c00b0021d7e9851bamr9427301wrb.442.1657831181447; Thu, 14
 Jul 2022 13:39:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220712183238.844813653@linuxfoundation.org> <CA+G9fYtntg7=zWSs-dm+n_AUr_u0eBOU0zrwWqMeXZ+SF6_bLw@mail.gmail.com>
 <eb63e4ce-843f-c840-060e-6e15defd3c4d@roeck-us.net> <CAHk-=wj5cOA+fbGeV15kvwe6YGT54Wsk8F2UGoekVQLTPJz_pw@mail.gmail.com>
 <CAHk-=wgq1soM4gudypWLVQdYuvJbXn38LtvJMtnLZX+RTypqLg@mail.gmail.com>
 <Ys/bYJ2bLVfNBjFI@nazgul.tnic> <CAHk-=wjdafFUFwwQNvNQY_D32CBXnp6_V=DL2FpbbdstVxafow@mail.gmail.com>
 <YtBLe5AziniDm/Wt@nazgul.tnic>
In-Reply-To: <YtBLe5AziniDm/Wt@nazgul.tnic>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 14 Jul 2022 13:39:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=wghZB60WCh5M_Y0n1qGYbg-1fvWFnU-bV-4j1bQM1qE5A@mail.gmail.com>
Message-ID: <CAHk-=wghZB60WCh5M_Y0n1qGYbg-1fvWFnU-bV-4j1bQM1qE5A@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
To:     Borislav Petkov <bp@alien8.de>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
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

On Thu, Jul 14, 2022 at 10:02 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Thu, Jul 14, 2022 at 09:51:40AM -0700, Linus Torvalds wrote:
> > Oh, absolutely. Doing an -rc7 is normal.
>
> Good. I'm gathering all the fallout fixes and will send them to you on
> Sunday, if nothing unexpected happens.

Btw, I assume that includes the clang fix for the
x86_spec_ctrl_current section attribute.

That's kind of personally embarrassing that it slipped through: I do
all my normal test builds that I actually *boot* with clang.

But since I kept all of the embargoed stuff outside my normal trees,
it also meant that the test builds I did didn't have my "this is my
clang tree" stuff in it.

And so I - like apparently everybody else - only did those builds with gcc.

And gcc for some reason doesn't care about this whole "you redeclared
that variable with a different attribute" thing.

And sadly, our percpu accessor functions don't verify these things
either, so you can write code like this:

    unsigned long myvariable;

    unsigned long test_fn(void)
    {
        return this_cpu_read(myvariable);
    }

and the compiler will not complain about anything at all, and happily
generate completely nonsensical code like

        movq %gs:myvariable(%rip), %rax

for it, which will do entirely the wrong thing because 'myvariable'
wasn't allocated in the percpu section.

In the 'x86_spec_ctrl_current' case, that nonsensical code _worked_
(with gcc), because despite the declaration being for a regular
variable, the actual definition was in the proper segment.

But that 'myvariable' thing above does end up being another example of
how we are clearly missing some type checkng in this area.

I'm not sure if there's any way to get that section mismatch at
compile-time at all. For the static declarations, we could just make
DECLARE_PER_CPU() add some prefix/postfix to the name (and obviously
then do it at use time too).

We have that '__pcpu_scope_##name' thing to make sure of globally
unique naming due to the whole weak type thing. I wonder if we could
do something similar to verify that "yes, this has been declared as a
percpu variable" at use time?

                   Linus
