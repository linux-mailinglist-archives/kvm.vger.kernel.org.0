Return-Path: <kvm+bounces-27690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 231D398A94D
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 18:05:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D79BB245EE
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 16:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF8D6193071;
	Mon, 30 Sep 2024 16:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GQalLAEl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B1E192D68
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 16:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727712266; cv=none; b=sBZHt4yBQrzI6F+BjRtkIc0gXlQmOjPxBxCYXPJxV3K6rV5haUkCceyr13hJ8LE+crzjgQXNqhTqoAX3mMaaryD63TOnj+mmW74zV7mxZIDTrf89k5sNvDF9DxPgzgTBF2iIYmNzNhzYufTsCZJ/Bs4d0RIzoQFR4GaU/hdfCmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727712266; c=relaxed/simple;
	bh=dVOtEFflHz9cQq8g/90blsyTaVAoQK/Ef0RTO5W+Q7g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gJpcel1J70lngXaYe/gaxTSbMnB8WpSb3kNrvO+2JtoSEo620eqRzECj86p26lsHxeNB8ArlePfV+Qg5vdkL+oa9YBqq54TzUbobe15OV7z5bsEXmGYr6EXwmWEASVNfBaUuyc2FqRKSXLSM81/rAK+LJATN7xD+us9i3lZBTKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GQalLAEl; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e20937a68bso80159847b3.3
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 09:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727712264; x=1728317064; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DZOI0ZtiEf+KO3gdJcLblXQ+4fi4rP+GU4jZn3dbVFs=;
        b=GQalLAEldx9pj+j8mhLxdOhVQPM+QCGxrzakjHRKl+kGYceQNnenZc1Ldt/oRJH2c3
         jTz1SAV+oBN9imosynXNwkK0H7VqYMvHPkKruhSVESh87v42qLj3pmL57Wa/DDG2C2oz
         4XWhYrrQj3/h6XsbGUqFo/sZsLUsFPxwQB4GAHtZlS61Uth/JiRURKB8wECGj4SJiGU8
         MYywE5wS6AvJT/vaNm5j/HFSljiVKHhouF6IfOkKPbn74cLdWCV2DX6YiGtXr1cWCWxv
         26JB1IzYoKtImmZmMym0YHOk/3U75EqVBtvBjXGyeTMQ6/QPwMe/KeAGf4lKw+fOhnfr
         4Mvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727712264; x=1728317064;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DZOI0ZtiEf+KO3gdJcLblXQ+4fi4rP+GU4jZn3dbVFs=;
        b=RIZOwWD6WFjMRLzY9NmX2+hDGQAS3tDWfjltB49Op7+Oac7aqepkwPxj0qFfIY+4zL
         49EO9Tnts82/PN2KBZ6LJ8IDQ1VG16cXLI50pKk9G1vycIMoi1POgzm+djXoASCmYt2e
         OxkKWy4odYbYUWSVwf7C7L9dWYrbeMCAAsq389SGPJZcFxoKeMWKmTA582gVZOCY/79b
         wY+YZo1q414DxxkJm0DArOLOzbmmj50J+f3TtwAWReJGd9GVyr5frlEHMqN/ExRiO7lE
         ygmvAbek+n1HFTLPUD7CBAyQnd7lmiWo/1oZ3WV7AHTI64jtpSibmYBF/+yrpE4SFsF0
         O/7w==
X-Forwarded-Encrypted: i=1; AJvYcCWyCSO2LJPxRjiuOqAbf11RCUPd0dT478eSjhZUe5KqFUHyAqZjADRUwAvL6QVVej9+NrI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXWPTINSMlDuFy85iiS0VA/7dBT5wVxm7op18Z+LT4ocS2WgHE
	/mY0lEmzPQJAuQ9gK0lpTJagbBZF+r3UIN44nyP1uE8PXfu1Fe0yPzIhZ0eYwOfqBKxA5koEyVs
	MMA==
