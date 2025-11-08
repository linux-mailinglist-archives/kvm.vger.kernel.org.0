Return-Path: <kvm+bounces-62371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 41CD6C42262
	for <lists+kvm@lfdr.de>; Sat, 08 Nov 2025 01:46:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E3C4A34ECF4
	for <lists+kvm@lfdr.de>; Sat,  8 Nov 2025 00:46:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 379DA287508;
	Sat,  8 Nov 2025 00:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uMS1n4ZF"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D281E5B9E
	for <kvm@vger.kernel.org>; Sat,  8 Nov 2025 00:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762562756; cv=none; b=d6uF01ZW96SzlWmlLSIKiuPVpYRK2Tvc9dYq09KhFN7gl2tQyrJMlH1CTcu8CbJOIvGv1BKrSjrT/7KROT4QhhzBWeGmi1HJaG41AEnwAFmji80aFvbW3XsLi371UM2CrVoRjZxh+cj/UJgeaJ0OFOKPfmjg8OBA8/V8Dz3d0RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762562756; c=relaxed/simple;
	bh=x85JRd3eoh4Fmbm0hw42uUNA1ySyfDcR++08WBtPvAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/ZLzFR7c2Un4/ZM2wtH689ACvXszmkgLiHob7oDY0f5Llh1GBg8Yn8K9XOA8go7uH6AWfe6xJgYIEeDVqDorpULyxkRBo3kCKPygNqfFugPDgYeHssedODa4AMJfP+02gSMETMncLdXEo5v4mXRE0muNVUY2WlE+TxDv33VO1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uMS1n4ZF; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762562751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dqxsukY6YvoTOTLjaVVpP8tsHHl1y/4M81vp3qGNAj8=;
	b=uMS1n4ZFUiK46BRYuOJuLrtZiJU2mpDTu4SgcqddDGtQc2V31e7+h9DIQ0WDcvT0Bweihi
	ftPnMmy3y1Dz8w5KNmkhH3VqKPZabohnTCjKFppzy3L4qLTixb9P88szrfwvr5Xi5WcHes
	BqGCFbKe9Jd9/Bx6ub79Dq/o5oyCSAw=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Matteo Rizzo <matteorizzo@google.com>,
	evn@google.com
Subject: [PATCH 1/6] KVM: SVM: Mark VMCB_LBR dirty when MSR_IA32_DEBUGCTLMSR is updated
Date: Sat,  8 Nov 2025 00:45:19 +0000
Message-ID: <20251108004524.1600006-2-yosry.ahmed@linux.dev>
In-Reply-To: <20251108004524.1600006-1-yosry.ahmed@linux.dev>
References: <20251108004524.1600006-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Clear the VMCB_LBR clean bit when MSR_IA32_DEBUGCTLMSR is updated, as
the only valid bit is DEBUGCTLMSR_LBR.

The history is complicated, it was correctly cleared for L1 before
commit 1d5a1b5860ed ("KVM: x86: nSVM: correctly virtualize LBR msrs when
L2 is running"), then the latter relied on svm_update_lbrv() to clear
it, but it only did so for L2. Go back to clearing it directly in
svm_set_msr().

Fixes: 1d5a1b5860ed ("KVM: x86: nSVM: correctly virtualize LBR msrs when L2 is running")
Reported-by: Matteo Rizzo <matteorizzo@google.com>
Reported-by: evn@google.com
Co-developed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/svm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 55bd7aa5cd743..d25c56b30b4e2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3009,7 +3009,11 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		if (data & DEBUGCTL_RESERVED_BITS)
 			return 1;
 
+		if (svm_get_lbr_vmcb(svm)->save.dbgctl == data)
+			break;
+
 		svm_get_lbr_vmcb(svm)->save.dbgctl = data;
+		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
 		svm_update_lbrv(vcpu);
 		break;
 	case MSR_VM_HSAVE_PA:
-- 
2.51.2.1041.gc1ab5b90ca-goog


