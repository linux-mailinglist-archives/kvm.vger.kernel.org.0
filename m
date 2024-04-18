Return-Path: <kvm+bounces-15124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CDDE8AA21D
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 20:37:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1EDF28259B
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 18:37:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA392178CEC;
	Thu, 18 Apr 2024 18:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rS82ilXo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EB016F843
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 18:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713465421; cv=none; b=DLD1c1UqL9+4XJsEbm3QD3uR2aKeG+ZOYivQEGAVpg8kw8VEvLzzEorEkzuNqgmOt+crwIZp9A70oWQfyheLjYl46nbjiP0uV3w46c2pdm7z5nSsTHyToGpDuMiaCbikatdHP3CLpH6wr4MFsBSIkGV5rrLoQw5zNdOh28BffBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713465421; c=relaxed/simple;
	bh=5M7sY2eNkmePxZYEhbphJRX7F7XSNeGGbs2z+TtGQ10=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=llXnI/x21oYV5JassrT5aGjrHLFSVziDmLI3ZBVNAnKLWOediWDTWTJ1zTZDtsDjtU7b+k0PPQwsHOFQiQ61fI82VWr+3Ma0fRJO3LytM5Xd5TVRPRtiqF1hIse7Eo85SAH4etaW4A9vdIyoYm3hBE7RGjoFwFiEXKl7r/dSIYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rS82ilXo; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2a482a2360aso2021642a91.0
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 11:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713465419; x=1714070219; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+wlN/ce91bTf9rbFasUDQdfgpzsyETmNKvn6NbsAl7o=;
        b=rS82ilXoy6GZhfwknA0JqCrTPIg4eHWWzsNFXY1+6YnMxmOVOpz2aPS6qs/yvXNBC/
         IY3p6GFKqzBramDmAMK2oJckpsfw/Yn598Tt+qBYIbQXbpPg6r7dHXVYtSC9+j8yen4A
         dy9TKe3tzEbKadQoCnB6lloa+66xFKtdSB3yzhbns4IPAoFx9sWYXfxqEmbOvbrr7ZK3
         Hx97/T559MRJtWsHSU0EpXXuuGNu70C0n9jExU8vFZuGpJy9SBuFgezejK6ccnSJSS0g
         rX93TTJp4H1GGbpedbgpkbLoU1sFTgy2HMnDjqDK7y1T3VFujup1bgFNb4wy/Fp7G4nu
         6ozg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713465419; x=1714070219;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+wlN/ce91bTf9rbFasUDQdfgpzsyETmNKvn6NbsAl7o=;
        b=vfO6FdwpXio4B0QuIYuGXP9pm6XOR93CThr4QvXxTj1GmCGruCaGBYj6Fs2aTw0Mlo
         L/43ASbX6SnGa65GGaeUAmkhmQbueQUTJZcNJ8rXHfsI2anhzm/JEjA49itndO9uA+Sy
         b8yyWZrtJ4YttUdXJTcWFm/y05AmkFOCjNkeWey9EMd8rmS6BPMeguyAlMPpTXlid75S
         XW+NzEojqpq/25Qv2oBwxQEPIROk2EFZRj1+RPyNHtvARbUkA9EZRx9ZSK0bXhE161en
         zoAm2tKluPEM7V9tt3uNtutdd7rbGBRgjpS5yb5RRlzniPYrDienqxhdiB4DL5wXx6xq
         B64g==
X-Forwarded-Encrypted: i=1; AJvYcCVYJsAjIJG0qR9q3j3AedMow9W1oKAw+6SMJ89ud8/ugxzPskMmCphAZrANsFQnZ0gJDLUWohBuiNPipfa1kp636WC8
X-Gm-Message-State: AOJu0YwrqumX7MQq9ZjQQEFrW5RrzH9YUDKMJZyNQ6aT4KBwtUe8BjsI
	uy7cNw3B0mC+oisti0XSNzYBdTfFjuOSzxsrvYGKzIT0v4Z4L0qnsQzxtt7vjZkRf5ICloqnkzL
	3FA==
