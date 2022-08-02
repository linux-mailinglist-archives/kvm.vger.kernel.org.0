Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D69587857
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 09:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236206AbiHBHuw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 03:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236299AbiHBHu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 03:50:29 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098824F188
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 00:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659426606; x=1690962606;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=up0NC9t6i/8Y6UeydX8wwRAt4pZuRoc1u2sqV3Hai3Y=;
  b=MzN1yGjbRfrELhQd+Mt/18OBfIj6ZOmT+Lp54Vh8s+QgYrHRBPMM6kki
   7K0w3yHVuIVZ3VlE5McPQ54pag422Ty1urCNRQmHmyUXCzWr7wvapu48p
   hqJ6/JI8p4GQy8E+tiMytJIgusKyL/2yy5Nf6D14YPXSsmBYJZ7vxfce1
   tLtZdGAH/BOBGM83w5yzMpzi5KuBDIc66Pi4wKXYNkabTxayJv0Qh36oh
   NUWzHfq+8fBgf2ImcC5JjO5xOxVDhkX7bxsEala2ys459/86s7s8OBCJ7
   NtXOnzIkqSPqxLSQZV8rETIR5IGC03Upzh5kwdb2VcWlvzIFucx1QATGP
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="272393121"
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="272393121"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 00:49:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="630604275"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by orsmga008.jf.intel.com with ESMTP; 02 Aug 2022 00:49:52 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>
Cc:     Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com,
        xiaoyao.li@intel.com
Subject: [PATCH v1 28/40] i386/tdx: Add TDVF memory via KVM_TDX_INIT_MEM_REGION
Date:   Tue,  2 Aug 2022 15:47:38 +0800
Message-Id: <20220802074750.2581308-29-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220802074750.2581308-1-xiaoyao.li@intel.com>
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
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
Acked-by: Gerd Hoffmann <kraxel@redhat.com>

---
Changes from RFC v4:
  - rename variable @metadata to @flags
---
 target/i386/kvm/tdx.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 944f2f5b6921..d0bbe06f5504 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -575,6 +575,7 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
 {
     TdxFirmware *tdvf = &tdx_guest->tdvf;
     TdxFirmwareEntry *entry;
+    int r;
 
     tdx_init_ram_entries();
 
@@ -600,6 +601,29 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
           sizeof(TdxRamEntry), &tdx_ram_entry_compare);
 
     tdvf_hob_create(tdx_guest, tdx_get_hob_entry(tdx_guest));
+
+    for_each_tdx_fw_entry(tdvf, entry) {
+        struct kvm_tdx_init_mem_region mem_region = {
+            .source_addr = (__u64)entry->mem_ptr,
+            .gpa = entry->address,
+            .nr_pages = entry->size / 4096,
+        };
+
+        __u32 flags = entry->attributes & TDVF_SECTION_ATTRIBUTES_MR_EXTEND ?
+                      KVM_TDX_MEASURE_MEMORY_REGION : 0;
+
+        r = tdx_vm_ioctl(KVM_TDX_INIT_MEM_REGION, flags, &mem_region);
+        if (r < 0) {
+             error_report("KVM_TDX_INIT_MEM_REGION failed %s", strerror(-r));
+             exit(1);
+        }
+
+        if (entry->type == TDVF_SECTION_TYPE_TD_HOB ||
+            entry->type == TDVF_SECTION_TYPE_TEMP_MEM) {
+            qemu_ram_munmap(-1, entry->mem_ptr, entry->size);
+            entry->mem_ptr = NULL;
+        }
+    }
 }
 
 static Notifier tdx_machine_done_notify = {
-- 
2.27.0

