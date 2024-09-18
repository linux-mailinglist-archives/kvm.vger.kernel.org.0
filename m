Return-Path: <kvm+bounces-27085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC42297BE98
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 17:28:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 02259B20F47
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 15:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A3FF1C9859;
	Wed, 18 Sep 2024 15:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="QD5KAzrX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0500B1C8FBA
	for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 15:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726673303; cv=none; b=u96V4k7jwkm0sMj0NrUHc7OlxOAj5LpYM1VBCkNAOQyA90IE1Hoh6WCk2qOxc8OX9G2oYXxZSFgsqC+avV3z8ZFPSgQIv6xZa8i1e2gCfEmnxjl6PIU+sYkH+jq5y4k9Xi6P8GZybfCjUfj8yKC9JK5nBPJpm+ah0BmVpYk+LIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726673303; c=relaxed/simple;
	bh=4lpWST6t8mybHndN1aRSO27ONMTZqZptQQkLmxl6rCM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=c+KvhN5P6CvHHK+F0TLtHNleBTWNTa/sUDVoxRKuxumcRS/m8KFdBkeTh8xhw9I22MCKqOurp8Erfkeb2mMPR3olTHnsrpZZUEPNpPmfHqnL8KyZvdGe4PhcyWFdSWRRGy5QlvBC8LVtf4jx4wU7R/FXVbvJYKvqFI3ShVYfxR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=QD5KAzrX; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726673301; x=1758209301;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+i9gAx9JKpRUPJlbaH34JvHaf2WKdHtYbpj1plFSHWg=;
  b=QD5KAzrXH5HEre148BJD9qjOeu+CkTgTsZPr6PyuRs/o4Na5H4OH4jRV
   kD1hALU0LCiFlPhdrZFJiclz61O4pJojGTitb8+8KJTIqAj7+uzfYLMXd
   pLZXQ5AJCiPtOXWUmusNUXw8MBbXIUmBkm/ms/WTVasyAFVySG7ItIYdI
   8=;
X-IronPort-AV: E=Sophos;i="6.10,239,1719878400"; 
   d="scan'208";a="127584742"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 15:28:16 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.10.100:45210]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.31.173:2525] with esmtp (Farcaster)
 id 9ef85f35-6417-4148-bff7-667a5cffafdf; Wed, 18 Sep 2024 15:28:14 +0000 (UTC)
X-Farcaster-Flow-ID: 9ef85f35-6417-4148-bff7-667a5cffafdf
Received: from EX19D018EUC001.ant.amazon.com (10.252.51.197) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 18 Sep 2024 15:28:14 +0000
Received: from EX19MTAUWC002.ant.amazon.com (10.250.64.143) by
 EX19D018EUC001.ant.amazon.com (10.252.51.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 18 Sep 2024 15:28:14 +0000
Received: from email-imr-corp-prod-iad-all-1a-93a35fb4.us-east-1.amazon.com
 (10.25.36.210) by mail-relay.amazon.com (10.250.64.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Wed, 18 Sep 2024 15:28:13 +0000
Received: from dev-dsk-lilitj-1a-5039c68b.eu-west-1.amazon.com (dev-dsk-lilitj-1a-5039c68b.eu-west-1.amazon.com [172.19.104.233])
	by email-imr-corp-prod-iad-all-1a-93a35fb4.us-east-1.amazon.com (Postfix) with ESMTPS id 7F8544041D;
	Wed, 18 Sep 2024 15:28:12 +0000 (UTC)
From: Lilit Janpoladyan <lilitj@amazon.com>
To: <kvm@vger.kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<james.morse@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<nh-open-source@amazon.com>, <lilitj@amazon.com>
Subject: [PATCH 0/8] *** RFC: ARM KVM dirty tracking device ***
Date: Wed, 18 Sep 2024 15:27:59 +0000
Message-ID: <20240918152807.25135-1-lilitj@amazon.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

This patch series adds an ARM KVM interface for platform specific stage-2
page tracking devices and makes use of this interface for dirty tracking.

The page_tracking_device interface will be implemented by a device driver and
used by KVM. A device driver will register/deregister its implementation via
page_tracking_device_register()/page_tracking_device_unregister() functions;
KVM can use the device when page_tracking_device_registered() is true.

The page_tracking_device interface provides the following functionality:
- enabling\disabling dirty tracking for a VMID (+ optionally for a CPU id),
- reading GPAs dirtied by either any CPU (to populate dirty bitmaps) or
  by a specific CPU (to populate dirty rings)
- flushing not yet logged data.

KVM support for the page tracking device is added as a new extension and a
capability with the same name - KVM_CAP_ARM_PAGE_TRACKING_DEVICE. The 
capability is available when extension is supported (page_tracking_device_registered()
is true). When a device is available, new capability toggles device use for
dirty tracking. The capability is currently not compatible with the dirty ring
interface. At this moment only dirty bitmaps are supported as they allow userspace
to sync dirty pages from the hardware (e.g. PML) via kvm_arch_sync_dirty_log()
function. We have yet to add support for the dirty ring interface; which can sync
dirty pages into dirty rings either from userspace via a new ioctl or from KVM
on timer events.

For the page tracking device to be able to log guest write accesses this patch
series enables hardware management of the dirty state for stage-2 translations
by 1) setting VTCR_EL2.HD flag and 2) setting DBM (51) flag for the tracked
stage-2 descriptors. Currently KVM sets the DBM flag only when faulting in pages,
thus the first write to a page is logged by KVM as usual - on write fault, 
subsequent writes to the same page will be logged by a page tracking device.
We will optimize this by setting DBM flag when eagerly splitting huge pages.

