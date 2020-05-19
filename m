Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D934B1D8C55
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 02:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgESAeg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 20:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgESAeg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 20:34:36 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC94C061A0C;
        Mon, 18 May 2020 17:34:36 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id o24so10863641oic.0;
        Mon, 18 May 2020 17:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QTe3DwbwV7u1yYwjv8zRwMmpL8+NnWFqSvQxAqUEHZ4=;
        b=CH7DFSLagQRXgUOPomUrzGDkgktIZ0TNSusffZ+nGxGxMWosi7hOtcFdr2FRuMf8Ij
         hJUC2VRr5J2iMZYTUM4cufysuKpsxk0EvmGHpN83jWNu7Y+aQR29135QU2DwxqQa5+ul
         78xPNmniC3lD1DKwJZyVAQK76CtdOWdJ8kaphkt1JNqXlcvg3y0OrouuIlma3QFlMTXd
         APjSJtCjKzeswpC7EELIlPLrUDV72fkYzpXlT8as/FqDYYGIVky5qB5Q87bZOdws7OBL
         zcBYYKzLWb5hvVZPX7inGjK722tlAhevpaKYXwM46/WGTSVQuH9v8r24SUxsyZO+x/y4
         Wckg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QTe3DwbwV7u1yYwjv8zRwMmpL8+NnWFqSvQxAqUEHZ4=;
        b=O7B3UtRNpK8yY4bchbXaizJmotzAzrcTfAn9idJn9nNyaGDUtupSyySnx2Szae1HLv
         8NLNnpO7CrWP1nskcC2+wh3OJ4oR9ihEOrn82em4H8iJschlFxlrr85jPWSz6YK3bao/
         An+lKHfswZTapyv0YHm8tM4TcKlGVsAwHMQLhVtel8P7Cq8yigCfChWpnW1eCwD8ewUV
         qcLJ+jA2WN5TNCPJCBPOGpsIrt5If0puv2vZbnoANuE/OHXnsy4dMa+T0JpMFxBJL+ZO
         2PxbvYlsvJNCly5Toa7L1KTWalkHT6Gj8vj/GtFDuy0XNZy1IsYsV3BErsyuWrkhxnJL
         J0Bw==
X-Gm-Message-State: AOAM532Fj6II7V9tnAOuS78Yj0w5hB7zfjFvISZi7fd5PZqYU9IogM5z
        1MI3zNs4W3TWCF7imh+vGzkwC8whmfsS2K2FEjE=
X-Google-Smtp-Source: ABdhPJxFZKaLvbiSXB5jTrLz/6a0reF3UugxmqcLUUcsQi9KiF5O9O8Gay7dz6ku7X21bSk6r1pkZPpnJvcp8EHXk98=
X-Received: by 2002:a05:6808:988:: with SMTP id a8mr1481944oic.5.1589848475533;
 Mon, 18 May 2020 17:34:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200424054837.5138-1-dave@stgolabs.net> <20200424054837.5138-5-dave@stgolabs.net>
 <57309494-58bf-a11e-e4ac-e669e6af22f2@redhat.com>
In-Reply-To: <57309494-58bf-a11e-e4ac-e669e6af22f2@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 19 May 2020 08:34:24 +0800
Message-ID: <CANRm+CxXacjtTZe8gGLR+iH_X8QrC2R_2ncL9aMB2ukoEmn8FQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] rcuwait: Introduce rcuwait_active()
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Davidlohr Bueso <dave@stgolabs.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        will@kernel.org, joel@joelfernandes.org,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Davidlohr Bueso <dbueso@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 May 2020 at 18:36, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 24/04/20 07:48, Davidlohr Bueso wrote:
> > +/*
> > + * Note: this provides no serialization and, just as with waitqueues,
> > + * requires care to estimate as to whether or not the wait is active.
> > + */
> > +static inline int rcuwait_active(struct rcuwait *w)
> > +{
> > +     return !!rcu_dereference(w->task);
> > +}
>
> This needs to be changed to rcu_access_pointer:
>
>
> --------------- 8< -----------------
> From: Paolo Bonzini <pbonzini@redhat.com>
> Subject: [PATCH] rcuwait: avoid lockdep splats from rcuwait_active()
>
> rcuwait_active only returns whether w->task is not NULL.  This is
> exactly one of the usecases that are mentioned in the documentation
> for rcu_access_pointer() where it is correct to bypass lockdep checks.
>
> This avoids a splat from kvm_vcpu_on_spin().
>
> Reported-by: Wanpeng Li <kernellwp@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Tested-by: Wanpeng Li <wanpengli@tencent.com>
