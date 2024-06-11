Return-Path: <kvm+bounces-19345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD6C69042A5
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 19:45:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6F0D1C24B74
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 17:45:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D1AD59167;
	Tue, 11 Jun 2024 17:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="LXjNsKH6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3795579F;
	Tue, 11 Jun 2024 17:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718127913; cv=none; b=ZSTFyhUloO9psz4MkcPEA9RNG0OA6CagsMddE1124Rzaatt87X6BSLIc4cj9E2V2vV1xzu0Wd5L2GLZ2V5lZ1f+xN28mRitrLVtyI1iOCMK9KoP4dyNL2Kv3ew9j2LOdbnXDTPya6KJ7PgyukAUhCzNbolZk6QLQ6ME3Z458YOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718127913; c=relaxed/simple;
	bh=QQ02+mkzYjPRvb27y9YFwt+gKe6ixGuhqmmLhsFLGLo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BMDa71/+cBPwCwEhMYoySR1scs2vicabddSpp2jtu9/zxM6k2vJ9S10XY0ZK6WoVOtUhlo5BDec/FwBIm1ep08EwhjVgYXrgGdcir9JO14POVj7Evlo1lyH6SUeRub7pfzNPs1Wok4JFd5naxOVA5ta7v3GxWrExKhAS2phlqo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=LXjNsKH6; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1718127912; x=1749663912;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SOieNredUdM8JpFWUQxaEce8ZPl3Pr5HtLPDB7wvMwk=;
  b=LXjNsKH6NZElu9oCkJ4NaXgM5e8RQeZvmzFTBEVTCVN3RTaRq7/eCYlE
   xz1KvnYOvpcJ/CsrVK9DXkuQNjubsI7MDt/Khyt/EhgNIG4iS5V9eEcJT
   lYe855Dsu50rPaK6wfkKudkmJGnu9FfsIFYZz2V0XaHIew8Bd+uP4E/BX
   I=;
X-IronPort-AV: E=Sophos;i="6.08,230,1712620800"; 
   d="scan'208";a="96035021"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 17:45:09 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.17.79:61403]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.26.236:2525] with esmtp (Farcaster)
 id 4429eedd-bbf8-4dbb-a230-2b025dd2025c; Tue, 11 Jun 2024 17:45:08 +0000 (UTC)
X-Farcaster-Flow-ID: 4429eedd-bbf8-4dbb-a230-2b025dd2025c
Received: from EX19D007EUA001.ant.amazon.com (10.252.50.133) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Tue, 11 Jun 2024 17:45:08 +0000
Received: from EX19MTAUWA001.ant.amazon.com (10.250.64.204) by
 EX19D007EUA001.ant.amazon.com (10.252.50.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Tue, 11 Jun 2024 17:45:08 +0000
Received: from dev-dsk-fgriffo-1c-69b51a13.eu-west-1.amazon.com
 (10.13.244.152) by mail-relay.amazon.com (10.250.64.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34 via Frontend Transport; Tue, 11 Jun 2024 17:45:03 +0000
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
Subject: [PATCH v6 0/2] vfio/pci: add interrupt affinity support
Date: Tue, 11 Jun 2024 17:44:23 +0000
Message-ID: <20240611174430.90787-1-fgriffo@amazon.co.uk>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

v6:
 - corrections following review from Alex Williamson
   <alex.williamson@redhat.com>:
   - rename the new flag VFIO_IRQ_SET_DATA_CPUSET.
   - add a new VFIO_IRQ_INFO_CPUSET flag for IRQ_INFO.
   - rename the new vfio pci function vfio_pci_set_affinity()
     and calls it for both msi or intx interrupt.
   - use size_mul() for the VFIO_IRQ_SET_DATA_BOOL data
     size computation.
   - remove the specific cpumask_var_t allocation/release to
     handle DATA_CPUSET data copy as all the other flags, with
     the generic memdup_user(). The minor drawback is we then
     have to reject a cpu_set_t data smaller than the actual
     cpumask kernel structure.
  - in vfio_pci_set_affinity() use pci_irq_vector() to retrieve
    the irq number of each vector.

v5:
 - vfio_pci_ioctl_set_irqs(): fix copy_from_user() check when copying
   the cpumask argument. Reported by Dan Carpenter
   <dan.carpenter@linaro.org>
 - vfio_set_irqs_validate_and_prepare(): use size_mul() to compute the
   data size of a VFIO_IRQ_SET_DATA_EVENTFD ioctl() to avoid a possible
   overflow on 32-bit system. Reported by Dan Carpenter
   <dan.carpenter@linaro.org>
 - export system_32bit_el0_cpumask() to fix yet another missing symbol
   for arm64 architecture.

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
  vfio/pci: add interrupt affinity support

 arch/arm64/kernel/cpufeature.c    |  2 ++
 drivers/vfio/pci/vfio_pci_core.c  |  2 +-
 drivers/vfio/pci/vfio_pci_intrs.c | 41 +++++++++++++++++++++++++++++++
 drivers/vfio/vfio_main.c          | 20 ++++++++++++---
 include/uapi/linux/vfio.h         | 11 ++++++++-
 kernel/cgroup/cpuset.c            |  1 +
 6 files changed, 71 insertions(+), 6 deletions(-)


base-commit: cbb325e77fbe62a06184175aa98c9eb98736c3e8
--
2.40.1


