Return-Path: <kvm+bounces-56848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AEDCAB4458A
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 20:36:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD7347B5443
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 18:35:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA16131158C;
	Thu,  4 Sep 2025 18:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tdlRzwZB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DAE270578
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 18:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757011001; cv=none; b=pYIPmU2KToGcI/Cne7znQqSjn4IMmpePkixsTFzfbeZNSJXKf5qjcqB5M4WVH0mL0cqHi+0J4AN70OeSARqRI5ljzuQH5GPo6PBbk3xc6QWqKqTkNGWuXFx44Xm3iFKUPZ4Sdyw93h6erbuboQVlmdFGIXyivDTPG0oNDbEZnlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757011001; c=relaxed/simple;
	bh=+bsXqjrbjdk0kUQXXL1WrzIRuzrIEx7IY5OrHK70vXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kG0aXV3fOksnvILppqNCYqfFFP36WXJBusvupKw/8WWLW+6P6TwpG2flXZgY5PpLz2z5BEeQ5lRNEKz7rCVZ9TCJLK6ckvNOXk/Zk9BXqwuYeOYNBG4gSynR/8OolfjBNnHRzKMDlC7UVFxeiuv9rElpIKAGfGkvQVeqSYD0/cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tdlRzwZB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6812DC4CEF0;
	Thu,  4 Sep 2025 18:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757011000;
	bh=+bsXqjrbjdk0kUQXXL1WrzIRuzrIEx7IY5OrHK70vXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdlRzwZBTicqELzW8mOaMkYBHvuBXkS7G/fYgHo1R6ZITkfYnVRKvs+vtQNw7JHUE
	 3yLLLc4ZXD34cSF+7fag7DvhLuAdEml4KPFvU48y76+cUnS36iU4tAa+CUOrexgC23
	 Y2oevdrtBL3hwQOfh1LCaJ3wPBjPo9GJrX96221YESylZYsrZEIHyIhAcOUnvmk+W6
	 s1zizGohxFFFBh1ii79vpqhN0qI2i31IMfcVmFF3dyQqSJLH1HpDFsjxmAxrl40Ug3
	 wnv8io5S/HFNPa9LcKB5kXzgy9VTK0HNvhFOEqP6vSF/jxLpb1+sMA/oGzkEKw2RrV
	 31CtuNMJURovQ==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: <x86@kernel.org>,
	<kvm@vger.kernel.org>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [RESEND v4 1/7] KVM: SVM: Limit AVIC physical max index based on configured max_vcpu_ids
Date: Fri,  5 Sep 2025 00:03:01 +0530
Message-ID: <adb07ccdb3394cd79cb372ba6bcc69a4e4d4ef54.1757009416.git.naveen@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1757009416.git.naveen@kernel.org>
References: <cover.1757009416.git.naveen@kernel.org>
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


