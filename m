Return-Path: <kvm+bounces-66274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AEF8CCC4AE
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 15:34:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B4856302D2B0
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 14:33:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26DC02EC563;
	Thu, 18 Dec 2025 14:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iAPtN2p5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VwZSitQZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C89D257448
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 14:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766068426; cv=none; b=YgSXWWd8F92VKzVBLTzSrAZE+3XRzO7kD1ijMaTcj6Lbd5rFDDALgfJVuJ5zIPn0QcvSkWNXPyCcbExX3hTcEVwTGAU1HYBAP4v8inmlwh1lMEgQTd7wGkp9+5jq1jR9bPUinShc0jfmcmND6YPat1b2O55t95Oq65MAt3j6twQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766068426; c=relaxed/simple;
	bh=cYroOoaFxCVGmVKH0RMowxTZQmolf25MYMi2FsWk8Y8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R2rL7pYCeaRalaYnoQNJ2dQ6asqoMki6DcZOxGVkCSuLitK4Lsv7gtIAu4XT/Y5fBEml1lYvN63BSthkvOqzKEC2KL9S865QojHuPrrc6FI4adqmKwvbqLSCDTs+Mige9RwgNw9aYFFiAkDYR3hNyl5zYX72GvSm8CKFvPevslU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iAPtN2p5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VwZSitQZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766068423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o2jclgT+hyK8+FgcLN0D0cFPi3FqzWtgZmEYfXHS49I=;
	b=iAPtN2p5ex6fU3edNTf3+d288BpoUJ+y3Vzym8dbS1kSKQt5AyMrhMeWu6E5X+QfL8+peD
	pp/vmiAfXxarDMF32yV6UhdVFbqSaMHIxRLWyWl8Iig1b1YYmFz0IOVKDBj1gQRbxr92nH
	argue5tMWa2bxEFoflSAHtcDYRj1Vsk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-A54Wq3E4Pg2gTa3Cvi4CBg-1; Thu, 18 Dec 2025 09:33:41 -0500
X-MC-Unique: A54Wq3E4Pg2gTa3Cvi4CBg-1
X-Mimecast-MFC-AGG-ID: A54Wq3E4Pg2gTa3Cvi4CBg_1766068420
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477a0ddd1d4so5292545e9.0
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 06:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766068420; x=1766673220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o2jclgT+hyK8+FgcLN0D0cFPi3FqzWtgZmEYfXHS49I=;
        b=VwZSitQZBY33t68tNLWZfEh6dEBb34+7J1eWRRShGDhcwk91ja7KWOs6xClpY/JHpt
         wXaapiPvoosOT4lYt94qVSXTDdrk/svb9XPg0JUA2DQ50DQRpVIhCdQgcdpJEehOenGV
         72p5ZLEx6ERtuFuWis3KQz9ynx7YN1iGKiagfPyfywEU0+xLrghy/RvEZMTigzes6sq7
         n/v1DxJQlAS9EcTRpqcQjEai0p9JPgZq6lHbI2dnKnhfflAUrQX8PwayS6ip9KGAmYCJ
         iIxiuSPRF9mZPY5Ovexz5wpZkSLvII+2v+KpnEGgzBFvMmC/rUPnjDVzIv7Aj8qwVApZ
         fTnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766068420; x=1766673220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=o2jclgT+hyK8+FgcLN0D0cFPi3FqzWtgZmEYfXHS49I=;
        b=JFpTAvaMMhV2/OahOp582wZzokTYuDFS3Lr5x1QZHinVgHKYwjwcTM57X7++Zjho2o
         LqLgF17PByJHDhtGJHbF77hx5uEV74s7jEMK0Mz00zUyyRJSYMwBeMu9tkXpJNlH+tWi
         r/WJrGIFtXlxz6jU4Hjc6XF1JQmJ4WrLX1urkFgjKDx32zKLhj75LqUQrlfBHO08/CKN
         uJevKH59dgSm/RieQNwL3zp9eKTc9S7rsjOGqNvTldYhSVQqq/FllT39YOoDDNp/yYHM
         Iz59583y1M1UwUMZBJKB5SENZZdpndZmCyiLpY+YZ8/5qekC/0kUajwKghsN8GWaZCp8
         Brkw==