X-Google-Smtp-Source: AGHT+IEEQdqUCVbpG8urZmuw0tUnHYvNqYQTHwsqXS5Je37zGkNyPzcVm0cNUkYflnrODXJVMl1KaQDGJeY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:3d4f:b0:2a2:bcae:83c1 with SMTP id
 o15-20020a17090a3d4f00b002a2bcae83c1mr15360pjf.3.1713465419139; Thu, 18 Apr
 2024 11:36:59 -0700 (PDT)
Date: Thu, 18 Apr 2024 11:36:57 -0700
In-Reply-To: <70f9f3f847e614cbb95be4c011ecb0a5cbd2ef34.camel@cyberus-technology.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240416123558.212040-1-julian.stecklina@cyberus-technology.de>
 <Zh6MmgOqvFPuWzD9@google.com> <ecb314c53c76bc6d2233a8b4d783a15297198ef8.camel@cyberus-technology.de>
 <Zh6WlOB8CS-By3DQ@google.com> <c2ca06e2d8d7ef66800f012953b8ea4be0147c92.camel@cyberus-technology.de>
 <Zh6-e9hy7U6DD2QM@google.com> <adb07a02b3923eeb49f425d38509b340f4837e17.camel@cyberus-technology.de>
 <Zh_0sJPPoHKce5Ky@google.com> <70f9f3f847e614cbb95be4c011ecb0a5cbd2ef34.camel@cyberus-technology.de>
Message-ID: <ZiFoSdKY7nrh7cfL@google.com>
Subject: Re: [PATCH 1/2] KVM: nVMX: fix CR4_READ_SHADOW when L0 updates CR4
 during a signal
From: Sean Christopherson <seanjc@google.com>
To: Thomas Prescher <thomas.prescher@cyberus-technology.de>
Cc: "mingo@redhat.com" <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	Julian Stecklina <julian.stecklina@cyberus-technology.de>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 18, 2024, Thomas Prescher wrote:
> You are right. After your pointers and looking at the nesting code
> again, I think I know what to do. Just to make sure I understand this
> correctly:=C2=A0
>=20
> If L0 exits with L2 state, KVM_GET_NESTED_STATE will have
> KVM_STATE_NESTED_RUN_PENDING set in the flags field.

Not necessarily.  KVM_STATE_NESTED_GUEST_MODE is the flag that says "L2 sta=
te is
loaded", the NESTED_RUN_PENDING flag is effectively a modifier on top of th=
at.

KVM_STATE_NESTED_RUN_PENDING is set when userspace interrupts KVM in the mi=
ddle
of nested VM-Enter emulation.  In that case, KVM needs to complete emulatio=
n of
the VM-Enter instruction (VMLAUNCH, VMRESUME, or VMRUN) before doing anythi=
ng.
I.e. KVM has loaded L2 state and is committed to completing VM-Enter, but h=
asn't
actually done so yet.

In retrospect, KVM probably should have forced userspace to call back into =
KVM to
complete emulation before allowing KVM_GET_NESTED_STATE to succeed, but it'=
s a
minor blip.

> So when we restore the vCPU state after a vmsave/vmload cycle, we don't n=
eed
> to update anything in kvm_run.s.regs because KVM will enter the L2
> immediately.  Is that correct?

No?  Presumably your touching vCPU state, otherwise you wouldn't be doing
vmsave/vmload.  And if you touch vCPU state, then you need to restore the o=
ld
state for things to work.

Again, what are you trying to do, at a higher level?  I.e. _why_ are you do=
ing
a save/restore cycle?  If it's for something akin to live migration, where =
you
need to save and restore *everything*, then stating the obvious, you need t=
o
save and restore everything in KVM too, which includes nested state.

