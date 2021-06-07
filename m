Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2D539D9BF
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 12:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhFGKgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 06:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbhFGKge (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 06:36:34 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1B1C0617A6
        for <kvm@vger.kernel.org>; Mon,  7 Jun 2021 03:34:43 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id j189so16125758qkf.2
        for <kvm@vger.kernel.org>; Mon, 07 Jun 2021 03:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W1Z9gEhrO+dFGwff9bZiaB/Edk6g694l5FTvX8TnmqE=;
        b=iTtdkG5oAQc1PJs6q76R+08BA/t3w7Wq0B5q0H3ufJUid+AhdIEg3Y7fEh5tvg+XdW
         59gjhb2UQezoRRcs6jsnQry+7KjS/8g6IMni8HGD16dE51trmOBjXRtipOnNlpsv21H/
         4gB311yqb4F57DW8p98BkOuLBxbWB/QMW/ct8ycdrOesNpXpOqGaHtOf//MeCDDjrH5q
         uF0ze7KA5EuIxV5OEmz2vTKb7IYQSVhse9ZIsA0utfTlmx1u3ZfETfQW9jpk4VhCu02/
         unJalB4bnrHV3OiWEs7dCHEm4b8l0JftUBB4lDcwiHZZ79ZbMqv7OGCPzQTCU5xdEPmM
         dSig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W1Z9gEhrO+dFGwff9bZiaB/Edk6g694l5FTvX8TnmqE=;
        b=MfCReK8Nl10eRjwb0Ve6QytF09V7q6mmpPN41SqmLKtkcpgDqMNfXhb4FSqh2g2flW
         zl6tuavXwD0nwelDoUXbhFc7nqV9q6EBRVSKxUmz9INJDiZ3Cq8R7ActwGVhdK2PQDZj
         9UOT6gOfReBt8bXjkqTq7M5zNgMLTqyNBsBveun0ZwjhC4sriZigQn/c4hAbk8tLPS34
         Kyf9oeN+vRFvRNTim3cLgEsevXbbO04gaoDDrGkiqszzKf8tjcZSAzA2sXxX5oeo3B8o
         sB9TDxeTInEQ6YqBCogR+vvEFBkdj6ANoS1JIk1EEU7cEzYhV1JJj122s1JwgYT34e8O
         +Lcg==
X-Gm-Message-State: AOAM5318I06GpYjFO5fPS9m5EoJNExYb9pM+l/VjNEVPFy+qAihhxu/p
        NRpH8mFz2vea3rEJOK1G3XUxMmv9y/kY0m0OWwjQzg==
X-Google-Smtp-Source: ABdhPJzTaPg9Os78/lByEqsfjEnL/w2wMnrVZ00vCZM9WGJQ9q3qi9YoIFwEozZ90r1enDNg908KqoHmNpKV1LanaKs=
X-Received: by 2002:a37:4694:: with SMTP id t142mr16089543qka.265.1623062081807;
 Mon, 07 Jun 2021 03:34:41 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000f3fc9305c2e24311@google.com> <87v9737pt8.ffs@nanos.tec.linutronix.de>
 <0f6e6423-f93a-5d96-f452-4e08dbad9b23@redhat.com> <87sg277muh.ffs@nanos.tec.linutronix.de>
 <CANRm+CxaJ2Wu-f0Ys-1Fi7mo4FY9YBXNymdt142poSuND-K36A@mail.gmail.com>
In-Reply-To: <CANRm+CxaJ2Wu-f0Ys-1Fi7mo4FY9YBXNymdt142poSuND-K36A@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 7 Jun 2021 12:34:30 +0200
Message-ID: <CACT4Y+YDtBf1GebeAA=twsfuv9e0HN+w7Lt5ZqDJhMJ5-PWYXQ@mail.gmail.com>
Subject: Re: [syzbot] WARNING in x86_emulate_instruction
To:     Wanpeng Li <kernellwp@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        syzkaller <syzkaller@googlegroups.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        syzbot <syzbot+71271244f206d17f6441@syzkaller.appspotmail.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, jarkko@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kan.liang@linux.intel.com,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>, steve.wahl@hpe.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 28, 2021 at 2:34 AM Wanpeng Li <kernellwp@gmail.com> wrote:
>
> On Fri, 28 May 2021 at 08:31, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > On Fri, May 28 2021 at 01:21, Paolo Bonzini wrote:
> > > On 28/05/21 00:52, Thomas Gleixner wrote:
> > >>
> > >> So this is stale for a week now. It's fully reproducible and nobody
> > >> can't be bothered to look at that?
> > >>
> > >> What's wrong with you people?
> > >
> > > Actually there's a patch on list ("KVM: X86: Fix warning caused by stale
> > > emulation context").  Take care.
> >
> > That's useful, but does not change the fact that nobody bothered to
> > reply to this report ...
>
> Will do it next time. Have a nice evening, guys!

There was an idea to do this automatically by syzbot:

dashboard/app: notify bug report about fix patches
https://github.com/google/syzkaller/issues/1574

Namely: if syzbot discovers a fix anywhere (by the hash), it could
send a notification email to the bug report email thread.
The downside is that the robot sends even more emails, so I am not
sure how it will be accepted. Any opinions?
