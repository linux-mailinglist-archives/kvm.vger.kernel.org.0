Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A57769C61
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 18:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbjGaQ0Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 12:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233364AbjGaQ0V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 12:26:21 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08231BCF
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 09:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690820755; x=1722356755;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FHpLYKCG5XsNyQYsZISCBt3MZkpY6KPjFJu1ItFTkyA=;
  b=On3MqzhEVpU/w47N69C911GWKGdQgzQEcw/mD8GqQs4O9S4K5NPG0Zyp
   GPkd2jKu01UQS7yMS/KzKJbmHIKkaHUkD0fHu0tUAYEhJTNWM6yteHbu+
   u8/Q/oUZVRLwZyy0ZQgy3I+X3eMa8izPsw2ZiCJanre/GOOWAAplQqffU
   UiH+FPebsH+4X1o4gPniC64RCKPUAgNka5HZJAKhkLMi0noKvDRGVSdL0
   OLAiTXZ4bR0zAx1t+XXaQI3qv8IxUNj2grjhTJLas8hrKV7J0dz01G9Wi
   dUnUG8lu2JYQ9lfh3yEOeUk08VM1GrNsmoPTcYDY9WhhKl40BHKD7g6Op
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="353993542"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="353993542"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 09:25:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="757984304"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="757984304"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga008.jf.intel.com with ESMTP; 31 Jul 2023 09:25:47 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        xiaoyao.li@intel.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [RFC PATCH 13/19] physmem: replace function name with __func__ in ram_block_discard_range()
Date:   Mon, 31 Jul 2023 12:21:55 -0400
Message-Id: <20230731162201.271114-14-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230731162201.271114-1-xiaoyao.li@intel.com>
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 softmmu/physmem.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/softmmu/physmem.c b/softmmu/physmem.c
index 8f64128de0b5..05c981e5c18e 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -3430,16 +3430,15 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
     uint8_t *host_startaddr = rb->host + start;
 
     if (!QEMU_PTR_IS_ALIGNED(host_startaddr, rb->page_size)) {
-        error_report("ram_block_discard_range: Unaligned start address: %p",
-                     host_startaddr);
+        error_report("%s: Unaligned start address: %p",
+                     __func__, host_startaddr);
         goto err;
     }
 
     if ((start + length) <= rb->max_length) {
         bool need_madvise, need_fallocate;
         if (!QEMU_IS_ALIGNED(length, rb->page_size)) {
-            error_report("ram_block_discard_range: Unaligned length: %zx",
-                         length);
+            error_report("%s: Unaligned length: %zx", __func__, length);
             goto err;
         }
 
@@ -3469,27 +3468,26 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
              * file.
              */
             if (!qemu_ram_is_shared(rb)) {
-                warn_report_once("ram_block_discard_range: Discarding RAM"
+                warn_report_once("%s: Discarding RAM"
                                  " in private file mappings is possibly"
                                  " dangerous, because it will modify the"
                                  " underlying file and will affect other"
-                                 " users of the file");
+                                 " users of the file", __func__);
             }
 
             ret = fallocate(rb->fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
                             start, length);
             if (ret) {
                 ret = -errno;
-                error_report("ram_block_discard_range: Failed to fallocate "
-                             "%s:%" PRIx64 " +%zx (%d)",
-                             rb->idstr, start, length, ret);
+                error_report("%s: Failed to fallocate %s:%" PRIx64 " +%zx (%d)",
+                             __func__, rb->idstr, start, length, ret);
                 goto err;
             }
 #else
             ret = -ENOSYS;
-            error_report("ram_block_discard_range: fallocate not available/file"
+            error_report("%s: fallocate not available/file"
                          "%s:%" PRIx64 " +%zx (%d)",
-                         rb->idstr, start, length, ret);
+                         __func__, rb->idstr, start, length, ret);
             goto err;
 #endif
         }
@@ -3507,25 +3505,23 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
             }
             if (ret) {
                 ret = -errno;
-                error_report("ram_block_discard_range: Failed to discard range "
+                error_report("%s: Failed to discard range "
                              "%s:%" PRIx64 " +%zx (%d)",
-                             rb->idstr, start, length, ret);
+                             __func__, rb->idstr, start, length, ret);
                 goto err;
             }
 #else
             ret = -ENOSYS;
-            error_report("ram_block_discard_range: MADVISE not available"
-                         "%s:%" PRIx64 " +%zx (%d)",
-                         rb->idstr, start, length, ret);
+            error_report("%s: MADVISE not available %s:%" PRIx64 " +%zx (%d)",
+                         __func__, rb->idstr, start, length, ret);
             goto err;
 #endif
         }
         trace_ram_block_discard_range(rb->idstr, host_startaddr, length,
                                       need_madvise, need_fallocate, ret);
     } else {
-        error_report("ram_block_discard_range: Overrun block '%s' (%" PRIu64
-                     "/%zx/" RAM_ADDR_FMT")",
-                     rb->idstr, start, length, rb->max_length);
+        error_report("%s: Overrun block '%s' (%" PRIu64 "/%zx/" RAM_ADDR_FMT")",
+                     __func__, rb->idstr, start, length, rb->max_length);
     }
 
 err:
-- 
2.34.1

