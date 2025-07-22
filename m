Return-Path: <kvm+bounces-53129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B87A4B0DE33
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 16:24:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38A8D1C859FA
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 14:18:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ACF12EAD1E;
	Tue, 22 Jul 2025 14:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PDQV1Dwf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A832EACFB
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 14:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193628; cv=none; b=mimzITGyy2ylm4MSVfG1PHRZul34YI+0t9SXuRYCMUbJx4H6og/noQcKvs5Mbnuc35ZIgyiOfROjBz61h3Rr5syTcgkPyAqcpXzzIqQ2FbNq4DVjuOfsfMKNCIlfAmjw/06jKHDs+4+4crZzV89g2YR2+aoBt6zvbkKKF0KP5HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193628; c=relaxed/simple;
	bh=SIVeV/5x+C+aiI03S1yS9XTn1eCXwkQ8UaH2ikV0LOM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JGpeV8R8uZHXzuPUKzG4EhiWx+MPOxucdb9sOJt0X4NNqu5CFDnVxy9Pq5CEuJLwynTKg4z893D0xCHmqiaeqN9QLa48SnNn6UkXAKsOZw0gvjg3954icWz0a88VADhQz1hv2OsQXzmrJ/sagBCPg+xoKeHDe9gtciqY9ZFNoJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PDQV1Dwf; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313ff01d2a6so4485621a91.3
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 07:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753193626; x=1753798426; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=20QLCvcSY004GezKtjT3+306FnS1qCy6LGwEuBD+8PQ=;
        b=PDQV1DwfZmU8I+tEYB/6rFr8+Qw6rWmy+NVOPOo0aZB+O44qLApABV/adtGv75mAq7
         VaxGD/GhCXpP4AtG+Uqn/SI1qpeDDfdhdY8j9hi7TSRJa2lsrBC+Ig3AxSnTrPJlM7z3
         l7VRiodD2P1IELY9NSw0Z3VNAF5DJhgW9PznBeEriaYQWrS5NR3wFNTBVEdGWAjcLrR2
         zmoQY4satICRkCvknv1cVomSxFSA/kNyY57al7XsGsEsl2NbCEeEpkiGqLs/Gx6yNkJH
         9yCtmJcauJn2Qe5mAPy1vX4P/U8c+PLU43mcm8NAGX+1Kt/+TjPFRwByh94I02dqscOf
         kl4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753193626; x=1753798426;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=20QLCvcSY004GezKtjT3+306FnS1qCy6LGwEuBD+8PQ=;
        b=mcuEKq9+UI5PKbPDB4Ir7BJIgW3vPk2k3FIN1e9iO9pplTD5oTbuSgMtApBADC3uwh
         SiqdG//779CIJoaadwwjj4rjnp4pq/nk1AMx7JPKsSkyrr3S7/4qNrQd120yyf+KdIdC
         ox1GBbuBci3g8253ybyvMfZkJw4cA+xhp//P9jb5jr7akevrYdEnSl8CCBPgz9hmLfVy
         7DhLkyULvyYPL2wm6sOEgymWye2TQ1x8suHVEyULPutUkn4BPtVGEC6YEOKQDkZWpmYB
         +F6CRecP3CikYHFRJQeuNbdMvsr2WixxOKoMCQRcEnn2KnQOwYGGGqWP00HlBHxBdlIg
         m1Iw==
X-Forwarded-Encrypted: i=1; AJvYcCXC52wrwyqh4ZcsH/LKDsl6ffvq+H27mkgqi3gEoYSELSdMzm3ZPU+qQjFGe7jR1dioDkE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxgMtHMhCWGliAP14nUa2gckWsncm5XNRAU6iadtKFTRabJx8X
	TWR2I6cjDAzNu/90/s5x/ji5qcBUj20ah9H5EH/0Xdv6yf5u/jk7N6UYUbA2TT4tUU2mYB4ENkr
	XXOg+vw==
X-Google-Smtp-Source: AGHT+IHfoyKyRi4QOiUDSxvjqgLFDO1L/1RhSMjfXAzLTeEHcAyBHXnbeLhZO6F6DXRrf5fW+BcFtbQoa1I=
X-Received: from pjh16.prod.google.com ([2002:a17:90b:3f90:b0:312:eaf7:aa0d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c04:b0:312:e9bd:5d37
 with SMTP id 98e67ed59e1d1-31cc2515a29mr24112775a91.6.1753193626228; Tue, 22
 Jul 2025 07:13:46 -0700 (PDT)
Date: Tue, 22 Jul 2025 07:13:44 -0700
In-Reply-To: <96a0a8b2-3ebd-466c-9c6e-8ba63cd4e2e3@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250704085027.182163-1-chao.gao@intel.com> <20250704085027.182163-20-chao.gao@intel.com>
 <4114d399-8649-41de-97bf-3b63f29ec7e8@grsecurity.net> <aH58w_wHx3Crklp4@google.com>
 <96a0a8b2-3ebd-466c-9c6e-8ba63cd4e2e3@grsecurity.net>
Message-ID: <aH-cmDRPPp2X7OxN@google.com>
Subject: Re: [PATCH v11 19/23] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, pbonzini@redhat.com, dave.hansen@intel.com, 
	rick.p.edgecombe@intel.com, mlevitsk@redhat.com, john.allen@amd.com, 
	weijiang.yang@intel.com, xin@zytor.com, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 22, 2025, Mathias Krause wrote:
> On 21.07.25 19:45, Sean Christopherson wrote:
> > On Mon, Jul 21, 2025, Mathias Krause wrote:
> >> Can we please make CR4.CET a guest-owned bit as well (sending a patch in
> >> a second)? It's a logical continuation to making CR0.WP a guest-owned
> >> bit just that it's even easier this time, as no MMU role bits are
> >> involved and it still makes a big difference, at least for grsecurity
> >> guest kernels.
> > 
> > Out of curiosity, what's the use case for toggling CR4.CET at runtime?
> 
> Plain and simple: architectural requirements to be able to toggle CR0.WP.

Ugh, right.  That was less fun than I as expecting :-)

> > E.g. at one point CR4.LA57 was a guest-owned bit, and the code was buggy.  Fixing
> > things took far more effort than it should have there was no justification for
> > the logic (IIRC, it was done purely on the whims of the original developer).
> > 
> > KVM has had many such cases, where some weird behavior was never documented/justified,
> > and I really, really want to avoid committing the same sins that have caused me
> > so much pain :-)
> 
> I totally understand your reasoning, "just because" shouldn't be the
> justification. In this case, however, not making it a guest-owned bit
> has a big performance impact for grsecurity, we would like to address.

Oh, I'm not objecting to the change, at all.  I just want to make sure we capture
the justification in the changelog.

