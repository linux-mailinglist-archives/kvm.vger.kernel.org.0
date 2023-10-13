Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB9D7C8D69
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 21:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbjJMTCv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 15:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjJMTCu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 15:02:50 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E59B95
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 12:02:49 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-27d0a173c7bso1948567a91.3
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 12:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697223769; x=1697828569; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ezE2irapYgf+YDmCO+ecdM4YYnOHGtV+6PhfUW/a4YY=;
        b=WtM5iYcZ0vQKSZZu7rJE8xA6RbvNvyNAbvufCAgnTHRVKQKmPp/AnzESJFM74PmErn
         paN5MgssmZFSLw3kI4TSjpb3xpGfBEC6BlBRlBKw8/Ofdlwz6FGko6oWBgY+V1+WIOuA
         9VPKcrFmXIm9lisw9UTH1gj5bFOEV0Nclvx+VjZlhdRrE0Op+cUGol6uLqYsOdXdjZNk
         IHKsFOmBLNmj6O8ninCMzQrEA5S5ZH7qmYxHPKmeob926gOMh7/l0C8OxQhNgtnF4vcS
         HJLXqLAzlS7wz9NqY3lJxzVFZxPfykRaLvyCkF2oPDbxMnCX9r/vCfG3Mm+RJRkq3vXd
         iCZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697223769; x=1697828569;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ezE2irapYgf+YDmCO+ecdM4YYnOHGtV+6PhfUW/a4YY=;
        b=sbOa9HGsfeMP2OPgNEx0jIKfjYz3OHPhoio+BoD7zfPjz9vPmTDx3YPcXUQmwnNxvd
         7AL+5/GXyxB7mc3RdO9v0H5IzBSbCdsk8ruUN/wEDK4D0xtzD0HCLGxlq17uKEF5hI5j
         FBK3NonMp9jsaMzb0VbEi4yKogo01q84+HFfrspVZ2XMzcu1o6P53Bi3Ue1rf4yw1BHe
         bFkxxj6WHqtKZZTr+8S04QcKcm5x1772vlrCbenWAaqDiUSwDLtDf01lowa7IWGUyvHL
         OfzNf8/OQ3lK3fK6mfwI+AdWg4lNnd6mG0nAD2ZOGDxNNwAJM87MgQigDcqJdpiGys7o
         BssA==
X-Gm-Message-State: AOJu0YxCKdcRmOIDRwpUU8WMPcz86nTG1hvEeQIBV8Ny1/0qQjGlsvJV
        9kYf+oU3LgClzSd8yaAY8cfDeWxoIYQ=
X-Google-Smtp-Source: AGHT+IFsRDjBWN+t3sGf9QNb0ZMoT2HmbFQflBNsCIqmCQ1tXfo/BQiXBdPZIocaFxyPZNEYUCGoo663YvE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c705:b0:27d:1af4:2ef3 with SMTP id
 o5-20020a17090ac70500b0027d1af42ef3mr165731pjt.3.1697223768664; Fri, 13 Oct
 2023 12:02:48 -0700 (PDT)
Date:   Fri, 13 Oct 2023 12:02:47 -0700
In-Reply-To: <5ea168df6dfbe910524a381b88347636e1a6a3bc.camel@infradead.org>
Mime-Version: 1.0
References: <ZRtl94_rIif3GRpu@google.com> <9975969725a64c2ba2b398244dba3437bff5154e.camel@infradead.org>
 <ZRysGAgk6W1bpXdl@google.com> <d6dc1242ff731cf0f2826760816081674ade9ff9.camel@infradead.org>
 <ZR2pwdZtO3WLCwjj@google.com> <34057852-f6c0-d6d5-261f-bbb5fa056425@oracle.com>
 <ZSXqZOgLYkwLRWLO@google.com> <8f3493ca4c0e726d5c3876bb7dd2cfc432d9deaa.camel@infradead.org>
 <ZSmHcECyt5PdZyIZ@google.com> <5ea168df6dfbe910524a381b88347636e1a6a3bc.camel@infradead.org>
Message-ID: <ZSmUV3AoFWBTMx-o@google.com>
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock periodically
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Dongli Zhang <dongli.zhang@oracle.com>,
        Joe Jin <joe.jin@oracle.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 13, 2023, David Woodhouse wrote:
> On Fri, 2023-10-13 at 11:07 -0700, Sean Christopherson wrote:
> > I generally support the idea, but I think it needs to an opt-in from us=
erspace.
> > Essentially a "I pinky swear to give all vCPUs the same TSC frequency, =
to not
> > suspend the host, and to not run software/firmware that writes IA32_TSC=
_ADJUST".
> > AFAICT, there are too many edge cases and assumptions about userspace f=
or KVM to
> > safely couple kvmclock to guest TSC by default.
>=20
> I think IA32_TSC_ADJUST is OK, isn't it? There is a "real" TSC value
> and if vCPUs adjust themselves forward and backwards from that, it's
> just handled as a delta.

I meant the host writing IA32_TSC_ADJUST.  E.g. if a host SMM handler mucks=
 with
TSC offsets to try and hide the time spent in the SMM handler, then the pla=
tform
owner gets to keep the pieces.

> And we solved 'give all vCPUS the same TSC frequency' by making that
> KVM-wide.
>=20
> Maybe suspending and resuming the host can be treated like live
> migration, where you know the host TSC is different so you have to make
> do with a delta based on CLOCK_TAI.
>=20
> But while I'm picking on the edge cases and suggesting that we *can*
> cope with some of them, I do agree with your suggestion that "let
> kvmclock run by itself without being clamped back to
> CLOCK_MONOTONIC_RAW" should be an opt *in* feature.

Yeah, I'm of the mind that just because we can cope with some edge cases, d=
oesn't
mean we should.  At this point, kvmclock really should be considered deprec=
ated
on modern hardware.  I.e. needs to be supported for older VMs, but shouldn'=
t be
advertised/used when creating entirely new VMs.

Hence my desire to go with a low effort solution for getting kvmclock to pl=
ay nice
with modern hardware.

> > > [1] Yes, I believe "back" does happen. I have test failures in my que=
ue
> > > to look at, where guests see the "Xen" clock going backwards.
> >=20
> > Yeah, I assume "back" can happen based purely on the wierdness of the p=
vclock math.o
> >=20
> > What if we add a module param to disable KVM's TSC synchronization craz=
iness
> > entirely?=C2=A0 If we first clean up the peroidic sync mess, then it se=
ems like it'd
> > be relatively straightforward to let kill off all of the synchronizatio=
n, including
> > the synchronization of kvmclock to the host's TSC-based CLOCK_MONOTONIC=
_RAW.
> >=20
> > Not intended to be a functional patch...
>=20
> Will stare harder at the actual patch when it isn't Friday night.
>=20
> In the meantime, I do think a KVM cap that the VMM opts into is better
> than a module param?

Hmm, yeah, I think a capability would be cleaner overall.  Then KVM could r=
eturn
-EINVAL instead of silently forcing synchronization if the platform conditi=
ons
aren't meant, e.g. if the TSC isn't constant or if the host timekeeping isn=
't
using TSC.

The interaction with kvmclock_periodic_sync might be a bit awkward, but tha=
t's
easy enough to solve with a wrapper.
