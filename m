Return-Path: <kvm+bounces-1764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CE317EBDB6
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:20:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1BC75B21104
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE01522D;
	Wed, 15 Nov 2023 07:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HVqKJpUg"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681C74691
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:20:02 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6C5E9
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032801; x=1731568801;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ceLZFadqcMuz7+1KZlXYA4ETVyzE2WNEepCeXMUldJc=;
  b=HVqKJpUg5OkPbd+Io93UAMNt8gRjltupPTD5J7fPiJDzkuYbp2uCyfzx
   lCkS0+4yW9ggvL5lZMEty7LAMV6BDNBAwedRMAWQx6uJE2XHqRU7Rv1PT
   0/ZWG2gr3/PPudEjQtXUxqAPNoLADhUJMrCkUP7KaQePgWVXXA4vQaKct
   +cvsqoTW7n9ko/YmSX/m6eCVNmHfhiRpealJ5F94Jd3U6Ez7Jzo6MA2Ty
   urO0k/wJWuxrAuDB6vVnnarnELe8+dAsfw9RuWo4st38OuyhOiNdI8fWe
   l0P2zsEiZ+yRvRPTSxf+TUi8KBsIvqqI2bSeSPBLUjB4nAUi6Nzf5cOrt
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390623047"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390623047"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:20:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714799418"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714799418"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:19:52 -0800
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
Subject: [PATCH v3 36/70] kvm/tdx: Don't complain when converting vMMIO region to shared
Date: Wed, 15 Nov 2023 02:14:45 -0500
Message-Id: <20231115071519.2864957-37-xiaoyao.li@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because vMMIO region needs to be shared region, guest TD may explicitly
convert such region from private to shared.  Don't complain such
conversion.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 accel/kvm/kvm-all.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 316690d113d0..5e862db4af41 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2933,17 +2933,19 @@ static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
 {
     MemoryRegionSection section;
     ram_addr_t offset;
+    MemoryRegion *mr;
     RAMBlock *rb;
     void *addr;
     int ret = -1;
 
     trace_kvm_convert_memory(start, size, to_private ? "shared_to_private" : "private_to_shared");
     section = memory_region_find(get_system_memory(), start, size);
-    if (!section.mr) {
+    mr = section.mr;
+    if (!mr) {
         return ret;
     }
 
-    if (memory_region_has_guest_memfd(section.mr)) {
+    if (memory_region_has_guest_memfd(mr)) {
         if (to_private) {
             ret = kvm_set_memory_attributes_private(start, size);
         } else {
@@ -2965,9 +2967,22 @@ static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
          */
         ram_block_convert_range(rb, offset, size, to_private);
     } else {
-        warn_report("Convert non guest_memfd backed memory region "
-                    "(0x%"HWADDR_PRIx" ,+ 0x%"HWADDR_PRIx") to %s",
-                    start, size, to_private ? "private" : "shared");
+        /*
+         * Because vMMIO region must be shared, guest TD may convert vMMIO
+         * region to shared explicitly.  Don't complain such case.  See
+         * memory_region_type() for checking if the region is MMIO region.
+         */
+        if (!to_private &&
+            !memory_region_is_ram(mr) &&
+            !memory_region_is_ram_device(mr) &&
+            !memory_region_is_rom(mr) &&
+            !memory_region_is_romd(mr)) {
+		    ret = 0;
+	    } else {
+            warn_report("Convert non guest_memfd backed memory region "
+                        "(0x%"HWADDR_PRIx" ,+ 0x%"HWADDR_PRIx") to %s",
+                        start, size, to_private ? "private" : "shared");
+        }
     }
 
     memory_region_unref(section.mr);
-- 
2.34.1


