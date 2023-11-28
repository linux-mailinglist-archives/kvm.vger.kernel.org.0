Return-Path: <kvm+bounces-2645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FBD87FBE1E
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 16:32:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC4F7282E93
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 131C85E0B1;
	Tue, 28 Nov 2023 15:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GE3baWR/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE1410F6
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 07:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701185550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tg6RYWeqCpwUoQCzRfUgguApc1UmfoSk7iO/0ub4xnQ=;
	b=GE3baWR/Ic4lSqM+v8Iuv73mh2HZZpi9dI02qi8AP6pwNWJMpevamHRbSRMwxQpubAuAK7
	XU6CxE6gfXMXA1yvWMEy3kAKNJ9cCws4XzqT0/XjxnntvgbRYPwFTTNuaswMkZ4lCDJO9R
	2hJ/u8EliY199YwYpG+NOgjJP5HOjvo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-BlJXkXZgPl-VmAsKJx4kSA-1; Tue, 28 Nov 2023 10:32:29 -0500
X-MC-Unique: BlJXkXZgPl-VmAsKJx4kSA-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-548cf45e962so3941226a12.2
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 07:32:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701185545; x=1701790345;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tg6RYWeqCpwUoQCzRfUgguApc1UmfoSk7iO/0ub4xnQ=;
        b=bgv40ecW8bHiiTUnE/VPgqvoQuZCT3qWC6nQHLwFLifUrb+4BWWigj3xuUc6XFhqSB
         /I46FfI+7wXXbkrdmDlHv6fLaj8u/q7zFBpZXUaNZpv/+V70x6KUwcItdpNGyp5WS4rR
         lHu0SMYzyZdwn7lxnrWLaE9naLynQE4uJXcQzzD4+dfnZjByzyIA+Zdst8jXXpZy7COt
         x5dGhEXXEMAVGx9aPnUWQmZrHVh14CZCplj7N5vQrk6Eb5xRCK5ft+jVwixCBQ+Vu0oj
         l1WAlGPQnoMfJE6Y42LIJZd0f2jfPHOXURkbZbEQzOowoxI6gMwbQfSMo/ASsh/A2Rsw
         +9+A==
X-Gm-Message-State: AOJu0YydnhaASgxGLZomLFbPXx8U/6HCny1S8N1YOyhD0JGA1cvopKr8
	ZKQsXBQchfHdJXk9idfwGOBaPm1EgXAEy40dEfaWSOvJjS/M9lj8KN8Hmsm8lI5KRzcVly/9CGV
	30Lf/zQUgqJ8q
X-Received: by 2002:a05:6402:ca9:b0:54b:8a3:33d4 with SMTP id cn9-20020a0564020ca900b0054b08a333d4mr8894228edb.21.1701185545212;
        Tue, 28 Nov 2023 07:32:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHMGpmPt7p6iX1F5rrS2VkmRstyL767+5Ii7X39+PL6kV21emtghvT6KRos4CGfcShd+vt/lQ==
X-Received: by 2002:a05:6402:ca9:b0:54b:8a3:33d4 with SMTP id cn9-20020a0564020ca900b0054b08a333d4mr8894200edb.21.1701185544908;
        Tue, 28 Nov 2023 07:32:24 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id z40-20020a509e2b000000b0054b79a10c5bsm2011932ede.1.2023.11.28.07.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 07:32:24 -0800 (PST)
