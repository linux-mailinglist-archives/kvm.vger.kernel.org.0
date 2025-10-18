Return-Path: <kvm+bounces-60409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 905EFBEC163
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 02:07:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5A3174F349A
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 00:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDDA64A1A;
	Sat, 18 Oct 2025 00:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hoV2gUxB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3503C38
	for <kvm@vger.kernel.org>; Sat, 18 Oct 2025 00:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760746047; cv=none; b=ShdDRkZGWZmGh/HO+fjjc9Y3rMB+hzmi8tOeQSoXzdVWWM7lEf+SEnhM1Fklm3c5GGLBI5c0uGrnMWZcgBngGvs9NeR6ObPkdd9Y3FaB+Tx1pFaoE4P1kIiDhNr90RMCy2U7x46yKtz4AlvSumTkj0j7wfrPtSm43TRLJL0AHAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760746047; c=relaxed/simple;
	bh=JsF3pCaJNrsPpYhzB/cGCKrK/cKCLDnGL/lBx/nc630=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IDgZraI1+tNbmU7Q/ceuLsIIyKIrjABKFo347Ip0JTdDNyl7Y5UaFPuRceQAekHl/arF1yRcw4yfva2qdNbAb/Rmje1qkcj+T0k8ZzZNwCgg2a+UPnZjL2Fxv0gFXc8iqs3c9tZHki+j74LJBEZbE1R1UAse9BpsQ7G4ZUaCxBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hoV2gUxB; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2697410e7f9so62950565ad.2
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 17:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760746044; x=1761350844; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6pRYEHJAtcQPB4+ypf1OfjNx0LJ2Hfu10ud0VIrmLZk=;
        b=hoV2gUxB/Tq00vzPq5qvHOuDzy4m68EzFsjRfrczKavQL7xGQ1jB2SmrH4W51io6wc
         N13/aRtoQi73KkUb4sp8noHtTpYcgDXTaUomPbev7WBYr3EGonmSZHNW018S7VAPMCdQ
         ZDOTscxyKjlJfT5wv24bRSAHbLMszwC2m8+3rUpIKO/AyQdCc1nWjz7ZpjPgpcVJHrO8
         zZru4d183qu9rS8XZzu6sr6enFYRejW9ZGBxGEOUtuxeTEwlZUwdkpN9lG7HXi3fZjo2
         9GlenWrMRC9SrST2LT/G1XnxFXz59A+TlOj00GnPLdJKnvZ4z9nZ0APzTqRHbsRfSmvB
         AMvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760746044; x=1761350844;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6pRYEHJAtcQPB4+ypf1OfjNx0LJ2Hfu10ud0VIrmLZk=;
        b=Qn3xKZK3Hznjqh2bmsQedDQ9AO3ooc77qWs0oc5osODwXAcNAWt3VLbxhn4xUp/RIr
         WFP+3I30oiH3FO+FFthJGdZAIk2qrApoKPK8DoZ+dHeXPq9EHLONX/VnXTtWtGvLlcT/
         WieSLwLzDLG+8taIIfNz4dgEPemIg7tYAghBne2e1hWy//D/eL2Jlr3YUpgHKAwuN617
         /OotxHCCl6RUJIX5bJ5ZTfGi9A1YA+5mVHQQ5ZED9ntsuPssvf14KoNQChSkjPNq7gSY
         K3gpQuqwHVWSId/oiHSPq2+azeJM80KNKb+GGs/JVBq9cTTdJRAOarymNWNde3DHUSCe
         /wHA==
X-Forwarded-Encrypted: i=1; AJvYcCUHX8BHL3Lz2Q91nLsNZf9yFNEE32Ur3SLqadzr+rW+6P2CO6NbaJpkK9V6nmtpSufENkM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZwDPoJgjY4/Sgrgeyj1RYQTtLLCgNCkJvgudm5zSz3QaJNxnc
	atOY4GyUUCdADsKK7di2bEiHkEFlcxtLuZX1+sVuHWoGQ7JYZJ0gFxhoI5J0q+P4w2pVGIAz2p7
	Nk1nMsCm9+Q==
