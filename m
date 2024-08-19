Return-Path: <kvm+bounces-24530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D8EE956D13
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 16:21:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2B8A1F25DE6
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 14:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85F0416D4C4;
	Mon, 19 Aug 2024 14:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kym3MM06"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0113816C863
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 14:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724077307; cv=none; b=mIOKhDASqquGgSPZ7nTh0+vqqajGnPX3Ud3ZSRlOGy7jl4smR4KPGrf6nnFupBG+tkiYiK7d1qBnhYxtA8YR8jcQYzJd4kesrsKYZGYlYs5+X+8jowcnDynwlW4YVrcuYFRV2+XS+xNgCwILF+eFBk23lONsGDQ1o+tn3PLF/9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724077307; c=relaxed/simple;
	bh=X6Oum9qUOFOyLXCFWWn44VFU84P/iKZ7Gr4ZKEWYMxg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SSmmSYvhBaMzoIJ5MiocYVluLN2f8h69vgknzHwANMoQAlBWm1ybKn8oWMYP1JbwgFM9yqIxIigzasW3AWjb1sgD+R5CKFgFgKjQMkz56QUrldioSWwVCnjni3Ro1zW4Sr6s0MAnbNGx+ucFw5dYkq4RLBDBL5LNCnFkqAO+TUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kym3MM06; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724077304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sbJ58YvVZ4dzlnRt+qzf9Ta7hAcbIsn3dkKna10OJxE=;
	b=Kym3MM06B5sOIoFC/VkC3w6snDftroA2gSLzIA1OgYNVWtDUGu04TSZn44i0waiVUETy8D
	6dhAWzctT6PIYvt1ef/32mgS/XYhbFAyISyD1HrHTwrrtOGw7la/ppjCXShucZAf7UsFgG
	rmxwMsMu/490AXp+jpHc2fw2EFq71do=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-uXa8Rg-lORmH-bA8PvzESg-1; Mon, 19 Aug 2024 10:21:41 -0400
X-MC-Unique: uXa8Rg-lORmH-bA8PvzESg-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3718bf7d54aso2611841f8f.1
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 07:21:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724077300; x=1724682100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sbJ58YvVZ4dzlnRt+qzf9Ta7hAcbIsn3dkKna10OJxE=;
        b=amUCPF2N3kz4Dy1hgdadNbZKL33RQ9YZPCxYmOs/MkEjB66oksyn0ombecxx/4zEt2
         VPU/nI7iE9nxLCHyWIE8eKGlDyHI5LVYJEZyvpJfWeOLMjEqVyB+ZuezrwXtpiSEK5FH
         8tHzbj6K61pbww5uA194No6F25FLwEWi2Qy8QlobPEzJzEKQjtu4/M1sXbhZcgKBXd9c
         d0ySVdDBv0b58KtyYq4cJZBEowfLN6BFt5fXCpCCX6gzUkW5icAoKh0CQJ95FEEwPBvI
         3tf2BwBYMzrKhFvYGf4sH1ZHt6OWyOA9JTFWVita0wGe03Bo0URizULh6cSBr/Mgz9/S
         RtAA==
X-Forwarded-Encrypted: i=1; AJvYcCXiskkAzO+Yd76i8i5tOt3PlofPGFkK0t+K/RU3xWGgTvFjBxLIDg1EYchBmOl6EKFXe1s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLKiFxLqndzVK4uPnf5lC7YmOpPGzwouIT6cVv4MIq24abvJud
	wwnMoqCOXBUe62GsJCXy55Q2kYLEgqWViAfOL5povCZv74ir8AcaJzC3NxvaUWH4WljNomD3e/l
	yPUkHmObnstNik4yBnHlGaiQKeQwSFWj1FAf5/hXqFLC9FlZ/+w==
X-Received: by 2002:adf:cc8c:0:b0:368:3f60:8725 with SMTP id ffacd0b85a97d-3719468fac0mr5409896f8f.39.1724077299930;
        Mon, 19 Aug 2024 07:21:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFRkNenkG/Yd1MX23P9IfW6QETLMQ6jCAglC3GAfYRJh+TfR+pbxrhdqEe60rPRg0gC1zv+UA==
X-Received: by 2002:adf:cc8c:0:b0:368:3f60:8725 with SMTP id ffacd0b85a97d-3719468fac0mr5409876f8f.39.1724077299359;
        Mon, 19 Aug 2024 07:21:39 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ed6507c4sm113966685e9.15.2024.08.19.07.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2024 07:21:38 -0700 (PDT)
Date: Mon, 19 Aug 2024 16:21:38 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Shiju Jose
 <shiju.jose@huawei.com>, Ani Sinha <anisinha@redhat.com>, Dongjiu Geng
 <gengdongjiu1@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, Peter
 Maydell <peter.maydell@linaro.org>, Shannon Zhao
 <shannon.zhaosl@gmail.com>, kvm@vger.kernel.org, qemu-arm@nongnu.org,
 qemu-devel@nongnu.org
