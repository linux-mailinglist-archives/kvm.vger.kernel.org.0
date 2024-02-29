Return-Path: <kvm+bounces-10362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 401B286C0CB
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:39:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63C2B1C20E47
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED855481A0;
	Thu, 29 Feb 2024 06:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V4t4cj0C"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9C945C0B
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188696; cv=none; b=Vmom52CkHE2AREVJQShVpO+JCPE99HBHh6YAuyQ0TCQ5DdRYfCLK7Lr/OOhr1NoXzxg8/NUDM578X9y0qE6LWgMyBbtlY7cwbRymaxMBttZfYI3nP9B6X+n0HVs1kltinuZYBD1TSBrx71b+XbPQxRsi5LjzJvnUhFmbraS+qx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188696; c=relaxed/simple;
	bh=Fb7bHySspTS4hjuABM77dUCDCJxo9f235G4HFPXOtck=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=km50zegkMlu/b4AEKzna7my7e0bJ0dD2hzGQRrWuWhxYX53zJmYR1dcDb1iZli8k+cyf9YwfozHiO8msNvZhilOW1P8bjOGP1xCXqyxqDpWZw8hmC8h6kJ9DkXJA4jsI7pzGTYv/+NgraS/2M7b+objbDHmdj5sD557TlWaqjP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V4t4cj0C; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188694; x=1740724694;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fb7bHySspTS4hjuABM77dUCDCJxo9f235G4HFPXOtck=;
  b=V4t4cj0COW4yNUedEuySEav51wxtZDSYbvFBv9ONI9FpuPkgJ9RX0Qtg
   JWj4TjqBhwV2H2njUb+6pcuYFo0TP8sbGdSoV5n7TaR/PuWuKasONC4dC
   ypY3OnZc6dqlOeFCHT6V8ng2ZfpzM489kUZuF4pIgEBnw9KO/eSKDlHjj
   XqbjxXnTROwBzXh3bnGcZhbLETbKPjalsGZOc2rT/xS5HD+YdJb1vxpBS
   NqyLsl/LKRR39/nn24Jvf1svJoAarew6JESM15UXKNH0W95ucx5fcKvi2
   E2wsH00hWjjx/wn99s7HidFetzBAuXAHd5bt0pckejDWRpbAt56xN2C3E
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3802504"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3802504"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:38:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8074889"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:38:08 -0800
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
Subject: [PATCH v5 06/65] kvm: Introduce support for memory_attributes
Date: Thu, 29 Feb 2024 01:36:27 -0500
Message-Id: <20240229063726.610065-7-xiaoyao.li@intel.com>
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
index cd0aa7545a1f..70d482a2c936 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -92,6 +92,7 @@ static bool kvm_has_guest_debug;
 static int kvm_sstep_flags;
 static bool kvm_immediate_exit;
 static bool kvm_guest_memfd_supported;
+static uint64_t kvm_supported_memory_attributes;
 static hwaddr kvm_max_slot_size = ~0;
 
 static const KVMCapabilityInfo kvm_required_capabilites[] = {
@@ -1304,6 +1305,46 @@ void kvm_set_max_memslot_size(hwaddr max_slot_size)
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
@@ -2439,6 +2480,9 @@ static int kvm_init(MachineState *ms)
 
     kvm_guest_memfd_supported = kvm_check_extension(s, KVM_CAP_GUEST_MEMFD);
 
+    ret = kvm_check_extension(s, KVM_CAP_MEMORY_ATTRIBUTES);
+    kvm_supported_memory_attributes = ret > 0 ? ret : 0;
+
     if (object_property_find(OBJECT(current_machine), "kvm-type")) {
         g_autofree char *kvm_type = object_property_get_str(OBJECT(current_machine),
                                                             "kvm-type",
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 6cdf82de8372..8e83adfbbd19 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -546,4 +546,7 @@ uint32_t kvm_dirty_ring_size(void);
 bool kvm_hwpoisoned_mem(void);
 
 int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp);
+
+int kvm_set_memory_attributes_private(hwaddr start, hwaddr size);
+int kvm_set_memory_attributes_shared(hwaddr start, hwaddr size);
 #endif
-- 
2.34.1


