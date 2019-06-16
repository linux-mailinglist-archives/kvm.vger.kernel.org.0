Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADEE47718
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 00:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfFPWSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jun 2019 18:18:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727209AbfFPWSO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jun 2019 18:18:14 -0400
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ECBD20866
        for <kvm@vger.kernel.org>; Sun, 16 Jun 2019 22:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560723493;
        bh=O1ycWhUilyVeZV1l4Vcdv51ZM55dvixJqHvFqBWW/UQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uPTQWy7A2IaMi2VBKyydX6tBMS0ETwgHQLORn92D5Ob77cz9VH+Q0CCsmmQuAjDST
         Wlrjhv1YwjNqUQj+5SQpca8XI46FMMLkmV/MP22m2HnBN6RXFL9a06Y8VMioCARb0h
         eq9dGVqnSe0ejcfAgRvWxQLa0KPBAe617qplclt0=
Received: by mail-wm1-f41.google.com with SMTP id c66so7301348wmf.0
        for <kvm@vger.kernel.org>; Sun, 16 Jun 2019 15:18:13 -0700 (PDT)
X-Gm-Message-State: APjAAAXxhvZf3lJke0WpfmzNWkxisS3sh+1xEvPhEwimyGoMgCIHL5+N
        5F8elEX5zrx7zVkYHThfoQONjzJycQCYnbz8CncOQQ==
X-Google-Smtp-Source: APXvYqzLtLrlyAc4h7N2S7ze6VO2usm4Gpw8733KZc+aAYCc4lsGwCtnws1ou95toQgBrBXzSaYCX/qQON0xFktvLrY=
X-Received: by 2002:a1c:6242:: with SMTP id w63mr17250060wmb.161.1560723492077;
 Sun, 16 Jun 2019 15:18:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190612170834.14855-1-mhillenb@amazon.de> <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net> <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sun, 16 Jun 2019 15:18:00 -0700
X-Gmail-Original-Message-ID: <CALCETrWZ4qUW+A+YqE36ZJHqJAzxwDgq77bL99BEKQx-=JYAtA@mail.gmail.com>
Message-ID: <CALCETrWZ4qUW+A+YqE36ZJHqJAzxwDgq77bL99BEKQx-=JYAtA@mail.gmail.com>
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM secrets
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Marius Hillenbrand <mhillenb@amazon.de>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux-MM <linux-mm@kvack.org>, Alexander Graf <graf@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 14, 2019 at 7:21 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Wed, 12 Jun 2019, Andy Lutomirski wrote:
> > > On Jun 12, 2019, at 12:55 PM, Dave Hansen <dave.hansen@intel.com> wro=
te:
> > >
> > >> On 6/12/19 10:08 AM, Marius Hillenbrand wrote:
> > >> This patch series proposes to introduce a region for what we call
> > >> process-local memory into the kernel's virtual address space.
> > >
> > > It might be fun to cc some x86 folks on this series.  They might have
> > > some relevant opinions. ;)
> > >
> > > A few high-level questions:
> > >
> > > Why go to all this trouble to hide guest state like registers if all =
the
> > > guest data itself is still mapped?
> > >
> > > Where's the context-switching code?  Did I just miss it?
> > >
> > > We've discussed having per-cpu page tables where a given PGD is only =
in
> > > use from one CPU at a time.  I *think* this scheme still works in suc=
h a
> > > case, it just adds one more PGD entry that would have to context-swit=
ched.
> >
> > Fair warning: Linus is on record as absolutely hating this idea. He mig=
ht
> > change his mind, but it=E2=80=99s an uphill battle.
>
> Yes I know, but as a benefit we could get rid of all the GSBASE horrors i=
n
> the entry code as we could just put the percpu space into the local PGD.
>

I have personally suggested this to Linus on a couple of occasions,
and he seemed quite skeptical.
