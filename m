Return-Path: <kvm+bounces-6156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C49E82C5E5
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 20:32:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8C1D3B238D5
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 19:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EEA516429;
	Fri, 12 Jan 2024 19:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HrVLB5sh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C9416419
	for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 19:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705087899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qARUiNn2Jrx1KvihHVdfIiteTOrgQb9MKbdKKhl244M=;
	b=HrVLB5shDNrEeq4NhRWb9vmEkdTTNYyv8RxrBoefv/tkLsJbc28j5+QP88K+cc9mUI6opf
	/9CDP+398/rOBIFuFYWKDEKnb9n+ug2BsXYdQdwsGcF8kMykCEt1l69KhVHYsP89gxe5i6
	7EY9CXr3W8KIq7C3AFd4RhO/E6kQL8o=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-237-yDft8DbJOAGGRU1Kn2_EYA-1; Fri, 12 Jan 2024 14:31:37 -0500
X-MC-Unique: yDft8DbJOAGGRU1Kn2_EYA-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7bee3ad7bcfso395148639f.1
        for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 11:31:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705087897; x=1705692697;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qARUiNn2Jrx1KvihHVdfIiteTOrgQb9MKbdKKhl244M=;
        b=exN5hnR2gCF27kcoiflEvnRiZXh2KuhfLWtYMBjlTvSsX2/LwwDLkapbilAsdIKhrA
         /fCWaIyDA5jIJke6KaHLUPTKG0hb6AmGKMMxp/JrUax8CuPih3shlSyuAS3RKvN65WzR
         p3/OjRWkACf2+zLb9BksZUDkoqXbXV64vffK9O+Ct7ziZzB8WKLqT1tC3OCg3sIfmK2q
         P3X2MTkNSzwot6SEFaJPNhx7w33W8SIOAbOHknn/TB4l4JB01zJleQF2O0VIfzXrQj4V
         z/klHH/tqFJoIDj8pLXPYezG8iKcLa9/50Z7pnm7tfZC6ne16v1NloLaRvJIHLLncWXD
         6nlQ==
X-Gm-Message-State: AOJu0YzEk/XtnKY/RN+LViWqKGRB0TV1mubviP+qJIYPMVWNhHedd45U
	0A4X1lGZnQOf7ZxJoEBFkdMXoIxhG+QjTWFyNOrBsypFVnUerr4xPphq8bpswR6yFBtUmWbmHfa
	ELsE0ldd2eFVGwaXoP3PR
X-Received: by 2002:a6b:e919:0:b0:7bf:2b94:5cc1 with SMTP id u25-20020a6be919000000b007bf2b945cc1mr818547iof.7.1705087896810;
        Fri, 12 Jan 2024 11:31:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEsgUtGzSjQB4EJc5YO3yWNR79/7QpPWBImRh6SQMbd/m8WXcEDug1AZhFYJnmepx/TIhlvjA==
X-Received: by 2002:a6b:e919:0:b0:7bf:2b94:5cc1 with SMTP id u25-20020a6be919000000b007bf2b945cc1mr818538iof.7.1705087896477;
        Fri, 12 Jan 2024 11:31:36 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id a1-20020a0566380b0100b0046d9e290a74sm1045304jab.7.2024.01.12.11.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jan 2024 11:31:35 -0800 (PST)
Date: Fri, 12 Jan 2024 12:31:34 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, mst@redhat.com
Subject: [GIT PULL] VFIO updates for v6.8-rc1
Message-ID: <20240112123134.2deb3896.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit 33cc938e65a98f1d29d0a18403dbbee050dcad9a:

  Linux 6.7-rc4 (2023-12-03 18:52:56 +0900)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.8-rc1

for you to fetch changes up to 78f70c02bdbccb5e9b0b0c728185d4aeb7044ace:

  vfio/virtio: fix virtio-pci dependency (2024-01-10 15:10:41 -0700)

----------------------------------------------------------------
VFIO updates for v6.8-rc1

 - Add debugfs support, initially used for reporting device migration
   state. (Longfang Liu)

 - Fixes and support for migration dirty tracking across multiple IOVA
   regions in the pds-vfio-pci driver. (Brett Creeley)

 - Improved IOMMU allocation accounting visibility. (Pasha Tatashin)

 - Virtio infrastructure and a new virtio-vfio-pci variant driver, which
   provides emulation of a legacy virtio interfaces on modern virtio
   hardware for virtio-net VF devices where the PF driver exposes
   support for legacy admin queues, ie. an emulated IO BAR on an SR-IOV
   VF to provide driver ABI compatibility to legacy devices.
   (Yishai Hadas & Feng Liu)

 - Migration fixes for the hisi-acc-vfio-pci variant driver.
   (Shameer Kolothum)

 - Kconfig dependency fix for new virtio-vfio-pci variant driver.
   (Arnd Bergmann)

