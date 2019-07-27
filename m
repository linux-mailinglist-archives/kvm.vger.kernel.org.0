Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 016BC776E9
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 07:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbfG0FwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 01:52:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:40960 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728342AbfG0FwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 01:52:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 22:52:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,313,1559545200"; 
   d="scan'208";a="254568620"
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
Subject: [RFC PATCH 14/21] x86/sgx: Add helpers to expose ECREATE and EINIT to KVM
Date:   Fri, 26 Jul 2019 22:52:07 -0700
Message-Id: <20190727055214.9282-15-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190727055214.9282-1-sean.j.christopherson@intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide wrappers around __ecreate() and __einit() to export their
functionality for use by KVM without having to export a large amount of
SGX boilerplate code.  Intermediate helpers also shelter KVM from the
ugliness of overloading the ENCLS return value to encode multiple error
formats in a single int.

KVM will use the helpers to trap-and-execute ECREATE and EINIT as part
its SGX virtualization.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/Kconfig               |  3 ++
 arch/x86/include/asm/sgx.h     | 15 ++++++++++
 arch/x86/kernel/cpu/sgx/virt.c | 55 ++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+)
 create mode 100644 arch/x86/include/asm/sgx.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c1bdb9f85928..8bbc6a30588d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1969,6 +1969,9 @@ config INTEL_SGX_VIRTUALIZATION
 	  "raw" EPC for the purpose of exposing EPC to a KVM guest, i.e. a
 	  virtual machine, via a device node (/dev/sgx/virt_epc by default).
 
+	  SGX virtualization also adds helpers that are used by KVM to trap
+	  and execute certain ENCLS instructions on behalf of a KVM guest.
+
 	  If unsure, say N.
 
 config EFI
diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
new file mode 100644
index 000000000000..f0f0176b8e2f
--- /dev/null
+++ b/arch/x86/include/asm/sgx.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_SGX_H
+#define _ASM_X86_SGX_H
+
+#include <linux/types.h>
+
+struct sgx_pageinfo;
+
+#if IS_ENABLED(CONFIG_KVM_INTEL)
+int sgx_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs, int *trapnr);
+int sgx_einit(void __user *sigstruct, void __user *token,
+	      void __user *secs, u64 *lepubkeyhash, int *trapnr);
+#endif
+
+#endif /* _ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 79ee5917a4fc..9e5bf4450bf7 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -251,3 +251,58 @@ int __init sgx_virt_epc_init(void)
 
 	return ret;
 }
+
+#if IS_ENABLED(CONFIG_KVM_INTEL)
+int sgx_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs, int *trapnr)
+{
+	int ret;
+
+	__uaccess_begin();
+	ret = __ecreate(pageinfo, (void *)secs);
+	__uaccess_end();
+
+	if (encls_faulted(ret)) {
+		*trapnr = ENCLS_TRAPNR(ret);
+		return -EFAULT;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sgx_ecreate);
+
+static int __sgx_einit(void __user *sigstruct, void __user *token,
+		       void __user *secs)
+{
+	int ret;
+
+	__uaccess_begin();
+	ret =  __einit((void *)sigstruct, (void *)token, (void *)secs);
+	__uaccess_end();
+	return ret;
+}
+
+int sgx_einit(void __user *sigstruct, void __user *token,
+	      void __user *secs, u64 *lepubkeyhash, int *trapnr)
+{
+	int ret;
+
+	if (!boot_cpu_has(X86_FEATURE_SGX_LC)) {
+		ret = __sgx_einit(sigstruct, token, secs);
+	} else {
+		preempt_disable();
+		sgx_update_lepubkeyhash_msrs(lepubkeyhash, false);
+		ret = __sgx_einit(sigstruct, token, secs);
+		if (ret == SGX_INVALID_EINITTOKEN) {
+			sgx_update_lepubkeyhash_msrs(lepubkeyhash, true);
+			ret = __sgx_einit(sigstruct, token, secs);
+		}
+		preempt_enable();
+	}
+
+	if (encls_faulted(ret)) {
+		*trapnr = ENCLS_TRAPNR(ret);
+		return -EFAULT;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sgx_einit);
+#endif
-- 
2.22.0

