Return-Path: <kvm+bounces-10408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A4E7986C11E
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:44:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1CB0FB2234A
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:44:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4B0146B9F;
	Thu, 29 Feb 2024 06:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jTwT3sOW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E35E46449
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188999; cv=none; b=sP43AxLRt1U19MQZW2VBij3N3x/HMr1VgtBzLXrdI05q1ALp5cCq4NV5rMmcbMS3562Xg42clubDAQWMa1BfmCQbg3JPhmXbvd7UTKuFTCcdqG1uGcc/MK5XylKGOxJOIJejblD5ZZw4t8dWAU8XVuKBQOj79eXp0jaAAgx+R0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188999; c=relaxed/simple;
	bh=VKrXmZ4yWCwN3uMt3MgNU2umCNe3ZwiWGHCR+mMGlKk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BBl+1LOBn8KUe+XmcOxzkF4Eujq1yDej9WuVsd9/3M3mbtLe31mQ9K9W/n84Gx1WrwCYSBtfdokJU8YNDgOGdrsl+U7zHcaLJ68AvcquH+QiYilQbFtcI1xtCTV92d2h9BfvR+oM8spyCKuZjcW7oWO667/CvtlaqZRUbS8PjXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jTwT3sOW; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188997; x=1740724997;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VKrXmZ4yWCwN3uMt3MgNU2umCNe3ZwiWGHCR+mMGlKk=;
  b=jTwT3sOWn4Z4To/LBvRq2rynM26ZRVMKmJwYLwZYsoJxL2wpMVVUJ5hJ
   /LWc1RpclOgAAjQw+qpEaMA9uDeqgcwrZM9qBofE6Ieo345fAG8CrsC5y
   I1cHJ8hDoNMODk95kLlGOL1HknGWCe6Q6/KxSWEc6gqwFLGicdqTxv5cj
   Q/UvrzlT3szsc7KCqkk8s7obUnbdRn0P36BoE2u7huYhXXhyhXIA+Xffe
   2M4lu2fFSh8LXylgAClUWiZlSyPVA7+xq3I4dGBazXGdlh5GRuarBsjnA
   A0Gt8tjIwbYiLmorROx34B0uSwRtlEh/9WAynYf4NwmIj6iCm89eKmZxf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3803135"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3803135"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:43:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8076173"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:43:11 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	xiaoyao.li@intel.com
Subject: [PATCH v5 52/65] i386/tdx: Wire TDX_REPORT_FATAL_ERROR with GuestPanic facility
Date: Thu, 29 Feb 2024 01:37:13 -0500
Message-Id: <20240229063726.610065-53-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240229063726.610065-1-xiaoyao.li@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
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
Changes in v5:
- mention additional error information in gpa when it presents;
- refine the documentation; (Markus)

Changes in v4:
- refine the documentation; (Markus)

Changes in v3:
- Add docmentation of new type and struct; (Daniel)
- refine the error message handling; (Daniel)
---
 qapi/run-state.json   | 31 +++++++++++++++++++++--
 system/runstate.c     | 58 +++++++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/tdx.c | 24 +++++++++++++++++-
 3 files changed, 110 insertions(+), 3 deletions(-)

diff --git a/qapi/run-state.json b/qapi/run-state.json
index dd0770b379e5..b71dd1884eb6 100644
--- a/qapi/run-state.json
+++ b/qapi/run-state.json
@@ -483,10 +483,12 @@
 #
 # @s390: s390 guest panic information type (Since: 2.12)
 #
+# @tdx: tdx guest panic information type (Since: 9.0)
+#
 # Since: 2.9
 ##
 { 'enum': 'GuestPanicInformationType',
-  'data': [ 'hyper-v', 's390' ] }
+  'data': [ 'hyper-v', 's390', 'tdx' ] }
 
 ##
 # @GuestPanicInformation:
