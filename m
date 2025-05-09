Return-Path: <kvm+bounces-46071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 94482AB1862
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 17:24:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91C289E1717
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 15:23:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8429D22DF8B;
	Fri,  9 May 2025 15:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OZD79d1N"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E91622DA10
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 15:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746804228; cv=none; b=nF32G9ZzUA3gKYk7acvhgCq4+3lSm2iG0lpRXtjUEcqcEko072+DCauYwkF4aq6djpHti3XDzRmO7hTnFoEEaPwJ3GIIUN+8ohU4R0MQez4IMSJQHPxrWrUMuyPS/2brC269ObwknpYDvY6EW+VNocWutThzBXEe432TBT4JnnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746804228; c=relaxed/simple;
	bh=bSHvkoUMAGUvpPbwAld32PC6XRt5ph5cd71mNkkkyDI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=afa+F6G+p5e2+ojOYn0F1pjZcKQAMOI+KqF3gYCfhQSC1dgrHClFuC2dsjKiJtkLDK537rXuHvR1KAOk/zsZy1MXFxkPPrag6JN6SVtyLAueLaY185vPaBuGeTNKJ1m8gwtVoPBR6+158bqkUL/7ZQT5mzOkm9/dGXn+UspWd4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OZD79d1N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746804226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UbfgctwTat72Vztwb/ysK4sx3FtDutARgQGzZ60JQJo=;
	b=OZD79d1NnNxV0aF1BO+gKsqaG4t1epDQqUy8g88QqYBIQ/6uf1bbAgATf0nQysiCeAJ/ig
	zllsyJZxS158+wwfE9k8fZpPB2j2uIKcTreoVR9/ma1+HswcizgyvdkzRV7S6hjAMOKl/Z
	vzDvW/G1T7rZTvASeszYdk3oJ4/GNwk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-2fg458lJOemPzb3nlYOlDw-1; Fri, 09 May 2025 11:23:43 -0400
X-MC-Unique: 2fg458lJOemPzb3nlYOlDw-1
X-Mimecast-MFC-AGG-ID: 2fg458lJOemPzb3nlYOlDw_1746804222
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43d209dc2d3so10560585e9.3
        for <kvm@vger.kernel.org>; Fri, 09 May 2025 08:23:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746804221; x=1747409021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UbfgctwTat72Vztwb/ysK4sx3FtDutARgQGzZ60JQJo=;
        b=p59w1VEd82mJiPGN5sD/kLY4mqZ657X88Iwp4YoaZ2TQrByaOHahGrC1mmljSB/ggJ
         WMtcotui6GxH27PIf/ZcdEq53RuCzbBYC0CVIW5Io1mo7WVAUEkJw1pg02tCd0Y1341k
         w5gOLikf7NdHhXyJm5ckAFdXATJEXiPYD3mj5UK+aN2q8kp5VGSGoruCX5BhZUyimB56
         cz8txlvS9pqdb9vC1sOxNYSICQcoqZv4R/7t28GnuwqAaI1Ov+77lDnEt6slvVvhlJkR
         5HmZmYllYDTQ+soV1FTdHGyTAAqfI0F6Cmbrrbu/tbHP0O3I02bTtCzW9ZFX/whc7uyB
         Rzew==
X-Forwarded-Encrypted: i=1; AJvYcCUy3tzF4Ntx1o/3RrZMGVkjYIDPaRj3XtzS/72tYiAQ8wxIOKpkRzdruB8YX3mxES0yG58=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSsDWZjImmL469DEq9kBn+K9Lbq31OsG6Wk5+P8dWztFoFBMad
	LWI4vIEdKLyOU9SiUb9GxlDzRvvRfi7cR90zUvmFVt42lO4xU3X8L3F8Ti3NfBihiKFwWU1Qq1q
	t9DHj/xsL/SrdZzsalX+aAhuiPlfJcmrFgU1+ubC8tMjBMMocnTgzO/SR65z8
X-Gm-Gg: ASbGnctflYC3z3+o69ohU7jukimLELa/Z40SL1pYA34M8x63PNpFBp9gSRjeiJmZi+Q
	mF11lgDvoXY6woDSsdOVmu41ixzGDvO9u4G/xiYRsG3lIGiI8F2MyrmbTonYYIxGSC3tlBrgdl+
	JXjun47SEVzaPGvzYssR3NCusk/3sM2vC2wTErKuHl9HuzrBNYQidEU6Gr2BK0lC6e8VlWpnrHB
	CVafkr+JfrMshS3dkEQov1AF4BgUUgKhT6pyW5DFo+G13jfZMqTbrenbow04kL6wlAKMmWqUOzF
	PE/27uGBrLwLmDO3UwpkplTfpEfjIdOX
