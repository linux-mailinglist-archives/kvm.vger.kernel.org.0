Return-Path: <kvm+bounces-33414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 365039EB1D7
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 14:26:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DD08188A131
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 13:25:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A86A1AA782;
	Tue, 10 Dec 2024 13:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W4GZFqfX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021031A9B2B;
	Tue, 10 Dec 2024 13:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733837137; cv=none; b=KcCdUPGfD9QIstHCwbaqp6CqbvcFUpwb5ibNzl+WdHvdtx35uACFe39LLxKGKe/ncZn5YiP8acRoicQwQzBQiDhfFiTW3DoQPGVligsQ9Q0R3aIoByv6IPioYSJlF268b4tjsdykBjoS5Y555JZjNFUMWxWXv37x/GX9RQEjBKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733837137; c=relaxed/simple;
	bh=KGE06P5wGdeAx3Y/4+t5a/rj5ZkKtAQ3902PJPsdsog=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DaLfrhmBNwo+WU9WSdtGy4V8ogFlK3l567Awh9QCYjlPc8CxHk8G2mMBiUuOHKUcXsAmmw9IBPwMl1EePNzw0reoZthNlt6YdEIFInsdueYXr4hQbmG1jmdAqnVcgI8ztTzM0f+06kuE395FKJ5/LDySn/fmyXCHxgAC9Kcfj2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W4GZFqfX; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733837136; x=1765373136;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KGE06P5wGdeAx3Y/4+t5a/rj5ZkKtAQ3902PJPsdsog=;
  b=W4GZFqfXmWZNiswnlGuXhmOO8NyHlScMxHw/YjdeaQO8fIfLF3Bo/XfE
   roYUOvLmMYrXTdqPHOk/hptuDpn02IrwelHx11K7S0oox4fz2uxKPciQ7
   g1vRqeAQsjvojciCSdAYDXG5awNxpk96z48ZIdU3IxqXRixyGetA84b52
   Q42fV/RnwxmArdLAZASerwxJwfulKsapeNPCPlMpWtL/UmSL7dtrH/cok
   KAz0ic/zGOwyOrDmQnh3EFrybZlsFaiX94DoxuhbFBzvlyZtnhLwRkTof
   YsjXTH4WNFkIQuuHGiiKBUBoOUoMUghoG2K/vPkIhyiDgE671wAe1w0Id
   A==;
X-CSE-ConnectionGUID: nKpQyM/8RhiK/yjrJ8rsCw==
X-CSE-MsgGUID: mFdZsAA0SgK45AcaqU/oaA==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="37864751"
X-IronPort-AV: E=Sophos;i="6.12,222,1728975600"; 
   d="scan'208";a="37864751"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 05:25:34 -0800
X-CSE-ConnectionGUID: pkSpKLM5TzOryx0MbDlNpA==
X-CSE-MsgGUID: JEKpzjIfSG6148RmiiCKpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,222,1728975600"; 
   d="scan'208";a="95750020"
Received: from rthomas.sc.intel.com ([172.25.112.51])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 05:25:33 -0800
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
Subject: [PATCH v3 1/2] vfio/pci: Enable iowrite64 and ioread64 for vfio pci
Date: Tue, 10 Dec 2024 05:19:37 -0800
Message-Id: <20241210131938.303500-2-ramesh.thomas@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241210131938.303500-1-ramesh.thomas@intel.com>
References: <20241210131938.303500-1-ramesh.thomas@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Definitions of ioread64 and iowrite64 macros in asm/io.h called by vfio
pci implementations are enclosed inside check for CONFIG_GENERIC_IOMAP.
They don't get defined if CONFIG_GENERIC_IOMAP is defined. Include
linux/io-64-nonatomic-lo-hi.h to define iowrite64 and ioread64 macros
when they are not defined. io-64-nonatomic-lo-hi.h maps the macros to
generic implementation in lib/iomap.c. The generic implementation does
64 bit rw if readq/writeq is defined for the architecture, otherwise it
would do 32 bit back to back rw.

Note that there are two versions of the generic implementation that
differs in the order the 32 bit words are written if 64 bit support is
not present. This is not the little/big endian ordering, which is
handled separately. This patch uses the lo followed by hi word ordering
which is consistent with current back to back implementation in the
vfio/pci code.

Signed-off-by: Ramesh Thomas <ramesh.thomas@intel.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 66b72c289284..a0595c745732 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -16,6 +16,7 @@
 #include <linux/io.h>
 #include <linux/vfio.h>
 #include <linux/vgaarb.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
 
 #include "vfio_pci_priv.h"
 
-- 
2.34.1


