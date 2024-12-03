Return-Path: <kvm+bounces-32944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B7F89E2B50
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 19:48:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6091282F7C
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 18:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02EB11FC7C6;
	Tue,  3 Dec 2024 18:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HRFiJEZ+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4951362;
	Tue,  3 Dec 2024 18:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733251677; cv=none; b=RuQI9lAXLIVE8OA6vgrz4EgaqWVfPxFzItKQ86AtU8WDHupVcLEhJLn4LuQwX0OBtcnZgr/sVP+QGy8UPG6qqeEqAjVQ77uUtApNaDbX/mO+Uv2i39JSl7NkeTsycLXYMX5nPuwAmLWzYSlyyGGvovVfekNI/OMdy4puBTkd4vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733251677; c=relaxed/simple;
	bh=62qKMZZWNcz5M+209QiFVBa+TWcB3rtKMsA/EBEsFAM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TAJ7JXOqycZLAdkgaiiCXF/NvSdXdrH/VVgc5rngXdmafp3c0KxcCp+QFFpqaL1nLkjFYzQcujsCpD5UuGxnRhy64s5LsgIRbzWg9zeRtzkhsf1IqGDOOODEcICZnhZaa46B9mH87NZwaE4Z6I0QV8WtuIkZ1pdgUv/BVILzCLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HRFiJEZ+; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733251676; x=1764787676;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=62qKMZZWNcz5M+209QiFVBa+TWcB3rtKMsA/EBEsFAM=;
  b=HRFiJEZ+UeJKefNw6UgtRSjQtVrQqDsikbJGgcfFF1/wmVLQYqtZGdGE
   05Xy4vbEgn4FhMOznsKPOmIkTE/X/iNmAh/m3S0PyhQAYkuoIX8wFc83m
   2N7FH3ll57MCVY9+cobLNaP7OBKJxBO+fCNFQuds1fYglvKflqA+CGOdT
   G2iXiSvmOEBRPkaf8S3Pzn8GZBg/mpC8og7VoqeNDZ+c66uv8Z7nknumB
   6LNMEHWWJoYpyHA9LONR+h7W+cz9CADZo1D7zxCUe9LHGvGOBCHW3fL+G
   x73QJqTZvMAVn8fqmgl+AYZasC1GmcJLadj9QVaIO4Qa7PkkfDwsw1UXz
   A==;
X-CSE-ConnectionGUID: afDQlZKeRlay4ai3iymM4g==
X-CSE-MsgGUID: +vmghaZmRSyREKPlNae/JA==
X-IronPort-AV: E=McAfee;i="6700,10204,11275"; a="37143160"
X-IronPort-AV: E=Sophos;i="6.12,205,1728975600"; 
   d="scan'208";a="37143160"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 10:47:55 -0800
X-CSE-ConnectionGUID: AsBODGdQSZOoo3sEf9T5GQ==
X-CSE-MsgGUID: n+55R6mgRIebNkinu6YKpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,205,1728975600"; 
   d="scan'208";a="93420011"
Received: from rthomas.sc.intel.com ([172.25.112.51])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 10:47:54 -0800
From: Ramesh Thomas <ramesh.thomas@intel.com>
To: alex.williamson@redhat.com,
	jgg@ziepe.ca,
	schnelle@linux.ibm.com,
	gbayer@linux.ibm.com
Cc: kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	ankita@nvidia.com,
	yishaih@nvidia.com,
	pasic@linux.ibm.com,
	julianr@linux.ibm.com,
	bpsegal@us.ibm.com,
	ramesh.thomas@intel.com,
	kevin.tian@intel.com,
	cho@microsoft.com
Subject: [PATCH v2 0/2] Extend 8-byte PCI load/store support to x86 arch
Date: Tue,  3 Dec 2024 10:41:56 -0800
Message-Id: <20241203184158.172492-1-ramesh.thomas@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series extends the recently added 8-byte PCI load/store
support to the x86 architecture. 

Refer patch series adding above support:
https://lore.kernel.org/all/20240522150651.1999584-1-gbayer@linux.ibm.com/

The 8-byte implementations are enclosed inside #ifdef checks of the
macros "ioread64" and "iowrite64". These macros don't get defined if
CONFIG_GENERIC_IOMAP is defined. CONFIG_GENERIC_IOMAP gets defined for
x86 and hence the macros are undefined. Due to this the 8-byte support
was not enabled for x86 architecture.

To resolve this, include the header file io-64-nonatomic-lo-hi.h that
maps the ioread64 and iowrite64 macros to a generic implementation in
lib/iomap.c. This was the intention of defining CONFIG_GENERIC_IOMAP.

Tested using a pass-through PCI device bound to vfio-pci driver and
doing BAR reads and writes that trigger calls to
vfio_pci_core_do_io_rw() that does the 8-byte reads and writes.

Patch history:
v2: Based on Jason's feedback moved #include io-64-nonatomic-lo-hi.h
to vfio_pci_rdwr.c and replaced #ifdef checks of iowrite64 and ioread64
macros with checks for CONFIG_64BIT.

https://lore.kernel.org/all/20240522232125.548643-1-ramesh.thomas@intel.com/
https://lore.kernel.org/all/20240524140013.GM69273@ziepe.ca/
https://lore.kernel.org/all/bfb273b2-fc5e-4a8b-a40d-56996fc9e0af@intel.com/

Ramesh Thomas (2):
  vfio/pci: Enable iowrite64 and ioread64 for vfio pci
  vfio/pci: Remove #ifdef iowrite64 and #ifdef ioread64

 drivers/vfio/pci/vfio_pci_rdwr.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

-- 
2.34.1


