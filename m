Return-Path: <kvm+bounces-39293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B101DA463C9
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 15:53:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DB1C189EF33
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 14:52:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 659CD2222D3;
	Wed, 26 Feb 2025 14:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VQ2z5qo8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF141221712
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 14:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740581512; cv=none; b=KwS8J8mDndl6QZbuV/m14dkY/Uy/38ySwmqkJ8WYHB8GSQ+q8cvr3Th3h+KCJWvf6JD5xNJYSCu9Muo+8l+rI8uxdeBDOYeQNMQNvuoUt1b5cX2ptqfYHduZFqyRTcfzYmPRtMc078KgN8gW8J2kkJy74VAfaYLNs7F5i/zi918=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740581512; c=relaxed/simple;
	bh=wCEwsl2V3nnnJWdvvQYSH2hUeveA9ELhAK1ybqU2HVE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OXSeYCdSIVtGNSPfV3uX84CLZAi7opZAtwBxbOUr5rheYSEa4a6SSmOFuZ0KquJsrxjrOxQS2Da3wWSdLvfcyLvdTSJLgQkuyy+5glyTk2eJEL02YYfqWMpKDJOrZfjPfJjeZj6K8qzXwo/HgQjKRf5ltjqND7717yl+eErsRaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VQ2z5qo8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740581510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hjDcNMS3m2KvFYfCArjaQPKsyojcR0O9nS1Ii1LdD30=;
	b=VQ2z5qo8MpAHDiYnZvcwzxH/uguOzDLS+uXrVwGYdc8g8+BaCTQBrqQiUn2aScozsh+rmB
	HCLUkLfRUuLKZyIVoOH14Hfe3iXo4ae8paOtXlge1GbgssTK60EbylGRRehFlKKpufef/d
	8Gu7AxVNXL1MhCB3KTv/XymYymZ2hzQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-Y7txK6JVNRmmau1_DwJjQA-1; Wed, 26 Feb 2025 09:51:46 -0500
X-MC-Unique: Y7txK6JVNRmmau1_DwJjQA-1
X-Mimecast-MFC-AGG-ID: Y7txK6JVNRmmau1_DwJjQA_1740581506
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-438e180821aso35148785e9.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 06:51:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740581505; x=1741186305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hjDcNMS3m2KvFYfCArjaQPKsyojcR0O9nS1Ii1LdD30=;
        b=DCU/iAgaiB7KB2YgQtUvJjf8QvnOTVXfxEwaDLzjwD91jWGSJY7gz+gg9HDeNy0oly
         iHCh8uutQe4fLTfj32kaBN/XkUNuN0CSad6fRI+BfzSRg4SX3lCcOcx3W9rYcrFUM9xF
         beoJXC8kdxU6ktAKiLwIdEsmAhfFiH9VY4yIemo9gPjfxXZr2msRlOmpiZq99qTAvovo
         K9etS9UkYrdIaIuZSAqKLDyezQzAnSSjbPmW1hVZXSZOf+/21fPbWnCSts812lfi5eRQ
         qUquWPDaNRKUQCL8udwrCVUDP2tGy0npMN16vtWNgtlieVR8I0S8sUkm0ehncITn1a8n
         drFg==
X-Forwarded-Encrypted: i=1; AJvYcCVltpPqyKHk+9a0o6hQOpAzJNTwOY57OLacGp+b2ALd85H1JWMjqi1in3JM6oHNRenjOQU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVgY1xVliBHBfEa5ltg6cLmdHuXXgbZ+yAru7aeeTHEHjoloa0
	2c9w+FNp9J6gYdsRYwjKLpZJEDW95q2+aqu9PxYIOjQ5DlPZ/L0/eqneEfcX/rSmDlHTr1a4Imz
	hK0KelpU89MFeYZYpImoFbbrMCMkcy9REOHwHIdovM8aYUKkaXw==
