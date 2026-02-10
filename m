Return-Path: <kvm+bounces-70680-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8IFQKUR9imkgLAAAu9opvQ
	(envelope-from <kvm+bounces-70680-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 01:35:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 155E9115AB0
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 01:35:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3E18F303CA5A
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 00:33:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EF7823C4F2;
	Tue, 10 Feb 2026 00:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vMUCDjaY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B3816F0FE
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 00:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770683628; cv=none; b=N7eg1PoY7bXZMkWiJKredLDnvpJIurRTEbwBPfmFkqIga9sXVT6luompmg2nfFzreAGDDn1UEsSGDrxEcI3tvAB3ONQSLbEbErWAc5D/kSxqToJZ80oRWbgUYmPSeXMDOvjavjXX2tqbkaS5wvPhHvilHEFPY1RYWIOPf91LdAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770683628; c=relaxed/simple;
	bh=7ydWrjlCepD6nB2ObFrNdCIBZVDXv0TnWs2DKYuT5zI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pFXQzN205Jp8mBqfYjRj2swEOxuf3O50vj2HEcmUlw/3r2DvZn3vvBPLCL/ymzepiRP1wNMcjxgHjEhWZhvqXG6FWCqP1SYuTfSw7Fl917TVTlWGkakazuskOt1ey7w0oYztTOvm47Phu5Wg+7xbMZLU7x9JpgoRdiympzIPpXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vMUCDjaY; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2aadeb3dee4so62844215ad.2
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 16:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770683627; x=1771288427; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7k/XzuZM96p1tSUw8bPt3a7YL5QqswpTlWe5QXEZ234=;
        b=vMUCDjaYssh9Tk83i2OJ1P4gjDBZXIskB6CytTQT5TCXDI6oHhArD1u7dkuMFrs5F9
         J6tzxVp494/dM1GC9qRuQV2IhG/n1VfuIMl0dBEoMHUM6JB5NNC8RlJKh7QauR9ja4ps
         jtmSkMQ3edhUFcm6sqkGOoWcnZA4Rv3lKQPJ57x5kFC4EBRkjFS3EwG9Bt/1nJ1UyufC
         f1Ch3QaCgp0aXsHG84hD+ZL3E2YhJ4dm0/hWdDmD5XGNXglq66XpqYRhIh4tBETu7aK7
         YE34NyhTI35Be9yXUluBXUoMlztRATePqSYnZISUyvLj/6N1SlSPgAFfu5cjD0HEqBLB
         Cb9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770683627; x=1771288427;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7k/XzuZM96p1tSUw8bPt3a7YL5QqswpTlWe5QXEZ234=;
        b=GQCKhF/YqH8GnIPXYHeagzOEGO1HTFu/1IkgeW2xJ8m9ix7/u7/PNlWP60R0m7Q0+B
         5iDnKdyCnDh7SK6wtcoOQxAIj/ITisFLRBh22gi/Suu/4s3MJWlJKKLUrH2JWVSOLTFn
         Az7PQYJEiDSkDyG1KaqP0VrWwPxklkFZ2OwWNU10f/LKUHFZ14VcoY4McbUhWsC+HDVW
         Y+DVW1nXX8ByNLTuwoPbzY49WXqhFRGi+o29G2MUsrWaH6BmWXfs3UN+DrNdcsBUIgSS
         46DjjSMUAbG4Piysm9W9lH3kHsePk0wLxaMOovck+2pY6+yfj05JcpgjKWoteiiukf9s
         wiKQ==
X-Gm-Message-State: AOJu0YyPKwSxt5TTeQykQlHTJb0axcNEzSIpSnX8HIbKz6Qe8TKZlErX
	Cp30DFQlENluFGaqEWDYRKdX8sSiA+8uR7BtnbCrvUK1Mehrde5eS+f2eRsY91dwPYl83EClGRP
	BkFPzLQ==
X-Received: from plbcp16.prod.google.com ([2002:a17:902:e790:b0:29f:68b:3550])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:41c7:b0:2a9:410:23fe
 with SMTP id d9443c01a7336-2ab10a1a54bmr4579545ad.36.1770683626791; Mon, 09
 Feb 2026 16:33:46 -0800 (PST)
Date: Mon, 9 Feb 2026 16:33:45 -0800
In-Reply-To: <CABgObfbKh1Tbzv63GfopW3KQhYtfAGgXXBgGn6EiR2kSBgH_jA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260207041011.913471-1-seanjc@google.com> <20260207041011.913471-3-seanjc@google.com>
 <CABgObfZeV6D-2cEht1300xNgxYtz=mi6oX4-D8x7exittEe22Q@mail.gmail.com> <CABgObfbKh1Tbzv63GfopW3KQhYtfAGgXXBgGn6EiR2kSBgH_jA@mail.gmail.com>
Message-ID: <aYp86UFynnoBLy3m@google.com>
Subject: Re: [GIT PULL] KVM: Generic changes for 6.20
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70680-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 155E9115AB0
X-Rspamd-Action: no action

On Mon, Feb 09, 2026, Paolo Bonzini wrote:
> On Mon, Feb 9, 2026 at 6:38=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
> >
> > On Sat, Feb 7, 2026 at 5:10=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > >  - Document that vcpu->mutex is take outside of kvm->slots_lock, whic=
h is all
> > >    kinds of unintuitive, but is unfortunately the existing behavior f=
or
> > >    multiple architectures, and in a weird way actually makes sense.
> >
> > I disagree that it is "arguably wrong" how you put it in the commit
> > message. vcpu->mutex is really a "don't worry about multiple ioctls at
> > the same time" mutex that tries to stay out of the way.  It only
> > becomes unintuitive in special cases like
> > tdx_acquire_vm_state_locks().
> >
> > By itself this would not be a reason to resend, but while at it you
> > could mention that vcpu->mutex is taken outside kvm->slots_arch_lock?
>=20
> ... as well as mention kvm_alloc_apic_access_page() in the commit message=
.

Ya, will do.

