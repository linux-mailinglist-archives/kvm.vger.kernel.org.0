Return-Path: <kvm+bounces-17857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D24188CB366
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 20:18:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 59ED0B22506
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 18:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FBB8148851;
	Tue, 21 May 2024 18:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MkKGpjw7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6452520322
	for <kvm@vger.kernel.org>; Tue, 21 May 2024 18:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716315514; cv=none; b=CdCqBsmPUtB0pnl6DF5qB8fKfe9I0HJhDb/K3REUBn+Es84IMs9B2BvsA78dl2DEBJeyQmVJyDkQmRXZGnB+F3P/kqLk7j5BApZUVwf79DZ4DJIDkYtpX62902m8/gdQTMvC5HlcM+IHI2abVtRORsle5IEUCRqdfeH98ZYdnGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716315514; c=relaxed/simple;
	bh=lfq3/p0h5MKLio19PWndwbYN7MTFoTHLcIZ5Z+wNiy4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XEGX3ocSNRiRjS8gn4Rl0Ee9bbUSFBB9Uq79XvH71HYLkjKP7daQ96j9Jjm4y2SuhHW2MsSK+yiZAelJCSCSZxCLr8slkW9uh10ukdskHKlYTivpdHOm9dNVnUFoHILwSLYuWXVSPuTBGV9MZrOzkp3NELiR8wrsznSf+C7ze9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MkKGpjw7; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b26845cdso18328983276.3
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 11:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716315510; x=1716920310; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TwQ9snbu95pE4x0LUCjBq9CW+c6Rq1RORndHTBMHkaw=;
        b=MkKGpjw7yRyu7hFkfcAWL/Ua8etRSiR/yt3NX3LgjfpIoZcwBfK79AIiXZd9XHl084
         h8PXOiALT9wdbP6pJN7+OlUn6vBwbOoc3AMHPyK1h4jGnM0IIoTFrEqHIDtjSTSplD6A
         NuqrmnsvAc9Nofrw2qfT7N7FGJAHR3xj9RdX7l/Yry4ufvkIB52rr7lT6eWWGxMWvFA2
         XcdEGW6ZODGFGARytnWO7fYHhj3XpFiXvRZ14UjjO1qAdE8pHohGykFxmo3StyBUJc/5
         J0CK5VTgmNYgwMaEUk5TpdIHqluy189p/8l2ZzBcvIHos4fYQUn3NenWZ7YUsDlMTEfE
         qSuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716315510; x=1716920310;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TwQ9snbu95pE4x0LUCjBq9CW+c6Rq1RORndHTBMHkaw=;
        b=Q+jHO/xxXnRi4CcyI/FrKg85Q4psOuXN8f63z+MNYTIn+E3C9eG3WkZit33P2yXKG7
         Z2x3dDOGYKl9yB9wO8BJq3pvfesmW4OTbguNaldSTGGMWh2BNckSwJFQIb2SuHoYBgEl
         s0DmrQctSiOdZq6We4QeMTcVSAqdOYmt1pJ5Qm5XBcMLJmyr2k0C9bBKg9CnFJa7/23Z
         AXv2jB1MA0xO/lIb/m30oNVT48LsLhBATqabVKEUGscWK7u3W8roPWUi/JRmwcDvsiWw
         7oEvCNcAWmpVsYxBMvc00ktiLqqJLadIif3YtlAudiQ8EECEv7VDVHiIkMQdVcyTDBt7
         MB4A==
X-Gm-Message-State: AOJu0YzDYxcFwv2K93AKI6SE5M/Kcbx6XI9Erh/uWZQepKZw+3YGcDnk
	z07iqtdB2Vz3usuYC9UTrdPL2ZYbq3/27OydowW/TG+MRlM98jnltf9+KekPBVSn7ANbxt4Se5o
	e+w==
X-Google-Smtp-Source: AGHT+IGHGDBMmiK5t+GbcsuTKyZDDKZC3FkQs9ca5TrM1ADcpb5DnT7k1vbmiAW7NmfDK1CcFHd1cmlhwBY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:149:b0:de5:5225:c3a4 with SMTP id
 3f1490d57ef6-dee4f304cb7mr7842641276.7.1716315510346; Tue, 21 May 2024
 11:18:30 -0700 (PDT)
Date: Tue, 21 May 2024 11:18:28 -0700
In-Reply-To: <CABgObfYo3jR7b4ZkkuwKWbon-xAAn+Lvfux7ifQUXpDWJds1hg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240518000430.1118488-1-seanjc@google.com> <20240518000430.1118488-10-seanjc@google.com>
 <CABgObfYo3jR7b4ZkkuwKWbon-xAAn+Lvfux7ifQUXpDWJds1hg@mail.gmail.com>
Message-ID: <ZkzldN0SwEhstwEB@google.com>
Subject: Re: [PATCH 9/9] KVM: x86: Disable KVM_INTEL_PROVE_VE by default
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 21, 2024, Paolo Bonzini wrote:
> On Sat, May 18, 2024 at 2:04=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > Disable KVM's "prove #VE" support by default, as it provides no functio=
nal
> > value, and even its sanity checking benefits are relatively limited.  I=
.e.
> > it should be fully opt-in even on debug kernels, especially since EPT
> > Violation #VE suppression appears to be buggy on some CPUs.
>=20
> More #VE trapping than #VE suppression.
>
> I wouldn't go so far as making it *depend* on DEBUG_KERNEL.  EXPERT
> plus the scary help message is good enough.

Works for me.

>=20
> What about this:
>=20
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index b6831e17ec31..2864608c7016 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -97,14 +97,15 @@ config KVM_INTEL
>=20
>  config KVM_INTEL_PROVE_VE
>          bool "Check that guests do not receive #VE exceptions"
> -        depends on KVM_INTEL && DEBUG_KERNEL && EXPERT
> +        depends on KVM_INTEL && EXPERT
>          help
>            Checks that KVM's page table management code will not incorrec=
tly
>            let guests receive a virtualization exception.  Virtualization
>            exceptions will be trapped by the hypervisor rather than injec=
ted
>            in the guest.
>=20
> -          This should never be enabled in a production environment.
> +          Note that #VE trapping appears to be buggy on some CPUs.

I see where you're coming from, but I don't think "trapping" is much better=
,
e.g. it suggests there's something broken with the interception of #VEs.  A=
h,
the entire help text is weird.

This?

config KVM_INTEL_PROVE_VE
        bool "Verify guests do not receive unexpected EPT Violation #VEs"
        depends on KVM_INTEL && EXPERT
        help
          Enable EPT Violation #VEs (when supported) for all VMs, to verify
	  that KVM's EPT management code will not incorrectly result in a #VE
	  (KVM is supposed to supress #VEs by default).  Unexpected #VEs will
	  be intercepted by KVM and will trigger a WARN, but are otherwise
	  transparent to the guest.
	 =20
	  Note, EPT Violation #VE support appears to be buggy on some CPUs.

          This should never be enabled in a production environment!

          If unsure, say N.

