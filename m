Return-Path: <kvm+bounces-32945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B9D79E2D01
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 21:26:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9092CB36AD4
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 18:48:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE36D1FECC3;
	Tue,  3 Dec 2024 18:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pb9YzMdL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288411F7545;
	Tue,  3 Dec 2024 18:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733251679; cv=none; b=TvHyVtWfTBez2XF9aHFpfH6QcB0JxuZyNdiNTwCQuE8aJKJM/Tb1rG/WBUM9/TA6gcq7G3105VMZiyPWbDw9UKdaKw8Pt8l3sM2lCT1A6WcnwDNNP+o1MnLoXzImcwfBAYrymYVEg0lwYoRdCkqfrFWVOYFyouCTVPTDAZnFF3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733251679; c=relaxed/simple;
	bh=KGE06P5wGdeAx3Y/4+t5a/rj5ZkKtAQ3902PJPsdsog=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uSj5dMgjUaJ5E3HYwZZZNUszmTX56/TIevWX6RbG8JI6u0El/q1t+G06kQl26WJimgfiXDo5Q0vhajSx7ocHH2NoYISydg4S/wDCPVnkVt6lfENKRYnCG3ATsIid5vfxnK7crAI29yxPO53Ej+wOny6kmzIFV/q/lsdxuOdeJ70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pb9YzMdL; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733251678; x=1764787678;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KGE06P5wGdeAx3Y/4+t5a/rj5ZkKtAQ3902PJPsdsog=;
  b=Pb9YzMdLSUx51/qpaydecMuLsswxSlAeKIFFLlE1r6nbC9KA4EVK1X82
   5hl2+5ZLIdvO1JAB59WKxLKc0OxL28fIFPITArEiB9gsQtK/Y36ChzrW/
   l5jsFjtouqE4FurmHVnOGyNjEne2mcWZ+XlmVl0yIyuzAkTBaV/uVay3N
   2Q1E1EOfs1Q4/yqhZSYeDZE/Zv2PPwROsLcfjYLyWbc+45SNy3IDgBSo9
   yW0PkmF6pBQNpyW7bY1H6kIRMZ9CRBdR47fFWa80iGQmYf5ffQaE5QdWq
   cfLTqBfpYOBFM97O+yGJTU/+3r19wlYYLL7l+3ciDnPm6nH1MXvwT5xCA
   w==;
X-CSE-ConnectionGUID: 0b8FcaoxRNCi2MurX923Gg==
X-CSE-MsgGUID: J04FnVW5R2KbwUPn+JAN0Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11275"; a="37143167"
X-IronPort-AV: E=Sophos;i="6.12,205,1728975600"; 
   d="scan'208";a="37143167"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 10:47:55 -0800
X-CSE-ConnectionGUID: rEk1kLcETp6SCybnrqNSug==
X-CSE-MsgGUID: YHyvKJ04Si6l+HfHlWuBeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,205,1728975600"; 
   d="scan'208";a="93420015"
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
Subject: [PATCH v2 1/2] vfio/pci: Enable iowrite64 and ioread64 for vfio pci
Date: Tue,  3 Dec 2024 10:41:57 -0800
Message-Id: <20241203184158.172492-2-ramesh.thomas@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241203184158.172492-1-ramesh.thomas@intel.com>
References: <20241203184158.172492-1-ramesh.thomas@intel.com>
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


