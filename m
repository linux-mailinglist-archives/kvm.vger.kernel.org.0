Return-Path: <kvm+bounces-46070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C1C7AB1838
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 17:19:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99ED43AF7F4
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 15:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0449621A453;
	Fri,  9 May 2025 15:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GacPWxba"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3DA136672
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 15:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746803938; cv=none; b=jPaF6LuB/T/8HVOzupEw6pO7mXdmgai28ueYn9M2460rlxaomrjRhCVfLF/R41LZWXJvSbUYmQEjYFnj2vJNxfHH3VUfV/9eI/cTY4UV+SMOMugxMt2Oi4Onl/X85fYI2cAk/Q+LPLv8Ucn1DPoH8IR5orelt1wOYnN+ZFh9FoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746803938; c=relaxed/simple;
	bh=HBdoc9Az3vRxvff1IsTBEU6XN0P2xNzhpvQHB8W8ri4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qvWWJn4JVpa1Z70wQFkB/x5pNb9F7jvNdScbvB32W1YYBl05M4cTpfVo8OmhArbAqddKnMDMETNKqCvTQtmImQkCJBOW0Lwv+huXaX5FHY4ZfptDNU7zufyCHuL6qCnhnIwuqLx731Lo0U58uvBX1BDK2aj2UGcot5iV7WYfgZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GacPWxba; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746803935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JWJim7G+Siwefyo++b2WmY1msvaLlI1d6zRqWaOxyzA=;
	b=GacPWxba1Y89sCV3W0IMTE3lHzkxH8HNXifB+jQITMdfVwb3GwmfR5wQ25qwGEERvOd94I
	ETqns+J2+vqW1ccq/7riHCBb1VSPgVh0iZm1NDqedjrvufkm17ve9Txlg5CZA0jL01h8PH
	jzuSwOMQq7vGisyQ2wcAkL46xVAHNMQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-248-WOubEPUUNii3PXu_m0CbBg-1; Fri, 09 May 2025 11:18:53 -0400
X-MC-Unique: WOubEPUUNii3PXu_m0CbBg-1
X-Mimecast-MFC-AGG-ID: WOubEPUUNii3PXu_m0CbBg_1746803932
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-442d472cf7fso10641175e9.3
        for <kvm@vger.kernel.org>; Fri, 09 May 2025 08:18:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746803932; x=1747408732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JWJim7G+Siwefyo++b2WmY1msvaLlI1d6zRqWaOxyzA=;
        b=KAdX2HGXstf9P2SVc40SIRFjAlq0LVvP7u4kXzaABro4hmuGHvqJLQPNYW40TVP30o
         vFv2AyK+dkfCpANU8UCBgbyNzU8hPiNWsWcDpoZyLUX8PsiKbI64ZZJGZSIim7wbZ0VP
         LNKERCwRvmLAVZzM73/02jfcpx57/8/FuivwTLYbYBKv6mu9KUSYpT0l31SVb8eK/92E
         yT+ZTNPsjr7xF/DT+BcgSowAGnx/5ygcHs4lpTTNa3bamx14PoagmRJRS2EcDHZBv7Pd
         2XWjcmmsUENG/hCuS5j7I07zkd3Hy94ObFhgoPoYMzmGbqWMBpW1XTlUL1Mrtp7qIiAw
         0LiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNs2E8jcL34aeb+FrXpVBdXtax+vtGH0eu30GEUf9FjSwSYgGDEyBKjjbp/BnGBFGBMYU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJaJPybO5Q6MDlQZl8R7xN+dIWRxfkC9bhlec9aviWLW2NffEF
	+QKIpY1h2VJrXioKNVoX9kO+5Jl6Uf0eIdLcpS0J5PX7o/lzqmW7CMLy16QGvC6hl0JlRM51tO6
	pvCYHcmDja04A9FADNzUNzHWOsyOnGD6qDJRCcXuXxB9a1RCGwA==
X-Gm-Gg: ASbGncsr8YDVGgiF4n9Hj9HzDzmQwAEsFB7sv+oxLve5hOpA76Ctq/8eh0t2O4eFlHp
	a1RcvuIY+A0vNt4WplcGc0bdI2LjqR8voVyK/XihuAZHBbrzWxcffE0aVebRSYEPt0raATKzU25
	I/is+jDFd5Sp5nJFMSgsSZiLfPJhiD9oJzxkOqKC7F0aw53Wd9SLUImLi7/NhXX8WyhJohi9Uq6
	aMA3J+aLB/BDJT2eCv8AqKaQNv+fDzwgYgd9Ype2VVJ+e2X5+k6ymuJ6kR5Y1IJZgCa4fM9vwuL
	421kujvRpH8ugr1ZZIM4ZPJyvBpiCkLE
