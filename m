Return-Path: <kvm+bounces-49277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CBAAAD758A
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 17:18:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C72E13AAE35
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 15:18:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC8FA299A9C;
	Thu, 12 Jun 2025 15:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c183YOmu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE1E298989;
	Thu, 12 Jun 2025 15:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749741469; cv=none; b=fQ9YAkeTXuP2Yp41jDHvlYcIhjZm/TxZZhWo3KauDjCC5V0ZUC6c3mD8KAZKqwO3c+EpIqu+ZIAr9WaHqyEJxwTs2rkCsb04bBxFToStJnalxnr73WTkEhoNn8sO9GRe3nkvfabH+q795eDAjIRpTJ8LS9Tey9aDdivbIKIf8PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749741469; c=relaxed/simple;
	bh=rdDqYZpuQPOAXU9gt2awAFZCsnRKJ5QLS/BhyGxpYX0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=opazuleh2QzAmO6+H12jG/ckSxsTYr7KAIwmtoLE6Dary7YWYwSF1aGy5/GSS95MmyIqsjL0y2ZEcIAXn0MJAgzV3o9XlTr8fwSbqlm30+WmcUFHi09qmZoQv0DZHLz0/aDGdCn4v2UtLbNolbHrD+sPERJMC4sVpSiFkbA9LDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c183YOmu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F13C4CEEE;
	Thu, 12 Jun 2025 15:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749741468;
	bh=rdDqYZpuQPOAXU9gt2awAFZCsnRKJ5QLS/BhyGxpYX0=;
	h=From:To:Cc:Subject:Date:From;
	b=c183YOmukx4+1oM7y9glS4W5vWDy+h+x2kXPLdPaLPKAVL1XSdn5SGIOZ2euFu5oR
	 moWLYfRPudiXwepC7byVYX4OYUJf9/WCf1QYlK3ltmuCYeUZyx36nqC+kv6jU7kz5f
	 5+4BREXvua1kUYY794+7URRd9Ms4ATA0LLxW/+bLndw+G5/k55voCGPdyUo+oANdbn
	 s2xxyS3+Q0J54m6lmHIkd6peoCKHjA74lKfk3r8qZnsKD/sGCHpQp5iNTAtzdoZeZ4
	 iKWAU2U5VlL7GXxGjCJn0VJOgvbFxS86gw44FnHAiVzRvke51fmmN9VPCRUccU915v
	 dvjrGy+0wttPg==
Received: from mchehab by mail.kernel.org with local (Exim 4.98.2)
	(envelope-from <mchehab+huawei@kernel.org>)
	id 1uPjgY-00000005Ev8-2cRl;
	Thu, 12 Jun 2025 17:17:46 +0200
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Shiju Jose <shiju.jose@huawei.com>,
	qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Dongjiu Geng <gengdongjiu1@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	kvm@vger.kernel.org,
	Cleber Rosa <crosa@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Eric Blake <eblake@redhat.com>,
	John Snow <jsnow@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Markus Armbruster <armbru@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 (RESEND) 00/20] Change ghes to use HEST-based offsets and add support for error inject
Date: Thu, 12 Jun 2025 17:17:24 +0200
Message-ID: <cover.1749741085.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Hi Michael,

This is v10 of the patch series, rebased to apply after release
10.0. The only difference against v9 is a minor confict resolution.

I sent already the patch with conflicts, but, as you didn't pick,
I'm assuming you're opting to see the entire series again, as it
could make easier for you to use b4 or some other script you may
use to pick patches. So, let me resend the entire series.

It is nearly identical to v9 which addressed 3 issues:

- backward compatibility logic moved to version 10.0;
- fixed a compilation issue with target/arm/kvm.c (probably
  caused by some rebase - funny enough, incremental 
  compilation was fine here);
- added two missing SPDX comments.

As ghes_record_cper_errors() was written since the beginning
to be public and used by ghes-cper.c. It ended being meged
earlier because the error-injection series become too big,
so it was decided last year to split in two to make easier for
reviewers and maintainers to discuss.

This series change the way HEST table offsets are calculated,
making them identical to what an OSPM would do and allowing
multiple HEST entries without causing migration issues. It open
space to add HEST support for non-arm architectures, as now
the number and type of HEST notification entries are not
hardcoded at ghes.c. Instead, they're passed as a parameter
from the arch-dependent init code.

With such issue addressed, it adds a new notification type and
add support to inject errors via a Python script. The script
itself is at the final patch.

---

v10:
- rebased on the top of current upstream:
  d9ce74873a6a ("Merge tag 'pull-vfio-20250611' of https://github.com/legoater/qemu into staging")
- solved a minor conflict

v9:
- backward compatibility logic moved to version 10.0;
- fixed a compilation issue with target/arm/kvm.c (probably
  caused by some rebase - funny enough, incremental 
  compilation was fine here);
- added two missing SPDX comments.

v8:
  - added a patch to revert recently-added changeset causing a
    conflict with these. All remaining patches are identical.

v7:
  - minor editorial change at the patch updating HEST doc spec
   with the new workflow

