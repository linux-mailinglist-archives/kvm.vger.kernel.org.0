Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11792325166
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 15:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhBYOQ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 09:16:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhBYOQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 09:16:58 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC80DC06174A
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 06:16:17 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id dg2so2764170qvb.12
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 06:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ziwhP9OmxK9JBWvbCBdfdzzIAMJoChb9AXfWl0EGwQk=;
        b=g+BSigtLpBzC1puNHN31efc7b0UyfzHMz9GKyrtn/n2B8FocAOfk/iXn7ZVQ3Hipmy
         D3nqoMSiNylQG5QVQ+JvXxv50ODNswhNvOSU6IRWM0YedVDwOmBP7MwvuS2fGJjHb85T
         904ah9stBarxor3lSgCwezobVtRQnQmSrNjMQUxJCRRgEr4O4RpBG1Z0IrvDgYZWXLtq
         x0krEWpG+EYP4FSM/m0yaJaUNMEAfJ34hL7H1UJfm8i5vpe8tDe6QAPExO8fu5iWSPj2
         ZRItyD4IyE5YWmyzBwJ0RAl/7AYbdCGyi7nblXVgO2szaYzIoJoBQxZErm9ltG5ub9wP
         mh2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ziwhP9OmxK9JBWvbCBdfdzzIAMJoChb9AXfWl0EGwQk=;
        b=qgvd25PI0dQzrnbWoKFxV5rvRV+X75MBfrHD8PvoKvBTHZ8DDNx6jIynDaBHh6dk02
         Uo6rD1qXkCI+qUn/9Fco/iyZcexVKvPK5+YkJgJnQsL9TS4dXtXeEZk1/tdNvckkk6RA
         I/bv4757u54jRXint3vOp6R06auS+XA6PUL+FOLQUNJF6oefWZsT+D+cvkLUsvF14dN+
         vYu7TCoVUJAHG2pJCzgg/CxzPQtWqgsBraKh2V3x0cZTpeYokdI79+gPNV/5aEdJfb6u
         E3R3hiKrNYRKr/5rEoWG6oQEpN/fa6lj5SGIFZ7ITknKlJZWH7XqgFEJ7sHNDcSHVbiA
         k1RQ==
X-Gm-Message-State: AOAM531wTI8Z2+H9Z6mQ3EkTzp0HW/tzmETMYnsFgldIV0fMbfqn3zkT
        o8TODwTsvzuqrEjW44JuMqK3lzmG32u33Kkv/jllOQ==
X-Google-Smtp-Source: ABdhPJyOpiI4ZgaHQ1Wc5fYgMQQRbFv2ZjfhfOp5YS3J0A8WC0KtcvfIyrvH/929YCJV8cZnrg4ZclVxtR4rFNJqRfI=
X-Received: by 2002:a0c:9142:: with SMTP id q60mr2658536qvq.23.1614262576687;
 Thu, 25 Feb 2021 06:16:16 -0800 (PST)
MIME-Version: 1.0
References: <0000000000007ff56205ba985b60@google.com> <00000000000004e7d105bc091e06@google.com>
 <20210224122710.GB20344@zn.tnic> <CACT4Y+ZaGOpJ1+dxfTVWhNuV5hFJmx=HgPqVf6bqWE==7PeFFQ@mail.gmail.com>
 <20210224174936.GG20344@zn.tnic> <YDaV+ThL4c+vTo4e@google.com>
In-Reply-To: <YDaV+ThL4c+vTo4e@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 25 Feb 2021 15:16:05 +0100
Message-ID: <CACT4Y+ZMdxYdh_VcGLyq_pFDvD0RNbHcKZKcAd=BRu+yzq5z2Q@mail.gmail.com>
Subject: Re: general protection fault in vmx_vcpu_run (2)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        syzbot <syzbot+42a71c84ef04577f1aef@syzkaller.appspotmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, wanpengli@tencent.com,
        "the arch/x86 maintainers" <x86@kernel.org>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 24, 2021 at 7:08 PM 'Sean Christopherson' via
syzkaller-bugs <syzkaller-bugs@googlegroups.com> wrote:
>
> On Wed, Feb 24, 2021, Borislav Petkov wrote:
> > Hi Dmitry,
> >
> > On Wed, Feb 24, 2021 at 06:12:57PM +0100, Dmitry Vyukov wrote:
> > > Looking at the bisection log, the bisection was distracted by something else.
> >
> > Meaning the bisection result:
> >
> > 167dcfc08b0b ("x86/mm: Increase pgt_buf size for 5-level page tables")
> >
> > is bogus?
>
> Ya, looks 100% bogus.
>
> > > You can always find the original reported issue over the dashboard link:
> > > https://syzkaller.appspot.com/bug?extid=42a71c84ef04577f1aef
> > > or on lore:
> > > https://lore.kernel.org/lkml/0000000000007ff56205ba985b60@google.com/
> >
> > Ok, so this looks like this is trying to run kvm ioctls *in* a guest,
> > i.e., nested. Right?
>
> Yep.  I tried to run the reproducer yesterday, but the kernel config wouldn't
> boot my VM.  I haven't had time to dig in.  Anyways, I think you can safely
> assume this is a KVM issue unless more data comes along that says otherwise.

Interesting. What happens? Does the kernel crash? Userspace crash?
Rootfs is not mounted? Or something else?
