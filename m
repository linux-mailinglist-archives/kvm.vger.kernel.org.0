Return-Path: <kvm+bounces-59220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A76B2BAE54A
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 20:42:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 175FC1944E0C
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:43:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B6FB267F58;
	Tue, 30 Sep 2025 18:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="euVuJ7Iw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13A624EAB1
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 18:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759257761; cv=none; b=DYtU0k28y3NtQGpxRqQyf5x7XlYpodvmhKBuFtP5oZ40/D3ocWyvSzDHro5Khql81INFae1LUf+j3Wx1RbY/jwmlxh2oOqIiE6xCiAOGpfbgGC7NqUkUJ21AI1gLpGHLYszCat8Lxk87xGHvxPEcfnFbFpKufdzvTzGvBPWvqKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759257761; c=relaxed/simple;
	bh=aVWVURhii6qBrIwK+bR3pj92fwrHdTqPFet1/u8qBEc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=Hs4I24fTrCGfJ+0t5Dn70tseVU6szhACDGvHfp6HnC61LIBXKPcwXEHg7xDr0qRu0RPxxmqvBqdUSYiOwQWs4lxeon3MD2iw35ASlV3EnLx+9xqAempMN7nBX/w5eOjxTbLtWEH41Wn6+/oU3e8Eh9ttasGp9NWOIkI4GlTTI5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=euVuJ7Iw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759257748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=x6hlcVbvRzzKhW3YzhPC1SyaWRJSa9WcOx8faDw3Dvk=;
	b=euVuJ7Iw5C+k7dEphvKcUqTS66NPvQmGkweZesb8SfRhdsBHmBPIXwrLeqpb/7BYTLS9tY
	sb9OoMceXZbbxJFjnnx9xn6nIsuNxyPSBqi7BAhQ7iIPh7PQ1ajCLsla/YtB8azqM8Xek5
	BgIBuIfenhtBfzQSA9XJYAqyVwYVOio=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-4jgCrF-ZNIK8Rvqzz0dPbA-1; Tue, 30 Sep 2025 14:42:26 -0400
X-MC-Unique: 4jgCrF-ZNIK8Rvqzz0dPbA-1
X-Mimecast-MFC-AGG-ID: 4jgCrF-ZNIK8Rvqzz0dPbA_1759257746
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-427350656e3so8840515ab.1
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 11:42:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759257745; x=1759862545;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x6hlcVbvRzzKhW3YzhPC1SyaWRJSa9WcOx8faDw3Dvk=;
        b=vK5JhVW69rFBoCoghzHIVjYAvN+sYTeH99XTj35M6Z0TlrhW8YVYrOI0aFAvJbhBAd
         10SHuNdt4Y1H82L6U/76RckmQO2CmlbvVFTEXkGOU6OzWhJ88NR/S8vcbknSF7vxvi3F
         3B/uahBMs/K+F3kvi8cyOyRSemvi1NJrMJ0G+UT4VGM0EgdvjHLn6qnRjBM7Rb8GrSiA
         FW+e9siD1KWcClZWhDOT7ogUcO3OBRZt3zkwnmdP4Gx5jFJkIkIwY8+xfL15+maCk8NA
         DOYc+puDzDnUEDzM7IHzFJ8ZDBRhgTwLWJdyLHDiI5ZYAqZdOPtJWmBNFqEM0ok/jA9r
         id/w==
X-Forwarded-Encrypted: i=1; AJvYcCXssR5nQyqCpbuyAtLYMTJXPiHqiNy5+UV8QHWi0GSgLO6U/rddn1no6Qd66dbjLEyGQkU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMzDytFrUArpbw2syT+oeJLwiD6W0WV9c19TGX+1cwt28vyMMr
	xXU//C59X4UvEqZLY3m4oOtu3u9r65I3ah0nnlY0hW7ekazB7/+VujJhc/Dmfzo1vHGfGwN77/Q
	wR7/27xASwEcD67Vc8NrrnnStaWGw9wrUGR9EIa5h2zUTETt28w6ER3SqmI9Sgw==
