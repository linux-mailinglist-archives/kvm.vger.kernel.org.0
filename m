Return-Path: <kvm+bounces-71038-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oCzaCGnrjmkCGAEAu9opvQ
	(envelope-from <kvm+bounces-71038-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 10:14:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B24613453F
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 10:14:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C06033033508
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 09:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58167349AEA;
	Fri, 13 Feb 2026 09:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HcNk/thk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB61D330B27
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 09:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770974048; cv=none; b=FMgczfpesRp+hiGlbcv0iKQ9SvcIenS4Oq/MhAItv7sIZcDm9c77K7Jhohw9f1zYtznAQkPvLEAsyd90RDLPPmAAzjXIsO6pTiIkqenMX0txul3zmFohZ8H8u8RaTvnxWDfrTVG59UHB6C0W8vd6KlDCE1T0sfmVUEX/XJdcRiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770974048; c=relaxed/simple;
	bh=PMa6YgrazO3G78nBzIeQZbhkPv0pBL3ypWbxUNNFUmY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=BkLLjDyHlVXJc/8t1YoSlaev88AHphnvq9A5OoS9Ncn0wWGseFXIr6L4IO9bE6hQ0OirQfqkp6pjyt8oxpa5AKwzAHWlfC/VxJatHTUZeDbD5p8vLYrzw9pes8Qb7irQ/jvhXVMhKULR8WCH8zbdcG1lCVaoP7UoQY8zI8/znF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HcNk/thk; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770974047; x=1802510047;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PMa6YgrazO3G78nBzIeQZbhkPv0pBL3ypWbxUNNFUmY=;
  b=HcNk/thkBWcmxPiqtz0G5s7I+Z/G8yS0OCsqfh1mRhlq8EpDg0Ug/9oH
   vU/vz2th3pTr6vtfxkUVsFZ0U/oTErcJKZwtjdiZ9yj83P7twQL2iI9rh
   iATTiqnV4AbjoK8ggAF2aG4YLbMcKTTZ1ICIca6cqe4ZC+lQGjgYdJg0/
   Xt5fJCCNRKuWh8j1KBiitlRQ1f0svrEhYdiMYxxuekwlHex1A2OKYpiht
   xvGi8we/Wr3wEl0co3LpJGw2pAsx9IL9TKi/VEBTnpDD1Q8vW4x7s/aQK
   7gp07Rp3zgXkEeWThW2/oT2znKOVsWpi6jkv+hl8TySdtVj0OXEm/bhOL
   g==;
X-CSE-ConnectionGUID: kl4eGaPDRPOrS2nSTfjoPw==
X-CSE-MsgGUID: gSHt7zKHTbePhiKh9FIaBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="72051240"
X-IronPort-AV: E=Sophos;i="6.21,288,1763452800"; 
   d="scan'208";a="72051240"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2026 01:14:06 -0800
X-CSE-ConnectionGUID: 1IQ8Tg52Snqp27jJZP5qpg==
X-CSE-MsgGUID: ahoeqJcgTWqLDttINTUouw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,288,1763452800"; 
   d="scan'208";a="242311423"
Received: from dmr-suman.iind.intel.com ([10.49.14.197])
  by fmviesa001.fm.intel.com with ESMTP; 13 Feb 2026 01:14:04 -0800
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: jgg@ziepe.ca,
	yishaih@nvidia.com,
	skolothumtho@nvidia.com,
	kevin.tian@intel.com,
	giovanni.cabiddu@intel.com,
	alex@shazbot.org,
	kvm@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH] vfio/qat: extend Kconfig dependencies for 420xx and 6xxx devices
Date: Fri, 13 Feb 2026 09:14:03 +0000
Message-ID: <20260213091403.72338-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_NEQ_ENVFROM(0.00)[suman.kumar.chakraborty@intel.com,kvm@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-71038-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim,intel.com:email]
X-Rspamd-Queue-Id: 9B24613453F
X-Rspamd-Action: no action

From: Vijay Sundar Selvamani <vijay.sundar.selvamani@intel.com>

Currently, the QAT VFIO PCI driver can only be configured when the 4xxx
QAT driver (CRYPTO_DEV_QAT_4XXX) is enabled. This is too restrictive as
the VFIO driver also supports VFs from the 420xx and 6xxx device
families, which share a compatible migration interface.

Extends the Kconfig dependencies to allow configuration when any of the
supported QAT device families (4xxx, 420xx, or 6xxx) are enabled.

Signed-off-by: Vijay Sundar Selvamani <vijay.sundar.selvamani@intel.com>
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/vfio/pci/qat/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/qat/Kconfig b/drivers/vfio/pci/qat/Kconfig
index bf52cfa4b595..83f037d7e9a4 100644
--- a/drivers/vfio/pci/qat/Kconfig
+++ b/drivers/vfio/pci/qat/Kconfig
@@ -2,7 +2,7 @@
 config QAT_VFIO_PCI
 	tristate "VFIO support for QAT VF PCI devices"
 	select VFIO_PCI_CORE
-	depends on CRYPTO_DEV_QAT_4XXX
+	depends on CRYPTO_DEV_QAT_4XXX || CRYPTO_DEV_QAT_420XX || CRYPTO_DEV_QAT_6XXX
 	help
 	  This provides migration support for Intel(R) QAT Virtual Function
 	  using the VFIO framework.

base-commit: b10c62483b324e60e45fb27d7fdc09c9198993d7
-- 
2.52.0


