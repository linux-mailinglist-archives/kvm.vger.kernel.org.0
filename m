Return-Path: <kvm+bounces-67468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CBDCBD060A6
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 21:26:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 752D33010055
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 20:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18ED632BF5B;
	Thu,  8 Jan 2026 20:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RVqURCVn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023112E7F25
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 20:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767903986; cv=none; b=FsHlKnbijwPimjMAlnyTOqClEL6i/t5nYQOwGtjzDiEimBNHgJyt6zdFK+VSHDi/XtedB+OSa3BD/5WbHrF/N3esJ+7BLACMsD1hkiqkXrrgCdTnvT3IsDE2vtE+o0sD96Wp16n5SB4mGqG/6BCow+k49blNExoiMqBFDJuW5LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767903986; c=relaxed/simple;
	bh=vIRf8ek37UC4I8pZL8f4DnX+0SWacmoiw+WywWiO7KQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BGD64onD5h4ij9wBlEk2Qakl0MiOh6/IqER9cnnIFynLHsOtzVW892tnUnnVDUuvKZWKKbyBtFf+u6gXciDPdWpdd2mLBtTt22LlD/88JYQSTdLixmc4RAeJ386GXBLUiuTBsI8x4Jlfo9VqMI+18cXsDyRLeWPeZZ779Yb1/HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RVqURCVn; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29f25a008dbso27426835ad.1
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 12:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767903984; x=1768508784; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KHFQ1zwwcYEgWyhJUZX4RICWrZYFGmhNrU0B1R8MCB0=;
        b=RVqURCVnGMRIuzLvfLM/Byl2mxDgAJUySNqs2YVdf6k+EGfpuTOtx9PoyOfxkYBdgV
         h3EhbCF6CRO+XoEaAzvga1Nj4t5uXTkSdqnpTRBoFnu28KfU9rez/mY4wxL0BEdYs/OA
         y593fufPCcLlf8xr1rksYutbBLkpNPos1WcUoCGZ8atClcF1YOmfO86s+5lyfDtu4vCI
         j75Hq8XYvlFryGB3VEafgFK4uC6raeNQ81hQ+1Zkm25Duf1z7xPVicjupElYkzRWSy2N
         G60RmSaNVvbpoHB2p//l9YkENUyEFN6CAF1Lx/qG93BEZx6uqINhbKKkuQa6Ml54OyX3
         rNCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767903984; x=1768508784;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KHFQ1zwwcYEgWyhJUZX4RICWrZYFGmhNrU0B1R8MCB0=;
        b=c31jmmnebleZwOqT/96pzKyfEoY3IIAVbSdxqRs3++3kJWXJxKXZ5BEq13rg0vwVAY
         Wm2El38zkhnahXmqMQM2Yw8KIFWb6uaToOZkdbMEZPB5JgZyHrCWMXzCpbDaQqO/xhx7
         8Haa7xGNocGb4rDcSqkwXTNMGV7zKqsbeEkxYRKyJ9znRupEO09doYZFCHafeFcANtEV
         MkH1afGRQAQB2cMpX00wnX08RWoRonpGd5NiCQLZ7Vmh36h2E7CfHC1XNN+AlCsfYZ6K
         2LkyBTcsGMk/Uz9mchCHKRqcWAZMrSCRHciYwZ6S4Jbx8+Gbbnmog9GIFK0Ikep68vJq
         tsCA==
X-Forwarded-Encrypted: i=1; AJvYcCXPOgc0op/29eexQIasNnt+tLl+44LDkMJL1rkHXE54JjIsL13pCK9iQ36Dno71PUZe9D8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8MzgA/WhjllDg7zK7eK9Jkay0qRssibj9bWiQAnVivfuAWAz/
	7pYMeejZpoZFNS/paUObMdXNUdeB+9e4IriiOWfh3th4FA82wEmTFupg9Vo5C5mMj5wEk2k1//d
	7b5IB4g==
X-Google-Smtp-Source: AGHT+IELS2jNbkin4p6y/JaFdumZZ6d4Quwy/rgYJYNAtZ7zSyujQrglRfN5SOfYVkHyE9oSzxVyjGEfPAs=
X-Received: from plbbh12.prod.google.com ([2002:a17:902:a98c:b0:2a0:d5be:7bb3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:46c5:b0:2a3:e89c:593e
 with SMTP id d9443c01a7336-2a3ee41f181mr81057965ad.4.1767903984247; Thu, 08
 Jan 2026 12:26:24 -0800 (PST)
Date: Thu, 8 Jan 2026 12:26:22 -0800
In-Reply-To: <CABgObfZSchPMdqSvvVPgy9s5-TkHHZpLPHNYSsK-YHRye0SAaw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260101090516.316883-1-pbonzini@redhat.com> <20260101090516.316883-3-pbonzini@redhat.com>
 <aVxRAv888jsmQJ8-@google.com> <CABgObfZSchPMdqSvvVPgy9s5-TkHHZpLPHNYSsK-YHRye0SAaw@mail.gmail.com>
Message-ID: <aWAS7iCLgJHd_GgZ@google.com>
Subject: Re: [PATCH 2/4] selftests: kvm: replace numbered sync points with actions
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 07, 2026, Paolo Bonzini wrote:
> On Tue, Jan 6, 2026 at 1:02=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> > > @@ -244,6 +254,7 @@ int main(int argc, char *argv[])
> > >       memset(addr_gva2hva(vm, xstate), 0, PAGE_SIZE * DIV_ROUND_UP(XS=
AVE_SIZE, PAGE_SIZE));
> > >       vcpu_args_set(vcpu, 3, amx_cfg, tiledata, xstate);
> > >
> > > +     int iter =3D 0;
> >
> > If we want to retain "tracing" of guest syncs, I vote to provide the in=
formation
> > from the guest, otherwise I'll end up counting GUEST_SYNC() calls on my=
 fingers
> > (and run out of fingers) :-D.
>=20
> I had a similar idea, but I was too lazy to implement it because for a
> very linear test such as this one, "12n" in vi does wonders...
>=20
> > E.g. if we wrap all GUEST_SYNC() calls in a macro, we can print the lin=
e number
> > without having to hardcode sync point numbers.
>=20
> ... but there are actually better reasons than laziness and linearity
> to keep the simple "iter++".
>=20
> First, while using line numbers has the advantage of zero maintenance,
> the disadvantage is that they change all the time as you're debugging.
> So you are left slightly puzzled if the number changed because the
> test passed or because of the extra debugging code you added.

True.  I'm good with the current patch.

> Second, the iteration number is probably more useful to identify the
> places at which the VM was reentered (which are where the iteration
> number changes), than to identify the specific GUEST_SYNC that failed;
> from that perspective there's not much difference between line
> numbers, manually-numbered sync points, or incrementing a counter in
> main().

