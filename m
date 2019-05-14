Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9852A1D093
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 22:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfENU10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 16:27:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726134AbfENU10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 16:27:26 -0400
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FBB3216FD
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 20:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557865644;
        bh=DzocNwMVi5SAbWmRTGaV0IjOHUG4WEPp/2+M4ioUzgA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=H7eAox2hSzIAWyeZKe5RK68sRQU/pkz/MU1gJXfJmQJwc8b9Y2i+bnIi6WWU9vdvc
         FSSl9o0Ds5GeA/th5W2//Zn9ZeQyIyYwOhETDLySSfAJFdoU9sT0kQQWo4hIcLuOnO
         JwlV8WuVYZF14qijOoItC6HIVEGbP7RGFDKPU0Uw=
Received: by mail-wm1-f42.google.com with SMTP id c66so3165718wme.0
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 13:27:24 -0700 (PDT)
X-Gm-Message-State: APjAAAXe9L3GNOADEeVbnvnMJI3knsL+y9QZHOyVj8+X5nAlxm6hyRsy
        bR43GvLy58b8sSBPPxGuvTAJMq9eA/B41rGxTqS/VA==
X-Google-Smtp-Source: APXvYqylF1zWRPSScsXn1HT0hufRGNU6xmts2UUV+2BP0SCGJO/kSUqZv0VIS1G4vkVbMaznNIUpjuvdLJlKdGXqL9Y=
X-Received: by 2002:a1c:eb18:: with SMTP id j24mr21736258wmh.32.1557865643024;
 Tue, 14 May 2019 13:27:23 -0700 (PDT)
MIME-Version: 1.0
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <1557758315-12667-19-git-send-email-alexandre.chartre@oracle.com>
 <CALCETrWUKZv=wdcnYjLrHDakamMBrJv48wp2XBxZsEmzuearRQ@mail.gmail.com>
 <20190514070941.GE2589@hirez.programming.kicks-ass.net> <b8487de1-83a8-2761-f4a6-26c583eba083@oracle.com>
 <B447B6E8-8CEF-46FF-9967-DFB2E00E55DB@amacapital.net> <4e7d52d7-d4d2-3008-b967-c40676ed15d2@oracle.com>
 <CALCETrXtwksWniEjiWKgZWZAyYLDipuq+sQ449OvDKehJ3D-fg@mail.gmail.com>
 <e5fedad9-4607-0aa4-297e-398c0e34ae2b@oracle.com> <20190514170522.GW2623@hirez.programming.kicks-ass.net>
In-Reply-To: <20190514170522.GW2623@hirez.programming.kicks-ass.net>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 14 May 2019 13:27:11 -0700
X-Gmail-Original-Message-ID: <CALCETrVRBC6DY9QXwksqLYP+LWD1PDw8nQyE03PbytDQ4+=LXQ@mail.gmail.com>
Message-ID: <CALCETrVRBC6DY9QXwksqLYP+LWD1PDw8nQyE03PbytDQ4+=LXQ@mail.gmail.com>
Subject: Re: [RFC KVM 18/27] kvm/isolation: function to copy page table
 entries for percpu buffer
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexandre Chartre <alexandre.chartre@oracle.com>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Liran Alon <liran.alon@oracle.com>,
        Jonathan Adams <jwadams@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 14, 2019 at 10:05 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, May 14, 2019 at 06:24:48PM +0200, Alexandre Chartre wrote:
> > On 5/14/19 5:23 PM, Andy Lutomirski wrote:
>
> > > How important is the ability to enable IRQs while running with the KVM
> > > page tables?
> > >
> >
> > I can't say, I would need to check but we probably need IRQs at least for
> > some timers. Sounds like you would really prefer IRQs to be disabled.
> >
>
> I think what amluto is getting at, is:
>
> again:
>         local_irq_disable();
>         switch_to_kvm_mm();
>         /* do very little -- (A) */
>         VMEnter()
>
>                 /* runs as guest */
>
>         /* IRQ happens */
>         WMExit()
>         /* inspect exit raisin */
>         if (/* IRQ pending */) {
>                 switch_from_kvm_mm();
>                 local_irq_restore();
>                 goto again;
>         }
>

What I'm getting at is that running the kernel without mapping the
whole kernel is a horrible, horrible thing to do.  The less code we
can run like that, the better.
