Return-Path: <kvm+bounces-18531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B08E98D6089
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 13:22:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CF291C23195
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 11:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C817015746B;
	Fri, 31 May 2024 11:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V5AJnZtM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B40315575A
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 11:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717154548; cv=none; b=BjfIIz4lmrtgKoBp/SRQ5ybs8DUumUoHSxguI/lvtgbCwwTWQNtMf0aCjEKTNHpnd105K50Fp828e/9422l2TMrriwx46K9XWj2cHcuuBoDY39m1CAfGu6Az7BHMtn+HG5TOx//YPHftKWayBXALhpoTBw9mKujiTr9RgLWZVRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717154548; c=relaxed/simple;
	bh=0LqE8FDS5kbRgxNvg8h594D6HHGUeTw9o8XE7M42b+M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iUfYhcWNLgDbh/GASRGWYAXiWrk6l9GHvTakCa+rsij7iE2ePvIJH/HT0NHM0iGPGt+mrTPs3JU2I+epTQ6u39PSfIpnFBFP1gVFkmyNXqxTGdbKzO3PpbONiwJtdCnHIBy75SwRphVgYyqdsLukg/37AQ94YUZ9PL9rbncY+f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V5AJnZtM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717154544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UAWheUW+czVmcKYjV8Dp8vDbyjXbz/6UcUqunqJ3kC0=;
	b=V5AJnZtMUN5yWwC6cL41jdmkNdGcfvxVSJkiIldyyPhDUQ+O2/1VRTHQhdPdAY/2eD4fxh
	B607xhGIhIQwPvhw7ccG2YMyjJ3RvXirAHyfCqIbdE7BnV1URNHt+DAvZhdCOtYXWhrDHk
	KUPldWWRnB5h6LG+fONcNn7cYjN+3IE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-J4tYapUWN1uAQNgkl9zTwQ-1; Fri, 31 May 2024 07:22:23 -0400
X-MC-Unique: J4tYapUWN1uAQNgkl9zTwQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-35dcd39c6ebso865851f8f.1
        for <kvm@vger.kernel.org>; Fri, 31 May 2024 04:22:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717154542; x=1717759342;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UAWheUW+czVmcKYjV8Dp8vDbyjXbz/6UcUqunqJ3kC0=;
        b=oYqaI9bugKyhJjhq0wj5DJZ85cJ7csYnKFVHEj0o/m7285R9vZ2CFFqZ7AYGIlEtHp
         twHu1vXb6bDazOa90REXhaKLf9T/k0im+kUbGteIbt5tdtowA/5cdlXqGSZAcxX5Jf4g
         oy80JvhWxTJFAlD5/5oE54DCxqHpxRBGWEgOJhfySiH4MTxGDAh20IT3h83J0nSxWNgC
         L0/PtfcL9alkgvSY4eFbqFhtn7TPe8+DmEQNRAjUqFkmSyn4YvRnk1ieGXtvtLIRR9wb
         /RUw59vbnA7S8JXsk9swIrPJ89Yq6aXRozkKimy4WQZ/8KE2/rjEz0jFi21+tSvTK8G4
         BdRA==
X-Forwarded-Encrypted: i=1; AJvYcCUbhooy/BJIJvOxeUdtU+xtkRrFn1tjSseCTAFyjz5oLJTKyNiM/yrZuY6/URiFzSR0igqvYuF8jbxeFTZtU4zPPimL
X-Gm-Message-State: AOJu0YzeQd/lo36fVq5Nohvkts/q4Q9BlsPhpJVCR6O1QSG9fUfijV1y
	DOvKldCquIi8QptRW07pR3h0jlGueYzQnB+A07nswMbFscvmHwILGG3+xxmhRpBid98TUx3xm1Y
	IhpzeE68wQJyhYF+QI1oZuNSdein8gkHRp2IqoFmVTJtoxjoWSDkQg41ljy1ZZ+Z9YCGo4yv7B7
	7iib4+hPzStCHog17iG6TkDWoh
X-Received: by 2002:adf:ce8f:0:b0:357:398a:b94f with SMTP id ffacd0b85a97d-35e0e5e9e79mr1552603f8f.26.1717154541837;
        Fri, 31 May 2024 04:22:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFSL8UFosZjFoJQhMVi4zx3TgAUecWQ0sZg7JltbVgqW+uJqoAfCMK7BTXpCXQcig6JubLXzlyW6iTGM3Zd9j8=
X-Received: by 2002:adf:ce8f:0:b0:357:398a:b94f with SMTP id
 ffacd0b85a97d-35e0e5e9e79mr1552581f8f.26.1717154541470; Fri, 31 May 2024
 04:22:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530111643.1091816-1-pankaj.gupta@amd.com> <20240530111643.1091816-29-pankaj.gupta@amd.com>
In-Reply-To: <20240530111643.1091816-29-pankaj.gupta@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 31 May 2024 13:22:10 +0200
Message-ID: <CABgObfYoO1kpgWrjo9=n6Q6nf9qtRfd1rwdHU81d6UMMkPSewQ@mail.gmail.com>
Subject: Re: [PATCH v4 28/31] hw/i386: Add support for loading BIOS using guest_memfd
To: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: qemu-devel@nongnu.org, brijesh.singh@amd.com, dovmurik@linux.ibm.com, 
	armbru@redhat.com, michael.roth@amd.com, xiaoyao.li@intel.com, 
	thomas.lendacky@amd.com, isaku.yamahata@intel.com, berrange@redhat.com, 
	kvm@vger.kernel.org, anisinha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 1:17=E2=80=AFPM Pankaj Gupta <pankaj.gupta@amd.com>=
 wrote:
