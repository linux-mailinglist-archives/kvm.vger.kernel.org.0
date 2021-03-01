Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64211327B21
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 10:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbhCAJtZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 04:49:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:63203 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234150AbhCAJqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 04:46:51 -0500
IronPort-SDR: WGCVm/3qKVvWh5sKwO3KlI46jlxE49fKv0DpC7uuPcE9md1ZPelPIhRxtjmDPWGqn3RMSPg9Ox
 rluMAfnd1Ing==
X-IronPort-AV: E=McAfee;i="6000,8403,9909"; a="183012443"
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="183012443"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 01:45:54 -0800
IronPort-SDR: LGtV3xzOSxv3ixZbo0pyArMGSWr0zogQKtixXNfkhy08jt5af51/x47BkmZeTHa4CVfb8CoNwj
 3meD7VCm8G7w==
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="599267534"
Received: from jscomeax-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.139.76])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 01:45:48 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH 13/25] x86/sgx: Add helpers to expose ECREATE and EINIT to KVM
Date:   Mon,  1 Mar 2021 22:45:13 +1300
Message-Id: <3c9a46ad0707ca658073a566232811347aaf4bdf.1614590788.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1614590788.git.kai.huang@intel.com>
References: <cover.1614590788.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

The host kernel must intercept ECREATE to be able to impose policies on
guests.  When it does this, the host kernel runs ECREATE against the
userspace mapping of the virtualized EPC.

Provide wrappers around __ecreate() and __einit() to hide the ugliness
of overloading the ENCLS return value to encode multiple error formats
in a single int.  KVM will trap-and-execute ECREATE and EINIT as part
of SGX virtualization, and on an exception, KVM needs the trapnr so that
it can inject the correct fault into the guest.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/include/asm/sgx.h     |  7 +++
 arch/x86/kernel/cpu/sgx/virt.c | 95 ++++++++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+)

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
index d206d81280cf..2ffa4ecb92c7 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -258,3 +258,98 @@ int __init sgx_vepc_init(void)
 
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
+	 * @secs is userspace address, and it's not guaranteed @secs points at
+	 * an actual EPC page. It's also possible to generate a kernel mapping
+	 * to physical EPC page by resolving PFN but using __uaccess_xx() is
+	 * simpler.
+	 */
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

