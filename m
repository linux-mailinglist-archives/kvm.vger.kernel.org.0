Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CECF9331C76
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 02:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhCIBkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 20:40:49 -0500
Received: from mga11.intel.com ([192.55.52.93]:62333 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231489AbhCIBk1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 20:40:27 -0500
IronPort-SDR: B4m0qHDk8Nd4ciau11KPg5LIxsxVvaQo3DDwPNPMYn00EFw//PyGfzcg4fPD7WzqMENBAign3P
 8CLOt412H/+A==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="184774701"
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="184774701"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 17:40:25 -0800
IronPort-SDR: mEO4n27R7bfyt7rhsl9j5PMJNi39Z0bXPloFj6ndbaC5qw6q9Ip/6/VzFX0G4LmmQi/33et9J1
 tPIfGLPsoADA==
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="447327544"
Received: from kzliu-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.128.38])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 17:40:21 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 13/25] x86/sgx: Add helpers to expose ECREATE and EINIT to KVM
Date:   Tue,  9 Mar 2021 14:39:46 +1300
Message-Id: <e1534e0a65c8c68d0843d037bcdb32f995d381e7.1615250634.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1615250634.git.kai.huang@intel.com>
References: <cover.1615250634.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

The host kernel must intercept ECREATE to impose policies on guests, and
intercept EINIT to be able to write guest's virtual SGX_LEPUBKEYHASH MSR
values to hardware before running guest's EINIT so it can run correctly
according to hardware behavior.

Provide wrappers around __ecreate() and __einit() to hide the ugliness
of overloading the ENCLS return value to encode multiple error formats
in a single int.  KVM will trap-and-execute ECREATE and EINIT as part
of SGX virtualization, and reflect ENCLS execution result to guest by
setting up guest's GPRs, or on an exception, injecting the correct fault
based on return value of __ecreate() and __einit().

Use host userspace addresses (provided by KVM based on guest physical
address of ENCLS parameters) to execute ENCLS/EINIT when possible.
Accesses to both EPC and memory originating from ENCLS are subject to
segmentation and paging mechanisms.  It's also possible to generate
kernel mappings for ENCLS parameters by resolving PFN but using
__uaccess_xx() is simpler.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
v1->v2:

 - Tried to address Dave's comments:
  - Refined comments around @secs in sgx_virt_ecreate().
  - Refined commit msg to explain why to use userspace address for ENCLS,
    instead of generating kernel mapping.
  - Added access_ok() on userspace addresses, and give WARN() if check fails.

---
 arch/x86/include/asm/sgx.h     |   7 +++
 arch/x86/kernel/cpu/sgx/virt.c | 110 +++++++++++++++++++++++++++++++++
 2 files changed, 117 insertions(+)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 0db1e47a90c5..d2e1f9a6dd4d 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -365,4 +365,11 @@ struct sgx_sigstruct {
  * line!
  */
 
+#ifdef CONFIG_X86_SGX_KVM
+int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
+		     int *trapnr);
+int sgx_virt_einit(void __user *sigstruct, void __user *token,
+		   void __user *secs, u64 *lepubkeyhash, int *trapnr);
+#endif
+
 #endif /* _ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 29d8d28b4695..ef0a8b39315d 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -258,3 +258,113 @@ int __init sgx_vepc_init(void)
 
 	return misc_register(&sgx_vepc_dev);
 }