X-Gm-Gg: ASbGncvWxS3wbUvuJ0SrdFoxWjNNHETL2bM0UX9M3Y6jm65IfhtdR+2wXFP5/e4azrR
	BxFrVR+uLZlyNuvayOONglVvuHDEJT4Vgiovu8zMri/ZhiqechEXwaSeK/i09hnmNErz4Q/eM4c
	O856tvPA5FePSaRn7G9kkyRmxguN+hOqObEUA5jDEZJrx+nH5jWe5d6vwyQwlX0lX46dTV8ao8Z
	YCH/i0hfdLZJ5dWvqBpnRqpI/NbyF9ayiOIOjeoTxsDFxa643/6bShOA6x+dpetAkM5Sa6OF3Wz
	J6F9RFJ9+j9obgfE8hLIhfjHxyRFQaWsoPkTz374+mvBAfRv
X-Received: by 2002:a05:6e02:1a86:b0:423:fcd6:549e with SMTP id e9e14a558f8ab-42d81632973mr5896365ab.7.1759257745069;
        Tue, 30 Sep 2025 11:42:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFy1hxkRNTtZx8e+QGHUmQrk20UQiCzg7Pz4dXbjRyqOCvglQxBciKjkUUeA8UDvyuA8k/elg==
X-Received: by 2002:a05:6e02:1a86:b0:423:fcd6:549e with SMTP id e9e14a558f8ab-42d81632973mr5896245ab.7.1759257744575;
        Tue, 30 Sep 2025 11:42:24 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-56a6ae6ec63sm6130670173.73.2025.09.30.11.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 11:42:23 -0700 (PDT)
Date: Tue, 30 Sep 2025 12:42:21 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v6.18-rc1
Message-ID: <20250930124221.39523455.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit 1b237f190eb3d36f52dffe07a40b5eb210280e00:

  Linux 6.17-rc3 (2025-08-24 12:04:12 -0400)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.18-rc1

for you to fetch changes up to 407aa63018d15c35a34938633868e61174d2ef6e:

  vfio/nvgrace-gpu: Add GB300 SKU to the devid table (2025-09-26 08:38:05 -0600)

----------------------------------------------------------------
VFIO updates for v6.18-rc1

 - Use fdinfo to expose the sysfs path of a device represented by a
   vfio device file. (Alex Mastro)

 - Mark vfio-fsl-mc, vfio-amba, and the reset functions for
   vfio-platform for removal as these are either orphaned or believed
   to be unused. (Alex Williamson)

 - Add reviewers for vfio-platform to save it from also being marked
   for removal. (Mostafa Saleh, Pranjal Shrivastava)

 - VFIO selftests, including basic sanity testing and minimal userspace
   drivers for testing against real hardware.  This is also expected to
   provide integration with KVM selftests for KVM-VFIO interfaces.
   (David Matlack, Josh Hilke)

 - Fix drivers/cdx and vfio/cdx to build without CONFIG_GENERIC_MSI_IRQ.
   (Nipun Gupta)

 - Fix reference leak in hisi_acc. (Miaoqian Lin)

 - Use consistent return for unsupported device feature. (Alex Mastro)

 - Unwind using the correct memory free callback in vfio/pds.
   (Zilin Guan)

 - Use IRQ_DISABLE_LAZY flag to improve handling of pre-PCI2.3 INTx
   and resolve stalled interrupt on ppc64. (Timothy Pearson)

 - Enable GB300 in nvgrace-gpu vfio-pci variant driver. (Tushar Dave)

 - Misc:
   - Drop unnecessary ternary conversion in vfio/pci. (Xichao Zhao)
   - Grammatical fix in nvgrace-gpu. (Morduan Zang)
   - Update Shameer's email address. (Shameer Kolothum)
   - Fix document build warning. (Alex Williamson)

----------------------------------------------------------------
Alex Mastro (2):
      vfio/pci: print vfio-device syspath to fdinfo
      vfio: return -ENOTTY for unsupported device feature

Alex Williamson (4):
      vfio/fsl-mc: Mark for removal
      docs: proc.rst: Fix VFIO Device title formatting
      vfio/amba: Mark for removal
      vfio/platform: Mark reset drivers for removal

