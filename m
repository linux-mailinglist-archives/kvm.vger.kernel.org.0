Return-Path: <kvm+bounces-11247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 18CD08745FB
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 03:14:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BB5D1F21C09
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 02:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC49C63A5;
	Thu,  7 Mar 2024 02:14:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp238.sjtu.edu.cn (smtp238.sjtu.edu.cn [202.120.2.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DD2EAD5;
	Thu,  7 Mar 2024 02:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.120.2.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709777680; cv=none; b=gwz0iyN0tRo6LuclYx3Y+N9xMZl92MqwWv1qJ//87TBqRiDtXvPmGXAOsOdURUillxsIkJkZeNG9vWZvLiXxDWSzSB2/KGa+CY5jYMGmxf1OTRp+nrfC4VRDYffbXsoJ0ybC0qeW5Hz5dJKcmBJQA4fIEAyHzlk+bNn8IAoTszE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709777680; c=relaxed/simple;
	bh=zgC/d6cds9XJiQqU/dEwldAPOIfK/79YXy+0W9vHRtE=;
	h=Date:From:To:Cc:Message-ID:Subject:MIME-Version:Content-Type; b=Dop6LWPTE5XQpfHjWwYkmCkZCuDHKN+8w42hxhWa3pluvOpqQr3dR9qWrowcY9pG400sYRgdiNEMMsPLOzXM6i5tuki2Q0X5wtubN2DWjy7UiEU0AO8Zg+ZufKR3Qzw1L/Vfjx8/C1Spdm0Ol6fQZu+aNTyuTzHUisErJ92QCjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn; spf=pass smtp.mailfrom=sjtu.edu.cn; arc=none smtp.client-ip=202.120.2.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sjtu.edu.cn
Received: from mta91.sjtu.edu.cn (unknown [10.118.0.91])
	by smtp238.sjtu.edu.cn (Postfix) with ESMTPS id C5445274D;
	Thu,  7 Mar 2024 10:14:27 +0800 (CST)
Received: from mstore135.sjtu.edu.cn (unknown [10.118.0.135])
	by mta91.sjtu.edu.cn (Postfix) with ESMTP id 7F0C337C8F4;
	Thu,  7 Mar 2024 10:14:27 +0800 (CST)
Date: Thu, 7 Mar 2024 10:14:26 +0800 (CST)
From: Zheyun Shen <szy0127@sjtu.edu.cn>
To: Sean Christopherson <seanjc@google.com>, 
	thomas lendacky <thomas.lendacky@amd.com>, 
	pbonzini <pbonzini@redhat.com>, tglx <tglx@linutronix.de>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <980607740.5109383.1709777666996.JavaMail.zimbra@sjtu.edu.cn>
Subject: [PATCH v2] KVM:SVM: Flush cache only on CPUs running SEV guest
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 10.0.6_GA_4585 (ZimbraWebClient - GC122 (Win)/10.0.6_GA_4585)
Thread-Index: E3LcEnfndLKXNi/4RoxZJ7buiDAZDw==
Thread-Topic: Flush cache only on CPUs running SEV guest

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
 arch/x86/kvm/svm/sev.c | 27 +++++++++++++++++++++++----
 arch/x86/kvm/svm/svm.h |  3 +++
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f760106c3..743931e33 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -215,6 +215,24 @@ static void sev_asid_free(struct kvm_sev_info *sev)
 	sev->misc_cg = NULL;
 }
 
+static struct cpumask *sev_get_wbinvd_dirty_mask(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	return &sev->wbinvd_dirty_mask;
+}
+
+static void sev_do_wbinvd(struct kvm *kvm)
+{
+	int cpu;
+	struct cpumask *dirty_mask = sev_get_wbinvd_dirty_mask(kvm);
+
+	for_each_possible_cpu(cpu) {
+		if (cpumask_test_and_clear_cpu(cpu, dirty_mask))
+			wbinvd_on_cpu(cpu);
+	}
+}
+
 static void sev_decommission(unsigned int handle)
 {
 	struct sev_data_decommission decommission;
@@ -2048,7 +2066,7 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
 	 * releasing the pages back to the system for use. CLFLUSH will
 	 * not do this, so issue a WBINVD.
 	 */
-	wbinvd_on_all_cpus();
+	sev_do_wbinvd(kvm);
 
 	__unregister_enc_region_locked(kvm, region);
 
@@ -2152,7 +2170,7 @@ void sev_vm_destroy(struct kvm *kvm)
 	 * releasing the pages back to the system for use. CLFLUSH will
 	 * not do this, so issue a WBINVD.
 	 */
-	wbinvd_on_all_cpus();
+	sev_do_wbinvd(kvm);
 
 	/*
 	 * if userspace was terminated before unregistering the memory regions
@@ -2343,7 +2361,7 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
 	return;
 
 do_wbinvd:
-	wbinvd_on_all_cpus();
+	sev_do_wbinvd(vcpu->kvm);
 }
 
 void sev_guest_memory_reclaimed(struct kvm *kvm)
@@ -2351,7 +2369,7 @@ void sev_guest_memory_reclaimed(struct kvm *kvm)
 	if (!sev_guest(kvm))
 		return;
 
-	wbinvd_on_all_cpus();
+	sev_do_wbinvd(kvm);
 }
 
 void sev_free_vcpu(struct kvm_vcpu *vcpu)
@@ -2648,6 +2666,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 	sd->sev_vmcbs[asid] = svm->vmcb;
 	svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
 	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
+	cpumask_set_cpu(get_cpu(), sev_get_wbinvd_dirty_mask(svm->vcpu.kvm));
 }
 
 #define GHCB_SCRATCH_AREA_LIMIT		(16ULL * PAGE_SIZE)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8ef95139c..de240a9e9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -90,6 +90,9 @@ struct kvm_sev_info {
 	struct list_head mirror_entry; /* Use as a list entry of mirrors */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	atomic_t migration_in_progress;
+
+	/* CPUs invoked VMRUN should do wbinvd after guest memory is reclaimed */
+	struct cpumask wbinvd_dirty_mask;
 };
 
 struct kvm_svm {
-- 
2.34.1


