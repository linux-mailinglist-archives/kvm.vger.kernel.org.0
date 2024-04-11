Return-Path: <kvm+bounces-14259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 55D028A16B3
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 16:07:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 752D61C22F1C
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 14:07:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86554152178;
	Thu, 11 Apr 2024 14:06:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp232.sjtu.edu.cn (smtp232.sjtu.edu.cn [202.120.2.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8780815098A;
	Thu, 11 Apr 2024 14:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.120.2.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712844361; cv=none; b=EHLz41Ne9GUVe2cMiG3XTAwcU5sdnQiqYGITsicNIEkQ0dovuoAh6yO4PxjCOI/9DA5Tw2UVfsZEkbDIVZ9Eikn2z3fBsngbqx8EjfsAt+h7o/YtAXqg8emmipWcXD2oNq2dX6v7om2B9SxHxOtah73rqY+BifLRISyM1HdStbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712844361; c=relaxed/simple;
	bh=nW543UmCuzyTfxa5GK23YA/xxrdunGVtlo+B03BjHmU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RRAO2Z+pLrs1NfSkLB1gsEo4oDujT8R7o3J09lBJE9PfhDZgn7YZ6l4Hejg3+8M63rQIcVz5uAeDOKmT7bRZMv75/kSA7XnwHbsQgSTtVAE/Mw9ahtjpnBM+pjQH0dcEE5FV06ylz9r0QTPOmhUvyMbFifOqo3wl/s4IFIDlw6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn; spf=pass smtp.mailfrom=sjtu.edu.cn; arc=none smtp.client-ip=202.120.2.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sjtu.edu.cn
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp232.sjtu.edu.cn (Postfix) with ESMTPS id D02B01006BD67;
	Thu, 11 Apr 2024 22:05:44 +0800 (CST)
Received: from broadband.ipads-lab.se.sjtu.edu.cn (unknown [202.120.40.82])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id DB8DF37C974;
	Thu, 11 Apr 2024 22:05:39 +0800 (CST)
From: Zheyun Shen <szy0127@sjtu.edu.cn>
To: thomas.lendacky@amd.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zheyun Shen <szy0127@sjtu.edu.cn>
Subject: [PATCH v4 2/2] KVM: SVM: Flush cache only on CPUs running SEV guest
Date: Thu, 11 Apr 2024 22:04:45 +0800
Message-Id: <20240411140445.1038319-3-szy0127@sjtu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240411140445.1038319-1-szy0127@sjtu.edu.cn>
References: <20240411140445.1038319-1-szy0127@sjtu.edu.cn>
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

Since the usage of sev_flush_asids() isn't tied to a single VM, we just
replace all wbinvd_on_all_cpus() with sev_do_wbinvd() except for that
in sev_flush_asids().

Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
---
 arch/x86/kvm/svm/sev.c | 48 ++++++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/svm/svm.c |  2 ++
 arch/x86/kvm/svm/svm.h |  4 ++++
 3 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f760106c3..3a129aa61 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -215,6 +215,42 @@ static void sev_asid_free(struct kvm_sev_info *sev)
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
+	 * The per-VM wbinvd_dirty_mask should record all physical CPUs
+	 * that are running a SEV guest and be used in memory reclamation.
+	 *
+	 * Migrating vCPUs between pCPUs is tricky. We cannot clear
+	 * this mask each time reclamation finishes and record it again
+	 * before VMRUN, because we cannot guarantee the pCPU will exit
+	 * to VMM before the next reclamation happens.
+	 *
+	 * Thus we just keep stale pCPU numbers in the mask if vCPU
+	 * migration happens.
+	 */
+	cpumask_set_cpu(cpu, sev_get_wbinvd_dirty_mask(vcpu->kvm));
+}
+
+static void sev_do_wbinvd(struct kvm *kvm)
+{
+	struct cpumask *dirty_mask = sev_get_wbinvd_dirty_mask(kvm);
+
+	/*
+	 * Although dirty_mask is not maintained perfectly and may lead
+	 * to wbinvd on physical CPUs that are not running a SEV guest,
+	 * it's still better than wbinvd_on_all_cpus().
+	 */
+	wbinvd_on_many_cpus(dirty_mask);
+}
+
 static void sev_decommission(unsigned int handle)
 {
 	struct sev_data_decommission decommission;
@@ -265,6 +301,9 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	ret = sev_platform_init(&argp->error);
 	if (ret)
 		goto e_free;
+	if (!zalloc_cpumask_var(&sev->wbinvd_dirty_mask, GFP_KERNEL_ACCOUNT))
+		goto e_free;
+
 
 	INIT_LIST_HEAD(&sev->regions_list);
 	INIT_LIST_HEAD(&sev->mirror_vms);
@@ -2048,7 +2087,7 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
 	 * releasing the pages back to the system for use. CLFLUSH will
 	 * not do this, so issue a WBINVD.
 	 */
-	wbinvd_on_all_cpus();
+	sev_do_wbinvd(kvm);
 
 	__unregister_enc_region_locked(kvm, region);
 
@@ -2152,7 +2191,7 @@ void sev_vm_destroy(struct kvm *kvm)
 	 * releasing the pages back to the system for use. CLFLUSH will
 	 * not do this, so issue a WBINVD.
 	 */
-	wbinvd_on_all_cpus();
+	sev_do_wbinvd(kvm);
 
 	/*
 	 * if userspace was terminated before unregistering the memory regions
@@ -2168,6 +2207,7 @@ void sev_vm_destroy(struct kvm *kvm)
 
 	sev_unbind_asid(kvm, sev->handle);
 	sev_asid_free(sev);
+	free_cpumask_var(sev->wbinvd_dirty_mask);
 }
 
 void __init sev_set_cpu_caps(void)
@@ -2343,7 +2383,7 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
 	return;
 
 do_wbinvd:
-	wbinvd_on_all_cpus();
+	sev_do_wbinvd(vcpu->kvm);
 }
 
 void sev_guest_memory_reclaimed(struct kvm *kvm)
@@ -2351,7 +2391,7 @@ void sev_guest_memory_reclaimed(struct kvm *kvm)
 	if (!sev_guest(kvm))
 		return;
 
-	wbinvd_on_all_cpus();
+	sev_do_wbinvd(kvm);
 }
 
 void sev_free_vcpu(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e90b429c8..6ec118df3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1560,6 +1560,8 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	}
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_vcpu_load(vcpu, cpu);
+	if (sev_guest(vcpu->kvm))
+		sev_vcpu_load(vcpu, cpu);
 }
 
 static void svm_vcpu_put(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8ef95139c..dfb889c91 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -90,6 +90,9 @@ struct kvm_sev_info {
 	struct list_head mirror_entry; /* Use as a list entry of mirrors */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	atomic_t migration_in_progress;
+
+    /* CPUs invoked VMRUN should do wbinvd after guest memory is reclaimed */
+	struct cpumask *wbinvd_dirty_mask;
 };
 
 struct kvm_svm {
@@ -694,6 +697,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
+void sev_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 
 /* vmenter.S */
 
-- 
2.34.1


