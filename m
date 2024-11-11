Return-Path: <kvm+bounces-31520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2079E9C459D
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 20:11:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7331283569
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 19:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 572F71AB501;
	Mon, 11 Nov 2024 19:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qQ/22BOH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CC014B965
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 19:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731352282; cv=none; b=LIscXCZHNfb4bvqC4NkV9aVQl5SwVZZhtZhleI7BHMb6LAc3oLdkHbCVzkPAGFFTek+C1+kYreZjbmEwGv3QDSj9/a/2tyMKWEv3kh+DcToRnMasng3NzCpXTRRIg4wKBIuMOlXo1lG6jihMwtpLzddSCT3US03l7jJHpEck+SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731352282; c=relaxed/simple;
	bh=JlO6q+OUe1i268Mv5jC2WU0Znx+OObKUQdS3UctfJYI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LcfwLMAIZEcB3zTr25LAamtt2U62BWezJt8Ky9Dpk4bBTLw0rWcI39eott2Hv+iF7VUbNhkZ7pL/WWMQzjTk4FrlqRyvD4dccMm6UR4Q/c77rKNuCBnKgFyraMESsYLt9xoA+rqz0C9LoO5WEHzCuP52NbxhenCcuZOgSZXYHlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qQ/22BOH; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-20c9fe994daso50677555ad.2
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 11:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731352280; x=1731957080; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ycB/AH4RVmcFXjN8oQpRRHRWTlPOr33hZc08ueCNSuQ=;
        b=qQ/22BOHz29IZvnYb/t8lhk4xUncq84923hO1tjhMk1OQYF2cHFPOLM3B94M27msd7
         uPzVFKO0MWrjsWcKwunP7a5ZY1/JaeY4S+aT9chE+kCO1J/WEu2GXyao8vo+ISCUeLo4
         zuXCNM+KBx5NdY4vhtOokrxQAVcTxcWKPHSmL98dzcVbfNWqMcOILpZoLTx5eNHWY4/b
         FTgPOKYoKJIMs3BNGvuqplPzwWb13Jw9DoK084qhqaF/L4aKTKrZkEN4lXMrr49AUzbU
         /z1Xb6OtGWtwySaup9x7pockDRYJ+/NHs3bQIeBWgayfUWBJCfFhlJCcDM6usTCwLxg6
         Bv3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731352280; x=1731957080;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ycB/AH4RVmcFXjN8oQpRRHRWTlPOr33hZc08ueCNSuQ=;
        b=PukD4jLY82iOdDC+6D20msilfzPMybFEOkozu6h1el3B1CZyFtpgjQkJs+LHqYYlMK
         qsS7AdYLxaaUltHYouqAqjdrnt/g4KVt8s3E+E/jhKp0QBWjFI2KrWlrED/fqlYxC4a4
         vNfVvZczhb/prl+LgKA5IRNimOGMCd9F/4AR7/oTwCiIy01OV7FMp4rSQTpM7E+/BPiH
         h9Xq7N1V6WePqeQXy1s9zK3FbUhculBdEir5cRd/MBWEHUkdRNTjTgPflwLyTulGSe+F
         LZeYeAm2f6SmW2oQl1gLBrn69S3KTEn7UaIuy2dZPtp/9aYswmNRk/piPA2rcpMN2p1O
         mF0g==
X-Forwarded-Encrypted: i=1; AJvYcCWXo5vEIxcKU10YPgxuFMQk/I7iER4V7rGO2cTaxbNAqehVCC5gnM6YvnCdtdLiNMI5Nh8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+svWQoqidUrqsfZZXogKIhV4FzefsiE9OCgRcArCg6xvTcNAE
	RepnCsB6ixWi5p0JhbaRDaqp+WmZPExBEjI7UaPTeH8INmJAGxbPxdAHG6ZfhqY0Jd7KmwaLOyF
	pPQ==
X-Google-Smtp-Source: AGHT+IFKZjLCcbHBZ7qRiVULKga60+iBsVEKe4QUj/6ecRDCwbyIGBpL83UDcVDRSqb5Kx4yQ4yIv9iDl6I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:e492:b0:20c:6bff:fcb6 with SMTP id
 d9443c01a7336-211834e0eccmr268195ad.3.1731352280377; Mon, 11 Nov 2024
 11:11:20 -0800 (PST)
Date: Mon, 11 Nov 2024 11:11:18 -0800
In-Reply-To: <CABgObfZ+ZiQWJ_x2AJ2bgModK7ziv+qUvWaS-HySq4SRwvFMCw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241023083237.184359-1-bk@alpico.io> <ZyUMlFSjNTJdQpU6@google.com>
 <CABgObfZ+ZiQWJ_x2AJ2bgModK7ziv+qUvWaS-HySq4SRwvFMCw@mail.gmail.com>
Message-ID: <ZzJW1nosoaovA-fF@google.com>
Subject: Re: [PATCH] KVM: x86: Make the debugfs per VM optional
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Bernhard Kauer <bk@alpico.io>, kvm@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 07, 2024, Paolo Bonzini wrote:
> On Fri, Nov 1, 2024 at 6:15=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> > I'm not opposed to letting userspace say "no debugfs for me", but I don=
't know
> > that a module param is the right way to go.  It's obviously quite easy =
to
> > implement and maintain (in code), but I'm mildly concerned that it'll h=
ave limited
> > usefulness and/or lead to bad user experiences, e.g. because people tur=
n off debugfs
> > for startup latency without entirely realizing what they're sacrificing=
.
>=20
> What are they sacrificing? :)

For all intents and purposes, the ability to get an per-VM and per-vCPU inf=
ormation
from an arbitrary shell.

> The per-VM statistics information is also accessible without debugfs, eve=
n
> though kvm_stat does not support it.

I assume you're referring to KVM_GET_STATS_FD?  That's not easy to get at f=
rom
the shell.

If a host is running a single VM, then the per-VM directories aren't needed=
.  But
I would be very, very surprised if there's a legitimate use case for runnin=
g a
single VM, with debugfs, that cares deeply about the boot latency of that o=
ne VM.

FWIW, I would be wholeheartedly in favor of providing tooling to get at sta=
ts
via KVM_GET_STATS_FD, e.g. given a VM's PID.  But then I think it would mak=
e sense
to have CONFIG_KVM_DEBUGFS, not a module param.

> However I'd make the module parameter read-only, so you don't have
> half-and-half setups. And maybe even in this mode we should create the
> directory anyway to hold the vcpu%d/pid files, which are not
> accessible in other ways.
>=20
> > One potentially terrible idea would be to setup debugfs asynchronously,=
 so that
> > the VM is runnable asap, but userspace still gets full debugfs informat=
ion.  The
> > two big wrinkles would be the vCPU debugfs creation and kvm_uevent_noti=
fy_change()
> > (or at least the STATS_PATH event) would both need to be asynchronous a=
s well.
>=20
> STATS_PATH is easy because you can create the toplevel directory
> synchronously; same for vCPUs. I'd be willing to at least see what a
> patch looks like.

Ah, creating the directories synchrously would definitely simplify things.

