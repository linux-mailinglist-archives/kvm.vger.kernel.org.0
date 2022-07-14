Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B03575370
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 18:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbiGNQxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 12:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239480AbiGNQwt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 12:52:49 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1B62DAA2
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 09:51:59 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id dn9so4457753ejc.7
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 09:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UkKAKPPtro79xKHDPBehtihMhR7Lh7lQwIdzYzaJOZw=;
        b=Mr94LDjwnV8nGBNNVAJX0c9LMeMtH4cDpRa5fj+6lq8ilb1VFMXaD3H2Ik9nf7Im9V
         XZyhuuiBGMSLiEDZ8jkg99ghi7VhgSI6uCGroUHirIu1a+9FR19M3SveBO6J6ruu/gBv
         73wvSSvqkb+WbC+/4GP+cysrOXahEAqgw1UYI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UkKAKPPtro79xKHDPBehtihMhR7Lh7lQwIdzYzaJOZw=;
        b=BqQKaMZ3q0fFzLYyMS3WznZuWtwcb/VKOVmk5UvF5ntsW7Cqba76nHv2VZc/sQc6EH
         mbQ3qbKSBUhMrSUpsgAmG8Yag2O8t6BLUKMf6hMTWs57dvLwZf2dutuqF/C6eMmDD43D
         55mfcqvD00EL+j1/dVIWoPQPa8Q+WpquDDv4j8sYWGBvBYx5YmC0/a89RAtk6y/tpdzW
         xEiSwCfsmd8UzKvHwi3NDQ1gAII1y9gfO0YZ+1xvtT86RjiZ8ENcvMfZhesYVEwaL74B
         T8xNXbe40mSwI4wdKOWFgXInewMvqoJsMsq1eLM6k494+28lqYevJEzYDU7AaX7WbAsC
         eEmA==
X-Gm-Message-State: AJIora9TMD58dhQwgmdcUouEXojJ6ljHN+cPGw0J89ywGUaPcpHSzOpZ
        4ueA/nCex1nzSfR7jffuTVL4K760cN5EI4QQxFE=
X-Google-Smtp-Source: AGRyM1utJLZEk0T5RYvQaIEB2k4842p9f317V0mStNlPY0Y0qaTbYAQIopMhFh+xAvl/y8m+zJrzKw==
X-Received: by 2002:a17:906:cc5a:b0:72b:1459:6faa with SMTP id mm26-20020a170906cc5a00b0072b14596faamr9869497ejb.221.1657817517936;
        Thu, 14 Jul 2022 09:51:57 -0700 (PDT)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com. [209.85.128.47])
        by smtp.gmail.com with ESMTPSA id uh40-20020a170906b3a800b0072ab06bc3b5sm891849ejc.34.2022.07.14.09.51.57
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 09:51:57 -0700 (PDT)
Received: by mail-wm1-f47.google.com with SMTP id y22-20020a7bcd96000000b003a2e2725e89so1584251wmj.0
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 09:51:57 -0700 (PDT)
X-Received: by 2002:a7b:cd97:0:b0:3a2:dfcf:dd2d with SMTP id
 y23-20020a7bcd97000000b003a2dfcfdd2dmr15971099wmj.68.1657817517167; Thu, 14
 Jul 2022 09:51:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220712183238.844813653@linuxfoundation.org> <CA+G9fYtntg7=zWSs-dm+n_AUr_u0eBOU0zrwWqMeXZ+SF6_bLw@mail.gmail.com>
 <eb63e4ce-843f-c840-060e-6e15defd3c4d@roeck-us.net> <CAHk-=wj5cOA+fbGeV15kvwe6YGT54Wsk8F2UGoekVQLTPJz_pw@mail.gmail.com>
 <CAHk-=wgq1soM4gudypWLVQdYuvJbXn38LtvJMtnLZX+RTypqLg@mail.gmail.com> <Ys/bYJ2bLVfNBjFI@nazgul.tnic>
In-Reply-To: <Ys/bYJ2bLVfNBjFI@nazgul.tnic>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 14 Jul 2022 09:51:40 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjdafFUFwwQNvNQY_D32CBXnp6_V=DL2FpbbdstVxafow@mail.gmail.com>
Message-ID: <CAHk-=wjdafFUFwwQNvNQY_D32CBXnp6_V=DL2FpbbdstVxafow@mail.gmail.com>
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

On Thu, Jul 14, 2022 at 2:02 AM Borislav Petkov <bp@alien8.de> wrote:
>
> I'm guessing you're thinking of cutting an -rc7 so that people can test
> the whole retbleed mitigation disaster an additional week?

Oh, absolutely. Doing an -rc7 is normal.

Right now the question isn't whether an rc7 happens, but whether we'll
need an rc8. We'll see.

Oh, I do hate the hw-embargoed stuff that doesn't get all the usual
testing in all our automation.

             Linus