X-Forwarded-Encrypted: i=1; AJvYcCWAirdt/pHmj+IArWT7ImZQLoOTQaG0AnMdiPAXQbmt2+oIkkEQuP/vVFmVZiSsaTwz0MM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2p2NEYIEu1S2+bDQVzd7nxl83yU7Wtzv8B1E85N90Xti1hJ/2
	nDhVb43bWL0rPqX1x2NRmAsmaikBFQkBIktXI5MGyhKENklSH4o7NS41dui4zRSd5CqSv6o73+8
	+V2BZ8+jq6uj/00EqW0SU5H5DdG6V1nvG/na9H3pgSNjJD4iOrwpZkw==
X-Gm-Gg: AY/fxX7fSMOyS8A7KrnvFn/Ltkw8+JVEviFvjGb8nnMH12UKFR9RboUeWIJzm56QixT
	vTvp+cXIsJzYBcEv2hti4C7JfHPjbZ5RVA5wqac1S2w/4cvRDJhY3SgF6UFFQbGlLee0mhKH0Q2
	b/W9XejMA3oJfKxDupmOLGQEa4aFArO+lqQ/wZc8VTOnTEOSKnhULKrNVDNn5NnQLKqbIdN2tAq
	snTtEXfTFOpY3LmQAa9l5gsBuEgU9G0X/gvUFu3Phn+EvVWS1qemnK/QdG+SP0R760IvZgT3VBB
	vHr6bpTY+5iMsi0qmBbsRTsP6kb2i4TDa+/RASp9hEJQseqpU+69cD4LmbhIv9EOtx6Rcg==
X-Received: by 2002:a05:600c:444b:b0:477:9b4a:a82 with SMTP id 5b1f17b1804b1-47a8f91561cmr213462085e9.35.1766068420095;
        Thu, 18 Dec 2025 06:33:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFHkM8I8rGTbj5vVhu+IFR0KTxVCJf2Bqm0R9jiEdZksNnyLIDlDTrsToVkrXGVL7udw2ORQQ==
X-Received: by 2002:a05:600c:444b:b0:477:9b4a:a82 with SMTP id 5b1f17b1804b1-47a8f91561cmr213459505e9.35.1766068416567;
        Thu, 18 Dec 2025 06:33:36 -0800 (PST)
Received: from imammedo ([213.175.37.14])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be3a0fb5bsm15679935e9.1.2025.12.18.06.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 06:33:36 -0800 (PST)
Date: Thu, 18 Dec 2025 15:33:33 +0100
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
Subject: Re: [PATCH v5 16/28] hw/i386: Remove linuxboot.bin
Message-ID: <20251218153333.6cb6e080@imammedo>
In-Reply-To: <aUOxBg3bVii1HAOx@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
	<20251202162835.3227894-17-zhao1.liu@intel.com>
	<20251217155530.3353e904@imammedo>
	<aUOxBg3bVii1HAOx@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Dec 2025 15:45:10 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> On Wed, Dec 17, 2025 at 03:55:30PM +0100, Igor Mammedov wrote:
> > Date: Wed, 17 Dec 2025 15:55:30 +0100
> > From: Igor Mammedov <imammedo@redhat.com>
> > Subject: Re: [PATCH v5 16/28] hw/i386: Remove linuxboot.bin
> > X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
> >=20
> > On Wed,  3 Dec 2025 00:28:23 +0800
> > Zhao Liu <zhao1.liu@intel.com> wrote:
> >  =20
> > > From: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> > >=20
> > > All machines now use the linuxboot_dma.bin binary, so it's safe to
> > > remove the non-DMA version (linuxboot.bin). =20
> >=20
> > after applying this patch:
> >=20
> > git grep linuxboot.bin
> >=20
> >     option_rom[nb_option_roms].bootindex =3D 0;                        =
           =20
> >     option_rom[nb_option_roms].name =3D "linuxboot.bin";               =
           =20
> >     if (fw_cfg_dma_enabled(fw_cfg)) {                                  =
         =20
> >         option_rom[nb_option_roms].name =3D "linuxboot_dma.bin";       =
           =20
> >     }       =20
> >=20
> > perhaps it should be fixed in previous patch =20
>=20
> Thanks, I find this change was included in the previous patch (patch 15).

Yep, sorry for confusion. /I forgot to apply #15, hence it led to a stray l=
inuxboot.bin/

>=20
> And I have a GitLab branch and hopefully it could help apply and review:
>=20
> https://gitlab.com/zhao.liu/qemu/-/commits/remove-2.6-and-2.7-pc-v5-11-26=
-2025
>=20
> Regards,
> Zhao
>=20


