Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F38614D45C
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 01:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgA3AK2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 19:10:28 -0500
Received: from mga06.intel.com ([134.134.136.31]:48389 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726671AbgA3AK1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 19:10:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 16:10:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,379,1574150400"; 
   d="scan'208";a="261990351"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 29 Jan 2020 16:10:25 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] KVM: x86: Move init-only kvm_x86_ops to separate struct
Date:   Wed, 29 Jan 2020 16:10:20 -0800
Message-Id: <20200130001023.24339-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200130001023.24339-1-sean.j.christopherson@intel.com>
References: <20200130001023.24339-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the kvm_x86_ops functions that are used only within the scope of
kvm_init() into a separate struct, kvm_x86_init_ops.  In addition to
identifying the init-only functions without restorting to code comments,
this also sets the stage for waiting until after ->hardware_setup() to
set kvm_x86_ops.  Setting kvm_x86_ops after ->hardware_setup() is
desirable as many of the hooks are not usable until ->hardware_setup()
completes.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 13 +++++++++----
 arch/x86/kvm/svm.c              | 15 ++++++++++-----
 arch/x86/kvm/vmx/vmx.c          | 16 +++++++++++-----
 arch/x86/kvm/x86.c              | 10 ++++++----
 4 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 77d206a93658..23afa627166a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1042,12 +1042,8 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 }
 
 struct kvm_x86_ops {
-	int (*cpu_has_kvm_support)(void);          /* __init */
-	int (*disabled_by_bios)(void);             /* __init */
 	int (*hardware_enable)(void);
 	void (*hardware_disable)(void);
-	int (*check_processor_compatibility)(void);/* __init */
-	int (*hardware_setup)(void);               /* __init */
 	void (*hardware_unsetup)(void);            /* __exit */
 	bool (*cpu_has_accelerated_tpr)(void);
 	bool (*has_emulated_msr)(int index);
@@ -1258,6 +1254,15 @@ struct kvm_x86_ops {
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
 };
 
+struct kvm_x86_init_ops {
+	int (*cpu_has_kvm_support)(void);
+	int (*disabled_by_bios)(void);
+	int (*check_processor_compatibility)(void);
+	int (*hardware_setup)(void);
+
+	struct kvm_x86_ops *runtime_ops;
+};
+
 struct kvm_arch_async_pf {
 	u32 token;
 	gfn_t gfn;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index bf0556588ad0..80c430b4967f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7371,11 +7371,7 @@ static void svm_pre_update_apicv_exec_ctrl(struct kvm *kvm, bool activate)
 }
 
 static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
-	.cpu_has_kvm_support = has_svm,
-	.disabled_by_bios = is_disabled,
-	.hardware_setup = svm_hardware_setup,
 	.hardware_unsetup = svm_hardware_unsetup,
-	.check_processor_compatibility = svm_check_processor_compat,
 	.hardware_enable = svm_hardware_enable,
 	.hardware_disable = svm_hardware_disable,
 	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
@@ -7511,9 +7507,18 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
 };
 
+static struct kvm_x86_init_ops svm_init_ops __initdata = {
+	.cpu_has_kvm_support = has_svm,
+	.disabled_by_bios = is_disabled,
+	.hardware_setup = svm_hardware_setup,
+	.check_processor_compatibility = svm_check_processor_compat,
+
+	.runtime_ops = &svm_x86_ops,
+};
+
 static int __init svm_init(void)
 {
-	return kvm_init(&svm_x86_ops, sizeof(struct vcpu_svm),
+	return kvm_init(&svm_init_ops, sizeof(struct vcpu_svm),
 			__alignof__(struct vcpu_svm), THIS_MODULE);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1419c53aed16..b7ffff90c2d7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7746,11 +7746,8 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 }
 
 static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
-	.cpu_has_kvm_support = cpu_has_kvm_support,
-	.disabled_by_bios = vmx_disabled_by_bios,
-	.hardware_setup = hardware_setup,
 	.hardware_unsetup = hardware_unsetup,
-	.check_processor_compatibility = vmx_check_processor_compat,
+
 	.hardware_enable = hardware_enable,
 	.hardware_disable = hardware_disable,
 	.cpu_has_accelerated_tpr = report_flexpriority,
@@ -7898,6 +7895,15 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 };
 
+static struct kvm_x86_init_ops vmx_init_ops __initdata = {
+	.cpu_has_kvm_support = cpu_has_kvm_support,
+	.disabled_by_bios = vmx_disabled_by_bios,
+	.check_processor_compatibility = vmx_check_processor_compat,
+	.hardware_setup = hardware_setup,
+
+	.runtime_ops = &vmx_x86_ops,
+};
+
 static void vmx_cleanup_l1d_flush(void)
 {
 	if (vmx_l1d_flush_pages) {
@@ -7982,7 +7988,7 @@ static int __init vmx_init(void)
 	}
 #endif
 
-	r = kvm_init(&vmx_x86_ops, sizeof(struct vcpu_vmx),
+	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
 		     __alignof__(struct vcpu_vmx), THIS_MODULE);
 	if (r)
 		return r;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 720fd7136712..eb36762aa2ce 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7276,8 +7276,8 @@ static struct notifier_block pvclock_gtod_notifier = {
 
 int kvm_arch_init(void *opaque)
 {
+	struct kvm_x86_init_ops *ops = opaque;
 	int r;
-	struct kvm_x86_ops *ops = opaque;
 
 	if (kvm_x86_ops) {
 		printk(KERN_ERR "kvm: already loaded the other module\n");
@@ -7326,7 +7326,7 @@ int kvm_arch_init(void *opaque)
 	if (r)
 		goto out_free_percpu;
 
-	kvm_x86_ops = ops;
+	kvm_x86_ops = ops->runtime_ops;
 
 	kvm_mmu_set_mask_ptes(PT_USER_MASK, PT_ACCESSED_MASK,
 			PT_DIRTY_MASK, PT64_NX_MASK, 0,
@@ -9581,9 +9581,10 @@ void kvm_arch_hardware_disable(void)
 
 int kvm_arch_hardware_setup(void *opaque)
 {
+	struct kvm_x86_init_ops *ops = opaque;
 	int r;
 
-	r = kvm_x86_ops->hardware_setup();
+	r = ops->hardware_setup();
 	if (r != 0)
 		return r;
 
@@ -9618,13 +9619,14 @@ void kvm_arch_hardware_unsetup(void)
 int kvm_arch_check_processor_compat(void *opaque)
 {
 	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
+	struct kvm_x86_init_ops *ops = opaque;
 
 	WARN_ON(!irqs_disabled());
 
 	if (kvm_host_cr4_reserved_bits(c) != cr4_reserved_bits)
 		return -EIO;
 
-	return kvm_x86_ops->check_processor_compatibility();
+	return ops->check_processor_compatibility();
 }
 
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
-- 
2.24.1

