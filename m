Return-Path: <kvm+bounces-53744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 48F8AB165C6
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 19:47:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D75341AA49CF
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 17:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 454172E2F12;
	Wed, 30 Jul 2025 17:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="QxTfTGBR"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02852DCF64;
	Wed, 30 Jul 2025 17:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753897628; cv=none; b=SxyAhNhzxS81KHLTtq2+Ghy38kVI7c/pz8pc+2OmOyhkaKii2e3el4v5iuO5D+8iOkZ0cd2sZoV68JconM0oWkD7O6AirdD0EFdBtV8VA10RBDH64cZuPy9yQOOBK57cFoMNxKfuzvVnlNSKuPr9EMdsNWXBBRoCU6sN1NMbg0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753897628; c=relaxed/simple;
	bh=0Kc7jvARdLyXdBvQ6trNh3aGtpd2HrUi9jADvEjuC+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkswIqsUIkTe3IfiHcTz8sXUUrcqo2zKcEtaOYRZDLCPfi5y2dH+R5D5BzzEt1OYe6HR9FgHDucYdGcsSxjJildgdejk+3a0sPQ9WW1V6HP6LSfgsT/1t0PBBbmkKXxBA21INmiST9J3Y9c94Kfrn8YCEEQct/haSx+kUqesvNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=QxTfTGBR; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56UHk6nA1614815
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 30 Jul 2025 10:46:31 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56UHk6nA1614815
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753897591;
	bh=2zF97TfTyDzxj7Meh54oh9Ub3fo+pB2wdmcB/Olws2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QxTfTGBRMfI1qBGB5i3atkV5F3beDhlw+p8rjk33wM1js2ftX2kM7tMbiuq4Z2jO+
	 v3zuk4bhutgl7StYC2DQkSRwFelu8u3TEWFp5s7P3leOAFN6+FrI4ufDXz9MYfkIJh
	 PH2J6glXOG2k7cVA5rgar6bPeQXeGH8e4WmJkSOd+7ZWE0pmgKFCK/Zh8d1+wHj0I3
	 InRQQj0eRUya4H5bpxSIc2MWYIy3CoX8RuSOaHjFf3CRVaTDXSnbkCmCNjrNN/Qdvd
	 01rRoqgXjdN9/dmZjW9Ii9F42sW9iQsmFAlwRb+Xj/vyg0L8fBiiEovJ3jodCJ9DAj
	 oN7OVI7jsSzWQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, chao.gao@intel.com
