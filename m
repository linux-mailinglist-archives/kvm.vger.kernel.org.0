Return-Path: <kvm+bounces-19184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E61FC90222A
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 14:57:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 619241F2126F
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 12:57:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FFE28248D;
	Mon, 10 Jun 2024 12:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="dXvxT2wI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FE180C1D;
	Mon, 10 Jun 2024 12:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718024250; cv=none; b=gTqP09ty8eACRD5zDn+qeTZ4RlSANhEaofT0RnmMJzbQUxrNlo2xjj8povIx3trjZZpHiTXv7kuBVFwkevJ6te1ESpmZNvPI8WmP1Jxa4ETTsda+PfEdODCw/hhsZfiOWfCr4RzGceH8/0ohNemao10OEATi6avESH26nZJl8/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718024250; c=relaxed/simple;
	bh=nJlLLJ2rBh0pTmSFO7XatNSh6LfP0lAb9qJiPmFoxzY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pixwywIv1CdoPerKS828X9wp/3di2Je9+5ERgHG4l7ij/ewa0Wt/F8ot+ealaB8DBZiKI1JmMd4jPt1lvNuW5iAhxx+t96wAuzhnizoABevmkUYTcuX1FRZbJ7YG6x7eBimgOANC6FGsVIedAcM0QWZ0FoxosdWEl/rTaMZvldU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=dXvxT2wI; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1718024249; x=1749560249;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ib8x6MUsFnm8OLqTHSSQ95s+8p+vISoBQLrMEQteYyg=;
  b=dXvxT2wIfzS5ZMLQ8zutroDw3BOPn/LhHzHaaqTE6Et3L147a4gZg9Fx
   HFORkWCUlOoiW7Bpq5nmg3Nd7PujLagNiNROqvnZG6gOJ4xZEXgsNV5Lz
   LacB6gy66Wkq0ihLdt1gFRpM+v3xUS0BNaGrIdDETgChp5QJMeJbTU5jE
   U=;
X-IronPort-AV: E=Sophos;i="6.08,227,1712620800"; 
   d="scan'208";a="3967790"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 12:57:27 +0000
Received: from EX19MTAEUB001.ant.amazon.com [10.0.10.100:53360]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.26.236:2525] with esmtp (Farcaster)
 id 9d700111-131b-461d-9914-1613d0d80b56; Mon, 10 Jun 2024 12:57:25 +0000 (UTC)
X-Farcaster-Flow-ID: 9d700111-131b-461d-9914-1613d0d80b56
Received: from EX19D007EUA004.ant.amazon.com (10.252.50.76) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 10 Jun 2024 12:57:25 +0000
Received: from EX19MTAUWA001.ant.amazon.com (10.250.64.204) by
 EX19D007EUA004.ant.amazon.com (10.252.50.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 10 Jun 2024 12:57:24 +0000
Received: from dev-dsk-fgriffo-1c-69b51a13.eu-west-1.amazon.com
 (10.13.244.152) by mail-relay.amazon.com (10.250.64.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34 via Frontend Transport; Mon, 10 Jun 2024 12:57:20 +0000
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
Subject: [PATCH v5 0/2] vfio/pci: add msi interrupt affinity support
Date: Mon, 10 Jun 2024 12:57:06 +0000
Message-ID: <20240610125713.86750-1-fgriffo@amazon.co.uk>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

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
  vfio/pci: add msi interrupt affinity support

 arch/arm64/kernel/cpufeature.c    |  2 ++
 drivers/vfio/pci/vfio_pci_core.c  | 27 +++++++++++++++++----
 drivers/vfio/pci/vfio_pci_intrs.c | 39 +++++++++++++++++++++++++++++++
 drivers/vfio/vfio_main.c          | 13 +++++++----
 include/uapi/linux/vfio.h         | 10 +++++++-
 kernel/cgroup/cpuset.c            |  1 +
 6 files changed, 83 insertions(+), 9 deletions(-)


base-commit: cbb325e77fbe62a06184175aa98c9eb98736c3e8
--
2.40.1


