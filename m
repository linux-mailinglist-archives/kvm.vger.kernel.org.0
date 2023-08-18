Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61756780918
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 11:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359437AbjHRJzy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 05:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359528AbjHRJzn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 05:55:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7014F2D7D
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352535; x=1723888535;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nVYcIdwdyKkgGNLz8MQrbz4I0Memc1hrI+C+lv2rwrM=;
  b=ngPzMTXh3qm3PHu4guGPmMZFG5ov3IhM4D04K9lxX4Wb1mGfV0RcT873
   /scrZkAG52MPvP+c32qKDUhsUW1GozVLTaqDTqvHkTVz4U2ofxdEszT3y
   R006NwQP3NYhYjcPkxtd1WICEPBc9z+GW7Sy4ANFjiWgxHx/xPNYLvNJM
   EPXXZr0atE23iN8YFyKvaqqTaCODqposJc29GxEme5vZKLqoJnCcSQ2J5
   oO/dQve/g66owBDfrxpkI7iJUk5o6XKvcqknFpDf+2cw+ossKALsfyjx2
   nuwjCfmzFeomTN9zKZipG68H+OzrfpujPH+mxDeZ/khkUN9n9k9m8T1SA
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371965754"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371965754"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:55:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849234853"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849234853"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:55:08 -0700
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
Subject: [PATCH v2 09/58] i386/tdx: Update tdx_cpuid_lookup[].tdx_fixed0/1 by tdx_caps.cpuid_config[]
Date:   Fri, 18 Aug 2023 05:49:52 -0400
Message-Id: <20230818095041.1973309-10-xiaoyao.li@intel.com>
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

tdx_cpuid_lookup[].tdx_fixed0/1 is QEMU maintained data which reflects
TDX restrictions regrading how some CPUIDs are virtualized by TDX.

It's retrieved from TDX spec. However, TDX may change some fixed
fields to configurable in the future. Update
tdx_cpuid.lookup[].tdx_fixed0/1 fields by removing the bits that
reported from TDX module as configurable. This can adapt with the
updated TDX (module) automatically.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 3198bc9fd5fb..4518c79aecc8 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -369,6 +369,34 @@ static void get_tdx_capabilities(void)
     tdx_caps = caps;
 }
 
+static void update_tdx_cpuid_lookup_by_tdx_caps(void)
+{
+    KvmTdxCpuidLookup *entry;
+    FeatureWordInfo *fi;
+    uint32_t config;
+    FeatureWord w;
+
+    /*
+     * Patch tdx_fixed0/1 by tdx_caps that what TDX module reports as
+     * configurable is not fixed.
+     */
+    for (w = 0; w < FEATURE_WORDS; w++) {
+        fi = &feature_word_info[w];
+        entry = &tdx_cpuid_lookup[w];
+
+        if (fi->type != CPUID_FEATURE_WORD) {
+            continue;
+        }
+
+        config = tdx_cap_cpuid_config(fi->cpuid.eax,
+                                      fi->cpuid.needs_ecx ? fi->cpuid.ecx : ~0u,
+                                      fi->cpuid.reg);
+
+        entry->tdx_fixed0 &= ~config;
+        entry->tdx_fixed1 &= ~config;
+    }
+}
+
 int tdx_kvm_init(MachineState *ms, Error **errp)
 {
     TdxGuest *tdx = (TdxGuest *)object_dynamic_cast(OBJECT(ms->cgs),
@@ -378,6 +406,8 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
         get_tdx_capabilities();
     }
 
+    update_tdx_cpuid_lookup_by_tdx_caps();
+
     tdx_guest = tdx;
 
     return 0;
-- 
2.34.1

