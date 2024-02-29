Return-Path: <kvm+bounces-10363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 91B8586C0DA
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:39:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2DF261F237FF
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ECD0482DF;
	Thu, 29 Feb 2024 06:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WfpZylEC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D23447F7F
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188702; cv=none; b=uJ3kb2z5VOGoJSvWXXDGPIRQzAO0qWd7qmFbj2u+vsvxr/W3x1IXBZxNG728+ssPq0l382n+id4mvngQlrVXQXSRuVopxibYgbn57AHhpgMnTobNpPx1B6PHe/O3O25GklRLQ2E6bQtLHPCVsTikbNYWR2Ol3YNdn4aMXys2hXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188702; c=relaxed/simple;
	bh=WAqfZmQu9OAek4ji1m8qxL8+r+CAlNqVbFvsF8ajRvo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l5J0orXPH8YX0f3+hw2V7dHeAnsdB+1/30zFkei8WaRPyFK9BwODu8VS7o3l4icjZcNMbEvCZwD15q3XtTY0IjOmXr272kpb4xUMKhKWzLjpN6IHEpv0iBkicBt0nKbrlAAWawpKl+p2me188Xj7Si1KC0IZgDVAWAt4bj6MwAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WfpZylEC; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188701; x=1740724701;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WAqfZmQu9OAek4ji1m8qxL8+r+CAlNqVbFvsF8ajRvo=;
  b=WfpZylECUuOu26I0ee2FTURaX1krWZ7M8Csj0IMYeJpa5AnrmmP2wDjc
   VzpNLU5n1hljPrZhtJr+Scguxyr/j1AYvebZriC/I9l+kGGkyIDlt0wS5
   AqutGANSz9AJTpy8wrIvTGYWfMPG8t3PQKv7zUoSFtMeWOrZa/q3LgEf/
   p4VB6iO396rhKfm2mzJAUMEG0QcrqNWf9Qgv1bTaIgyof7x/N34R8BqQA
   eaG6ZN6JlMzVKquvkPdRmArbSTT5wpozY8epEla4r+GVUr+g4lUuDsO0x
   eS6VIwhMvdm3Y/Z8zUIetKHHrVe5FDdGMjruJKgWzn49jhqS9/65czNTR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3802516"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3802516"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:38:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8074898"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:38:14 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	xiaoyao.li@intel.com
Subject: [PATCH v5 07/65] physmem: Introduce ram_block_discard_guest_memfd_range()
Date: Thu, 29 Feb 2024 01:36:28 -0500
Message-Id: <20240229063726.610065-8-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240229063726.610065-1-xiaoyao.li@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When memory page is converted from private to shared, the original
private memory is back'ed by guest_memfd. Introduce
ram_block_discard_guest_memfd_range() for discarding memory in
guest_memfd.

Originally-from: Isaku Yamahata <isaku.yamahata@intel.com>
Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
Changes in v5:
- Collect Reviewed-by from David;

Changes in in v4:
- Drop ram_block_convert_range() and open code its implementation in the
  next Patch.
---
 include/exec/cpu-common.h |  2 ++
 system/physmem.c          | 23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 9ead1be10057..ccd46ad3e173 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -166,6 +166,8 @@ typedef int (RAMBlockIterFunc)(RAMBlock *rb, void *opaque);
 
 int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque);
 int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length);
+int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t start,
+                                        size_t length);
 
 #endif
 
diff --git a/system/physmem.c b/system/physmem.c
index c4fc1e506de8..8c9368bc99ef 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3618,6 +3618,29 @@ err:
     return ret;
 }
 
+int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t start,
+                                        size_t length)
+{
+    int ret = -1;
+
+#ifdef CONFIG_FALLOCATE_PUNCH_HOLE
+    ret = fallocate(rb->guest_memfd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+                    start, length);
+
+    if (ret) {
+        ret = -errno;
+        error_report("%s: Failed to fallocate %s:%" PRIx64 " +%zx (%d)",
+                     __func__, rb->idstr, start, length, ret);
+    }
+#else
+    ret = -ENOSYS;
+    error_report("%s: fallocate not available %s:%" PRIx64 " +%zx (%d)",
+                 __func__, rb->idstr, start, length, ret);
+#endif
+
+    return ret;
+}
+
 bool ramblock_is_pmem(RAMBlock *rb)
 {
     return rb->flags & RAM_PMEM;
-- 
2.34.1


