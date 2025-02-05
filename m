Return-Path: <kvm+bounces-37381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6060A298E5
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 19:25:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42A3316350C
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 18:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 754A020C473;
	Wed,  5 Feb 2025 18:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YjpfcRyc"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD96D1FF7A0
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 18:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738779873; cv=none; b=hZzu/dOM46Ar/SpJUM207yXBi3GXppXsD6DnRFwseAgI0E1+cHNpFWXxVH80jvYC3Q8S3cAh2eRgYyXCvfmgK0DXTSZrZ5Ii2c6Cl7p5AKyQYP6kJzS0nXaO+m6i4Pm4EeltCkMFw2sh9kJpYIoaQ6H/hiuz1se4JGeodT4ey6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738779873; c=relaxed/simple;
	bh=LgRIp5yvhsB+a0uyfuYo1zyr/44Jkdw2aSFiug2omYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cl8ydbR9Y8Z0lmfTHqBDsB83Rjp1nHKq+zWc2W3M9lfKLUgLQBTUOvTPCi9X4AC0+FhWRBvTFGDDDtPKzM4Hp6PWRdNjvSfKSuRElECtWUeNPmDNgW6ttaRs0+5egftv1XAQuQAEhBAi+Sye/9ZFO7QSJJOEDdEkZDxI6VXs3KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YjpfcRyc; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738779869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MxlUxHUE2R3T/zv/8G0eMFUCZCbOt6xBlqOK6ZjmqgA=;
	b=YjpfcRycWUspV0lkPxuIl/4NFg7Ylb6RUjgPO6qWR5e8rRtl20N3IgIiSSO0Or/yNYe37W
	Nmv39v1XjIiMdSjCXX+snGRZkkkHNdBuR1W8RuIHa0QhmXQOT7yWspQjMt4Cizi4gbbOmx
	Q5aZe4aRApbDtQatmSaaVySVjyJhYIk=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 05/13] KVM: x86/mmu: rename __kvm_mmu_invalidate_addr()
Date: Wed,  5 Feb 2025 18:23:54 +0000
Message-ID: <20250205182402.2147495-6-yosry.ahmed@linux.dev>
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

In preparation for creating another helper for
kvm_mmu_invalidate_addr(), rename __kvm_mmu_invalidate_addr() to
kvm_mmu_invalidate_addr_in_root().

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/mmu/mmu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3ff55a18347da..b93f560a2c0e8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6120,8 +6120,9 @@ void kvm_mmu_print_sptes(struct kvm_vcpu *vcpu, gpa_t gpa, const char *msg)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_print_sptes);
 
-static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-				      u64 addr, hpa_t root_hpa)
+static void kvm_mmu_invalidate_addr_in_root(struct kvm_vcpu *vcpu,
+					    struct kvm_mmu *mmu,
+					    u64 addr, hpa_t root_hpa)
 {
 	struct kvm_shadow_walk_iterator iterator;
 
@@ -6177,11 +6178,11 @@ void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		return;
 
 	if (roots & KVM_MMU_ROOT_CURRENT)
-		__kvm_mmu_invalidate_addr(vcpu, mmu, addr, mmu->root.hpa);
+		kvm_mmu_invalidate_addr_in_root(vcpu, mmu, addr, mmu->root.hpa);
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 		if (roots & KVM_MMU_ROOT_PREVIOUS(i))
-			__kvm_mmu_invalidate_addr(vcpu, mmu, addr, mmu->prev_roots[i].hpa);
+			kvm_mmu_invalidate_addr_in_root(vcpu, mmu, addr, mmu->prev_roots[i].hpa);
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_invalidate_addr);
-- 
2.48.1.362.g079036d154-goog


