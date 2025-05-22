Return-Path: <kvm+bounces-47430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 39F49AC182C
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:39:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 579C07A5415
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 23:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C7302D3A6F;
	Thu, 22 May 2025 23:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CWGUyIll"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2752D3210
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 23:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747957076; cv=none; b=iSvtBj8UezCfV7JHIW6aueFbJcYgRfG9dQBqYqrl/dOJIyLICGoKoyLOg7y9LsVqRVbB/c3o/Dj667ZOXn73aInkovEew4OLwBr2LYw6Pd8NroAlbzBcBgJQ5GnOG5i44lCIjAQ+xEXgPlT+cbEPa4pw7ANC1NKv/8e6qr0wRSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747957076; c=relaxed/simple;
	bh=EJSWXtll+OllBjJufDyDEa/BI4x/BrdIZLYuFPsRMNI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SCGbI4ggZhn5tg0V/QRVo+yEOObzYfOH5vMeNY3wzxt0e34uAHIHbMTgDOweKnFzMf1A7qBIHl4wBttnn8fpvT9sFxsIP7ddBSqOOCg+cdp7SdDdxOE3SilTxF+QyKmnL+rb8cPopKYEGyseMZuZq9K+tyqguzqe0k+asiianR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CWGUyIll; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30ec5cc994eso4767466a91.2
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 16:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747957075; x=1748561875; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=f9Xn4KYWiGCbjLdjL8speXTpf75EGP3mA2cTcsP7kRE=;
        b=CWGUyIllGTIwpPH7p8CFIjoEkt97HcqLw5uADcx4SE614xhGo/A3c1Yu3oMzqJFDcf
         D9FnC31gdE7Sa0tSdvBo5t+zeuYRTGvmuiEnD0X9batPtvloRWgtGMS3uEhFepeSTDoz
         q4Q1egFeKDi7/wQyjMeHKTIImzG5btcewh579SpZBwpG3By6kk1dJsU/O+M5NH0wfBhd
         QlktKvBMZCEeCsfVSlJQsl40X7IQn08vlhmMll+xJino3L6U/xla0cnrUXo2Gu2q1a/s
         7DTajzFlGYWDN6NQ/KW6zXK9MHTAGWXGM9vFjSTjaw8dYCIeqwph55fa6+h2FFFj7Trv
         24dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747957075; x=1748561875;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f9Xn4KYWiGCbjLdjL8speXTpf75EGP3mA2cTcsP7kRE=;
        b=P2upvaYA0aGsuov1TmY/2a2cU/RLU1VOKSl5eQcmFb7C7ArPRXtOPXFH91yePavQch
         cvPkyzHBLVzNNolEmUa3ULEcP8xHh2qCwl0uWLyZ9UhU++qYMjwi4rqzqlGIGXpX93KX
         G0NtwB6xIpBzwpAmJfHtLB6wyLg8dEGrjZkdvZ8Lh3QMt9lwyrAxaMyfG4aSsibJxNJL
         yz+g4+WzbUHKiD+7QQvU++qTeEeMfnOdRdkLZhdh7FTg2nT2OlQyEVH1uY2Hc56zlOqh
         yNtZN8NF3tX5wsbLaMD/CwqjxPiGp6vctAyntNiFmcW5++2R0Dbzr3SG/7V58p5frp3S
         j/nQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3308gFJk+fx1f8OaqSEi+K7dtPw7/gpQKHBwR+gERZ3OAYLKhkidqWM6OZcbsoXVzjAo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUO5TXYIAStaqIQfSU0hk3WrUEjfiSL8HDLNYoTQcAbO0L5W73
	lYddh7+GKg30tDG+0hE9Z58CYhfnOoUzoGhqE95mZRsdQbBZJpOkaj1I9OwMUOToJEn+XxAXpIb
	jUrwnxw==
X-Google-Smtp-Source: AGHT+IF5Lb8CXIC70Vyva66+17O+yrwnyFqJbN7erK3jdHXzkFdxO3FG0VdX++4AGAOrzJkMYErRjBNX2mI=
X-Received: from pjg13.prod.google.com ([2002:a17:90b:3f4d:b0:2ee:4a90:3d06])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f4c:b0:2fe:994d:613b
 with SMTP id 98e67ed59e1d1-30e7d5be445mr37978564a91.35.1747957074752; Thu, 22
 May 2025 16:37:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 16:37:32 -0700