>      if (bios_size <=3D 0 ||
>          (bios_size % 65536) !=3D 0) {
> -        goto bios_error;
> +        if (!machine_require_guest_memfd(MACHINE(x86ms))) {
> +                g_warning("%s: Unaligned BIOS size %d", __func__, bios_s=
ize);
> +                goto bios_error;
> +        }

Why is this not needed for SEV-SNP? (The bios_size <=3D 0 case
definitely should be an error).

I'll just drop this change.

> +    }
> +    if (machine_require_guest_memfd(MACHINE(x86ms))) {
> +        memory_region_init_ram_guest_memfd(&x86ms->bios, NULL, "pc.bios"=
,
> +                                           bios_size, &error_fatal);
> +    } else {
> +        memory_region_init_ram(&x86ms->bios, NULL, "pc.bios",
> +                               bios_size, &error_fatal);
>      }
> -    memory_region_init_ram(&x86ms->bios, NULL, "pc.bios", bios_size,
> -                           &error_fatal);
>      if (sev_enabled()) {
>          /*
>           * The concept of a "reset" simply doesn't exist for
> @@ -1023,9 +1031,11 @@ void x86_bios_rom_init(X86MachineState *x86ms, con=
st char *default_firmware,
>      }
>      g_free(filename);
>
> -    /* map the last 128KB of the BIOS in ISA space */
> -    x86_isa_bios_init(&x86ms->isa_bios, rom_memory, &x86ms->bios,
> -                      !isapc_ram_fw);

> +    if (!machine_require_guest_memfd(MACHINE(x86ms))) {
> +        /* map the last 128KB of the BIOS in ISA space */
> +        x86_isa_bios_init(&x86ms->isa_bios, rom_memory, &x86ms->bios,
> +                          !isapc_ram_fw);
> +    }
>
>      /* map all the bios at the top of memory */
>      memory_region_add_subregion(rom_memory,
> --
> 2.34.1
>

On Thu, May 30, 2024 at 1:17=E2=80=AFPM Pankaj Gupta <pankaj.gupta@amd.com>=
 wrote:
>
> From: Michael Roth <michael.roth@amd.com>
>
> When guest_memfd is enabled, the BIOS is generally part of the initial
> encrypted guest image and will be accessed as private guest memory. Add
> the necessary changes to set up the associated RAM region with a
> guest_memfd backend to allow for this.
>
> Current support centers around using -bios to load the BIOS data.
> Support for loading the BIOS via pflash requires additional enablement
> since those interfaces rely on the use of ROM memory regions which make
> use of the KVM_MEM_READONLY memslot flag, which is not supported for
> guest_memfd-backed memslots.
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
> ---
>  hw/i386/x86-common.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
>
> diff --git a/hw/i386/x86-common.c b/hw/i386/x86-common.c
> index f41cb0a6a8..059de65f36 100644
> --- a/hw/i386/x86-common.c
> +++ b/hw/i386/x86-common.c
> @@ -999,10 +999,18 @@ void x86_bios_rom_init(X86MachineState *x86ms, cons=
t char *default_firmware,
>      }
>      if (bios_size <=3D 0 ||
>          (bios_size % 65536) !=3D 0) {
> -        goto bios_error;
> +        if (!machine_require_guest_memfd(MACHINE(x86ms))) {
> +                g_warning("%s: Unaligned BIOS size %d", __func__, bios_s=
ize);
> +                goto bios_error;
> +        }
> +    }
> +    if (machine_require_guest_memfd(MACHINE(x86ms))) {
> +        memory_region_init_ram_guest_memfd(&x86ms->bios, NULL, "pc.bios"=
,
> +                                           bios_size, &error_fatal);
> +    } else {
> +        memory_region_init_ram(&x86ms->bios, NULL, "pc.bios",
> +                               bios_size, &error_fatal);
>      }
> -    memory_region_init_ram(&x86ms->bios, NULL, "pc.bios", bios_size,
> -                           &error_fatal);
>      if (sev_enabled()) {
>          /*
>           * The concept of a "reset" simply doesn't exist for
> @@ -1023,9 +1031,11 @@ void x86_bios_rom_init(X86MachineState *x86ms, con=
st char *default_firmware,
>      }
>      g_free(filename);
>
> -    /* map the last 128KB of the BIOS in ISA space */
> -    x86_isa_bios_init(&x86ms->isa_bios, rom_memory, &x86ms->bios,
> -                      !isapc_ram_fw);
> +    if (!machine_require_guest_memfd(MACHINE(x86ms))) {
> +        /* map the last 128KB of the BIOS in ISA space */
> +        x86_isa_bios_init(&x86ms->isa_bios, rom_memory, &x86ms->bios,
> +                          !isapc_ram_fw);
> +    }
>
>      /* map all the bios at the top of memory */
>      memory_region_add_subregion(rom_memory,
> --
> 2.34.1
>


