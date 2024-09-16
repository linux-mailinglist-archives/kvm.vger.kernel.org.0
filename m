Return-Path: <kvm+bounces-26980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1A7297A042
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 13:31:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 866F7283641
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 11:31:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E35115383F;
	Mon, 16 Sep 2024 11:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="iY6Cbb9O"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2570B208CA;
	Mon, 16 Sep 2024 11:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726486295; cv=none; b=I8TurbsHeBPkiFDNAaZbxZxzsIsZ4fWJ8SlRzhi4A5u7tfjJ6JZYhFr7LqgtxnQpGOXBRRJOaYHASY7ya7ByGAf+ds6G0R/PCwqOnj6XOVWGgKihYeZ58jEnztz16Ci+fF+KxTezmV+rAxvU7+5VziOjMz1Af7vgdNlc/fz+6W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726486295; c=relaxed/simple;
	bh=VZnyVMb6Wj2410ekX/pEaZC9oXqPoXwT02Si0EfrpEo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tW3vtp24w7x2m7fojGAMtnCf5nWB/SBLbZDcfY+kiDY6J8LV2LRzxcLhXcZeEWHK4YrTOTvC+V+bHIXoM+kvC+aXmpEIwn8h1+9c/zlvFuocZktfLuPPAQUf2fWHVglEbwSA/U4GadI8Ai6IPhsittTm8RqjlainiiT+FUWgDqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=iY6Cbb9O; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726486294; x=1758022294;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OX3dcMl0h44bjFPAp5DDbhaUKj/uf/l3sfyAqSczm54=;
  b=iY6Cbb9On09DaQ7oYHf/4F4kUh7DzloYU7vIIPeCfIqsJy+cW22CllMz
   xAP/eHqgLwEqow9hxMc9rom3nb3NoVsd3KwlmkGyRaoHNNaBu5Qxt8I0e
   yMVvceCNZZ8yP6AKJTmrDNVlFbJ+AtWZwR+r1H5Z7sUqjhIPKi0zvp3nm
   A=;
X-IronPort-AV: E=Sophos;i="6.10,233,1719878400"; 
   d="scan'208";a="331432394"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2024 11:31:31 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.17.79:36766]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.1.23:2525] with esmtp (Farcaster)
 id 9ca89d8f-4bf5-41bd-964f-b09beac1ac86; Mon, 16 Sep 2024 11:31:30 +0000 (UTC)
