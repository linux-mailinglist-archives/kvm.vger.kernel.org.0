Return-Path: <kvm+bounces-66023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CA571CBF95A
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:42:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 13682301B604
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 19:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BFA833C50D;
	Mon, 15 Dec 2025 19:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dFcVsrz0"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A655C33C1B9
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 19:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765826975; cv=none; b=lvXXu0ijzeOYz3IhJmC50d2mDmmajuHKMxlnjwqpy0IU0CBNVmR5JnonlkbetA4Og8TlC6opfMCJEmQrhMsqoP7dvPt+YVjCc36VwOzfK6YawBTDb9G61K04xAq4slHUPk9HraJC5GJ4qmKuhqsx1d+p8iorMzgFexhRIse9ng4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765826975; c=relaxed/simple;
	bh=lHHC/JgXQ2z+AyquPPAsuOlUQi/NgvYqRIy/qru+lqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jOxkZPQIwTZzhtMUO4lm/yLDduUFJUqr6Ftcdl7Ytsp94cc34s2oBb0gkYeuzrlRxpRMEdm3zlUgoWrzpWs7R0MXom42qfkgaCYcwhxg2YI29mnqQVb0j1OcecT5kLtCwuPQo9r8tcXidCmtRirNMZIE2VkLxByw3+mXSa2cROw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dFcVsrz0; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765826967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hNcj+uP4GCWTvM7ZSLKbaXlNVsuQ6wzrsKeDyf/ZNj8=;
	b=dFcVsrz08UXK5dWtZfw47q/Dg0zjAOej7JAE8C8wmeAG/uqkfh5W1xhX743RPqUvNfeALk
	bN/XvsY6MSl+N++XaNVXhUB9x+mn5vKKvr3abtOj6r3S5YwlWUGPMHd/BbvZPd6ZirLQtu
	HDdDc1BIQN0U7T7WGE2Ii5iIKDVmlHY=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v3 17/26] KVM: nSVM: Add missing consistency check for hCR0.PG and NP_ENABLE
Date: Mon, 15 Dec 2025 19:27:12 +0000
Message-ID: <20251215192722.3654335-19-yosry.ahmed@linux.dev>
In-Reply-To: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
References: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From the APM Volume #2, 15.25.3 (24593—Rev. 3.42—March 2024):

	If VMRUN is executed with hCR0.PG cleared to zero and NP_ENABLE
	set to 1 , VMRUN terminates with #VMEXIT(VMEXIT_INVALID).

Add the consistency check by plumbing L1's CR0 to
nested_vmcb_check_controls().

Fixes: 4b16184c1cca ("KVM: SVM: Initialize Nested Nested MMU context on VMRUN")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index cac61d65efc7..5184e5ae8ccf 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -327,7 +327,8 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
 }
 
 static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
-				       struct vmcb_ctrl_area_cached *control)
+				       struct vmcb_ctrl_area_cached *control,
+				       unsigned long l1_cr0)
 {
 	if (CC(!vmcb12_is_intercept(control, INTERCEPT_VMRUN)))
 		return false;
@@ -338,6 +339,8 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 	if (nested_npt_enabled(to_svm(vcpu))) {
 		if (CC(!kvm_vcpu_is_legal_gpa(vcpu, control->nested_cr3)))
 			return false;
+		if (CC(!(l1_cr0 & X86_CR0_PG)))
+			return false;
 	}
 
 	if (CC(!nested_svm_check_bitmap_pa(vcpu, control->msrpm_base_pa,
@@ -902,7 +905,8 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	enter_guest_mode(vcpu);
 
 	if (!nested_vmcb_check_save(vcpu, &svm->nested.save) ||
-	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl))
+	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl,
+					svm->vmcb01.ptr->save.cr0))
 		return -EINVAL;
 
 	if (nested_npt_enabled(svm))
@@ -1823,7 +1827,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	ret = -EINVAL;
 	__nested_copy_vmcb_control_to_cache(vcpu, &ctl_cached, ctl);
-	if (!nested_vmcb_check_controls(vcpu, &ctl_cached))
+	/* 'save' contains L1 state saved from before VMRUN */
+	if (!nested_vmcb_check_controls(vcpu, &ctl_cached, save->cr0))
 		goto out_free;
 
 	/*
-- 
2.52.0.239.gd5f0c6e74e-goog


