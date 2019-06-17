Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 979BC48888
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 18:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbfFQQPF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 12:15:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbfFQQPE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 12:15:04 -0400
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 401E02166E
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 16:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560788103;
        bh=JVZ01VQ9q2BY9LSCSpDeGenC0gNyM0CCxXIGe7cpTRk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=u0yPsNKYjsVDPjixo7eGt49hpgnj9Qzul0OjSRqTnkpQP/9jPpaQD4omedpzMB2lr
         9051sf80GG3JB8m+1Z2RCtEy/6xh2uXK0IsU7wtiqF8+FXMLdRKWfssLvW2hnqbCzC
         6R4kLuNGpy6jCcaZPdNYXNItJBk70On/mmPqEBsE=
Received: by mail-wr1-f45.google.com with SMTP id x17so10617688wrl.9
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 09:15:03 -0700 (PDT)
X-Gm-Message-State: APjAAAX90fybAkvq3J/wkPgalBu5yVJczkBb7vPFYjzLisy6gc4WW6Qg
        lqX+DEJ49gqHGDF1qBec4Wyq2Tllx0Ebh8CovjlzTA==
X-Google-Smtp-Source: APXvYqw+aKjGo1oOpxFBQkSUulEn15Px0suva6OwH4jzhCqa52shTOhsLX33dxRlw1A3thzjVwlJh2/YrXPs9J0TKOY=
X-Received: by 2002:adf:cc85:: with SMTP id p5mr16200961wrj.47.1560788101765;
 Mon, 17 Jun 2019 09:15:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190612170834.14855-1-mhillenb@amazon.de> <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net> <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
 <58788f05-04c3-e71c-12c3-0123be55012c@amazon.com> <63b1b249-6bc7-ffd9-99db-d36dd3f1a962@intel.com>
 <CALCETrXph3Zg907kWTn6gAsZVsPbCB3A2XuNf0hy5Ez2jm2aNQ@mail.gmail.com> <698ca264-123d-46ae-c165-ed62ea149896@intel.com>
In-Reply-To: <698ca264-123d-46ae-c165-ed62ea149896@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 17 Jun 2019 09:14:50 -0700
X-Gmail-Original-Message-ID: <CALCETrVt=X+FB2cM5hMN9okvbcROFfT4_KMwaKaN2YVvc7UQTw@mail.gmail.com>
Message-ID: <CALCETrVt=X+FB2cM5hMN9okvbcROFfT4_KMwaKaN2YVvc7UQTw@mail.gmail.com>
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM secrets
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Alexander Graf <graf@amazon.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marius Hillenbrand <mhillenb@amazon.de>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux-MM <linux-mm@kvack.org>, Alexander Graf <graf@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 17, 2019 at 9:09 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 6/17/19 8:54 AM, Andy Lutomirski wrote:
> >>> Would that mean that with Meltdown affected CPUs we open speculation
> >>> attacks against the mmlocal memory from KVM user space?
> >> Not necessarily.  There would likely be a _set_ of local PGDs.  We could
> >> still have pair of PTI PGDs just like we do know, they'd just be a local
> >> PGD pair.
> >>
> > Unfortunately, this would mean that we need to sync twice as many
> > top-level entries when we context switch.
>
> Yeah, PTI sucks. :)
>
> For anyone following along at home, I'm going to go off into crazy
> per-cpu-pgds speculation mode now...  Feel free to stop reading now. :)
>
> But, I was thinking we could get away with not doing this on _every_
> context switch at least.  For instance, couldn't 'struct tlb_context'
> have PGD pointer (or two with PTI) in addition to the TLB info?  That
> way we only do the copying when we change the context.  Or does that tie
> the implementation up too much with PCIDs?

Hmm, that seems entirely reasonable.  I think the nasty bit would be
figuring out all the interactions with PV TLB flushing.  PV TLB
flushes already don't play so well with PCID tracking, and this will
make it worse.  We probably need to rewrite all that code regardless.
