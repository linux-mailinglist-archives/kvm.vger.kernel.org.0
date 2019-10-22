Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5718DDFA83
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 04:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387634AbfJVB7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 21:59:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:61596 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387621AbfJVB7x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 21:59:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 18:59:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="196293866"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 18:59:52 -0700
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
Subject: [PATCH 29/45] KVM: Introduce kvm_vcpu_destroy()
Date:   Mon, 21 Oct 2019 18:59:09 -0700
Message-Id: <20191022015925.31916-30-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022015925.31916-1-sean.j.christopherson@intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add kvm_vcpu_destroy() and wire up all architectures to call the common
function instead of their arch specific implementation.  The common
destruction function will be used by future patches to move allocation
and initialization of vCPUs to common KVM code, i.e. to free resources
that are allocated by arch agnostic code.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/mips/kvm/mips.c       | 2 +-
 arch/powerpc/kvm/powerpc.c | 2 +-
 arch/s390/kvm/kvm-s390.c   | 2 +-
 arch/x86/kvm/x86.c         | 2 +-
 include/linux/kvm_host.h   | 1 +
 virt/kvm/arm/arm.c         | 2 +-
 virt/kvm/kvm_main.c        | 6 ++++++
 7 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 73360e021259..8546bc6e09e7 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -156,7 +156,7 @@ void kvm_mips_free_vcpus(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		kvm_arch_vcpu_destroy(vcpu);
+		kvm_vcpu_destroy(vcpu);
 	}
 
 	mutex_lock(&kvm->lock);
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index fa9ed239c546..69a1a1c36909 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -473,7 +473,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 #endif
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvm_arch_vcpu_destroy(vcpu);
+		kvm_vcpu_destroy(vcpu);
 
 	mutex_lock(&kvm->lock);
 	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 9289ed10561b..2c965f11c276 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2544,7 +2544,7 @@ static void kvm_free_vcpus(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvm_arch_vcpu_destroy(vcpu);
+		kvm_vcpu_destroy(vcpu);
 
 	mutex_lock(&kvm->lock);
 	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9fdfc20f0cc2..c72b104deaca 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9496,7 +9496,7 @@ static void kvm_free_vcpus(struct kvm *kvm)
 		kvm_unload_vcpu_mmu(vcpu);
 	}
 	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvm_arch_vcpu_destroy(vcpu);
+		kvm_vcpu_destroy(vcpu);
 
 	mutex_lock(&kvm->lock);
 	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8bc03884cf5c..f38d75f60c8c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -587,6 +587,7 @@ static inline int kvm_vcpu_get_idx(struct kvm_vcpu *vcpu)
 
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id);
 void kvm_vcpu_uninit(struct kvm_vcpu *vcpu);
+void kvm_vcpu_destroy(struct kvm_vcpu *vcpu);
 
 void vcpu_load(struct kvm_vcpu *vcpu);
 void vcpu_put(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 03f6eec1841c..deb8a540538f 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -170,7 +170,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		if (kvm->vcpus[i]) {
-			kvm_arch_vcpu_destroy(kvm->vcpus[i]);
+			kvm_vcpu_destroy(kvm->vcpus[i]);
 			kvm->vcpus[i] = NULL;
 		}
 	}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9c6791ad71e5..dc6c721348dd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -341,6 +341,12 @@ void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_uninit);
 
+void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
+{
+	kvm_arch_vcpu_destroy(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_destroy);
+
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
 {
-- 
2.22.0

