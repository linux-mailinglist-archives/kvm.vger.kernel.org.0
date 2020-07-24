Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D5322C11C
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 10:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgGXIsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 04:48:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:45604 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbgGXIsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 04:48:09 -0400
IronPort-SDR: sH6rwSAxZ1rS5Gvp09MhgJ+hBfsY/Jiulsyzzv04BQ+5NStcQtKtHTx+XR1EIUZHnP3Q+Uxas6
 F5B8HltMKMvw==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="138742736"
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="138742736"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2020 01:48:09 -0700
IronPort-SDR: +Un+cSduj96ujc+RzGWhAE9vgnycKNK++XQWrcgHivKYO1MueFnzcalUZFyGf87nATYpUZltb8
 r1MhhKa+Uuyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="311335253"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga004.fm.intel.com with ESMTP; 24 Jul 2020 01:48:05 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     alex.williamson@redhat.com, herbert@gondor.apana.org.au
Cc:     cohuck@redhat.com, nhorman@redhat.com, vdronov@redhat.com,
        bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        fiona.trahe@intel.com, qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v4 0/5] vfio/pci: add denylist and disable qat
Date:   Fri, 24 Jul 2020 09:47:55 +0100
Message-Id: <20200724084800.6136-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset defines a denylist of devices in the vfio-pci module and adds
the current generation of Intel(R) QuickAssist devices to it as they are
not designed to run in an untrusted environment.

By default, if a device is in the denylist, the probe of vfio-pci fails.
If a user wants to use a device in the denylist, he needs to disable the
full denylist providing the option disable_denylist=1 at the load of
vfio-pci or specifying that parameter in a config file in /etc/modprobe.d.

This series also moves the device ids definitions present in the qat driver
to linux/pci_ids.h since they will be shared between the vfio-pci and the qat
drivers and replaces the custom ADF_SYSTEM_DEVICE macro with PCI_VDEVICE.

The series is applicable to Herbert's tree. Patches 1 to 3 apply also to
Alex's tree (next). Patches 4 and 5 are optional and can be applied at a later
stage.

Changes from v3:
 - Patch #1: included Acked-by tag, after ack from Bjorn Helgaas
 - Patch #2: s/prevents/allows/ in module parameter description

Changes from v2:
 - Renamed blocklist in denylist
 - Patch #2: reworded module parameter description to clarify why a device is
   in the denylist
 - Patch #2: reworded warning that occurs when denylist is enabled and device
   is present in that list

Changes from v1:
 - Reworked commit messages:
   Patches #1, #2 and #3: capitalized first character after column to comply to
   subject line convention
   Patch #3: Capitalized QAT acronym and added link and doc number for document
   "Intel® QuickAssist Technology (Intel® QAT) Software for Linux"

Giovanni Cabiddu (5):
  PCI: Add Intel QuickAssist device IDs
  vfio/pci: Add device denylist
  vfio/pci: Add QAT devices to denylist
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

