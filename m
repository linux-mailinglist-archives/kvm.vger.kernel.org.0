Return-Path: <kvm+bounces-66173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5884ECC81AF
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 15:14:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7B4F33037976
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 14:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B76038F258;
	Wed, 17 Dec 2025 14:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QVbi5dpW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="R7sOdT/+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E5E32340D
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 14:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765980225; cv=none; b=k9A0P131qjIOwKDLdBxTry95BTZVXOBShQ4i95/O1wiW0HGDSvrKCGNXbz5Q+LJaz7bvkTahrZfWHJVJ/JE4oRUXWTgmNpvGkm+pbaViHvRhAy1YDZhQCS7XBQ4dvhw2qjA6DmWuIUF2R42YEHLcXVA2sd1wcwEs2ppqVpTdZ5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765980225; c=relaxed/simple;
	bh=lObbwfTE3RNoqZeV4yO/uDMSSr1ZK80evGeQn+wsXsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VTNmFncaMN+1S7+gxVGnvkG3AcOUtdfvZavT7RFGaicUZ3Z9JTbfKsMPBcxekiWzc0xHpZKnxGwsRBzPStDPjjfmt56YHfjs+5nGuY2nDi74erIL54bAwOLJXqrUEza0VPUlR0uXidDNPdAusCYAMYWKow9oHXR2+18XAx3jKYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QVbi5dpW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=R7sOdT/+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765980220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lSMSAqeBodf9WOo627PunboXQJpHb2fcrFl5bFdPgYI=;
	b=QVbi5dpWKEUbhzjoA5gFRoz5kMw9LdJ28+lGApD3x9C86489fdNKC1CrckckiUyFwjms1I
	KYApOPmX86QgmLeADWjZgaw357N+zNZB/MFJpUQe2kvnM8tZV3Vzc+vzObe8PYb6sWB8cd
	O3U3EKiGnQMUYX+6HS0+OaJ3tiVjBMM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-bWWOyn6-MA60noTBk_wC7Q-1; Wed, 17 Dec 2025 09:03:38 -0500
X-MC-Unique: bWWOyn6-MA60noTBk_wC7Q-1
X-Mimecast-MFC-AGG-ID: bWWOyn6-MA60noTBk_wC7Q_1765980214
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-477bf8c1413so37631015e9.1
        for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 06:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765980212; x=1766585012; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lSMSAqeBodf9WOo627PunboXQJpHb2fcrFl5bFdPgYI=;
        b=R7sOdT/+ui99xex9RzCHZYDKO41k4cH8kK+UXNpF1IKoyiHRd1OYgO/1LIxtflaW9L
         DqzV2BGFjoG9rUN8ADRwOBHHKbEpErOa81MTHPAtFkDr3tdGl6ChBsM9LjlRYd3KhLMg
         2DITCXSij8lAtKoblhiZve4+51kxCMT5GpWGJRKOyuhFkLFWRCv4JGxaK05TcqGTHk6M
         UGwJFXPZIwL9Mlm7BPPf5G/yseMWE6GSgtx1LVoXUOU7JQMCWJvOPSsmNHTdICk/fZ4K
         AmOmzq+7mFY4PrKIg2WuQaf41+H4zKg5kBCPiZ60SvMRmSTAc9PmqvLwOk/DbYxLv2k4
         cDJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765980212; x=1766585012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lSMSAqeBodf9WOo627PunboXQJpHb2fcrFl5bFdPgYI=;
        b=Bm4WjuBH46lLwlsCJXIWsORcLV95fDjogdbSrUzukxPKUOOMu0ErJoa5oS/84a8yZr
         EVEOOuPZZShPenTuH2zM+GZC4nIJrBTsHZiY8qLa+/D++6S+lkvrr24FrEMyIbEjfy0b
         G3a+aVyXI3FsQ/AbJj0bVDbKIcbkuaD7cjn/RgefIfHSvmifRPnPYS4e2QDMp4KxqG3B
         bk1nnmXJ/TF55R6xG6CcE8lquhkTjPzAuZ3cVynKdEe+lxDznoPc9EkERmwe4eWKIXo5
         vctDHcdTGOd1/wnpjT8nZN3XfFHmJRfdjVGEvzTAFE1eZc4Bnik5/bLflXU6IXxc9s50
         BOgg==
X-Forwarded-Encrypted: i=1; AJvYcCWwq6N8X1fOswpqnDjnVEt9kXlklQop3Vs+GecdYTioG2X4s54cRhTak3qToapN38QDdlA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaPyE9dYoq47BcAuCd0gIaswzn+EtIQs2BxjgHJvKs0xFgE+86
	1WwKDPNSNEOoqpCYZy24qfUj8StOyjdBeD8tibvyOsTfe3IG/VqaxB7rZP2XGJDLhAUOzWhsPoL
	bXMauzzXqu5WKL+XGQTcHjo0Y6KiFyTNbX2couifYEJZoKedvPyrI+Q==
X-Gm-Gg: AY/fxX7nxPH4FcRrXZj79OAFQbsYlSE3niuotjG8ywgk0KhgXltUX/GfI4T+KrzTeZo
	SztDNu9PFAnr0agIpVxFyQ7Dld4Jp97dRiT/UHNs3IbKpxEK8IT7oISbawlvL4fVvEVh/JuTUS9
	/WvcsinUvIXjrkvIm8I8yoqVy6VXNxWCt5RKvPJ2XeHRA+oN9RtvZ4PvhO5WskfwFUfIiyg+c1P
	Yzcbo84ftzKnUVZn60D5nUM0AmBJBwHB+oAlwNu23n9OsPkBfzAcmgqvMqAJXwLSH0EOcw8XZRo
	noYXgPaEUCY0mHKJiFNHvZ1/cSoMnBXtRHYGR+hub2IkNy9h2VwGZQK8YLrS/hF5tfr9kw==
X-Received: by 2002:a05:600c:3489:b0:477:7725:c16a with SMTP id 5b1f17b1804b1-47a8f8c0375mr193101035e9.10.1765980211362;
        Wed, 17 Dec 2025 06:03:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFSqOZaoxCBiEyshHPCZexK5cOQ/FNZQvl9pU/zft4jtq08adhQ6EojvIVOzC5Nnz5xjMHa4A==