X-Received: by 2002:a05:600c:6487:b0:43d:7a:471f with SMTP id 5b1f17b1804b1-442d6d5d178mr32661355e9.18.1746803932375;
        Fri, 09 May 2025 08:18:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGWV3J6bpvPo+qOaKHJGbLAXu3HltVy9Aw1OV77LyApiIBOyXHQKhK2ndFIELG8bCn3yooizQ==
X-Received: by 2002:a05:600c:6487:b0:43d:7a:471f with SMTP id 5b1f17b1804b1-442d6d5d178mr32660905e9.18.1746803931902;
        Fri, 09 May 2025 08:18:51 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d67d5c35sm33173825e9.5.2025.05.09.08.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 08:18:51 -0700 (PDT)
Date: Fri, 9 May 2025 17:18:47 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
 kvm@vger.kernel.org, Sergio Lopez <slp@redhat.com>, Gerd Hoffmann
 <kraxel@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Laurent
 Vivier <lvivier@redhat.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu
 <yi.l.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, Eduardo
 Habkost <eduardo@habkost.net>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, qemu-riscv@nongnu.org, Weiwei Li
 <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>, Zhao Liu
 <zhao1.liu@intel.com>, Yanan Wang <wangyanan55@huawei.com>, Helge Deller
 <deller@gmx.de>, Palmer Dabbelt <palmer@dabbelt.com>, Ani Sinha
 <anisinha@redhat.com>, Fabiano Rosas <farosas@suse.de>, Paolo Bonzini
 <pbonzini@redhat.com>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 =?UTF-8?B?Q2zDqW1lbnQ=?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
 qemu-arm@nongnu.org, =?UTF-8?B?TWFyYy1BbmRyw6k=?= Lureau
 <marcandre.lureau@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, Jason
 Wang <jasowang@redhat.com>, Mark Cave-Ayland <mark.caveayland@nutanix.com>,
 Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v4 02/27] hw/i386/pc: Remove
 PCMachineClass::legacy_cpu_hotplug field
Message-ID: <20250509171847.0b505c96@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250508133550.81391-3-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-3-philmd@linaro.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  8 May 2025 15:35:25 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> The PCMachineClass::legacy_cpu_hotplug boolean was only used
> by the pc-q35-2.6 and pc-i440fx-2.6 machines, which got
> removed. Remove it and simplify build_dsdt(), removing
> build_legacy_cpu_hotplug_aml() altogether.
>=20
> Note, this field was added by commit 679dd1a957d ("pc: use
> new CPU hotplug interface since 2.7 machine type"):
>=20
>  >  For compatibility reasons PC/Q35 will start with legacy
>  >  CPU hotplug interface by default but with new CPU hotplug
>  >  AML code since 2.7 machine type. That way legacy firmware
>  >  that doesn't use QEMU generated ACPI tables will be
>  >  able to continue using legacy CPU hotplug interface.
>  >
>  >  While new machine type, with firmware supporting QEMU
>  >  provided ACPI tables, will generate new CPU hotplug AML,
>  >  which will switch to new CPU hotplug interface when
>  >  guest OS executes its _INI method on ACPI tables
>  >  loading. =20
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  include/hw/acpi/cpu_hotplug.h |   3 -
>  include/hw/i386/pc.h          |   3 -
>  hw/acpi/cpu_hotplug.c         | 230 ----------------------------------
>  hw/i386/acpi-build.c          |   4 +-
>  4 files changed, 1 insertion(+), 239 deletions(-)
>=20

...

> diff --git a/hw/i386/acpi-build.c b/hw/i386/acpi-build.c
> index 3fffa4a3328..625889783ec 100644
> --- a/hw/i386/acpi-build.c
> +++ b/hw/i386/acpi-build.c
> @@ -1465,9 +1465,7 @@ build_dsdt(GArray *table_data, BIOSLinker *linker,
>      }
>      aml_append(dsdt, scope);
> =20
> -    if (pcmc->legacy_cpu_hotplug) {
> -        build_legacy_cpu_hotplug_aml(dsdt, machine, pm->cpu_hp_io_base);
> -    } else {
> +    {
>          CPUHotplugFeatures opts =3D {
>              .acpi_1_compatible =3D true, .has_legacy_cphp =3D true,
                                           ^^^^^
that still leaves legacy CPU hotplug hardware around, which we should remove
at the same time as legacy AML.

i.e.:
  drop _INI in hw/acpi/cpu.c
  and at the same time replace legacy_acpi_cpu_hotplug_init() at call sites=
 with
  cpu_hotplug_hw_init()
  after that you can safely remove legacy_cpu_hotplug and no longer needed =
hw/acpi/cpu_hotplug.c && co


>              .smi_path =3D pm->smi_on_cpuhp ? "\\_SB.PCI0.SMI0.SMIC" : NU=
LL,


