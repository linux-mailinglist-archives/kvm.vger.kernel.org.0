Return-Path: <kvm+bounces-23668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EA5F94C978
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 07:03:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07B73286558
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 05:03:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD47D167D8C;
	Fri,  9 Aug 2024 05:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YAuaeowQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384EC4C83
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 05:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723179821; cv=none; b=j72djVk5KSyHQ9Rw2urJPWuhnb5kO12vQdsdjbnPy9Pquj1FZuHraD2F+Oc1AfdeHBwaXcKOVuBDXZAYJgNeS7e9cE/o0YR3IeKiVlaMw87nnRUMO82xItrQBzFQk50JciuryqsxdpyiHO+xLZ0Xm31KJGGm28qtYKKew1A+GW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723179821; c=relaxed/simple;
	bh=1yYL4cYGvkUG7tE4L4vipA7o9s+XxcmT7BrUm2XXZac=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QMCpzqKKPWFqUEL55Jy0iGa8Hnu/ksrAZndOSVBj3oQQ/0vmuxGx9S5fKrPK94iHFUyW5pIL+dUPVcdCLUhlbFG3hwKrzwXypCbmncMLGuW8lMhRp3R2eATUlQ3s+Zq3Qpjrar5i6pUhuu9n/x5qlbtyYalcKZPLtXP4Zc53kSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YAuaeowQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723179818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nFm7hX11ewPim1wI/XILslO8UkfCpMWJ2klA+0ZXIsQ=;
	b=YAuaeowQNWO2yv2p2877RwBb5zlTk7Ln3tlxhYqbHJ+Hyq27fko5yHf0oGh7rpYbz38cX7
	75q+voPmKZ3+qroVFn5KXataGhYTkDvscJvjKSxqrGKy5FmVSV4pFLA5sAzTdjpDtdZ2gk
	tRPR1rDFJuPvQgHVmxAmb39ZYO7Ewjo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-CFWaR0TGN2meiw6y90mDhA-1; Fri, 09 Aug 2024 01:03:36 -0400
X-MC-Unique: CFWaR0TGN2meiw6y90mDhA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a7bcaa94892so139372966b.0
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2024 22:03:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723179816; x=1723784616;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nFm7hX11ewPim1wI/XILslO8UkfCpMWJ2klA+0ZXIsQ=;
        b=m+3h6wdrc3+xnIhAeGfGfkcLqFrViI52JlHVqRue7FxDT/pT1/a33Phb1ElBz17ygB
         z41NjzHawSSjujlyIEE+vrmM0rkMEoYY8ddXmEmb3ASjH105wIs9xUdpvjKNHsFVuPgm
         b8G5Is4v70ve/6S05fHaLmYgEeUba/+Z5LftmBy+L0n6/U0ARaxAT3Ugfyu3f/Mb2srU
         8Z3MQuD/YJ9LN++rrFWrieXukNWGsFouyym/nsmWKakNY7JLIgcrY1iM+DlmQ7R1avH4
         OBs1GnNrSVslQVWqlpK3LFqVmacXvoJ5/doPRQGDC55DiSMw/f5lMDUW3nGsVj1ZKdKX
         iRJg==
X-Forwarded-Encrypted: i=1; AJvYcCXu/SFfRX45D358P6MoJ5212Kql7h+9YJTTvzG+zRGJgwEudSFcxfeaWBl1SP2cFKHAxrKoDEigzS2VyUsdCIvTfY9I
X-Gm-Message-State: AOJu0YxWrKsM+ZOroap689b/KTY/m1Wd1BPVMxTooLgRy4VfcSXZIfez
	LFwZzo2Ja2COfWGiXJY+z+OgtLu2ZaldPYvXD7oqUTylr2GFC4b1mKjagxX88KkbxFBT/c5Z64k
	LnX2dvtglvpUi7bTyUmP2Bi6wmCWmdSEHhClqcrwc/RjVPXAXgr5D2dS9IotFZOTcHNw7B9fBfZ
	/8/KUNTek3hoAfZDCmB1j/zC2X
X-Received: by 2002:a17:907:2d1e:b0:a7a:b561:3575 with SMTP id a640c23a62f3a-a80aa67d153mr25370366b.56.1723179815452;
        Thu, 08 Aug 2024 22:03:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQzk5UK4neT2CvDN53fBwu1GDTnIFuo3jXYxP/4UJ3b+bRNkgXGG1aJOPCxVX/HvKR/9QRXjpY1BRXq/ttqJ8=
X-Received: by 2002:a17:907:2d1e:b0:a7a:b561:3575 with SMTP id
 a640c23a62f3a-a80aa67d153mr25368966b.56.1723179814864; Thu, 08 Aug 2024
 22:03:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240809045153.1744397-1-anisinha@redhat.com> <20240809045153.1744397-2-anisinha@redhat.com>