Subject: [PATCH v1 2/4] KVM: x86: Introduce MSR read/write emulation helpers
Date: Wed, 30 Jul 2025 10:46:03 -0700
Message-ID: <20250730174605.1614792-3-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730174605.1614792-1-xin@zytor.com>
References: <20250730174605.1614792-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add helper functions to centralize guest MSR read and write emulation.
This change consolidates the MSR emulation logic and makes it easier
to extend support for new MSR-related VM exit reasons introduced with
the immediate form of MSR instructions.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 67 +++++++++++++++++++++++----------
 2 files changed, 49 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f19a76d3ca0e..a854d9a166fe 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -201,6 +201,7 @@ enum kvm_reg {
 	VCPU_EXREG_SEGMENTS,
 	VCPU_EXREG_EXIT_INFO_1,
 	VCPU_EXREG_EXIT_INFO_2,
+	VCPU_EXREG_EDX_EAX,
 };
 
 enum {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1c49bc681c4..5086c3b30345 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2024,54 +2024,71 @@ static int kvm_msr_user_space(struct kvm_vcpu *vcpu, u32 index,
 	return 1;
 }
 
-int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
+static int kvm_emulate_get_msr(struct kvm_vcpu *vcpu, u32 msr, int reg)
 {
-	u32 ecx = kvm_rcx_read(vcpu);
 	u64 data;
 	int r;
 
-	r = kvm_get_msr_with_filter(vcpu, ecx, &data);
+	r = kvm_get_msr_with_filter(vcpu, msr, &data);
 
 	if (!r) {
-		trace_kvm_msr_read(ecx, data);
+		trace_kvm_msr_read(msr, data);
 
-		kvm_rax_write(vcpu, data & -1u);
-		kvm_rdx_write(vcpu, (data >> 32) & -1u);
+		if (reg == VCPU_EXREG_EDX_EAX) {
+			kvm_rax_write(vcpu, data & -1u);
+			kvm_rdx_write(vcpu, (data >> 32) & -1u);
+		} else {
+			kvm_register_write(vcpu, reg, data);
+		}
 	} else {
 		/* MSR read failed? See if we should ask user space */
-		if (kvm_msr_user_space(vcpu, ecx, KVM_EXIT_X86_RDMSR, 0,
+		if (kvm_msr_user_space(vcpu, msr, KVM_EXIT_X86_RDMSR, 0,
 				       complete_fast_rdmsr, r))
 			return 0;
-		trace_kvm_msr_read_ex(ecx);
+		trace_kvm_msr_read_ex(msr);
 	}
 
 	return kvm_x86_call(complete_emulated_msr)(vcpu, r);
 }
+
+int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
+{
+	return kvm_emulate_get_msr(vcpu, kvm_rcx_read(vcpu), VCPU_EXREG_EDX_EAX);
+}
 EXPORT_SYMBOL_GPL(kvm_emulate_rdmsr);
 
-int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
+static int kvm_emulate_set_msr(struct kvm_vcpu *vcpu, u32 msr, int reg)
 {
-	u32 ecx = kvm_rcx_read(vcpu);
-	u64 data = kvm_read_edx_eax(vcpu);
+	u64 data;
 	int r;
 
-	r = kvm_set_msr_with_filter(vcpu, ecx, data);
+	if (reg == VCPU_EXREG_EDX_EAX)
+		data = kvm_read_edx_eax(vcpu);
+	else
+		data = kvm_register_read(vcpu, reg);
+
+	r = kvm_set_msr_with_filter(vcpu, msr, data);
 
 	if (!r) {
-		trace_kvm_msr_write(ecx, data);
+		trace_kvm_msr_write(msr, data);
 	} else {
 		/* MSR write failed? See if we should ask user space */
-		if (kvm_msr_user_space(vcpu, ecx, KVM_EXIT_X86_WRMSR, data,
+		if (kvm_msr_user_space(vcpu, msr, KVM_EXIT_X86_WRMSR, data,
 				       complete_fast_msr_access, r))
 			return 0;
 		/* Signal all other negative errors to userspace */
 		if (r < 0)
 			return r;
-		trace_kvm_msr_write_ex(ecx, data);
+		trace_kvm_msr_write_ex(msr, data);
 	}
 
 	return kvm_x86_call(complete_emulated_msr)(vcpu, r);
 }
+
+int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
+{
+	return kvm_emulate_set_msr(vcpu, kvm_rcx_read(vcpu), VCPU_EXREG_EDX_EAX);
+}
 EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
 
 int kvm_emulate_as_nop(struct kvm_vcpu *vcpu)
@@ -2163,9 +2180,8 @@ static int handle_fastpath_set_tscdeadline(struct kvm_vcpu *vcpu, u64 data)
 	return 0;
 }
 
-fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
+static fastpath_t handle_set_msr_irqoff(struct kvm_vcpu *vcpu, u32 msr, int reg)
 {
-	u32 msr = kvm_rcx_read(vcpu);
 	u64 data;
 	fastpath_t ret;
 	bool handled;
@@ -2174,11 +2190,19 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 
 	switch (msr) {
 	case APIC_BASE_MSR + (APIC_ICR >> 4):
-		data = kvm_read_edx_eax(vcpu);
+		if (reg == VCPU_EXREG_EDX_EAX)
+			data = kvm_read_edx_eax(vcpu);
+		else
+			data = kvm_register_read(vcpu, reg);
+
 		handled = !handle_fastpath_set_x2apic_icr_irqoff(vcpu, data);
 		break;
 	case MSR_IA32_TSC_DEADLINE:
-		data = kvm_read_edx_eax(vcpu);
+		if (reg == VCPU_EXREG_EDX_EAX)
+			data = kvm_read_edx_eax(vcpu);
+		else
+			data = kvm_register_read(vcpu, reg);
+
 		handled = !handle_fastpath_set_tscdeadline(vcpu, data);
 		break;
 	default:
@@ -2200,6 +2224,11 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 
 	return ret;
 }
+
+fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
+{
+	return handle_set_msr_irqoff(vcpu, kvm_rcx_read(vcpu), VCPU_EXREG_EDX_EAX);
+}
 EXPORT_SYMBOL_GPL(handle_fastpath_set_msr_irqoff);
 
 /*
-- 
2.50.1


