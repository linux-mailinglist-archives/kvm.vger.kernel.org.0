Return-Path: <kvm+bounces-66260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id BAE45CCC13A
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 14:45:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8D448302A7A0
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 13:45:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0371033711E;
	Thu, 18 Dec 2025 13:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V8hlKqG1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="W9l4aEQI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DDD336EF9
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 13:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766065508; cv=none; b=DdsJpel21DlugUZHQDEW94y0gV5YfICsq57sLr9fcFRmLqayOWAls3qi8iYKr78UYape4bBNcEgSyCs0zeUA6IO6IbpCrAasUwNylFDLVMSjQ0dzbIrR9kePk2YvQTLT8vesIbcR0lMlbo0yJMR6Gx/7xre+q04WokjHXvu7xUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766065508; c=relaxed/simple;
	bh=R1dwmLPfeJnDBQH30WEzrx/FdFVQRHG+tdcGWzTjeYc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=itRuSMJoJ8PXREjDXW4nxcnpCUfImsKJ6GzGRvKuDC/Z86UZjll6JwZGAHoDAZD3UydhI4y1P6q/s/TiWWU08A6X/xj9oCIU3/4rmByd1/Bz2E/WgnyCUALQkHlGJpSCGkxVgOoanvijltpekLlzOEyREfBLvWf2IQEHR7POEXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V8hlKqG1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=W9l4aEQI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766065504;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OcGyhvdq0kxqwUU4NFVOHDluMCKeql1WmgcW9G4ZFcU=;
	b=V8hlKqG1nvnT4gbFBKnDpUphMXwqS1YlE+s1JHNxRkzibnyJpTJIZ/ASwNzeDRBXTOYepG
	cIqGtTHCZ4jKgjh/L+31Windj1uhTduW5EF8OMojE34KksZC5V/Zhnt041M1YljYG8THZF
	sasiOCscJHRtXBtobPHgoZeM4N67tfY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-5e9wn8KgMQyRC3rU_WawdQ-1; Thu, 18 Dec 2025 08:45:03 -0500
X-MC-Unique: 5e9wn8KgMQyRC3rU_WawdQ-1
X-Mimecast-MFC-AGG-ID: 5e9wn8KgMQyRC3rU_WawdQ_1766065502
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42fb1c2c403so464238f8f.3
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 05:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766065502; x=1766670302; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OcGyhvdq0kxqwUU4NFVOHDluMCKeql1WmgcW9G4ZFcU=;
        b=W9l4aEQImuVCBi5lubdHSiPYid2BTvfgTXuEnbzz7ZPxKjRMCzT577DWEPBtE8vO1k
         HrAMBiUzqByFopKonHBlpOG1tAUMTQVMXgwvyWLJUWNF/KNqDVKd2C4XACkdFTJylPtz
         7MdBPDNPBEam8E1ennvu9h8TLu4gAGwkgKKq0tZb7+VzcewLT/r2kEovby4ns5rlk9xw
         2H9zQQ/zJZRO2Q94qXdXo6vB6j/wO2n9jgMVtA9Ozv5HUGk13AXZFHHPBzUu9mNjbgJ7
         Ec7KjCnBp2/BpemzFus4lkifiN8+mgJJPK9E+1BvykB2VNMx2WfgoRtH5rrQdGy7chvd
         58Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766065502; x=1766670302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OcGyhvdq0kxqwUU4NFVOHDluMCKeql1WmgcW9G4ZFcU=;
        b=CysuBR6PHPX/oYf58Fk8x9jonlBp0RKVqIeWWgn2ZgL9rjk9d0Fu8N6Q0XbJwUSGI7
         YZL/DygsjBlLXN9/kUisYH5F87DpgJVWevWbVw7DT3jN9sG59gRZihP261B83Cgp+hYL
         Yz10im1evvo1a26aFNa9bfPPTYDo3JPlfeArynaGhkELaAPnGVAp7Pi9mxEcy7ihi+tT
         hqwSBAYFH3O2SH1FNnvEpQCXn6hHmnREDaqiKlP/3e54lvNqTj4GaeJZXjxMzKyaMk8A
         Qq16GySAhcUlpwvrzGiKxL09ROjhlYQKMXLGZ7ZTpvh4aqKIgoIsFfypxUUfiUG9kGxQ
         brLg==
X-Forwarded-Encrypted: i=1; AJvYcCVWwG69cNiPBV3Z688bIaHXIcPddBzgECxYA/ys8FwIjBt0VMUnCj5vgTM/0/J1eGhLzLY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNiScx+GBgtxlK5l73ha/HkvqCcd9k45aX4pEpbA2QWb3jTSQD
	0ojqqss2eiABkgCnS0jkq1tDKCzPtYkF2jtjPro2dYMdcBfEcbRYkniOENvcw5wD8PvxnveegM5
	7TElpJCYzi/BesD2dYEQEIaH+e3GZX/IifMB18SeZP+W+LRyaW61GSw==
