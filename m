Return-Path: <kvm+bounces-62106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4988EC3789D
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 20:48:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F14F1A2085C
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 19:49:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADE56343D9C;
	Wed,  5 Nov 2025 19:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S3uIAEUN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D029333732
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 19:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762372110; cv=none; b=khM56/hrBB1ke/UfW5mS9tmtSWLSRKklkNLmW+GG3boxW3L2LEgPgaA7+QQXtaUb7Ooj+cdRrF/f54h4Uas0qt5+MoQSZAEgIj0wFu9B7B9rh8Xcv9D63yWR3BH9A3k7gaJ8DiOw8eFV/sB4TgxKXLHn1x4K3qNwUBOYxeKtoqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762372110; c=relaxed/simple;
	bh=dAO5idOu+0iMr3uG0QieOyCoPcFOP+lVtFZxQxmb9tY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WNp/+VOx+2OI4JCJWPZYMfwVuOd6ki4bauBhnC/FuLHmd5JkNCrOHSOtyV5lUpm6V4LBzGT0LM6VnOnFF1JijwAQp8qEWvlC620p8H3hCO+xxaa/y0BrqtRwNBqESQxOMsRLycaTLuLCsf9wkVG27+ppFyuMSjby8kLHwRbIm0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S3uIAEUN; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340c0604e3dso260342a91.2
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 11:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762372109; x=1762976909; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iJ9g9/MW3cPbq0Qsr27VqnUS6cxO+o/mZrZxaJIOOVA=;
        b=S3uIAEUNdGziBNiukfnqDUIReH2TN8StSKBGDZXH8olimytgpuv8k1zP+6ESqmPQlR
         oYhIld3FVLHcfAzeM2EzA//KxOEgSZ1Ma4zmdIDuIPks4u4doJhz0UEhluM577/VeF8B
         M9Vx3zCaWTGjKLpCc9hzVsHTjr6tyFbznyqz36mBFmG+C8KTkKvKdjdGDZGV3LEYQKfg
         npZnYAJk+AXgiIcQQsSrhXBhmg5SvQJjQ5A+a6vNhGDY7MySSKifTeDT/an4VjuTUyjB
         ewzMVV3hdokrx1/G2uu5j4H01mEok8G0zjdx9vvw8DYHIUqYzYiOLdl9DURqavZn1RaZ
         7Vow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762372109; x=1762976909;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iJ9g9/MW3cPbq0Qsr27VqnUS6cxO+o/mZrZxaJIOOVA=;
        b=F6RP1n6qknoHd1hdgpLJVwnG1UczhJDDaFJTCRWxqDydIeBMD4YLLBuCU+ZBSoCjz2
         ASh3Jqi0dTSr+RXRq7D44p3MFUokyxiHl8E3i5+DJ5xlfJn/ujcqKd2gQqebyPfJEXOj
         qDPVMMXLjLjnnxRQpesool//CS3A4Pnc1RL36DS6MYdFyuzSgBUpd4UbWQQj+77puzsO
         4eodlxLDvVhfJTs5Q3gnHcFXsne+2Xc+mJWBhxGMnxHumaGlpHGM8Vz/OGSmmbse1pju
         F1OEqkR2EOS5pwY6VA26ZW/Q4PYmkRmFjwsEyjycXlE5p3ENeMYzUjPRSwxLmKgq4SyJ
         njiw==
X-Forwarded-Encrypted: i=1; AJvYcCUPRuYPrw9pqDlfhwE4TDblIB4rKG9979VfpYSzOP132hYoZ2EODUmXcl/GRA0WDwR/4+I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyB3ClaxtEQ6z6lk0FD+YzyzyH7ba4nmlkwKmzCiNsQpXojKT5x
	XR60D+z1I76ARPpX/cWtWs46c/LE93cyKdcXFHSBOfxFzYO4v7tKK3jxDnxwkp8mrzmM7I1E+n3
	4hNQxpw==
X-Google-Smtp-Source: AGHT+IFe6pvHrJuZ17PMNc8VFi8y57k5Cq5xXs5oW0zvjPZB3dLuuy7A1imQb2zstjnYRJDeHHQO/gU4Smc=
X-Received: from pjxu7.prod.google.com ([2002:a17:90a:db47:b0:33e:34c2:1e17])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b41:b0:32e:7c34:70cf
 with SMTP id 98e67ed59e1d1-341a7005bfcmr5444226a91.36.1762372108792; Wed, 05
 Nov 2025 11:48:28 -0800 (PST)
