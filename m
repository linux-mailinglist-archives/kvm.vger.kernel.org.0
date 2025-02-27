Return-Path: <kvm+bounces-39556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 57686A479A0
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 10:55:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7C2E1889533
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 09:55:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B823229B00;
	Thu, 27 Feb 2025 09:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a3+nueta"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D6742065
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 09:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740650102; cv=none; b=hoKUVs3Pth+Ot4FwfUr/veBZ6dGdD0VgeCWqFvzHj//T2lOJg5wndgwHRdczQiYCb3oT8WyGN4cINRLC+jT2hV1v+cuMNVloZEkMhUvJPIPNuPclIkbLsgFod+lOIVDqfP2lF2vv5uhRlbLB/ee3/uxicE4ylGEm65t89PF0qIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740650102; c=relaxed/simple;
	bh=nNy/XI7LSsI3A4lshOd/X1+NFMLZUoE26TwjOAgGz+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BOpiHBrLXL9lFIPofZDiTNc66UkJd+GFjzI/uazv+weZYHs5K9UL2hlTBUrePN9bAYDCRkqYGS7MM/eKVa9NTFGUXdpuMOCYHwk6ECQuwyBafSD+QLxOBMvnv2PcZPWLz1NXvGnwB5/1KUpVjatiS3dvYE/StHXSAwW+D6OUCJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a3+nueta; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740650100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sM37GoCBrelHpecugQ7DvbegVqt19Ri+N9wNIK8C7vQ=;
	b=a3+nuetapw9s7EuMln8BW2dhK8vIH/G9I/rwefekIbPo/p8LDT8YmO/PpYK1eLTWRLX6xX
	2Q4ipXhdUl8CLDNozt8QRRvUFc1uDfUQjSnlFhDc3BCzhxl4p0YirBOOAusrd29wtn7L/r
	UQSrdqsKPK3V0R5asg182XdMkZekjQw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441--K7GYzEhNKev8iXsYvz2Vg-1; Thu, 27 Feb 2025 04:54:58 -0500
X-MC-Unique: -K7GYzEhNKev8iXsYvz2Vg-1
X-Mimecast-MFC-AGG-ID: -K7GYzEhNKev8iXsYvz2Vg_1740650097
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4393e89e910so3763535e9.0
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:54:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740650097; x=1741254897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sM37GoCBrelHpecugQ7DvbegVqt19Ri+N9wNIK8C7vQ=;
        b=byC3vfHi0Pbn4l/YVehZD65m1rpEGRIDfuxOud/TBkt65sSFWFCecDtNgq5XDm6Y7L
         HNayN3NM7q2CSnj9LiXuFUo1b/qr5VgMK+mpz0Pob4bOk4Xz3SwueEVCoRdjpX5F5B9J
         DE2IL7v878d1yYn5JMNGzvnxEuc8hZL2pzxtlWHKCfrmDVFsUrnyU/ZKxm09iwrXHHXI
         LdQlfYaoz6ifM2pfzWoSuLFavhCgCNX0uWTdwofkbK4HM8olvHq0OGywXpxLWvT+6GNy
         h0HGw/s5goUr0yWaBIk5mNB2YupoeUBul0ctCTlgZD12Tkx9DGa2G9/Kf00wtLtXb4fk
         LXIA==
X-Forwarded-Encrypted: i=1; AJvYcCVieZpOui5jeH+O+W81TwbNgCRcJzploU0r7gfKCDt/KCiHoT8Xfb5m6+aXnJJL2YUuFy0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxlch48DzbkQ4T0DfMzoeiWqf/4Eszib0uiM5RZr444cpTdnUA3
	Hpcfre4laZam8Daa8gKECR7CiLBQ1Y9zlmpPcZGBaRGx130pHYeumREzOTpp/ALiIuwiglPR2OU
	Nriw0+4xd/wVvZuZeGbDjruPaREAl1iwlkAFgmMo/x1r5sic9Kw==
X-Gm-Gg: ASbGncux2/FZOeJV/1yg2VGlG69xxQBt0RDHQKbojUArH0Q02XVK5b8YvO7cBTzlp0a
	CSPrCFXB5HQMvEIv+Se062vgskfvXWTbp0ovVc85jPZrdq3fXlyF1YyiNsOHDRlbOjAVySGmlFL
	Gy3XLTckhvD1uTlEda0OY6OFJSoCpdQlUHeR6jrNv2oUrDvV7fMj4O7qwHFYQCKi1nYxGeE+I+B
	bh+kQvD1SPsnCXc+3n5DxZKckFY6vEQu2O/bok+3tQsnZ/7JIkttp24xLqV1sWj/RXyoHkr9Wdn
	QAbR3DMZF5EtwgAN1yxRnz+uaTthgefDuequU23R6kwqgwBOmsSgQ/aM8OWlXSE=
X-Received: by 2002:a05:600c:b97:b0:43b:8198:f6fc with SMTP id 5b1f17b1804b1-43b8198f8efmr17561975e9.11.1740650096849;
        Thu, 27 Feb 2025 01:54:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEIPu5VQ/hiL8z8t1cKtb2pjMgTWX7upe4WwktQRFRpTNjOGTmG0PLGgfQJU7qJUE349QFvTg==
X-Received: by 2002:a05:600c:b97:b0:43b:8198:f6fc with SMTP id 5b1f17b1804b1-43b8198f8efmr17561605e9.11.1740650096489;
        Thu, 27 Feb 2025 01:54:56 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43b73718e2asm17268555e9.21.2025.02.27.01.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 01:54:55 -0800 (PST)
Date: Thu, 27 Feb 2025 10:54:54 +0100
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
Message-ID: <20250227105454.69e3d459@imammedo.users.ipa.redhat.com>
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

once you enable, ras in tests as 1st patches and fixup minor issues
please try to do patch by patch compile/bios-tables-test testing, to avoid
unnecessary respin in case at table change crept in somewhere unnoticed. 


