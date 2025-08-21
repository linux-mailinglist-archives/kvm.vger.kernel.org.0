Return-Path: <kvm+bounces-55335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BAD5B301F1
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 20:24:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72F92568609
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 18:24:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 645A2343D9F;
	Thu, 21 Aug 2025 18:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SwWUAZ/X"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EEB2E62B3;
	Thu, 21 Aug 2025 18:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755800600; cv=none; b=bLiaLOl9P+FADvj2GutLZ5Jo1Fo5PypBc4H/yx33K8lEof2jBRIFv0M9LNzAhUpMjs1Ts+Hg9lUonLrdgw53FgCHSsIbERKUoLaXCrVfErp0bZX7OcMxi7/dIeKLKRYwBpJJqVFgywmkwCTNuOKgkY2FYe1SEC92daLR4jDPtF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755800600; c=relaxed/simple;
	bh=n/UG1uEWyVosv/9nhjgReWzsttl/974c80BSLHMkfb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hy7SiD9BNVrh14ok+CIqxLCOnqbKzwOV9fOZm60yD/ouLtDImVOgy/AWfLVIfBH6rE/YYBMuLUsUOsZt0xg30hFr3veys3uh++us1c+DPQB2wrPWpGPtEiQtccr7/UeQRcHpU4oFcySBUv/xjNp2tJSDJVn8ZCi4UUL+LEK2srk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SwWUAZ/X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50003C4CEEB;
	Thu, 21 Aug 2025 18:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755800600;
	bh=n/UG1uEWyVosv/9nhjgReWzsttl/974c80BSLHMkfb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwWUAZ/Xp543KQ1EST1hyVkt9ReqApRTOulqWlgA5iCyMT8t23/YjnVdSBuJQnjzR
	 wAttMsXm8N2wGZXzlvvOd0eIdWQmtnms09xEa1nFKPOcSOpAdMgnCU4ceG01I8JORi
	 YcUeWE9tuMPwpCJKneDnXR+WQDRRVm2SB2UcrbIqxDAmX4WH9YrmpVHmXFiEOexPdE
	 +w0KgmW78x6xRSLUJQ9e4L3o8EXIKSVhwSYbcpOdQTal4bLmu93GNuvJ5YGPyydC0o
	 11XDys4llVk8sdzPPwTV7NvlCfYFLXUN6VITtZpZubKXo8iG4DuzcrcAaByuVpI1Wi
	 G8abx4uh5gDag==
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
Subject: [PATCH v4 5/7] KVM: SVM: Move AVIC Physical ID table allocation to vcpu_precreate()
Date: Thu, 21 Aug 2025 23:48:36 +0530
Message-ID: <14f291111be8f32fdd49e37f1466dc4a4b2f7872.1755797611.git.naveen@kernel.org>
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
index 58b9d168e0c8..58d13b418734 100644
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
index 7e7821ee8ee1..949cc9e76007 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1271,6 +1271,14 @@ void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
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
@@ -5063,6 +5071,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.emergency_disable_virtualization_cpu = svm_emergency_disable_virtualization_cpu,
 	.has_emulated_msr = svm_has_emulated_msr,
 
+	.vcpu_precreate = svm_vcpu_precreate,
 	.vcpu_create = svm_vcpu_create,
 	.vcpu_free = svm_vcpu_free,
 	.vcpu_reset = svm_vcpu_reset,
-- 
2.50.1