Date: Wed, 5 Nov 2025 11:48:27 -0800
In-Reply-To: <20251024192918.3191141-4-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251024192918.3191141-1-yosry.ahmed@linux.dev> <20251024192918.3191141-4-yosry.ahmed@linux.dev>
Message-ID: <aQuqC6Nh4--OV0Je@google.com>
Subject: Re: [PATCH 3/3] KVM: nSVM: Avoid incorrect injection of SVM_EXIT_CR0_SEL_WRITE
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2025, Yosry Ahmed wrote:
> When emulating L2 instructions, svm_check_intercept() checks whether a
> write to CR0 should trigger a synthesized #VMEXIT with
> SVM_EXIT_CR0_SEL_WRITE. However, it does not check whether L1 enabled
> the intercept for SVM_EXIT_WRITE_CR0, which has higher priority
> according to the APM (24593=E2=80=94Rev.  3.42=E2=80=94March 2024, Table =
15-7):
>=20
>   When both selective and non-selective CR0-write
>   intercepts are active at the same time, the non-selective
>   intercept takes priority. With respect to exceptions, the
>   priority of this inter
>=20
> Make sure L1 does NOT intercept SVM_EXIT_WRITE_CR0 before checking if
> SVM_EXIT_CR0_SEL_WRITE needs to be injected.
>=20
> Fixes: cfec82cb7d31 ("KVM: SVM: Add intercept check for emulated cr acces=
ses")
> Cc: stable@vger.kernel
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/svm.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 9ea0ff136e299..4f79c4d837535 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4533,12 +4533,22 @@ static int svm_check_intercept(struct kvm_vcpu *v=
cpu,
>  		if (info->intercept =3D=3D x86_intercept_cr_write)
>  			icpt_info.exit_code +=3D info->modrm_reg;
> =20
> +		/*
> +		 * If the write is indeed to CR0, check whether the exit_code
> +		 * needs to be converted to SVM_EXIT_CR0_SEL_WRITE. Intercepting
> +		 * SVM_EXIT_WRITE_CR0 has higher priority than
> +		 * SVM_EXIT_CR0_SEL_WRITE, so this is only relevant if L1 sets
> +		 * INTERCEPT_SELECTIVE_CR0 but not INTERCEPT_CR0_WRITE.
> +		 */
>  		if (icpt_info.exit_code !=3D SVM_EXIT_WRITE_CR0 ||

Oof, the existing is all kinds of confusing.  Even with your comment, it to=
ok me
a few seconds to understand how/where the exit_code is being modified.  Eww=
.

Any objection to opportunistically fixing this up to the (completely untest=
ed)
below when applying?

		/*
		 * Adjust the exit code accordingly if a CR other than CR0 is
		 * being written, and skip straight to the common handling as
		 * only CR0 has an additional selective intercept.
		 */
		if (info->intercept =3D=3D x86_intercept_cr_write && info->modrm_reg) {
			icpt_info.exit_code +=3D info->modrm_reg;
			break;
		}

		/*
		 * Convert the exit_code to SVM_EXIT_CR0_SEL_WRITE if L1 set
		 * INTERCEPT_SELECTIVE_CR0 but not INTERCEPT_CR0_WRITE, as the
		 * unconditional intercept has higher priority.
		 */
		if (vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_CR0_WRITE) ||
		    !(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_SELECTIVE_CR0)))
			break;


> -		    info->intercept =3D=3D x86_intercept_clts)
> +		    vmcb12_is_intercept(&svm->nested.ctl,
> +					INTERCEPT_CR0_WRITE) ||
> +		    !(vmcb12_is_intercept(&svm->nested.ctl,
> +					  INTERCEPT_SELECTIVE_CR0)))

Let these poke out.

>  			break;
> =20
> -		if (!(vmcb12_is_intercept(&svm->nested.ctl,
> -					INTERCEPT_SELECTIVE_CR0)))
> +		/* CLTS never triggers INTERCEPT_SELECTIVE_CR0 */
> +		if (info->intercept =3D=3D x86_intercept_clts)
>  			break;
> =20
>  		/* LMSW always triggers INTERCEPT_SELECTIVE_CR0 */
> --=20
> 2.51.1.821.gb6fe4d2222-goog
>=20

