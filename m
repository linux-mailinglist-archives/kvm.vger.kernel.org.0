Return-Path: <kvm+bounces-66273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5070ACCC50E
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 15:41:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5AC0230E8E9F
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 14:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 321202C0298;
	Thu, 18 Dec 2025 14:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="heF1tdcw";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="T3YYilAw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981892D8362
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 14:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766068013; cv=none; b=tW/y3YwGj4EgWNUe7XAFRPG2q8DfAm/+qArUAWl+WpOpB3lKAd9b/B3/KssqWqGJ3SkbTNyKz4f5IxHt/h9LIRF7qhWqsX3u66w2g40DpIsTRDgFSVHsVMvNAZxGLhSUJ511mtk4HUOEcYQuSuN7YJ5zzgH7y0Wd2hBw9ryy6tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766068013; c=relaxed/simple;
	bh=J2cxRxMHXxP2BsbqA3Yioi0x9025MueiADfn0TYqfC0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qGI6GHR7mYkxrNYgq3ZXrTeqh0Cr/VjIgAfV3pEhJ7TMUS8LEcyBTSIUotXsuSrXtkVTdwGwlfQ683xU0NFMpeCnbR6jmfq+GFhRrTNuGyHoOUlSM7sDgjpK50K+f8bELg0NGY9lKvL8U3NGs/b0VW8YeUm/jUhQL9Q7ZjB76tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=heF1tdcw; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=T3YYilAw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766068008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=82hiJN0/5F2+dRtrDEgVb12FI+OynQXRA4CdmhTgEHQ=;
	b=heF1tdcwbMTD59v9CytuaT3AoxixjUXWCqq8uP2oW6TEtN5tW2NLwIYInJ0nYB/32LNe++
	ATlTOZqT6M8iTzv/EkgulSWl56BgX7uiqZaHG6DvbyMF6peYdPAHuqBd036iQrM2aun7uY
	9kGrsfE/iRMzNSf55uo4JpJFRejaQzc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-446-PqnBKRUJNMWHzfpN-h4vKg-1; Thu, 18 Dec 2025 09:26:47 -0500
X-MC-Unique: PqnBKRUJNMWHzfpN-h4vKg-1
X-Mimecast-MFC-AGG-ID: PqnBKRUJNMWHzfpN-h4vKg_1766068006
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-b800559710aso55498966b.3
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 06:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766068006; x=1766672806; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=82hiJN0/5F2+dRtrDEgVb12FI+OynQXRA4CdmhTgEHQ=;
        b=T3YYilAwhm3Z0sVAymEk1OBZsUXs9MTckbO+77qw+m0UCsyHLrW2ZBtuS2yMUqncTT
         10RgsW/OnxRjYuObwchgwV9Lu3pqHHBWTRYBdZYvNfCZncwiulOl5ARPD5AoRRVua+3M
         kzMon+zoVMREaEqMxW7KMIVuw17QlGQeemBlKxCM9yerCkJH4GQ3B3/7U0joagVNzJtf
         aB0dfZpMB5whIvUztBTQZAnw4zHrlQfKJP58C2o678EH5ySgKh3Qnh7TAwmTuL9ot9jH
         zR9jg+hOLq0nNNf7+0ZO1y2KM5/9n+Nk6FOkxEzAZ65/exsIQDjB95AQpBNhAMR5oJXH
         CkAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766068006; x=1766672806;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=82hiJN0/5F2+dRtrDEgVb12FI+OynQXRA4CdmhTgEHQ=;
        b=uw2XIfvh1j5BCKDtEFADLV5yOhBp/y5bnc2qThPi+6BaVtHhWYBSnnyjTdjneewnUb
         jGkUuI31LiWC46f91IG/dDCi5JOOlexTqAqiJciPLwTMDPQaURqHBnwcFxiDYhzXnY/p
         dxB1TWs1LPmwFX8rpw5uChBTG64XhA9B9tLUVWZ9HuX1BMOQjNj32kKKUBz+D5+f4rlX
         V+HMpjpaVJWbZm1UWwuqWtM2qqQDjJr0SmTUVb+K3gUulIbXRqFkhgnXoYgKolMlyoO0
         OlRnHuuL8Sq3qaRCHn74B4e8wc5X3e757WQntz23+z7YWSCF+3HychnkBmKzkJ+ErIEB
         LXmw==
X-Forwarded-Encrypted: i=1; AJvYcCVFXcL6lf4ZBCmeC8hOHLD/ZBYb7arWWPHwzyF+vUrSIn1y7AIf6SArTMuljzbKrpkKVck=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp2iXcc/3aG1BK4kkXI27H0G/T8U+rqRch3P4tkmcoH8W1q5OT
	jsuWJoJHUnN6C5Pwr9PfdsjgiowChDCAhpP3s3DFV7BJ0Rzfn2djdN7NjjG581Xet5it63Iqsqe
	GAC6S3xebyF7yV4eNa72goRn6uPIQqGT+Eo4o/2YArkK390htOviUUg==
