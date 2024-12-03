Return-Path: <kvm+bounces-32866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C76819E1092
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 02:00:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CAE528165C
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 01:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FE1C4F218;
	Tue,  3 Dec 2024 01:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bGNGE+sy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB49288DA
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 01:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733187631; cv=none; b=dNfCfX0MgSunQnrW2wAmxDZDavmHRcKQJNftcBECc02ODOeLXYjKXjgnH+x/xFAVIGZu2idNE8/G7zENDp/avECD8uL6erpvP2iHGnKdSyoymAAw9rG6u+AU+ALhGJOqkDBT7Yiwjdl2Dv0puQKCCu669YBjZW/QwJIVF7N1gQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733187631; c=relaxed/simple;
	bh=xMS1uH7AFuF+2czM41v55mFLwPP1FGhTkUrAHqIpFLQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SFti2vd2KgkuOxpLWCL7h8f2Sjf6XujIeMcYjkFSrpYoxn/6ac574Yir34jlVx087386Xd52ksvSPanjE74EkwocFj9VRDPXo+Zf7VsIHLX4YsuIITxwB0nB0PhJol9kNA+MwpbFhnrasVUuEatlHw2hj/2QyD7a3REIp2vMX8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bGNGE+sy; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-8419aa46a87so501818039f.2
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2024 17:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733187629; x=1733792429; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HXZpw0j64Kx8pQRMw/cVhgPa64V3XlxKoRy53BFPQ2Y=;
        b=bGNGE+syU6EU8nH8CsTHcbpa3ZrmXan1SGoQgctp1qlcRbPKbhG3WjQ7cUxCSVPfxw
         xA3iDmmjKYLGEJAOKuAUGPtFQcSDLUeRU0Rw0Mcf+O0yiwA694dp0zT6bVqWqZ8Vjohu
         Xfyf2FmD0KVbshy3NyEBFzjFAGIt3pqzuzKlTre2THpvP+7RXV62OXMtBBtaT13NOh6y
         6kyxOh/s0RFS83XPdzZXzUx6DHMQWWouqXhjHc7CgGuVhxR+2JZstufGZ+5j1Q95fhwf
         f/AXpdLwBlab1JMNXv267CFWsUYJTCh8ZfmQflWpLNZdAhrTRF4GHuz9Xq0AlLoo7O9c
         6DYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733187629; x=1733792429;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HXZpw0j64Kx8pQRMw/cVhgPa64V3XlxKoRy53BFPQ2Y=;
        b=rJuixLG0ya/ESp2Bi1SiTUqDujPTOidPpVL/mtJz87yBnBSSrXCvNEY02moU8vHswV
         7xUXUeTlXC6uYLjpJ+1qEayuM2ptAIK7gPDeo+Np5dhmduVULy4OsouxaZLCwRt97MBH
         qPNY3a6JyCSZ4OodmwtLRn6SWlDJDeirllTKuNar0FJno31KOpXCWFguCv1/nCimobAN
         rdhA1dOcGvWDdeKli1B6D5U+HnxvBQxMWG7WgHwPuQIgMkOlO+55zE+Pz2b61QropWBi
         vuV6dhxN3kKTVsoDCknZ5drHycXOxt7WOk2TNVTd81unbvRwmewBYVK/VbdoIo7EC+OS
         41DA==
X-Forwarded-Encrypted: i=1; AJvYcCVQ62flRaZAxzKCRjt+o65CFgdvIcC83Soj+O7L/UFm32HGYK/zYUYSJtqFCiDt3wP/yAU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiYA1XbafoE7+utBW5UmzUl6AhuwIkvmNbqzQGnYeVxFwbCncX
	6NpMFHPTdXeBPPV5hKc1tm73f3hW8DRAYmP7lZBVhdXpbG53Az1aqQCCWlyY88uD4W6XNiDMvtz
	ostxRiPia+L14NKj2BjIy7V1StwMKoQ==
X-Google-Smtp-Source: AGHT+IEZmspYrC4umegddmCrbePNuN6PHswfr1n3f4QWHFbbvkBj0Jxf86Z77+97glx5zKlFrBkgAIn3Vka01mS0VDUG
X-Received: from iotr20.prod.google.com ([2002:a05:6602:2354:b0:841:8ee4:fc23])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6602:6422:b0:83a:db84:41a8 with SMTP id ca18e2360f4ac-8445b5ccdddmr90500239f.10.1733187629246;
 Mon, 02 Dec 2024 17:00:29 -0800 (PST)
Date: Tue,  3 Dec 2024 00:59:21 +0000
In-Reply-To: <20241203005921.1119116-1-kevinloughlin@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241203005921.1119116-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241203005921.1119116-3-kevinloughlin@google.com>
Subject: [RFC PATCH 2/2] KVM: SEV: Prefer WBNOINVD over WBINVD for cache
 maintenance efficiency
