Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84162573CA7
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 20:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236799AbiGMSlb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 14:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236817AbiGMSl1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 14:41:27 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4798D2F643
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 11:41:26 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id b11so21366885eju.10
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 11:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KifgCMjgebK/NLp6nn+G8EJhgQBv0NBPfKiflov1mlU=;
        b=WXkiCM2m7cWXxt53oQNuRjMlHN9tRHeiD9hdMvRX9/jmGDWKVCpWfb/ymYf0GUrQkn
         2gcUvM0fppN4jvlrJBHSQ6kMpDV+0P4G+reqg6RPyFytwCdFGVuiwifzJXcN+e0T0eK3
         apqVZARbdC+XmrVpwiiRoZeHilhOPB7mXQ0Jw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KifgCMjgebK/NLp6nn+G8EJhgQBv0NBPfKiflov1mlU=;
        b=M0D2mHNyGZsGsFiQ5W/Ne8AMGaS/NStStS+kYD/bYznlyEGsv8zqXa53wKN+ojCWxM
         4DWfKZhzfUjdOZdPrl774ppic+Ibb3KvABCQ0wcXCD/v80ESXWTVIaG/2o/bnsxZvKWX
         3fjrVJSwL9hbn4xs2i4d1VpAwj/RKZyQmachZ1h0j+J2mGRRY4OoPJ6gaAJpcun8XNgH
         eyLLBWVpmy0zKKkypYpGvDCy/AKaqzGDU5FCoxDFzjGnZSEjQ3kgT7qq6G7mkbnXi1sF
         2l+s2dsUD5SE8SUelUeBJUmWTPu9OnK6ItygMgOQFPJcmmlXlWMsgYaVLD8Fj7tzyZM/
         J0vQ==
X-Gm-Message-State: AJIora8v8UGyT6gAdY013RnZxI0H1Dnljm3lWgoW6/sCwHnApCis81bD
        V07naP4j0KNDN7DF6k5hdrVWTeZV6J9iU2KTPws=
X-Google-Smtp-Source: AGRyM1vcnuNH2KLxMeQGsK2Baocu1Omt9Nu8P5s9OJ1oKR98BBr9UP+7E0/ZPbMiwSdxmz3WXXUggw==
X-Received: by 2002:a17:906:dc8f:b0:725:28d1:422d with SMTP id cs15-20020a170906dc8f00b0072528d1422dmr4724076ejc.131.1657737684494;
        Wed, 13 Jul 2022 11:41:24 -0700 (PDT)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id ky18-20020a170907779200b00715a02874acsm5217475ejc.35.2022.07.13.11.41.24
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 11:41:24 -0700 (PDT)
Received: by mail-wr1-f51.google.com with SMTP id r10so10562205wrv.4
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 11:41:24 -0700 (PDT)
X-Received: by 2002:a5d:544b:0:b0:21d:70cb:b4a2 with SMTP id
 w11-20020a5d544b000000b0021d70cbb4a2mr4440805wrv.281.1657737218805; Wed, 13
 Jul 2022 11:33:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220712183238.844813653@linuxfoundation.org> <CA+G9fYtntg7=zWSs-dm+n_AUr_u0eBOU0zrwWqMeXZ+SF6_bLw@mail.gmail.com>
 <eb63e4ce-843f-c840-060e-6e15defd3c4d@roeck-us.net>
In-Reply-To: <eb63e4ce-843f-c840-060e-6e15defd3c4d@roeck-us.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 13 Jul 2022 11:33:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj5cOA+fbGeV15kvwe6YGT54Wsk8F2UGoekVQLTPJz_pw@mail.gmail.com>
Message-ID: <CAHk-=wj5cOA+fbGeV15kvwe6YGT54Wsk8F2UGoekVQLTPJz_pw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
To:     Guenter Roeck <linux@roeck-us.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>
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

On Wed, Jul 13, 2022 at 6:34 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> Looking into the log, I don't think that message is related to the crash.
>
> ...
> [  105.653777] Modules linked in: x86_pkg_temp_thermal
> [  105.902123] ---[ end trace cec99cae36bcbfd7 ]---
> [  105.902124] RIP: 0010:xaddw_ax_dx+0x9/0x10    <--- crash
> [  105.902126] Code: 00 0f bb d0 c3 cc cc cc cc 48 0f bb d0 c3 cc cc

Yeah, the code you snipped, shows

  20: 66 0f c1 d0          xadd   %dx,%ax
  24: c3                    ret
  25: cc                    int3
  26: cc                    int3
  27: cc                    int3
  28: cc                    int3
  29:* 0f 1f 80 00 00 00 00 nopl   0x0(%rax) <-- trapping instruction
  30: 0f c1 d0              xadd   %edx,%eax
  33: c3                    ret
  34: cc                    int3
  35: cc                    int3
  36: cc                    int3
  37: cc                    int3
  38: 48 0f c1 d0          xadd   %rdx,%rax
  3c: c3                    ret
  3d: cc                    int3

and that's a bit odd.

It says "xaddw_ax_dx+0x9/0x10", but I think somebody jumped to
"xaddw_ax_dx+8", hit the 'int3', and the RIP points to the next
instruction (because that's how int3 works).

And the fastop code says:

 * fastop functions have a special calling convention:
...
 * Moreover, they are all exactly FASTOP_SIZE bytes long,

but that is clearly *NOT* the case for xaddw_ax_dx, because it's 16
bytes in size, and the other ones are 8 bytes. That's where the "nopl"
comes from: it's the alignment instruction to the next fastop
function.

Compare that to the word-sized 'xaddl' case rigth afterwards: that one
*is* just 8 bytes in size, so the 64-byte 'xaddq' comes 8 bytes aftrer
it, and there's no 7-byte padding nop-instruction.

So I think that that is where the "xaddw_ax_dx+8" comes from: some
code assumes that FASTOP_SIZE is 8, but that xaddw_ax_dx case was
actually 9 bytes and thus got that "int3 + padding" in the next 8
bytes.

The whole kvm x86 emulation thiing is quite complicated and has lots
of instruction size #defines and magic.

I'm not familiar enough with it to go "Ahh, it's obviously XYZ", but
I'm sure PeterZ and Borislav know exactly what's going on.

                 Linus
