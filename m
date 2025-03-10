Return-Path: <kvm+bounces-40607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FEB4A58DF2
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 09:21:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D9B13188DEB7
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:21:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9400223326;
	Mon, 10 Mar 2025 08:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bHS56YfZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3771DE4FA
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741594849; cv=none; b=TCLdHruuNgDYfOCMXjeLogIgbPBXYvEx4VV7UwLA2+rg4wBwLX5rBdof1Ez/kJPdcDU5GsGMZXcQpqKfrOPRGjvLRLcbREukDJtn2TFxiieTSJ59B7KP2g/uJ0GkNnZqb1eNjE4TZjQ0eMnoqgoJITX1VA6BinltjF/z2Es0UU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741594849; c=relaxed/simple;
	bh=hNdLZ8kK1rf9TDHkt6IAvF/6Xekzb2aG95CQUh+XPPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rmy35enxJZraWOeiHIejyZt1CDcVYR6SIjepWUN4xIm7FXyCcqLkUj9Jam0/NL1VfBVJKYWWBAFlyUS9Y72Zu3SD0ADJ4SmVi5Mjxc6XEISHr5StGUpOV3Al1rV+LQInoCAS8iPtqR8x8OsRLUcCEcRBiATKvXauU1Mhmvo46E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bHS56YfZ; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741594847; x=1773130847;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hNdLZ8kK1rf9TDHkt6IAvF/6Xekzb2aG95CQUh+XPPY=;
  b=bHS56YfZFVMzG4CTzrOtM/IASZuq+dyX/JI3yvAyaOGJrMQKMQvbzM/M
   3UOYxeiySGSqQ79B/p4EJDApZiYOtOHK+EMFdZ5gfwDyorO6+UgxGVaP5
   KjQrMC6ICCJHV4XU2FTKyiYm7AU/8cOnPWI99JkheLRuFQ0+guwLoF36h
   qgSUJ/8yyTW7MDaoIDbawxmv3ArdtwAKat7xzRLsRcfazPNzfdaLjrQT7
   Kf8S5G0EywDLwwA6EqhHD7LYVulmpaTfu1DllTEiMgYwkz55dzNsWup6d
   vwT4yvNoixNYf+/3kbECnY8KE5/IKqdOAkScncu4xknA/hZPi3pn5tQ6y
   Q==;
X-CSE-ConnectionGUID: CF/zMlA7RfinZSVLiaEtXQ==
X-CSE-MsgGUID: rX49QVI6RFGcFqy6lIa+pg==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="42688569"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="42688569"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 01:20:46 -0700
X-CSE-ConnectionGUID: Rr8bERHAT9qYYs5LAc7IXg==
X-CSE-MsgGUID: v2iKTpieQ3yncekKnk3AjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="150862863"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 01:20:38 -0700
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Li Xiaoyao <xiaoyao.li@intel.com>
Subject: [PATCH v3 7/7] RAMBlock: Make guest_memfd require coordinate discard
Date: Mon, 10 Mar 2025 16:18:35 +0800
Message-ID: <20250310081837.13123-8-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250310081837.13123-1-chenyi.qiang@intel.com>
References: <20250310081837.13123-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As guest_memfd is now managed by memory_attribute_manager with
RamDiscardManager, only block uncoordinated discard.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v3:
    - No change.

Changes in v2:
    - Change the ram_block_discard_require(false) to
      ram_block_coordinated_discard_require(false).
---
 system/physmem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/system/physmem.c b/system/physmem.c
index 0ed394c5d2..a30cdd43ee 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1872,7 +1872,7 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
         assert(kvm_enabled());
         assert(new_block->guest_memfd < 0);
 
-        ret = ram_block_discard_require(true);
+        ret = ram_block_coordinated_discard_require(true);
         if (ret < 0) {
             error_setg_errno(errp, -ret,
                              "cannot set up private guest memory: discard currently blocked");
@@ -1892,7 +1892,7 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
             error_setg(errp, "Failed to realize memory attribute manager");
             object_unref(OBJECT(new_block->memory_attribute_manager));
             close(new_block->guest_memfd);
-            ram_block_discard_require(false);
+            ram_block_coordinated_discard_require(false);
             qemu_mutex_unlock_ramlist();
             goto out_free;
         }
@@ -2152,7 +2152,7 @@ static void reclaim_ramblock(RAMBlock *block)
         memory_attribute_manager_unrealize(block->memory_attribute_manager);
         object_unref(OBJECT(block->memory_attribute_manager));
         close(block->guest_memfd);
-        ram_block_discard_require(false);
+        ram_block_coordinated_discard_require(false);
     }
 
     g_free(block);
-- 
2.43.5


