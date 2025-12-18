Return-Path: <kvm+bounces-66257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 612E3CCC0C5
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 14:39:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 78C6F30F6C12
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 13:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22059332911;
	Thu, 18 Dec 2025 13:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CcKuH4uI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HW6XzIer"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DED335BCF
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 13:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766064851; cv=none; b=JmwB094IIY7zfWWAzeg+Azz5KW8Z9n1Xiv2Fuk5aILsyYnm30JsPrNqnA028D5/1UapyrC3DSrimXlNpiMk9JLQ+heBzFb3zKHArctPdStSOQTpUZlTDjVccPVWy6mVNZ6DgurtXZI8YxPdcEUVIq3hovaDxtOSO5Y9OVfZc7J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766064851; c=relaxed/simple;
	bh=Q6i5LYY7MDxh0a3ImXyR2y/hOda5k3l/3qRL8j9LxrI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OXvleHWnav+jK8DtQoB0nVTj3y7AvubT0SwLzkVjzHrss/pit5U/FoowjjOzz+LsZny120Z2BOpkVtjlWjtJeYkdXZ2olyNrpDRd2qkzjJRqDhygZm+dwTHNNH754jnZOEcBKM+bKlPhDz9DZZ5r8zg8SXlboFgJVWcLLNuc2eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CcKuH4uI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HW6XzIer; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766064845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ygbAU5x3T384LKUGynR1xkO6dKCGM4SShqXTIGHAd/Y=;
	b=CcKuH4uIzeBaOb/aEbxwDziJjom6J6g/R0AinZOC2d5TBiJ4J6ogVKyqe+cuaHTeTyWKsU
	7m9Fj/+jF72dnRNDzGmNbggtxTgKKXKlnOoc4AfMX9NTVAeMG4ZGCnhZ028mQD34gZafKV
	lSPQkq+VVkJB8Nk0Cfpi27r771RtfJU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-ugTQDDQUPpeGExtHfPdu3w-1; Thu, 18 Dec 2025 08:34:04 -0500
X-MC-Unique: ugTQDDQUPpeGExtHfPdu3w-1
X-Mimecast-MFC-AGG-ID: ugTQDDQUPpeGExtHfPdu3w_1766064844
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-430f5dcd4d3so367380f8f.1
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 05:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766064843; x=1766669643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ygbAU5x3T384LKUGynR1xkO6dKCGM4SShqXTIGHAd/Y=;
        b=HW6XzIersBKE2uHmP31voDL9cIkjHLDZlSrAd4pqR6KGR2mcGG+BsH04BmZmOH/jgl
         bABedS7CD3YI+26qCheRo5IcAQb72mmKdj/EEy//1eachvVeMjWiZWjPYiizZS3RX5QW
         YootVVAdTtkO0NtgTbzkzcyDUryrewcluykVCXXu2+vL+VmFNpADqZ/dhxlVS2Io+DRQ
         u7//kBtqR4AHMq5EL8Y78enAe4eb2DO2DyFOFcy6eWoYf2CEDOVNGTdB7sc0oAHmFOVA
         0Ogq2cT0ZGAcPhV5a62di+AqC7KClBI0Fd48P0l3P99VZSIXKSHc0AlmCoFwGx2eengT
         VWiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766064843; x=1766669643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ygbAU5x3T384LKUGynR1xkO6dKCGM4SShqXTIGHAd/Y=;
        b=Ts/qHQmNg4YSxPqAvzAopqEk602MMUpiAdYwQDkCKXcCyhsKX8iqtr+F9RvHwj/crZ
         soAgVlE+Y+qk/k4MxDZHUOI5+KnWUK6jc8YKWfeWPx0LY8yGIvQcb01WfXg8WWeRZJCp
         AhoXcuhtlxg1k3jMeRQbdZlJbOIlo8s3pCFcaIhV42zWHn3a4rRJ+gsCgR8xUt1XBAXy
         GMEfnIIyeWU0yD76P7XE4Pc8fxPqdSleOu2q/07baDXpjxGfG9Fv/3t5rfHrfu5xVM+V
         Q9fbmLRtKLDbRXTzTe6uYwyU+fr8qalrbiGAuunP5UUOH0zYfsckctBvTOF/40sVtVzF
         6r2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWZsFHhf8VBiLcOCG4upcoIRHzIZdSqbk567CXbYkCDDLMumUAEjP/xd9BB5d3KrzQ+Mj0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb87laKuAF5OE4QaEKxQCws83/ZIHpH2RerMA3MCekVPea4pcv
	MMtZU1TLk3m+hElWkjZQ0sv8a7cvDxngKy1oRXpvvA272J3kgss69nxwOyHYXAM49xASEg+MCHM
	p1YrlEEORRF/iIYDfXWMJmCV5j5Ag5A2lY6V/j8pMXERBQiV/uh6plw==