X-Received: by 2002:a05:600c:4e46:b0:442:c993:6f94 with SMTP id 5b1f17b1804b1-442d6d3dafbmr37079555e9.12.1746804221460;
        Fri, 09 May 2025 08:23:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFP9pYN9puPiqkAj4uLWOelxROpw1y+p6NieMuknXnqrPphphHn4Ue+I3VMsXEnn2/RaKCr7w==
X-Received: by 2002:a05:600c:4e46:b0:442:c993:6f94 with SMTP id 5b1f17b1804b1-442d6d3dafbmr37079275e9.12.1746804221031;
        Fri, 09 May 2025 08:23:41 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d67efdd0sm32939935e9.24.2025.05.09.08.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 08:23:40 -0700 (PDT)
Date: Fri, 9 May 2025 17:23:36 +0200
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
Subject: Re: [PATCH v4 01/27] hw/i386/pc: Remove deprecated pc-q35-2.6 and
 pc-i440fx-2.6 machines
Message-ID: <20250509172336.6e73884f@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250508133550.81391-2-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-2-philmd@linaro.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  8 May 2025 15:35:24 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> These machines has been supported for a period of more than 6 years.
> According to our versioned machine support policy (see commit
> ce80c4fa6ff "docs: document special exception for machine type
> deprecation & removal") they can now be removed.

if these machine types are the last users of compat arrays,
it's better to remove array at the same time, aka squash
those patches later in series into this one.
That leaves no illusion that compats could be used in the later patches.
=20
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  hw/i386/pc_piix.c | 14 --------------
>  hw/i386/pc_q35.c  | 14 --------------
>  2 files changed, 28 deletions(-)
>=20
> diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
> index 7a62bb06500..98a118fd4a0 100644
> --- a/hw/i386/pc_piix.c
> +++ b/hw/i386/pc_piix.c
> @@ -764,20 +764,6 @@ static void pc_i440fx_machine_2_7_options(MachineCla=
ss *m)
> =20
>  DEFINE_I440FX_MACHINE(2, 7);
> =20
> -static void pc_i440fx_machine_2_6_options(MachineClass *m)
> -{
> -    X86MachineClass *x86mc =3D X86_MACHINE_CLASS(m);
> -    PCMachineClass *pcmc =3D PC_MACHINE_CLASS(m);
> -
> -    pc_i440fx_machine_2_7_options(m);
> -    pcmc->legacy_cpu_hotplug =3D true;
> -    x86mc->fwcfg_dma_enabled =3D false;
> -    compat_props_add(m->compat_props, hw_compat_2_6, hw_compat_2_6_len);
> -    compat_props_add(m->compat_props, pc_compat_2_6, pc_compat_2_6_len);
> -}
> -
> -DEFINE_I440FX_MACHINE(2, 6);
> -
>  #ifdef CONFIG_ISAPC
>  static void isapc_machine_options(MachineClass *m)
>  {
> diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
> index 33211b1876f..b7ffb5f1216 100644
> --- a/hw/i386/pc_q35.c
> +++ b/hw/i386/pc_q35.c
> @@ -658,17 +658,3 @@ static void pc_q35_machine_2_7_options(MachineClass =
*m)
>  }
> =20
>  DEFINE_Q35_MACHINE(2, 7);
> -
> -static void pc_q35_machine_2_6_options(MachineClass *m)
> -{
> -    X86MachineClass *x86mc =3D X86_MACHINE_CLASS(m);
> -    PCMachineClass *pcmc =3D PC_MACHINE_CLASS(m);
> -
> -    pc_q35_machine_2_7_options(m);
> -    pcmc->legacy_cpu_hotplug =3D true;
> -    x86mc->fwcfg_dma_enabled =3D false;
> -    compat_props_add(m->compat_props, hw_compat_2_6, hw_compat_2_6_len);
> -    compat_props_add(m->compat_props, pc_compat_2_6, pc_compat_2_6_len);
> -}
> -
> -DEFINE_Q35_MACHINE(2, 6);


