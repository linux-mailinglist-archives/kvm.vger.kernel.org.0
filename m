Return-Path: <kvm+bounces-39483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D6FCA471B3
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:53:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14022165E51
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2245017A2FC;
	Thu, 27 Feb 2025 01:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yvx+w/0c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C537D1632F2
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740620953; cv=none; b=kM7yoCrUU8txhXBVqLwDnftwvhembD6VBS3FMiSywSQMq+zbiA1cZ2+hZdzVV0L5r95zxOkPUtkog3s3a3Yjlrs+JqqC8my+/a/lrVIdSyTsA2jz9yN4Mp/QpvahF1l9zBO0yxUhtENrQhL+S+jISqkvSdcjP803LoHsEf7HW+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740620953; c=relaxed/simple;
	bh=DfYvZ5Mm0h+MWifbIAedzEkieOfAgd0J2MF+dMGDucI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P/3wshqgwldNJyvIRPZ3kWaCjZFoOmY97IrQUBulhwtKYUXeJ7nd8EQIfyQl3L/CkvsDVAXTUmQsBvQC5ZGoiLXVjgTT049ak+ccODJGEYbVSw7JPt1AYJk0aZNcYHCr0YvWizSaYTmzdDZlfbnWlmhbiaLFQPYd+5omOFoGL0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yvx+w/0c; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2233b154004so8916825ad.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740620951; x=1741225751; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TR4IeDnNClz6+x5842imtnuCjIWUrPGC6Tw25Ns6uLw=;
        b=yvx+w/0crUXCD0OqZ/CPGrDgDHcvbp2WY9Dew1AA+dEWg199FEzaYMcYC8RkLwii/S
         SZlLVqHbhRckN8/BCVkTporXP9WUYBXrgoFcXJkYhTekO/KYyw85R4siPIzop9VTBg5e
         t1A/Qg2P6IlkTQssU0ehy/XmIyXRXrfcKpj5X1UMDhJb8HN8poFz7fNVp9CyMo8TLY6V
         jSuGNsKubCzSUCx7ZrJYzFDpIw8lnxWMpNxotTMYbEiEL8CoygTGXsKLsOzFESAlbL1I
         niTQG/GogYaDCXFqHw1Lyxe6cRlxL3DxyryCB6mLTbcvD1BW7r0InM3eMqAPIX2oU2d1
         aewg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740620951; x=1741225751;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TR4IeDnNClz6+x5842imtnuCjIWUrPGC6Tw25Ns6uLw=;
        b=wAFnUizcfO8Iv+S3tqBUpNQEPUCf/NqG+wImSD3GDZ7O28VIY+mveTcL+wYohkaymj
         20RdIl6KYPcZewBAIx+tGrPuJAfr/09UsXi5vtTsFuGfpArZZzUK6YmvR/vmoVunizXh
         tUAuPD+fTwLeuE+ru/u/XeHatp5gu1Mz4l5XdKOxEAwmml2jcia11OkIQdx4mC+nTIOA
         bURR20CB8RZ82Azei+fknNA2p6Yw79gvE1+SAkV6Aymqtz9kTrLAXbULTJp68lOEUEI+
         bwc6zcwk8ZsHaDohKHNpCrceCz7miGIEJvWqpfiMcTpc5RuLPZsZnz8xgFvqtlO4XKBd
         ebXA==
X-Forwarded-Encrypted: i=1; AJvYcCWJFNSXCwoKUBjAmtr7cf6OijVssL/6YV8S3f47bnaszlcXAVTrA3/Ifb9pB7e7bK6kHaI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyin2oNSAdCdhVvunSXkNtQGJBZP157MbxWnjy9JqlJxw2SrTEd
	FVK5wHFfehkjuPJXhbhwwyWGwe14j2QYP9kUYZGdIMSAWKOfWliBtWnHAAVVkxVIeLVs60vXmni
	e8w==
X-Google-Smtp-Source: AGHT+IGD//k8iz98CkPPC/4d9y2zUzbB/Sbo83vNGoT7wE075VyBluONQFVEM/j9i7oxwwVwWqKwPa4RqRM=
X-Received: from pjc12.prod.google.com ([2002:a17:90b:2f4c:b0:2e5:5ffc:1c36])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:18f:b0:220:c9e5:f94e
 with SMTP id d9443c01a7336-223200b2f02mr96564955ad.23.1740620951184; Wed, 26
 Feb 2025 17:49:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:48:55 -0800
In-Reply-To: <20250227014858.3244505-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227014858.3244505-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227014858.3244505-5-seanjc@google.com>
Subject: [PATCH 4/7] KVM: SEV: Prefer WBNOINVD over WBINVD for cache
 maintenance efficiency
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Zheyun Shen <szy0127@sjtu.edu.cn>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Kevin Loughlin <kevinloughlin@google.com>, Mingwei Zhang <mizhang@google.com>
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
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 43 ++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d934d788ac39..4238af23ab1b 100644
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
@@ -3856,8 +3863,8 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
 		 * guest-mapped page rather than the initial one allocated
 		 * by KVM in svm->sev_es.vmsa. In theory, svm->sev_es.vmsa
 		 * could be free'd and cleaned up here, but that involves
-		 * cleanups like wbinvd_on_all_cpus() which would ideally
-		 * be handled during teardown rather than guest boot.
+		 * cleanups like flushing caches, which would ideally be
+		 * handled during teardown rather than guest boot.
 		 * Deferring that also allows the existing logic for SEV-ES
 		 * VMSAs to be re-used with minimal SNP-specific changes.
 		 */
@@ -4905,7 +4912,7 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 
 		/*
 		 * SEV-ES avoids host/guest cache coherency issues through
-		 * WBINVD hooks issued via MMU notifiers during run-time, and
+		 * WBNOINVD hooks issued via MMU notifiers during run-time, and
 		 * KVM's VM destroy path at shutdown. Those MMU notifier events
 		 * don't cover gmem since there is no requirement to map pages
 		 * to a HVA in order to use them for a running guest. While the
-- 
2.48.1.711.g2feabab25a-goog


