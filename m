Return-Path: <kvm+bounces-27640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 70F1C988A67
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 20:52:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C0081F2453D
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 18:52:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D71631C231A;
	Fri, 27 Sep 2024 18:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pdYENyEG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A591E1C1AD3
	for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 18:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727463138; cv=none; b=Tbw5t2e2EARLxIi4yhFzQ6oXhh0NSefAzH4JWG32kf9XQNwbNr/ty7YG/dv7t7WuQk1VWatIFKIj2v/BGdm/tP8j84kQkJMVS4DecCPoRAI1bV1bD5fMLWz+Q5ST/50ZRXCUvz2EO0ktJtBhXhQMqp2TR34IerEGOCw8TkxzF2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727463138; c=relaxed/simple;
	bh=IzWjw7eN0y01PVEFCALDoih+toQy5a+BhLNxBF2j7ms=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=IdveObseHgBwuOUKJ1j1G0L4+nNOujjyvTKiLdajwwj7uJHVO8BlHd561g/+QestSq+18v8G0odNLNPzQ1+RLhLiL8JiYcmTVE2DRzqpNAudbX8HAsKRRQIvg8vOKZ0at3PvF5IUJWT3EglC7tD15hsRtqJzjJuynKIbxhcm0zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pdYENyEG; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3a0cb892c6aso37765ab.0
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 11:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727463136; x=1728067936; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1oLFkKO1VpfbWh8RAovo3jp9IKk3ALZrZVKd9HwvoaM=;
        b=pdYENyEG3AWrqQC4lHurdQQGECdq6Fyf1bwFX7HUzwCLNzQu9NlKm7zELR0kJLOidy
         wpgG1x1ji/PgB6BdTSV7uGZQQa3NzgSoQuBdtIDgEZt0m07IlAZG6bHaGQ7aIqeV7Nem
         F7h1jd2pKmOjX5G3f5WNsFj6OaXAdsUGhslUMXQ/jVCKRLz/sm9PW6+T8jalbHGESCXO
         lkLftwkCtV9K0JeNhzdRGG42Q0f/ADOOriN0c6rIRpn6UwUOKvED2TqRfEMNyYd0pncl
         VNQlPq3wewAu+2uQkMifP42739HVYHXaSVRePwzRAJdWMZUhqXnCdlMFzIpXz0dgJ92n
         nF0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727463136; x=1728067936;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1oLFkKO1VpfbWh8RAovo3jp9IKk3ALZrZVKd9HwvoaM=;
        b=BZteLIHDsuID6i8nVZbsPk0/op4QE8JkkcWQB+leskegRCNSPpkYwTbNuGTOITaqMh
         3ytozY0DlexEvD2HjALEUNI5IDvetzZKrOiFbznW75zeIPCBEZYiI2uEppv8ZKIPNcT9
         zZoklVudPOrMLtVBpa6IJfVGvNGxMGDLZX8cBxV5oLi34uAT/wdrrIJhtbmOZ/+7JoJs
         b5ktqwgRMjnDGESh/tuT1dbQnOmdCBkFjhAOqqaqg8bZxjY8htVhMeli6P9viGNL8kqt
         J2L9OVMcwh5sPv+rhqbE7vmzMv/SHQWvCs5NMIrH8ZlwOh0i5tCgqyu07+p70k7nPokn
         FFyA==
X-Forwarded-Encrypted: i=1; AJvYcCV7tkagIXAyEHQMY+Lozc+FOOjVFZ1aUBtx1ydi/YR+KhJ+B32ywhvYl440GRgEwbWMLW8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrkCnphcTgpyYcXI12y9eUcIfBrWrrXivkSxD3th0ptyC2KV7s
	EGTfnNDRKc7YBjOJrq16dpgT+f4kt7HNAHUWSKP0IcSeqQzxc0dLTWdo9MoKETjMNzgtq8MPU+A
	eVBarHyp85Mt8SN3sFZFcqDbchDq8aNK/iRqP
X-Google-Smtp-Source: AGHT+IHsljO1XOSs8sBOur4Zv2fgb8b4s3bUfld8PGFucwZxQKtVXzovLlISUT9gEFG9kNJu45XDphWC853dVxqtTwg=
X-Received: by 2002:a92:cd8b:0:b0:39e:68d8:2891 with SMTP id
 e9e14a558f8ab-3a34bc236c6mr444995ab.6.1727463135626; Fri, 27 Sep 2024
 11:52:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240913173242.3271406-1-jmattson@google.com>
In-Reply-To: <20240913173242.3271406-1-jmattson@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 27 Sep 2024 11:52:03 -0700
Message-ID: <CALMp9eSd49O_J=hJKdE0QAcYFY1N1cxG1rKDJH-GUZL7i_VJig@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] Distinguish between variants of IBPB
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jim Mattson <jmattson@google.com>, Sandipan Das <sandipan.das@amd.com>, 
	Kai Huang <kai.huang@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 13, 2024 at 10:32=E2=80=AFAM Jim Mattson <jmattson@google.com> =
wrote:
>
> Prior to Zen4, AMD's IBPB did not flush the RAS (or, in Intel
> terminology, the RSB). Hence, the older version of AMD's IBPB was not
> equivalent to Intel's IBPB. However, KVM has been treating them as
> equivalent, synthesizing Intel's CPUID.(EAX=3D7,ECX=3D0):EDX[bit 26] on a=
ny
> platform that supports the synthetic features X86_FEATURE_IBPB and
> X86_FEATURE_IBRS.
>
> Equivalence also requires a previously ignored feature on the AMD side,
> CPUID Fn8000_0008_EBX[IBPB_RET], which is enumerated on Zen4.
>
> v4: Added "guaranteed" to X86_FEATURE_IBPB comment [Pawan]
>     Changed logic for deducing AMD IBPB features from Intel IBPB features
>     in kvm_set_cpu_caps [Tom]
>     Intel CPUs that suffer from PBRSB can't claim AMD_IBPB_RET [myself]
>
> v3: Pass through IBPB_RET from hardware to userspace. [Tom]
>     Derive AMD_IBPB from X86_FEATURE_SPEC_CTRL rather than
>     X86_FEATURE_IBPB. [Tom]
>     Clarify semantics of X86_FEATURE_IBPB.
>
> v2: Use IBPB_RET to identify semantic equality. [Venkatesh]
>
> Jim Mattson (3):
>   x86/cpufeatures: Define X86_FEATURE_AMD_IBPB_RET
>   KVM: x86: Advertise AMD_IBPB_RET to userspace
>   KVM: x86: AMD's IBPB is not equivalent to Intel's IBPB

Oops. I forgot to include the v3 responses:

> For the series:
>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

and

> Assuming this goes through the KVM tree:
>
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

The only substantive change was to patch 3/3.

Sean: Are you willing to take this through KVM/x86?

