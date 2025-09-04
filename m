Return-Path: <kvm+bounces-56844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 059FBB44586
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 20:36:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C13F1586CCF
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 18:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A58B130BBBC;
	Thu,  4 Sep 2025 18:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dlTnYTAb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB2A2D6630
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 18:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757010958; cv=none; b=oZ5N7XBvqICv/1ABsiDpSCB9UFGrMNSMO0SVyIz1+SYxXOXVxW9oojBbB4WD8ScUQB4Be0AG4mo/wsutSP7TZ0J8+GhnHKZ3j3UqQd0sUNKVYx6toht+xWGmUHemutR2CgKHPruSO9zNOfq9zJ6sDpgUp6q5qS2SbMETOpna9xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757010958; c=relaxed/simple;
	bh=5JJUhuDphwQRDsn4xnJY27gsjgfY8NFDiTRQ6+7yP0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6t6ZDswRfbsjlV2MDNc1IPfg3p3hsB/HFSBPLKuDY4fEO1SG6xqukwvEUkK7EgLjCqEH/q/feSCU9y8DnLBik1ineCV1EnWu8r/r0sMRS8E7JbPorS4qON+8GIz/gf/x9ip+vdAGtNxa3PnMT1p57lStD51vJ7polBU1U4uinY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dlTnYTAb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602CCC4CEF0;
	Thu,  4 Sep 2025 18:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757010958;
	bh=5JJUhuDphwQRDsn4xnJY27gsjgfY8NFDiTRQ6+7yP0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dlTnYTAbBikpc5cKD23RFmH4fFsrvvdTstTfv0bW6oCw75Y9UCsxAGxID5oxI69zg
	 VkJgdGCtqeski+G7MvpTGm0W6xmTBSbTX2ELJUkS3XIgjSHN+K5X40xhRSa/ky1Ffi
	 iCy+gNV478tQJG63YSCJqkwZT++yo1fteZZvCPRACVbg5rY4uHIKF0XkwreijoDzks
	 JRowIdyTQoYjneYPVYXL9ZDng2+gY+RmcRx7xiaPHV95sWc12NUeXoKQyiT9sUdeFd
	 R03FnSSqYnniidZY6yHmChLkddd64cimrIQvB6NjMrk9qT66nUieziTcyGOPwzvRik
	 9ZVdKK7sTt3EQ==
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
Subject: [RESEND v4 3/7] KVM: SVM: Replace hard-coded value 0x1FF with the corresponding macro
Date: Fri,  5 Sep 2025 00:03:03 +0530
Message-ID: <95795f449c68bffcb3e1789ee2b0b7393711d37d.1757009416.git.naveen@kernel.org>
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

The lower 9-bit field in EXITINFO2 represents an index into the AVIC
Physical/Logical APIC ID table for a AVIC_INCOMPLETE_IPI #VMEXIT. Since
the index into the Logical APIC ID table is just 8 bits, this field is
actually bound by the bit-width of the index into the AVIC Physical ID
table which is represented by AVIC_PHYSICAL_MAX_INDEX_MASK. So, use that
macro to mask EXITINFO2.Index instead of hard coding 0x1FF in
avic_incomplete_ipi_interception().

Co-developed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 arch/x86/kvm/svm/avic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4f00e31347c3..d00b8f34e8d3 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -500,7 +500,7 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 	u32 icrh = svm->vmcb->control.exit_info_1 >> 32;
 	u32 icrl = svm->vmcb->control.exit_info_1;
 	u32 id = svm->vmcb->control.exit_info_2 >> 32;
-	u32 index = svm->vmcb->control.exit_info_2 & 0x1FF;
+	u32 index = svm->vmcb->control.exit_info_2 & AVIC_PHYSICAL_MAX_INDEX_MASK;
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	trace_kvm_avic_incomplete_ipi(vcpu->vcpu_id, icrh, icrl, id, index);
-- 
2.50.1


