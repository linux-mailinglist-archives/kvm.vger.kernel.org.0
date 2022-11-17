Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6C262E9DF
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 00:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240377AbiKQXts (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 18:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbiKQXtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 18:49:46 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA65712D02
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 15:49:45 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id v28so3283662pfi.12
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 15:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CmUlPv6JN6E1EH9fXrvK0C0oF8i3G3CmzUIka+xcvXs=;
        b=Hh0rjMM4zU3zXlbrZ725wJpUrlAa3OuUI8sFZVvhI06eOIhV+ZsP/zqhwF1hByqQX8
         jgeH9E1LWmvOTjoMo+kFAWj25H8dDGDCuUYeDX2p0MMn2kbAt9BvCW47PUcJ/ZG/jJo/
         FV0/+kVveq6Isr2U74mnsKqpodi0IF5OGqiGjN9l92KhU83URPVMyXsvWuXGnhkbbvdM
         10mPan/7DMQcfcxFW+mlYf/ImSDivB+vZxyywW5TJXLW+XHvQ6/CD3yu77CcLvGVgMv5
         Okypl99k2mTqC+M3V4dX0rzCQPrlVjUluDeHuZxEc5qFxF5ZldgisKEUH8Zz4S7i7gPk
         NHlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CmUlPv6JN6E1EH9fXrvK0C0oF8i3G3CmzUIka+xcvXs=;
        b=MDO9EwLfzEBIlKUXh40wzWd3SSrmQpi5MFTWAPgbnaC2mhF/xvqn+6fuqB3suHkwHe
         zTJK6fdT4a/y1YtAWv1LxnIxSO8U1POKzK6JvApeFv0SwSwRzir+LFmLztRzh59GW8Zi
         VyvpIMZpWbHNbSnztyQTmFcO+faUDOZUFxDMv8kZsQMzLCy46OCiAZaxBUIXPpFS9DSt
         EKtzKwhLv/a39PM+iwKlob1zQOjGcHl6PqeZDxyTKqx/BptS5PrODkQk//YPPx3OWWFl
         W5dWAcFNBk/ceCWeLByXP6eBOC5m5ea64qFXv5kWXRvEJk+9tI5TyNuRTI/twvf8me2O
         /IYw==
X-Gm-Message-State: ANoB5pnCzo8r5K7AQq7FFBTzkCNC+bUZwEPu5A8EEGCoUh0hazgvJ/bv
        bpTEYQCX8b3U/RewL4lTOp1qtw==
X-Google-Smtp-Source: AA0mqf6VeeKqOlh/ycfiTYZVamS2IcRj4ymO4WUrKLmOXjEbTHOAWE4tqnUNJfU9JEtpOHDyx2RKxQ==
X-Received: by 2002:a63:495e:0:b0:470:75a1:c6d7 with SMTP id y30-20020a63495e000000b0047075a1c6d7mr4239749pgk.120.1668728985096;
        Thu, 17 Nov 2022 15:49:45 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h21-20020a17090acf1500b0021870b2c7absm1429863pju.42.2022.11.17.15.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 15:49:44 -0800 (PST)
Date:   Thu, 17 Nov 2022 23:49:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Reiji Watanabe <reijiw@google.com>, kvm@vger.kernel.org,
        Colin Ian King <colin.i.king@gmail.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Gautam Menghani <gautammenghani201@gmail.com>,
        Peter Gonda <pgonda@google.com>,
        Vishal Annapurve <vannapurve@google.com>
Subject: Re: [GIT PULL] KVM: selftests: Early pile of updates for 6.2
Message-ID: <Y3bIlLI6SgmD7P5j@google.com>
References: <Y3WKCRJbbvhnyDg1@google.com>
 <861qq1ptew.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861qq1ptew.wl-maz@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 17, 2022, Marc Zyngier wrote:
> On Thu, 17 Nov 2022 01:10:33 +0000,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > Please pull a set of selftests updates for 6.2.  Many of these changes are
> > prep work for future selftests, e.g. for SEV and TDX, and/or have myriad
> > conflicts, e.g. the former "perf util" code.  I am hoping to get these
> > changes queued up for 6.2 sooner than later so that the chain of dependent
> > work doesn't get too long.
> > 
> > Except for the ARM single-step changes[*], everything has been posted for
> > quite some time and/or has gone through multiple rounds of review.
> > 
> > The ARM single-step changes are a last minute fix to resolve a hilarious
> > (IMO) collision between the pool-based ucall implementation and the
> > recently added single-step test.  Turns out that GCC will generate older
> > flavors of atomics that rely on a monitor to detect conflicts, and that
> 
> A quick nit, and to make things clear: there is no "older flavours of
> atomics". These are exclusive accesses, and atomics are, well,
> atomics.

Heh, good to know even ARM doesn't consider them atomics.

> The tests seem to use the former, which cannot guarantee forward progress.
> Yes, this is utter crap.

Ya, it's gcc-12's built-in "atomics" :-(

> > monitor is cleared by eret.  gdb is allegedly smart enough to skip over
> > atomic sequences, but our selftest... not so much.
> 
> I'm not sure how GDB performs this feat without completely messing
> things up in some cases...
> 
> But it brings another question. Shouldn't these tests actively use
> atomics when on 8.1+ HW?

tools/ doesn't exactly have robust arch-specific support, e.g. the x86 versus the
world stuff is a big hack:

#if defined(__i386__) || defined(__x86_64__)
#include "../../arch/x86/include/asm/atomic.h"
#else
#include <asm-generic/atomic-gcc.h>
#endif

Patching in modern alternatives, especially in the guest code, would be quite
rough.

Oliver suggested trying "-march=armv8.1-a" to get gcc to use actual atomics, but
that obviously requires knowing the target hardware.
