Return-Path: <kvm+bounces-42065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 090F6A71F69
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 20:44:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34B567A368F
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 19:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56A57254877;
	Wed, 26 Mar 2025 19:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pBejHsMv"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4AF24C676
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 19:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743018240; cv=none; b=Ul0L19TtgFhuViKji5/asE/qmIkRC/0D24ZuziOvLXfYBvtWENtUjMIVBxmmayID6Yjwhtp5Uv1C/t+Xnt6mjuLfjK+2JFqvCX59whOOA2ygbJVcs9zkQ4NY3hS2MyKp2Q1PBuzx2wSRg8+sz3q6Yq5DuK4N7KMSiv+Plt3eg8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743018240; c=relaxed/simple;
	bh=lItvqMpdi0XTZjnRfwfXkLzIAb/GODCc1nwOMcOITZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SiEjjIRsjbwwFleOM/InS7K7VVWitfRiZi4TPPBX/D97XBRqEbVqeVy2PurDbgcWsH3w53MwDDd2KY4KpRChFCLArL2akduWWZQ6xFHa3g0q2nh6fd8gyG45GvK51tG0+sR3VnLuBv7aCLON31vIEBE1RIR6I5AeqY2CPHSdIKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pBejHsMv; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743018226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tKO1BhmCWE+lwO4jftvRFSsIiScoXZA46QHUMAkMydM=;
	b=pBejHsMvUadGCdrYvPyjfVXNPdnVW7/g+YCHZcV4ldSYb48WRncQlXt9WJk9DVx14c0Y6y
	Abg0KM/sloByOBWeOfBPNJKggAlMQ5uC+nsLlelH3mLYrgf1xggQClCXhnCe/L238pw4Tb
	kFsBdLSMvckqxlt69WH0mNc0+VsIJeU=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [RFC PATCH 19/24] KVM: nSVM: Flush the TLB if L1 changes L2's ASID
Date: Wed, 26 Mar 2025 19:43:31 +0000
Message-ID: <20250326194331.3717289-1-yosry.ahmed@linux.dev>
In-Reply-To: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM tracks a single ASID for L2 guests. An L1 vCPU could change the ASID
it has assigned L2 due to switching to a different L2 guest or simply to
avoid flushing L2's existing ASID. Flush L2's TLB when this happens to
avoid reusing TLB entries from the old ASID (from L1's perspective).

Remove the comment in __nested_copy_vmcb_control_to_cache() about the
cached ASID usage, as this changes makes it stale by adding another
usage.

This is heavily inspired by nVMX's handling of last_vpid.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 5 ++++-
 arch/x86/kvm/svm/svm.h    | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ffe01c2ae7db5..ca8db246ac050 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -368,7 +368,6 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	to->pause_filter_count  = from->pause_filter_count;
 	to->pause_filter_thresh = from->pause_filter_thresh;
 
-	/* Copy asid here because nested_vmcb_check_controls will check it.  */
 	to->asid           = from->asid;
 	to->msrpm_base_pa &= ~0x0fffULL;
 	to->iopm_base_pa  &= ~0x0fffULL;
@@ -508,6 +507,10 @@ static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
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
index e67e3a64e92f7..0c44133bc05ca 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -212,6 +212,8 @@ struct svm_nested_state {
 	 * on its side.
 	 */
 	bool force_msr_bitmap_recalc;
+
+	u32 last_asid;
 };
 
 struct vcpu_sev_es_state {
-- 
2.49.0.395.g12beb8f557-goog


