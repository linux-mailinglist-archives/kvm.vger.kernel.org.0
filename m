Return-Path: <kvm+bounces-52452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 582B5B0548C
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 10:17:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6BD61AA2549
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 08:18:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F39B72741D4;
	Tue, 15 Jul 2025 08:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wze5KBOR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C931DED5F;
	Tue, 15 Jul 2025 08:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752567455; cv=none; b=a+9ls89xMb9BIjlE5S6QVqB9Kia6DdYSN/ndgBMJlfs0xvr7wU78sJItivMWuxbZk/xlvXkAfFSJKdKlUSsKZZhdlDss01Yo+IQpn7S84VSdtA0wMP+AqS1Z37PPUNueAG6jm5A9fp2Tv3dWmCeFp7diGS8aFwfGkgPcBDip69s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752567455; c=relaxed/simple;
	bh=B2i2mE7/q8o00PDlL5rVCsg5r6ROQYQBRQfO4c99+/8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G6Y4d1dFYUBt1NfQWbRWZNzAoS1wk+AKAlFAuISZTJPafDHolYa8hkNrOvjoOaS/KNZRNeGiYHkctVK2ytHom1QlN2qOGicpFwwkcRBi2xCuzkofvQfkCgp/pDIqxK1QvFffM5Mn9Dc8AK/OAGkszzGnISCCxTskRkYWUQX8luA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wze5KBOR; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b350704f506so4043647a12.0;
        Tue, 15 Jul 2025 01:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752567453; x=1753172253; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cIDPXywsEVB5HcRcVHQgnm1zzAlxNSarDIxQPMMSz4Y=;
        b=Wze5KBOR6X9NnbMy2ltMiTof1/RaLxLpn18NwGRffDZVW9J3HQTp22xhIOBQkYeSBI
         +VD5NYMI9hGVp7ImXxI9HgQImsqrA7nTmR76PpHGkgQF6cl6lCPYXT+Hf2UR9vT42pCa
         hToDyNTnnH2x7eFiYGIo24m+jFEiefOxWJcbAZfPlub1jkBpKoDr0IbQjr8zLumTknED
         zEJtFNzue1VPWTUxkN31eqpUsyG6G0mFL70bh5KCeHm35nFPYJiJFrFHMnIJb+/dhsRG
         8q/XM1Lf4Wk4KoHE7Iau91c+o3YZR2/CxFnJ4xvtVxTBnxnsSypwjG8rY4Q6S4jhtTQT
         YC1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752567453; x=1753172253;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cIDPXywsEVB5HcRcVHQgnm1zzAlxNSarDIxQPMMSz4Y=;
        b=qzlxQACF4ku+ifvZVXtZp3CYORh/Sg/0F8QXyi0qYXICTJ3ihm99jBtDcX5Nj1v3zt
         oedV2bWWIZTcN7qMH8cJCkWw45gNIB+MlpeKaN0xi/LBZC8dxynqoXon1iFJ8tsR8TtO
         prBD1bYSMsDHFEOhQNQgXEEeePIovvk3oCd8RYYSiFvp1ooaqhJ987X0njA++4UGWTF+
         jvACRulN8iPkJpxxb9bFEfmWvPqp5Cg/lsxnL1JHsRn/Q6DBwlEdFgkeLbt+5seSdvM4
         TrfB0SsCURiqzP0hMZQVClMdScui4yjIUmEmkfD5mb1HqEV3guKtbalfGHjKXE+EMYcC
         ZqHg==
X-Forwarded-Encrypted: i=1; AJvYcCUvyLs5iJugD88aTOxBkdUcgNoSoY1fuAihH40gp+KbKxsiSu5iCdKQxsykbBXw+HDDmK4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxD+7fZ04Gwzl0kcxI6Q6Zl5dGTLRt72fSmXX3XyMLO8CUkXzh4
	XCu7y51IFbmNVfQgLaKSiQX03aM7/L91NbEFa7X6GJxkI6B8uibNgCiX9BMwT1rYj8ffg8BGiZe
	/T5TkYwkA2WOJ50p0nph3H0GfsUTLbSU=
X-Gm-Gg: ASbGncsxGEb34KCOiq3F5CzXRyNXIbmhmCzJz+XPZyhX3nkcJrL7PVfUaI0iBTzRvDx
	pym8qgVj/UIdnO5UaEkvGlzi8QS11aHh7+WfFLAcpSvNA68W+TeTqvu5YpQZW06izuLQMLWWjiv
	EDN8mdDVhzaGXzs6hHH+ifOAcZ8ktApfllUBFjiDgNM3h0uto9J+3lRAuBHxi4EPtg9JVSqiqo/
	wll
X-Google-Smtp-Source: AGHT+IHduJlmeIitGuEnOXQxzzGBsMqvN70L4DO8oLDAs6lZKoHUCffLJxv/+fYcJUjYR/0C8senNa5cFI1V8GuuJNE=
X-Received: by 2002:a17:90b:3f8f:b0:315:f6d6:d29c with SMTP id
 98e67ed59e1d1-31c8fbc1b65mr4070709a91.15.1752567453044; Tue, 15 Jul 2025
 01:17:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-22-Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250709033242.267892-22-Neeraj.Upadhyay@amd.com>
From: Tianyu Lan <ltykernel@gmail.com>
Date: Tue, 15 Jul 2025 16:16:57 +0800
X-Gm-Features: Ac12FXyO4skjIVSvdfNnDDtno4cCVvnzq_dBGANg7kA5K8Zsnn8dpEaphfliOdI
Message-ID: <CAMvTesDWSUxj+KtdLnymu6HEATEPW2525KswZyP07PpjK+hD1g@mail.gmail.com>
Subject: Re: [RFC PATCH v8 21/35] x86/apic: Initialize APIC ID for Secure AVIC
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com, 
	kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com, 
	naveen.rao@amd.com, kai.huang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 9, 2025 at 11:40=E2=80=AFAM Neeraj Upadhyay <Neeraj.Upadhyay@am=
d.com> wrote:
>
> Initialize the APIC ID in the Secure AVIC APIC backing page with
> the APIC_ID msr value read from Hypervisor. CPU topology evaluation
> later during boot would catch and report any duplicate APIC ID for
> two CPUs.
>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v7:
>  - No change.
>

Reviewed-by: Tianyu Lan <tiala@microsoft.com>

>  arch/x86/kernel/apic/x2apic_savic.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x=
2apic_savic.c
> index 186e69a5e169..618643e7242f 100644
> --- a/arch/x86/kernel/apic/x2apic_savic.c
> +++ b/arch/x86/kernel/apic/x2apic_savic.c
> @@ -131,6 +131,18 @@ static void savic_write(u32 reg, u32 data)
>         }
>  }
>
> +static void init_apic_page(struct apic_page *ap)
> +{
> +       u32 apic_id;
> +
> +       /*
> +        * Before Secure AVIC is enabled, APIC msr reads are intercepted.
> +        * APIC_ID msr read returns the value from the Hypervisor.
> +        */
> +       apic_id =3D native_apic_msr_read(APIC_ID);
> +       apic_set_reg(ap, APIC_ID, apic_id);
> +}
> +
>  static void savic_setup(void)
>  {
>         void *backing_page;
> @@ -138,6 +150,7 @@ static void savic_setup(void)
>         unsigned long gpa;
>
>         backing_page =3D this_cpu_ptr(apic_page);
> +       init_apic_page(backing_page);
>         gpa =3D __pa(backing_page);
>
>         /*
> --
> 2.34.1
>
>


--=20
Thanks
Tianyu Lan

