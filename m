Return-Path: <kvm+bounces-46311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6CD3AB4F00
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 11:16:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31BE93A79C4
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 09:16:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92107212FA2;
	Tue, 13 May 2025 09:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JWKQDwN0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C8F1E0DFE
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 09:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747127782; cv=none; b=Mu3M1zYRf78eO+zP1KgCJZGw7s7KPpUmTrOEqh6s0He2zvmMv9KSiqRSpHfudedvZnT9PwG08fEux1/lsZEsHCIe1PNWPlTZBnsj3HRwS2kTKgDieU+cpt0ThQ4vi5W0/p1HYAsODW4+6M6kSU7fqqTVtP7TOIN/UxyIwqGnS/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747127782; c=relaxed/simple;
	bh=HNtjjCsC/MT4RXrShvWdcT3xvS8QL8bkihqK2Jg1q8c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZmZjI3S2eKmCxKvkudPg8Cak+EeaM4eaeJFmpKOE1/1aOomGL1QI07WnxdjnJ+kllFXReMOfQfSSmvM3fje/RtXwmabxU+E9CT+jsZPu5MeSqW2ePtcQ9A4hdDhn4RBsg4Hlv2TjEreS9bY79Fb0m6KAovDUyXE8OQtM+mujuN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JWKQDwN0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747127779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HlADszS+Jp7Q3TGl9uZ1eHzM09x0nyHrIGrUpdW9aBo=;
	b=JWKQDwN0pSDx/g1GA6zTji++Me02ha7VaarjpmP6bt0iQICsZ8cwkGO4MKRogGnHxPnCfA
	L1GKaK1w7ftsQagAN1FjcBM/SCY1kA13qGkIkxzvlArrZk/Zv7k+9cj6q+G065oRtsb45b
	z2XjksHhsrSdwl4gS7e5LvtsrrC1oE8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-444-moBnj5AlPgOUHe6hhvxhKQ-1; Tue, 13 May 2025 05:16:18 -0400
X-MC-Unique: moBnj5AlPgOUHe6hhvxhKQ-1
X-Mimecast-MFC-AGG-ID: moBnj5AlPgOUHe6hhvxhKQ_1747127777
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43ea256f039so39710765e9.0
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 02:16:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747127777; x=1747732577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HlADszS+Jp7Q3TGl9uZ1eHzM09x0nyHrIGrUpdW9aBo=;
        b=nWmOB+IEXx6ZRbDj7IxxiofKILAbVc54n9lj+v+dm8Iw0UKJJhyz8ToyOZJE1j44/T
         ARByJ//OFTVksnv5pfN4Xqn2zLCGP8QD2jRpeyG9gOGLe/uAiXqM3n9Y0WzR2UqZj006
         +LVjexGklu4Xun7WdEYjpVyVHbiQQ/fM5uh0D3wRgYplOge4982YPkPkB779F7h12vRp
         9sZBJUaci8usHTwMojQfKbJrhPZziHS+XkFodR9BRM2BrVza0hCxtxZ2+ohkTnjiNv1m
         gXCvat+S+6eBXj3qTtcZOImQQenTYVOC7EVs8oWcPY7aovNildhhsrNe278XzD0mIyt5
         n1WQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/QMa6USt3/XRCdxyDyUR3dbTTZAK4FIDBoqJspxFtTugkmACyWo2Svf8gOiyX9DL9c4w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxP1yy+ILUZhqf6xjnn7jLifryc8wIgX8VXKXwddesy7tsu6s8c
	spm56oRMtcDw6FyHXIRsQI/G1Sj2pAEdvzst2c8Wzx+PZwAOVjTMw8XDPHXTM2lfCfRFhppMjwG
	ng65pyza5crKnVHNqPlHbW1SCK3n3LxP4O3nQJKVSno3wD+eYnw==
X-Gm-Gg: ASbGncuqZETa6pTPc/CPbKG+3Ls8Rrhsx/1bLa4vvfOOO1iRk3rRSdBPMFmIXQ7o/IK
	P1rkj/OK1oPOzCalHMTEcgapTjXKBhKG+ornf6vAoy4pGx72ohbelnSJn1ShIkSV2hPQrC32qZ0
	3HupPCRAAk7bsx1G48c9Hi12Jc718zhjFf/0xw163F/ePk89KQi8vwyHjBG2Nv8l4AaXdf7PHgq
	cKGGqi7mAhpTQSCPMfYjHR2HDVSAJhP4k+paQwtKg19VnpzoFvbUtjAIxyT6qBPTHlCTA2UZA9I
	p6RuT0PrT316jWEqjc8PIlzr8b+6aQ7d
