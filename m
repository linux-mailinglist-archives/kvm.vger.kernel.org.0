Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951FB1E7D11
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 14:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgE2MVk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 08:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbgE2MVj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 08:21:39 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85D2C03E969;
        Fri, 29 May 2020 05:21:39 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jee10-0003wZ-1U; Fri, 29 May 2020 14:21:34 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 48CEB100C2D; Fri, 29 May 2020 14:21:33 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org
Subject: Re: system time goes weird in kvm guest after host suspend/resume
In-Reply-To: <CAJfpegv0fNfHrkovSXCNq5Hk+yHP7usfMgr0qjPfwqiovKygDA@mail.gmail.com>
References: <CAJfpegstNYeseo_C4KOF9Y74qRxr78x2tK-9rTgmYM4CK30nRQ@mail.gmail.com> <875zcfoko9.fsf@nanos.tec.linutronix.de> <CAJfpegsjd+FJ0ZNHJ_qzJo0Dx22ZaWh-WZ48f94Z3AUXbJfYYQ@mail.gmail.com> <CAJfpegv0fNfHrkovSXCNq5Hk+yHP7usfMgr0qjPfwqiovKygDA@mail.gmail.com>
Date:   Fri, 29 May 2020 14:21:33 +0200
Message-ID: <87r1v3lynm.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Miklos,

Miklos Szeredi <miklos@szeredi.hu> writes:
> On Fri, May 29, 2020 at 11:51 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Thu, May 28, 2020 at 10:43 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>> >
>> > Miklos Szeredi <miklos@szeredi.hu> writes:
>> > > Bisected it to:
>> > >
>> > > b95a8a27c300 ("x86/vdso: Use generic VDSO clock mode storage")
>> > >
>> > > The effect observed is that after the host is resumed, the clock in
>> > > the guest is somewhat in the future and is stopped.  I.e. repeated
>> > > date(1) invocations show the same time.
>> >
>> > TBH, the bisect does not make any sense at all. It's renaming the
>> > constants and moving the storage space and I just read it line for line
>> > again that the result is equivalent. I'll have a look once the merge
>> > window dust settles a bit.
>>
>> Yet, reverting just that single commit against latest linus tree fixes
>> the issue.  Which I think is a pretty good indication that that commit
>> *is* doing something.

A revert on top of Linus latest surely does something, it disables VDSO
because clocksource.vdso_clock_mode becomes NONE.

That's a data point maybe, but it clearly does not restore the situation
_before_ that commit.

>> The jump forward is around 35 minutes; that seems to be consistent as
>> well.
>
> Oh, and here's a dmesg extract for the good case:
>
> [   26.402239] clocksource: timekeeping watchdog on CPU0: Marking
> clocksource 'tsc' as unstable because the skew is too large:
> [   26.407029] clocksource:                       'kvm-clock' wd_now:
> 635480f3c wd_last: 3ce94a718 mask: ffffffffffffffff
> [   26.407632] clocksource:                       'tsc' cs_now:
> 92d2e5d08 cs_last: 81305ceee mask: ffffffffffffffff
> [   26.409097] tsc: Marking TSC unstable due to clocksource watchdog
>
> and the bad one:
>
> [   36.667576] clocksource: timekeeping watchdog on CPU1: Marking
> clocksource 'tsc' as unstable because the skew is too large:
> [   36.690441] clocksource:                       'kvm-clock' wd_now:
> 89885027c wd_last: 3ea987282 mask: ffffffffffffffff
> [   36.690994] clocksource:                       'tsc' cs_now:
> 95666ec22 cs_last: 84e747930 mask: ffffffffffffffff
> [   36.691901] tsc: Marking TSC unstable due to clocksource watchdog

And the difference is? It's 10 seconds later and the detection happens
on CPU1 and not on CPU0. I really don't see what you are reading out of
this.

Can you please describe the setup of this test?

 - Host kernel version
 - Guest kernel version
 - Is the revert done on the host or guest or both?
 - Test flow is:

   Boot host, start guest, suspend host, resume host, guest is screwed

   correct?

Thanks,

        tglx

