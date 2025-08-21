Return-Path: <kvm+bounces-55338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86C34B301F7
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 20:24:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05106568805
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 18:24:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7FDC34DCCE;
	Thu, 21 Aug 2025 18:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gXOFFeCL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096723451DE;
	Thu, 21 Aug 2025 18:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755800620; cv=none; b=d3MUpPTSSlH9puIePc5l1lEOLGslzF+bF7qiGEseEpdeTAj1TZZIpQg6Oq+aDy4V/5dy3zmmH4/H9f5etBr6OUWPdgfU1aCYYVptWmq3l6wRDfR6Yb4M34Z44jtXF6ogZXSvrrisxHzJdrpvkRe2tkKqUrLQwnOF75QU/21Ip18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755800620; c=relaxed/simple;
	bh=+bsXqjrbjdk0kUQXXL1WrzIRuzrIEx7IY5OrHK70vXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovMqvYNa9u49jwYpkmIdO3In/Q10aDJ5uAUCu2UizJvcWMHa+s4YP6EiYDEuIZ9UjrKZIVjzZDGQ01XzAInvJM79Uf/uL1hUg8+mFFlCnAkBU+lkv8hALvBntUQfR2/MsUu+SbW52vqBmQ/t7k6j5/qNPy6sHRDp7Be73OE1QsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gXOFFeCL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB229C4CEEB;
	Thu, 21 Aug 2025 18:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755800618;
	bh=+bsXqjrbjdk0kUQXXL1WrzIRuzrIEx7IY5OrHK70vXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gXOFFeCLTTNqCVCKZ0JTD61qLiaW/lEaolroVnAs/+nklhVjQCH/tfdoABvL2Qzv+
	 ezddI3EL4PH5IYkaB4Dx/bUpNXhbrHBGkmVFCzivk00BPFClyCQSFV/X+9Dg8z/dgK
	 hd0cfxb2J6VdDHtG+Cb3JfrxJlukh/xBA6XgX8Ue1VPqs/n4J0CmZ0CK0J2J1JPQ/r
	 hxvemuevxPO/8q8eHt9NreQ8rErznyJB6oEVThnsKxlugPvnoPKPf4uiHArzjrjXs1
	 KZHNFdBDFYPg7G//Z0fCCva1J4KqY6olsoqdx9HKLEiQOsBUsbavKcdcHoOP2dcWbh
	 0lgV+g6o+tJKw==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH v4 1/7] KVM: SVM: Limit AVIC physical max index based on configured max_vcpu_ids
Date: Thu, 21 Aug 2025 23:48:32 +0530
Message-ID: <471e9725e5f10a4d609910c684152de4689c09f2.1755797611.git.naveen@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755797611.git.naveen@kernel.org>
References: <cover.1755797611.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM allows VMMs to specify the maximum possible APIC ID for a virtual
machine through KVM_CAP_MAX_VCPU_ID capability so as to limit data
structures related to APIC/x2APIC. Utilize the same to set the AVIC
physical max index in the VMCB, similar to VMX. This helps hardware
limit the number of entries to be scanned in the physical APIC ID table
speeding up IPI broadcasts for virtual machines with smaller number of
vCPUs.

Unlike VMX, SVM AVIC requires a single page to be allocated for the
Physical APIC ID table and the Logical APIC ID table, so retain the
existing approach of allocating those during VM init.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 arch/x86/kvm/svm/avic.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index a34c5c3b164e..a6908ac5298d 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -82,6 +82,7 @@ bool x2avic_enabled;
 static void avic_activate_vmcb(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = svm->vmcb01.ptr;
+	struct kvm *kvm = svm->vcpu.kvm;
 
 	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
 	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
@@ -97,7 +98,8 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
 	 */
 	if (x2avic_enabled && apic_x2apic_mode(svm->vcpu.arch.apic)) {
 		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
-		vmcb->control.avic_physical_id |= X2AVIC_MAX_PHYSICAL_ID;
+		vmcb->control.avic_physical_id |= min(kvm->arch.max_vcpu_ids - 1,
+						      X2AVIC_MAX_PHYSICAL_ID);
 		/* Disabling MSR intercept for x2APIC registers */
 		svm_set_x2apic_msr_interception(svm, false);
 	} else {
@@ -108,7 +110,8 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
 		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, &svm->vcpu);
 
 		/* For xAVIC and hybrid-xAVIC modes */
-		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
+		vmcb->control.avic_physical_id |= min(kvm->arch.max_vcpu_ids - 1,
+						      AVIC_MAX_PHYSICAL_ID);
 		/* Enabling MSR intercept for x2APIC registers */
 		svm_set_x2apic_msr_interception(svm, true);
 	}
-- 
2.50.1


