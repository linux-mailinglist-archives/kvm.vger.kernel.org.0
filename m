Return-Path: <kvm+bounces-17998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A5DFD8CC992
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 01:26:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D629D1C21DDA
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 23:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D51F314B07F;
	Wed, 22 May 2024 23:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bp/6xQhJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC912146A95;
	Wed, 22 May 2024 23:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716420386; cv=none; b=XsbCIYoYS5GOlxiqr3+LjuhIryzReP6AmAg4hImDQJAGyvwlXfr1Q02P92eHNxFPmJs9/w6r5SA4w2za/GMDfNBy9zZNVWMp7yd8zrdGDC0iuQZKmy7fTMCzb3f+aWW/QsxIiTZfZiHfqdYlJBP3BtXIDEjnzoIPoLWwDLEZvsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716420386; c=relaxed/simple;
	bh=9ncjYOjKKFLJI68+icXqP1KKF3yTUVcBxw5EFZaIewM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Lphpj/CFQbJpK9Xz5byNcn9G42/54FToPQbpePhpDZfmUxEyuA/Bpze+G8dx7QubaTkw9rAz/t0CwjAcQVGoqHf4F4ozczKOhD2RTqa5+humBsZRuL/kZ4MxzGR8/3JAa+q6LW3v0WCwvJXvcwZLp/U7LDZR/FyiI5glZNMB/9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bp/6xQhJ; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716420384; x=1747956384;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9ncjYOjKKFLJI68+icXqP1KKF3yTUVcBxw5EFZaIewM=;
  b=Bp/6xQhJRCwcIBL2/XEdFja22/gbj9Gnv6UncW1X8XGO/kKX5bwBPIG6
   IcRCJg2M0DVS5LE1o4OPsBN3fF17WfZyd9sgE6TEo5gJO253KoB9a+iKk
   SiiWBNsr1v+62pT5NA2wPuo58hPoBnYD4bFyqabcAfJo7U3xJlABI+WY/
   /a+RW5jCd7SO2VD5CC5C2i03ieLjMIzr4Wt2a0dljDdJ2/b+9nb5JSl/C
   jvF2Jvdr7ByWh1gBhZY/Gi9qcTwC0TR27iJynVS9RK2nlrfJupsgNK1VM
   d3hrPvdq4v4MaEeqkux7Dd7y8dpwPhYrQIRl0/BsxEQ/00SbHdSbMmWs3
   w==;
X-CSE-ConnectionGUID: Yq/H44HPRQyyZUazxaPjUQ==
X-CSE-MsgGUID: yqZPc65uSWKbW3fLA36uCw==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="38086865"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="38086865"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 16:26:23 -0700
X-CSE-ConnectionGUID: Ec0yLkIRQgyTFcuo5wP2UA==
X-CSE-MsgGUID: th/ufplgTQ6oXXSgCCYZ2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="33914859"
Received: from rthomas.sc.intel.com ([172.25.112.51])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 16:26:23 -0700
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
	kevin.tian@intel.com
Subject: [PATCH] vfio/pci: Add iowrite64 and ioread64 support for vfio pci
Date: Wed, 22 May 2024 16:21:25 -0700
Message-Id: <20240522232125.548643-1-ramesh.thomas@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ioread64 and iowrite64 macros called by vfio pci implementations are
defined in asm/io.h if CONFIG_GENERIC_IOMAP is not defined. Include
linux/io-64-nonatomic-lo-hi.h to define iowrite64 and ioread64 macros
when they are not defined. io-64-nonatomic-lo-hi.h maps the macros to
generic implementation in lib/iomap.c. The generic implementation
does 64 bit rw if readq/writeq is defined for the architecture,
otherwise it would do 32 bit back to back rw.

Note that there are two versions of the generic implementation that
differs in the order the 32 bit words are written if 64 bit support is
not present. This is not the little/big endian ordering, which is
handled separately. This patch uses the lo followed by hi word ordering
which is consistent with current back to back implementation in the
vfio/pci code.

Refer patch series the requirement originated from:
https://lore.kernel.org/all/20240522150651.1999584-1-gbayer@linux.ibm.com/

Signed-off-by: Ramesh Thomas <ramesh.thomas@intel.com>
---
 drivers/vfio/pci/vfio_pci_priv.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 5e4fa69aee16..5eab5abf2ff2 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -3,6 +3,7 @@
 #define VFIO_PCI_PRIV_H
 
 #include <linux/vfio_pci_core.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
 
 /* Special capability IDs predefined access */
 #define PCI_CAP_ID_INVALID		0xFF	/* default raw access */
-- 
2.34.1


