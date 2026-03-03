Return-Path: <kvm+bounces-72614-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sA1WGRFcp2knhAAAu9opvQ
	(envelope-from <kvm+bounces-72614-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 23:09:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AD60C1F7DE2
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 23:09:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DA0F630BA3A6
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 22:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C16F53932C1;
	Tue,  3 Mar 2026 22:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GtX2wovR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA21738423A
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 22:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772575740; cv=none; b=JEPfnRBdGtPdN33Ahjuw/vQON9T72aPkkII5oWyQrHhhZbprYDfBhiBIlta2DvgAnwj/eiscQXjzgST7s+f+OpHZnTskuB+4vQC3mQNTQEoTedsDO8abNnU+mAPSd9jRLmhn5W9XdZeBZNL+ZIW/bYQ7J34JSzN+/yXIK7tGYvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772575740; c=relaxed/simple;
	bh=Of7BTYeza07tyJCqXUipN95k452hh96VN8OAHgpIRDg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A7XU9vN6y4X8ipnXLT2odmTqjiouM61oHcRbn3iJLa3x6AIxVoT8A6t+56VCJndSRjxtSP+NEaIMxD3dbHRyE+aW5jzmKZdA2UEnkknpim8bL6QE7JLg1q2DmGZxx4GRMMGjMwNQRKL742k6aUuaA6syezTgf8FTGTooRC58hdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GtX2wovR; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35980affbf3so2236568a91.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 14:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772575738; x=1773180538; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zj6uWkxQBYzI6TemYHQOyFliUtyyEllmJWAoAGhyJyU=;
        b=GtX2wovRP/1lxYJ4KIUuiUDDox7ZjCkSBD5PE6yhe6TBbEq2aBasnHqSc9KYIdsG7B
         pr13GKEHFkQXo7We0eGs9zNn0QSao7oMl5BDFjEg32MN8LvFlb0UA+f8H4FwB49LLYg6
         RP2RwqBtY9vo7Zzd+52yLvmDdoZyw/cN9sJX0CwyofvxL7NVpOplwhYdoAMeZwCy4SQR
         C1IDG/M9GXyDvA6ys9NSTimUHPtpiAjvqW4FZoaipteRhLOuotuuLpR0bJ0nTzUmXek4
         BiuJJ/k2XHz6AFpwimlHoyVhMC/MsEqkV5JleAZfwwB/anRMqyoSmgemwCbIn/36zCC2
         UdFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772575738; x=1773180538;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zj6uWkxQBYzI6TemYHQOyFliUtyyEllmJWAoAGhyJyU=;
        b=SlvN5bbd7dIPBDahGK3mTbpuemuJTtjoQtmAD7KgpQlWZnwMKhXt/lbuBxUoBYLaej
         Szgc1TmHqu15mSBRzehb8Nr9PgGNJDDJWgcJ4wSERPwtIEZbx7C2SdRb730wNaKHgoRe
         UG6D1D2VCelCbcyCpzmHi2+IdfecDZuFMztwz3Wps5bD0Seo5JeGq3bfZ75N/x0/MvrQ
         SZh8TrEJNl+8cb/ARhdPp2Wn+oW0AFEQTpvyou5rH8GPzvxF9w2/FKQGtLxybxHgZbLU
         JGg8FTeXBuaSyct2bUFw8dw2BjX92pai6+y6tPTxqMH+bzXPnclDRj8S6Z4FoGo9TEhV
         uFmA==
X-Forwarded-Encrypted: i=1; AJvYcCUghbyNZlIwaBCj8JcaH4AKGLj3XLZ97Bnq33fIYi06BsZRD5hQtyF/nm+X8JJiLhoRZjQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzy4pHHhwE0yiPr6aqnPJga09xtnoadG0RcDp+qDND/syNxcsaI
	b/pSNqAVs011ULtZelfnj/drhFsdPOL9yHdgaxUWMvRL6wwTaEbcVxkNKJWsiGgPnuNfxozIaM6
	LKabelw==
X-Received: from pjbgm24.prod.google.com ([2002:a17:90b:1018:b0:359:979d:cee5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1ccc:b0:341:c964:126c
 with SMTP id 98e67ed59e1d1-35965cef645mr16197271a91.34.1772575738034; Tue, 03
 Mar 2026 14:08:58 -0800 (PST)
Date: Tue, 3 Mar 2026 14:08:56 -0800
In-Reply-To: <CAE6NW_YTqbMZgq1nEiO6XsuQPZsKd9_0DseFDStocrh-sB1TBw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260228033328.2285047-1-chengkev@google.com> <CAO9r8zODn_ZGHsftsj0B6dJe9jy8sVZwdOgFi=ebZoHfGrWxXw@mail.gmail.com>
 <aaXXs4ubgmxf_E1O@google.com> <aaYanA9WBSZWjQ8Y@google.com>
 <aaYssiNf7YrprstZ@google.com> <CAE6NW_YTqbMZgq1nEiO6XsuQPZsKd9_0DseFDStocrh-sB1TBw@mail.gmail.com>
Message-ID: <aadb-JQdbQJNvm0o@google.com>
Subject: Re: [PATCH V4 0/4] Align SVM with APM defined behaviors
From: Sean Christopherson <seanjc@google.com>
To: Kevin Cheng <chengkev@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AD60C1F7DE2
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
	TAGGED_FROM(0.00)[bounces-72614-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026, Kevin Cheng wrote:
> On Mon, Mar 2, 2026 at 7:35=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Mon, Mar 02, 2026, Sean Christopherson wrote:
> > > On Mon, Mar 02, 2026, Sean Christopherson wrote:
> > > > On Mon, Mar 02, 2026, Yosry Ahmed wrote:
> > > > > Also taking a step back, I am not really sure what's the right th=
ing
> > > > > to do for Intel-compatible guests here. It also seems like even i=
f we
> > > > > set the intercept, svm_set_gif() will clear the STGI intercept, e=
ven
> > > > > on Intel-compatible guests.
> > > > >
> > > > > Maybe we should leave that can of worms alone, go back to removin=
g
> > > > > initializing the CLGI/STGI intercepts in init_vmcb(), and in
> > > > > svm_recalc_instruction_intercepts() set/clear these intercepts ba=
sed
> > > > > on EFER.SVME alone, irrespective of Intel-compatibility?
> > > >
> > > > Ya, guest_cpuid_is_intel_compatible() should only be applied to VML=
OAD/VMSAVE.
> > > > KVM intercepts VMLOAD/VMSAVE to fixup SYSENTER MSRs, not to inject =
#UD.  I.e. KVM
> > > > is handling (the absoutely absurd) case that FMS reports an Intel C=
PU, but the
> > > > guest enables and uses SVM.
> > > >
> > > >     /*
> > > >      * Intercept VMLOAD if the vCPU model is Intel in order to emul=
ate that
> > > >      * VMLOAD drops bits 63:32 of SYSENTER (ignoring the fact that =
exposing
> > > >      * SVM on Intel is bonkers and extremely unlikely to work).
> > > >      */
> > > >     if (guest_cpuid_is_intel_compatible(vcpu))
> > > >             guest_cpu_cap_clear(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
> > > >
> > > > Sorry for not catching this in previous versions.
> > >
> > > Because I got all kinds of confused trying to recall what was differe=
nt between
> > > v3 and v4, I went ahead and spliced them together.
> > >
> > > Does the below look right?  If so, I'll formally post just patches 1 =
and 3 as v5.
> > > I'll take 2 and 4 directly from here; I want to switch the ordering a=
nyways so
> > > that the vgif movement immediately precedes the Recalc "instructions"=
 patch.
> >
> > Actually, I partially take that back.  I'm going to send a separate v5 =
for patch
> > 4, as there are additional cleanups that can be done related to Hyper-V=
 stubs.
> >
>=20
> Gotcha, if you're sending just patch 4 as v5, then should I send
> patches 1 and 3 (with fixes) as a new series?

No need, I'll send a v5 for 1 and 3 as well.

