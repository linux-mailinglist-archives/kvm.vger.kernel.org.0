Return-Path: <kvm+bounces-39563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 71CC3A47B5D
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 12:09:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22A6F1891953
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 11:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A85622B8C5;
	Thu, 27 Feb 2025 11:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pq91ovwN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B6F22B8BE;
	Thu, 27 Feb 2025 11:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740654332; cv=none; b=lgRKdFsxxJsLxw6E+LgH/UiJekVIulHV2k4DN+oiXe6hlaWQ3/HNFRE5g7kamA6o7ly5NrnGAUHTlVZ3EwIpE5uIBLz/ameu5AA75Z3SwD/78Vp0CfiI8zLd4ee98l5toUVhzNIIj2RhL7s5SCLucMwFtmxh8N4PpxPdusoPass=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740654332; c=relaxed/simple;
	bh=30VEPafuYaXUOzx4ugW+Q9XaK63O/Un27g6xe0Hutbk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S8v3szjo6BXqqwsdRipra1Fn7qmwl0BxawV6N8flzaM4cDB/hNbxvgyApbwzM8fHsjKNwpNxEISp7PYkFO8H5C3v6LORM110Dt0vTZgWRO8EtnvwEbCUMyG6wZe04lJPKxUS0KPrz6Hn5AICTdlyogqE2UZitXObWjSLk9FbztM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pq91ovwN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8F1C4CEDD;
	Thu, 27 Feb 2025 11:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740654332;
	bh=30VEPafuYaXUOzx4ugW+Q9XaK63O/Un27g6xe0Hutbk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Pq91ovwNVBny9JMf8+HSNMd53hixAs09BNZdZs5+XZvukQo19RDYmaAYsKuKnRqbO
	 6qo83flXm7EcwbmofLf+K/qhsk3B2bAqdNTMyY/WKXRgvC0HaoCsudv+HdBkrxGgIy
	 W4UCV9K8pWXY1D6xpT48SrVORm8c4TjrcMZJLrS0G06NvYq+PWtK/eobNmfWXSBSh/
	 CVsZJQvI+myXNB+tNggscbw4QICP4mKpEB9mI3ofP3VY4nQvRUr5s9XHr7OZbBwiCw
	 Ng8h4v4zAUUE26KyhVo+9/xOxpgQphhwKFZmhAOYf68HoY/Kn1nPA1H87h4vqpLuKN
	 BwGFkzU7lAAHg==
Date: Thu, 27 Feb 2025 12:05:25 +0100
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>
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
Message-ID: <20250227120525.66c348a0@foz.lan>
In-Reply-To: <20250227105454.69e3d459@imammedo.users.ipa.redhat.com>
References: <cover.1740148260.git.mchehab+huawei@kernel.org>
	<20250227105454.69e3d459@imammedo.users.ipa.redhat.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Em Thu, 27 Feb 2025 10:54:54 +0100
Igor Mammedov <imammedo@redhat.com> escreveu:

> On Fri, 21 Feb 2025 15:35:09 +0100
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
> 
> > Now that the ghes preparation patches were merged, let's add support
> > for error injection.
> > 
> > On this series, the first 6 patches chang to the math used to calculate offsets at HEST
> > table and hardware_error firmware file, together with its migration code. Migration tested
> > with both latest QEMU released kernel and upstream, on both directions.
> > 
> > The next patches add a new QAPI to allow injecting GHESv2 errors, and a script using such QAPI
> >    to inject ARM Processor Error records.
> > 
> > ---
> > v4:
> > - added an extra comment for AcpiGhesState structure;
> > - patches reordered;
> > - no functional changes, just code shift between the patches in this series.
> > 
> > v3:
> > - addressed more nits;
> > - hest_add_le now points to the beginning of HEST table;
> > - removed HEST from tests/data/acpi;
> > - added an extra patch to not use fw_cfg with virt-10.0 for hw_error_le
> > 
> > v2: 
> > - address some nits;
> > - improved ags cleanup patch and removed ags.present field;
> > - added some missing le*_to_cpu() calls;
> > - update date at copyright for new files to 2024-2025;
> > - qmp command changed to: inject-ghes-v2-error ans since updated to 10.0;
> > - added HEST and DSDT tables after the changes to make check target happy.
> >   (two patches: first one whitelisting such tables; second one removing from
> >    whitelist and updating/adding such tables to tests/data/acpi)
> > 
> > 
> > 
> > Mauro Carvalho Chehab (14):
> >   acpi/ghes: prepare to change the way HEST offsets are calculated
> >   acpi/ghes: add a firmware file with HEST address
> >   acpi/ghes: Use HEST table offsets when preparing GHES records
> >   acpi/ghes: don't hard-code the number of sources for HEST table
> >   acpi/ghes: add a notifier to notify when error data is ready
> >   acpi/ghes: create an ancillary acpi_ghes_get_state() function
> >   acpi/generic_event_device: Update GHES migration to cover hest addr
> >   acpi/generic_event_device: add logic to detect if HEST addr is
> >     available
> >   acpi/generic_event_device: add an APEI error device
> >   tests/acpi: virt: allow acpi table changes for a new table: HEST
> >   arm/virt: Wire up a GED error device for ACPI / GHES
> >   tests/acpi: virt: add a HEST table to aarch64 virt and update DSDT
> >   qapi/acpi-hest: add an interface to do generic CPER error injection
> >   scripts/ghes_inject: add a script to generate GHES error inject
> > 
> >  MAINTAINERS                                   |  10 +
> >  hw/acpi/Kconfig                               |   5 +
> >  hw/acpi/aml-build.c                           |  10 +
> >  hw/acpi/generic_event_device.c                |  43 ++
> >  hw/acpi/ghes-stub.c                           |   7 +-
> >  hw/acpi/ghes.c                                | 231 ++++--
> >  hw/acpi/ghes_cper.c                           |  38 +
> >  hw/acpi/ghes_cper_stub.c                      |  19 +
> >  hw/acpi/meson.build                           |   2 +
> >  hw/arm/virt-acpi-build.c                      |  37 +-
> >  hw/arm/virt.c                                 |  19 +-
> >  hw/core/machine.c                             |   2 +
> >  include/hw/acpi/acpi_dev_interface.h          |   1 +
> >  include/hw/acpi/aml-build.h                   |   2 +
> >  include/hw/acpi/generic_event_device.h        |   1 +
> >  include/hw/acpi/ghes.h                        |  54 +-
> >  include/hw/arm/virt.h                         |   2 +
> >  qapi/acpi-hest.json                           |  35 +
> >  qapi/meson.build                              |   1 +
> >  qapi/qapi-schema.json                         |   1 +
> >  scripts/arm_processor_error.py                | 476 ++++++++++++
> >  scripts/ghes_inject.py                        |  51 ++
> >  scripts/qmp_helper.py                         | 702 ++++++++++++++++++
> >  target/arm/kvm.c                              |   7 +-
> >  tests/data/acpi/aarch64/virt/DSDT             | Bin 5196 -> 5240 bytes
> >  .../data/acpi/aarch64/virt/DSDT.acpihmatvirt  | Bin 5282 -> 5326 bytes
> >  tests/data/acpi/aarch64/virt/DSDT.memhp       | Bin 6557 -> 6601 bytes
> >  tests/data/acpi/aarch64/virt/DSDT.pxb         | Bin 7679 -> 7723 bytes
> >  tests/data/acpi/aarch64/virt/DSDT.topology    | Bin 5398 -> 5442 bytes
> >  29 files changed, 1677 insertions(+), 79 deletions(-)
> >  create mode 100644 hw/acpi/ghes_cper.c
> >  create mode 100644 hw/acpi/ghes_cper_stub.c
> >  create mode 100644 qapi/acpi-hest.json
> >  create mode 100644 scripts/arm_processor_error.py
> >  create mode 100755 scripts/ghes_inject.py
> >  create mode 100755 scripts/qmp_helper.py
> >   
> 
> once you enable, ras in tests as 1st patches and fixup minor issues
> please try to do patch by patch compile/bios-tables-test testing, to avoid
> unnecessary respin in case at table change crept in somewhere unnoticed. 

Just submitted v5.

I took some extra care to avoid bisect issues. Still checkpatch 
had some warnings, but they seemed false positives.

Thanks,
Mauro

