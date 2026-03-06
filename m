Return-Path: <kvm+bounces-72973-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6GLUHN4zqmnwNAEAu9opvQ
	(envelope-from <kvm+bounces-72973-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 02:54:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CCBC821A6D3
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 02:54:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 00DDF3046523
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 01:54:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78BEA324B1E;
	Fri,  6 Mar 2026 01:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RnF+e0PE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9764733688C
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 01:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772762047; cv=none; b=AMsErgZwZUvWh9w0NSEfNDTYU2JY6/nr02N4BPMzUFahkalYWvFzmFQh2Ymb7mS4z55HF4cPGnFLvOExJFkpeut4EH407pqGRMm/alktjpIqRoEwAbAZqey9wY1oIVp6wHEVLISelDdXOT0aTrPDVf/9ibXMK96a+6f5SjFceC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772762047; c=relaxed/simple;
	bh=9yiqdcz3cdRYIWbmF4dcZW/lzkxykTTCB4jQN1wm+U0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bQLKKe3VY/ZUstKMJqXeXnPReNg+CGy+4mdUhd6KOGti05GYmSDxF6cCMOdBT9Q99ypMxWlQX3gTtEKCyIZdO2BoAAdGz73kSziRs6rg1qjNAi2x8WxcGkWg1FzhGhxePsdn77NAZ7+6uVkGR1c+AYh5n9JORoH1UUaQlxGbnvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RnF+e0PE; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354490889b6so28830211a91.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 17:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772762046; x=1773366846; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m8ciziDlbxufZRQC6FrddeCQkTWLOHur28NanEALAQg=;
        b=RnF+e0PETAqrGTo2ZeHDhKCLW9Lum3ED/uVgofRblcrxBLv+lduXt5eM7uLpBd9rjb
         Uph3Z9Lw+cByPAJWHaxBHE2HbwT5Khx7COTb/P8uVX5uVGZsArn/zAT4fzyk251sGp+C
         ifbfqHAaHk3ZRKlu/Z3vQQ9JJ8JR/sK9TCCgqliZ2SOcJx8RxBy1q3Gk4mQBg0XGH+zT
         Uzdce3uK4sHX8Rkf3tCrNiHIk8jDxWBJ7GyvwPw+xJNRaQMCuIWVJwybo9g0zA6IMuAw
         rx3AsYb18Zxn3VOQkXjr51OuGZP9RFKjHUQ8e5cHx7ToCZYmEw3XDWcw0He0uwG6GzeM
         Yagw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772762046; x=1773366846;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m8ciziDlbxufZRQC6FrddeCQkTWLOHur28NanEALAQg=;
        b=JxmIjZePHQrDuWNVq+ViI7KNMxOYdTH+bC+PQrwNyyTPxdEqmjr7TZFOa4isTrexvA
         FkI2TNmut+EVItO5p3af5lEAItMB4pM7h4HlXz7A6wtEBdPwfUrATF79XIMKIJzleSVq
         Evbu7nSkIfewAGTQ2G3L/OffIMylObaDUXY6rNLpeH2SE9yQXXUq9xi/rJUeL+buElKj
         2yNmyMqjy/6itz5yEEW1Y06T9gLUbtlAuWnUYi11cf3U/jZS/MWMPehPTiuYqrAoFQoA
         PBVkafBgKTAgLqXp9qtx1Saz8HUNElHkAUgxcaFwCDnbuaCkEUI8WpOH5sTg9ZaMrPCW
         qsFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXf/ag4CkFrEi50mhlq7yU+31SBgoJjBJEuNNFjrFVyY5UjDxcXYRu55RlNO35BbI/uWBY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwBpYXiakjM1BUZo+3Aa0GelIIZNUHRoUczlrpcO/+FMzoQng8
	QuBc7akLA3uh6k0IcB5iHUguH5WOmf9/+flZ1MuG1wR5BlAcRi3cnyjarySk5JCk97HxvwQVPB4
	mwUGZZg==
X-Received: from pjhk31.prod.google.com ([2002:a17:90a:4ca2:b0:359:8225:ed4e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:48:b0:359:8411:a40
 with SMTP id 98e67ed59e1d1-359be140e43mr481078a91.0.1772762045798; Thu, 05
 Mar 2026 17:54:05 -0800 (PST)
Date: Thu, 5 Mar 2026 17:54:04 -0800
In-Reply-To: <FFDA9F60-F0AD-4A92-8203-40DE82A921A7@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250804064405.4802-1-thijs@raymakers.nl> <ac94394405bf7e878c8ff0acf87db922dc4af48c.camel@infradead.org>
 <CALMp9eTSb3YrLRxnSbYQmAsK1SKA3Job6z2VjUWcKpPOGbWvRw@mail.gmail.com>
 <aaoDtzpY-2y-c-66@google.com> <FFDA9F60-F0AD-4A92-8203-40DE82A921A7@infradead.org>
Message-ID: <aaozvNtzczwlyz_3@google.com>
Subject: Re: [PATCH v3] KVM: x86: use array_index_nospec with indices that
 come from guest
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jim Mattson <jmattson@google.com>, Thijs Raymakers <thijs@raymakers.nl>, kvm@vger.kernel.org, 
	Anel Orazgaliyeva <anelkz@amazon.de>, stable <stable@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CCBC821A6D3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-72973-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On Thu, Mar 05, 2026, David Woodhouse wrote:
> On 5 March 2026 23:29:11 CET, Sean Christopherson <seanjc@google.com> wro=
te:
> >On Thu, Mar 05, 2026, Jim Mattson wrote:
> >> On Thu, Mar 5, 2026 at 12:31=E2=80=AFPM David Woodhouse <dwmw2@infrade=
ad.org> wrote:
> >> >
> >> > On Mon, 2025-08-04 at 08:44 +0200, Thijs Raymakers wrote:
> >> > > min and dest_id are guest-controlled indices. Using array_index_no=
spec()
> >> > > after the bounds checks clamps these values to mitigate speculativ=
e execution
> >> > > side-channels.
> >> > >
> >> >
> >> > (commit c87bd4dd43a6)
> >> >
> >> > Is this sufficient in the __pv_send_ipi() case?
> >> >
> >> > > --- a/arch/x86/kvm/lapic.c
> >> > > +++ b/arch/x86/kvm/lapic.c
> >> > > @@ -852,6 +852,8 @@ static int __pv_send_ipi(unsigned long *ipi_bi=
tmap, struct kvm_apic_map *map,
> >> > >       if (min > map->max_apic_id)
> >> > >               return 0;
> >> > >
> >> > > +     min =3D array_index_nospec(min, map->max_apic_id + 1);
> >> > > +
> >> > >       for_each_set_bit(i, ipi_bitmap,
> >> > >               min((u32)BITS_PER_LONG, (map->max_apic_id - min + 1)=
)) {
> >> > >               if (map->phys_map[min + i]) {
> >> >                         vcpu =3D map->phys_map[min + i]->vcpu;
> >> >                         count +=3D kvm_apic_set_irq(vcpu, irq, NULL)=
;
> >> >                 }
> >> >         }
> >> >
> >> > Do we need to protect [min + i] in the loop, rather than just [min]?
> >> >
> >> > The end condition for the for_each_set_bit() loop does mean that it
> >> > won't actually execute past max_apic_id but is that sufficient to
> >> > protect against *speculative* execution?
> >> >
> >> > I have a variant of this which uses array_index_nospec(min+i, ...)
> >> > *inside* the loop.
> >>=20
> >> Heh. Me too!
> >
> >LOL, OMG, get off your high horses you two and someone send a damn patch=
! =20
>=20
> Heh, happy to, but it was actually a genuine question. Our pre-embargo
> patches did it in the loop but the most likely explanation seemed to be t=
hat
> upstream changed it as a valid optimization (because somehow the loop was=
n't
> vulnerable?), and that we *can* drop the old patches in favour of the
> upstream one.
>=20
> If no such reason exists for why the patch got changed, I'm happy to post=
 the
> delta.

AFAIK, there was no such justification.  I'm pretty sure the only upstream =
version
I've ever seen is what ended up in-tree.

Speculation stuff definitely isn't my area of expertise.  Honestly, you, Ji=
m, and
a few others are who I'd go bug for answers for this sort of thing, so unle=
ss
someone chimes in with a strong argument for the current code, I say we go =
with
the more conservative approach.

