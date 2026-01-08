Return-Path: <kvm+bounces-67315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C08ED00C60
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 04:05:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BBF05300EF44
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 03:05:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68C2527EC7C;
	Thu,  8 Jan 2026 03:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZS7XQzTE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91F4276038
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 03:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767841539; cv=none; b=O6b6KC2DLDZa5Q7aw/avaTwoOV5gUVi08/+HYk2Lcl6/10Y5V0lOxgODB4AtQGdkHnqmYdd5d+7nB2DJlZW8FYH+Z3XMEt1dSdxEuS1gk/3884Zm6CtVUx7Z6zvWHmlxBmj51hKuogOCpBCj02uSQ+KY3z9XWoTtU2hTt4kejss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767841539; c=relaxed/simple;
	bh=otyETV30vdfhYPoyBoUooXnaMNpRVerC31jFgU5oZhU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=YDtdLzio07X3h+3aR1cdHCHgtDkPQ8GPbT2bsE3Cj+OPR5QS6chz6TPAe2vuKcsUzFz6H13aEhdJT35nZ7vOkSyixqlY2GNUbzbe6WvK4FIxriPvatrTzAiG0EFqFb3qVbOBvugXsX8/Ln8k7v4fZyQtB+Kio4qfiEVWf71tbPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZS7XQzTE; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767841538; x=1799377538;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=otyETV30vdfhYPoyBoUooXnaMNpRVerC31jFgU5oZhU=;
  b=ZS7XQzTE0moYPW2ujekMGYVOeHAX1QHEqGmZieX7NE6qe0GCVFthFypi
   oFui03TTP/bEvgM5RdQYshaNW1g9WsAF0ZwjNH/+lw94DrgvEEPImtemB
   SC2Iq5RToYDh6Gyoo422wEelkIjI4GM4/ZxVVDhAZLYkgWiaes6pzLYZ0
   39W5rpoJOjLq7uiK/5f2BX8/QybdF9cKl4qhAu4iqavlRGF6pQQMaGGNu
   CGm/zgTuxTPlCImTu2i67DKW6vfJ8o1qkB5DfaIWOgK5/t072+6KUf97m
   saG6Xu6GOt9FS06ZOnY81y+uaduZdlQrKvD625pYiI0OsPmg6BH/+IF5o
   A==;
X-CSE-ConnectionGUID: DCS7infkSumapp6pVPhqOA==
X-CSE-MsgGUID: Uc9t7NtwSuC+j0p6sSk6qA==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="91876869"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="91876869"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 19:05:38 -0800
X-CSE-ConnectionGUID: xNFSBGhgTnWPuswOdRNByw==
X-CSE-MsgGUID: eA76c9LSTCC062C8o7C4+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="202210486"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa006.jf.intel.com with ESMTP; 07 Jan 2026 19:05:27 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Thomas Huth <thuth@redhat.com>
Cc: qemu-devel@nongnu.org,
	devel@lists.libvirt.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Amit Shah <amit@kernel.org>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Peter Krempa <pkrempa@redhat.com>,
	Jiri Denemark <jdenemar@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v6 00/27] hw/i386/pc: Remove deprecated 2.6 and 2.7 PC machines
Date: Thu,  8 Jan 2026 11:30:24 +0800
Message-Id: <20260108033051.777361-1-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

This v6 is based on the master branch at the commit 0fc482b73d8e
("Merge tag 'pull-aspeed-20260105' of https://github.com/legoater/qemu
into staging").

Since there's the discussion around fw_cfg_init_io_nodma() [*], v6
doesn't include that cleanups. Therefore, comparing v5, v6 has *very*
minimal changes and most of patches have been reviewed (except patch 15
- I think it needs an additianl review :-) ).

Thanks for your patience and review!


Introduction
============

A brief introduction from Philippe's v4:

The versioned 'pc' and 'q35' machines up to 2.12 been marked
as deprecated three releases ago, and are older than 6 years,
so according to our support policy we can remove them.

