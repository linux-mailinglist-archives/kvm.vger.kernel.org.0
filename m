Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF4E316798
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 14:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhBJNLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 08:11:19 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:59628 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhBJNLO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 08:11:14 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612962631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j47nNp+SD+H9c+k5EegmkzNDcoY6wFWyStCOtk4WgM0=;
        b=AMF21FWD7XWLudLEWa/MTcigwDP3U/1VqQDtWbHwbDwIoEnPgkgXe7U5Nm2wI4VcZVcCA8
        OLIfm3u8wjrOHiKU28EQj7oCcdBeF1GpYGp+N9z1eT/iDKfe3tMgzFeY3p3VFLd4pt7Bax
        rU+f4mushiUzzCj1qz7ypqgDv+x9KNLMZqqXtrV7xFMB2kLpJfz1kB3aO9PDdVSKM74d0b
        8YQaEzMchzCYo7qumv0vvOCbfw57OjuJQvTjSPFzXx9DJI9w3EKg5oX5w6hsOnWIeJe+85
        rQ3rM1cDiqKBEBhVXnAYdgcWx6W9I/Ioj1NLOVjrm0f9CzuSUechIsJrO+SdEw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612962631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j47nNp+SD+H9c+k5EegmkzNDcoY6wFWyStCOtk4WgM0=;
        b=xaevcwaELiQtvo2LwuzOJKEUnkwR3sBzAwQkH8/KaF/T0usQepGpkea8b37kwGMWTzJDC5
        jF2dOH0w7+UxHvAA==
To:     Hikaru Nishida <hikalium@chromium.org>,
        linux-kernel@vger.kernel.org
Cc:     suleiman@google.com, Hikaru Nishida <hikalium@chromium.org>,
        Alexander Graf <graf@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH 2/2] drivers/virt: introduce CLOCK_BOOTTIME adjustment sysfs interface driver
In-Reply-To: <20210210193728.RFC.2.I03c0323c1564a18210ec98fb78b3eb728a90c2d2@changeid>
References: <20210210103908.1720658-1-hikalium@google.com> <20210210193728.RFC.2.I03c0323c1564a18210ec98fb78b3eb728a90c2d2@changeid>
Date:   Wed, 10 Feb 2021 14:10:31 +0100
Message-ID: <87eehoax14.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10 2021 at 19:39, Hikaru Nishida wrote:
> From: Hikaru Nishida <hikalium@chromium.org>
>
> This adds a sysfs interface /sys/kernel/boottime_adj to enable advancing
> CLOCK_BOOTTIME from the userspace without actual susupend/resume cycles.
>
> This gives a way to mitigate CLOCK_BOOTTIME divergence between guest
> and host on virtualized environments after suspend/resume cycles on
> the host.
>
> We observed an issue of a guest application that expects there is a gap
> between CLOCK_BOOTTIME and CLOCK_MONOTONIC after the device is suspended
> to detect whether the device went into suspend or not.
> Since the guest is paused instead of being actually suspended during the
> host's suspension, guest kernel doesn't advance CLOCK_BOOTTIME correctly
> and there is no way to correct that.
>
> To solve the problem, this change introduces a way to modify a gap
> between those clocks and align the timer behavior to host's one.

That's not a solution, that's a bandaid and just creating a horrible
user space ABI which we can't get rid off anymore.

The whole approach of virt vs. pausing and timekeeping is busted as I
pointed out several times before. Just papering over it with random
interfaces which fiddle with the timekeeping internals is not going to
happen.

Thanks,

        tglx
