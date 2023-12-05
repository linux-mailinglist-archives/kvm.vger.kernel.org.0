Return-Path: <kvm+bounces-3611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07854805AFE
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 18:16:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38A501C21155
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09143692B5;
	Tue,  5 Dec 2023 17:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vqX8g0sk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DF0188
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 09:16:40 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-54c79cca895so16940a12.0
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 09:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701796599; x=1702401399; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aSBKKU83hDN118eQdXRp7uqCLcQ4IWw8MqbWslBNiH0=;
        b=vqX8g0skmYIIMpe+vxKIJjnV09zf5j6xgts60pHKJzbEIDojzzCJ7+5/Pt0s9wPV8M
         XYrtAcQIgAaIZKU/iB0khFu+vCE7OEhYs/Y0dzn8/C1gCqlEC21Me6/W/djupAcnt1Bl
         soTWXluHcpY5uC5w3qcMEBwREed/gn069YJpWm1/+rAXnOB+96Cb5+kVK7DMwnQjhS/5
         RzoYs/giSOG4FMzsNBlnFwSW2GnHgg8zUd/v8XKGrxXlDfqVv6kHTkyxkuHcLARUZPgf
         rDB3FTpY5wcjXjHkw52L8A0gMItDKq0yNLWUzBbGzvpxK8+DeH0D4kPqoc2ci0CXgLDB
         /Ntg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701796599; x=1702401399;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aSBKKU83hDN118eQdXRp7uqCLcQ4IWw8MqbWslBNiH0=;
        b=Tg0kKdX863fMByRPSDuC80w25Fe4rwzokTqe8dlxuHjpV8kbzvPOedSecjAXgJSX2n
         qVmcUw97YlOZCZBLgYWciyY8QVxobUiGYmN6vSqG1RNzpgA5ejLfY6liy3hFAtSSQFeZ
         njeia5JxhgYezGPRGwZPW2pKVHUpgR9OJykvHg539RZqimE4k++ocN7yfmaTw/KA7GyB
         z/qjhUSFe7aLBXewVXz5llnTw3N+mi17WRCIml55kmk3PJyWE5agcrS6CZp7x7PQCfkt
         NyYqIdFhUvPVDbsbSF5MuXIeCky0FyUz09mc6MyXkrKLmGmo6NrZAQk8QwIz6M7/A2lW
         3E6g==
X-Gm-Message-State: AOJu0YwbnGWLUnI7+Ev84GU/Yk9b8/Te/RkYgujEgy3iGyuocjv0R6qR
	PlX6RK698V5xobZz6tgUMykS9dI2D9C7GLutgZojrQ==
X-Google-Smtp-Source: AGHT+IHhWfDjtX7QFgsVonw1utkXmkzqOjxQMR+jQXUD8x+BlFDqv25hTYs1PkiYjEeN5YUy2Ak3VErs9f0y4Tgh9ok=
X-Received: by 2002:a50:99de:0:b0:54a:ee8b:7a99 with SMTP id
 n30-20020a5099de000000b0054aee8b7a99mr478462edb.0.1701796598345; Tue, 05 Dec
 2023 09:16:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231128125959.1810039-1-nikunj@amd.com> <20231128125959.1810039-13-nikunj@amd.com>
In-Reply-To: <20231128125959.1810039-13-nikunj@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Tue, 5 Dec 2023 09:16:27 -0800
Message-ID: <CAAH4kHYL9A4+F0cN1VT1EbaHACFjB6Crbsdzp3hwjz+GuK_CSg@mail.gmail.com>
Subject: Re: [PATCH v6 12/16] x86/sev: Prevent RDTSC/RDTSCP interception for
 Secure TSC enabled guests
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org, 
	kvm@vger.kernel.org, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de, 
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 28, 2023 at 5:02=E2=80=AFAM Nikunj A Dadhania <nikunj@amd.com> =
wrote:
>
> The hypervisor should not be intercepting RDTSC/RDTSCP when Secure TSC
> is enabled. A #VC exception will be generated if the RDTSC/RDTSCP
> instructions are being intercepted. If this should occur and Secure
> TSC is enabled, terminate guest execution.
>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/kernel/sev-shared.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index ccb0915e84e1..6d9ef5897421 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -991,6 +991,16 @@ static enum es_result vc_handle_rdtsc(struct ghcb *g=
hcb,
>         bool rdtscp =3D (exit_code =3D=3D SVM_EXIT_RDTSCP);
>         enum es_result ret;
>
> +       /*
> +        * RDTSC and RDTSCP should not be intercepted when Secure TSC is
> +        * enabled. Terminate the SNP guest when the interception is enab=
led.
> +        * This file is included from kernel/sev.c and boot/compressed/se=
v.c,
> +        * use sev_status here as cc_platform_has() is not available when
> +        * compiling boot/compressed/sev.c.
> +        */
> +       if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
> +               return ES_VMM_ERROR;

Is this not a cc_platform_has situation? I don't recall how the
conversation shook out for TDX's forcing X86_FEATURE_TSC_RELIABLE
versus having a cc_attr_secure_tsc

> +
>         ret =3D sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, 0, 0);
>         if (ret !=3D ES_OK)
>                 return ret;
> --
> 2.34.1
>


--=20
-Dionna Glaze, PhD (she/her)

