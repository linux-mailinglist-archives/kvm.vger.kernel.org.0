Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A747C8E17
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 22:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbjJMUDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 16:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbjJMUDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 16:03:36 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6325DB7
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 13:03:35 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5a08e5c7debso1520958a12.2
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 13:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697227415; x=1697832215; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vffxO0sw6Zb0lQ2AM2IHgtRpxIRkuWcHJpB50yNrKk4=;
        b=MaUHIFF3UuDrrkbcH8UycN1Y729i91/QO7knrBnjdJ1bEkQbDKCIvVZ6XRg2cU8Jqf
         Gb9MY76yNK2BxF56WZAxDyYLphlDY+L6VzQubUmt7G7+2a7REojBUKTPXpNWfxWCpUKz
         h5t1Jek4iHyZ8L62HcJtPPM0CH2Qn+PQvFRkM3UKjhT3/M6+uQuqEVtrS8MmaUDzv6AS
         YBYkajHlWXePZq0wLrXuFSrYFLyz+mJ+LdHpNMwJke98cB9QYm5cl2ItKiimOA3bJoax
         cynqpsePu1lmYUeyAZ1Gv/7HnBb4E3t6ilQBjDzD5S7XFIU2TeqRsWdSMeubBMk8iiGa
         77xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697227415; x=1697832215;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vffxO0sw6Zb0lQ2AM2IHgtRpxIRkuWcHJpB50yNrKk4=;
        b=acer+cTlAAYKw/OdVzGH5qNd+yFnNKpvtZo7DiEd4E9lGjcd+378D64Jo8olAgfDf0
         tfo5cEFcEO40sjLCHD1s/660G54fduc1+zt7e83TNXCEcsnOZsyhTwa4B+hJx7qEP38N
         gq424Rp3oVEFNyhrW7Hqe0z7QVdjrWfZVxrP+4KmqaT05C5OIpU2OeOMaCRWAffYYQF7
         0AYJS6lecTLgrmdNK0VkiPBQmDXPe75kIgEM2M0v3sp80zHFt7QGYAW0GED+MT+GkpEA
         3v2c4SaYymu8UhcrKyo4GhEcUR5HULLfqEuuZxQT5prdjvKUfll27Q4gIsq/OJs5aLSo
         +xHw==
X-Gm-Message-State: AOJu0YwhytJl0V1By/SHXkm1CInbwn61LGo01twtNDt4bBA0GdeQMACM
        i1sU9tetedWeJwhj64EdEYMyMwkwObs=
X-Google-Smtp-Source: AGHT+IGonwtskxsEKWK2/VEwk3FOCJq5hhnqRsHBzBiWFfH/KBni4+gOTzTak2R8kVPU2PdLuYSln5EeA3o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f54d:b0:1c9:b785:bc46 with SMTP id
 h13-20020a170902f54d00b001c9b785bc46mr241059plf.12.1697227414850; Fri, 13 Oct
 2023 13:03:34 -0700 (PDT)
Date:   Fri, 13 Oct 2023 13:03:33 -0700
In-Reply-To: <3228f3dd7652146780b60419296033a79051ea75.camel@infradead.org>
Mime-Version: 1.0
References: <ZRysGAgk6W1bpXdl@google.com> <d6dc1242ff731cf0f2826760816081674ade9ff9.camel@infradead.org>
 <ZR2pwdZtO3WLCwjj@google.com> <34057852-f6c0-d6d5-261f-bbb5fa056425@oracle.com>
 <ZSXqZOgLYkwLRWLO@google.com> <8f3493ca4c0e726d5c3876bb7dd2cfc432d9deaa.camel@infradead.org>
 <ZSmHcECyt5PdZyIZ@google.com> <5ea168df6dfbe910524a381b88347636e1a6a3bc.camel@infradead.org>
 <ZSmUV3AoFWBTMx-o@google.com> <3228f3dd7652146780b60419296033a79051ea75.camel@infradead.org>
Message-ID: <ZSmilTCQ-LITYJPK@google.com>
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 13, 2023, David Woodhouse wrote:
> On Fri, 2023-10-13 at 12:02 -0700, Sean Christopherson wrote:
> > > But while I'm picking on the edge cases and suggesting that we *can*
> > > cope with some of them, I do agree with your suggestion that "let
> > > kvmclock run by itself without being clamped back to
> > > CLOCK_MONOTONIC_RAW" should be an opt *in* feature.
> >=20
> > Yeah, I'm of the mind that just because we can cope with some edge case=
s, doesn't
> > mean we should.=C2=A0 At this point, kvmclock really should be consider=
ed deprecated
> > on modern hardware.=C2=A0 I.e. needs to be supported for older VMs, but=
 shouldn't be
> > advertised/used when creating entirely new VMs.
> >=20
> > Hence my desire to go with a low effort solution for getting kvmclock t=
o play nice
> > with modern hardware.
>=20
> Yeah... although the kvmclock is also the *Xen* clock (and the clock on
> which Xen timers are based). So while I'm perfectly prepared to call
> those Xen guests "older VMs", I do still have to launch quite a lot of
> new ones the same... :)

Heh, yeah, by "new" I meant "new shapes/classes/types of VMs", not simply "=
new
instances of existing VM types".

> > > > > [1] Yes, I believe "back" does happen. I have test failures in my=
 queue
> > > > > to look at, where guests see the "Xen" clock going backwards.
> > > >=20
> > > > Yeah, I assume "back" can happen based purely on the wierdness of t=
he pvclock math.o
> > > >=20
> > > > What if we add a module param to disable KVM's TSC synchronization =
craziness
> > > > entirely?=C2=A0 If we first clean up the peroidic sync mess, then i=
t seems like it'd
> > > > be relatively straightforward to let kill off all of the synchroniz=
ation, including
> > > > the synchronization of kvmclock to the host's TSC-based CLOCK_MONOT=
ONIC_RAW.
> > > >=20
> > > > Not intended to be a functional patch...
> > >=20
> > > Will stare harder at the actual patch when it isn't Friday night.
> > >=20
> > > In the meantime, I do think a KVM cap that the VMM opts into is bette=
r
> > > than a module param?
> >=20
> > Hmm, yeah, I think a capability would be cleaner overall.=C2=A0 Then KV=
M could return
> > -EINVAL instead of silently forcing synchronization if the platform con=
ditions
> > aren't meant, e.g. if the TSC isn't constant or if the host timekeeping=
 isn't
> > using TSC.
>=20
> Right.
>=20
> > The interaction with kvmclock_periodic_sync might be a bit awkward, but=
 that's
> > easy enough to solve with a wrapper.
>=20
> At least that's all per-KVM already. We do also still need to deal with
> the mess of having a single system-wide kvm_guest_has_master_clock and
> different KVMs explicitly setting that to 1 or 0, don't we?

Hmm, I think the simplest way to handle kvm_guest_has_master_clock would be=
 to
have KVM check that the host clocksource is TSC-based when enabling the cap=
ability,
but define the behavior to be that once kvmclock is tied to the TSC, it's *=
always*
tied to the TSC, even if the host switches to a different clock source.  Th=
en VMs
for which kvmclock is tied to TSC can simply not set kvm_guest_has_master_c=
lock
and be skipped by pvclock_gtod_update_fn().

Side topic, I have no idea why that thing is an atomic.  It's just a flag t=
hat
tracks if at least one VM is using masterclock, and its only usage is to di=
sable
all masterclocks if the host stops using TSC as the clocksource for whateve=
r reason.
It really should just be a simple bool that's accessed with {READ,WRITE}_ON=
CE().
