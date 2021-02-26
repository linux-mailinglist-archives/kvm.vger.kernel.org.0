Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5252326284
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 13:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhBZMQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 07:16:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:44724 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230357AbhBZMQB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 07:16:01 -0500
IronPort-SDR: PUC/Dpf+NZzbCZiwhxlJhmi9WfgiNvhIo7Lnlvtw1jwWZZQHcBh/mCluVJH8+yOwjVkvNTjFKZ
 xdnxniDz7gbQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9906"; a="185979924"
X-IronPort-AV: E=Sophos;i="5.81,208,1610438400"; 
   d="scan'208";a="185979924"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 04:15:30 -0800
IronPort-SDR: N+nZva2H8dGhAtkWf49EK6iY7vEMmPLabQnLeKu+/CjFleiX4FFVG6UrLF7FKnz2eaLNjG9oUC
 JRJtdSaesKvQ==
X-IronPort-AV: E=Sophos;i="5.81,208,1610438400"; 
   d="scan'208";a="598420542"
Received: from ciparjol-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.175])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 04:15:25 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v6 08/25] x86/sgx: Expose SGX architectural definitions to the kernel
Date:   Sat, 27 Feb 2021 01:15:07 +1300
Message-Id: <caaffe4375099b939dbdb5fa04302dd44c7881e2.1614338774.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1614338774.git.kai.huang@intel.com>
References: <cover.1614338774.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Expose SGX architectural structures, as KVM will use many of the
architectural constants and structs to virtualize SGX.

Name the new header file as asm/sgx.h, rather than asm/sgx_arch.h, to
have single header to provide SGX facilities to share with other kernel
componments.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
v5->v6:

 - Renamed asm/sgx_arch.h to asm/sgx.h, which will contain both archiitectural
   definitions and Linux defined sofware structures and functions, suggested by
   Boris.
 - Removed the comment saying "Data structures defined by Linux software stack
   should not be placed here", since it is not valid anymore. Added comments to
   explain asm/sgx.h is for both architectural and non-architectural
   definitions. Added a comment to split the two parts, suggested by Boris.
 - Added one more sentence in commit msg to explain asm/sgx.h is intended for
   single header file for sharing with other kernel componments.

v4->v5:

 - No code change.

v3->v4:

 - No code change.
 - Added Jarkko's Acked-by. Restored Dave's Acked-by.

v2->v3:

 - Added "Expose SGX architectural structures, as..." to commit message,
   per Jarkko.

---
 .../cpu/sgx/arch.h => include/asm/sgx.h}      | 20 ++++++++++++++-----
 arch/x86/kernel/cpu/sgx/encl.c                |  2 +-
 arch/x86/kernel/cpu/sgx/sgx.h                 |  2 +-
 tools/testing/selftests/sgx/defines.h         |  2 +-
 4 files changed, 18 insertions(+), 8 deletions(-)
 rename arch/x86/{kernel/cpu/sgx/arch.h => include/asm/sgx.h} (95%)

diff --git a/arch/x86/kernel/cpu/sgx/arch.h b/arch/x86/include/asm/sgx.h
similarity index 95%
rename from arch/x86/kernel/cpu/sgx/arch.h
rename to arch/x86/include/asm/sgx.h
index abf99bb71fdc..d4ad35f6319a 100644
--- a/arch/x86/kernel/cpu/sgx/arch.h
+++ b/arch/x86/include/asm/sgx.h
@@ -2,15 +2,20 @@
 /**
  * Copyright(c) 2016-20 Intel Corporation.
  *
- * Contains data structures defined by the SGX architecture.  Data structures
- * defined by the Linux software stack should not be placed here.
+ * Intel Software Guard Extensions (SGX) support.
  */
-#ifndef _ASM_X86_SGX_ARCH_H
-#define _ASM_X86_SGX_ARCH_H
+#ifndef _ASM_X86_SGX_H
+#define _ASM_X86_SGX_H
 
 #include <linux/bits.h>
 #include <linux/types.h>
 
+/*
+ * This file contains both data structures defined by SGX architecture and Linux
+ * defined software data structures and functions.  The two should not be mixed
+ * together for better readibility.  The architectural definitions come first.
+ */
+
 /* The SGX specific CPUID function. */
 #define SGX_CPUID		0x12
 /* EPC enumeration. */
@@ -337,4 +342,9 @@ struct sgx_sigstruct {
 
 #define SGX_LAUNCH_TOKEN_SIZE 304
 
-#endif /* _ASM_X86_SGX_ARCH_H */
+/*
+ * Do not put any hardware-defined SGX structure representations below this
+ * line!
+ */
+
+#endif /* _ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 7a09a98fe68d..e023c7a2d062 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -7,7 +7,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/suspend.h>
 #include <linux/sched/mm.h>
-#include "arch.h"
+#include <asm/sgx.h>
 #include "encl.h"
 #include "encls.h"
 #include "sgx.h"
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 1bff93be7bf4..5d71c9c8644d 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -8,7 +8,7 @@
 #include <linux/rwsem.h>
 #include <linux/types.h>
 #include <asm/asm.h>
-#include "arch.h"
+#include <asm/sgx.h>
 
 #undef pr_fmt
 #define pr_fmt(fmt) "sgx: " fmt
diff --git a/tools/testing/selftests/sgx/defines.h b/tools/testing/selftests/sgx/defines.h
index 592c1ccf4576..0bd73428d2f3 100644
--- a/tools/testing/selftests/sgx/defines.h
+++ b/tools/testing/selftests/sgx/defines.h
@@ -14,7 +14,7 @@
 #define __aligned(x) __attribute__((__aligned__(x)))
 #define __packed __attribute__((packed))
 
-#include "../../../../arch/x86/kernel/cpu/sgx/arch.h"
+#include "../../../../arch/x86/include/asm/sgx.h"
 #include "../../../../arch/x86/include/asm/enclu.h"
 #include "../../../../arch/x86/include/uapi/asm/sgx.h"
 
-- 
2.29.2

