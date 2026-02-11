Return-Path: <kvm+bounces-70868-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +NUyJ8urjGl/sAAAu9opvQ
	(envelope-from <kvm+bounces-70868-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:18:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 03CBA12609F
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:18:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 627EE303A860
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:17:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B1AA33E36F;
	Wed, 11 Feb 2026 16:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sb7HjYCT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EAC329387
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 16:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770826657; cv=none; b=jt5eb8vFini6xMofogqKZ+xHn5Ot6niS46HdvXv5QLh4q21HJ89p+q4jC0Z0h0hevJtbtXnFv4S0/VSnz+7XjZmCo9Mmqhd2dY09o6Lh9AjCsGU1Z78+Mo4qvYPWJjS7uGQHG6tzrCIrvTYiiCdm3UKbczLUxYA8PaShwUssb60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770826657; c=relaxed/simple;
	bh=5EvPyEvkqgrA7n4tzyHxQD1hclI9/oIsK3uTskzov3E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MSqJO2r0iHjzep4EecOig9YzPqxfOfBRrXlhJNFSo6erh32qDQwDlfTBS/OR7+4aOjuY/9dYnEcgmcxXN+6umJoYjkt2n1481fj1hrlygqMrbSDqM6aZ9zI3Qbx5pk1ZdhRpkWgBftSw7YI+dXcdSIDpnlsREbjs8rYTN1yRKHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sb7HjYCT; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35301003062so14814763a91.2
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 08:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770826656; x=1771431456; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V146SZPvRkej/EcKHnMerrWgIyMy78Orla7tpTzo81E=;
        b=Sb7HjYCTRU+5218WmZMnNTRAbKzB91Ey8WV1c9FVkd0hkcKdPFD/KpRAmRe9OKb6+9
         cOe4Az+wIqe9DpI+zrBggxdQynNDDNyyeHcUaQ8/rwzmPdnmYddDhf6WTnhrcAoH5cg7
         7I4E8RAARBSvpEUoEMyakFEz5Qzt1Bb3WWPiE/77SnJKxq2dZmE4BM80cKPyx0XJOIDo
         8tvCCDP9U0lvURCgNMfcdCLQWb2PR8XlX8bevTMetkDdQiPbZm1f0uwy3512JuaoiRNF
         Cqq7bY5W0pgN0dDJc/JpmCitFJvZndb6y8dx7A1VGfYiBx+cLLRtCHJfxoH7rB9t2Myb
         be8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770826656; x=1771431456;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V146SZPvRkej/EcKHnMerrWgIyMy78Orla7tpTzo81E=;
        b=oiv1k4pp68zmX01ilhBlaZHoK3oN+SjcRb4QZjwU4SFiSqH1J+V/tUV3SlyIWMEV6I
         RuTsczHSEtKmRe0vctJh3v3mgFsvJkZZS/RtNtFSWWjEt9zaEIUgSdq/EajX3I9su3Ua
         l5iRwcajkziYVGwlw/6HqsVqd2ekkGomgIXPUWEOsd54gPQSYce+nMcKfhbg9sijsLDD
         pK09vqHc7qvJHF2fSrprFMOZoqHveWa7TPkgxgzcFjasUX9WJMSMe1Mq+Co6qU+IouY4
         c9GcagHM9NwaTL2Ud3F4ElUZ7KjXD7Zl8XGmnU6r4z9a8/7tsJxPq8pe+PU32leBo2pz
         ztsg==
X-Forwarded-Encrypted: i=1; AJvYcCXPleDSBc6C2YuurKXBMI273Jyu5vhxc1yiF6RMowhyuDzJeItXQjkvol9Pvb/hvk8INqk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQFVrsZqh91HIr8Zd9QxGmle0QUqJfmTe8s+5tjK5uL95FlhbV
	R82u2kC0koBBGpnxOEcNsbzM0aIOfPkE/YROXq7/EwFmOAreZ5l+fbVnCN40juo9GcXcLFv1J32
	EkTZE8Q==
X-Received: from pjboh4.prod.google.com ([2002:a17:90b:3a44:b0:356:5127:89c6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ec87:b0:338:3d07:5174
 with SMTP id 98e67ed59e1d1-3567afccb5cmr3006508a91.5.1770826655716; Wed, 11
 Feb 2026 08:17:35 -0800 (PST)
Date: Wed, 11 Feb 2026 08:17:34 -0800
In-Reply-To: <bc3784ea-3315-4e96-9cc9-7f837410e7d9@citrix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260211102928.100944-1-ubizjak@gmail.com> <2af5e3a8-f520-40fd-96a5-28555c3e4a5e@citrix.com>
 <20260211134342.45b7e19e@pumpkin> <5276256b-9669-46df-8fcd-b216f3d3e45b@citrix.com>
 <aYyjw0FxDfNqgPDn@google.com> <bc3784ea-3315-4e96-9cc9-7f837410e7d9@citrix.com>
Message-ID: <aYyrnjV4ewtXlSeL@google.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70868-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[citrix.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 03CBA12609F
X-Rspamd-Action: no action

On Wed, Feb 11, 2026, Andrew Cooper wrote:
> On 11/02/2026 3:44 pm, Sean Christopherson wrote:
> > On Wed, Feb 11, 2026, Andrew Cooper wrote:
> >> On 11/02/2026 1:43 pm, David Laight wrote:
> >>> On Wed, 11 Feb 2026 10:57:31 +0000
> >>> Andrew Cooper <andrew.cooper3@citrix.com> wrote:
> >>>
> >>>>> Remove explicit branch hint prefixes (.byte 0x2e / 0x3e) from VMX
> >>>>> inline assembly sequences.
> >>>>>
> >>>>> These prefixes (CS/DS segment overrides used as branch hints on
> >>>>> very old x86 CPUs) have been ignored by modern processors for a
> >>>>> long time. Keeping them provides no measurable benefit and only
> >>>>> enlarges the generated code. =20
> >>>> It's actually worse than this.
> >>>>
> >>>> The branch-taken hint has new meaning in Lion Cove cores and later,
> >>>> along with a warning saying "performance penalty for misuse".
> >>>>
> >>>> i.e. "only insert this prefix after profiling".
> >>> Don't they really have much the same meaning as before?
> >> Architecturally yes, microarchitecturally very much not.
> >>
> >> For a branch known to the predictor, there is no effect.=C2=A0 If a br=
anch
> >> unknown to the predictor gets decoded, it triggers a frontend flush an=
d
> >> resteer.
> >>
> >> It is only useful for programs large enough to exceed the working set =
of
> >> the conditional predictor, and for which certain branches are known to
> >> be ~always taken.
> >>
> >> Putting the prefix on a branch that isn't ~always taken is worse than
> >> not having the prefix in the first place, hence the warning.
> > These branches indeed ~always follow the hinted path (not taken in this=
 case).

Doh, forgot the !CC_HAS_ASM_GOTO_OUTPUT case uses a branch-taken hint.

> > So it sounds like this definitely isn't stable@ material, and maybe eve=
n begs
> > the question if dropping the hints is a net positive?
>=20
> The new behaviour only exists for hint-taken. Because it only has any
> effect for a branch unknown to the predictor, the behaviour without this
> hint would be as if it were a larger basic block.
>=20
> hint-not-takens have no behaviour since the Pentium 4 that I'm aware of.
>=20
> This change is almost certainly marginal at best.=C2=A0 It's not as if
> VMREAD/VMWRITE lead to good code gen even at the best of times.

Yeah, but adding in them in the first place was even more marginal (I added=
 the
hints as much for documentation purposes as anything else).  Absent proof t=
hat
having the hints is a net positive, I'm inclined to trust the compiler folk=
s on
what is/isn't optimal, and drop them.

