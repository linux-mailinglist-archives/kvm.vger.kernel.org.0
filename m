Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A4251FFB
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 02:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbfFYAcz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 20:32:55 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39086 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbfFYAcz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 20:32:55 -0400
Received: by mail-ed1-f65.google.com with SMTP id m10so24332386edv.6
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2019 17:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nBkBYYZc0s8xxqgkIM92IszAEEryF8hhcj8JV1SU20A=;
        b=UXhIQBFYD2yMmcFMLp1puhsD2i9OksoE0tmnxr7K5BnwgNkxdyzcQboUIz9i20Lsz4
         3m1RTIe30lWE24I7cvsZZLLhkZgDOCOIkk9ZbG6EosmpUQjxEvoya52YQrtLyV7zH9ed
         epQ9slu7TgFvXvJ/O6QSeC0l0d5tfQ1BjsfsF+SeCivQZbElS/gZ18iF66YuOrQ/JcOD
         zhFe4na0F79DpVOMYVK7Dpm3S34HraMbgjpZtfCF2h2d+s5CnnYrRGOohH7RQ9Wj0HSM
         Xurwf4MZJZS7xJOqWZLSW/LSVgkO36dAgq2GlDTSVHZBaAcm83Tu0TMT9EcFBYadyl+r
         OB+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nBkBYYZc0s8xxqgkIM92IszAEEryF8hhcj8JV1SU20A=;
        b=t67lPZghke1gol0eWUOUqNCiPVrozu2/ta4JW59BWH53VEmPx1lY9W2ytGqe+l9aY2
         AyvEfXS3Ghxtd74HjF2Q5SOfO/klAKVYJ76VN/c53u+YaVatTSytDqMOER4wl+DpzYvY
         AKfa4Q8tQHSO2q8jZAavnT2QjrxQ9c4LR/u9kE82AJgyJyQWrjIc8MRjMUIuzDrpS/7i
         7ktjMinoIvN1vlIeGZ4cJJgA8nMNL0t5MLtgPu807DOWAqqgPWKR2xa3gfmZ2ZUgATHL
         Iyy+lw7icBNrL2RBwJVUCU8y0LD/aOoBtJUfOJHFbPGYZaCjRzph3NYqP8fpcuHyKYf1
         AsLA==
X-Gm-Message-State: APjAAAUGIcXj8gOrbjYnN5cQqaz7uY7XsWiFUNuKh/OAxsJRFPhp+zpS
        3rGBvu8ULKxWKBSgrCS8uuC9Ke2W55JTejvsspODAg==
X-Google-Smtp-Source: APXvYqzllDy+o0mw3P7xV2FKxd3VIsRlZU7rPG+3/Ts1FSD6sOvt+xhoMTQM+Dp6LA2x/CQ75QeVvVj+dgN2KOP+P5k=
X-Received: by 2002:aa7:cdc6:: with SMTP id h6mr80176428edw.5.1561422773047;
 Mon, 24 Jun 2019 17:32:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAOyeoRWfPNmaWY6Lifdkdj3KPPM654vzDO+s3oduEMCJP+Asow@mail.gmail.com>
 <5D036843.2010607@intel.com>
In-Reply-To: <5D036843.2010607@intel.com>
From:   Eric Hankland <ehankland@google.com>
Date:   Mon, 24 Jun 2019 17:32:41 -0700
Message-ID: <CAOyeoRXr4gmbBPq1RsStoPguiZB8Jxod-irYd3Dm_AGVcQRGSQ@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: x86: PMU Whitelist
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for your feedback - I'll send out an updated version
incorporating your comments shortly (assuming you don't have more
after this).

> > +struct kvm_pmu_whitelist {
> > +       __u64 event_mask;
>
> Is this "ARCH_PERFMON_EVENTSEL_EVENT | ARCH_PERFMON_EVENTSEL_UMASK"?

In most cases, I envision this being the case, but it's possible users
may want other bits - see response to the next question below.

> > +       __u16 num_events;
> > +       __u64 events[0];
>
> Can this be __u16?
> The lower 16 bits (umask+eventsel) already determines what the event is.

It looks like newer AMD processors also use bits 32-35 for eventsel
(see AMD64_EVENTSEL_EVENT/AMD64_RAW_EVENT_MASK in
arch/x86/include/asm/perf_event.h or a recent reference guide), though
it doesn't look like this has made it to pmu_amd.c in kvm yet.
Further, including the whole 64 bits could enable whitelisting some
events with particular modifiers (e.g. in_tx=0, but not in_tx=1). I'm
not sure if whitelisting with specific modifiers will be necessary,
but we definitely need more than u16 if we want to support any AMD
events that make use of those bits in the future.

> > +       struct kvm_pmu_whitelist *whitelist;
>
> This could be per-VM and under rcu?
I'll try this out in the next version.

> Why not moving this filter to reprogram_gp_counter?
>
> You could directly compare "unit_mask, event_sel"  with whitelist->events[i]
The reason is that this approach provides uniform behavior whether an
event is programmed on a fixed purpose counter vs a general purpose
one. Though I admit it's unlikely that instructions retired/cycles
wouldn't be whitelisted (and ref cycles can't be programmed on gp
counters), so it wouldn't be missing too much if I do move this to
reprogram_gp_counter. What do you think?

> I would directly return -EFAULT here.
>
> Same here.

Sounds good - I'll fix that in the next version.

> > +       pmu->whitelist = new;
>
> Forgot to copy the whitelist-ed events to new?
Yep, somehow I deleted the lines that did this - thanks for pointing it out.
