Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5F73FFA83
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 08:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344995AbhICGnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 02:43:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232218AbhICGnG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 02:43:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E66060F91;
        Fri,  3 Sep 2021 06:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630651327;
        bh=hKmqa7Vs9APJQ/9FaigC6kerO3ACZOY+NOsi/tv20Xg=;
        h=From:To:Cc:Subject:Date:From;
        b=IzC1DstgmX4ke/oK/LJ/XxA41KkndggA/GhJRSuAKhDNb48g+HODyGVl4rP26pnLe
         uC65ieYl+KiGMn1KhPlfCNE7CsJkRm+jMZAqgzP5/2cepbfCpd8i52yeiwjrKuF4vM
         QoXfF5DPQwqLsSMGi41sfLMXEeFaVUszmxIgNRY2ur4btARtcrAeDJ/DCUI3NurHyj
         qze6F/cbR1HbLoECKcETLdeXZ+OgNrKxiQ9Pj760h6TV3WrQHQkdfzj9ZL/okSokh3
         uPvzDYw4YH8W6b4qOWBfM70nBejDXRdg0MIkIMTqIagU+YW18+ebT1CBkUT4S6Y3Zz
         LUR4Qm93fGXZA==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Tony Luck <tony.luck@intel.com>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] x86/sgx: Declare sgx_set_attribute() for !CONFIG_X86_SGX
Date:   Fri,  3 Sep 2021 09:41:56 +0300
Message-Id: <20210903064156.387979-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Simplify sgx_set_attribute() usage by declaring a fallback
implementation for it rather than requiring to have compilation
flag checks in the call site. The fallback unconditionally returns
-EINVAL.

Refactor the call site in kvm_vm_ioctl_enable_cap() accordingly.
The net result is the same: KVM_CAP_SGX_ATTRIBUTE causes -EINVAL
when kernel is compiled without CONFIG_X86_SGX_KVM.

Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/include/asm/sgx.h | 8 ++++++++
 arch/x86/kvm/x86.c         | 2 --
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 05f3e21f01a7..31ee106c0f4b 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -372,7 +372,15 @@ int sgx_virt_einit(void __user *sigstruct, void __user *token,
 		   void __user *secs, u64 *lepubkeyhash, int *trapnr);
 #endif
 
+#ifdef CONFIG_X86_SGX
 int sgx_set_attribute(unsigned long *allowed_attributes,
 		      unsigned int attribute_fd);
+#else
+static inline int sgx_set_attribute(unsigned long *allowed_attributes,
+				    unsigned int attribute_fd)
+{
+	return -EINVAL;
+}
+#endif
 
 #endif /* _ASM_X86_SGX_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5d5c5ed7dd4..a6a27a8f41eb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5633,7 +5633,6 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			kvm->arch.bus_lock_detection_enabled = true;
 		r = 0;
 		break;
-#ifdef CONFIG_X86_SGX_KVM
 	case KVM_CAP_SGX_ATTRIBUTE: {
 		unsigned long allowed_attributes = 0;
 
@@ -5649,7 +5648,6 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			r = -EINVAL;
 		break;
 	}
-#endif
 	case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
 		r = -EINVAL;
 		if (kvm_x86_ops.vm_copy_enc_context_from)
-- 
2.25.1

