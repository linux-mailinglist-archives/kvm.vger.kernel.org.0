Return-Path: <kvm+bounces-66017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 28518CBFA95
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 21:06:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CEF9B3030FC2
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7DEE33A6FA;
	Mon, 15 Dec 2025 19:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jet7cUq6"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56903339B20
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 19:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765826934; cv=none; b=OaXuCxd5O9tD9Vf/FVyqPHNyTzt+IZIcssOAUDINjc1rN0x93VCPBUeqpFFYJpJkp6yvhqrTJXvhH2zzxnMk9FNbqhUZdu445sHmmop6JiWzktm+v/t1AMA3puH9pxa5x5BpHGrOhJFPLxARXV1Ys+BLikt+K0FFHpMaT43bpbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765826934; c=relaxed/simple;
	bh=SV7c0IyOf3Swzxd3gebnZioCBNhbYaYAgXQyQDGAhfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZR+iK9d0E+9HOXBk+42fJP9Jhcl+xnJf0p+ilOx6kxSaLukyYkwAqI9vAGP+T2WlYshCgyp/3wTV3WA35yVo18d3jPXfNt908n6rVKf6vwY/4MSnPDh2BQDHCFrQWsY7G+wAXlOWVZgIksdPwiOa45YUiNr4QEpVEuH/8QG2Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jet7cUq6; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765826926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tc3xBZamumzsZJyhbkQzKCsRcoP4wPj4nN9OpwKoIWo=;
	b=jet7cUq65d96HYUtZQuUTFWVT1jJ4vBwYATZoXQn8Xctj1/cC6pRaJSX5I1XpvX74+GX3v
	lH5Mq3fos+M1GdurbbpFAkiGTheWWjQauM3G6qd4YmgxpfvsetxnFIU6KnH7KqQQ82kij+
	bt9Ufd5RtE92iAdp6Ff3ZjeDpaCCTPc=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v3 11/26] KVM: nSVM: Call nested_svm_init_mmu_context() before switching to VMCB02
Date: Mon, 15 Dec 2025 19:27:06 +0000
Message-ID: <20251215192722.3654335-13-yosry.ahmed@linux.dev>
In-Reply-To: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
References: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
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
index 2ee9d8bef5ba..4781acfa3504 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -771,10 +771,6 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	/* Also overwritten later if necessary.  */
 	vmcb02->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
 
-	/* nested_cr3.  */
-	if (nested_npt_enabled(svm))
-		nested_svm_init_mmu_context(vcpu);
-
 	vcpu->arch.tsc_offset = kvm_calc_nested_tsc_offset(
 			vcpu->arch.l1_tsc_offset,
 			svm->nested.ctl.tsc_offset,
@@ -900,6 +896,9 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 
 	enter_guest_mode(vcpu);
 
+	if (nested_npt_enabled(svm))
+		nested_svm_init_mmu_context(vcpu);
+
 	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
@@ -1849,6 +1848,10 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	nested_copy_vmcb_control_to_cache(svm, ctl);
 
 	enter_guest_mode(vcpu);
+
+	if (nested_npt_enabled(svm))
+		nested_svm_init_mmu_context(vcpu);
+
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
 	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
 
-- 
2.52.0.239.gd5f0c6e74e-goog


