Return-Path: <kvm+bounces-65123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CFE6BC9C13C
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 17:04:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EC943A49FB
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 16:04:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7195A2737E0;
	Tue,  2 Dec 2025 16:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J0BcIto9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED354248896
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 16:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691450; cv=none; b=KHbBvcDAoO5RyjWlQtffim0b1VkNcrWa8vxfgKkBUY1+4tDelLj7/0SdO2thLgTIynA6wNa3UMAWDnNLmAye92+RXL63CkSaYJWiZTOfNkTlQbLGxOZi9O1iYUZ60ekUGkUKa8tMaFAdg1f6Ymasn1CTbZiHiPMfU0lxgbX62tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691450; c=relaxed/simple;
	bh=gl+I3qRUk/2kD6tcKA1cj0SEcivTN17lu7FLN59Ycg4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=E8jyAJ906hm9Fl2ZntWPgWFlGFe21f+dL+M3CE6hOUrYLAaOIbg4sIMMGkPNmIWS8QEsDO6t0tRDpiqvM7nieFy7ht22Zs3xhGZGTd6Cq4vQ44uYkDfoYslSTSbLLdXwPURG4guQ8B60H99TNV+q+SO7FdhQ/Eu4ItZGTjz1XA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J0BcIto9; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764691449; x=1796227449;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gl+I3qRUk/2kD6tcKA1cj0SEcivTN17lu7FLN59Ycg4=;
  b=J0BcIto9f8Nzxd5yX8vv81Z7Qde1S3urGC0jL9PAVzhx18WKAWt+0kcX
   LYBJ4QbDMu7Vw//hXT28qr3T4JgjH9ArHHtsvh3Gj822JkkitH8dpm7DX
   yGWqs5pN0agp2jwXb1nV8t172Ai3kqd7CRxOp9AmpH+ygf2MsPkvf933g
   /ogK4gyMLqUiTTK4M9EEMwgusambL9K78nHR5HXeg7JM3MZ7nmPhQ/LMe
   eN0oeG7hwcqrTOhy7qcwDKmg2o6PHSBa77ltz5h197urKbu7pwD1De9UD
   NEGNQ2yjfR6LwANJ3SwCHll8+wZjI//9mwDXLg7u+01HzQ7X4aC+262Rz
   w==;
X-CSE-ConnectionGUID: Bu4Y6IXjT4GHDlGXXOaltw==
X-CSE-MsgGUID: qnUs08y2Q1OufiL4KqBwxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="92142172"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="92142172"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:04:08 -0800
X-CSE-ConnectionGUID: bzzD33gAS+6lPd5xdA7mbA==
X-CSE-MsgGUID: IhCA6L4sQFiUFoTfizwXUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="199536863"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 02 Dec 2025 08:03:59 -0800
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
Subject: [PATCH v5 00/28] hw/i386/pc: Remove deprecated 2.6 and 2.7 PC machines
Date: Wed,  3 Dec 2025 00:28:07 +0800
Message-Id: <20251202162835.3227894-1-zhao1.liu@intel.com>
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

A brief introduction from Philippe's v4:

The versioned 'pc' and 'q35' machines up to 2.12 been marked
as deprecated three releases ago, and are older than 6 years,
so according to our support policy we can remove them.

This series only includes the 2.6 and 2.7 machines removal,
as it is a big enough number of LoC removed. Rest will
follow.

This v5 is based on the master branch at the commit 66ec38b6fa59
("Merge tag 'pull-target-arm-20251201' of https://gitlab.com/pm215/qemu
into staging").

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

Thank you everyone for the reviews and patience, and also thank you
Philippe for the guidance and Igor for the patch.

Best Regards,
Zhao
---
Igor Mammedov (3):
  tests/acpi: Allow DSDT table change for x86 machines
  pc: Start with modern CPU hotplug interface by default
  acpi: Remove legacy cpu hotplug utilities

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

Zhao Liu (3):
  docs/specs/acpi_cpu_hotplug: Remove legacy cpu hotplug descriptions
  tests/acpi: Update DSDT tables for pc machine
  tests/acpi: Update DSDT tables for q35 machine

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
 include/hw/acpi/cpu_hotplug.h                 |  40 --
 include/hw/acpi/ich9.h                        |   4 +-
 include/hw/acpi/piix4.h                       |   4 +-
 include/hw/boards.h                           |   6 -
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
 target/i386/cpu.c                             | 111 +++---
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
 96 files changed, 359 insertions(+), 1264 deletions(-)
 delete mode 100644 hw/acpi/cpu_hotplug.c
 delete mode 100644 include/hw/acpi/cpu_hotplug.h
 delete mode 100644 pc-bios/multiboot.bin
 delete mode 100644 pc-bios/optionrom/linuxboot.S
 delete mode 100644 pc-bios/optionrom/multiboot.S

-- 
2.34.1


