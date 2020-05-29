Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237451E79EF
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 11:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgE2J6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 05:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE2J6A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 05:58:00 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B509C03E969
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 02:58:00 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id n24so1510482ejd.0
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 02:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=99pOzzXbN5adJubUzcJGXQQVBGmFL/nmnlnO5ZMkTJo=;
        b=gprvDCD/kRqOIy/BgHi73ZOyKU+h3Vg37a1mXEhQlyYlrku3TB6/A76nUIjpaO1btt
         EQke9n3jMnQ/wZAeMgOMUcfevQ0bxQ5mrKEX6oYqc3jJn6VP9WIwAMmPKFTMJdRJ7g16
         1atubjMdmy4paGmVrxzOP5bb7C99Mhzjc1+sI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=99pOzzXbN5adJubUzcJGXQQVBGmFL/nmnlnO5ZMkTJo=;
        b=PlMRIghlOh33ulo+sdxXfEjpcfqtCkf+GkyZ/KhCECmV+ccaQ5dqA3PAmW8fDJOTKS
         PJAcKKeBs80dCVQRWfBvwe9c78cZCf8+rB2iZQwzVjLPtgUwpZVal7gWKGLk+0Xv+vu7
         LieHZvNwf8X5NLAA7vXGGsn7knZ4nYEhyuejemQLBSNFah8//zf8dILurXIuGcvOgQew
         42M/yPP6I+TijASbc06E4jY3pS9vbLRDK7o8YbAMRftD01aVe1u6Ibux/0WMfmLIsIWk
         YVFgT6NMSdacM4AGxyIqKYII24041MnTKeubFJ+5C3g8Ux6Y1cpKUErnkGkYVGD0vvmq
         qggw==
X-Gm-Message-State: AOAM533ixNpEkz4rLiU3wd8RzEsigmdarFJItFBP4GVtn450eIHUuuoc
        fDE7Aapsjjj2DOdR5Hr5FilECulddFVSqUZImu80QA==
X-Google-Smtp-Source: ABdhPJyb/rBlZlBbzxI1OWPb1qBLaJ06N49Sr4s+4Q+qqtyiGbwnxNhE0Ti1HY50v9eJThFRtvBgzAEfY0HHuTPZLDQ=
X-Received: by 2002:a17:907:20d9:: with SMTP id qq25mr6687153ejb.202.1590746278813;
 Fri, 29 May 2020 02:57:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegstNYeseo_C4KOF9Y74qRxr78x2tK-9rTgmYM4CK30nRQ@mail.gmail.com>
 <875zcfoko9.fsf@nanos.tec.linutronix.de> <CAJfpegsjd+FJ0ZNHJ_qzJo0Dx22ZaWh-WZ48f94Z3AUXbJfYYQ@mail.gmail.com>
In-Reply-To: <CAJfpegsjd+FJ0ZNHJ_qzJo0Dx22ZaWh-WZ48f94Z3AUXbJfYYQ@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 29 May 2020 11:57:45 +0200
Message-ID: <CAJfpegv0fNfHrkovSXCNq5Hk+yHP7usfMgr0qjPfwqiovKygDA@mail.gmail.com>
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

On Fri, May 29, 2020 at 11:51 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Thu, May 28, 2020 at 10:43 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Miklos Szeredi <miklos@szeredi.hu> writes:
> > > Bisected it to:
> > >
> > > b95a8a27c300 ("x86/vdso: Use generic VDSO clock mode storage")
> > >
> > > The effect observed is that after the host is resumed, the clock in
> > > the guest is somewhat in the future and is stopped.  I.e. repeated
> > > date(1) invocations show the same time.
> >
> > TBH, the bisect does not make any sense at all. It's renaming the
> > constants and moving the storage space and I just read it line for line
> > again that the result is equivalent. I'll have a look once the merge
> > window dust settles a bit.
>
> Yet, reverting just that single commit against latest linus tree fixes
> the issue.  Which I think is a pretty good indication that that commit
> *is* doing something.
>
> The jump forward is around 35 minutes; that seems to be consistent as well.

Oh, and here's a dmesg extract for the good case:

[   26.402239] clocksource: timekeeping watchdog on CPU0: Marking
clocksource 'tsc' as unstable because the skew is too large:
[   26.407029] clocksource:                       'kvm-clock' wd_now:
635480f3c wd_last: 3ce94a718 mask: ffffffffffffffff
[   26.407632] clocksource:                       'tsc' cs_now:
92d2e5d08 cs_last: 81305ceee mask: ffffffffffffffff
[   26.409097] tsc: Marking TSC unstable due to clocksource watchdog

and the bad one:

[   36.667576] clocksource: timekeeping watchdog on CPU1: Marking
clocksource 'tsc' as unstable because the skew is too large:
[   36.690441] clocksource:                       'kvm-clock' wd_now:
89885027c wd_last: 3ea987282 mask: ffffffffffffffff
[   36.690994] clocksource:                       'tsc' cs_now:
95666ec22 cs_last: 84e747930 mask: ffffffffffffffff
[   36.691901] tsc: Marking TSC unstable due to clocksource watchdog

Thanks,
Miklos
