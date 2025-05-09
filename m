Return-Path: <kvm+bounces-46075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F298DAB18F5
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 17:39:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52ECCA2099B
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 15:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AAA922F778;
	Fri,  9 May 2025 15:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AXMiOVns"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2783B224882
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 15:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746805150; cv=none; b=mZ3vBIXpUiDfdhjCJ26g0QADtQ+M3xOyimoIoR3VQNDtdcEx9OPsDbhSd+KKXvkOz0owF3bhjPpfPKMLxEGmos2pN8CCegbtAj6/BhSMleUPZDh1dwvEt4S1kovkS3eJNkfJPANiLB2IEFENPtQFQse8FQKMze3W/1ar52Ufdfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746805150; c=relaxed/simple;
	bh=rJ73UCHMnGLLWzjZXtZ9NCQsGMPRoJRIaHGYmFcH62o=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kJsNDo7zKc6LbMgLwdzqZWA4i2xdz4bzoRyskP5p4yHpf2JOw8tl+RFHbw5Nabf8X3ccH67yBcIkpho2mxEOjpleDBJMzlsxTf9IhYiFBC5WwWdq+WGgY9Q6dv9kr9Yu1PL6rhyDYQRy9BLuEXrhLE8Bo3YjP3WXCujwaDo53LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AXMiOVns; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746805148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XjfMm92yDrp8r2ZOJnfR/TKWAwp/QZ0ox7aMgUojhHI=;
	b=AXMiOVnsR9SOWjPswTPTP7LV9T6+m0xql3Vlb0259OPqCZC17ZFAzaz4E95UKG8XwtJvYU
	3pJJB0U5nXBtm7Qc6jscWp1uMydfa8czLZeBUbayLJbL6Gkp6r1n4+veyesUIM8kvjYG+f
	7zmrQLwVv3XFCi7iKkuNeEK8bsckRHQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-t7XcDGUpNcOMj8uhZ96-uA-1; Fri, 09 May 2025 11:39:06 -0400
X-MC-Unique: t7XcDGUpNcOMj8uhZ96-uA-1
X-Mimecast-MFC-AGG-ID: t7XcDGUpNcOMj8uhZ96-uA_1746805145
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-39c1b1c0969so1355689f8f.1
        for <kvm@vger.kernel.org>; Fri, 09 May 2025 08:39:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746805145; x=1747409945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XjfMm92yDrp8r2ZOJnfR/TKWAwp/QZ0ox7aMgUojhHI=;
        b=F1phgThvU115yVp0JUJWPT+Ug+yBRLRLWBafoOzbyKUwW28slJskpVH5MgXa5furpm
         Q24RZoKberJ/5ydAmiKb8rYRUibDkG1g7cld18vw2b0JfEydbVN9N335eAVeUJobZZF2
         sYB9OPnIIPZwDb5/1nrFUGT0ZYmZvhApNd9Z8AqIAajSBUAYOZ6y0w54UreQ18la1+c1
         ZTkHNpxWLXKQpn8GUFfP6eeZ2vwb6VlecJinOVTvAWrwCsGzm+ikoJNWb0NBHvkZTedh
         oLWBGwCF/z3nHWTKkpRhZwKdlTjF1NgCCeFOihrMZI1JfNDH69bfmM8BTZgdIKgj7KHA
         PO7A==
X-Forwarded-Encrypted: i=1; AJvYcCVCtMVOkxr9Mga+9/h9pgCXihhEurakAbaU1RYp08/pVcOcLOKzETVRLqTx25OQeiDQ70s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLnTdwQJxrTODOYZLDT9FsFoU5Irn02jm4ZxnaKVJ9Q4GTBmDw
	x8rD2t0ylVOnSo/QfEDPHz0xkSpIqvYYba7Q3HyAwAApm5ejS9d9Y9IyxYnWfDWMkeFCcxbswnL
	S+ID6cy/FnEnU1PUNiC2MsKjqLrfj/cc9emLdmtxBNoyl+obD4Q==
X-Gm-Gg: ASbGnctVljeS2EqjvfTE8eUFRoBbbxyDtYQT8SB1Ac9FK8aT09+QqeQAZmOfAVPqa+x
	kIEcL0kcXCMQlXk1rqHz53cjSaXIdKzA+CDE7njVIlYo0x7kZqCqSdcg4FC3SeV1oD4wem+KrS0
	Jl5XZrZCBfPF94QEs+/XrLjKdPQPgBwBPgleHEQCcoihWtw48z03AMutvEsz8PUDcgYIxpyCn+D
	ZuzBpnKASJHPQ5wDJQM5A0GXCYojxQw4YJFxDZnKxOILqgmZcn18xac6ghwBr3kcj0oQhq6/RqZ
	lkfJua5T9FKKoeVKyd3ON3Lvy6UJ3wpg
