Return-Path: <kvm+bounces-66259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AAFC5CCC16A
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 14:47:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1C7DE306EF7A
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 13:43:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D44F334C0A;
	Thu, 18 Dec 2025 13:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fA2TPvVZ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PQnVVoPn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E537A3328F0
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 13:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766065426; cv=none; b=JXn7zoFCCRnni9HbN6D6i13B4TCtEzDYdBPNQapinxdB//NshieUoCzpV0ED2LojxvnAKDfvKVaZH9RnbMDncYoTs9lTBGPYoX1LWtlNiAY6hAEZIVWrD/PUb9ULGv0wtXdHT5VE1cTpCDv6awlX8Ax00T8qoA1GXRenNKfwrI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766065426; c=relaxed/simple;
	bh=x4qPUuhlrBPwW8qMzu9PfhHYFLzm9BW4pTafGCL6Xfk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=opdtKL08ix85Iy6I3SuPehVn2wkC6R1cEne98ooGkcDrb4tL7GqfhuL0TJTpMsN8chTN6THCQsXB7kcx4nHwfp/KeoZ8bMS+8oaAritKttAxJCcSbTN882WrMgFcc0lhmJYVQCbVDu9HV+lqA/2Ddif0KbiYMQOupZ93oPJmR/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fA2TPvVZ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PQnVVoPn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766065422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hnm/Q5APpwGI4EN9d81xpwBKHIVDaJBAyxjHvreVfHU=;
	b=fA2TPvVZ/p/nY4KWgNgDpfsXhRFdl/hPzhVY3i6vWwtNwyCOGBhTE3+oCDhw4g3YP4vuvs
	rkmiWRFyEk0al1dQh2u0SNwj/oMJLUbA8UyDuABVSkbibiq/qWju//NF0vjYHK91zCOSOj
	S9ubcrVEJodKGQRFgWHIA+sgun22zsM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-578-wkubsyHeP6qNCW3YzXsCZA-1; Thu, 18 Dec 2025 08:43:41 -0500
X-MC-Unique: wkubsyHeP6qNCW3YzXsCZA-1
X-Mimecast-MFC-AGG-ID: wkubsyHeP6qNCW3YzXsCZA_1766065420
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4788112ec09so6701695e9.3
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 05:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766065420; x=1766670220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hnm/Q5APpwGI4EN9d81xpwBKHIVDaJBAyxjHvreVfHU=;
        b=PQnVVoPn7BuZyHomaI3lS4iguCHsHlKJ2UB52qQQOWhxiAL/FylTLRzw+XOkz87iXF
         RoTHOKe9AnTdYqIyMe+6JzGOp6fH8QcieWrv0KLyMh/2Lq550Gq+JkzLU4IvN4ucDR7w
         m0cogdGVdgwXxMod4n5ZME/2MhS3fpKg4ZVr9efRSV3l7wXwbsQ19orQr9aqCMbE6Yqj
         oqXVyFbgWGOtUY+tZqkXLpX9C8oFKbr8xsQ1wM4uR4XkF0y9yjZL47zn+Q5a3z4WLtIU
         ExBeoc50LLA5erGvMpMP22ZoepheDGW2G97zz/INusoZ/YvijeRkaQvTFE0MChIJ5ucj
         Dklw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766065420; x=1766670220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Hnm/Q5APpwGI4EN9d81xpwBKHIVDaJBAyxjHvreVfHU=;
        b=QAbAvvHoKJza/2S4cyrnhxrNEcJWQ7VBitU/ryU747mWXCZDBI+2j4Sw680gn7/t2u
         Wdt5fej9K3XTZWiQZwNdbKzvh5dau39+SllUKq1mMBmpTTeeB3VgKyJOlgmv3D16pbTF
         cnzaaMT0On2uxKRTygSQugBMW/DFBGaee4mhg/JR0WzHkaSgI0upSSTYT6ErtTDVAZwW
         Eeix0l5RFFCwn+/O+MIskNlDw1TG+THs0bBQ2decLINI9CpX8N9rbJusjhuW9ez3mUk0
         Aq12s7AaMeyG2BKJM7MlQC3AHK82xWTkvOqfOqB9UTodvZBnTo5HXAIJ0iwflYMOp2IF
         emRw==
X-Forwarded-Encrypted: i=1; AJvYcCV5FytYFqVEpezLag5jhAV1lcaxYRXNd2F0yt3If4F4FSGikE91xUCa5bmBtVdfMVvTvsk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWQxOYW8kfeJnFWbYv1W+OLLw/OLja5slwWmF9ZN1HXCS6ARiy
	3akpJ+nEtceVwbUjn9S9tNrGX/8Ge2hfKLj84E0nbofWmUzBrtwLKnrmxFvNg2JJRuGpM9s1f/R
	C/Oi9ALEimBF0BvizoYO77jkhI929YNpDLR6qgX7pLLPvsFWacs2dtUyy70GVQA==
