Return-Path: <kvm+bounces-39289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12A4EA4621E
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 15:17:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0678B17AE9F
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 14:17:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBA26221721;
	Wed, 26 Feb 2025 14:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OVcnoHyt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA18219E8D
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 14:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740579425; cv=none; b=eEmlYlqpsqhgmc6BR8HTn8jwTflJOl8n6fzj30ZzTrBIKxtKLtwyUKmfTpwron1aYwYOiWTsmv2dZRP6TEYPTHOzrVEUeoM/1UkQwRAgFWAVVfds4KIB7jPe8RO1BjRpxrtycg++P/tWxt5ynv6r+OgGmkU3N6QjcKwHDHfoPD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740579425; c=relaxed/simple;
	bh=tHXWRUcfC/Uu4A9QJGcvpZQXhOm64uKap9xDNT5NsNk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KxS8H5pcOpsJlvNCh0p2a8FCBgVIHgyh4Aq+z1n/c6D3fZvLNJZDeYVqPEFw6SVb+uulPJirsd0Mq+Ne2wbcE+cEwU+8swuXdQxGfyAx1RXMhHkg0aupppwlHjdH8h90stGbGtGr7GNsM5XD+6aM0++kJOd37M+IEts1KqcN+nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OVcnoHyt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740579421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U47VA7bQAyReFmXTz+SvCcW2YjnEudaZ9f05EVRkBHw=;
	b=OVcnoHyt0ec6xHiN1RUFJmZlzyeHGE7rzfByghIMmyykydOHk/Rmado59zAadYY+nds1lL
	Ei1q3PGRHbQy5POCEppJ9SXEgKUHSck7I+aCNki73tqAPcmfXIcZGJr1QnWeDvmqEJ/OQb
	jzThAkTvvnl/ft+/sHstW+2zwjePUrY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-hVRHVpVINymUw_5d9eJwcA-1; Wed, 26 Feb 2025 09:16:59 -0500
X-MC-Unique: hVRHVpVINymUw_5d9eJwcA-1
X-Mimecast-MFC-AGG-ID: hVRHVpVINymUw_5d9eJwcA_1740579418
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43aafafe6b7so17897115e9.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 06:16:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740579418; x=1741184218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U47VA7bQAyReFmXTz+SvCcW2YjnEudaZ9f05EVRkBHw=;
        b=Ft7Sn2uZmkgdkyYNz2S+OAR8RH3fnz9MD7s9loq66Em2JlwHBgoGdBREkRdvS7DV7n
         gbyVebYCanu2ssYB03CU8TUbB8skiQPBwLS7hDXpdv3ssP6fX0j0uW8I6TglOdpIkgwB
         2OJjt8Zhi5lI2NAFukWkXEiQLcnCg2oPungoIRumplgMzUnioDY9sx6/VXS5B5z0gY+v
         G73LXIsqZhHbAPThHMc5n+150lUHZnwXE08QDGzPCGCQeGE8McZ4BTSAKr+NcMxR7Cys
         BX3ugb/wjmpKOvv+/XOWnmgaNVZNT9fii4M0JBklmJOxlpD8PrLhb/c3hC9Q31Kk8hEv
         M7UQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbTPT6u9Uuu8VRTm6k6j/6OPrSskkszuYNVnooV7YnAdl4DCjLm+eyRwwQo8JDSqUQDJA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8wJ8U4Bl6Rg9gfxNeKuu4bf9GWDQfA8V5MdHzqI5MZpcEh/yy
	gBL+JVVctRwBuMcOKOIAJi2+9AUbIQw96rLLzzptdPoAlecTrh8wKJPCn1Xfrcty1Wn6WH/ziR4
	OAS+tHd65yGQ/UV2Hav2/CEIVgHi8TcTzpHEfvmchIu65ZdrP4Q==
