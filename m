Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111894DC82B
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 15:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbiCQOCF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 10:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234882AbiCQOCA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 10:02:00 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450611E374B
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 07:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647525643; x=1679061643;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ot2UhC4Ngkt9x2qNK3E3XsueHhOSstt/gdRmDwhsnY4=;
  b=CSqFXBWODSaSpiPOvCNLiL0NFjns0Kqq1FJ3+Up4bMgZSoj4f5ABpda9
   T+g2XXpqUZ9xG0gnPGaw7lrl0Nj6B+9VJ860iemdpoQC0t6UhLHpodd8O
   PXFSVznyHvOG/O3btygndqf2lia4kyg66fSJ3zDZNu2pgqJZRh+JpW4if
   VMAnUWlAJqJOI5wUxOluCH/k4tQUFAphxkDq3nptphDk5vRaeqgBnpW6L
   HsEvxvqXS7YL9DvIHrhDtG/XSQSLDotEvbZEOmHH+nct5bBkFhrMFSv7l
   ayEzdvE6hx2xuWhVfDCFN7W7bYSjWw8vYXc2hG2Bcwhvj1SzV+4RtLNrA
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="257058517"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="257058517"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 07:00:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="541378246"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga007.jf.intel.com with ESMTP; 17 Mar 2022 07:00:25 -0700
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
Subject: [RFC PATCH v3 16/36] i386/tdx: Set kvm_readonly_mem_enabled to false for TDX VM
Date:   Thu, 17 Mar 2022 21:58:53 +0800
Message-Id: <20220317135913.2166202-17-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220317135913.2166202-1-xiaoyao.li@intel.com>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDX only supports readonly for shared memory but not for private memory.

In the view of QEMU, it has no idea whether a memslot is used by shared
memory of private. Thus just mark kvm_readonly_mem_enabled to false to
TDX VM for simplicity.

Note, pflash has dependency on readonly capability from KVM while TDX
wants to reuse pflash interface to load TDVF (as OVMF). Excuse TDX VM
for readonly check in pflash.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 hw/i386/pc_sysfw.c    | 2 +-
 target/i386/kvm/tdx.c | 9 +++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
index c8b17af95353..75b34d02cb4f 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -245,7 +245,7 @@ void pc_system_firmware_init(PCMachineState *pcms,
         /* Machine property pflash0 not set, use ROM mode */
         x86_bios_rom_init(MACHINE(pcms), "bios.bin", rom_memory, false);
     } else {
-        if (kvm_enabled() && !kvm_readonly_mem_enabled()) {
+        if (kvm_enabled() && (!kvm_readonly_mem_enabled() && !is_tdx_vm())) {
             /*
              * Older KVM cannot execute from device memory. So, flash
              * memory cannot be used unless the readonly memory kvm
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 94a9c1ea7e9c..1bb8211e74e6 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -115,6 +115,15 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
         get_tdx_capabilities();
     }
 
+    /*
+     * Set kvm_readonly_mem_allowed to false, because TDX only supports readonly
+     * memory for shared memory but not for private memory. Besides, whether a
+     * memslot is private or shared is not determined by QEMU.
+     *
+     * Thus, just mark readonly memory not supported for simplicity.
+     */
+    kvm_readonly_mem_allowed = false;
+
     tdx_guest = tdx;
 
     return 0;
-- 
2.27.0

