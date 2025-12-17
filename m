Return-Path: <kvm+bounces-66175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BAACCC8607
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 16:16:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 34C2B3016D8D
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 15:15:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1838F341AAA;
	Wed, 17 Dec 2025 14:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BfBn0/jR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EbKPPNa+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508C333891D
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 14:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765980999; cv=none; b=YJheYXdPBE+00aM9CnaxevjB6f8D0L3bUHsIAXuhQTmkX9YEfqfY5beY25SotZoUUfQv8vEewdfG9JJsKaS/K5AeYsEMbdFd8WPNyoElaT+73DZj4HiDRUaZGeu0fp54InT7FMY+F95gXPnFIb+CGgEZH63pEFQIxz2e2zs+v0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765980999; c=relaxed/simple;
	bh=8cyOwKnPppWEoB2x3Onz2bvU2zSIOwae9j+OOKDfK6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nD98+NUOhVhrpfEu0QwISPxKQxTly8tlqBe85MOGSxtzBOs0e7c3HSQXiSKG93aOJU7jKrtZ/KKzF/RXnMrXNd+Lw/ACP79ph/yUkuOecw4Qf/Wp+9/FWTAPasoDL89cHXzM7+x0STHFLY3skkFC1qXRak6cm34uBA+su9QCK4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BfBn0/jR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EbKPPNa+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765980995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UPuvZsVg2/P92nYtjYvwgSdJvJL9SagAwz9Q3Fo+Uxo=;
	b=BfBn0/jRCpulmT4IaFxAy/lleZ5SSdaJj9FHMmBP3tXIVfavoYD27p9f5VNAqkm2cKAW+6
	ViOxTitlFirkTXMCvh9siKSDukb9xCxqyRzGIQQQr4TelVZjA/KOpifUMLwsHHxtujytyo
	/Idz+f+Jh0I28krmQITqlLw087yxzf0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-546-UVf04yGmPqKL3Wxg-vK_1A-1; Wed, 17 Dec 2025 09:16:33 -0500
X-MC-Unique: UVf04yGmPqKL3Wxg-vK_1A-1
X-Mimecast-MFC-AGG-ID: UVf04yGmPqKL3Wxg-vK_1A_1765980992
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4310062d97bso1478560f8f.0
        for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 06:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765980991; x=1766585791; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UPuvZsVg2/P92nYtjYvwgSdJvJL9SagAwz9Q3Fo+Uxo=;
        b=EbKPPNa+5pYqgvD7hf43ZccJEA3hQVaR8+DQ2OobsvoFU5O7DyAYINU2MlqnefQEM3
         grzIAAxIPEMojM/Qr89GQ4r+WKeOMMXxTFmlOQzGnYWN9VtX2W38pBHD9SfQTrp1I/71
         u/Dz2c5+zeuYx8SxjEr2Qqc7BdYtMo+zYTDPoMaQ8sZhbqof5mlSt+7z/hXIPzUiJ8f2
         w5ryOwLxUtrtW9uxnyhIHUVkEwgqO6FeyO8lM17yqOF9GufPVHhS7+VQ4WQ/m8ls51r4
         DmXRLnGPlCbyOlyhoA1KdhwWw9pAeC3+AG6/alIyk1TFYua6ISqZyJ/KFefgD9xko2J5
         gr3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765980991; x=1766585791;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UPuvZsVg2/P92nYtjYvwgSdJvJL9SagAwz9Q3Fo+Uxo=;
        b=WogZk5iGdAbVyMHGggIkkUiCedLFB185X7+4LpO/RolLvnPuGEbgHGSFl2Ra7MoIhL
         vrDSMtgrpswpQfWwmfxDP4edm45QDsS5v4zZbimWOkNLNkuK1Ofh5hAF80BMqon40osJ
         EK5cuFMVbzo1jjMwn1L5+1itaxUHt4mekGsdrK0pYzx9nMUiRStOzSDysj6MqU2Tzmho
         HTt6t68lNQZhZOGjCF7JFG5G7ylPYhHooxVZRPeGRIleuNekyUo696YkOhG01na3zXSy
         e2GSKYjIOinXL3U0aOB4pB73JsOuFBNDFb5XIsgx+QKp6+EUthfHIrQ67b1OcOZwCPvU
         NLIw==
X-Forwarded-Encrypted: i=1; AJvYcCUV70tmaLxhuRYsjrUWHFzOIOl9NDsiRHJyXeHtg0zfgQG1Bd3UhiK1+C770pIUhjyKRFQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSx0e4+is5tvD0D4jh1GJx6zLPZJo/DCUTKSu2KuVu/5pWYU2N
	Nf9I+EerX7MCmg2KMxFQH5Mrj5/Du5C+YBMAwv3yTWvIVZs0NvN6dLosOyfhwp6rge3UI2fm97b
	0zFDDaZKmoPkKb7NsKlFynAhyUQSS04sE4YwmnJA8ZlGD1Ts76NR3FA==
X-Gm-Gg: AY/fxX6RrbPWR8oHlZHbfgjfPitXPvipvKTvCy4oOqvbqqQlDDu158bSabcnos00pow
	26xBXlfRRXpvi9Ts6j2lD9M81p5Km6rYNHONbqRgxihDhNjwaLrK886btY1xixe/G1ILrbsGImx
	0GO8kw8RGqZQM0sEGD1ApI1iMHfMNm63NapznZiYOdAY2CM/OH7T5jKR3zSE4jFcwNNOqie4tix
	6rVPQM14c1nGMKoZ3yuSkEmsn+bk5YR8UE3i+T4j/MLvacwEH2Oh1leYcsXRygJu77WhlCmlAub
	OSNNV7VcnE4Ma+1USCrDxUVhrCOTMV7KeoBuU+USQQTBPscBV/5t9LgtMblnR07tf6d5Iw==
X-Received: by 2002:a05:6000:22c4:b0:431:5ca:c1b0 with SMTP id ffacd0b85a97d-43105cac279mr6386397f8f.4.1765980990793;
        Wed, 17 Dec 2025 06:16:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHj4yTZFGhFGg4sY1F3wyJEyzPlbljJv4mOI7hBcL/tv70HvAtVNpU0cfi6m1v8b2iyH3GSrw==
