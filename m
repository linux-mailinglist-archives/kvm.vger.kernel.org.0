Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5266A331C72
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 02:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhCIBkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 20:40:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:62322 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231414AbhCIBkW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 20:40:22 -0500
IronPort-SDR: LQhOfIFDqz2RWyAfosTt8yjkcoMD8eL4srzQ2pzehBxH5Vz5Btavu98Mg4MdrxJPcqcNumJ/Dm
 lYfTlQWh+ynw==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="184774697"
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="184774697"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 17:40:21 -0800
IronPort-SDR: fd2Quy4cJWijciFaZPAAQHRTdwFhEN4kkwlyNdCBvZNxK3wl8VOHmGLTAYmM6xVD5lci3yrDjq
 zmZdFWsV+TQQ==
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="447327510"
Received: from kzliu-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.128.38])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 17:40:17 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 12/25] x86/sgx: Add helper to update SGX_LEPUBKEYHASHn MSRs
Date:   Tue,  9 Mar 2021 14:39:45 +1300
Message-Id: <ca4845f1b4d8a84b50a02a5522cd1f742dff8d4b.1615250634.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1615250634.git.kai.huang@intel.com>
References: <cover.1615250634.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper to update SGX_LEPUBKEYHASHn MSRs.  SGX virtualization also
needs to update those MSRs based on guest's "virtual" SGX_LEPUBKEYHASHn
before EINIT from guest.

Acked-by: Dave Hansen <dave.hansen@intel.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
v1->v2:

 - Added WARN_ON_ONCE(preemptible()) check, per Sean.

---
 arch/x86/kernel/cpu/sgx/ioctl.c |  5 ++---
 arch/x86/kernel/cpu/sgx/main.c  | 17 +++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h   |  2 ++
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index e5977752c7be..1bae754268d1 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -495,7 +495,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 			 void *token)
 {
 	u64 mrsigner[4];
-	int i, j, k;
+	int i, j;
 	void *addr;
 	int ret;
 
@@ -544,8 +544,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 
 			preempt_disable();
 
-			for (k = 0; k < 4; k++)
-				wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + k, mrsigner[k]);
+			sgx_update_lepubkeyhash(mrsigner);
 
 			ret = __einit(sigstruct, token, addr);
 
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8c922e68274d..3f632efbb503 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -696,6 +696,23 @@ static bool __init sgx_page_cache_init(void)
 	return true;
 }
 
+
+/*
+ * Update the SGX_LEPUBKEYHASH MSRs to the values specified by caller.
+ * Bare-metal driver requires to update them to hash of enclave's signer
+ * before EINIT. KVM needs to update them to guest's virtual MSR values
+ * before doing EINIT from guest.
+ */
+void sgx_update_lepubkeyhash(u64 *lepubkeyhash)
+{
+	int i;
+
+	WARN_ON_ONCE(preemptible());
+
+	for (i = 0; i < 4; i++)
+		wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + i, lepubkeyhash[i]);
+}
+
 static int __init sgx_init(void)
 {
 	int ret;
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 5d71c9c8644d..d4b19e5cca16 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -92,4 +92,6 @@ static inline int __init sgx_vepc_init(void)
 }
 #endif
 
+void sgx_update_lepubkeyhash(u64 *lepubkeyhash);
+
 #endif /* _X86_SGX_H */
-- 
2.29.2

