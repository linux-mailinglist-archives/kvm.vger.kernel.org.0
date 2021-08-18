Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1273F09BC
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 18:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbhHRQ6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 12:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbhHRQ6R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 12:58:17 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80815C061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 09:57:42 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so5579712pje.0
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 09:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UtSUrHBbqT6vHI639MuFCud7b8CUrqArLCWf9PwtDoI=;
        b=HipmoXSO8i8I6rJu/W1m5nLm+NQsgGcClby+o6A0Ymtixep+rU3uj7DJOMq6gneoDQ
         D037r96a93WnnAwhJJ4lnwQjO/mcAacI1xJtu255BIsrmh0kHkJJ12AxJy5eScu9VPYX
         y2e1BPnQn9MiG5EdS5Klnr9jiFRToq4wbLoU/gg++rtK7sh1r9RpDSu5x5nE0HQnyx2s
         xqLmQV04wGa0OIBMnV+szh1jdwZOE8rf/U0onnWGvcmZ0O4A/gxRCE+ZaV3uIgH33CY9
         Qh1AdmCGziUZWM8raIDk8DsOsTLWdnEvQ7bRHJyuyokoKnq+z3oFIT1KcQ8ALIpReYtG
         yXQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UtSUrHBbqT6vHI639MuFCud7b8CUrqArLCWf9PwtDoI=;
        b=o4kN62d6BrXdD6oZmIrnf2tMN4Q0AS/3D3PZ3HIYC/v+rs4w0//5W+ZtPp+ch3PwHR
         Z/PgzyAdMDzK65gc65U3D97UheUx17E5ooxS0gQrLoaDz/lOXlnRwxnGr6YUu2iXL9y2
         1fwmk08qmYkwLSSialvESXTVqTXp0acLUDn78g13cY2tQ4rxgc6cChuRl33KtTTPI77u
         LUytTCqxOTjgHy9om9iHE9FgFKm7wMoljEeb76TObXbH6u3lmqkjaTJBbsQ9D8QFlKci
         RyRGv8NhnD6jzXfp4q/U7q9PeuWTW7HTkc8aVwslhBZDbMiYdfjP1RoJRX7Chim3EBi9
         3Dsg==
X-Gm-Message-State: AOAM533ylGXTZ4HlXo5yuaE+8pPa2T0GaSMDHMNafMVDtazpXeiCLbDO
        73WcEdZZxBmevB9FKOetN2q1wA==
X-Google-Smtp-Source: ABdhPJx7aD/ahpjDNbfHDvmJzkViGstSM6hPM+rrk+pEYDFbS6UKBGrRRutUrTb00Gl5dswBbSuKxw==
X-Received: by 2002:a17:90a:9cf:: with SMTP id 73mr10386754pjo.136.1629305861852;
        Wed, 18 Aug 2021 09:57:41 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n32sm254558pgl.69.2021.08.18.09.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 09:57:41 -0700 (PDT)
Date:   Wed, 18 Aug 2021 16:57:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Cannon Matthews <cannonmatthews@google.com>
Subject: Re: [PATCH] KVM: stats: add stats to detect if vcpu is currently
 halted
Message-ID: <YR07//lqbJlh9woJ@google.com>
References: <20210817230508.142907-1-jingzhangos@google.com>
 <YRxKZXm68FZ0jr34@google.com>
 <CAAdAUthw0gT2_K+WzkWeEHApGqM14qpH+kuoO6WZBnjvez6ZAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAdAUthw0gT2_K+WzkWeEHApGqM14qpH+kuoO6WZBnjvez6ZAg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 18, 2021, Jing Zhang wrote:
> > > Original-by: Cannon Matthews <cannonmatthews@google.com>
> > > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > > ---
> > >  include/linux/kvm_host.h  | 4 +++-
> > >  include/linux/kvm_types.h | 2 ++
> > >  virt/kvm/kvm_main.c       | 2 ++
> > >  3 files changed, 7 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index d447b21cdd73..23d2e19af3ce 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -1459,7 +1459,9 @@ struct _kvm_stats_desc {
> > >       STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_hist,        \
> > >                       HALT_POLL_HIST_COUNT),                                 \
> > >       STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_wait_hist,             \
> > > -                     HALT_POLL_HIST_COUNT)
> > > +                     HALT_POLL_HIST_COUNT),                                 \
> > > +     STATS_DESC_COUNTER(VCPU_GENERIC, halt_block_starts),                   \
> > > +     STATS_DESC_COUNTER(VCPU_GENERIC, halt_block_ends)
> >
> > Why two counters?  It's per-vCPU, can't this just be a "blocked" flag or so?  I
> > get that all the other stats use "halt", but that's technically wrong as KVM will
> > block vCPUs that are not runnable for other reason, e.g. because they're in WFS
> > on x86.
> The two counters are used to determine the reason why vCPU is not
> running. If the halt_block_ends is one less than halt_block_starts,
> then we know the vCPU is explicitly blocked by KVM. Otherwise, we know
> there might be something wrong with the vCPU. Does this make sense?
> Will rename from "halt_block_*" to "vcpu_block_*".

Yeah, but why not do the below?  "halt_block_starts - halt_block_ends" can only
ever be '0' or '1'; if it's anything else, KVM done messed up, e.g. failed to
bump halt_block_ends when unblocking.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3e67c93ca403..aa98dec727d0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3208,6 +3208,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)

        kvm_arch_vcpu_blocking(vcpu);

+       vcpu->stat.generic.blocked = 1;
+
        start = cur = poll_end = ktime_get();
        if (vcpu->halt_poll_ns && !kvm_arch_no_poll(vcpu)) {
                ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
@@ -3258,6 +3260,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
                                ktime_to_ns(cur) - ktime_to_ns(poll_end));
        }
 out:
+       vcpu->stat.generic.blocked = 0;
        kvm_arch_vcpu_unblocking(vcpu);
        block_ns = ktime_to_ns(cur) - ktime_to_ns(start);