From: Kevin Loughlin <kevinloughlin@google.com>
To: linux-kernel@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	pgonda@google.com, sidtelang@google.com, mizhang@google.com, 
	virtualization@lists.linux.dev, xen-devel@lists.xenproject.org, 
	bcm-kernel-feedback-list@broadcom.com, 
	Kevin Loughlin <kevinloughlin@google.com>
Content-Type: text/plain; charset="UTF-8"

AMD CPUs currently execute WBINVD in the host when unregistering SEV
guest memory or when deactivating SEV guests. Such cache maintenance is
performed to prevent data corruption, wherein the encrypted (C=1)
version of a dirty cache line might otherwise only be written back
after the memory is written in a different context (ex: C=0), yielding
corruption. However, WBINVD is performance-costly, especially because
it invalidates processor caches.

Strictly-speaking, unless the SEV ASID is being recycled (meaning all
existing cache lines with the recycled ASID must be flushed), the
cache invalidation triggered by WBINVD is unnecessary; only the
writeback is needed to prevent data corruption in remaining scenarios.

To improve performance in these scenarios, use WBNOINVD when available
instead of WBINVD. WBNOINVD still writes back all dirty lines
(preventing host data corruption by SEV guests) but does *not*
invalidate processor caches.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 arch/x86/kvm/svm/sev.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 943bd074a5d3..dbe40f728c4b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -116,6 +116,7 @@ static int sev_flush_asids(unsigned int min_asid, unsigned int max_asid)
 	 */
 	down_write(&sev_deactivate_lock);
 
+	/* SNP firmware expects WBINVD before SNP_DF_FLUSH, so do *not* use WBNOINVD */
 	wbinvd_on_all_cpus();
 
 	if (sev_snp_enabled)
@@ -710,6 +711,14 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
 	}
 }
 
+static void sev_wb_on_all_cpus(void)
+{
+	if (boot_cpu_has(X86_FEATURE_WBNOINVD))
+		wbnoinvd_on_all_cpus();
+	else
+		wbinvd_on_all_cpus();
+}
+
 static unsigned long get_num_contig_pages(unsigned long idx,
 				struct page **inpages, unsigned long npages)
 {
@@ -2774,11 +2783,11 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
 	}
 
 	/*
-	 * Ensure that all guest tagged cache entries are flushed before
-	 * releasing the pages back to the system for use. CLFLUSH will
-	 * not do this, so issue a WBINVD.
+	 * Ensure that all dirty guest tagged cache entries are written back
+	 * before releasing the pages back to the system for use. CLFLUSH will
+	 * not do this without SME_COHERENT, so issue a WB[NO]INVD.
 	 */
-	wbinvd_on_all_cpus();
+	sev_wb_on_all_cpus();
 
 	__unregister_enc_region_locked(kvm, region);
 
@@ -2900,11 +2909,11 @@ void sev_vm_destroy(struct kvm *kvm)
 	}
 
 	/*
-	 * Ensure that all guest tagged cache entries are flushed before
-	 * releasing the pages back to the system for use. CLFLUSH will
-	 * not do this, so issue a WBINVD.
+	 * Ensure that all dirty guest tagged cache entries are written back
+	 * before releasing the pages back to the system for use. CLFLUSH will
+	 * not do this without SME_COHERENT, so issue a WB[NO]INVD.
 	 */
-	wbinvd_on_all_cpus();
+	sev_wb_on_all_cpus();
 
 	/*
 	 * if userspace was terminated before unregistering the memory regions
@@ -3130,12 +3139,12 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
 	 * by leaving stale encrypted data in the cache.
 	 */
 	if (WARN_ON_ONCE(wrmsrl_safe(MSR_AMD64_VM_PAGE_FLUSH, addr | asid)))
-		goto do_wbinvd;
+		goto do_wb_on_all_cpus;
 
 	return;
 
-do_wbinvd:
-	wbinvd_on_all_cpus();
+do_wb_on_all_cpus:
+	sev_wb_on_all_cpus();
 }
 
 void sev_guest_memory_reclaimed(struct kvm *kvm)
@@ -3149,7 +3158,7 @@ void sev_guest_memory_reclaimed(struct kvm *kvm)
 	if (!sev_guest(kvm) || sev_snp_guest(kvm))
 		return;
 
-	wbinvd_on_all_cpus();
+	sev_wb_on_all_cpus();
 }
 
 void sev_free_vcpu(struct kvm_vcpu *vcpu)
@@ -3858,7 +3867,7 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
 		 * guest-mapped page rather than the initial one allocated
 		 * by KVM in svm->sev_es.vmsa. In theory, svm->sev_es.vmsa
 		 * could be free'd and cleaned up here, but that involves
-		 * cleanups like wbinvd_on_all_cpus() which would ideally
+		 * cleanups like sev_wb_on_all_cpus() which would ideally
 		 * be handled during teardown rather than guest boot.
 		 * Deferring that also allows the existing logic for SEV-ES
 		 * VMSAs to be re-used with minimal SNP-specific changes.
-- 
2.47.0.338.g60cca15819-goog


