Return-Path: <kvm+bounces-10572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54A5586D9D2
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 03:39:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 607811C22A8A
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 02:39:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D432405C6;
	Fri,  1 Mar 2024 02:39:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp238.sjtu.edu.cn (smtp238.sjtu.edu.cn [202.120.2.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FB9111B1;
	Fri,  1 Mar 2024 02:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.120.2.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709260760; cv=none; b=BUNJHX/8DF6nDFXD1+E3JwHdwjaNxRcZA6LUoY7CQgKz+yZGsu9h1B4vBgpyaIPXq2BeGGtl54yZZcrrXXDmbUHAv6FYmLVoHE4kvfDpHizMt3bM7anXh04MI52MHmGoGJse4uRk1pPqcsgD8SGkTBh0X2xQ6aLcWH/quYqCvQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709260760; c=relaxed/simple;
	bh=5OyCANYln5q1VLkON3YNr7lqyaeK3o62e/PwZmVTQz4=;
	h=Date:From:To:Cc:Message-ID:Subject:MIME-Version:Content-Type; b=TxwrUvW5Ju2AorWenpSjT8gKaJgs7p87rATzHMUAzy2YFEhaonj/zrkJvTt7jWLTCshVJYvNS0vSYgKknOsyrC81rzI5SNrZrkgEMePL2MRTteyQDcv+fzoRquXqMZU7jhoXbCuetXbDOP9lKjN1t+CuNzunbCCtkbvbpUQXeEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn; spf=pass smtp.mailfrom=sjtu.edu.cn; arc=none smtp.client-ip=202.120.2.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sjtu.edu.cn
Received: from mta91.sjtu.edu.cn (unknown [10.118.0.91])
	by smtp238.sjtu.edu.cn (Postfix) with ESMTPS id DAB52DAA;
	Fri,  1 Mar 2024 10:30:50 +0800 (CST)
Received: from mstore135.sjtu.edu.cn (unknown [10.118.0.135])
	by mta91.sjtu.edu.cn (Postfix) with ESMTP id A037037C8F4;
	Fri,  1 Mar 2024 10:30:50 +0800 (CST)
Date: Fri, 1 Mar 2024 10:30:50 +0800 (CST)
From: Zheyun Shen <szy0127@sjtu.edu.cn>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <1880816055.4545532.1709260250219.JavaMail.zimbra@sjtu.edu.cn>
Subject: [PATCH] KVM:SVM: Flush cache only on CPUs running SEV guest
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 10.0.6_GA_4585 (ZimbraWebClient - GC121 (Win)/10.0.6_GA_4585)
Thread-Index: 6+0saTCB4Pk4lnaiqVwtNt1nJUojNQ==
Thread-Topic: Flush cache only on CPUs running SEV guest

On AMD CPUs without ensuring cache consistency, each memory page reclamation in
an SEV guest triggers a call to wbinvd_on_all_cpus, thereby affecting the
performance of other programs on the host.

Typically, an AMD server may have 128 cores or more, while the SEV guest might only
utilize 8 of these cores. Meanwhile, host can use qemu-affinity to bind these 8 vCPUs
to specific physical CPUs.

Therefore, keeping a record of the physical core numbers each time a vCPU runs
can help avoid flushing the cache for all CPUs every time.

Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
---
 arch/x86/include/asm/smp.h |  1 +
 arch/x86/kvm/svm/sev.c     | 28 ++++++++++++++++++++++++----
 arch/x86/kvm/svm/svm.c     |  4 ++++
 arch/x86/kvm/svm/svm.h     |  3 +++
 arch/x86/lib/cache-smp.c   |  7 +++++++
 5 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 4fab2ed45..19297202b 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -120,6 +120,7 @@ void native_play_dead(void);
 void play_dead_common(void);
 void wbinvd_on_cpu(int cpu);
 int wbinvd_on_all_cpus(void);
+int wbinvd_on_cpus(struct cpumask *cpumask);
 
 void smp_kick_mwait_play_dead(void);
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f760106c3..b6ed9a878 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -215,6 +215,21 @@ static void sev_asid_free(struct kvm_sev_info *sev)
         sev->misc_cg = NULL;
 }
 
+struct cpumask *sev_get_cpumask(struct kvm *kvm)
+{
+        struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+        return &sev->cpumask;
+}
+
+void sev_clear_cpumask(struct kvm *kvm)
+{
+        struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+        cpumask_clear(&sev->cpumask);
+}
+
+
 static void sev_decommission(unsigned int handle)
 {
         struct sev_data_decommission decommission;
@@ -255,6 +270,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
         if (unlikely(sev->active))
                 return ret;
 
+        cpumask_clear(&sev->cpumask);
         sev->active = true;
         sev->es_active = argp->id == KVM_SEV_ES_INIT;
         asid = sev_asid_new(sev);
@@ -2048,7 +2064,8 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
          * releasing the pages back to the system for use. CLFLUSH will
          * not do this, so issue a WBINVD.
          */
-        wbinvd_on_all_cpus();
+        wbinvd_on_cpus(sev_get_cpumask(kvm));
+        sev_clear_cpumask(kvm);
 
         __unregister_enc_region_locked(kvm, region);
 
@@ -2152,7 +2169,8 @@ void sev_vm_destroy(struct kvm *kvm)
          * releasing the pages back to the system for use. CLFLUSH will
          * not do this, so issue a WBINVD.
          */
-        wbinvd_on_all_cpus();
+        wbinvd_on_cpus(sev_get_cpumask(kvm));
+        sev_clear_cpumask(kvm);
 
         /*
          * if userspace was terminated before unregistering the memory regions
@@ -2343,7 +2361,8 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
         return;
 
 do_wbinvd:
-        wbinvd_on_all_cpus();
+        wbinvd_on_cpus(sev_get_cpumask(vcpu->kvm));
+        sev_clear_cpumask(vcpu->kvm);
 }
 
 void sev_guest_memory_reclaimed(struct kvm *kvm)
@@ -2351,7 +2370,8 @@ void sev_guest_memory_reclaimed(struct kvm *kvm)
         if (!sev_guest(kvm))
                 return;
 
-        wbinvd_on_all_cpus();
+        wbinvd_on_cpus(sev_get_cpumask(kvm));
+        sev_clear_cpumask(kvm);
 }
 
 void sev_free_vcpu(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e90b429c8..f9bfa6e57 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4107,6 +4107,10 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
 
         amd_clear_divider();
 
+    if (sev_guest(vcpu->kvm))
+                cpumask_set_cpu(smp_processor_id(), sev_get_cpumask(vcpu->kvm));
+    
         if (sev_es_guest(vcpu->kvm))
                 __svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted);
         else
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8ef95139c..1577e200e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -90,6 +90,7 @@ struct kvm_sev_info {
         struct list_head mirror_entry; /* Use as a list entry of mirrors */
         struct misc_cg *misc_cg; /* For misc cgroup accounting */
         atomic_t migration_in_progress;
+        struct cpumask cpumask; /* CPU list to flush */
 };
 
 struct kvm_svm {
@@ -694,6 +695,8 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
+struct cpumask *sev_get_cpumask(struct kvm *kvm);
+void sev_clear_cpumask(struct kvm *kvm);
 
 /* vmenter.S */
 
diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
index 7af743bd3..8806f53ba 100644
--- a/arch/x86/lib/cache-smp.c
+++ b/arch/x86/lib/cache-smp.c
@@ -20,3 +20,10 @@ int wbinvd_on_all_cpus(void)
         return 0;
 }
 EXPORT_SYMBOL(wbinvd_on_all_cpus);
+
+int wbinvd_on_cpus(struct cpumask *mask)
+{
+    on_each_cpu_cond_mask(NULL, __wbinvd, NULL, 1, mask);
+    return 0;
+}
+EXPORT_SYMBOL(wbinvd_on_cpus);
--
2.34.1

