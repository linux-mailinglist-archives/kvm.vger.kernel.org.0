Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5F031300E
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 12:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbhBHLFa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 06:05:30 -0500
Received: from mga17.intel.com ([192.55.52.151]:51142 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232838AbhBHK6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 05:58:22 -0500
IronPort-SDR: KuwfAocQ7LtLg2HV+sBXauSUP0J34gqxlIOWwCYs28U6pqlQzEyJfBpTx7YPAB8O3Y/z89BLQP
 yIVodEftRlcw==
X-IronPort-AV: E=McAfee;i="6000,8403,9888"; a="161443937"
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="161443937"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 02:55:24 -0800
IronPort-SDR: O+73kYbz8QVzP6qEFIdlQOkTohnMiuVC2Ra+ACyYqHnk895Iox1LO/JDy5/0Vfzd9eXZQa/MwE
 kr2+xOVNHpwA==
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="374451114"
Received: from jaeminha-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.11.62])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 02:55:21 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v4 11/26] x86/sgx: Add encls_faulted() helper
Date:   Mon,  8 Feb 2021 23:54:54 +1300
Message-Id: <a84a952017f728f52055e3d7295056cd3ec3ff9d.1612777752.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1612777752.git.kai.huang@intel.com>
References: <cover.1612777752.git.kai.huang@intel.com>
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

