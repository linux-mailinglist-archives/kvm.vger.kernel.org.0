Return-Path: <kvm+bounces-66283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BA35FCCDA28
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 22:06:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E9C433073972
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 21:01:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41652221F00;
	Thu, 18 Dec 2025 20:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h0kKjdwA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71D822FF22;
	Thu, 18 Dec 2025 20:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766091125; cv=none; b=kxsJLurorPCnrPOfP4/H5RAMyKTQDj6na8cJuYtD6J/N9nLh7DENSWyOToaVbZskDLwAC4OXb2ObnhxZpDby+o1rSk5ZcjITASPMPi67mfaTDUEZQGzMpRktN8037vR+fzkcChOiyFpnU2F0Mus14N6dtSRES5D2y9L2f59gyAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766091125; c=relaxed/simple;
	bh=2XZdUtKR6MvONlRmAqwV3O6fAvfiIt4dTsRHLf3lBEs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bucV5KPXx+9kmw5/gNymxCnhV32JOWFqyo1Xj81TXa4XzjCpe2dTW8YpHwpQjYnW99oBc4zeFXUpv1A+JUITdi+zUFnIabrHCztyF0rrOaR/TG99xadK1feXUMp+ZCUaB/NZAmKe1Q/tCDo7oiYCs2UpuLcWCqFFlEK6PSY+TSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h0kKjdwA; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766091123; x=1797627123;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2XZdUtKR6MvONlRmAqwV3O6fAvfiIt4dTsRHLf3lBEs=;
  b=h0kKjdwAWxMIcCcOp4DM3Ea/0MK20eOb/0VFSnhKoXLrHeuatZ8/jhIh
   5tCxL7/aXkBmdFt/AA7vEwoboGPRPRhyDIovbE6TFb2/ZQI6Tn1CeHOR9
   6vomkkVba8E44jum0XpI7l7OMtbZLOaSsBoUa26Y+16usUGiJQsL6NRYe
   Bp/+H4M5A4BdcjCE0vnPFSxmZSoCIWSM5PAHEHK6NjC6txGKUS7+Y5K09
   Dqv8puyYdntiZq3f/pmuc5E1HchTlONaW6R0sPmyPcDHHrjPCnZ3QMN6O
   6t3aQVbMe49GTeqIKmtGMMi9bba97IsSShKY3k5LapbyYuDU6eUHYjaYI
   A==;
X-CSE-ConnectionGUID: ONLshfnYS9Sb7Oa4tRHlpw==
X-CSE-MsgGUID: ljedNb4STTGWZZ0Kzh0cxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11646"; a="71904920"
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="71904920"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 12:52:02 -0800
X-CSE-ConnectionGUID: oovG9KqhSQmpE0t3DfRTAQ==
X-CSE-MsgGUID: Xyis932jQZyEx5a3EmntDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="197834403"
Received: from mrbroom-desk1.ger.corp.intel.com (HELO mwajdecz-hp.clients.intel.com) ([10.246.20.17])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 12:51:59 -0800
From: Michal Wajdeczko <michal.wajdeczko@intel.com>
To: intel-xe@lists.freedesktop.org
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	Marcin Bernatowicz <marcin.bernatowicz@linux.intel.com>,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH] vfio/xe: Add default handler for .get_region_info_caps
Date: Thu, 18 Dec 2025 21:51:06 +0100
Message-ID: <20251218205106.4578-1-michal.wajdeczko@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

New requirement for the vfio drivers was added by the commit
f97859503859 ("vfio: Require drivers to implement get_region_info")
followed by commit 1b0ecb5baf4a ("vfio/pci: Convert all PCI drivers
to get_region_info_caps") that was missed by the new vfio/xe driver.

Add handler for .get_region_info_caps to avoid -EINVAL errors.

Fixes: 2e38c50ae492 ("vfio/xe: Add device specific vfio_pci driver variant for Intel graphics")
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
---
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Alex Williamson <alex@shazbot.org>
Cc: Michał Winiarski <michal.winiarski@intel.com>
Cc: Marcin Bernatowicz <marcin.bernatowicz@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
 drivers/vfio/pci/xe/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/xe/main.c b/drivers/vfio/pci/xe/main.c
index 0156b53c678b..719ab4660085 100644
--- a/drivers/vfio/pci/xe/main.c
+++ b/drivers/vfio/pci/xe/main.c
@@ -504,6 +504,7 @@ static const struct vfio_device_ops xe_vfio_pci_ops = {
 	.open_device = xe_vfio_pci_open_device,
 	.close_device = xe_vfio_pci_close_device,
 	.ioctl = vfio_pci_core_ioctl,
+	.get_region_info_caps = vfio_pci_ioctl_get_region_info,
 	.device_feature = vfio_pci_core_ioctl_feature,
 	.read = vfio_pci_core_read,
 	.write = vfio_pci_core_write,
-- 
2.47.1


