Return-Path: <kvm+bounces-65957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0949FCBD466
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 10:51:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 886DB301F8CE
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 09:48:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7474631577B;
	Mon, 15 Dec 2025 09:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dJsh1b3B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524B9314A80
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 09:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765792124; cv=none; b=lF0ekXswD0aiA3L32qy4mg5f6JuUrN/jjLn/08k2Tt0ZNwI+kUqwpav6exXsPDXh3OI3IqlH/drMFgtFaMJdjwtfujRIoR3IEGRLKB728bQyKCpsYNirOMuyAJKhRPPuFBjIwqBt7Z/b/b+J3qIL6/A3sPzh0AGwxSCwh7PXvN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765792124; c=relaxed/simple;
	bh=cvdujgeuf3fiQARwCU90g6TYaSFWALdGmOAteldWrWo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Tgdr6ARxqhQ3HhT6weiMHyroFWL1V7f029l0QIoxYbsi3fbk3IAlH554hD5MmsKOmfiJkvqu19Q2SoVdA5G//WkOIbgCZ59nIkeuEtnn4ijsva3Uki8U0ekpF4mwMXJK1zlqvHsnaX4i7o0HfCLfg4epMA2GiaDzzP3COMhA1eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dJsh1b3B; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47775fb6c56so25490825e9.1
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 01:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1765792120; x=1766396920; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SAx3ENHaV9JRcdq0peONXwra7099CJO3M9OJCqRp4S8=;
        b=dJsh1b3BbGjyhhZCZ2FfbEDKE3quO8Bz9+aMq7FHREm0UEMOwYMwaFWG5bL6l7jgV3
         6s0qcdshQk55u7uqlcak9MuHFpbcV1GqhHhEe3D2yW6ucnaBgQ5HDoe9HK3apzw9NsxL
         0sVYvy+z3EGqDAsgFNhXiGT5QzGFXHui1rYD9wxzDb4czTBuSw7l77lO0MFkDDMPYBXL
         dP7iBY5KA6bmMgPVfooWCli++V5+EnNtSvYVbhdSoWmtVYnUrEMo0nvZTLImEhDSW+Bc
         8JqTQoaYJY4uVc1uyVOgJFARKj/W8peUyD76Th2mc6IN4piuhoc7gZSFthiq/bZ2VzW5
         fiHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765792120; x=1766396920;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SAx3ENHaV9JRcdq0peONXwra7099CJO3M9OJCqRp4S8=;
        b=bbI51u3m44mxrObkE8Tf7vTLXQWg6rrwW2r1P/RrnjliU1jDyZheNLI5dmuqoXQWgn
         WVoWn3sBv01pwqKhvRbmRMGlRQp8b0r+7WQT6hFBhYEae6FC2i5wfmQ7Cvl/aRpiFCnF
         jFiKyVuf1K2BX587pGlrl99ITc3/4Nrorg2Fp+KEyOfHosMWQasYYYZ9/0hmOklsK5/m
         MCO9ijMhBTgvygEYkj/cuNE0tkAfC6tycoDrRDRWg6rR7nTdn/6ZHhZIRy+hEEIQHM5w
         bGVH5yVXNDzHd6wQS5pl8m9EnktBUJzDlYIFIRbTPafqyRyfnU5uopf4eE3VcYUcYdfl
         NdBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXaufzx/AYViyrNJxwxqHdd8ljm4GKfI650YGJBRZC4eV4OmAHEhB9T83tMy45uUjKFhtE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo0ThtrT4+GbHwe9xV2yh0gmNAgzpfsRimxR3YZLBrRkgVryyd
	sBzCI7qPJ+73/GYtUpnCkVkjqF4wTRnk6CBe/pqGexE0JibtsIdsqEe1UyLnrOr5gEk=
X-Gm-Gg: AY/fxX5d+AfYo9Cvrh1kC0knJKhehpR4ndLmhEnVAXwZHeo4RWDvhjWDdvNNw2XZhu3
	1wQNdsfTBUlEbUkoQFOC1r+25VDsqDmAcccKpmAKb3eBuJO7bP4aEd3T4/vGjuti+K4CHGqfD3E
	kYHT0m2fJCAGUQMXw2iwwVlXzOmwfSFmW8AADqLctK3qHbkuz9T3N0ftWO/BIQvsVX2obpwMQkB
	5MgH4qWDaTYkfXfI53HDnDDuNJpYNIYsUEcGFCbksXwYMaelVZvfFXV2mDxIaIXBafvILHTDLEO
	Hu2T2BTslyl17brVTmcPlzIhQJNiPEtJZBGQSQmg6n+zPQeh0APauTX2RdTdTxqU8hjvYVUmtAP
	EFBpmaD8oDNox6TfRWoBFPCTsqgogsQ7qPB/lesqeKhslnKK551EIN0qYGukyLp1bmip7vc4b/L
	ssslA1VNvqIes=
