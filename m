Return-Path: <kvm+bounces-46889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 007EFABA539
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:32:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89E814A735B
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2AC52836B5;
	Fri, 16 May 2025 21:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sqT+I+ep"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F7D283147
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 21:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747431020; cv=none; b=QYr0WNS+QFx1dYtKka6ZnkyTZqliKCruFNpwAMl+eIMA14I3qxc0YXNb+0zktfR6RzsaCIeX+pMzLcuN2dTDCOx5Z05APK5vk3w2yRdqw20iw5+YVA86dvP83TBHKtOJKWjPSe052hKbe4hF4lvHfQwk25zUU9zlnxlDYOox2f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747431020; c=relaxed/simple;
	bh=9gjRLei6v1SxXphoOx9HIqBlLl2425GFsp2GVeMc6XM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ejJRzBdWL7/pVSnTlNp6xVci6PUhuwiguL3kEfXFSxHCt7zIkISi1YUSBqD6Rg/rrOpZ5bz04oZ+SI71hxh07ip284g5HHFspM0czmu/DRRBqIkdKjSkrGeLyXqudcp7pL0Es+LN1Xev6eiQF29W4VBZ01uAdyl+UYZnhszejAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sqT+I+ep; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e896e116fso741127a91.2
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747431018; x=1748035818; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SXRj+NGuc6iHnmhzt+utocsfWr9n0NYuxoyZ1Z1GpaI=;
        b=sqT+I+ep5uO8mvrrkLJ5c+S5nHhqEt3jF7Gwmy1nacZ5/y6MXulRf0CmwONxdUCpMC
         2bSioLGHT/1SHiZYqf7V7rPuZXpjZVopdQ9xEjECdF9cyqnURI4V+ndmOtuZ5ur1xmcs
         Z5PhY89FnSThmwl0R1YhV0PLBSSjePbKztTf6IiJZRKHpaynOtz2Dhg4aaTGcBXRY+ms
         /Y51Ue9GgBDYQODgFFhaRrOO6vGyVBWxmmiNS+6Nn9i45UEPux13bJIVKUKIoi8dYtvK
         fUZiGDfFIh7uIK8Hr3ZdYtKqXucs0uA/4v8jeRuquN/dcIIwZO2CWUEZ1LQi8vuJRwh+
         PL1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747431018; x=1748035818;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SXRj+NGuc6iHnmhzt+utocsfWr9n0NYuxoyZ1Z1GpaI=;
        b=rNx5oSsdNTIVY4cWtS80W9ExT36ULwdSI6nCxQpLsr00EneMSkg6mbHnOMMkAHYx2X
         KUcOtmbTTPcEOmSBwtLCS58w6/QKxr8FcmY7ORYLHkwj7E0mM6S1TRQbLT7ONA9C6POL
         BcPKoF2sAti++906w8+qyYS+Cu2D6x9AvoF4hdrLYWDXWg+UIG7fL73uHbqnCBa1ojzh
         zVRYTsz2peMSYcsBZjBCMUfs0T5jQmb60DG5LgeiILmOxjcy2EFBBXJFq9WV3L78tIjr
         ykXsfRI4+4qSaxkMon2g6KGQ50emXSfZYki2sV9kX8llWRGQ4plXKav7GdzpUJ/f6kzq
         2Icg==
X-Forwarded-Encrypted: i=1; AJvYcCUWVXdgmuIDI9MMcDawTZY8UNEj/rN8WF93PXWaz7lt8KLktKfVbBtRWR89JCaKfjYLFhA=@vger.kernel.org
X-Gm-Message-State: AOJu0YztTOsnrlCVNVBW+6eCJMu8Sm2mqA02R8uFaLJe0nYZy7e6vSiH
	ZX3D2fKcRqTmds1an7DZLofc4WKbA7aps4HLqIBKlvudEaWQZVWXa9KqmMZogJCSbGMkI4JuKjp
	NN6eJ7A==
X-Google-Smtp-Source: AGHT+IHYL3O/Cbv2jm09q+kj8jdu7I3+wzJtsaAiUexntrMOt9TdJlvYVGl+QVySwxtGwHh68HxcdY/49Ac=
X-Received: from pjg13.prod.google.com ([2002:a17:90b:3f4d:b0:301:1bf5:2f07])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2c85:b0:30a:2196:e654
 with SMTP id 98e67ed59e1d1-30e8312bb11mr6078548a91.15.1747431018405; Fri, 16
 May 2025 14:30:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 14:28:33 -0700
In-Reply-To: <20250516212833.2544737-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516212833.2544737-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516212833.2544737-9-seanjc@google.com>
Subject: [PATCH v2 8/8] KVM: SVM: Flush cache only on CPUs running SEV guest
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, Zheyun Shen <szy0127@sjtu.edu.cn>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Kevin Loughlin <kevinloughlin@google.com>, 
	Kai Huang <kai.huang@intel.com>, Mingwei Zhang <mizhang@google.com>
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
 arch/x86/kvm/svm/sev.c | 46 +++++++++++++++++++++++++++++++++++-------
 arch/x86/kvm/svm/svm.h |  1 +
 2 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9dcdeea954d3..e40fb2105dbc 100644
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
@@ -708,16 +715,31 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
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
@@ -2770,7 +2792,7 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
 		goto failed;
 	}
 
-	sev_writeback_caches();
+	sev_writeback_caches(kvm);
 
 	__unregister_enc_region_locked(kvm, region);
 
@@ -2918,6 +2940,7 @@ void sev_vm_destroy(struct kvm *kvm)
 	}
 
 	sev_asid_free(sev);
+	free_cpumask_var(sev->have_run_cpus);
 }
 
 void __init sev_set_cpu_caps(void)
@@ -3131,7 +3154,7 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
 	return;
 
 do_sev_writeback_caches:
-	sev_writeback_caches();
+	sev_writeback_caches(vcpu->kvm);
 }
 
 void sev_guest_memory_reclaimed(struct kvm *kvm)
@@ -3144,7 +3167,7 @@ void sev_guest_memory_reclaimed(struct kvm *kvm)
 	if (!sev_guest(kvm) || sev_snp_guest(kvm))
 		return;
 
-	sev_writeback_caches();
+	sev_writeback_caches(kvm);
 }
 
 void sev_free_vcpu(struct kvm_vcpu *vcpu)
@@ -3476,6 +3499,15 @@ int pre_sev_run(struct vcpu_svm *svm, int cpu)
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
index e6f3c6a153a0..a7c6f07260cf 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -113,6 +113,7 @@ struct kvm_sev_info {
 	void *guest_req_buf;    /* Bounce buffer for SNP Guest Request input */
 	void *guest_resp_buf;   /* Bounce buffer for SNP Guest Request output */
 	struct mutex guest_req_mutex; /* Must acquire before using bounce buffers */
+	cpumask_var_t have_run_cpus; /* CPUs that have done VMRUN for this VM. */
 };
 
 #define SEV_POLICY_NODBG	BIT_ULL(0)
-- 
2.49.0.1112.g889b7c5bd8-goog


