Return-Path: <kvm+bounces-52529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4124DB0653A
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 19:36:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7ACB616568B
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 17:36:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4574C2857FC;
	Tue, 15 Jul 2025 17:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gzg3rQiD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD7A1CDFAC
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 17:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752600999; cv=none; b=sCy0aEszsbOb8N3ni18mrhu5vkdx0ENhh5W8j5RDwz3pzCSD+bzmOHXIaShj2Dkir4cQ/AWpEhvkN9YDofBDXEJJogT+X88Yzfx+xP52ds999agA2ZLA/5SEiQgxHs4eCfc9BPFHEPT5Jhps42rETSfJXmdMfGlcpSP1/Hu6VeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752600999; c=relaxed/simple;
	bh=CqQ5em+WgBFxdg4h5IJYD913JlF36prRZebysi0Th/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XxVj5EuUI1b5remFaUA81EN5IF4ElX8lFiDz4wo5acUoCT/2C0oKhSTtuyvcUBHUephDonFHCL7HiPjNZJIRTQ7drcczdBPcgNeh6xPsXQcb7eYLWZiKaK6V2iubP96XnRs9QSxH/YFOCs1t/49Urv/rF8J88VskKjZlkqbEeEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gzg3rQiD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752600996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=day658YKIQbW8r75aOdYjZTSiajvic/kfG8T2N/ZV/k=;
	b=gzg3rQiDBZ8zwWLr/a3PRGLCO/aPdr+sYoS26mcXGapluEKpsVeUGgCNfh0i5Jvo75spdi
	/HkqNfmB6OKqT4ov5AHUJ5ifxEW3b2aUqoeOT8p1WOiAQoNSyz+SdvIcoyDMf7qgH3lrqq
	SbUXRm3jjhIndU5dEItrQP4ev/jAKrY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-538-Da5qL3L6N-2FzGlRWoUghA-1; Tue, 15 Jul 2025 13:36:32 -0400
X-MC-Unique: Da5qL3L6N-2FzGlRWoUghA-1
X-Mimecast-MFC-AGG-ID: Da5qL3L6N-2FzGlRWoUghA_1752600991
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-455ea9cb0beso34415015e9.0
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 10:36:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752600991; x=1753205791;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=day658YKIQbW8r75aOdYjZTSiajvic/kfG8T2N/ZV/k=;
        b=bptk26SHLiLj/LqOd7Ul2GBR9X4TpY3RcVS/zO3Jc0lh+cqaPXk3w6JhHI5td5RQ9A
         pRrLcifJQF8Iav+RLgsyTF90vMRvMK8cXe2ZW+TZmoV8XzwFpavK3RdSLqKQahx3fqy8
         iay2Vej9w/rov0WvyHnXzmkTh4EF/3a9YcTnmThnPWD5BW5/OBIosL4tBlBes1hWYq1S
         K816W4pCnQVEhZaAlER4fuw8v2G4ZjlrZa6azYK7dz2gEpqJ3DKT03huyBAF124FOG7l
         dAPAYUDmk6TWaAaO0nMkkiPAtqUwP7ATb7RyoSvGyNEIpBjAfm1TuaWwq9XYvtcG5AAx
         dywA==
X-Forwarded-Encrypted: i=1; AJvYcCUYDlJAy2LHZ8PxyjmwiN8aK+7mHvTWjValSj7wjbjmBYdrij/JDBNjAoFPP5KBF7K4K2s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzm/m5v4el16iMdyXaBbGH/mviJrheOAe4GqWTW94I/XCqvxY1U
	2NC73eJKNW/eRxpL984vbC/MKffdXHstpFR/3N0Sk9BEsY6RhE9JMoUGA1+WDZ4pETgI7pPre3B
	HSw8k50mYuye/NzjIdJwRHk1rTAZcVhakzxaLDXd20lcFhNYJeR0zzg==
X-Gm-Gg: ASbGncvDab58+Nca+fCzZ2MvYogEvc86R4pAKH5g+nKWezeznwjnKv5B7spQ4dnYTgn
	fS0NYhagq+Y0w2Xanz4VYmUzbr6ZvdebWzej48erIeg0uCdMwhrop/aQtO3NMluGKyJ0IR89/qW
	9xvqTH/4SkwQZ28ixHOthMP5MDX0iF6HaSS2Jm/i5mt7VJjtsjFUcFfVJF1uuT0qvPDx73LkXeY
	Ld7EHpvbB2ssxUvES5G8VYq6V8wT6tg/GsRX35U9HCZKNLxkok/7vFJUXUIDu/haD1aZz8t6Xpj
	3DCnvxwgmYncH2yY2zrevi/OPugbxIPu
