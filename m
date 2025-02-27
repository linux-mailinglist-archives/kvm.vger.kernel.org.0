Return-Path: <kvm+bounces-39486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29ACEA471B8
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:53:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB1C11686A3
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EA821A3140;
	Thu, 27 Feb 2025 01:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d0K1ouEp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F30192D8A
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740620959; cv=none; b=LwoUyPn090nvscWaXebHd5vYMRnzGIRmTjlVIT4P9CZe1zJ/JdAzn41dPGezlif0EE5vEcs9KKqeh80LVuhM5A7gcTDXeZ2gBVYmh5G1CvGYC5HFSjyvoQiwPX4xgPO8ClS4eaHAYTUAf+zFePkGXgVZlxYJs0idnVElx/SCU/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740620959; c=relaxed/simple;
	bh=ZjznNdxeawcs4ehBQN14IvUeGWD7tUmkCSukq8IQXtk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iG9VooHdr3XL/esuDbZNPCyBEoT/MvJS7BBAgh0JHqfi/V615GC6ra6KOpKPfw0HPL8u3azaGPAK9DwS9bRz6fRok+a9rr4ly12DAVk0tjqYbiA4WMURbfqGMP8asnvPVPILsfajN8v57AVd0c2qaPxR+pUwTdIHstOsxY/Yur8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d0K1ouEp; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1e7efdffso1473056a91.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740620956; x=1741225756; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+fAaFYGznjHWuwCGEwUCA2tWPe6g3CNPq2rCUGtXY68=;
        b=d0K1ouEpird8L1LWt/dgiZAAcoBnqbc6UE4hKIqx+2cqZnFXIBBDzP8l4KRiXLppj5
         ieWrXcGcc3pWmgxiIIcj2B5IrYQJ+BXu/E2aFetE8UX47VAmR4leQk+zo2X8CAovA949
         13eIq28uJW7FqjMS06bDmNtFoKO0P+X3PYYXMUXdWNxP/sKMTM1zGnEvB3hqc8YHmZi7
         PLLKaYcVn8BPf0z1DWELwVL/5YhbSF44dQoW354SgLPe8nXYpEp3ROZeK7DzsUnPTgaM
         fMtJh9LBjtV6EMkR/9mdKIQV/oBOWhCgai07JMX4+r9EC2TJza89esr4lg7uk81gsxZO
         H+Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740620956; x=1741225756;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+fAaFYGznjHWuwCGEwUCA2tWPe6g3CNPq2rCUGtXY68=;
        b=ZnCDETMuDDBT3+pJU+TZrb4fDDCD/RWqW7ijf9vfjXAY5C+/CGKHYHikau8jHpwdaC
         cUYxIaOhB0YAyO3NvYs4+Wk49oYMBcWN/fSooLMzinK5ibK3O36CzOcWvs3plnDYnt6g
         Z6XsGYhn6zx9XZ44oRItb7xJkHyo1L4R1ZPOoGmpU07c+KN0Oi+UYgvUBYhYE2tG6BGT
         JLkvYY2CuUnFGhvk/2QZYuzXhTQVubW7ZyX6TW7hkhP3zn3IXEcmBvylEF+bFRD32a23
         ZhQHMnMnGJL/t9PKcGx7Tu/gOjvzLr0yOktOVW7O2HhePyly1DVyH5AJsEY1VAb3RMUY
         530A==
X-Forwarded-Encrypted: i=1; AJvYcCWsKzvAXcdcFUTt0vN99LxMIqH4hxKLhpPE2MIBFkZkq7DUSafdR1y6mTs/vxvxnbHrnlA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKvb7+iYM+nA5jc/dv3hdpZRZCVAtOnPwVmesEh5F+Lyk9iqZh
	XESxGCaV+NXeBDlIjhAn2bcjwIeMELxaJdTti2FJyGG3OEgds7d4mUZO3OySrWwYSvv5K7sESGh
	7Sg==
