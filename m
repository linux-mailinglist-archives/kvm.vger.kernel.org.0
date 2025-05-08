Return-Path: <kvm+bounces-45859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2017DAAFB7F
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:36:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88FD7463BA4
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91584227B88;
	Thu,  8 May 2025 13:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Sq+Bq6Sg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1136019D891
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711370; cv=none; b=P/ai24QtY1QMFFLo6Di8ZSig+r40ug2LWsq3PFP/ZC54+mB61Fwc1VbcZ7zQvuMpFiZ6ekH6K7asyKfDpNts5cGnWtb0f/nUV1I1NixFHDA6rrCZwEs0XwwCwxC74dm7Doi6KQon8ogk/m1JKj/P9sQNoB2xgv8FyUFm9UoyE7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711370; c=relaxed/simple;
	bh=NYxC4VAQRvp1oNFlw6l7w5wP6RiO8NZY1F/miU8Amq0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JjylnDZKYH5rRm8gYRdxChWr6w27Fe8q9TN16vl+NU9C49ABVjZEvYvRdN9S5ypcdlnhFnl3xeaMPtBeqOhOQ5OoHOkljjLzNhm9jXuPaXkF+JnmulJWNcIAlAq9+AzND2jg8U2FUX3pPvmkkq+WYkxvy6lPrHdpt0gHMJcu/x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Sq+Bq6Sg; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22fac0694aaso4410885ad.1
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746711368; x=1747316168; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9KuBrSw61wT1TUDNwR8So3hV4T+jBIcjNnsvQibQhUU=;
        b=Sq+Bq6SgarFX9JTWxgAk76gHpbopsz1J+ZpmSzuLm5R2wq99yXEHFoePg/ce7aiAMh
         w9/hm2vcSGjsrb5GAIXWnu24slrj/GZp/81IfvxcMG0MX+6DF+EdQWinOIghHE/p84Mn
         IVgvM+w5tvyBndJFx4xosoQ7jlMKqnCYNC1/Xn3S60NUnOTalUl1UhebKQCdSplt33Y4
         UIM4W7PTIDPfhLD0IgLFvd55ZBpHJIszzNKo/FmwwFUr0yqxPxpZv0pGzridchLcHFxz
         UrNa+Falg+DaIWBJnecOV6j8Ww0N0oCV24Ufchuf4lvQhf4W1lxkNbKYRjPYnaZjHY24
         bbvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711368; x=1747316168;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9KuBrSw61wT1TUDNwR8So3hV4T+jBIcjNnsvQibQhUU=;
        b=Nj/agrmortIjlyRD3fPYXjK456iO8Xxp4MdPR4SKJdFVkTEhwC0aZWEuHPubuzEyf6
         Wyv5pNSmEcky9Y963zIrVGDnVKjmGww/pDwFR5tmyezsuIWprbrpdL6y9cTid+t6NNGJ
         nerRmv7XbPrLgjWTUPLSgVWD5Icl4/FYs4nYATDnHvGQA8G4JU5xnrV4ObMVEVqy10Jd
         TI4GxW8Jvlp+pveu1uJYF+JZfG6SIRP32w0l76424RtPZTND8WYWw7dp6fDybehZcCfd
         /lUFTryxbGUTCfHmpCZ5d67lpFt6kdypsznE+88M9qZ1oVGPYPACKs41aM6rR+OWJy+Y
         5hSg==
X-Forwarded-Encrypted: i=1; AJvYcCUy6l4CD/YINzUHAo2gayp6M53cnQ+0bR9FankeUthRt4DOmRNyfuDCSChdhsUjQtfcato=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPcTcBwGDIws71DuVP4pIquBU3/hHc8rK5carOwaCYBRJxRbJe
	dBa/APhY21GC63GfhQZcfgDp9z5njFUFEdzBqCbMrCsbtzjD5gJ7JlpMr6rPcsE=
