Return-Path: <kvm+bounces-46309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFE82AB4EC6
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 11:03:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCFDF3BD33D
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 09:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5F14211A3D;
	Tue, 13 May 2025 09:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FlqB2w1F"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFA020D4F2
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 09:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747126955; cv=none; b=C7XFMlWFWM2fDxHhYbNGoZ8WAPwZT4jDLRlzI2jfd8nijVNmmyizFKfMRt+m7PtWelSJGxaATVctIIP0YF/a3fi/thNlJx53uhJihMxaYVbI5tZ+XdCY46oX8KUdCnjV97diyN0iiVyiXJE1wfqCD5sKDXr13K7gkW62vRtxsJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747126955; c=relaxed/simple;
	bh=z9ZVdpkY/+iGE5XX5cVhDDfw4N/cl5VVQoSuuqBABMU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pMIZqipB7Va7d2QLLbEHRyPrFe5doG9JCxxwzodKvpNiJGscskgvB9rY4jB/GjlAxrjgfU7V3HNKkwGG+y5k42dloMuHI8K2+6lCEq+d/agUIwczNA3hZX8AYYzX00cZpk1i6PbclKwgBB2NSwhOt0hO6oQ/bj7zo5So8clX2ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FlqB2w1F; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747126952;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HE5E63A6rmg07JemaPIfncFI01OB8TrlgBKDzNGQzCc=;
	b=FlqB2w1FxAvztT4Ph7UpEnufeCeGaunFAlrLwYroSRoTuEg8AztzMsIn1UJWYEeETyPUwz
	2dcOdTaxcMjNOvj0WJl+2qXk29nv1rk/TuxBfmzaiVEWn/jJ2JiYURS0GWzTSajPQlD424
	LlHTOYAqqRJmEHlZSLiGiD1yukdqm88=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-350-np5xIB2jMveYMK7NxMmOpA-1; Tue, 13 May 2025 05:02:30 -0400
X-MC-Unique: np5xIB2jMveYMK7NxMmOpA-1
X-Mimecast-MFC-AGG-ID: np5xIB2jMveYMK7NxMmOpA_1747126950
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a1f9ddf04bso2220942f8f.3
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 02:02:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747126949; x=1747731749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HE5E63A6rmg07JemaPIfncFI01OB8TrlgBKDzNGQzCc=;
        b=VA+1IRPcv9h4O42cY78nAM8akGSgP4lMg1OQWi/07uzNoC573SQ1WaOcAlHy5f7P/e
         cKFGGmuHaArQ2NMXW8ZOWu7cdLEWt3Swm3wVqPsrKIgfBc4H3IGdc2qzrMGDpfVx8Ggg
         yWpC0uRQaNdBQd/DkkpMUlcno+bmB5LxiPlBla+CKMRksKt/fry6kJLk/qMexoahFuOt
         B3ly9tXgx2rKUU/4HJpP1f6KD7gwfCHf7w1TwTh4Uc0kRqfWE9NzwoQdpTs2sLXgOEwh
         SlQpHDXeEaJTjSH8KrUs/YiCPtML4m7NpFFmIr4XLMbmX48qt4Fw8es/lf6uhE9k6iwi
         cecA==
X-Forwarded-Encrypted: i=1; AJvYcCWWUjjFKi+eGxNbOHw7gF8p6lLJotDpmkokBh/Kffva060E5haN4zqqLFrbTPlFUaAgUG4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcspcHQMAn4xN0UkkoKvnt7aaxxyTFL3JOe94O7/Dx1ag5IFYg
	e/TOGMni2ZGpcCFX6tX7tlxUqIPT9bWwTlq8GBc5fQPpC97BOkR+FznUoV/kkMzx7nqeQ6BTzEA
	4FlG2v1Oo9vSz1d1H1VOvN/Rp9MwA7OY7cfSKzHXxe41V2nA+mw==
