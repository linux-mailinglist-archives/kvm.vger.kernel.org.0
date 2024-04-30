Return-Path: <kvm+bounces-16239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EC538B7C76
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 18:02:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 248941F23C4D
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 16:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E952B17966C;
	Tue, 30 Apr 2024 16:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tsd8c9aP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08250172BCC
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 16:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714492932; cv=none; b=FY5TMc+H2vJxG4yFhhzdoFyv/tljBBitEfYOtG0SXuaHIgVpgZR0Hrlov1yuzbbRXHTEFdt81XsPPxkBPVsEtuC46/JAibkibr4xMmtR2rUHo0g+ie7P19PQpzfsdxv26Vplw8Z5eN697C9jebWpbl9nWmKEp17rOXOBAtPirjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714492932; c=relaxed/simple;
	bh=t9C7Ye6tArU7Baw32FWLZftC1ohgE3SE8Qu1VszqBkA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tEj4QZS7Ch1MtzNMIYBzhNKHI29ExYd/vUcR7L+xvnW8+KoK6JEymgUrJnp5621R8ccFHkk85jle+8o5GTDKqGjyiBE822GnPHnLSkup4fze24XHpgRZyfGW0XOOQOpITGosC4hJln8MvYRECOIvPnIOQGAogX+YXkr0W0ztAKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tsd8c9aP; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61b2ef746c9so108718717b3.1
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 09:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714492929; x=1715097729; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nnx8PEh4F0H2pwvd5VJa9QAeHpiBNkwiDpkDCA/9d28=;
        b=Tsd8c9aPA3axGEFylUe+D4SNOxlu5bv7IyNh+ZARaAIkNNdyPKAI/l44JCm0R9wKHe
         PUGVpGpwH4ojSF1Pn+HYodeD7HV4jTa7d47mDAL2ba+eCt752oQkxx8VeOndXpiqSOiU
         VYiESNIqy69nO47Vh+SIXtEI4R/Ju4kukYSaXxkKPeK+Ehfb8fa+lknCP5WJk9QxiETn
         Ph+bSGj2jGQ+btVKuZEgpWf3rcZb9oe1z7BWJEn7MCKdpGWGPwj9CCs4jpPlmRKcEqr3
         zUwJv6GvP0JYmFV9Q5q3HUr08hAmNUv2tBWxkjSsgM8K4n7KOLiBqt1s1RV5QsgxYVnv
         1IQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714492929; x=1715097729;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Nnx8PEh4F0H2pwvd5VJa9QAeHpiBNkwiDpkDCA/9d28=;
        b=ab87+1ePwVxdPlbUj1czNRqTpmMHuBoTYqN8LHnjlXJwLCYs6G6oWO5c8l5kfEPIrR
         IofGmyou86xazVkT1+cQdXN37n3UHEImvQagyGYuhUmqaWJRqggaJpseffpfc64xvLcZ
         9MrXcCpCNXV7hK02Eq3Xtkpwz/7DPg70HOyLKaOKGpHJZEw1s9PRc8Po0qOK1ecNYFFh
         ex0K69HbWbcpnhylQZ78xfqbRlrIoTH+/W97N3+lTV2D3I278oe7e9NuKfOVlaHAtCoP
         n7XHAm+ZNIbkJ3b20i0ytNwfl2b9c2s6Q8HsTQli02lOFXubJxpF5Z715qLxIHJ81vtA
         YPSA==
X-Gm-Message-State: AOJu0YwjBB+Avp4G1XlI2ZUxjaWXHpe/SGy99vG0duPQM97UgkVz5Lor
	iVA7njL0QndsMCGvQF7LerBuKwRKNRQ+dBYm3qtY6dIqXHyow2Xl3UAouUAyvz0xHAhdUdIsi22
	ZAg==
X-Google-Smtp-Source: AGHT+IHKEpOrUUpr879xfqxmU8uZlro4QxVZM2T9MnKEU6UhkgNuMfrZrPFPOzrx8/CedBlpCnSRt2fJQnQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1002:b0:dd9:1db5:8348 with SMTP id
 w2-20020a056902100200b00dd91db58348mr4752342ybt.8.1714492928972; Tue, 30 Apr
 2024 09:02:08 -0700 (PDT)
