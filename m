Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B89287F8E
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407426AbfHIQTz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:19:55 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53304 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407417AbfHIQTz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:19:55 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 517C2305D3DF;
        Fri,  9 Aug 2019 19:01:01 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id DF0E8305B7A4;
        Fri,  9 Aug 2019 19:01:00 +0300 (EEST)
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
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>
Subject: [RFC PATCH v6 26/92] kvm: x86: add kvm_mmu_nested_pagefault()
Date:   Fri,  9 Aug 2019 18:59:41 +0300
Message-Id: <20190809160047.8319-27-alazar@bitdefender.com>
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

This is needed to filter #PF introspection events.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++++
 arch/x86/kvm/mmu.c              | 5 +++++
 arch/x86/kvm/svm.c              | 7 +++++++
 arch/x86/kvm/vmx/vmx.c          | 9 +++++++++
 4 files changed, 25 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2d6bde6fa59f..7da1137a2b82 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1004,6 +1004,8 @@ struct kvm_x86_ops {
 	bool (*has_emulated_msr)(int index);
 	void (*cpuid_update)(struct kvm_vcpu *vcpu);
 
+	bool (*nested_pagefault)(struct kvm_vcpu *vcpu);
+
 	struct kvm *(*vm_alloc)(void);
 	void (*vm_free)(struct kvm *);
 	int (*vm_init)(struct kvm *kvm);
@@ -1593,4 +1595,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 #define put_smstate(type, buf, offset, val)                      \
 	*(type *)((buf) + (offset) - 0x7e00) = val
 
+bool kvm_mmu_nested_pagefault(struct kvm_vcpu *vcpu);
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ff053f17b8c2..9eaf6cc776a9 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -6169,3 +6169,8 @@ void kvm_mmu_module_exit(void)
 	unregister_shrinker(&mmu_shrinker);
 	mmu_audit_disable();
 }
+
+bool kvm_mmu_nested_pagefault(struct kvm_vcpu *vcpu)
+{
+	return kvm_x86_ops->nested_pagefault(vcpu);
+}
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f13a3a24d360..3c099c56099c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7098,6 +7098,11 @@ static int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 	return -ENODEV;
 }
 
+static bool svm_nested_pagefault(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -7109,6 +7114,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
 	.has_emulated_msr = svm_has_emulated_msr,
 
+	.nested_pagefault = svm_nested_pagefault,
+
 	.vcpu_create = svm_create_vcpu,
 	.vcpu_free = svm_free_vcpu,
 	.vcpu_reset = svm_vcpu_reset,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 30a6bcd735ec..e10ee8fd1c67 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7682,6 +7682,13 @@ static __exit void hardware_unsetup(void)
 	free_kvm_area();
 }
 
+static bool vmx_nested_pagefault(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.exit_qualification & EPT_VIOLATION_GVA_TRANSLATED)
+		return false;
+	return true;
+}
+
 static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -7693,6 +7700,8 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.cpu_has_accelerated_tpr = report_flexpriority,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
+	.nested_pagefault = vmx_nested_pagefault,
+
 	.vm_init = vmx_vm_init,
 	.vm_alloc = vmx_vm_alloc,
 	.vm_free = vmx_vm_free,
