Return-Path: <kvm+bounces-19015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 35AC48FF067
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 17:20:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3CA81F24FF7
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 15:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F50C19753F;
	Thu,  6 Jun 2024 15:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="nk7w70ZS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3001168C10;
	Thu,  6 Jun 2024 15:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717686658; cv=none; b=YA4tBhu4ImI9cI7pRnZuWGye3tGSg9UnVvTcOoX2y6IqV8JY5P74NB7SmtIIiuBsOgPFLe+9xP4hh5QNxbvNvjcrhEkUvsJk6xWpz4D9ym2chQJqPOB6eAnjmDSFsEEwkMknmlfQgjmmpapm8ZsWtIFQW2SjLlD0ZcLiCylPtxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717686658; c=relaxed/simple;
	bh=fbCSoygPwHdLM7iPTtWlurwOXaTi2Ksi8ooe/3rlYAE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JoUg8jsGwml3qMGwJ0H9v+cxFpUEWna17JsW0K4cdTAVTxRBcDhEANDf5V6A7J6h9Qy+QFuamtygTgTTAOj+UiVI/9wBlD6ytd+f9WyLSd3C9vd8NCi6mFIXpuSaWxGKV6Gb5A5sf+y4zmYoW3HWOC+1DS4+7yOaUihqmtstrGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=nk7w70ZS; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1717686657; x=1749222657;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sE/C5KmC7luL7orJdPJPqjjTa+YE7T9SOokR6V0nF6E=;
  b=nk7w70ZSz/+FICvKS19MupPfFErXfL0fgCftBICp+FwtgtXU6PZycDi5
   bT4lh7obsHz7g0Lv4wlYRf0qPICNsJghF6enSeRev9UqvzC5XXPwBbyEE
   7ZwafrYC5vZ9Odg7WuWwmOCXM53LFB8XsnSUrJNsDHF0MXEtjPON+J3im
   M=;
X-IronPort-AV: E=Sophos;i="6.08,219,1712620800"; 
   d="scan'208";a="94853772"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 15:10:53 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.43.254:31168]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.2.117:2525] with esmtp (Farcaster)
 id b4896dd1-c96a-4a12-a0b3-c91b6a8991d4; Thu, 6 Jun 2024 15:10:52 +0000 (UTC)
X-Farcaster-Flow-ID: b4896dd1-c96a-4a12-a0b3-c91b6a8991d4
Received: from EX19D007EUA001.ant.amazon.com (10.252.50.133) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 6 Jun 2024 15:10:50 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D007EUA001.ant.amazon.com (10.252.50.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 6 Jun 2024 15:10:49 +0000
Received: from dev-dsk-fgriffo-1c-69b51a13.eu-west-1.amazon.com
 (10.13.244.152) by mail-relay.amazon.com (10.250.64.254) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34 via Frontend Transport; Thu, 6 Jun 2024 15:10:47 +0000
From: Fred Griffoul <fgriffo@amazon.co.uk>
To: <griffoul@gmail.com>
CC: Fred Griffoul <fgriffo@amazon.co.uk>, Alex Williamson
	<alex.williamson@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu
	<yi.l.liu@intel.com>, Kevin Tian <kevin.tian@intel.com>, Eric Auger
	<eric.auger@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Christian
 Brauner" <brauner@kernel.org>, Ankit Agrawal <ankita@nvidia.com>, "Reinette
 Chatre" <reinette.chatre@intel.com>, Ye Bin <yebin10@huawei.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/2] vfio/pci: add msi interrupt affinity support
Date: Thu, 6 Jun 2024 15:10:11 +0000
Message-ID: <20240606151017.41623-1-fgriffo@amazon.co.uk>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

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
  cgroup/cpuset: export cpusset_cpus_allowed()
  vfio/pci: add msi interrupt affinity support

 drivers/vfio/pci/vfio_pci_core.c  | 26 +++++++++++++++++----
 drivers/vfio/pci/vfio_pci_intrs.c | 39 +++++++++++++++++++++++++++++++
 drivers/vfio/vfio_main.c          | 13 +++++++----
 include/uapi/linux/vfio.h         | 10 +++++++-
 kernel/cgroup/cpuset.c            |  1 +
 5 files changed, 80 insertions(+), 9 deletions(-)

--
2.40.1


