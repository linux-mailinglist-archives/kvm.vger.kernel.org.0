Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6943E2109FA
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 13:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbgGALDd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 07:03:33 -0400
Received: from mga17.intel.com ([192.55.52.151]:29868 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729791AbgGALDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 07:03:33 -0400
IronPort-SDR: 2KqFDk3XRgZZlWr61S3xgu2aN9/+ilol8Xfm45FnCb6JU/aW/uuyq08BbmzK4dw4x987i5G6rZ
 YLTjJLPHKwCQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9668"; a="126632412"
X-IronPort-AV: E=Sophos;i="5.75,300,1589266800"; 
   d="scan'208";a="126632412"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 04:03:31 -0700
IronPort-SDR: 2roBXaX2pEJg+CrG0EZQp8eMiOVysvZQbG2RrwkA6aPyCwIKeHyrtluTkyGoM5ZMVduqaSFC4U
 OwssjGD6tfAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,300,1589266800"; 
   d="scan'208";a="425557243"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga004.jf.intel.com with ESMTP; 01 Jul 2020 04:03:27 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     alex.williamson@redhat.com, herbert@gondor.apana.org.au
Cc:     cohuck@redhat.com, nhorman@redhat.com, vdronov@redhat.com,
        bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 0/5] vfio/pci: add blocklist and disable qat
Date:   Wed,  1 Jul 2020 12:02:57 +0100
Message-Id: <20200701110302.75199-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset defines a blocklist of devices in the vfio-pci module and adds
the current generation of Intel(R) QuickAssist devices to it as they are
not designed to run in an untrusted environment.

By default, if a device is in the blocklist, the probe of vfio-pci fails.
If a user wants to use a device in the blocklist, he needs to disable the
full blocklist providing the option disable_blocklist=1 at the load of
vfio-pci or specifying that parameter in a config file in /etc/modprobe.d.

This series also moves the device ids definitions present in the qat driver
to linux/pci_ids.h since they will be shared between the vfio-pci and the qat
drivers and replaces the custom ADF_SYSTEM_DEVICE macro with PCI_VDEVICE.

The series is applicable to Herbert's tree but only partially applicable to
Alex's tree due to a merge conflict.

Giovanni Cabiddu (5):
  PCI: add Intel QuickAssist device IDs
  vfio/pci: add device blocklist
  vfio/pci: add qat devices to blocklist
  crypto: qat - replace device ids defines
  crypto: qat - use PCI_VDEVICE

 drivers/crypto/qat/qat_c3xxx/adf_drv.c        | 11 ++---
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c      | 11 ++---
 drivers/crypto/qat/qat_c62x/adf_drv.c         | 11 ++---
 drivers/crypto/qat/qat_c62xvf/adf_drv.c       | 11 ++---
 .../crypto/qat/qat_common/adf_accel_devices.h |  6 ---
 drivers/crypto/qat/qat_common/qat_hal.c       |  7 +--
 drivers/crypto/qat/qat_common/qat_uclo.c      |  9 ++--
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c     | 11 ++---
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c   | 11 ++---
 drivers/vfio/pci/vfio_pci.c                   | 48 +++++++++++++++++++
 include/linux/pci_ids.h                       |  6 +++
 11 files changed, 87 insertions(+), 55 deletions(-)

-- 
2.26.2