+
+/**
+ * sgx_virt_ecreate() - Run ECREATE on behalf of guest
+ * @pageinfo:	Pointer to PAGEINFO structure
+ * @secs:	Userspace pointer to SECS page
+ * @trapnr:	trap number injected to guest in case of ECREATE error
+ *
+ * Run ECREATE on behalf of guest after KVM traps ECREATE for the purpose
+ * of enforcing policies of guest's enclaves, and return the trap number
+ * which should be injected to guest in case of any ECREATE error.
+ *
+ * Return:
+ * - 0: 	ECREATE was successful.
+ * - -EFAULT:	ECREATE returned error.
+ */
+int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
+		     int *trapnr)
+{
+	int ret;
+
+	/*
+	 * @secs is an untrusted, userspace-provided address.  It comes from
+	 * KVM and is assumed to be a valid pointer which points somewhere in
+	 * userspace.  This can fault and call SGX or other fault handlers when
+	 * userspace mapping @secs doesn't exist.
+	 *
+	 * Add a WARN() to make sure @secs is already valid userspace pointer
+	 * from caller (KVM), who should already have handled invalid pointer
+	 * case (for instance, made by malicious guest).  All other checks,
+	 * such as alignment of @secs, are deferred to ENCLS itself.
+	 */
+	WARN_ON_ONCE(!access_ok(PTR_ALIGN_DOWN(secs, PAGE_SIZE), PAGE_SIZE));
+	__uaccess_begin();
+	ret = __ecreate(pageinfo, (void *)secs);
+	__uaccess_end();
+
+	if (encls_faulted(ret)) {
+		*trapnr = ENCLS_TRAPNR(ret);
+		return -EFAULT;
+	}
+
+	/* ECREATE doesn't return an error code, it faults or succeeds. */
+	WARN_ON_ONCE(ret);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sgx_virt_ecreate);
+
+static int __sgx_virt_einit(void __user *sigstruct, void __user *token,
+			    void __user *secs)
+{
+	int ret;
+
+	/*
+	 * Make sure all userspace pointers from caller (KVM) are valid.
+	 * All other checks deferred to ENCLS itself.  Also see comment
+	 * for @secs in sgx_virt_ecreate().
+	 */
+	WARN_ON_ONCE(!access_ok(PTR_ALIGN_DOWN(sigstruct, PAGE_SIZE),
+				PAGE_SIZE) ||
+		     !access_ok(PTR_ALIGN_DOWN(token, PAGE_SIZE), PAGE_SIZE) ||
+		     !access_ok(PTR_ALIGN_DOWN(secs, PAGE_SIZE), PAGE_SIZE));
+	__uaccess_begin();
+	ret =  __einit((void *)sigstruct, (void *)token, (void *)secs);
+	__uaccess_end();
+
+	return ret;
+}
+
+/**
+ * sgx_virt_einit() - Run EINIT on behalf of guest
+ * @sigstruct:		Userspace pointer to SIGSTRUCT structure
+ * @token:		Userspace pointer to EINITTOKEN structure
+ * @secs:		Userspace pointer to SECS page
+ * @lepubkeyhash:	Pointer to guest's *virtual* SGX_LEPUBKEYHASH MSR
+ * 			values
+ * @trapnr:		trap number injected to guest in case of EINIT error
+ *
+ * Run EINIT on behalf of guest after KVM traps EINIT. If SGX_LC is available
+ * in host, SGX driver may rewrite the hardware values at wish, therefore KVM
+ * needs to update hardware values to guest's virtual MSR values in order to
+ * ensure EINIT is executed with expected hardware values.
+ *
+ * Return:
+ * - 0: 	EINIT was successful.
+ * - -EFAULT:	EINIT returned error.
+ */
+int sgx_virt_einit(void __user *sigstruct, void __user *token,
+		   void __user *secs, u64 *lepubkeyhash, int *trapnr)
+{
+	int ret;
+
+	if (!boot_cpu_has(X86_FEATURE_SGX_LC)) {
+		ret = __sgx_virt_einit(sigstruct, token, secs);
+	} else {
+		preempt_disable();
+
+		sgx_update_lepubkeyhash(lepubkeyhash);
+
+		ret = __sgx_virt_einit(sigstruct, token, secs);
+		preempt_enable();
+	}
+
+	if (encls_faulted(ret)) {
+		*trapnr = ENCLS_TRAPNR(ret);
+		return -EFAULT;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sgx_virt_einit);
-- 
2.29.2

