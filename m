Return-Path: <kvm+bounces-5873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 97421827FE1
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 08:58:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 26B56B255E9
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 07:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEB872D63A;
	Tue,  9 Jan 2024 07:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Me4pfJh6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6BEB66B;
	Tue,  9 Jan 2024 07:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DBCAC433C7;
	Tue,  9 Jan 2024 07:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704787056;
	bh=VLDneZLA6cAnWxtoG7KbCxm8KweXPrrQ2Mn6Ofb6MR8=;
	h=From:To:Cc:Subject:Date:From;
	b=Me4pfJh6dlkcobjt6Eefwwv0CZqzwIrWh7igIV5Wxk1VrgKQ0L3y2cd3e2iJibOky
	 w9bIh2oR9cNnIfumWNhOf5GgJyXoFI7NpSALoLeM24wc9ZAAqpPNUMceKug/BANQEO
	 QY+E+Up/zXp11/IStSHvYzSDlaNCI9aX2TQXo/KsiF6UgM1tlBzqYjFMVNMjaq9w8a
	 XOFazkm9TgNWSD06qM5FsLAvm2iCG76aS0fG01Gs82wWG7K0GiiDbmEAvmWgwJgsz4
	 yhbOC2FDCE6Ch8UrSIaOWGbB8Au5fQcsineQXjTsrjz3txvMELmdrK6b6n1lMurQ0L
	 vgx248eNSPm+w==
From: Arnd Bergmann <arnd@kernel.org>
To: Yishai Hadas <yishaih@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] vfio: fix virtio-pci dependency
Date: Tue,  9 Jan 2024 08:57:19 +0100
Message-Id: <20240109075731.2726731-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The new vfio-virtio driver already has a dependency on VIRTIO_PCI_ADMIN_LEGACY,
but that is a bool symbol and allows vfio-virtio to be built-in even if
virtio-pci itself is a loadable module. This leads to a link failure:

aarch64-linux-ld: drivers/vfio/pci/virtio/main.o: in function `virtiovf_pci_probe':
main.c:(.text+0xec): undefined reference to `virtio_pci_admin_has_legacy_io'
aarch64-linux-ld: drivers/vfio/pci/virtio/main.o: in function `virtiovf_pci_init_device':
main.c:(.text+0x260): undefined reference to `virtio_pci_admin_legacy_io_notify_info'
aarch64-linux-ld: drivers/vfio/pci/virtio/main.o: in function `virtiovf_pci_bar0_rw':
main.c:(.text+0x6ec): undefined reference to `virtio_pci_admin_legacy_common_io_read'
aarch64-linux-ld: main.c:(.text+0x6f4): undefined reference to `virtio_pci_admin_legacy_device_io_read'
aarch64-linux-ld: main.c:(.text+0x7f0): undefined reference to `virtio_pci_admin_legacy_common_io_write'
aarch64-linux-ld: main.c:(.text+0x7f8): undefined reference to `virtio_pci_admin_legacy_device_io_write'

Add another explicit dependency on the tristate symbol.

Fixes: eb61eca0e8c3 ("vfio/virtio: Introduce a vfio driver over virtio devices")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/vfio/pci/virtio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/virtio/Kconfig b/drivers/vfio/pci/virtio/Kconfig
index fc3a0be9d8d4..bd80eca4a196 100644
--- a/drivers/vfio/pci/virtio/Kconfig
+++ b/drivers/vfio/pci/virtio/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config VIRTIO_VFIO_PCI
         tristate "VFIO support for VIRTIO NET PCI devices"
-        depends on VIRTIO_PCI_ADMIN_LEGACY
+        depends on VIRTIO_PCI && VIRTIO_PCI_ADMIN_LEGACY
         select VFIO_PCI_CORE
         help
           This provides support for exposing VIRTIO NET VF devices which support
-- 
2.39.2


