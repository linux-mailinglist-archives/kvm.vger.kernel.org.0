Return-Path: <kvm+bounces-59660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 96F84BC6D9E
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 01:26:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C22824E9295
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 23:26:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EE972C15AC;
	Wed,  8 Oct 2025 23:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KJgEvhoV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A57C242D65
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 23:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759965958; cv=none; b=idOIWkU8+oW4EqumEx4rlFoLBYF3PMAKAW7uN3WD6/XlmJgkGJScUyLu0IXD5GD/V3JSRYWTQuEB60iA5QvhTeUusEw48Y4BRLtyaq67AfQ/YQx+eRitFTpFwqRrQlNnsd5NZe5bFlq7izTWj7BKfgdGe1MTPMegI9vnZPoZRko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759965958; c=relaxed/simple;
	bh=6Te/l1FdMgvPDFYXAb0MrPj9LS/0fpRak9SEl70hHbE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=nqgdQsuzUO0FJhmrmQe4CvkOCpGjFeh1+x61rd3V/bb3zmPVVflE+CcLj5kIAqF2+I1nGjIhWFQ7HFyvrY5BzpKH5nsT+XgXklNpKmnUJD6LtTfPfUy30qBdvHGCmbPXfRpToAkc3poVISRqpL1wHbm7R2UpXswi8lQIgzgQs5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KJgEvhoV; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7821487d16bso923503b3a.1
        for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 16:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759965956; x=1760570756; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=szw8ENnqBfK3xzPUp7EhEzvfR21xiuivCXeVXMJ7ofs=;
        b=KJgEvhoV2TwyPx2Z8RVR30HX5y2Yl1EWJDEdylW8ESvsZqE96L4+RUEPz0T4pXrqwM
         TjtvqQ/2Gyuj0HEJ6hMcmIl57Otwi70qSbhVo4t/EWZ+eg+qYurB5MG8v0ZBlXfa5DTO
         YqkeASO19JeXMABn0DJiqvZILW4WCN9k+0pWgAWMWZytGpx29CWet5k42LB55iyo/uJx
         nbGDVWnnTscr+ootA6PAYUW/aiH7de58sSRWtoWqd1WEfcYGR+18dWVZ5xWtV0p/7wLd
         ArlmeEeogs1ThlNsnsXIOxsvnwnmBQUI3LWcnBCkrYxxu/PZMeuVu8GADyQIzhZivgPK
         S0bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759965956; x=1760570756;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=szw8ENnqBfK3xzPUp7EhEzvfR21xiuivCXeVXMJ7ofs=;
        b=FFAhKCe5NMCxzKhX1OmMd5H2TWr0pQgtNRGwqKxdd46sSp3kp/TJAxHIjWAKgUg0fh
         YNPBDy5tuk2hMrZJbyMgAtc9w7/5gOOUAvhcU1/m5neoJl2yCCWwSbR0W5ogBv7GCLEo
         oOtqWgqSHDVdZTqlCZ8dCU0yiVM6npR7ASt/VBS6s3NYMey7gvEg6eqrrVMiEsHvO40C
         Uxo/LDXcAQXy6O4N0XGRvl2/EQya57Qga37rS/afOyeh40YYoRRicn/d5BR0sz+i3Tvt
         UjgyhCo/n+I7jmjBCab0gJedyZczhXPowZOZJc4fOTsng5eObUs6CuZ/znXA9rw2EI0C
         RtwA==
X-Forwarded-Encrypted: i=1; AJvYcCWX7JdxLAH2mCZcSKnU7Z+15aFAV8oDkqrdNSE0AuHg5Qsl8zYAjMezoiu1UmvRTad4VHM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5WS1BRB9hhCSUWMl+oBn9Bw+QuHqoJe67jx+p7AMIriC5kK3P
	QyrcjOOEtyKm6g2NAT3hhDUY0KdbIDlWPP7HdPlv2WwzgHsvrRNioyzOAbB8RKRaXn+UxIFPaeq
	Lz7UV0e0IXezXEg==
X-Google-Smtp-Source: AGHT+IFLdKVljjE5aEMuQ/6hsKfRemEEpa1HrpdifwRIyMDTtsT1e6kqgvmNUT5Gk/mQN/hv20a+rUO5Awp3Ng==
X-Received: from pfux2.prod.google.com ([2002:a05:6a00:bc2:b0:781:1ccb:9052])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:14c1:b0:78c:994a:fc87 with SMTP id d2e1a72fcca58-793853254c5mr6749198b3a.6.1759965956441;
 Wed, 08 Oct 2025 16:25:56 -0700 (PDT)
Date: Wed,  8 Oct 2025 23:25:19 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008232531.1152035-1-dmatlack@google.com>
Subject: [PATCH 00/12] vfio: selftests: Support for multi-device tests
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Matlack <dmatlack@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, 
	kvm@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