X-Gm-Gg: AY/fxX7USRMhvE5twhXjZttKQxe4nkcYJg9gdSVrGtQHzXm1ilvlfTy+aRpd6bn0APw
	UIXBhkw7Q0iNTo/XzDhiUxFmNAuRdlTdOPexPtP6I9mqBFmp/94YSNb5z7hvhH6wMLRfKy42Kyr
	ppud6zlr9UOPWMBSX9gXNODgWGZUf3c6HJlT7lnF0v/6PXYZ6kiTdxX/TTbdTJaDBKnGtImNTxH
	k5VIqU5NZnwKeJW3XEnSqYJVWue1Z0zUO0rJwkyiJHLDV/y+X8tVR1pVXhmMsUU+0mvwSOaBIcP
	AenM9nj4wpxe9vMQdaWwnOQJRJiCOHDZ4lnilpqbvdJbke0/utnZWXj3HHXAMafUTnc1nA==
X-Received: by 2002:a05:6000:230d:b0:429:b963:cdd5 with SMTP id ffacd0b85a97d-43244795a5amr3553266f8f.5.1766064843472;
        Thu, 18 Dec 2025 05:34:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEIIhtQ63uV7WOn8IreQo+ZbPmGD3G2VFSLJtwjjUHetMozKfXuRebRZihn0OnYhKPteoqFwQ==
X-Received: by 2002:a05:6000:230d:b0:429:b963:cdd5 with SMTP id ffacd0b85a97d-43244795a5amr3553201f8f.5.1766064842951;
        Thu, 18 Dec 2025 05:34:02 -0800 (PST)
Received: from imammedo ([213.175.46.86])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43244998c8asm5239848f8f.30.2025.12.18.05.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 05:34:02 -0800 (PST)
Date: Thu, 18 Dec 2025 14:33:59 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Michael S . Tsirkin"
 <mst@redhat.com>, Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?=
 <philmd@linaro.org>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Thomas
 Huth <thuth@redhat.com>, qemu-devel@nongnu.org, devel@lists.libvirt.org,
 kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org, Richard
 Henderson <richard.henderson@linaro.org>, Sergio Lopez <slp@redhat.com>,
 Gerd Hoffmann <kraxel@redhat.com>, Peter Maydell
 <peter.maydell@linaro.org>, Laurent Vivier <lvivier@redhat.com>, Jiaxun
 Yang <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>, Eduardo
 Habkost <eduardo@habkost.net>, Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, Weiwei Li <liwei1518@gmail.com>, Amit Shah
 <amit@kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>, Yanan Wang
 <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>, Palmer Dabbelt
 <palmer@dabbelt.com>, "Daniel P . =?UTF-8?B?QmVycmFuZ8Op?="
 <berrange@redhat.com>, Ani Sinha <anisinha@redhat.com>, Fabiano Rosas
 <farosas@suse.de>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 =?UTF-8?B?Q2zDqW1lbnQ=?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
 =?UTF-8?B?TWFyYy1BbmRyw6k=?= Lureau <marcandre.lureau@redhat.com>, Huacai
 Chen <chenhuacai@kernel.org>, Jason Wang <jasowang@redhat.com>, Mark
 Cave-Ayland <mark.caveayland@nutanix.com>, BALATON Zoltan
 <balaton@eik.bme.hu>, Peter Krempa <pkrempa@redhat.com>, Jiri Denemark
 <jdenemar@redhat.com>
Subject: Re: [PATCH v5 19/28] hw/core/machine: Remove hw_compat_2_6[] array
Message-ID: <20251218143359.2b3ee268@imammedo>
In-Reply-To: <20251202162835.3227894-20-zhao1.liu@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
	<20251202162835.3227894-20-zhao1.liu@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed,  3 Dec 2025 00:28:26 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> From: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
>=20
> The hw_compat_2_6[] array was only used by the pc-q35-2.6 and
> pc-i440fx-2.6 machines, which got removed. Remove it.
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Igor Mammedov <imammedo@redhat.com>

> ---
>  hw/core/machine.c   | 8 --------
>  include/hw/boards.h | 3 ---
>  2 files changed, 11 deletions(-)
>=20
> diff --git a/hw/core/machine.c b/hw/core/machine.c
> index 27372bb01ef4..0b10adb5d538 100644
> --- a/hw/core/machine.c
> +++ b/hw/core/machine.c
> @@ -290,14 +290,6 @@ GlobalProperty hw_compat_2_7[] =3D {
>  };
>  const size_t hw_compat_2_7_len =3D G_N_ELEMENTS(hw_compat_2_7);
> =20
> -GlobalProperty hw_compat_2_6[] =3D {
> -    { "virtio-mmio", "format_transport_address", "off" },
> -    /* Optional because not all virtio-pci devices support legacy mode */
> -    { "virtio-pci", "disable-modern", "on",  .optional =3D true },
> -    { "virtio-pci", "disable-legacy", "off", .optional =3D true },
> -};
> -const size_t hw_compat_2_6_len =3D G_N_ELEMENTS(hw_compat_2_6);
> -
>  MachineState *current_machine;
> =20
>  static char *machine_get_kernel(Object *obj, Error **errp)
> diff --git a/include/hw/boards.h b/include/hw/boards.h
> index a48ed4f86a35..5ddadbfd8a83 100644
> --- a/include/hw/boards.h
> +++ b/include/hw/boards.h
> @@ -882,7 +882,4 @@ extern const size_t hw_compat_2_8_len;
>  extern GlobalProperty hw_compat_2_7[];
>  extern const size_t hw_compat_2_7_len;
> =20
> -extern GlobalProperty hw_compat_2_6[];
> -extern const size_t hw_compat_2_6_len;
> -
>  #endif


