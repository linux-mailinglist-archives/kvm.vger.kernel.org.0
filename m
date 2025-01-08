Return-Path: <kvm+bounces-34831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36C0CA064B9
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:38:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35E49167132
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 18:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B1A203711;
	Wed,  8 Jan 2025 18:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d+VDfPyZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7440E202F8E
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 18:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736361490; cv=none; b=i0oHTGOA5y69+41A3hw7gBQ/VY84R9qe9yI9Cq+EnQn7UdAEbXHkzshiAjoxC19eM/EbVJ4ZAorHa5W4dSBS5E3sCrBrA4ZJ/LRAmjoW1Cm0/0eClnZx+3Yf/fVFcyyQzjjHh0XZR9dtrsg7sZBsqjtaoDpaPTmadGtshd9Ro1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736361490; c=relaxed/simple;
	bh=bf48noVx1rxZiq7D8zYv8Ls/wisBvKRUQ3WxadgSAGI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PUcNHKDNCXPN54ued89vJPaWYkDPvMS/ZV8vRQx9qNfLTo6DdQP+tKuYBKvZlNXpfnjYc3LidrKOPNLWn1Mb6PkCMxhtvISPhK1vBxOyxFAydFmFkmJRFELVDaGSvtvR3FEYrONI+thlQ8NrIn9NgHaXI1mYb5PMI4IMc0KMIY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d+VDfPyZ; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3a7dfcd40fcso5535ab.1
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 10:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736361488; x=1736966288; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fQwVsko0I7mVNZY1jfYaW/hpkuFOzc2MVb+xzo71Ygo=;
        b=d+VDfPyZrgs6A/ZpsbwfvOQWIb13/0Fk/cddLzef1VPNZ/sFFobykQXpPoWjh8OLlP
         YbQkjrXwjQxIQUuk2E2pB7oeCGxMGIoloLEOMgxkG3wAfCEzIid+nIIuRQFalyeEaTMq
         VGuM1LQpDKbs4mHXQiBMSUxa7Nmu1IJ+ZbyqyL/tHm8t4eM0VvtWamJrX7h7EYFcLMyT
         w23YmNqbFNUGYk6m23l0yhfJmStNVzLO1KBJ3gosid8eJcz+NhRdcKLq3I2t7rEmEN9R
         2zaYBS7rYVAoT6odmjPNipGX8BDtq5Z1nCETuNqmfc1n9xiuLH1IwQaRzK7wWHFmx8UJ
         LIcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736361488; x=1736966288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fQwVsko0I7mVNZY1jfYaW/hpkuFOzc2MVb+xzo71Ygo=;
        b=hHjclrnLRnstVi8w/jvJ6LO9aJjp9DVi5yUqhHaRJ54/8g+OO7ifdJjolk2rGX0f7f
         MnwCYaPF5R03Jbq4QYk6Nez5LNI74ZlXtbif/nTz6FmsUgL07sNTJgQkqfTtQFc1WHRY
         3mNiECnNuepFJU1AWcDmiXo4kz14XC1TpLQr6gX5mACASA5ftXsWhIUs2BUmIVQVAn5a
         gTldlMCeVN+6QyHEYYCp1pSo2eW/sq7jcOMebON/KY/lSCjQfOOY0CeTmaz0t84hmNra
         o/JQmASkh31QD1VBg0HsrujyMc/QSQ7ERcXAb7/IVyh6LN6Q8YFcuEy5BTe0PrrPOqVb
         gCEw==
X-Forwarded-Encrypted: i=1; AJvYcCXJEgFDBIBAb7Q1Ge/rOzBRec5/ptozjdy0WSsUbUdWvqTu+g4TVOMrR51jtn+8gpGSRIY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8G8NbiBuM6vyHobr7XGEhfj929EhPbOSMkqCi5r2NeT4gejTF
	LIZbHRSULY4T8e0nHhVrJbXLLOLClhdDeLc/kasb/bgegA71yNDoeZFJPtlSoHLetLQfnuIRPfd
	vB8Idr+qRu8sqNWq9ZVtLcZSi+vQIaTVHFTJM
