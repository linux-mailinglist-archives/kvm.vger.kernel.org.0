Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42A4780902
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 11:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359403AbjHRJys (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 05:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359400AbjHRJym (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 05:54:42 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED01D272B
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352480; x=1723888480;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h73zyzASLNvlG9AYCYMj6vv1Gc8rlR2ijy1Q2NU2HtU=;
  b=eCyBZNYFIlXN6+cQmlJrtkbvKkuRbNKG+q4PNbjeKp3hFtynaHT/W0ua
   KYVaf5WqwwB5A1fLiNvNBrLHUYZeHtYcXUPGZqbnikZWm7G/8lVtta5J4
   4zV1zgquKE4xS6PAiKuyvm13n6wLpSuGLuPP+G2FQ3bib7lvRNbo/01dX
   8sgz3Jrq9QlW0sAoCvxmcdvR4p4K/IDLdMB+9Wt/mkd0uq+nCae76BkL5
   3hfPG3UlqXoBMfHpV3El2O5sYbQL2J2maLx7jbQY4oUFyDDdtIGZV7lCl
   SA9HREuuWUzRk+FIV23B8eNImECsIj1D859Z6ATD5RxcQVTuZuP/l0HmD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371965560"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371965560"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:54:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849234794"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849234794"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:54:35 -0700
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
Subject: [PATCH v2 03/58] target/i386: Parse TDX vm type
Date:   Fri, 18 Aug 2023 05:49:46 -0400
Message-Id: <20230818095041.1973309-4-xiaoyao.li@intel.com>
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

TDX VM requires VM type KVM_X86_TDX_VM to be passed to
kvm_ioctl(KVM_CREATE_VM).

If tdx-guest object is specified to confidential-guest-support, like,

  qemu -machine ...,confidential-guest-support=tdx0 \
       -object tdx-guest,id=tdx0,...

it parses VM type as KVM_X86_TDX_VM.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/kvm.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 62f237068a3a..77f4772afe6c 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -32,6 +32,7 @@
 #include "sysemu/runstate.h"
 #include "kvm_i386.h"
 #include "sev.h"
+#include "tdx.h"
 #include "xen-emu.h"
 #include "hyperv.h"
 #include "hyperv-proto.h"
@@ -158,6 +159,7 @@ static int kvm_get_one_msr(X86CPU *cpu, int index, uint64_t *value);
 static const char* vm_type_name[] = {
     [KVM_X86_DEFAULT_VM] = "default",
     [KVM_X86_SW_PROTECTED_VM] = "sw-protected-vm",
+    [KVM_X86_TDX_VM] = "tdx",
 };
 
 int kvm_get_vm_type(MachineState *ms, const char *vm_type)
@@ -170,12 +172,18 @@ int kvm_get_vm_type(MachineState *ms, const char *vm_type)
             kvm_type = KVM_X86_DEFAULT_VM;
         } else if (!g_ascii_strcasecmp(vm_type, "sw-protected-vm")) {
             kvm_type = KVM_X86_SW_PROTECTED_VM;
-        } else {
+        } else if (!g_ascii_strcasecmp(vm_type, "tdx")) {
+            kvm_type = KVM_X86_TDX_VM;
+        }else {
             error_report("Unknown kvm-type specified '%s'", vm_type);
             exit(1);
         }
     }
 
+    if (ms->cgs && object_dynamic_cast(OBJECT(ms->cgs), TYPE_TDX_GUEST)) {
+        kvm_type = KVM_X86_TDX_VM;
+    }
+
     /*
      * old KVM doesn't support KVM_CAP_VM_TYPES and KVM_X86_DEFAULT_VM
      * is always supported
-- 
2.34.1

