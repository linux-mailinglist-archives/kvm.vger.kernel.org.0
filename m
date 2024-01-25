Return-Path: <kvm+bounces-6955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7416683B835
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:33:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 14A2EB270AB
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:33:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D64812E49;
	Thu, 25 Jan 2024 03:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CAqnPLwg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A785612E40
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153452; cv=none; b=QdpVkOdY8J9RdyKlR+RGDxlQk1Np2tIq/2aBRSkNTp16JcNXKoXJOJRbfCVhEHd6qZcePv1EFYCVVupAt+Yhb9QNvpAMDHqcgDqcsfnFOyHBnBi+08G0FWKJYko4OS92DtDS5QLurd7LJAlgnss1Tj1mCmNmQLXlEIKdb3MsePQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153452; c=relaxed/simple;
	bh=XbBZ8FghQKjl9boDgrpDUaHhve+aNsi3xaBiWaJYrm0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jT02aySUhY8epILky1HGO9AeppSuWS5vuVFNLnuLX9Qa9RApan03etJmovT/wCMR2XX99iRoXw+A7Gc9TEJbb0O+wp+i6+8XssDg05yVD4ZunrYctngQ4tsrv3uXpBL3snhxREkkct76n22XqaPLLW/1od+UV2Q3g74brzXc61o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CAqnPLwg; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153451; x=1737689451;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XbBZ8FghQKjl9boDgrpDUaHhve+aNsi3xaBiWaJYrm0=;
  b=CAqnPLwga9sOq2F50F+M6RsQ8XsEmRJYBTXaZRSgz/+UCX4gZ8b51yhv
   Zd1nHrxKd0NNjgZaIS60a86Ej4Z8+yTCrihmxi+NMjpSbSDV+mJA05ehv
   jWdmhR4rvgOda3HRfEZmQDsVpQKO3/bhIEfd4iEi3H3rM4bKiu5U7zp7+
   aT3t679oDhB3HHIIXCU8/+ISAiUWWbKqIlUG+abbk7juXdmvWCDbYCWQA
   kvRCE67aA0/prX7Ty3JT+vLw32+RaoSHxNeSFkr95q+XwuQqkWIW9o6Br
   MIJQFgnogbwyNekn4QSB2iXxPgGicTgZ2P5pvfzLdZ02W01o8A7UsI36k
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9430152"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9430152"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:28:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2086209"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:28:23 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v4 53/66] i386/tdx: Wire TDX_REPORT_FATAL_ERROR with GuestPanic facility
Date: Wed, 24 Jan 2024 22:23:15 -0500
Message-Id: <20240125032328.2522472-54-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125032328.2522472-1-xiaoyao.li@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Integrate TDX's TDX_REPORT_FATAL_ERROR into QEMU GuestPanic facility

Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v4:
- refine the documentation; (Markus)

Changes in v3:
- Add docmentation of new type and struct; (Daniel)
- refine the error message handling; (Daniel)
---
 qapi/run-state.json   | 28 ++++++++++++++++++++--
 system/runstate.c     | 54 +++++++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/tdx.c | 24 ++++++++++++++++++-
 3 files changed, 103 insertions(+), 3 deletions(-)

diff --git a/qapi/run-state.json b/qapi/run-state.json
index 08bc99cb8561..5429116679e3 100644
--- a/qapi/run-state.json
+++ b/qapi/run-state.json
@@ -485,10 +485,12 @@
 #
 # @s390: s390 guest panic information type (Since: 2.12)
 #
+# @tdx: tdx guest panic information type (Since: 8.2)
+#
 # Since: 2.9
 ##
 { 'enum': 'GuestPanicInformationType',
-  'data': [ 'hyper-v', 's390' ] }
+  'data': [ 'hyper-v', 's390', 'tdx' ] }
 
 ##
 # @GuestPanicInformation:
@@ -503,7 +505,8 @@
  'base': {'type': 'GuestPanicInformationType'},
  'discriminator': 'type',
  'data': {'hyper-v': 'GuestPanicInformationHyperV',
-          's390': 'GuestPanicInformationS390'}}
+          's390': 'GuestPanicInformationS390',
+          'tdx' : 'GuestPanicInformationTdx'}}
 
 ##
 # @GuestPanicInformationHyperV:
@@ -566,6 +569,27 @@
           'psw-addr': 'uint64',
           'reason': 'S390CrashReason'}}
 
