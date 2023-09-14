Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90C9679F915
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 05:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbjINDwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 23:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234552AbjINDwJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 23:52:09 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A6A1FC2
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 20:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694663525; x=1726199525;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=irH/wLKdEugUhkFaQFSUiyQL8CkBW40MSIixqkcbXPo=;
  b=VVHC0issyyfXfyLFe2pTW/GqQaWym6Zhl2IIuFHGPD5jARuVN+PRKtmc
   LY40cPZZqUbAd1S/WjrSTX5xt0teA4HnlWqvX1Io8ci2IvGlerxUOY1r9
   OwitTU70U+SasddJ9xtj8a788p/EDla5hZyLeMSzZh/7bKGKk1ttvROjc
   z2TP7sxpmUsn8bZiC1bT1zgTINvRX1yUYsrUuWXLAkhfFoHzfQgJzUmZd
   fkxWFbjwhFyiT0wjeNLaYTt74oIznr5UL/ZnTTcleq02VCYbGl6m2kYAF
   Pg9ojA4w2xlGO2KXyqXmjei26r4lFHBebGUzKvsUb4uDnd5yDaEflCBKI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="381528420"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="381528420"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 20:52:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="814500599"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="814500599"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmsmga004.fm.intel.com with ESMTP; 13 Sep 2023 20:52:00 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, xiaoyao.li@intel.com,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
Subject: [RFC PATCH v2 09/21] target/i386: Introduce kvm_confidential_guest_init()
Date:   Wed, 13 Sep 2023 23:51:05 -0400
Message-Id: <20230914035117.3285885-10-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914035117.3285885-1-xiaoyao.li@intel.com>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a separate function kvm_confidential_guest_init(), which
dispatches specific confidential guest initialization function by
ms->cgs type.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/kvm/kvm.c | 11 ++++++++++-
 target/i386/sev.c     |  1 -
 target/i386/sev.h     |  2 ++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index d1cf6c1f63b3..fb1be16471b4 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2583,6 +2583,15 @@ static void register_smram_listener(Notifier *n, void *unused)
                                  &smram_address_space, 1, "kvm-smram");
 }
 
+static int kvm_confidential_guest_init(MachineState *ms, Error **errp)
+{
+    if (object_dynamic_cast(OBJECT(ms->cgs), TYPE_SEV_GUEST)) {
+        return sev_kvm_init(ms->cgs, errp);
+    }
+
+    return 0;
+}
+
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     uint64_t identity_base = 0xfffbc000;
@@ -2603,7 +2612,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
      * mechanisms are supported in future (e.g. TDX), they'll need
      * their own initialization either here or elsewhere.
      */
-    ret = sev_kvm_init(ms->cgs, &local_err);
+    ret = kvm_confidential_guest_init(ms, &local_err);
     if (ret < 0) {
         error_report_err(local_err);
         return ret;
diff --git a/target/i386/sev.c b/target/i386/sev.c
index fe2144c0388b..5aa04863846d 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -39,7 +39,6 @@
 #include "hw/i386/pc.h"
 #include "exec/address-spaces.h"
 
-#define TYPE_SEV_GUEST "sev-guest"
 OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
 
 
diff --git a/target/i386/sev.h b/target/i386/sev.h
index 7b1528248a54..64fbf186dbd2 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -20,6 +20,8 @@
 
 #include "exec/confidential-guest-support.h"
 
+#define TYPE_SEV_GUEST "sev-guest"
+
 #define SEV_POLICY_NODBG        0x1
 #define SEV_POLICY_NOKS         0x2
 #define SEV_POLICY_ES           0x4
-- 
2.34.1

