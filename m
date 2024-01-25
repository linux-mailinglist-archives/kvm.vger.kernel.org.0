Return-Path: <kvm+bounces-6909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2821383B7CF
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:28:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BBA31C22CBD
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8739510A18;
	Thu, 25 Jan 2024 03:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Msazv583"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B9CD287
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153290; cv=none; b=NsUQEO55Yd/5SQB+iIQIyC8bHg4yNMF/2MFg7DWh/zH1Hz7cY9dwseztwZ7wJSZ844Fsc0BiUCOW+ybusyS9udnMeE4cZG/DZxCaec+WRgZb73ccvnNyfQBGKMGiq+DbmeJTOjEZb/thADlzKgEIp+pW50nRobgjhQt1a+stWkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153290; c=relaxed/simple;
	bh=HeSIyCfwY3UukiDGQMr59wgL9NJm35/w6ryNr1Q1bMU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZZe9lZp4OXwR6SfCthbO7BA8GUy8SMN2vk2z/RmB88xSfoo+bz7i5o2Tt0UbVDBtWcPqxu5RPmyPKOGiDs4LXMyHjikzFdDDpWbvndHTnypnzBoXHS7/Upm6TWkGTpe9FmIczXbyg5g2uKwC78EPW3Myb/zIUOw8oqunQIsV474=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Msazv583; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153289; x=1737689289;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HeSIyCfwY3UukiDGQMr59wgL9NJm35/w6ryNr1Q1bMU=;
  b=Msazv583njSDj15cxS2HQ1zXFi0TEIhC0+u2LdeO4kJa57sSVnmTmzpA
   6rIGSxE5EFCf4G8D1ujnYtLgVHdLh4BZrMioJz9fqquiqbQLDg65+Z4bl
   OMNYPzNMbQEpmeESW7K9MNWnkN9J652PkztJvG+002P8AYDXKEkwTH3E9
   N4K6udYv8ltxAzPdjONK0Cg5PsdfF0OKIuNXqH4wIUG9Jqu6ZtepTtB6u
   y9O3PDVfS3QDyTem3OET7ekDGD/lmQw4ujmy3ttwyzBuckyn6z4U9JbRl
   zEIWZ1RD0eV8nTfGJHZnlA0rzSQjyOuoRJHofd+/x9sd//bU3252uqIai
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9427969"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9427969"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:24:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2084618"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:24:10 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v4 07/66] physmem: Introduce ram_block_discard_guest_memfd_range()
Date: Wed, 24 Jan 2024 22:22:29 -0500
Message-Id: <20240125032328.2522472-8-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125032328.2522472-1-xiaoyao.li@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
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
---
Changes in in v4:
- Drop ram_block_convert_range() and open code its implementation in the
  next Patch.
---
 include/exec/cpu-common.h |  2 ++
 system/physmem.c          | 23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index fef3138d29fc..05610efa8b4f 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -175,6 +175,8 @@ typedef int (RAMBlockIterFunc)(RAMBlock *rb, void *opaque);
 
 int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque);
 int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length);
+int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t start,
+                                        size_t length);
 
 #endif
 
diff --git a/system/physmem.c b/system/physmem.c
index 4735b0462ed9..fc59470191ef 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3626,6 +3626,29 @@ err:
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


