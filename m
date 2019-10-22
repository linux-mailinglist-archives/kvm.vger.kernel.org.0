Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B983DDFAB5
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 04:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387877AbfJVCAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 22:00:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:61609 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387727AbfJVCAD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 22:00:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 19:00:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="196293961"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 19:00:02 -0700
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
Subject: [PATCH 42/45] KVM: arm64: Free sve_state via arm specific hook
Date:   Mon, 21 Oct 2019 18:59:22 -0700
Message-Id: <20191022015925.31916-43-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022015925.31916-1-sean.j.christopherson@intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
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
index 8a37c8e89777..cc414de5acd3 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -333,6 +333,7 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
+static inline int kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu) {}
 
 static inline void kvm_arm_init_debug(void) {}
 static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f656169db8c3..92d7c384a4ed 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -52,6 +52,7 @@ int kvm_arm_init_sve(void);
 
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
+int kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu);
 int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext);
 void __extended_idmap_trampoline(phys_addr_t boot_pgd, phys_addr_t idmap_start);
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index f4a8ae918827..98abc4278f42 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -205,6 +205,11 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
 }
 
 void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
+{
+
+}
+
+int kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	kfree(vcpu->arch.sve_state);
 }
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index aac4e5a1a521..b38088415cde 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -298,6 +298,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_caches(vcpu);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
+
+	kvm_arm_vcpu_destroy(vcpu);
 }
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
-- 
2.22.0