Date: Tue, 30 Apr 2024 09:02:07 -0700
In-Reply-To: <38e124dcdbf5e0badedf3c0e52c72e5e9352c435.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240206151950.31174-1-vkuznets@redhat.com> <171441840173.70995.3768949354008381229.b4-ty@google.com>
 <38e124dcdbf5e0badedf3c0e52c72e5e9352c435.camel@infradead.org>
Message-ID: <ZjEV_6SpS7MEN_Cx@google.com>
Subject: Re: [PATCH v2] KVM: selftests: Compare wall time from xen shinfo
 against KVM_GET_CLOCK
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jan Richter <jarichte@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 29, 2024, David Woodhouse wrote:
> On Mon, 2024-04-29 at 13:45 -0700, Sean Christopherson wrote:
> > On Tue, 06 Feb 2024 16:19:50 +0100, Vitaly Kuznetsov wrote:
> > > xen_shinfo_test is observed to be flaky failing sporadically with
> > > "VM time too old". With min_ts/max_ts debug print added:
> > >=20
> > > Wall clock (v 3269818) 1704906491.986255664
> > > Time info 1: v 1282712 tsc 33530585736 time 14014430025 mul 358755222=
3 shift 4294967295 flags 1
> > > Time info 2: v 1282712 tsc 33530585736 time 14014430025 mul 358755222=
3 shift 4294967295 flags 1
> > > min_ts: 1704906491.986312153
> > > max_ts: 1704906506.001006963
> > > =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
> > > =C2=A0=C2=A0 x86_64/xen_shinfo_test.c:1003: cmp_timespec(&min_ts, &vm=
_ts) <=3D 0
> > > =C2=A0=C2=A0 pid=3D32724 tid=3D32724 errno=3D4 - Interrupted system c=
all
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 0x00000000004030ad: main at xen_shinfo_test.c:1003
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 0x00007fca6b23feaf: ?? ??:0
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 0x00007fca6b23ff5f: ?? ??:0
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 0x0000000000405e04: _start at ??:?
> > > =C2=A0=C2=A0 VM time too old
> > >=20
> > > [...]
> >=20
> > Applied to kvm-x86 selftests, thanks!
> >=20
> > [1/1] KVM: selftests: Compare wall time from xen shinfo against KVM_GET=
_CLOCK
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 https://github.com/kvm-x86/linux/commit/=
201142d16010
>=20
> Of course, this just highlights the fact that the very *definition* of
> the wallclock time as exposed in the Xen shinfo and MSR_KVM_WALL_CLOCK
> is entirely broken now.=20
>=20
> When the KVM clock was based on CLOCK_MONOTONIC, the delta between that
> and wallclock time was constant (well, apart from leap seconds but KVM
> has *always* been utterly hosed for that, so that's just par for the
> course). So that made sense.
>=20
> But when we switched the KVM clock to CLOCK_MONOTONIC_RAW, trying to
> express wallclock time in terms of the KVM clock became silly. They run
> at different rates, so the value returned by kvm_get_wall_clock_epoch()
> will be constantly changing.
>=20
> As I work through cleaning up the KVM clock mess, it occurred to me
> that we should maybe *refresh* the wallclock time we report to the
> guest. But I think it's just been hosed for so long that no guest could
> ever trust it for anything but knowing roughly what year it is when
> first booting, and it isn't worth fixing.
>=20
> What we *should* do is expose something new which exposes the NTP-
> calibrated relationship between the arch counter (or TSC) and the real
> time, being explicit about TAI and about live migration (a guest needs
> to know when it's been migrated and should throw away any NTP
> refinement that it's done for *itself*).
>=20
> I know we have the PTP paired reading thing, but that's *still* not
> TAI, it makes guests do the work for themselves and doesn't give a
> clean signal when live migration disrupts them.

Is the above an objection to the selftest change, or just an aside?  Honest
question, I have no preference either way; I just don't have my head wrappe=
d
around all of the clock stuff enough to have an informed opinion on what th=
e
right/best way forward is.

