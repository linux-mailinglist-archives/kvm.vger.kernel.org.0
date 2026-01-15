Return-Path: <kvm+bounces-68129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B75BD21FB2
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:18:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id ABE02302B99F
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:15:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43C43241114;
	Thu, 15 Jan 2026 01:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ARbW/+gH"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D168123C512
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439646; cv=none; b=VWv5UM7bNH/C9B0NUDlIUhCTmR3Mu6dNdXDVmzEf+5HdtkUeenQFEL0zVofpsoYYg3KFute4MIzc+Qydzr9RxJIUw/kBsMrc1YoVrPv3ifCYHFwtRGkEda0QJ4367Dzi0aYj8Hv/6YoEhEhBAccekjjO9zRV/zpuxzkJZ/+Z6/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439646; c=relaxed/simple;
	bh=/iYHmwrHBc4Z/9o/cwPY7owGtq7bxTWgmkTdkDT1YjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R0RbFTqKjz20RLS0uZkfKmQm7Z/ORHxkrv8zxigh/FGCABT1JRJu8OjfA7x9HvehsK5085wiWaXnqnjtYGFTvs/LAG0dS9JEPCIpUqXu7ocNtdP+tKMGecu5YQvx7i7orpSytnWwZJcTbhHC4dltemgsTJhr6+aN1u9nq2tc9jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ARbW/+gH; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768439640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3ZxEkfJ4v9hif4brlpeOid1QR0PaBxuKeB/A2Sc7/9E=;
	b=ARbW/+gHbrqorKGryMkW2O2qsapZy/78qr+4wDB8fXh3TdRSrjzhZm0f0GmvvRHAIpeST7
	c0AMv3Bl2O9g4k6Ti5dzBnBCH7zWK9HPDoi7ZM1gOWPEKGNLuzqwoAW8T6KDa61OPgnW5F
	Sl02kS4gmDfp2A5zqcc/vGLeXaxlVC4=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v4 18/26] KVM: nSVM: Add missing consistency check for EFER, CR0, CR4, and CS
Date: Thu, 15 Jan 2026 01:13:04 +0000
Message-ID: <20260115011312.3675857-19-yosry.ahmed@linux.dev>
In-Reply-To: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

According to the APM Volume #2, 15.5, Canonicalization and Consistency
Checks (24593—Rev. 3.42—March 2024), the following condition (among
others) results in a #VMEXIT with VMEXIT_INVALID (aka SVM_EXIT_ERR):

  EFER.LME, CR0.PG, CR4.PAE, CS.L, and CS.D are all non-zero.

Add the missing consistency check. This is functionally a nop because
the nested VMRUN results in SVM_EXIT_ERR in HW, which is forwarded to
L1, but KVM makes all consistency checks before a VMRUN is actually
attempted.

Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 7 +++++++
 arch/x86/kvm/svm/svm.h    | 1 +
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 72db46b5126d..d8c79b3ea55e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -398,6 +398,11 @@ static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu,
 		    CC(!(save->cr0 & X86_CR0_PE)) ||
 		    CC(!kvm_vcpu_is_legal_cr3(vcpu, save->cr3)))
 			return false;
+
+		if (CC((save->cr4 & X86_CR4_PAE) &&
+		       (save->cs.attrib & SVM_SELECTOR_L_MASK) &&
+		       (save->cs.attrib & SVM_SELECTOR_DB_MASK)))
+			return false;
 	}
 
 	/* Note, SVM doesn't have any additional restrictions on CR4. */
@@ -494,6 +499,8 @@ static void __nested_copy_vmcb_save_to_cache(struct vmcb_save_area_cached *to,
 	 * Copy only fields that are validated, as we need them
 	 * to avoid TOC/TOU races.
 	 */
+	to->cs = from->cs;
+
 	to->efer = from->efer;
 	to->cr0 = from->cr0;
 	to->cr3 = from->cr3;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 3e3dcd671aad..dc0ce2141d5f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -139,6 +139,7 @@ struct kvm_vmcb_info {
 };
 
 struct vmcb_save_area_cached {
+	struct vmcb_seg cs;
 	u64 efer;
 	u64 cr4;
 	u64 cr3;
-- 
2.52.0.457.g6b5491de43-goog


