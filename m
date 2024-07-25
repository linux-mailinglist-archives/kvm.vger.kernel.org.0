Return-Path: <kvm+bounces-22216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 851D993BD05
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 09:23:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7EE81C21449
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 07:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CA5617107E;
	Thu, 25 Jul 2024 07:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TgN5jnHp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C971F4428
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 07:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721892171; cv=none; b=LH4SioBWnmFlo8KD8dy9ghYZ4jfxAv5tB0ubISUrUQdvn6Nv/UvLlkCznqkQg7V//XwJ/zYa47mEaFtCrx6KSyXu/4lsKjyYGG6bruam48dqelQbcWFJw1WCWfsZerIsAEsGk3M/l5nAwS9nbE082+8RQKR46Uh1S/YYXczgi8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721892171; c=relaxed/simple;
	bh=PzDthdOyXi8jqps5YCnKqKm2ZMk1q6Qbjz/AdVU9fYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFmeZtXo6po88TXgMUXeJQjZhfo8Css/DS7/H24JafECMlzyfPlmx0RJw2PEzggU1NkaSnyHvtgT8DsNHd6bFRWkc5eyYQ68e7zF5urWsQGht0XfjAuFiBZJu/m6uYolZx1d59tMoc2v7a0QEfMNNe7iPnChCaeJnokReaBtjt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TgN5jnHp; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721892170; x=1753428170;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PzDthdOyXi8jqps5YCnKqKm2ZMk1q6Qbjz/AdVU9fYE=;
  b=TgN5jnHpNqF3e/bbddPr8g9BKHtPvpUIqHb0pPsqWvuEPgjG/3r45T3W
   R3tHehXGBYTlx+KZ9BMJRx7zIpuFvTvdaTrazgI4VEQLFQ2quLqks3eIc
   5mxaJ73F20Alzv48nTE8loMtKVqQMHqkIpkxj6L225sXG+LH0bWPIsSsa
   zmQwNGE1CMxGKPIfujfN+eWQdKcJS7OXeqQSEVHXBp/8fw0E1G3SdhbxB
   DqCLogOCbim2lbivwiHQ1YJOA9oAav7bVaugq6vcWALhYsy8dlZw4WOeT
   qj/LGqXuLyd3ykWdOEmC15xucMtobMv9WHwFbxr2x/uVwTXzbfuPFAnJa
   w==;
X-CSE-ConnectionGUID: lH4tedJCS++or2xqrNwTbg==
X-CSE-MsgGUID: HwXM9t7WQbOYoMuo44LUzA==
X-IronPort-AV: E=McAfee;i="6700,10204,11143"; a="30753964"
X-IronPort-AV: E=Sophos;i="6.09,235,1716274800"; 
   d="scan'208";a="30753964"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 00:22:50 -0700
X-CSE-ConnectionGUID: BmOnfm53TROM4l4nb2FKiw==
X-CSE-MsgGUID: 1Cs7+M5qSK6v2R8gqF5zBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,235,1716274800"; 
   d="scan'208";a="52858161"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 00:22:46 -0700
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
Subject: [RFC PATCH 3/6] KVM: Notify the state change via RamDiscardManager helper during shared/private conversion
Date: Thu, 25 Jul 2024 03:21:12 -0400
Message-ID: <20240725072118.358923-4-chenyi.qiang@intel.com>
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

Once exit to userspace to convert the page from private to shared or
vice versa at runtime, notify the state change via the
guest_memfd_state_change() helper so that other registered subsystems
like VFIO can be notified.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 accel/kvm/kvm-all.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 854cb86b22..94bbbbd2de 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -48,6 +48,7 @@
 #include "kvm-cpus.h"
 #include "sysemu/dirtylimit.h"
 #include "qemu/range.h"
+#include "sysemu/guest-memfd-manager.h"
 
 #include "hw/boards.h"
 #include "sysemu/stats.h"
@@ -2852,6 +2853,7 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
     RAMBlock *rb;
     void *addr;
     int ret = -1;
+    GuestMemfdManager *gmm;
 
     trace_kvm_convert_memory(start, size, to_private ? "shared_to_private" : "private_to_shared");
 
@@ -2914,6 +2916,11 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
     addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
     rb = qemu_ram_block_from_host(addr, false, &offset);
 
+    gmm = GUEST_MEMFD_MANAGER(mr->rdm);
+    if (gmm) {
+        guest_memfd_state_change(gmm, offset, size, to_private);
+    }
+
     if (to_private) {
         if (rb->page_size != qemu_real_host_page_size()) {
             /*
-- 
2.43.5


