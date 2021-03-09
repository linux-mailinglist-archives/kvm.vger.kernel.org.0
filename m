Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7CC331C6C
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 02:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhCIBkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 20:40:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:62303 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231207AbhCIBkH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 20:40:07 -0500
IronPort-SDR: fuAWDNV61VqF0wu1zxbJsDUGRAOLBKMBTZ24yiiBCo1Muzb4cCj3mBmLKCFWm3qlfLrzVPHJFW
 K7fUkTrBehvA==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="184774637"
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="184774637"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 17:40:06 -0800
IronPort-SDR: an0g8MBNw32SWB2fBtmMT9ggtx1tpvNjZbDSyyhPbqRdToTsXc6tjP07p1HSbvcAIzvZgDbRwW
 3RmfWD81+Wxw==
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="447327354"
Received: from kzliu-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.128.38])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 17:40:00 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 08/25] x86/sgx: Expose SGX architectural definitions to the kernel
Date:   Tue,  9 Mar 2021 14:39:41 +1300
Message-Id: <b60e1d665c17ed6430166d659bd0f547a53aea0f.1615250634.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1615250634.git.kai.huang@intel.com>
References: <cover.1615250634.git.kai.huang@intel.com>
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
Acked-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
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
index dcbcf840c522..130f6520438f 100644
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

