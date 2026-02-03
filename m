Return-Path: <kvm+bounces-70093-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id VmEZKz5ygmnBUgMAu9opvQ
	(envelope-from <kvm+bounces-70093-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:10:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 173D0DF186
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:10:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 43D82302F40E
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 22:09:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90497371048;
	Tue,  3 Feb 2026 22:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="20x0waBL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4EE31B83B
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 22:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770156592; cv=none; b=EfD5sIlcffMw4Bhei46MnUu3iiYhfeEjv2r3tJ8tMIKByJjg3rNhcbUizjqC2HZEQpZSmfE8Ij6ssMaex1HBjA2ApeR+nutILV2OGzMSXaoqoKeq6wwJzKOUhHg7Kr0+Ae3ukQ1v1XB21jSS8B8R7TcFcDEDSNuzl0U6oOvemt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770156592; c=relaxed/simple;
	bh=++pOXY7jKvruZEFWEcAkOOnM7B77EUJ5Be21PQUqBGI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=AinX0LFtS/lcKKR8yitkC0pTVuiFfxROrQU0wSN+9MhYgJrIU5QybE0HA5RiRaEsow3Y50JeN1B5RNsxy8q9Rz/96B7t/li1LjWhQW6QcmyD+7KmvA2SiV7/188joGyTYYKjjDE2ROafOiIrZX8Fpj5ZAh/mQHnHfKGIQ8LysJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=20x0waBL; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-81e7fd70908so12947848b3a.2
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 14:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770156590; x=1770761390; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SpRJJ9G8q3T44zX9+oPHRq/pJ0xN8Ws+kTYVqjDiXOU=;
        b=20x0waBLliDeEWzmUojJ0VBPqKXIeTeT+HK2As4nfdDX8iubDRllx+kHWWbhnJJNIc
         hmkQaYBIGyecj+uLd7iwxAsD7vu3gTM45nEvbNnEyMNUJ8ZGBaLeMgQBCUwDTDxelduU
         U5TB4SWhSB0m+wnTcK4VQChiQu7PeZrjWzCcM2MxgKuTrVqjkg/F6GbuSlQ1pOlN3jHw
         2Z7XBbHZlKfBH6CW8LB+hsyg1NbrUBxWmzSNx8ewcXMat8/+vAT4GuKqua4Nff5K9hhZ
         lBj5H1kJZVJcuOjj31ZtaA2Dg8dzBS9Ke8HW/7qKOJjsqCUXK97G4ImxX533AxJ7XTY+
         5ZRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770156590; x=1770761390;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SpRJJ9G8q3T44zX9+oPHRq/pJ0xN8Ws+kTYVqjDiXOU=;
        b=n6iY4RTjK3Wvw7FYffGS37F41q9v6/VSwco7LkTRbdfkiXVjp2isH/L5mLI+v2trS2
         Tx2J4SoDmSrimplmllDuetAPgnIVgbH0+9ifrWsaBe4sIBI8SgnZ4D+49yev5HI87zAQ
         E1K5o0RJ1SBI+YXrBLY7jYesJ7AnTwc9PHESbm3Phj68HSCX8P4VVkPZ/i9KAxRaL5e6
         cIVQs4uYN1SZFg2lzmPT2LSECcM07i4q1kVShqR2o1PCpY0tcwHTKDEo94v7kz0ge1ph
         DKvYqzQ0Mi4KfBfFk9LoG/43w1F5Tzt9DtJPIYpLuWgtmJxOLvzRyqh11qTXhw8ZLtkr
         /x4g==
X-Forwarded-Encrypted: i=1; AJvYcCW3cUNv5NAb8kBIW+G+YK4/iaiN9mE4njHrcSKxL6Bqjcjl+lJo86B2mm/RgbJO1OoJ6Tk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywww9O6jNkXFCeYPXn5fL/9WypMQa0dV3bDh/w2jsytNQ5MpA96
	u0eJieSCJ82frZQmWkaoMVQHSsh8m72cwGpne12ueV3Dosj8wzK0aFsRijMliBfAM3XCwwOmnD6
	+fEBuhMYL4pFNUg==
X-Received: from pfbds4.prod.google.com ([2002:a05:6a00:4ac4:b0:824:1bc7:4d11])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:32cf:b0:823:1c5f:1c43 with SMTP id d2e1a72fcca58-8241c5f5e6amr800774b3a.36.1770156590345;
 Tue, 03 Feb 2026 14:09:50 -0800 (PST)
Date: Tue,  3 Feb 2026 22:09:34 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260203220948.2176157-1-skhawaja@google.com>
Subject: [PATCH 00/14] iommu: Add live update state preservation
From: Samiullah Khawaja <skhawaja@google.com>
To: David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Samiullah Khawaja <skhawaja@google.com>, Robin Murphy <robin.murphy@arm.com>, 
	Kevin Tian <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Parav Pandit <parav@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>, 
	YiFei Zhu <zhuyifei@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70093-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[26];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[skhawaja@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 173D0DF186
X-Rspamd-Action: no action

Hi,

This patch series introduces a mechanism for IOMMU state preservation
across live update, including the Intel VT-d driver support
implementation.

This is a non-RFC version of the previously sent RFC:
https://lore.kernel.org/all/20251202230303.1017519-1-skhawaja@google.com/

Please take a look at the following LWN article to learn about KHO and
Live Update Orchestrator:

https://lwn.net/Articles/1033364/

This work is based on,

- linux-next (tag: next-20260115)
- MEMFD SEAL preservation series:
  https://lore.kernel.org/all/20260123095854.535058-1-pratyush@kernel.org/
- VFIO CDEV preservation series (v2):
  https://lore.kernel.org/all/20260129212510.967611-1-dmatlack@google.com/

The kernel tree with all dependencies is uploaded to the following
Github location:

https://github.com/samikhawaja/linux/tree/iommu/phase1-v1

Overall Goals:

The goal of this effort is to preserve the IOMMU domains, managed by
iommufd, attached to devices preserved through VFIO cdev. This allows
DMA mappings and IOMMU context of a device assigned to a VM to be
maintained across a kexec live update.

This is achieved by preserving IOMMU page tables using Generic Page
Table support, IOMMU root table and the relevant context entries across
live update.

The functionality in the previously sent RFC is split into two phases
and this series implements the Phase 1. Phase 1 implements the following
functionality:

  - Foundational work in IOMMU core and VT-d driver to preserve and
    restore IOMMU translation units, IOMMU domains and devices across
    liveupdate kexec.
  - The preservation is triggered by preserving vfio cdev FD and bound
    iommufd FD into a live update session.
  - An HWPT (and backing IOMMU domain) is only preserved if it contains
    only file type DMA mappings. Also the memfd being used for such
    mapping should be SEAL SEAL'd during mapping.
  - During live update boot, the state of preserved Intel VT-d, IOMMU
    domain and devices is restored.
  - The restored IOMMU domains are reattached to the preserved devices
    during early boot.
  - The DMA ownership of restored devices is also claimed during
    live update boot. This means that any attempt to bind a non-vfio
    drivers with them or binding a new iommufd with them will fail.

Architectural Overview:

The target architecture for IOMMU state preservation across a live
update involves coordination between the Live Update Orchestrator,
iommufd, and the IOMMU drivers.

The core design uses the Live Update Orchestrator's file descriptor
preservation mechanism to preserve iommufd file descriptors. The user
marks the iommufd HWPTs for preservation using a new ioctl added in this
series. Once done, the preservation of iommufd inside an LUO session is
triggered using LUO ioctls. During preservation, the LUO preserve
callback for an iommufd walks through the HWPTs it manages to identify
the ones that need to be preserved. Once identified, a new IOMMU core
API is used to preserve the iommu domain. The IOMMU core uses Generic
Page Table to preserve the page tables of these domains. The domains are
then marked as preserved.

When the user triggers the preservation of a VFIO cdev that is attached
to an iommufd that is preserved, the device attachment state of that
VFIO cdev is also preserved using an API exported by iommufd. IOMMUFD
fetches all the information that needs to be preserved and calls the
IOMMU core API to preserve the device state. The IOMMU core also
preserves state of IOMMU that is associated with this device.

The IOMMU core has LUO FLB registered with the iommufd LUO file handler
so the preserved iommu domain and iommu hardware unit state is available
during boot for early restore in the next kernel.

During boot the driver fetches the preserved state from the IOMMU core
and restores the state of preserved IOMMUs. Later when IOMMU core goes
through the devices and probes them, the iommu domains of preserved
devices are restored and the preserved devices are attached to them.
During attachment, the DMA ownership of these devices is also claimed.

Tested:

The new iommufd_liveupdate selftest was used to verify the preservation
logic. It was tested using QEMU with virtual IOMMU (VT-d) support with
virtio pcie device bound to the vfio-pci driver.

Also Tested on an Intel machine with DSA device bound to vfio-pci driver.

Following steps were followed for verification,

- Bind the test device with vfio-pci driver
- Run test on the machine by running

  ./iommufd_liveupdate <vfio-cdev-path>

- Trigger Kexec.
- After reboot, try binding the device to a non-vfio pci driver,

  echo <device bdf> > /sys/class/bus/drivers/pci-pf-stub/bind

- This should fail with "Device or resource busy".
- Bind the device with vfio-pci driver and run the test again.
- Test verifies that the device cannot be bound with a new iommufd and
  the session cannot be finished.

Future Work:

- Phase 2 with IOMMUFD restore to reclaim the preserved vfio cdev and
  restore the preserved HWPTs.
- Full support for PASID preservation.
- Nested IOMMU preservation.
- Extend support to other IOMMU architectures (e.g., AMD-Vi, Arm SMMUv3).

High-Level Sequence Flow:

The following diagrams illustrate the high-level interactions during the
preservation phase. Note that function names in the diagram are kept
abbreviated to save horizontal space.

Prepare:

Before live update the PREPARE event of Liveupdate Orchestrator invokes
callbacks of the registered file and subsystem handlers.

 Userspace (VMM) | LUO Core |    iommufd    |  IOMMU Core   | IOMMU Driver
-----------------|----------|---------------|---------------|-------------
                 |          |               |               |
MARK_HWPT        |          |               |               |
--------------------------->                |               |
                 |          | Mark HWPT for |               |
                 |          | preservation  |               |
                 |          |               |               |
PRESERVE         |          |               |               |
 iommufd_fd      |          |               |               |
----------------->          |               |               |
                 | preserve |               |               |
                 |---------->               |               |
                 |          | For each HWPT |               |
                 |          |-------------->                |
                 |          |               | domain_presrv |
                 |          |               |-------------->
                 |          |               |               | gpt(preserve)
                 |          |               |<--------------|
                 |          |<--------------|               |
                 |<---------|               |               |
                 |          |               |               |
...              |          |               |               |
                 |          |               |               |
PRESERVE,        |          |               |               |
 vfio_cdev_fd    |          |               |               |
----------------->          |               |               |
                 | preserve |               |               |
                 |---------->               |               |
                 |          |               |               |
                 |          | iommu_preserv |               |
                 |          | _device()     |               |
                 |          |-------------->                |
                 |          |               | preserve      |
                 |          |               | (iommu_hw)    |
                 |          |               |-------------->
                 |          |               |               | preserve(root)
                 |          |               |               | preserve(pasid)
                 |          |               |<--------------|
                 |          |               |               |
                 |          |               | preserve      |
                 |          |               | _device(dev)  |
                 |          |               |-------------->
                 |          |               |               |
                 |          |               |<--------------|
                 |          |<--------------|               |
                 |<---------|               |               |

Restore:

After a live update, the preserved state is restored during boot.

 Userspace (VMM) | LUO Core |    iommufd    |  IOMMU Core   | IOMMU Driver
-----------------|----------|---------------|---------------|-------------
                 |          |               |               |
                 |          |               |               | Restore
                 |          |               |               | Root, DIDs
                 |          |               |               |
                 |          |               |               | Register
                 |          |               | probe devices |
                 |          |               |               |
                 |          |               | restore       |
                 |          |               | domain        |
                 |          |               |-------------->
                 |          |               |               | restore
                 |          |               | reattach      |
                 |          |               | domain        |
                 |          |               |-------------->
                 |          |               |               |


Looking forward to your feedback on this.

Pasha Tatashin (1):
  liveupdate: luo_file: Add internal APIs for file preservation

Samiullah Khawaja (11):
  iommu: Implement IOMMU LU FLB callbacks
  iommu: Implement IOMMU core liveupdate skeleton
  iommu/pages: Add APIs to preserve/unpreserve/restore iommu pages
  iommupt: Implement preserve/unpreserve/restore callbacks
  iommu/vt-d: Implement device and iommu preserve/unpreserve ops
  iommu/vt-d: Restore IOMMU state and reclaimed domain ids
  iommu: Restore and reattach preserved domains to devices
  iommu/vt-d: preserve PASID table of preserved device
  iommufd: Add APIs to preserve/unpreserve a vfio cdev
  vfio/pci: Preserve the iommufd state of the vfio cdev
  iommufd/selftest: Add test to verify iommufd preservation

YiFei Zhu (2):
  iommufd-lu: Implement ioctl to let userspace mark an HWPT to be
    preserved
  iommufd-lu: Persist iommu hardware pagetables for live update

 drivers/iommu/Kconfig                         |  11 +
 drivers/iommu/Makefile                        |   1 +
 drivers/iommu/generic_pt/iommu_pt.h           |  96 ++++
 drivers/iommu/intel/Makefile                  |   1 +
 drivers/iommu/intel/iommu.c                   | 115 +++-
 drivers/iommu/intel/iommu.h                   |  42 +-
 drivers/iommu/intel/liveupdate.c              | 304 ++++++++++
 drivers/iommu/intel/nested.c                  |   2 +-
 drivers/iommu/intel/pasid.c                   |   7 +-
 drivers/iommu/intel/pasid.h                   |   9 +
 drivers/iommu/iommu-pages.c                   |  74 +++
 drivers/iommu/iommu-pages.h                   |  30 +
 drivers/iommu/iommu.c                         |  50 +-
 drivers/iommu/iommufd/Makefile                |   1 +
 drivers/iommu/iommufd/device.c                |  69 +++
 drivers/iommu/iommufd/io_pagetable.c          |  17 +
 drivers/iommu/iommufd/io_pagetable.h          |   1 +
 drivers/iommu/iommufd/iommufd_private.h       |  38 ++
 drivers/iommu/iommufd/liveupdate.c            | 349 ++++++++++++
 drivers/iommu/iommufd/main.c                  |  16 +-
 drivers/iommu/iommufd/pages.c                 |   8 +
 drivers/iommu/liveupdate.c                    | 534 ++++++++++++++++++
 drivers/vfio/pci/vfio_pci_liveupdate.c        |  28 +-
 include/linux/generic_pt/iommu.h              |  10 +
 include/linux/iommu-lu.h                      | 144 +++++
 include/linux/iommu.h                         |  32 ++
 include/linux/iommufd.h                       |  23 +
 include/linux/kho/abi/iommu.h                 | 127 +++++
 include/linux/kho/abi/iommufd.h               |  39 ++
 include/linux/kho/abi/vfio_pci.h              |  10 +
 include/linux/liveupdate.h                    |  21 +
 include/uapi/linux/iommufd.h                  |  19 +
 kernel/liveupdate/luo_file.c                  |  71 +++
 kernel/liveupdate/luo_internal.h              |  16 +
 tools/testing/selftests/iommu/Makefile        |  12 +
 .../selftests/iommu/iommufd_liveupdate.c      | 209 +++++++
 36 files changed, 2502 insertions(+), 34 deletions(-)
 create mode 100644 drivers/iommu/intel/liveupdate.c
 create mode 100644 drivers/iommu/iommufd/liveupdate.c
 create mode 100644 drivers/iommu/liveupdate.c
 create mode 100644 include/linux/iommu-lu.h
 create mode 100644 include/linux/kho/abi/iommu.h
 create mode 100644 include/linux/kho/abi/iommufd.h
 create mode 100644 tools/testing/selftests/iommu/iommufd_liveupdate.c


base-commit: 9b7977f9e39b7768c70c2aa497f04e7569fd3e00
-- 
2.53.0.rc2.204.g2597b5adb4-goog