@@ -501,7 +503,8 @@
  'base': {'type': 'GuestPanicInformationType'},
  'discriminator': 'type',
  'data': {'hyper-v': 'GuestPanicInformationHyperV',
-          's390': 'GuestPanicInformationS390'}}
+          's390': 'GuestPanicInformationS390',
+          'tdx' : 'GuestPanicInformationTdx'}}
 
 ##
 # @GuestPanicInformationHyperV:
@@ -564,6 +567,30 @@
           'psw-addr': 'uint64',
           'reason': 'S390CrashReason'}}
 
+##
+# @GuestPanicInformationTdx:
+#
+# TDX Guest panic information specific to TDX, as specified in the
+# "Guest-Hypervisor Communication Interface (GHCI) Specification",
+# section TDG.VP.VMCALL<ReportFatalError>.
+#
+# @error-code: TD-specific error code
+#
+# @message: Human-readable error message provided by the guest. Not
+#     to be trusted.
+#
+# @gpa: guest-physical address of a page that contains more verbose
+#     error information, as zero-terminated string.  Present when the
+#     "GPA valid" bit (bit 63) is set in @error-code.
+#
+#
+# Since: 9.0
+##
+{'struct': 'GuestPanicInformationTdx',
+ 'data': {'error-code': 'uint64',
+          'message': 'str',
+          '*gpa': 'uint64'}}
+
 ##
 # @MEMORY_FAILURE:
 #
diff --git a/system/runstate.c b/system/runstate.c
index d6ab860ecaa7..3b628c38739d 100644
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
@@ -560,7 +606,19 @@ void qemu_system_guest_panicked(GuestPanicInformation *info)
                           S390CrashReason_str(info->u.s390.reason),
                           info->u.s390.psw_mask,
                           info->u.s390.psw_addr);
+        } else if (info->type == GUEST_PANIC_INFORMATION_TYPE_TDX) {
+            qemu_log_mask(LOG_GUEST_ERROR,
+                          " TDX guest reports fatal error:"
+                          " error code: 0x%#" PRIx64 " error message:\"%s\"\n",
+                          info->u.tdx.error_code,
+                          tdx_parse_panic_message(info->u.tdx.message));
+            if (info->u.tdx.error_code & (1ull << 63)) {
+                qemu_log_mask(LOG_GUEST_ERROR, "Additional error information "
+                              "can be found at gpa page: 0x%#" PRIx64 "\n",
+                              info->u.tdx.gpa);
+            }
         }
+
         qapi_free_GuestPanicInformation(info);
     }
 }
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 6cd72a26b970..811a3b81af99 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -20,6 +20,7 @@
 #include "qom/object_interfaces.h"
 #include "standard-headers/asm-x86/kvm_para.h"
 #include "sysemu/kvm.h"
+#include "sysemu/runstate.h"
 #include "sysemu/sysemu.h"
 #include "exec/ramblock.h"
 
@@ -1092,11 +1093,26 @@ static int tdx_handle_get_quote(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
     return 0;
 }
 
+static void tdx_panicked_on_fatal_error(X86CPU *cpu, uint64_t error_code,
+                                        char *message, uint64_t gpa)
+{
+    GuestPanicInformation *panic_info;
+
+    panic_info = g_new0(GuestPanicInformation, 1);
+    panic_info->type = GUEST_PANIC_INFORMATION_TYPE_TDX;
+    panic_info->u.tdx.error_code = error_code;
+    panic_info->u.tdx.message = message;
+    panic_info->u.tdx.gpa = gpa;
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
@@ -1125,7 +1141,13 @@ static int tdx_handle_report_fatal_error(X86CPU *cpu,
         assert((char *)tmp == message + GUEST_PANIC_INFO_TDX_MESSAGE_MAX);
     }
 
-    error_report("TD guest reports fatal error. %s\n", message ? : "");
+#define TDX_REPORT_FATAL_ERROR_GPA_VALID    BIT_ULL(63)
+    if (error_code & TDX_REPORT_FATAL_ERROR_GPA_VALID) {
+        gpa = vmcall->in_r13;
+    }
+
+    tdx_panicked_on_fatal_error(cpu, error_code, message, gpa);
+
     return -1;
 }
 
-- 
2.34.1


