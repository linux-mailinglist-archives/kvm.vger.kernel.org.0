Return-Path: <kvm+bounces-50114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4AF4AE1EE4
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:40:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 044237AFFCE
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4D892DFF2E;
	Fri, 20 Jun 2025 15:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="P2BCdBaY"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98AB82DF3CC;
	Fri, 20 Jun 2025 15:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750433999; cv=none; b=NquXTnnhbudWW/P+pJSYLMLdbw/38F0m4mT5ea/Ip7Gp32q/T3X8Bk1A9kjlXFmSm+bOLmim+4JEUme2UxX0LNTE7/pBHPyNziP3eIxsNJc+uu3en4G7d4slsOFFETQHOWy4IrCVtzwLtZYr+rqxgBB9Hvh+MEWYh2uzjbCdZbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750433999; c=relaxed/simple;
	bh=3TCjJNEsevipq/wYQO0d3KSail06dLDqwHLc+Sc/vuQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jJzCu1LmUYmGiP251sHmu77jI4s5RuiyUmq6NDL0Gyywc7ZplFNNMKbgxo4KnxJujxSeasYPedaB2YpwPPaqaZ7ggvhkqtTNt+SxR0XnnW018zrLtNKqG308wJcyjZ4H4O77QV5zKEHCAvB86xN2QFgf6UgjPf0J8U6+u9+9fO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=P2BCdBaY; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from LAPTOP-I1KNRUTF.home (unknown [40.68.205.236])
	by linux.microsoft.com (Postfix) with ESMTPSA id 53AA721176CB;
	Fri, 20 Jun 2025 08:39:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 53AA721176CB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1750433997;
	bh=8MFrkxQlcB5ZBCN4SMkrO/wa5QDMvzRY6icXFN3sfTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2BCdBaYvGi3WFsyzj4DeUqVte/ozZyq1SBFOykIU69NZCRH0LIrw1rJHsugTIDXQ
	 mw/gQFTdmnkiIkiis5JesmIPJhLzrZQNpOhJJcHIBxtw6taVkoKhtEanY/hybmn8he
	 dWqXIegMaP6vsoz9rZCWV5LkklFE4Fcj1KCMlu14=
From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
To: "Sean Christopherson" <seanjc@google.com>,
	"Vitaly Kuznetsov" <vkuznets@redhat.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Cc: "Dave Hansen" <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	alanjiang@microsoft.com,
	chinang.ma@microsoft.com,
	andrea.pellegrini@microsoft.com,
	"Kevin Tian" <kevin.tian@intel.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	"Haiyang Zhang" <haiyangz@microsoft.com>,
	"Wei Liu" <wei.liu@kernel.org>,
	"Dexuan Cui" <decui@microsoft.com>,
	linux-hyperv@vger.kernel.org,
	Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Subject: [RFC PATCH 1/1] KVM: VMX: Use Hyper-V EPT flush for local TLB flushes
Date: Fri, 20 Jun 2025 17:39:14 +0200
Message-Id: <4266fc8f76c152a3ffcbb2d2ebafd608aa0fb949.1750432368.git.jpiotrowski@linux.microsoft.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1750432368.git.jpiotrowski@linux.microsoft.com>
References: <cover.1750432368.git.jpiotrowski@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use Hyper-V's HvCallFlushGuestPhysicalAddressSpace for local TLB flushes.
This makes any KVM_REQ_TLB_FLUSH_CURRENT (such as on root alloc) visible to
all CPUs which means we no longer need to do a KVM_REQ_TLB_FLUSH on CPU
migration.

The goal is to avoid invept-global in KVM_REQ_TLB_FLUSH. Hyper-V uses a
shadow page table for the nested hypervisor (KVM) and has to invalidate all
EPT roots when invept-global is issued. This has a performance impact on
all nested VMs.  KVM issues KVM_REQ_TLB_FLUSH on CPU migration, and under
load the performance hit causes vCPUs to use up more of their slice of CPU
time, leading to more CPU migrations. This has a snowball effect and causes
CPU usage spikes.