X-Received: by 2002:a05:600c:3489:b0:477:7725:c16a with SMTP id 5b1f17b1804b1-47a8f8c0375mr193100305e9.10.1765980210099;
        Wed, 17 Dec 2025 06:03:30 -0800 (PST)
Received: from imammedo ([213.175.37.14])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47bdc1c2243sm39940755e9.1.2025.12.17.06.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 06:03:29 -0800 (PST)
Date: Wed, 17 Dec 2025 15:03:25 +0100
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
Subject: Re: [PATCH v5 08/28] tests/acpi: Update DSDT tables for q35 machine
Message-ID: <20251217150325.417bcf16@imammedo>
In-Reply-To: <20251202162835.3227894-9-zhao1.liu@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
	<20251202162835.3227894-9-zhao1.liu@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  3 Dec 2025 00:28:15 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> Now the legacy cpu hotplug way has gone away, and there's no _INIT
> method in DSDT table for modern cpu hotplug support.
> 
> Update DSDT tables for q35 machine.
> 
> The following diff changes show only _INIT methods are removed from DSDT
> tables.
> 
> * tests/data/acpi/x86/q35/DSDT:

missing SoB

squash this into previous patch


with that Acked-by: Igor Mammedov <imammedo@redhat.com>

> 
> --- /tmp/asl-BSAVG3.dsl	2025-11-27 15:29:29.707267890 +0800
> +++ /tmp/asl-WDGVG3.dsl	2025-11-27 15:29:29.700267890 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT, Thu Nov 27 15:29:29 2025
> + * Disassembly of /tmp/aml-AFGVG3, Thu Nov 27 15:29:29 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x000020F8 (8440)
> + *     Length           0x000020EB (8427)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0xBE
> + *     Checksum         0xC5
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.acpierst:
> 
> --- /tmp/asl-5FERG3.dsl	2025-11-27 15:29:23.887268107 +0800
> +++ /tmp/asl-PPKRG3.dsl	2025-11-27 15:29:23.881268108 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.acpierst, Thu Nov 27 15:29:23 2025
> + * Disassembly of /tmp/aml-0QKRG3, Thu Nov 27 15:29:23 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x00002109 (8457)
> + *     Length           0x000020FC (8444)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x5D
> + *     Checksum         0x65
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.acpihmat:
> 
> --- /tmp/asl-JRLYG3.dsl	2025-11-27 15:29:21.552268195 +0800
> +++ /tmp/asl-QETYG3.dsl	2025-11-27 15:29:21.544268195 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.acpihmat, Thu Nov 27 15:29:21 2025
> + * Disassembly of /tmp/aml-2FTYG3, Thu Nov 27 15:29:21 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x00002625 (9765)
> + *     Length           0x00002618 (9752)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x7A
> + *     Checksum         0x81
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.acpihmat-generic-x:
> 
> --- /tmp/asl-38KFG3.dsl	2025-11-27 15:29:14.394268462 +0800
> +++ /tmp/asl-9ETFG3.dsl	2025-11-27 15:29:14.384268462 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.acpihmat-generic-x, Thu Nov 27 15:29:14 2025
> + * Disassembly of /tmp/aml-OHTFG3, Thu Nov 27 15:29:14 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x0000316A (12650)
> + *     Length           0x0000315D (12637)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x1F
> + *     Checksum         0x35
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.acpihmat-noinitiator:
> 
> --- /tmp/asl-N0VHG3.dsl	2025-11-27 15:29:16.287268391 +0800
> +++ /tmp/asl-XTAIG3.dsl	2025-11-27 15:29:16.277268392 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.acpihmat-noinitiator, Thu Nov 27 15:29:16 2025
> + * Disassembly of /tmp/aml-1UAIG3, Thu Nov 27 15:29:16 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x0000220F (8719)
> + *     Length           0x00002202 (8706)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x34
> + *     Checksum         0x3B
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.applesmc:
> 
> --- /tmp/asl-XR4EG3.dsl	2025-11-27 15:29:25.412268050 +0800
> +++ /tmp/asl-6IBFG3.dsl	2025-11-27 15:29:25.404268051 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.applesmc, Thu Nov 27 15:29:25 2025
> + * Disassembly of /tmp/aml-TPBFG3, Thu Nov 27 15:29:25 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x00002126 (8486)
> + *     Length           0x00002119 (8473)
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.bridge:
> 
> --- /tmp/asl-7WRVG3.dsl	2025-11-27 15:28:59.686269011 +0800
> +++ /tmp/asl-KEYVG3.dsl	2025-11-27 15:28:59.676269012 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.bridge, Thu Nov 27 15:28:59 2025
> + * Disassembly of /tmp/aml-NCYVG3, Thu Nov 27 15:28:59 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x00002F15 (12053)
> + *     Length           0x00002F08 (12040)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0xD9
> + *     Checksum         0xE0
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.core-count:
> 
> --- /tmp/asl-RENPG3.dsl	2025-11-27 15:29:21.971268179 +0800
> +++ /tmp/asl-IGXPG3.dsl	2025-11-27 15:29:21.961268179 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.core-count, Thu Nov 27 15:29:21 2025
> + * Disassembly of /tmp/aml-GPWPG3, Thu Nov 27 15:29:21 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x000032C6 (12998)
> + *     Length           0x000032B9 (12985)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x36
> + *     Checksum         0x3D
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.core-count2:
> 
> --- /tmp/asl-YGFMG3.dsl	2025-11-27 15:29:23.094268137 +0800
> +++ /tmp/asl-SU2MG3.dsl	2025-11-27 15:29:23.063268138 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.core-count2, Thu Nov 27 15:29:23 2025
> + * Disassembly of /tmp/aml-OW2MG3, Thu Nov 27 15:29:23 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x0000843F (33855)
> + *     Length           0x00008432 (33842)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x87
> + *     Checksum         0x8E
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.cphp:
> 
> --- /tmp/asl-SAFWG3.dsl	2025-11-27 15:29:09.652268639 +0800
> +++ /tmp/asl-1BJWG3.dsl	2025-11-27 15:29:09.646268639 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.cphp, Thu Nov 27 15:29:09 2025
> + * Disassembly of /tmp/aml-JAJWG3, Thu Nov 27 15:29:09 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x000022C8 (8904)
> + *     Length           0x000022BB (8891)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x31
> + *     Checksum         0x38
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.cxl:
> 
> --- /tmp/asl-VYSRG3.dsl	2025-11-27 15:29:35.869267660 +0800
> +++ /tmp/asl-RAZRG3.dsl	2025-11-27 15:29:35.862267660 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.cxl, Thu Nov 27 15:29:35 2025
> + * Disassembly of /tmp/aml-ZBZRG3, Thu Nov 27 15:29:35 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x000033AF (13231)
> + *     Length           0x000033A2 (13218)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0xF2
> + *     Checksum         0xF9
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.dimmpxm:
> 
> --- /tmp/asl-A93JG3.dsl	2025-11-27 15:29:20.180268246 +0800
> +++ /tmp/asl-CEBKG3.dsl	2025-11-27 15:29:20.172268246 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.dimmpxm, Thu Nov 27 15:29:20 2025
> + * Disassembly of /tmp/aml-MFBKG3, Thu Nov 27 15:29:20 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x0000276E (10094)
> + *     Length           0x00002761 (10081)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0xDE
> + *     Checksum         0xE5
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
> @@ -2891,37 +2891,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.ipmibt:
> 
> --- /tmp/asl-SW1YG3.dsl	2025-11-27 15:29:04.532268830 +0800
> +++ /tmp/asl-KJQCG3.dsl	2025-11-27 15:29:04.524268831 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.ipmibt, Thu Nov 27 15:29:04 2025
> + * Disassembly of /tmp/aml-MMQCG3, Thu Nov 27 15:29:04 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x00002143 (8515)
> + *     Length           0x00002136 (8502)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0xF1
> + *     Checksum         0xF8
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.ipmismbus:
> 
> --- /tmp/asl-5BDMG3.dsl	2025-11-27 15:29:31.075267839 +0800
> +++ /tmp/asl-KKIMG3.dsl	2025-11-27 15:29:31.068267839 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.ipmismbus, Thu Nov 27 15:29:31 2025
> + * Disassembly of /tmp/aml-8LIMG3, Thu Nov 27 15:29:31 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x00002150 (8528)
> + *     Length           0x00002143 (8515)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x62
> + *     Checksum         0x69
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.ivrs:
> 
> --- /tmp/asl-AZ0SG3.dsl	2025-11-27 15:29:27.813267961 +0800
> +++ /tmp/asl-QV7SG3.dsl	2025-11-27 15:29:27.804267961 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.ivrs, Thu Nov 27 15:29:27 2025
> + * Disassembly of /tmp/aml-PU7SG3, Thu Nov 27 15:29:27 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x00002109 (8457)
> + *     Length           0x000020FC (8444)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x5D
> + *     Checksum         0x65
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.memhp:
> 
> --- /tmp/asl-VVJNG3.dsl	2025-11-27 15:29:19.018268289 +0800
> +++ /tmp/asl-EIONG3.dsl	2025-11-27 15:29:19.013268289 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.memhp, Thu Nov 27 15:29:19 2025
> + * Disassembly of /tmp/aml-FHONG3, Thu Nov 27 15:29:19 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x00002647 (9799)
> + *     Length           0x0000263A (9786)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x91
> + *     Checksum         0x98
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.mmio64:
> 
> --- /tmp/asl-7NEUG3.dsl	2025-11-27 15:29:22.749268150 +0800
> +++ /tmp/asl-FQSUG3.dsl	2025-11-27 15:29:22.741268150 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.mmio64, Thu Nov 27 15:29:22 2025
> + * Disassembly of /tmp/aml-WPSUG3, Thu Nov 27 15:29:22 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x00002562 (9570)
> + *     Length           0x00002555 (9557)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x52
> + *     Checksum         0x59
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.multi-bridge:
> 
> --- /tmp/asl-JNDLG3.dsl	2025-11-27 15:29:02.126268920 +0800
> +++ /tmp/asl-6QNLG3.dsl	2025-11-27 15:29:02.113268921 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.multi-bridge, Thu Nov 27 15:29:02 2025
> + * Disassembly of /tmp/aml-0ONLG3, Thu Nov 27 15:29:02 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x000033ED (13293)
> + *     Length           0x000033E0 (13280)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0xD3
> + *     Checksum         0xDA
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.noacpihp:
> 
> --- /tmp/asl-5PGXG3.dsl	2025-11-27 15:29:04.605268828 +0800
> +++ /tmp/asl-WLPXG3.dsl	2025-11-27 15:29:04.597268828 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.noacpihp, Thu Nov 27 15:29:04 2025
> + * Disassembly of /tmp/aml-VNPXG3, Thu Nov 27 15:29:04 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x0000206E (8302)
> + *     Length           0x00002061 (8289)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0xA0
> + *     Checksum         0xA7
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
> @@ -2796,37 +2796,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.nohpet:
> 
> --- /tmp/asl-CF4OG3.dsl	2025-11-27 15:29:14.994268440 +0800
> +++ /tmp/asl-KFBPG3.dsl	2025-11-27 15:29:14.987268440 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.nohpet, Thu Nov 27 15:29:14 2025
> + * Disassembly of /tmp/aml-QHBPG3, Thu Nov 27 15:29:14 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x0000206A (8298)
> + *     Length           0x0000205D (8285)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x87
> + *     Checksum         0x8E
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
> @@ -2844,37 +2844,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.numamem:
> 
> --- /tmp/asl-IPHHG3.dsl	2025-11-27 15:29:07.303268727 +0800
> +++ /tmp/asl-67NHG3.dsl	2025-11-27 15:29:07.295268727 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.numamem, Thu Nov 27 15:29:07 2025
> + * Disassembly of /tmp/aml-NAOHG3, Thu Nov 27 15:29:07 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x000020FE (8446)
> + *     Length           0x000020F1 (8433)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x4A
> + *     Checksum         0x51
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.pvpanic-isa:
> 
> --- /tmp/asl-WJDHG3.dsl	2025-11-27 15:29:18.306268316 +0800
> +++ /tmp/asl-6RHHG3.dsl	2025-11-27 15:29:18.300268316 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.pvpanic-isa, Thu Nov 27 15:29:18 2025
> + * Disassembly of /tmp/aml-XUNHG3, Thu Nov 27 15:29:18 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x0000215D (8541)
> + *     Length           0x00002150 (8528)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x70
> + *     Checksum         0x77
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.thread-count:
> 
> --- /tmp/asl-TWDTG3.dsl	2025-11-27 15:29:23.799268111 +0800
> +++ /tmp/asl-USNTG3.dsl	2025-11-27 15:29:23.788268111 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.thread-count, Thu Nov 27 15:29:23 2025
> + * Disassembly of /tmp/aml-ASNTG3, Thu Nov 27 15:29:23 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x000032C6 (12998)
> + *     Length           0x000032B9 (12985)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x36
> + *     Checksum         0x3D
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.thread-count2:
> 
> --- /tmp/asl-I56IG3.dsl	2025-11-27 15:29:25.246268057 +0800
> +++ /tmp/asl-Z2YJG3.dsl	2025-11-27 15:29:25.213268058 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.thread-count2, Thu Nov 27 15:29:25 2025
> + * Disassembly of /tmp/aml-L4YJG3, Thu Nov 27 15:29:25 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x0000843F (33855)
> + *     Length           0x00008432 (33842)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x87
> + *     Checksum         0x8E
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.tis.tpm12:
> 
> --- /tmp/asl-SHLRG3.dsl	2025-11-27 15:29:01.877268929 +0800
> +++ /tmp/asl-1LQRG3.dsl	2025-11-27 15:29:01.871268930 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.tis.tpm12, Thu Nov 27 15:29:01 2025
> + * Disassembly of /tmp/aml-9MQRG3, Thu Nov 27 15:29:01 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x00002356 (9046)
> + *     Length           0x00002349 (9033)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0xEE
> + *     Checksum         0xF5
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.tis.tpm2:
> 
> --- /tmp/asl-KISFG3.dsl	2025-11-27 15:28:57.380269097 +0800
> +++ /tmp/asl-ZIYFG3.dsl	2025-11-27 15:28:57.373269098 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.tis.tpm2, Thu Nov 27 15:28:57 2025
> + * Disassembly of /tmp/aml-ZJYFG3, Thu Nov 27 15:28:57 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x00002370 (9072)
> + *     Length           0x00002363 (9059)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0xA8
> + *     Checksum         0xAF
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.type4-count:
> 
> --- /tmp/asl-PJ6JG3.dsl	2025-11-27 15:29:21.179268209 +0800
> +++ /tmp/asl-GPJKG3.dsl	2025-11-27 15:29:21.168268209 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.type4-count, Thu Nov 27 15:29:21 2025
> + * Disassembly of /tmp/aml-FRJKG3, Thu Nov 27 15:29:21 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x000048F2 (18674)
> + *     Length           0x000048E5 (18661)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x53
> + *     Checksum         0x5A
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.viot:
> 
> --- /tmp/asl-9POJG3.dsl	2025-11-27 15:29:26.204268021 +0800
> +++ /tmp/asl-BEXJG3.dsl	2025-11-27 15:29:26.192268021 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.viot, Thu Nov 27 15:29:26 2025
> + * Disassembly of /tmp/aml-YDXJG3, Thu Nov 27 15:29:26 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x00003969 (14697)
> + *     Length           0x0000395C (14684)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x90
> + *     Checksum         0x97
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
> @@ -2885,37 +2885,32 @@
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
> * tests/data/acpi/x86/q35/DSDT.xapic:
> 
> --- /tmp/asl-JOGEG3.dsl	2025-11-27 15:29:32.463267787 +0800
> +++ /tmp/asl-6UFFG3.dsl	2025-11-27 15:29:32.428267788 +0800
> @@ -1,30 +1,30 @@
>  /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20200925 (64-bit version)
>   * Copyright (c) 2000 - 2020 Intel Corporation
>   *
>   * Disassembling to symbolic ASL+ operators
>   *
> - * Disassembly of tests/data/acpi/x86/q35/DSDT.xapic, Thu Nov 27 15:29:32 2025
> + * Disassembly of /tmp/aml-U2EFG3, Thu Nov 27 15:29:32 2025
>   *
>   * Original Table Header:
>   *     Signature        "DSDT"
> - *     Length           0x00008BDB (35803)
> + *     Length           0x00008BCE (35790)
>   *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
> - *     Checksum         0x83
> + *     Checksum         0x8A
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
> @@ -2885,37 +2885,32 @@
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
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changes since v4:
>  * New patch.
> ---
>  tests/data/acpi/x86/q35/DSDT                  | Bin 8440 -> 8427 bytes
>  tests/data/acpi/x86/q35/DSDT.acpierst         | Bin 8457 -> 8444 bytes
>  tests/data/acpi/x86/q35/DSDT.acpihmat         | Bin 9765 -> 9752 bytes
>  .../data/acpi/x86/q35/DSDT.acpihmat-generic-x | Bin 12650 -> 12637 bytes
>  .../acpi/x86/q35/DSDT.acpihmat-noinitiator    | Bin 8719 -> 8706 bytes
>  tests/data/acpi/x86/q35/DSDT.applesmc         | Bin 8486 -> 8473 bytes
>  tests/data/acpi/x86/q35/DSDT.bridge           | Bin 12053 -> 12040 bytes
>  tests/data/acpi/x86/q35/DSDT.core-count       | Bin 12998 -> 12985 bytes
>  tests/data/acpi/x86/q35/DSDT.core-count2      | Bin 33855 -> 33842 bytes
>  tests/data/acpi/x86/q35/DSDT.cphp             | Bin 8904 -> 8891 bytes
>  tests/data/acpi/x86/q35/DSDT.cxl              | Bin 13231 -> 13218 bytes
>  tests/data/acpi/x86/q35/DSDT.dimmpxm          | Bin 10094 -> 10081 bytes
>  tests/data/acpi/x86/q35/DSDT.ipmibt           | Bin 8515 -> 8502 bytes
>  tests/data/acpi/x86/q35/DSDT.ipmismbus        | Bin 8528 -> 8515 bytes
>  tests/data/acpi/x86/q35/DSDT.ivrs             | Bin 8457 -> 8444 bytes
>  tests/data/acpi/x86/q35/DSDT.memhp            | Bin 9799 -> 9786 bytes
>  tests/data/acpi/x86/q35/DSDT.mmio64           | Bin 9570 -> 9557 bytes
>  tests/data/acpi/x86/q35/DSDT.multi-bridge     | Bin 13293 -> 13280 bytes
>  tests/data/acpi/x86/q35/DSDT.noacpihp         | Bin 8302 -> 8289 bytes
>  tests/data/acpi/x86/q35/DSDT.nohpet           | Bin 8298 -> 8285 bytes
>  tests/data/acpi/x86/q35/DSDT.numamem          | Bin 8446 -> 8433 bytes
>  tests/data/acpi/x86/q35/DSDT.pvpanic-isa      | Bin 8541 -> 8528 bytes
>  tests/data/acpi/x86/q35/DSDT.thread-count     | Bin 12998 -> 12985 bytes
>  tests/data/acpi/x86/q35/DSDT.thread-count2    | Bin 33855 -> 33842 bytes
>  tests/data/acpi/x86/q35/DSDT.tis.tpm12        | Bin 9046 -> 9033 bytes
>  tests/data/acpi/x86/q35/DSDT.tis.tpm2         | Bin 9072 -> 9059 bytes
>  tests/data/acpi/x86/q35/DSDT.type4-count      | Bin 18674 -> 18661 bytes
>  tests/data/acpi/x86/q35/DSDT.viot             | Bin 14697 -> 14684 bytes
>  tests/data/acpi/x86/q35/DSDT.xapic            | Bin 35803 -> 35790 bytes
>  tests/qtest/bios-tables-test-allowed-diff.h   |  29 ------------------
>  30 files changed, 29 deletions(-)
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT b/tests/data/acpi/x86/q35/DSDT
> index e5e8d1e041e20e1b3ee56a5c93fe3d6ebd721ee6..377e880175f6f11101548c0c64da61b5aee00bd9 100644
> GIT binary patch
> delta 39
> vcmez2_}Y=nCD<k8wE_bJ<I#;=l9F7mPVvD`@zG7*oRf7WXKubMsmcxj3Rw)V
> 
> delta 53
> zcmaFu_`{LQCD<k8hXMlw<Gzhtl9F6b&hf!c@zG5lT$6PrXYz{h#C!UAauhH)2fO-g
> JJ|?Nk4gkhs53c|K
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.acpierst b/tests/data/acpi/x86/q35/DSDT.acpierst
> index 072a3fe2cd17dfe06658dfd82588f69787810114..026bfdfebf66c1803f158ac8c115eb5f49b5cb19 100644
> GIT binary patch
> delta 39
> vcmeBl`s2vu66_N4M}dKXF?A!Cq$HQCQ+%*fd~}mH=VV>UnVT<5ny~`_^t=od  
> 
> delta 53
> zcmez4*y+UO66_MfsmQ><7`u^6Qj*KbIX>7aKDx<+YqGB7OkNS5cuzl1jsgbfU{{~b  
> I$0W_z0eo!^6aWAK
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.acpihmat b/tests/data/acpi/x86/q35/DSDT.acpihmat
> index 2a4f2fc1d5c5649673353186e67ff5b5e59e8d53..f1b8483d8da21dd57f3e5e7a1e4eb787df2c38ac 100644
> GIT binary patch
> delta 39
> vcmZ4LGsB0=CD<iILXClev2i1pq$HP%M|`kTd~}mH=VV>UnVT<52Jrv@*4zt4
> 
> delta 53
> zcmbQ?v($&nCD<iIRgHmxv1%iiq$HQ4XMC_zd~}ls*JNGEnY<!A@t%I390d%{!LB}=
> Jk4Xmc004Yz4n+U}
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.acpihmat-generic-x b/tests/data/acpi/x86/q35/DSDT.acpihmat-generic-x
> index 7911c058bba5005d318b8db8d6da5c1ee381b0f1..a7731403f460a235bf705770a1547dafeee069ab 100644
> GIT binary patch
> delta 39
> vcmaErbT^61CD<h-){udL(R3r1q$HP<Uwp7rd~}mH=VV>UnVT<5P8SCN^mq(Y
> 
> delta 53
> zcmcbc^eTzVCD<h-%aDPAQGO$rq$HQWUwp7rd~}ls*JNGEnY<!A@t%I390d%{!LB}=
> Jk4a7!2LPlJ4^sdD
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.acpihmat-noinitiator b/tests/data/acpi/x86/q35/DSDT.acpihmat-noinitiator
> index 580b4a456a20fc0cc0a832eaf74193b46d8ae8b1..cb4995de7e33cd9f2d134ec96651d217873d6944 100644
> GIT binary patch
> delta 39
> ucmeBoX>#Fm33dr#Qet3WwBE=iDaqv%93SiyAKm25Iayb7=H|<iHXH!OR0^U1  
> 
> delta 53
> zcmZp2>389B33dtLS7KmbG}*`{Daqv-5+CdoAKm1^HCb13Ca(xjyr-WhM*)L#u&dAJ  
> IW0E!;0Apnhq5uE@
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.applesmc b/tests/data/acpi/x86/q35/DSDT.applesmc
> index 5e8220e38d6f88b103f6eb3eb7c78dfa466882dc..92c8fdb6cbb8ae8bdf5ede9679eea92486eaf372 100644
> GIT binary patch
> delta 39
> vcmZ4HG}DR8CD<iIQjvjyamz+7Nl7kOr}$u}_~<5Y&dIuxGdEwB3}y!a*l-J3
> 
> delta 53
> zcmbQ~w9JXiCD<iIO_70taqUJfNl7jz=lEc!_~<4NuF1NRGkHaL;ywL5ISLq@gI#?#
> JACnAb2LOLh4p{&I
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.bridge b/tests/data/acpi/x86/q35/DSDT.bridge
> index ee039453af1071e00a81ee7b37cf8f417f524257..957b3ad90c787616eac212865bce0a19a5ac1e6e 100644
> GIT binary patch
> delta 39
> vcmbOl*Ad6%66_Mfq0hj;_+TTKq$HQCQ+%*fd~}mH=VV>UnVT<5I*9@R-%JaY  
> 
> delta 53
> zcmeB(n;OUE66_Kps?Wf{cyl9{q$HP<b9}H<d~}ls*JNGEnY<!A@t%I390d%{!LB}=
> Jk4ZX-0sx7f4wV1^
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.core-count b/tests/data/acpi/x86/q35/DSDT.core-count
> index 7ebfceeb66460d0ad98471924ce224b7153e87ef..50ca91b065d9a2ba95f97d01856865f0e7c615f6 100644
> GIT binary patch
> delta 40
> wcmX?>x-*r_CD<iorx61KqwPj6NlEVJc*gi(r}*e5Z_dejk~247k^Ce900Y(yC;$Ke  
> 
> delta 54
> zcmdm)dMuU8CD<k8m=Oa5quE9-NlEU81jhJar}*e553b32k~4Wlc;Y?%JUI#&oP%9`
> KHXoP#Bmn@rP7o*n
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.core-count2 b/tests/data/acpi/x86/q35/DSDT.core-count2
> index d0394558a1faa0b4ba43abab66d474d96b477ff3..f460be2bf74ae512db8f24418b42e8cf2a56202d 100644
> GIT binary patch
> delta 42
> ycmdnr!L+G^iOVI}CB&$Ofq}7aBbTHkcTX8xe6Uk|bdxvdWIf55o3BV_X8`~d01a>e  
> 
> delta 56
> zcmdng!L+}FiOVI}CB(jkfq}7oBbTHkcV{_Ue6Uk|bdv|yWIf55ydpgDo_?Mj1q{x?
> Mu0ETOOJ-*Q0MS7ZZ~y=R
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.cphp b/tests/data/acpi/x86/q35/DSDT.cphp
> index a055c2e7d3c4f5a00a03be20fd73227e322283a4..7c87d41d03fcfd2b5b82f2581f16de6bc0bb10bf 100644
> GIT binary patch
> delta 39
> vcmX@%y4#h@CD<iow-N&bqs2xpNl7l(`1oL__~<5Y&dIuxGdEwB{K^3U?XnDt
> 
> delta 53
> zcmdn(dcu{<CD<k8gc1V-qv1v_Nl7lJg!o{m_~<4NuF1NRGkHaL;ywL5ISLq@gI#?#
> JACvsb0RWs;4~hT)
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.cxl b/tests/data/acpi/x86/q35/DSDT.cxl
> index 20843549f54af1cb0e6017c4cfff7463318d9eb7..da86b25f51b550ab20771111cb0a2bc49e713186 100644
> GIT binary patch
> delta 39
> vcmZ3Vz9^l`CD<iokud`U<Ijy;l9F7mPVvD`@zG7*oRf7WXKubMc}Efe|Hln5
> 
> delta 53
> zcmZ3KzCNAHCD<ioy)gp=<EM>Wl9F6b&hf!c@zG5lT$6PrXYz{h#C!UAauhH)2fO-g
> JJ|=lb5&*aE5HJ7$
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.dimmpxm b/tests/data/acpi/x86/q35/DSDT.dimmpxm
> index 664e926e90765550136242f7e3e0bdc7719c1853..a2d812e5a23a3ce7739789246b342e703f8c96c0 100644
> GIT binary patch
> delta 39
> vcmaFo_t1~aCD<h-QJsN-@##h`T}dv#;P_yt_~<5Y&dH9FGdDk%Z07|41ThT|
> 
> delta 53
> zcmaFp_s);YCD<h-Po05*@!m!*T}dwQkoaJy_~<4NuE~y)GkHaL;ywL5ISLq@gI#?#
> J-;!+S1pvOk5D)+W
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.ipmibt b/tests/data/acpi/x86/q35/DSDT.ipmibt
> index 4066a76d26aa380dfbecc58aa3f83ab5db2baadb..43ac1bd693d1b3f67d2a9e89ccaf8a56656df22d 100644
> GIT binary patch
> delta 39
> vcmX@?w9SdjCD<jzOp$?s@yA9kNl7kOr}$u}_~<5Y&dIuxGdEwBEMNx!>rf04
> 
> delta 53
> zcmdnybl8c@CD<jzS&@N(@#97=Nl7jz=lEc!_~<4NuF1NRGkHaL;ywL5ISLq@gI#?#
> JACoL#2LPI>4-o(W  
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.ipmismbus b/tests/data/acpi/x86/q35/DSDT.ipmismbus
> index 6d0b6b95c2a9fd01befc37b26650781ee1562e2a..1b998820d46e522b3129e42a867ed691c1f83e8f 100644
> GIT binary patch
> delta 39
> vcmccMbl8c@CD<jzS&@N(F>@oAq$HQCQ+%*fd~}mH=VV>UnVT<5*0KWt;?)bb
> 
> delta 53
> zcmX@?bis+sCD<h-K#_rgF=->0q$HP<b9}H<d~}ls*JNGEnY<!A@t%I390d%{!LB}=
> Jk4e_D0|1PE4z>UQ  
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.ivrs b/tests/data/acpi/x86/q35/DSDT.ivrs
> index 072a3fe2cd17dfe06658dfd82588f69787810114..026bfdfebf66c1803f158ac8c115eb5f49b5cb19 100644
> GIT binary patch
> delta 39
> vcmeBl`s2vu66_N4M}dKXF?A!Cq$HQCQ+%*fd~}mH=VV>UnVT<5ny~`_^t=od  
> 
> delta 53
> zcmez4*y+UO66_MfsmQ><7`u^6Qj*KbIX>7aKDx<+YqGB7OkNS5cuzl1jsgbfU{{~b  
> I$0W_z0eo!^6aWAK
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.memhp b/tests/data/acpi/x86/q35/DSDT.memhp
> index 4f2f9bcfceff076490cc49b8286380295a340004..7346125d23fb3174c0ce678a2cdf2fdc77c4a9fa 100644
> GIT binary patch
> delta 39
> vcmX@^v&)CeCD<jzN{xYmamGe2Nl7kmr}$u}_~<5Y&dIuxGdEwBEa3qF=Zp*G
> 
> delta 53
> zcmdnxbKHl^CD<jzU5$Z(apFcUNl7jb=lEc!_~<4NuF1NRGkHaL;ywL5ISLq@gI#?#
> JACoNM0RWT#4&?v<
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.mmio64 b/tests/data/acpi/x86/q35/DSDT.mmio64
> index 0fb6aab16f1bd79f3c0790cc9f644f7e52ac37b1..15a291dbfb62e6ceb0249e02eb25b319744e351f 100644
> GIT binary patch
> delta 39
> vcmaFlb=8Z@CD<h-RF#2&F>)i9q$HQOQ+%*fd~}mH=VV>UnVT<5_HzRO>=z6S
> 
> delta 53
> zcmccW^~j6MCD<h-NtJ<tF=!)~q$HPzb9}H<d~}ls*JNGEnY<!A@t%I390d%{!LB}=
> Jk4g4(0|1#o4-5bR
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.multi-bridge b/tests/data/acpi/x86/q35/DSDT.multi-bridge
> index f6afa6d96d2525d512cc46f17439f7a49962b730..889a9040d950dd08980408d57f1037a5fc20c961 100644
> GIT binary patch
> delta 39
> vcmaEx{ve&pCD<k8fiVLE<E@Qcl9F7mPVvD`@zG7*oRf7WXKubMDJ2B}6!;Aa
> 
> delta 53
> zcmaEm{x+S<CD<k8tuX@w<K>N9l9F6b&hf!c@zG5lT$6PrXYz{h#C!UAauhH)2fO-g
> JJ|-z81pw8G5DEYQ
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.noacpihp b/tests/data/acpi/x86/q35/DSDT.noacpihp
> index 9f7261d1b06bbf5d8a3e5a7a46b247a2a21eb544..780616774f97a2d7305faf9e9a9d12afeb0e2fa2 100644
> GIT binary patch
> delta 39
> vcmaFo@X&$FCD<h-QGtPhars8BUE*A>PVvD`@zG7*oRiOq&)i%h@rxY*2F?wn
> 
> delta 53
> zcmaFp@XmqDCD<h-Pl17faluBeUE*9$&hf!c@zG5lT$9g<&*T;1iTCvL<S1Zp4tDj~
> JoG$T;9RSJJ5TpPA
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.nohpet b/tests/data/acpi/x86/q35/DSDT.nohpet
> index 99ad629c9171ff6ab346d6b4c519e77ca23e5b1c..0f862ab2938e0e11aa8335630fad389095b37edd 100644
> GIT binary patch
> delta 39
> vcmaFmaMyv$CD<h-R)K+mv2P<+w*;4~Q+%*fd~}mH=j8bkGdH_Rs<HzB`rQm5
> 
> delta 53
> zcmccX@XCS9CD<h-OM!ubv3(;~w*;4yb9}H<d~}ls*W~#UGkHaL;ywL5ISLq@gI#?#
> JTS%(10|2(>4<G;l  
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.numamem b/tests/data/acpi/x86/q35/DSDT.numamem
> index fd1d8a79d3d9b071c8796e5e99b76698a9a8d29c..df8edc05b69ecd1331973b16e534b44616b50f58 100644
> GIT binary patch
> delta 39
> vcmez8_|cKeCD<k8qXGj1W8g+ENl7kmr}$u}_~<5Y&dIuxGdEwB)Mf_&0sjnH
> 
> delta 53
> zcmez9_|K8cCD<k8p8^8|qt`|*Nl7jb=lEc!_~<4NuF1NRGkHaL;ywL5ISLq@gI#?#
> JACuH(2LQPL4_N>J  
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.pvpanic-isa b/tests/data/acpi/x86/q35/DSDT.pvpanic-isa
> index 89032fa0290f496be0c06c6382586541aa1118a8..da3ce12787c28e555b6ba5eacb26275bdd4587f1 100644
> GIT binary patch
> delta 39
> vcmccXbis+sCD<h-K#_rgv3w(!q$HQCQ+%*fd~}mH=VV>UnVT<5cCiBh>8}g;
> 
> delta 53
> zcmccMbk~W?CD<h-R*`{$v0x*Yq$HP<b9}H<d~}ls*JNGEnY<!A@t%I390d%{!LB}=
> Jk4bj10|1sj4)_27
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.thread-count b/tests/data/acpi/x86/q35/DSDT.thread-count
> index 7ebfceeb66460d0ad98471924ce224b7153e87ef..50ca91b065d9a2ba95f97d01856865f0e7c615f6 100644
> GIT binary patch
> delta 40
> wcmX?>x-*r_CD<iorx61KqwPj6NlEVJc*gi(r}*e5Z_dejk~247k^Ce900Y(yC;$Ke  
> 
> delta 54
> zcmdm)dMuU8CD<k8m=Oa5quE9-NlEU81jhJar}*e553b32k~4Wlc;Y?%JUI#&oP%9`
> KHXoP#Bmn@rP7o*n
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.thread-count2 b/tests/data/acpi/x86/q35/DSDT.thread-count2
> index d0394558a1faa0b4ba43abab66d474d96b477ff3..f460be2bf74ae512db8f24418b42e8cf2a56202d 100644
> GIT binary patch
> delta 42
> ycmdnr!L+G^iOVI}CB&$Ofq}7aBbTHkcTX8xe6Uk|bdxvdWIf55o3BV_X8`~d01a>e  
> 
> delta 56
> zcmdng!L+}FiOVI}CB(jkfq}7oBbTHkcV{_Ue6Uk|bdv|yWIf55ydpgDo_?Mj1q{x?
> Mu0ETOOJ-*Q0MS7ZZ~y=R
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.tis.tpm12 b/tests/data/acpi/x86/q35/DSDT.tis.tpm12
> index f2ed40ca70cb13e733e39f4bad756be8688e01fe..67ebd7c158759221b801ecb67d8562d92fa219d5 100644
> GIT binary patch
> delta 39
> vcmccScG8W@CD<jzQ<;H*@#{t|Nl7kOr}$u}_~<5Y&dIuxGdEwBY~}<2^lc1g
> 
> delta 53
> zcmX@<cFm2;CD<h-Oqqd!@!du)Nl7jz=lEc!_~<4NuF1NRGkHaL;ywL5ISLq@gI#?#
> JACqk61OTT-4`u)W
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.tis.tpm2 b/tests/data/acpi/x86/q35/DSDT.tis.tpm2
> index 5c975d2162d0bfee5a3a089e79b5ba038f82b7ef..c6b58472157d575e2625557d1346586be06b927c 100644
> GIT binary patch
> delta 39
> vcmez1_SlWfCD<h-S($->as5UvNl7kOr}$u}_~<5Y&dIuxGdEwBoXZIS_>T;T
> 
> delta 53
> zcmaFt_Q8$ICD<jTK$(Goam7Y1Nl7jz=lEc!_~<4NuF1NRGkHaL;ywL5ISLq@gI#?#
> JACsKR2>`3u4~PH&  
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.type4-count b/tests/data/acpi/x86/q35/DSDT.type4-count
> index 3194a82b8b4f66aff1ecf7d2d60b4890181fc600..17a64adb2055ad3168754ca121bf29851d2ee496 100644
> GIT binary patch
> delta 42
> ycmew~k@4w7MlP3Nmyo9(3=E7>8@VJUx%&??#RogZM>lzMPS%s0x%rBuoIU_FstxM^  
> 
> delta 56
> zcmaDlk@3?+MlP3Nmyk~$3=E9H8@VJUxqA*V#RogZM>lzJP1ci~$t%JW@9F2sQNZ9F
> M?CP`mxTKsu001Nq>i_@%  
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.viot b/tests/data/acpi/x86/q35/DSDT.viot
> index 129d43e1e561be3fd7cd71406829ab81d0a8aba0..6eb30e8f4b2c54e4789c649475adff356c8c58a4 100644
> GIT binary patch
> delta 39
> vcmaD^bf<{RCD<h-#*%@7ar#CsNl7kOr}$u}_~<5Y&dIuxGdEwBoF)$d0-g-m
> 
> delta 53
> zcmcap^s<P{CD<h-(~^OKal%F}Nl7jz=lEc!_~<4NuF1NRGkHaL;ywL5ISLq@gI#?#
> JACsIW4*<Dl57+<z
> 
> diff --git a/tests/data/acpi/x86/q35/DSDT.xapic b/tests/data/acpi/x86/q35/DSDT.xapic
> index b37ab591110d1c8201575ad6bba83449d7b90b21..111bb041dc0d114351add07c040dde61643d157a 100644
> GIT binary patch
> delta 42
> ycmcaTo$1_kCN7s?mymPa3=E828@VJUxjR0v#RogZM>lzMPS%s0x%rADdl3LU$qs)2  
> 
> delta 56
> zcmX>%o$2;;CN7s?myp}t3=E9T8@VJUxm!Q7#RogZM>lzJP1ci~$t%JW@9F2sQNZ9F  
> M?CP`mxFmZK01fjIe*gdg
> 
> diff --git a/tests/qtest/bios-tables-test-allowed-diff.h b/tests/qtest/bios-tables-test-allowed-diff.h
> index 2ed74f72e7c9..dfb8523c8bf4 100644
> --- a/tests/qtest/bios-tables-test-allowed-diff.h
> +++ b/tests/qtest/bios-tables-test-allowed-diff.h
> @@ -1,30 +1 @@
>  /* List of comma-separated changed AML files to ignore */
> -"tests/data/acpi/x86/q35/DSDT",
> -"tests/data/acpi/x86/q35/DSDT.tis.tpm2",
> -"tests/data/acpi/x86/q35/DSDT.tis.tpm12",
> -"tests/data/acpi/x86/q35/DSDT.bridge",
> -"tests/data/acpi/x86/q35/DSDT.noacpihp",
> -"tests/data/acpi/x86/q35/DSDT.multi-bridge",
> -"tests/data/acpi/x86/q35/DSDT.ipmibt",
> -"tests/data/acpi/x86/q35/DSDT.cphp",
> -"tests/data/acpi/x86/q35/DSDT.numamem",
> -"tests/data/acpi/x86/q35/DSDT.nohpet",
> -"tests/data/acpi/x86/q35/DSDT.acpihmat-noinitiator",
> -"tests/data/acpi/x86/q35/DSDT.acpihmat-generic-x",
> -"tests/data/acpi/x86/q35/DSDT.memhp",
> -"tests/data/acpi/x86/q35/DSDT.dimmpxm",
> -"tests/data/acpi/x86/q35/DSDT.acpihmat",
> -"tests/data/acpi/x86/q35/DSDT.mmio64",
> -"tests/data/acpi/x86/q35/DSDT.acpierst",
> -"tests/data/acpi/x86/q35/DSDT.applesmc",
> -"tests/data/acpi/x86/q35/DSDT.pvpanic-isa",
> -"tests/data/acpi/x86/q35/DSDT.ivrs",
> -"tests/data/acpi/x86/q35/DSDT.type4-count",
> -"tests/data/acpi/x86/q35/DSDT.core-count",
> -"tests/data/acpi/x86/q35/DSDT.core-count2",
> -"tests/data/acpi/x86/q35/DSDT.thread-count",
> -"tests/data/acpi/x86/q35/DSDT.thread-count2",
> -"tests/data/acpi/x86/q35/DSDT.viot",
> -"tests/data/acpi/x86/q35/DSDT.cxl",
> -"tests/data/acpi/x86/q35/DSDT.ipmismbus",
> -"tests/data/acpi/x86/q35/DSDT.xapic",