Subject: Re: [PATCH v8 00/13] Add ACPI CPER firmware first error injection
 on ARM emulation
Message-ID: <20240819162138.4dd45330@imammedo.users.ipa.redhat.com>
In-Reply-To: <cover.1723793768.git.mchehab+huawei@kernel.org>
References: <cover.1723793768.git.mchehab+huawei@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 Aug 2024 09:37:32 +0200
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> This series add support for injecting generic CPER records.  Such records
> are generated outside QEMU via a provided script.
> 
> On this version, I added two optional patches at the end:
> - acpi/ghes: cleanup generic error data logic
> 
>   It drops some obvious comments from some already-existing code.
>   As we're already doing lots of changes at the code, it sounded
>   reasonable to me to have such cleanup here;
> 
> - acpi/ghes: check if the BIOS pointers for HEST are correct
> 
>   QEMU has two ways to navigate to a CPER start data: via its
>   memory address or indirectly following 2 BIOS pointers.
>   OS only have the latter one. This patch validates if the BIOS
>   links used by the OS were properly produced, comparing to the
>   actual location of the CPER record.

I went over the series,
once suggestion in 13/13 implemented
we can get rid of pointer math that is reshuffled several times
in patches here.

I'd suggest to structure series as following:
 
  1: patch that adds hest_addr_le
  2: refactoring current code to use address lookup vs pointer math
  3. renaming patches 
  4. patch adding new error source
  5. QAPI patch
  6. python script for error injection

with that in place we probably would need to
  * iron out minor migration compat issues
    (I didn't look for them during this review round as much
     would change yet)
  * make sure that bios tables test is updated