X-Google-Smtp-Source: AGHT+IGbjRoFCjMvOeGXu9RK0gRf9Ijwuald6ht6i+Npc7dk1q3jzJElM+UQai3QIsIybXRrn5wOLg==
X-Received: by 2002:a05:600c:8b16:b0:477:7975:30ea with SMTP id 5b1f17b1804b1-47a8f90e81fmr110425585e9.29.1765792119940;
        Mon, 15 Dec 2025 01:48:39 -0800 (PST)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-430f6e78a7csm10539636f8f.34.2025.12.15.01.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 01:48:39 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 719E95F7F9;
	Mon, 15 Dec 2025 09:48:38 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Marc Morcos <marcmorcos@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  Richard Henderson
 <richard.henderson@linaro.org>,  Eduardo Habkost <eduardo@habkost.net>,
  "Dr . David Alan Gilbert" <dave@treblig.org>,  "Michael S . Tsirkin"
 <mst@redhat.com>,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,  Markus
 Armbruster <armbru@redhat.com>,  Marcelo Tosatti <mtosatti@redhat.com>,
  qemu-devel@nongnu.org,  kvm@vger.kernel.org
Subject: Re: [PATCH 1/4] apic: Resize APICBASE
In-Reply-To: <20251213001443.2041258-2-marcmorcos@google.com> (Marc Morcos's
	message of "Sat, 13 Dec 2025 00:14:40 +0000")
References: <20251213001443.2041258-1-marcmorcos@google.com>
	<20251213001443.2041258-2-marcmorcos@google.com>
User-Agent: mu4e 1.12.14-pre3; emacs 30.1
Date: Mon, 15 Dec 2025 09:48:38 +0000
Message-ID: <875xa8nki1.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Marc Morcos <marcmorcos@google.com> writes:

>  APICBASE is 36-bits wide, so this commit resizes it to hold the full dat=
a.
>
> Signed-off-by: Marc Morcos <marcmorcos@google.com>
> ---
>  hw/intc/apic_common.c           | 4 ++--
>  include/hw/i386/apic_internal.h | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/hw/intc/apic_common.c b/hw/intc/apic_common.c
> index ec9e978b0b..1e9aba2e48 100644
> --- a/hw/intc/apic_common.c
> +++ b/hw/intc/apic_common.c
> @@ -233,7 +233,7 @@ static void apic_reset_common(DeviceState *dev)
>  {
>      APICCommonState *s =3D APIC_COMMON(dev);
>      APICCommonClass *info =3D APIC_COMMON_GET_CLASS(s);
> -    uint32_t bsp;
> +    uint64_t bsp;
>=20=20
>      bsp =3D s->apicbase & MSR_IA32_APICBASE_BSP;

This seems overkill for something considering MSR_IA32_APICBASE_BSP is a
single bit (1<<8) and the reset never overflows as APIC_DEFAULT_ADDRESS
is within the 32 bit range.

>      s->apicbase =3D APIC_DEFAULT_ADDRESS | bsp | MSR_IA32_APICBASE_ENABL=
E;
> @@ -363,7 +363,7 @@ static const VMStateDescription vmstate_apic_common =
=3D {
>      .post_load =3D apic_dispatch_post_load,
>      .priority =3D MIG_PRI_APIC,
>      .fields =3D (const VMStateField[]) {
> -        VMSTATE_UINT32(apicbase, APICCommonState),
> +        VMSTATE_UINT64(apicbase, APICCommonState),

Changing this is problematic as you now have to deal with migration
between older and current QEMU's.

>          VMSTATE_UINT8(id, APICCommonState),
>          VMSTATE_UINT8(arb_id, APICCommonState),
>          VMSTATE_UINT8(tpr, APICCommonState),
> diff --git a/include/hw/i386/apic_internal.h b/include/hw/i386/apic_inter=
nal.h
> index 4a62fdceb4..c7ee65ce1d 100644
> --- a/include/hw/i386/apic_internal.h
> +++ b/include/hw/i386/apic_internal.h
> @@ -158,7 +158,7 @@ struct APICCommonState {
>=20=20
>      MemoryRegion io_memory;
>      X86CPU *cpu;
> -    uint32_t apicbase;
> +    uint64_t apicbase;
>      uint8_t id; /* legacy APIC ID */
>      uint32_t initial_apic_id;
>      uint8_t version;

I'll defer to the x86 experts here but perhaps an alternative would be
to clamp kvm_apic_set_base() which seems to be the only place where you
can set it and not get clamped like in apic_set_base()?

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

