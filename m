Return-Path: <kvm+bounces-6908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 802DD83B7CE
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:28:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C6FB1B2370D
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A8E010A01;
	Thu, 25 Jan 2024 03:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YcLcY6f1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD8C8826
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153290; cv=none; b=AtmORpn/90mxj0KRK/KGgxewxyFG9VqZ0xQz+v9PSpo9RJDtJtRYyJEMP2lEfbnI6/y/1ia0JBoWZfI+4I7NcY2nD3lZQgrw0dlIKVyr3AP640MGT2/MVZ54pZ2wqoZsFKorXa0xrYUFWnS15/Pi1njNeBuCteA0PEMchi4PZsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153290; c=relaxed/simple;
	bh=8AoHBD7YPJCeSiiafbeRxLUlYdqPOgOF84h3ug2/0pE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JiDSW0yQUyOGmcFxcAK/Tp6i6zHxV+7d18Yk+ckoIN0RRtW7loxJvLJFdOnP08qBl9pTo0DVAMquEXz6AkBibDwYqDzUO3z5SJQuqZUmaVDj76wPDUPPBtKZFUw7LEaKKLYF+AcpDlPxmyDCWrmZstc3DPgOSK+66Doe6Xt6ZvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YcLcY6f1; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153288; x=1737689288;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8AoHBD7YPJCeSiiafbeRxLUlYdqPOgOF84h3ug2/0pE=;
  b=YcLcY6f1X/iaBcqDfeE8RMErUnlKuQjIkQ3W9y/h3oM7HmpUQDAztZnC
   GnqfI7W6DV0Z2FtLZDm7d6uaSmREf8eg3rX2dZ/gqXCVAKO3FSyhKd78w
   MQnGaz0ewNdFWq5AZkX5wwIgXtN1Jod4ciY7/1NxjiYLY5jTVxtT9oprA
   j2NLqsnsNCLG3+m1SS+h4llCOfaft0lR4aGxiZmVkIcjU2UELzDdp9fL3
   w+d/8WWwWMVVurEXdCNXaxmdwkeT02qXnKxABUpLXWHMRoXO7A35yIyeG
   KHTyZmIM93DOeq/c2kYTsYQrPxqNnt1M6s2F7X3pxMWHWBFjnZ5lmjjfz
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9427963"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9427963"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:24:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2084576"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:24:05 -0800
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
Subject: [PATCH v4 06/66] kvm: Introduce support for memory_attributes
Date: Wed, 24 Jan 2024 22:22:28 -0500
Message-Id: <20240125032328.2522472-7-xiaoyao.li@intel.com>
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

Introduce the helper functions to set the attributes of a range of
memory to private or shared.

This is necessary to notify KVM the private/shared attribute of each gpa
range. KVM needs the information to decide the GPA needs to be mapped at
hva-based shared memory or guest_memfd based private memory.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v4:
- move the check of kvm_supported_memory_attributes to the common
  kvm_set_memory_attributes(); (Wang Wei)
- change warn_report() to error_report() in kvm_set_memory_attributes()
  and drop the __func__; (Daniel)
---
 accel/kvm/kvm-all.c  | 44 ++++++++++++++++++++++++++++++++++++++++++++
 include/sysemu/kvm.h |  3 +++
 2 files changed, 47 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 50c10becf772..3bc78a16b48d 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -92,6 +92,7 @@ static bool kvm_has_guest_debug;
 static int kvm_sstep_flags;
 static bool kvm_immediate_exit;
 static bool kvm_guest_memfd_supported;
+static uint64_t kvm_supported_memory_attributes;
 static hwaddr kvm_max_slot_size = ~0;
 
 static const KVMCapabilityInfo kvm_required_capabilites[] = {
@@ -1294,6 +1295,46 @@ void kvm_set_max_memslot_size(hwaddr max_slot_size)
     kvm_max_slot_size = max_slot_size;
 }
 
+static int kvm_set_memory_attributes(hwaddr start, hwaddr size, uint64_t attr)
+{
+    struct kvm_memory_attributes attrs;
+    int r;
+
+    if (kvm_supported_memory_attributes == 0) {
+        error_report("No memory attribute supported by KVM\n");
+        return -EINVAL;
+    }
+
+    if ((attr & kvm_supported_memory_attributes) != attr) {
+        error_report("memory attribute 0x%lx not supported by KVM,"
+                     " supported bits are 0x%lx\n",
+                     attr, kvm_supported_memory_attributes);
+        return -EINVAL;
+    }
+
+    attrs.attributes = attr;
+    attrs.address = start;
+    attrs.size = size;
+    attrs.flags = 0;
+
+    r = kvm_vm_ioctl(kvm_state, KVM_SET_MEMORY_ATTRIBUTES, &attrs);
+    if (r) {
+        error_report("failed to set memory (0x%lx+%#zx) with attr 0x%lx error '%s'",
+                     start, size, attr, strerror(errno));
+    }
+    return r;
+}
+
+int kvm_set_memory_attributes_private(hwaddr start, hwaddr size)
+{
+    return kvm_set_memory_attributes(start, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
+}
+
+int kvm_set_memory_attributes_shared(hwaddr start, hwaddr size)
+{
+    return kvm_set_memory_attributes(start, size, 0);
+}
+
 /* Called with KVMMemoryListener.slots_lock held */
 static void kvm_set_phys_mem(KVMMemoryListener *kml,
                              MemoryRegionSection *section, bool add)
@@ -2429,6 +2470,9 @@ static int kvm_init(MachineState *ms)
 
     kvm_guest_memfd_supported = kvm_check_extension(s, KVM_CAP_GUEST_MEMFD);
 
+    ret = kvm_check_extension(s, KVM_CAP_MEMORY_ATTRIBUTES);
+    kvm_supported_memory_attributes = ret > 0 ? ret : 0;
+
     if (object_property_find(OBJECT(current_machine), "kvm-type")) {
         g_autofree char *kvm_type = object_property_get_str(OBJECT(current_machine),
                                                             "kvm-type",
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index fedc28c7d17f..0e88958190a4 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -540,4 +540,7 @@ bool kvm_dirty_ring_enabled(void);
 uint32_t kvm_dirty_ring_size(void);
 
 int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp);
+
+int kvm_set_memory_attributes_private(hwaddr start, hwaddr size);
+int kvm_set_memory_attributes_shared(hwaddr start, hwaddr size);
 #endif
-- 
2.34.1


