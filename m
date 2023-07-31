Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3DC769C54
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 18:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbjGaQZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 12:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233250AbjGaQZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 12:25:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188A010F5
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 09:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690820711; x=1722356711;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aL1UPlr2chE5l10fcGzhJ5ApDBOAfrYAdLTB07kHh9c=;
  b=dMxB6MWwUCyuKfjGvbji6AkqP+HymK78rrORJmpOBIZq+VomtAZcCt/g
   sSyPzMOy0JxTmVxEoYUgmkyNAath5bHYHj1McWb3fqSe+8ghnwc8xf3rm
   E83K2TbhpwVau4kNmMXdV2Vb8Rn7EVQTacnnehX7ojTT4oGs5c8cCw56i
   Vfmo5aPml1t8nelYxG856vG4QCJrm5Vzek7SNsyJWXQwuuNtxSqGNq9PS
   3gKNJOhFGfbGTbBCpSfoMsGn2Ztq3CkciA/K0jVMgozZfIUr6TAE6RUYC
   xB49o2nrbHwtvCDN1U0PYMULkGt4QVPb59Rjt2lTbIeO8FvVO/Oi6pKa8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="353993415"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="353993415"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 09:25:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="757984060"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="757984060"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga008.jf.intel.com with ESMTP; 31 Jul 2023 09:25:05 -0700
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
Subject: [RFC PATCH 04/19] memory: Introduce memory_region_can_be_private()
Date:   Mon, 31 Jul 2023 12:21:46 -0400
Message-Id: <20230731162201.271114-5-xiaoyao.li@intel.com>
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
 include/exec/memory.h | 9 +++++++++
 softmmu/memory.c      | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 61e31c7b9874..e119d3ce1a1d 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -1679,6 +1679,15 @@ static inline bool memory_region_is_romd(MemoryRegion *mr)
  */
 bool memory_region_is_protected(MemoryRegion *mr);
 
+/**
+ * memory_region_can_be_private: check whether a memory region can be private
+ *
+ * Returns %true if a memory region's ram_block has valid gmem fd assigned.
+ *
+ * @mr: the memory region being queried
+ */
+bool memory_region_can_be_private(MemoryRegion *mr);
+
 /**
  * memory_region_get_iommu: check whether a memory region is an iommu
  *
diff --git a/softmmu/memory.c b/softmmu/memory.c
index 4f8f8c0a02e6..336c76ede660 100644
--- a/softmmu/memory.c
+++ b/softmmu/memory.c
@@ -1855,6 +1855,11 @@ bool memory_region_is_protected(MemoryRegion *mr)
     return mr->ram && (mr->ram_block->flags & RAM_PROTECTED);
 }
 
+bool memory_region_can_be_private(MemoryRegion *mr)
+{
+    return mr->ram_block && mr->ram_block->gmem_fd >= 0;
+}
+
 uint8_t memory_region_get_dirty_log_mask(MemoryRegion *mr)
 {
     uint8_t mask = mr->dirty_log_mask;
-- 
2.34.1