X-Google-Smtp-Source: AGHT+IEbQ1gQgokpG5EzaQqC9W30sV157j2cgm8ux/I9GJmzFDDxw179J+/d8wjCg+jKRuKefKs1aMX8P1M=
X-Received: from pjyd4.prod.google.com ([2002:a17:90a:dfc4:b0:2ef:8055:93d9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:6cc:b0:2ee:ad18:b309
 with SMTP id 98e67ed59e1d1-2fe68accf77mr13751734a91.3.1740620956399; Wed, 26
 Feb 2025 17:49:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:48:58 -0800
In-Reply-To: <20250227014858.3244505-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227014858.3244505-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227014858.3244505-8-seanjc@google.com>
Subject: [PATCH 7/7] KVM: SVM: Flush cache only on CPUs running SEV guest
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Zheyun Shen <szy0127@sjtu.edu.cn>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Kevin Loughlin <kevinloughlin@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Zheyun Shen <szy0127@sjtu.edu.cn>

On AMD CPUs without ensuring cache consistency, each memory page
reclamation in an SEV guest triggers a call to do WBNOINVD/WBINVD on all
CPUs, thereby affecting the performance of other programs on the host.

Typically, an AMD server may have 128 cores or more, while the SEV guest
might only utilize 8 of these cores. Meanwhile, host can use qemu-affinity
to bind these 8 vCPUs to specific physical CPUs.

Therefore, keeping a record of the physical core numbers each time a vCPU
runs can help avoid flushing the cache for all CPUs every time.

Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 42 +++++++++++++++++++++++++++++++++++-------
 arch/x86/kvm/svm/svm.h |  1 +
 2 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4238af23ab1b..b7a4cb728fba 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -447,6 +447,8 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	ret = sev_platform_init(&init_args);
 	if (ret)
 		goto e_free;
+	if (!zalloc_cpumask_var(&sev->have_run_cpus, GFP_KERNEL_ACCOUNT))
+		goto e_free;
 
 	/* This needs to happen after SEV/SNP firmware initialization. */
 	if (vm_type == KVM_X86_SNP_VM) {
@@ -706,16 +708,31 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
 	}
 }
 
-static void sev_writeback_caches(void)
+static void sev_writeback_caches(struct kvm *kvm)
 {
+	/*
+	 * Note, the caller is responsible for ensuring correctness if the mask
+	 * can be modified, e.g. if a CPU could be doing VMRUN.
+	 */
+	if (cpumask_empty(to_kvm_sev_info(kvm)->have_run_cpus))
+		return;
+
 	/*
 	 * Ensure that all dirty guest tagged cache entries are written back
 	 * before releasing the pages back to the system for use.  CLFLUSH will
 	 * not do this without SME_COHERENT, and flushing many cache lines
 	 * individually is slower than blasting WBINVD for large VMs, so issue
-	 * WBNOINVD (or WBINVD if the "no invalidate" variant is unsupported).
+	 * WBNOINVD (or WBINVD if the "no invalidate" variant is unsupported)
+	 * on CPUs that have done VMRUN, i.e. may have dirtied data using the
+	 * VM's ASID.
+	 *
+	 * For simplicity, never remove CPUs from the bitmap.  Ideally, KVM
+	 * would clear the mask when flushing caches, but doing so requires
+	 * serializing multiple calls and having responding CPUs (to the IPI)
+	 * mark themselves as still running if they are running (or about to
+	 * run) a vCPU for the VM.
 	 */
-	wbnoinvd_on_all_cpus();
+	wbnoinvd_on_many_cpus(to_kvm_sev_info(kvm)->have_run_cpus);
 }
 
 static unsigned long get_num_contig_pages(unsigned long idx,
@@ -2766,7 +2783,7 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
 		goto failed;
 	}
 
-	sev_writeback_caches();
+	sev_writeback_caches(kvm);
 
 	__unregister_enc_region_locked(kvm, region);
 
@@ -2914,6 +2931,7 @@ void sev_vm_destroy(struct kvm *kvm)
 	}
 
 	sev_asid_free(sev);
+	free_cpumask_var(sev->have_run_cpus);
 }
 
 void __init sev_set_cpu_caps(void)
@@ -3127,7 +3145,7 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
 	return;
 
 do_sev_writeback_caches:
-	sev_writeback_caches();
+	sev_writeback_caches(vcpu->kvm);
 }
 
 void sev_guest_memory_reclaimed(struct kvm *kvm)
@@ -3140,7 +3158,7 @@ void sev_guest_memory_reclaimed(struct kvm *kvm)
 	if (!sev_guest(kvm) || sev_snp_guest(kvm))
 		return;
 
-	sev_writeback_caches();
+	sev_writeback_caches(kvm);
 }
 
 void sev_free_vcpu(struct kvm_vcpu *vcpu)
@@ -3456,7 +3474,17 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 void pre_sev_run(struct vcpu_svm *svm, int cpu)
 {
 	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
-	unsigned int asid = sev_get_asid(svm->vcpu.kvm);
+	struct kvm *kvm = svm->vcpu.kvm;
+	unsigned int asid = sev_get_asid(kvm);
+
+	/*
+	 * To optimize cache flushes when memory is reclaimed from an SEV VM,
+	 * track physical CPUs that enter the guest for SEV VMs and thus can
+	 * have encrypted, dirty data in the cache, and flush caches only for
+	 * CPUs that have entered the guest.
+	 */
+	if (!cpumask_test_cpu(cpu, to_kvm_sev_info(kvm)->have_run_cpus))
+		cpumask_set_cpu(cpu, to_kvm_sev_info(kvm)->have_run_cpus);
 
 	/* Assign the asid allocated with this SEV guest */
 	svm->asid = asid;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5b159f017055..6ad18ce5a754 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -112,6 +112,7 @@ struct kvm_sev_info {
 	void *guest_req_buf;    /* Bounce buffer for SNP Guest Request input */
 	void *guest_resp_buf;   /* Bounce buffer for SNP Guest Request output */
 	struct mutex guest_req_mutex; /* Must acquire before using bounce buffers */
+	cpumask_var_t have_run_cpus; /* CPUs that have done VMRUN for this VM. */
 };
 
 struct kvm_svm {
-- 
2.48.1.711.g2feabab25a-goog