X-Gm-Gg: AY/fxX5TavbwngS6Tb33vTBTwDQz70OHYs/w+EgQe6iQJiiPjilef8hfxF/EKNkudvD
	Tl9rt7xbds6dFPeXMqUGMzCfdZQ7tKSQ9TpCSHjQOZyUjrEI8NFcTBM9xSfoWgRigGLwNXu4m57
	WluRje/cMCLbqAsO6MoPtrGEBrjHuVdF37HS/nxb41FR6Ex28kwz6MgH4lGcXB4ueE4jaPsljeM
	Bgi00BaEy1LENeTIkEg0/927L3v+dbpuli+yiZR1tx7VeGgCbJqZ7+gTAa+IDh9ltZcMS3EYhSM
	GmuuspEYOaQN2IvpXaSqs+w0aqRDR8BG0C8Oqp+aRx764vPd7LTrur3smQNVcjBiy71jAQ==
X-Received: by 2002:a17:907:2d89:b0:b73:8639:cd96 with SMTP id a640c23a62f3a-b7d23668f88mr2273369066b.24.1766068005913;
        Thu, 18 Dec 2025 06:26:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEz69NP3JT0pAAUlXIjoFd1NFW/0F7KYZI/65Y+y5uNeHQ2bp0ZijtV0N1YN8UJawKqiCLYCg==
X-Received: by 2002:a17:907:2d89:b0:b73:8639:cd96 with SMTP id a640c23a62f3a-b7d23668f88mr2273365566b.24.1766068005406;
        Thu, 18 Dec 2025 06:26:45 -0800 (PST)
Received: from imammedo ([213.175.37.14])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b80234a2ee4sm238557166b.57.2025.12.18.06.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 06:26:44 -0800 (PST)
Date: Thu, 18 Dec 2025 15:26:41 +0100
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
Subject: Re: [PATCH v5 28/28] hw/char/virtio-serial: Do not expose the
 'emergency-write' property
Message-ID: <20251218152641.007ddd92@imammedo>
In-Reply-To: <20251202162835.3227894-29-zhao1.liu@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
	<20251202162835.3227894-29-zhao1.liu@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed,  3 Dec 2025 00:28:35 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> From: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
>=20
> The VIRTIO_CONSOLE_F_EMERG_WRITE feature bit was only set
> in the hw_compat_2_7[] array, via the 'emergency-write=3Doff'
> property. We removed all machines using that array, lets remove
> that property. All instances have this feature bit set and
> it can not be disabled. VirtIOSerial::host_features mask is
> now unused, remove it.
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Igor Mammedov <imammedo@redhat.com>

> ---
>  hw/char/virtio-serial-bus.c       | 9 +++------
>  include/hw/virtio/virtio-serial.h | 2 --
>  2 files changed, 3 insertions(+), 8 deletions(-)
>=20
> diff --git a/hw/char/virtio-serial-bus.c b/hw/char/virtio-serial-bus.c
> index 673c50f0be08..7abb7b5e31bf 100644
> --- a/hw/char/virtio-serial-bus.c
> +++ b/hw/char/virtio-serial-bus.c
> @@ -557,7 +557,7 @@ static uint64_t get_features(VirtIODevice *vdev, uint=
64_t features,
> =20
>      vser =3D VIRTIO_SERIAL(vdev);
> =20
> -    features |=3D vser->host_features;
> +    features |=3D BIT_ULL(VIRTIO_CONSOLE_F_EMERG_WRITE);
>      if (vser->bus.max_nr_ports > 1) {
>          virtio_add_feature(&features, VIRTIO_CONSOLE_F_MULTIPORT);
>      }
> @@ -587,8 +587,7 @@ static void set_config(VirtIODevice *vdev, const uint=
8_t *config_data)
>      VirtIOSerialPortClass *vsc;
>      uint8_t emerg_wr_lo;
> =20
> -    if (!virtio_has_feature(vser->host_features,
> -        VIRTIO_CONSOLE_F_EMERG_WRITE) || !config->emerg_wr) {
> +    if (!config->emerg_wr) {
>          return;
>      }
> =20
> @@ -1040,7 +1039,7 @@ static void virtio_serial_device_realize(DeviceStat=
e *dev, Error **errp)
>          return;
>      }
> =20
> -    if (!virtio_has_feature(vser->host_features,
> +    if (!virtio_has_feature(vdev->host_features,
>                              VIRTIO_CONSOLE_F_EMERG_WRITE)) {
>          config_size =3D offsetof(struct virtio_console_config, emerg_wr);
>      }
> @@ -1156,8 +1155,6 @@ static const VMStateDescription vmstate_virtio_cons=
ole =3D {
>  static const Property virtio_serial_properties[] =3D {
>      DEFINE_PROP_UINT32("max_ports", VirtIOSerial, serial.max_virtserial_=
ports,
>                                                    31),
> -    DEFINE_PROP_BIT64("emergency-write", VirtIOSerial, host_features,
> -                      VIRTIO_CONSOLE_F_EMERG_WRITE, true),
>  };
> =20
>  static void virtio_serial_class_init(ObjectClass *klass, const void *dat=
a)
> diff --git a/include/hw/virtio/virtio-serial.h b/include/hw/virtio/virtio=
-serial.h
> index 60641860bf83..da0c91e1a403 100644
> --- a/include/hw/virtio/virtio-serial.h
> +++ b/include/hw/virtio/virtio-serial.h
> @@ -186,8 +186,6 @@ struct VirtIOSerial {
>      struct VirtIOSerialPostLoad *post_load;
> =20
>      virtio_serial_conf serial;
> -
> -    uint64_t host_features;
>  };
> =20
>  /* Interface to the virtio-serial bus */