X-Gm-Gg: AY/fxX6BV+n3Ai07RTq1Mb3saNt5SCSi2fFKhf0/DQ3afvE4vyxS6mzjBbHdEcKvA4P
	WMRKi9KKrUMKP59KnMgA17nPuEPVFHsoP5U4/dix1OVsVUeCTbiwwwv6+FiSjIw5ueNdO8mTRxc
	oTGirUdpahtlqmIXT2/s2OAw+jHBciZAz2Fgna78TiYDaU1jzdORYQrsMZliN/tOBFDk9Tqxm6T
	UZKgtJnRKDeP06pM6KYenE+X6ht8/IY3jONE+M+f2zhkzldn9ml19MYiOYj0Ea2gwcTbyXugSFB
	5eG5uIZlOuui527254BwF06LZ/25M0moDnnRK/n76wj0YKg4XVuSCWkMZ7+k98Vwnh2t6Q==
X-Received: by 2002:a05:600c:34c3:b0:47a:7fdd:2906 with SMTP id 5b1f17b1804b1-47a8f8c47c2mr242773845e9.12.1766065420095;
        Thu, 18 Dec 2025 05:43:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFnuoYyOC7iv0lUxnK/Tn9C/mTvEX+0TSPaAZ1QvvRD1VwB+sDBVdYmFcJzvP15/PNtcrASqA==
X-Received: by 2002:a05:600c:34c3:b0:47a:7fdd:2906 with SMTP id 5b1f17b1804b1-47a8f8c47c2mr242773255e9.12.1766065419688;
        Thu, 18 Dec 2025 05:43:39 -0800 (PST)
Received: from imammedo ([213.175.46.86])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be3a9687dsm15060665e9.3.2025.12.18.05.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 05:43:39 -0800 (PST)
Date: Thu, 18 Dec 2025 14:43:37 +0100
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
Subject: Re: [PATCH v5 20/28] hw/virtio/virtio-mmio: Remove
 VirtIOMMIOProxy::format_transport_address field
Message-ID: <20251218144337.77dcf630@imammedo>
In-Reply-To: <20251202162835.3227894-21-zhao1.liu@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
	<20251202162835.3227894-21-zhao1.liu@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed,  3 Dec 2025 00:28:27 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> From: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
>=20
> The VirtIOMMIOProxy::format_transport_address boolean was only set
> in the hw_compat_2_6[] array, via the 'format_transport_address=3Doff'
> property. We removed all machines using that array, lets remove
> that property, simplifying virtio_mmio_bus_get_dev_path().
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Igor Mammedov <imammedo@redhat.com>

> ---
>  hw/virtio/virtio-mmio.c         | 15 ---------------
>  include/hw/virtio/virtio-mmio.h |  1 -
>  2 files changed, 16 deletions(-)
>=20
> diff --git a/hw/virtio/virtio-mmio.c b/hw/virtio/virtio-mmio.c
> index c05c00bcd4a7..c779836201d5 100644
> --- a/hw/virtio/virtio-mmio.c
> +++ b/hw/virtio/virtio-mmio.c
> @@ -764,8 +764,6 @@ static void virtio_mmio_pre_plugged(DeviceState *d, E=
rror **errp)
>  /* virtio-mmio device */
> =20
>  static const Property virtio_mmio_properties[] =3D {
> -    DEFINE_PROP_BOOL("format_transport_address", VirtIOMMIOProxy,
> -                     format_transport_address, true),
>      DEFINE_PROP_BOOL("force-legacy", VirtIOMMIOProxy, legacy, true),
>      DEFINE_PROP_BIT("ioeventfd", VirtIOMMIOProxy, flags,
>                      VIRTIO_IOMMIO_FLAG_USE_IOEVENTFD_BIT, true),
> @@ -827,19 +825,6 @@ static char *virtio_mmio_bus_get_dev_path(DeviceStat=
e *dev)
>      virtio_mmio_proxy =3D VIRTIO_MMIO(virtio_mmio_bus->parent);
>      proxy_path =3D qdev_get_dev_path(DEVICE(virtio_mmio_proxy));
> =20
> -    /*
> -     * If @format_transport_address is false, then we just perform the s=
ame as
> -     * virtio_bus_get_dev_path(): we delegate the address formatting for=
 the
> -     * device on the virtio-mmio bus to the bus that the virtio-mmio pro=
xy
> -     * (i.e., the device that implements the virtio-mmio bus) resides on=
. In
> -     * this case the base address of the virtio-mmio transport will be
> -     * invisible.
> -     */
> -    if (!virtio_mmio_proxy->format_transport_address) {
> -        return proxy_path;
> -    }
> -
> -    /* Otherwise, we append the base address of the transport. */
>      section =3D memory_region_find(&virtio_mmio_proxy->iomem, 0, 0x200);
>      assert(section.mr);
> =20
> diff --git a/include/hw/virtio/virtio-mmio.h b/include/hw/virtio/virtio-m=
mio.h
> index aa492620228d..8b19ec2291ac 100644
> --- a/include/hw/virtio/virtio-mmio.h
> +++ b/include/hw/virtio/virtio-mmio.h
> @@ -66,7 +66,6 @@ struct VirtIOMMIOProxy {
>      uint32_t guest_page_shift;
>      /* virtio-bus */
>      VirtioBusState bus;
> -    bool format_transport_address;
>      /* Fields only used for non-legacy (v2) devices */
>      uint32_t guest_features[2];
>      VirtIOMMIOQueue vqs[VIRTIO_QUEUE_MAX];


