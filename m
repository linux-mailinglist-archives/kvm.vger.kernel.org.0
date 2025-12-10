Return-Path: <kvm+bounces-65655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BB209CB31A3
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 15:07:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D549131631A8
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 14:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A499D2550AF;
	Wed, 10 Dec 2025 14:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MN9CzEXG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="eRC2tx2U"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FDD13D503
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 14:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765375284; cv=none; b=CcIsOuedcIC/cM3Qcfam8Hsf+AtdqoNWNrIVYFBYuWJNbNBv2s9peXAR28rcTG/+kRK8LLing4c0n0nTU7Q0dOYL/eF/cj2FwmOC1hResVqyia6/fz9iFMvSpOGBaWrGC+u2aUnlfn0UuDkhdGZitHlTuEFP9w2WjRW41r4FBI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765375284; c=relaxed/simple;
	bh=uTB8FeJa3RRQ+zCY/41aqsH+9IT+HYXmUFzJKYm1/eM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LW+8iXn24+2mSR3yfF3U7cF6TVTYlG9FbnFLJpnfHgCgeuDAO28rcxBNg6SFv4Z7kxYPdCMztQEha60FVK7Df18fzXuQD3fwbRaK0LxV1gUmqSBv8WHpjG4dH6g2hWzEBSlDSUYb6bwAGmPCvNjH7SwQLEdsq16C7+myKWl+/To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MN9CzEXG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=eRC2tx2U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765375282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j6O14IgCI996JZsx0l90XqR/9ZXCFZHWkgAIKqs9gec=;
	b=MN9CzEXGcH+bLUSWdKLf1rre+9yDc+sT6Qys7/nbM6Kpxo9g/cf8faSeUoZsTCD53rQgcL
	UByYvC98X0BP0O0cfZ04aOB2exSMHp7rEag3pIeFXIaaY1p614dLUSCgSLEkoF0+/aSVnz
	Xj5HsvtwpKi8KoWEKQutBoKI/tEA2G8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-A_hQDrGOMQWwV_dyhpUjmg-1; Wed, 10 Dec 2025 09:01:19 -0500
X-MC-Unique: A_hQDrGOMQWwV_dyhpUjmg-1
X-Mimecast-MFC-AGG-ID: A_hQDrGOMQWwV_dyhpUjmg_1765375278
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47775585257so44704285e9.1
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 06:01:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765375278; x=1765980078; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j6O14IgCI996JZsx0l90XqR/9ZXCFZHWkgAIKqs9gec=;
        b=eRC2tx2U3iLDUjVy0u+hkFtHQdUBhbEfjU2Ky0FPDsWLqCU+a3fdfU5Ry+x7q4fIEI
         Mn5v4/7J9/CXtxZnssLL2iOPiVOYsjJ5rEjPFzWmrfaB479ObWvzPjvu0q1RU6QZ6HFr
         b7FeJwHY787rFPe2Eztxr5+RHzNCmq/YIDaVEldKzJbX9cGDxRjisxekwIZqhnDjEVyX
         TMriIQOEr6/RUAx0e4q1vaze6T5Tt4/ry24ifM6b2QhMOKD8LRjz0RhwLmPzOA8tFk4j
         otS7fI504p7H7R32SD9cX5en9hNP4SpWiHDJUg1MXRJ3WxcvC9cMRuVwPJymSB9Oksw7
         TJyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765375278; x=1765980078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j6O14IgCI996JZsx0l90XqR/9ZXCFZHWkgAIKqs9gec=;
        b=c+yT+CWcdFDq9g3fGmzFFnctKLJumggx6aTHvFtzAYLLvpnlRFmpZsIbGAUH2/ka/c
         LNXEcu2Y5GS31kQM2n/Gqu2f260bZTohsLe3zZiuB7kSPN3kVPz+myzvRhAMtY5fDGHS
         rY4xgQ6up4dT+0JPUUbihQpxW9T2z4WeyjzgZjFwhDfEwY2tCFfATXd0MUEpBk8Q6Km6
         N/2XwVPTmmUdX/0LeIjVUApBy+e52EXrsviq2X5nw2XzGCCgrVwEkHYtOAKD6+KDMGqA
         9+D6Hso85GXI1yj0/XSuzBZ2LRIi1Lbayz3/71jn9Vy2JS2yTKVX8VA7x4moQOt3RJAa
         h+Ew==
