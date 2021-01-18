Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B459C2F9840
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 04:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731687AbhARD31 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Jan 2021 22:29:27 -0500
Received: from mga18.intel.com ([134.134.136.126]:60995 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731683AbhARD3V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Jan 2021 22:29:21 -0500
IronPort-SDR: EOybH/EI6pnY4WTOPB8tCyoRmzhgivZ4lPZo5zcYl67N2n/FNnFVwEKoXkVNobi3IrnXvfrI4f
 uryRpHWmzaAA==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="166420880"
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="166420880"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:28:31 -0800
IronPort-SDR: NQepSmyI5tr9Sp9MBh30H4/zJk5eegDk7ztEnKT925lzETntfSpRpsT/8TSKuDflxY1/xYurF9
 9Qpd2OxhPF4g==
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="573151030"
Received: from amrahman-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.142.253])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:28:28 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v2 13/26] x86/sgx: Add helpers to expose ECREATE and EINIT to KVM
Date:   Mon, 18 Jan 2021 16:28:06 +1300
Message-Id: <e9a350fac5b18ca69496d07fe25a7a2408d1a73a.1610935432.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610935432.git.kai.huang@intel.com>
References: <cover.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

The bare-metal kernel must intercept ECREATE to be able to impose policies
on guests.  When it does this, the bare-metal kernel runs ECREATE against
the userspace mapping of the virtualized EPC.

Provide wrappers around __ecreate() and __einit() to hide the ugliness
of overloading the ENCLS return value to encode multiple error formats
in a single int.  KVM will trap-and-execute ECREATE and EINIT as part
of SGX virtualization, and on an exception, KVM needs the trapnr so that
it can inject the correct fault into the guest.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
 [Kai: Use sgx_update_lepubkeyhash() to update pubkey hash MSRs.]
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
v1->v2:

 - Refined commit msg based on Dave's comment.
 - Added comment to explain why to use __uaccess_xxx().
---
 arch/x86/include/asm/sgx.h     | 16 +++++++++
 arch/x86/kernel/cpu/sgx/virt.c | 61 ++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)
 create mode 100644 arch/x86/include/asm/sgx.h

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
new file mode 100644
index 000000000000..0d643b985085
--- /dev/null
+++ b/arch/x86/include/asm/sgx.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_SGX_H
+#define _ASM_X86_SGX_H
+
+#include <linux/types.h>
+
+#ifdef CONFIG_X86_SGX_VIRTUALIZATION
+struct sgx_pageinfo;
+
+int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
+		     int *trapnr);
+int sgx_virt_einit(void __user *sigstruct, void __user *token,
+		   void __user *secs, u64 *lepubkeyhash, int *trapnr);
+#endif
+
+#endif /* _ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 1e8620f20651..97f02e5235ca 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -253,3 +253,64 @@ int __init sgx_virt_epc_init(void)
 
 	return misc_register(&sgx_virt_epc_dev);
 }
+
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
+	return ret;
+}
+
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
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sgx_virt_einit);
-- 
2.29.2

