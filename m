Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2FF931ABC4
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 14:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhBMNat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Feb 2021 08:30:49 -0500
Received: from mga12.intel.com ([192.55.52.136]:59259 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229662AbhBMNaa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Feb 2021 08:30:30 -0500
IronPort-SDR: eIDCoW9CAxmNY2DO/vTGbgMZncS3quTeoxGLxgF6ySfOsQmdOsuiuzncNzLAEy3Avp4TvZUXXp
 Fq2JENoBJaIQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="161667700"
X-IronPort-AV: E=Sophos;i="5.81,176,1610438400"; 
   d="scan'208";a="161667700"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2021 05:29:46 -0800
IronPort-SDR: N5HUOJQzJgrbskEMiM/HNp5mT/eJcRLBsFF0jslH1wMLqBVtp1n5avBA+aTYzUf68QytScW+30
 yVyD5LE0cZ2Q==
X-IronPort-AV: E=Sophos;i="5.81,176,1610438400"; 
   d="scan'208";a="398366044"
Received: from kshah-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.239])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2021 05:29:43 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v5 12/26] x86/sgx: Add helper to update SGX_LEPUBKEYHASHn MSRs
Date:   Sun, 14 Feb 2021 02:29:14 +1300
Message-Id: <7d2365223d92d489356926fa36dc06fd0e1c1ab8.1613221549.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1613221549.git.kai.huang@intel.com>
References: <cover.1613221549.git.kai.huang@intel.com>
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
v4->v5:

 - No code change.

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

