Return-Path: <kvm+bounces-1730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE8AB7EBD74
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:16:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27F8F1C208BA
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:16:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 549FF441C;
	Wed, 15 Nov 2023 07:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AmJn1HXQ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53E2611A
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:15:55 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E69BE9
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032555; x=1731568555;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qY9pdRRi3gnZ4VLEVBqiSbNccgKMU+XVba+RGctQW98=;
  b=AmJn1HXQStnv9zXy1y0tfQUpFdY7pTck042UxmW9H8ZuuuGkufZDD8kV
   CCO9G73mzeUAJu9m1aN2qbAqj48Gly1J+EDRzvdoYhQuqp8X8462GHBZr
   ubmBKmYTTpUAC9TMVjaQlpUm5dr2g9hCR5eJBnocON4TjRTYCNeZPxqIw
   W+XqGxZfG+qaV6PmRw6NLBZQDJJWlnV3sGBUTp0hdeKBteRDimUIRekrx
   zBUbnL8wluh3GuPTGV/LQ44TukM6mUkPvU7C04iabSdkp/kDNHFlY4Whk
   arIrlQTGTL/iRiUn8uJauaOjtZVJfJNpC+30BnT3ddHnEJPRZR7NpLxkL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390622077"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390622077"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:15:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714796837"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714796837"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:15:46 -0800
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
Subject: [PATCH v3 03/70] RAMBlock/guest_memfd: Enable KVM_GUEST_MEMFD_ALLOW_HUGEPAGE
Date: Wed, 15 Nov 2023 02:14:12 -0500
Message-Id: <20231115071519.2864957-4-xiaoyao.li@intel.com>
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

KVM allows KVM_GUEST_MEMFD_ALLOW_HUGEPAGE for guest memfd. When the
flag is set, KVM tries to allocate memory with transparent hugeapge at
first and falls back to non-hugepage on failure.

However, KVM defines one restriction that size must be hugepage size
aligned when KVM_GUEST_MEMFD_ALLOW_HUGEPAGE is set.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
v3:
 - New one in v3.
---
 system/physmem.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/system/physmem.c b/system/physmem.c
index 0af2213cbd9c..c56b17e44df6 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1803,6 +1803,40 @@ static void dirty_memory_extend(ram_addr_t old_ram_size,
     }
 }
 
+#ifdef CONFIG_KVM
+#define HPAGE_PMD_SIZE_PATH "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"
+#define DEFAULT_PMD_SIZE (1ul << 21)
+
+static uint32_t get_thp_size(void)
+{
+    gchar *content = NULL;
+    const char *endptr;
+    static uint64_t thp_size = 0;
+    uint64_t tmp;
+
+    if (thp_size != 0) {
+        return thp_size;
+    }
+
+    if (g_file_get_contents(HPAGE_PMD_SIZE_PATH, &content, NULL, NULL) &&
+        !qemu_strtou64(content, &endptr, 0, &tmp) &&
+        (!endptr || *endptr == '\n')) {
+        /* Sanity-check the value and fallback to something reasonable. */
+        if (!tmp || !is_power_of_2(tmp)) {
+            warn_report("Read unsupported THP size: %" PRIx64, tmp);
+        } else {
+            thp_size = tmp;
+        }
+    }
+
+    if (!thp_size) {
+        thp_size = DEFAULT_PMD_SIZE;
+    }
+
+    return thp_size;
+}
+#endif
+
 static void ram_block_add(RAMBlock *new_block, Error **errp)
 {
     const bool noreserve = qemu_ram_is_noreserve(new_block);
@@ -1844,8 +1878,8 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
 #ifdef CONFIG_KVM
     if (kvm_enabled() && new_block->flags & RAM_GUEST_MEMFD &&
         new_block->guest_memfd < 0) {
-        /* TODO: to decide if KVM_GUEST_MEMFD_ALLOW_HUGEPAGE is supported */
-        uint64_t flags = 0;
+        uint64_t flags = QEMU_IS_ALIGNED(new_block->max_length, get_thp_size()) ?
+                         KVM_GUEST_MEMFD_ALLOW_HUGEPAGE : 0;
         new_block->guest_memfd = kvm_create_guest_memfd(new_block->max_length,
                                                         flags, errp);
         if (new_block->guest_memfd < 0) {
-- 
2.34.1


