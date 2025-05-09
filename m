Return-Path: <kvm+bounces-46077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 654BEAB1915
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 17:44:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E01107AA791
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 15:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47E8A22DF82;
	Fri,  9 May 2025 15:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zf7o4/Hl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2C117C208
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 15:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746805450; cv=none; b=j098G1nrjkzn9SSGtE3IkDtEmO+AIGnfUOTICI9SUXgShL6ayeNPjPlfRSRPVqxPmxMsf5SICrTuOyD8kmS+EYMSILuRLDFS4GQI6giWcISpA3Vki+/vNZSwPqOifwkV1ZGL/ifJoP+/ZdOLezEBXGUy58BfOhV418XXSYmu6hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746805450; c=relaxed/simple;
	bh=8zBOLKmkYsWLTVC5zbXXw+r6uQDZmxWl2Wi7T2IQRaM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H8n2Ss+/q5jaJ2CWDW7TtS9StoqLZWsCJnrm1wTVbcIbzMp0ntG/5OB6tNRdt3JgF4EoLG4nzcWEawoX5KvHD8Qjp2qDnXtfsbdTZPbmBJaZPwX7QGe7A+W6Wa8c874XY3gixSRNww6VSF4C1lhcmEGxWgERFsk4DMZkOcjDdE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zf7o4/Hl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746805447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K3YdAPz/G+ySpv1BewJ+oTg4/vb8fkPHd3D7oo2CbsY=;
	b=Zf7o4/Hlp8E9u1JxH8+xsw0ZPEvO0ZvoCGFCkPSxC9nFpT2ibgoKb5PtKM4v+ZkucG1q9C
	QYFQFGCZkACj+gOM8KF4ibFMzduxyCueYID7EgUVZMeGlR0iS6AAquWoYr0fU4OzRgL73m
	NI3ED+ENXxxOAW0zR7RY349ciV8wFRQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-339-QGSVEkvdNPe2TFUkSbi3WA-1; Fri, 09 May 2025 11:44:04 -0400
X-MC-Unique: QGSVEkvdNPe2TFUkSbi3WA-1
X-Mimecast-MFC-AGG-ID: QGSVEkvdNPe2TFUkSbi3WA_1746805443
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a1f7204d72so511690f8f.0
        for <kvm@vger.kernel.org>; Fri, 09 May 2025 08:44:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746805443; x=1747410243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K3YdAPz/G+ySpv1BewJ+oTg4/vb8fkPHd3D7oo2CbsY=;
        b=Ur/S5SJEuFifGB7OY0K47eXXXQNfzIIJn2bWJAguo8vDtiRhuQY5atL5j6uqDCIu1R
         qi3zsc85rnjtgGKIusyI/VadLDp7yaOfQBrOrDH5EFHcuKWka110px0XvaSuaZczrnGn
         CGJNmgG/FPW9H2s64qKtlaFhZ5yFDM0gYtZDu644geYgrwXjJg+oYGUOTjgOIRlP5/aD
         N0/FQKSuXg2bOfnmuifhFsdxDFHD8ymiCwOy71usZ9zvz8JM13TAI+F6pZa2xmHYnTWg
         DbY/5Aaydautu96ngPxqBxWqnCvZg9RFlc98+i5HESIFinlnsIbKBx37dBEG9MoeJXBj
         GqmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWis4Cpa0HXq+6eOzh374KtRznkJYiBQ5v2MG+FB9PyxBRqAhtAtk2Q7/YxFbm8VLXpW0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHVxgYmd861TtDSAWxjrddn7ussIiGhlz8CuFZBTxmq/UGT8Nj
	FzOaU2n7Tgl2clSKJ4oSwLoOvVjUT64vBee9xTu1nIVThFqDMqyVfcKJqRJ+bSb7tUI4J8TQQ6q
	rU2uZbJgbo4Emg15yIXgW+eVgdjJmiXKTR5RQ1sqiMMfSHdWvXA==
X-Gm-Gg: ASbGnctVrBLaExjQV+BYQgesHNl2WD3DanFXpLB9kAtkfDxHXPR+usGMdYBBe5C1Wcz
	+rn10a61sAdBTtuyfoIUAHyuIMo6CxkO4ettBoQRJZjfsIXcLbzOfVLsmK/lIwlK/dX+LiBOKDU
	vJdItZ4jQVFuqzMDZTXrOwZyRX3M/8WSpkWfWy4qjZKlmpCmWqaL98gEfI7rsNM3j9xIj3+8uVi
	7tELKDZlmviE2qClJiiRQfGID418baMMUxkbUr+4azrdtXlCbzEMj5U1jXH6MN1fysKqMMRKGnU
	MAjvYWizIJSqTZAVohBSDpUIaauhBRrv
X-Received: by 2002:a05:6000:a90:b0:3a1:f8d1:6340 with SMTP id ffacd0b85a97d-3a1f8d163efmr2412468f8f.34.1746805443458;
        Fri, 09 May 2025 08:44:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJ4tApLs/7beq2ISsmZX0H/5JPrpQGPA+N4z3F46IuN+nZ43V5QuLAvkC132uAnnrZxwdO0w==
