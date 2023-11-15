Return-Path: <kvm+bounces-1733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F2ADC7EBD77
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:16:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92A181F25C09
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74701522D;
	Wed, 15 Nov 2023 07:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n5rgZ8v3"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084703D9F
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:16:28 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14F0EB
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032586; x=1731568586;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5oFP29/6hPQTSjt7+TkWWvWCU+lwZOG63ox2Xe0ioV4=;
  b=n5rgZ8v3k9d5tfks1M6gtIt3Oct+yfCT1YWYAj3x6j8gOARz0OfWu1IY
   23AatTsbCVlloWDhk2n+MPrFRQ6S/BGNGONkMP3AdYtU+N3r2Q8PoiKZX
   M+GHr4+wqqq/fjNvHmOiOjUKfSnigumDPSpNs48BZF8Duu2m6ROnZnOcp
   kZ/6ymxd/1xOdAykgzBXQnxDt4sksP45L/QRvqbHxaXeqsE8uLtfrJVgt
   XVvTbC+vZv5W92RNxUC/1xgU9p29zDrpDDq1JMUl4ntkk79PtQB+l443d
   zIKK7pJwKoojLWB2IgW36kxvqwR91ltDzXPxjhK4naAu9OIzepMV7ymaO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390622170"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390622170"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:16:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714796990"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714796990"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:16:08 -0800
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
Subject: [PATCH v3 06/70] kvm: Introduce support for memory_attributes
Date: Wed, 15 Nov 2023 02:14:15 -0500
Message-Id: <20231115071519.2864957-7-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115071519.2864957-1-xiaoyao.li@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
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
 accel/kvm/kvm-all.c  | 42 ++++++++++++++++++++++++++++++++++++++++++
 include/sysemu/kvm.h |  3 +++
 2 files changed, 45 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 69afeb47c9c0..76e2404d54d2 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -102,6 +102,7 @@ bool kvm_has_guest_debug;
 static int kvm_sstep_flags;
 static bool kvm_immediate_exit;
 static bool kvm_guest_memfd_supported;
+static uint64_t kvm_supported_memory_attributes;
 static hwaddr kvm_max_slot_size = ~0;
 
 static const KVMCapabilityInfo kvm_required_capabilites[] = {
@@ -1305,6 +1306,44 @@ void kvm_set_max_memslot_size(hwaddr max_slot_size)
     kvm_max_slot_size = max_slot_size;
 }
 
+static int kvm_set_memory_attributes(hwaddr start, hwaddr size, uint64_t attr)
+{
+    struct kvm_memory_attributes attrs;
+    int r;
+
+    attrs.attributes = attr;
+    attrs.address = start;
+    attrs.size = size;
+    attrs.flags = 0;
+
+    r = kvm_vm_ioctl(kvm_state, KVM_SET_MEMORY_ATTRIBUTES, &attrs);
+    if (r) {
+        warn_report("%s: failed to set memory (0x%lx+%#zx) with attr 0x%lx error '%s'",
+                     __func__, start, size, attr, strerror(errno));
+    }
+    return r;
+}
+
+int kvm_set_memory_attributes_private(hwaddr start, hwaddr size)
+{
+    if (!(kvm_supported_memory_attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+        error_report("KVM doesn't support PRIVATE memory attribute\n");
+        return -EINVAL;
+    }
+
+    return kvm_set_memory_attributes(start, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
+}
+
+int kvm_set_memory_attributes_shared(hwaddr start, hwaddr size)
+{
+    if (!(kvm_supported_memory_attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+        error_report("KVM doesn't support PRIVATE memory attribute\n");
+        return -EINVAL;
+    }
+
+    return kvm_set_memory_attributes(start, size, 0);
+}
+
 /* Called with KVMMemoryListener.slots_lock held */
 static void kvm_set_phys_mem(KVMMemoryListener *kml,
                              MemoryRegionSection *section, bool add)
@@ -2440,6 +2479,9 @@ static int kvm_init(MachineState *ms)
 
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


