Return-Path: <kvm+bounces-46073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D786CAB18D2
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 17:35:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA3095255C7
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 15:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 091FE22E3FD;
	Fri,  9 May 2025 15:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZFGbZw/O"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CCC21B9CE
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 15:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746804928; cv=none; b=ucZzN5dPCLVoa975m27eWjHT+Ew7IgJUQ81BTqooadIUoJZBxURCKQAiM7/KQeFbxsjdCXBL239Fua84K8gZss5P3KGu4dkU86Q9+aeZQqgRp9r5xTp9bq4ue1QLTNKjx2Av8gtsfhO+Zi+vck7JHYuKdtHBBdoBj1xZG7o6Wyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746804928; c=relaxed/simple;
	bh=/1OWeYzNZb24eJtczRx1xZ6IizjxkO5KMaeMzrkc/IU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F9JXLY1CqlWyYGa1KxUTHtErmEIUUIfm8A4Jd0QPwZ5KJl6/ttaF7A+3yc4CUbbRtEDkKiuNjC8mYGLqs10bnsO3QnJncXFOHOdgWxV3RGlV7tkN2JPUkR/59Q/7mjIoSkpgHQuiA/Mu96+pO07zgLrRhte7jxBJTO+lUQB8DWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZFGbZw/O; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746804925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KvgodsRX5jVPKQKXhLVAtbiUkGwGclYVHGBsI+/pme4=;
	b=ZFGbZw/ORZvsvZ8/aZoqiIKWUdl8L6xW1T0cFtqaT7C8FEvTOK/GnABDON/13HFM+uAgfR
	dq8B9nxYak79efMcbTbZ0jg0sGJ7JTajzLAlBWqL9hr5GnQN2f2k3Ntl8w6JpsFHlBoXHs
	mL5fxQZgpcCZGFuO2pI/r+ZXLNimbng=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-686-FJF-P9iRP5aTlXr0KO3SWA-1; Fri, 09 May 2025 11:35:24 -0400
X-MC-Unique: FJF-P9iRP5aTlXr0KO3SWA-1
X-Mimecast-MFC-AGG-ID: FJF-P9iRP5aTlXr0KO3SWA_1746804923
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-440667e7f92so12100305e9.3
        for <kvm@vger.kernel.org>; Fri, 09 May 2025 08:35:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746804923; x=1747409723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KvgodsRX5jVPKQKXhLVAtbiUkGwGclYVHGBsI+/pme4=;
        b=tut5Vl/YNbszwOWcppO5dwsYJNRCOx7bp5Z4Twcgi0delL9xD50raYUF+Znqa+8E6H
         KzR7vUye9UfL6C9m5Wy5IPaGHIj+NqTz7x8zYL91vkVdth1qqJvbxsfoYqYIUM843KrV
         LneeM+WSnRgXaTs3nl2DiwZ3XmuEO819am7rB0BWSulbrHiyl/s0sA0cHpNdS9m9VQZx
         aL2Q9dI+wOEFkFwrpSYZcyNDH/MMMZljVVXB38FPSHyyzSjduuHqVUmVnSL7EHvDh1fT
         C+qj9TUTIL3Ma8bDW81wbDQqFJCWNJ6TZzgW4/IJsVeMqJWcnBYdqqAnSKCCc04PQPxU
         akEg==
X-Forwarded-Encrypted: i=1; AJvYcCUSA0q1vHC8aupaJUSllAvxsxRVx1zYRWgEsSysKzVZSIf9ECqAq5CgUchAQIVjjvwOaIY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNRHHcl5C4z6nXMWMpTtEFyuy0dakNVLTJggVfRmUJHzbDqgCO
	NRuaL4k7uIhvLDj6cbadlFtDSfEf1bTuHvhpQCWx1AWT2LPkPq0u5pXgP3SELp1L6FyJYKhhUqh
	Fx9Uuz55yQPAHv21RZxWangOXhi3RTzlszZ3cxcxDU9aZUuvycA==
X-Gm-Gg: ASbGnctgibXn4zdU/3YbbePyW9me8lqWuGEGXHx9CIeT2Ddg/3tUf2BwuoWmc7K+e+L
	K71DW0yO7b7uHJIXmhK9g1dzjPrYOaqhIQwmidL8dTnl/b1pr7dvnQrJc/GhLJCR3ZCAZYK51/F
	zNhE7G+JKav2wRIsQIqpHxp9bZS7GIelyGuoi6YHlTo3g86FWmCyq1j4BeO7B1Zoo9shW40DRzk
	dc7mjJECqfNWfyzJLrodlUXPbzqmfv6fGtjLTwJh9peMMqKHIBEiROcXxdb4JjpXZBH3Z0rhgu6
	YCNCWusj/oTbdJAEPfqij9vtnpP2dOY9
X-Received: by 2002:a05:600c:1d8c:b0:43c:fe85:e4ba with SMTP id 5b1f17b1804b1-442d6d6477amr38265145e9.15.1746804923097;
        Fri, 09 May 2025 08:35:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNyAfppT9uee9ogVYiyR4nXpot/QB0mvHEteKSSPEKtPIA4s/28JMxoH1SBEhBGoRPk3h89g==
X-Received: by 2002:a05:600c:1d8c:b0:43c:fe85:e4ba with SMTP id 5b1f17b1804b1-442d6d6477amr38264785e9.15.1746804922673;
        Fri, 09 May 2025 08:35:22 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd32f1eesm76794905e9.9.2025.05.09.08.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 08:35:22 -0700 (PDT)
Date: Fri, 9 May 2025 17:35:19 +0200
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
Subject: Re: [PATCH v4 04/27] hw/mips/loongson3_virt: Prefer using
 fw_cfg_init_mem_nodma()
Message-ID: <20250509173519.50d4f073@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250508133550.81391-5-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-5-philmd@linaro.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  8 May 2025 15:35:27 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> fw_cfg_init_mem_wide() is prefered to initialize fw_cfg
> with DMA support. Without DMA, use fw_cfg_init_mem_nodma().
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>

Reviewed-by: Igor Mammedov <imammedo@redhat.com>

> ---
>  hw/mips/loongson3_virt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/hw/mips/loongson3_virt.c b/hw/mips/loongson3_virt.c
> index de6fbcc0cb4..654a2f0999f 100644
> --- a/hw/mips/loongson3_virt.c
> +++ b/hw/mips/loongson3_virt.c
> @@ -286,7 +286,7 @@ static void fw_conf_init(void)
>      FWCfgState *fw_cfg;
>      hwaddr cfg_addr =3D virt_memmap[VIRT_FW_CFG].base;
> =20
> -    fw_cfg =3D fw_cfg_init_mem_wide(cfg_addr, cfg_addr + 8, 8, 0, NULL);

just a question, given it's a rather modern machine is there a reason
why it is not using DMA here?

> +    fw_cfg =3D fw_cfg_init_mem_nodma(cfg_addr, cfg_addr + 8, 8);
>      fw_cfg_add_i16(fw_cfg, FW_CFG_NB_CPUS, (uint16_t)current_machine->sm=
p.cpus);
>      fw_cfg_add_i16(fw_cfg, FW_CFG_MAX_CPUS, (uint16_t)current_machine->s=
mp.max_cpus);
>      fw_cfg_add_i64(fw_cfg, FW_CFG_RAM_SIZE, loaderparams.ram_size);


