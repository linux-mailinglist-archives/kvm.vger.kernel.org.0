Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF8F780970
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 12:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359619AbjHRKBM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 06:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359639AbjHRKAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 06:00:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF60423A
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 03:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352821; x=1723888821;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Wzl1mEkj+oKZ5v/JH8PdKP/YtEL6uTtNv7gUv6XTCgc=;
  b=I0UIF5RNTBsDZFZPGWskXW/ZGD6xFbdM5BUg/C/s/lud44BKk6LJMveF
   MNU/lUrd0zZek/6J3ZaZlMvVvuSUPNnQrda1uNfw8mBZptSnT74uSPxnD
   DGudnWx6oq5kBDgimPmFcox851Km/PtsV1dByNp+/Zmji4ShPA7TqzzbA
   4SvhGIuDYDNXpJRTIK2cx759uBjuofmkqj9vCuVs2VQ0K4p/bT47vZ8IB
   fWTzGsnu4gQgRjo/Tia3VN0NkrjHqGR+axP0u6RZCMPMlQoC89pvWOr3k
   XaIsRtrEIXTgWIKusyZXtuWjkT+mU+BcfDiUJXn088TsIDRQ6KEfQEvKD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371966774"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371966774"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:58:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849235554"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849235554"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:58:27 -0700
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
Subject: [PATCH v2 47/58] i386/tdx: Wire REPORT_FATAL_ERROR with GuestPanic facility
Date:   Fri, 18 Aug 2023 05:50:30 -0400
Message-Id: <20230818095041.1973309-48-xiaoyao.li@intel.com>
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

Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 qapi/run-state.json   | 17 +++++++++++++--
 softmmu/runstate.c    | 49 +++++++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/tdx.c | 24 ++++++++++++++++++++-
 3 files changed, 87 insertions(+), 3 deletions(-)

diff --git a/qapi/run-state.json b/qapi/run-state.json
index f216ba54ec4c..506bbe31541f 100644
--- a/qapi/run-state.json
+++ b/qapi/run-state.json
@@ -499,7 +499,7 @@
 # Since: 2.9
 ##
 { 'enum': 'GuestPanicInformationType',
-  'data': [ 'hyper-v', 's390' ] }
+  'data': [ 'hyper-v', 's390', 'tdx' ] }
 
 ##
 # @GuestPanicInformation:
@@ -514,7 +514,8 @@
  'base': {'type': 'GuestPanicInformationType'},
  'discriminator': 'type',
  'data': {'hyper-v': 'GuestPanicInformationHyperV',
-          's390': 'GuestPanicInformationS390'}}
+          's390': 'GuestPanicInformationS390',
+          'tdx' : 'GuestPanicInformationTdx'}}
 
 ##
 # @GuestPanicInformationHyperV:
@@ -577,6 +578,18 @@
           'psw-addr': 'uint64',
           'reason': 'S390CrashReason'}}
 
+##
+# @GuestPanicInformationTdx:
+#
+# TDX GHCI TDG.VP.VMCALL<ReportFatalError> specific guest panic information
+#
+# Since: 8.2
+##
+{'struct': 'GuestPanicInformationTdx',
+ 'data': {'error-code': 'uint64',
+          'gpa': 'uint64',
+          'message': 'str'}}
+
 ##
 # @MEMORY_FAILURE:
 #
diff --git a/softmmu/runstate.c b/softmmu/runstate.c
index f3bd86281813..cab11484ed7e 100644
--- a/softmmu/runstate.c
+++ b/softmmu/runstate.c
@@ -518,7 +518,56 @@ void qemu_system_guest_panicked(GuestPanicInformation *info)
                           S390CrashReason_str(info->u.s390.reason),
                           info->u.s390.psw_mask,
                           info->u.s390.psw_addr);
