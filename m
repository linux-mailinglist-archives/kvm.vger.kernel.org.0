Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B5C79F910
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 05:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbjINDvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 23:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234274AbjINDvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 23:51:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DEC1BE9
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 20:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694663502; x=1726199502;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bz7wCSve/nZkE1jWq4TK9eEpAIR2dm0qaoQY8fTWjd8=;
  b=OCSLnPlrwZEYrx9SB8yPkD6FBxzkTY/4sIwxBx0FDLxEfhtd250L5sC8
   pU486caFbudLR2sGcSGXDFzbITmOrpp6uRaXnV95nx9dTpDB+FHk2bLCe
   nqnqif87auRbZiuSkFoNyHOke/Wuq37draFYx3yrNhRTxlhTK9p+hS8JU
   VqsgJx/GB5s391Jly7xG89ubtouVZnexKujCbe4fF5Y6BvF2Rn8DoktX/
   2TXE3Fz4jzXVKm7Kts/lLb5KjOuLY2APNODymOnlW65Vj5MYR7BmKnQOn
   Qnj80SX9avOdQYx2NamNeYqxMgfCEWnPWdGvCUovdS1cbCq06o9Anluz3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="381528329"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="381528329"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 20:51:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="814500562"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="814500562"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmsmga004.fm.intel.com with ESMTP; 13 Sep 2023 20:51:37 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, xiaoyao.li@intel.com,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
Subject: [RFC PATCH v2 04/21] memory: Introduce memory_region_has_gmem_fd()
Date:   Wed, 13 Sep 2023 23:51:00 -0400
Message-Id: <20230914035117.3285885-5-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914035117.3285885-1-xiaoyao.li@intel.com>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce memory_region_has_gmem_fd() to query if the MemoryRegion has
KVM gmem fd allocated.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 include/exec/memory.h | 10 ++++++++++
 softmmu/memory.c      |  5 +++++
 2 files changed, 15 insertions(+)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 227cb2578e95..4b8486ca3632 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -1674,6 +1674,16 @@ static inline bool memory_region_is_romd(MemoryRegion *mr)
  */
 bool memory_region_is_protected(MemoryRegion *mr);
 
+/**
+ * memory_region_has_gmem_fd: check whether a memory region has KVM gmem fd
+ *     associated
+ *
+ * Returns %true if a memory region's ram_block has valid gmem fd assigned.
+ *
+ * @mr: the memory region being queried
+ */
+bool memory_region_has_gmem_fd(MemoryRegion *mr);
+
 /**
  * memory_region_get_iommu: check whether a memory region is an iommu
  *
diff --git a/softmmu/memory.c b/softmmu/memory.c
index 7d9494ce7028..e69a5f96d5d1 100644
--- a/softmmu/memory.c
+++ b/softmmu/memory.c
@@ -1846,6 +1846,11 @@ bool memory_region_is_protected(MemoryRegion *mr)
     return mr->ram && (mr->ram_block->flags & RAM_PROTECTED);
 }
 
+bool memory_region_has_gmem_fd(MemoryRegion *mr)
+{
+    return mr->ram_block && mr->ram_block->gmem_fd >= 0;
+}
+
 uint8_t memory_region_get_dirty_log_mask(MemoryRegion *mr)
 {
     uint8_t mask = mr->dirty_log_mask;
-- 
2.34.1