X-Received: by 2002:a05:600c:1e8a:b0:456:18ca:68db with SMTP id 5b1f17b1804b1-45618ca6fbcmr88881535e9.8.1752600991245;
        Tue, 15 Jul 2025 10:36:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF16b3YOx+Ogh7UeyDcMz2z8ZoA+/bnGN8dm1xA14v40A4+mY6qroqciY4O+dckrPLW3UsPBA==
X-Received: by 2002:a05:600c:1e8a:b0:456:18ca:68db with SMTP id 5b1f17b1804b1-45618ca6fbcmr88881085e9.8.1752600990658;
        Tue, 15 Jul 2025 10:36:30 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:150d:fc00:de3:4725:47c6:6809])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45624651a09sm36942335e9.12.2025.07.15.10.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jul 2025 10:36:30 -0700 (PDT)
Date: Tue, 15 Jul 2025 13:36:26 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Igor Mammedov <imammedo@redhat.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Shiju Jose <shiju.jose@huawei.com>, qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Dongjiu Geng <gengdongjiu1@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>, Zhao Liu <zhao1.liu@intel.com>,
	kvm@vger.kernel.org, Cleber Rosa <crosa@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Eric Blake <eblake@redhat.com>, John Snow <jsnow@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Markus Armbruster <armbru@redhat.com>,
	Michael Roth <michael.roth@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 (RESEND) 00/20] Change ghes to use HEST-based offsets
 and add support for error inject
Message-ID: <20250715133423-mutt-send-email-mst@kernel.org>
References: <cover.1749741085.git.mchehab+huawei@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1749741085.git.mchehab+huawei@kernel.org>

On Thu, Jun 12, 2025 at 05:17:24PM +0200, Mauro Carvalho Chehab wrote:
> Hi Michael,
> 
> This is v10 of the patch series, rebased to apply after release
> 10.0. The only difference against v9 is a minor confict resolution.