+##
+# @GuestPanicInformationTdx:
+#
+# TDX Guest panic information specific to TDX GCHI
+# TDG.VP.VMCALL<ReportFatalError>.
+#
+# @error-code: TD-specific error code
+#
+# @gpa: guest-physical address of a page that contains additional
+#     error data, in forms of zero-terminated string.
+#
+# @message: Human-readable error message provided by the guest. Not
+#     to be trusted.
+#
+# Since: 9.0
+##
+{'struct': 'GuestPanicInformationTdx',
+ 'data': {'error-code': 'uint64',
+          'gpa': 'uint64',
+          'message': 'str'}}
+
 ##
 # @MEMORY_FAILURE:
 #
diff --git a/system/runstate.c b/system/runstate.c
index d6ab860ecaa7..1ae85ea2c345 100644
--- a/system/runstate.c
+++ b/system/runstate.c
@@ -519,6 +519,52 @@ static void qemu_system_wakeup(void)
     }
 }
 
+static char* tdx_parse_panic_message(char *message)
+{
+    bool printable = false;
+    char *buf = NULL;
+    int len = 0, i;
+
+    /*
+     * Although message is defined as a json string, we shouldn't
+     * unconditionally treat it as is because the guest generated it and
+     * it's not necessarily trustable.
+     */
+    if (message) {
+        /* The caller guarantees the NUL-terminated string. */
+        len = strlen(message);
+
+        printable = len > 0;
+        for (i = 0; i < len; i++) {
+            if (!(0x20 <= message[i] && message[i] <= 0x7e)) {
+                printable = false;
+                break;
+            }
+        }
+    }
+
+    if (!printable && len) {
+        /* 3 = length of "%02x " */
+        buf = g_malloc(len * 3);
+        for (i = 0; i < len; i++) {
+            if (message[i] == '\0') {
+                break;
+            } else {
+                sprintf(buf + 3 * i, "%02x ", message[i]);
+            }
+        }
+        if (i > 0)
+            /* replace the last ' '(space) to NUL */
+            buf[i * 3 - 1] = '\0';
+        else
+            buf[0] = '\0';
+
+        return buf;
+    }
+
+    return message;
+}
+
 void qemu_system_guest_panicked(GuestPanicInformation *info)
 {
     qemu_log_mask(LOG_GUEST_ERROR, "Guest crashed");
@@ -560,7 +606,15 @@ void qemu_system_guest_panicked(GuestPanicInformation *info)
                           S390CrashReason_str(info->u.s390.reason),
                           info->u.s390.psw_mask,
                           info->u.s390.psw_addr);
+        } else if (info->type == GUEST_PANIC_INFORMATION_TYPE_TDX) {
+            qemu_log_mask(LOG_GUEST_ERROR,
+                          " TDX guest reports fatal error:\"%s\""
+                          " error code: 0x%016" PRIx64 " gpa page: 0x%016" PRIx64 "\n",
+                          tdx_parse_panic_message(info->u.tdx.message),
+                          info->u.tdx.error_code,
+                          info->u.tdx.gpa);
         }
+
         qapi_free_GuestPanicInformation(info);
     }
 }
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 1c79032ca262..4fbb18135951 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -20,6 +20,7 @@
 #include "qom/object_interfaces.h"
 #include "standard-headers/asm-x86/kvm_para.h"
 #include "sysemu/kvm.h"
+#include "sysemu/runstate.h"
 #include "sysemu/sysemu.h"
 #include "exec/address-spaces.h"
 #include "exec/ramblock.h"
@@ -1078,11 +1079,26 @@ static int tdx_handle_get_quote(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
     return 0;
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
+    panic_info->u.tdx.message = message;
+
+    qemu_system_guest_panicked(panic_info);
+}
+
 static int tdx_handle_report_fatal_error(X86CPU *cpu,
                                          struct kvm_tdx_vmcall *vmcall)
 {
     uint64_t error_code = vmcall->in_r12;
     char *message = NULL;
+    uint64_t gpa = -1ull;
 
     if (error_code & 0xffff) {
         error_report("TDX: REPORT_FATAL_ERROR: invalid error code: "
@@ -1111,7 +1127,13 @@ static int tdx_handle_report_fatal_error(X86CPU *cpu,
         assert((char *)tmp == message + GUEST_PANIC_INFO_TDX_MESSAGE_MAX);
     }
 
-    error_report("TD guest reports fatal error. %s\n", message ? : "");
+#define TDX_REPORT_FATAL_ERROR_GPA_VALID    BIT_ULL(63)
+    if (error_code & TDX_REPORT_FATAL_ERROR_GPA_VALID) {
+        gpa = vmcall->in_r13;
+    }
+
+    tdx_panicked_on_fatal_error(cpu, error_code, gpa, message);
+
     return -1;
 }
 
-- 
2.34.1