In-Reply-To: <20250522233733.3176144-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522233733.3176144-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250522233733.3176144-9-seanjc@google.com>
Subject: [PATCH v3 8/8] KVM: SVM: Flush cache only on CPUs running SEV guest
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, Kevin Loughlin <kevinloughlin@google.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Kai Huang <kai.huang@intel.com>, 
	Ingo Molnar <mingo@kernel.org>, Zheyun Shen <szy0127@sjtu.edu.cn>, 
	Mingwei Zhang <mizhang@google.com>, Francesco Lavra <francescolavra.fl@gmail.com>
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

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 46 +++++++++++++++++++++++++++++++++++-------
 arch/x86/kvm/svm/svm.h |  1 +
 2 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2676be2b121d..c3ddcca9fdce 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -446,7 +446,12 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	init_args.probe = false;
 	ret = sev_platform_init(&init_args);
 	if (ret)
-		goto e_free;
+		goto e_free_asid;
+
+	if (!zalloc_cpumask_var(&sev->have_run_cpus, GFP_KERNEL_ACCOUNT)) {
+		ret = -ENOMEM;
+		goto e_free_asid;
+	}
 
 	/* This needs to happen after SEV/SNP firmware initialization. */
 	if (vm_type == KVM_X86_SNP_VM) {
@@ -464,6 +469,8 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	return 0;
 
 e_free:
+	free_cpumask_var(sev->have_run_cpus);
+e_free_asid:
 	argp->error = init_args.error;
 	sev_asid_free(sev);
 	sev->asid = 0;
@@ -706,16 +713,31 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
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
+	wbnoinvd_on_cpus_mask(to_kvm_sev_info(kvm)->have_run_cpus);
 }
 
 static unsigned long get_num_contig_pages(unsigned long idx,
@@ -2766,7 +2788,7 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
 		goto failed;
 	}
 
-	sev_writeback_caches();
+	sev_writeback_caches(kvm);
 
 	__unregister_enc_region_locked(kvm, region);
 
@@ -2914,6 +2936,7 @@ void sev_vm_destroy(struct kvm *kvm)
 	}
 
 	sev_asid_free(sev);
+	free_cpumask_var(sev->have_run_cpus);
 }
 
 void __init sev_set_cpu_caps(void)
@@ -3127,7 +3150,7 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
 	return;
 
 do_sev_writeback_caches:
-	sev_writeback_caches();
+	sev_writeback_caches(vcpu->kvm);
 }
 
 void sev_guest_memory_reclaimed(struct kvm *kvm)
@@ -3140,7 +3163,7 @@ void sev_guest_memory_reclaimed(struct kvm *kvm)
 	if (!sev_guest(kvm) || sev_snp_guest(kvm))
 		return;
 
-	sev_writeback_caches();
+	sev_writeback_caches(kvm);
 }
 
 void sev_free_vcpu(struct kvm_vcpu *vcpu)
@@ -3472,6 +3495,15 @@ int pre_sev_run(struct vcpu_svm *svm, int cpu)
 	if (sev_es_guest(kvm) && !VALID_PAGE(svm->vmcb->control.vmsa_pa))
 		return -EINVAL;
 
+	/*
+	 * To optimize cache flushes when memory is reclaimed from an SEV VM,
+	 * track physical CPUs that enter the guest for SEV VMs and thus can
+	 * have encrypted, dirty data in the cache, and flush caches only for
+	 * CPUs that have entered the guest.
+	 */
+	if (!cpumask_test_cpu(cpu, to_kvm_sev_info(kvm)->have_run_cpus))
+		cpumask_set_cpu(cpu, to_kvm_sev_info(kvm)->have_run_cpus);
+
 	/* Assign the asid allocated with this SEV guest */
 	svm->asid = asid;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f16b068c4228..45d564c674ef 100644
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
2.49.0.1151.ga128411c76-goog


