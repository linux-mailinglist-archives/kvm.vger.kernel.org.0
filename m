Return-Path: <kvm+bounces-46306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90176AB4E2D
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:34:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A58F19E0923
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 08:34:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D46C20D4F2;
	Tue, 13 May 2025 08:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ybox8v2N"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A58C1E1E06
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 08:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747125253; cv=none; b=fajlfVl8dPA+mFZzeY/Dux8KEYK6kx32MW1GNj93vX5juWTpY55SGvpwbZZ9LgfUnnSbVVg1O7GVJvZKm2i+9Cy+VP0TRy0ZDGvb+4g4n7wsJI4lsjqR2SG38cbz3/PShIz8FzrU29gfSHD34VzKBfKEdA3O2yoB/7+ckOm4jKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747125253; c=relaxed/simple;
	bh=6mW+Bp+s1wRlm5D/f2IOBaaovt/te8Otrta+0EJMCg0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F+Eq6SQDxRZD9a4D2i59598n78Y0/zrgh0K1yPWC0jb6/i8rgjGJyDo26oN+FYH7N8qYh6c2NB7g6OkPyyz0jOdLf6KusUBa5IffGeaPlzBX91zwDM5kmCb30nECYL9nqKtKYOh4SHqVO6eCVVsTJYrEczGp2YRHe2Quza99OoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ybox8v2N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747125250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4VUUz/K3vD5ynFqMRnkFNAMs82oWIMcdZAYYGqNsb/s=;
	b=Ybox8v2N9sY15rFQTmY5D/MPJBfpJtfIw1eNemnQXFWZh9045DYcJF0oLhaW9cdU45ywKa
	9wdgkk8wfai+hRuuZo13ZvO2aa1imN6+fXro+fYewDCBNimJvPLtc3XmRKegg+RP4lhQLo
	UDCSi8PrOxWhFZ7LRgCMdWBTUpNWDlw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-f-Px3dbGO7eaZ6XUGaC71g-1; Tue, 13 May 2025 04:34:09 -0400
X-MC-Unique: f-Px3dbGO7eaZ6XUGaC71g-1
X-Mimecast-MFC-AGG-ID: f-Px3dbGO7eaZ6XUGaC71g_1747125248
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43cec217977so26504265e9.0
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 01:34:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747125248; x=1747730048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4VUUz/K3vD5ynFqMRnkFNAMs82oWIMcdZAYYGqNsb/s=;
        b=sXJVNZzeL2IQCfqFpuOo/BKewdvtnDU5nnLx1ztBc9XDEWd8MMrztiRMsrk0bwMZC7
         BByDvhQRIBQNgFnHnfn+KJKxfSClm4DT5RlEd2vP/iPa8UnQgguGAX9aa50U3xtokPdQ
         OZhtHNra++uVF8EhNC/9ZixwF1M/ISVirwVP9DebRo4LDrSps65Ihx4j23k6YPgw7nOA
         tL1cAW7r5po4XLH2X1OXgAB+ubXWB1SAxktpiqiXznrSsp9dH6N2XZ5tS4xoDOWiKnsm
         11Ij31pSKyde5VgBIvG4wKpUJFehEuxn10H2iSQ3nUCi12smnh8m/nF0t8EXsrL9O++m
         7I7w==
X-Forwarded-Encrypted: i=1; AJvYcCVXrkLoHz6t4f27o3tMbv2U0KnEDqtUxOXi9HK+pI+A59K6yyShGzolJnkgb+w2KWUF9Yw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZUojaAn8PHZTojEX5cFFVqCkn/GyMnHPwFN2TpVmLT7Q5d5Nu
	yjkQVwSEu4fKnglyMXzns1P8lvon0bt/ijXzW+OLGLSTirO6MJmXVVvRGYB8usTm6OevKu53Szp
	e4SpwUtbMDzXcLjkJTtT4eUMuBIEajqLTYo62ApVtte2pI6aIQw==
