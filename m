Return-Path: <kvm+bounces-1763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E49DC7EBDB5
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:20:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF129B20F56
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:20:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A24D44427;
	Wed, 15 Nov 2023 07:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W8SDEZSk"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A4C3D6C
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:19:55 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB75EB
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032793; x=1731568793;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YEcoHggTNp3SWmCyqSzPRp4dnOuhAVXArV6J4/gEuPY=;
  b=W8SDEZSkLuYC+dca3K3fnJjJyXeuYLnwYsXetpbxGpu6q+4AekYYxUk7
   TDcsL42mkdRq0EyHDcwHKlke/Sfs7z5Y6o6SRTWKmjvHdQKKWZ1PBXKrF
   b8O/Q9joOhrMkejiTbaSX0JsHEvjDCq1uEP5xJIqCMcA2f/K2W7O8hS/0
   1gajftv0gRNhuc3VyvbyXXVF0Blz+eJuyFkR0PmuCgBhv93GmFDJWy9UJ
   lCqFUnXNds0OWUETUMWbS8dwUTjPh7AJ/RA+qHMTm2atHbbMlGvhdaluU
   6tFPDDWjTA7qOMP3+GeReya8juj4kqnweGw9YAcyIuCxFB3em9J5NJvgr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390623019"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390623019"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:19:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714799276"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714799276"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:19:43 -0800
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
Subject: [PATCH v3 35/70] i386/tdx: Make memory type private by default
Date: Wed, 15 Nov 2023 02:14:44 -0500
Message-Id: <20231115071519.2864957-36-xiaoyao.li@intel.com>
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

By default (due to the recent UPM change), restricted memory attribute is
shared.  Convert the memory region from shared to private at the memory
slot creation time.

add kvm region registering function to check the flag
and convert the region, and add memory listener to TDX guest code to set
the flag to the possible memory region.

Without this patch
- Secure-EPT violation on private area
- KVM_MEMORY_FAULT EXIT (kvm -> qemu)
- qemu converts the 4K page from shared to private
- Resume VCPU execution
- Secure-EPT violation again
- KVM resolves EPT Violation
This also prevents huge page because page conversion is done at 4K
granularity.  Although it's possible to merge 4K private mapping into
2M large page, it slows guest boot.

With this patch
- After memory slot creation, convert the region from private to shared
- Secure-EPT violation on private area.
- KVM resolves EPT Violation

Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 include/exec/memory.h |  1 +
 target/i386/kvm/tdx.c | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index bdc4b98efe70..c8b0385b19ad 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -850,6 +850,7 @@ struct IOMMUMemoryRegion {
 #define MEMORY_LISTENER_PRIORITY_MIN            0
 #define MEMORY_LISTENER_PRIORITY_ACCEL          10
 #define MEMORY_LISTENER_PRIORITY_DEV_BACKEND    10
+#define MEMORY_LISTENER_PRIORITY_ACCEL_HIGH     20
 
 /**
  * struct MemoryListener: callbacks structure for updates to the physical memory map
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 50e68f9c1a41..82a1b010746a 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -19,6 +19,7 @@
 #include "standard-headers/asm-x86/kvm_para.h"
 #include "sysemu/kvm.h"
 #include "sysemu/sysemu.h"
+#include "exec/address-spaces.h"
 
 #include "hw/i386/x86.h"
 #include "kvm_i386.h"
@@ -619,6 +620,19 @@ out:
     return r;
 }
 
+static void tdx_guest_region_add(MemoryListener *listener,
+                                 MemoryRegionSection *section)
+{
+    memory_region_set_default_private(section->mr);
+}
+
+static MemoryListener tdx_memory_listener = {
+    .name = TYPE_TDX_GUEST,
+    .region_add = tdx_guest_region_add,
+    /* Higher than KVM memory listener = 10. */
+    .priority = MEMORY_LISTENER_PRIORITY_ACCEL_HIGH,
+};
+
 static bool tdx_guest_get_sept_ve_disable(Object *obj, Error **errp)
 {
     TdxGuest *tdx = TDX_GUEST(obj);
@@ -690,6 +704,12 @@ OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
 static void tdx_guest_init(Object *obj)
 {
     TdxGuest *tdx = TDX_GUEST(obj);
+    static bool memory_listener_registered = false;
+
+    if (!memory_listener_registered) {
+        memory_listener_register(&tdx_memory_listener, &address_space_memory);
+        memory_listener_registered = true;
+    }
 
     qemu_mutex_init(&tdx->lock);
 
-- 
2.34.1


