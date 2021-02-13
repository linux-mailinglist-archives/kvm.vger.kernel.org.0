Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8593631ABC5
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 14:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhBMNbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Feb 2021 08:31:07 -0500
Received: from mga12.intel.com ([192.55.52.136]:59260 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229813AbhBMNan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Feb 2021 08:30:43 -0500
IronPort-SDR: xyHO3Rjpw0imW8ucML9dF57/hFBx8iVJC84H3DFgoGA2e7ffAhE5pkYNkYfUI6qHn4FE2+Kp7C
 MlKzbb/O0vhw==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="161667696"
X-IronPort-AV: E=Sophos;i="5.81,176,1610438400"; 
   d="scan'208";a="161667696"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2021 05:29:44 -0800
IronPort-SDR: mzApb0DL7nW+fViR/tOIGDtOcGjDwsLY77Gm4tTMARi+7YxneQJ7OAki0Ao5kpvuQn/iroTvWR
 xxFNgXQtbyfA==
X-IronPort-AV: E=Sophos;i="5.81,176,1610438400"; 
   d="scan'208";a="398366039"
Received: from kshah-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.239])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2021 05:29:39 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v5 11/26] x86/sgx: Add encls_faulted() helper
Date:   Sun, 14 Feb 2021 02:29:13 +1300
Message-Id: <db784b06bbc20ab4307005d6c5db7765effc788f.1613221549.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1613221549.git.kai.huang@intel.com>
References: <cover.1613221549.git.kai.huang@intel.com>
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
v4->v5:

 - No code change.

v3->v4:

 - No code change. Added Jarkko's Acked-by.

v2->v3:

 - Changed commenting style for return value, per Jarkko.

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

