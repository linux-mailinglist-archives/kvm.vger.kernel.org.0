Return-Path: <kvm+bounces-37011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 71A05A245C9
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:03:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B4D91889DE0
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 00:03:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37C8CAD27;
	Sat,  1 Feb 2025 00:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JYPRcO+v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A291123CB
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 00:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738368193; cv=none; b=evJGnLHDk+tRQbVMS1vf06ichpe+gIL4o0OTb30B1SJfW6M8FyDLty+kcXGDLUzfyAdh1iM4j8A5kzCIYbB5gT6HG23heZVlDzai8mN3njI2k+yo40AifK0uPJpam34SwCuqO3A+1Ax9mlTo36J2vZYcpMRnMDJ1+azPoPCWxa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738368193; c=relaxed/simple;
	bh=WVCQCd+O+0ASP0iAAFLRAMf6fTBEWgdOhE30uu1osm0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G3Yu8mAqidQtkxO+mEOfvgdfw4q6eB0gEmkmAy0/D+Cg7oGwvQrA7p+P6zXbCNo4cZJ+6Fa9o+YFyQ8OvpvMyd4io02BRU7PCssfjqzbxJs2+vjgrKQrgPgvP6kPbpMxW2P8t+i+JELWUBGzxOmdIk3h3+WycVBOFxnpqZwbYlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JYPRcO+v; arc=none smtp.client-ip=209.85.160.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-29f601b1c3cso855279fac.0
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 16:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738368190; x=1738972990; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AWCssPTtwZhYmV2JdOyYrw5kj4Hb5Puh42WXWn/vgRM=;
        b=JYPRcO+vioHWOSIyVvDio128Uoc4fjOLyoDH6JUcMXoMdgYlVNHZE2APySj1BDKoXp
         bsF1dNfQOg+LR+Gd6TEHLlcwMVsQdUOrsQDeAs9apZTL5EuoRCTC2jxLx6rFtdYXaybT
         +8xGoQ4EbX0Rp2+OwR9iYIYT8qiw/RzJG5pnZD+PgdMczNS68JzDqA+0g1YNGqN81Ffc
         7eTBbrYrG2DDiBmBLpp4CXCLZEgfDR8t4a8Z4nliJKiEy4Egf93cl0I2D2MmU5XQz2EN
         DYrDlaYAVALgFiYAd/ADsP0nYUd0Wje8heG4R9uG4ZoI8YBbQEGSvzKDjesXhKsJbZZW
         uvnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738368190; x=1738972990;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AWCssPTtwZhYmV2JdOyYrw5kj4Hb5Puh42WXWn/vgRM=;
        b=RT3+bK+6PBDboXGzeOzQX0ov+9WEC22dNTo3cTPMtq1ym2AP5ct92Ha8NwJxhHwyq5
         zPs5blhZslsajDXQ6EFaLfGac0B8L0NAfEjoemvMunBs7wlQzSqjq0IKXGJoFmbxCh1M
         nQSzsLkre7zR5kF38udTTJtqYXRd6cnqAj1hvXiGUQ7ndHk6d9mZ4KWjsI4n4EtlmGBG
         xwRIG1YsDVCLBFmH53P5hB+b5TDteXS7EFOlTPZ0YPsVVVkKzIkb1feBbLo5vFq8bDQ2
         lbBzcwrMSjDbSqCEJKTKRiCVHy93zOpM3NXoxoDyiZYvdk/kNrCZ0/DAP1MT15zms3L5
         2cRA==
X-Forwarded-Encrypted: i=1; AJvYcCWKT/nzCqLVKCSYPLDwJc2ebkfnxuxbN8aQ7zHpGqE4LHBfa7j4zd8544tU30tJUpv8+2Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwI/1A2PJIgv1QhBMzREyhF18BZRlEB4n5UFV3cRfV1kY/DovqY
	49teAf95OU92KknX3JaG1M6km9V7OVlGtF1iAltO9C57m90NXkIEgZGfebeniCCDoO794vvPpq1
	7mrQKObxe2ETfNmYN9lzAGBeEAwuDhA==
X-Google-Smtp-Source: AGHT+IEe6Cm/cr1UFpsMwadljWsRlzohbdqDYjO+KCnYJdwNZOHhW8vmBkDqLOHb98N+kkT9tbXU3XvLpLYiCABZG7va
X-Received: from oacny5.prod.google.com ([2002:a05:6871:7505:b0:2ae:bdb:eb0])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6870:ae87:b0:29e:4bc4:97ca with SMTP id 586e51a60fabf-2b32f12d6camr8056186fac.21.1738368190657;
 Fri, 31 Jan 2025 16:03:10 -0800 (PST)
Date: Sat,  1 Feb 2025 00:02:59 +0000
In-Reply-To: <20250201000259.3289143-1-kevinloughlin@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250123002422.1632517-1-kevinloughlin@google.com> <20250201000259.3289143-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201000259.3289143-3-kevinloughlin@google.com>
Subject: [PATCH v6 2/2] KVM: SEV: Prefer WBNOINVD over WBINVD for cache
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
2.48.1.362.g079036d154-goog


