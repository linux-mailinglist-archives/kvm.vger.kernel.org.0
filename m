Return-Path: <kvm+bounces-14898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80B998A76E0
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 23:39:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38DFE281F15
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 21:39:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1A6B13BAC6;
	Tue, 16 Apr 2024 21:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XcihlohY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FCD13B292
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 21:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713303416; cv=none; b=oFUFqnhaksaDnSbC8P1xKsgMhhsJmouzwcEbdtl4Qv8/DlaaDHjDYe4Rtlym2r2OkJUaPjxdAEoV88m3WjoUu2sjpNi00bVDo79aO7YSQO0U/4UGhp5/nJI+eSRUWj6DrM2GkTXmS/E+QxJSWMvJNIXXYZIEJ1iwzmlT5CMKj3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713303416; c=relaxed/simple;
	bh=c3EoyWM19DUSeIavFgvY6oD+s9pl5dwzlLm7a+SK04M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LYDsLQDv5hk4JntLvxo8TAKAu6rJ5rIDzAO8MHn5LzxRbTT8/Om/QlfRnKvwSYHSWtc/LbY2ILKg4lXi3OFNwM647crakoq0jpNsT2u4MFuKrVwDDYPiDrp4pzZDTFuCJ/FTHJRPX5jI7WB3Mrene3Ryl38lcgm+VQe7eJhQWjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XcihlohY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713303414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H0qLih9CVo//sQPGcjSldQT1UvSQG7AJG7QoYxruR5c=;
	b=XcihlohYkoTGI1dlijb4xDDTq+yjX/DKKDaa5XOOX35ZJyJkMDtwxXV72XIExfVptkDLO5
	eQumzaZk4qJmk3pz+TNht5S1HxxSoLsHO6USWnIhB/f1F0BMhkhAh/r07D8OPeR00m/G50
	UQuW+8su8vtWYjvaOxBiZByC4rm02pU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-MJid2VNBPuCkHtu0eBXDpQ-1; Tue, 16 Apr 2024 17:36:50 -0400
X-MC-Unique: MJid2VNBPuCkHtu0eBXDpQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-343da0a889dso3691286f8f.0
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 14:36:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713303409; x=1713908209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H0qLih9CVo//sQPGcjSldQT1UvSQG7AJG7QoYxruR5c=;
        b=FDtp71nYzevdYg2Jzc6tG5xyh/L4jEFzIp1jMgE4mMb3/xByui+C7UNMxHAzLRZRYh
         45o88RUuz7wzvqQnjFMEp0xc9bvDBrgspTkgcZjf1a3Q3XtsB5Z78smAlHEHB6wpB5Ol
         /7MCcuNd9voDZVTt1Tr780DGvK2JIMXlyw5ItFd55G/pJ6e7v2iqHCiyI0BmUjeLW3fU
         /Bcd7DRAwTu6I5CDXOo/SwEYUYvOaIPgnyUmI0dt5ZMxYP6qoEVJxsM+IsqO7Cy2ouFF
         +97GQEJGNRTRqccy8tqoDkaogQQe/fpJchF7zJw4rSol4XJoxgbmJ6GFBYVAqE3QMFcP
         l8lw==
X-Forwarded-Encrypted: i=1; AJvYcCWOa5K0UX8OM7hlFklqqnfSFnD+kiKcc35DktRfItBeeaztlzmPYnG8orORvywREq/mNBGY2PYfZUSk1JZY6YgirQGr
X-Gm-Message-State: AOJu0Yyr82ZZgWsPc8HONI46k8k/2KHit0nrxogtelY/HjIzIlPVb1Ag
	CZ9sr5QAyjdnH5l8oyVYSTpVrMkeBrJLQLdDAjzPp47vWfl+juEdeUFbZe0mDe3uwgE/H/MagbQ
	aLy/5PgTHF9c1lkMF0lB9qCxuocPTIQATSG3BvMO2b/YEPxqaWet5qiT7rzfDAzL+l47dbZwJL1
	ApxhofQrVgliXiw2o4af+hSDD6
X-Received: by 2002:a5d:4d03:0:b0:346:c6e6:b7a3 with SMTP id z3-20020a5d4d03000000b00346c6e6b7a3mr10055940wrt.27.1713303409633;
        Tue, 16 Apr 2024 14:36:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEH2aalsqR17NVaw3iwl23TCGdtUkDF3Z86K6sf3k8FdRa0FuECZeJaDo/mZHzWA4PU75JXSod12XE1eLB57eI=
X-Received: by 2002:a5d:4d03:0:b0:346:c6e6:b7a3 with SMTP id
 z3-20020a5d4d03000000b00346c6e6b7a3mr10055930wrt.27.1713303409298; Tue, 16
 Apr 2024 14:36:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240215160136.1256084-1-alejandro.j.jimenez@oracle.com>
 <Zh6-h0lBCpYBahw7@google.com> <CABgObfZ4kqaXLaOAOj4aGB5GAe9GxOmJmOP+7kdke6OqA35HzA@mail.gmail.com>
 <4cdf71ca-c4e4-49a5-a64d-d0549ad2cf7b@oracle.com>
