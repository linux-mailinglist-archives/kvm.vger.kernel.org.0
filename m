Return-Path: <kvm+bounces-39301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3681EA4664B
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 17:14:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04A5317A87D
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 16:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AEE6224AE4;
	Wed, 26 Feb 2025 16:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cgAd6pzO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B834921D580
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 16:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740585646; cv=none; b=k0L1wLDEQqALwMuYywMM1ge+DVcyZ9T5GvB/Zz16Bra3Mnsi/MoC9M/iv/6qJGIiiVH1IpKKo4+KvZplQ6ULGM0e3qlB1L2ogcAPLoEUrwDQ0Orfqf24XbozAdQGoZY3D/WLI0d8pBlZNiuRE36e36hXGi2r8gls0cQIM2ySvuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740585646; c=relaxed/simple;
	bh=PzU4b01qO2LwfblWa/oKQuFMDxEUtm45DRVjkCcoteY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j0l4Y0BYMA1Nv2HvTbVl6g4IplhJ2I5uUhI6Qm48/wQa6Z06IIv7F1TJMCxWHkGA2ztqz37AgtCcQ/b84WFUXwhVlEtYWgroYX1jrT4I64FaDpLoh1LAH/b1/crYWwrQGhg1LSStDXjlFjK6yh95g7f1TZZXXCz22IPtVE2wNgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cgAd6pzO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740585643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lqa5gQlqS9US5GtfUQPHzeFlJi9ebohvbqbVThoHRcI=;
	b=cgAd6pzOEJuz8vcml6ta9hJZw/bV0c+3bDz4HOj465LlP2hPY9LBBuzn8aGiMmwY1UQQ21
	mb1Coz5rh5vg6BTSUHGpFW5nms4q0FqHqXSvNZh2p+M19dNWvOxpb9ae7LbRe0Z/Py2MjF
	BqqIEwdQP/vUPHsSvVhvPIvoAlw8mts=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-j5t9PsNXOkio33uOh44l9w-1; Wed, 26 Feb 2025 11:00:42 -0500
X-MC-Unique: j5t9PsNXOkio33uOh44l9w-1
X-Mimecast-MFC-AGG-ID: j5t9PsNXOkio33uOh44l9w_1740585641
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4399a5afcb3so64218935e9.3
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 08:00:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740585641; x=1741190441;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lqa5gQlqS9US5GtfUQPHzeFlJi9ebohvbqbVThoHRcI=;
        b=WGxXMMogLiSsVYTq38LoK5zEXrfmlcFuMh0gMy84WgMddoUt5GVvI2xd1AT++p5nef
         g87ohpUfc4CqvAew/PR60X/q/xUT5wcrGR2LUjvTJUbJJynu9hhoOVMbOu15pAvTWDqA
         8x9mp5P+eEgFJ6JWuwe1JsSterKKyvtdAondUj5jPX5MDt0dPZB05eBkiEudDrf5CwxP
         YACxSN9nYOqGcP5/aGLep3eacOWM6q4ryNauX350/xrt5JbQDpFn2rAg19nSfQo8AMCJ
         5faFGwCKxSbTOBMJnUwhomzonoMAMoztJg0snpyhqfoODZOXXvjQQc7B2FGKEB3wL6WM
         fEfg==
X-Forwarded-Encrypted: i=1; AJvYcCWk9hv5z4Id3C+yxOnOQNjEKs6HrqFu+59cwzUJEwfhQUKR/dx2M2tjDWrYYQ45bgyBEpc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQFil5fFD0Ia0/lzX/hksIohmygzW3aNSfQBCNe8qkOxhABW/9
	o4gcEQBbLCXEDvSV1gMkcc/g321kE5hfyQIVjYW3/CX51vmfCQCHohw46hGf6Fkk7m+asTN5Ebn
	+NGUebzipVJGunZcaLgnEM3iYmAf1g53VLegJfBklRtG/9jS1oA==
X-Gm-Gg: ASbGncv6/NjVSXQMMzc7q30WMfvyS321j9JnUhc2SUZMXvIPY0pAe6caHy35MYfqGdo
	JRva7LjT2VjUdlhBJDjKi6nEzfzxFyPwJK1G2Vh6oNM6XekIdFS8wOjv0Lmsgb3sDeFVfd0wjuQ
	i1qhevMfF26LqCEoxsw8Lir7sqUeSwRqS1ncu7/mgt85deO6CPC3kulXPHwaqYVHaHe5uAuRiSF
	2H6jz7WISk0GBusjqbQROaW7vOcz+jlthS2fSppJuQIIgut29yqgy4e7ZFeLtVTdTUE2b+RPW+l
	jPaSkPxJzfQ8oe79+jycoBW3Dd8w27gKnUEPBAB/hY3RlaMflMMqnSmmcfQRswg=
X-Received: by 2002:a05:600c:1c86:b0:439:8b05:66a6 with SMTP id 5b1f17b1804b1-43ab0f64425mr75173685e9.22.1740585639387;
        Wed, 26 Feb 2025 08:00:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEGOJUxfNkJ47dOepAoS3DkNdGuo0CohyHyhD/GA0TMRONmh8zeK9C4FdbnePVZ6SIE8cqCJg==
X-Received: by 2002:a05:600c:1c86:b0:439:8b05:66a6 with SMTP id 5b1f17b1804b1-43ab0f64425mr75170455e9.22.1740585637323;
        Wed, 26 Feb 2025 08:00:37 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43aba5393e5sm26113765e9.20.2025.02.26.08.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 08:00:36 -0800 (PST)
