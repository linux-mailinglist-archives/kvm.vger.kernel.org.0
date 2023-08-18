Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A63780973
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 12:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357784AbjHRKBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 06:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359651AbjHRKBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 06:01:15 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED6B3C33
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 03:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352847; x=1723888847;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J1WPsYdQTiWXgcoXS+NYAHLd+9qhvAps9CeOOFHbUtI=;
  b=DEyPlRHnBuoeDqdS79xiuwS+fnbaQZhdJzIk/eWJx5ltRYrrT1RkFO/O
   1abHvLEf17egzoczODX3iZZ7nrbIKWb4jIexdUuCdbnhYTRTCtZJuj8Q8
   G/LNmcc1l9jDBA59Ds5va5r1pXyhge8tXAFjfXG/Pr2o09xdbkzd0iM/O
   ztW77u0ReJcB0dm+h0zXSPZvvGB5jjvWolRd4xl+YqisB0a9LATYihxbV
   2WB7aQThlZM9NuVyVVJeF20JgTRxxg6F0csnK3UgEI9ucSjBQae8gVZNY
   od+7qoTXSddwbMaXea9Dvsr63KTqlTqKjnM/GpUbyv5XAQwnM4G/Qi2v7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371966914"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371966914"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:58:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849235756"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849235756"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:58:52 -0700
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
Subject: [PATCH v2 52/58] hw/i386: add eoi_intercept_unsupported member to X86MachineState
Date:   Fri, 18 Aug 2023 05:50:35 -0400
Message-Id: <20230818095041.1973309-53-xiaoyao.li@intel.com>
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

Add a new bool member, eoi_intercept_unsupported, to X86MachineState
with default value false. Set true for TDX VM.

Inability to intercept eoi causes impossibility to emulate level
triggered interrupt to be re-injected when level is still kept active.
which affects interrupt controller emulation.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 hw/i386/x86.c         | 1 +
 include/hw/i386/x86.h | 1 +
 target/i386/kvm/tdx.c | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index a0c9f4d646e2..567384484244 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1426,6 +1426,7 @@ static void x86_machine_initfn(Object *obj)
     x86ms->oem_table_id = g_strndup(ACPI_BUILD_APPNAME8, 8);
     x86ms->bus_lock_ratelimit = 0;
     x86ms->above_4g_mem_start = 4 * GiB;
+    x86ms->eoi_intercept_unsupported = false;
 }
 
 static void x86_machine_class_init(ObjectClass *oc, void *data)
diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
index a3d03f78cefe..c4bfb67b03c7 100644
--- a/include/hw/i386/x86.h
+++ b/include/hw/i386/x86.h
@@ -61,6 +61,7 @@ struct X86MachineState {
 
     /* CPU and apic information: */
     bool apic_xrupt_override;
+    bool eoi_intercept_unsupported;
     unsigned pci_irq_mask;
     unsigned apic_id_limit;
     uint16_t boot_cpus;
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 23ecd84a9e21..9c017cf16d0d 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -696,6 +696,8 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
         return -EINVAL;
     }
 
+    x86ms->eoi_intercept_unsupported = true;
+
     if (!tdx_caps) {
         get_tdx_capabilities();
     }
-- 
2.34.1

