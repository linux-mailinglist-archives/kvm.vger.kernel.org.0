Return-Path: <kvm+bounces-36609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0756A1C78A
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 12:38:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1FFC166D6B
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 11:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79BCC156F41;
	Sun, 26 Jan 2025 11:37:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp237.sjtu.edu.cn (smtp237.sjtu.edu.cn [202.120.2.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3434E1531C4;
	Sun, 26 Jan 2025 11:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.120.2.237
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737891458; cv=none; b=fAfjkcGyJCrrc7cVxhZyxy6G/u/Hiz4FjkUwM3d0LJLAHtFyXQjmbWCDUk7bghop853qX7/NkyIRTv3dq1sa3O7ajJbMLcQtxe0Qx9+ajeZ8AymY1E/pEC4M0Jf03xf2MVCuQDDwIP3upnJxmDiCOfEUsi2Mm7yqUFCQtQNdSyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737891458; c=relaxed/simple;
	bh=dmAcphMopESfxZ04xl0/mZ9P2VsXIR6iEbbjAqJZ9d4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=drkJi7chwsvR37oWkxD9b/Qg91CViqqjg+lY5FrOFeca4G4nA59PXB72cQkwR0GtaFX3oh3gTmel/UCqY1rOyKWqDMdFO/80K2m5bfbgiCo1hRvNuiCgqb9h/Ibu9QgCfIE1FNAwBe7BVMKoXN/xS8WflPFgPTiEV3VL7IoQHJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn; spf=pass smtp.mailfrom=sjtu.edu.cn; arc=none smtp.client-ip=202.120.2.237
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sjtu.edu.cn
Received: from proxy189.sjtu.edu.cn (smtp189.sjtu.edu.cn [202.120.2.189])
	by smtp237.sjtu.edu.cn (Postfix) with ESMTPS id 10D88812AC;
	Sun, 26 Jan 2025 19:37:19 +0800 (CST)
Received: from localhost.localdomain (unknown [101.80.151.229])
	by proxy189.sjtu.edu.cn (Postfix) with ESMTPSA id 6D2623FC595;
	Sun, 26 Jan 2025 19:37:10 +0800 (CST)
From: Zheyun Shen <szy0127@sjtu.edu.cn>
To: thomas.lendacky@amd.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	kevinloughlin@google.com,
	mingo@redhat.com,
	bp@alien8.de
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zheyun Shen <szy0127@sjtu.edu.cn>
Subject: [PATCH v6 3/3] KVM: SVM: Flush cache only on CPUs running SEV guest
Date: Sun, 26 Jan 2025 19:36:40 +0800
Message-Id: <20250126113640.3426-4-szy0127@sjtu.edu.cn>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250126113640.3426-1-szy0127@sjtu.edu.cn>
References: <20250126113640.3426-1-szy0127@sjtu.edu.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On AMD CPUs without ensuring cache consistency, each memory page
reclamation in an SEV guest triggers a call to wbinvd_on_all_cpus(),
thereby affecting the performance of other programs on the host.

Typically, an AMD server may have 128 cores or more, while the SEV guest
might only utilize 8 of these cores. Meanwhile, host can use qemu-affinity
to bind these 8 vCPUs to specific physical CPUs.

Therefore, keeping a record of the physical core numbers each time a vCPU
runs can help avoid flushing the cache for all CPUs every time.

Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
---
 arch/x86/kvm/svm/sev.c | 30 +++++++++++++++++++++++++++---
 arch/x86/kvm/svm/svm.c |  2 ++
 arch/x86/kvm/svm/svm.h |  5 ++++-
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1ce67de9d..4b80ecbe7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -252,6 +252,27 @@ static void sev_asid_free(struct kvm_sev_info *sev)
 	sev->misc_cg = NULL;
 }
 
+void sev_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	/*
+	 * To optimize cache flushes when memory is reclaimed from an SEV VM,
+	 * track physical CPUs that enter the guest for SEV VMs and thus can
+	 * have encrypted, dirty data in the cache, and flush caches only for
+	 * CPUs that have entered the guest.
+	 */
+	cpumask_set_cpu(cpu, to_kvm_sev_info(kvm)->wbinvd_dirty_mask);
+}
+
+static void sev_do_wbinvd(struct kvm *kvm)
+{
+	/*
+	 * TODO: Clear CPUs from the bitmap prior to flushing.  Doing so
+	 * requires serializing multiple calls and having CPUs mark themselves
+	 * "dirty" if they are currently running a vCPU for the VM.
+	 */
+	wbinvd_on_many_cpus(to_kvm_sev_info(kvm)->wbinvd_dirty_mask);
+}
+
 static void sev_decommission(unsigned int handle)
 {
 	struct sev_data_decommission decommission;
@@ -448,6 +469,8 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	ret = sev_platform_init(&init_args);
 	if (ret)
 		goto e_free;
+	if (!zalloc_cpumask_var(&sev->wbinvd_dirty_mask, GFP_KERNEL_ACCOUNT))
+		goto e_free;
 
 	/* This needs to happen after SEV/SNP firmware initialization. */
 	if (vm_type == KVM_X86_SNP_VM) {
@@ -2778,7 +2801,7 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
 	 * releasing the pages back to the system for use. CLFLUSH will
 	 * not do this, so issue a WBINVD.
 	 */
-	wbinvd_on_all_cpus();
+	sev_do_wbinvd(kvm);
 
 	__unregister_enc_region_locked(kvm, region);
 
@@ -2926,6 +2949,7 @@ void sev_vm_destroy(struct kvm *kvm)
 	}
 
 	sev_asid_free(sev);
+	free_cpumask_var(sev->wbinvd_dirty_mask);
 }
 
 void __init sev_set_cpu_caps(void)
@@ -3129,7 +3153,7 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
 	return;
 
 do_wbinvd:
-	wbinvd_on_all_cpus();
+	sev_do_wbinvd(vcpu->kvm);
 }
 
 void sev_guest_memory_reclaimed(struct kvm *kvm)
@@ -3143,7 +3167,7 @@ void sev_guest_memory_reclaimed(struct kvm *kvm)
 	if (!sev_guest(kvm) || sev_snp_guest(kvm))
 		return;
 
-	wbinvd_on_all_cpus();
+	sev_do_wbinvd(kvm);
 }
 
 void sev_free_vcpu(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dd15cc635..f3b03b0d8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1565,6 +1565,8 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	}
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_vcpu_load(vcpu, cpu);
+	if (sev_guest(vcpu->kvm))
+		sev_vcpu_load(vcpu, cpu);
 }
 
 static void svm_vcpu_put(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 43fa6a16e..82ec80cf4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -112,6 +112,8 @@ struct kvm_sev_info {
 	void *guest_req_buf;    /* Bounce buffer for SNP Guest Request input */
 	void *guest_resp_buf;   /* Bounce buffer for SNP Guest Request output */
 	struct mutex guest_req_mutex; /* Must acquire before using bounce buffers */
+	/* CPUs invoked VMRUN call wbinvd after guest memory is reclaimed */
+	struct cpumask *wbinvd_dirty_mask;
 };
 
 struct kvm_svm {
@@ -763,6 +765,7 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+void sev_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 #else
 static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 {
@@ -793,7 +796,7 @@ static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	return 0;
 }
-
+static inline void sev_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
 #endif
 
 /* vmenter.S */
-- 
2.34.1


