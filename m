Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 598B0115823
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 21:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfLFUMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 15:12:50 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:40118 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfLFUMu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 15:12:50 -0500
Received: by mail-vs1-f66.google.com with SMTP id g23so5959080vsr.7
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2019 12:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8qIqii0hij1bkxybhZjCHxV2AXeFazCmihvClNmACK4=;
        b=hFrkb0uM8/P6nAJqtmj+R7SngfgUZvm+e+7iMHBWFXz/F/vp56Dwem+vLrIrKVqO5K
         sjJY/TAKc036ZQ0MXMTt9qSbDCJKAbgVwDaPFDdssrWTozQSnyOgFW54dR45jhAcTHAj
         Zi3YBzT3yt6xesOdQmmbix+5J+S8fkkFJ2sOgTOQlB2mJNdauLFd2kj48drJTiVqamOj
         qlDtzz+5yGg3Stn4KWsl70Hm6T+iSqWJ1MruFkDI/hK5Fps9XQGzrOsU43xf/MEVEpYj
         RgvuFPt4ihNiIYHqBK1Ed7JakIxEBE8RvEDJFTFs5/H5/WlI7OgjNAIxboyAq39w7RyB
         94eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8qIqii0hij1bkxybhZjCHxV2AXeFazCmihvClNmACK4=;
        b=H6DJDiel02R/qIqQm2cwYC79pjVJE1lSNPyF2MEAAPEBjtG10w5CJnk9WJccvrDESF
         MPjbYXCJQa8SarlcYXoUrx92F1F1j0lCOkTO19hpgyk0/ZSd45SmFvabTBsEDS9qzP8C
         x+a+NzpLhymR8Cikh6GrtQNkWpzJXi9C/frmqbY2iuaXbRXumzLIqNHKttdiTZH9omg/
         OBIXFcT55u/EUarf6iZJhJzxouxMZhY+qBILmblgWWdhKQknD5WIy1hOEzAKvAgYEa30
         jTDBDQitOQodYbt+kzwARjEIWvKlrt4QsAJrbsXJijrLzn3VleDITBHvD1R9jJ4sgdIm
         6n/g==
X-Gm-Message-State: APjAAAVv0XGogJtmwP7s7DnJKp14m82PYMmDagSHhyAkO2Q6noKuzPyr
        27xl6WvhHrX9aTmxqa9qV6p1/pNAmIibvxsf0+yxxA==
X-Google-Smtp-Source: APXvYqy7e6PgvbIq+FsFMOQpzwK/F212Feo+mic4TCMgsDKoNEbpjflxRTNqf+A5D/JjRsPAEAB1cGBpUKD/07aLFH0=
X-Received: by 2002:a67:1104:: with SMTP id 4mr10951470vsr.117.1575663168781;
 Fri, 06 Dec 2019 12:12:48 -0800 (PST)
MIME-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com> <20190926231824.149014-6-bgardon@google.com>
 <20191127184237.GE22227@linux.intel.com>
In-Reply-To: <20191127184237.GE22227@linux.intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Fri, 6 Dec 2019 12:12:37 -0800
Message-ID: <CANgfPd-OrT1_L=9P9kc2vhyTTLRGp3hBuxSHMESqDR2JN+i4Ag@mail.gmail.com>
Subject: Re: [RFC PATCH 05/28] sched: Add cond_resched_rwlock
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lock contention should definitely be considered. It was an oversight
on my part to not have a check for that.

On Wed, Nov 27, 2019 at 10:42 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, Sep 26, 2019 at 04:18:01PM -0700, Ben Gardon wrote:
> > Rescheduling while holding a spin lock is essential for keeping long
> > running kernel operations running smoothly. Add the facility to
> > cond_resched read/write spin locks.
> >
> > RFC_NOTE: The current implementation of this patch set uses a read/write
> > lock to replace the existing MMU spin lock. See the next patch in this
> > series for more on why a read/write lock was chosen, and possible
> > alternatives.
>
> This definitely needs to be run by the sched/locking folks sooner rather
> than later.
>
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  include/linux/sched.h | 11 +++++++++++
> >  kernel/sched/core.c   | 23 +++++++++++++++++++++++
> >  2 files changed, 34 insertions(+)
> >
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 70db597d6fd4f..4d1fd96693d9b 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1767,12 +1767,23 @@ static inline int _cond_resched(void) { return 0; }
> >  })
> >
> >  extern int __cond_resched_lock(spinlock_t *lock);
> > +extern int __cond_resched_rwlock(rwlock_t *lock, bool write_lock);
> >
> >  #define cond_resched_lock(lock) ({                           \
> >       ___might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);\
> >       __cond_resched_lock(lock);                              \
> >  })
> >
> > +#define cond_resched_rwlock_read(lock) ({                    \
> > +     __might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET); \
> > +     __cond_resched_rwlock(lock, false);                     \
> > +})
> > +
> > +#define cond_resched_rwlock_write(lock) ({                   \
> > +     __might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET); \
> > +     __cond_resched_rwlock(lock, true);                      \
> > +})
> > +
> >  static inline void cond_resched_rcu(void)
> >  {
> >  #if defined(CONFIG_DEBUG_ATOMIC_SLEEP) || !defined(CONFIG_PREEMPT_RCU)
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index f9a1346a5fa95..ba7ed4bed5036 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -5663,6 +5663,29 @@ int __cond_resched_lock(spinlock_t *lock)
> >  }
> >  EXPORT_SYMBOL(__cond_resched_lock);
> >
> > +int __cond_resched_rwlock(rwlock_t *lock, bool write_lock)
> > +{
> > +     int ret = 0;
> > +
> > +     lockdep_assert_held(lock);
> > +     if (should_resched(PREEMPT_LOCK_OFFSET)) {
> > +             if (write_lock) {
>
> The existing __cond_resched_lock() checks for resched *or* lock
> contention.  Is lock contention not something that needs (or can't?) be
> considered?
>
> > +                     write_unlock(lock);
> > +                     preempt_schedule_common();
> > +                     write_lock(lock);
> > +             } else {
> > +                     read_unlock(lock);
> > +                     preempt_schedule_common();
> > +                     read_lock(lock);
> > +             }
> > +
> > +             ret = 1;
> > +     }
> > +
> > +     return ret;
> > +}
> > +EXPORT_SYMBOL(__cond_resched_rwlock);
> > +
> >  /**
> >   * yield - yield the current processor to other threads.
> >   *
> > --
> > 2.23.0.444.g18eeb5a265-goog
> >