This series only includes the 2.6 and 2.7 machines removal,
as it is a big enough number of LoC removed. Rest will
follow.


Change Log
==========

(Main) changes since v5:
 * Merge pc & q35 changes for testing DSDT tables into one patch and
   simplify the commit message.
 * Reorganize S-o-b and collect review tags from Igor. 

(Main) changes since v4:
 * Completely remove the legacy CPU hotplug approach.
   - New patch 2-8.
   - Test CPU hot-plug & hot-unplug via qmp.

 * Keep "dma_enabled" property in fw_cfg_io_properties[] since Sun4u &
   Sun4v are still using it.
   - About more details, please see commit message of patch 15.

 * Temporarily keep these properties: "cpuid-0xb" (of X86CPU),
   "fill-mtrr-mask" (of X86CPU), "version" (of IOAPICCommonState).
   - These properties will be deprecated first before removal, in
     another series.

 * Keep "l3-cache" (of X86CPU) and "page-per-vq" (of VirtIOPCIProxy),
   since they are still in use (e.g., libvirt).


Reference
=========

[*]: https://lore.kernel.org/qemu-devel/20251203060942.57851-1-philmd@linaro.org/

Best Regards,
Zhao
---
Igor Mammedov (1):
  tests/acpi: Allow DSDT table change for x86 machines

Philippe Mathieu-Daudé (22):
  hw/i386/pc: Remove deprecated pc-q35-2.6 and pc-i440fx-2.6 machines
  hw/i386/pc: Remove PCMachineClass::legacy_cpu_hotplug field
  hw/nvram/fw_cfg: Rename fw_cfg_init_mem() with '_nodma' suffix
  hw/mips/loongson3_virt: Prefer using fw_cfg_init_mem_nodma()
  hw/nvram/fw_cfg: Factor fw_cfg_init_mem_internal() out
  hw/nvram/fw_cfg: Rename fw_cfg_init_mem_wide() ->
    fw_cfg_init_mem_dma()
  hw/i386/x86: Remove X86MachineClass::fwcfg_dma_enabled field
  hw/i386/pc: Remove multiboot.bin
  hw/i386: Assume fw_cfg DMA is always enabled
  hw/i386: Remove linuxboot.bin
  hw/i386/pc: Remove pc_compat_2_6[] array
  hw/intc/apic: Remove APICCommonState::legacy_instance_id field
  hw/core/machine: Remove hw_compat_2_6[] array
  hw/virtio/virtio-mmio: Remove
    VirtIOMMIOProxy::format_transport_address field
  hw/i386/pc: Remove deprecated pc-q35-2.7 and pc-i440fx-2.7 machines
  hw/i386/pc: Remove pc_compat_2_7[] array
  target/i386/cpu: Remove CPUX86State::full_cpuid_auto_level field
  hw/audio/pcspk: Remove PCSpkState::migrate field
  hw/core/machine: Remove hw_compat_2_7[] array
  hw/i386/intel_iommu: Remove IntelIOMMUState::buggy_eim field
  hw/virtio/virtio-pci: Remove VirtIOPCIProxy::ignore_backend_features
    field
  hw/char/virtio-serial: Do not expose the 'emergency-write' property

