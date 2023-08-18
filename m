Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 803D0780975
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 12:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359653AbjHRKBs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 06:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359650AbjHRKBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 06:01:15 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5879E3C31
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 03:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352847; x=1723888847;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+/SvpCisWi7VrhwToytirBBYpzG+C0HWkIkqrhR7TC8=;
  b=E4C6Ttlqxwwm1Ojgc9mmZurl17uaCkW9zhonMPsxNEoYAjwXnQPbGO1H
   XkZXrvNx00TZkbprZVePgGfHMG6azhi73EHU8hnRX+4H6bfBAtPd0Bxv6
   Y9Jc7Y3rs/z3dIGI5xWkBeaHaKAa0/cDawBBlU1WeRGf+h9rXCO+Gdj18
   pO7n0lCtDDWKkHgTUmqbHzZaqVPxy8aFVaXi2u4Ydg7D4AFR+rtRPv9UD
   9XtxqYo6YttGjrsbDpxbI+jwtjOBaSUQRLJPC9rQ/XtCosz1Gg8u0QdqH
   aRBf7LAdELQ0SchVTH3i/FB9xQvp/j/NkyFgp0qPBuCDMCmwrWuSjO4AT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371966893"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371966893"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:58:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849235703"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849235703"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:58:47 -0700
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
Subject: [PATCH v2 51/58] i386/tdx: LMCE is not supported for TDX
Date:   Fri, 18 Aug 2023 05:50:34 -0400
Message-Id: <20230818095041.1973309-52-xiaoyao.li@intel.com>
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

LMCE is not supported TDX since KVM doesn't provide emulation for
MSR_IA32_FEAT_CTL.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/kvm-cpu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index 7237378a7d4e..bec8b5f918e7 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -15,6 +15,7 @@
 #include "sysemu/sysemu.h"
 #include "hw/boards.h"
 
+#include "tdx.h"
 #include "kvm_i386.h"
 #include "hw/core/accel-cpu.h"
 
@@ -59,6 +60,10 @@ static bool lmce_supported(void)
     if (kvm_ioctl(kvm_state, KVM_X86_GET_MCE_CAP_SUPPORTED, &mce_cap) < 0) {
         return false;
     }
+
+    if (is_tdx_vm())
+        return false;
+
     return !!(mce_cap & MCG_LMCE_P);
 }
 
-- 
2.34.1

