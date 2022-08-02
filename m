Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3141D58783E
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 09:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236081AbiHBHtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 03:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236192AbiHBHsq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 03:48:46 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611F94D150
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 00:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659426514; x=1690962514;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V6iMxGM1nBAlYnFHJg6pN49HUYwr2bEgyN6VTOxhwDE=;
  b=l5PJS2fCXMbMPu3+Q45+Ohhg3Y0SuIvuBe0NaTjJRkZ3gpHtMQ51KIO0
   CLLDp/J3ds3l47ux0ztOOK3FuVpnc4inTChE87dPgDFVidrNucU+TC3ZN
   y0YfzNR5hfGGWmO1CYqps0gGdn8YgBeEOMtw/yE6qebD+VnzO6WRoE1nO
   5n7PRF/SyHxFGflgUQyhWOPpUzw7LPQRkRJX2pOWSawnSw/ia41p1YQ9Y
   /EgCACo0O1PdK4ZRKx1SDnPt4Ol8f6khVnhGvXBeSunuu8L5eb+obhw5d
   yPGe2WdmhbtDPnut7aQsZW8L2Jr4eMfviC+VzUg8zlnChkpsfxgVgB+9U
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="286908511"
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="286908511"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 00:48:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="630603911"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by orsmga008.jf.intel.com with ESMTP; 02 Aug 2022 00:48:30 -0700
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
Subject: [PATCH v1 09/40] i386/tdx: Update tdx_fixed0/1 bits by tdx_caps.cpuid_config[]
Date:   Tue,  2 Aug 2022 15:47:19 +0800
Message-Id: <20220802074750.2581308-10-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220802074750.2581308-1-xiaoyao.li@intel.com>
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tdx_cpuid_lookup[].tdx_fixed0/1 is the QEMU maintained data which
reflects TDX restrictions regrading how some CPUID is virtualized by
TDX. It's retrieved from TDX spec. However, TDX may change some fixed
fields to configurable in the future. Update
tdx_cpuid.lookup[].tdx_fixed0/1 fields by removing the bits that
reported from TDX module as configurable. This can adapt with the
updated TDX (module) automatically.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index e3e9a424512e..d12b03fa05c9 100644
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
2.27.0

