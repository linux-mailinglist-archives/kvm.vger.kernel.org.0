Return-Path: <kvm+bounces-36248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 445A4A193C7
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 15:20:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 05FAC7A4DB8
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 14:20:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33CA8213E67;
	Wed, 22 Jan 2025 14:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IL34dDGI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987F817C220
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 14:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737555633; cv=none; b=O/l2ExSFDH7Jkp+uC61Sy6scTt3cZ6WPucCIuW9cVCXyk4QXnQ9mBhnTYU4/+C8+ijKFgN3mty5eRfr3ThrrDJFSmq1ZtubcNuuTMXoO9zCGDksJzmouZxS3572dgaLioPPKE0MuqR7cWtyjJ5aS+coQhhFm8qlSghG/720dgDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737555633; c=relaxed/simple;
	bh=Ctlp/Bov5/V2jj7uREn3KF0AexvoCY6y6MkTR2GJdLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QjQT2OHIzs1pfr6Ad2eKrkC+3mzUwFy9rxUnmqrj8vI/SFzzrkz835Ck8xTuTebbSoEvywZ+rvcI8ervmG40do20regBmSPUbcFy7iNe1mgp+6Jdkh0iJWkauNxyu6MsHFAfkWSxqCTo2HIKwJ14RVxZvDR5zcuH3kCww/0x+QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IL34dDGI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737555630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dut6hZbDd6BfAIsiyGgJ+kYCdZA4Ogbk5rArrmutuEA=;
	b=IL34dDGI+Niu/TMqEfHwjlPRsgz8ioTTbazTub2pK6EVN2ler2ndcMwOvpkHntR6LSvLMX
	dqeF5fhfRTFrc9z1GaKcf+aFfSZri0BJQPGhNZy+xyGZaz0UhRVnYcOMqQrVhOxIij7rqI
	cTzkST1tTmTzDGfhz3WrhJpISaEXekU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-7kMS0rHaPM-Wa-mnlDYTag-1; Wed, 22 Jan 2025 09:20:28 -0500
X-MC-Unique: 7kMS0rHaPM-Wa-mnlDYTag-1
X-Mimecast-MFC-AGG-ID: 7kMS0rHaPM-Wa-mnlDYTag
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4362f893bfaso37818885e9.1
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 06:20:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737555628; x=1738160428;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dut6hZbDd6BfAIsiyGgJ+kYCdZA4Ogbk5rArrmutuEA=;
        b=m+w7M2jIAdSAGrEiBIWd4Ohx8lWYDEGqYEIM0rGdUun7l2GdL1N4VMn8MLtghs48b1
         XLRoQ3T4OJeYjt3t5fdkhKcXOsmuUI2oN1YqEpF7LbNms1X+P+b03zkjkun9Z2Z4HbWs
         HLlcepcVyCSJSLASV+IITvUeLwXWVvlQ91WBdQ/qpS0Nrv54ZdVSSYnbwTbdnUxNifpX
         zT7hP6F6R0vNGXGE87mcGubgPh0fClyWrwQbIgiAxLIqZIV15XmBV8ofV6mIWzFxWitm
         9okAro2CtZ4E/5vhWsdGTDS/66anooFrdKMrXQtlpPGntyGlwg/MKPERFZgvHK9ftz4S
         J/ZA==
X-Forwarded-Encrypted: i=1; AJvYcCUORQIlDyBPWhod4KOCUZG/3faXQ8glb1+fdoc/N8KtU2sfKfXeihksqF5S9hSK+EH+/pA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxspN1d5GpKBJ/hZUL87+50dd6wgT3wLgufTuN7TGgWKG3eoLaP
	D40qPOs8229+/sq/pgH1leBX+lBAs7APqnm2rAuwAqQP8roGLfTPTO4e2nZC3SfkitXChsDX90P
	MBPMiZsFlL1lLrBc3GrIYdK3cfHDWyYvla6QyLa8SaI7vX3YdvQ==
