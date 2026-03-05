Return-Path: <kvm+bounces-72947-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QLNKNQreqWm4GgEAu9opvQ
	(envelope-from <kvm+bounces-72947-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 20:48:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 315A4217BCD
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 20:48:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DAC68304C136
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 19:46:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 714773CB2CB;
	Thu,  5 Mar 2026 19:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RK6KUkvN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6C326B77D
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 19:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772740007; cv=none; b=tyROX/Q4++VKUhpeA6MDDekhdFEsFGj8lb5DqFOttTN6zvbmcCYgq/kF1pKAxZqRBvqA4fCEqbXn/DIAnCvDwcGLziSesMb7H2Rr9NqJShyXt/tXZVWZURwOFOsfCKzLbng3nfIEcobN43StDG5wJ4c+d9fTgCAqehnbDVAF0fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772740007; c=relaxed/simple;
	bh=JH15yDfCbqJbRHQkR4wgBRmd6IFbUbM1meiQNP0Wrgk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h5PyLOsEBi7s1JHq7wbTZ54JpIFIWhXO0xpnZ07M55gsj6XbwQOzgJ4KybW8beR7+nrx/xEJzgupVAL3hjZFnhj4O6vPcRZdRN61tx3PXVbTPZBTopbh801FCIJMKBbnpQqFuH4AOl0Yp5vcTfFREXY/OP1WT4yj+gPlVUB/cTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RK6KUkvN; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3597baf976dso18734598a91.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 11:46:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772740006; x=1773344806; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wjn38o8lsg+c2mqWGvvOi9PSLqHeZjHOFWYbF5i1GhM=;
        b=RK6KUkvN1u2z65rHg/R5lkDQRU28GtYT93K9cjmu1M00lGc3WmYRf/CCOopFcAvYJh
         UmUOHwmpA+lNq3nz3bioyefpFmhpASipfYk7I4NvetfrLLdGgv9STmOekmUwkzuU3uKg
         B1XND1OXb4jpkUAnXSJ9K/k/5JyrO7udNPR20Tbb6VmTsfeLgQSXsGWdZ1ElTSPEwHeC
         GqTF99MUMlKDUTuSIUWGbWVLJ8VcgA/dGNblvUFFbvXwScC/QWlFKTdW6R1wdfhjiVmZ
         EWH5c+l5nUBk1aOUpm1IKTcjw5T518l0+qj/+T+zekKd3V3ELb3Vdjb3fvpqzG328JT6
         HERQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772740006; x=1773344806;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Wjn38o8lsg+c2mqWGvvOi9PSLqHeZjHOFWYbF5i1GhM=;
        b=JTuws3wh99uLervwWm0NorjTvNrABYH7+gdQ6VyJa5ZWqdWXwwK+h6BgEHVAIM93iI
         DrSfX3J8AT5I011F6s3I6pz6gZ1eOt/P9a0eD04WacvZAmY7bR1zocC/VkYwcwPsuf/7
         pjLLYeqe2Py8NeN5Gi0bHNj9DhxrSIbnE4bq9eB0k94czQydKJ0Ud8YeeRwzBziCx/du
         v3NcB8LSVX4Aa8nIGyyYBbMdO+U1H8RG4cZRLdMEw/KTlmO3rlie7QH7a3WU6D8ENxBQ
         V8ewuLd3cr8KJQ+ycHABsmWnpnuTpJGtwcnVNDm5mTfgRHbRaH4TkPHZH0I24/MwKfFl
         IWKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXy499cG24krT0bh0y5Lx6ShkkDAABJSJIxwlXxjDMhg+lGPuWBHaehX9bBMMBPKv8737I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrIFO+mCIalGEi4Ck5CTrjGFAfBRXRluzhi7WW+8yxBciStspi
	xwZ+LOyRmvo4jkuTlQF+101M8/muvRTuoUZ+7wgwNb/CgebidsSH3nlehQ5eXqlay4P7QH/7Tgo
	q6HEj/g==
X-Received: from pjbcu12.prod.google.com ([2002:a17:90a:fa8c:b0:359:9633:e147])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d403:b0:356:41c2:897d
 with SMTP id 98e67ed59e1d1-359bb39a0c4mr534663a91.8.1772740005862; Thu, 05
 Mar 2026 11:46:45 -0800 (PST)
Date: Thu, 5 Mar 2026 11:46:44 -0800
In-Reply-To: <CAE6NW_a0dAS9j+erHzZgVT5zXcqAi=kxBt7=5m4JSxBSVvvbFA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224071822.369326-1-chengkev@google.com> <20260224071822.369326-3-chengkev@google.com>
 <aZ3VCq4s7l9f4JTw@google.com> <CAE6NW_a0dAS9j+erHzZgVT5zXcqAi=kxBt7=5m4JSxBSVvvbFA@mail.gmail.com>
Message-ID: <aandpOJWr3eFCVcG@google.com>
Subject: Re: [PATCH V2 2/4] KVM: SVM: Fix nested NPF injection to set PFERR_GUEST_{PAGE,FINAL}_MASK
From: Sean Christopherson <seanjc@google.com>
To: Kevin Cheng <chengkev@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 315A4217BCD
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
	TAGGED_FROM(0.00)[bounces-72947-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Mar 04, 2026, Kevin Cheng wrote:
> On Tue, Feb 24, 2026 at 11:42=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > This is all kinds of messy.  KVM _appears_ to still rely on the hardwar=
e-reported
> > address + error_code
> >
> >         if (vmcb->control.exit_code !=3D SVM_EXIT_NPF) {
> >                 vmcb->control.exit_info_1 =3D fault->error_code;
> >                 vmcb->control.exit_info_2 =3D fault->address;
> >         }
> >
> > But then drops bits 31:0 in favor of the fault error code.  Then even m=
ore
> > bizarrely, bitwise-ORs bits 63:32 and WARNs if multiple bits in
> > PFERR_GUEST_FAULT_STAGE_MASK are set.  In practice, the bitwise-OR of 6=
3:32 is
> > _only_ going to affect PFERR_GUEST_FAULT_STAGE_MASK, because the other =
defined
> > bits are all specific to SNP, and KVM doesn't support nested virtualiza=
tion for
> > SEV+.
> >
> > So I don't understand why this isn't simply:
> >
> >         vmcb->control.exit_code =3D SVM_EXIT_NPF;
> >         vmcb->control.exit_info_1 =3D fault->error_code;
> >
>=20
> Hmmm yes I do think it can be replaced by this but we would also need
> to grab the address from the walker. So
>=20
>         vmcb->control.exit_code =3D SVM_EXIT_NPF;
>         vmcb->control.exit_info_1 =3D fault->error_code;
>         vmcb->control.exit_info_2 =3D fault->address;
>=20
> For example, in the selftest that I wrote we should be populating the
> exit_info_2 with the faulting address from the walker, not the
> original hardware reported address which is related to IO.

Yeah, sorry for the confusion.  I wasn't saying _don't_ include the address=
, I
was just pointing out that the error_code handling can be much simpler.

