Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F065573CAB
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 20:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236732AbiGMSpp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 14:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236706AbiGMSpo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 14:45:44 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7D92C139
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 11:45:43 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id va17so21478449ejb.0
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 11:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PTaNdUVQ+FmmgGgyaGPbQquf7hxH0Xo9Q96HHi4sep8=;
        b=L73SZ+mHgtriwniSrAhSkxjXKDDXd0WPgqFSlQUlKk5euLzrMbPjkEmJ9R+ZsDkWsH
         g0Meu4SIWMqSxjGIrdgkCgnmWaUXM68miVezQGPM9PXgHGoW1g8lxifty3vtR7bbVqJ1
         7asnHsF2ys8kx0XarbxrDW+2kekvsiZEVyWFI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PTaNdUVQ+FmmgGgyaGPbQquf7hxH0Xo9Q96HHi4sep8=;
        b=LfinGnPGKGWfXPQUFVVOY4GZr7CRfTfBSJjCKLEutXNrVA6ZHp+FgJ7k+se03LIhSc
         ieTgslnWGcHpVyGUJiFvEBtAB8h/zfdgvLI7Mkj3O1nL8f/E0z3DILlGV/EauuHm+ivo
         56qPYOSLBpvGTj4Lq0PNxAiAfOff49Td7l2fxDn6Xnqm0vCI4MdUe33H7sDBPsq6mHPZ
         W69rXIwnwM4EP1EONwfZGt9yw7/phj2P5ml3P9XRF2gFIXsgfcF9nXlvXcxgizkhhV/Z
         P+U7Bf08uCFbpGGWZOWKRc4SJNM6YYq3faBN6GUcp+C9W/tjPEpxVQFFE/GnCwP2VrPT
         LovQ==
X-Gm-Message-State: AJIora+DTxlxNXpD6DaavHkzB0gU6kbN2yRPJ3LmEHtUJQI6mUDMjr/W
        vwEQ25v/AJLR2P9ihiNrUULn075v06Js3V8abYs=
X-Google-Smtp-Source: AGRyM1tB0JlIizlpgymWR7A1ryy1/Wq2rmGvub+32NjXtIdmWxPMh34Xg3rjNRslIfRKcmOwXJXeEw==
X-Received: by 2002:a17:907:7348:b0:72b:44bf:96b6 with SMTP id dq8-20020a170907734800b0072b44bf96b6mr5009444ejc.7.1657737941543;
        Wed, 13 Jul 2022 11:45:41 -0700 (PDT)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id z8-20020a1709063a0800b006febce7081bsm1441524eje.163.2022.07.13.11.45.41
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 11:45:41 -0700 (PDT)
Received: by mail-wr1-f51.google.com with SMTP id o4so16739581wrh.3
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 11:45:41 -0700 (PDT)
X-Received: by 2002:a05:6000:180f:b0:21d:68f8:c4ac with SMTP id
 m15-20020a056000180f00b0021d68f8c4acmr4766164wrh.193.1657737619653; Wed, 13
 Jul 2022 11:40:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220712183238.844813653@linuxfoundation.org> <CA+G9fYtntg7=zWSs-dm+n_AUr_u0eBOU0zrwWqMeXZ+SF6_bLw@mail.gmail.com>
 <eb63e4ce-843f-c840-060e-6e15defd3c4d@roeck-us.net> <CAHk-=wj5cOA+fbGeV15kvwe6YGT54Wsk8F2UGoekVQLTPJz_pw@mail.gmail.com>
In-Reply-To: <CAHk-=wj5cOA+fbGeV15kvwe6YGT54Wsk8F2UGoekVQLTPJz_pw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 13 Jul 2022 11:40:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgq1soM4gudypWLVQdYuvJbXn38LtvJMtnLZX+RTypqLg@mail.gmail.com>
Message-ID: <CAHk-=wgq1soM4gudypWLVQdYuvJbXn38LtvJMtnLZX+RTypqLg@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
To:     Guenter Roeck <linux@roeck-us.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
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

On Wed, Jul 13, 2022 at 11:33 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So I think that that is where the "xaddw_ax_dx+8" comes from: some
> code assumes that FASTOP_SIZE is 8, but that xaddw_ax_dx case was
> actually 9 bytes and thus got that "int3 + padding" in the next 8
> bytes.
>
> The whole kvm x86 emulation thing is quite complicated and has lots
> of instruction size #defines and magic.
>
> I'm not familiar enough with it to go "Ahh, it's obviously XYZ", but
> I'm sure PeterZ and Borislav know exactly what's going on.

And I see that Thadeau already figured it out:

  https://lore.kernel.org/all/20220713171241.184026-1-cascardo@canonical.com/

So presumably we need that patch everywhere.

              Linus