By issuing the hypercall we are now guaranteed that any root modification
that requires a local TLB flush becomes visible to all CPUs. The same
hypercall is already used in kvm_arch_flush_remote_tlbs and
kvm_arch_flush_remote_tlbs_range.  The KVM expectation is that roots are
flushed locally on alloc and we achieve consistency on migration by
flushing all roots - the new behavior of achieving consistency on alloc on
Hyper-V is a superset of the expected guarantees. This makes the
KVM_REQ_TLB_FLUSH on CPU migration no longer necessary on Hyper-V.

Coincidentally - we now match the behavior of SVM on Hyper-V.

Signed-off-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/vmx.c          | 20 +++++++++++++++++---
 arch/x86/kvm/vmx/vmx_onhyperv.h |  6 ++++++
 arch/x86/kvm/x86.c              |  3 +++
 4 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b4a391929cdb..d3acab19f425 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1077,6 +1077,7 @@ struct kvm_vcpu_arch {
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t hv_root_tdp;
+	bool hv_vmx_use_flush_guest_mapping;
 #endif
 };
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4953846cb30d..f537e0df56fc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1485,8 +1485,12 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
 		/*
 		 * Flush all EPTP/VPID contexts, the new pCPU may have stale
 		 * TLB entries from its previous association with the vCPU.
+		 * Unless we are running on Hyper-V where we promotes local TLB
+		 * flushes to be visible across all CPUs so no need to do again
+		 * on migration.
 		 */
-		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+		if (!vmx_hv_use_flush_guest_mapping(vcpu))
+			kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 
 		/*
 		 * Linux uses per-cpu TSS and GDT, so set these when switching
@@ -3243,11 +3247,21 @@ void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 	if (!VALID_PAGE(root_hpa))
 		return;
 
-	if (enable_ept)
+	if (enable_ept) {
+		/*
+		 * hyperv_flush_guest_mapping() has the semantics of
+		 * invept-single across all pCPUs. This makes root
+		 * modifications consistent across pCPUs, so an invept-global
+		 * on migration is no longer required.
+		 */
+		if (vmx_hv_use_flush_guest_mapping(vcpu))
+			return (void)WARN_ON_ONCE(hyperv_flush_guest_mapping(root_hpa));
+
 		ept_sync_context(construct_eptp(vcpu, root_hpa,
 						mmu->root_role.level));
-	else
+	} else {
 		vpid_sync_context(vmx_get_current_vpid(vcpu));
+	}
 }
 
 void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
diff --git a/arch/x86/kvm/vmx/vmx_onhyperv.h b/arch/x86/kvm/vmx/vmx_onhyperv.h
index cdf8cbb69209..a5c64c90e49e 100644
--- a/arch/x86/kvm/vmx/vmx_onhyperv.h
+++ b/arch/x86/kvm/vmx/vmx_onhyperv.h
@@ -119,6 +119,11 @@ static inline void evmcs_load(u64 phys_addr)
 }
 
 void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf);
+
+static inline bool vmx_hv_use_flush_guest_mapping(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.hv_vmx_use_flush_guest_mapping;
+}
 #else /* !IS_ENABLED(CONFIG_HYPERV) */
 static __always_inline bool kvm_is_using_evmcs(void) { return false; }
 static __always_inline void evmcs_write64(unsigned long field, u64 value) {}
@@ -128,6 +133,7 @@ static __always_inline u64 evmcs_read64(unsigned long field) { return 0; }
 static __always_inline u32 evmcs_read32(unsigned long field) { return 0; }
 static __always_inline u16 evmcs_read16(unsigned long field) { return 0; }
 static inline void evmcs_load(u64 phys_addr) {}
+static inline bool vmx_hv_use_flush_guest_mapping(struct kvm_vcpu *vcpu) { return false; }
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
 #endif /* __ARCH_X86_KVM_VMX_ONHYPERV_H__ */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b58a74c1722d..cbde795096a6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -25,6 +25,7 @@
 #include "tss.h"
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
+#include "kvm_onhyperv.h"
 #include "mmu/page_track.h"
 #include "x86.h"
 #include "cpuid.h"
@@ -12390,6 +12391,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	vcpu->arch.hv_root_tdp = INVALID_PAGE;
+	vcpu->arch.hv_vmx_use_flush_guest_mapping =
+		(kvm_x86_ops.flush_remote_tlbs == hv_flush_remote_tlbs);
 #endif
 
 	r = kvm_x86_call(vcpu_create)(vcpu);
-- 
2.39.5


