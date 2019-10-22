Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B435FDFAF7
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 04:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387592AbfJVCCQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 22:02:16 -0400
Received: from mga14.intel.com ([192.55.52.115]:61596 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387569AbfJVB7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 21:59:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 18:59:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="196293847"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 18:59:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 24/45] KVM: Add kvm_arch_vcpu_precreate() to handle pre-allocation issues
Date:   Mon, 21 Oct 2019 18:59:04 -0700
Message-Id: <20191022015925.31916-25-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022015925.31916-1-sean.j.christopherson@intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a pre-allocation arch hook to handle checks that are currently done
by arch specific code prior to allocating the vCPU object.  This paves
the way for moving the allocation to common KVM code.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/mips/kvm/mips.c       |  5 +++++
 arch/powerpc/kvm/powerpc.c |  5 +++++
 arch/s390/kvm/kvm-s390.c   | 12 ++++++++----
 arch/x86/kvm/x86.c         | 14 +++++++++-----
 include/linux/kvm_host.h   |  1 +
 virt/kvm/arm/arm.c         | 21 +++++++++++----------
 virt/kvm/kvm_main.c        |  4 ++++
 7 files changed, 43 insertions(+), 19 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index d72bceb10439..2e14455aec4e 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -280,6 +280,11 @@ static inline void dump_handler(const char *symbol, void *start, void *end)
 	pr_debug("\tEND(%s)\n", symbol);
 }
 
+int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
+{
+	return 0;
+}
+
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 {
 	int err, size;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 2cdc443cc09b..fa9ed239c546 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -716,6 +716,11 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	kvmppc_core_flush_memslot(kvm, slot);
 }
 
+int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
+{
+	return 0;
+}
+
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 {
 	struct kvm_vcpu *vcpu;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d047e846e1b9..ddc90fa6abfd 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3038,15 +3038,19 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 	return rc;
 }
 
+int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
+{
+	if (!kvm_is_ucontrol(kvm) && !sca_can_add_vcpu(kvm, id))
+		return -EINVAL;
+	return 0;
+}
+
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 				      unsigned int id)
 {
 	struct kvm_vcpu *vcpu;
 	struct sie_page *sie_page;
-	int rc = -EINVAL;
-
-	if (!kvm_is_ucontrol(kvm) && !sca_can_add_vcpu(kvm, id))
-		goto out;
+	int rc;
 
 	rc = -ENOMEM;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 10ee982b214d..964b3d0c7bc6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9010,17 +9010,21 @@ static void fx_init(struct kvm_vcpu *vcpu)
 	vcpu->arch.cr0 |= X86_CR0_ET;
 }
 
+int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
+{
+	if (kvm_check_tsc_unstable() && atomic_read(&kvm->online_vcpus) != 0)
+		pr_warn_once("kvm: SMP vm created on host with unstable TSC; "
+			     "guest TSC will not be reliable\n");
+
+	return 0;
+}
+
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 						unsigned int id)
 {
 	struct kvm_vcpu *vcpu;
 	int r;
 
-	if (kvm_check_tsc_unstable() && atomic_read(&kvm->online_vcpus) != 0)
-		printk_once(KERN_WARNING
-		"kvm: SMP vm created on host with unstable TSC; "
-		"guest TSC will not be reliable\n");
-
 	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
 	if (!vcpu)
 		return ERR_PTR(-ENOMEM);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ff31470aabd3..8bc03884cf5c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -855,6 +855,7 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu);
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
+int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id);
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id);
 int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 266d78fbc86c..03f6eec1841c 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -253,21 +253,22 @@ void kvm_arch_free_vm(struct kvm *kvm)
 		vfree(kvm);
 }
 
+int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
+{
+	if (irqchip_in_kernel(kvm) && vgic_initialized(kvm))
+		return -EBUSY;
+
+	if (id >= kvm->arch.max_vcpus)
+		return -EINVAL;
+
+	return 0;
+}
+
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 {
 	int err;
 	struct kvm_vcpu *vcpu;
 
-	if (irqchip_in_kernel(kvm) && vgic_initialized(kvm)) {
-		err = -EBUSY;
-		goto out;
-	}
-
-	if (id >= kvm->arch.max_vcpus) {
-		err = -EINVAL;
-		goto out;
-	}
-
 	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
 	if (!vcpu) {
 		err = -ENOMEM;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 67ef3f2e19e8..9c6791ad71e5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2653,6 +2653,10 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	kvm->created_vcpus++;
 	mutex_unlock(&kvm->lock);
 
+	r = kvm_arch_vcpu_precreate(kvm, id);
+	if (r)
+		goto vcpu_decrement;
+
 	vcpu = kvm_arch_vcpu_create(kvm, id);
 	if (IS_ERR(vcpu)) {
 		r = PTR_ERR(vcpu);
-- 
2.22.0

