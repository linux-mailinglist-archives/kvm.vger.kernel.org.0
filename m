Return-Path: <kvm+bounces-2796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C99A97FE173
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 21:56:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 070131C20BC6
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 20:56:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75C2661666;
	Wed, 29 Nov 2023 20:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBD8DC;
	Wed, 29 Nov 2023 12:55:53 -0800 (PST)
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-58d9a0ead0cso41036eaf.0;
        Wed, 29 Nov 2023 12:55:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701291353; x=1701896153;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N7c1Bubisrl68U842oFCv7/E0UhOuVZ4XvYZuACc8eY=;
        b=DPCba4Xh2aabY6K4fMtTKm+7kmoBG6L0AYynmDlzhpvBNuluwC1KJwYGLx8QVJUHfT
         ty2FDEG9sGf8CWU/A2ytPk2uz1pHRZRpDFjfZ5/7kQYK/ysaqWkcFq9c1A2MmvnCzIvG
         XlkWaPfs/IZWJWFilFDJKBLJFtuVEk2zZIBonHOOiSo3kdHcJl9axawQBqKOXJrTs0Hk
         AuHrRfs8Pje5ylosz/vqCCVZjy7agOKE2dNOYJh4AS4CB6GZmn39Y5p+iztXXtBzFD/F
         exm72/DdUzPA0Cax8cLENZdiuoomUg1jjx3Bc4e0M5qTQFW21/nsxeffEJvnEDkxRc5E
         1IzQ==
X-Gm-Message-State: AOJu0Yz5luxs8zbk+Z+/ExgJKHhICMngEJ7gPdSaXUcm2k4a/TGW+DLU
	yPhvHfpTO/b4X8PmowX5EHgXQ+yPHN+kOyu8LE4=
X-Google-Smtp-Source: AGHT+IEBfD/9l20lo6SNtWfZYkQa3nFyyj//mCc2waWUrux0EwVLhVh78MKvu8Sp5jNwclh7wy3o6FMPoDiNaIiU7+U=
X-Received: by 2002:a4a:c691:0:b0:584:1080:f0a5 with SMTP id
 m17-20020a4ac691000000b005841080f0a5mr19313032ooq.1.1701291353066; Wed, 29
 Nov 2023 12:55:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1700488898-12431-1-git-send-email-mihai.carabas@oracle.com> <1700488898-12431-3-git-send-email-mihai.carabas@oracle.com>
In-Reply-To: <1700488898-12431-3-git-send-email-mihai.carabas@oracle.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 29 Nov 2023 21:55:42 +0100
Message-ID: <CAJZ5v0h717jGsMeEVCCY25=Ry7btM_CjRtxTjhGpirTU6yQshg@mail.gmail.com>
Subject: Re: [PATCH 2/7] x86/kvm: Move haltpoll_want() to be arch defined
To: Mihai Carabas <mihai.carabas@oracle.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, 
	pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com, 
	rafael@kernel.org, daniel.lezcano@linaro.org, akpm@linux-foundation.org, 
	pmladek@suse.com, peterz@infradead.org, dianders@chromium.org, 
	npiggin@gmail.com, rick.p.edgecombe@intel.com, joao.m.martins@oracle.com, 
	juerg.haefliger@canonical.com, mic@digikod.net, arnd@arndb.de, 
	ankur.a.arora@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 20, 2023 at 4:15=E2=80=AFPM Mihai Carabas <mihai.carabas@oracle=
.com> wrote:
>
> From: Joao Martins <joao.m.martins@oracle.com>
>
> Right now, kvm_para_has_hint(KVM_HINTS_REALTIME) is x86 only, and so in t=
he
> pursuit of making cpuidle-haltpoll arch independent, move the check for
> haltpoll enablement to be defined per architecture. Same thing for
> boot_option_idle_override. To that end, add a arch_haltpoll_want() and mo=
ve the
> check there.
>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>

From the cpuidle side:

Acked-by: Rafael J. Wysocki <rafael@kernel.org>

> ---
>  arch/x86/include/asm/cpuidle_haltpoll.h |  1 +
>  arch/x86/kernel/kvm.c                   | 10 ++++++++++
>  drivers/cpuidle/cpuidle-haltpoll.c      |  8 ++------
>  include/linux/cpuidle_haltpoll.h        |  5 +++++
>  4 files changed, 18 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/cpuidle_haltpoll.h b/arch/x86/include/a=
sm/cpuidle_haltpoll.h
> index c8b39c6716ff..2c5a53ce266f 100644
> --- a/arch/x86/include/asm/cpuidle_haltpoll.h
> +++ b/arch/x86/include/asm/cpuidle_haltpoll.h
> @@ -4,5 +4,6 @@
>
>  void arch_haltpoll_enable(unsigned int cpu);
>  void arch_haltpoll_disable(unsigned int cpu);
> +bool arch_haltpoll_want(void);
>
>  #endif
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 1cceac5984da..75a24f107b2a 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -1151,4 +1151,14 @@ void arch_haltpoll_disable(unsigned int cpu)
>         smp_call_function_single(cpu, kvm_enable_host_haltpoll, NULL, 1);
>  }
>  EXPORT_SYMBOL_GPL(arch_haltpoll_disable);
> +
> +bool arch_haltpoll_want(void)
> +{
> +       /* Do not load haltpoll if idle=3D is passed */
> +       if (boot_option_idle_override !=3D IDLE_NO_OVERRIDE)
> +               return false;
> +
> +       return kvm_para_has_hint(KVM_HINTS_REALTIME);
> +}
> +EXPORT_SYMBOL_GPL(arch_haltpoll_want);
>  #endif
> diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle=
-haltpoll.c
> index e66df22f9695..72f9c84990c5 100644
> --- a/drivers/cpuidle/cpuidle-haltpoll.c
> +++ b/drivers/cpuidle/cpuidle-haltpoll.c
> @@ -96,7 +96,7 @@ static void haltpoll_uninit(void)
>
>  static bool haltpoll_want(void)
>  {
> -       return kvm_para_has_hint(KVM_HINTS_REALTIME) || force;
> +       return (kvm_para_available() && arch_haltpoll_want()) || force;
>  }
>
>  static int __init haltpoll_init(void)
> @@ -104,11 +104,7 @@ static int __init haltpoll_init(void)
>         int ret;
>         struct cpuidle_driver *drv =3D &haltpoll_driver;
>
> -       /* Do not load haltpoll if idle=3D is passed */
> -       if (boot_option_idle_override !=3D IDLE_NO_OVERRIDE)
> -               return -ENODEV;
> -
> -       if (!kvm_para_available() || !haltpoll_want())
> +       if (!haltpoll_want())
>                 return -ENODEV;
>
>         cpuidle_poll_state_init(drv);
> diff --git a/include/linux/cpuidle_haltpoll.h b/include/linux/cpuidle_hal=
tpoll.h
> index d50c1e0411a2..bae68a6603e3 100644
> --- a/include/linux/cpuidle_haltpoll.h
> +++ b/include/linux/cpuidle_haltpoll.h
> @@ -12,5 +12,10 @@ static inline void arch_haltpoll_enable(unsigned int c=
pu)
>  static inline void arch_haltpoll_disable(unsigned int cpu)
>  {
>  }
> +
> +static inline bool arch_haltpoll_want(void)
> +{
> +       return false;
> +}
>  #endif
>  #endif
> --
> 1.8.3.1
>

