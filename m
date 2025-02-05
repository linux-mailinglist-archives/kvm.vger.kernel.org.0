Return-Path: <kvm+bounces-37382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18731A298EC
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 19:26:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A52F316087B
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 18:26:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DADE2212D86;
	Wed,  5 Feb 2025 18:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nHGUqtZs"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D10120F09B
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 18:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738779877; cv=none; b=g0vHgjMqspDpoPLSz09pI3z13/JXuhHWC2rP6lL/1kTVYVSPFBWD1PXS+PHzzBUFWYnhf8NF7Wrzss2gTiUEZMPUgQeqc5gukXQXRyo6yJmwGFz5zfXdnhz6XHw6Aiiq0O/ZUMlmTcP13dKNpQFbqIzyPQ9xrGuwF5YfARtKfts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738779877; c=relaxed/simple;
	bh=PAfQqhxa85USuXKn06RgSkuInnQbNs5bBN77CzeXAjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5ySfPLyTqDhsQK1nn0RvaGIAcKXWsA/WzVk8AOfiNo56bDE8owthU9W7E6ZvDP35UsTgqohjpviTSZNTwNFJsFFdnJ7JmB0zcuMHwXKKCL9OsHfx9OmStBbwKLf4oziIys66GMRSR/iu7/OXrpteM4DeHpVPr4Ju+wzsNvZzJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nHGUqtZs; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738779871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qPn1PgFe4AwJI+C+l1VhnOCa43xf5YTOK+x82W3HwlY=;
	b=nHGUqtZs5lpSAOQvux06QCutFWkYJbBVT/d/RmPjTMgNf8S0mKoTxa28XpxKduG/KUk+tb
	YgAn8BV22tJRwK8nx6OuQXYA6Wu6lovMEIKIqZHenG5MM7caw6lOTBFV8R3b78sNmyPgOc
	ippMZ3LllFaxYl7a+WyCBa9TvPZ/F6Q=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 06/13] KVM: x86/mmu: Allow skipping the gva flush in kvm_mmu_invalidate_addr()
Date: Wed,  5 Feb 2025 18:23:55 +0000
Message-ID: <20250205182402.2147495-7-yosry.ahmed@linux.dev>
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

Refactor a helper out of kvm_mmu_invalidate_addr() that allows skipping
the gva flush. This will be used when an invalidation is needed but the
GVA TLB translations that require invalidation are not of the current
context (e.g. when emulating INVLPGA for L1 to flush L2's translations).

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/mmu/mmu.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b93f560a2c0e8..ac133abc9c173 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6158,15 +6158,15 @@ static void kvm_mmu_invalidate_addr_in_root(struct kvm_vcpu *vcpu,
 	write_unlock(&vcpu->kvm->mmu_lock);
 }
 
-void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-			     u64 addr, unsigned long roots)
+static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+				      u64 addr, unsigned long roots, bool gva_flush)
 {
 	int i;
 
 	WARN_ON_ONCE(roots & ~KVM_MMU_ROOTS_ALL);
 
 	/* It's actually a GPA for vcpu->arch.guest_mmu.  */
-	if (mmu != &vcpu->arch.guest_mmu) {
+	if (gva_flush && mmu != &vcpu->arch.guest_mmu) {
 		/* INVLPG on a non-canonical address is a NOP according to the SDM.  */
 		if (is_noncanonical_invlpg_address(addr, vcpu))
 			return;
@@ -6185,6 +6185,12 @@ void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			kvm_mmu_invalidate_addr_in_root(vcpu, mmu, addr, mmu->prev_roots[i].hpa);
 	}
 }
+
+void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+			     u64 addr, unsigned long roots)
+{
+	__kvm_mmu_invalidate_addr(vcpu, mmu, addr, roots, true);
+}
 EXPORT_SYMBOL_GPL(kvm_mmu_invalidate_addr);
 
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
-- 
2.48.1.362.g079036d154-goog