X-Google-Smtp-Source: AGHT+IE4sqzg7x9pdj/gU+/lFXsDmRAAlwvYzmvAHj/tmhxjrwOvAMwjo98m7QZ00QqFFxAX1FacQ9WT8yT5
X-Received: from pjbhg4.prod.google.com ([2002:a17:90b:3004:b0:33b:c15c:f245])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ecc8:b0:290:c516:8c53
 with SMTP id d9443c01a7336-290caf831d8mr69996655ad.40.1760746043781; Fri, 17
 Oct 2025 17:07:23 -0700 (PDT)
Date: Fri, 17 Oct 2025 17:06:52 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251018000713.677779-1-vipinsh@google.com>
Subject: [RFC PATCH 00/21] VFIO live update support
From: Vipin Sharma <vipinsh@google.com>
To: bhelgaas@google.com, alex.williamson@redhat.com, pasha.tatashin@soleen.com, 
	dmatlack@google.com, jgg@ziepe.ca, graf@amazon.com
Cc: pratyush@kernel.org, gregkh@linuxfoundation.org, chrisl@kernel.org, 
	rppt@kernel.org, skhawaja@google.com, parav@nvidia.com, saeedm@nvidia.com, 
	kevin.tian@intel.com, jrhilke@google.com, david@redhat.com, 
	jgowans@amazon.com, dwmw2@infradead.org, epetron@amazon.de, 
	junaids@google.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Hello,

This series adds the live update support in the VFIO PCI subsystem on top of
Live Update Orchestrator (LUO) [1].

This series can also be found on GitHub:

  https://github.com/shvipin/linux vfio/liveupdate/rfc-v1

Goal of live update in VFIO subsystem is to preserve VFIO PCI devices
while the host kernel is going through a live update. A preserved device
means it can continue to work, perform DMA, not get reset while host
under live update gets rebooted via kexec.

This series registers VFIO with LUO, implements LUO callbacks, skip DMA
clear, skip device reset, preserves and restores a device virtual
config during live update. I have added a selftest towards the end of
this series, vfio_pci_liveupdate_test, which sets certain properties of
a VFIO PCI device, performs a live update, and then validates those
properties are still same on the device.

Overall flow for a VFIO device going through a live update will be
something like:

1. Userspace passes a VFIO cdev FD along with a token to LUO for preservation.
2. LUO passes FD to VFIO subsystem to verify if FD can be preserved. If
   yes, it increases the refcount on the FD.
3. Eventually, userspace tells LUO to prepare for live update which
   results in LUO calling prepare() callback to each of its register filesystem
   handler with the passed FD it should be preparing.
4. VFIO subsystem saves certain properties which will be either lost or
   hard to recover from the device.
5. VFIO saves the needed data to KHO and provide LUO with the
   physical address of the data preserved by KHO.
6. Userspace sends FREEZE event to freeze the system. LUO forwards this
   to each of its registered subsystem.
7. VFIO disables interrupts configured on the device during freeze call.
8. Userspace performs kexec.
9. During kexec reboot, generally, all PCI devices gets their Bus Master
   Enable bit disabled. In live update case, preserved VFIO devices are
   skipped.
9. During boot, usual device enumeration happens and LUO also intializes
   itself.
10. Userspace uses the same token value (step 1), and ask LUO to return
    VFIO FD corresponding to token.
11. LUO ask VFIO to return VFIO cdev FD corresponding to the token. It
    gives it the physical address which VFIO returned it in step 5.
12. VFIO restore the KHO data and read the BDF value it saved. It
    iterates through all of the VFIO device it has in its VFIO cdev
    class and finds the BDF device.
13. VFIO creates an anonymous inode and file corresponding to the VFIO
    PCI device and returns it to LUO and LUO returns it to userspace.
