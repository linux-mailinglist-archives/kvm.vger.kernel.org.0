Return-Path: <kvm+bounces-34970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2E62A08308
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 23:56:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52F2F3A77DA
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 22:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F0B62063E9;
	Thu,  9 Jan 2025 22:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ktiFiCgY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00692063E0
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 22:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736463366; cv=none; b=QktlB6w013PcZRXyNUOInNdEko/4VI/RmLbVgPx6AFrde972VwRxsoGU3HFBdodwSW7eCRA/tkvBJTCxgjaG3jTkeJfY82Ab5KxiHNxFYsovoG2YyQUZV7uv8ZuiFR9pYZvtsKCrCNInYCucAQEezAQfHuZAHnKWdhhXUCLxDtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736463366; c=relaxed/simple;
	bh=VT0OGzvxAJ9Uz9B67epxZPGZ+m0QbF3JgGUbzN/lGQI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lUm4C6Q8zLK5QYww0tq7LRZ11uGNdY6a5uNf+45MDHOv48Ilx8ejBIpYHt4LuoLjF0pHbxDl5UnPa4or4tmZ0LaesGiDuUjOhfteupOZT4GQy8Sx2gmilxI6Eseq2KfHlCYINSVXdEQOfKnOBW5UKm0xUcT69Sk2cjcDTBwv3HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ktiFiCgY; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-844ccafe468so206857239f.0
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 14:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736463363; x=1737068163; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ml2rBHjoO/PJ66L0lfVhpyVN92A2i0agI4aAaOu7J38=;
        b=ktiFiCgYBDvYcb6BgMsdW1Yp2aLiz4UxS8mjJhXauPF71Xu5qmUmBw2jCgWxxDVOxZ
         IOuUUsUGYE8n8X/2+s6noF4WHcgXIdQsjtt9Hvq/b/dCt5FUtBNTxxeL4D6yAvkt0V76
         4kUr/cuR6DyiiviwoOW++PbL3Qprx/e16uQGqmbYt+1gG7RqFXWPrm3bUOYdzffAXosy
         lOzbrQeKckfxVML3YB4ASRZbqvnNNwxhE/D4Qm8FeL5KaXfymeI5rA7FB+JKe0B3mgfD
         0GLh411BIyy1S2cMDndIUQK39DmmKJRH4v1fTWvMYWpN9UaJPFWHx7byCKBo4Df3yluz
         olBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736463363; x=1737068163;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ml2rBHjoO/PJ66L0lfVhpyVN92A2i0agI4aAaOu7J38=;
        b=nYzNyLN+ckKIMR6BIKwUDQzJIZsoQNK/mdDe1SJNHrUH4vlhHk/KKUs5Vx5fefQXWP
         MQvX685fY0y+Svj8th3zQjlYKcJmkOjuMo8kVtcw/y1gFrCVHHaPyQttEy0qoUgNxrQm
         klSAVwh9m0SD9K8J96860Zj5QCndPoOR2kzYJqYnBGsk0mf9k+bdmUfNzgAYdrY1HNdf
         HaFKwti4nCOc5B3xYdQUXWu7q9DBidEw87WaBf132atsAtqDX9+j03sUWP0RBzYMyZFG
         KwIit0lOQZFaFjNSre6gB0CDfWE6Gw6vIQRWU0/udUiToL23x96C4o8bY1zGV4srwyU0
         4Ljw==
X-Forwarded-Encrypted: i=1; AJvYcCXMMTE2s/9OiE3JsNuMtpC4C+Rb2z3jzfXpfx2cybAXSPNWxR3qVYL8mcLB4oxfMiQIgmg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/NmN48ZEY36wJ7OTM0YV0Jd1YP6iGiZ0Jv4CTJXiU5JAPPAZc
	GGfZBVosqqKIP9g3/E2n2aq5rOCsRHxOBVxa7g4/++istRAA3wqRBFG2ZX83wqR8btqssYj4nSw
	N2ZSfIrmGdzRmxWOFCRGRmjUagJaDxw==
X-Google-Smtp-Source: AGHT+IF8Pd7PkVi3L9SEuAVYvt3NhxCjNnS56PWf0U3mSRLhd1A7UAvJx/+dNy0qqinMsdc6K4vyC0miVScJkn9kpF3G
X-Received: from iobbe12.prod.google.com ([2002:a05:6602:378c:b0:844:c5b1:9dce])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6602:b98:b0:835:4cb5:4fa7 with SMTP id ca18e2360f4ac-84ce016f5d3mr862698539f.12.1736463363795;
 Thu, 09 Jan 2025 14:56:03 -0800 (PST)
Date: Thu,  9 Jan 2025 22:55:33 +0000
In-Reply-To: <20250109225533.1841097-1-kevinloughlin@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250109225533.1841097-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.47.1.688.g23fc6f90ad-goog
Message-ID: <20250109225533.1841097-3-kevinloughlin@google.com>
Subject: [PATCH v2 2/2] KVM: SEV: Prefer WBNOINVD over WBINVD for cache
 maintenance efficiency
From: Kevin Loughlin <kevinloughlin@google.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, seanjc@google.com, 
	pbonzini@redhat.com, kevinloughlin@google.com, 
	kirill.shutemov@linux.intel.com, kai.huang@intel.com, ubizjak@gmail.com, 
	dave.jiang@intel.com, jgross@suse.com, kvm@vger.kernel.org, 
	thomas.lendacky@amd.com, pgonda@google.com, sidtelang@google.com, 
	mizhang@google.com, rientjes@google.com, szy0127@sjtu.edu.cn
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
index fe6cc763fd51..a413b2299d30 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -116,6 +116,7 @@ static int sev_flush_asids(unsigned int min_asid, unsigned int max_asid)
 	 */
 	down_write(&sev_deactivate_lock);
 
+	/* Use WBINVD for ASID recycling. */
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
2.47.1.688.g23fc6f90ad-goog