X-Gm-Gg: ASbGncuDuKG1sN5qK0sSXfM5zpnxoALlndP042zbnOCRMUEMl5j6gK8DKkZEv2QscMU
	pADRZ4xz1skVNQMYT2myt7EH9FAFag1a5JUSMO9zaekntfgUSlsTVZlYIjrOEMSEwo4dJsrsaig
	0NO9gB4xk8nGUsS8HSDeBYbljxAK8olIZ9WkoUNF6IulsAXuHxtHNyesvgBwVLK7QqGX6f37p/0
	iS1mIhuPWiojQDUfkIiF6dgUSGj38ll9VFWhiwNweG9Cj0xmcq2WRwCeWdzklBIXLbhj5tADTxq
	PNbK/RbrcrzCi70US/c/PGpEpr+nASHIdjMXdIviu1c4X17VefxyIKdCn9T03/Q=
X-Received: by 2002:a05:6000:1ac8:b0:38f:39e5:6b5d with SMTP id ffacd0b85a97d-390d4f8b64bmr2980504f8f.44.1740579418271;
        Wed, 26 Feb 2025 06:16:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGpbWVd48qhAy+RqiOR6hOvkRh0yJcnowd3kVeAC9R1PEvlXonoM8kmft0OL4NXIEZaESe9oA==
X-Received: by 2002:a05:6000:1ac8:b0:38f:39e5:6b5d with SMTP id ffacd0b85a97d-390d4f8b64bmr2980477f8f.44.1740579417874;
        Wed, 26 Feb 2025 06:16:57 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390de5a5b5esm1102094f8f.89.2025.02.26.06.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 06:16:57 -0800 (PST)
Date: Wed, 26 Feb 2025 15:16:56 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jonathan Cameron
 <Jonathan.Cameron@huawei.com>, Shiju Jose <shiju.jose@huawei.com>,
 qemu-arm@nongnu.org, qemu-devel@nongnu.org, Philippe =?UTF-8?B?TWF0aGll?=
 =?UTF-8?B?dS1EYXVkw6k=?= <philmd@linaro.org>, Ani Sinha
 <anisinha@redhat.com>, Cleber Rosa <crosa@redhat.com>, Dongjiu Geng
 <gengdongjiu1@gmail.com>, Eduardo Habkost <eduardo@habkost.net>, Eric Blake
 <eblake@redhat.com>, John Snow <jsnow@redhat.com>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, Markus Armbruster <armbru@redhat.com>,
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Shannon Zhao
 <shannon.zhaosl@gmail.com>, Yanan Wang <wangyanan55@huawei.com>, Zhao Liu
 <zhao1.liu@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/14] Change ghes to use HEST-based offsets and add
 support for error inject
Message-ID: <20250226151656.10665bc9@imammedo.users.ipa.redhat.com>
In-Reply-To: <cover.1740148260.git.mchehab+huawei@kernel.org>
References: <cover.1740148260.git.mchehab+huawei@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 21 Feb 2025 15:35:09 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> Now that the ghes preparation patches were merged, let's add support
> for error injection.
> 
> On this series, the first 6 patches chang to the math used to calculate offsets at HEST
> table and hardware_error firmware file, together with its migration code. Migration tested
> with both latest QEMU released kernel and upstream, on both directions.
> 
> The next patches add a new QAPI to allow injecting GHESv2 errors, and a script using such QAPI
>    to inject ARM Processor Error records.

please, run ./scripts/checkpatch on patches before submitting them.
as it stands now series cannot be merged due to failing checkpatch