David Matlack (26):
      selftests: Create tools/testing/selftests/vfio
      vfio: selftests: Add a helper library for VFIO selftests
      vfio: selftests: Introduce vfio_pci_device_test
      vfio: selftests: Keep track of DMA regions mapped into the device
      vfio: selftests: Enable asserting MSI eventfds not firing
      vfio: selftests: Add a helper for matching vendor+device IDs
      vfio: selftests: Add driver framework
      vfio: sefltests: Add vfio_pci_driver_test
      tools headers: Add stub definition for __iomem
      tools headers: Import asm-generic MMIO helpers
      tools headers: Import x86 MMIO helper overrides
      tools headers: Add symlink to linux/pci_ids.h
      dmaengine: ioat: Move system_has_dca_enabled() to dma.h
      vfio: selftests: Add driver for Intel CBDMA
      tools headers: Import iosubmit_cmds512()
      dmaengine: idxd: Allow registers.h to be included from tools/
      vfio: selftests: Add driver for Intel DSA
      vfio: selftests: Move helper to get cdev path to libvfio
      vfio: selftests: Encapsulate IOMMU mode
      vfio: selftests: Replicate tests across all iommu_modes
      vfio: selftests: Add vfio_type1v2_mode
      vfio: selftests: Add iommufd_compat_type1{,v2} modes
      vfio: selftests: Add iommufd mode
      vfio: selftests: Make iommufd the default iommu_mode
      vfio: selftests: Add a script to help with running VFIO selftests
      vfio: selftests: Fix .gitignore for already tracked files

Josh Hilke (5):
      vfio: selftests: Test basic VFIO and IOMMUFD integration
      vfio: selftests: Move vfio dma mapping test to their own file
      vfio: selftests: Add test to reset vfio device.
      vfio: selftests: Add DMA mapping tests for 2M and 1G HugeTLB
      vfio: selftests: Validate 2M/1G HugeTLB are mapped as 2M/1G in IOMMU

Miaoqian Lin (1):
      hisi_acc_vfio_pci: Fix reference leak in hisi_acc_vfio_debug_init

Morduan Zang (1):
      vfio/nvgrace-gpu: fix grammatical error

Mostafa Saleh (1):
      MAINTAINERS: Add myself as VFIO-platform reviewer

Nipun Gupta (2):
      cdx: don't select CONFIG_GENERIC_MSI_IRQ
      vfio/cdx: update driver to build without CONFIG_GENERIC_MSI_IRQ

Pranjal Shrivastava (1):
      MAINTAINERS: Add myself as VFIO-platform reviewer

Shameer Kolothum (1):
      MAINTAINERS: Update Shameer Kolothum's email address

Timothy Pearson (1):
      vfio/pci: Fix INTx handling on legacy non-PCI 2.3 devices

Tushar Dave (1):
      vfio/nvgrace-gpu: Add GB300 SKU to the devid table

Xichao Zhao (1):
      vfio/pci: drop redundant conversion to bool

