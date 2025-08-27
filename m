Return-Path: <kvm+bounces-55815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D89F5B375E2
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 02:09:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 010C61B67B91
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 00:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FFC7226D1D;
	Wed, 27 Aug 2025 00:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UyDKvtjz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246AE2236F0
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 00:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253147; cv=none; b=I4S4qucPqAH/eDegiLJ4AGDs1YE8dWhQodlqnJgVPMdJ40ZLZtbj1wthtc+x9TNMWKW4DB/zz72GfrLQC+tf5t8SLewOzhmISG2VZBYdljF3fwXREi8q8O9FX/+6QcclOYUspTEuhqL5d93NQSZ4RNDKSxi7FyJqqzYc91dMvFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253147; c=relaxed/simple;
	bh=+ptPO8wiWLdE67ovmdHqqqNTkWuU8Wbd/ifeWjv87No=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O0s43up4NhMOBL+XwxoI+b6VG+eIVd6DvWZE0YnuQa5Rex+Zzfpu+zYm9rQBlapSnnFR2Tl0ldXVmN+iu20zfu3CnjFyhtFaX7rme/FcxACcaxQcZFIJrFbJ/sAjNLsaWsrAmhA5uTBD/8uK/t2f+INcKM8ms2HDZlGPg+j32G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UyDKvtjz; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-324e4c3af5fso6258562a91.3
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 17:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756253145; x=1756857945; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kJ6rATzspI5eGA3xG6HKuRZsUtSaW3a6n8TI9IFDChs=;
        b=UyDKvtjzswpXJX9jy2hmIk8acSjaNvnee4L8cF2Xd2jtvcT9EMX8UOlY0CxOTedEwo
         kFhi6ptMoz+K7uFbbBJaND1mNXhmfpoFq8y4yFsd0xL5ocDKoymfLtqRxQOFvjbQ7MYQ
         M+/c/bA2xI1tDFtWKbZ15RE83XU3/gP5e/ur0HG22HOrcLsc6N7CrHTU0qX1b0XDKlmF
         KdJobPW6xCCFoMO1aOH/k8D+1xewU3zDopQz9osRapmEkX5F2rp4H67ptXBtn8vZFCq8
         0LvVUme/6QPbnvgpyUmVOJQWnaa8BaTM9ngIjbqK3P9/px/LlUk+3iQ2hkFkdK+JUOTf
         YD2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756253145; x=1756857945;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kJ6rATzspI5eGA3xG6HKuRZsUtSaW3a6n8TI9IFDChs=;
        b=wcChXD6iC2IUIKaq1L6IqZVjkkMuvzWoSORqHhOthHRaPlZQcQElyoww9RxywRpC7O
         yVLe+RBm0qmD7z2q6/hjcYfZW3tZYnqzD2HlXX5H8+nj5/ZAlh6TpysVNczwvDTtvQXl
         MqmQkTBGsg2oktZoKVGSCbrwSvrtV+G04c/vS4KxEK450hzOxNtTXWgEUDy0wv+iFePy
         jVq3YWqF2i68kV8ls1jHguMkF1bqIcG+UT7+7Tj+/97BTmZnIoBbog+YfpR8iKVhIpKg
         11O4TicJNM+I/I3BcFX64uCIHm4vHqNrK+LFe8epYAkf5TxsPvrg/JSZK9BRxI7/YnaO
         /2IQ==
X-Gm-Message-State: AOJu0YyVmMvsP66ire8wkTlbUtDW1DbmDqmT/8fos8gAXHFbGehwvL9p
	rz6Yp5oo4WM55claovI02h+P+Bjy5+qO+peiePe97OGgH+uivxT34CNqZlAz7HaROfhmht4jkYg
	THF854g==
X-Google-Smtp-Source: AGHT+IF+jEprkjlej8Prs6xu/gBvPow2HKyDXuqwzy8PeYZGXGFMT3K+Rg3QiclX8uRbzKpIye1R6CZL/V0=
X-Received: from pjbqb16.prod.google.com ([2002:a17:90b:2810:b0:321:c441:a0a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b87:b0:327:41c8:882a
 with SMTP id 98e67ed59e1d1-32741c8893dmr5208970a91.20.1756253145402; Tue, 26
 Aug 2025 17:05:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 26 Aug 2025 17:05:22 -0700
In-Reply-To: <20250827000522.4022426-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827000522.4022426-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.268.g9569e192d0-goog
Message-ID: <20250827000522.4022426-13-seanjc@google.com>
Subject: [RFC PATCH 12/12] KVM: TDX: Rename nr_premapped to nr_pending_tdh_mem_page_adds
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"

Rename "nr_premapped" to an asurdly verbose "nr_pending_tdh_mem_page_adds"
to make it explicitly clear what the counter tracks.  "pre-map" is far
too similar to "pre-fault", especially since tdx_sept_set_private_spte()
deals with both "pre_fault_allowed" and the counter.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 8 ++++----
 arch/x86/kvm/vmx/tdx.h | 9 +++++++--
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 5d2bb27f22da..f9ac590e8ff0 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1639,7 +1639,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 		if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
 			return -EIO;
 
-		kvm_tdx->nr_premapped++;
+		kvm_tdx->nr_pending_tdh_mem_page_adds++;
 		return 0;
 	}
 
@@ -1771,7 +1771,7 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level)) {
 		lockdep_assert_held(&kvm->slots_lock);
 
-		if (KVM_BUG_ON(--kvm_tdx->nr_premapped < 0, kvm))
+		if (KVM_BUG_ON(--kvm_tdx->nr_pending_tdh_mem_page_adds < 0, kvm))
 			return -EIO;
 
 		return 0;
@@ -2846,7 +2846,7 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	 * Pages are pending for KVM_TDX_INIT_MEM_REGION to issue
 	 * TDH.MEM.PAGE.ADD().
 	 */
-	if (kvm_tdx->nr_premapped)
+	if (kvm_tdx->nr_pending_tdh_mem_page_adds)
 		return -EINVAL;
 
 	cmd->hw_error = tdh_mr_finalize(&kvm_tdx->td);
@@ -3160,7 +3160,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 		goto out;
 	}
 
-	KVM_BUG_ON(--kvm_tdx->nr_premapped < 0, kvm);
+	KVM_BUG_ON(--kvm_tdx->nr_pending_tdh_mem_page_adds < 0, kvm);
 
 	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
 		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 04ba9ea3e0ba..45d86f9fa41c 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -36,8 +36,13 @@ struct kvm_tdx {
 
 	struct tdx_td td;
 
-	/* For KVM_TDX_INIT_MEM_REGION. */
-	unsigned long nr_premapped;
+	/*
+	 * The number of pages that KVM_TDX_INIT_MEM_REGION has mapped into the
+	 * S-EPT, but not yet initialized via TDH.MEM.PAGE_ADD.  Used to sanity
+	 * check adding pages to the image, and to ensure that all pages have
+	 * been initialized before finalizing the TD.
+	 */
+	unsigned long nr_pending_tdh_mem_page_adds;
 
 	/*
 	 * Prevent vCPUs from TD entry to ensure SEPT zap related SEAMCALLs do
-- 
2.51.0.268.g9569e192d0-goog


