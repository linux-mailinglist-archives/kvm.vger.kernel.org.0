Return-Path: <kvm+bounces-33876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D4BA29F3A6A
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 21:05:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CAD816A783
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 20:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32AA71D0E26;
	Mon, 16 Dec 2024 20:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vXQh/NVl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AFC51C5A
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 20:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734379493; cv=none; b=CR2gTyRKv0gzE5ysjJHNSg+QR6IEfXyoE+fQ+T0sW3R87W9qSsCtgLZvVFfSv70wuz3QkSr7dgvMUm3dkCftHnhXBpaIxeJZW16vkwSEu6IIHrripPFUxROURJsgWyZdMA/IKMUY/04ZUvS4kLfBIa5UIXu7cmR80GS8x2kHH6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734379493; c=relaxed/simple;
	bh=/5ZIMWJqbiQGKSssgkI1chR7dUUmhZA6/QOZ/9gvO14=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bl1QzTmo/uj62WAVslZf+PIh5Wv0S+XcvgNZPKyFv1gtOxeg3bHQehu0Ea5Nv5P/LCZ6Z0z17v5A+HV+0cY9poTZKDGLlinTaKbPONyCUFyy3c6Vfy04T8Os9eTouvM9iYQ+fCAJGcjb9TLZuUD9HYaUXiR5NiY2bGqUcyevqM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vXQh/NVl; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4679b5c66d0so42361cf.1
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 12:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734379490; x=1734984290; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xexP53Lx7tUORX67wL7XY75PZF0aHX6WFTVho6quOos=;
        b=vXQh/NVlNU4OvYez3VOq0Lw/fBLpoKVUD4rCcB3Rn2sbXUaaYHIMy6t/KUSoDCD32M
         90NXZbm8AJ+Eq/2eF8w3uzUVoOLWyvZm8PlS1TOu25O2CmX49CxRKQKgZ3SMVXY60j+J
         93eQGwN4ClNWlWTXCcHJzb4YPVpX4cxntNRNpYc8FmcpJVnqXy/nO0MDlPgmbYFAS1nC
         GmJ032YqQYF2wnUqYZcFWz0/58oraeUHxCZVz0ptKDsmiVFHW3xxJIQQp0Qwhz9XaUZX
         u3elAZSfJrLeZvMLubAI0jEqT6tPo0kyUO2znKPYWUJ8ghYjkBgqMqLUqkeq8GnSbeuN
         /Mww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734379490; x=1734984290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xexP53Lx7tUORX67wL7XY75PZF0aHX6WFTVho6quOos=;
        b=lBEUstoq40sCoXJbRSYPD/ilJwSACE7cFbgpOIBaAcBdajXzxXZh4m6pmWn8E687eP
         rcfe040K+ll4VP0Jxr7QpJnzLOo3g9/7OxuneOEWeKFW5qXcRBc+TpIvL68SD1lRnq7X
         aPHht/B2Z98XB/mMW/fFtV9Y40QD8+tPcZVCj6UnQILfD0GstU0bQ7ZnfW2T/9Bm8nHi
         ky9Xvnu0WQi+wsGz/r8AVrzhF6Z56GKQZfJFO4C2+z6+/1+/JRw6cfaiZR4+aD9cAQnJ
         CzT+smUI4YZ9jRkcae1EJcZEvuUkfPwFSYdujXaDAFL6y0QgpM6y8Qm2eWQY95qxgRTo
         bI+w==
X-Forwarded-Encrypted: i=1; AJvYcCU+hIHy72RrUHN51ZU9EAylbbUg5KS1BpFEAC3i2Ec7pXDGHlC7RQuAa9rwtgSrwgRyJVQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJoXIZw+LAnewxLkcS+hM8H6J8XNajBycgDWkIjsr6O3w11GEE
	63YQiWzegTw24K8FiCozBQMQogBKsFcJ8JLwUFIrwLavozCMTMxJ7oGrLd64wBtLmCRhK8tb1GI
	h4ZC+TMovAsyIv3W//IOnvqmdTB2tMfHsykwU
X-Gm-Gg: ASbGncuqoFzjR1XZ/kPT/TH4V1mflMrr/bdoTkHJGxu/5UsbDcjEvmwudLvJfTKw+o1
	4Q2lsFguO6H1BEIYVAlR0dxJ+Srb8pBSYrTfZ
X-Google-Smtp-Source: AGHT+IFXDBt/j1JROjzWset6I1rAZRjVktzvmNLlqSdxVj7Lr0GyCEGur4tk3TBmNyasuCEi2g+JnqclC9EkYDDtKyg=
X-Received: by 2002:a05:622a:1312:b0:466:7926:c69 with SMTP id
 d75a77b69052e-468f979b7ddmr409811cf.20.1734379489466; Mon, 16 Dec 2024
 12:04:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241211013302.1347853-1-seanjc@google.com>
