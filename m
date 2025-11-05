Return-Path: <kvm+bounces-62097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 860B7C375F5
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 19:48:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 11D241A21B92
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 18:49:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1B902BFC60;
	Wed,  5 Nov 2025 18:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mmPfOgXS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C72A2836A0
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 18:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762368511; cv=none; b=lJH42JITNb5iIm2epQzmUwcQEpgDnlmUV4VSoV5Snp7BY1LM4oat0ZYMrAstxBGAph1dc11XUAOOcVHdZxXV6o3TL5ALjX5M1n244EJLu/v1EKnoFBzM9QMDT6eaujbDB3/dwDAogC/EWVzBqq1+ojeOMQFIf/UYhqsNhkTLWeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762368511; c=relaxed/simple;
	bh=6VX/MaVGYB8nnDcW+9XMWl4yI03AMMC4TwfOr1Tb1bU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EPZhW+dPN0A6STKDdHnW2zsxEut6ZfW0u79bP1C/V9vaTLb09QaOU539kl77lYs6w7lnPXD/Si5S9DZrpIwe/9vsi3r8sOm/Z2DZqmbgmpMZ4RiM2jsFncJFa5MoI0HMqVc96LTvHZRt9cKhW3hmOfhMbPGMzUZ/oTz0K/02cG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mmPfOgXS; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2956510d04cso1806085ad.3
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 10:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762368510; x=1762973310; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uwldtlJsW8UutEA5JzxFh14mKn4uh9aSlx+yupLBCtg=;
        b=mmPfOgXSi+CKRuqTpqKQwQIhMjo5ZiwafiHeahLMvTOfevN+4WK9pMuh7XQ7xdxusk
         +/82y0yU9DfGTWEhP3lF69f3bKAclHaxmogFGqtTxWGsqyHF/EtlXcA3qVJ0BA4pO606
         xDsEAZDozSpqumzaDFDKPG+3OxVm0p8yB/AagLzzeT6Q0KDKiMg2d1Bt3jP1QD4l//Qs
         HR19ZAN0nnr4wJaD7UzIddQjrwFPGfklbvYHUklHlUQiTfpis2lj1oo0VRmOBTyU14hc
         2BBYJdmFL4gcvGApzet7FJrHO8Kp/aL4b5aGmdKInRehRedAbogwbNLy9uWtIpz9ZyMA
         MmWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762368510; x=1762973310;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uwldtlJsW8UutEA5JzxFh14mKn4uh9aSlx+yupLBCtg=;
        b=TfPXRrvsVckzLJHUbL/w1hRJ8qkYBagbSC5DKjjFcoXb1o/vbDdHReFQUEEPtAJf/Y
         Eyod8we0f0oZSJoi/rNuiH2e0y9TVLrY4Jw7bFTquDgQClp0v59MYoCnniu/2k2EqdRQ
         SwgcDoEskexxRjV05tQM5n7c+mCzbL/3A/h6iRmUBAiKc7hZtPpOSXA63BNuzOWEzxf6
         NGV3EwijaqPK10I0ETg6/Z8oG/SMYJkryb0M/t5fWw9+ssaZlzJoT7GkACRI3JL5EYJ6
         BFA9Wj/6QU8SDbHoAyMK4khpirxnPW2ahLb/z3Cz0t7SXznCnN2lO1xNz2T59flMgWc3
         tJFA==
X-Forwarded-Encrypted: i=1; AJvYcCUhTIzHkNJXVvV70a4+RoPOOEtpMuf8JuyQZL/BXfl1AMi0nvQEB+nC1vy+eBRW6Le04ug=@vger.kernel.org
X-Gm-Message-State: AOJu0YzL0BaL/To3zfgEEGqSXltiC5uZ1NoSyd0CZHAV9heJO0cKSIPs
	2fanbyvXGoBeXc5NsXlDPK353aN7aV6vgRhhHvOdo36Am5IlEJwuNS0M43nyRwjChBxvL6o2TnY
	CdtAlAA==
