Return-Path: <kvm+bounces-66269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 47108CCC35E
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 15:14:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B21BF307F607
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 14:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4528F34C822;
	Thu, 18 Dec 2025 14:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XE1+dnEr";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nlk528FB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A9934C145
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 14:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766066687; cv=none; b=TakrDDPvsjZrRJrji1KGDcVxrYaW3suAoHu2I0JEyxJ+X1MyZj4NFxvpf6dZgTY3lRDN+p0A8NPtFtGX6J4st7Z9Q6aTHB30vnVQ4QnosKbwl5No5BefxJw0rh3XNY0A8LLHUhXkcfn+2q9Jl+p+OTFqCRhVP0xmlLdqun+jc1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766066687; c=relaxed/simple;
	bh=chtqE8ZGBuCQhXfG44YiDPHcc6HOHCXqjofe8wcWV7k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EqN3qZqnFNNcAZWSFNXNZs0Vy/tBl3B+bFOb5Ec0N6rK7XS/BP6vcvHLYk+I7c0H4imU5CB4ZL3b0FG/lDnSXJAh88Z2ku8RVnE8jmm1y+i+YYSjILW1l8dsDwoI8RGgV6j+vgEiLYzX7SC5DQQ1+WLnQTgBJXsdKI0V9wQEnDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XE1+dnEr; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nlk528FB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766066683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LZa/LONa7ZGo/OqCKXVn4+AcaCSwo5WF//FIZlqUxgs=;
	b=XE1+dnErLjsbpLNK5qMOsTTDC+yNMwO7oY6zWgRYEd5H17j84moFAZjzrHxChayDK4Ub75
	3EIpP5loU1y3zd+JLol9RHaP/cJ1OH5oBqx2JNA70vsxC3/kM6VdbQgiO4Xt//7MxY1H0x
	hIqyIbC5ekONnJeRfaIzdRLiaswOFFM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-426-frOEsdm8MAa1nic5cEkhbg-1; Thu, 18 Dec 2025 09:04:41 -0500
X-MC-Unique: frOEsdm8MAa1nic5cEkhbg-1
X-Mimecast-MFC-AGG-ID: frOEsdm8MAa1nic5cEkhbg_1766066681
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430fcf10287so550703f8f.0
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 06:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766066681; x=1766671481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LZa/LONa7ZGo/OqCKXVn4+AcaCSwo5WF//FIZlqUxgs=;
        b=Nlk528FBXuC45OpsDqxcKhk/xi9DpoPun6T7tS9spr+4U47l7xTa16z45sqLNWQJTI
         VsyGBtNYIn2uxJXBia19Yc8ZamGFB2THqCc2Nq3PmQ4b8ZJI7uYsEqNp6fyH6eKoIZHK
         2D0kM27csYOZjycvMAKkhr2GgbyVbvQ3AcEZ1pgCEBvgjiq3O/vJdpKtdGWxTEafd6G1
         T8wkD2hAS1TKHbJ9eolJp9ra4dtfM+SW87VXS+IlBIsHK6A0eurljLTvJmzpTT44GWSE
         a0tPvEqrWD14FjlXt5R5GIpwspuTUzPSsdVj6ZVmjT2cAfn2GeCL0DIDzZWlMA/FKNBL
         GA1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766066681; x=1766671481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LZa/LONa7ZGo/OqCKXVn4+AcaCSwo5WF//FIZlqUxgs=;
        b=X+/65qIDPt4ywM2UELfujDYagqAF70/giJkSs9xtLSC5cumvu3NiDMRNFxw3DYLTW5
         VyI0QEsgMcOj2YNmjPgKI2vfWUVW/LL504uTlqeQZ29pEdmovZoxg2SUQThQolr30PtL
         hJC1WOhcLWH8TeEOBJ1LFVd01B+JBN6hh2ggraiJXfp1pKVuq6o25z8xPRDPSHuD65Yy
         Wn5ccdV2PlrKKbFFvYJGe4BC8w7gopci1iIK7ElTGB5+L4kQqyfRP+CbOzCkSxbI00KY
         kyVS6BZxBOjseldKDxv3h46wIbS/Wg0CDHaI8oNySeYAabsZXimInyVrAie4/h1YUEGU
         TwsQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+DROcjooWG4dP6GwhmlSS3wnnZGvqsCIjIWJ+0zsM6Tvd4L+W45d7YWhzQ0w8Rrk7amc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRELr/nrmtDOI7MCiuL5kUw1gptTyBaZxfiqj/6qQOatBn5rht
	OiaglzyUnNgcvKhzQb/z1svfQxyJT9jF9gtJeWNcpQ7dvmP8fN7t7mq2rsvz+GK/uB4KwobPAQ2
	ICyWbm7nV9dEwMD3qll9vmIrdnHCQQfZk704SPuFMIxAcjcgmWBjn9A==
