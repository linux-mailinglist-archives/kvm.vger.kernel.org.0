Return-Path: <kvm+bounces-39575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DE0EA47F48
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 14:37:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 469EE1631B5
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 13:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86F95230272;
	Thu, 27 Feb 2025 13:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bCtOb9Og"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0898521C19C
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 13:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740663036; cv=none; b=Ej38GyZmqH9n8htp8EfLpRpksbXrjT+XPlrYVdnlGZHDsLccBolBT1jFcY8Ex2L2JOBwc5UzQmVtlUaF/WubvOPasBohGRuarvHi189y3/hbnrrpZBMDGH3AJ4mX7YRXcmHTBZieNbieVEssbqVwoZ9x670HcTXxXtOykCSMR0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740663036; c=relaxed/simple;
	bh=DueZqCozERlca+RVkfx9tZTXSZg207xg5AFCIHcPtfw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GtQyTZjq6sgHeLA6n58iSrPUTKuPiiuOonJnJakSNoFeNbt/+WL8VaHYi8AlW5hT/pQn893eKU0ZQpFwv3Kej+0ufRjG7Lfi25Yxw2M4G4JqRl1/SF3uQ7IySknucsK2ykLepwoLA0aoEKmnZCKKexzZzcfCzPy1PzTGCmuelxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bCtOb9Og; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740663033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=10kUSJV4EUd1FzHZvX0wjBLQDNiAVBrIFn/OMdDmjA4=;
	b=bCtOb9OgSGr3G3UV6Ua+x4wHs32tc2b4RXTV/bkuzKMiyYFTFHJ2LmlXtdptxZ8Mp/m6fN
	mnlod70VgHWqVbS29rxPC9Ys9B5zjyhUUloSyM0Ku+ea/N8JdSjhBm7jVQ7DWUikKpw1U3
	cFl2S/kzp/GZh0sFYqLiWEO6Zjy5PKs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-Ivvbc6tsO5GB1Y-fiRJnvw-1; Thu, 27 Feb 2025 08:30:31 -0500
X-MC-Unique: Ivvbc6tsO5GB1Y-fiRJnvw-1
X-Mimecast-MFC-AGG-ID: Ivvbc6tsO5GB1Y-fiRJnvw_1740663030
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-390e8df7ab6so182675f8f.3
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 05:30:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740663030; x=1741267830;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=10kUSJV4EUd1FzHZvX0wjBLQDNiAVBrIFn/OMdDmjA4=;
        b=KiI/vHeumfxlZRjE7Wc/naIRp5p0ux/HiSW8R5iqkeSpm/bwDvcja970hp7msteXd0
         YIbJXTcpKzRd+2NlVJellk64Qxf2bthr3cBfWQZ0ASbvxc+Dgv2m5cQfbCfu1eW8BZI9
         tKX3CKrBxkXqM7BZAG5orMuYCgVw/PSAXi25xY6J+CEQu+jz3hS79nw1/xobpY9OXhga
         nRNIjfazJnXt75TnHjjC2ebdfPVHZqBm5ydTS3d4HN9AqcBapToAP4UDvbrVkjZUU+5A
         iLr6ZflXZpne+dmb24U4afRFPujR5AyIQrIJKFbs3AkdgfwpFFAlzIV7Qoz42vK3ix8w
         Ggkg==
X-Forwarded-Encrypted: i=1; AJvYcCWo3a6X9hjUft6iEgIbTvU1HzVDdPXVz3yBbS+Ae+88veDfdCzZ9cMg4JzMy3DNr++D1Ms=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSGMMgh7UYt4KEehrai2Ia8gNRbFSGl5yeGLvJPZgrrCNJ+Q0f
	PGQIDfduNbgQqK8i21XPRyreAzG72ux4rKHVvqZYH7J4+b6lIX1JwXo1YvIfIHwQmDqNTgvm+ZT
	oiJfCzgn1PS9Jmr/4UDp3xSbCR+7UUvy3bo5v9iW6i5CpnJTfaQ==
X-Gm-Gg: ASbGncvfnOi8PU614xyArjoVXxh6Qw8YI7evqkwweaaoJx4Ipty0cKa5g4rPnoO74sQ
	MS1Y8lLHCh35zDxS7nu0a+bxWxzd8fw6jn2pg/ivkr0PwnBU9ObW/AVybaf9ysXYq8pCiyDhMaG
	AcYnhdz7jMIEvld8/I7GdtmYLkUcCh7ut+NkSQmxvwpVSkzQvuouuSS/tbrwtZiVBzHJbSpYYQr
	+7MvziFYlM/AbSlq8FIcAadi3Efbj3pqVSebz4oFPzBsLnu0yPlo61R2/vuWoFQxH24wcqNu2lN
	LgodTu9i/hUJ4YDWbySr32aml/NwcFxEHUed0gFXQKkhoYKidXdySmM21JMu7l8=