X-Google-Smtp-Source: AGHT+IFLaNnoj3qggxHJas4K5ftn8LNDGyunMGhaWQS5bBqsth8bncL9oJPd1LFrTN+cPLAJBX0FF/cK8TA=
X-Received: from plbku7.prod.google.com ([2002:a17:903:2887:b0:24c:966a:4a6b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e88b:b0:295:5138:10f9
 with SMTP id d9443c01a7336-2962ae9408bmr60414175ad.54.1762368509678; Wed, 05
 Nov 2025 10:48:29 -0800 (PST)
Date: Wed, 5 Nov 2025 10:48:28 -0800
In-Reply-To: <20251104195949.3528411-4-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251104195949.3528411-1-yosry.ahmed@linux.dev> <20251104195949.3528411-4-yosry.ahmed@linux.dev>
Message-ID: <aQub_AbP6l6BJlB2@google.com>
Subject: Re: [PATCH 03/11] KVM: nSVM: Add missing consistency check for event_inj
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 04, 2025, Yosry Ahmed wrote:
> According to the APM Volume #2, 15.20 (24593=E2=80=94Rev. 3.42=E2=80=94Ma=
rch 2024):
>=20
>   VMRUN exits with VMEXIT_INVALID error code if either:
>   =E2=80=A2 Reserved values of TYPE have been specified, or
>   =E2=80=A2 TYPE =3D 3 (exception) has been specified with a vector that =
does not
>     correspond to an exception (this includes vector 2, which is an NMI,
>     not an exception).
>=20
> Add the missing consistency checks to KVM. For the second point, inject
> VMEXIT_INVALID if the vector is anything but the vectors defined by the
> APM for exceptions. Reserved vectors are also considered invalid, which
> matches the HW behavior.

Ugh.  Strictly speaking, that means KVM needs to match the capabilities of =
the
virtual CPU.  E.g. if the virtual CPU predates SEV-ES, then #VC should be r=
eserved
from the guest's perspective.

> Vector 9 (i.e. #CSO) is considered invalid because it is reserved on mode=
rn
> CPUs, and according to LLMs no CPUs exist supporting SVM and producing #C=
SOs.
>=20
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/include/asm/svm.h |  5 +++++
>  arch/x86/kvm/svm/nested.c  | 33 +++++++++++++++++++++++++++++++++
>  2 files changed, 38 insertions(+)
>=20
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index e69b6d0dedcf0..3a9441a8954f3 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -633,6 +633,11 @@ static inline void __unused_size_checks(void)
>  #define SVM_EVTINJ_VALID (1 << 31)
>  #define SVM_EVTINJ_VALID_ERR (1 << 11)
> =20
> +/* Only valid exceptions (and not NMIs) are allowed for SVM_EVTINJ_TYPE_=
EXEPT */
> +#define SVM_EVNTINJ_INVALID_EXEPTS (NMI_VECTOR | BIT_ULL(9) | BIT_ULL(15=
) | \
> +				    BIT_ULL(20) | GENMASK_ULL(27, 22) | \
> +				    BIT_ULL(31))

As above, hardcoding this won't work.  E.g. if a VM is migrated from a CPU =
where
vector X is reserved to a CPU where vector X is valid, then the VM will obs=
erve
a change in behavior.=20

Even if we're ok being overly permissive today (e.g. by taking an erratum),=
 this
will create problems in the future when one of the reserved vectors is defi=
ned,
at which point we'll end up changing guest-visible behavior (and will have =
to
take another erratum, or maybe define the erratum to be that KVM straight u=
p
doesn't enforce this correctly?)

And if we do throw in the towel and don't try to enforce this, we'll still =
want
a safeguard against this becoming stale, e.g. when KVM adds support for new
feature XYZ that comes with a new vector.

Off the cuff, the best idea I have is to define the positive set of vectors
somewhere common with a static assert, and then invert that.  E.g. maybe so=
mething
shared with kvm_trace_sym_exc()?