X-Gm-Gg: ASbGncsUAij6mhpzPlK+NCkVgEZ5+ql5v8Ur/CqxkYce/CIP8JdaEiq1/X7mVd6wopM
	ihkYkevlwLdQqUXcIee3ictl+2OfLZEEXXoX7TO3j/Whm8MqorH/dlpibDKPBWFah2Qw5ScQJrR
	IheqrDK8BiGToFE8Sbk5R7HeviThhQZbQpoQZ49ZvXDQHukEjbrcksESfniQhu6f4DEkVluLGv9
	EeStQBV7AKssByHbl17GrMLBd6KpDyWHEjtKh+deXpvU8xUv/jjUahTHshgizQbQZO07Pbt/s70
	bOscwRylVJYemI9g7IIIhiGA5DwHrKpblzWr9ey+Yw==
X-Received: by 2002:a05:600c:4710:b0:434:a59c:43c6 with SMTP id 5b1f17b1804b1-43891451388mr174742375e9.26.1737555627660;
        Wed, 22 Jan 2025 06:20:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG5NEdwGW3AASXDNblTqeS/rrJSs7oL8g6o9u0iasINje1Lj5tIEqz7MQ/xoV62NeqtH0NxQQ==
X-Received: by 2002:a05:600c:4710:b0:434:a59c:43c6 with SMTP id 5b1f17b1804b1-43891451388mr174742065e9.26.1737555627147;
        Wed, 22 Jan 2025 06:20:27 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438b31af925sm26918075e9.23.2025.01.22.06.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 06:20:26 -0800 (PST)
Date: Wed, 22 Jan 2025 15:20:23 +0100
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
Subject: Re: [PATCH 06/22] exec/cpu: Call cpu_remove_sync() once in
 cpu_common_unrealize()
Message-ID: <20250122152023.5ee90f50@imammedo.users.ipa.redhat.com>
In-Reply-To: <5f25576c-598f-4fd7-8238-61edcff2c411@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
	<20230918160257.30127-7-philmd@linaro.org>
	<20231128174215.32d2a350@imammedo.users.ipa.redhat.com>
	<5f25576c-598f-4fd7-8238-61edcff2c411@linaro.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Jan 2025 19:05:46 +0100
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> On 28/11/23 17:42, Igor Mammedov wrote:
> > On Mon, 18 Sep 2023 18:02:39 +0200
> > Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:
> >  =20
> >> While create_vcpu_thread() creates a vCPU thread, its counterpart
> >> is cpu_remove_sync(), which join and destroy the thread.
> >>
> >> create_vcpu_thread() is called in qemu_init_vcpu(), itself called
> >> in cpu_common_realizefn(). Since we don't have qemu_deinit_vcpu()
> >> helper (we probably don't need any), simply destroy the thread in
> >> cpu_common_unrealizefn().
> >>
> >> Note: only the PPC and X86 targets were calling cpu_remove_sync(),
> >> meaning all other targets were leaking the thread when the vCPU
> >> was unrealized (mostly when vCPU are hot-unplugged).
> >>
> >> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> >> ---
> >>   hw/core/cpu-common.c  | 3 +++
> >>   target/i386/cpu.c     | 1 -
> >>   target/ppc/cpu_init.c | 2 --
> >>   3 files changed, 3 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
> >> index a3b8de7054..e5841c59df 100644
> >> --- a/hw/core/cpu-common.c
> >> +++ b/hw/core/cpu-common.c
> >> @@ -221,6 +221,9 @@ static void cpu_common_unrealizefn(DeviceState *de=
v)
> >>  =20
> >>       /* NOTE: latest generic point before the cpu is fully unrealized=
 */
> >>       cpu_exec_unrealizefn(cpu);
> >> +
> >> +    /* Destroy vCPU thread */
> >> +    cpu_remove_sync(cpu);
> >>   }
> >>  =20
> >>   static void cpu_common_initfn(Object *obj)
> >> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> >> index cb41d30aab..d79797d963 100644
> >> --- a/target/i386/cpu.c
> >> +++ b/target/i386/cpu.c
> >> @@ -7470,7 +7470,6 @@ static void x86_cpu_unrealizefn(DeviceState *dev)
> >>       X86CPUClass *xcc =3D X86_CPU_GET_CLASS(dev);
> >>  =20
> >>   #ifndef CONFIG_USER_ONLY
> >> -    cpu_remove_sync(CPU(dev));
> >>       qemu_unregister_reset(x86_cpu_machine_reset_cb, dev);
> >>   #endif =20
> >=20
> > missing  followup context:
> >      ...
> >      xcc->parent_unrealize(dev);
> >=20
> > Before the patch, vcpu thread is stopped and onnly then
> > clean up happens.
> >=20
> > After the patch we have cleanup while vcpu thread is still running.
> >=20
> > Even if it doesn't explode, such ordering still seems to be wrong. =20
>=20
> OK.

