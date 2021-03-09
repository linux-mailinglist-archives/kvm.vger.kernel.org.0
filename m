Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E28D331C73
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 02:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhCIBkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 20:40:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:62322 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231394AbhCIBkV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 20:40:21 -0500
IronPort-SDR: jhGwryXRjk2qio0vmsfTI5dmVFCcMSwHIZlmBs0b9FsveqYSjez+knYI2nXYDzAyPcq+tqZWdd
 2Rn9JKCkXoEw==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="184774693"
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="184774693"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 17:40:18 -0800
IronPort-SDR: qvjXjW2QuXjLyHsIHSQ1PMKXpl/ZnhMP1vi9YLAyeScxq2mOvt8DU3yjWLWKiKnWJ16uFr/9gB
 YeMHXYYLh6ZA==
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="447327497"
Received: from kzliu-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.128.38])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 17:40:13 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 11/25] x86/sgx: Add encls_faulted() helper
Date:   Tue,  9 Mar 2021 14:39:44 +1300
Message-Id: <52d02dc1724a2199577546bb81f7ed84c0b6346b.1615250634.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1615250634.git.kai.huang@intel.com>
References: <cover.1615250634.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a helper to extract the fault indicator from an encoded ENCLS return
value.  SGX virtualization will also need to detect ENCLS faults.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kernel/cpu/sgx/encls.h | 15 ++++++++++++++-
 arch/x86/kernel/cpu/sgx/ioctl.c |  2 +-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
index be5c49689980..3219d011ee28 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -40,6 +40,19 @@
 	} while (0);							  \
 }
 
+/*
+ * encls_faulted() - Check if an ENCLS leaf faulted given an error code
+ * @ret 	the return value of an ENCLS leaf function call
+ *
+ * Return:
+ * - true:	ENCLS leaf faulted.
+ * - false:	Otherwise.
+ */
+static inline bool encls_faulted(int ret)
+{
+	return ret & ENCLS_FAULT_FLAG;
+}
+
 /**
  * encls_failed() - Check if an ENCLS function failed
  * @ret:	the return value of an ENCLS function call
@@ -50,7 +63,7 @@
  */
 static inline bool encls_failed(int ret)
 {
-	if (ret & ENCLS_FAULT_FLAG)
+	if (encls_faulted(ret))
 		return ENCLS_TRAPNR(ret) != X86_TRAP_PF;
 
 	return !!ret;
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 90a5caf76939..e5977752c7be 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -568,7 +568,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 		}
 	}
 
-	if (ret & ENCLS_FAULT_FLAG) {
+	if (encls_faulted(ret)) {
 		if (encls_failed(ret))
 			ENCLS_WARN(ret, "EINIT");
 
-- 
2.29.2