----------------------------------------------------------------
Alex Williamson (2):
      Merge branches 'v6.8/vfio/debugfs', 'v6.8/vfio/pds' and 'v6.8/vfio/type1-account' into v6.8/vfio/next
      Merge branch 'v6.8/vfio/virtio' into v6.8/vfio/next

Arnd Bergmann (1):
      vfio/virtio: fix virtio-pci dependency

Brett Creeley (6):
      vfio/pds: Fix calculations in pds_vfio_dirty_sync
      vfio/pds: Only use a single SGL for both seq and ack
      vfio/pds: Move and rename region specific info
      vfio/pds: Pass region info to relevant functions
      vfio/pds: Move seq/ack bitmaps into region struct
      vfio/pds: Add multi-region support

Feng Liu (4):
      virtio: Define feature bit for administration virtqueue
      virtio-pci: Introduce admin virtqueue
      virtio-pci: Introduce admin command sending function
      virtio-pci: Introduce admin commands

Longfang Liu (3):
      vfio/migration: Add debugfs to live migration driver
      Documentation: add debugfs description for vfio
      MAINTAINERS: Add vfio debugfs interface doc link

Pasha Tatashin (1):
      vfio/type1: account iommu allocations

Shameer Kolothum (1):
      hisi_acc_vfio_pci: Update migration data pointer correctly on saving/resume

Yishai Hadas (6):
      virtio-pci: Initialize the supported admin commands
      virtio-pci: Introduce APIs to execute legacy IO admin commands
      vfio/pci: Expose vfio_pci_core_setup_barmap()
      vfio/pci: Expose vfio_pci_core_iowrite/read##size()
      vfio/virtio: Introduce a vfio driver over virtio devices
      vfio/virtio: Declare virtiovf_pci_aer_reset_done() static

 Documentation/ABI/testing/debugfs-vfio         |  25 ++
 MAINTAINERS                                    |   8 +
 drivers/vfio/Kconfig                           |  10 +
 drivers/vfio/Makefile                          |   1 +
 drivers/vfio/debugfs.c                         |  92 ++++
 drivers/vfio/pci/Kconfig                       |   2 +
 drivers/vfio/pci/Makefile                      |   2 +
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c |   7 +-
 drivers/vfio/pci/pds/dirty.c                   | 309 ++++++++-----
 drivers/vfio/pci/pds/dirty.h                   |  18 +-
 drivers/vfio/pci/vfio_pci_rdwr.c               |  57 +--
 drivers/vfio/pci/virtio/Kconfig                |  15 +
 drivers/vfio/pci/virtio/Makefile               |   3 +
 drivers/vfio/pci/virtio/main.c                 | 576 +++++++++++++++++++++++++
 drivers/vfio/vfio.h                            |  14 +
 drivers/vfio/vfio_iommu_type1.c                |   8 +-
 drivers/vfio/vfio_main.c                       |   4 +
 drivers/virtio/Kconfig                         |   5 +
 drivers/virtio/Makefile                        |   1 +
 drivers/virtio/virtio.c                        |  37 +-
 drivers/virtio/virtio_pci_admin_legacy_io.c    | 244 +++++++++++
 drivers/virtio/virtio_pci_common.c             |  14 +
 drivers/virtio/virtio_pci_common.h             |  42 +-
 drivers/virtio/virtio_pci_modern.c             | 259 ++++++++++-
 drivers/virtio/virtio_pci_modern_dev.c         |  24 +-
 include/linux/vfio.h                           |   7 +
 include/linux/vfio_pci_core.h                  |  20 +
 include/linux/virtio.h                         |   8 +
 include/linux/virtio_config.h                  |   4 +
 include/linux/virtio_pci_admin.h               |  23 +
 include/linux/virtio_pci_modern.h              |   2 +
 include/uapi/linux/vfio.h                      |   1 +
 include/uapi/linux/virtio_config.h             |   8 +-
 include/uapi/linux/virtio_pci.h                |  68 +++
 34 files changed, 1754 insertions(+), 164 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-vfio
 create mode 100644 drivers/vfio/debugfs.c
 create mode 100644 drivers/vfio/pci/virtio/Kconfig
 create mode 100644 drivers/vfio/pci/virtio/Makefile
 create mode 100644 drivers/vfio/pci/virtio/main.c
 create mode 100644 drivers/virtio/virtio_pci_admin_legacy_io.c
 create mode 100644 include/linux/virtio_pci_admin.h


