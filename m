Return-Path: <kvm+bounces-72961-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qNB4HWEEqmliJgEAu9opvQ
	(envelope-from <kvm+bounces-72961-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 23:32:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D0E22218EC2
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 23:32:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7A0143031CD8
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 22:29:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F01036404B;
	Thu,  5 Mar 2026 22:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vbrs2SxY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C249F145B27
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 22:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772749754; cv=none; b=VXRojzpZBspF/O7IS/scDh/AAF9akHxK8+KVrGpV5RvrzDUDXZuhsajgh6J685W4peV9pQQE64iwv95oTn1iM80wJFsnKMshltV6Y077O2lB/FwSdJ/JT9Rs6ZSFycziZN7y6zE/5fp+5w9UhnTVLDgZMjKqvUS3Nl6mPbAhjJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772749754; c=relaxed/simple;
	bh=Hli/PWdMOCVUCM+gNtsmZJ7Kt3KS8LqRkIlXgOXduV8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WID3wCPAtLRiLcB3NQBPHMrLuoQyR8MMTSYZ+ycmw0X4c9ONf6PLrujWqwN2n1v7TvnuA/miBwVbknoVDttBzoXqfeXSP74gaIr688hsvZjVTITL4jFE4GyY8i1+XUXPLrSlrv6SJOub7kQywna6cJ9WHxmDiGVkQAQVDVuZtlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vbrs2SxY; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-359918118ebso12639504a91.2
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 14:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772749753; x=1773354553; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/o1sMjKw1NNm8NoRHmNtAwKcjHmALv2lhSG4zF2E0Pk=;
        b=vbrs2SxYuwpgv592ilUvPRcbFSiPSWwM1A/5JDKF1hmPOHi+T0Omvw+jaUBOE9fZMW
         YWv7UmZf/lPG5EXeFBMQ8xqGMt7h9IcOUGsmV7qs2QCKhw8jm/jZ4l0PL4PxgqtdjCmd
         GQdyQ7u9fgYPhWyxbPBivkXaxe+aGb7XatcGSYegE+FQ+hpgO0mPYjlLfmDM+IJSAwDv
         dWGwe3V7eBs7tixbtYBZdJdubgh2+amZ6um9ujZcvc7MSCxXJEYm2LJPmOcWwn1bguig
         XHeCARW2jKrbA8vbzJbhBMlXtLzxITUI4bGUHhUPJ9bILEQspUpn7Vr6m8TyOF+OkUlr
         ojCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772749753; x=1773354553;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/o1sMjKw1NNm8NoRHmNtAwKcjHmALv2lhSG4zF2E0Pk=;
        b=tIPyFu7mJrKiuyYsu6w7GlvreAWGj4L6zwyy3H1Dup/VMlzo7sQwdW3XDsjClXypvR
         LsXs39wNKHZQSplS8e34MKgzqUeYRo5/EQvBTD3VzPxStbXbn0G5ZFN8wVLJSuacYZfk
         7XDRzpTsskgORjLzVR7Ke8MGYFWsaiZffvdDupFgrXO4i1b8icfbIJJPZHZ69YBamCiY
         IsuCB6e/Z3sfPW57v+wKGjboH3To/zEc6NU1RK2hiaEIdU8dkSOqvooiLT0tyxqv+bEK
         xgjRtxtWsNrXYwEmBDzcpK5977SmFAiq9OKkxQcMjJqA3o3lFfKuvxYciqkwD5gt+3fx
         Pcyg==
X-Forwarded-Encrypted: i=1; AJvYcCWXQL4P2rNlz4ZS+NNpm6n63yx0Im6N4Erw8hZ+WBSy8UDbqPqpvSCk+KC830oErNrnDjI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwC803til8nSmclMeTW+SleIFwGZZ8abVE0kddGEGwKUaD7w4oz
	t0L1zRtf8shBEiPnnLW5AZ+IfEgtl660C3bylMCVQd+pGlP9TLFS05YuL4u+PIX7Z0gA7jbdowD
	w9+4A0g==
X-Received: from pjbgd21.prod.google.com ([2002:a17:90b:fd5:b0:359:92db:6c34])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2c86:b0:356:2872:9c5d
 with SMTP id 98e67ed59e1d1-359a6a6648fmr7125618a91.24.1772749752983; Thu, 05
 Mar 2026 14:29:12 -0800 (PST)
Date: Thu, 5 Mar 2026 14:29:11 -0800
In-Reply-To: <CALMp9eTSb3YrLRxnSbYQmAsK1SKA3Job6z2VjUWcKpPOGbWvRw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250804064405.4802-1-thijs@raymakers.nl> <ac94394405bf7e878c8ff0acf87db922dc4af48c.camel@infradead.org>
 <CALMp9eTSb3YrLRxnSbYQmAsK1SKA3Job6z2VjUWcKpPOGbWvRw@mail.gmail.com>
Message-ID: <aaoDtzpY-2y-c-66@google.com>
Subject: Re: [PATCH v3] KVM: x86: use array_index_nospec with indices that
 come from guest
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Thijs Raymakers <thijs@raymakers.nl>, kvm@vger.kernel.org, 
	Anel Orazgaliyeva <anelkz@amazon.de>, stable <stable@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D0E22218EC2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-72961-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On Thu, Mar 05, 2026, Jim Mattson wrote:
> On Thu, Mar 5, 2026 at 12:31=E2=80=AFPM David Woodhouse <dwmw2@infradead.=
org> wrote:
> >
> > On Mon, 2025-08-04 at 08:44 +0200, Thijs Raymakers wrote:
> > > min and dest_id are guest-controlled indices. Using array_index_nospe=
c()
> > > after the bounds checks clamps these values to mitigate speculative e=
xecution
> > > side-channels.
> > >
> >
> > (commit c87bd4dd43a6)
> >
> > Is this sufficient in the __pv_send_ipi() case?
> >
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -852,6 +852,8 @@ static int __pv_send_ipi(unsigned long *ipi_bitma=
p, struct kvm_apic_map *map,
> > >       if (min > map->max_apic_id)
> > >               return 0;
> > >
> > > +     min =3D array_index_nospec(min, map->max_apic_id + 1);
> > > +
> > >       for_each_set_bit(i, ipi_bitmap,
> > >               min((u32)BITS_PER_LONG, (map->max_apic_id - min + 1))) =
{
> > >               if (map->phys_map[min + i]) {
> >                         vcpu =3D map->phys_map[min + i]->vcpu;
> >                         count +=3D kvm_apic_set_irq(vcpu, irq, NULL);
> >                 }
> >         }
> >
> > Do we need to protect [min + i] in the loop, rather than just [min]?
> >
> > The end condition for the for_each_set_bit() loop does mean that it
> > won't actually execute past max_apic_id but is that sufficient to
> > protect against *speculative* execution?
> >
> > I have a variant of this which uses array_index_nospec(min+i, ...)
> > *inside* the loop.
>=20
> Heh. Me too!

LOL, OMG, get off your high horses you two and someone send a damn patch! =
=20