X-Gm-Gg: ASbGncuEZOFFMJW2sVNeIAsYxGSubkM1vgNJyChthDCEU9JKDn2DaQK4ImvBWsS5P+N
	yD+c2GnmQy3bnX97JZOMEy6YtKTn8ahjdMTjmjD7OHg6d8Vqa3bXQurY3Ib2s7AZFIvf8JmAB/A
	bOsJKhDrFPJesooH1gvwijB6OHQlmOBW3Mlmr67SQos4c6rZ//ooUiOsdYHy7+Sq+G9IAY0l2Gz
	cyaUAJgC+QdcxRBbF9yefGubXU0lgVE+DD/RDwHIQXUPbznm8KDi0VLJMUgGwMoEHrSU/2mQakL
	YcYJhFV3X96pqkD3Mke9mtNtgK6otINMKKTrFKZLXg9+yR+WyYknUpJzUA/0uSR3X5pSjdNv+Y8
	wJe67XSfMCmnrd5yCU/d1bIopsw==
X-Google-Smtp-Source: AGHT+IHCT7Ta0iqmowfn6JqxQ1updQHvZZpvmqe29UPiMd4qZ7+roOQP5pRKO/ivAKjg6VTKGbWo9g==
X-Received: by 2002:a17:903:478d:b0:220:e924:99dd with SMTP id d9443c01a7336-22e5ecc52a4mr120970055ad.34.1746711368214;
        Thu, 08 May 2025 06:36:08 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1521fd31sm112108055ad.130.2025.05.08.06.35.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 May 2025 06:36:07 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	qemu-riscv@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	Amit Shah <amit@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Ani Sinha <anisinha@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>
Subject: [PATCH v4 00/27] hw/i386/pc: Remove deprecated 2.6 and 2.7 PC machines
Date: Thu,  8 May 2025 15:35:23 +0200
Message-ID: <20250508133550.81391-1-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Since v3:
- Addressed Thomas and Zhao review comments
- Rename fw_cfg_init_mem_[no]dma() helpers
- Remove unused CPU properties
- Remove {multi,linux}boot.bin
- Added R-b tags

Since v2:
- Addressed Mark review comments and added his R-b tags

The versioned 'pc' and 'q35' machines up to 2.12 been marked
as deprecated two releases ago, and are older than 6 years,
so according to our support policy we can remove them.

This series only includes the 2.6 and 2.7 machines removal,
as it is a big enough number of LoC removed. Rest will
follow.

Based-on: <20250506143905.4961-1-philmd@linaro.org>