X-Farcaster-Flow-ID: 9ca89d8f-4bf5-41bd-964f-b09beac1ac86
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:31:30 +0000
Received: from u5d18b891348c5b.ant.amazon.com (10.146.13.221) by
 EX19D014EUC004.ant.amazon.com (10.252.51.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:31:19 +0000
From: James Gowans <jgowans@amazon.com>
To: <linux-kernel@vger.kernel.org>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, "Joerg
 Roedel" <joro@8bytes.org>, =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?=
	<kw@linux.com>, Will Deacon <will@kernel.org>, Robin Murphy
	<robin.murphy@arm.com>, Mike Rapoport <rppt@kernel.org>, "Madhavan T.
 Venkataraman" <madvenka@linux.microsoft.com>, <iommu@lists.linux.dev>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>, Lu Baolu
	<baolu.lu@linux.intel.com>, Alexander Graf <graf@amazon.de>,
	<anthony.yznaga@oracle.com>, <steven.sistare@oracle.com>,
	<nh-open-source@amazon.com>, "Saenz Julienne, Nicolas" <nsaenz@amazon.es>
Subject: [RFC PATCH 00/13] Support iommu(fd) persistence for live update
Date: Mon, 16 Sep 2024 13:30:49 +0200
Message-ID: <20240916113102.710522-1-jgowans@amazon.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D041UWB003.ant.amazon.com (10.13.139.176) To
 EX19D014EUC004.ant.amazon.com (10.252.51.182)

Live update is a mechanism to support updating a hypervisor in a way
that has limited impact to running virtual machines. This is done by
pausing/serialising running VMs, kexec-ing into a new kernel, starting
new VMM processes and then deserialising/resuming the VMs so that they
continue running from where they were. When the VMs have DMA devices
assigned to them, the IOMMU state and page tables needs to be persisted
so that DMA transactions can continue across kexec.

Currently there is no mechanism in Linux to be able to continue running DMA
across kexec, and pick up handles to the original DMA mappings after
kexec. We are looking for a path to be able to support this capability
which is necessary for live update.  In this RFC patch series a
potential solution is sketched out, and we are looking for feedback on
the approach and userspace interfaces.

This RFC is intended to serve as the discussion ground for a Linux
Plumbers Conf 2024 session on iommu persistence:
https://lpc.events/event/18/contributions/1686/
... and a BoF session on memory persistence in general:
https://lpc.events/event/18/contributions/1970/
Please join those to further this discussion.

The concept is as follows:
IOMMUFDs are marked as persistent via a new option.  When a struct
iommu_domain is allocated by a iommufd, that iommu_domain also gets
marked as persistend.  Before kexec iommufd serialises the metadata for
all persistent domains to the KHO device tree blob. Similarly the IOMMU
platform driver marks all of the page table pages as persistent.  After
kexec the persistent IOMMUFDs are expose to userspace in sysfs.  Fresh
IOMMUFD objects are built up from the data which was passed across in
KHO. Userspace can open these sysfs files to get a handle on the IOMMUFD
again. Iommufd ensures that only persistent memory can be mapped into
persistent address spaces.

This depends on KHO as the foundational framework for passing data
across kexec and for marking pages as persistent:
https://lore.kernel.org/all/20240117144704.602-1-graf@amazon.com/

It also depends on guestmemfs as the provider of persistent guest RAM to
be mapped into the IOMMU:
https://lore.kernel.org/all/20240805093245.889357-1-jgowans@amazon.com/

The code is not a complete solution, it is more of a sketch to show the
moving parts and proposed interfaces to gather feedback and have the
discussion. Only a small portion of the IOMMUFD object and dmar_domains
are serialised; it is necessary to figure out all the data which needs
to be serialised to have a fully working deserialised object.

Sign-offs are omitted to make it clear that this is not for merging yet.

Adding maintainers from IOMMU drivers, iommufd, kexec and KVM (seeing as
this is designed for live update of a hypervisor specifically), and
others who have engaged with the topic of memory persistence previously.

James Gowans (13):
  iommufd: Support marking and tracking persistent iommufds
  iommufd: Add plumbing for KHO (de)serialise
  iommu/intel: zap context table entries on kexec
  iommu: Support marking domains as persistent on alloc
  iommufd: Serialise persisted iommufds and ioas
  iommufd: Expose persistent iommufd IDs in sysfs
  iommufd: Re-hydrate a usable iommufd ctx from sysfs
  intel-iommu: Add serialise and deserialise boilerplate
  intel-iommu: Serialise dmar_domain on KHO activaet
  intel-iommu: Re-hydrate persistent domains after kexec
  iommu: Add callback to restore persisted iommu_domain
  iommufd, guestmemfs: Ensure persistent file used for persistent DMA
  iommufd, guestmemfs: Pin files when mapped for persistent DMA

 drivers/iommu/amd/iommu.c                   |   4 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |   3 +-
 drivers/iommu/intel/Makefile                |   1 +
 drivers/iommu/intel/dmar.c                  |   1 +
 drivers/iommu/intel/iommu.c                 |  84 ++++++--
 drivers/iommu/intel/iommu.h                 |  31 +++
 drivers/iommu/intel/serialise.c             | 174 ++++++++++++++++
 drivers/iommu/iommufd/Makefile              |   1 +
 drivers/iommu/iommufd/hw_pagetable.c        |   5 +-
 drivers/iommu/iommufd/io_pagetable.c        |   2 +-
 drivers/iommu/iommufd/ioas.c                |  26 +++
 drivers/iommu/iommufd/iommufd_private.h     |  34 ++++
 drivers/iommu/iommufd/main.c                |  75 ++++++-
 drivers/iommu/iommufd/selftest.c            |   1 +
 drivers/iommu/iommufd/serialise.c           | 213 ++++++++++++++++++++
 fs/guestmemfs/file.c                        |  25 +++
 fs/guestmemfs/guestmemfs.h                  |   1 +
 fs/guestmemfs/inode.c                       |   4 +
 include/linux/guestmemfs.h                  |  15 ++
 include/linux/iommu.h                       |  16 +-
 include/uapi/linux/iommufd.h                |   5 +
 21 files changed, 698 insertions(+), 23 deletions(-)
 create mode 100644 drivers/iommu/intel/serialise.c
 create mode 100644 drivers/iommu/iommufd/serialise.c

-- 
2.34.1


