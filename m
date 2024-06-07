Return-Path: <kvm+bounces-19089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D0362900C47
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 21:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A7891F2371E
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 19:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30519149C55;
	Fri,  7 Jun 2024 19:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="G+zWQtHX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42D1D2E5;
	Fri,  7 Jun 2024 19:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717787413; cv=none; b=ChTu6hJmL5NYbB7swGYDTxV4F/JFld3jCrSZ1V+w6q5UnhvLHD/iLOHWfMzVWYFoP46qID4JCKdpogl8HHHqqUHFnDwi7/E67fE8oEsMwFgPIJCTuRBAVMP7p4lwjpT8iFDNgAT/vHDbECoCjaN3PLCcakIJmKEIvEon8qIi9zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717787413; c=relaxed/simple;
	bh=Z4QAKAxa4Z6eA8Xk0RNt4/hYgvYzXEdnVXDs3bnsvGw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JMChvbGVBurWAC5p0paSGB+UFCiohFxs5YsDaVFDlT9wwvdP8L1WeIWTwI1N23CJijeqpOwJrpNBU+P/PEZF+45fWJhGfpLH4rR4Nkc/lY5Da4Tl6Y48tEkqfp36x0Xy9JAz4tZ7VgYSiblhGZvqxHQgd0TiTkm3kPGXR2opbhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=G+zWQtHX; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1717787412; x=1749323412;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cSxRdA7CtZqMH5AHnu0pjbjgm4y83TDi1I22kwsZmWA=;
  b=G+zWQtHXmfXubDNFTDepYAk6wIz5BaO1db6q8RE4t1Io5Y4OYqMi21ut
   tRa2inuUCr3LHCG/BQ/KJ6HcRQkEqZ6SXLFqtZ+2NYOqiY03i+UqSCVCK
   FliK/N1lxR2Qg5LiAKvJ5jFUOW22WasckeaQto6pSmlqTGPMoWwoLOdUu
   w=;
X-IronPort-AV: E=Sophos;i="6.08,221,1712620800"; 
   d="scan'208";a="301930328"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 19:10:06 +0000
Received: from EX19MTAEUB001.ant.amazon.com [10.0.17.79:48726]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.2.117:2525] with esmtp (Farcaster)
 id 6c8e0930-de93-4c38-9937-28cedbcfa495; Fri, 7 Jun 2024 19:10:05 +0000 (UTC)
X-Farcaster-Flow-ID: 6c8e0930-de93-4c38-9937-28cedbcfa495
Received: from EX19D007EUA003.ant.amazon.com (10.252.50.8) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 7 Jun 2024 19:10:05 +0000
Received: from EX19MTAUWC001.ant.amazon.com (10.250.64.145) by
 EX19D007EUA003.ant.amazon.com (10.252.50.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 7 Jun 2024 19:10:04 +0000
Received: from dev-dsk-fgriffo-1c-69b51a13.eu-west-1.amazon.com
 (10.13.244.152) by mail-relay.amazon.com (10.250.64.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34 via Frontend Transport; Fri, 7 Jun 2024 19:10:00 +0000
From: Fred Griffoul <fgriffo@amazon.co.uk>
To: <griffoul@gmail.com>
CC: Fred Griffoul <fgriffo@amazon.co.uk>, Catalin Marinas
	<catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Alex Williamson
	<alex.williamson@redhat.com>, Waiman Long <longman@redhat.com>, Zefan Li
	<lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner
	<hannes@cmpxchg.org>, Mark Rutland <mark.rutland@arm.com>, Marc Zyngier
	<maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Mark Brown
	<broonie@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Joey Gouly
	<joey.gouly@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, Jeremy Linton
	<jeremy.linton@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu
	<yi.l.liu@intel.com>, Kevin Tian <kevin.tian@intel.com>, Eric Auger
	<eric.auger@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Christian
 Brauner" <brauner@kernel.org>, Ankit Agrawal <ankita@nvidia.com>, "Reinette
 Chatre" <reinette.chatre@intel.com>, Ye Bin <yebin10@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <cgroups@vger.kernel.org>
Subject: [PATCH v3 0/2] vfio/pci: add msi interrupt affinity support
Date: Fri, 7 Jun 2024 19:09:47 +0000
Message-ID: <20240607190955.15376-1-fgriffo@amazon.co.uk>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

v4:
 - export arm64_mismatched_32bit_el0 to compile the vfio driver as
   a kernel module on arm64 if CONFIG_CPUSETS is not defined.
 - vfio_pci_ioctl_set_irqs(): free the cpumask_var_t only if data_size
   is not zero, otherwise it was not allocated.
 - vfio_pci_set_msi_trigger(): call the new function
   vfio_pci_set_msi_affinity() later, after the DATA_EVENTFD
   processing and the vdev index check.

v3:
 - add a first patch to export cpuset_cpus_allowed() to be able to
   compile the vfio driver as a kernel module.

v2:
 - change the ioctl() interface to use a cpu_set_t in vfio_irq_set
   'data' to keep the 'start' and 'count' semantic, as suggested by
    David Woodhouse <dwmw2@infradead.org>

v1:

The usual way to configure a device interrupt from userland is to write
the /proc/irq/<irq>/smp_affinity or smp_affinity_list files. When using
vfio to implement a device driver or a virtual machine monitor, this may
not be ideal: the process managing the vfio device interrupts may not be
granted root privilege, for security reasons. Thus it cannot directly
control the interrupt affinity and has to rely on an external command.

This patch extends the VFIO_DEVICE_SET_IRQS ioctl() with a new data flag
to specify the affinity of a vfio pci device interrupt.

The affinity argument must be a subset of the process cpuset, otherwise
an error -EPERM is returned.

The vfio_irq_set argument shall be set-up in the following way:

- the 'flags' field have the new flag VFIO_IRQ_SET_DATA_AFFINITY set
as well as VFIO_IRQ_SET_ACTION_TRIGGER.

- the 'start' field is the device interrupt index. Only one interrupt
can be configured per ioctl().

- the variable-length array consists of one or more CPU index
encoded as __u32, the number of entries in the array is specified in the
'count' field.

Fred Griffoul (2):
  cgroup/cpuset: export cpuset_cpus_allowed()
  vfio/pci: add msi interrupt affinity support

 arch/arm64/kernel/cpufeature.c    |  1 +
 drivers/vfio/pci/vfio_pci_core.c  | 26 +++++++++++++++++----
 drivers/vfio/pci/vfio_pci_intrs.c | 39 +++++++++++++++++++++++++++++++
 drivers/vfio/vfio_main.c          | 13 +++++++----
 include/uapi/linux/vfio.h         | 10 +++++++-
 kernel/cgroup/cpuset.c            |  1 +
 6 files changed, 81 insertions(+), 9 deletions(-)


base-commit: cbb325e77fbe62a06184175aa98c9eb98736c3e8
--
2.40.1