X-Gm-Gg: ASbGncuV1pcz0xPqP7ZQXkf3v7yI/d0J6Q7uWG/1fRXrWFuRHy6SD5pa99ANSBuPfJh
	KkT1WJkBeSRNXKzJmqtnJHZ+xhdMXWDag1c/e
X-Google-Smtp-Source: AGHT+IF018xD8Mcvb76c5KqDYudFT6BfFw2iDRUQdDqGU8JWFVUbiQFezGjPu+jUcfVc4WL8XPsaJ1L5KQC1nKxJ0rs=
X-Received: by 2002:a05:6e02:148a:b0:3a7:e04b:1fe2 with SMTP id
 e9e14a558f8ab-3ce3cee57e2mr3739815ab.7.1736361488305; Wed, 08 Jan 2025
 10:38:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241202120416.6054-1-bp@kernel.org> <20241202120416.6054-4-bp@kernel.org>
 <Z1oR3qxjr8hHbTpN@google.com> <20241216173142.GDZ2Bj_uPBG3TTPYd_@fat_crate.local>
 <Z2B2oZ0VEtguyeDX@google.com> <20241230111456.GBZ3KAsLTrVs77UmxL@fat_crate.local>
 <Z35_34GTLUHJTfVQ@google.com> <20250108154901.GFZ36ebXAZMFZJ7D8t@fat_crate.local>
 <Z36zWVBOiBF4g-mW@google.com> <20250108181434.GGZ37AiioQkcYbqugO@fat_crate.local>
In-Reply-To: <20250108181434.GGZ37AiioQkcYbqugO@fat_crate.local>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 8 Jan 2025 10:37:57 -0800
X-Gm-Features: AbW1kvYhw3zQESTzxn1NhVaBN6lqn2Da8f3hhSct6ppxyfB7QEKSx5pA43U3EH4
Message-ID: <CALMp9eTwao7qWsmVTDgqW_KdjMKeRBYp1JpfN2Xyj+qVyLwHbA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] x86/bugs: KVM: Add support for SRSO_MSR_FIX
To: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>, Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, KVM <kvm@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 8, 2025 at 10:15=E2=80=AFAM Borislav Petkov <bp@alien8.de> wrot=
e:
>
> On Wed, Jan 08, 2025 at 09:18:17AM -0800, Sean Christopherson wrote:
> > then my vote is to go with the user_return approach.  It's unfortunate =
that
> > restoring full speculation may be delayed until a CPU exits to userspac=
e or KVM
> > is unloaded, but given that enable_virt_at_load is enabled by default, =
in practice
> > it's likely still far better than effectively always running the host w=
ith reduced
> > speculation.
>
> I guess. Kaplan just said something to that effect so I guess we can star=
t
> with that and then see who complains and address it if she cries loud eno=
ugh.
> :-P
>
> > No?  svm_vcpu_load() emits IBPB when switching VMCBs, i.e. when switchi=
ng between
>
> Bah, nevermind. I got confused by our own whitepaper. /facepalm.
>
> So here's the deal:
>
> The machine has SRSO_USER_KERNEL_NO=3D1. Which means, you don't need safe=
-RET.
> So we fallback to ibpb-on-vmexit.

Surely, IBPB-on-VMexit is worse for performance than safe-RET?!?

(But, maybe I have a warped perspective, since I only care about VM
performance).

> Now, if the machine sports BpSpecReduce, we do that and that covers all t=
he
> vectors. Otherwise, IBPB-on-VMEXIT it is.
>
> The VM/VM attack vector the paper is talking about and having to IBPB is =
for
> the Spectre v2 side of things. Not SRSO.
>
> Yeah, lemme document that while it is fresh in my head. This is exactly w=
hy
> I wanted Josh to start mitigation documentation - exactly for such nastie=
s.
>
> Thx.
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
>

