Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF2532628D
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 13:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhBZMRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 07:17:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:44781 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230206AbhBZMQa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 07:16:30 -0500
IronPort-SDR: QaGJ7mdzwDNoGHYFBVjRiWjSdr0qJKp2Bt6NeqquOwmhvYhlGxmrxhu4Lu/J9jGB42oiheZDai
 gmMHZm/GHWpA==
X-IronPort-AV: E=McAfee;i="6000,8403,9906"; a="185979984"
X-IronPort-AV: E=Sophos;i="5.81,208,1610438400"; 
   d="scan'208";a="185979984"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 04:15:44 -0800
IronPort-SDR: FDOPITsE9EeS6enEtHePgCUaQQAitvFgIjWdSZ5/SKT/zw3xN6DxhbfqMowMKXeJGGhPYfMiai
 yk4fakIB2wxw==
X-IronPort-AV: E=Sophos;i="5.81,208,1610438400"; 
   d="scan'208";a="598420591"
Received: from ciparjol-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.175])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 04:15:40 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v6 12/25] x86/sgx: Add helper to update SGX_LEPUBKEYHASHn MSRs
Date:   Sat, 27 Feb 2021 01:15:11 +1300
Message-Id: <a689835aa2e3ac9f796e224efca66daec2174f50.1614338774.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1614338774.git.kai.huang@intel.com>
References: <cover.1614338774.git.kai.huang@intel.com>
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
 arch/x86/kernel/cpu/sgx/ioctl.c |  5 ++---
 arch/x86/kernel/cpu/sgx/main.c  | 15 +++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h   |  2 ++
 3 files changed, 19 insertions(+), 3 deletions(-)

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
index 8c922e68274d..276220d0e4b5 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -696,6 +696,21 @@ static bool __init sgx_page_cache_init(void)
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

