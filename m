Return-Path: <kvm+bounces-35993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC9DCA16C01
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 13:06:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C00523A1F18
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 12:06:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5EF71DFDA7;
	Mon, 20 Jan 2025 12:06:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp232.sjtu.edu.cn (smtp232.sjtu.edu.cn [202.120.2.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F771DEFFE;
	Mon, 20 Jan 2025 12:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.120.2.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737374772; cv=none; b=dTa7zQzfD7KtoSVp2Z4R1nIbjGOHrwX/1Z2YixyFko0IQWcDybgXI86an4iuddZ3OU+BLfEaNUTO4EgnsRqj5GOHkfHZaoQ7yfG08fxZFvDTys+oN+K869ibSely0yZ9Ah6lKdIowzR+XnhNRqpAY+WcPF1mMYuIFpVxdWjwyrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737374772; c=relaxed/simple;
	bh=E0vz45kujEmmbnsv5ULF5wrUd2lin7nq6u9gVVJVLMM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DGv//7V3+GMV5p9v80+uH6fkKSP+3JqmPu36uzEFJ4tYDgC106Fk6qdY2c6uBr22QRCBUaUeiJx0zje9wdvWgANn7HXChJ7MJ39YH9FrGpHlV1C5cF7DhcEkK7qw74YRWn53szWU12p9WxUxFLuehIicGyt1WwvdEKJ5ppU6Ja4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn; spf=pass smtp.mailfrom=sjtu.edu.cn; arc=none smtp.client-ip=202.120.2.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sjtu.edu.cn
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp232.sjtu.edu.cn (Postfix) with ESMTPS id 03D4D1008CF48;
	Mon, 20 Jan 2025 20:05:37 +0800 (CST)
Received: from broadband.. (unknown [202.120.40.80])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id 5931837C955;
	Mon, 20 Jan 2025 20:05:29 +0800 (CST)
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
Subject: [PATCH v5 3/3] KVM: SVM: Flush cache only on CPUs running SEV guest
Date: Mon, 20 Jan 2025 20:05:03 +0800
Message-Id: <20250120120503.470533-4-szy0127@sjtu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250120120503.470533-1-szy0127@sjtu.edu.cn>
References: <20250120120503.470533-1-szy0127@sjtu.edu.cn>
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

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
---
 arch/x86/kvm/svm/sev.c | 39 ++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/svm/svm.c |  2 ++
 arch/x86/kvm/svm/svm.h |  5 ++++-
 3 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1ce67de9d..91469edd1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -252,6 +252,36 @@ static void sev_asid_free(struct kvm_sev_info *sev)
 	sev->misc_cg = NULL;
 }
 
+static struct cpumask *sev_get_wbinvd_dirty_mask(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	return sev->wbinvd_dirty_mask;
+}
+
+void sev_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	/*
+	 * To optimize cache flushes when memory is reclaimed from an SEV VM,
+	 * track physical CPUs that enter the guest for SEV VMs and thus can
+	 * have encrypted, dirty data in the cache, and flush caches only for
+	 * CPUs that have entered the guest.
+	 */
+	cpumask_set_cpu(cpu, sev_get_wbinvd_dirty_mask(vcpu->kvm));
+}
+
+static void sev_do_wbinvd(struct kvm *kvm)
+{
+	struct cpumask *dirty_mask = sev_get_wbinvd_dirty_mask(kvm);
+
+	/*
+	 * TODO: Clear CPUs from the bitmap prior to flushing.  Doing so
+	 * requires serializing multiple calls and having CPUs mark themselves
+	 * "dirty" if they are currently running a vCPU for the VM.
+	 */
+	wbinvd_on_many_cpus(dirty_mask);
+}
+
 static void sev_decommission(unsigned int handle)
 {
 	struct sev_data_decommission decommission;
@@ -448,6 +478,8 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	ret = sev_platform_init(&init_args);
 	if (ret)
 		goto e_free;
+	if (!zalloc_cpumask_var(&sev->wbinvd_dirty_mask, GFP_KERNEL_ACCOUNT))
+		goto e_free;
 
 	/* This needs to happen after SEV/SNP firmware initialization. */
 	if (vm_type == KVM_X86_SNP_VM) {
@@ -2778,7 +2810,7 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
 	 * releasing the pages back to the system for use. CLFLUSH will
 	 * not do this, so issue a WBINVD.
 	 */
-	wbinvd_on_all_cpus();
+	sev_do_wbinvd(kvm);
 
 	__unregister_enc_region_locked(kvm, region);
 
@@ -2926,6 +2958,7 @@ void sev_vm_destroy(struct kvm *kvm)
 	}
 
 	sev_asid_free(sev);
+	free_cpumask_var(sev->wbinvd_dirty_mask);
 }
 
 void __init sev_set_cpu_caps(void)
@@ -3129,7 +3162,7 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
 	return;
 
 do_wbinvd:
-	wbinvd_on_all_cpus();
+	sev_do_wbinvd(vcpu->kvm);
 }
 
 void sev_guest_memory_reclaimed(struct kvm *kvm)
@@ -3143,7 +3176,7 @@ void sev_guest_memory_reclaimed(struct kvm *kvm)
 	if (!sev_guest(kvm) || sev_snp_guest(kvm))
 		return;
 
-	wbinvd_on_all_cpus();
+	sev_do_wbinvd(kvm);
 }
 
 void sev_free_vcpu(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 21dacd312..d2a423c0e 100644
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
index 43fa6a16e..c8f42cb61 100644
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


