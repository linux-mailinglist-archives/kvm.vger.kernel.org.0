Return-Path: <kvm+bounces-70863-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qM1dLB+kjGlhrwAAu9opvQ
	(envelope-from <kvm+bounces-70863-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:45:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 15841125D19
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:45:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E9D273048B3F
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 15:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2885F30F7F7;
	Wed, 11 Feb 2026 15:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2pVArm6Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F3E30EF88
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 15:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770824647; cv=none; b=J3hyQaVMGYDu0V7RrvQvJXrCumi2sUdnSEiJf5vXIAcAwZ709VfPAABAcwnoKtwgTuGFE22x32pFcq+MU8SQyzVU87d5XMw0ozZhnsDX4b599pVmQ/de4UTyuR5uRjyBbV5vu+6yTp4sbxeatX8C47MvG228yW1Fwe5SjtYdmGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770824647; c=relaxed/simple;
	bh=GvTQ7X1t9rWdwqwmfS4q3q0vgU0V7zXK7RebluAmI78=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BvTn/I+hj8YYer/j8fABR9hEeMntLiWv1tN7oGamiGOO35uZvKkx02qHUvOopA+r4vkCUO1AJGnfKrqM+C8dnxrsLTMwdtn40JgXb7RNOY50RFGWPwHrSmHoBkXd/OXlSlnNhXqwg8/mYJHDICwr0o2fQw02qQ9+dDr+sb/B4fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2pVArm6Z; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35301003062so14740114a91.2
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 07:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770824645; x=1771429445; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GvTQ7X1t9rWdwqwmfS4q3q0vgU0V7zXK7RebluAmI78=;
        b=2pVArm6ZXhg6cOvytJYzLYYsa9NxDDLEexQPsfOEsbytF/nBS4WBaPv2TpSsunnWLb
         YQONpF5fOu/g05eBYN3G49kbYdJLkgYZaFo1upQ98HkJsBvqq1hCCuiO971TUvinCwU4
         GYuWJSmRVmFOKS0hjByoY9/xNWqEcf5pUwtUMHkG2QyWk6dSMCI//1t1ei6hs2jme8sK
         zBeM6xhrZ4wCwup+IHCO0iKEPxtkMY1LEb2ziQxEVpJ6B+JkUESjsNLSMpvytmZU9hoj
         U7U2Z8MX7Uw9/28uHlwfGxljc8GuhFqjKtrimkIdkfdkyKN+OQ799r4UrLbE3jTbyV8Z
         dC8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770824645; x=1771429445;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GvTQ7X1t9rWdwqwmfS4q3q0vgU0V7zXK7RebluAmI78=;
        b=ieX90xNkAYgPIPOgl61VqYJpoVzoeoeBhT+gluzE3b3S5WF1EwlWT3TUYZebfds4yb
         Qim/8jHiZYZMZDTAFRAP62t9OGCwjRT5Ivddq/E29v/OFj/kvTytpspFM+VzcIcQ152C
         +kXYqa0s2e7VT9fxTRm33umd2p31QsidqcCvJMt7mvKeuOuz8gm082ek31TpFzTqON+a
         Y9NjFQb6DRwVRqqyVU9cFeReXifdbyxkVAR6mEIwFP9yMVzZDy/ZDl8lfNitFk3WdwH9
         rORyv6KcGFvLZTfUhPSEI3N/cosAb5RHo7BBX2npRH/w1NoO4lhIIjwx689Rg4Ti2n7W
         iD1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVRS+6/WJoyKDqUQ6BszMWHoXYzGcSblDp2zcwUEFTtVce6Kl5h+eQ4V499GTbqEtjwoWA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz32fRSzmn5pyt+ZjGPQMrog+i8D/+r2b5HyN77vLrVdRblnihU
	uu9GJcsA0kF4Xk65GvcpUR2ygCe+XsAFiUwk+zfumWf48DkqpokbbKzxl7lawGvMnCBzOH1lo+y
	wB2AT3w==
X-Received: from pjbsm7.prod.google.com ([2002:a17:90b:2e47:b0:339:e59f:e26])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:278b:b0:356:2c7b:c013
 with SMTP id 98e67ed59e1d1-3567b10b67amr2994667a91.29.1770824645221; Wed, 11
 Feb 2026 07:44:05 -0800 (PST)
Date: Wed, 11 Feb 2026 07:44:03 -0800
In-Reply-To: <5276256b-9669-46df-8fcd-b216f3d3e45b@citrix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260211102928.100944-1-ubizjak@gmail.com> <2af5e3a8-f520-40fd-96a5-28555c3e4a5e@citrix.com>
 <20260211134342.45b7e19e@pumpkin> <5276256b-9669-46df-8fcd-b216f3d3e45b@citrix.com>
Message-ID: <aYyjw0FxDfNqgPDn@google.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Drop obsolete branch hint prefixes from
 inline asm
From: Sean Christopherson <seanjc@google.com>
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: David Laight <david.laight.linux@gmail.com>, ubizjak@gmail.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@kernel.org, pbonzini@redhat.com, 
	tglx@kernel.org, x86@kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70863-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	FREEMAIL_CC(0.00)[gmail.com,alien8.de,linux.intel.com,zytor.com,vger.kernel.org,kernel.org,redhat.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[citrix.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 15841125D19
X-Rspamd-Action: no action

On Wed, Feb 11, 2026, Andrew Cooper wrote:
> On 11/02/2026 1:43 pm, David Laight wrote:
> > On Wed, 11 Feb 2026 10:57:31 +0000
> > Andrew Cooper <andrew.cooper3@citrix.com> wrote:
> >
> >>> Remove explicit branch hint prefixes (.byte 0x2e / 0x3e) from VMX
> >>> inline assembly sequences.
> >>>
> >>> These prefixes (CS/DS segment overrides used as branch hints on
> >>> very old x86 CPUs) have been ignored by modern processors for a
> >>> long time. Keeping them provides no measurable benefit and only
> >>> enlarges the generated code. =20
> >> It's actually worse than this.
> >>
> >> The branch-taken hint has new meaning in Lion Cove cores and later,
> >> along with a warning saying "performance penalty for misuse".
> >>
> >> i.e. "only insert this prefix after profiling".
> > Don't they really have much the same meaning as before?
>=20
> Architecturally yes, microarchitecturally very much not.
>=20
> For a branch known to the predictor, there is no effect.=C2=A0 If a branc=
h
> unknown to the predictor gets decoded, it triggers a frontend flush and
> resteer.
>=20
> It is only useful for programs large enough to exceed the working set of
> the conditional predictor, and for which certain branches are known to
> be ~always taken.
>=20
> Putting the prefix on a branch that isn't ~always taken is worse than
> not having the prefix in the first place, hence the warning.

These branches indeed ~always follow the hinted path (not taken in this cas=
e).

So it sounds like this definitely isn't stable@ material, and maybe even be=
gs
the question if dropping the hints is a net positive?

