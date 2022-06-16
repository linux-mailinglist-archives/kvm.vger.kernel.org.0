Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C9554EC97
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 23:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378634AbiFPVbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 17:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231972AbiFPVbQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 17:31:16 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCAA61298;
        Thu, 16 Jun 2022 14:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655415075; x=1686951075;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=jVvRqD/Jo18BkJasvT/53ehh+KR6a5iysHBM6bgbmiY=;
  b=RCFDOIswr8J3vn+ctMhYpY4h089NYYQfgRyEW/VpaZbGqHkkpehO+/ge
   TkAiITzLwwkFYKrZpXiOSL8CWpe90dOhvWjcypekiY+Y+zP7dGq3nBJoG
   fyiLLftMEwahhpM+gbj7rUkjoGLx3O2U7W70xZzIhaE6W47VWE2gsehIP
   dHMA4uFsparIfYxSboOWcExCAHw9qm4sQZxAz4NZYyw43nN5ZppNd8xJ7
   Lbw9yBMsZrniJubei7Vwtvug3eZ/lS4AlYjkUjNT3eaXamxImKfwyPxVe
   LQXLPbeoD2RapXaZjre0HIRIuP57SU2SiIwOxElj+BoIs4XFJKp/HWy9j
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="280389922"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="280389922"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 14:31:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="589824125"
Received: from chang-linux-3.sc.intel.com ([172.25.66.173])
  by fmsmga007.fm.intel.com with ESMTP; 16 Jun 2022 14:31:14 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     dave.hansen@intel.com, len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com
Cc:     corbet@lwn.net, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com
Subject: [PATCH 1/2] Documentation/x86: Add the AMX enabling example
Date:   Thu, 16 Jun 2022 14:22:09 -0700
Message-Id: <20220616212210.3182-2-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220616212210.3182-1-chang.seok.bae@intel.com>
References: <20220616212210.3182-1-chang.seok.bae@intel.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explain steps to enable the dynamic feature with a code example.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Thiago Macieira <thiago.macieira@intel.com>
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/x86/xstate.rst | 48 ++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/Documentation/x86/xstate.rst b/Documentation/x86/xstate.rst
index 5cec7fb558d6..9597e6caa30e 100644
--- a/Documentation/x86/xstate.rst
+++ b/Documentation/x86/xstate.rst
@@ -64,6 +64,54 @@ the handler allocates a larger xstate buffer for the task so the large
 state can be context switched. In the unlikely cases that the allocation
 fails, the kernel sends SIGSEGV.
 
+AMX TILE_DATA enabling example
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+The following steps dynamically enable TILE_DATA:
+
+  1. **Check the feature availability**. AMX_TILE is enumerated in CPUID
+     leaf 7, sub-leaf 0, bit 24 of EDX. If available, ``/proc/cpuinfo``
+     shows ``amx_tile`` in the flag entry of the CPUs.  Given that, the
+     kernel may have set XSTATE component 18 in the XCR0 register. But a
+     user needs to ensure the kernel support via the ARCH_GET_XCOMP_SUPP
+     option::
+
+        #include <asm/prctl.h>
+        #include <sys/syscall.h>
+	#include <stdio.h>
+        #include <unistd.h>
+
+        #define ARCH_GET_XCOMP_SUPP  0x1021
+
+        #define XFEATURE_XTILECFG    17
+        #define XFEATURE_XTILEDATA   18
+        #define XFEATURE_MASK_XTILE ((1 << XFEATURE_XTILECFG) | (1 << XFEATURE_XFILEDATA))
+
+        unsigned long features;
+        long rc;
+
+        ...
+
+        rc = syscall(SYS_arch_prctl, ARCH_GET_XCOMP_SUPP, &features);
+
+        if (!rc && features & XFEATURE_MASK_XTILE == XFEATURE_MASK_XTILE)
+            printf("AMX is available.\n");
+
+  2. **Request permission**. Now it is found that the kernel supports the
+     feature. But the permission is not automatically given. A user needs
+     to explicitly request it via the ARCH_REQ_XCOMP_PERM option::
+
+        #define ARCH_REQ_XCOMP_PERM  0x1023
+
+        ...
+
+        rc = syscall(SYS_arch_prctl, ARCH_REQ_XCOMP_PERM, XFEATURE_XTILEDATA);
+
+        if (!rc)
+            printf("AMX is ready for use.\n");
+
+Note this example does not include the sigaltstack preparation.
+
 Dynamic features in signal frames
 ---------------------------------
 
-- 
2.17.1

