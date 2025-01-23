Return-Path: <kvm+bounces-36309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D2BEA19BC0
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 01:25:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1A2E3A3D60
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 00:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA5B325632;
	Thu, 23 Jan 2025 00:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fJlZbRqB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6971E535
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 00:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737591874; cv=none; b=u61fx88foHKHogP38cX6OwTLw3Lqg/EK4oyZSMa7/nMm/GLuvqo4y0mU5Uw9HQ4f0C4aDzwPR3MjdTZqGzTFqWauE9egpahsR1vyFID2Epv2m9pwqQ6hob8D7AVQSuDcmk++nL4dWT0nQ5h0lueZNJkGz9XOHYGMYk0UWWuCBPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737591874; c=relaxed/simple;
	bh=yPf27K03/uVqqrLt0hh23/xHA+vw8UXWLwpu1KmsK20=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iv/STj6ZOqXwglhlw75oSSAeW7HhSSzysxvRazYmcYyZdK8/bC2I+6X5CxCDHhCQTVwCZgZfQLLEzOd59A03wwp4Nm6a8g6nTl9dmBPO7JE9ydJm65BXEfZZzLUe8LwXPpnWv4sTSVlyikNNQymm+PPGcAAEq+JhWC0C4rEOHMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fJlZbRqB; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3ac005db65eso2601135ab.3
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 16:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737591871; x=1738196671; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o1kWLqC/0VVh3Ec7HiMF8h2C2kgo4gHLLUGbm+ZaoH4=;
        b=fJlZbRqB6o1ujqqWBbLEGeFk85CSemAgSvwjOXV4yPK0S2yPsr5eVn8SJ6Dsu6GAZw
         k5SsP0CqBMA0GFcJR1tCvcdJDWJMouYkwnbkS2oiAHU7NgzDvN7q3qaL3I7Ebvj4zUNY
         foz4V5iIu7gGb8YU9j+rN+cyOFmKjNnUVzWoxIOodvoRKW/HRafmjFN4c+1zsQC3StdG
         JWaM14sK0ESxbXHY0s2NMs4C9UCP8xdyT5Qf2TZl0N/AzXOe5s99mNbddBnh8J8znoC9
         2tpTTHWpW5JPNdCnAinHhdGPrgFawg4t/NI48echmbwkrVmBvUoZodtF6Khg3pd+wmSe
         O4cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737591871; x=1738196671;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o1kWLqC/0VVh3Ec7HiMF8h2C2kgo4gHLLUGbm+ZaoH4=;
        b=wtogtZzQQNF/bHukr6JXUgoROYOQbgp7X6MWIlkHwhg+o08K7hMGXLt7uZWGJ7U7kx
         qcFXlieEf5piu3S7OcHAXdD+wWz6AfxvMnW7/tJmDpOLHHTjar1446yQ/r+mMJaigsMC
         Y8D3gfCDEM5XxT6aWAuBt16q1mL/ljyS+0RGOCc4B1M1TCEJDuAi/6r7FAzyIsZN9xoo
         aSNs2ErYFMrI0lJsIkIdqxGLU5gzd580dullhhJ7j9fXlTpzv86NeoYpaLuAimIA2UZr
         Kaxuix5smpANxBbTohuAofqqZDkjwW9yoUlIk4tYK2HRo0EMYWFrv5/GC/fL/Po854qc
         sWpA==
X-Forwarded-Encrypted: i=1; AJvYcCUj+0zOkGR5sAeKa5K0Nxgq5FH9ePUU6m2IXcjmmqtaE/tbc9PAzeOyUE2pQz321tnLPm4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtRa8V3REbKDt2OZ/Rn9rqsUyRLEfGMVpJnNqzbOgqEzeIXxDl
	qYWyVu56bATzAL9kUwHwPk+bk/g5AJgqH9yRmN7oeuQ35A5zt8OIDENmW0d+B9K0Xvz72AWvay3
	s2Ia6gTQWSXdM3ETl8307XWwImL1dlw==
X-Google-Smtp-Source: AGHT+IEXuH5osyQosE9ETFSAKWfy85ZILThMDDuTJ59nPcAtkDwqvBrEyFsN0vFN8Vqt746WqYCwBgn8KqlyrLpnM3dJ
X-Received: from jabkw23.prod.google.com ([2002:a05:6638:9317:b0:4e2:d072:3b50])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1b04:b0:3cf:b982:1a70 with SMTP id e9e14a558f8ab-3cfb9821d3bmr26155145ab.10.1737591871382;
 Wed, 22 Jan 2025 16:24:31 -0800 (PST)