X-Received: by 2002:a05:6000:a90:b0:3a1:f8d1:6340 with SMTP id ffacd0b85a97d-3a1f8d163efmr2412425f8f.34.1746805442994;
        Fri, 09 May 2025 08:44:02 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f5a2d2c8sm3612110f8f.61.2025.05.09.08.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 08:44:02 -0700 (PDT)
Date: Fri, 9 May 2025 17:44:00 +0200
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
 Wang <jasowang@redhat.com>
Subject: Re: [PATCH v4 07/27] hw/i386/x86: Remove
 X86MachineClass::fwcfg_dma_enabled field
Message-ID: <20250509174400.1cb2ca7b@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250509174125.41bc03a3@imammedo.users.ipa.redhat.com>
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-8-philmd@linaro.org>
	<20250509174125.41bc03a3@imammedo.users.ipa.redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 9 May 2025 17:41:25 +0200
Igor Mammedov <imammedo@redhat.com> wrote:

> On Thu,  8 May 2025 15:35:30 +0200
> Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:
>=20
> > The X86MachineClass::fwcfg_dma_enabled boolean was only used
> > by the pc-q35-2.6 and pc-i440fx-2.6 machines, which got
> > removed. Remove it and simplify.
> >=20
> > 'multiboot.bin' isn't used anymore, we'll remove it in the
> > next commit.
> >=20
> > Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> > ---
> >  include/hw/i386/x86.h | 2 --
> >  hw/i386/microvm.c     | 3 ---
> >  hw/i386/multiboot.c   | 7 +------
> >  hw/i386/x86-common.c  | 3 +--
> >  hw/i386/x86.c         | 2 --
> >  5 files changed, 2 insertions(+), 15 deletions(-)
> >=20
> > diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
> > index fc460b82f82..29d37af11e6 100644
> > --- a/include/hw/i386/x86.h
> > +++ b/include/hw/i386/x86.h
> > @@ -29,8 +29,6 @@
> >  struct X86MachineClass {
> >      MachineClass parent;
> > =20
> > -    /* use DMA capable linuxboot option rom */
> > -    bool fwcfg_dma_enabled;
> >      /* CPU and apic information: */
> >      bool apic_xrupt_override;
> >  };
> > diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
> > index e0daf0d4fc3..b1262fb1523 100644
> > --- a/hw/i386/microvm.c
> > +++ b/hw/i386/microvm.c
> > @@ -637,7 +637,6 @@ GlobalProperty microvm_properties[] =3D {
> > =20
> >  static void microvm_class_init(ObjectClass *oc, const void *data)
> >  {
> > -    X86MachineClass *x86mc =3D X86_MACHINE_CLASS(oc);
> >      MicrovmMachineClass *mmc =3D MICROVM_MACHINE_CLASS(oc);
> >      MachineClass *mc =3D MACHINE_CLASS(oc);
> >      HotplugHandlerClass *hc =3D HOTPLUG_HANDLER_CLASS(oc);
> > @@ -671,8 +670,6 @@ static void microvm_class_init(ObjectClass *oc, con=
st void *data)
> >      hc->unplug_request =3D microvm_device_unplug_request_cb;
> >      hc->unplug =3D microvm_device_unplug_cb;
> > =20
> > -    x86mc->fwcfg_dma_enabled =3D true;
> > -
> >      object_class_property_add(oc, MICROVM_MACHINE_RTC, "OnOffAuto",
> >                                microvm_machine_get_rtc,
> >                                microvm_machine_set_rtc,
> > diff --git a/hw/i386/multiboot.c b/hw/i386/multiboot.c
> > index 6e6b96bc345..bfa7e8f1e83 100644
> > --- a/hw/i386/multiboot.c
> > +++ b/hw/i386/multiboot.c
> > @@ -153,7 +153,6 @@ int load_multiboot(X86MachineState *x86ms,
> >                     int kernel_file_size,
> >                     uint8_t *header)
> >  {
> > -    bool multiboot_dma_enabled =3D X86_MACHINE_GET_CLASS(x86ms)->fwcfg=
_dma_enabled;
> >      int i, is_multiboot =3D 0;
> >      uint32_t flags =3D 0;
> >      uint32_t mh_entry_addr;
> > @@ -402,11 +401,7 @@ int load_multiboot(X86MachineState *x86ms,
> >      fw_cfg_add_bytes(fw_cfg, FW_CFG_INITRD_DATA, mb_bootinfo_data,
> >                       sizeof(bootinfo));
> > =20
> > -    if (multiboot_dma_enabled) {
> > -        option_rom[nb_option_roms].name =3D "multiboot_dma.bin";
> > -    } else {
> > -        option_rom[nb_option_roms].name =3D "multiboot.bin"; =20
>=20
> shouldn't we remove "multiboot.bin" as well?

never mind, I see it's being removed by the next patch

Reviewed-by: Igor Mammedov <imammedo@redhat.com>