X-Gm-Gg: ASbGncvoxujFS+N1m1dm1Ee0UztzGz9UoeGIe02fqRkEuOULy0y/Z1o7OU7JxsFmUCd
	so47hXReIU8E5TtsK+dKlsCn4tys39piv8RauTndAtGezhQ2FnzH1pSEnYni6WxqqjsytX1GH+k
	CJB23v139lXm7rpITkOmETen/Ojilbt0E6ZUOnSTODTfevz3habt4eUDX5reuU6unpwKW5V8aSq
	VxuDqR2aUvD3hdVugjDM0ncdMUWaOrV080TERTdrkC1koWDrVUDV0rJVU9KIQpMolGjRkcL/qJP
	4h2JH0j2cIyZA9b6gNyJSFBK2UmPS7m7HdAObJiWZ2jhugKsEvuj98cNa4OODEA=
X-Received: by 2002:a05:600c:4588:b0:439:88bb:d020 with SMTP id 5b1f17b1804b1-43ab0f2dcb1mr60884535e9.8.1740581505535;
        Wed, 26 Feb 2025 06:51:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGKa94atTc56+cD/Ww+Jgaq2nnB0Xu5jKGJ9ryPYaz3eiHumwOvBEgn93E/1uEp4aCSOrKpVQ==
X-Received: by 2002:a05:600c:4588:b0:439:88bb:d020 with SMTP id 5b1f17b1804b1-43ab0f2dcb1mr60884275e9.8.1740581505080;
        Wed, 26 Feb 2025 06:51:45 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390cd8e71c0sm5790989f8f.78.2025.02.26.06.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 06:51:44 -0800 (PST)
Date: Wed, 26 Feb 2025 15:51:43 +0100
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
Message-ID: <20250226155143.0e4a05f8@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250226153913.27255b1e@sal.lan>
References: <cover.1740148260.git.mchehab+huawei@kernel.org>
	<20250226151656.10665bc9@imammedo.users.ipa.redhat.com>
	<20250226153913.27255b1e@sal.lan>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 26 Feb 2025 15:39:13 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> Em Wed, 26 Feb 2025 15:16:56 +0100
> Igor Mammedov <imammedo@redhat.com> escreveu:
> 
> > On Fri, 21 Feb 2025 15:35:09 +0100
> > Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
> >   
> > > Now that the ghes preparation patches were merged, let's add support
> > > for error injection.
> > > 
> > > On this series, the first 6 patches chang to the math used to calculate offsets at HEST
> > > table and hardware_error firmware file, together with its migration code. Migration tested
> > > with both latest QEMU released kernel and upstream, on both directions.
> > > 
> > > The next patches add a new QAPI to allow injecting GHESv2 errors, and a script using such QAPI
> > >    to inject ARM Processor Error records.    
> > 
> > please, run ./scripts/checkpatch on patches before submitting them.
> > as it stands now series cannot be merged due to failing checkpatch  
> 
> Weird... checkpatch is at pre-commit hook, as recommended at QEMU 
> documentation. It is actually a little harder to manage this way, as it 
> sometimes cause troubles with binary files.
> 
> Anyway, I'll run it by hand before sending the next version.

