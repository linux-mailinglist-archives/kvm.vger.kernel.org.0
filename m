Return-Path: <kvm+bounces-6863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 632CC83B337
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 21:49:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CA7E284258
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 20:49:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33AA81350FD;
	Wed, 24 Jan 2024 20:48:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD0C13474A;
	Wed, 24 Jan 2024 20:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.28.154.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706129333; cv=none; b=KrH+amEL1VLGQGgx8yvh57wp7NKXLQmEfwnOP5J0VU+83S7x+qAbJW7CIe1i8gT1vqEEI7oHYXOOF1ESHUsLMJY9+1+m7POLVBS1D8lTWvKowu4PmOOhEi/ZXa2kKMVylUoxjjVIyMbtwsyId3uZdHYVIM5OhXuLig5iePXmlKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706129333; c=relaxed/simple;
	bh=6FC/0e29kJXWgGL2yi5/vbe6wptoY2zpI5hp51jovMo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MJCM9CZavBxuUh+xrit494KulpjJvcMHLrghZw2J9yRrXZ4RBqg0wQPGw0HExAoP7aLBXcJt1Q1f0OkDGZLpF0hkjLKQ5ioHs3GlrqMYbONsqRogHSmb7AHs2icdEMrZlD8LDb67SzRxdv14ZHuDa1pS4oOi/5eTQKCoCQUvixM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name; spf=pass smtp.mailfrom=maciej.szmigiero.name; arc=none smtp.client-ip=37.28.154.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=maciej.szmigiero.name
Received: from MUA
	by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <mail@maciej.szmigiero.name>)
	id 1rSjhi-0003sJ-QU; Wed, 24 Jan 2024 21:18:34 +0100
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Give a hint when Win2016 might fail to boot due to XSAVES erratum
Date: Wed, 24 Jan 2024 21:18:21 +0100
Message-ID: <b83ab45c5e239e5d148b0ae7750133a67ac9575c.1706127425.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

Since commit b0563468eeac ("x86/CPU/AMD: Disable XSAVES on AMD family 0x17")
kernel unconditionally clears the XSAVES CPU feature bit on Zen1/2 CPUs.

Because KVM CPU caps are initialized from the kernel boot CPU features this
makes the XSAVES feature also unavailable for KVM guests in this case.
At the same time the XSAVEC feature is left enabled.

Unfortunately, having XSAVEC but no XSAVES in CPUID breaks Hyper-V enabled
Windows Server 2016 VMs that have more than one vCPU.

Let's at least give users hint in the kernel log what could be wrong since
these VMs currently simply hang at boot with a black screen - giving no
clue what suddenly broke them and how to make them work again.

Trigger the kernel message hint based on the particular guest ID written to
the Guest OS Identity Hyper-V MSR implemented by KVM.

Defer this check to when the L1 Hyper-V hypervisor enables SVM in EFER
since we want to limit this message to Hyper-V enabled Windows guests only
(Windows session running nested as L2) but the actual Guest OS Identity MSR
write is done by L1 and happens before it enables SVM.

Fixes: b0563468eeac ("x86/CPU/AMD: Disable XSAVES on AMD family 0x17")
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/hyperv.c           | 48 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/hyperv.h           |  3 +++
 arch/x86/kvm/x86.c              |  4 +++
 4 files changed, 57 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7bc1daf68741..c4b63be775df 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1145,6 +1145,8 @@ struct kvm_hv {
 	unsigned int synic_auto_eoi_used;
 
 	struct kvm_hv_syndbg hv_syndbg;
+
+	bool xsaves_xsavec_warned;
 };
 #endif
 
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 238afd7335e4..41485ae35b23 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1322,6 +1322,54 @@ static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
 	return false;
 }
 
+#define KVM_HV_WIN2016_GUEST_ID 0x1040a00003839
+#define KVM_HV_WIN2016_GUEST_ID_MASK (~GENMASK_ULL(23, 16)) /* mask out the service version */
+
+/*
+ * Hyper-V enabled Windows Server 2016 SMP VMs fail to boot in !XSAVES && XSAVEC
+ * configuration.
+ * Such configuration can result from, for example, AMD Erratum 1386 workaround.
+ *
+ * Print a notice so users aren't left wondering what's suddenly gone wrong.
+ */
+static void kvm_hv_xsaves_xsavec_maybe_warn_unlocked(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_hv *hv = to_kvm_hv(kvm);
+
+	if (hv->xsaves_xsavec_warned)
+		return;
+
+	if (!vcpu->arch.hyperv_enabled)
+		return;
+
+	if ((hv->hv_guest_os_id & KVM_HV_WIN2016_GUEST_ID_MASK) !=
+	    KVM_HV_WIN2016_GUEST_ID)
+		return;
+
+	/* UP configurations aren't affected */
+	if (atomic_read(&kvm->online_vcpus) < 2)
+		return;
+
+	if (boot_cpu_has(X86_FEATURE_XSAVES) ||
+	    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVEC))
+		return;
+
+	pr_notice_ratelimited("Booting SMP Windows KVM VM with !XSAVES && XSAVEC. "
+			      "If it fails to boot try disabling XSAVEC in the VM config.\n");
+
+	hv->xsaves_xsavec_warned = true;
+}
+
+void kvm_hv_xsaves_xsavec_maybe_warn(struct kvm_vcpu *vcpu)
+{
+	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
+
+	mutex_lock(&hv->hv_lock);
+	kvm_hv_xsaves_xsavec_maybe_warn_unlocked(vcpu);
+	mutex_unlock(&hv->hv_lock);
+}
+
 static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 			     bool host)
 {
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 1dc0b6604526..923e64903da9 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -182,6 +182,8 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 			   struct pvclock_vcpu_time_info *hv_clock);
 void kvm_hv_request_tsc_page_update(struct kvm *kvm);
 
+void kvm_hv_xsaves_xsavec_maybe_warn(struct kvm_vcpu *vcpu);
+
 void kvm_hv_init_vm(struct kvm *kvm);
 void kvm_hv_destroy_vm(struct kvm *kvm);
 int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu);
@@ -267,6 +269,7 @@ int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu);
 static inline void kvm_hv_setup_tsc_page(struct kvm *kvm,
 					 struct pvclock_vcpu_time_info *hv_clock) {}
 static inline void kvm_hv_request_tsc_page_update(struct kvm *kvm) {}
+static inline void kvm_hv_xsaves_xsavec_maybe_warn(struct kvm_vcpu *vcpu) {}
 static inline void kvm_hv_init_vm(struct kvm *kvm) {}
 static inline void kvm_hv_destroy_vm(struct kvm *kvm) {}
 static inline int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 27e23714e960..db0a2c40d749 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1782,6 +1782,10 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	if ((efer ^ old_efer) & KVM_MMU_EFER_ROLE_BITS)
 		kvm_mmu_reset_context(vcpu);
 
+	if (guest_cpuid_is_amd_or_hygon(vcpu) &&
+	    efer & EFER_SVME)
+		kvm_hv_xsaves_xsavec_maybe_warn(vcpu);
+
 	return 0;
 }
 

