Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7BFD780941
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 11:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359559AbjHRJ7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 05:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359609AbjHRJ7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 05:59:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C5D3C3D
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352719; x=1723888719;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L+Ie8fVXesxX03pHi9RWXI2Ko3hFQLmT6urXp1l4sE0=;
  b=WscYsAGPWE7fkNHchFEilP4SzfpBG/QkiL5zrAe3jJ12Hsz57r1V3bBg
   H+PihphreE+rs+WFTGRJXw3UgQXxaV4Zie2YdANeG8wTkxGkzx+N4LHK6
   FzSfPJpWn1DHyT1k/ymgynwDX3ei/jUIiceAzxv8MYXl95s/+hspzzCAp
   zWZPLfmNtrisIz2vPFHY0EBfLDSndbXIGhbxO53QjGQ3e0JBYqjxXgbHk
   jI8+4byhDGnPsejeJPUfocNLZelIWeVZkREdHWmtTMdspVL7Ex03ouYgB
   7Jnsf2hgSNYABDPDshazRPGUqLU8ce1OJz75EW2NgliRdCj/GJcxcqAMN
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371966267"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371966267"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:56:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849235252"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849235252"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:56:53 -0700
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
Subject: [PATCH v2 29/58] i386/tdx: Skip BIOS shadowing setup
Date:   Fri, 18 Aug 2023 05:50:12 -0400
Message-Id: <20230818095041.1973309-30-xiaoyao.li@intel.com>
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

TDX doesn't support map different GPAs to same private memory. Thus,
aliasing top 128KB of BIOS as isa-bios is not supported.

On the other hand, TDX guest cannot go to real mode, it can work fine
without isa-bios.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
Changes from RFC v4:
 - update commit message and comment to clarify
---
 hw/i386/x86.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index dabd33cb830b..e2a1369e5dfc 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1175,17 +1175,20 @@ void x86_bios_rom_init(MachineState *ms, const char *default_firmware,
     }
     g_free(filename);
 
-    /* map the last 128KB of the BIOS in ISA space */
-    isa_bios_size = MIN(bios_size, 128 * KiB);
-    isa_bios = g_malloc(sizeof(*isa_bios));
-    memory_region_init_alias(isa_bios, NULL, "isa-bios", bios,
-                             bios_size - isa_bios_size, isa_bios_size);
-    memory_region_add_subregion_overlap(rom_memory,
-                                        0x100000 - isa_bios_size,
-                                        isa_bios,
-                                        1);
-    if (!isapc_ram_fw) {
-        memory_region_set_readonly(isa_bios, true);
+    /* For TDX, alias different GPAs to same private memory is not supported */
+    if (!is_tdx_vm()) {
+        /* map the last 128KB of the BIOS in ISA space */
+        isa_bios_size = MIN(bios_size, 128 * KiB);
+        isa_bios = g_malloc(sizeof(*isa_bios));
+        memory_region_init_alias(isa_bios, NULL, "isa-bios", bios,
+                                bios_size - isa_bios_size, isa_bios_size);
+        memory_region_add_subregion_overlap(rom_memory,
+                                            0x100000 - isa_bios_size,
+                                            isa_bios,
+                                            1);
+        if (!isapc_ram_fw) {
+            memory_region_set_readonly(isa_bios, true);
+        }
     }
 
     /* map all the bios at the top of memory */
-- 
2.34.1