Date: Wed, 26 Feb 2025 17:00:33 +0100
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
Message-ID: <20250226170033.5c4687dd@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250226155143.0e4a05f8@imammedo.users.ipa.redhat.com>
References: <cover.1740148260.git.mchehab+huawei@kernel.org>
	<20250226151656.10665bc9@imammedo.users.ipa.redhat.com>
	<20250226153913.27255b1e@sal.lan>
	<20250226155143.0e4a05f8@imammedo.users.ipa.redhat.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 26 Feb 2025 15:51:43 +0100
Igor Mammedov <imammedo@redhat.com> wrote:

> On Wed, 26 Feb 2025 15:39:13 +0100
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
[...]
> 
> PS: do not respin until I've finish this review.

finished

>  
> > >     
> > > > 
> > > > ---
> > > > v4:
> > > > - added an extra comment for AcpiGhesState structure;
> > > > - patches reordered;
> > > > - no functional changes, just code shift between the patches in this series.
> > > > 
> > > > v3:
> > > > - addressed more nits;
> > > > - hest_add_le now points to the beginning of HEST table;
> > > > - removed HEST from tests/data/acpi;
> > > > - added an extra patch to not use fw_cfg with virt-10.0 for hw_error_le
> > > > 
> > > > v2: 
> > > > - address some nits;
> > > > - improved ags cleanup patch and removed ags.present field;
> > > > - added some missing le*_to_cpu() calls;
> > > > - update date at copyright for new files to 2024-2025;
> > > > - qmp command changed to: inject-ghes-v2-error ans since updated to 10.0;
> > > > - added HEST and DSDT tables after the changes to make check target happy.
> > > >   (two patches: first one whitelisting such tables; second one removing from
> > > >    whitelist and updating/adding such tables to tests/data/acpi)
> > > > 
> > > > 
> > > > 
> > > > Mauro Carvalho Chehab (14):
> > > >   acpi/ghes: prepare to change the way HEST offsets are calculated
> > > >   acpi/ghes: add a firmware file with HEST address
> > > >   acpi/ghes: Use HEST table offsets when preparing GHES records
> > > >   acpi/ghes: don't hard-code the number of sources for HEST table
> > > >   acpi/ghes: add a notifier to notify when error data is ready
> > > >   acpi/ghes: create an ancillary acpi_ghes_get_state() function
> > > >   acpi/generic_event_device: Update GHES migration to cover hest addr
> > > >   acpi/generic_event_device: add logic to detect if HEST addr is
> > > >     available
> > > >   acpi/generic_event_device: add an APEI error device
> > > >   tests/acpi: virt: allow acpi table changes for a new table: HEST
> > > >   arm/virt: Wire up a GED error device for ACPI / GHES
> > > >   tests/acpi: virt: add a HEST table to aarch64 virt and update DSDT
> > > >   qapi/acpi-hest: add an interface to do generic CPER error injection
> > > >   scripts/ghes_inject: add a script to generate GHES error inject
> > > > 
> > > >  MAINTAINERS                                   |  10 +
> > > >  hw/acpi/Kconfig                               |   5 +
> > > >  hw/acpi/aml-build.c                           |  10 +
> > > >  hw/acpi/generic_event_device.c                |  43 ++
> > > >  hw/acpi/ghes-stub.c                           |   7 +-
> > > >  hw/acpi/ghes.c                                | 231 ++++--
> > > >  hw/acpi/ghes_cper.c                           |  38 +
> > > >  hw/acpi/ghes_cper_stub.c                      |  19 +
> > > >  hw/acpi/meson.build                           |   2 +
> > > >  hw/arm/virt-acpi-build.c                      |  37 +-
> > > >  hw/arm/virt.c                                 |  19 +-
> > > >  hw/core/machine.c                             |   2 +
> > > >  include/hw/acpi/acpi_dev_interface.h          |   1 +
> > > >  include/hw/acpi/aml-build.h                   |   2 +
> > > >  include/hw/acpi/generic_event_device.h        |   1 +
> > > >  include/hw/acpi/ghes.h                        |  54 +-
> > > >  include/hw/arm/virt.h                         |   2 +
> > > >  qapi/acpi-hest.json                           |  35 +
> > > >  qapi/meson.build                              |   1 +
> > > >  qapi/qapi-schema.json                         |   1 +
> > > >  scripts/arm_processor_error.py                | 476 ++++++++++++
> > > >  scripts/ghes_inject.py                        |  51 ++
> > > >  scripts/qmp_helper.py                         | 702 ++++++++++++++++++
> > > >  target/arm/kvm.c                              |   7 +-
> > > >  tests/data/acpi/aarch64/virt/DSDT             | Bin 5196 -> 5240 bytes
> > > >  .../data/acpi/aarch64/virt/DSDT.acpihmatvirt  | Bin 5282 -> 5326 bytes
> > > >  tests/data/acpi/aarch64/virt/DSDT.memhp       | Bin 6557 -> 6601 bytes
> > > >  tests/data/acpi/aarch64/virt/DSDT.pxb         | Bin 7679 -> 7723 bytes
> > > >  tests/data/acpi/aarch64/virt/DSDT.topology    | Bin 5398 -> 5442 bytes
> > > >  29 files changed, 1677 insertions(+), 79 deletions(-)
> > > >  create mode 100644 hw/acpi/ghes_cper.c
> > > >  create mode 100644 hw/acpi/ghes_cper_stub.c
> > > >  create mode 100644 qapi/acpi-hest.json
> > > >  create mode 100644 scripts/arm_processor_error.py
> > > >  create mode 100755 scripts/ghes_inject.py
> > > >  create mode 100755 scripts/qmp_helper.py
> > > >       
> > >     
> >   
> 


