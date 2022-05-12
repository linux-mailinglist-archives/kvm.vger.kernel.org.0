Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7754E52432B
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 05:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245698AbiELDSm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 23:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245676AbiELDSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 23:18:32 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A9721604B
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 20:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652325508; x=1683861508;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=COg8H/rnrZsDiVcVhms9o3HiM706Q7sERHLRJcHf8FE=;
  b=iSlq+NW4iYiNGaXS3BPeiZkJNYAZW6qPYKXXu19LTPJL+PXeoEjCXQLg
   VCrxdmz1WH1V7DKoB3cpnmv9b7ebNRzQBF75io3kBaFlPP7Xz5QwGfsDU
   HfRUzx4BjAuZsv665JVspO9O+quPfvr40cdWAmee3aiSAYXt91UYr5dZM
   MhM5ehvMYZtiPcjGs0cDm13d5M42YSc/Aq2uv3uoCWBM7jf1PaDfB0fP1
   u4tJ+E2qvxNh+WZRcHIeQawEHsNfbPM3bfal/pu3IoIlGEUlGhVacenCd
   LW3Rr0uM1iIXXkPFbIwMIIy9w4ZOUvEFQOLmaOyRfXN3vXCNsPt2C5A/O
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="257424004"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="257424004"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 20:18:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="594455461"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga008.jf.intel.com with ESMTP; 11 May 2022 20:18:23 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, Gerd Hoffmann <kraxel@redhat.com>,
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
Subject: [RFC PATCH v4 04/36] target/i386: Introduce kvm_confidential_guest_init()
Date:   Thu, 12 May 2022 11:17:31 +0800
Message-Id: <20220512031803.3315890-5-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220512031803.3315890-1-xiaoyao.li@intel.com>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a separate function kvm_confidential_guest_init() for SEV (and
future TDX).

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/kvm.c | 11 ++++++++++-
 target/i386/sev.c     |  1 -
 target/i386/sev.h     |  2 ++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 3f8a9183fa9b..f657518616f1 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2426,6 +2426,15 @@ static void register_smram_listener(Notifier *n, void *unused)
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
@@ -2446,7 +2455,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
      * mechanisms are supported in future (e.g. TDX), they'll need
      * their own initialization either here or elsewhere.
      */
-    ret = sev_kvm_init(ms->cgs, &local_err);
+    ret = kvm_confidential_guest_init(ms, &local_err);
     if (ret < 0) {
         error_report_err(local_err);
         return ret;
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 32f7dbac4efa..6089b91cc698 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -39,7 +39,6 @@
 #include "hw/i386/pc.h"
 #include "exec/address-spaces.h"
 
-#define TYPE_SEV_GUEST "sev-guest"
 OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
 
 
diff --git a/target/i386/sev.h b/target/i386/sev.h
index 83e82aa42c41..a9c980dd4b2d 100644
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
2.27.0