Zhao Liu (4):
  pc: Start with modern CPU hotplug interface by default
  acpi: Remove legacy cpu hotplug utilities
  docs/specs/acpi_cpu_hotplug: Remove legacy cpu hotplug descriptions
  tests/acpi: Update DSDT tables for pc & q35 machines

 docs/specs/acpi_cpu_hotplug.rst               |  28 +-
 hw/acpi/acpi-cpu-hotplug-stub.c               |  19 +-
 hw/acpi/cpu.c                                 |  10 -
 hw/acpi/cpu_hotplug.c                         | 348 ------------------
 hw/acpi/generic_event_device.c                |   1 +
 hw/acpi/ich9.c                                |  61 +--
 hw/acpi/meson.build                           |   2 +-
 hw/acpi/piix4.c                               |  61 +--
 hw/arm/virt.c                                 |   2 +-
 hw/audio/pcspk.c                              |  10 -
 hw/char/virtio-serial-bus.c                   |   9 +-
 hw/core/machine.c                             |  17 -
 hw/hppa/machine.c                             |   2 +-
 hw/i386/acpi-build.c                          |   7 +-
 hw/i386/fw_cfg.c                              |  16 +-
 hw/i386/intel_iommu.c                         |   5 +-
 hw/i386/microvm.c                             |   3 -
 hw/i386/multiboot.c                           |   7 +-
 hw/i386/pc.c                                  |  25 +-
 hw/i386/pc_piix.c                             |  23 --
 hw/i386/pc_q35.c                              |  24 --
 hw/i386/x86-common.c                          |   8 +-
 hw/i386/x86.c                                 |   2 -
 hw/intc/apic_common.c                         |   5 -
 hw/loongarch/fw_cfg.c                         |   4 +-
 hw/loongarch/virt-acpi-build.c                |   1 -
 hw/mips/loongson3_virt.c                      |   2 +-
 hw/nvram/fw_cfg.c                             |  22 +-
 hw/riscv/virt.c                               |   4 +-
 hw/virtio/virtio-mmio.c                       |  15 -
 hw/virtio/virtio-pci.c                        |   5 +-
 include/hw/acpi/cpu.h                         |   1 -
 include/hw/acpi/ich9.h                        |   4 +-
 include/hw/acpi/piix4.h                       |   4 +-
 include/hw/core/boards.h                      |   6 -
 include/hw/i386/apic_internal.h               |   1 -
 include/hw/i386/intel_iommu.h                 |   1 -
 include/hw/i386/pc.h                          |   9 -
 include/hw/i386/x86.h                         |   2 -
 include/hw/nvram/fw_cfg.h                     |   9 +-
 include/hw/virtio/virtio-mmio.h               |   1 -
 include/hw/virtio/virtio-pci.h                |   1 -
 include/hw/virtio/virtio-serial.h             |   2 -
 pc-bios/meson.build                           |   2 -
 pc-bios/multiboot.bin                         | Bin 1024 -> 0 bytes
 pc-bios/optionrom/Makefile                    |   2 +-
 pc-bios/optionrom/linuxboot.S                 | 195 ----------
 pc-bios/optionrom/multiboot.S                 | 232 ------------
 pc-bios/optionrom/multiboot_dma.S             | 234 +++++++++++-
 pc-bios/optionrom/optionrom.h                 |   4 -
 target/i386/cpu.c                             | 119 +++---
 target/i386/cpu.h                             |   3 -
 tests/data/acpi/x86/pc/DSDT                   | Bin 8611 -> 8598 bytes
 tests/data/acpi/x86/pc/DSDT.acpierst          | Bin 8522 -> 8509 bytes
 tests/data/acpi/x86/pc/DSDT.acpihmat          | Bin 9936 -> 9923 bytes
 tests/data/acpi/x86/pc/DSDT.bridge            | Bin 15482 -> 15469 bytes
 tests/data/acpi/x86/pc/DSDT.cphp              | Bin 9075 -> 9062 bytes
 tests/data/acpi/x86/pc/DSDT.dimmpxm           | Bin 10265 -> 10252 bytes
 tests/data/acpi/x86/pc/DSDT.hpbridge          | Bin 8562 -> 8549 bytes
 tests/data/acpi/x86/pc/DSDT.hpbrroot          | Bin 5100 -> 5087 bytes
 tests/data/acpi/x86/pc/DSDT.ipmikcs           | Bin 8683 -> 8670 bytes
 tests/data/acpi/x86/pc/DSDT.memhp             | Bin 9970 -> 9957 bytes
 tests/data/acpi/x86/pc/DSDT.nohpet            | Bin 8469 -> 8456 bytes
 tests/data/acpi/x86/pc/DSDT.numamem           | Bin 8617 -> 8604 bytes
 tests/data/acpi/x86/pc/DSDT.roothp            | Bin 12404 -> 12391 bytes
 tests/data/acpi/x86/q35/DSDT                  | Bin 8440 -> 8427 bytes
 tests/data/acpi/x86/q35/DSDT.acpierst         | Bin 8457 -> 8444 bytes
 tests/data/acpi/x86/q35/DSDT.acpihmat         | Bin 9765 -> 9752 bytes
 .../data/acpi/x86/q35/DSDT.acpihmat-generic-x | Bin 12650 -> 12637 bytes
 .../acpi/x86/q35/DSDT.acpihmat-noinitiator    | Bin 8719 -> 8706 bytes
 tests/data/acpi/x86/q35/DSDT.applesmc         | Bin 8486 -> 8473 bytes
 tests/data/acpi/x86/q35/DSDT.bridge           | Bin 12053 -> 12040 bytes
 tests/data/acpi/x86/q35/DSDT.core-count       | Bin 12998 -> 12985 bytes
 tests/data/acpi/x86/q35/DSDT.core-count2      | Bin 33855 -> 33842 bytes
 tests/data/acpi/x86/q35/DSDT.cphp             | Bin 8904 -> 8891 bytes
 tests/data/acpi/x86/q35/DSDT.cxl              | Bin 13231 -> 13218 bytes
 tests/data/acpi/x86/q35/DSDT.dimmpxm          | Bin 10094 -> 10081 bytes
 tests/data/acpi/x86/q35/DSDT.ipmibt           | Bin 8515 -> 8502 bytes
 tests/data/acpi/x86/q35/DSDT.ipmismbus        | Bin 8528 -> 8515 bytes
 tests/data/acpi/x86/q35/DSDT.ivrs             | Bin 8457 -> 8444 bytes
 tests/data/acpi/x86/q35/DSDT.memhp            | Bin 9799 -> 9786 bytes
 tests/data/acpi/x86/q35/DSDT.mmio64           | Bin 9570 -> 9557 bytes
 tests/data/acpi/x86/q35/DSDT.multi-bridge     | Bin 13293 -> 13280 bytes
 tests/data/acpi/x86/q35/DSDT.noacpihp         | Bin 8302 -> 8289 bytes
 tests/data/acpi/x86/q35/DSDT.nohpet           | Bin 8298 -> 8285 bytes
 tests/data/acpi/x86/q35/DSDT.numamem          | Bin 8446 -> 8433 bytes
 tests/data/acpi/x86/q35/DSDT.pvpanic-isa      | Bin 8541 -> 8528 bytes
 tests/data/acpi/x86/q35/DSDT.thread-count     | Bin 12998 -> 12985 bytes
 tests/data/acpi/x86/q35/DSDT.thread-count2    | Bin 33855 -> 33842 bytes
 tests/data/acpi/x86/q35/DSDT.tis.tpm12        | Bin 9046 -> 9033 bytes
 tests/data/acpi/x86/q35/DSDT.tis.tpm2         | Bin 9072 -> 9059 bytes
 tests/data/acpi/x86/q35/DSDT.type4-count      | Bin 18674 -> 18661 bytes
 tests/data/acpi/x86/q35/DSDT.viot             | Bin 14697 -> 14684 bytes
 tests/data/acpi/x86/q35/DSDT.xapic            | Bin 35803 -> 35790 bytes
 tests/qtest/test-x86-cpuid-compat.c           |  11 -
 95 files changed, 363 insertions(+), 1228 deletions(-)
 delete mode 100644 hw/acpi/cpu_hotplug.c
 delete mode 100644 pc-bios/multiboot.bin
 delete mode 100644 pc-bios/optionrom/linuxboot.S
 delete mode 100644 pc-bios/optionrom/multiboot.S

-- 
2.34.1


