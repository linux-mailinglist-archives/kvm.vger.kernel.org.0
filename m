Return-Path: <kvm+bounces-47429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 41172AC182A
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:39:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50E757A513C
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 23:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DFB82D321D;
	Thu, 22 May 2025 23:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pylouOSo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBA02D29D3
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 23:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747957075; cv=none; b=GBrkvkdl1Jcc6vBkac9lX0s49v591JxiTAr/jSJOHxsZuVgL/qGL5lHPPhi4MsJSv+QyMf2CR7FGRbsTXmA6v1oY/Um/SbAw0H8Wpfgur6ZF0kKF0rAHFVj0yb6gRGxfqjzXH2VTRMlFTzSzBAVluOgxXf0GDArTi8+pVtMI78Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747957075; c=relaxed/simple;
	bh=bknyA+PyGb2jdOkVdNsNZUNIAgBV0hNEsZUHJd96il0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=geMhMAtoo5YbgYXit/02saNZfKNC/X3quzuL6QRVJCqJw/Ry+4ZJPRJ9FSTlqmWLeK+OAHRkb81x6OkeJ6Q1J3U2ngVVKDqeKYn0Or4VZ+HXllAbzJ520Dfq2cVusM0/aBRY4HQW0x7boDld/8xyNwLsw3ZgdeQHZqjs40Licys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pylouOSo; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-231d0c0fdedso51863945ad.1
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 16:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747957073; x=1748561873; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=seZN2EGAtTjhEaK9XXu9a0BU/Kezpabke/BGyffe3tE=;
        b=pylouOSozt50nOm3ZTG0whXgufYHmRmn2F8DpPPFshTiBD33myHZOTFS0YlIG0M4Lk
         v/V9ZkSn+SpLBuOHvDIr6sCK7sGkceQW5hqXzZfCVgSIUmDM3R13fZwYA+gIfmrKIYy9
         RyIt8tRxxi48dMh2AFNUYtsytE1JmeBnIsvDbE4MIh51Jrp3/rRiHQB2np8yverjyZJU
         YcGQdMLklyAKCpSXMvxo9kQstA5VadUnwJVOIVLwkb6pL+3OA7Ks7x3B19PPJpwj2TDY
         hK20l3mvrK9B7+nPFU3/RXSM/27CZbIklP/XtsoSjuBQsUPUPs7Hxjox/1uHWuHoH+32
         046w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747957073; x=1748561873;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=seZN2EGAtTjhEaK9XXu9a0BU/Kezpabke/BGyffe3tE=;
        b=K49xaYlKWdf1fZ9J60q1uMvEGg0SyBe4LIvH+Au2lMeKl9l6gnRQxlM8akEPhkd6Ku
         U9xQFwqsjapiZshLvjo94czagK95Xx86+a9QZXisWBep7avkc3wRAkqrIn9aGtMrPleL
         g+UAklNtxBO0RXhG3M76W8oyFWUdyfB1xu1BonoH1uqDnyq4gOoNYqojAeqoU/0JlgSJ
         ZAMx6qC82sjquf4WxPjXz1NRkzWYIsPEYNDiFk/fvHGUZSMfAD5yL9Q1+6BS+Ay3Vsyh
         R6ZFIevO4aRC5Lm6ZK7iDynR6thS7X1nuzVg0pK8Q+01UCETzEof61FY7NmJkS8E3C5B
         Qn0A==
X-Forwarded-Encrypted: i=1; AJvYcCVq9txekkzqy12DcJ1HR1VsZmNo0VRNoA2K9Sb2CUuCdPz0YAoXcVb945Z40XXPa+Ou1zs=@vger.kernel.org
X-Gm-Message-State: AOJu0YygUR5d2dbrPbQ/kWCtWIMXwPYKVM/1pC0/TsxXzMzEnM+uM1t/
	9gdXPKZm+aPI14R9hbb2cZiqj7OkIZNgXsVBF9WZTgDB1Ri2d44gkSRqLnkp7PRX3YpTOBZfcUu
	f2Fk/9Q==
