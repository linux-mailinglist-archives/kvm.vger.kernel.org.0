Return-Path: <kvm+bounces-68121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 56024D21FCC
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:18:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C50353064C07
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 430DDF9D9;
	Thu, 15 Jan 2026 01:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rkxlqoZ4"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C034254B18
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439635; cv=none; b=O47lMotzzTgVU9WQH+PlHKc+LfoIQhShGKr/uLNUQTbR7C0iN37aq/nsTF8AmuQL6a6UGVC55GCb9fwn7WRyr1HK2FPANzmrZYf4mg1ga5kmjBr4KvIuIWJI+qdjXtjlSNa+cGO4e4npgKAt1k8kqn8ds7xbt59S7tkXxdxXTNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439635; c=relaxed/simple;
	bh=Ea6rWEDN+cRIxk3jN8cryjzwbqVJQqjFfLbIhwK2/f0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDWE3IRVS3J+2y1OJLHoJhCcTAcKhsDTo0r5enOZ9j3AbUreviTKd9mkhVcUX4JG5rO1RY1LdmCMcqR1dfSm3RIdeTbWsVPkeDu2PJHg6d0+x3/ov8o3DRhQjqaC4TNzYJAP30EBqP0Yaliz+bccf75ocJqUMOiQtztHYA1f/SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rkxlqoZ4; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768439625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WNERaqN0p70Upb1bv3QyZM9OSIxy0licFd67fEooyUg=;
	b=rkxlqoZ4QoptuWx0HpQn5E2NLyTJuzS4pFexq0op5yiieJJZHkTvmAIBNg9BW4M3w0vZOw
	3k2axA3boIJy9NfEpRHXfdr5b+u7Rvl8HwQWLbgkMlSzJuw2k0QDAkI9o+iRnVnkQowEI4
	HuEEcVtCSQ777M94kvo4uOGG3p1OT0M=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v4 11/26] KVM: nSVM: Call nested_svm_init_mmu_context() before switching to VMCB02
Date: Thu, 15 Jan 2026 01:12:57 +0000
Message-ID: <20260115011312.3675857-12-yosry.ahmed@linux.dev>
In-Reply-To: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In preparation for moving more code that depends on
nested_svm_init_mmu_context() before switching to VMCB02, move the call
outside of nested_vmcb02_prepare_control() into callers, a bit earlier.
nested_svm_init_mmu_context() needs to be called after
enter_guest_mode(), but not after switching to VMCB02.

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index debbce5c6511..f108f6fae5bc 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -807,10 +807,6 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	/* Also overwritten later if necessary.  */
 	vmcb02->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
 
-	/* nested_cr3.  */
-	if (nested_npt_enabled(svm))
-		nested_svm_init_mmu_context(vcpu);
-
 	vcpu->arch.tsc_offset = kvm_calc_nested_tsc_offset(
 			vcpu->arch.l1_tsc_offset,
 			svm->nested.ctl.tsc_offset,
@@ -949,6 +945,9 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 
 	enter_guest_mode(vcpu);
 
+	if (nested_npt_enabled(svm))
+		nested_svm_init_mmu_context(vcpu);
+
 	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
@@ -1904,6 +1903,10 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	nested_copy_vmcb_control_to_cache(svm, ctl);
 
 	enter_guest_mode(vcpu);
+
+	if (nested_npt_enabled(svm))
+		nested_svm_init_mmu_context(vcpu);
+
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
 	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
 
-- 
2.52.0.457.g6b5491de43-goog