In-Reply-To: <4cdf71ca-c4e4-49a5-a64d-d0549ad2cf7b@oracle.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 16 Apr 2024 23:36:36 +0200
Message-ID: <CABgObfZugCVm7xysXBB=OZhQumga1bvit8oXbfhyjk7ncCa4NA@mail.gmail.com>
Subject: Re: [RFC 0/3] Export APICv-related state via binary stats interface
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, mark.kanda@oracle.com, 
	suravee.suthikulpanit@amd.com, mlevitsk@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 16, 2024 at 11:29=E2=80=AFPM Alejandro Jimenez
<alejandro.j.jimenez@oracle.com> wrote:
>
>
>
> On 4/16/24 15:51, Paolo Bonzini wrote:
> > On Tue, Apr 16, 2024 at 8:08=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> >>
> >> On Thu, Feb 15, 2024, Alejandro Jimenez wrote:
> >>> The goal of this RFC is to agree on a mechanism for querying the stat=
e (and
> >>> related stats) of APICv/AVIC. I clearly have an AVIC bias when approa=
ching this
> >>> topic since that is the side that I have mostly looked at, and has th=
e greater
> >>> number of possible inhibits, but I believe the argument applies for b=
oth
> >>> vendor's technologies.
> >>>
> >>> Currently, a user or monitoring app trying to determine if APICv is a=
ctually
> >>> being used needs implementation-specific knowlegde in order to look f=
or specific
> >>> types of #VMEXIT (i.e. AVIC_INCOMPLETE_IPI/AVIC_NOACCEL), checking GA=
Log events
> >>> by watching /proc/interrupts for AMD-Vi*-GA, etc. There are existing =
tracepoints
> >>> (e.g. kvm_apicv_accept_irq, kvm_avic_ga_log) that make this task easi=
er, but
> >>> tracefs is not viable in some scenarios. Adding kvm debugfs entries h=
as similar
> >>> downsides. Suravee has previously proposed a new IOCTL interface[0] t=
o expose
> >>> this information, but there has not been any development in that dire=
ction.
> >>> Sean has mentioned a preference for using BPF to extract info from th=
e current
> >>> tracepoints, which would require reworking existing structs to access=
 some
> >>> desired data, but as far as I know there isn't any work done on that =
approach
> >>> yet.
> >>>
> >>> Recently Joao mentioned another alternative: the binary stats framewo=
rk that is
> >>> already supported by kernel[1] and QEMU[2].
> >>
> >> The hiccup with stats are that they are ABI, e.g. we can't (easily) di=
tch stats
> >> once they're added, and KVM needs to maintain the exact behavior.
> >
> > Stats are not ABI---why would they be? They have an established
> > meaning and it's not a good idea to change it, but it's not an
> > absolute no-no(*); and removing them is not a problem at all.
> >
> > For example, if stats were ABI, there would be no need for the
> > introspection mechanism, you could just use a struct like ethtool
> > stats (which *are* ABO).
> >
> > Not everything makes a good stat but, if in doubt and it's cheap
> > enough to collect it, go ahead and add it. Cheap collection is the
> > important point, because tracepoints in a hot path can be so expensive
> > as to slow down the guest substantially, at least in microbenchmarks.
> >
> > In this case I'm not sure _all_ inhibits makes sense and I certainly
> > wouldn't want a bitmask,
>
> I wanted to be able to query enough info via stats (i.e. is APICv active,=
 and if
> not, why is it inhibited?) that is exposed via the other interfaces which=
 are not
> always available. That unfortunately requires a bit of "overloading" of
> the stat as I mentioned earlier, but it remains cheap to collect and expo=
se.
>
> What would be your preferred interface to provide the (complete) APICv st=
ate?
>
>   but a generic APICv-enabled stat certainly
> > makes sense, and perhaps another for a weirdly-configured local APIC.
>
> Can you expand on what you mean by "weirdly-configured"? Do you mean some=
thing
> like virtual wire mode?

I mean any of

    APICV_INHIBIT_REASON_HYPERV,
    APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED,
    APICV_INHIBIT_REASON_APIC_ID_MODIFIED,
    APICV_INHIBIT_REASON_APIC_BASE_MODIFIED,
    APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED,

which in practice are always going to be APICV_INHIBIT_REASON_HYPERV
on 99.99% of the gues

ExtINT is visible via irq_window_exits; if you are not running nested,
do not have the problematic configurations above. don't have debugging
(BLOCKIRQ) or in-kernel PIT with reinjection, that's basically the
only one that's left.

Paolo

> Alejandro
>
> >
> > Paolo
> >
> > (*) you have to draw a line somewhere. New processor models may
> > virtualize parts of the CPU in such a way that some stats become
> > meaningless or just stay at zero. Should KVM not support those
> > features because it is not possible anymore to introspect the guest
> > through stat?
> >
> >> Tracepoints are explicitly not ABI, and so we can be much more permiss=
ive when it
> >> comes to adding/expanding tracepoints, specifically because there are =
no guarantees
> >> provided to userspace.
> >>
> >
> >
>


