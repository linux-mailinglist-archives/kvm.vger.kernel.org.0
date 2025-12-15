Return-Path: <kvm+bounces-66021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 14636CBF98A
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:47:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AB0BE308A395
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 19:42:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E66E433C188;
	Mon, 15 Dec 2025 19:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cQatsWEC"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538533321AA
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 19:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765826962; cv=none; b=In3Yv9JhFWKA6s+bGvB4Fu4iUDJil2vzcXPe02gSOrCIxspulsbYUbT+WutbrSwSBsi53atywz2FfoH0/6eUCxzPAJh/70uraGLye4LCxyEwEPU6D9YGaHOb70J9jN7mIElfXxnftzD2+ejI5kJrGMs1cb+dH0kC8D1Zn4KaoII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765826962; c=relaxed/simple;
	bh=Y/ktjna45Z6jMiagIfspvK/EyvR8MKSSQL7teOwJMoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cdop9/xKnIMRXLwLcIh7AKABUD1oAw63tgS3SiuTIYLTC7pkJtB7da942XpBgngluyRd02tFtI9DmgXHCEcb/3VmkoULLE9Tp/mmZOGorl0WIUQxG/mzNP7M6MclZTFINBSSl/gLiHH/KjcOsDvhfcWLzo5uxRZI9Iw7YjFb8wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cQatsWEC; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765826953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LtjzcMLwZKcyHnexb9YdURizd6U7k7zRx7/18UXQh9U=;
	b=cQatsWECJZDWRfzHXaNslwW9lhhLEB7yw+NXouiXi9ccYKsQs4C9CO77L0AZFzKhRz/Av8
	VwhzfCvnQjMMCx8XRjaV1AOzUc18JEOEGF4zi2WwWr/cNPDxT2cT+9/hwVEPFYerubgXkO
	mQ3D4jUxPYMPiSiV0UALYicl5IfaMFo=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v3 15/26] KVM: nSVM: Drop the non-architectural consistency check for NP_ENABLE
Date: Mon, 15 Dec 2025 19:27:10 +0000
Message-ID: <20251215192722.3654335-17-yosry.ahmed@linux.dev>
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

KVM currenty fails a nested VMRUN and injects VMEXIT_INVALID (aka
SVM_EXIT_ERR) if L1 sets NP_ENABLE and the host does not support NPTs.
On first glance, it seems like the check should actually be for
guest_cpu_cap_has(X86_FEATURE_NPT) instead, as it is possible for the
host to support NPTs but the guest CPUID to not advertise it.

However, the consistency check is not architectural to begin with. The
APM does not mention VMEXIT_INVALID if NP_ENABLE is set on a processor
that does not have X86_FEATURE_NPT. Hence, NP_ENABLE should be ignored
if X86_FEATURE_NPT is not available for L1, so sanitize it when copying
from the VMCB12 to KVM's cache.

Apart from the consistency check, NP_ENABLE in VMCB12 is currently
ignored because the bit is actually copied from VMCB01 to VMCB02, not
from VMCB12.

Fixes: 4b16184c1cca ("KVM: SVM: Initialize Nested Nested MMU context on VMRUN")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b4074e674c9d..24b10188fb91 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -335,9 +335,6 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 	if (CC(control->asid == 0))
 		return false;
 
-	if (CC((control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) && !npt_enabled))
-		return false;
-
 	if (CC(!nested_svm_check_bitmap_pa(vcpu, control->msrpm_base_pa,
 					   MSRPM_SIZE)))
 		return false;
@@ -399,6 +396,11 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	for (i = 0; i < MAX_INTERCEPT; i++)
 		to->intercepts[i] = from->intercepts[i];
 
+	/* Always clear NP_ENABLE if the guest cannot use NPTs */
+	to->nested_ctl          = from->nested_ctl;
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_NPT))
+		to->nested_ctl &= ~SVM_NESTED_CTL_NP_ENABLE;
+
 	to->iopm_base_pa        = from->iopm_base_pa;
 	to->msrpm_base_pa       = from->msrpm_base_pa;
 	to->tsc_offset          = from->tsc_offset;
@@ -412,7 +414,6 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	to->exit_info_2         = from->exit_info_2;
 	to->exit_int_info       = from->exit_int_info;
 	to->exit_int_info_err   = from->exit_int_info_err;
-	to->nested_ctl          = from->nested_ctl;
 	to->event_inj           = from->event_inj;
 	to->event_inj_err       = from->event_inj_err;
 	to->next_rip            = from->next_rip;
-- 
2.52.0.239.gd5f0c6e74e-goog