looking at all users, some do stop vcpu thread before tearing down vcpu obj=
ect
and interrupt controller, while some do it other way around or mix of both.

It's probably safe to stop vcpu thread wrt intc cleanup.
Can you check what would happen if there were a pending interrupt,
but then flowing would happen:
 1. destroying intc
 2. can vcpu thread just kicked out from KVM_RUN,
    trip over missing/invalid intc state while thread runs towards its exit=
 point?

If above can't crash then,
I'd prefer to stop vcpu at least before vcpu cleanup is run.
i.e. put cpu_remove_sync() as the very 1st call inside of cpu_common_unreal=
izefn()

> >> diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
> >> index e2c06c1f32..24d4e8fa7e 100644
> >> --- a/target/ppc/cpu_init.c
> >> +++ b/target/ppc/cpu_init.c
> >> @@ -6853,8 +6853,6 @@ static void ppc_cpu_unrealize(DeviceState *dev)
> >>  =20
> >>       pcc->parent_unrealize(dev);
> >>  =20
> >> -    cpu_remove_sync(CPU(cpu)); =20
> >=20
> > bug in current code? =20
>=20
> Plausibly. See:
>=20
> commit f1023d21e81b7bf523ddf2ac91a48117f20ef9d7
> Author: Greg Kurz <groug@kaod.org>
> Date:   Thu Oct 15 23:18:32 2020 +0200
>=20
>      spapr: Unrealize vCPUs with qdev_unrealize()
>=20
>      Since we introduced CPU hot-unplug in sPAPR, we don't unrealize the
>      vCPU objects explicitly. Instead, we let QOM handle that for us
>      under object_property_del_all() when the CPU core object is
>      finalized. The only thing we do is calling cpu_remove_sync() to
>      tear the vCPU thread down.
>=20
>      This happens to work but it is ugly because:
>      - we call qdev_realize() but the corresponding qdev_unrealize() is
>        buried deep in the QOM code
>      - we call cpu_remove_sync() to undo qemu_init_vcpu() called by
>        ppc_cpu_realize() in target/ppc/translate_init.c.inc
>      - the CPU init and teardown paths aren't really symmetrical
>=20
>      The latter didn't bite us so far but a future patch that greatly
>      simplifies the CPU core realize path needs it to avoid a crash
>      in QOM.
>=20
>      For all these reasons, have ppc_cpu_unrealize() to undo the changes
>      of ppc_cpu_realize() by calling cpu_remove_sync() at the right
>      place, and have the sPAPR CPU core code to call qdev_unrealize().
>=20
>      This requires to add a missing stub because translate_init.c.inc is
>      also compiled for user mode.
>=20
> >  =20
> >> -
> >>       destroy_ppc_opcodes(cpu);
> >>   }
> >>    =20
>=20