X-Google-Smtp-Source: AGHT+IFOOrwLLJCq1Z+4dRHMqtaDLThdmKHgmx1QXHqioZeimXXjRObTtkWDRHa0hE0Qmb1cyO8UAcflGvE=
X-Received: from pjbso5.prod.google.com ([2002:a17:90b:1f85:b0:2fa:1481:81f5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ec89:b0:231:b1c8:3591
 with SMTP id d9443c01a7336-231de36bb99mr418195725ad.24.1747957073118; Thu, 22
 May 2025 16:37:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 16:37:31 -0700
In-Reply-To: <20250522233733.3176144-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522233733.3176144-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250522233733.3176144-8-seanjc@google.com>
Subject: [PATCH v3 7/8] KVM: SEV: Prefer WBNOINVD over WBINVD for cache
 maintenance efficiency
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

From: Kevin Loughlin <kevinloughlin@google.com>

AMD CPUs currently execute WBINVD in the host when unregistering SEV
guest memory or when deactivating SEV guests. Such cache maintenance is
performed to prevent data corruption, wherein the encrypted (C=1)
version of a dirty cache line might otherwise only be written back
after the memory is written in a different context (ex: C=0), yielding
corruption. However, WBINVD is performance-costly, especially because
it invalidates processor caches.

Strictly-speaking, unless the SEV ASID is being recycled (meaning the
SNP firmware requires the use of WBINVD prior to DF_FLUSH), the cache
invalidation triggered by WBINVD is unnecessary; only the writeback is
needed to prevent data corruption in remaining scenarios.

To improve performance in these scenarios, use WBNOINVD when available
instead of WBINVD. WBNOINVD still writes back all dirty lines
(preventing host data corruption by SEV guests) but does *not*
invalidate processor caches. Note that the implementation of wbnoinvd()
ensures fall back to WBINVD if WBNOINVD is unavailable.

In anticipation of forthcoming optimizations to limit the WBNOINVD only
to physical CPUs that have executed SEV guests, place the call to
wbnoinvd_on_all_cpus() in a wrapper function sev_writeback_caches().

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20250201000259.3289143-3-kevinloughlin@google.com
[sean: tweak comment regarding CLFUSH]
Cc: Francesco Lavra <francescolavra.fl@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 45 ++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index be70c8401c9b..2676be2b121d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -116,6 +116,7 @@ static int sev_flush_asids(unsigned int min_asid, unsigned int max_asid)
 	 */
 	down_write(&sev_deactivate_lock);
 
+	/* SNP firmware requires use of WBINVD for ASID recycling. */
 	wbinvd_on_all_cpus();
 
 	if (sev_snp_enabled)
@@ -705,6 +706,18 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
 	}
 }
 
+static void sev_writeback_caches(void)
+{
+	/*
+	 * Ensure that all dirty guest tagged cache entries are written back
+	 * before releasing the pages back to the system for use.  CLFLUSH will
+	 * not do this without SME_COHERENT, and flushing many cache lines
+	 * individually is slower than blasting WBINVD for large VMs, so issue
+	 * WBNOINVD (or WBINVD if the "no invalidate" variant is unsupported).
+	 */
+	wbnoinvd_on_all_cpus();
+}
+
 static unsigned long get_num_contig_pages(unsigned long idx,
 				struct page **inpages, unsigned long npages)
 {
@@ -2753,12 +2766,7 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
 		goto failed;
 	}
 
-	/*
-	 * Ensure that all guest tagged cache entries are flushed before
-	 * releasing the pages back to the system for use. CLFLUSH will
-	 * not do this, so issue a WBINVD.
-	 */
-	wbinvd_on_all_cpus();
+	sev_writeback_caches();
 
 	__unregister_enc_region_locked(kvm, region);
 
@@ -3110,30 +3118,29 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
 
 	/*
 	 * VM Page Flush takes a host virtual address and a guest ASID.  Fall
-	 * back to WBINVD if this faults so as not to make any problems worse
-	 * by leaving stale encrypted data in the cache.
+	 * back to full writeback of caches if this faults so as not to make
+	 * any problems worse by leaving stale encrypted data in the cache.
 	 */
 	if (WARN_ON_ONCE(wrmsrl_safe(MSR_AMD64_VM_PAGE_FLUSH, addr | asid)))
-		goto do_wbinvd;
+		goto do_sev_writeback_caches;
 
 	return;
 
-do_wbinvd:
-	wbinvd_on_all_cpus();
+do_sev_writeback_caches:
+	sev_writeback_caches();
 }
 
 void sev_guest_memory_reclaimed(struct kvm *kvm)
 {
 	/*
 	 * With SNP+gmem, private/encrypted memory is unreachable via the
-	 * hva-based mmu notifiers, so these events are only actually
-	 * pertaining to shared pages where there is no need to perform
-	 * the WBINVD to flush associated caches.
+	 * hva-based mmu notifiers, i.e. these events are explicitly scoped to
+	 * shared pages, where there's no need to flush caches.
 	 */
 	if (!sev_guest(kvm) || sev_snp_guest(kvm))
 		return;
 
-	wbinvd_on_all_cpus();
+	sev_writeback_caches();
 }
 
 void sev_free_vcpu(struct kvm_vcpu *vcpu)
@@ -3897,9 +3904,9 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 	 * From this point forward, the VMSA will always be a guest-mapped page
 	 * rather than the initial one allocated by KVM in svm->sev_es.vmsa. In
 	 * theory, svm->sev_es.vmsa could be free'd and cleaned up here, but
-	 * that involves cleanups like wbinvd_on_all_cpus() which would ideally
-	 * be handled during teardown rather than guest boot.  Deferring that
-	 * also allows the existing logic for SEV-ES VMSAs to be re-used with
+	 * that involves cleanups like flushing caches, which would ideally be
+	 * handled during teardown rather than guest boot.  Deferring that also
+	 * allows the existing logic for SEV-ES VMSAs to be re-used with
 	 * minimal SNP-specific changes.
 	 */
 	svm->sev_es.snp_has_guest_vmsa = true;
@@ -4892,7 +4899,7 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 
 		/*
 		 * SEV-ES avoids host/guest cache coherency issues through
-		 * WBINVD hooks issued via MMU notifiers during run-time, and
+		 * WBNOINVD hooks issued via MMU notifiers during run-time, and
 		 * KVM's VM destroy path at shutdown. Those MMU notifier events
 		 * don't cover gmem since there is no requirement to map pages
 		 * to a HVA in order to use them for a running guest. While the
-- 
2.49.0.1151.ga128411c76-goog