v6:
- some minor nits addressed:
   - use GPA instead of offset;
   - merged two patches;
   - fixed a couple of long line coding style issues;
   - the HEST/DSDT diff inside a patch was changed to avoid troubles
     applying it.

v5:
- make checkpatch happier;
- HEST table is now tested;
- some changes at HEST spec documentation to align with code changes;
- extra care was taken with regards to git bisectability.

v4:
- added an extra comment for AcpiGhesState structure;
- patches reordered;
- no functional changes, just code shift between the patches in this series.

v3:
- addressed more nits;
- hest_add_le now points to the beginning of HEST table;
- removed HEST from tests/data/acpi;
- added an extra patch to not use fw_cfg with virt-10.0 for hw_error_le

v2:
- address some nits;
- improved ags cleanup patch and removed ags.present field;
- added some missing le*_to_cpu() calls;
- update date at copyright for new files to 2024-2025;
- qmp command changed to: inject-ghes-v2-error ans since updated to 10.0;
- added HEST and DSDT tables after the changes to make check target happy.
  (two patches: first one whitelisting such tables; second one removing from
   whitelist and updating/adding such tables to tests/data/acpi)

Mauro Carvalho Chehab (20):
  tests/acpi: virt: add an empty HEST file
  tests/qtest/bios-tables-test: extend to also check HEST table
  tests/acpi: virt: update HEST file with its current data
  Revert "hw/acpi/ghes: Make ghes_record_cper_errors() static"
  acpi/ghes: Cleanup the code which gets ghes ged state
  acpi/ghes: prepare to change the way HEST offsets are calculated
  acpi/ghes: add a firmware file with HEST address
  acpi/ghes: Use HEST table offsets when preparing GHES records
  acpi/ghes: don't hard-code the number of sources for HEST table
  acpi/ghes: add a notifier to notify when error data is ready
  acpi/generic_event_device: Update GHES migration to cover hest addr
  acpi/generic_event_device: add logic to detect if HEST addr is
    available
  acpi/generic_event_device: add an APEI error device
  tests/acpi: virt: allow acpi table changes at DSDT and HEST tables
  arm/virt: Wire up a GED error device for ACPI / GHES
  qapi/acpi-hest: add an interface to do generic CPER error injection
  acpi/generic_event_device.c: enable use_hest_addr for QEMU 10.x
  tests/acpi: virt: update HEST and DSDT tables
  docs: hest: add new "etc/acpi_table_hest_addr" and update workflow
  scripts/ghes_inject: add a script to generate GHES error inject

 MAINTAINERS                                   |  10 +
 docs/specs/acpi_hest_ghes.rst                 |  28 +-
 hw/acpi/Kconfig                               |   5 +
 hw/acpi/aml-build.c                           |  10 +
 hw/acpi/generic_event_device.c                |  44 ++
 hw/acpi/ghes-stub.c                           |   7 +-
 hw/acpi/ghes.c                                | 233 ++++--
 hw/acpi/ghes_cper.c                           |  39 +
 hw/acpi/ghes_cper_stub.c                      |  20 +
 hw/acpi/meson.build                           |   2 +
 hw/arm/virt-acpi-build.c                      |  35 +-
 hw/arm/virt.c                                 |  19 +-
 hw/core/machine.c                             |   2 +
 include/hw/acpi/acpi_dev_interface.h          |   1 +
 include/hw/acpi/aml-build.h                   |   2 +
 include/hw/acpi/generic_event_device.h        |   1 +
 include/hw/acpi/ghes.h                        |  51 +-
 include/hw/arm/virt.h                         |   2 +
 qapi/acpi-hest.json                           |  35 +
 qapi/meson.build                              |   1 +
 qapi/qapi-schema.json                         |   1 +
 scripts/arm_processor_error.py                | 476 ++++++++++++
 scripts/ghes_inject.py                        |  51 ++
 scripts/qmp_helper.py                         | 703 ++++++++++++++++++
 target/arm/kvm.c                              |   7 +-
 tests/data/acpi/aarch64/virt/DSDT             | Bin 5196 -> 5240 bytes
 .../data/acpi/aarch64/virt/DSDT.acpihmatvirt  | Bin 5282 -> 5326 bytes
 tests/data/acpi/aarch64/virt/DSDT.memhp       | Bin 6557 -> 6601 bytes
 tests/data/acpi/aarch64/virt/DSDT.pxb         | Bin 7679 -> 7723 bytes
 tests/data/acpi/aarch64/virt/DSDT.topology    | Bin 5398 -> 5442 bytes
 tests/data/acpi/aarch64/virt/HEST             | Bin 0 -> 224 bytes
 tests/qtest/bios-tables-test.c                |   2 +-
 32 files changed, 1697 insertions(+), 90 deletions(-)
 create mode 100644 hw/acpi/ghes_cper.c
 create mode 100644 hw/acpi/ghes_cper_stub.c
 create mode 100644 qapi/acpi-hest.json
 create mode 100644 scripts/arm_processor_error.py
 create mode 100755 scripts/ghes_inject.py
 create mode 100755 scripts/qmp_helper.py
 create mode 100644 tests/data/acpi/aarch64/virt/HEST

-- 
2.49.0