14. Now FD returned to userspace works exactly same as if userspace has
    opened a VFIO device from /dev/vfio/device/* location.
15. It makes usual bind iommufd and attach page table calls.
16. During bind, when VFIO device is internally opened for the first
    time:
    - VFIO skips Bus Master Disable
    - VFIO skips device reset.
    - VFIO instead of initializing vconfig from the scratch uses the
      vconfig stored in KHO, and same for few other fields.

This is what current series is implementing and validating through
selftest.

There are other things are which not implemented yet and some are also
dependent on other subsystems. For example:

1. Once a device has been prepared, VFIO should not allow any changes to
   its state from userspace for example, changing PCI config values,
   resetting the device, etc. 
2. Device IOVA is not preserved in this series. This work is done
   separately in IOMMMUFD live update preservation [2]
3. During PCI device enumeration, PCI subsystem writes to PCI config
   space, attach device to its original driver if present. This work is
   being done in PCI preservation [3].
4. Enabling PCI device done in VFIO subsystem should be handled in PCI
   subsystem. Current, this patch series hasn't changed the behavior. 
5. If live update gets canceled, interrupts which are disabled in
   freeze need to be reconfigured again.
6. In finish, if a device is not restored, how to know if KHO folio has been
   restored or not.
6. VFIO cdev is restored in anonymous file system. This should instead
   be done on devetmpfs

For reviewers, following are the grouping of patches in this series:

Patches 1-4
-----------
  Feel free to ignore if you are only interested in VFIO.

  These are only for live update selftests. I had to make some changes
  on top LUO v4 series, to create a library out of them which can be
  used in other selftests (vfio), and fix some build issues.

Patches 5-9
-----------
  Adds basic live update support in VFIO.

  Registers to LUO, saves the device BDF in KHO during prepare, and
  returns VFIO cdev FD during restore.

  It doesn't save or skip anything else.

Patches 10-17
-------------
  Adds support for skipping certain opertions and preserving certain
  data needed to restore a device.

Patches 18-21
-------------
  - Integrate VFIO selftest with live update selftest library. 
  - Adds a basic vfio_pci_liveupdate_test test which validates that Bus
    Master Enable bit is preserved, and virtual config is restored
    properly.

Testing
-------

I have done testing on QEMU with a test pci device and also on a bare
metal with Intel DSA device. Make sure IDXD driver is not built in your
kernel if testing with Intel DSA device. Basically, whichever device you
use, it should not get auto-bind to any other driver.

Important config options which should be enabled to test this series:

  - CONFIG_KEXEC_FILE
  - CONFIG_LIVEUPDATE
  - CONFIG_KEXEC_HANDOVER

Besides this usual VFIO, VFIO_PCI, IOMMU and other dependencies are
enabled.

To build the test provide KHDR_INCLUDES to your make command if your
headers are out-of-tree.

  KHDR_INCLUDES="-isystem ../../../../build/usr/include"  make

vfio_pci_liveupdate_test needs to be executed manually. This test needs
to be executed two times; one before the live update and second after.

  ./run.sh -d 0000:00:04.0 vfio_pci_liveupdate_test

Next Steps
----------

1. Looking forward to feedback on this series.
   - What other things we should save?
   - Which things should not be saved?
   - Any locks or incorrect locking done in the series.
   - Any optimizations.
2. Integration with IOMMUFD and PCI series for complete workflow where a
   device continues a DMA while undergoing through live update.

I will be going on a paternity leave soon, so, my responses gonna be
intermittent. David Matlack (dmatlack@google.com) has graciously offered
to work on this series and continue upstream engagement on this feature
until I am back. Thank you, David!


[1] LUO-v4: https://lore.kernel.org/linux-mm/20250929010321.3462457-1-pasha.tatashin@soleen.com/
[2] IOMMUFD: https://lore.kernel.org/linux-iommu/20250928190624.3735830-1-skhawaja@google.com/
[3] PCI: https://lore.kernel.org/linux-pci/20250916-luo-pci-v2-0-c494053c3c08@kernel.org/


Vipin Sharma (21):
  selftests/liveupdate: Build tests from the selftests/liveupdate
    directory
  selftests/liveupdate: Create library of core live update ioctls
  selftests/liveupdate: Move do_kexec.sh script to liveupdate/lib
  selftests/liveupdate: Move LUO ioctls calls to liveupdate library
  vfio/pci: Register VFIO live update file handler to Live Update
    Orchestrator
  vfio/pci: Accept live update preservation request for VFIO cdev
  vfio/pci: Store VFIO PCI device preservation data in KHO for live
    update
  vfio/pci: Retrieve preserved VFIO device for Live Update Orechestrator
  vfio/pci: Add Live Update finish callback implementation
  PCI: Add option to skip Bus Master Enable reset during kexec
  vfio/pci: Skip clearing bus master on live update device during kexec
  vfio/pci: Skip clearing bus master on live update restored device
  vfio/pci: Preserve VFIO PCI config space through live update
  vfio/pci: Skip device reset on live update restored device.
  PCI: Make PCI saved state and capability structs public
  vfio/pci: Save and restore the PCI state of the VFIO device
  vfio/pci: Disable interrupts before going live update kexec
  vfio: selftests: Build liveupdate library in VFIO selftests
  vfio: selftests: Initialize vfio_pci_device using a VFIO cdev FD
  vfio: selftests: Add VFIO live update test
  vfio: selftests: Validate vconfig preservation of VFIO PCI device
    during live update

 drivers/pci/pci-driver.c                      |   6 +-
 drivers/pci/pci.c                             |   5 -
 drivers/pci/pci.h                             |   7 -
 drivers/vfio/pci/Makefile                     |   1 +
 drivers/vfio/pci/vfio_pci_config.c            |  17 +
 drivers/vfio/pci/vfio_pci_core.c              |  31 +-
 drivers/vfio/pci/vfio_pci_liveupdate.c        | 461 ++++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h              |  17 +
 drivers/vfio/vfio_main.c                      |  20 +-
 include/linux/pci.h                           |  15 +
 include/linux/vfio.h                          |   8 +
 include/linux/vfio_pci_core.h                 |   1 +
 tools/testing/selftests/liveupdate/.gitignore |   7 +-
 tools/testing/selftests/liveupdate/Makefile   |  31 +-
 .../liveupdate/{ => lib}/do_kexec.sh          |   0
 .../liveupdate/lib/include/liveupdate_util.h  |  27 +
 .../selftests/liveupdate/lib/libliveupdate.mk |  18 +
 .../liveupdate/lib/liveupdate_util.c          | 106 ++++
 .../selftests/liveupdate/luo_multi_file.c     |   2 -
 .../selftests/liveupdate/luo_multi_kexec.c    |   2 -
 .../selftests/liveupdate/luo_multi_session.c  |   2 -
 .../selftests/liveupdate/luo_test_utils.c     |  73 +--
 .../selftests/liveupdate/luo_test_utils.h     |  10 +-
 .../selftests/liveupdate/luo_unreclaimed.c    |   1 -
 tools/testing/selftests/vfio/Makefile         |  15 +-
 .../selftests/vfio/lib/include/vfio_util.h    |   1 +
 .../selftests/vfio/lib/vfio_pci_device.c      |  33 +-
 .../selftests/vfio/vfio_pci_liveupdate_test.c | 116 +++++
 28 files changed, 900 insertions(+), 133 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_liveupdate.c
 rename tools/testing/selftests/liveupdate/{ => lib}/do_kexec.sh (100%)
 create mode 100644 tools/testing/selftests/liveupdate/lib/include/liveupdate_util.h
 create mode 100644 tools/testing/selftests/liveupdate/lib/libliveupdate.mk
 create mode 100644 tools/testing/selftests/liveupdate/lib/liveupdate_util.c
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_test.c


base-commit: e48be01cadc981362646dc3a87d57316421590a5
-- 
2.51.0.858.gf9c4a03a3a-goog


