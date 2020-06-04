Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB8F1EEB1F
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 21:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgFDT3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 15:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbgFDT3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 15:29:10 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7D4C08C5C1
        for <kvm@vger.kernel.org>; Thu,  4 Jun 2020 12:29:09 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id a25so7355131ejg.5
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 12:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j6gkV1M6uV+OuuFK+qAzr87kpluSyFv5J8BZ8QElYLA=;
        b=StfOJSo7NYLIluA/YDez5nMC1dIK8IG3hWcNjaw1BBW1jB0z7dbLt32PboLFh/6UID
         o+zydnnIKt0/MDZUcCCOCO51H9nWoWCCO9a7unK573wtplklABGFqLV6cp9E8ez0CD3n
         hU4LM/2JwJvwjrKXqi9KHdhD+zIieK6bDyVkg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j6gkV1M6uV+OuuFK+qAzr87kpluSyFv5J8BZ8QElYLA=;
        b=GtKz0NSVkx42HCrnKx5SUhVyp4vUf9d+IJr2QkKTFY5HzuR8vE7pVTgYGvR8jLk3Ic
         UFkJINC2oHgFEy/MctUAt37mTgxqvnEM0qbVBOTmwUB6N9mXhbvN6ZU8jtLU33YQN4xH
         KSnSzTU9rj3tY+oDKk+bTfpVm6f5EvdUxu6U3rioLCAJd3/sKJkaHySXnbOSRbTkIJDg
         w+wK2mLNkXWaksjL+QN/hfJ427hoNzcS9FRViHvPrtidniX0ysXEZBokm8WY91DCs9uP
         Zqy/VAJjumqVjl2phuFjyeaZRfFU7W6gw/rAL4mygvo5ce22U6AbHklYWgysO0ciPZs/
         LF4Q==
X-Gm-Message-State: AOAM531CwkOmaSkugzAA+jC/nQO/C9A86j41DEMeGWmeM1taM7V6jP79
        YuLBPbb/g8EVvNdsDbR90xGXNPFdb2EN05sY+/KqRg==
X-Google-Smtp-Source: ABdhPJw1ZDaeUGvDlk3zpLn20zmqANlllPdBvumUAZgVjw38FHbbwUHZTmBVJ0w+2d+aKUNJPm1OUHBHxYD49cYS2s8=
X-Received: by 2002:a17:906:f0c3:: with SMTP id dk3mr5082727ejb.202.1591298948511;
 Thu, 04 Jun 2020 12:29:08 -0700 (PDT)
MIME-Version: 1.0
References: <87pnagf912.fsf@nanos.tec.linutronix.de> <87367a91rn.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87367a91rn.fsf@nanos.tec.linutronix.de>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 4 Jun 2020 21:28:57 +0200
Message-ID: <CAJfpegvchB2H=NK3JU0BQS7h=kXyifgKD=JHjjT6vTYVMspY2A@mail.gmail.com>
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

On Thu, Jun 4, 2020 at 7:30 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Miklos,
>
> Thomas Gleixner <tglx@linutronix.de> writes:
> >> Of course this does not reproduce here. What kind of host is this
> >> running on? Can you provide a full demsg of the host please from boot to
> >> post resume?
> >
> > Plus /proc/cpuinfo please (one CPU is sufficient)
>
> thanks for providing the data. Unfortunately not really helpful. The
> host has a non-stop TSC and the dmesg does not contain anything which
> sheds light on this.
>
> I grabbed a similar machine, installed a guest with 5.7 kernel and I'm
> still unable to reproduce. No idea yet how to get down to the real root
> cause of this.

Well, I have neither.  But more investigation turned up some interesting things.

time(2) returns good time, while clock_gettime(2) returns bad time.
Here's an example:

time=1591298725 RT=1591300383 MONO=39582 MONO_RAW=39582 BOOT=39582
time=1591298726 RT=1591300383 MONO=39582 MONO_RAW=39582 BOOT=39582
time=1591298727 RT=1591300383 MONO=39582 MONO_RAW=39582 BOOT=39582
time=1591298728 RT=1591300383 MONO=39582 MONO_RAW=39582 BOOT=39582
time=1591298729 RT=1591300383 MONO=39582 MONO_RAW=39582 BOOT=39582

As you can see, only time(2) is updated, the others remain the same.
date(1) uses clock_gettime(CLOCK_REALTIME) so that shows the bad date.

When the correct time reaches the value returned by CLOCK_REALTIME,
the value jumps exactly 2199 seconds.

Does that make any sense?

Thanks,
Miklos
