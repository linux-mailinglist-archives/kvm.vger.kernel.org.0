Return-Path: <kvm+bounces-70598-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KNmAMlXniWmdDwAAu9opvQ
	(envelope-from <kvm+bounces-70598-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 14:55:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C91610FEB3
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 14:55:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EA236300A754
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 13:55:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC3CA37996D;
	Mon,  9 Feb 2026 13:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hpgeyon6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EU5DKUu1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A1E36604D
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 13:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770645325; cv=pass; b=s8xCdYkx1iOI5Jq528gcTa8QFtqO2xCpFf7DAmfFV24nX+0wZSEv/7WuL/wxvDq2sOwO1pOzZhh7K2Kz7R+bBjEHkHaUdyw6Opsl/KsGUwG0xLzR2B6Y9bMWQ9gMMXVxT6VngJJHnRaF/4Qdms5jd6IWH7P3zyFTobjoBJUWO7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770645325; c=relaxed/simple;
	bh=QrXQFd+cy1rwTM9gtQ2eVvR5NbatZLIDRsG3qt2Jc3c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jZnFztGSgFArHSDxDyOyVyNH3U8IRQool8rT1XzH5g9k4EXx7CFhwYPAPwtqYH1WCs82/o7a3z1hmyRrJjYy0sFOiwq+KMuWyz9GscBjmTzwT78kUG8NPgjUC8QUQrDZBh/G/nMDC0Dr8WQ0gm4NrlctAR4Cj2yJYLyASebtwPY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hpgeyon6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EU5DKUu1; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770645323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IYbx074fuAgyO8RGb6D+Pi1xYeIRePOLZjOYGfAnwY4=;
	b=hpgeyon6lY4h13LacBStE1oSz34/H1WpiCGMZLskjA0rNA+e1qY+Y3Zekdk3d9fCjTF+mM
	E3saTtKgyCjGsuG8/0NDG8uRs1SaupRhPGCpRsPzo3/rPtsx7xrp/rMEXdLs5Kbh7eAMmZ
	S6lXDbb9b3o45KL9Cw3x9X5kQXqoCUc=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-ZSMMB_nTOuSEm82cxbB8MA-1; Mon, 09 Feb 2026 08:55:22 -0500
X-MC-Unique: ZSMMB_nTOuSEm82cxbB8MA-1
X-Mimecast-MFC-AGG-ID: ZSMMB_nTOuSEm82cxbB8MA_1770645321
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2a94369653aso45555655ad.1
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 05:55:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770645321; cv=none;
        d=google.com; s=arc-20240605;
        b=iC+60NWXo/7P48Wscv1tbThHHCR4QP92z/xmbcAsVECQWt98riNcIh2lyaVNQh0g+2
         A7E9AQ/ZvVSYSnK/epU2frJzUhRGh3iKiIdXw41EeCcxqlho0rN3rAXUQshMY+1upeXS
         TXazj9/oVaOtLSZYkwKFJI1TkyJYqz+7zDAriwcDyOWJhkTN9RjuSQldeTttdKKmEfgO
         nfoQij8ndfOB59QXV5GqBfeqVZZ2kKo9GTh6eTC5bzxWIx6awGRiTSdWT9KCNDlsQjsL
         xe3gijj7gO0cLV5e4Gg8a3gVUd1xl3Pht9+5YsLwak6nzbBo/g+UCeToclYl2QctSgfS
         KyjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IYbx074fuAgyO8RGb6D+Pi1xYeIRePOLZjOYGfAnwY4=;
        fh=tH8NWWTBuNk3rkk+8ZayWKHfc3WYz7XSM7+Ji8KX/es=;
        b=C2LaJKqN/2AeWE9vmX4TAxtf+bKx4x8SqoYkM4+a/n4Bk6DV5hfx8F8nzMXYhYM9j0
         V2N5k7jY/16QUq1tIwuw7T9HyIO53zPlymfOjBLzSHvJGf6bj+AbZIWuR7kz9bFoWxQd
         MouGVYnbHAm3e/DAVFwrshUMvXRbMZlA0P89nHzVvFTSq4bRZ0adg+QXRffJkAnQ75HF
         rJPogj/9aZ+m8u1Rs0tyzebigJmCCQrVerH/u56y4x3vojCa5DUbqIcjlxqMp9aDtJzx
         3td31VoHFOUXsf+6OM5E4yTU40nbjMyDx3ksG6Qx7PkoJAOrJ+xqmTS/1DKZmLqnvl+L
         NINw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770645321; x=1771250121; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IYbx074fuAgyO8RGb6D+Pi1xYeIRePOLZjOYGfAnwY4=;
        b=EU5DKUu1hOs1k9YsqpPQX17wEDyYMxgV04gXTggPtXoiJ9Mlqwlv33BNNO9WYOwgaq
         mvoMGLURUaSZOskew9g1bqP+8rU/fEiitrdtmEsdcQwiF2QTML2IY22Sb4Q/ZZDjca1d
         mdW8b0fcaFQwlkFlgsIiur51sbvmDn+8j+vuoWoMyhvZUiDvCUmdpCUpbBN2ANrdDw0i
         RJllv/Zs+lPLWEBNeizEj/SdKTiCJKQjbPdvjDSteAD6Mv1+RZMV4HbiaxGPgrgqQyab
         +Z7vU9Ndogd+flGxLfDqrpAbrrLeeljvCtXcL78VsrGWUPKTxEggpB0Q4QIc8jAeq+2k
         6eEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770645321; x=1771250121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IYbx074fuAgyO8RGb6D+Pi1xYeIRePOLZjOYGfAnwY4=;
        b=a7SSbkDtd5/i/3rTz+Qr5MgTqXrf/L4pmRIyDOKNYbMd61YQN5vXJJuRBj9yizqKls
         lhTNXSvmyS5QPah7APqe9EaDtIGGWrlNZ33mylmsk+yalG5QadR2JM7k+S4zLkKlX1rN
         J7YBbZf15oFpLBDh5wr18EQpT36242P+GNOvQvCTObcDxB/hbYRvRdxg4ce47qXQ7GB3
         e568IYSCsjILEqAN1fQkk1kd/z9UPCk/TiBXEfh3kNJHhy/FdQK3u9hvgHTUQ3InuDDm
         gGX/Rry8DZ3Lqp/aVyquSJgwPjYTWSb23YQTGtD1PxSbogDF7mhVo+3sUqqu+l0FDJWk
         tJjg==
X-Forwarded-Encrypted: i=1; AJvYcCW1PmKgUskICUuAg5UdmEqp+4nxAbqeokwZRb8TcsYBy4jjKILkojpzRg83XgIVjAhXqdA=@vger.kernel.org
X-Gm-Message-State: AOJu0YywCKXpBNYzSEwHaeZigTaPBJq5CQH9OxjxoNCn4mieH7WYpytt
	vdQsDQVEWqgafN14VMv+6eeF550v8OQikwFcEUEbkLWv3ZDkdyyayCEg11X7Cd5JV0cWjrQBwFd
	jjLuJ5pbXCB5PbYC6XZGeT6Gt1shMxyUdpiXDxiN9SHyFP2SuH3XNwB2HDK9yGcMcUcf30F2wM6
	AhmtBYsLvh6hdUmOGbxpQVVMk90q35PxXEq7tPuH0=
X-Gm-Gg: AZuq6aKLma21voE0HKTDqy3Q82fLrNBQHkROhaZtqpr7Hxn2jvSu7XfekbyVwB76TGp
	sVvAl2PsNl3FNmvequjXqzKvcI9oz2g0XzKKB0o6jYrJBcG/XtK32msbtddqzMx5yNytc/Hg5Qc
	xSrtCrx1Ckm96NhrhPD+aSAilYoQREqm4z4C5BW/ZutULgoAF4KXOAPZuPQdKT181fsCtz0WU7r
	lJaWrdeFt7Pj9W/0zQpO+xQVg==
X-Received: by 2002:a17:902:f70e:b0:2a9:4c2:e46 with SMTP id d9443c01a7336-2a95225f9bfmr119988955ad.54.1770645321176;
        Mon, 09 Feb 2026 05:55:21 -0800 (PST)
X-Received: by 2002:a17:902:f70e:b0:2a9:4c2:e46 with SMTP id
 d9443c01a7336-2a95225f9bfmr119988785ad.54.1770645320784; Mon, 09 Feb 2026
 05:55:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260106183620.2144309-1-marcandre.lureau@redhat.com>
 <aV41CQP0JODTdRqy@redhat.com> <87qzrzku9z.fsf@pond.sub.org>
 <aWDMU7WOlGIdNush@redhat.com> <87jyxrksug.fsf@pond.sub.org>
 <aWDTXvXxPRj2fs2b@redhat.com> <87cy3jkrj8.fsf@pond.sub.org>
 <aWDatqLQYBV9fznm@redhat.com> <871pjzkm4y.fsf@pond.sub.org>
In-Reply-To: <871pjzkm4y.fsf@pond.sub.org>
From: =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>
Date: Mon, 9 Feb 2026 17:55:09 +0400
X-Gm-Features: AZwV_Qg-c5YMc2Yci-hcpbp6t1Zog-FShbSeXdhMcIJyFPyyUkzxXGfQHrcVbCE
Message-ID: <CAMxuvay0yrQ1hp-zBFxwGy42eCG0_kUmi+rmX8U=BOLNRKgfdQ@mail.gmail.com>
Subject: Re: [PATCH] Add query-tdx-capabilities
To: Markus Armbruster <armbru@redhat.com>
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	qemu-devel@nongnu.org, Eric Blake <eblake@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
	"open list:X86 KVM CPUs" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[marcandre.lureau@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-70598-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+]
X-Rspamd-Queue-Id: 2C91610FEB3
X-Rspamd-Action: no action

Hi

On Fri, Jan 9, 2026 at 4:26=E2=80=AFPM Markus Armbruster <armbru@redhat.com=
> wrote:
>
> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
>
> > On Fri, Jan 09, 2026 at 11:29:47AM +0100, Markus Armbruster wrote:
> >> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
> >>
> >> > On Fri, Jan 09, 2026 at 11:01:27AM +0100, Markus Armbruster wrote:
> >> >> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
> >> >>
> >> >> > On Fri, Jan 09, 2026 at 10:30:32AM +0100, Markus Armbruster wrote=
:
> >> >> >> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
> >> >> >>
> >> >> >> > On Tue, Jan 06, 2026 at 10:36:20PM +0400, marcandre.lureau@red=
hat.com wrote:
> >> >> >> >> From: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com>
> >> >> >> >>
> >> >> >> >> Return an empty TdxCapability struct, for extensibility and m=
atching
> >> >> >> >> query-sev-capabilities return type.
> >> >> >> >>
> >> >> >> >> Fixes: https://issues.redhat.com/browse/RHEL-129674
> >> >> >> >> Signed-off-by: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redha=
t.com>
> >> >>
> >> >> [...]
> >> >>
> >> >> >> > This matches the conceptual design used with query-sev-capabil=
ities,
> >> >> >> > where the lack of SEV support has to be inferred from the comm=
and
> >> >> >> > returning "GenericError".
> >> >> >>
> >> >> >> Such guesswork is brittle.  An interface requiring it is flawed,=
 and
> >> >> >> should be improved.
> >> >> >>
> >> >> >> Our SEV interface doesn't actually require it: query-sev tells y=
ou
> >> >> >> whether we have SEV.  Just run that first.
> >> >> >
> >> >> > Actually these commands are intended for different use cases.
> >> >> >
> >> >> > "query-sev" only returns info if you have launched qemu with
> >> >> >
> >> >> >   $QEMU -object sev-guest,id=3Dcgs0  -machine confidential-guest-=
support=3Dcgs0
> >> >> >
> >> >> > The goal of "query-sev-capabilities" is to allow you to determine
> >> >> > if the combination of host+kvm+qemu are capable of running a gues=
t
> >> >> > with "sev-guest".
> >> >> >
> >> >> > IOW, query-sev-capabilities alone is what you want/need in order
> >> >> > to probe host features.
> >> >> >
> >> >> > query-sev is for examining running guest configuration
> >> >>
> >> >> The doc comments fail to explain this.  Needs fixing.
> >> >>
> >> >> Do management applications need to know more than "this combination=
 of
> >> >> host + KVM + QEMU can do SEV, yes / no?
> >> >>
> >> >> If yes, what do they need?  "No" split up into serval "No, because =
X"?
> >> >
> >> > When libvirt runs  query-sev-capabilities it does not care about the
> >> > reason for it being unsupported.   Any "GenericError" is considered
> >> > to mark the lack of host support, and no fine grained checks are
> >> > performed on the err msg.
> >> >
> >> > If query-sev-capabilities succeeds (indicating SEV is supported), th=
en
> >> > all the returned info is exposed to mgmt apps in the libvirt domain
> >> > capabilities XML document.
> >>
> >> So query-sev-capabilities is good enough as is?
> >
> > IIUC, essentially all QEMU errors that could possibly be seen with
> > query-sev-capabilities are "GenericError" these days, except for
> > the small possibility of "CommandNotFound".
> >
> > The two scenarios with lack of SEV support are covered by GenericError
> > but I'm concerned that other things that should be considered fatal
> > will also fall under GenericError.
> >
> > eg take a look at qmp_dispatch() and see countless places where we can
> > return GenericError which ought to be treated as fatal by callers.
> >
> > IMHO  "SEV not supported" is not conceptually an error, it is an
> > expected informational result of query-sev-capabilities, and thus
> > shouldn't be using the QMP error object, it should have been a
> > boolean result field.
>
> I agree that errors should be used only for "abnormal" outcomes, not for
> the "no" answer to a simple question like "is SEV available, and if yes,
> what are its capabilities?"
>
> I further agree that encoding "no" as GenericError runs the risk of
> conflating "no" with other errors.  Since query-sev itself can fail just
> one way, these can only come from the QMP core.  For the core's syntax
> and type errors, the risk is only theoretical: just don't do that.
> Errors triggered by state, like the one in qmp_command_available(), are
> a bit more worrying.  I think they're easy enough to avoid if you're
> aware, but "if you're aware" is admittedly rittle.
>
> Anyway, that's what we have.  Badly designed, but it seems to be
> workable.
>
> Is the bad enough to justify revising the interface?  I can't see how to
> do that compatibly.
>
> Is it bad enough to justify new interfaces for similar things to be
> dissimilar?
>

Markus, as our QAPI maintainer, you have more weight on the decision.
Should the query return an union ( "unavailable": "reason..",
"available":  TdxCapability ) or the proposed patch is okay?


> >> If yes, then the proposed query-tdx-capabilities should also be good
> >> enough, shouldn't it?
> >
> > With regards,
> > Daniel
>