Zilin Guan (1):
      vfio/pds: replace bitmap_free with vfree

 .mailmap                                           |   1 +
 Documentation/filesystems/proc.rst                 |  14 +
 MAINTAINERS                                        |  14 +-
 drivers/cdx/Kconfig                                |   1 -
 drivers/cdx/cdx.c                                  |   4 +-
 drivers/cdx/controller/Kconfig                     |   1 -
 drivers/cdx/controller/cdx_controller.c            |   3 +-
 drivers/dma/idxd/registers.h                       |   4 +
 drivers/dma/ioat/dma.h                             |   2 +
 drivers/dma/ioat/hw.h                              |   3 -
 drivers/vfio/cdx/Makefile                          |   6 +-
 drivers/vfio/cdx/private.h                         |  14 +
 drivers/vfio/fsl-mc/Kconfig                        |   5 +-
 drivers/vfio/fsl-mc/vfio_fsl_mc.c                  |   2 +
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c     |   6 +-
 drivers/vfio/pci/nvgrace-gpu/main.c                |   4 +-
 drivers/vfio/pci/pds/dirty.c                       |   2 +-
 drivers/vfio/pci/vfio_pci_intrs.c                  |   9 +-
 drivers/vfio/platform/Kconfig                      |   5 +-
 drivers/vfio/platform/reset/Kconfig                |   6 +-
 .../vfio/platform/reset/vfio_platform_amdxgbe.c    |   2 +
 .../vfio/platform/reset/vfio_platform_bcmflexrm.c  |   2 +
 .../platform/reset/vfio_platform_calxedaxgmac.c    |   2 +
 drivers/vfio/platform/vfio_amba.c                  |   2 +
 drivers/vfio/vfio_main.c                           |  22 +-
 tools/arch/x86/include/asm/io.h                    | 101 ++++
 tools/arch/x86/include/asm/special_insns.h         |  27 +
 tools/include/asm-generic/io.h                     | 482 +++++++++++++++++
 tools/include/asm/io.h                             |  11 +
 tools/include/linux/compiler.h                     |   4 +
 tools/include/linux/io.h                           |   4 +-
 tools/include/linux/pci_ids.h                      |   1 +
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/vfio/.gitignore            |  10 +
 tools/testing/selftests/vfio/Makefile              |  21 +
 tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c | 416 +++++++++++++++
 .../selftests/vfio/lib/drivers/dsa/registers.h     |   1 +
 tools/testing/selftests/vfio/lib/drivers/ioat/hw.h |   1 +
 .../testing/selftests/vfio/lib/drivers/ioat/ioat.c | 235 ++++++++
 .../selftests/vfio/lib/drivers/ioat/registers.h    |   1 +
 .../testing/selftests/vfio/lib/include/vfio_util.h | 295 ++++++++++
 tools/testing/selftests/vfio/lib/libvfio.mk        |  24 +
 tools/testing/selftests/vfio/lib/vfio_pci_device.c | 594 +++++++++++++++++++++
 tools/testing/selftests/vfio/lib/vfio_pci_driver.c | 126 +++++
 tools/testing/selftests/vfio/run.sh                | 109 ++++
 .../testing/selftests/vfio/vfio_dma_mapping_test.c | 199 +++++++
 .../selftests/vfio/vfio_iommufd_setup_test.c       | 127 +++++
 .../testing/selftests/vfio/vfio_pci_device_test.c  | 176 ++++++
 .../testing/selftests/vfio/vfio_pci_driver_test.c  | 244 +++++++++
 49 files changed, 3323 insertions(+), 23 deletions(-)
 create mode 100644 tools/arch/x86/include/asm/io.h
 create mode 100644 tools/arch/x86/include/asm/special_insns.h
 create mode 100644 tools/include/asm-generic/io.h
 create mode 100644 tools/include/asm/io.h
 create mode 120000 tools/include/linux/pci_ids.h
 create mode 100644 tools/testing/selftests/vfio/.gitignore
 create mode 100644 tools/testing/selftests/vfio/Makefile
 create mode 100644 tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c
 create mode 120000 tools/testing/selftests/vfio/lib/drivers/dsa/registers.h
 create mode 120000 tools/testing/selftests/vfio/lib/drivers/ioat/hw.h
 create mode 100644 tools/testing/selftests/vfio/lib/drivers/ioat/ioat.c
 create mode 120000 tools/testing/selftests/vfio/lib/drivers/ioat/registers.h
 create mode 100644 tools/testing/selftests/vfio/lib/include/vfio_util.h
 create mode 100644 tools/testing/selftests/vfio/lib/libvfio.mk
 create mode 100644 tools/testing/selftests/vfio/lib/vfio_pci_device.c
 create mode 100644 tools/testing/selftests/vfio/lib/vfio_pci_driver.c
 create mode 100755 tools/testing/selftests/vfio/run.sh
 create mode 100644 tools/testing/selftests/vfio/vfio_dma_mapping_test.c
 create mode 100644 tools/testing/selftests/vfio/vfio_iommufd_setup_test.c
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_device_test.c
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_driver_test.c


