Return-Path: <kvm+bounces-22217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29FEC93BD06
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 09:23:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F23F1C21372
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 07:23:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B0C64428;
	Thu, 25 Jul 2024 07:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l66Z4CLG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4FF17109D
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 07:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721892175; cv=none; b=WksHwPAgcx/AgUshjPG1TZnsMQ7Z/mpBFcbXNEqPti0ieQNRU/i7Jp6Jccz+Kzadov/agG22UapgYh0ZwV01N+qVbA0/7hOCYlofWVgMsEgxcvnpi+s64KvL/KJw2qw+IPh9fGgVOo7t3B3H0bxCIz77VMPW8JNA2oid6CN/CrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721892175; c=relaxed/simple;
	bh=PifPO2VLSml++/yyEHfyB9LD6kSBnEg6UWh8hpYvOM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6Io8MoBRr3mA3G/9fpYkggo8W++Q/y2pkglJrLDag/gYGqLRpLFiFXcAJG78+X+Fg4upZ/jQ0/R/LJpuhrciyrV6z5Sxpq/b4ho95mRDZ2E0dNzHKjb+o5ncDQ7yOqqG5dZK/i/FZTeA/XOfVmD392eqSUc39iW9ies90p1yeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l66Z4CLG; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721892174; x=1753428174;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PifPO2VLSml++/yyEHfyB9LD6kSBnEg6UWh8hpYvOM8=;
  b=l66Z4CLGcdWH4D3mRiyFzWe2jiZyxM2t1mGWyqEGQAOcxcgkHRoJQ+oW
   pbNFnzwvAAW3/+McAitnVn58/idzuZOshz9BymQ7uI/ePW87+5c09dJI9
   EPTAag3uUx+o8REal3RjDGjBU3A9VLoZrOi7gPQEw3SES+xxSJRNUHF9f
   3Gp+oDMtheL290ZfRQEXTjRBND3RRVZaZuJIts6gRUO8Hv0tCsgjbY08P
   KNv/EyVNBnaGbPizmPEZHEBXabf7pDccS1DzC6XZ+swmJ6OUgXVLd4987
   wgoV7CVLtaLBfAFI5uRBi983kpPj9nuO2ed1B9bvuLjmBSvx4hi7wZYVm
   w==;
X-CSE-ConnectionGUID: buk/9EF8TEGdB653ijsFEQ==
X-CSE-MsgGUID: geWvxKo8RtCWgG6UOmguUA==
X-IronPort-AV: E=McAfee;i="6700,10204,11143"; a="30753989"
X-IronPort-AV: E=Sophos;i="6.09,235,1716274800"; 
   d="scan'208";a="30753989"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 00:22:53 -0700
X-CSE-ConnectionGUID: gFgeME1KR7eAyTzj7cKk1A==
X-CSE-MsgGUID: xo48P9PiTWaGNySerO1iQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,235,1716274800"; 
   d="scan'208";a="52858168"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 00:22:50 -0700
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Edgecombe Rick P <rick.p.edgecombe@intel.com>,
	Wang Wei W <wei.w.wang@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Wu Hao <hao.wu@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: [RFC PATCH 4/6] memory: Register the RamDiscardManager instance upon guest_memfd creation
Date: Thu, 25 Jul 2024 03:21:13 -0400
Message-ID: <20240725072118.358923-5-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240725072118.358923-1-chenyi.qiang@intel.com>
References: <20240725072118.358923-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instantiate a new guest_memfd_manager object and register it in the
target MemoryRegion. From this point, other subsystems such as VFIO can
register their listeners in guest_memfd_manager and receive conversion
events through RamDiscardManager.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 system/physmem.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/system/physmem.c b/system/physmem.c
index 33d09f7571..98072ae246 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -53,6 +53,7 @@
 #include "sysemu/hostmem.h"
 #include "sysemu/hw_accel.h"
 #include "sysemu/xen-mapcache.h"
+#include "sysemu/guest-memfd-manager.h"
 #include "trace/trace-root.h"
 
 #ifdef CONFIG_FALLOCATE_PUNCH_HOLE
@@ -1861,6 +1862,12 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
             qemu_mutex_unlock_ramlist();
             goto out_free;
         }
+
+        GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(object_new(TYPE_GUEST_MEMFD_MANAGER));
+        GuestMemfdManagerClass *gmmc = GUEST_MEMFD_MANAGER_GET_CLASS(gmm);
+        g_assert(new_block->mr);
+        gmmc->realize(OBJECT(gmm), new_block->mr, new_block->mr->size);
+        memory_region_set_ram_discard_manager(gmm->mr, RAM_DISCARD_MANAGER(gmm));
     }
 
     new_ram_size = MAX(old_ram_size,
@@ -2118,6 +2125,8 @@ static void reclaim_ramblock(RAMBlock *block)
 
     if (block->guest_memfd >= 0) {
         close(block->guest_memfd);
+        g_assert(block->mr);
+        object_unref(OBJECT(block->mr->rdm));
         ram_block_discard_require(false);
     }
 
-- 
2.43.5