X-Received: by 2002:a05:6000:22c4:b0:431:5ca:c1b0 with SMTP id ffacd0b85a97d-43105cac279mr6386355f8f.4.1765980990046;
        Wed, 17 Dec 2025 06:16:30 -0800 (PST)
Received: from imammedo ([213.175.37.14])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4310adb5f24sm4979348f8f.19.2025.12.17.06.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 06:16:29 -0800 (PST)
Date: Wed, 17 Dec 2025 15:16:27 +0100
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
Subject: Re: [PATCH v5 07/28] tests/acpi: Update DSDT tables for pc machine
Message-ID: <20251217151627.3ee7bf07@imammedo>
In-Reply-To: <20251202162835.3227894-8-zhao1.liu@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
	<20251202162835.3227894-8-zhao1.liu@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  3 Dec 2025 00:28:14 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> Now the legacy cpu hotplug way has gone away, and there's no _INIT
> method in DSDT table for modern cpu hotplug support.
> 
> Update DSDT tables for pc machine.
> 
> The following diff changes show only _INIT methods are removed from DSDT
> tables.
> 

below diff in commit message confuses git am,
I'd suggests to point out only what's deleted  
and skip the rest, aka.
removed section in x86 DSDTs:
  -
  -            Method (_INI, 0, Serialized)  // _INI: Initialize
  -            {
  -                CSEL = Zero
  -            }

ditto for blurb in the next patch

