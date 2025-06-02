Return-Path: <kvm+bounces-48224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A36FACBD9C
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 01:07:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C756C3A4001
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 23:07:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 651932522B6;
	Mon,  2 Jun 2025 23:07:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D55B46B8;
	Mon,  2 Jun 2025 23:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748905655; cv=none; b=su1fNU4tM+5LFW0/AR3SaW7e5AAbnzDSQsBglcX2KIbr3QpUet7uwB1tdxTEFFpBj7XQt0krQs/jEQ601hohncmlrM8+dbOSuus/nRGh1UczLBJsixzT20t6A3HauKo1xjxAWCW0BAj6lqxyL0HBa3UmJr6mUksQ150WzTV3WsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748905655; c=relaxed/simple;
	bh=XdhBC06MxRGs0J6I4K1b1h30EVioVJEFF+ZyG2+elCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+9Q7rJgluOknAAyxmAn/ZPH+2FOvf8m05ZKsVqFhwmsNXf0Qmyk+UqdayHYuyxY0me8EQ4WY9KmgrCLcrFNToZBFu4wlDTGI7PDiIg59k6VgUkgLsKl6wd8XU0Z01liXXU5obuu+92pr6oj9dbszuyrUpqpc6AUNwEfaaOsoSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8025B106F;
	Mon,  2 Jun 2025 16:07:15 -0700 (PDT)
Received: from ampere-altra-2-1.usa.arm.com (ampere-altra-2-1.usa.arm.com [10.118.91.158])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A2C6E3F59E;
	Mon,  2 Jun 2025 16:07:31 -0700 (PDT)
From: Wathsala Vithanage <wathsala.vithanage@arm.com>
To: linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com,
	gg@ziepe.ca,
	kevin.tian@intel.com,
	bhelgaas@google.com,
	pstanner@redhat.com,
	linux@treblig.org,
	schnelle@linux.ibm.com,
	Yunxiang.Li@amd.com,
	kvm@vger.kernel.org,
	Wathsala Vithanage <wathsala.vithanage@arm.com>
Subject: [RFC PATCH v2 0/1] VFIO ioctl for TLP Processing Hints
Date: Mon,  2 Jun 2025 23:06:39 +0000
Message-ID: <20250602230641.821485-1-wathsala.vithanage@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
References: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linux v6.13 introduced the PCIe TLP Processing Hints (TPH) feature for
direct cache injection. As described in the relevant patch set [1],
direct cache injection in supported hardware allows optimal platform
resource utilization for specific requests on the PCIe bus. This feature
is currently available only for kernel device drivers. However, user
space applications, especially those whose performance is sensitive to
the latency of inbound writes as seen by a CPU core, may benefit from
using this information (E.g., DPDK cache stashing RFC [2] or an HPC
application running in a VM). For such applications to enable and
configure TPH on PCIe devices, this RFC proposes a new VFIO ioctl.

[1] lore.kernel.org/linux-pci/20241002165954.128085-1-wei.huang2@amd.com
[2] inbox.dpdk.org/dev/20241021015246.304431-2-wathsala.vithanage@arm.com

V1->V2:
 * Rewrite as a VFIO IOCTL
 * Add missing padding for structs
 * Increase maximum steering tags per IOCTL to 2048

Wathsala Vithanage (1):
  vfio/pci: add PCIe TPH device ioctl

 drivers/vfio/pci/vfio_pci_core.c | 153 +++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h        |  83 +++++++++++++++++
 2 files changed, 236 insertions(+)

-- 
2.43.0


