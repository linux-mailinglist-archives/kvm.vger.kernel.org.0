Return-Path: <kvm+bounces-14849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 411898A7402
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 20:59:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 647531C20BF0
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 18:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A088F137753;
	Tue, 16 Apr 2024 18:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Oe9H5i+2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED08A13777B
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 18:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713293986; cv=none; b=l9rYOwOi8MwqfrJX5UpYtmODb2d4uD096tH04ccxeAWljhqLeWt7+yOpBq7h2+LOM03OjoRYK3PY9Y/VoEK9gJZINIpOaipmf6bTgIRSl+XAgA6zQKALjfpAH2xoPw3TH8MC98njj8bFS2rApbM0vhfS2mTr9EYj/K08aHkidT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713293986; c=relaxed/simple;
	bh=7jFfiDFd9XUUKcfd5FBvcwlsdJXRyEr3uHdkC2o423s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XzhmwiaOfeYzpXd9bKUVWESGjVuvfA4ChO7jxQ5a9kC0WEr2vyFqvHXSP78Q14Lw7RhJyPumk/UVUEF+xj125+YZPaTF1YzY4e42iyVTbQeRSf29CXt0VpIu6RIc9SohNpaoOz6yk5NBAZdPsuLlMROvdUtjUmqy8v0kc49qYbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Oe9H5i+2; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a5252e5aa01so447383966b.1
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 11:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713293983; x=1713898783; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aKI7O+b3Bo+xsao49zshX9B958w9RaU2PXoPe3/rS/I=;
        b=Oe9H5i+2TxHxYX2ODYCY5I14LwDIGm8U9FRiWtpMKLTMRXTSsatvkVfGytrOqeRBWp
         3ZMAlnRPQj5IFgHYt8DknZ+5IzE+3NCZYyszH4dfqfsKXyJSM/BR+8ZxsIo9OUEMJVEE
         Wrmo+cQfX+RqQe5EEeqV2CalcLzYPfKeI9C5KR4qngNh/fL4umKUgA8SEueXsIeN4P+d
         17zkzBBU5LLjy/G6DJnVqDw2hFpfDgjL2ONBMuuAVFJ2oKgL8gz5GMh0zMRWA2X/dotA
         KLMIA/M8KAqEkoqUAsWtZ0dm8t+L0etkiLdO82a0fpADXRfyGw4I0MXsD/E2jPqES7ZI
         EQew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713293983; x=1713898783;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aKI7O+b3Bo+xsao49zshX9B958w9RaU2PXoPe3/rS/I=;
        b=V/+EV8Y03J2B8yiJIAxrWnXrnFKjjob6izjtBnufn/mNOSMQP2c3riT5gqXDPn55oV
         XYYpnAnavl6TWYAGmW04oYPNttDrjTo0ZyItHsi8Mi6InVNSLo9SxpQqoP3P0KPyCYg5
         VXHBxhhCP3eue03aAeh5VhvuYvtiA0JnP5OYvTBlgr2KqsQ7Ag6vG04M3o2AnApRZYUo
         sDbuQeLt8KuW7WzWEuzdTcOtM170eZJQ+MtiNCvuXr/Ejlds175NcU1V/SG4T/kG7k8o
         m/MJKPyWX73QV+d+93HzS8DXudaRcRANvqtB7fv3EU0vSaOgNSdDeaf8i0wJOpFOPuuU
         5Hzw==
X-Forwarded-Encrypted: i=1; AJvYcCXZs/mD3MpgYMjJEwZAV737RgUlRPGe1wc84so+EzbtTcE9xTLPICSwdlsYxlxSLfxGoJvdyPajHLdorbJ6XxrUz3Bv
X-Gm-Message-State: AOJu0YwyY2a1hM3Lm7yHo6nLBbVfPt1S5UxFX3JF5imB6IBkB8ZqDNgu
	npZ4kQG3flvzA8NuYYGAd2PyHUZ18JLVwRi7clTPoGeA6NjVynM3I/HApQtaDKI=
X-Google-Smtp-Source: AGHT+IFKgUSVsIVRMT5nMr3cABObk1lQpiHZ360coDmul5EDy1HnpHZOBxGQZGiixLiic7I+g4y/cA==
X-Received: by 2002:a17:906:794e:b0:a4e:904:3c7f with SMTP id l14-20020a170906794e00b00a4e09043c7fmr11383890ejo.50.1713293983216;
        Tue, 16 Apr 2024 11:59:43 -0700 (PDT)
