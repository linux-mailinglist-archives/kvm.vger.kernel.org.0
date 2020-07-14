Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B582821E85D
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 08:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgGNGgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 02:36:42 -0400
Received: from mga07.intel.com ([134.134.136.100]:33942 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgGNGgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 02:36:42 -0400
IronPort-SDR: y/WZAvLRwj8hPQ+uwCxcEZnM8nPjeoUjN0QSyUOC0xJVFeLuCni7Mn36Ds8+2DTaG5TYrrPIls
 Rlfl6sJCaKYA==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="213632478"
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="213632478"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 23:36:41 -0700
IronPort-SDR: mzMEla1h7jyhnOmhfJhtbCX9CSn3eWsOlv1WrB9YA3MDDahiUzdA5d9zO3xruCKSGyNDa55twr
 fDZmejJ2Owcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="299435523"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga002.jf.intel.com with ESMTP; 13 Jul 2020 23:36:38 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     alex.williamson@redhat.com, herbert@gondor.apana.org.au
Cc:     cohuck@redhat.com, nhorman@redhat.com, vdronov@redhat.com,
        bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 0/5] vfio/pci: add blocklist and disable qat
Date:   Tue, 14 Jul 2020 07:36:05 +0100
Message-Id: <20200714063610.849858-1-giovanni.cabiddu@intel.com>
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

The series is applicable to Herbert's tree. Patches 1 to 3 apply also to
Alex's tree. Patches 4 and 5 are optional and can be applied at a later stage.

Changes from v1:
 - Reworked commit messages:
   Patches #1, #2 and #3: capitalized first character after column to comply to
   subject line convention
   Patch #3: Capitalized QAT acronym and added link and doc number for
   document "Intel® QuickAssist Technology (Intel® QAT) Software for Linux"

Giovanni Cabiddu (5):
  PCI: Add Intel QuickAssist device IDs
  vfio/pci: Add device blocklist
  vfio/pci: Add QAT devices to blocklist
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