X-Gm-Gg: ASbGnctQpli9Fl5kq6xgIo4hJ5btuTV1pzZjY7AFfzf9jYlNyDlrn6Fl5Nv1LCDOrJ+
	EjkibtDmBAZ6zQE3K9XMqBkghzSZDNxSLTYbh3i/BpM0yU/ec/NE3gS6Q5O4t8YWo2pinOF5lGE
	0UzIC1pcClLIjc+z6LQFTy9caVaEt6dx+ypL9fXf0l0/CVOeUrVl4qlWybsImutZC0irg7ATUqp
	44F/Rd17dZstqXNjL6EZ9aqVSuCiIfKQgMSY0qF3qeIANQGi2hpkCwRBR1SNzMM2Rl7F+CciIE1
	GUk1oIvPZ5JksmPbv/hDyfSOCJF//gz1
X-Received: by 2002:a05:600c:628c:b0:43c:f689:dd with SMTP id 5b1f17b1804b1-442d6d71df0mr146869955e9.19.1747125248014;
        Tue, 13 May 2025 01:34:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHSlfEs20rOFjqqrW5vXRv0rjvijsDxbmGSr2wixU5yagOHT15C4yLbypPTku5RDF+DKRHL5Q==
X-Received: by 2002:a05:600c:628c:b0:43c:f689:dd with SMTP id 5b1f17b1804b1-442d6d71df0mr146869485e9.19.1747125247581;
        Tue, 13 May 2025 01:34:07 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442e9d00bacsm40155815e9.12.2025.05.13.01.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 01:34:07 -0700 (PDT)
Date: Tue, 13 May 2025 10:34:05 +0200
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
Subject: Re: [PATCH v4 14/27] hw/intc/apic: Remove
 APICCommonState::legacy_instance_id field
Message-ID: <20250513103405.6c502bbc@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250508133550.81391-15-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-15-philmd@linaro.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  8 May 2025 15:35:37 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> The APICCommonState::legacy_instance_id boolean was only set
> in the pc_compat_2_6[] array, via the 'legacy-instance-id=3Don'
> property. We removed all machines using that array, lets remove
> that property, simplifying apic_common_realize().
>=20
> Because instance_id is initialized as initial_apic_id, we can
> not register vmstate_apic_common directly via dc->vmsd.

I think just removing this property is pretty save,
it's highly unlikely to be used by any external user
as it's purpose was to keep migration working for 2.6.
With the later gone there is not need for the property at all.
 =20

>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Igor Mammedov <imammedo@redhat.com>

> ---
>  include/hw/i386/apic_internal.h | 1 -
>  hw/intc/apic_common.c           | 5 -----
>  2 files changed, 6 deletions(-)
>=20
> diff --git a/include/hw/i386/apic_internal.h b/include/hw/i386/apic_inter=
nal.h
> index 429278da618..db6a9101530 100644
> --- a/include/hw/i386/apic_internal.h
> +++ b/include/hw/i386/apic_internal.h
> @@ -188,7 +188,6 @@ struct APICCommonState {
>      uint32_t vapic_control;
>      DeviceState *vapic;
>      hwaddr vapic_paddr; /* note: persistence via kvmvapic */
> -    bool legacy_instance_id;
>      uint32_t extended_log_dest;
>  };
> =20
> diff --git a/hw/intc/apic_common.c b/hw/intc/apic_common.c
> index 37a7a7019d3..1d259b97e63 100644
> --- a/hw/intc/apic_common.c
> +++ b/hw/intc/apic_common.c
> @@ -294,9 +294,6 @@ static void apic_common_realize(DeviceState *dev, Err=
or **errp)
>          info->enable_tpr_reporting(s, true);
>      }
> =20
> -    if (s->legacy_instance_id) {
> -        instance_id =3D VMSTATE_INSTANCE_ID_ANY;
> -    }
>      vmstate_register_with_alias_id(NULL, instance_id, &vmstate_apic_comm=
on,
>                                     s, -1, 0, NULL);
> =20
> @@ -412,8 +409,6 @@ static const Property apic_properties_common[] =3D {
>      DEFINE_PROP_UINT8("version", APICCommonState, version, 0x14),
>      DEFINE_PROP_BIT("vapic", APICCommonState, vapic_control, VAPIC_ENABL=
E_BIT,
>                      true),
> -    DEFINE_PROP_BOOL("legacy-instance-id", APICCommonState, legacy_insta=
nce_id,
> -                     false),
>  };
> =20
>  static void apic_common_get_id(Object *obj, Visitor *v, const char *name,