> 
> ---
> 
> v8:
> - Fix one of the BIOS links that were incorrect;
> - Changed mem error internal injection to use a common code;
> - No more hardcoded values for CPER: instead of using just the
>   payload at the QAPI, it now has the full raw CPER there;
> - Error injection script now supports changing fields at the
>   Generic Error Data section of the CPER;
> - Several minor cleanups.
> 
> v7:
> - Change the way offsets are calculated and used on HEST table.
>   Now, it is compatible with migrations as all offsets are relative
>   to the HEST table;
> - GHES interface is now more generic: the entire CPER is sent via
>   QMP, instead of just the payload;
> - Some code cleanups to make the code more robust;
> - The python script now uses QEMUMonitorProtocol class.
> 
> v6:
> - PNP0C33 device creation moved to aml-build.c;
> - acpi_ghes record functions now use ACPI notify parameter,
>   instead of source ID;
> - the number of source IDs is now automatically calculated;
> - some code cleanups and function/var renames;
> - some fixes and cleanups at the error injection script;
> - ghes cper stub now produces an error if cper JSON is not compiled;
> - Offset calculation logic for GHES was refactored;
> - Updated documentation to reflect the GHES allocated size;
> - Added a x-mpidr object for QOM usage;
> - Added a patch making usage of x-mpidr field at ARM injection
>   script;
> 
> v5:
> - CPER guid is now passing as string;
> - raw-data is now passed with base64 encode;
> - Removed several GPIO left-overs from arm/virt.c changes;
> - Lots of cleanups and improvements at the error injection script.
>   It now better handles QMP dialog and doesn't print debug messages.
>   Also, code was split on two modules, to make easier to add more
>   error injection commands.
> 
> v4:
> - CPER generation moved to happen outside QEMU;
> - One patch adding support for mpidr query was removed.
> 
> v3:
> - patch 1 cleanups with some comment changes and adding another place where
>   the poweroff GPIO define should be used. No changes on other patches (except
>   due to conflict resolution).
> 
> v2:
> - added a new patch using a define for GPIO power pin;
> - patch 2 changed to also use a define for generic error GPIO pin;
> - a couple cleanups at patch 2 removing uneeded else clauses.
> 
> Example of generating a CPER record:
> 
> $ scripts/ghes_inject.py -d arm -p 0xdeadbeef
> GUID: e19e3d16-bc11-11e4-9caa-c2051d5d46b0
> Generic Error Status Block (20 bytes):
>       00000000  01 00 00 00 00 00 00 00 00 00 00 00 90 00 00 00   ................
>       00000010  00 00 00 00                                       ....
> 
> Generic Error Data Entry (72 bytes):
>       00000000  16 3d 9e e1 11 bc e4 11 9c aa c2 05 1d 5d 46 b0   .=...........]F.
>       00000010  00 00 00 00 00 03 00 00 48 00 00 00 00 00 00 00   ........H.......
>       00000020  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
>       00000030  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
>       00000040  00 00 00 00 00 00 00 00                           ........
> 
> Payload (72 bytes):
>       00000000  05 00 00 00 01 00 00 00 48 00 00 00 00 00 00 00   ........H.......
>       00000010  00 00 00 80 00 00 00 00 10 05 0f 00 00 00 00 00   ................
>       00000020  00 00 00 00 00 00 00 00 00 20 14 00 02 01 00 03   ......... ......
>       00000030  0f 00 91 00 00 00 00 00 ef be ad de 00 00 00 00   ................
>       00000040  ef be ad de 00 00 00 00                           ........
> 
> Error injected.
> 
> [    9.358364] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
> [    9.359027] {1}[Hardware Error]: event severity: recoverable
> [    9.359586] {1}[Hardware Error]:  Error 0, type: recoverable
> [    9.360124] {1}[Hardware Error]:   section_type: ARM processor error
> [    9.360561] {1}[Hardware Error]:   MIDR: 0x00000000000f0510
> [    9.361160] {1}[Hardware Error]:   Multiprocessor Affinity Register (MPIDR): 0x0000000080000000
> [    9.361643] {1}[Hardware Error]:   running state: 0x0
> [    9.362142] {1}[Hardware Error]:   Power State Coordination Interface state: 0
> [    9.362682] {1}[Hardware Error]:   Error info structure 0:
> [    9.363030] {1}[Hardware Error]:   num errors: 2
> [    9.363656] {1}[Hardware Error]:    error_type: 0x02: cache error
> [    9.364163] {1}[Hardware Error]:    error_info: 0x000000000091000f
> [    9.364834] {1}[Hardware Error]:     transaction type: Data Access
> [    9.365599] {1}[Hardware Error]:     cache error, operation type: Data write
> [    9.366441] {1}[Hardware Error]:     cache level: 2
> [    9.367005] {1}[Hardware Error]:     processor context not corrupted
> [    9.367753] {1}[Hardware Error]:    physical fault address: 0x00000000deadbeef
> [    9.374267] Memory failure: 0xdeadb: recovery action for free buddy page: Recovered
> 
> Such script currently supports arm processor error CPER, but can easily be
> extended to other GHES notification types.
> 
> 
> 
> Jonathan Cameron (1):
>   acpi/ghes: Add support for GED error device
> 
> Mauro Carvalho Chehab (12):
>   acpi/generic_event_device: add an APEI error device
>   arm/virt: Wire up a GED error device for ACPI / GHES
>   qapi/acpi-hest: add an interface to do generic CPER error injection
>   acpi/ghes: rework the logic to handle HEST source ID
>   acpi/ghes: add support for generic error injection via QAPI
>   acpi/ghes: cleanup the memory error code logic
>   docs: acpi_hest_ghes: fix documentation for CPER size
>   scripts/ghes_inject: add a script to generate GHES error inject
>   target/arm: add an experimental mpidr arm cpu property object
>   scripts/arm_processor_error.py: retrieve mpidr if not filled
>   acpi/ghes: cleanup generic error data logic
>   acpi/ghes: check if the BIOS pointers for HEST are correct
> 
>  MAINTAINERS                            |  10 +
>  docs/specs/acpi_hest_ghes.rst          |   6 +-
>  hw/acpi/Kconfig                        |   5 +
>  hw/acpi/aml-build.c                    |  10 +
>  hw/acpi/generic_event_device.c         |   8 +
>  hw/acpi/ghes-stub.c                    |   3 +-
>  hw/acpi/ghes.c                         | 362 ++++++++-----
>  hw/acpi/ghes_cper.c                    |  33 ++
>  hw/acpi/ghes_cper_stub.c               |  19 +
>  hw/acpi/meson.build                    |   2 +
>  hw/arm/Kconfig                         |   5 +
>  hw/arm/virt-acpi-build.c               |   6 +-
>  hw/arm/virt.c                          |  12 +-
>  include/hw/acpi/acpi_dev_interface.h   |   1 +
>  include/hw/acpi/aml-build.h            |   2 +
>  include/hw/acpi/generic_event_device.h |   1 +
>  include/hw/acpi/ghes.h                 |  24 +-
>  include/hw/arm/virt.h                  |   1 +
>  qapi/acpi-hest.json                    |  36 ++
>  qapi/meson.build                       |   1 +
>  qapi/qapi-schema.json                  |   1 +
>  scripts/arm_processor_error.py         | 388 ++++++++++++++
>  scripts/ghes_inject.py                 |  51 ++
>  scripts/qmp_helper.py                  | 702 +++++++++++++++++++++++++
>  target/arm/cpu.c                       |   1 +
>  target/arm/cpu.h                       |   1 +
>  target/arm/helper.c                    |  10 +-
>  target/arm/kvm.c                       |   2 +-
>  28 files changed, 1551 insertions(+), 152 deletions(-)
>  create mode 100644 hw/acpi/ghes_cper.c
>  create mode 100644 hw/acpi/ghes_cper_stub.c
>  create mode 100644 qapi/acpi-hest.json
>  create mode 100644 scripts/arm_processor_error.py
>  create mode 100755 scripts/ghes_inject.py
>  create mode 100644 scripts/qmp_helper.py
> 


