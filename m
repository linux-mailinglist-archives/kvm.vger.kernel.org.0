Return-Path: <kvm+bounces-45932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61994AAFE8E
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:12:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11096465AEC
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:10:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D307927A903;
	Thu,  8 May 2025 15:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dgv5oquw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B401A239F
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716787; cv=none; b=nOlWrl1y57W/UAhIhFqFjkZmgNM8RNCvj0Oj3Uoct0P/A6AT+9NplZ5GdX/b1z7y99WYqGWA1Moy5ZRX7B/jsCCZ9IEPBkRVlcXtmqQnf078VVp9xtPOaYhxq2tta3AX1LX8JT1fBi5KeR8OS5BqufAHHvnqc4QV9lGmpG3lhL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716787; c=relaxed/simple;
	bh=x2kqyFzDP0o/tEqatbnmXsZt2N2+iX3e/6TbvOqfIEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFsx0C/wfqzedZEKIQ98aUOJUJBJZSKFe1fLYps79NPRN7hLgmKokZRQDjAODV+jMEpo5QUvtuf372yQ/CIKSb5V3T0iAPtM/uSLfyHCAv0eNR9YoDRjaG6wR5lOesbK9q5ArKwavbXm5FRbtQ/dXGPqTOoZZdhFaWmaiUquByA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dgv5oquw; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716785; x=1778252785;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x2kqyFzDP0o/tEqatbnmXsZt2N2+iX3e/6TbvOqfIEk=;
  b=Dgv5oquwx8vh2Rf/4Fz/ijOOmDIENgJvTHj727dzKQoMKnLDNjTtWI78
   uauls34Ng0nz9bceAvf5GAuFZguNGwLhaNSiSwLURHQDV91Lx0qUan8u8
   K/PHSr/D6VF0AVK2SYEFCAa7BRxuJIK918mb8zrgUxuFq4JVIsPnAAe7u
   rBXjsqSKBbZ9l2b/NEPzpyTRdGexTcsX033iWLUBeJiPRPQHuAqxhOs8h
   SewIGnFiey4GguLrHV5shYUSlA+tftsNPUyExdnCjkPnxcX4a9+B5GP76
   h7uLZNYAePz8unbU5eiKMaJensGK5+sHlhz5DQOshzEaGVRz2uVIQHF6t
   Q==;
X-CSE-ConnectionGUID: 4kJqQpc8Rci+YtHr7dHVyw==
X-CSE-MsgGUID: FjZXAoA3T7mFpwdArdVURw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888255"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888255"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:06:25 -0700
X-CSE-ConnectionGUID: Vr7n9L7NRqyuur7/B4JFbw==
X-CSE-MsgGUID: XcQMzW4kRk2d38QSx5dvGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440109"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:06:22 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 29/55] i386/tdx: Wire TDX_REPORT_FATAL_ERROR with GuestPanic facility
Date: Thu,  8 May 2025 10:59:35 -0400
Message-ID: <20250508150002.689633-30-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
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
Acked-by: Markus Armbruster <armbru@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes in v9:
- move the MACRO definition of TDX_REPORT_FATAL_ERROR_GPA_VALID out of
  the function; (Zhao Liu)

Changes in v8:
- use g_strdup() for copy string;
- use the new data ABI of KVM_SYSTEM_EVENT_TDX_FATAL to grab gpa info;

Changes in v6:
- change error_code of GuestPanicInformationTdx from uint64_t to
  uint32_t, to only contains the bit 31:0 returned in r12.

Changes in v5:
- mention additional error information in gpa when it presents;
- refine the documentation; (Markus)

Changes in v4:
- refine the documentation; (Markus)

Changes in v3:
- Add docmentation of new type and struct; (Daniel)
- refine the error message handling; (Daniel)
---
 qapi/run-state.json   | 31 +++++++++++++++++++--
 system/runstate.c     | 65 +++++++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/tdx.c | 25 ++++++++++++++++-
 3 files changed, 118 insertions(+), 3 deletions(-)

diff --git a/qapi/run-state.json b/qapi/run-state.json
index ce95cfa46b73..ee11adc50889 100644
--- a/qapi/run-state.json
+++ b/qapi/run-state.json
@@ -501,10 +501,12 @@
 #
 # @s390: s390 guest panic information type (Since: 2.12)
 #
+# @tdx: tdx guest panic information type (Since: 10.1)
+#
 # Since: 2.9
 ##
 { 'enum': 'GuestPanicInformationType',
-  'data': [ 'hyper-v', 's390' ] }
+  'data': [ 'hyper-v', 's390', 'tdx' ] }
 
 ##
 # @GuestPanicInformation:
@@ -519,7 +521,8 @@
  'base': {'type': 'GuestPanicInformationType'},
  'discriminator': 'type',
  'data': {'hyper-v': 'GuestPanicInformationHyperV',
-          's390': 'GuestPanicInformationS390'}}
+          's390': 'GuestPanicInformationS390',
+          'tdx' : 'GuestPanicInformationTdx'}}
 
 ##
 # @GuestPanicInformationHyperV:
