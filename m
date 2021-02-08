Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD958313038
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 12:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbhBHLKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 06:10:44 -0500
Received: from mga17.intel.com ([192.55.52.151]:51021 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232623AbhBHK7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 05:59:17 -0500
IronPort-SDR: g34+VM4h2p+vGcwD6AyURrBvdsXx7P06Dz8yPNZSvUqEmp4s9iuljSKVfx8Ic/vp5RNOLLD85+
 jWhdZQVStPmA==
X-IronPort-AV: E=McAfee;i="6000,8403,9888"; a="161443943"
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="161443943"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 02:55:27 -0800
IronPort-SDR: JY08++9qG1TIAIVr6f8WAHDx9K7KnRL9KGlZH70sxCNZcj6ePcm+E8rNwzo+ClQKFvnHh9IG4Y
 mzXluJsakigg==
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="374451131"
Received: from jaeminha-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.11.62])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 02:55:24 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v4 12/26] x86/sgx: Add helper to update SGX_LEPUBKEYHASHn MSRs
Date:   Mon,  8 Feb 2021 23:54:55 +1300
Message-Id: <ae9a4ed0c0f259518979095fa42bedc0aa17d7f3.1612777752.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1612777752.git.kai.huang@intel.com>
References: <cover.1612777752.git.kai.huang@intel.com>
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
v3->v4:
 - Patch rebase due to sgx/virt.h was removed per Dave, and sgx_vepc_init()
   declaration was moved to sgx/sgx.h.
 - Added Jarkko's Ack-by. Restored Dave's Acked-by.

v2->v3:

 - Added comment for sgx_update_lepubkeyhash(), per Jarkko and Dave.

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
index 60a7a630212e..dadd7acac4ad 100644
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
index 161d2d8ac3b6..371fdf3b16a8 100644
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

