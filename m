Return-Path: <kvm+bounces-39607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EF193A48572
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 17:43:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B417D7A5418
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 16:42:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3CA81B4140;
	Thu, 27 Feb 2025 16:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q6fPEnZx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342E51A9B5B
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 16:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740674610; cv=none; b=hEFoRhE+JBUTozF+9vypvvAVy9yyN+a9dwGbwuLKi6F3ILMnwxo4qN1Hp7sk+2m7z3Qk38uYC/jvKrBPn3ybOZ2HiUpwcCEPKrugh3hV9UHQPpZtH9yqlUVd1qLdsGMTe46wA+C5oXnJnf9M+hOK/L2NVdKv0dZTEwECtsitIS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740674610; c=relaxed/simple;
	bh=N2U6Xyj+9lJkd79UADYQfgAlIIyD7zVtVL/LKmWPx0g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bh+OFFH3rGi0/54Md6fPvbPpIkUpE7wsfu0BTs8nS+emvjZKKFox9qrNkDJK5zo1vdFXBmNoiZPCnoIK17K1IB1MXpv7A7mAoF42KCrPO8dIxM3bHGFLFt1RmN9xwlij4/SpReHnhG9EW7WAdIjoanap57KcJ21+7estY6qjEHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q6fPEnZx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740674607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TQNCbBxi7eD7idYstTcVVTcDcXqJ3+FMvik+jAH6Dos=;
	b=Q6fPEnZx8nLEFQPAzBX7CCyKjB0JIFhgqsLYEMbMBhX8iq9ds9berfAbIIavAvAV9OlMHT
	dOkvXaoyGN1BCwy4K+YgLRYQtxbv7i0/B7bK9izLbf/u9Bw1tXxJPRfaKuuX2QiAbYOeNo
	Gq/7EZ3SLkqZsV4G0WLkRG/TISrqt70=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-30oMhKpIPRadwgBRm-Kpow-1; Thu, 27 Feb 2025 11:43:26 -0500
X-MC-Unique: 30oMhKpIPRadwgBRm-Kpow-1
X-Mimecast-MFC-AGG-ID: 30oMhKpIPRadwgBRm-Kpow_1740674605
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-439a5c4dfb2so5949045e9.1
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 08:43:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740674605; x=1741279405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TQNCbBxi7eD7idYstTcVVTcDcXqJ3+FMvik+jAH6Dos=;
        b=Wy2389gFQftDRVmwwHy15NiJktegEGre9+EWXZ8Yv1of7H786NjxkCHI67erxbRYyI
         Hv3enwpvWEmYsNhRRu3RrDM7KA9DIbUOp8fygWhbQ6Cu9Myeuv5HTJFPjCZXRaFmoYn8
         TJ0qEGYrx1i7georqxT1Mqm+hvhL5PoP/iUZ6Ms4pXEfc4tT4KlzyTMRAaPHLV/xGwjW
         ifgbTZYXUfktG6beYoRkntWtQYoYHGWZ2e8IRqfBPAXZFnInXjOS6j9MLhfMJCQTJI65
         t/5tw/oX7TKcyRGTdWXFkPD1vb2vuks/05g5nHSOXBNvB98gnP0T9FJOzxgvjS0ssKlm
         c+bA==
X-Forwarded-Encrypted: i=1; AJvYcCXmnEsGTb32qJ5yWz89S69kG4nlzn1tgK97kmnNL6ojnx3v8vHkJu8huXKhqBBsybou6jA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjLjIe8DU1n/jROBqMMzxtBPW2bfzrwUlsYWfnbPPYEpZC779c
	99otLJYgNL9QGNSfIr6UTdprdOlkwEWEAaRfu9gq2nTjQqjjgJBWrUR20idVDcU46ETNIkUWJqr
	0JPwwdz8wWoD7Yx20hLIYLqSWLHDJxCxfqAZ3z4OGernN7+/Qzw==
X-Gm-Gg: ASbGncsoeHVuT1FelK5sp/zxY0OvSthbluaJoNNc+RJE3uAp6kKHqZb4fk2bN+JoIiD
	E8ZpEKUiap2zbLUGxuRh1/1cUTWbmF5FRPsyXWKelnT6Wc/eS8FcoJRy8G3S6ykll6A1aKaqFnz
	6ufNAwCqC84cY44ppbqYrIgrYwdicqnWWsDkl2f2noAm+oKFmxwz+5blt5A+RYIcY4FqVGhv6YL
	j/u7fJGZTVYtPR3lcb2HNk7TgKrz2ycM0xbu6HbyksO181lTaqQwbntyn/+k+kU4RCRlYpcjdrN
	RUEk/SLq+YEg1Y2ab3iECxow+6FlxNuwa8k0otISvSzR+JaIxHvi++mBG2ae7B8=