+        } else if (info->type == GUEST_PANIC_INFORMATION_TYPE_TDX) {
+            char *buf = NULL;
+            bool printable = false;
+
+            /*
+             * Although message is defined as a json string, we shouldn't
+             * unconditionally treat it as is because the guest generated it and
+             * it's not necessarily trustable.
+             */
+            if (info->u.tdx.message) {
+                /* The caller guarantees the NUL-terminated string. */
+                int len = strlen(info->u.tdx.message);
+                int i;
+
+                printable = len > 0;
+                for (i = 0; i < len; i++) {
+                    if (!(0x20 <= info->u.tdx.message[i] &&
+                          info->u.tdx.message[i] <= 0x7e)) {
+                        printable = false;
+                        break;
+                    }
+                }
+
+                /* 3 = length of "%02x " */
+                buf = g_malloc(len * 3);
+                for (i = 0; i < len; i++) {
+                    if (info->u.tdx.message[i] == '\0') {
+                        break;
+                    } else {
+                        sprintf(buf + 3 * i, "%02x ", info->u.tdx.message[i]);
+                    }
+                }
+                if (i > 0)
+                    /* replace the last ' '(space) to NUL */
+                    buf[i * 3 - 1] = '\0';
+                else
+                    buf[0] = '\0';
+            }
+
+            qemu_log_mask(LOG_GUEST_ERROR,
+                          //" TDX report fatal error:\"%s\" %s",
+                          " TDX report fatal error:\"%s\""
+                          "error: 0x%016" PRIx64 " gpa page: 0x%016" PRIx64 "\n",
+                          printable ? info->u.tdx.message : "",
+                          //buf ? buf : "",
+                          info->u.tdx.error_code,
+                          info->u.tdx.gpa);
+            g_free(buf);
         }
+
         qapi_free_GuestPanicInformation(info);
     }
 }
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index f111b46dac92..7efaa13f59e2 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -18,6 +18,7 @@
 #include "qom/object_interfaces.h"
 #include "standard-headers/asm-x86/kvm_para.h"
 #include "sysemu/kvm.h"
+#include "sysemu/runstate.h"
 #include "sysemu/sysemu.h"
 #include "exec/address-spaces.h"
 #include "exec/ramblock.h"
@@ -1408,11 +1409,26 @@ static void tdx_handle_get_quote(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
     vmcall->status_code = TDG_VP_VMCALL_SUCCESS;
 }
 
+static void tdx_panicked_on_fatal_error(X86CPU *cpu, uint64_t error_code,
+                                        uint64_t gpa, char *message)
+{
+    GuestPanicInformation *panic_info;
+
+    panic_info = g_new0(GuestPanicInformation, 1);
+    panic_info->type = GUEST_PANIC_INFORMATION_TYPE_TDX;
+    panic_info->u.tdx.error_code = error_code;
+    panic_info->u.tdx.gpa = gpa;
+    panic_info->u.tdx.message = (char *)message;
+
+    qemu_system_guest_panicked(panic_info);
+}
+
 static void tdx_handle_report_fatal_error(X86CPU *cpu,
                                           struct kvm_tdx_vmcall *vmcall)
 {
     uint64_t error_code = vmcall->in_r12;
     char *message = NULL;
+    uint64_t gpa = -1ull;
 
     if (error_code & 0xffff) {
         error_report("invalid error code of TDG.VP.VMCALL<REPORT_FATAL_ERROR>\n");
@@ -1441,7 +1457,13 @@ static void tdx_handle_report_fatal_error(X86CPU *cpu,
     }
 
     error_report("TD guest reports fatal error. %s\n", message ? : "");
-    exit(1);
+
+#define TDX_REPORT_FATAL_ERROR_GPA_VALID    BIT_ULL(63)
+    if (error_code & TDX_REPORT_FATAL_ERROR_GPA_VALID) {
+	gpa = vmcall->in_r13;
+    }
+
+    tdx_panicked_on_fatal_error(cpu, error_code, gpa, message);
 }
 
 static void tdx_handle_setup_event_notify_interrupt(X86CPU *cpu,
-- 
2.34.1

