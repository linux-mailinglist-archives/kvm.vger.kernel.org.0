Return-Path: <kvm+bounces-38613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82C1AA3CD11
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 00:10:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA8E37A82EC
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 23:09:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B0D125A2B2;
	Wed, 19 Feb 2025 23:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZsLGu7YK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78DF23E259
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 23:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740006598; cv=none; b=CjKJdwcfE3pGFf1LMfmxtpmvAM+C5Jtvl4UZkQuu4h/4FSavSMqjWtsVRN40B1FFz32YyQqPiZe1ccWuoOtF1YrkW6GxhA6U4A9+hKOYx++NRtSMOCqwewCzZB6sAUSauv9bB/SzDjx3esFiU3hdotCHKEJ7wr73aY1n9qaJYHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740006598; c=relaxed/simple;
	bh=AQQz81U+/uQt8t1jtDfXn5ubKPfVZPZuQq0XA2aTtFw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kP6nYzs7SB5HaOWMoVgy9FdHcAcSbi9okuQkRbfuMYvS6s1Y9UOE76q+7ldEb1OmQ+tFVC7bbUWe+BQf2z82k+lsxNOek/UBLEwwwVCzxrxqgBnk/DCEHRgiqpkaxy1e3iKfuQHah3h951uBPkA6xKpmSx0Mm15/kYWgoDOiEhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZsLGu7YK; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3d19702f977so27545ab.1
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 15:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740006596; x=1740611396; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AQQz81U+/uQt8t1jtDfXn5ubKPfVZPZuQq0XA2aTtFw=;
        b=ZsLGu7YK9eF+Pcq7F4H+mjL16tNspFf2QQp0mJVOCiuIvzX0p0K87DF0KFMybbw45Z
         p/cNOgPaqdODwjm9rxrIOjnaEv2Xfyvnt7873RWrzW/lXFAXQ5+b+RUz4Wmnw0uLjdJW
         GXhdSpzSoC75nwf5WlU2tUCqOMUWkpjqLaz/cP3VT5Cj9P3erA9vmzFm2qwBN/xqchFP
         OCjChEUeguKUUJ1HgI++wnnJyyQ/oMY/Vm/Y/8+vnUTp7ItCuhAFdksOMD0fi3sZfKx5
         c2g5GaHcB+1p/JyDEL1JaH1W2QuluinBl4s05GTOpiO9lIHUzW6gg6GTBL6pyvYRYxj3
         KSLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740006596; x=1740611396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AQQz81U+/uQt8t1jtDfXn5ubKPfVZPZuQq0XA2aTtFw=;
        b=aaVTWurFWoCB8d7C78RHZI9k5doa3HgGRG+qDn+xed5+ZyRDbg3fB1S4FC4pO1Ya3d
         4+2hl4/IyJzjPj08PzEA4noUlBf06tG7VUQiak2C8trelRDz8/oAMLXOGYGHWGP0EhNt
         bC3pkHdKIgg8NJNPQo0WyRNnkGG8P66+0UbrdM8yJxdOs23otWUoKRsmXmHzcnLPnkm9
         H7Hv/y3M30wRZe8Gk1ha5Sj5qaCGFhgbXKIusqa5VN/jUsXKy0UBp1dDN1znzeb7DiYx
         OtKDuEhSU3NxQj2VXhqdlKs174jg0uISzFLrZuO6gEpucWR91aKO9C/411BsP5qkJYpZ
         IuiA==
X-Forwarded-Encrypted: i=1; AJvYcCUSJCv6y9fvQTIe0ZVvvpX2e9quZhdo4Q0w9C6q7SaAkKVkJx/0TkmYRD867mtSdSJH+Ko=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7zkj4PWrm2BMCoBhgeZOVKZ/MNob0KzTPBYiNqVIegdoLU6cq
	2vXQYRYh7Jf5JWwbjkJTHBMUgxETh2c0jL4MblqQv+u4lc8ALahSfgJuTBtgJeK7kKCUd3UgFCs
	wOwt9JXIpLGLyR6fzaJ8kx9HwLeVE6tvSBDNZ
X-Gm-Gg: ASbGncuDiCcsJ7q7GR3ar0w+ORsc7PfFisNwMDe+E3GhfqaIJNhNKNKZ2bYtd8jkUUa
	GdZyWAwdp4jq2NITor0zOCoF5znDX0iHpVon+Bijs/aMCY6pXjqrq8IFTNBvyyVXbCbm+jHTf
X-Google-Smtp-Source: AGHT+IEjLr482aJlHAAFBNSdvbSRICH9yurzAps08NVDvhZKsMsHZ4nAAaz9Lt8jjyW1wzcJ2bGnYSo/O/9OKcNCh0w=
X-Received: by 2002:a05:6e02:144d:b0:3d0:4e5d:4782 with SMTP id
 e9e14a558f8ab-3d2c09e9cbemr1292775ab.10.1740006595834; Wed, 19 Feb 2025
 15:09:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250219220826.2453186-1-yosry.ahmed@linux.dev> <20250219220826.2453186-6-yosry.ahmed@linux.dev>
In-Reply-To: <20250219220826.2453186-6-yosry.ahmed@linux.dev>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 19 Feb 2025 15:09:43 -0800
X-Gm-Features: AWEUYZmIhUTZVLHPN2I1OKFIOPwRKrPuUJoTdwG1QAkz1q6QNSK1OOrLwbQj-NE
Message-ID: <CALMp9eSUGYfyogSruFY_o7EXdKUB52EC3iOU4r+vyrnG3cW-4g@mail.gmail.com>
Subject: Re: [PATCH 5/6] KVM: nVMX: Always use IBPB to properly virtualize IBRS
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 19, 2025 at 2:11=E2=80=AFPM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> On synthesized nested VM-exits in VMX, an IBPB is performed if IBRS is
> advertised to the guest to properly provide separate prediction domains
> for L1 and L2. However, this is currently conditional on
> X86_FEATURE_USE_IBPB, which depends on the host spectre_v2_user
> mitigation.
>
> In short, if spectre_v2_user=3Dno, IBRS is not virtualized correctly and
> L1 becomes suspectible to attacks from L2. Fix this by performing the

Nit: susceptible.

> IBPB regardless of X86_FEATURE_USE_IBPB.
>
> Fixes: 2e7eab81425a ("KVM: VMX: Execute IBPB on emulated VM-exit when gue=
st has IBRS")
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>

Argh! No doubt, I was burned once again by assuming that a function
name (indirect_branch_prediction_barrier) was actually descriptive.

Reviewed-by: Jim Mattson <jmattson@google.com>