X-Gm-Gg: AY/fxX7TLJMAsV4/tsd7gsKdnz/x1jIU3PQ8GE6JGjouep4AIJ1uKhmJWWQT7gVDuI5
	PIqgcVjwwoTy5tBjvwzpMY4RSUKVpg4aB+2Rb8H7KxjHz6rjxU8rq4Ti1UGVDhb0PU+xSH1mZOx
	hPP+1wx9AfCXdBMjftpxNx9SFdbBo3qeELA1vxwWkgrvB/jImVOGB3EtreADYmQCKrZxUYQn96i
	G57qbIw9DhIon0VEBFzUQLKH87UDyXTenoU9B2q2+CCQU8QH4aJwOayNnzcKPwxoCVXTGHY9iEb
	R2ttXIG+04Iw2ZMkmqWj59pAGgKJsEKCHWqt1OdaQxwBJ91rgLZh/SBQVUH44bTjPLDfbA==
X-Received: by 2002:a05:6000:4024:b0:431:35a:4a8f with SMTP id ffacd0b85a97d-431035a4cdbmr13030595f8f.47.1766066680504;
        Thu, 18 Dec 2025 06:04:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG5sI4sfzxmpDw2vWdy5N6JNiW5EGUAYBc3RmsncYQrOquL+EF//rXIjYGO/naLgvGUOz66hg==
X-Received: by 2002:a05:6000:4024:b0:431:35a:4a8f with SMTP id ffacd0b85a97d-431035a4cdbmr13030504f8f.47.1766066679952;
        Thu, 18 Dec 2025 06:04:39 -0800 (PST)
Received: from imammedo ([213.175.37.14])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43244998c8asm5391292f8f.30.2025.12.18.06.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 06:04:39 -0800 (PST)
Date: Thu, 18 Dec 2025 15:04:36 +0100
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
Subject: Re: [PATCH v5 25/28] hw/core/machine: Remove hw_compat_2_7[] array
Message-ID: <20251218150436.5bb926cc@imammedo>
In-Reply-To: <20251202162835.3227894-26-zhao1.liu@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
	<20251202162835.3227894-26-zhao1.liu@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed,  3 Dec 2025 00:28:32 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> From: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
>=20
> The hw_compat_2_7[] array was only used by the pc-q35-2.7 and
> pc-i440fx-2.7 machines, which got removed. Remove it.
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Igor Mammedov <imammedo@redhat.com>

> ---
>  hw/core/machine.c   | 9 ---------
>  include/hw/boards.h | 3 ---
>  2 files changed, 12 deletions(-)
>=20
> diff --git a/hw/core/machine.c b/hw/core/machine.c
> index 0b10adb5d538..f3e9346965c3 100644
> --- a/hw/core/machine.c
> +++ b/hw/core/machine.c
> @@ -281,15 +281,6 @@ GlobalProperty hw_compat_2_8[] =3D {
>  };
>  const size_t hw_compat_2_8_len =3D G_N_ELEMENTS(hw_compat_2_8);
> =20
> -GlobalProperty hw_compat_2_7[] =3D {
> -    { "virtio-pci", "page-per-vq", "on" },
> -    { "virtio-serial-device", "emergency-write", "off" },
> -    { "ioapic", "version", "0x11" },
> -    { "intel-iommu", "x-buggy-eim", "true" },
> -    { "virtio-pci", "x-ignore-backend-features", "on" },
> -};
> -const size_t hw_compat_2_7_len =3D G_N_ELEMENTS(hw_compat_2_7);
> -
>  MachineState *current_machine;
> =20
>  static char *machine_get_kernel(Object *obj, Error **errp)
> diff --git a/include/hw/boards.h b/include/hw/boards.h
> index 5ddadbfd8a83..83b78b35f2bf 100644
> --- a/include/hw/boards.h
> +++ b/include/hw/boards.h
> @@ -879,7 +879,4 @@ extern const size_t hw_compat_2_9_len;
>  extern GlobalProperty hw_compat_2_8[];
>  extern const size_t hw_compat_2_8_len;
> =20
> -extern GlobalProperty hw_compat_2_7[];
> -extern const size_t hw_compat_2_7_len;
> -
>  #endif