X-Received: by 2002:a05:600c:3c83:b0:439:82de:9166 with SMTP id 5b1f17b1804b1-43ab8fd1e8dmr64031115e9.1.1740674605051;
        Thu, 27 Feb 2025 08:43:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFrTKA/tq7v3HDQicW7l4zuzGDkJqwkvaaj/r610R8fS1dVqhjB9P9yfyCOg58tOjH/0/jlEQ==
X-Received: by 2002:a05:600c:3c83:b0:439:82de:9166 with SMTP id 5b1f17b1804b1-43ab8fd1e8dmr64030785e9.1.1740674604620;
        Thu, 27 Feb 2025 08:43:24 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43b737074d8sm29172345e9.16.2025.02.27.08.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 08:43:24 -0800 (PST)
Date: Thu, 27 Feb 2025 17:43:21 +0100
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
Subject: Re: [PATCH v6 00/19] Change ghes to use HEST-based offsets and add
 support for error inject
Message-ID: <20250227174321.0162a10f@imammedo.users.ipa.redhat.com>
In-Reply-To: <cover.1740671863.git.mchehab+huawei@kernel.org>
References: <cover.1740671863.git.mchehab+huawei@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 27 Feb 2025 17:00:38 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> Now that the ghes preparation patches were merged, let's add support
> for error injection.
> 
> On this version, HEST table got added to ACPI tables testing for aarch64 virt.
> 
> There are also some patch reorder to help reviewers to check the changes.
> 
> The code itself is almost identical to v4, with just a few minor nits addressed.
checkpatch on my machine still complains

0007-acpi-ghes-Use-HEST-table-offsets-when-preparing-GHES.patch has no obvious style problems and is ready for submission.
Checking 0008-acpi-ghes-don-t-hard-code-the-number-of-sources-for-.patch...
WARNING: line over 80 characters
#170: FILE: hw/acpi/ghes.c:390:
+        build_ghes_v2_entry(table_data, linker, &notif_source[i], i, num_sources);

total: 0 errors, 1 warnings, 159 lines checked

0008-acpi-ghes-don-t-hard-code-the-number-of-sources-for-.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
Checking 0009-acpi-ghes-add-a-notifier-to-notify-when-error-data-i.patch...
total: 0 errors, 0 warnings, 26 lines checked

0009-acpi-ghes-add-a-notifier-to-notify-when-error-data-i.patch has no obvious style problems and is ready for submission.
Checking 0010-acpi-generic_event_device-Update-GHES-migration-to-c.patch...
total: 0 errors, 0 warnings, 41 lines checked

0010-acpi-generic_event_device-Update-GHES-migration-to-c.patch has no obvious style problems and is ready for submission.
Checking 0011-acpi-generic_event_device-add-logic-to-detect-if-HES.patch...
total: 0 errors, 0 warnings, 59 lines checked

0011-acpi-generic_event_device-add-logic-to-detect-if-HES.patch has no obvious style problems and is ready for submission.
Checking 0012-acpi-generic_event_device-add-an-APEI-error-device.patch...
total: 0 errors, 0 warnings, 72 lines checked

0012-acpi-generic_event_device-add-an-APEI-error-device.patch has no obvious style problems and is ready for submission.
Checking 0013-tests-acpi-virt-allow-acpi-table-changes-at-DSDT-and.patch...
total: 0 errors, 0 warnings, 7 lines checked

0013-tests-acpi-virt-allow-acpi-table-changes-at-DSDT-and.patch has no obvious style problems and is ready for submission.
Checking 0014-arm-virt-Wire-up-a-GED-error-device-for-ACPI-GHES.patch...
WARNING: line over 80 characters
#68: FILE: hw/arm/virt.c:1015:
+    VirtMachineState *s = container_of(n, VirtMachineState, generic_error_notifier);

total: 0 errors, 1 warnings, 44 lines checked

0014-arm-virt-Wire-up-a-GED-error-device-for-ACPI-GHES.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
Checking 0015-qapi-acpi-hest-add-an-interface-to-do-generic-CPER-e.patch...
total: 0 errors, 0 warnings, 178 lines checked



> ---
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
> 
> 
> Mauro Carvalho Chehab (19):
>   tests/acpi: virt: add an empty HEST file
>   tests/qtest/bios-tables-test: extend to also check HEST table
>   tests/acpi: virt: update HEST file with its current data
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
>  hw/acpi/ghes.c                                | 231 ++++--
>  hw/acpi/ghes_cper.c                           |  38 +
>  hw/acpi/ghes_cper_stub.c                      |  19 +
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
>  32 files changed, 1692 insertions(+), 91 deletions(-)
>  create mode 100644 hw/acpi/ghes_cper.c
>  create mode 100644 hw/acpi/ghes_cper_stub.c
>  create mode 100644 qapi/acpi-hest.json
>  create mode 100644 scripts/arm_processor_error.py
>  create mode 100755 scripts/ghes_inject.py
>  create mode 100755 scripts/qmp_helper.py
>  create mode 100644 tests/data/acpi/aarch64/virt/HEST
> 


