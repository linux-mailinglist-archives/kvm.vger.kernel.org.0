Return-Path: <kvm+bounces-47108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B0850ABD4F1
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 12:32:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 916F1188EE3F
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 10:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1924F27A12E;
	Tue, 20 May 2025 10:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dusq5jG2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDFD270EDB
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 10:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747736971; cv=none; b=n4UmkITU3c5M0uLqYnvmu1Dzxilp2DCFcF7F30neadth1bth8IkebAgiVgWdO9B0t1s94PIoHKzqpvHFYjieqDtr1DZQ2nsZjhWP+yArWVBNjHD9Zhdk45y23vrnsc4zMXXUStki9T1QiWZS6/kBum8Enuk4odI0ii1Sr+DCi9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747736971; c=relaxed/simple;
	bh=OSuErpkqUJGssDM/2HKZwtfnarun4vbCQ+Y6deq9Hhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfiZdl82v6lEkjlCSrNxsu/ZmFEiAcNXIMBR34WjZQN0VAQ0kHobpB+LQF8UE4ZdXviPy/rgmGKHstX24IjlxY2owL1m+AeVitwQFfesavpgQiI+LGyXtJPbuA6mIwsGsW1ps381DJxuRLU7WBdHM02j6ZmM5mBYc00S9VqwUH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dusq5jG2; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747736970; x=1779272970;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OSuErpkqUJGssDM/2HKZwtfnarun4vbCQ+Y6deq9Hhs=;
  b=Dusq5jG2mZkR4PObFEyJsFWxpAdTQOsQDGyM75QPkNV0YOAB4/7LrI96
   l+ZVqTVmzK26KYCItAgWvZwdKKcFRB4CSKxRv9RasYDGuIo+z/sa1OmK1
   7SbKxiSjHISH1QSEK65aiBDYL4y8XxxPTD/Sk+hZfUCTKulokZ95JltlM
   hEzhAAEK7vjwqcmFwN51A5LRrbgpk2Wqydr5mtqUBukxtT3F8IbtwGhYQ
   J7xGsndxKwuVenVmXVpk6y4FGiHLde0vSrZZ3fLDJl6t0Rt6dWMOES5MJ
   zYDUifF0gCdMIqQUzZrQpOo8A/jywWDhI8URFGBnv+tpBgb4EfqAXFnGH
   A==;
X-CSE-ConnectionGUID: 1pYtt6YYRraaSXaP7KYBjg==
X-CSE-MsgGUID: njwKJxx+Q3KWweILo9wnHw==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="49566674"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="49566674"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:29:30 -0700
X-CSE-ConnectionGUID: TGNIopkFRjSHPyy6DQtU4A==
X-CSE-MsgGUID: dLLYEA9gQ6iB4ii9cFAFGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="144905289"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:29:26 -0700
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>,
	Gupta Pankaj <pankaj.gupta@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Li Xiaoyao <xiaoyao.li@intel.com>
Subject: [PATCH v5 07/10] RAMBlock: Make guest_memfd require coordinate discard
Date: Tue, 20 May 2025 18:28:47 +0800
Message-ID: <20250520102856.132417-8-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250520102856.132417-1-chenyi.qiang@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As guest_memfd is now managed by RamBlockAttribute with
RamDiscardManager, only block uncoordinated discard.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v5:
    - Revert to use RamDiscardManager.

Changes in v4:
    - Modify commit message (RamDiscardManager->PrivateSharedManager).

Changes in v3:
    - No change.

Changes in v2:
    - Change the ram_block_discard_require(false) to
      ram_block_coordinated_discard_require(false).
---
 system/physmem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/system/physmem.c b/system/physmem.c
index f05f7ff09a..58b7614660 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1916,7 +1916,7 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
         }
         assert(new_block->guest_memfd < 0);
 
-        ret = ram_block_discard_require(true);
+        ret = ram_block_coordinated_discard_require(true);
         if (ret < 0) {
             error_setg_errno(errp, -ret,
                              "cannot set up private guest memory: discard currently blocked");
@@ -1939,7 +1939,7 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
              * ever develops a need to check for errors.
              */
             close(new_block->guest_memfd);
-            ram_block_discard_require(false);
+            ram_block_coordinated_discard_require(false);
             qemu_mutex_unlock_ramlist();
             goto out_free;
         }
@@ -2302,7 +2302,7 @@ static void reclaim_ramblock(RAMBlock *block)
     if (block->guest_memfd >= 0) {
         ram_block_attribute_destroy(block->ram_shared);
         close(block->guest_memfd);
-        ram_block_discard_require(false);
+        ram_block_coordinated_discard_require(false);
     }
 
     g_free(block);
-- 
2.43.5


