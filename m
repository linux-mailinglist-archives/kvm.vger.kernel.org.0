Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843332EB7E5
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 02:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbhAFB5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 20:57:13 -0500
Received: from mga03.intel.com ([134.134.136.65]:2804 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726606AbhAFB5N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 20:57:13 -0500
IronPort-SDR: WHNR3HxDTvLZ9MPCPdutX9QH7sFjPezrSg3wTzyYru4bq3fx4T3wpssRohhDbvByTPpE8dI3mE
 bEcXJYgMhGUg==
X-IronPort-AV: E=McAfee;i="6000,8403,9855"; a="177313511"
X-IronPort-AV: E=Sophos;i="5.78,478,1599548400"; 
   d="scan'208";a="177313511"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 17:56:32 -0800
IronPort-SDR: qoEs9epuRS1IU6oWValiN8euDiURLsrI6BLkJNrO4by4i+Zb66gchFSy5r5Yg/mRhbY0yM7QEw
 xrPIwdeqUyiw==
X-IronPort-AV: E=Sophos;i="5.78,478,1599548400"; 
   d="scan'208";a="421993325"
Received: from zhuoxuan-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.29.237])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 17:56:29 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH 09/23] x86/sgx: Add encls_faulted() helper
Date:   Wed,  6 Jan 2021 14:56:18 +1300
Message-Id: <77a558023c2de2656f94004839a0284fd0d41428.1609890536.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1609890536.git.kai.huang@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
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
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kernel/cpu/sgx/encls.h | 14 +++++++++++++-
 arch/x86/kernel/cpu/sgx/ioctl.c |  2 +-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
index be5c49689980..55919a2b01b0 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -40,6 +40,18 @@
 	} while (0);							  \
 }
 
+/*
+ * encls_faulted() - Check if an ENCLS leaf faulted given an error code
+ * @ret		the return value of an ENCLS leaf function call
+ *
+ * Return:
+ *	%true if @ret indicates a fault, %false otherwise
+ */
+static inline bool encls_faulted(int ret)
+{
+	return ret & ENCLS_FAULT_FLAG;
+}
+
 /**
  * encls_failed() - Check if an ENCLS function failed
  * @ret:	the return value of an ENCLS function call
@@ -50,7 +62,7 @@
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

