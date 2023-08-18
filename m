Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F141780953
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 12:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359597AbjHRJ75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 05:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359671AbjHRJ7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 05:59:32 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B88F3AB4
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352754; x=1723888754;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n6J9qyA7Bfj5B8pEb9VtkWEigfZf2sgdu905dTUQSJY=;
  b=PO3T266HpOwYnw+AuhjJ3j75ToJmcF3YeDG3aEWJ49tx3E5p5vHX7ywa
   2cdXiC3qo6ldg9EvdyHfW0FkPWruTzy85vcMLS4Ik4U7HsXK321NOWmNw
   r+W6Oto3hpsT2u/EgmMO400zNImTCOt5RbbMQLuB41t+UBuBNO3cWh1ks
   Da/Y8qmx0DGr/2cBv9erXoqXYQ5kh1EPdjDVtgdLgEsjESRCvRuWogxm/
   7HOBYgbPIjXfanb+xVUuuogOqWKQcGBmFurtI4UQbwFRjJj4EgtqUaFDY
   CKQdrGqb0NBBkfKBWzt3AFjJUOtXg9Z92IdPZ2ZyHHRz2QYDd2OCyBDp6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371966555"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371966555"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:57:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849235429"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849235429"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:57:39 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>, xiaoyao.li@intel.com,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v2 38/58] i386/tdx: Call KVM_TDX_INIT_VCPU to initialize TDX vcpu
Date:   Fri, 18 Aug 2023 05:50:21 -0400
Message-Id: <20230818095041.1973309-39-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230818095041.1973309-1-xiaoyao.li@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDX vcpu needs to be initialized by SEAMCALL(TDH.VP.INIT) and KVM
provides vcpu level IOCTL KVM_TDX_INIT_VCPU for it.

KVM_TDX_INIT_VCPU needs the address of the HOB as input. Invoke it for
each vcpu after HOB list is created.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 5b688eb39327..2d0efca6787b 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -578,6 +578,22 @@ static void tdx_init_ram_entries(void)
     tdx_guest->nr_ram_entries = j;
 }
 
+static void tdx_post_init_vcpus(void)
+{
+    TdxFirmwareEntry *hob;
+    CPUState *cpu;
+    int r;
+
+    hob = tdx_get_hob_entry(tdx_guest);
+    CPU_FOREACH(cpu) {
+        r = tdx_vcpu_ioctl(cpu, KVM_TDX_INIT_VCPU, 0, (void *)hob->address);
+        if (r < 0) {
+            error_report("KVM_TDX_INIT_VCPU failed %s", strerror(-r));
+            exit(1);
+        }
+    }
+}
+
 static void tdx_finalize_vm(Notifier *notifier, void *unused)
 {
     TdxFirmware *tdvf = &tdx_guest->tdvf;
@@ -610,6 +626,8 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
 
     tdvf_hob_create(tdx_guest, tdx_get_hob_entry(tdx_guest));
 
+    tdx_post_init_vcpus();
+
     for_each_tdx_fw_entry(tdvf, entry) {
         struct kvm_tdx_init_mem_region mem_region = {
             .source_addr = (__u64)entry->mem_ptr,
-- 
2.34.1