In-Reply-To: <20240809045153.1744397-2-anisinha@redhat.com>
From: Ani Sinha <anisinha@redhat.com>
Date: Fri, 9 Aug 2024 10:33:23 +0530
Message-ID: <CAK3XEhNvbtJL68cD9pi9i+rMc6a68jpBgyivsj8ZKEaar+trcg@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm: replace fprintf with error_report() in
 kvm_init() for error conditions
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-trivial@nongnu.org, zhao1.liu@intel.com, kvm@vger.kernel.org, 
	qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 9, 2024 at 10:23=E2=80=AFAM Ani Sinha <anisinha@redhat.com> wro=
te:
>
> error_report() is more appropriate for error situations. Replace fprintf =
with
> error_report. Cosmetic. No functional change.
>
> CC: qemu-trivial@nongnu.org
> CC: zhao1.liu@intel.com
> Signed-off-by: Ani Sinha <anisinha@redhat.com>
> ---
>  accel/kvm/kvm-all.c | 42 +++++++++++++++++++-----------------------
>  1 file changed, 19 insertions(+), 23 deletions(-)
>
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 75d11a07b2..899b5264e3 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2427,7 +2427,7 @@ static int kvm_init(MachineState *ms)
>      QLIST_INIT(&s->kvm_parked_vcpus);
>      s->fd =3D qemu_open_old(s->device ?: "/dev/kvm", O_RDWR);
>      if (s->fd =3D=3D -1) {
> -        fprintf(stderr, "Could not access KVM kernel module: %m\n");
> +        error_report("Could not access KVM kernel module: %m");
>          ret =3D -errno;
>          goto err;
>      }
> @@ -2437,13 +2437,13 @@ static int kvm_init(MachineState *ms)
>          if (ret >=3D 0) {
>              ret =3D -EINVAL;
>          }
> -        fprintf(stderr, "kvm version too old\n");
> +        error_report("kvm version too old");
>          goto err;
>      }
>
>      if (ret > KVM_API_VERSION) {
>          ret =3D -EINVAL;
> -        fprintf(stderr, "kvm version not supported\n");
> +        error_report("kvm version not supported");
>          goto err;
>      }
>
> @@ -2488,30 +2488,26 @@ static int kvm_init(MachineState *ms)
>      } while (ret =3D=3D -EINTR);
>
>      if (ret < 0) {
> -        fprintf(stderr, "ioctl(KVM_CREATE_VM) failed: %d %s\n", -ret,
> -                strerror(-ret));
> +        error_report("ioctl(KVM_CREATE_VM) failed: %d %s", -ret,
> +                    strerror(-ret));
>
>  #ifdef TARGET_S390X
>          if (ret =3D=3D -EINVAL) {
> -            fprintf(stderr,
> -                    "Host kernel setup problem detected. Please verify:\=
n");
> -            fprintf(stderr, "- for kernels supporting the switch_amode o=
r"
> -                    " user_mode parameters, whether\n");
> -            fprintf(stderr,
> -                    "  user space is running in primary address space\n"=
);
> -            fprintf(stderr,
> -                    "- for kernels supporting the vm.allocate_pgste sysc=
tl, "
> -                    "whether it is enabled\n");
> +            error_report("Host kernel setup problem detected. Please ver=
ify:");
> +            error_report("- for kernels supporting the switch_amode or"
> +                        " user_mode parameters, whether");
> +            error_report("  user space is running in primary address spa=
ce");
> +            error_report("- for kernels supporting the vm.allocate_pgste=
 "
> +                        "sysctl, whether it is enabled");
>          }
>  #elif defined(TARGET_PPC)
>          if (ret =3D=3D -EINVAL) {
> -            fprintf(stderr,
> -                    "PPC KVM module is not loaded. Try modprobe kvm_%s.\=
n",
> -                    (type =3D=3D 2) ? "pr" : "hv");
> +            error_report("PPC KVM module is not loaded. Try modprobe kvm=
_%s.",
> +                        (type =3D=3D 2) ? "pr" : "hv");
>          }
>  #endif
> -        goto err;
>      }
> +        goto err;

Sorry, this is a bug. I will resend.

>
>      s->vmfd =3D ret;
>
> @@ -2526,9 +2522,9 @@ static int kvm_init(MachineState *ms)
>                          nc->name, nc->num, soft_vcpus_limit);
>
>              if (nc->num > hard_vcpus_limit) {
> -                fprintf(stderr, "Number of %s cpus requested (%d) exceed=
s "
> -                        "the maximum cpus supported by KVM (%d)\n",
> -                        nc->name, nc->num, hard_vcpus_limit);
> +                error_report("Number of %s cpus requested (%d) exceeds "
> +                             "the maximum cpus supported by KVM (%d)",
> +                             nc->name, nc->num, hard_vcpus_limit);
>                  exit(1);
>              }
>          }
> @@ -2542,8 +2538,8 @@ static int kvm_init(MachineState *ms)
>      }
>      if (missing_cap) {
>          ret =3D -EINVAL;
> -        fprintf(stderr, "kvm does not support %s\n%s",
> -                missing_cap->name, upgrade_note);
> +        error_report("kvm does not support %s", missing_cap->name);
> +        error_report("%s", upgrade_note);
>          goto err;
>      }
>
> --
> 2.45.2
>


