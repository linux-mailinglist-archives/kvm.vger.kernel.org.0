Return-Path: <kvm+bounces-73186-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qIphB5hxq2m6dAEAu9opvQ
	(envelope-from <kvm+bounces-73186-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 01:30:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BD6AE228FC8
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 01:30:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C21543051C80
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 00:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 776F4275864;
	Sat,  7 Mar 2026 00:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iX3OE5qF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB29D26AA91
	for <kvm@vger.kernel.org>; Sat,  7 Mar 2026 00:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772843332; cv=none; b=kJp5Qs5ZooWJssxscZHiwCYE/OCDqgC5AeHgFYF2csinUTl9pgrtoWA07Fg1EHStKAaF+McIlsahiYXL240uQdn0hrLTmEebL9FBmNpyX2ybGKiQgN2ccOPIo+b5TLA+ORQbkj7ne+F0dCem7Z8x5CNWOQ0o4EuakqNlkb8xJb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772843332; c=relaxed/simple;
	bh=QWMLlUntDiL0xIVsEqxbbJvqg3LbfJ3Wz79e3tM5FWA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R6L/NG5B19vFB62vUhEo7Onvv8H91ufcgOeI0VBr4xOWN77KBZj5CxNZGfd3Bz7s97R5fA2prSghJFZOBGcgkQy5PDJ1rOaQ41CMIL2g865lkM24i4TEF5spvV/EHtdVvSyrVG7wlj53t2RygnZdXCmlWwaEtXOgk2KUaOKHJ+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iX3OE5qF; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6e24ee93a6so5954957a12.0
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 16:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772843331; x=1773448131; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tHNM+q95fw1pTGGYqDi35exVyzczshxw543JBLx5Ogc=;
        b=iX3OE5qFtiCoQVDsQlxF8Pmm5zbfPp/URqbfaUr46NBC8PtAo+ualv/M3Nv/0JIsGb
         H4/znFX1+TSerqwJGfg/SP3WLYeY0Q4dZzjxwLcKr7Yk6hcXnFXkZ29N/VSL2LuGObax
         DJ6DczlviSGNaZJpHGCepEtNWc1Fik5wF41n90Pgj3oK6DV/ir/l7E1r2GB9wWCL1iJB
         xQmlpW0YTzSJ9+PlWJcR9tGsmAGdTLhoe88sOy5WXidCSAJOErGm7XfqzhjwDlDVRli4
         YhU3rDPiBuKIOMhrKMYsJpXUM/hj8LuhgTHLagYeBrZSPPMX9F4CgOacodgwiUGx7aAs
         ooTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772843331; x=1773448131;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tHNM+q95fw1pTGGYqDi35exVyzczshxw543JBLx5Ogc=;
        b=UcU0OzgGn9chQmuEdNMan/sEhWmdcf867yNWxQC/JkHiVYZIaxz6rru5h68z48ITQ5
         bkrzg/SidFc6Q4U27yhV70r7krJ/KzcPjJzh5vxGOWjFYhnCd7glabwYZQvw+STAhmqs
         YVg4+qbHTbY4gzGWxUZmDtoNlbtCnPQBf4D0FOC25JukLp0qqI7wpxfYUOEuqcdj5dep
         Tp7NLFTUcLckZMosUrLWiBjmUyBGiyCa+Zixiv4t9kfAn3WhX4tGViwmIwlL9fjulhEd
         3B71p9KyfmM+vUUWqNOV/kQr329z8arWkBDXFv9zzE4gZFD3hkaNN+UkfEq+aK2CYlE+
         JzMg==
X-Forwarded-Encrypted: i=1; AJvYcCWXeul3yGD/ALaBT8DHvfSLpva4cQLVfdJyJX1PxVf5lj7yZq/OK09K+ASyHYM0abFsA/4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYWIaSzYWiX5/ThGk5EZuCj1C8wqaOIzdoW/w9VSQ4WDgv2vQT
	NJ0EIG/IF9ipTv+A5nfyAZWj6D3hGaKHkaiaTeZsHby59/xFxjE2nDz8XH03a4btwxtQCWsUa2r
	GBDuZww==
X-Received: from pjza2.prod.google.com ([2002:a17:90a:e202:b0:359:86b9:176d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3dc8:b0:359:8c5a:a564
 with SMTP id 98e67ed59e1d1-359be37fc88mr3246997a91.13.1772843330852; Fri, 06
 Mar 2026 16:28:50 -0800 (PST)
Date: Fri, 6 Mar 2026 16:28:49 -0800
In-Reply-To: <CALMp9eScswzFak+PMOcaDXM-W+cXtkG7fQ=jadq__+5JeqYcTQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260306210900.1933788-1-yosry@kernel.org> <20260306210900.1933788-2-yosry@kernel.org>
 <CALMp9eRWwPwUSyQmizy8i2tF1CVO4iLY6x0vX1OoPUiRdCm4NQ@mail.gmail.com>
 <CAO9r8zOhaDeYWq_6TNdPGyEE323o_8xsWTozGdro9Oni8310kA@mail.gmail.com> <CALMp9eScswzFak+PMOcaDXM-W+cXtkG7fQ=jadq__+5JeqYcTQ@mail.gmail.com>
Message-ID: <aatxQXV-mQX6uE1C@google.com>
Subject: Re: [PATCH v2 1/6] KVM: SVM: Use maxphyaddr in emulator RAX check for VMRUN/VMLOAD/VMSAVE
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BD6AE228FC8
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
	TAGGED_FROM(0.00)[bounces-73186-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.949];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026, Jim Mattson wrote:
> On Fri, Mar 6, 2026 at 2:37=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
> >
> > On Fri, Mar 6, 2026 at 2:27=E2=80=AFPM Jim Mattson <jmattson@google.com=
> wrote:
> > >
> > > On Fri, Mar 6, 2026 at 1:09=E2=80=AFPM Yosry Ahmed <yosry@kernel.org>=
 wrote:
> > > >
> > > > Architecturally, VMRUN/VMLOAD/VMSAVE should generate a #GP if the
> > > > physical address in RAX is not supported. check_svme_pa() hardcodes=
 this
> > > > to checking that bits 63-48 are not set. This is incorrect on HW
> > > > supporting 52 bits of physical address space, so use maxphyaddr ins=
tead.
> > > >
> > > > Note that the host's maxphyaddr is used, not the guest, because the
> > > > emulator path for VMLOAD/VMSAVE is generally used when virtual
> > > > VMLOAD/VMSAVE is enabled AND a #NPF is generated. If a #NPF is not
> > > > generated, the CPU will inject a #GP based on the host's maxphyaddr=
.  So
> > > > this keeps the behavior consistent.
> > > >
> > > > If KVM wants to consistently inject a #GP based on the guest's
> > > > maxphyaddr, it would need to disabled virtual VMLOAD/VMSAVE and
> > > > intercept all VMLOAD/VMSAVE instructions to do the check.
> > > >
> > > > Also, emulating a smaller maxphyaddr for the guest than the host
> > > > generally doesn't work well, so it's not worth handling this.
> > >
> > > If we're going to throw in the towel on allow_smaller_maxphyaddr, the
> > > code should be removed.
> > >
> > > In any case, the check should logically be against the guest's
> > > maxphyaddr, because the VMLOAD/VMSAVE instruction executes in guest
> > > context.
> >
> > Right, but I am trying to have the #GP check for VMLOAD/VMSAVE behave
> > consistently with vls=3D1, whether it's done by the hardware or the
> > emulator.
>=20
> Consistency should not be an issue, since VLS cannot be enabled when
> the MAXPHYADDRs differ. VLS doesn't work in that scenario.
>=20
> > >
> > > Note that virtual VMLOAD/VMSAVE cannot be used if the guest's
> > > maxphyaddr doesn't match the host's maxphyaddr.
> >
> > Not sure what you mean? Do you mean it wouldn't be correct to use it?
> > AFAICT that doesn't prevent it from being enabled.

It does, actually.  KVM doesn't support allow_smaller_maxphyaddr when NPT i=
s
enabled, because AMD CPUs (and now some Intel CPUs, lolz) do A/D updates be=
fore
signalling the reserved #NPF.

	allow_smaller_maxphyaddr =3D !npt_enabled;


And vls is disabled if NPT is disabled, for all the reasons Jim is pointing=
 out.

	if (vls) {
		if (!npt_enabled ||
		    !boot_cpu_has(X86_FEATURE_V_VMSAVE_VMLOAD) ||
		    !IS_ENABLED(CONFIG_X86_64)) {
			vls =3D false;
		} else {
			pr_info("Virtual VMLOAD VMSAVE supported\n");
		}
	}

Thus running with allow_smaller_maxphyaddr+vls is impossible.

> It is incorrect to use VLS when it doesn't work.