X-Gm-Gg: AY/fxX7/ZbFfXe4DsIsdwr97zCqVSAh3JTp/GsOtVJhu6hfQo5grWiE5+n1TK2vJ0VN
	VKnl0MuICCoVa/KW41ELceNgymaJG4yFMOf7+IrQHayA5lGqJTK5vEIlpALbzdyCbAQZYMS9jDJ
	3b1MY3hW0sUEdhmNnEI3aKBY7HeGMFCXUm59H0HiHQHTRJtqq2KlcRx7X2gGdey6qTs1xT++lAI
	DwOgMiOhKTpHLss1WSwawu48Ee9cHXVAXC+uxbI6GNQ0DTzMYg6QjNNju6/dtcMUS2BVgWyfpDT
	gzx3XB1fShS0ieHvSmmgRYHzwlZb2SSIfDMQk8k/JVXvvQRqEZPJ6SsxCm5QJAMtqMtVdA==
X-Received: by 2002:a5d:64e8:0:b0:430:f6bc:2f8b with SMTP id ffacd0b85a97d-430f6bc3221mr18155844f8f.45.1766065502176;
        Thu, 18 Dec 2025 05:45:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHnEeHyuc3XOw+0zv5jgfMxc4yPA83Oi7haKTTABOLc0orXoBwjLhHFxyrb01vSj4hp1xkXJg==
X-Received: by 2002:a5d:64e8:0:b0:430:f6bc:2f8b with SMTP id ffacd0b85a97d-430f6bc3221mr18155764f8f.45.1766065501002;
        Thu, 18 Dec 2025 05:45:01 -0800 (PST)
Received: from imammedo ([213.175.46.86])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324493fda5sm5264021f8f.17.2025.12.18.05.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 05:45:00 -0800 (PST)
Date: Thu, 18 Dec 2025 14:44:58 +0100
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
Subject: Re: [PATCH v5 22/28] hw/i386/pc: Remove pc_compat_2_7[] array
Message-ID: <20251218144458.1b6b3b40@imammedo>
In-Reply-To: <20251202162835.3227894-23-zhao1.liu@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
	<20251202162835.3227894-23-zhao1.liu@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed,  3 Dec 2025 00:28:29 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> From: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
>=20
> The pc_compat_2_7[] array was only used by the pc-q35-2.7
> and pc-i440fx-2.7 machines, which got removed. Remove it.
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Igor Mammedov <imammedo@redhat.com>

> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  hw/i386/pc.c         | 10 ----------
>  include/hw/i386/pc.h |  3 ---
>  2 files changed, 13 deletions(-)
>=20
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index 85d12f8d0389..b88030bf50d0 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -253,16 +253,6 @@ GlobalProperty pc_compat_2_8[] =3D {
>  };
>  const size_t pc_compat_2_8_len =3D G_N_ELEMENTS(pc_compat_2_8);
> =20
> -GlobalProperty pc_compat_2_7[] =3D {
> -    { TYPE_X86_CPU, "l3-cache", "off" },
> -    { TYPE_X86_CPU, "full-cpuid-auto-level", "off" },
> -    { "Opteron_G3" "-" TYPE_X86_CPU, "family", "15" },
> -    { "Opteron_G3" "-" TYPE_X86_CPU, "model", "6" },
> -    { "Opteron_G3" "-" TYPE_X86_CPU, "stepping", "1" },
> -    { "isa-pcspk", "migrate", "off" },
> -};
> -const size_t pc_compat_2_7_len =3D G_N_ELEMENTS(pc_compat_2_7);
> -
>  /*
>   * @PC_FW_DATA:
>   * Size of the chunk of memory at the top of RAM for the BIOS ACPI tables
> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
> index f8f317aee197..accd08cb666b 100644
> --- a/include/hw/i386/pc.h
> +++ b/include/hw/i386/pc.h
> @@ -292,9 +292,6 @@ extern const size_t pc_compat_2_9_len;
>  extern GlobalProperty pc_compat_2_8[];
>  extern const size_t pc_compat_2_8_len;
> =20
> -extern GlobalProperty pc_compat_2_7[];
> -extern const size_t pc_compat_2_7_len;
> -
>  #define DEFINE_PC_MACHINE(suffix, namestr, initfn, optsfn) \
>      static void pc_machine_##suffix##_class_init(ObjectClass *oc, \
>                                                   const void *data) \


