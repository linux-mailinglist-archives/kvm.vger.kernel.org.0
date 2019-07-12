Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE6367112
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 16:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbfGLONY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 10:13:24 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33231 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbfGLONX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 10:13:23 -0400
Received: by mail-qk1-f193.google.com with SMTP id r6so6510291qkc.0;
        Fri, 12 Jul 2019 07:13:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8c4jxWOyQNYg+EXZEt1rUQ27lN5OR3C4Tw6lA++twW8=;
        b=dwyja7ltni5MvdIoZuAvkQXOUZwpQcyYgkc0mE1viIQRBQiq6VRNbhG04zY7TYUben
         qJ/lgbQyXArp86pDybLrdJf7G7uSoi7yJ75WskOXowDr3VG2jiixTfnYAeVuFN+X/GQe
         yZpmM7GpiU0uixbq+/LQr/Z9zNL85a0U9fF9rUc9hCtQvDAfUtESmobihMiiXGP8hnJl
         Df5LgbvGU21lY0rSzmoZ48gdRqIWDkqZRYxA7Dbc1o6Ye2c96OJBHPUmm+lWX1Xp15cp
         5ACmhIPUlWqAEY/JHfc0uA6r+LGN5vxTTaHaN6RaK/ASOhbsMyneuCSg1uFiR/23fday
         lcdQ==
X-Gm-Message-State: APjAAAUo71zyOqn+j6DlG5v2g3sknAnpM7bLXsesfDZ66isZNZJqpWdU
        RtLkrL3J9sCUiQDWOE9kfYYjwlzTfsenJY4GWmg=
X-Google-Smtp-Source: APXvYqynzn/HkJQ+ZQ2dubJmUNo5nWbfS3m5iJJaG+uwDIjl2aK8DRQ0yg9JYMKbIO4d9pF4dR6KweZpxJOq81f1r9w=
X-Received: by 2002:a37:76c5:: with SMTP id r188mr6432948qkc.394.1562940802620;
 Fri, 12 Jul 2019 07:13:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190712133324.3934659-1-arnd@arndb.de> <20190712135427.GB27820@rkaganb.sw.ru>
In-Reply-To: <20190712135427.GB27820@rkaganb.sw.ru>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 12 Jul 2019 16:13:06 +0200
Message-ID: <CAK8P3a1zBsjM43t=+tZ6sVuRy2QXuJa5_gaeY5vmEgLWhf0BAw@mail.gmail.com>
Subject: Re: [PATCH] [v2] x86: kvm: avoid -Wsometimes-uninitized warning
To:     Roman Kagan <rkagan@virtuozzo.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 12, 2019 at 3:54 PM Roman Kagan <rkagan@virtuozzo.com> wrote:
>
> On Fri, Jul 12, 2019 at 03:32:43PM +0200, Arnd Bergmann wrote:
> > clang points out that running a 64-bit guest on a 32-bit host
> > would lead to uninitialized variables:
> >
> > arch/x86/kvm/hyperv.c:1610:6: error: variable 'ingpa' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
> >         if (!longmode) {
> >             ^~~~~~~~~
> > arch/x86/kvm/hyperv.c:1632:55: note: uninitialized use occurs here
> >         trace_kvm_hv_hypercall(code, fast, rep_cnt, rep_idx, ingpa, outgpa);
> >                                                              ^~~~~
> > arch/x86/kvm/hyperv.c:1610:2: note: remove the 'if' if its condition is always true
> >         if (!longmode) {
> >         ^~~~~~~~~~~~~~~
> > arch/x86/kvm/hyperv.c:1595:18: note: initialize the variable 'ingpa' to silence this warning
> >         u64 param, ingpa, outgpa, ret = HV_STATUS_SUCCESS;
> >                         ^
> >                          = 0
> > arch/x86/kvm/hyperv.c:1610:6: error: variable 'outgpa' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
> > arch/x86/kvm/hyperv.c:1610:6: error: variable 'param' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
> >
> > Since that combination is not supported anyway, change the condition
> > to tell the compiler how the code is actually executed.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> > v2: make the change inside of is_64_bit_mode().
> > ---
> >  arch/x86/kvm/hyperv.c | 6 ++----
> >  arch/x86/kvm/x86.h    | 4 ++++
> >  2 files changed, 6 insertions(+), 4 deletions(-)
>
> Reviewed-by: Roman Kagan <rkagan@virtuozzo.com>
>
> However I still think the log message could state it more explicitly
> that it was the compiler's fault, and the patch is a workaround for it.
>
> Otherwise later on someone may decide to restore the similarity of
> is_64_bit_mode() to other inlines in this file, and will be extremely
> unlikely to test clang 32-bit build...

Fair enough. I've reworded the changelog, as well as the patch to
document this now, in a way that should make it harder to introduce
the warning again by accident. Unfortunately, that #ifdef check
cannot be turned into an if(IS_ENABLED()) because kvm_r8_read()
is not defined on i386.

Note that the 0-day bot now tests with clang as well, so you would
definitely hear about a warning appearing.

v3 coming.

       Arnd
