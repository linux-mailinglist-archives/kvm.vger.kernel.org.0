Return-Path: <kvm+bounces-36211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E6E5A18996
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 02:35:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60E8E169A7F
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 01:35:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CD4514AD3F;
	Wed, 22 Jan 2025 01:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zkRWwpCc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44354C9F
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 01:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737509695; cv=none; b=mOEj7BicHQsIN0gjpFjiOWF9Fr8361BgrWiv0/Zb6aaCCjCtDV+XJ8jpolUt5ePVjcuxAVO/QpD1UnWtRX3ke6f0twvpk8hUHxOD0S4BGP3e9lcWI5l6HevBug1tHmQmdLOqE5Zi+Qe9dOVAmhMERQzj4CnVvk+Jty6OseWmQsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737509695; c=relaxed/simple;
	bh=yPf27K03/uVqqrLt0hh23/xHA+vw8UXWLwpu1KmsK20=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aiMSlFhnS5rDDxvgP76eYSjHFlL/VStLnZY4oVCb4tMieibEatyNBdxPURyIIv6qCt4hUngFb5I4zR1obOWEBn8v643acuPrp1+yEEsttHDMIo81q6fYgQe+glz6evdVJ6ZDFUR75DQfE/ir/alnOJ3ItevJ1RbuWWX0bV2OHK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zkRWwpCc; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-84cdae60616so445568139f.3
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 17:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737509693; x=1738114493; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o1kWLqC/0VVh3Ec7HiMF8h2C2kgo4gHLLUGbm+ZaoH4=;
        b=zkRWwpCcuvNVVbGhpL9KeyY7xVc9dEXdzGWaq5kePyVlXa2VBa0w9iMyQdrGPF4T7n
         8o7j+2FooYndwV4o36w8AOs7UTuADjk4gIFEXEYdYs3jAMArgoWQL2PjYK6XqQvEeyCJ
         hfSetdG7aHwG0odRP9g19GvZBRdoWtVJ4H/SCAX9S3Ld8t0LeKXsXE+dDKt8KiJRMIZe
         GuFgQGav3t/SSyFE8U82tr5RkpjFLiZfFPBU3ocA0lFmgZc0C0o3W19hQV18kU8c98Wo
         BkwZq26XzZ3k1QUxKcCc5kdwwYo50stE3koTJXTOS7hOpLoAiwIYgmRdJt7ZvYDQ/sj7
         p7ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737509693; x=1738114493;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o1kWLqC/0VVh3Ec7HiMF8h2C2kgo4gHLLUGbm+ZaoH4=;
        b=BDlhLb+xvEMGJzf52WQ5MsmyouuZaaTw3lgFtETAEgupnQuYtb9ZlLbYaacG6RWfsE
         g2fGa4cnkoUG9nGmsCR7DLnEqvWqBNcWv/P8qKizHEPwkW3t+tBvwpGruTMqUL1se/Y4
         hI1omKoy0mvoa6978Wee4o9+8D6ZGZlTEVKVBqiDrJ3lNP66uzj9vhXBTRWARrDbiemA
         EmStVo13+qVZPbeMPfk+GE3HoZDG2bLLJ0Ve+KnxXYhqa0qkVsX4+gKOX/1yV9zL+AUo
         HziXQQ24fJ1BBPQAkZ+yeoaLn4cVojfDzDwRNhAN+6829KaaWn4VwRi3og6JQiqw16gO
         gSwg==
X-Forwarded-Encrypted: i=1; AJvYcCWt4cBbNRriTrzklN39e18Ecjxy317Y0lszrDT2O/5bsQ9vLtQiC0mGzl/cR1e8iiMp5fw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlMRz0qB6euKrYZuxD1eWabyfqliuUl43aIVn+i/qYYcIt6deg
	7vj86QBVnqAjbMja5l+s6AkWLMvE1qfiF0V4VYSxmQVnnTU4xItp3JGEfCw9E2zoS/8Q1nLozQB
	l6TZVIOQUN9Cp3erF8kMPqtIsO2Qn1Q==
X-Google-Smtp-Source: AGHT+IENqNHF6TwDR2t1G9IC5SHDsRc2itu4M6ExIszwTzHYfjC1GR6kt5kh6jgzkQjyLEuQJAp1qLtl/bkYzM0VGZep
X-Received: from ios25.prod.google.com ([2002:a05:6602:7419:b0:844:d3b6:585d])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6602:3411:b0:83a:639b:bc44 with SMTP id ca18e2360f4ac-851b61733a0mr1529315439f.3.1737509692884;
 Tue, 21 Jan 2025 17:34:52 -0800 (PST)
Date: Wed, 22 Jan 2025 01:34:38 +0000
In-Reply-To: <20250122013438.731416-1-kevinloughlin@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250122001329.647970-1-kevinloughlin@google.com> <20250122013438.731416-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250122013438.731416-3-kevinloughlin@google.com>
Subject: [PATCH v4 2/2] KVM: SEV: Prefer WBNOINVD over WBINVD for cache
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