X-Received: by 2002:a5d:64ad:0:b0:3a0:b4f1:8bda with SMTP id ffacd0b85a97d-3a1f643ac2fmr3272178f8f.1.1746805144997;
        Fri, 09 May 2025 08:39:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGhKPmGTam1SWc4Gq6m5qYczHRHd+/PPrONEzG16dZjSMP8SZ3aFRBc8dbuayiDSu1cWlR1ag==
X-Received: by 2002:a5d:64ad:0:b0:3a0:b4f1:8bda with SMTP id ffacd0b85a97d-3a1f643ac2fmr3272131f8f.1.1746805144552;
        Fri, 09 May 2025 08:39:04 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f57de001sm3565183f8f.20.2025.05.09.08.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 08:39:04 -0700 (PDT)
Date: Fri, 9 May 2025 17:39:02 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>,
 qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
 kvm@vger.kernel.org, Sergio Lopez <slp@redhat.com>, Gerd Hoffmann
 <kraxel@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Laurent
 Vivier <lvivier@redhat.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu
 <yi.l.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, Eduardo
 Habkost <eduardo@habkost.net>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, qemu-riscv@nongnu.org, Weiwei Li
 <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>, Yanan Wang
 <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>, Palmer Dabbelt
 <palmer@dabbelt.com>, Ani Sinha <anisinha@redhat.com>, Fabiano Rosas
 <farosas@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Liu Zhiwei
 <zhiwei_liu@linux.alibaba.com>, =?UTF-8?B?Q2zDqW1lbnQ=?= Mathieu--Drif
 <clement.mathieu--drif@eviden.com>, qemu-arm@nongnu.org, =?UTF-8?B?TWFy?=
 =?UTF-8?B?Yy1BbmRyw6k=?= Lureau <marcandre.lureau@redhat.com>, Huacai Chen
 <chenhuacai@kernel.org>, Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v4 06/27] hw/nvram/fw_cfg: Rename fw_cfg_init_mem_wide()
 -> fw_cfg_init_mem_dma()
Message-ID: <20250509173902.718c2dc5@imammedo.users.ipa.redhat.com>
In-Reply-To: <aB2l25PwH4e0jaTb@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-7-philmd@linaro.org>
	<aB2l25PwH4e0jaTb@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 9 May 2025 14:51:07 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> On Thu, May 08, 2025 at 03:35:29PM +0200, Philippe Mathieu-Daud=C3=A9 wro=
te:
> > Date: Thu,  8 May 2025 15:35:29 +0200
> > From: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> > Subject: [PATCH v4 06/27] hw/nvram/fw_cfg: Rename fw_cfg_init_mem_wide(=
) ->
> >  fw_cfg_init_mem_dma()
> > X-Mailer: git-send-email 2.47.1
> >=20
> > "wide" in fw_cfg_init_mem_wide() means "DMA support".
> > Rename for clarity.
> >=20
> > Suggested-by: Zhao Liu <zhao1.liu@intel.com>
> > Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> > ---
> >  include/hw/nvram/fw_cfg.h | 6 +++---
> >  hw/arm/virt.c             | 2 +-
> >  hw/nvram/fw_cfg.c         | 6 +++---
> >  hw/riscv/virt.c           | 4 ++--
> >  4 files changed, 9 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/include/hw/nvram/fw_cfg.h b/include/hw/nvram/fw_cfg.h
> > index d5161a79436..c4c49886754 100644
> > --- a/include/hw/nvram/fw_cfg.h
> > +++ b/include/hw/nvram/fw_cfg.h
> > @@ -309,9 +309,9 @@ FWCfgState *fw_cfg_init_io_dma(uint32_t iobase, uin=
t32_t dma_iobase,
> >                                  AddressSpace *dma_as);
> >  FWCfgState *fw_cfg_init_mem_nodma(hwaddr ctl_addr, hwaddr data_addr,
> >                                    unsigned data_width);
> > -FWCfgState *fw_cfg_init_mem_wide(hwaddr ctl_addr,
> > -                                 hwaddr data_addr, uint32_t data_width,
> > -                                 hwaddr dma_addr, AddressSpace *dma_as=
);
> > +FWCfgState *fw_cfg_init_mem_dma(hwaddr ctl_addr,
> > +                                hwaddr data_addr, uint32_t data_width,
> > +                                hwaddr dma_addr, AddressSpace *dma_as)=
; =20
>=20
> There's one more use in latest master:
>=20
> git grep fw_cfg_init_mem_wide
> hw/loongarch/fw_cfg.c:    fw_cfg =3D fw_cfg_init_mem_wide(VIRT_FWCFG_BASE=
 + 8, VIRT_FWCFG_BASE, 8,

with that fixed:
  Reviewed-by: Igor Mammedov <imammedo@redhat.com>


