Return-Path: <kvm+bounces-37386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E035A298F5
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 19:27:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9198C3AA00C
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 18:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50430214A96;
	Wed,  5 Feb 2025 18:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rFixJRd4"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44BA214A90
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 18:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738779889; cv=none; b=XV56ZX2axYoLa2iXbpsUGQffvhhRm6CGeG4olJuP80dIdjylmU/Q88Vfiaivii2SedAmkOv4+yz7jPl0vhXnXEGzYBjL4X6hUEhJalxDlm+4dcrMpEI038JUqaIM9RMfqvpkVTYH6w7JZ4FKbIaeGyd+r5LEgDqDhkZbB0gQkVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738779889; c=relaxed/simple;
	bh=J80J7QWwNwqKJI9OkYLRwkYf70xFczDYSSkcpDuLb08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUoouVolccYAjXMKtUfCfEDKyZsBtDmAyge5cULtWK1xCAw1K3a3P/w/8CwCGEtlk+OYvaS3qUkSRpJgQ2ng5CHy8XHYuWX4Vx+17R7WCR2kO8vRBWQMGEQgqZfV0MKmZwbfcrDWU0Xots3L8P/NB2094+MCIf037WFChtfRoL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rFixJRd4; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738779881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rrSQ3jUA061xY0J/9WOEI/tvDvAK9ExwlT3CVuaXaqw=;
	b=rFixJRd4jqemOUEt6Oub7sb4hNpmJV/0S9sRHsSEfePv6qJ537nFtEQB29iWNNGtz90xAj
	4gmeuc2iGq4CGW8FIQqoDcNS+Wd/yG8cjpPywroYkeqcbAR+kl/p3TpQ6NbskxPQnwfNWz
	jHoFrfP4qYSC4XFCJ+gcYRDs2q+IaAU=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 10/13] KVM: nSVM: Flush the TLB if L1 changes L2's ASID
Date: Wed,  5 Feb 2025 18:23:59 +0000
Message-ID: <20250205182402.2147495-11-yosry.ahmed@linux.dev>
In-Reply-To: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM tracks a single ASID for L2 guests. L1 could change the ASID it has
assigned L2 due to switching to a different L2 guest or simply to avoid
flushing L2's existing ASID. Flush L2's TLB when this happens to avoid
reusing TLB entries from the old ASID (from L1's perspective).

Remove the comment in __nested_copy_vmcb_control_to_cache() about the
cached ASID usage, as this changes makes it stale by adding another
usage.

This is heavily inspired by nVMX's handling of last_vpid.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 5 ++++-
 arch/x86/kvm/svm/svm.h    | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e2c59eb2907e8..12bb391884299 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -368,7 +368,6 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	to->pause_filter_count  = from->pause_filter_count;
 	to->pause_filter_thresh = from->pause_filter_thresh;
 
-	/* Copy asid here because nested_vmcb_check_controls will check it.  */
 	to->asid           = from->asid;
 	to->msrpm_base_pa &= ~0x0fffULL;
 	to->iopm_base_pa  &= ~0x0fffULL;
@@ -509,6 +508,10 @@ static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
 		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 	}
 
+	if (svm->nested.ctl.asid != svm->nested.last_asid) {
+		svm->nested.last_asid = svm->nested.ctl.asid;
+		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+	}
 	/*
 	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
 	 * things to fix before this can be conditional:
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6a73d6ed1e428..f2352135b99d3 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -211,6 +211,8 @@ struct svm_nested_state {
 	 * on its side.
 	 */
 	bool force_msr_bitmap_recalc;
+
+	u32 last_asid;
 };
 
 struct vcpu_sev_es_state {
-- 
2.48.1.362.g079036d154-goog


