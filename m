Return-Path: <kvm+bounces-56846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01B3EB44588
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 20:36:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E4F116E870
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 18:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5703730BBBC;
	Thu,  4 Sep 2025 18:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fNxyFc7I"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79444224AE6
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 18:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757010982; cv=none; b=rtbSMjZyooSxHj45p5Lc0rN4V+3pAZhgpj0w94I5txa5zJcfX0Y2i/yPNFC0pR+z0pQ/MtYhv/Wqit84bu0RHg7N7OB2uOMQV2ycgc5QsBQMt5B7844Y5E/duN73gP+Wu1jgfMtLkwrFQC7jpxBezCe1f7sm5ZrdTzM1u/tJCtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757010982; c=relaxed/simple;
	bh=m4OcWGKwPL3YJ+iKJIADLKsDpBMzU1uWiIiUtOT23Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/GreFdVaFozzgl///W4bY6yy/qZOSxgutYPAbt45sIiLxk9tP/yvMlf8cgpopCoa7U39tayX8IkX/fPhVavXfHl+tFzO71cb/7ULTGIgD6bGqvlI4PNPDTcQTgwllakxh6uihIqeUxz0iuVBkqxd+e45LYVsOhRK6zpzjh/vBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fNxyFc7I; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEC2C4CEF0;
	Thu,  4 Sep 2025 18:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757010982;
	bh=m4OcWGKwPL3YJ+iKJIADLKsDpBMzU1uWiIiUtOT23Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNxyFc7Ipreb2A/JM1eCpWr/xw52/tkwt8yyh93W10TepkIYeodlliRusWVbaA3u2
	 flSGYBzA41CBKPLYbqwAK3vGh83zryG6fZ94ckn94YxLoeB4kWH0JvbQWazbu3O/3T
	 WQh2Q9FpsCk+bYMyi2ASFHSjT2iEux8TldUBpqzMRzcB4CJgLHS8pE9bLIOtfLPX8A
	 5u7Z6TrBSgosFBivPxxgFNadXdwqkgxf1pCyaRzwz9SEyWuu5atc8X1zeGcYEHJeBS
	 cMINy7pcJx1NmY2Cy/AvPvswlcDVu3HhxRmvsu4KEK4C3Ls4Cj7nl+6Cfyzu2a/xZj
	 jXSl64vqpj5TQ==
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
Subject: [RESEND v4 5/7] KVM: SVM: Move AVIC Physical ID table allocation to vcpu_precreate()
Date: Fri,  5 Sep 2025 00:03:05 +0530
Message-ID: <7dc764e0af7f01440bbac3d9215ed174027c2384.1757009416.git.naveen@kernel.org>
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

With support for 4k vCPUs in x2AVIC, the size of the AVIC Physical ID
table is expanded from a single 4k page to a maximum of 8 contiguous 4k
pages. The actual number of pages allocated depends on the maximum
possible APIC ID in the guest, which is only known by the time the first
vCPU is created. In preparation for supporting a dynamic AVIC Physical
ID table size, move its allocation to vcpu_precreate().

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 arch/x86/kvm/svm/svm.h  |  1 +
 arch/x86/kvm/svm/avic.c | 18 ++++++++++++++----
 arch/x86/kvm/svm/svm.c  |  9 +++++++++
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 3c7f208b7935..1cb442bda303 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -803,6 +803,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 
 bool avic_hardware_setup(void);
 int avic_ga_log_notifier(u32 ga_tag);
+int avic_alloc_physical_id_table(struct kvm *kvm);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
 void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb);
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index d00b8f34e8d3..b5a397b7c684 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -185,6 +185,20 @@ int avic_ga_log_notifier(u32 ga_tag)
 	return 0;
 }
 
+int avic_alloc_physical_id_table(struct kvm *kvm)
+{
+	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
+
+	if (kvm_svm->avic_physical_id_table || !enable_apicv || !irqchip_in_kernel(kvm))
+		return 0;
+
+	kvm_svm->avic_physical_id_table = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	if (!kvm_svm->avic_physical_id_table)
+		return -ENOMEM;
+
+	return 0;
+}
+
 void avic_vm_destroy(struct kvm *kvm)
 {
 	unsigned long flags;
@@ -212,10 +226,6 @@ int avic_vm_init(struct kvm *kvm)
 	if (!enable_apicv)
 		return 0;
 
-	kvm_svm->avic_physical_id_table = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
-	if (!kvm_svm->avic_physical_id_table)
-		goto free_avic;
-
 	kvm_svm->avic_logical_id_table = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!kvm_svm->avic_logical_id_table)
 		goto free_avic;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cb4f81be0024..ac50906e6265 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1265,6 +1265,14 @@ void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
 	svm->vmcb = target_vmcb->ptr;
 }
 
+static int svm_vcpu_precreate(struct kvm *kvm)
+{
+	if (enable_apicv)
+		return avic_alloc_physical_id_table(kvm);
+
+	return 0;
+}
+
 static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm;
@@ -5046,6 +5054,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.emergency_disable_virtualization_cpu = svm_emergency_disable_virtualization_cpu,
 	.has_emulated_msr = svm_has_emulated_msr,
 
+	.vcpu_precreate = svm_vcpu_precreate,
 	.vcpu_create = svm_vcpu_create,
 	.vcpu_free = svm_vcpu_free,
 	.vcpu_reset = svm_vcpu_reset,
-- 
2.50.1


