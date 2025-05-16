Return-Path: <kvm+bounces-46886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F6E4ABA533
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:31:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E30A3AD94F
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:31:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C31B2820BA;
	Fri, 16 May 2025 21:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I58OX6ZK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959C5281515
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 21:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747431015; cv=none; b=iqimTAB0y95gKKeoRWx+DfWADyC3NGPsdzOZ8DCzdj5nHceBwaJRv82aChE/QfI1dsr23/iekzTjB7K8zoyO7UdoVP/YMt6bYC0Hs2ANWKeMeOgYJhvMHipHxvo7+uvAeUvJO6lCiU7krOxkTIzG18GUb2jcmWOMwusObqj1x+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747431015; c=relaxed/simple;
	bh=flYWJPPU3bRx3+dVKKMz70hC4D0LNvPpc7j5HWWPtvE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oveO8DJgUQFIccJ1xZFc2umWJg7Qa7DCDhF07CPE0ssnIKclS6DPat/fmhA/zu0dIewvPuQXlmcMPk5KV9PQspHddGgaXxGFuCw2/IYUcGlrHpALuQfWDQuWUjNS3X8sjh4TneZvN5zl3Eth2UIJKUl5fziVQh1X3+ueOsN5+Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I58OX6ZK; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b240fdc9c20so2451318a12.3
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747431013; x=1748035813; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vApJs4VkDB5QlNVHwT4ZvbZJAzsc+75w07odne9W4Q4=;
        b=I58OX6ZKW0LXzuLqKDZjxw6XjIveh9DwU1Wee0aiWkf5YDMJyNc518rkQvZ5OSf4MW
         6xqZ/rX5rNCkTm8IODC/Y/+MC4RzMt/5KvcpB8Y97y3dMGoRGOVfzL+BcAwGf2emmWq0
         naaIE2IYRDxMP5N6slH5vRQ37jv9cizGGr4tmGAlH4YR7XqY9Iyn+0Jh7vVBGti4D08i
         2J3v1xWLxqfJwBP42jog1yDXjMBolXowGgCCK7PBXvknT/2pn80NMa7xOFgIyeqUiWaf
         HCzR0ia72s8mgHgLSn/jpKMG0ZMRa4ltBFeoqAUR4vU+JkjrvxpzEtMG7VSX3hJWXX8+
         LECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747431013; x=1748035813;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vApJs4VkDB5QlNVHwT4ZvbZJAzsc+75w07odne9W4Q4=;
        b=nAngn37S7SAXcRPGeShr+Dk9VpYTwMCu7VrFyk6r3Ie3LbitrG9VVL+dAkxc/+2HLg
         mIjcloMmB9grlACSV+5MlMnfvAJIf0hv08mgveRVQJ7psu3kMDlJWJbPWFJ9zgkjmtup
         b+/NB04/79B/N0Z0zmtfz3ILX+nJyzXsNyj2OL6t6OEs/qvioqMKHiJE8E0K//yMI2O+
         8GYIHNTd2zDtfNcHTLgSJpKeH3wVoWHFC+C6fTIVL3COGNDJ6BezLBQUiTZj7YufNKV/
         yQJ5RCMcg9gUHyZ71isl/yKbEHpzPNpngQeAiM1V5DF6Vq2V525NmHdTWB4qnQW78XiC
         7Jhw==
X-Forwarded-Encrypted: i=1; AJvYcCUilWr1OEwKL+8crbmWQKL5MnMiILAJlFGQgeCxbAo1Kk3weLkJh6LUgWT8BKel2BqtycI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLZLxyzhAYNUdwpOc2cBRMvC1JCjgA384j/H+2f4usVh/QMbtx
	QRXuGlnTg57Fo9QFs5MWE7CN3tCQfk3cF+30xHzcUiqlpnehi7WOjUeuiB1XmP8BaXiPmmi4qoP
	nzTxceA==
X-Google-Smtp-Source: AGHT+IGb68toJP8qmeSh29S453pBC6YH3dAmwTf87WeOmAYT6NO/sBgl0udqJdDz9JEtnHFNAAvfH+MPaDk=
X-Received: from pjyp5.prod.google.com ([2002:a17:90a:e705:b0:2f4:465d:5c61])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a12a:b0:215:e08d:7953
 with SMTP id adf61e73a8af0-2162192b844mr7618494637.24.1747431012754; Fri, 16
 May 2025 14:30:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 14:28:30 -0700
In-Reply-To: <20250516212833.2544737-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516212833.2544737-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516212833.2544737-6-seanjc@google.com>
Subject: [PATCH v2 5/8] KVM: SEV: Prefer WBNOINVD over WBINVD for cache
 maintenance efficiency
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
 arch/x86/kvm/svm/sev.c | 41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e9fd3bcec37a..9dcdeea954d3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -116,6 +116,7 @@ static int sev_flush_asids(unsigned int min_asid, unsigned int max_asid)
 	 */
 	down_write(&sev_deactivate_lock);
 
+	/* SNP firmware requires use of WBINVD for ASID recycling. */
 	wbinvd_on_all_cpus();
 
 	if (sev_snp_enabled)
@@ -707,6 +708,18 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
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
@@ -2757,12 +2770,7 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
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
 
@@ -3114,30 +3122,29 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
 
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
@@ -3901,7 +3908,7 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 	 * From this point forward, the VMSA will always be a guest-mapped page
 	 * rather than the initial one allocated by KVM in svm->sev_es.vmsa. In
 	 * theory, svm->sev_es.vmsa could be free'd and cleaned up here, but
-	 * that involves cleanups like wbinvd_on_all_cpus() which would ideally
+	 * that involves cleanups like flushing caches, which would ideally be
 	 * be handled during teardown rather than guest boot.  Deferring that
 	 * also allows the existing logic for SEV-ES VMSAs to be re-used with
 	 * minimal SNP-specific changes.
@@ -4899,7 +4906,7 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 
 		/*
 		 * SEV-ES avoids host/guest cache coherency issues through
-		 * WBINVD hooks issued via MMU notifiers during run-time, and
+		 * WBNOINVD hooks issued via MMU notifiers during run-time, and
 		 * KVM's VM destroy path at shutdown. Those MMU notifier events
 		 * don't cover gmem since there is no requirement to map pages
 		 * to a HVA in order to use them for a running guest. While the
-- 
2.49.0.1112.g889b7c5bd8-goog