> * tests/data/acpi/x86/pc/DSDT:
> 
> --- /tmp/asl-6MNNG3.dsl	2025-11-27 11:35:53.011791359 +0800
> +++ /tmp/asl-ENING3.dsl	2025-11-27 11:35:53.004791360 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/pc/DSDT, Thu Nov 27 11:35:53 2025
> + * Disassembly of /tmp/aml-RMING3, Thu Nov 27 11:35:53 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x000021A3 (8611)
> + *     Length           0x00002196 (8598)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0xF0
> + *     Checksum         0xF7
>   *     OEM ID           "BOCHS "
>   *     OEM Table ID     "BXPC    "
>   *     OEM Revision     0x00000001 (1)
>   *     Compiler ID      "BXPC"
>   *     Compiler Version 0x00000001 (1)
>   */
>  DefinitionBlock ("", "DSDT", 1, "BOCHS ", "BXPC    ", 0x00000001)
>  {
>      Scope (\)
>      {
>          OperationRegion (DBG, SystemIO, 0x0402, One)
>          Field (DBG, ByteAcc, NoLock, Preserve)
>          {
>              DBGB,   8
>          }
> 
> @@ -1478,37 +1478,32 @@
>                  Offset (0x04),
>                  CPEN,   1,
>                  CINS,   1,
>                  CRMV,   1,
>                  CEJ0,   1,
>                  CEJF,   1,
>                  Offset (0x05),
>                  CCMD,   8
>              }
> 
>              Field (PRST, DWordAcc, NoLock, Preserve)
>              {
>                  CSEL,   32,
>                  Offset (0x08),
>                  CDAT,   32
>              }
> -
> -            Method (_INI, 0, Serialized)  // _INI: Initialize
> -            {
> -                CSEL = Zero
> -            }
>          }
> 
>          Device (\_SB.CPUS)
>          {
>              Name (_HID, "ACPI0010" /* Processor Container Device */)  // _HID: Hardware ID
>              Name (_CID, EisaId ("PNP0A05") /* Generic Container Device */)  // _CID: Compatible ID
>              Method (CTFY, 2, NotSerialized)
>              {
>                  If ((Arg0 == Zero))
>                  {
>                      Notify (C000, Arg1)
>                  }
>              }
> 
>              Method (CSTA, 1, Serialized)
>              {
> 
> * tests/data/acpi/x86/pc/DSDT.acpierst:
> 
> --- /tmp/asl-0Q9CG3.dsl	2025-11-27 11:36:09.513790743 +0800
> +++ /tmp/asl-0A3CG3.dsl	2025-11-27 11:36:09.505790743 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/pc/DSDT.acpierst, Thu Nov 27 11:36:09 2025
> + * Disassembly of /tmp/aml-S72CG3, Thu Nov 27 11:36:09 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x0000214A (8522)
> + *     Length           0x0000213D (8509)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x38
> + *     Checksum         0x3F
>   *     OEM ID           "BOCHS "
>   *     OEM Table ID     "BXPC    "
>   *     OEM Revision     0x00000001 (1)
>   *     Compiler ID      "BXPC"
>   *     Compiler Version 0x00000001 (1)
>   */
>  DefinitionBlock ("", "DSDT", 1, "BOCHS ", "BXPC    ", 0x00000001)
>  {
>      Scope (\)
>      {
>          OperationRegion (DBG, SystemIO, 0x0402, One)
>          Field (DBG, ByteAcc, NoLock, Preserve)
>          {
>              DBGB,   8
>          }
> 
> @@ -1478,37 +1478,32 @@
>                  Offset (0x04),
>                  CPEN,   1,
>                  CINS,   1,
>                  CRMV,   1,
>                  CEJ0,   1,
>                  CEJF,   1,
>                  Offset (0x05),
>                  CCMD,   8
>              }
> 
>              Field (PRST, DWordAcc, NoLock, Preserve)
>              {
>                  CSEL,   32,
>                  Offset (0x08),
>                  CDAT,   32
>              }
> -
> -            Method (_INI, 0, Serialized)  // _INI: Initialize
> -            {
> -                CSEL = Zero
> -            }
>          }
> 
>          Device (\_SB.CPUS)
>          {
>              Name (_HID, "ACPI0010" /* Processor Container Device */)  // _HID: Hardware ID
>              Name (_CID, EisaId ("PNP0A05") /* Generic Container Device */)  // _CID: Compatible ID
>              Method (CTFY, 2, NotSerialized)
>              {
>                  If ((Arg0 == Zero))
>                  {
>                      Notify (C000, Arg1)
>                  }
>              }
> 
>              Method (CSTA, 1, Serialized)
>              {
> 
> * tests/data/acpi/x86/pc/DSDT.acpihmat:
> 
> --- /tmp/asl-5ICTG3.dsl	2025-11-27 11:36:11.803790658 +0800
> +++ /tmp/asl-5A4SG3.dsl	2025-11-27 11:36:11.795790658 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/pc/DSDT.acpihmat, Thu Nov 27 11:36:11 2025
> + * Disassembly of /tmp/aml-273SG3, Thu Nov 27 11:36:11 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x000026D0 (9936)
> + *     Length           0x000026C3 (9923)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0xAD
> + *     Checksum         0xB4
>   *     OEM ID           "BOCHS "
>   *     OEM Table ID     "BXPC    "
>   *     OEM Revision     0x00000001 (1)
>   *     Compiler ID      "BXPC"
>   *     Compiler Version 0x00000001 (1)
>   */
>  DefinitionBlock ("", "DSDT", 1, "BOCHS ", "BXPC    ", 0x00000001)
>  {
>      Scope (\)
>      {
>          OperationRegion (DBG, SystemIO, 0x0402, One)
>          Field (DBG, ByteAcc, NoLock, Preserve)
>          {
>              DBGB,   8
>          }
> 
> @@ -1478,37 +1478,32 @@
>                  Offset (0x04),
>                  CPEN,   1,
>                  CINS,   1,
>                  CRMV,   1,
>                  CEJ0,   1,
>                  CEJF,   1,
>                  Offset (0x05),
>                  CCMD,   8
>              }
> 
>              Field (PRST, DWordAcc, NoLock, Preserve)
>              {
>                  CSEL,   32,
>                  Offset (0x08),
>                  CDAT,   32
>              }
> -
> -            Method (_INI, 0, Serialized)  // _INI: Initialize
> -            {
> -                CSEL = Zero
> -            }
>          }
> 
>          Device (\_SB.CPUS)
>          {
>              Name (_HID, "ACPI0010" /* Processor Container Device */)  // _HID: Hardware ID
>              Name (_CID, EisaId ("PNP0A05") /* Generic Container Device */)  // _CID: Compatible ID
>              Method (CTFY, 2, NotSerialized)
>              {
>                  If ((Arg0 == Zero))
>                  {
>                      Notify (C000, Arg1)
>                  }
> 
>                  If ((Arg0 == One))
>                  {
>                      Notify (C001, Arg1)
> 
> * tests/data/acpi/x86/pc/DSDT.bridge:
> 
> --- /tmp/asl-0OWEG3.dsl	2025-11-27 11:35:57.430791194 +0800
> +++ /tmp/asl-H2CFG3.dsl	2025-11-27 11:35:57.415791195 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/pc/DSDT.bridge, Thu Nov 27 11:35:57 2025
> + * Disassembly of /tmp/aml-P89EG3, Thu Nov 27 11:35:57 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x00003C7A (15482)
> + *     Length           0x00003C6D (15469)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0xFE
> + *     Checksum         0x05
>   *     OEM ID           "BOCHS "
>   *     OEM Table ID     "BXPC    "
>   *     OEM Revision     0x00000001 (1)
>   *     Compiler ID      "BXPC"
>   *     Compiler Version 0x00000001 (1)
>   */
>  DefinitionBlock ("", "DSDT", 1, "BOCHS ", "BXPC    ", 0x00000001)
>  {
>      Scope (\)
>      {
>          OperationRegion (DBG, SystemIO, 0x0402, One)
>          Field (DBG, ByteAcc, NoLock, Preserve)
>          {
>              DBGB,   8
>          }
> 
> @@ -1478,37 +1478,32 @@
>                  Offset (0x04),
>                  CPEN,   1,
>                  CINS,   1,
>                  CRMV,   1,
>                  CEJ0,   1,
>                  CEJF,   1,
>                  Offset (0x05),
>                  CCMD,   8
>              }
> 
>              Field (PRST, DWordAcc, NoLock, Preserve)
>              {
>                  CSEL,   32,
>                  Offset (0x08),
>                  CDAT,   32
>              }
> -
> -            Method (_INI, 0, Serialized)  // _INI: Initialize
> -            {
> -                CSEL = Zero
> -            }
>          }
> 
>          Device (\_SB.CPUS)
>          {
>              Name (_HID, "ACPI0010" /* Processor Container Device */)  // _HID: Hardware ID
>              Name (_CID, EisaId ("PNP0A05") /* Generic Container Device */)  // _CID: Compatible ID
>              Method (CTFY, 2, NotSerialized)
>              {
>                  If ((Arg0 == Zero))
>                  {
>                      Notify (C000, Arg1)
>                  }
>              }
> 
>              Method (CSTA, 1, Serialized)
>              {
> 
> * tests/data/acpi/x86/pc/DSDT.cphp:
> 
> --- /tmp/asl-Z59FG3.dsl	2025-11-27 11:36:01.356791048 +0800
> +++ /tmp/asl-UVSGG3.dsl	2025-11-27 11:36:01.348791048 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/pc/DSDT.cphp, Thu Nov 27 11:36:01 2025
> + * Disassembly of /tmp/aml-JUSGG3, Thu Nov 27 11:36:01 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x00002373 (9075)
> + *     Length           0x00002366 (9062)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x63
> + *     Checksum         0x6A
>   *     OEM ID           "BOCHS "
>   *     OEM Table ID     "BXPC    "
>   *     OEM Revision     0x00000001 (1)
>   *     Compiler ID      "BXPC"
>   *     Compiler Version 0x00000001 (1)
>   */
>  DefinitionBlock ("", "DSDT", 1, "BOCHS ", "BXPC    ", 0x00000001)
>  {
>      Scope (\)
>      {
>          OperationRegion (DBG, SystemIO, 0x0402, One)
>          Field (DBG, ByteAcc, NoLock, Preserve)
>          {
>              DBGB,   8
>          }
> 
> @@ -1478,37 +1478,32 @@
>                  Offset (0x04),
>                  CPEN,   1,
>                  CINS,   1,
>                  CRMV,   1,
>                  CEJ0,   1,
>                  CEJF,   1,
>                  Offset (0x05),
>                  CCMD,   8
>              }
> 
>              Field (PRST, DWordAcc, NoLock, Preserve)
>              {
>                  CSEL,   32,
>                  Offset (0x08),
>                  CDAT,   32
>              }
> -
> -            Method (_INI, 0, Serialized)  // _INI: Initialize
> -            {
> -                CSEL = Zero
> -            }
>          }
> 
>          Device (\_SB.CPUS)
>          {
>              Name (_HID, "ACPI0010" /* Processor Container Device */)  // _HID: Hardware ID
>              Name (_CID, EisaId ("PNP0A05") /* Generic Container Device */)  // _CID: Compatible ID
>              Method (CTFY, 2, NotSerialized)
>              {
>                  If ((Arg0 == Zero))
>                  {
>                      Notify (C000, Arg1)
>                  }
> 
>                  If ((Arg0 == One))
>                  {
>                      Notify (C001, Arg1)
> 
> * tests/data/acpi/x86/pc/DSDT.dimmpxm:
> 
> --- /tmp/asl-87HXG3.dsl	2025-11-27 11:36:10.604790702 +0800
> +++ /tmp/asl-GXDXG3.dsl	2025-11-27 11:36:10.597790703 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/pc/DSDT.dimmpxm, Thu Nov 27 11:36:10 2025
> + * Disassembly of /tmp/aml-8TDXG3, Thu Nov 27 11:36:10 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x00002819 (10265)
> + *     Length           0x0000280C (10252)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x10
> + *     Checksum         0x17
>   *     OEM ID           "BOCHS "
>   *     OEM Table ID     "BXPC    "
>   *     OEM Revision     0x00000001 (1)
>   *     Compiler ID      "BXPC"
>   *     Compiler Version 0x00000001 (1)
>   */
>  DefinitionBlock ("", "DSDT", 1, "BOCHS ", "BXPC    ", 0x00000001)
>  {
>      External (_SB_.NVDR, UnknownObj)
> 
>      Scope (\)
>      {
>          OperationRegion (DBG, SystemIO, 0x0402, One)
>          Field (DBG, ByteAcc, NoLock, Preserve)
>          {
>              DBGB,   8
> @@ -1484,37 +1484,32 @@
>                  Offset (0x04),
>                  CPEN,   1,
>                  CINS,   1,
>                  CRMV,   1,
>                  CEJ0,   1,
>                  CEJF,   1,
>                  Offset (0x05),
>                  CCMD,   8
>              }
> 
>              Field (PRST, DWordAcc, NoLock, Preserve)
>              {
>                  CSEL,   32,
>                  Offset (0x08),
>                  CDAT,   32
>              }
> -
> -            Method (_INI, 0, Serialized)  // _INI: Initialize
> -            {
> -                CSEL = Zero
> -            }
>          }
> 
>          Device (\_SB.CPUS)
>          {
>              Name (_HID, "ACPI0010" /* Processor Container Device */)  // _HID: Hardware ID
>              Name (_CID, EisaId ("PNP0A05") /* Generic Container Device */)  // _CID: Compatible ID
>              Method (CTFY, 2, NotSerialized)
>              {
>                  If ((Arg0 == Zero))
>                  {
>                      Notify (C000, Arg1)
>                  }
> 
>                  If ((Arg0 == One))
>                  {
>                      Notify (C001, Arg1)
> 
> * tests/data/acpi/x86/pc/DSDT.hpbridge:
> 
> --- /tmp/asl-85THG3.dsl	2025-11-27 11:36:19.302790377 +0800
> +++ /tmp/asl-JXOHG3.dsl	2025-11-27 11:36:19.292790378 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/pc/DSDT.hpbridge, Thu Nov 27 11:36:19 2025
> + * Disassembly of /tmp/aml-7XOHG3, Thu Nov 27 11:36:19 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x00002172 (8562)
> + *     Length           0x00002165 (8549)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x24
> + *     Checksum         0x2B
>   *     OEM ID           "BOCHS "
>   *     OEM Table ID     "BXPC    "
>   *     OEM Revision     0x00000001 (1)
>   *     Compiler ID      "BXPC"
>   *     Compiler Version 0x00000001 (1)
>   */
>  DefinitionBlock ("", "DSDT", 1, "BOCHS ", "BXPC    ", 0x00000001)
>  {
>      Scope (\)
>      {
>          OperationRegion (DBG, SystemIO, 0x0402, One)
>          Field (DBG, ByteAcc, NoLock, Preserve)
>          {
>              DBGB,   8
>          }
> 
> @@ -1478,37 +1478,32 @@
>                  Offset (0x04),
>                  CPEN,   1,
>                  CINS,   1,
>                  CRMV,   1,
>                  CEJ0,   1,
>                  CEJF,   1,
>                  Offset (0x05),
>                  CCMD,   8
>              }
> 
>              Field (PRST, DWordAcc, NoLock, Preserve)
>              {
>                  CSEL,   32,
>                  Offset (0x08),
>                  CDAT,   32
>              }
> -
> -            Method (_INI, 0, Serialized)  // _INI: Initialize
> -            {
> -                CSEL = Zero
> -            }
>          }
> 
>          Device (\_SB.CPUS)
>          {
>              Name (_HID, "ACPI0010" /* Processor Container Device */)  // _HID: Hardware ID
>              Name (_CID, EisaId ("PNP0A05") /* Generic Container Device */)  // _CID: Compatible ID
>              Method (CTFY, 2, NotSerialized)
>              {
>                  If ((Arg0 == Zero))
>                  {
>                      Notify (C000, Arg1)
>                  }
>              }
> 
>              Method (CSTA, 1, Serialized)
>              {
> 
> * tests/data/acpi/x86/pc/DSDT.hpbrroot:
> 
> --- /tmp/asl-9C0IG3.dsl	2025-11-27 11:36:17.217790455 +0800
> +++ /tmp/asl-P7LJG3.dsl	2025-11-27 11:36:17.213790456 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/pc/DSDT.hpbrroot, Thu Nov 27 11:36:17 2025
> + * Disassembly of /tmp/aml-97LJG3, Thu Nov 27 11:36:17 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x000013EC (5100)
> + *     Length           0x000013DF (5087)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x63
> + *     Checksum         0x6A
>   *     OEM ID           "BOCHS "
>   *     OEM Table ID     "BXPC    "
>   *     OEM Revision     0x00000001 (1)
>   *     Compiler ID      "BXPC"
>   *     Compiler Version 0x00000001 (1)
>   */
>  DefinitionBlock ("", "DSDT", 1, "BOCHS ", "BXPC    ", 0x00000001)
>  {
>      Scope (\)
>      {
>          OperationRegion (DBG, SystemIO, 0x0402, One)
>          Field (DBG, ByteAcc, NoLock, Preserve)
>          {
>              DBGB,   8
>          }
> 
> @@ -1389,37 +1389,32 @@
>                  Offset (0x04),
>                  CPEN,   1,
>                  CINS,   1,
>                  CRMV,   1,
>                  CEJ0,   1,
>                  CEJF,   1,
>                  Offset (0x05),
>                  CCMD,   8
>              }
> 
>              Field (PRST, DWordAcc, NoLock, Preserve)
>              {
>                  CSEL,   32,
>                  Offset (0x08),
>                  CDAT,   32
>              }
> -
> -            Method (_INI, 0, Serialized)  // _INI: Initialize
> -            {
> -                CSEL = Zero
> -            }
>          }
> 
>          Device (\_SB.CPUS)
>          {
>              Name (_HID, "ACPI0010" /* Processor Container Device */)  // _HID: Hardware ID
>              Name (_CID, EisaId ("PNP0A05") /* Generic Container Device */)  // _CID: Compatible ID
>              Method (CTFY, 2, NotSerialized)
>              {
>                  If ((Arg0 == Zero))
>                  {
>                      Notify (C000, Arg1)
>                  }
>              }
> 
>              Method (CSTA, 1, Serialized)
>              {
> 
> * tests/data/acpi/x86/pc/DSDT.ipmikcs:
> 
> --- /tmp/asl-W20MG3.dsl	2025-11-27 11:36:00.052791096 +0800
> +++ /tmp/asl-STSMG3.dsl	2025-11-27 11:36:00.041791097 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/pc/DSDT.ipmikcs, Thu Nov 27 11:36:00 2025
> + * Disassembly of /tmp/aml-C1SMG3, Thu Nov 27 11:36:00 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x000021EB (8683)
> + *     Length           0x000021DE (8670)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x6C
> + *     Checksum         0x73
>   *     OEM ID           "BOCHS "
>   *     OEM Table ID     "BXPC    "
>   *     OEM Revision     0x00000001 (1)
>   *     Compiler ID      "BXPC"
>   *     Compiler Version 0x00000001 (1)
>   */
>  DefinitionBlock ("", "DSDT", 1, "BOCHS ", "BXPC    ", 0x00000001)
>  {
>      Scope (\)
>      {
>          OperationRegion (DBG, SystemIO, 0x0402, One)
>          Field (DBG, ByteAcc, NoLock, Preserve)
>          {
>              DBGB,   8
>          }
> 
> @@ -1478,37 +1478,32 @@
>                  Offset (0x04),
>                  CPEN,   1,
>                  CINS,   1,
>                  CRMV,   1,
>                  CEJ0,   1,
>                  CEJF,   1,
>                  Offset (0x05),
>                  CCMD,   8
>              }
> 
>              Field (PRST, DWordAcc, NoLock, Preserve)
>              {
>                  CSEL,   32,
>                  Offset (0x08),
>                  CDAT,   32
>              }
> -
> -            Method (_INI, 0, Serialized)  // _INI: Initialize
> -            {
> -                CSEL = Zero
> -            }
>          }
> 
>          Device (\_SB.CPUS)
>          {
>              Name (_HID, "ACPI0010" /* Processor Container Device */)  // _HID: Hardware ID
>              Name (_CID, EisaId ("PNP0A05") /* Generic Container Device */)  // _CID: Compatible ID
>              Method (CTFY, 2, NotSerialized)
>              {
>                  If ((Arg0 == Zero))
>                  {
>                      Notify (C000, Arg1)
>                  }
>              }
> 
>              Method (CSTA, 1, Serialized)
>              {
> 
> * tests/data/acpi/x86/pc/DSDT.memhp:
> 
> --- /tmp/asl-X0EDG3.dsl	2025-11-27 11:36:09.487790744 +0800
> +++ /tmp/asl-9EXDG3.dsl	2025-11-27 11:36:09.477790744 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/pc/DSDT.memhp, Thu Nov 27 11:36:09 2025
> + * Disassembly of /tmp/aml-PCXDG3, Thu Nov 27 11:36:09 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x000026F2 (9970)
> + *     Length           0x000026E5 (9957)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0xC4
> + *     Checksum         0xCB
>   *     OEM ID           "BOCHS "
>   *     OEM Table ID     "BXPC    "
>   *     OEM Revision     0x00000001 (1)
>   *     Compiler ID      "BXPC"
>   *     Compiler Version 0x00000001 (1)
>   */
>  DefinitionBlock ("", "DSDT", 1, "BOCHS ", "BXPC    ", 0x00000001)
>  {
>      Scope (\)
>      {
>          OperationRegion (DBG, SystemIO, 0x0402, One)
>          Field (DBG, ByteAcc, NoLock, Preserve)
>          {
>              DBGB,   8
>          }
> 
> @@ -1478,37 +1478,32 @@
>                  Offset (0x04),
>                  CPEN,   1,
>                  CINS,   1,
>                  CRMV,   1,
>                  CEJ0,   1,
>                  CEJF,   1,
>                  Offset (0x05),
>                  CCMD,   8
>              }
> 
>              Field (PRST, DWordAcc, NoLock, Preserve)
>              {
>                  CSEL,   32,
>                  Offset (0x08),
>                  CDAT,   32
>              }
> -
> -            Method (_INI, 0, Serialized)  // _INI: Initialize
> -            {
> -                CSEL = Zero
> -            }
>          }
> 
>          Device (\_SB.CPUS)
>          {
>              Name (_HID, "ACPI0010" /* Processor Container Device */)  // _HID: Hardware ID
>              Name (_CID, EisaId ("PNP0A05") /* Generic Container Device */)  // _CID: Compatible ID
>              Method (CTFY, 2, NotSerialized)
>              {
>                  If ((Arg0 == Zero))
>                  {
>                      Notify (C000, Arg1)
>                  }
>              }
> 
>              Method (CSTA, 1, Serialized)
>              {
> 
> * tests/data/acpi/x86/pc/DSDT.nohpet:
> 
> --- /tmp/asl-AY9OG3.dsl	2025-11-27 11:36:07.974790801 +0800
> +++ /tmp/asl-Q8PPG3.dsl	2025-11-27 11:36:07.964790801 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/pc/DSDT.nohpet, Thu Nov 27 11:36:07 2025
> + * Disassembly of /tmp/aml-HLQPG3, Thu Nov 27 11:36:07 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x00002115 (8469)
> + *     Length           0x00002108 (8456)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0xB9
> + *     Checksum         0xC0
>   *     OEM ID           "BOCHS "
>   *     OEM Table ID     "BXPC    "
>   *     OEM Revision     0x00000001 (1)
>   *     Compiler ID      "BXPC"
>   *     Compiler Version 0x00000001 (1)
>   */
>  DefinitionBlock ("", "DSDT", 1, "BOCHS ", "BXPC    ", 0x00000001)
>  {
>      Scope (\)
>      {
>          OperationRegion (DBG, SystemIO, 0x0402, One)
>          Field (DBG, ByteAcc, NoLock, Preserve)
>          {
>              DBGB,   8
>          }
> 
> @@ -1437,37 +1437,32 @@
>                  Offset (0x04),
>                  CPEN,   1,
>                  CINS,   1,
>                  CRMV,   1,
>                  CEJ0,   1,
>                  CEJF,   1,
>                  Offset (0x05),
>                  CCMD,   8
>              }
> 
>              Field (PRST, DWordAcc, NoLock, Preserve)
>              {
>                  CSEL,   32,
>                  Offset (0x08),
>                  CDAT,   32
>              }
> -
> -            Method (_INI, 0, Serialized)  // _INI: Initialize
> -            {
> -                CSEL = Zero
> -            }
>          }
> 
>          Device (\_SB.CPUS)
>          {
>              Name (_HID, "ACPI0010" /* Processor Container Device */)  // _HID: Hardware ID
>              Name (_CID, EisaId ("PNP0A05") /* Generic Container Device */)  // _CID: Compatible ID
>              Method (CTFY, 2, NotSerialized)
>              {
>                  If ((Arg0 == Zero))
>                  {
>                      Notify (C000, Arg1)
>                  }
>              }
> 
>              Method (CSTA, 1, Serialized)
>              {
> 
> * tests/data/acpi/x86/pc/DSDT.numamem:
> 
> --- /tmp/asl-GVAYG3.dsl	2025-11-27 11:36:02.576791002 +0800
> +++ /tmp/asl-856XG3.dsl	2025-11-27 11:36:02.568791002 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/pc/DSDT.numamem, Thu Nov 27 11:36:02 2025
> + * Disassembly of /tmp/aml-926XG3, Thu Nov 27 11:36:02 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x000021A9 (8617)
> + *     Length           0x0000219C (8604)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x7C
> + *     Checksum         0x83
>   *     OEM ID           "BOCHS "
>   *     OEM Table ID     "BXPC    "
>   *     OEM Revision     0x00000001 (1)
>   *     Compiler ID      "BXPC"
>   *     Compiler Version 0x00000001 (1)
>   */
>  DefinitionBlock ("", "DSDT", 1, "BOCHS ", "BXPC    ", 0x00000001)
>  {
>      Scope (\)
>      {
>          OperationRegion (DBG, SystemIO, 0x0402, One)
>          Field (DBG, ByteAcc, NoLock, Preserve)
>          {
>              DBGB,   8
>          }
> 
> @@ -1478,37 +1478,32 @@
>                  Offset (0x04),
>                  CPEN,   1,
>                  CINS,   1,
>                  CRMV,   1,
>                  CEJ0,   1,
>                  CEJF,   1,
>                  Offset (0x05),
>                  CCMD,   8
>              }
> 
>              Field (PRST, DWordAcc, NoLock, Preserve)
>              {
>                  CSEL,   32,
>                  Offset (0x08),
>                  CDAT,   32
>              }
> -
> -            Method (_INI, 0, Serialized)  // _INI: Initialize
> -            {
> -                CSEL = Zero
> -            }
>          }
> 
>          Device (\_SB.CPUS)
>          {
>              Name (_HID, "ACPI0010" /* Processor Container Device */)  // _HID: Hardware ID
>              Name (_CID, EisaId ("PNP0A05") /* Generic Container Device */)  // _CID: Compatible ID
>              Method (CTFY, 2, NotSerialized)
>              {
>                  If ((Arg0 == Zero))
>                  {
>                      Notify (C000, Arg1)
>                  }
>              }
> 
>              Method (CSTA, 1, Serialized)
>              {
> 
> * tests/data/acpi/x86/pc/DSDT.roothp:
> 
> --- /tmp/asl-VG4JG3.dsl	2025-11-27 11:36:18.176790420 +0800
> +++ /tmp/asl-R0LKG3.dsl	2025-11-27 11:36:18.169790420 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/pc/DSDT.roothp, Thu Nov 27 11:36:18 2025
> + * Disassembly of /tmp/aml-NYLKG3, Thu Nov 27 11:36:18 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x00003074 (12404)
> + *     Length           0x00003067 (12391)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x7C
> + *     Checksum         0x83
>   *     OEM ID           "BOCHS "
>   *     OEM Table ID     "BXPC    "
>   *     OEM Revision     0x00000001 (1)
>   *     Compiler ID      "BXPC"
>   *     Compiler Version 0x00000001 (1)
>   */
>  DefinitionBlock ("", "DSDT", 1, "BOCHS ", "BXPC    ", 0x00000001)
>  {
>      Scope (\)
>      {
>          OperationRegion (DBG, SystemIO, 0x0402, One)
>          Field (DBG, ByteAcc, NoLock, Preserve)
>          {
>              DBGB,   8
>          }
> 
> @@ -1478,37 +1478,32 @@
>                  Offset (0x04),
>                  CPEN,   1,
>                  CINS,   1,
>                  CRMV,   1,
>                  CEJ0,   1,
>                  CEJF,   1,
>                  Offset (0x05),
>                  CCMD,   8
>              }
> 
>              Field (PRST, DWordAcc, NoLock, Preserve)
>              {
>                  CSEL,   32,
>                  Offset (0x08),
>                  CDAT,   32
>              }
> -
> -            Method (_INI, 0, Serialized)  // _INI: Initialize
> -            {
> -                CSEL = Zero
> -            }
>          }
> 
>          Device (\_SB.CPUS)
>          {
>              Name (_HID, "ACPI0010" /* Processor Container Device */)  // _HID: Hardware ID
>              Name (_CID, EisaId ("PNP0A05") /* Generic Container Device */)  // _CID: Compatible ID
>              Method (CTFY, 2, NotSerialized)
>              {
>                  If ((Arg0 == Zero))
>                  {
>                      Notify (C000, Arg1)
>                  }
>              }
> 
>              Method (CSTA, 1, Serialized)
>              {
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changes since v4:
>  * New patch.
> ---
>  tests/data/acpi/x86/pc/DSDT                 | Bin 8611 -> 8598 bytes
>  tests/data/acpi/x86/pc/DSDT.acpierst        | Bin 8522 -> 8509 bytes
>  tests/data/acpi/x86/pc/DSDT.acpihmat        | Bin 9936 -> 9923 bytes
>  tests/data/acpi/x86/pc/DSDT.bridge          | Bin 15482 -> 15469 bytes
>  tests/data/acpi/x86/pc/DSDT.cphp            | Bin 9075 -> 9062 bytes
>  tests/data/acpi/x86/pc/DSDT.dimmpxm         | Bin 10265 -> 10252 bytes
>  tests/data/acpi/x86/pc/DSDT.hpbridge        | Bin 8562 -> 8549 bytes
>  tests/data/acpi/x86/pc/DSDT.hpbrroot        | Bin 5100 -> 5087 bytes
>  tests/data/acpi/x86/pc/DSDT.ipmikcs         | Bin 8683 -> 8670 bytes
>  tests/data/acpi/x86/pc/DSDT.memhp           | Bin 9970 -> 9957 bytes
>  tests/data/acpi/x86/pc/DSDT.nohpet          | Bin 8469 -> 8456 bytes
>  tests/data/acpi/x86/pc/DSDT.numamem         | Bin 8617 -> 8604 bytes
>  tests/data/acpi/x86/pc/DSDT.roothp          | Bin 12404 -> 12391 bytes
>  tests/qtest/bios-tables-test-allowed-diff.h |  13 -------------
>  14 files changed, 13 deletions(-)
> 
> diff --git a/tests/data/acpi/x86/pc/DSDT b/tests/data/acpi/x86/pc/DSDT
> index 4beb5194b84a711fcb52e3e52cc2096497d18442..6ea2d36d138daffb59a8636759078500adc58f24 100644
> GIT binary patch
> delta 39
> vcmZ4NJk6QQCD<ionj!-O<M)kRr+K(so#KO?;-j0qIVa!enYp=@S55=~{=N*|
> 
> delta 53
> zcmbQ{yx5t`CD<iou_6Nl<A;r0r+K)Xoa2L?;-i~9xF+A{naL}{6YuHg$x*=I9PH||
> Jxq??t1OUPD58VI&
> 
> diff --git a/tests/data/acpi/x86/pc/DSDT.acpierst b/tests/data/acpi/x86/pc/DSDT.acpierst
> index abda6863b64c5dc8ba5aba1a286cbfa76772a1e4..d8c173aa613f51b1c76ea7b9dee19e899cba240d 100644
> GIT binary patch
> delta 39
> vcmX@*wAYEtCD<jzR*`{$(S9S>X&x?Dr}$u}_~<5Y&dK+AW^QifJt_<U?(Yn~
> 
> delta 53
> zcmdn%bjpd#CD<jzOOb(r(PAUlX&x>o=lEc!_~<4NuF3a#X7Y;g#C!UAauhH)2fO-g
> JuHZc?3;?HG5552Z
> 
> diff --git a/tests/data/acpi/x86/pc/DSDT.acpihmat b/tests/data/acpi/x86/pc/DSDT.acpihmat
> index d081db26d7ba504b3344fad130d5812419291ac0..ba363d6af76af728b7c88bbaf47f7e0ea3dcb41f 100644
> GIT binary patch
> delta 39
> vcmccMd)SxDCD<k8uo?pc<CcwFr+K(sJmQ0$;-j0qIVa!enYp=@*IN<*4-pM<
> 
> delta 53
> zcmX@?d%>5>CD<k8f*Jz@<Jyf}r+K&>J>!F&;-i~9xF+A{naL}{6YuHg$x*=I9PH||  
> Jxq{bQ5&+kc5ODwi
> 
> diff --git a/tests/data/acpi/x86/pc/DSDT.bridge b/tests/data/acpi/x86/pc/DSDT.bridge
> index e16897dc5f0fbb3f7b4de8db913884046246cc3b..b68302363cb24181988d6e3dceb04a0946838d5e 100644
> GIT binary patch
> delta 39
> vcmexW@wS4?CD<h-*M@<Ck#!^2X&x?Dr}$u}_~<5Y&dK+AW^Qif{i+855Lyl9
> 
> delta 53
> zcmaD`@vDN%CD<jT%7%e~@!v+S(>z>G&hf!c@zG5lT$Atf%;Xi}iTCvL<S1Zp4tDj~
> JT*3QQ4*>hl5#|5@  
> 
> diff --git a/tests/data/acpi/x86/pc/DSDT.cphp b/tests/data/acpi/x86/pc/DSDT.cphp
> index e95711cd9cde5d50b841b701ae0fed5a4b15e872..20688edf2da41146ece4faa4141517408a42870c 100644
> GIT binary patch
> delta 39
> vcmezD_RNjTCD<h-O__m#F>52&X&x@u`1oL__~<5Y&dK+AW^QifeJ2V42kQ;C
> 
> delta 53
> zcmaFn_SucgCD<jTSeb!=F?l1`X&x@8g!o{m_~<4NuF3a#X7Y;g#C!UAauhH)2fO-g
> JuHbzq3INN05VimS
> 
> diff --git a/tests/data/acpi/x86/pc/DSDT.dimmpxm b/tests/data/acpi/x86/pc/DSDT.dimmpxm
> index 90ba66b9164f9a958d5a3c4371b1eec03e922828..8d4be05d2c71ca8de6d732d3e48e0e323143160c 100644
> GIT binary patch
> delta 39
> vcmbOk&=bJr66_Mfqrt$yD87;FJ`a~)aD1>+d~}mH=j6{kGdIuVZIA*0-<AwM  
> 
> delta 53
> zcmeAPm>Iz366_KpslmX&D6o<1J`b07NPMtUd~}ls*W}MUGkHaL;ywL5ISLq@gI#?#  
> J_wY7I0RWRv4?X|@
> 
> diff --git a/tests/data/acpi/x86/pc/DSDT.hpbridge b/tests/data/acpi/x86/pc/DSDT.hpbridge
> index 0eafe5fbf3d73719c9c3e6e26371863bfb44ed2f..2b5b885b862a2fe8bc4a24446400dccf685dab85 100644
> GIT binary patch
> delta 39
> vcmez5^wf#VCD<h-Rgr;#QF|lTX&x?Dr}$u}_~<5Y&dK+AW^QifeJczA{o4&n
> 
> delta 53
> zcmaFr^vQ|KCD<jTNRfeoQDr07X&x>o=lEc!_~<4NuF3a#X7Y;g#C!UAauhH)2fO-g
> JuHbzu3;?^p5J~_5
> 
> diff --git a/tests/data/acpi/x86/pc/DSDT.hpbrroot b/tests/data/acpi/x86/pc/DSDT.hpbrroot
> index 077a4cc988dc417a1bc9317dddd2dbd96ff1ff50..cc6f26a3f8fe85f34a8acb5432bab3cf4d3ab1f6 100644
> GIT binary patch
> delta 39
> vcmaE(eqWu-CD<k8zAys=W7bBl9BwXGr}$u}_~<5Y&dCkjGdHX89AgIn`U?zT
> 
> delta 53
> zcmcbw{zje4CD<k8jW7cPWAa9>9BwWr=lEc!_~<4NuE`DDGkHaL;ywL5ISLq@gI#?#
> JOY$6J2LQ7!4`2WQ
> 
> diff --git a/tests/data/acpi/x86/pc/DSDT.ipmikcs b/tests/data/acpi/x86/pc/DSDT.ipmikcs
> index 8d465f027772f9c59b0c328c1a099e374a6d2a90..052a84e294eee4ecef9a36341493f841caf887a5 100644
> GIT binary patch
> delta 39
> vcmaFue9xK7CD<k8o+1MSWAR3=(>z?RPVvD`@zG7*oRjbK%-r0{n<fGP5J?Sr
> 
> delta 53
> zcmccT{MwnzCD<k8wITxpW6nmd(>z>G&hf!c@zG5lT$Atf%;Xi}iTCvL<S1Zp4tDj~
> JT)~?r0sz<r5P1Lq
> 
> diff --git a/tests/data/acpi/x86/pc/DSDT.memhp b/tests/data/acpi/x86/pc/DSDT.memhp
> index e3b49757cb7abd7536ee89a6824967d2cb2485cf..7efc12a46cb87c0684b7d880b2cc94d302744e03 100644
> GIT binary patch
> delta 39
> vcmez5`_z}qCD<k8sTu<V<LQlDr+K)%o#KO?;-j0qIVa!enYp=@H&+q>AHfb0
> 
> delta 53
> zcmaFr`^lHfCD<k8lNtj9<B^SAr+K(Moa2L?;-i~9xF+A{naL}{6YuHg$x*=I9PH||
> Jxq>%W5&-Wd5fK0Y  
> 
> diff --git a/tests/data/acpi/x86/pc/DSDT.nohpet b/tests/data/acpi/x86/pc/DSDT.nohpet
> index 9e772c1316d0ea07c51717466c4c7e383553f345..7eedfcd64ebd0193744864b4f6cbead35c7c3ab2 100644
> GIT binary patch
> delta 39
> vcmbR0)ZxVC66_Mfp~%3%cwi%!Ef1HgQ+%*fd~}mH=j1@1nVY}!$cX>|)oKe*  
> 
> delta 53
> zcmeBhn(D;m66_Kps>r~=xN{?yEf1HIb9}H<d~}ls*W^H+nY<!A@t%I390d%{!LB}=  
> JU-8I^004Ze4o?68
> 
> diff --git a/tests/data/acpi/x86/pc/DSDT.numamem b/tests/data/acpi/x86/pc/DSDT.numamem
> index 9bfbfc28213713c208dfc38a85abb46fb190871d..910b4952a0757025cfed1c60416d16054e70846f 100644
> GIT binary patch
> delta 39
> vcmZ4KJja>KCD<iojv@mCWAjF?(>z?>PVvD`@zG7*oRjbK%-r0{t0Dpb_GAo)  
> 
> delta 53
> zcmbQ^ywaJ=CD<ior6L0ZW6egc(>z=r&hf!c@zG5lT$Atf%;Xi}iTCvL<S1Zp4tDj~
> JT*0d%0syp+4~GB%
> 
> diff --git a/tests/data/acpi/x86/pc/DSDT.roothp b/tests/data/acpi/x86/pc/DSDT.roothp
> index efbee6d8aa5c62ff4fcb83e6c5cff59542977850..45d3dbe1b69143a956b4f829913ca47f07134741 100644
> GIT binary patch
> delta 39
> vcmey8@H~ObCD<h--GG6Cv3VocX&x?Dr}$u}_~<5Y&dK+AW^QifeXj%n5y%b%
> 
> delta 53
> zcmaE!@FjuECD<jT#DIZ;v1TLJX&x>o=lEc!_~<4NuF3a#X7Y;g#C!UAauhH)2fO-g
> JuHb#I1OV9F5d;7L
> 
> diff --git a/tests/qtest/bios-tables-test-allowed-diff.h b/tests/qtest/bios-tables-test-allowed-diff.h
> index eed8ded69335..2ed74f72e7c9 100644
> --- a/tests/qtest/bios-tables-test-allowed-diff.h
> +++ b/tests/qtest/bios-tables-test-allowed-diff.h
> @@ -1,17 +1,4 @@
>  /* List of comma-separated changed AML files to ignore */
> -"tests/data/acpi/x86/pc/DSDT",
> -"tests/data/acpi/x86/pc/DSDT.bridge",
> -"tests/data/acpi/x86/pc/DSDT.ipmikcs",
> -"tests/data/acpi/x86/pc/DSDT.cphp",
> -"tests/data/acpi/x86/pc/DSDT.numamem",
> -"tests/data/acpi/x86/pc/DSDT.nohpet",
> -"tests/data/acpi/x86/pc/DSDT.memhp",
> -"tests/data/acpi/x86/pc/DSDT.dimmpxm",
> -"tests/data/acpi/x86/pc/DSDT.acpihmat",
> -"tests/data/acpi/x86/pc/DSDT.acpierst",
> -"tests/data/acpi/x86/pc/DSDT.roothp",
> -"tests/data/acpi/x86/pc/DSDT.hpbridge",
> -"tests/data/acpi/x86/pc/DSDT.hpbrroot",
>  "tests/data/acpi/x86/q35/DSDT",
>  "tests/data/acpi/x86/q35/DSDT.tis.tpm2",
>  "tests/data/acpi/x86/q35/DSDT.tis.tpm12",


