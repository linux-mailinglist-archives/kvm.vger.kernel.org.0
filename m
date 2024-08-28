Return-Path: <kvm+bounces-25306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C37CE96356F
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 01:29:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 031391C21D0D
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 23:29:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49BFC1AE874;
	Wed, 28 Aug 2024 23:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CpXZX8Np"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BE01AD9FC
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 23:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724887722; cv=none; b=GUfFl+0RQ6mMS/nSayTjn29m5sIpfHkUv77iH4yK3kHVu75o1e9q3Ao/6TzYr0WxooappBW4lxY4+NoxJJdUmVbUlybLERb0JEaGiQnYNG3QTqZ9sHvCuSGk4onyudEbvVvA6QvLfiyGl8X9i/2uQjbAWjzDQHjByOStDhnUGAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724887722; c=relaxed/simple;
	bh=lBhx0FCEgRhOzz/AM48gubNsM32UrXU4v7bnkO/VbF0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AEUlwvV/EAjCOZTYO2DySsHA0tOQrwB7dDUsy1Sk8pamgU82jpgFv+1U6mdrLsO2IFfszR+IdL3QY1k6YA5ox6+Nr0ve76pFCDIdwnT0mrCt4sH8yDTqKm3WSQRyRq51eaqQZ/3fr4gMtP4MEpPA5qfO0Cz2aDQ7PNbp+0M9mvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CpXZX8Np; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-201e24bd4d9so508495ad.0
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 16:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724887720; x=1725492520; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oxYEab6zxYFMI+0DGHubDHuUFu0b12AkR4fPJNH3Xb8=;
        b=CpXZX8Npuwm4t4m5HkqdpJhGhnuF9ab2US55QIAIaDy5BMGL+H33CynKgua8ylWNyQ
         jdwStKQzevzDrKrJnQbbjrH+jqWq/7CbSEX3YLzveMpogBgsabm3VIv/5GQSxD3/XsfF
         8dHmE39yC5OSZWnxyBsddfdfs8wYOfP7cZRnvyvP5Yr4yubUEMr6pDqx39y9CjLARdMh
         /1LXqYSiAO/GThjhs3MSdY5Ph+VgIOfHs29DNHY37xyK8TzWLFFunE5KCFfOyOwm3aTW
         pSMlq3WtJOYhs3yFHEOou6xtP+SUkjwJZ3apwTVlJ8NlGO2Jh9itHRXnCT/ze+p1fcJf
         C9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724887720; x=1725492520;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oxYEab6zxYFMI+0DGHubDHuUFu0b12AkR4fPJNH3Xb8=;
        b=ndOQp4MCuyKizdTerM/kd/J44DmyP73pgfHpriC8e9nDc7gcZOMNy5RLAjzz3RuhoG
         cg2auTgMdY53xKKqYVhvkr57rRl8DmJJ3Q7V4S5hnuygByz6FINczxmkq20ea4PTScIZ
         RCn7w1AD5/0kH1IfOOh5Z3gbKtjZh8f29awtWijc0eDiamtJW2o7MjtVQBbCO9pmImMn
         PHc/YZz4QWix/VTkkL36KCAJSnSse5aYyto9VICMu2PPHTkgAUwSnnjJInP5yqIddj4H
         /rjPltZfo3CkU0GoEuP0LqS/bbCjnmcy0Pb6Ckf7WZE8//AU9+iUJjENA7wbDiaNUV1Y
         3EEw==
X-Gm-Message-State: AOJu0YyjAdMYzxDKvoAUGWDznktUjQHPWEsRSyWIGduOPlBf+iD669YX
	RjhMgJet7E++HO8r4/seYYDsOxlwNAlteRJ4FW6qNDfudqv8oJ3zjto2b3g8Cefvx1WqWjSo8WG
	hpw==
X-Google-Smtp-Source: AGHT+IHQWZfN/lWwUXU9lq2tHcwgrLgbrNayvmPAfcbGRgGUTyyJfmJ/nZsxcaRcU/NLevR+7Kpsm016RsA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2281:b0:1fb:5a07:7977 with SMTP id
 d9443c01a7336-2050c23beb8mr613695ad.3.1724887720231; Wed, 28 Aug 2024
 16:28:40 -0700 (PDT)
Date: Wed, 28 Aug 2024 16:28:38 -0700
In-Reply-To: <CABgObfbyJo2uYYkTTYdrrYQcB6XgB2+PhmfqwKrQ-g7D5UPr5A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com> <20240809190319.1710470-10-seanjc@google.com>
 <e50240f9-a476-4ace-86aa-f2fd33fbe320@redhat.com> <Zr4L_4dzZl-qa3xu@google.com>
 <CABgObfbyJo2uYYkTTYdrrYQcB6XgB2+PhmfqwKrQ-g7D5UPr5A@mail.gmail.com>
Message-ID: <Zs-ypmZfGvCTcuBV@google.com>
Subject: Re: [PATCH 09/22] KVM: x86/mmu: Try "unprotect for retry" iff there
 are indirect SPs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 15, 2024, Paolo Bonzini wrote:
> On Thu, Aug 15, 2024 at 4:09=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > > (This is preexisting in reexecute_instruction() and goes away in patc=
h 18, if
> > > I'm pre-reading that part of the series correctly).
> > >
> > > Bonus points for opportunistically adding a READ_ONCE() here and in
> > > kvm_mmu_track_write().
> >
> > Hmm, right, this one should have a READ_ONCE(), but I don't see any rea=
son to
> > add one in kvm_mmu_track_write().  If the compiler was crazy and genera=
te multiple
> > loads between the smp_mb() and write_lock(), _and_ the value transition=
ed from
> > 1->0, reading '0' on the second go is totally fine because it means the=
 last
> > shadow page was zapped.  Amusingly, it'd actually be "better" in that i=
t would
> > avoid unnecessary taking mmu_lock.
>=20
> Your call, but I have started leaning towards always using
> READ_ONCE(), similar to all atomic_t accesses are done with
> atomic_read(); that is, just as much as a marker for cross-thread
> lock-free accesses, in addition to limiting the compiler's
> optimizations.
>=20
> tools/memory-model/Documentation/access-marking.txt also suggests
> using READ_ONCE() and WRITE_ONCE() always except in special cases.
> They are also more friendly to KCSAN (though I have never used it).
>=20
> This of course has the issue of being yet another unfinished transition.

I opted to fix the kvm_vcpu_exit_request() case[*], and add the READ_ONCE()=
 to
this patch, but left kvm_mmu_track_write() as-is.

My reasoning, and what I think makes for a decent policy, is that while I 1=
00%
agree lockless accesses need _some_ form of protection/documentation, I thi=
nk
adding READ_ONCE() (and WRITE_ONCE()) on top adds confusion and makes the a=
ctual
requirement unclear.

In other words, if there's already an smp_rmb() or smp_wmb() (or similar), =
then
don't add READ/WRITE_ONCE() (unless that's also necesary for some reason) b=
ecause
doing so detracts from the barriers that are actually necessary.

[*] https://lore.kernel.org/all/20240828232013.768446-1-seanjc@google.com

> > Obviously the READ_ONCE() would be harmless, but IMO it would be more c=
onfusing
> > than helpful, e.g. would beg the question of why kvm_vcpu_exit_request(=
) doesn't
> > wrap vcpu->mode with READ_ONCE().  Heh, though arguably vcpu->mode shou=
ld be
> > wrapped with READ_ONCE() since it's a helper and could be called multip=
le times
> > without any code in between that would guarantee a reload.
>=20
> Indeed, who said I wouldn't change that one as well? :)
>=20
> Paolo
>=20