X-Received: by 2002:a05:600c:6308:b0:43c:fe15:41c9 with SMTP id 5b1f17b1804b1-442d6d3e6d9mr160272625e9.9.1747127776777;
        Tue, 13 May 2025 02:16:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE1T/5gFVuk4ijjzA9YbA5QxEtUdD+KlrGtP96PmXtcNzFC1cX7Zq93bTxtyhDRAIbOqgjkbg==
X-Received: by 2002:a05:600c:6308:b0:43c:fe15:41c9 with SMTP id 5b1f17b1804b1-442d6d3e6d9mr160272145e9.9.1747127776344;
        Tue, 13 May 2025 02:16:16 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f58f2f65sm15734373f8f.55.2025.05.13.02.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 02:16:15 -0700 (PDT)
Date: Tue, 13 May 2025 11:16:14 +0200
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
Subject: Re: [PATCH v4 23/27] hw/i386/intel_iommu: Remove
 IntelIOMMUState::buggy_eim field
Message-ID: <20250513111614.31479c42@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250508133550.81391-24-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-24-philmd@linaro.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  8 May 2025 15:35:46 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> The IntelIOMMUState::buggy_eim boolean was only set in
> the hw_compat_2_7[] array, via the 'x-buggy-eim=3Dtrue'
> property. We removed all machines using that array, lets
> remove that property, simplifying vtd_decide_config().
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>

Reviewed-by: Igor Mammedov <imammedo@redhat.com>

> ---
>  include/hw/i386/intel_iommu.h | 1 -
>  hw/i386/intel_iommu.c         | 5 ++---
>  2 files changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/include/hw/i386/intel_iommu.h b/include/hw/i386/intel_iommu.h
> index e95477e8554..29304329d05 100644
> --- a/include/hw/i386/intel_iommu.h
> +++ b/include/hw/i386/intel_iommu.h
> @@ -303,7 +303,6 @@ struct IntelIOMMUState {
>      uint32_t intr_size;             /* Number of IR table entries */
>      bool intr_eime;                 /* Extended interrupt mode enabled */
>      OnOffAuto intr_eim;             /* Toggle for EIM cabability */
> -    bool buggy_eim;                 /* Force buggy EIM unless eim=3Doff =
*/
>      uint8_t aw_bits;                /* Host/IOVA address width (in bits)=
 */
>      bool dma_drain;                 /* Whether DMA r/w draining enabled =
*/
>      bool dma_translation;           /* Whether DMA translation supported=
 */
> diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> index 5f8ed1243d1..c980cecb4ee 100644
> --- a/hw/i386/intel_iommu.c
> +++ b/hw/i386/intel_iommu.c
> @@ -3823,7 +3823,6 @@ static const Property vtd_properties[] =3D {
>      DEFINE_PROP_UINT32("version", IntelIOMMUState, version, 0),
>      DEFINE_PROP_ON_OFF_AUTO("eim", IntelIOMMUState, intr_eim,
>                              ON_OFF_AUTO_AUTO),
> -    DEFINE_PROP_BOOL("x-buggy-eim", IntelIOMMUState, buggy_eim, false),
>      DEFINE_PROP_UINT8("aw-bits", IntelIOMMUState, aw_bits,
>                        VTD_HOST_ADDRESS_WIDTH),
>      DEFINE_PROP_BOOL("caching-mode", IntelIOMMUState, caching_mode, FALS=
E),
> @@ -4731,11 +4730,11 @@ static bool vtd_decide_config(IntelIOMMUState *s,=
 Error **errp)
>      }
> =20
>      if (s->intr_eim =3D=3D ON_OFF_AUTO_AUTO) {
> -        s->intr_eim =3D (kvm_irqchip_in_kernel() || s->buggy_eim)
> +        s->intr_eim =3D kvm_irqchip_in_kernel()
>                        && x86_iommu_ir_supported(x86_iommu) ?
>                                                ON_OFF_AUTO_ON : ON_OFF_AU=
TO_OFF;
>      }
> -    if (s->intr_eim =3D=3D ON_OFF_AUTO_ON && !s->buggy_eim) {
> +    if (s->intr_eim =3D=3D ON_OFF_AUTO_ON) {
>          if (kvm_irqchip_is_split() && !kvm_enable_x2apic()) {
>              error_setg(errp, "eim=3Don requires support on the KVM side"
>                               "(X2APIC_API, first shipped in v4.7)");