Philippe Mathieu-Daudé (27):
  hw/i386/pc: Remove deprecated pc-q35-2.6 and pc-i440fx-2.6 machines
  hw/i386/pc: Remove PCMachineClass::legacy_cpu_hotplug field
  hw/nvram/fw_cfg: Rename fw_cfg_init_mem() with '_nodma' suffix
  hw/mips/loongson3_virt: Prefer using fw_cfg_init_mem_nodma()
  hw/nvram/fw_cfg: Factor fw_cfg_init_mem_internal() out
  hw/nvram/fw_cfg: Rename fw_cfg_init_mem_wide() ->
    fw_cfg_init_mem_dma()
  hw/i386/x86: Remove X86MachineClass::fwcfg_dma_enabled field
  hw/i386/pc: Remove multiboot.bin
  hw/nvram/fw_cfg: Remove fw_cfg_io_properties::dma_enabled
  hw/i386/pc: Remove linuxboot.bin
  hw/i386/pc: Remove pc_compat_2_6[] array
  target/i386/cpu: Remove CPUX86State::enable_cpuid_0xb field
  target/i386/cpu: Remove CPUX86State::fill_mtrr_mask field
  hw/intc/apic: Remove APICCommonState::legacy_instance_id field
  hw/core/machine: Remove hw_compat_2_6[] array
  hw/virtio/virtio-mmio: Remove
    VirtIOMMIOProxy::format_transport_address field
  hw/i386/pc: Remove deprecated pc-q35-2.7 and pc-i440fx-2.7 machines
  hw/i386/pc: Remove pc_compat_2_7[] array
  target/i386/cpu: Remove CPUX86State::full_cpuid_auto_level field
  target/i386/cpu: Remove CPUX86State::enable_l3_cache field
  hw/audio/pcspk: Remove PCSpkState::migrate field
  hw/core/machine: Remove hw_compat_2_7[] array
  hw/i386/intel_iommu: Remove IntelIOMMUState::buggy_eim field
  hw/intc/ioapic: Remove IOAPICCommonState::version field
  hw/virtio/virtio-pci: Remove VirtIOPCIProxy::ignore_backend_features
    field
  hw/char/virtio-serial: Do not expose the 'emergency-write' property
  hw/virtio/virtio-pci: Remove VIRTIO_PCI_FLAG_PAGE_PER_VQ definition

 hw/intc/ioapic_internal.h           |   3 +-
 include/hw/acpi/cpu_hotplug.h       |   3 -
 include/hw/boards.h                 |   6 -
 include/hw/i386/apic_internal.h     |   1 -
 include/hw/i386/intel_iommu.h       |   1 -
 include/hw/i386/pc.h                |   9 --
 include/hw/i386/x86.h               |   2 -
 include/hw/nvram/fw_cfg.h           |   9 +-
 include/hw/virtio/virtio-mmio.h     |   1 -
 include/hw/virtio/virtio-pci.h      |   2 -
 include/hw/virtio/virtio-serial.h   |   2 -
 pc-bios/optionrom/optionrom.h       |   4 -
 target/i386/cpu.h                   |  15 --
 hw/acpi/cpu_hotplug.c               | 230 ---------------------------
 hw/arm/virt.c                       |   2 +-
 hw/audio/pcspk.c                    |  10 --
 hw/char/virtio-serial-bus.c         |   9 +-
 hw/core/machine.c                   |  17 --
 hw/display/virtio-vga.c             |  10 --
 hw/hppa/machine.c                   |   2 +-
 hw/i386/acpi-build.c                |   4 +-
 hw/i386/fw_cfg.c                    |   5 +-
 hw/i386/intel_iommu.c               |   5 +-
 hw/i386/microvm.c                   |   3 -
 hw/i386/multiboot.c                 |   7 +-
 hw/i386/pc.c                        |  22 +--
 hw/i386/pc_piix.c                   |  23 ---
 hw/i386/pc_q35.c                    |  24 ---
 hw/i386/x86-common.c                |   6 +-
 hw/i386/x86.c                       |   2 -
 hw/intc/apic_common.c               |   5 -
 hw/intc/ioapic.c                    |  18 +--
 hw/intc/ioapic_common.c             |   2 +-
 hw/mips/loongson3_virt.c            |   2 +-
 hw/nvram/fw_cfg.c                   |  48 +++---
 hw/riscv/virt.c                     |   4 +-
 hw/virtio/virtio-mmio.c             |  15 --
 hw/virtio/virtio-pci.c              |  12 +-
 target/i386/cpu.c                   | 152 ++++++++----------
 target/i386/kvm/kvm.c               |  10 +-
 tests/qtest/test-x86-cpuid-compat.c |  11 --
 pc-bios/meson.build                 |   2 -
 pc-bios/multiboot.bin               | Bin 1024 -> 0 bytes
 pc-bios/optionrom/Makefile          |   2 +-
 pc-bios/optionrom/linuxboot.S       | 195 -----------------------
 pc-bios/optionrom/multiboot.S       | 232 ---------------------------
 pc-bios/optionrom/multiboot_dma.S   | 234 +++++++++++++++++++++++++++-
 47 files changed, 349 insertions(+), 1034 deletions(-)
 delete mode 100644 pc-bios/multiboot.bin
 delete mode 100644 pc-bios/optionrom/linuxboot.S
 delete mode 100644 pc-bios/optionrom/multiboot.S

-- 
2.47.1


