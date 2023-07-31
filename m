Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34F5769C67
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 18:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjGaQ0x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 12:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233400AbjGaQ0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 12:26:40 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476111FEB
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 09:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690820775; x=1722356775;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=heHOwr2oExdov2YnZXE+amN8spk5BZtW366haLX5N0Q=;
  b=Qn/YeCaA2SQTSc/rdKz4ZhebpM4wYUvgv1f2o8jg1YUBJ1CIePacOMr/
   V307U0vD9pbV4izwUtEattgvoTOOzRX4M7/EUZkJ1XGwyg/vJ8RYRtxb0
   TYLzd1oSUwBF0F5JeM0D/Xv2YdYLuhoy8c9Xy0mYOTr6F8KP4Ddrxq2a7
   Bn5Cx002NInt5Jadolpf73mQoXRcFKOyGYw4sjGEg0/L20b1lkvAUhrrd
   HOrRFUr8FQw6YmuYHJR8XOy7a4ZRYD6DcQhCw6QF0Gf0tPk9TTyKhOqVm
   /Ska7pBjh2CxR+gLZ7YbNywLDvwFYMoEXctyMYYkeM07HteZhFARahg1v
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="353993597"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="353993597"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 09:26:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="757984384"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="757984384"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga008.jf.intel.com with ESMTP; 31 Jul 2023 09:26:01 -0700
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
Subject: [RFC PATCH 16/19] trace/kvm: Add trace for page convertion between shared and private
Date:   Mon, 31 Jul 2023 12:21:58 -0400
Message-Id: <20230731162201.271114-17-xiaoyao.li@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 accel/kvm/kvm-all.c    | 1 +
 accel/kvm/trace-events | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 72d50b923bf2..c9f3aab5e587 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3048,6 +3048,7 @@ static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
     ram_addr_t offset;
     int ret = -1;
 
+    trace_kvm_convert_memory(start, size, to_private ? "shared_to_private" : "private_to_shared");
     section = memory_region_find(get_system_memory(), start, size);
     if (!section.mr) {
         return ret;
diff --git a/accel/kvm/trace-events b/accel/kvm/trace-events
index 80694683acea..4935c9c5cf0b 100644
--- a/accel/kvm/trace-events
+++ b/accel/kvm/trace-events
@@ -25,4 +25,4 @@ kvm_dirty_ring_reaper(const char *s) "%s"
 kvm_dirty_ring_reap(uint64_t count, int64_t t) "reaped %"PRIu64" pages (took %"PRIi64" us)"
 kvm_dirty_ring_reaper_kick(const char *reason) "%s"
 kvm_dirty_ring_flush(int finished) "%d"
-
+kvm_convert_memory(uint64_t start, uint64_t size, const char *msg) "start 0x%" PRIx64 " size 0x%" PRIx64 " %s"
-- 
2.34.1

