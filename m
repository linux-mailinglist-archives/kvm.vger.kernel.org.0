Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0864187F92
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437054AbfHIQUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:20:01 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53330 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407428AbfHIQUA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:20:00 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 1DE1F305D3F4;
        Fri,  9 Aug 2019 19:01:04 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 3B6D5303EF08;
        Fri,  9 Aug 2019 19:01:03 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v6 30/92] kvm: x86: add kvm_spt_fault()
Date:   Fri,  9 Aug 2019 18:59:45 +0300
Message-Id: <20190809160047.8319-31-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This is needed to filter #PF introspection events, when not caused by
EPT/NPT fault. One such case is when handle_ud() calls the emulator
which failes to fetch the opcodes from stack (which is hooked rw-)
which leads to a page fault event.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/svm.c              | 8 ++++++++
 arch/x86/kvm/vmx/vmx.c          | 8 ++++++++
 arch/x86/kvm/x86.c              | 6 ++++++
 4 files changed, 24 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7da1137a2b82..f1b3d89a0430 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1005,6 +1005,7 @@ struct kvm_x86_ops {
 	void (*cpuid_update)(struct kvm_vcpu *vcpu);
 
 	bool (*nested_pagefault)(struct kvm_vcpu *vcpu);
+	bool (*spt_fault)(struct kvm_vcpu *vcpu);
 
 	struct kvm *(*vm_alloc)(void);
 	void (*vm_free)(struct kvm *);
@@ -1596,5 +1597,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 	*(type *)((buf) + (offset) - 0x7e00) = val
 
 bool kvm_mmu_nested_pagefault(struct kvm_vcpu *vcpu);
+bool kvm_spt_fault(struct kvm_vcpu *vcpu);
 
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3c099c56099c..6b533698c73d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7103,6 +7103,13 @@ static bool svm_nested_pagefault(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+static bool svm_spt_fault(struct kvm_vcpu *vcpu)
+{
+	const struct vcpu_svm *svm = to_svm(vcpu);
+
+	return (svm->vmcb->control.exit_code == SVM_EXIT_NPF);
+}
+
 static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -7115,6 +7122,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.has_emulated_msr = svm_has_emulated_msr,
 
 	.nested_pagefault = svm_nested_pagefault,
+	.spt_fault = svm_spt_fault,
 
 	.vcpu_create = svm_create_vcpu,
 	.vcpu_free = svm_free_vcpu,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e10ee8fd1c67..97cfd5a316f3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7689,6 +7689,13 @@ static bool vmx_nested_pagefault(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static bool vmx_spt_fault(struct kvm_vcpu *vcpu)
+{
+	const struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	return (vmx->exit_reason == EXIT_REASON_EPT_VIOLATION);
+}
+
 static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -7701,6 +7708,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.has_emulated_msr = vmx_has_emulated_msr,
 
 	.nested_pagefault = vmx_nested_pagefault,
+	.spt_fault = vmx_spt_fault,
 
 	.vm_init = vmx_vm_init,
 	.vm_alloc = vmx_vm_alloc,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c28e2a20dec2..257c4a262acd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9884,6 +9884,12 @@ bool kvm_vector_hashing_enabled(void)
 }
 EXPORT_SYMBOL_GPL(kvm_vector_hashing_enabled);
 
+bool kvm_spt_fault(struct kvm_vcpu *vcpu)
+{
+	return kvm_x86_ops->spt_fault(vcpu);
+}
+EXPORT_SYMBOL(kvm_spt_fault);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
