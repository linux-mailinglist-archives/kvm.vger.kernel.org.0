Return-Path: <kvm+bounces-2646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FE777FBE28
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 16:34:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CECE282910
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC62D5E0B4;
	Tue, 28 Nov 2023 15:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="al6VQ0gZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E44D1
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 07:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701185684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D9lOQjODNv02P43/kZH/wGQ3w31tJS9+8fDtN67uTGI=;
	b=al6VQ0gZmaO5cUAK8LObkne98U7txuUkzdUJ055/Tk7/NUrbDvgXMLTBHd4n1/GZ8TCCVE
	8bxj/xiagKhIXs/1da9nz6dUWczlciN9cpMkwU0FFr5vU2t+m645bmriHaGxfuH+hvSqo4
	kMFmXrY5NcLVzL1MVL4Wr+RVKelx3a8=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-Q7OM1teMNMe3L7JDLjL2iA-1; Tue, 28 Nov 2023 10:34:43 -0500
X-MC-Unique: Q7OM1teMNMe3L7JDLjL2iA-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-50abbf4ee79so6032815e87.1
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 07:34:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701185682; x=1701790482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D9lOQjODNv02P43/kZH/wGQ3w31tJS9+8fDtN67uTGI=;
        b=DBH7HK5cxGBYmrFEu0TMo+4Qh76OEmpWm7yLzkSP1kUXJ0ZS2TvmD0ak+Q7prsYXgn
         PToaqQWSq+MN7bluN9hDot43sVNGVi7z3QFbhkzYcr0u7HwpQNxtAi60OHgJKEWs2byg
         Kp59UwivDkCUbSKatn4P98eSJqBBEGaG7TBC9e/xFoZKkjnf+S/UE4Wnh1zn50uo9Ret
         TRy0bCDR/5l26Wrk5BU+jABPEcAn6sgANlvgSaRb96DhjuTzKyOYupnKnL/5ywZvxbxP
         WreEnv45zC4JuM1RU45gCk6DbdXvm54bsfAbvBFWbcaHtA9++q3S+EHOxwCDmha8rioW
         EKTA==
X-Gm-Message-State: AOJu0YyTNiXbZHPKOMtxCiClZW7gVaGDK2ZM8fZUsMa7eTfqYsk94/lG
	BFERH6TB/X8TtEOjknM22rZzbPOfZZruHk0GDYQslMVslI/O0CsYuy9mwgf4J7tR/Qt192MVOfZ
	f769FiMBM/s+6
X-Received: by 2002:ac2:4acb:0:b0:50b:ac31:28e5 with SMTP id m11-20020ac24acb000000b0050bac3128e5mr5758122lfp.65.1701185682044;
        Tue, 28 Nov 2023 07:34:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFVxWl5bdZvuMtpJUQ8Z+EaD52jviZNSCZAMpxb5IUoQ4q6GjfDoZU/DsJDwJO/WcMaVBCVag==
X-Received: by 2002:ac2:4acb:0:b0:50b:ac31:28e5 with SMTP id m11-20020ac24acb000000b0050bac3128e5mr5758085lfp.65.1701185681511;
        Tue, 28 Nov 2023 07:34:41 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id d11-20020a056402000b00b0054851cd28d2sm6365832edu.79.2023.11.28.07.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 07:34:41 -0800 (PST)
Date: Tue, 28 Nov 2023 16:34:38 +0100
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
Subject: Re: [PATCH 02/22] hw/intc/apic: Pass CPU using QOM link property
Message-ID: <20231128163438.3d257bdd@imammedo.users.ipa.redhat.com>
In-Reply-To: <20230918160257.30127-3-philmd@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
	<20230918160257.30127-3-philmd@linaro.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Sep 2023 18:02:35 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> QOM objects shouldn't access each other internals fields
> except using the QOM API.
>=20
> Declare the 'cpu' and 'base-addr' properties, set them
> using object_property_set_link() and qdev_prop_set_uint32()
> respectively.
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>

Reviewed-by: Igor Mammedov <imammedo@redhat.com>

> ---
>  hw/intc/apic_common.c    |  2 ++
>  target/i386/cpu-sysemu.c | 11 ++++++-----
>  2 files changed, 8 insertions(+), 5 deletions(-)
>=20
> diff --git a/hw/intc/apic_common.c b/hw/intc/apic_common.c
> index 68ad30e2f5..e28f7402ab 100644
> --- a/hw/intc/apic_common.c
> +++ b/hw/intc/apic_common.c
> @@ -394,6 +394,8 @@ static Property apic_properties_common[] =3D {
>                      true),
>      DEFINE_PROP_BOOL("legacy-instance-id", APICCommonState, legacy_insta=
nce_id,
>                       false),
> +    DEFINE_PROP_LINK("cpu", APICCommonState, cpu, TYPE_X86_CPU, X86CPU *=
),
> +    DEFINE_PROP_UINT32("base-addr", APICCommonState, apicbase, 0),
>      DEFINE_PROP_END_OF_LIST(),
>  };
> =20
> diff --git a/target/i386/cpu-sysemu.c b/target/i386/cpu-sysemu.c
> index 6a164d3769..6edfb7e2af 100644
> --- a/target/i386/cpu-sysemu.c
> +++ b/target/i386/cpu-sysemu.c
> @@ -269,7 +269,6 @@ APICCommonClass *apic_get_class(Error **errp)
> =20
>  void x86_cpu_apic_create(X86CPU *cpu, Error **errp)
>  {
> -    APICCommonState *apic;
>      APICCommonClass *apic_class =3D apic_get_class(errp);
> =20
>      assert(apic_class);
> @@ -279,11 +278,13 @@ void x86_cpu_apic_create(X86CPU *cpu, Error **errp)
>                                OBJECT(cpu->apic_state));
>      object_unref(OBJECT(cpu->apic_state));
> =20
> +    if (!object_property_set_link(OBJECT(cpu->apic_state), "cpu",
> +                                  OBJECT(cpu), errp)) {
> +        return;
> +    }
>      qdev_prop_set_uint32(cpu->apic_state, "id", cpu->apic_id);
> -    /* TODO: convert to link<> */
> -    apic =3D APIC_COMMON(cpu->apic_state);
> -    apic->cpu =3D cpu;
> -    apic->apicbase =3D APIC_DEFAULT_ADDRESS | MSR_IA32_APICBASE_ENABLE;
> +    qdev_prop_set_uint32(cpu->apic_state, "base-addr",
> +                         APIC_DEFAULT_ADDRESS | MSR_IA32_APICBASE_ENABLE=
);
>  }
> =20
>  void x86_cpu_apic_realize(X86CPU *cpu, Error **errp)