> 
> ---
> v4:
> - added an extra comment for AcpiGhesState structure;
> - patches reordered;
> - no functional changes, just code shift between the patches in this series.
> 
> v3:
> - addressed more nits;
> - hest_add_le now points to the beginning of HEST table;
> - removed HEST from tests/data/acpi;
> - added an extra patch to not use fw_cfg with virt-10.0 for hw_error_le
> 
> v2: 
> - address some nits;
> - improved ags cleanup patch and removed ags.present field;
> - added some missing le*_to_cpu() calls;
> - update date at copyright for new files to 2024-2025;
> - qmp command changed to: inject-ghes-v2-error ans since updated to 10.0;
> - added HEST and DSDT tables after the changes to make check target happy.
>   (two patches: first one whitelisting such tables; second one removing from
>    whitelist and updating/adding such tables to tests/data/acpi)
> 
> 
> 
> Mauro Carvalho Chehab (14):
>   acpi/ghes: prepare to change the way HEST offsets are calculated
>   acpi/ghes: add a firmware file with HEST address
>   acpi/ghes: Use HEST table offsets when preparing GHES records
>   acpi/ghes: don't hard-code the number of sources for HEST table
>   acpi/ghes: add a notifier to notify when error data is ready
>   acpi/ghes: create an ancillary acpi_ghes_get_state() function
>   acpi/generic_event_device: Update GHES migration to cover hest addr
>   acpi/generic_event_device: add logic to detect if HEST addr is
>     available
>   acpi/generic_event_device: add an APEI error device
>   tests/acpi: virt: allow acpi table changes for a new table: HEST
>   arm/virt: Wire up a GED error device for ACPI / GHES
>   tests/acpi: virt: add a HEST table to aarch64 virt and update DSDT
>   qapi/acpi-hest: add an interface to do generic CPER error injection
>   scripts/ghes_inject: add a script to generate GHES error inject
> 
>  MAINTAINERS                                   |  10 +
>  hw/acpi/Kconfig                               |   5 +
>  hw/acpi/aml-build.c                           |  10 +
>  hw/acpi/generic_event_device.c                |  43 ++
>  hw/acpi/ghes-stub.c                           |   7 +-
>  hw/acpi/ghes.c                                | 231 ++++--
>  hw/acpi/ghes_cper.c                           |  38 +
>  hw/acpi/ghes_cper_stub.c                      |  19 +
>  hw/acpi/meson.build                           |   2 +
>  hw/arm/virt-acpi-build.c                      |  37 +-
>  hw/arm/virt.c                                 |  19 +-
>  hw/core/machine.c                             |   2 +
>  include/hw/acpi/acpi_dev_interface.h          |   1 +
>  include/hw/acpi/aml-build.h                   |   2 +
>  include/hw/acpi/generic_event_device.h        |   1 +
>  include/hw/acpi/ghes.h                        |  54 +-
>  include/hw/arm/virt.h                         |   2 +
>  qapi/acpi-hest.json                           |  35 +
>  qapi/meson.build                              |   1 +
>  qapi/qapi-schema.json                         |   1 +
>  scripts/arm_processor_error.py                | 476 ++++++++++++
>  scripts/ghes_inject.py                        |  51 ++
>  scripts/qmp_helper.py                         | 702 ++++++++++++++++++
>  target/arm/kvm.c                              |   7 +-
>  tests/data/acpi/aarch64/virt/DSDT             | Bin 5196 -> 5240 bytes
>  .../data/acpi/aarch64/virt/DSDT.acpihmatvirt  | Bin 5282 -> 5326 bytes
>  tests/data/acpi/aarch64/virt/DSDT.memhp       | Bin 6557 -> 6601 bytes
>  tests/data/acpi/aarch64/virt/DSDT.pxb         | Bin 7679 -> 7723 bytes
>  tests/data/acpi/aarch64/virt/DSDT.topology    | Bin 5398 -> 5442 bytes
>  29 files changed, 1677 insertions(+), 79 deletions(-)
>  create mode 100644 hw/acpi/ghes_cper.c
>  create mode 100644 hw/acpi/ghes_cper_stub.c
>  create mode 100644 qapi/acpi-hest.json
>  create mode 100644 scripts/arm_processor_error.py
>  create mode 100755 scripts/ghes_inject.py
>  create mode 100755 scripts/qmp_helper.py
> 


