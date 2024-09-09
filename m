Return-Path: <kvm+bounces-26096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 78CB4970CE6
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 07:17:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2149EB21927
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 05:17:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C7F11AD27E;
	Mon,  9 Sep 2024 05:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SgfaDt55"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521A036B11;
	Mon,  9 Sep 2024 05:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725859056; cv=none; b=SXXRAzeNfELE/C+Qs2o0Ea2lTDBl06QyNvJTsO2iQpTpp9VZUvQfg7xj/SPZLUdck4kDFjP6IAyYxeLJj2lvSrbLbrt+ssF8T88QB+3UbJ6xrRic7Xj4ehO7qWgx62frlKs12CnTmw9RYP7RWuzD2MBS8Jv5BanUdYsQodS6Y+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725859056; c=relaxed/simple;
	bh=AsITGqxUQXjtOn3KpKG/emlPoDKBEPY4qyUPEUyEKUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Maqn+fdY959xr6yVzTND66qOXwGHLLPL8FgOiYUt6CUBJBLRUyHBKCaUaO4Te1S3po/LDclh0c6M4qH9t5mYunGXm7mBtwYtryRxd6lDGXI4XVJxynTfVoX2iCUZNTe1S3CYOixmVDGQAi7FyjMS8miiUCCVLsXrmhgZzmVJNM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SgfaDt55; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725859054; x=1757395054;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AsITGqxUQXjtOn3KpKG/emlPoDKBEPY4qyUPEUyEKUQ=;
  b=SgfaDt554JMHUHc2TrsZ2tsBmbP2gDilg2ICD8vLiTtQaal30RI2/tom
   FgTCtGms8KQx0HXV+mG6IwlxlEevy+Z2KNFsi84JO9pJQqqruyU8eCRlO
   KFWi2PNw/oG5vRBUUXf45AvOEFwZ6gEPkPyBDMnNwx5ExLIEdiArQQbAe
   1ovBkZfRvYvD2w6y4hGmkuG8ZBRFlsfsH3vaxMTmU7L9sgtL56YY2Lr7Q
   O/n3oHzMztXM/uWqSXOifjGczAWuZJhb4EFsc30Ycy9sBkBhU+oXPsv3R
   NmfSj+tJgUCIvvE9XFa58sbeZnCdquBv5joRAolPP8on6ZAzD1F+GS5L/
   A==;
X-CSE-ConnectionGUID: +yTGPE7xTDyvXy9SUhVSkg==
X-CSE-MsgGUID: oUKKhW6nS+iWKODvaW3tVQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11189"; a="24406634"
X-IronPort-AV: E=Sophos;i="6.10,213,1719903600"; 
   d="scan'208";a="24406634"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2024 22:17:33 -0700
X-CSE-ConnectionGUID: neJiYUOBQ/mmhdmgCmLFOA==
X-CSE-MsgGUID: mPR6cIWkSu+x+gdKx/x5ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,213,1719903600"; 
   d="scan'208";a="66772048"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2024 22:17:30 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: kraxel@redhat.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	daniel@ffwll.ch,
	virtualization@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH] drm/bochs: use ioremap_wc() to map framebuffer during driver probing
Date: Mon,  9 Sep 2024 13:15:29 +0800
Message-ID: <20240909051529.26776-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use ioremap_wc() instead of ioremap() to map framebuffer during driver
probing phase.

Using ioremap() results in a VA being mapped with PAT=UC-. Additionally,
on x86 architectures, ioremap() invokes memtype_reserve() to reserve the
memory type as UC- for the physical range. This reservation can cause
subsequent calls to ioremap_wc() to fail to map the VA with PAT=WC to the
same physical range for framebuffre in ttm_kmap_iter_linear_io_init().
Consequently, the operation drm_gem_vram_bo_driver_move() ->
ttm_bo_move_memcpy() -> ttm_move_memcpy() becomes significantly slow on
platforms where UC memory access is slow.

Here's the performance data measured in a guest on the physical machine
"Sapphire Rapids XCC".
With host KVM honors guest PAT memory types, the effective memory type
for this framebuffer range is
- WC when ioremap_wc() is used in driver probing phase
- UC- when ioremap() is used.

The data presented is an average from 10 execution runs.
The memcpy range for the data is
mem->bus.offset=0xfd000000, mem->size=0x3e8000.

--------------------------------------------------------------
                              |      in bochs_hw_init()       |
                              |    ioremap()   | ioremap_wc() |
------------------------------|----------------|--------------|
    cycles of                 |    2227.4M     |   17.8M      |
drm_gem_vram_bo_driver_move() |                |              |
------------------------------|----------------|--------------|
    time of                   |    1.24s       |   0.01s      |
drm_gem_vram_bo_driver_move() |                |              |
--------------------------------------------------------------

Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Closes: https://lore.kernel.org/all/87jzfutmfc.fsf@redhat.com/#t
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/gpu/drm/tiny/bochs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tiny/bochs.c b/drivers/gpu/drm/tiny/bochs.c
index 31fc5d839e10..6414f0a72f6a 100644
--- a/drivers/gpu/drm/tiny/bochs.c
+++ b/drivers/gpu/drm/tiny/bochs.c
@@ -261,7 +261,7 @@ static int bochs_hw_init(struct drm_device *dev)
 	if (pci_request_region(pdev, 0, "bochs-drm") != 0)
 		DRM_WARN("Cannot request framebuffer, boot fb still active?\n");
 
-	bochs->fb_map = ioremap(addr, size);
+	bochs->fb_map = ioremap_wc(addr, size);
 	if (bochs->fb_map == NULL) {
 		DRM_ERROR("Cannot map framebuffer\n");
 		return -ENOMEM;
-- 
2.43.2