X-Forwarded-Encrypted: i=1; AJvYcCVC70K6yRzH6lXO7mdtekYG8xR7QVzb58m/71yHXOgyp8GrunDvvFo2SCMapQ3LpuvGFqI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwH+Ub2FRosjcTAdrY0VHsq4FDD/WSfI8rGiukUfm6mbf9TNpB
	PaumfKFM26zQA9KkDTDCAPFsMGUN0uKKGZqNXNzOVXkoUiF6g4SyFUrGZzf5ic5httd5c4+mJPY
	eLvMVnKI0HF5XOWEyOVHEclIEj4h5wbYCDCtx9Otm0lB1aSyVtdrclg==
X-Gm-Gg: ASbGncvpL7CtqdKUPjFZXqO1ZmFEmMBmAgxIsv1+eT5qmuLq33uEG+Hc3YhMWhfqDVg
	sWFAykzJCT8uNoO3h1hxjsa0d1qHPu0LNow3L6YWQTIgF3xfj5bjFIhYAlC80Sg/fh6TlQN1pqy
	ChpRX80f+UvjAXEMuCts3t0Kxs/DXAuiCA64xOwKEhxjor1BW2uCheE7hv1FIozbIgPVd6KfVOA
	veODO9gKdTNz/U5m9ANo1897ngsrumRLA2jg5+DbxNnL8h/tc0puhzRKTPuM/VH8J9Vo4HX1cAB
	m4zhM52akiXri2XQkwC39Xk65gAKxQIR79107/p5LzdHpkHvtWI8RSwAyIJ7tAVYCjtxng==
X-Received: by 2002:a05:600c:3113:b0:477:7768:8da4 with SMTP id 5b1f17b1804b1-47a856249c2mr13338685e9.7.1765375278109;
        Wed, 10 Dec 2025 06:01:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFj/M79GqEHYM3DvJC6z3KKGc/jcvumRsPxQHknr/rdPhfB8kOLZa6+TISA54HNeWcCceufRw==
X-Received: by 2002:a05:600c:3113:b0:477:7768:8da4 with SMTP id 5b1f17b1804b1-47a856249c2mr13337925e9.7.1765375277520;
        Wed, 10 Dec 2025 06:01:17 -0800 (PST)
Received: from imammedo ([213.175.37.14])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a7d9bec74sm44288345e9.8.2025.12.10.06.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 06:01:16 -0800 (PST)
Date: Wed, 10 Dec 2025 15:01:15 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Michael S . Tsirkin"
 <mst@redhat.com>, Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?=
 <philmd@linaro.org>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Thomas
 Huth <thuth@redhat.com>, qemu-devel@nongnu.org, devel@lists.libvirt.org,
 kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org, Richard
 Henderson <richard.henderson@linaro.org>, Sergio Lopez <slp@redhat.com>,
 Gerd Hoffmann <kraxel@redhat.com>, Peter Maydell
 <peter.maydell@linaro.org>, Laurent Vivier <lvivier@redhat.com>, Jiaxun
 Yang <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>, Eduardo
 Habkost <eduardo@habkost.net>, Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, Weiwei Li <liwei1518@gmail.com>, Amit Shah
 <amit@kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>, Yanan Wang
 <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>, Palmer Dabbelt
 <palmer@dabbelt.com>, "Daniel P . =?UTF-8?B?QmVycmFuZ8Op?="
 <berrange@redhat.com>, Ani Sinha <anisinha@redhat.com>, Fabiano Rosas
 <farosas@suse.de>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 =?UTF-8?B?Q2zDqW1lbnQ=?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
 =?UTF-8?B?TWFyYy1BbmRyw6k=?= Lureau <marcandre.lureau@redhat.com>, Huacai
 Chen <chenhuacai@kernel.org>, Jason Wang <jasowang@redhat.com>, Mark
 Cave-Ayland <mark.caveayland@nutanix.com>, BALATON Zoltan
 <balaton@eik.bme.hu>, Peter Krempa <pkrempa@redhat.com>, Jiri Denemark
 <jdenemar@redhat.com>