In-Reply-To: <20241211013302.1347853-1-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 16 Dec 2024 12:04:28 -0800
Message-ID: <CALMp9eQaqYG4F6f9gm0_a9v+6A_1jXBxX5Wy3J-pDBk8iar1YA@mail.gmail.com>
Subject: Re: [PATCH 0/5] KVM: x86: Address xstate_required_size() perf regression
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10, 2024 at 5:33=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Fix a hilarious/revolting performance regression (relative to older CPU
> generations) in xstate_required_size() that pops up due to CPUID _in the
> host_ taking 3x-4x longer on Emerald Rapids than Skylake.
>
> The issue rears its head on nested virtualization transitions, as KVM
> (unnecessarily) performs runtime CPUID updates, including XSAVE sizes,
> multiple times per transition.  And calculating XSAVE sizes, especially
> for vCPUs with a decent number of supported XSAVE features and compacted
> format support, can add up to thousands of cycles.
>
> To fix the immediate issue, cache the CPUID output at kvm.ko load.  The
> information is static for a given CPU, i.e. doesn't need to be re-read
> from hardware every time.  That's patch 1, and eliminates pretty much all
> of the meaningful overhead.
>
> Patch 2 is a minor cleanup to try and make the code easier to read.
>
> Patch 3 fixes a wart in CPUID emulation where KVM does a moderately
> expensive (though cheap compared to CPUID, lol) MSR lookup that is likely
> unnecessary for the vast majority of VMs.
>
> Patches 4 and 5 address the problem of KVM doing runtime CPUID updates
> multiple times for each nested VM-Enter and VM-Exit, at least half of
> which are completely unnecessary (CPUID is a mandatory intercept on both
> Intel and AMD, so ensuring dynamic CPUID bits are up-to-date while runnin=
g
> L2 is pointless).  The idea is fairly simple: lazily do the CPUID updates
> by deferring them until something might actually consume guest the releva=
nt
> bits.
>
> This applies on the cpu_caps overhaul[*], as patches 3-5 would otherwise
> conflict, and I didn't want to think about how safe patch 5 is without
> the rework.
>
> That said, patch 1, which is the most important and tagged for stable,
> applies cleanly on 6.1, 6.6, and 6.12 (and the backport for 5.15 and
> earlier shouldn't be too horrific).
>
> Side topic, I can't help but wonder if the CPUID latency on EMR is a CPU
> or ucode bug.  For a number of leaves, KVM can emulate CPUID faster than
> the CPUID can execute the instruction.  I.e. the entire VM-Exit =3D> emul=
ate
> =3D> VM-Enter sequence takes less time than executing CPUID on bare metal=
.
> Which seems absolutely insane.  But, it shouldn't impact guest performanc=
e,
> so that's someone else's problem, at least for now.

Virtualization aside, perhaps Linux should set
MSR_FEATURE_ENABLES.CPUID_GP_ON_CPL_GT_0[bit 0] on EMR, and emulate
the CPUID instruction in the kernel?  :)

> [*] https://lore.kernel.org/all/20241128013424.4096668-1-seanjc@google.co=
m
>
> Sean Christopherson (5):
>   KVM: x86: Cache CPUID.0xD XSTATE offsets+sizes during module init
>   KVM: x86: Use for-loop to iterate over XSTATE size entries
>   KVM: x86: Apply TSX_CTRL_CPUID_CLEAR if and only if the vCPU has RTM
>     or HLE
>   KVM: x86: Query X86_FEATURE_MWAIT iff userspace owns the CPUID feature
>     bit
>   KVM: x86: Defer runtime updates of dynamic CPUID bits until CPUID
>     emulation
>
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/cpuid.c            | 63 ++++++++++++++++++++++++---------
>  arch/x86/kvm/cpuid.h            | 10 +++++-
>  arch/x86/kvm/lapic.c            |  2 +-
>  arch/x86/kvm/smm.c              |  2 +-
>  arch/x86/kvm/svm/sev.c          |  2 +-
>  arch/x86/kvm/svm/svm.c          |  2 +-
>  arch/x86/kvm/vmx/vmx.c          |  2 +-
>  arch/x86/kvm/x86.c              | 22 +++++++++---
>  9 files changed, 78 insertions(+), 28 deletions(-)
>
>
> base-commit: 06a4919e729761be751366716c00fb8c3f51d37e
> --
> 2.47.0.338.g60cca15819-goog
>

