Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43371EF22B
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 09:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgFEHfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 03:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgFEHfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 03:35:53 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9C2C08C5C2
        for <kvm@vger.kernel.org>; Fri,  5 Jun 2020 00:35:53 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id k8so6677989edq.4
        for <kvm@vger.kernel.org>; Fri, 05 Jun 2020 00:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1VjCE6/abJfOjLL4MnyYsiz/bdxeCMpDRWtyEIY5Fyw=;
        b=GrDjQ6zPgb16rLW77/79xBB9WwKwYgNQW0eQ4bbNWbMyOhQ8j7jNHuUga/T8Y/O5+o
         LEV8M9mKQY9uN+Q13VCK1oXtLwp8Qw6kEn4y91vPG/8jRoPNoblgbdO92pL0bXcLNzwS
         89t2zun8h0tJIN9iGV7yFhvNW27g88kRjymm0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1VjCE6/abJfOjLL4MnyYsiz/bdxeCMpDRWtyEIY5Fyw=;
        b=IPG9p0lpIqcvomI6ABtOS0hGlThsblkO9TLvOWq+DgDECZQFwndn1f6cWlo1RnHh4B
         2UwsdJQr+8oteFKEh0v61iFbTwHfZLuoTYKptEIdOTLPQyj7A7ZVxPFnZcdolgtX6wDj
         b0p3Rl+K7dIGg37tDkMas0PXQZzIhk1yLXKv4iiTOXBu8xCB4l+A1SBptO0wqzOSJEgn
         S5MziD3jSJls2oI4sHGzbeAhzeXYxRhLJHm2N50rUpjQOD/EmS+YvVvOX7NMI/x2iLtn
         wv9lf5qAH8Lmv2BALXC4guEavbEI5tjpT8VvAAlKXpIw9sYkAOAxb3VhMr0cGFZteGnY
         fp9g==
X-Gm-Message-State: AOAM530z438f9r8n1YpFA7eFkRwUmld80TzJ+i6NswLuSsE8C7GXc4zi
        /Ea1W12NNZDUI16wMSfrRZI8lKA8CAFNQFn5gMuEvw==
X-Google-Smtp-Source: ABdhPJzF3V4dXMFZl2VWWJFZ3s9Hxf+Fd4rb1Plh76REgsxPIq/XrVM8nWrdZKSeJwZMp0q1uOT7SCZxu+EUnANBlVE=
X-Received: by 2002:a50:ee8f:: with SMTP id f15mr8081524edr.168.1591342552038;
 Fri, 05 Jun 2020 00:35:52 -0700 (PDT)
MIME-Version: 1.0
References: <87pnagf912.fsf@nanos.tec.linutronix.de> <87367a91rn.fsf@nanos.tec.linutronix.de>
 <CAJfpegvchB2H=NK3JU0BQS7h=kXyifgKD=JHjjT6vTYVMspY2A@mail.gmail.com> <1a1c32fe-d124-0e47-c9e4-695be7ea7567@redhat.com>
In-Reply-To: <1a1c32fe-d124-0e47-c9e4-695be7ea7567@redhat.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 5 Jun 2020 09:35:40 +0200
Message-ID: <CAJfpegvwBx49j9XwJZXcSUK=V9oHES31zB2sev0xwS4wfhah-g@mail.gmail.com>
Subject: Re: system time goes weird in kvm guest after host suspend/resume
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 4, 2020 at 10:14 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 04/06/20 21:28, Miklos Szeredi wrote:
> > time(2) returns good time, while clock_gettime(2) returns bad time.
> > Here's an example:
> >
> > time=1591298725 RT=1591300383 MONO=39582 MONO_RAW=39582 BOOT=39582
> > time=1591298726 RT=1591300383 MONO=39582 MONO_RAW=39582 BOOT=39582
> > time=1591298727 RT=1591300383 MONO=39582 MONO_RAW=39582 BOOT=39582
> > time=1591298728 RT=1591300383 MONO=39582 MONO_RAW=39582 BOOT=39582
> > time=1591298729 RT=1591300383 MONO=39582 MONO_RAW=39582 BOOT=39582
> >
> > As you can see, only time(2) is updated, the others remain the same.
> > date(1) uses clock_gettime(CLOCK_REALTIME) so that shows the bad date.
> >
> > When the correct time reaches the value returned by CLOCK_REALTIME,
> > the value jumps exactly 2199 seconds.
>
> clockid_to_kclock(CLOCK_REALTIME) is &clock_realtime, so clock_gettime
> calls ktime_get_real_ts64, which is:
>
>
>         do {
>                 seq = read_seqcount_begin(&tk_core.seq);
>
>                 ts->tv_sec = tk->xtime_sec;
>                 nsecs = timekeeping_get_ns(&tk->tkr_mono);
>
>         } while (read_seqcount_retry(&tk_core.seq, seq));
>
>         ts->tv_nsec = 0;
>         timespec64_add_ns(ts, nsecs);
>
> time(2) instead should actually be gettimeofday(2), which just returns
> tk->xtime_sec.  So the problem is the nanosecond part which is off by
> 2199*10^9 nanoseconds, and that is suspiciously close to 2^31...

Yep: looking at the nanosecond values as well, the difference is
exactly 2199023255552 which is 2^41.

Thanks,
Miklos
