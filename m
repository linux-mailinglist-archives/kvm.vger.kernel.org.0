Return-Path: <kvm+bounces-8456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E06A484FB3D
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 18:46:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0879C1C24659
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 17:46:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1EAB7E59F;
	Fri,  9 Feb 2024 17:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lLRdFZOb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA2A7BB1E
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 17:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707500797; cv=none; b=la6yeLLUpvoIq51CP2pmSjRZVRXLmJU8+0TMHy/IG1SOvRxsYseyXBGaFC+H2nTBXyCHyQXc1ZMhb9awYBzEADC1t7D1Vg17e7xIyXc4PSI+ojdbUHPUMGhxba2BgVou5+05XDPPMOrZEmh5MlkMlkrFDI82FxFZlnEt5gHT2bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707500797; c=relaxed/simple;
	bh=pzTDimIyhJcqGBK/rI8G9PkFoMq+lwnFfneY7IjU7iM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=I6qMezH3Ep2GJkSad3V+gWB1J6WxdI/IDx9K5wkSs80xy/alinMS06Pr41qwcyMrWwKXaGA2BRdNai4Rt9rhZovn2BdDLtYioL5jzGTcynOCc6bW6bkOa9yoQJg4Q3R1E4cFORzz0Jf162rg0T42NuI131jbUiTX0lCxfa5EIKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lLRdFZOb; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-40fe03cd1caso11261035e9.0
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 09:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707500793; x=1708105593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CMP9+oA5PZa1GDmH6J/3qdiJQiJNWPu5uwirTMrtciQ=;
        b=lLRdFZObDSPoZ9qcrb98R2ot32xo6rIrLDDb3dtDWA3lGrNSrK6rrjKXNTJIfbtDl1
         BNIRMpIqeuVqI9Di7sAoAdnqxin5IZOEGJCYb2HvTXifOo7EfL7JPe1It9QM4aVH4sTK
         FPLv1ppGs126C4Ed6gQDRi1kaIXaf4qXt/WzaNjpSmu4u0OCxIglz7aS590fKLfQEGvu
         uBhj7nPVUo3ysAhgnDCqsB+f8oclpMk+tSa/3i9bk1mumxYYINE87cDg9vU8z4Rly/0w
         TJhfoPpqbGPJpmwDK1lFaqTdVVM4mTieoLiN0oMJqf4pMi7uvls9Dv4q3KRs6AD7/1tE
         vxsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707500793; x=1708105593;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CMP9+oA5PZa1GDmH6J/3qdiJQiJNWPu5uwirTMrtciQ=;
        b=InN7g7tSXwMFajnFqwNycJUC0iZ5oKC+f5USTjQUOYkBcODOTGzR2oKnq7RcTg43LK
         DYnn5/tlNR8dQig8BPgroK0vlR4m63dK8NwWGnyf+ov9N0vsQNeaXiv09k3Ffxoi1J/H
         3rNCtOQqKfSP/NF1i5/2sp9r+kkUZlr7c/iUvoi9M5hb3t/OaBwqwLWd8u5Z2EyXX1VB
         dF+2ZzOqTb9F0u6cvr7n9x8y/psYD29gfNhi0HpcBJRPus24Jdr0y/eEWEG2W2eIacTP
         INXnnPmsEYPq72a0YDh9f8bHwsaD/1zLkG7T+OoAAHp9ZQ/K0/HDL74CWa0EicxP6Ipz
         bL0w==
X-Gm-Message-State: AOJu0YyBw5v6TrHNXFNURoGctz79TCrVQ6yUQ7hT5t+gdzplMoj3eRPk
	AOwpKzjZWlh8xPLzY5M4rqW2ZuZNx9nlht3CFG2q30Cc13XnPu4px0pnlEQVna8=
