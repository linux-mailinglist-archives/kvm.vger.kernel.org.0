Return-Path: <kvm+bounces-70896-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sAf4BkL2jGnvwAAAu9opvQ
	(envelope-from <kvm+bounces-70896-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 22:36:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 277A8127C9D
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 22:36:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 31491303541D
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 21:35:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9C0436164A;
	Wed, 11 Feb 2026 21:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="StPnW2N2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58EA260565
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 21:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770845755; cv=none; b=gzpBZtL2iEbKF3H3j8r3ofm4trzo6jvFmVj/K4y51rFjUBlDWvtjmpI1KKzldtLE0WGS0KxrbWvyhGOcrwA8eaxofYq+1AjkQvDv50KqBUTkwUdMrRhQCjFQKig7VbtaZJpqQJXdbhcsZU0OkQFl5IIZLIOIrrCjFgLfL3F1124=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770845755; c=relaxed/simple;
	bh=94VqIfxqkPdDfQLBDVIyUks085h2KPM8RIenb0Potxk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QzKaigdN/zzuSEyasu5WNOSZ4BSmZxf5Sjaoi64Ei3Cx4LUgG1EwrJeal/uaDBplvE7hbnAb3yS+fQ0WMPeOiUzIz0h/AlQfNwoXluW0qaaDpFqwOTeA/lj5ducWq7zbV2+bb+94d+xXKd9K91zmHyXLAqPrfNCbPEgRXTZesQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=StPnW2N2; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48327b8350dso51949465e9.1
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 13:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770845752; x=1771450552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+JId8paJjkJoCR3S5gRaKmlCqxgyyzCJ6RtqTjfKE0o=;
        b=StPnW2N2abUGCZ6BNw/U5m/8dnEs8Pvd6GVzvoXm02iAvI5AJOF1JP/4sJDi8trl55
         SofAuU2nCTqIzhQGH0xtWjOYRxTHYfJ9sZtcNkPeaRoxbSOPQdkXqTU0s154z4iOfVxo
         RT9tmGLa2bIqLOX1VEA15JRXJ2TgcLmbF4C0PO/4rtp7ljkZ0ZyfD3vznCfjxnuk6fAs
         8VSkRWTtMY6W/6SLZtWYIEhRzHQjvc1OCrKFNrG3u2KtKWZm7gpvgJa0ckIAgutU2EXU
         7Uycg2KZiJqQMmB8zvhPHeIc9jhBAgln7rpQoP6vl/ZGQHpKb9+EpiWqYFCBXpC5mRFR
         eLaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770845752; x=1771450552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+JId8paJjkJoCR3S5gRaKmlCqxgyyzCJ6RtqTjfKE0o=;
        b=OMvJW7vs572V2QNKFXp8lXYm9KwFwom0FGgnS+XKhAOEriTq7TOjM4s7bzxzzLSIVd
         s25bHrodwujNQBGSSz6qrDehxDbzVvY+q2xVII5GA8RbPZpxGnodJ+RRQY2+AqSn1bAY
         bCGWIhn7g09knoCqwnTwSwWejwFEwWHwM15mJ4PCIm8TYBJOA534Mmx2FgxlKoPJLC16
         EuZsga1Ws1Ve8jB0adE/5sXs806CLImma/S94Z7yWxHylUFXJnsBj64jTTIldHvkqhD8
         GJQ2SS5TCblwh0467jq4VIG3qsM4aWTpFd8h1MKDGZXge4dsNloKj1v5/vYJePPXnXma
         FPkg==
X-Forwarded-Encrypted: i=1; AJvYcCWKshk9mZKU1Na10+HMxZ1+Upn3JngAY3M7iBW8El65eUuqNc+X+7pJdJU62j8amiTIByU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWUqIlrJQjoT6nPoW9PaBaYEnyFKZ6LxpAjAztM0aiTmlbPvSH
	yaEZ1FgXB6l3WNnj9/xGX0ccdz741vNRCcfyzccZUX3RzvMTqGazQsCUubI1OA==
X-Gm-Gg: AZuq6aK5i/0RokYeL+BK/eKOhTTW0OWkFIOkI/ZYxLWbjxJsZs86WaKQW7tPu6lRbzQ
	3fHwzrqhBbgcO5w59AfvSxiOLhd3VzjfWFcH0YCrbA5YpIDEWawtFwmCONh5+mSqNbMb12zBs2d
	C3LYcJnxcCHKZaHMsmyz3tlKUYqiANgwdgnosn9P2Jo0MUb+UTFCZJky6DNzfFbXHNn5H2LkDXf
	bZXPDHFDdLXvJbsfp7IiSZqJnAqu3EJRvVDLSpuIjOPQtT4uxJ///E+CuB/TQm3v2dhrVX0G7Eu
	Q5T+eba9x0PtjfjIU8w1uXVEuGuNZmbzd+CrmyoonLkC2Q0ztzYeGU2aQ2M44G3myVCczpzgQ9D
	g5Vbp9bZjyUejFVBgEBOkuKubMvuqsvgdaYPxTffS2TBPuwOhHxM1MHxmxK3zKK5xRu21ap19m9
	hFZIJpP1mOd3uCcfEEXEs9GmT0PiXc5hizH9up1tP5PoIQkb2+JwLcrZFNljTNrpT6
X-Received: by 2002:a05:600c:4694:b0:46e:49fb:4776 with SMTP id 5b1f17b1804b1-483656c1098mr6767475e9.11.1770845751996;
        Wed, 11 Feb 2026 13:35:51 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835ba506cesm35391085e9.6.2026.02.11.13.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 13:35:51 -0800 (PST)
Date: Wed, 11 Feb 2026 21:35:49 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: ubizjak@gmail.com, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 mingo@kernel.org, pbonzini@redhat.com, seanjc@google.com, tglx@kernel.org,
 x86@kernel.org
Subject: Re: [PATCH 1/2] KVM: VMX: Drop obsolete branch hint prefixes from
 inline asm
Message-ID: <20260211213549.1837bb50@pumpkin>
In-Reply-To: <5276256b-9669-46df-8fcd-b216f3d3e45b@citrix.com>
References: <20260211102928.100944-1-ubizjak@gmail.com>
	<2af5e3a8-f520-40fd-96a5-28555c3e4a5e@citrix.com>
	<20260211134342.45b7e19e@pumpkin>
	<5276256b-9669-46df-8fcd-b216f3d3e45b@citrix.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70896-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[gmail.com,alien8.de,linux.intel.com,zytor.com,vger.kernel.org,kernel.org,redhat.com,google.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[davidlaightlinux@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,citrix.com:email]
X-Rspamd-Queue-Id: 277A8127C9D
X-Rspamd-Action: no action

On Wed, 11 Feb 2026 13:55:35 +0000
Andrew Cooper <andrew.cooper3@citrix.com> wrote:

> On 11/02/2026 1:43 pm, David Laight wrote:
> > On Wed, 11 Feb 2026 10:57:31 +0000
> > Andrew Cooper <andrew.cooper3@citrix.com> wrote:
> > =20
> >>> Remove explicit branch hint prefixes (.byte 0x2e / 0x3e) from VMX
> >>> inline assembly sequences.
> >>>
> >>> These prefixes (CS/DS segment overrides used as branch hints on
> >>> very old x86 CPUs) have been ignored by modern processors for a
> >>> long time. Keeping them provides no measurable benefit and only
> >>> enlarges the generated code.   =20
> >> It's actually worse than this.
> >>
> >> The branch-taken hint has new meaning in Lion Cove cores and later,
> >> along with a warning saying "performance penalty for misuse".
> >>
> >> i.e. "only insert this prefix after profiling". =20
> > Don't they really have much the same meaning as before? =20
>=20
> Architecturally yes, microarchitecturally very much not.
>=20
> For a branch known to the predictor, there is no effect.=C2=A0 If a branch
> unknown to the predictor gets decoded, it triggers a frontend flush and
> resteer.

That'll be 'decoded taken'.
I suspect that it is less 'painful' than a normal mispredict since it happe=
ns
as lot earlier.
Of course, if you get it wrong, there will be a mispredict penalty as well.

	David

> It is only useful for programs large enough to exceed the working set of
> the conditional predictor, and for which certain branches are known to
> be ~always taken.
>=20
> Putting the prefix on a branch that isn't ~always taken is worse than
> not having the prefix in the first place, hence the warning.
>=20
> ~Andrew
>=20


