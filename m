Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05604DC822
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 15:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbiCQOBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 10:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234807AbiCQOBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 10:01:09 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A0F1E31B5
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 06:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647525589; x=1679061589;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=brlaegkO6g8V+UNDIi5H9X7EyUTLAdZgpHJD8X5Lu3c=;
  b=FfKIUVbYf0Josby0cuidmtH4j7v1PSaO+HZLQLrCqh5TgV072kH3DFMB
   9v9o0iaDXf6XsDswhN2CN21UA5An4B1h47HO37QjjWQW3oXgJEyeBpdRI
   ZFsK6rCJ7Ra/gkMwp+8q71Iv1r9pypmrEGPZPjwHWZcuSsIHoz/ZupR86
   p1TTakqFlYQ3fGu8roVW72StwS1ELKAjL/SwWiBB7UCsBB0XUxrQe9+oF
   3fjcVu/vEy1ovQKWGtes2NUU5CDgVAxhYIfP0FFH4kWiYF7dcFHFdAqwn
   UJXxBVjCNZoqFbINDTEgi1ZqbxKTUT2NHM6X/GvOSflu5O5bhoWLErhr7
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="257058260"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="257058260"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 06:59:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="541377907"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga007.jf.intel.com with ESMTP; 17 Mar 2022 06:59:45 -0700
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
Subject: [RFC PATCH v3 07/36] i386/tdx: Introduce is_tdx_vm() helper and cache tdx_guest object
Date:   Thu, 17 Mar 2022 21:58:44 +0800
Message-Id: <20220317135913.2166202-8-xiaoyao.li@intel.com>
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

It will need special handling for TDX VMs all around the QEMU.
Introduce is_tdx_vm() helper to query if it's a TDX VM.

Cache tdx_guest object thus no need to cast from ms->cgs every time.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 10 ++++++++++
 target/i386/kvm/tdx.h | 10 ++++++++++
 2 files changed, 20 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index bed337e5ba18..846511b299f4 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -19,6 +19,14 @@
 #include "hw/i386/x86.h"
 #include "tdx.h"
 
+static TdxGuest *tdx_guest;
+
+/* It's valid after kvm_confidential_guest_init()->kvm_tdx_init() */
+bool is_tdx_vm(void)
+{
+    return !!tdx_guest;
+}
+
 enum tdx_ioctl_level{
     TDX_VM_IOCTL,
     TDX_VCPU_IOCTL,
@@ -97,6 +105,8 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
         get_tdx_capabilities();
     }
 
+    tdx_guest = tdx;
+
     return 0;
 }
 
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index c8a23d95258d..4036ca2f3f99 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -1,6 +1,10 @@
 #ifndef QEMU_I386_TDX_H
 #define QEMU_I386_TDX_H
 
+#ifndef CONFIG_USER_ONLY
+#include CONFIG_DEVICES /* CONFIG_TDX */
+#endif
+
 #include "exec/confidential-guest-support.h"
 
 #define TYPE_TDX_GUEST "tdx-guest"
@@ -16,6 +20,12 @@ typedef struct TdxGuest {
     uint64_t attributes;    /* TD attributes */
 } TdxGuest;
 
+#ifdef CONFIG_TDX
+bool is_tdx_vm(void);
+#else
+#define is_tdx_vm() 0
+#endif /* CONFIG_TDX */
+
 int tdx_kvm_init(MachineState *ms, Error **errp);
 
 #endif /* QEMU_I386_TDX_H */
-- 
2.27.0

