Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF3A34166A
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 08:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234271AbhCSHXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 03:23:34 -0400
Received: from mga05.intel.com ([192.55.52.43]:22827 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234181AbhCSHXY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 03:23:24 -0400
IronPort-SDR: d7BHbGvMEWQ78bZ6otGDpUHcMFznq6htIyDLJB8LxdT2pe9GgOWKReDNB77EDNWr7umdcBJR6N
 gPOuijQO0bXQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="274910875"
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="274910875"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 00:23:24 -0700
IronPort-SDR: cw5wWWdBF3l+b0yKEV24XsDOMbojRb76SomDVWlGpUXvlSskwGSSGL5lwfsdxZcS4ogAM9ktvJ
 1g7HEXK568og==
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="413409389"
Received: from dlmeisen-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.165])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 00:23:20 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v3 08/25] x86/sgx: Expose SGX architectural definitions to the kernel
Date:   Fri, 19 Mar 2021 20:23:03 +1300
Message-Id: <6bf47acd91ab4d709e66ad1692c7803e4c9063a0.1616136308.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1616136307.git.kai.huang@intel.com>
References: <cover.1616136307.git.kai.huang@intel.com>
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
componments. Also update MAINTAINERS to include asm/sgx.h.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
v1->v3:
 - Added MAINTAINERS file update to include new asm/sgx.h
 - Changed 'line' to 'comment' in the comment pointed out by Sean.

---
 MAINTAINERS                                   |  1 +
 .../cpu/sgx/arch.h => include/asm/sgx.h}      | 20 ++++++++++++++-----
 arch/x86/kernel/cpu/sgx/encl.c                |  2 +-
 arch/x86/kernel/cpu/sgx/sgx.h                 |  2 +-
 tools/testing/selftests/sgx/defines.h         |  2 +-
 5 files changed, 19 insertions(+), 8 deletions(-)
 rename arch/x86/{kernel/cpu/sgx/arch.h => include/asm/sgx.h} (95%)

diff --git a/MAINTAINERS b/MAINTAINERS
index aa84121c5611..0cb606aeba5e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9274,6 +9274,7 @@ Q:	https://patchwork.kernel.org/project/intel-sgx/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/sgx
 F:	Documentation/x86/sgx.rst
 F:	arch/x86/entry/vdso/vsgx.S
+F:	arch/x86/include/asm/sgx.h
 F:	arch/x86/include/uapi/asm/sgx.h
 F:	arch/x86/kernel/cpu/sgx/*
 F:	tools/testing/selftests/sgx/*
diff --git a/arch/x86/kernel/cpu/sgx/arch.h b/arch/x86/include/asm/sgx.h
similarity index 95%
rename from arch/x86/kernel/cpu/sgx/arch.h
rename to arch/x86/include/asm/sgx.h
index abf99bb71fdc..14bb5f7e221c 100644
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
+ * comment!
+ */
+
+#endif /* _ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index e0fb0f121616..f78cf880c332 100644
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
index a3aa00cb1ac4..5086b240d269 100644
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
2.30.2