X-Gm-Gg: ASbGnctjiHrYDXwQRYzeWen1sCaTEskUNcu0v+ETrdFsyd/wjdDdH4Zj3/CH7Kn69W8
	euOklUcNsJT2aS9Bjy3oLZJ8s6+Wi+WzDmggo9M0xlkDBhQ/VprpT6H01iGQu2sdUQvLFbOp9Ow
	1OwAaIQC4A699gNW0PzyFoAGvWNBUoSHxT9Sg6Gsv/x5bFMrMOL/LDw79ZE56O80ZQWknxa/eUl
	jtPz+V87EubBsAvpqrf0KpY89TnaUlf+5APcFx1PlIwm9c9lY3NMy5Mz6+HFvGDg0vjGF5g1lNQ
	QY4jm6S+rY7QEVjzSHuNuGMgt3DVIol+
X-Received: by 2002:adf:f687:0:b0:3a1:fa6c:4735 with SMTP id ffacd0b85a97d-3a1fa6c4838mr8573381f8f.35.1747126949667;
        Tue, 13 May 2025 02:02:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFuyZeASJoiDIgAZ42Fslx6v9M83ncZUjLwgaiHV4EALKZNgG04LuVa4ibD678KGNhv6DCCrw==
X-Received: by 2002:adf:f687:0:b0:3a1:fa6c:4735 with SMTP id ffacd0b85a97d-3a1fa6c4838mr8573329f8f.35.1747126949240;
        Tue, 13 May 2025 02:02:29 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f58f296csm15256712f8f.47.2025.05.13.02.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 02:02:28 -0700 (PDT)
Date: Tue, 13 May 2025 11:02:27 +0200
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
Subject: Re: [PATCH v4 21/27] hw/audio/pcspk: Remove PCSpkState::migrate
 field
Message-ID: <20250513110227.04d709b2@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250508133550.81391-22-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-22-philmd@linaro.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  8 May 2025 15:35:44 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> The PCSpkState::migrate boolean was only set in the
> pc_compat_2_7[] array, via the 'migrate=3Doff' property.
> We removed all machines using that array, lets remove
> that property, simplifying vmstate_spk[].

same as 14/27, it should be safe to remove without deprecation

Reviewed-by: Igor Mammedov <imammedo@redhat.com>

=20
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  hw/audio/pcspk.c | 10 ----------
>  1 file changed, 10 deletions(-)
>=20
> diff --git a/hw/audio/pcspk.c b/hw/audio/pcspk.c
> index a419161b5b1..0e83ba0bf73 100644
> --- a/hw/audio/pcspk.c
> +++ b/hw/audio/pcspk.c
> @@ -56,7 +56,6 @@ struct PCSpkState {
>      unsigned int play_pos;
>      uint8_t data_on;
>      uint8_t dummy_refresh_clock;
> -    bool migrate;
>  };
> =20
>  static const char *s_spk =3D "pcspk";
> @@ -196,18 +195,10 @@ static void pcspk_realizefn(DeviceState *dev, Error=
 **errp)
>      pcspk_state =3D s;
>  }
> =20
> -static bool migrate_needed(void *opaque)
> -{
> -    PCSpkState *s =3D opaque;
> -
> -    return s->migrate;
> -}
> -
>  static const VMStateDescription vmstate_spk =3D {
>      .name =3D "pcspk",
>      .version_id =3D 1,
>      .minimum_version_id =3D 1,
> -    .needed =3D migrate_needed,
>      .fields =3D (const VMStateField[]) {
>          VMSTATE_UINT8(data_on, PCSpkState),
>          VMSTATE_UINT8(dummy_refresh_clock, PCSpkState),
> @@ -218,7 +209,6 @@ static const VMStateDescription vmstate_spk =3D {
>  static const Property pcspk_properties[] =3D {
>      DEFINE_AUDIO_PROPERTIES(PCSpkState, card),
>      DEFINE_PROP_UINT32("iobase", PCSpkState, iobase,  0x61),
> -    DEFINE_PROP_BOOL("migrate", PCSpkState, migrate,  true),
>  };
> =20
>  static void pcspk_class_initfn(ObjectClass *klass, const void *data)