I've just applied v4 => format-patch => checkpatch
maybe I did something wrong (don't see how) but it complains overhere


PS: do not respin until I've finish this review.
 
> >   
> > > 
> > > ---
> > > v4:
> > > - added an extra comment for AcpiGhesState structure;
> > > - patches reordered;
> > > - no functional changes, just code shift between the patches in this series.
> > > 
> > > v3:
> > > - addressed more nits;
> > > - hest_add_le now points to the beginning of HEST table;
> > > - removed HEST from tests/data/acpi;
> > > - added an extra patch to not use fw_cfg with virt-10.0 for hw_error_le
> > > 
> > > v2: 
> > > - address some nits;
> > > - improved ags cleanup patch and removed ags.present field;
> > > - added some missing le*_to_cpu() calls;
> > > - update date at copyright for new files to 2024-2025;
> > > - qmp command changed to: inject-ghes-v2-error ans since updated to 10.0;
> > > - added HEST and DSDT tables after the changes to make check target happy.
> > >   (two patches: first one whitelisting such tables; second one removing from
> > >    whitelist and updating/adding such tables to tests/data/acpi)
> > > 
> > > 
> > > 
> > > Mauro Carvalho Chehab (14):
> > >   acpi/ghes: prepare to change the way HEST offsets are calculated
> > >   acpi/ghes: add a firmware file with HEST address
> > >   acpi/ghes: Use HEST table offsets when preparing GHES records
> > >   acpi/ghes: don't hard-code the number of sources for HEST table
> > >   acpi/ghes: add a notifier to notify when error data is ready
> > >   acpi/ghes: create an ancillary acpi_ghes_get_state() function
> > >   acpi/generic_event_device: Update GHES migration to cover hest addr
> > >   acpi/generic_event_device: add logic to detect if HEST addr is
> > >     available
> > >   acpi/generic_event_device: add an APEI error device
> > >   tests/acpi: virt: allow acpi table changes for a new table: HEST
> > >   arm/virt: Wire up a GED error device for ACPI / GHES
> > >   tests/acpi: virt: add a HEST table to aarch64 virt and update DSDT
> > >   qapi/acpi-hest: add an interface to do generic CPER error injection
> > >   scripts/ghes_inject: add a script to generate GHES error inject
> > > 
> > >  MAINTAINERS                                   |  10 +
> > >  hw/acpi/Kconfig                               |   5 +
> > >  hw/acpi/aml-build.c                           |  10 +
> > >  hw/acpi/generic_event_device.c                |  43 ++
> > >  hw/acpi/ghes-stub.c                           |   7 +-
> > >  hw/acpi/ghes.c                                | 231 ++++--
> > >  hw/acpi/ghes_cper.c                           |  38 +
> > >  hw/acpi/ghes_cper_stub.c                      |  19 +
> > >  hw/acpi/meson.build                           |   2 +
> > >  hw/arm/virt-acpi-build.c                      |  37 +-
> > >  hw/arm/virt.c                                 |  19 +-
> > >  hw/core/machine.c                             |   2 +
> > >  include/hw/acpi/acpi_dev_interface.h          |   1 +
> > >  include/hw/acpi/aml-build.h                   |   2 +
> > >  include/hw/acpi/generic_event_device.h        |   1 +
> > >  include/hw/acpi/ghes.h                        |  54 +-
> > >  include/hw/arm/virt.h                         |   2 +
> > >  qapi/acpi-hest.json                           |  35 +
> > >  qapi/meson.build                              |   1 +
> > >  qapi/qapi-schema.json                         |   1 +
> > >  scripts/arm_processor_error.py                | 476 ++++++++++++
> > >  scripts/ghes_inject.py                        |  51 ++
> > >  scripts/qmp_helper.py                         | 702 ++++++++++++++++++
> > >  target/arm/kvm.c                              |   7 +-
> > >  tests/data/acpi/aarch64/virt/DSDT             | Bin 5196 -> 5240 bytes
> > >  .../data/acpi/aarch64/virt/DSDT.acpihmatvirt  | Bin 5282 -> 5326 bytes
> > >  tests/data/acpi/aarch64/virt/DSDT.memhp       | Bin 6557 -> 6601 bytes
> > >  tests/data/acpi/aarch64/virt/DSDT.pxb         | Bin 7679 -> 7723 bytes
> > >  tests/data/acpi/aarch64/virt/DSDT.topology    | Bin 5398 -> 5442 bytes
> > >  29 files changed, 1677 insertions(+), 79 deletions(-)
> > >  create mode 100644 hw/acpi/ghes_cper.c
> > >  create mode 100644 hw/acpi/ghes_cper_stub.c
> > >  create mode 100644 qapi/acpi-hest.json
> > >  create mode 100644 scripts/arm_processor_error.py
> > >  create mode 100755 scripts/ghes_inject.py
> > >  create mode 100755 scripts/qmp_helper.py
> > >     
> >   
> 


