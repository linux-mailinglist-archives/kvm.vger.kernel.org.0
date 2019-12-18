Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99E6B12557B
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 22:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbfLRV43 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 16:56:29 -0500
Received: from mga04.intel.com ([192.55.52.120]:16969 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727317AbfLRV4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 16:56:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 13:55:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="222108187"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 18 Dec 2019 13:55:51 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
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
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kurz <groug@kaod.org>
Subject: [PATCH v2 42/45] KVM: arm64: Free sve_state via arm specific hook
Date:   Wed, 18 Dec 2019 13:55:27 -0800
Message-Id: <20191218215530.2280-43-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218215530.2280-1-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an arm specific hook to free the arm64-only sve_state.  Doing so
eliminates the last functional code from kvm_arch_vcpu_uninit() across
all architectures and paves the way for removing kvm_arch_vcpu_init()
and kvm_arch_vcpu_uninit() entirely.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/arm/include/asm/kvm_host.h   | 1 +
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/reset.c            | 5 +++++
 virt/kvm/arm/arm.c                | 2 ++
 4 files changed, 9 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 556cd818eccf..de81dd897a30 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -366,6 +366,7 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu) {}
 
 static inline void kvm_arm_init_debug(void) {}
 static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b36dae9ee5f9..b1de2b147729 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -53,6 +53,7 @@ int kvm_arm_init_sve(void);
 
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
+void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu);
 int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext);
 void __extended_idmap_trampoline(phys_addr_t boot_pgd, phys_addr_t idmap_start);
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index f4a8ae918827..ff3512a0ca97 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -205,6 +205,11 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
 }
 
 void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
+{
+
+}
+
+void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	kfree(vcpu->arch.sve_state);
 }
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 1d87c194a6d3..f6c641136501 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -326,6 +326,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_caches(vcpu);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
+
+	kvm_arm_vcpu_destroy(vcpu);
 }
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
-- 
2.24.1