This series adds support for tests that use multiple devices, and adds
one new test, vfio_pci_device_init_perf_test, which measures parallel
device initialization time to demonstrate the improvement from commit
e908f58b6beb ("vfio/pci: Separate SR-IOV VF dev_set").

This series also breaks apart the monolithic vfio_util.h and
vfio_pci_device.c into separate files, to account for all the new code.
This required some code motion so the diffstat looks large. The final
layout is more granular and provides a better separation of the IOMMU
code from the device code.

  C files:
    - tools/testing/selftests/vfio/lib/libvfio.c
    - tools/testing/selftests/vfio/lib/iommu.c
    - tools/testing/selftests/vfio/lib/vfio_pci_device.c
    - tools/testing/selftests/vfio/lib/vfio_pci_driver.c

  H files:
   - tools/testing/selftests/vfio/lib/include/libvfio.h
   - tools/testing/selftests/vfio/lib/include/libvfio/assert.h
   - tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
   - tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
   - tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_driver.h

Notably, vfio_util.h is now gone and replaced with libvfio.h.

This series is based on vfio next, and can be found on GitHub:

  https://github.com/dmatlack/linux/tree/vfio/selftests/init_perf_test/v1

Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Vipin Sharma <vipinsh@google.com>
Cc: Josh Hilke <jrhilke@google.com>

David Matlack (12):
  vfio: selftests: Split run.sh into separate scripts
  vfio: selftests: Allow passing multiple BDFs on the command line
  vfio: selftests: Rename struct vfio_iommu_mode to iommu_mode
  vfio: selftests: Introduce struct iommu
  vfio: selftests: Support multiple devices in the same
    container/iommufd
  vfio: selftests: Eliminate overly chatty logging
  vfio: selftests: Prefix logs with device BDF where relevant
  vfio: selftests: Rename struct vfio_dma_region to dma_region
  vfio: selftests: Move iommu_*() functions into iommu.c
  vfio: selftests: Rename vfio_util.h to libvfio.h
  vfio: selftests: Split libvfio.h into separate header files
  vfio: selftests: Add vfio_pci_device_init_perf_test

 tools/testing/selftests/vfio/Makefile         |   3 +
 .../selftests/vfio/lib/drivers/dsa/dsa.c      |  36 +--
 .../selftests/vfio/lib/drivers/ioat/ioat.c    |  18 +-
 .../selftests/vfio/lib/include/libvfio.h      |  25 ++
 .../vfio/lib/include/libvfio/assert.h         |  53 ++++
 .../vfio/lib/include/libvfio/iommu.h          |  53 ++++
 .../lib/include/libvfio/vfio_pci_device.h     | 143 +++++++++
 .../lib/include/libvfio/vfio_pci_driver.h     |  98 ++++++
 .../selftests/vfio/lib/include/vfio_util.h    | 295 ------------------
 tools/testing/selftests/vfio/lib/iommu.c      | 219 +++++++++++++
 tools/testing/selftests/vfio/lib/libvfio.c    |  77 +++++
 tools/testing/selftests/vfio/lib/libvfio.mk   |   4 +-
 .../selftests/vfio/lib/vfio_pci_device.c      | 264 ++--------------
 .../selftests/vfio/lib/vfio_pci_driver.c      |  16 +-
 tools/testing/selftests/vfio/run.sh           | 109 -------
 .../testing/selftests/vfio/scripts/cleanup.sh |  42 +++
 tools/testing/selftests/vfio/scripts/lib.sh   |  42 +++
 tools/testing/selftests/vfio/scripts/run.sh   |  16 +
 tools/testing/selftests/vfio/scripts/setup.sh |  48 +++
 .../selftests/vfio/vfio_dma_mapping_test.c    |   4 +-
 .../selftests/vfio/vfio_iommufd_setup_test.c  |   2 +-
 .../vfio/vfio_pci_device_init_perf_test.c     | 163 ++++++++++
 .../selftests/vfio/vfio_pci_device_test.c     |   2 +-
 .../selftests/vfio/vfio_pci_driver_test.c     |   8 +-
 24 files changed, 1051 insertions(+), 689 deletions(-)
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio.h
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/assert.h
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_driver.h
 delete mode 100644 tools/testing/selftests/vfio/lib/include/vfio_util.h
 create mode 100644 tools/testing/selftests/vfio/lib/iommu.c
 create mode 100644 tools/testing/selftests/vfio/lib/libvfio.c
 delete mode 100755 tools/testing/selftests/vfio/run.sh
 create mode 100755 tools/testing/selftests/vfio/scripts/cleanup.sh
 create mode 100755 tools/testing/selftests/vfio/scripts/lib.sh
 create mode 100755 tools/testing/selftests/vfio/scripts/run.sh
 create mode 100755 tools/testing/selftests/vfio/scripts/setup.sh
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_device_init_perf_test.c


base-commit: 451bb96328981808463405d436bd58de16dd967d
prerequisite-patch-id: 2284290c5021a6efe82f911f0d86311b3f0c5794
-- 
2.51.0.710.ga91ca5db03-goog


