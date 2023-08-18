Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3DB780925
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 11:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359451AbjHRJ45 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 05:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359494AbjHRJ4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 05:56:38 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42723A8D
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352572; x=1723888572;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kXbz035m1UkBnkuE826SCE8I4pfJ0GU89RlTelDHwBk=;
  b=msSpJFl7T4eLs8xItCsXI+0blg75vVCcFIGaqNJlKETMcdxtXN5D4Z/d
   3XqlOzxZZ/ORrxfvxGiEC95N7PZ3Fvp8feT0S0r6RemcdwDx2x7CSrJwi
   tXsEyQmNBtg6a8HERCcqZSOnjoB2O9rI218Jl/jNFuV5wh/ONdM5acqF9
   +F6XTac0jV1LQxgVtCzThBxtois9QXi69JAxVy53yyGDWCAsNhIQGD0sD
   RDkCoQuzpkZ7Ml3i55e/nintqN0Glk7A7I7SWBl6ZMbGYw+/bAtH6XXsb
   6xcb0SBZKqhHCEjKJP4ZZGxC1nhYVF05lgM5T74vDO/HUNiiDTfh5/nfi
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371965968"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371965968"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:56:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849235160"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849235160"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:56:06 -0700
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
Subject: [PATCH v2 20/58] i386/tdx: Allows mrconfigid/mrowner/mrownerconfig for TDX_INIT_VM
Date:   Fri, 18 Aug 2023 05:50:03 -0400
Message-Id: <20230818095041.1973309-21-xiaoyao.li@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

When creating TDX vm, three sha384 hash values can be provided for
TDX attestation.

So far they were hard coded as 0. Now allow user to specify those values
via property mrconfigid, mrowner and mrownerconfig. Choose hex-encoded
string as format since it's friendly for user to input.

example
-object tdx-guest, \
  mrconfigid=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef, \
  mrowner=fedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210, \
  mrownerconfig=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
TODO:
 - community requests to use base64 encoding if no special reason
---
 qapi/qom.json         | 11 ++++++++++-
 target/i386/kvm/tdx.c | 13 +++++++++++++
 target/i386/kvm/tdx.h |  3 +++
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/qapi/qom.json b/qapi/qom.json
index cc08b9a98df9..87c1d440f331 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -873,10 +873,19 @@
 #
 # @sept-ve-disable: bit 28 of TD attributes (default: 0)
 #
+# @mrconfigid: MRCONFIGID SHA384 hex string of 48 * 2 length (default: 0)
+#
+# @mrowner: MROWNER SHA384 hex string of 48 * 2 length (default: 0)
+#
+# @mrownerconfig: MROWNERCONFIG SHA384 hex string of 48 * 2 length (default: 0)
+#
 # Since: 8.2
 ##
 { 'struct': 'TdxGuestProperties',
-  'data': { '*sept-ve-disable': 'bool' } }
+  'data': { '*sept-ve-disable': 'bool',
+            '*mrconfigid': 'str',
+            '*mrowner': 'str',
+            '*mrownerconfig': 'str' } }
 
 ##
 # @ThreadContextProperties:
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 73da15377ec3..33d015a08c34 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -521,6 +521,13 @@ int tdx_pre_create_vcpu(CPUState *cpu)
     init_vm->cpuid.nent = kvm_x86_arch_cpuid(env, init_vm->cpuid.entries, 0);
     init_vm->attributes = tdx_guest->attributes;
 
+    QEMU_BUILD_BUG_ON(sizeof(init_vm->mrconfigid) != sizeof(tdx_guest->mrconfigid));
+    QEMU_BUILD_BUG_ON(sizeof(init_vm->mrowner) != sizeof(tdx_guest->mrowner));
+    QEMU_BUILD_BUG_ON(sizeof(init_vm->mrownerconfig) != sizeof(tdx_guest->mrownerconfig));
+    memcpy(init_vm->mrconfigid, tdx_guest->mrconfigid, sizeof(tdx_guest->mrconfigid));
+    memcpy(init_vm->mrowner, tdx_guest->mrowner, sizeof(tdx_guest->mrowner));
+    memcpy(init_vm->mrownerconfig, tdx_guest->mrownerconfig, sizeof(tdx_guest->mrownerconfig));
+
     do {
         r = tdx_vm_ioctl(KVM_TDX_INIT_VM, 0, init_vm);
     } while (r == -EAGAIN);
@@ -575,6 +582,12 @@ static void tdx_guest_init(Object *obj)
     object_property_add_bool(obj, "sept-ve-disable",
                              tdx_guest_get_sept_ve_disable,
                              tdx_guest_set_sept_ve_disable);
+    object_property_add_sha384(obj, "mrconfigid", tdx->mrconfigid,
+                               OBJ_PROP_FLAG_READWRITE);
+    object_property_add_sha384(obj, "mrowner", tdx->mrowner,
+                               OBJ_PROP_FLAG_READWRITE);
+    object_property_add_sha384(obj, "mrownerconfig", tdx->mrownerconfig,
+                               OBJ_PROP_FLAG_READWRITE);
 }
 
 static void tdx_guest_finalize(Object *obj)
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 46a24ee8c7cc..68f8327f2231 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -21,6 +21,9 @@ typedef struct TdxGuest {
 
     bool initialized;
     uint64_t attributes;    /* TD attributes */
+    uint8_t mrconfigid[48];     /* sha348 digest */
+    uint8_t mrowner[48];        /* sha348 digest */
+    uint8_t mrownerconfig[48];  /* sha348 digest */
 } TdxGuest;
 
 #ifdef CONFIG_TDX
-- 
2.34.1