X-Google-Smtp-Source: AGHT+IH99libf9jh1GuN0cLdKL6aQYBI2jm6wSEaGlryUhwhMHBmWeUUEqkbvRsmEWdL9BCLx6e6Sw==
X-Received: by 2002:a05:600c:16c9:b0:40e:f154:752 with SMTP id l9-20020a05600c16c900b0040ef1540752mr23840wmn.20.1707500793453;
        Fri, 09 Feb 2024 09:46:33 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWGi45v2J76YthBvZEFTR/Y8eQh2CMiRBtNwTSpewaIt3GvhYYJV03JsJTM8HOH/wGHDO/f/8O41zTqtXQdw0dWc3A1J1XOxTI/Hkkkx3zrtkKPfX9JqO13c1yO5tNJ6zFFMUnNgs4A5w==
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id v17-20020a05600c445100b0041076153a40sm1266859wmn.44.2024.02.09.09.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 09:46:32 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 5BE985F79D;
	Fri,  9 Feb 2024 17:46:32 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Andrey Drobyshev <andrey.drobyshev@virtuozzo.com>
Cc: qemu-devel@nongnu.org,  pbonzini@redhat.com,  den@openvz.org,
 kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: emit GUEST_PANICKED event in case of abnormal KVM
 exit
In-Reply-To: <20231101152311.181817-1-andrey.drobyshev@virtuozzo.com> (Andrey
	Drobyshev's message of "Wed, 1 Nov 2023 17:23:11 +0200")
References: <20231101152311.181817-1-andrey.drobyshev@virtuozzo.com>
User-Agent: mu4e 1.11.27; emacs 29.1
Date: Fri, 09 Feb 2024 17:46:32 +0000
Message-ID: <875xyxledj.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Andrey Drobyshev <andrey.drobyshev@virtuozzo.com> writes:

(Add kvm@vger to CC for wider review)

> Currently we emit GUEST_PANICKED event in case kvm_vcpu_ioctl() returns
> KVM_EXIT_SYSTEM_EVENT with the event type KVM_SYSTEM_EVENT_CRASH.  Let's
> extend this scenario and emit GUEST_PANICKED in case of an abnormal KVM
> exit.  That's a natural thing to do since in this case guest is no
> longer operational anyway.
>
> Signed-off-by: Andrey Drobyshev <andrey.drobyshev@virtuozzo.com>
> Acked-by: Denis V. Lunev <den@virtuozzo.com>
> ---
>  accel/kvm/kvm-all.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index e39a810a4e..d74b3f0b0e 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2816,6 +2816,14 @@ static void kvm_eat_signals(CPUState *cpu)
>      } while (sigismember(&chkset, SIG_IPI));
>  }
>=20=20
> +static void kvm_emit_guest_crash(CPUState *cpu)
> +{
> +    kvm_cpu_synchronize_state(cpu);
> +    qemu_mutex_lock_iothread();
> +    qemu_system_guest_panicked(cpu_get_crash_info(cpu));
> +    qemu_mutex_unlock_iothread();
> +}
> +
>  int kvm_cpu_exec(CPUState *cpu)
>  {
>      struct kvm_run *run =3D cpu->kvm_run;
> @@ -2969,21 +2977,24 @@ int kvm_cpu_exec(CPUState *cpu)
>                  ret =3D EXCP_INTERRUPT;
>                  break;
>              case KVM_SYSTEM_EVENT_CRASH:
> -                kvm_cpu_synchronize_state(cpu);
> -                qemu_mutex_lock_iothread();
> -                qemu_system_guest_panicked(cpu_get_crash_info(cpu));
> -                qemu_mutex_unlock_iothread();
> +                kvm_emit_guest_crash(cpu);
>                  ret =3D 0;
>                  break;
>              default:
>                  DPRINTF("kvm_arch_handle_exit\n");
>                  ret =3D kvm_arch_handle_exit(cpu, run);
> +                if (ret < 0) {
> +                    kvm_emit_guest_crash(cpu);
> +                }
>                  break;
>              }
>              break;
>          default:
>              DPRINTF("kvm_arch_handle_exit\n");
>              ret =3D kvm_arch_handle_exit(cpu, run);
> +            if (ret < 0) {
> +                kvm_emit_guest_crash(cpu);
> +            }
>              break;
>          }
>      } while (ret =3D=3D 0);

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

