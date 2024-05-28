Return-Path: <kvm+bounces-18207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AD5F8D1A9E
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 14:05:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99E8B1C229E1
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 12:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A0EF16D337;
	Tue, 28 May 2024 12:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PUP6VGm6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9EA13A242;
	Tue, 28 May 2024 12:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716897907; cv=none; b=H0ONgQwBUWqKzkbmeNr64661JocWHgNIrKJXPQTlxLVqmhzJVvZTlzTe8HIG0czVqgBEJvQRXAXuCLFvZ3T86g6jpO3GY20uGaLiPMYpDZv0ain29l4OxVq8DfZ/dASICvIzP9AYtVUEt8U6ZWpvwW44hTo1ZJltGyORVRXAdcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716897907; c=relaxed/simple;
	bh=kaLuOjRkFqL42ZSISeMz90mU9RorzMOLwIkOwYEXp60=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=s5Szbu8Boe0xvIK5RGf7kekNt17WxAas+FAiEWVwiL4VeAlATp/sCubZwKzQI14KRiHuKJZn1Fy60A8AJetlcw87UGw6eV/9gQZvufgORAVpNekfB4WoliEz23FEwLBPjj5GihvxlxePVzsgUCsT+7c2OQt6oYmeTIo8h9TYn2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PUP6VGm6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8677AC3277B;
	Tue, 28 May 2024 12:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716897907;
	bh=kaLuOjRkFqL42ZSISeMz90mU9RorzMOLwIkOwYEXp60=;
	h=From:To:Cc:Subject:Date:From;
	b=PUP6VGm6Xn06TXAJ4XKsjNQZ+80X2eGoXUsCYdeFrF6spfAMMcRq6RtmWr8yRzyCc
	 aMvXu9qy7V9UYerjK/E8ZdiskIbiuZ13jWQVK1rWCNYUkYWMnNqW7Ax03/TKA1V5BE
	 zOgtOE7eNJKfryKtKApRvDRDu8ZJPNXmZLtUyFMom8D1/DIXzsoytEC4lyhBvP05Mj
	 O9JM0y+/gOYU45AE7Y2BU+3RLiEAygpLkEyZXi+Uwk2bMGzA+HuX4ouo/8mZjwcdF2
	 ucoYYPxJ+n5xymccDEyd0ZiwMfRqbFvgr9IhjCdR4M+BP/Nphs1S03GVgv0j8wQ1Jt
	 Av3KHZo905xTg==
From: Arnd Bergmann <arnd@kernel.org>
To: Xin Zeng <xin.zeng@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Yahui Cao <yahui.cao@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	kvm@vger.kernel.org,
	qat-linux@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] vfio/qat: add PCI_IOV dependency
Date: Tue, 28 May 2024 14:04:55 +0200
Message-Id: <20240528120501.3382554-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The newly added driver depends on the crypto driver, but it uses exported
symbols that are only available when IOV is also turned on:

x86_64-linux-ld: drivers/vfio/pci/qat/main.o: in function `qat_vf_pci_open_device':
main.c:(.text+0xd7): undefined reference to `qat_vfmig_open'
x86_64-linux-ld: drivers/vfio/pci/qat/main.o: in function `qat_vf_pci_release_dev':
main.c:(.text+0x122): undefined reference to `qat_vfmig_cleanup'
x86_64-linux-ld: main.c:(.text+0x12d): undefined reference to `qat_vfmig_destroy'
x86_64-linux-ld: drivers/vfio/pci/qat/main.o: in function `qat_vf_resume_write':
main.c:(.text+0x308): undefined reference to `qat_vfmig_load_setup'
x86_64-linux-ld: drivers/vfio/pci/qat/main.o: in function `qat_vf_save_device_data':
main.c:(.text+0x64c): undefined reference to `qat_vfmig_save_state'
x86_64-linux-ld: main.c:(.text+0x677): undefined reference to `qat_vfmig_save_setup'
x86_64-linux-ld: drivers/vfio/pci/qat/main.o: in function `qat_vf_pci_aer_reset_done':
main.c:(.text+0x82d): undefined reference to `qat_vfmig_reset'
x86_64-linux-ld: drivers/vfio/pci/qat/main.o: in function `qat_vf_pci_close_device':
main.c:(.text+0x862): undefined reference to `qat_vfmig_close'
x86_64-linux-ld: drivers/vfio/pci/qat/main.o: in function `qat_vf_pci_set_device_state':
main.c:(.text+0x9af): undefined reference to `qat_vfmig_suspend'
x86_64-linux-ld: main.c:(.text+0xa14): undefined reference to `qat_vfmig_save_state'
x86_64-linux-ld: main.c:(.text+0xb37): undefined reference to `qat_vfmig_resume'
x86_64-linux-ld: main.c:(.text+0xbc7): undefined reference to `qat_vfmig_load_state'

Add this as a second dependency.

Fixes: bb208810b1ab ("vfio/qat: Add vfio_pci driver for Intel QAT SR-IOV VF devices")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/vfio/pci/qat/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/qat/Kconfig b/drivers/vfio/pci/qat/Kconfig
index bf52cfa4b595..fae9d6cb8ccb 100644
--- a/drivers/vfio/pci/qat/Kconfig
+++ b/drivers/vfio/pci/qat/Kconfig
@@ -1,8 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config QAT_VFIO_PCI
 	tristate "VFIO support for QAT VF PCI devices"
-	select VFIO_PCI_CORE
 	depends on CRYPTO_DEV_QAT_4XXX
+	depends on PCI_IOV
+	select VFIO_PCI_CORE
 	help
 	  This provides migration support for Intel(R) QAT Virtual Function
 	  using the VFIO framework.
-- 
2.39.2


