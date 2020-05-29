Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35B81E7D44
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 14:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgE2Mb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 08:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgE2Mb5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 08:31:57 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B67C08C5C6
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 05:31:57 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id s19so1572104edt.12
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 05:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BSX+fgALxeDo66TlmBZRvGUGpirIUX7OaMfEiJ8VgVc=;
        b=Ed756vTx8vjBHmmtuSvsE+s5/eTQIQZkHdjkSOIvH5dbxiRq4xJ49dIXhAxD2nncE8
         imzXFTYbRNqurkW4gOK3fXeFbv1M8bCQ/VYojaotKpmsr9kkG5NaJefAsy3Ss1vlVDgj
         XiK/n7NHoaT6ELCXRMWt57emfy3wGlO5DEzHw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BSX+fgALxeDo66TlmBZRvGUGpirIUX7OaMfEiJ8VgVc=;
        b=HQowAagqaR0dJssi6OsiiVLGyNgIxSirTOMGakGaHRH/D/AhcB05mcRnfjXBNN8g01
         cA5yfb9JH5FrGMUdL16trFro/YHIt+95+aWwYS4kKY4kM9sjqo+i6JxxbKuuYuzkygmw
         lI+t1bg4/Fy9jfHC+4/K14u/hJPZ0zYYF71JXvFQgxEgQF6gWz6EUGqzIeh41OhTG/0F
         3CBztoQBdqbf2fOFiWRke3j667de7CVbSkmjfGSjltWh7iuHu7WBoMR4GnCTqGKASbfA
         JILChfs3guvreRXrftFN0WjJZJihatUF2yvmFy+N1qo/13SnKGREp+DfDtHHIcM/xpWe
         Fyyw==
X-Gm-Message-State: AOAM533b1ISQ8XIkfeiBafIMeIO+eBRjA5XB9crZf8vyvFQJWtrggs+C
        auwnPTKUl+x7Qf23z/WBM8JIToAR4SVL+cj9FQLnUA==
X-Google-Smtp-Source: ABdhPJy0e6fY0Xa6ObKsKhUbrEvASjVKRznwsK6CXtLI4IX90rRdLXrflSh7Onj4tM1lwBhnFn0kMLdjl65XhCkNElc=
X-Received: by 2002:a50:d785:: with SMTP id w5mr7827583edi.212.1590755515767;
 Fri, 29 May 2020 05:31:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegstNYeseo_C4KOF9Y74qRxr78x2tK-9rTgmYM4CK30nRQ@mail.gmail.com>
 <875zcfoko9.fsf@nanos.tec.linutronix.de> <CAJfpegsjd+FJ0ZNHJ_qzJo0Dx22ZaWh-WZ48f94Z3AUXbJfYYQ@mail.gmail.com>
 <CAJfpegv0fNfHrkovSXCNq5Hk+yHP7usfMgr0qjPfwqiovKygDA@mail.gmail.com> <87r1v3lynm.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87r1v3lynm.fsf@nanos.tec.linutronix.de>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 29 May 2020 14:31:44 +0200
Message-ID: <CAJfpegt6js2WK6SjSZHsz+fg7ZLU+AL6TzrsDYmRfp7vNrtXyw@mail.gmail.com>
Subject: Re: system time goes weird in kvm guest after host suspend/resume
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 29, 2020 at 2:21 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Miklos,
>
> Miklos Szeredi <miklos@szeredi.hu> writes:
> > On Fri, May 29, 2020 at 11:51 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >> On Thu, May 28, 2020 at 10:43 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> >> >
> >> > Miklos Szeredi <miklos@szeredi.hu> writes:
> >> > > Bisected it to:
> >> > >
> >> > > b95a8a27c300 ("x86/vdso: Use generic VDSO clock mode storage")
> >> > >
> >> > > The effect observed is that after the host is resumed, the clock in
> >> > > the guest is somewhat in the future and is stopped.  I.e. repeated
> >> > > date(1) invocations show the same time.
> >> >
> >> > TBH, the bisect does not make any sense at all. It's renaming the
> >> > constants and moving the storage space and I just read it line for line
> >> > again that the result is equivalent. I'll have a look once the merge
> >> > window dust settles a bit.
> >>
> >> Yet, reverting just that single commit against latest linus tree fixes
> >> the issue.  Which I think is a pretty good indication that that commit
> >> *is* doing something.
>
> A revert on top of Linus latest surely does something, it disables VDSO
> because clocksource.vdso_clock_mode becomes NONE.
>
> That's a data point maybe, but it clearly does not restore the situation
> _before_ that commit.
>
> >> The jump forward is around 35 minutes; that seems to be consistent as
> >> well.
> >
> > Oh, and here's a dmesg extract for the good case:
> >
> > [   26.402239] clocksource: timekeeping watchdog on CPU0: Marking
> > clocksource 'tsc' as unstable because the skew is too large:
> > [   26.407029] clocksource:                       'kvm-clock' wd_now:
> > 635480f3c wd_last: 3ce94a718 mask: ffffffffffffffff
> > [   26.407632] clocksource:                       'tsc' cs_now:
> > 92d2e5d08 cs_last: 81305ceee mask: ffffffffffffffff
> > [   26.409097] tsc: Marking TSC unstable due to clocksource watchdog
> >
> > and the bad one:
> >
> > [   36.667576] clocksource: timekeeping watchdog on CPU1: Marking
> > clocksource 'tsc' as unstable because the skew is too large:
> > [   36.690441] clocksource:                       'kvm-clock' wd_now:
> > 89885027c wd_last: 3ea987282 mask: ffffffffffffffff
> > [   36.690994] clocksource:                       'tsc' cs_now:
> > 95666ec22 cs_last: 84e747930 mask: ffffffffffffffff
> > [   36.691901] tsc: Marking TSC unstable due to clocksource watchdog
>
> And the difference is? It's 10 seconds later and the detection happens
> on CPU1 and not on CPU0. I really don't see what you are reading out of
> this.

I didn't even try to interpret this.  Just reporting what I'm seeing.

> Can you please describe the setup of this test?
>
>  - Host kernel version
>  - Guest kernel version
>  - Is the revert done on the host or guest or both?
>  - Test flow is:
>
>    Boot host, start guest, suspend host, resume host, guest is screwed
>
>    correct?

Yep.

Thanks,
Miklos