X-Google-Smtp-Source: AGHT+IFUb4pS11OWBjXuobxc0ron+yQSC6Q9zzmSWv8uoCzJridNyycF3g5Ujfe/0Nu39VcVWYmxIH4oe+8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:e344:0:b0:62f:1f63:ae4f with SMTP id
 00721157ae682-6e2474bd2b7mr1154347b3.1.1727712264357; Mon, 30 Sep 2024
 09:04:24 -0700 (PDT)
Date: Mon, 30 Sep 2024 09:04:22 -0700
In-Reply-To: <20240930055035.31412-1-suravee.suthikulpanit@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240930055035.31412-1-suravee.suthikulpanit@amd.com>
Message-ID: <ZvrMBs-eScleFMOT@google.com>
Subject: Re: [PATCH] KVM: SVM: Disable AVIC on SNP-enabled system without
 HvInUseWrAllowed feature
From: Sean Christopherson <seanjc@google.com>
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com, 
	david.kaplan@amd.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2024, Suravee Suthikulpanit wrote:
> On SNP-enabled system, VMRUN marks AVIC Backing Page as in-use while
> the guest is running for both secure and non-secure guest. This causes
> any attempts to modify the RMP entries for the backing page to result in
> FAIL_INUSE response. This is to ensure that the AVIC backing page is not
> maliciously assigned to an SNP guest while the unencrypted guest is activ=
e.
>=20
> Currently, an attempt to run AVIC guest would result in the following err=
or:
>=20
>     BUG: unable to handle page fault for address: ff3a442e549cc270
>     #PF: supervisor write access in kernel mode
>     #PF: error_code(0x80000003) - RMP violation
>     PGD b6ee01067 P4D b6ee02067 PUD 10096d063 PMD 11c540063 PTE 800000011=
49cc163
>     SEV-SNP: PFN 0x1149cc unassigned, dumping non-zero entries in 2M PFN =
region: [0x114800 - 0x114a00]
>     ...

This should be "fixed" by commit 75253db41a46 ("KVM: SEV: Make AVIC backing=
, VMSA
and VMCB memory allocation SNP safe"), no?

> Newer AMD system is enhanced to allow hypervisor to modify RMP entries of
> the backing page for non-secure guest on SNP-enabled system. This
> enhancement is available when the CPUID Fn8000_001F_EAX bit 30 is set
> (HvInUseWrAllowed) See the AMD64 Architecture Programmer=E2=80=99s Manual=
 (APM)
> Volume 2 for detail. (https://www.amd.com/content/dam/amd/en/documents/
> processor-tech-docs/programmer-references/40332.pdf)
>=20
> Therefore, add logic to check the new CPUID bit before enabling AVIC
> on SNP-enabled system.
>=20
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/kvm/svm/avic.c            | 6 ++++++
>  2 files changed, 7 insertions(+)
>=20
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cp=
ufeatures.h
> index dd4682857c12..921b6de80e24 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -448,6 +448,7 @@
>  #define X86_FEATURE_SME_COHERENT	(19*32+10) /* AMD hardware-enforced cac=
he coherency */
>  #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" AMD SEV-ES fu=
ll debug state swap support */
>  #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
> +#define X86_FEATURE_HV_INUSE_WR_ALLOWED	(19*32+30) /* Write to in-use hy=
pervisor-owned pages allowed */
> =20
>  /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), wor=
d 20 */
>  #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* No Nested Data Break=
points */
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 4b74ea91f4e6..42f2caf17d6a 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -1199,6 +1199,12 @@ bool avic_hardware_setup(void)
>  		return false;
>  	}
> =20
> +	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP) &&
> +	    !boot_cpu_has(X86_FEATURE_HV_INUSE_WR_ALLOWED)) {
> +		pr_warn("AVIC disabled: missing HvInUseWrAllowed on SNP-enabled system=
");
> +		return false;
> +	}
> +
>  	if (boot_cpu_has(X86_FEATURE_AVIC)) {
>  		pr_info("AVIC enabled\n");
>  	} else if (force_avic) {
> --=20
> 2.34.1
>=20

