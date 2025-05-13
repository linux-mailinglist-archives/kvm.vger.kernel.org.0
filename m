Return-Path: <kvm+bounces-46334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5652AB530E
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:44:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2103F866772
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:37:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADB3B23A989;
	Tue, 13 May 2025 10:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vs5mIYB2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CAD23AE9B
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747132146; cv=none; b=LJiM/Ky+qDT/Xc8EyxMIybynP7qw1YETJvG61dORF4VoJQPHc9dlVVau9ZfTDJtOvb61JVYJ967w9NMw+OJYFl3CQm5f1tnX7vrlBfETKDxDBtDpX/5L1dA0ZQ3RFNvuab3t5dRHvLI/crQ5jjkP1nZVZ3sPlR+ib84pBUUHD4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747132146; c=relaxed/simple;
	bh=wpMeNLu8nNUfunr0fcnrXxcrRFtYmHqswemJvTgucRk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sUXmVPBnepqBHy+x4E1fpp2gofYBi9JobuEoIvE7nqZkmzPxN6nNZtuGzMjVMkHnZaWIo56uHrbCKcFDNMSAJ5BE7VVMF2n54wuZKhE/xfHTu4HLD0tgLVkEPe4DhTe501c1wfY7NtY1iOkj4XpW95hcyLxQQbpLf8K//sxgjag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vs5mIYB2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747132143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Q9Purpm/K4u0zXRViMrb/8QUlPpX+E7LaiOih2O93w=;
	b=Vs5mIYB2CgJNx6O1BJ2jzcgYhiowKIqRmF9vPlUnOvl4krcJr5PI8LIt2K4pxPs4RobGif
	H4o19ALZ25qCb7nR2NjLgEZ8sQeDz9xDS136yaR+4Q4D054QbFe/x1vfQY4gCQcJJoeMrv
	oj1KMSN+5A39jJCNXxCAfOmf93mG0Ts=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-JukhNVkNOTWAE3R8jSMXWg-1; Tue, 13 May 2025 06:29:02 -0400
X-MC-Unique: JukhNVkNOTWAE3R8jSMXWg-1
X-Mimecast-MFC-AGG-ID: JukhNVkNOTWAE3R8jSMXWg_1747132142
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43d5ca7c86aso26147025e9.0
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 03:29:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747132141; x=1747736941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Q9Purpm/K4u0zXRViMrb/8QUlPpX+E7LaiOih2O93w=;
        b=Q7fmHDQZXqEX8Shg9T9WU8doZBcij7X6FHvCm/y/SVOVtm0hHfRPzFSFNTLeL9h8aS
         AN2w7bc0nD/z2IW3q/1z62QO7uu/XsaziaUtHrd2FWiVB85iEZ9UiJIGeStib0WL4sRH
         BjPdp5/y63Ir0Tg1Jrsc6s0L77sI9XPRvv3fVo2gxWe+dnnnT1C651CjuEO246zO8pDW
         SeSuu0HxfylySkRFlyR+Wp/67PMELrBbYGk8dvknJd8egSsJux7kNbQ1vR2yMYCCUHBF
         e5cpClata/4/G++jPZnWF70EMsZ+DZC2bzWxvFiGi6PTT9KnFg34sT3hhx77GG8tSQZf
         ir1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUBa1fs95iF9BoHSo8p8/wpihYWdsqq9S5/DU2IEiYa2tkexQtkfWMdZ+DxXNK8wsbWpFo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ8EsQqcbuTESVSTCzAHG2MeaCcQKk0rCoh9v3CQe5sj++Ii1K
	hjjrvu2m1NMbS7NzQr9XuA2Ks8cjVjq5bwwUzNdFmVliIerw5raq660FLwuFvuu/7OmiR8tZ4K0
	ahFLPj/hnpZYBG+3vmTnGeZ+emE3ESPUqs/OPf7JyD+3OxsvG1A==
X-Gm-Gg: ASbGncvFVlJFc0ErrWrWWsnlBABKkHKaMYj88jhbsiJTqJ8tieucopDJwX8MGaOqeRO
	jLqm4Hp2cHHGKEXsm9GbH934q4nqPB12IBQRj2i0iE76ODmBtDzH+x2FHYUAEQTZsNjFs9BoSsY
	QZyR5CzdUmnBGAM+mI3IKF7H0uj8SDyHCRbscGzx+9EQRR9SEUIrf2y5gtHF3/8SlZTZyJeSLVY
	u+9BG6gbAGzHl0V8gHSWqo9AGKRXWWXoXHOMIoa0P9+wbVSRrNS98FDqb/cN2xNg8QLZ0Z8qFDu
	IaATv8Mx0I0uAAIed9+9nXdgh7XfV+DX
