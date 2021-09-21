Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10615413C73
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 23:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbhIUVb0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 17:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234730AbhIUVbX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 17:31:23 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29028C061574
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 14:29:54 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id k23so567703pji.0
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 14:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LSn/kFygvp1Gc7LYRPSl9USN2eKVUYYqQK80C4S3HbY=;
        b=btxgeKmkbIeI+ZpOc6VlwSC4J1M0NxXCmAKO/nawCIYSv8cbGywGkAH3QCnwAqLAUI
         IOyxlnQF3u2reCho4aOS27m8AURN66z+f1gzEN4gfB+N1/w2JLIXtC4yGrRdYBUrXdWC
         Vx/SNzr0zgBg66Mt5tqVTWXtqNRo1cMW1HRk7P6/aIgQitN5dojnf/rmx3fJsNEBiKh4
         2oG4JdRFZ1cCImM5O4stFWaGUi4+BBk4LEDc8ZYoSTyQQ09FyLfXbzxkQRIwj2f3Y1ux
         qkOUO+HshbP+1GDpYX5TBWF68F9+FWvzry5+DIxEzwl/5EC5N4EFZsnTQtNpn8FiRBGK
         Np7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LSn/kFygvp1Gc7LYRPSl9USN2eKVUYYqQK80C4S3HbY=;
        b=6uk7buaj6I9ZMk1M5sigBXyt3w6oXa/MUPVARZVCUp6F8jYpja7eLBD2dSUgyPOBPk
         waanmMuVIipxXHL4T0b5/RjjYR+4Ma5VrnFbZp6+edH4Pj26+M2sjfMFkivrV2Z2vBsb
         jehki3hDyz8Rhs9wHo5m8Qsp/71sBioXn4+biyszEVL1BL2zFV4b43i8kUbJhaVirY8q
         LopnhPlcHUIbO7agfw85au0AyREuiJCP0VeZ0VZbEobEdAA9FAOMlrApw5zQC2GoT5oR
         neUj+vtBqeJ+dHQTYU4Oad6Ld7nCwOQXmLqhimoCD4zrZScxZuJKex+U9MQX20aFAt+I
         GKKA==
X-Gm-Message-State: AOAM530f7nXvqEWnWQdk2HGX9N82oQ3j/jCQ2hK5US0xYcUHLpWYHqnG
        CSLXztiXOukHkrgeB5Bb0vjYog==
X-Google-Smtp-Source: ABdhPJzMgcR9UgCsbvPuA/02v4FkJblQW9htJs47A2YRdbvRMs4AQG7O660EDIsBZdZMmGrIa23JJg==
X-Received: by 2002:a17:902:bf42:b0:13d:b79f:a893 with SMTP id u2-20020a170902bf4200b0013db79fa893mr8518959pls.1.1632259793364;
        Tue, 21 Sep 2021 14:29:53 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w142sm103618pfc.47.2021.09.21.14.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 14:29:52 -0700 (PDT)
Date:   Tue, 21 Sep 2021 21:29:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: Re: [PATCH v2 05/13] perf: Force architectures to opt-in to guest
 callbacks
Message-ID: <YUpOzFW3K3iJAoWa@google.com>
References: <20210828003558.713983-1-seanjc@google.com>
 <20210828003558.713983-6-seanjc@google.com>
 <20210828194752.GC4353@worktop.programming.kicks-ass.net>
 <8ee13a69-f2c4-2413-2d6c-b6c0a559286e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ee13a69-f2c4-2413-2d6c-b6c0a559286e@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 21, 2021, Paolo Bonzini wrote:
> On 28/08/21 21:47, Peter Zijlstra wrote:
> > > +config HAVE_GUEST_PERF_EVENTS
> > > +	bool
> > 	depends on HAVE_KVM
> 
> It won't really do anything, since Kconfig does not detects conflicts
> between select' and 'depends on' clauses.

It does throw a WARN, though the build doesn't fail.

WARNING: unmet direct dependencies detected for HAVE_GUEST_PERF_EVENTS
  Depends on [n]: HAVE_KVM [=n] && HAVE_PERF_EVENTS [=y]
  Selected by [y]:
  - ARM64 [=y]

WARNING: unmet direct dependencies detected for HAVE_GUEST_PERF_EVENTS
  Depends on [n]: HAVE_KVM [=n] && HAVE_PERF_EVENTS [=y]
  Selected by [y]:
  - ARM64 [=y]

WARNING: unmet direct dependencies detected for HAVE_GUEST_PERF_EVENTS
  Depends on [n]: HAVE_KVM [=n] && HAVE_PERF_EVENTS [=y]
  Selected by [y]:
  - ARM64 [=y]

> Rather, should the symbol be selected by KVM, instead of ARM64 and X86?

By KVM, you mean KVM in arm64 and x86, correct?  Because HAVE_GUEST_PERF_EVENTS
should not be selected for s390, PPC, or MIPS.

Oh, and Xen also uses the callbacks on x86, which means the HAVE_KVM part is
arguabably wrong, even though it's guaranteed to be true for the XEN_PV case.
I'll drop that dependency and send out a separate series to clean up the arm64
side of HAVE_KVM.

The reason I didn't bury HAVE_GUEST_PERF_EVENTS under KVM (and XEN_PV) is that
there are number of references to the callbacks throught perf and I didn't want
to create #ifdef hell.

But I think I figured out a not-awful solution.  If there are wrappers+stubs for
the guest callback users, then the new Kconfig can be selected on-demand instead
of unconditionally by arm64 and x86.  That has the added bonus of eliminating
the relevant code paths for !KVM (and !XEN_PV on x86), with or without static_call.
It also obviates the needs for __KVM_WANT_GUEST_PERF_EVENTS or whatever I called
that thing.

It more or less requires defining the static calls in generic perf, but I think
that actually ends up being good thing as it consolidates more code without
introducing more #ifdefs.  The diffstats for the static_call() conversions are
also quite nice.

 include/linux/perf_event.h | 28 ++++++----------------------
 kernel/events/core.c       | 15 +++++++++++++++
 2 files changed, 21 insertions(+), 22 deletions(-)

I'll try to get a new version out today or tomorrow.
