Return-Path: <kvm+bounces-46335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A9737AB52ED
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:41:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BA051B43136
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C509244682;
	Tue, 13 May 2025 10:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Haka4uiH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A5A211A16
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747132222; cv=none; b=H1EV84KRTYQ256aCzxWCRrHOuN8zWe6FatLQMBfvl555yfATgQO2pxjumb6nBqTsBVAuCdy1CZGBixqvlRVn5UQscPNQF5GhY3WC33Xp3f2pgBVe5zXh5ULcUiDtiEDTgieUEh16h4OINGEX743O1yIV6zTh3WwjeoTeecOHeZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747132222; c=relaxed/simple;
	bh=lnNifqSFirb8T0jB/tOkqcWeY6HGS6x6fBJJFBCgp30=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JYLYr4JrgmmorK98rBo6yW8PKUu8sJICpYvpV3R2UmXJvaYefwGmx615c4bSTSSVBKWY9/mCK/DBgarmJXlwo380DpVMbAc5+pkuv/tBLCjLLlOuxvXk+kQTenuqMkV/8k5uS3s44UE1fKRxDVoS+bSZpzqbfWF14eE01FRlyaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Haka4uiH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747132219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K8iuDoVUKmba4R8nSTe6+wX/Mku81yEFf9qrmeNuvU0=;
	b=Haka4uiHPPzZiHmy1FxSZBfyRmUBQ2aFt5nref4wJ41fCAAHYxZWIMheZxK3AcMA85iatL
	AhJeixluv0/y4q0coSFKVfrBXKQK6/ZkwzTr/EG5RHhLYJe4p9KczIiBGY1NamcT7i+DSS
	97DwJZviKj5p69ZotiKQsgW3hewpvOs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-uGXhXiP9PAOj2FjqPiOyRw-1; Tue, 13 May 2025 06:30:18 -0400
X-MC-Unique: uGXhXiP9PAOj2FjqPiOyRw-1
X-Mimecast-MFC-AGG-ID: uGXhXiP9PAOj2FjqPiOyRw_1747132217
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-442ccf0eb4eso40448265e9.1
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 03:30:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747132217; x=1747737017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K8iuDoVUKmba4R8nSTe6+wX/Mku81yEFf9qrmeNuvU0=;
        b=ZP1QcWMuJGQpQ7Fc6hKY2atqFmDRY5yELToaOfxUDdRVloj8cuIp+heP9vV/U/GOIM
         az6XHWdC2jkjrzc9mIVg3FUesCxM/xsV4X4FiyYIQywhzNvrD0LkZZPoCPGmrwvF9q1S
         iBFPx+0eL6wRaHZvStuEmE2Epmvtuk/CqRkkw8xAsx0H8UElctaTKGu7JhGoJHSzd3Ak
         0GSMq5Iol1iPNpb+M2iw+cSVK84eJOSy+uv76e07pAzUInSIRpqR9LkLTV31qq131QxW
         87TcUT8er/f41/VcUO1sFCj115HQH5ffaTuTdySA35Kl2wfGoTC+ue3+u7PgAlWLrVxR
         qO8A==
X-Forwarded-Encrypted: i=1; AJvYcCXGvNTkiZ2iqigbXEQcwiEmFodSw0smnIQx0/lKiPmUeIKPviG7yHSp6cvcLFlrty7UBLM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQK/leRemlJCX4GJ39M2sKrgNOBfWWFDSJ9Cok6m+WnRD/3WL2
	jHA6skoCo72J+SUHtlduW+TRrC4S73Fxxb92e4t9r62e676/ZoiWdJ4ANopPCgvFI7nZyQKlfOq
	9QRkZ6s9qUmj3Jti33HfWiTeH7Vf81WQ3ZuzkmAZsaYs7qrwdHQ==
X-Gm-Gg: ASbGncum2Yo2UrSdr4dvkSSfG3Zlp0aI/Tx3nSrYE+X0pihwbui1gk7xLRwmgXCd6Cc
	pascM7LgmvzgJ1OYmHmeSmQdZ+Pu7rXz6FfcXu/aUzefIe1Xjy54vhErqVumdD7zfnIcWXpuDiK
	d0J8xOfn/rLoMgeU8myyqJiT28uswTOUpvh1xwvMgW+T9LfRYEKyvfsNtScUWVdWkt9LKbgD0I/
	g0mJe4uxU8Uxx4yRJytOxxYJwWieDR+EY93+TsnyIcGoQDMD4Y4luNe6GaKxwOCW57vJdV53tcM
	dwSBQS6zjUQMjX9fIyi87gtaiLlULudR