X-Received: by 2002:a05:600c:a089:b0:43c:e9d0:9ee5 with SMTP id 5b1f17b1804b1-442d6d6ad82mr144906915e9.18.1747132141536;
        Tue, 13 May 2025 03:29:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHi10nzAH1EKGO/kzFRGmvYqSgNFAee4ggzvFi1MDmC4i0/84NFAoHOBMIjVrdAh6iczoq/8A==
X-Received: by 2002:a05:600c:a089:b0:43c:e9d0:9ee5 with SMTP id 5b1f17b1804b1-442d6d6ad82mr144906565e9.18.1747132141134;
        Tue, 13 May 2025 03:29:01 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd34bde2sm201853865e9.19.2025.05.13.03.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 03:29:00 -0700 (PDT)
Date: Tue, 13 May 2025 12:28:58 +0200
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
Subject: Re: [PATCH v4 24/27] hw/intc/ioapic: Remove
 IOAPICCommonState::version field
Message-ID: <20250513122858.2a596bd9@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250508133550.81391-25-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-25-philmd@linaro.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  8 May 2025 15:35:47 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> The IOAPICCommonState::version integer was only set
> in the hw_compat_2_7[] array, via the 'version=3D0x11'
> property. We removed all machines using that array,
> lets remove that property, simplify by only using the
> default version (defined as IOAPIC_VER_DEF).
>=20
> For the record, this field was introduced in commit
> 20fd4b7b6d9 ("x86: ioapic: add support for explicit EOI"):
>=20
>  >   Some old Linux kernels (upstream before v4.0), or any released RHEL
>  >   kernels has problem in sending APIC EOI when IR is enabled.
>  >   Meanwhile, many of them only support explicit EOI for IOAPIC, which
>  >   is only introduced in IOAPIC version 0x20. This patch provide a way
>  >   to boost QEMU IOAPIC to version 0x20, in order for QEMU to correctly
>  >   receive EOI messages.
>  >
>  >   Without boosting IOAPIC version to 0x20, kernels before commit
>  >   d32932d ("x86/irq: Convert IOAPIC to use hierarchical irqdomain
>  >   interfaces") will have trouble enabling both IR and level-triggered
>  >   interrupt devices (like e1000).
>  >
>  >   To upgrade IOAPIC to version 0x20, we need to specify:
>  >
>  >     -global ioapic.version=3D0x20
>  >

that crutch might be in-use by external users, and even if they use
0x20, removing property will break CLI.

I'd deprecate it first and then remove.

>  >   To be compatible with old systems, 0x11 will still be the default
>  >   IOAPIC version. Here 0x11 and 0x20 are the only versions to be
>  >   supported.
looking at the code removed, default is 0x20 which doesn't match above
statement. Have something changed between then and now (missing ref to
0x20 becoming default)?

>  >
>  >   One thing to mention: this patch only applies to emulated IOAPIC. It
>  >   does not affect kernel IOAPIC behavior. =20
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> ---
>  hw/intc/ioapic_internal.h |  3 +--
>  hw/intc/ioapic.c          | 18 ++----------------
>  hw/intc/ioapic_common.c   |  2 +-
>  3 files changed, 4 insertions(+), 19 deletions(-)
>=20
> diff --git a/hw/intc/ioapic_internal.h b/hw/intc/ioapic_internal.h
> index 51205767f44..330ce195222 100644
> --- a/hw/intc/ioapic_internal.h
> +++ b/hw/intc/ioapic_internal.h
> @@ -82,7 +82,7 @@
>  #define IOAPIC_ID_MASK                  0xf
> =20
>  #define IOAPIC_VER_ENTRIES_SHIFT        16
> -
> +#define IOAPIC_VER_DEF                  0x20
> =20
>  #define TYPE_IOAPIC_COMMON "ioapic-common"
>  OBJECT_DECLARE_TYPE(IOAPICCommonState, IOAPICCommonClass, IOAPIC_COMMON)
> @@ -104,7 +104,6 @@ struct IOAPICCommonState {
>      uint32_t irr;
>      uint64_t ioredtbl[IOAPIC_NUM_PINS];
>      Notifier machine_done;
> -    uint8_t version;
>      uint64_t irq_count[IOAPIC_NUM_PINS];
>      int irq_level[IOAPIC_NUM_PINS];
>      int irq_eoi[IOAPIC_NUM_PINS];
> diff --git a/hw/intc/ioapic.c b/hw/intc/ioapic.c
> index 133bef852d1..5cc97767d9d 100644
> --- a/hw/intc/ioapic.c
> +++ b/hw/intc/ioapic.c
> @@ -315,7 +315,7 @@ ioapic_mem_read(void *opaque, hwaddr addr, unsigned i=
nt size)
>              val =3D s->id << IOAPIC_ID_SHIFT;
>              break;
>          case IOAPIC_REG_VER:
> -            val =3D s->version |
> +            val =3D IOAPIC_VER_DEF |
>                  ((IOAPIC_NUM_PINS - 1) << IOAPIC_VER_ENTRIES_SHIFT);
>              break;
>          default:
> @@ -411,8 +411,7 @@ ioapic_mem_write(void *opaque, hwaddr addr, uint64_t =
val,
>          }
>          break;
>      case IOAPIC_EOI:
> -        /* Explicit EOI is only supported for IOAPIC version 0x20 */
> -        if (size !=3D 4 || s->version !=3D 0x20) {
> +        if (size !=3D 4) {
>              break;
>          }
>          ioapic_eoi_broadcast(val);
> @@ -444,18 +443,10 @@ static void ioapic_machine_done_notify(Notifier *no=
tifier, void *data)
>  #endif
>  }
> =20
> -#define IOAPIC_VER_DEF 0x20
> -
>  static void ioapic_realize(DeviceState *dev, Error **errp)
>  {
>      IOAPICCommonState *s =3D IOAPIC_COMMON(dev);
> =20
> -    if (s->version !=3D 0x11 && s->version !=3D 0x20) {
> -        error_setg(errp, "IOAPIC only supports version 0x11 or 0x20 "
> -                   "(default: 0x%x).", IOAPIC_VER_DEF);
> -        return;
> -    }
> -
>      memory_region_init_io(&s->io_memory, OBJECT(s), &ioapic_io_ops, s,
>                            "ioapic", 0x1000);
> =20
> @@ -476,10 +467,6 @@ static void ioapic_unrealize(DeviceState *dev)
>      timer_free(s->delayed_ioapic_service_timer);
>  }
> =20
> -static const Property ioapic_properties[] =3D {
> -    DEFINE_PROP_UINT8("version", IOAPICCommonState, version, IOAPIC_VER_=
DEF),
> -};
> -
>  static void ioapic_class_init(ObjectClass *klass, const void *data)
>  {
>      IOAPICCommonClass *k =3D IOAPIC_COMMON_CLASS(klass);
> @@ -493,7 +480,6 @@ static void ioapic_class_init(ObjectClass *klass, con=
st void *data)
>       */
>      k->post_load =3D ioapic_update_kvm_routes;
>      device_class_set_legacy_reset(dc, ioapic_reset_common);
> -    device_class_set_props(dc, ioapic_properties);
>  }
> =20
>  static const TypeInfo ioapic_info =3D {
> diff --git a/hw/intc/ioapic_common.c b/hw/intc/ioapic_common.c
> index fce3486e519..8b3e2ba9384 100644
> --- a/hw/intc/ioapic_common.c
> +++ b/hw/intc/ioapic_common.c
> @@ -83,7 +83,7 @@ static void ioapic_print_redtbl(GString *buf, IOAPICCom=
monState *s)
>      int i;
> =20
>      g_string_append_printf(buf, "ioapic0: ver=3D0x%x id=3D0x%02x sel=3D0=
x%02x",
> -                           s->version, s->id, s->ioregsel);
> +                           IOAPIC_VER_DEF, s->id, s->ioregsel);
>      if (s->ioregsel) {
>          g_string_append_printf(buf, " (redir[%u])\n",
>                                 (s->ioregsel - IOAPIC_REG_REDTBL_BASE) >>=
 1);


