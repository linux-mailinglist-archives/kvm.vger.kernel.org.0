Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF594DC837
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 15:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234877AbiCQOCg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 10:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234884AbiCQOCc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 10:02:32 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A671E31AD
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 07:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647525672; x=1679061672;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6VSHpYV1KU/cDu1QYhv7QkXrvs85Mq0GK2RV4+FNIXU=;
  b=SgbwtGu4emNb4LHL/2XY4CCMnhU5jFetxyXdnyCAto3+h/fB47Fa2sd3
   IM56uBgV8vI9N8oO1gNQ6mjBt6RPwxph2Sa6NIZ+WYHY7x3jzY4zqwKnM
   KgfsvAi73swQKo41wA6YIWW75JDeANDn+cjkbIReMt/XU6guJLRcDy7g2
   N0myQi5deS0LBcHauJZ1f3CY7duIbepVgDyJA8lgaSgWjmCN2hmExVU3O
   YiCYBuFOuJfJzkr32CaoGc18H7W4QULRzvKv34WDvfcvbCCpidnlDKJ8+
   /f0iK2UessnCR4W9fptpcwjj6ZvrWCNnPwUCVeyEe+Ltir6lQRMz6+Mha
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="239034194"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="239034194"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 07:01:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="541378610"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga007.jf.intel.com with ESMTP; 17 Mar 2022 07:01:07 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>
Cc:     Connor Kuehl <ckuehl@redhat.com>, isaku.yamahata@intel.com,
        xiaoyao.li@intel.com, erdemaktas@google.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, seanjc@google.com
Subject: [RFC PATCH v3 25/36] i386/tdx: Add TDVF memory via KVM_TDX_INIT_MEM_REGION
Date:   Thu, 17 Mar 2022 21:59:02 +0800
Message-Id: <20220317135913.2166202-26-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220317135913.2166202-1-xiaoyao.li@intel.com>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDVF firmware (CODE and VARS) needs to be added/copied to TD's private
memory via KVM_TDX_INIT_MEM_REGION, as well as TD HOB and TEMP memory.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index f06a0895b77a..fc03079571a1 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -234,6 +234,7 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
     void *base_ram_ptr = memory_region_get_ram_ptr(ms->ram);
     TdxFirmware *tdvf = &tdx_guest->tdvf;
     TdxFirmwareEntry *entry;
+    int r;
 
     tdx_init_ram_entries();
 
@@ -269,6 +270,23 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
     tdvf_hob_create(tdx_guest, tdx_get_hob_entry(tdx_guest));
 
     tdx_post_init_vcpu();
+
+    for_each_tdx_fw_entry(tdvf, entry) {
+        struct kvm_tdx_init_mem_region mem_region = {
+            .source_addr = (__u64)entry->mem_ptr,
+            .gpa = entry->address,
+            .nr_pages = entry->size / 4096,
+        };
+
+        __u32 metadata = entry->attributes & TDVF_SECTION_ATTRIBUTES_MR_EXTEND ?
+                         KVM_TDX_MEASURE_MEMORY_REGION : 0;
+
+        r = tdx_vm_ioctl(KVM_TDX_INIT_MEM_REGION, metadata, &mem_region);
+        if (r < 0) {
+             error_report("KVM_TDX_INIT_MEM_REGION failed %s", strerror(-r));
+             exit(1);
+        }
+    }
 }
 
 static Notifier tdx_machine_done_notify = {
-- 
2.27.0

