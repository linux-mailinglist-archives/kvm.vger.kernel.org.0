Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E142D776FE
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 07:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbfG0FxS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 01:53:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:40958 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728307AbfG0FwU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 01:52:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 22:52:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,313,1559545200"; 
   d="scan'208";a="254568617"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 26 Jul 2019 22:52:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC PATCH 13/21] x86/sgx: Move the intermediate EINIT helper into the driver
Date:   Fri, 26 Jul 2019 22:52:06 -0700
Message-Id: <20190727055214.9282-14-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190727055214.9282-1-sean.j.christopherson@intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Providing sgx_einit() in the common SGX code was a bit premature.  The
thought was that the native SGX driver and KVM would be able to use a
common EINIT helper, but that may or may not hold true depending on
how KVM's implementation shakes out.  For example, KVM may want to pass
user pointers directly to EINIT in order to avoid copying large amounts
of data to in-kernel temp structures.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 21 +++++++++++--
 arch/x86/kernel/cpu/sgx/main.c         | 43 ++++++--------------------
 arch/x86/kernel/cpu/sgx/sgx.h          |  4 +--
 3 files changed, 30 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index b7aa06920d10..a1cb5f772363 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -658,6 +658,23 @@ static int sgx_get_key_hash(const void *modulus, void *hash)
 	return ret;
 }
 
+static int __sgx_einit(struct sgx_sigstruct *sigstruct,
+		       struct sgx_einittoken *token, struct sgx_epc_page *secs,
+		       u64 *lepubkeyhash)
+{
+	int ret;
+
+	preempt_disable();
+	sgx_update_lepubkeyhash_msrs(lepubkeyhash, false);
+	ret = __einit(sigstruct, token, sgx_epc_addr(secs));
+	if (ret == SGX_INVALID_EINITTOKEN) {
+		sgx_update_lepubkeyhash_msrs(lepubkeyhash, true);
+		ret = __einit(sigstruct, token, sgx_epc_addr(secs));
+	}
+	preempt_enable();
+	return ret;
+}
+
 static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 			 struct sgx_einittoken *token)
 {
@@ -686,8 +703,8 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 
 	for (i = 0; i < SGX_EINIT_SLEEP_COUNT; i++) {
 		for (j = 0; j < SGX_EINIT_SPIN_COUNT; j++) {
-			ret = sgx_einit(sigstruct, token, encl->secs.epc_page,
-					mrsigner);
+			ret = __sgx_einit(sigstruct, token,
+					  encl->secs.epc_page, mrsigner);
 			if (ret == SGX_UNMASKED_EVENT)
 				continue;
 			else
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 532dd90e09e1..542427c6ae9c 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -166,7 +166,15 @@ void sgx_free_page(struct sgx_epc_page *page)
 	WARN(ret > 0, "sgx: EREMOVE returned %d (0x%x)", ret, ret);
 }
 
-static void sgx_update_lepubkeyhash_msrs(u64 *lepubkeyhash, bool enforce)
+/**
+ * sgx_update_lepubkeyhash_msrs - Write the IA32_SGXLEPUBKEYHASHx MSRs
+ * @lepubkeyhash:	array of desired MSRs values
+ * @enforce:		force WRMSR regardless of cache status
+ *
+ * Write the IA32_SGXLEPUBKEYHASHx MSRs according to @lepubkeyhash if the
+ * last cached value doesn't match the desired value, or if @enforce is %true.
+ */
+void sgx_update_lepubkeyhash_msrs(u64 *lepubkeyhash, bool enforce)
 {
 	u64 *cache;
 	int i;
@@ -180,39 +188,6 @@ static void sgx_update_lepubkeyhash_msrs(u64 *lepubkeyhash, bool enforce)
 	}
 }
 
-/**
- * sgx_einit - initialize an enclave
- * @sigstruct:		a pointer a SIGSTRUCT
- * @token:		a pointer an EINITTOKEN (optional)
- * @secs:		a pointer a SECS
- * @lepubkeyhash:	the desired value for IA32_SGXLEPUBKEYHASHx MSRs
- *
- * Execute ENCLS[EINIT], writing the IA32_SGXLEPUBKEYHASHx MSRs according
- * to @lepubkeyhash (if possible and necessary).
- *
- * Return:
- *   0 on success,
- *   -errno or SGX error on failure
- */
-int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
-	      struct sgx_epc_page *secs, u64 *lepubkeyhash)
-{
-	int ret;
-
-	if (!boot_cpu_has(X86_FEATURE_SGX_LC))
-		return __einit(sigstruct, token, sgx_epc_addr(secs));
-
-	preempt_disable();
-	sgx_update_lepubkeyhash_msrs(lepubkeyhash, false);
-	ret = __einit(sigstruct, token, sgx_epc_addr(secs));
-	if (ret == SGX_INVALID_EINITTOKEN) {
-		sgx_update_lepubkeyhash_msrs(lepubkeyhash, true);
-		ret = __einit(sigstruct, token, sgx_epc_addr(secs));
-	}
-	preempt_enable();
-	return ret;
-}
-
 static __init void sgx_free_epc_section(struct sgx_epc_section *section)
 {
 	struct sgx_epc_page *page;
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 748b1633d770..3f3311024bd0 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -85,8 +85,8 @@ void sgx_reclaim_pages(void);
 struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim);
 int __sgx_free_page(struct sgx_epc_page *page);
 void sgx_free_page(struct sgx_epc_page *page);
-int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
-	      struct sgx_epc_page *secs, u64 *lepubkeyhash);
+
+void sgx_update_lepubkeyhash_msrs(u64 *lepubkeyhash, bool enforce);
 
 #define SGX_ENCL_DEV_MINOR	0
 #define SGX_PROV_DEV_MINOR	1
-- 
2.22.0