X-Received: by 2002:a05:6000:1a89:b0:390:e9e7:ca70 with SMTP id ffacd0b85a97d-390e9e7cc41mr530498f8f.30.1740663030082;
        Thu, 27 Feb 2025 05:30:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHDkqUxDVICIl2asaXKqIUXiaJsWHY1QefjUZLHDH5yJP2etyBSJVoWL14wXy6Wvs131BU7Sg==
X-Received: by 2002:a05:6000:1a89:b0:390:e9e7:ca70 with SMTP id ffacd0b85a97d-390e9e7cc41mr530476f8f.30.1740663029647;
        Thu, 27 Feb 2025 05:30:29 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e47b7ddesm2094064f8f.57.2025.02.27.05.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 05:30:29 -0800 (PST)
Date: Thu, 27 Feb 2025 14:30:28 +0100
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
Subject: Re: [PATCH v5 00/21]Change ghes to use HEST-based offsets and add
 support for error inject
Message-ID: <20250227143028.22372363@imammedo.users.ipa.redhat.com>
In-Reply-To: <cover.1740653898.git.mchehab+huawei@kernel.org>
References: <cover.1740653898.git.mchehab+huawei@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 27 Feb 2025 12:03:30 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> Now that the ghes preparation patches were merged, let's add support
> for error injection.
> 
> On this version, HEST table got added to ACPI tables testing for aarch64 virt.
> 
> There are also some patch reorder to help reviewers to check the changes.
> 
> The code itself is almost identical to v4, with just a few minor nits addressed.

series still has checkpatch errors 'line over 80' which are not false positive,
it needs to be fixed

> 
> ---
> v5:
> - make checkpatch happier;
> - HEST table is now tested;
> - some changes at HEST spec documentation to align with code changes;
> - extra care was taken with regards to git bisectability.
> 
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
> Mauro Carvalho Chehab (21):
>   tests/acpi: virt: add an empty HEST file
>   tests/qtest/bios-tables-test: extend to also check HEST table
>   tests/acpi: virt: update HEST file with its current data
>   acpi/ghes: Cleanup the code which gets ghes ged state
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
>   tests/acpi: virt: allow acpi table changes at DSDT and HEST tables
>   arm/virt: Wire up a GED error device for ACPI / GHES
>   qapi/acpi-hest: add an interface to do generic CPER error injection
>   tests/acpi: virt: update HEST table to accept two sources
>   tests/acpi: virt: and update DSDT table to add the new GED device
>   docs: hest: add new "etc/acpi_table_hest_addr" and update workflow
>   acpi/generic_event_device.c: enable use_hest_addr for QEMU 10.x
>   scripts/ghes_inject: add a script to generate GHES error inject
> 
>  MAINTAINERS                                   |  10 +
>  docs/specs/acpi_hest_ghes.rst                 |  28 +-
>  hw/acpi/Kconfig                               |   5 +
>  hw/acpi/aml-build.c                           |  10 +
>  hw/acpi/generic_event_device.c                |  43 ++
>  hw/acpi/ghes-stub.c                           |   7 +-
>  hw/acpi/ghes.c                                | 231 ++++--
>  hw/acpi/ghes_cper.c                           |  38 +
>  hw/acpi/ghes_cper_stub.c                      |  19 +
>  hw/acpi/meson.build                           |   2 +
>  hw/arm/virt-acpi-build.c                      |  36 +-
>  hw/arm/virt.c                                 |  19 +-
>  hw/core/machine.c                             |   2 +
>  include/hw/acpi/acpi_dev_interface.h          |   1 +
>  include/hw/acpi/aml-build.h                   |   2 +
>  include/hw/acpi/generic_event_device.h        |   1 +
>  include/hw/acpi/ghes.h                        |  52 +-
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
>  tests/data/acpi/aarch64/virt/HEST             | Bin 0 -> 224 bytes
>  tests/qtest/bios-tables-test.c                |   2 +-
>  32 files changed, 1692 insertions(+), 91 deletions(-)
>  create mode 100644 hw/acpi/ghes_cper.c
>  create mode 100644 hw/acpi/ghes_cper_stub.c
>  create mode 100644 qapi/acpi-hest.json
>  create mode 100644 scripts/arm_processor_error.py
>  create mode 100755 scripts/ghes_inject.py
>  create mode 100755 scripts/qmp_helper.py
>  create mode 100644 tests/data/acpi/aarch64/virt/HEST
> 