Subject: Re: [PATCH v5 01/28] hw/i386/pc: Remove deprecated pc-q35-2.6 and
 pc-i440fx-2.6 machines
Message-ID: <20251210150115.5f9dc169@imammedo>
In-Reply-To: <20251202162835.3227894-2-zhao1.liu@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
	<20251202162835.3227894-2-zhao1.liu@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed,  3 Dec 2025 00:28:08 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> From: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
>=20
> These machines has been supported for a period of more than 6 years.
> According to our versioned machine support policy (see commit
> ce80c4fa6ff "docs: document special exception for machine type
> deprecation & removal") they can now be removed.
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Igor Mammedov <imammedo@redhat.com>

> ---
>  hw/i386/pc_piix.c | 14 --------------
>  hw/i386/pc_q35.c  | 14 --------------
>  2 files changed, 28 deletions(-)
>=20
> diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
> index 7b3611e973cd..4628d491d5b5 100644
> --- a/hw/i386/pc_piix.c
> +++ b/hw/i386/pc_piix.c
> @@ -733,20 +733,6 @@ static void pc_i440fx_machine_2_7_options(MachineCla=
ss *m)
> =20
>  DEFINE_I440FX_MACHINE(2, 7);
> =20
> -static void pc_i440fx_machine_2_6_options(MachineClass *m)
> -{
> -    X86MachineClass *x86mc =3D X86_MACHINE_CLASS(m);
> -    PCMachineClass *pcmc =3D PC_MACHINE_CLASS(m);
> -
> -    pc_i440fx_machine_2_7_options(m);
> -    pcmc->legacy_cpu_hotplug =3D true;
> -    x86mc->fwcfg_dma_enabled =3D false;
> -    compat_props_add(m->compat_props, hw_compat_2_6, hw_compat_2_6_len);
> -    compat_props_add(m->compat_props, pc_compat_2_6, pc_compat_2_6_len);
> -}
> -
> -DEFINE_I440FX_MACHINE(2, 6);
> -
>  #ifdef CONFIG_XEN
>  static void xenfv_machine_4_2_options(MachineClass *m)
>  {
> diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
> index 6015e639d7bc..0ae19eb9f1e4 100644
> --- a/hw/i386/pc_q35.c
> +++ b/hw/i386/pc_q35.c
> @@ -681,17 +681,3 @@ static void pc_q35_machine_2_7_options(MachineClass =
*m)
>  }
> =20
>  DEFINE_Q35_MACHINE(2, 7);
> -
> -static void pc_q35_machine_2_6_options(MachineClass *m)
> -{
> -    X86MachineClass *x86mc =3D X86_MACHINE_CLASS(m);
> -    PCMachineClass *pcmc =3D PC_MACHINE_CLASS(m);
> -
> -    pc_q35_machine_2_7_options(m);
> -    pcmc->legacy_cpu_hotplug =3D true;
> -    x86mc->fwcfg_dma_enabled =3D false;
> -    compat_props_add(m->compat_props, hw_compat_2_6, hw_compat_2_6_len);
> -    compat_props_add(m->compat_props, pc_compat_2_6, pc_compat_2_6_len);
> -}
> -
> -DEFINE_Q35_MACHINE(2, 6);