An example of a device that tracks accesses to stage-2 translations and will
implement page_tracking_device interface is AWS Graviton Page Tracking Agent
(PTA). We'll be posting code for the Graviton PTA device driver in a separate
series of patches.

When ARM architectural solution (FEAT_HDBSS feature) is available, we intend to
use it via the same interface most likely with adaptations.


Lilit Janpoladyan (8):
  arm64: add an interface for stage-2 page tracking
  KVM: arm64: add page tracking device as a capability
  KVM: arm64: use page tracking interface to enable dirty logging
  KVM: return value from kvm_arch_sync_dirty_log
  KVM: arm64: get dirty pages from the page tracking device
  KVM: arm64: flush dirty logging data
  KVM: arm64: enable hardware dirty state management for stage-2
  KVM: arm64: make hardware manage dirty state after write faults

 Documentation/virt/kvm/api.rst         |  17 +++
 arch/arm64/include/asm/kvm_host.h      |   8 ++
 arch/arm64/include/asm/kvm_pgtable.h   |   1 +
 arch/arm64/include/asm/page_tracking.h |  79 +++++++++++++
 arch/arm64/kvm/Kconfig                 |  12 ++
 arch/arm64/kvm/Makefile                |   1 +
 arch/arm64/kvm/arm.c                   | 121 ++++++++++++++++++-
 arch/arm64/kvm/hyp/pgtable.c           |  29 ++++-
 arch/arm64/kvm/mmu.c                   |   8 ++
 arch/arm64/kvm/page_tracking.c         | 158 +++++++++++++++++++++++++
 arch/loongarch/kvm/mmu.c               |   3 +-
 arch/mips/kvm/mips.c                   |  12 +-
 arch/powerpc/kvm/book3s.c              |  12 +-
 arch/powerpc/kvm/booke.c               |  12 +-
 arch/riscv/kvm/mmu.c                   |   3 +-
 arch/s390/kvm/kvm-s390.c               |  13 +-
 arch/x86/kvm/x86.c                     |  21 +++-
 include/linux/kvm_host.h               |   4 +-
 include/uapi/linux/kvm.h               |   1 +
 virt/kvm/kvm_main.c                    |  34 ++++--
 20 files changed, 521 insertions(+), 28 deletions(-)
 create mode 100644 arch/arm64/include/asm/page_tracking.h
 create mode 100644 arch/arm64/kvm/page_tracking.c

-- 
2.40.1