@@ -598,6 +601,30 @@
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
+# Since: 10.1
+##
+{'struct': 'GuestPanicInformationTdx',
+ 'data': {'error-code': 'uint32',
+          'message': 'str',
+          '*gpa': 'uint64'}}
+
 ##
 # @MEMORY_FAILURE:
 #
diff --git a/system/runstate.c b/system/runstate.c
index 272801d30769..e9d5d7505b4a 100644
--- a/system/runstate.c
+++ b/system/runstate.c
@@ -565,6 +565,58 @@ static void qemu_system_wakeup(void)
     }
 }
 
+static char *tdx_parse_panic_message(char *message)
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
+        /* The caller guarantees the NULL-terminated string. */
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
+    if (len == 0) {
+        buf = g_malloc(1);
+        buf[0] = '\0';
+    } else {
+        if (!printable) {
+            /* 3 = length of "%02x " */
+            buf = g_malloc(len * 3);
+            for (i = 0; i < len; i++) {
+                if (message[i] == '\0') {
+                    break;
+                } else {
+                    sprintf(buf + 3 * i, "%02x ", message[i]);
+                }
+            }
+            if (i > 0) {
+                /* replace the last ' '(space) to NULL */
+                buf[i * 3 - 1] = '\0';
+            } else {
+                buf[0] = '\0';
+            }
+        } else {
+            buf = g_strdup(message);
+        }
+    }
+
+    return buf;
+}
+
 void qemu_system_guest_panicked(GuestPanicInformation *info)
 {
     qemu_log_mask(LOG_GUEST_ERROR, "Guest crashed");
@@ -606,7 +658,20 @@ void qemu_system_guest_panicked(GuestPanicInformation *info)
                           S390CrashReason_str(info->u.s390.reason),
                           info->u.s390.psw_mask,
                           info->u.s390.psw_addr);
+        } else if (info->type == GUEST_PANIC_INFORMATION_TYPE_TDX) {
+            char *message = tdx_parse_panic_message(info->u.tdx.message);
+            qemu_log_mask(LOG_GUEST_ERROR,
+                          "\nTDX guest reports fatal error."
+                          " error code: 0x%" PRIx32 " error message:\"%s\"\n",
+                          info->u.tdx.error_code, message);
+            g_free(message);
+            if (info->u.tdx.gpa != -1ull) {
+                qemu_log_mask(LOG_GUEST_ERROR, "Additional error information "
+                              "can be found at gpa page: 0x%" PRIx64 "\n",
+                              info->u.tdx.gpa);
+            }
         }
+
         qapi_free_GuestPanicInformation(info);
     }
 }
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 5a140e88eb92..e80586feb704 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -16,6 +16,7 @@
 #include "qapi/error.h"
 #include "qom/object_interfaces.h"
 #include "crypto/hash.h"
+#include "system/runstate.h"
 #include "system/system.h"
 #include "exec/ramblock.h"
 
@@ -622,18 +623,35 @@ int tdx_parse_tdvf(void *flash_ptr, int size)
     return tdvf_parse_metadata(&tdx_guest->tdvf, flash_ptr, size);
 }
 
+static void tdx_panicked_on_fatal_error(X86CPU *cpu, uint64_t error_code,
+                                        char *message, uint64_t gpa)
+{
+    GuestPanicInformation *panic_info;
+
+    panic_info = g_new0(GuestPanicInformation, 1);
+    panic_info->type = GUEST_PANIC_INFORMATION_TYPE_TDX;
+    panic_info->u.tdx.error_code = (uint32_t) error_code;
+    panic_info->u.tdx.message = message;
+    panic_info->u.tdx.gpa = gpa;
+
+    qemu_system_guest_panicked(panic_info);
+}
+
 /*
  * Only 8 registers can contain valid ASCII byte stream to form the fatal
  * message, and their sequence is: R14, R15, RBX, RDI, RSI, R8, R9, RDX
  */
 #define TDX_FATAL_MESSAGE_MAX        64
 
+#define TDX_REPORT_FATAL_ERROR_GPA_VALID    BIT_ULL(63)
+
 int tdx_handle_report_fatal_error(X86CPU *cpu, struct kvm_run *run)
 {
     uint64_t error_code = run->system_event.data[R_R12];
     uint64_t reg_mask = run->system_event.data[R_ECX];
     char *message = NULL;
     uint64_t *tmp;
+    uint64_t gpa = -1ull;
 
     if (error_code & 0xffff) {
         error_report("TDX: REPORT_FATAL_ERROR: invalid error code: 0x%lx",
@@ -664,7 +682,12 @@ int tdx_handle_report_fatal_error(X86CPU *cpu, struct kvm_run *run)
     }
 #undef COPY_REG
 
-    error_report("TD guest reports fatal error. %s", message ? : "");
+    if (error_code & TDX_REPORT_FATAL_ERROR_GPA_VALID) {
+        gpa = run->system_event.data[R_R13];
+    }
+
+    tdx_panicked_on_fatal_error(cpu, error_code, message, gpa);
+
     return -1;
 }
 
-- 
2.43.0