Received: from m1x-phil.lan ([176.176.155.61])
        by smtp.gmail.com with ESMTPSA id jw9-20020a170906e94900b00a52241b823esm6940165ejb.109.2024.04.16.11.59.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Apr 2024 11:59:42 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Thomas Huth <thuth@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?unknown-8bit?q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v4 00/22] hw/i386: Remove deprecated pc-i440fx-2.0 -> 2.3 machines
Date: Tue, 16 Apr 2024 20:59:16 +0200
Message-ID: <20240416185939.37984-1-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Series fully reviewed.

Since v3:
- Deprecate up to 2.12 (Thomas)

Since v2:
- Addressed Zhao review comments

Since v1:
- Addressed Zhao and Thomas review comments

Kill legacy code, because we need to evolve.

I ended there via dynamic machine -> ICH9 -> legacy ACPI...

This should also help Igor cleanups:
http://lore.kernel.org/qemu-devel/20240326171632.3cc7533d@imammedo.users.ipa.redhat.com/

Philippe Mathieu-Daudé (22):
  hw/i386/pc: Deprecate 2.4 to 2.12 pc-i440fx machines
  hw/i386/pc: Remove deprecated pc-i440fx-2.0 machine
  hw/usb/hcd-xhci: Remove XHCI_FLAG_FORCE_PCIE_ENDCAP flag
  hw/usb/hcd-xhci: Remove XHCI_FLAG_SS_FIRST flag
  hw/i386/acpi: Remove PCMachineClass::legacy_acpi_table_size
  hw/acpi/ich9: Remove 'memory-hotplug-support' property
  hw/acpi/ich9: Remove dead code related to 'acpi_memory_hotplug'
  hw/i386/pc: Remove deprecated pc-i440fx-2.1 machine
  target/i386/kvm: Remove x86_cpu_change_kvm_default() and 'kvm-cpu.h'
  hw/i386/pc: Remove PCMachineClass::smbios_uuid_encoded
  hw/smbios: Remove 'uuid_encoded' argument from smbios_set_defaults()
  hw/smbios: Remove 'smbios_uuid_encoded', simplify smbios_encode_uuid()
  hw/i386/pc: Remove PCMachineClass::enforce_aligned_dimm
  hw/mem/pc-dimm: Remove legacy_align argument from pc_dimm_pre_plug()
  hw/mem/memory-device: Remove legacy_align from
    memory_device_pre_plug()
  hw/i386/pc: Remove deprecated pc-i440fx-2.2 machine
  hw/i386/pc: Remove PCMachineClass::resizable_acpi_blob
  hw/i386/pc: Remove PCMachineClass::rsdp_in_ram
  hw/i386/acpi: Remove AcpiBuildState::rsdp field
  hw/i386/pc: Remove deprecated pc-i440fx-2.3 machine
  target/i386: Remove X86CPU::kvm_no_smi_migration field
  hw/i386/pc: Replace PCMachineClass::acpi_data_size by
    PC_ACPI_DATA_SIZE

 docs/about/deprecated.rst             |   4 +-
 docs/about/removed-features.rst       |   2 +-
 hw/usb/hcd-xhci.h                     |   4 +-
 include/hw/firmware/smbios.h          |   3 +-
 include/hw/i386/pc.h                  |  22 ------
 include/hw/mem/memory-device.h        |   2 +-
 include/hw/mem/pc-dimm.h              |   3 +-
 target/i386/cpu.h                     |   3 -
 target/i386/kvm/kvm-cpu.h             |  41 ----------
 hw/acpi/ich9.c                        |  46 ++---------
 hw/arm/virt.c                         |   5 +-
 hw/i386/acpi-build.c                  |  95 ++---------------------
 hw/i386/fw_cfg.c                      |   3 +-
 hw/i386/pc.c                          | 107 ++++----------------------
 hw/i386/pc_piix.c                     | 102 +-----------------------
 hw/loongarch/virt.c                   |   4 +-
 hw/mem/memory-device.c                |  12 +--
 hw/mem/pc-dimm.c                      |   6 +-
 hw/ppc/spapr.c                        |   2 +-
 hw/riscv/virt.c                       |   2 +-
 hw/smbios/smbios.c                    |  13 +---
 hw/usb/hcd-xhci-nec.c                 |   4 -
 hw/usb/hcd-xhci-pci.c                 |   4 +-
 hw/usb/hcd-xhci.c                     |  42 ++--------
 hw/virtio/virtio-md-pci.c             |   2 +-
 target/i386/cpu.c                     |   2 -
 target/i386/kvm/kvm-cpu.c             |   3 +-
 target/i386/kvm/kvm.c                 |   7 +-
 tests/avocado/mem-addr-space-check.py |   9 +--
 29 files changed, 69 insertions(+), 485 deletions(-)
 delete mode 100644 target/i386/kvm/kvm-cpu.h

-- 
2.41.0