X-Received: by 2002:a05:600c:3e8c:b0:43c:f969:13c0 with SMTP id 5b1f17b1804b1-442d6ddec16mr137058915e9.29.1747132217492;
        Tue, 13 May 2025 03:30:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGWH2SlPJhTSYnfcP8ynqc1cV83KOO/vg2sWk6ss3ErHbO0veyJed2wklFPjNGmKZ6c9j4PTQ==
X-Received: by 2002:a05:600c:3e8c:b0:43c:f969:13c0 with SMTP id 5b1f17b1804b1-442d6ddec16mr137058455e9.29.1747132217110;
        Tue, 13 May 2025 03:30:17 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd3aecb0sm208576865e9.28.2025.05.13.03.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 03:30:16 -0700 (PDT)
Date: Tue, 13 May 2025 12:30:14 +0200
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
 Wang <jasowang@redhat.com>, Mark Cave-Ayland <mark.caveayland@nutanix.com>
Subject: Re: [PATCH v4 25/27] hw/virtio/virtio-pci: Remove
 VirtIOPCIProxy::ignore_backend_features field
Message-ID: <20250513123014.763837de@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250508133550.81391-26-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-26-philmd@linaro.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  8 May 2025 15:35:48 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> The VirtIOPCIProxy::ignore_backend_features boolean was only set
> in the hw_compat_2_7[] array, via the 'x-ignore-backend-features=3Don'
> property. We removed all machines using that array, lets remove
> that property, simplify by only using the default version.
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>

Reviewed-by: Igor Mammedov <imammedo@redhat.com>

> ---
>  include/hw/virtio/virtio-pci.h | 1 -
>  hw/virtio/virtio-pci.c         | 5 +----
>  2 files changed, 1 insertion(+), 5 deletions(-)
>=20
> diff --git a/include/hw/virtio/virtio-pci.h b/include/hw/virtio/virtio-pc=
i.h
> index f962c9116c1..9838e8650a6 100644
> --- a/include/hw/virtio/virtio-pci.h
> +++ b/include/hw/virtio/virtio-pci.h
> @@ -149,7 +149,6 @@ struct VirtIOPCIProxy {
>      int config_cap;
>      uint32_t flags;
>      bool disable_modern;
> -    bool ignore_backend_features;
>      OnOffAuto disable_legacy;
>      /* Transitional device id */
>      uint16_t trans_devid;
> diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
> index 8d68e56641a..7c965771907 100644
> --- a/hw/virtio/virtio-pci.c
> +++ b/hw/virtio/virtio-pci.c
> @@ -1965,8 +1965,7 @@ static void virtio_pci_device_plugged(DeviceState *=
d, Error **errp)
>       * Virtio capabilities present without
>       * VIRTIO_F_VERSION_1 confuses guests
>       */
> -    if (!proxy->ignore_backend_features &&
> -            !virtio_has_feature(vdev->host_features, VIRTIO_F_VERSION_1)=
) {
> +    if (!virtio_has_feature(vdev->host_features, VIRTIO_F_VERSION_1)) {
>          virtio_pci_disable_modern(proxy);
> =20
>          if (!legacy) {
> @@ -2351,8 +2350,6 @@ static const Property virtio_pci_properties[] =3D {
>                      VIRTIO_PCI_FLAG_MODERN_PIO_NOTIFY_BIT, false),
>      DEFINE_PROP_BIT("page-per-vq", VirtIOPCIProxy, flags,
>                      VIRTIO_PCI_FLAG_PAGE_PER_VQ_BIT, false),
> -    DEFINE_PROP_BOOL("x-ignore-backend-features", VirtIOPCIProxy,
> -                     ignore_backend_features, false),
>      DEFINE_PROP_BIT("ats", VirtIOPCIProxy, flags,
>                      VIRTIO_PCI_FLAG_ATS_BIT, false),
>      DEFINE_PROP_BIT("x-ats-page-aligned", VirtIOPCIProxy, flags,