Date: Tue, 28 Nov 2023 16:32:21 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Laurent Vivier <laurent@vivier.eu>, Paolo Bonzini
 <pbonzini@redhat.com>, Max Filippov <jcmvbkbc@gmail.com>, David Hildenbrand
 <david@redhat.com>, Peter Xu <peterx@redhat.com>, Anton Johansson
 <anjo@rev.ng>, Peter Maydell <peter.maydell@linaro.org>,
 kvm@vger.kernel.org, Marek Vasut <marex@denx.de>, David Gibson
 <david@gibson.dropbear.id.au>, Brian Cain <bcain@quicinc.com>, Yoshinori
 Sato <ysato@users.sourceforge.jp>, "Edgar E . Iglesias"
 <edgar.iglesias@gmail.com>, Claudio Fontana <cfontana@suse.de>, Daniel
 Henrique Barboza <dbarboza@ventanamicro.com>, Artyom Tarasenko
 <atar4qemu@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 qemu-ppc@nongnu.org, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Aurelien
 Jarno <aurelien@aurel32.net>, Ilya Leoshkevich <iii@linux.ibm.com>, Daniel
 Henrique Barboza <danielhb413@gmail.com>, Bastian Koppelmann
 <kbastian@mail.uni-paderborn.de>, =?UTF-8?B?Q8OpZHJpYw==?= Le Goater
 <clg@kaod.org>, Alistair Francis <alistair.francis@wdc.com>, Alessandro Di
 Federico <ale@rev.ng>, Song Gao <gaosong@loongson.cn>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, Chris Wulff <crwulff@gmail.com>, "Michael S.
 Tsirkin" <mst@redhat.com>, Alistair Francis <alistair@alistair23.me>,
 Fabiano Rosas <farosas@suse.de>, qemu-s390x@nongnu.org, Yanan Wang
 <wangyanan55@huawei.com>, Luc Michel <luc@lmichel.fr>, Weiwei Li
 <liweiwei@iscas.ac.cn>, Bin Meng <bin.meng@windriver.com>, Stafford Horne
 <shorne@gmail.com>, Xiaojuan Yang <yangxiaojuan@loongson.cn>, "Daniel P .
 Berrange" <berrange@redhat.com>, Thomas Huth <thuth@redhat.com>,
 qemu-arm@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>, Richard
 Henderson <richard.henderson@linaro.org>, Aleksandar Rikalo
 <aleksandar.rikalo@syrmia.com>, Bernhard Beschow <shentey@gmail.com>, Mark
 Cave-Ayland <mark.cave-ayland@ilande.co.uk>, qemu-riscv@nongnu.org, Alex
 =?UTF-8?B?QmVubsOpZQ==?= <alex.bennee@linaro.org>, Nicholas Piggin
 <npiggin@gmail.com>, Greg Kurz <groug@kaod.org>, Michael Rolnik
 <mrolnik@gmail.com>, Eduardo Habkost <eduardo@habkost.net>, Markus
 Armbruster <armbru@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>
Subject: Re: [PATCH 01/22] target/i386: Only realize existing APIC device
Message-ID: <20231128163221.6c91e013@imammedo.users.ipa.redhat.com>
In-Reply-To: <20230918160257.30127-2-philmd@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
	<20230918160257.30127-2-philmd@linaro.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Sep 2023 18:02:34 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> APIC state is created under a certain condition,
> use the same condition to realize it.
> Having a NULL APIC state is a bug: use assert().
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> ---
>  target/i386/cpu-sysemu.c | 9 +++------
>  target/i386/cpu.c        | 8 +++++---
>  2 files changed, 8 insertions(+), 9 deletions(-)
>=20
> diff --git a/target/i386/cpu-sysemu.c b/target/i386/cpu-sysemu.c
> index 2375e48178..6a164d3769 100644
> --- a/target/i386/cpu-sysemu.c
> +++ b/target/i386/cpu-sysemu.c
> @@ -272,9 +272,7 @@ void x86_cpu_apic_create(X86CPU *cpu, Error **errp)
>      APICCommonState *apic;
>      APICCommonClass *apic_class =3D apic_get_class(errp);
> =20
> -    if (!apic_class) {
> -        return;
> -    }
> +    assert(apic_class);

if errp doesn't lead to error_fatal/abort, wouldn't that effectively mask
following error
 apic_get_class():
      error_setg(errp, "KVM does not support userspace APIC");
      return NULL;
???

> =20
>      cpu->apic_state =3D DEVICE(object_new_with_class(OBJECT_CLASS(apic_c=
lass)));
>      object_property_add_child(OBJECT(cpu), "lapic",
> @@ -293,9 +291,8 @@ void x86_cpu_apic_realize(X86CPU *cpu, Error **errp)
>      APICCommonState *apic;
>      static bool apic_mmio_map_once;
> =20
> -    if (cpu->apic_state =3D=3D NULL) {
> -        return;
> -    }
> +    assert(cpu->apic_state);

it would be better to explode in one place only inside apic_get_class(),
provided !kvm_irqchip_in_kernel() case is dealt with properly.


>      qdev_realize(DEVICE(cpu->apic_state), NULL, errp);
> =20
>      /* Map APIC MMIO area */
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index b2a20365e1..a23d4795e0 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -7448,9 +7448,11 @@ static void x86_cpu_realizefn(DeviceState *dev, Er=
ror **errp)
>      }
> =20
>  #ifndef CONFIG_USER_ONLY
> -    x86_cpu_apic_realize(cpu, &local_err);
> -    if (local_err !=3D NULL) {
> -        goto out;
> +    if (cpu->env.features[FEAT_1_EDX] & CPUID_APIC || ms->smp.cpus > 1) {
> +        x86_cpu_apic_realize(cpu, &local_err);
> +        if (local_err !=3D NULL) {
> +            goto out;
> +        }

better move 'if (cpu->apic_state =3D=3D NULL) {' from x86_cpu_apic_realize()
to the caller, instead of repeating test again.

>      }
>  #endif /* !CONFIG_USER_ONLY */
>      cpu_reset(cs);