Date: Thu, 23 Jan 2025 00:24:22 +0000
In-Reply-To: <20250123002422.1632517-1-kevinloughlin@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250122013438.731416-1-kevinloughlin@google.com> <20250123002422.1632517-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250123002422.1632517-3-kevinloughlin@google.com>
Subject: [PATCH v5 2/2] KVM: SEV: Prefer WBNOINVD over WBINVD for cache
 maintenance efficiency
From: Kevin Loughlin <kevinloughlin@google.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, seanjc@google.com, 
	pbonzini@redhat.com, kevinloughlin@google.com, 
	kirill.shutemov@linux.intel.com, kai.huang@intel.com, ubizjak@gmail.com, 
	jgross@suse.com, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	pgonda@google.com, sidtelang@google.com, mizhang@google.com, 
	rientjes@google.com, manalinandan@google.com, szy0127@sjtu.edu.cn
Content-Type: text/plain; charset="UTF-8"

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
---
 arch/x86/kvm/svm/sev.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index fe6cc763fd51..f10f1c53345e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -116,6 +116,7 @@ static int sev_flush_asids(unsigned int min_asid, unsigned int max_asid)
 	 */
 	down_write(&sev_deactivate_lock);
 
+	/* SNP firmware requires use of WBINVD for ASID recycling. */
 	wbinvd_on_all_cpus();
 
 	if (sev_snp_enabled)
@@ -710,6 +711,16 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
 	}
 }
 
+static inline void sev_writeback_caches(void)
+{
+	/*
+	 * Ensure that all dirty guest tagged cache entries are written back
+	 * before releasing the pages back to the system for use. CLFLUSH will
+	 * not do this without SME_COHERENT, so issue a WBNOINVD.
+	 */
+	wbnoinvd_on_all_cpus();
+}
+
 static unsigned long get_num_contig_pages(unsigned long idx,
 				struct page **inpages, unsigned long npages)
 {
@@ -2773,12 +2784,7 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
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
 
@@ -2899,12 +2905,7 @@ void sev_vm_destroy(struct kvm *kvm)
 		return;
 	}
 
-	/*
-	 * Ensure that all guest tagged cache entries are flushed before
-	 * releasing the pages back to the system for use. CLFLUSH will
-	 * not do this, so issue a WBINVD.
-	 */
-	wbinvd_on_all_cpus();
+	sev_writeback_caches();
 
 	/*
 	 * if userspace was terminated before unregistering the memory regions
@@ -3126,16 +3127,16 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
 
 	/*
 	 * VM Page Flush takes a host virtual address and a guest ASID.  Fall
-	 * back to WBINVD if this faults so as not to make any problems worse
+	 * back to WBNOINVD if this faults so as not to make any problems worse
 	 * by leaving stale encrypted data in the cache.
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
@@ -3144,12 +3145,12 @@ void sev_guest_memory_reclaimed(struct kvm *kvm)
 	 * With SNP+gmem, private/encrypted memory is unreachable via the
 	 * hva-based mmu notifiers, so these events are only actually
 	 * pertaining to shared pages where there is no need to perform
-	 * the WBINVD to flush associated caches.
+	 * the WBNOINVD to flush associated caches.
 	 */
 	if (!sev_guest(kvm) || sev_snp_guest(kvm))
 		return;
 
-	wbinvd_on_all_cpus();
+	sev_writeback_caches();
 }
 
 void sev_free_vcpu(struct kvm_vcpu *vcpu)
@@ -3858,7 +3859,7 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
 		 * guest-mapped page rather than the initial one allocated
 		 * by KVM in svm->sev_es.vmsa. In theory, svm->sev_es.vmsa
 		 * could be free'd and cleaned up here, but that involves
-		 * cleanups like wbinvd_on_all_cpus() which would ideally
+		 * cleanups like sev_writeback_caches() which would ideally
 		 * be handled during teardown rather than guest boot.
 		 * Deferring that also allows the existing logic for SEV-ES
 		 * VMSAs to be re-used with minimal SNP-specific changes.
@@ -4910,7 +4911,7 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 
 		/*
 		 * SEV-ES avoids host/guest cache coherency issues through
-		 * WBINVD hooks issued via MMU notifiers during run-time, and
+		 * WBNOINVD hooks issued via MMU notifiers during run-time, and
 		 * KVM's VM destroy path at shutdown. Those MMU notifier events
 		 * don't cover gmem since there is no requirement to map pages
 		 * to a HVA in order to use them for a running guest. While the
-- 
2.48.1.262.g85cc9f2d1e-goog