Unfortunately, this needs a rebase on top of latest PCIHP
changes in my tree.  The changes are non trivial, too.
I should have let you know more early, sorry :(


> I sent already the patch with conflicts, but, as you didn't pick,
> I'm assuming you're opting to see the entire series again, as it
> could make easier for you to use b4 or some other script you may
> use to pick patches. So, let me resend the entire series.
> 
> It is nearly identical to v9 which addressed 3 issues:
> 
> - backward compatibility logic moved to version 10.0;
> - fixed a compilation issue with target/arm/kvm.c (probably
>   caused by some rebase - funny enough, incremental 
>   compilation was fine here);
> - added two missing SPDX comments.
> 
> As ghes_record_cper_errors() was written since the beginning
> to be public and used by ghes-cper.c. It ended being meged
> earlier because the error-injection series become too big,
> so it was decided last year to split in two to make easier for
> reviewers and maintainers to discuss.
> 
> This series change the way HEST table offsets are calculated,
> making them identical to what an OSPM would do and allowing
> multiple HEST entries without causing migration issues. It open
> space to add HEST support for non-arm architectures, as now
> the number and type of HEST notification entries are not
> hardcoded at ghes.c. Instead, they're passed as a parameter
> from the arch-dependent init code.
> 
> With such issue addressed, it adds a new notification type and
> add support to inject errors via a Python script. The script
> itself is at the final patch.
> 
> ---
> 
> v10:
> - rebased on the top of current upstream:
>   d9ce74873a6a ("Merge tag 'pull-vfio-20250611' of https://github.com/legoater/qemu into staging")
> - solved a minor conflict
> 
> v9:
> - backward compatibility logic moved to version 10.0;
> - fixed a compilation issue with target/arm/kvm.c (probably
>   caused by some rebase - funny enough, incremental 
>   compilation was fine here);
> - added two missing SPDX comments.
> 
> v8:
>   - added a patch to revert recently-added changeset causing a
>     conflict with these. All remaining patches are identical.
> 
> v7:
>   - minor editorial change at the patch updating HEST doc spec
>    with the new workflow
> 
> v6:
> - some minor nits addressed:
>    - use GPA instead of offset;
>    - merged two patches;
>    - fixed a couple of long line coding style issues;
>    - the HEST/DSDT diff inside a patch was changed to avoid troubles
>      applying it.
> 
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
> Mauro Carvalho Chehab (20):
>   tests/acpi: virt: add an empty HEST file
>   tests/qtest/bios-tables-test: extend to also check HEST table
>   tests/acpi: virt: update HEST file with its current data
>   Revert "hw/acpi/ghes: Make ghes_record_cper_errors() static"
>   acpi/ghes: Cleanup the code which gets ghes ged state
>   acpi/ghes: prepare to change the way HEST offsets are calculated
>   acpi/ghes: add a firmware file with HEST address
>   acpi/ghes: Use HEST table offsets when preparing GHES records
>   acpi/ghes: don't hard-code the number of sources for HEST table
>   acpi/ghes: add a notifier to notify when error data is ready
>   acpi/generic_event_device: Update GHES migration to cover hest addr
>   acpi/generic_event_device: add logic to detect if HEST addr is
>     available
>   acpi/generic_event_device: add an APEI error device
>   tests/acpi: virt: allow acpi table changes at DSDT and HEST tables
>   arm/virt: Wire up a GED error device for ACPI / GHES
>   qapi/acpi-hest: add an interface to do generic CPER error injection
>   acpi/generic_event_device.c: enable use_hest_addr for QEMU 10.x
>   tests/acpi: virt: update HEST and DSDT tables
>   docs: hest: add new "etc/acpi_table_hest_addr" and update workflow
>   scripts/ghes_inject: add a script to generate GHES error inject
> 
>  MAINTAINERS                                   |  10 +
>  docs/specs/acpi_hest_ghes.rst                 |  28 +-
>  hw/acpi/Kconfig                               |   5 +
>  hw/acpi/aml-build.c                           |  10 +
>  hw/acpi/generic_event_device.c                |  44 ++
>  hw/acpi/ghes-stub.c                           |   7 +-
>  hw/acpi/ghes.c                                | 233 ++++--
>  hw/acpi/ghes_cper.c                           |  39 +
>  hw/acpi/ghes_cper_stub.c                      |  20 +
>  hw/acpi/meson.build                           |   2 +
>  hw/arm/virt-acpi-build.c                      |  35 +-
>  hw/arm/virt.c                                 |  19 +-
>  hw/core/machine.c                             |   2 +
>  include/hw/acpi/acpi_dev_interface.h          |   1 +
>  include/hw/acpi/aml-build.h                   |   2 +
>  include/hw/acpi/generic_event_device.h        |   1 +
>  include/hw/acpi/ghes.h                        |  51 +-
>  include/hw/arm/virt.h                         |   2 +
>  qapi/acpi-hest.json                           |  35 +
>  qapi/meson.build                              |   1 +
>  qapi/qapi-schema.json                         |   1 +
>  scripts/arm_processor_error.py                | 476 ++++++++++++
>  scripts/ghes_inject.py                        |  51 ++
>  scripts/qmp_helper.py                         | 703 ++++++++++++++++++
>  target/arm/kvm.c                              |   7 +-
>  tests/data/acpi/aarch64/virt/DSDT             | Bin 5196 -> 5240 bytes
>  .../data/acpi/aarch64/virt/DSDT.acpihmatvirt  | Bin 5282 -> 5326 bytes
>  tests/data/acpi/aarch64/virt/DSDT.memhp       | Bin 6557 -> 6601 bytes
>  tests/data/acpi/aarch64/virt/DSDT.pxb         | Bin 7679 -> 7723 bytes
>  tests/data/acpi/aarch64/virt/DSDT.topology    | Bin 5398 -> 5442 bytes
>  tests/data/acpi/aarch64/virt/HEST             | Bin 0 -> 224 bytes
>  tests/qtest/bios-tables-test.c                |   2 +-
>  32 files changed, 1697 insertions(+), 90 deletions(-)
>  create mode 100644 hw/acpi/ghes_cper.c
>  create mode 100644 hw/acpi/ghes_cper_stub.c
>  create mode 100644 qapi/acpi-hest.json
>  create mode 100644 scripts/arm_processor_error.py
>  create mode 100755 scripts/ghes_inject.py
>  create mode 100755 scripts/qmp_helper.py
>  create mode 100644 tests/data/acpi/aarch64/virt/HEST
> 
> -- 
> 2.49.0


