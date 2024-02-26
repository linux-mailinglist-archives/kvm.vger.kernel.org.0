Return-Path: <kvm+bounces-9881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C51A8678D6
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:42:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8ABC1F2578C
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AFFA131E4F;
	Mon, 26 Feb 2024 14:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fJum386X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC1A131E34;
	Mon, 26 Feb 2024 14:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958139; cv=none; b=hl4CmGfl1Lsgen9ro8bRxgxzzqIN17tbJ1jAmpkOtxHQRM/HtQ+CwlF1lB+VsJFwm3ipcxhs6pGNtMpwszQ9F3ciD815KsigbfCL1Xh75Hgi8SGV4O3V0N3YZJ7iliY3QUxgC4gsd1TTcrBMvIafq55IRmk0r/sjzPo4TtStc+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958139; c=relaxed/simple;
	bh=iwftWf46wOnpswtTJOCMVHOfuKM+8gHZWJ2C/CjfvgU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OZ3GyT6eyLvjlhXv/NQ9sm5ktzDLVprskqOX2u0NF/fVfZYf6MxBtFnpFxm8r/4/Fw/Fu+WPzYE3BLmgil6IMQrh9LuQ1WSpusDvqiwuIdbym8KtvDm4oa23uM71QDRyEgUXpJgz8a+ru2W5AiyA3HbmsWJOph7mjgHbgGwiGzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fJum386X; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e43ee3f6fbso2829528b3a.3;
        Mon, 26 Feb 2024 06:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958137; x=1709562937; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ui4nV+xW+CAuqp8t7yR+nLCmWIr4uDNM8z/IC9GYkUg=;
        b=fJum386XeS2js/BrOdhAcagZ2WbwaehatTS+qxOgRDIjaGgtdPtmqxYFryiGVHZ2aq
         x5TbbY7EHL/2RSEwMzDtLMdYFbO0rVrQQbBHLcLLFr/MtWNRdCtGU2/TJ9OwrPqmhS7R
         KrRMEVuki7P2P74SIMqpS3W2PKyFHm/vKNWm7NtQR3knB22zk7s/bom1gXRImFeCGVro
         gO6DAVpm3EH+JTeYRZ1BwNCxcqLpfaYHJUB+vp9o4RQkGfqSSpvoUTIYGTj3G5gLg4zm
         cqILY2Ob+cxNruCqxW8yXzoSS0Ce0Xgp9F28S87VR+Xf870uZmI10VhoQf/sJJt98DCy
         t/kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958137; x=1709562937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ui4nV+xW+CAuqp8t7yR+nLCmWIr4uDNM8z/IC9GYkUg=;
        b=lFXFL807BtXzK9QA8t8NJePBW8Kqfy1AG7nr9xT+QzTFZqaN5wFkhlgHBvON7JYQ/e
         3fiWx4oj5HIkL+yx4cSCl6Uw2D6mzvXFtY0FG+HOcsECBaqAcqQktYhyRltM1hmLytF1
         dw1GbwRgJlHBKM11bRs2oN3renKI4K0gA5pXvT0lOhyO8un2tzwUuDsnVWx3zEdWq8NK
         vBLGenY0xHP0faPNpJX9wQRwjYVFFEf9qZWVnpYf91icKjlynwzW1Gt9JVUmeuJRcN7A
         gjWA06yyAaYZkW6Qv8exAawD4BqSx/qKBLk5EB8VtQVGd5RHUfxu+OX/HmJ0WvEabAmx
         43rg==
X-Forwarded-Encrypted: i=1; AJvYcCXTp+KyU8m+oQnuNqVHrs3qxm+b+sg6VHmkCTbHlD9XboS2pBndNl+iwEpV0sP6Q9Emjvav6+AAskpRo33kTPZqc/71
X-Gm-Message-State: AOJu0Yyq7DswNDyok0GXXEG4B6H3BY70kYxBQka/4ZgTCvzlrVIhWaBp
	H6C6wS/3urb4kDdbYbOcKSqsQeSwjGxqxhvn4ygvpHqI6CEbxgexgwDkWsIh
X-Google-Smtp-Source: AGHT+IF4Q1Dv0wbolFf05KnWD0z8wS1wGRKSqhBnMZon9r60ioyBfE2I77T9HPMxwLMDV0uNyNdWWQ==
X-Received: by 2002:a05:6a21:1518:b0:19e:3a94:6309 with SMTP id nq24-20020a056a21151800b0019e3a946309mr11225761pzb.5.1708958137168;
        Mon, 26 Feb 2024 06:35:37 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id it8-20020a056a00458800b006e05c801748sm4103970pfb.199.2024.02.26.06.35.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:35:36 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 18/73] KVM: x86/PVM: Implement VM/VCPU initialization related callbacks
Date: Mon, 26 Feb 2024 22:35:35 +0800
Message-Id: <20240226143630.33643-19-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

In the vm_init() callback, the cloned host root page table is recorded
into the 'kvm' structure, allowing for the cloning of host PGD entries
during SP allocation. In the vcpu_create() callback, the pfn cache for
'PVCS' is initialized and deactivated in the vcpu_free() callback.
Additionally, the vcpu_reset() callback needs to perform a common x86
reset and specific PVM reset.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 120 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/pvm/pvm.h |  34 ++++++++++++
 2 files changed, 154 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index 83aa2c9f42f6..d4cc52bf6b3f 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -55,6 +55,117 @@ static bool cpu_has_pvm_wbinvd_exit(void)
 	return true;
 }
 
+static void reset_segment(struct kvm_segment *var, int seg)
+{
+	memset(var, 0, sizeof(*var));
+	var->limit = 0xffff;
+	var->present = 1;
+
+	switch (seg) {
+	case VCPU_SREG_CS:
+		var->s = 1;
+		var->type = 0xb; /* Code Segment */
+		var->selector = 0xf000;
+		var->base = 0xffff0000;
+		break;
+	case VCPU_SREG_LDTR:
+		var->s = 0;
+		var->type = DESC_LDT;
+		break;
+	case VCPU_SREG_TR:
+		var->s = 0;
+		var->type = DESC_TSS | 0x2; // TSS32 busy
+		break;
+	default:
+		var->s = 1;
+		var->type = 3; /* Read/Write Data Segment */
+		break;
+	}
+}
+
+static void __pvm_vcpu_reset(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+
+	if (is_intel)
+		vcpu->arch.microcode_version = 0x100000000ULL;
+	else
+		vcpu->arch.microcode_version = 0x01000065;
+
+	pvm->msr_ia32_feature_control_valid_bits = FEAT_CTL_LOCKED;
+}
+
+static void pvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	int i;
+
+	kvm_gpc_deactivate(&pvm->pvcs_gpc);
+
+	if (!init_event)
+		__pvm_vcpu_reset(vcpu);
+
+	/*
+	 * For PVM, cpuid faulting relies on hardware capability, but it is set
+	 * as supported by default in kvm_arch_vcpu_create(). Therefore, it
+	 * should be cleared if the host doesn't support it.
+	 */
+	if (!boot_cpu_has(X86_FEATURE_CPUID_FAULT))
+		vcpu->arch.msr_platform_info &= ~MSR_PLATFORM_INFO_CPUID_FAULT;
+
+	// X86 resets
+	for (i = 0; i < ARRAY_SIZE(pvm->segments); i++)
+		reset_segment(&pvm->segments[i], i);
+	kvm_set_cr8(vcpu, 0);
+	pvm->idt_ptr.address = 0;
+	pvm->idt_ptr.size = 0xffff;
+	pvm->gdt_ptr.address = 0;
+	pvm->gdt_ptr.size = 0xffff;
+
+	// PVM resets
+	pvm->switch_flags = SWITCH_FLAGS_INIT;
+	pvm->hw_cs = __USER_CS;
+	pvm->hw_ss = __USER_DS;
+	pvm->int_shadow = 0;
+	pvm->nmi_mask = false;
+
+	pvm->msr_vcpu_struct = 0;
+	pvm->msr_supervisor_rsp = 0;
+	pvm->msr_event_entry = 0;
+	pvm->msr_retu_rip_plus2 = 0;
+	pvm->msr_rets_rip_plus2 = 0;
+	pvm->msr_switch_cr3 = 0;
+}
+
+static int pvm_vcpu_create(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+
+	BUILD_BUG_ON(offsetof(struct vcpu_pvm, vcpu) != 0);
+
+	pvm->switch_flags = SWITCH_FLAGS_INIT;
+	kvm_gpc_init(&pvm->pvcs_gpc, vcpu->kvm, vcpu, KVM_GUEST_AND_HOST_USE_PFN);
+
+	return 0;
+}
+
+static void pvm_vcpu_free(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+
+	kvm_gpc_deactivate(&pvm->pvcs_gpc);
+}
+
+static void pvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
+{
+}
+
+static int pvm_vm_init(struct kvm *kvm)
+{
+	kvm->arch.host_mmu_root_pgd = host_mmu_root_pgd;
+	return 0;
+}
+
 static int hardware_enable(void)
 {
 	/* Nothing to do */
@@ -169,6 +280,15 @@ static struct kvm_x86_ops pvm_x86_ops __initdata = {
 
 	.has_wbinvd_exit = cpu_has_pvm_wbinvd_exit,
 
+	.vm_size = sizeof(struct kvm_pvm),
+	.vm_init = pvm_vm_init,
+
+	.vcpu_create = pvm_vcpu_create,
+	.vcpu_free = pvm_vcpu_free,
+	.vcpu_reset = pvm_vcpu_reset,
+
+	.vcpu_after_set_cpuid = pvm_vcpu_after_set_cpuid,
+
 	.nested_ops = &pvm_nested_ops,
 
 	.setup_mce = pvm_setup_mce,
diff --git a/arch/x86/kvm/pvm/pvm.h b/arch/x86/kvm/pvm/pvm.h
index 6149cf5975a4..599bbbb284dc 100644
--- a/arch/x86/kvm/pvm/pvm.h
+++ b/arch/x86/kvm/pvm/pvm.h
@@ -3,6 +3,9 @@
 #define __KVM_X86_PVM_H
 
 #include <linux/kvm_host.h>
+#include <asm/switcher.h>
+
+#define SWITCH_FLAGS_INIT	(SWITCH_FLAGS_SMOD)
 
 #define PT_L4_SHIFT		39
 #define PT_L4_SIZE		(1UL << PT_L4_SHIFT)
@@ -24,6 +27,37 @@ int host_mmu_init(void);
 
 struct vcpu_pvm {
 	struct kvm_vcpu vcpu;
+
+	unsigned long switch_flags;
+
+	u32 hw_cs, hw_ss;
+
+	int int_shadow;
+	bool nmi_mask;
+
+	struct gfn_to_pfn_cache pvcs_gpc;
+
+	/*
+	 * Only bits masked by msr_ia32_feature_control_valid_bits can be set in
+	 * msr_ia32_feature_control. FEAT_CTL_LOCKED is always included
+	 * in msr_ia32_feature_control_valid_bits.
+	 */
+	u64 msr_ia32_feature_control;
+	u64 msr_ia32_feature_control_valid_bits;
+
+	// PVM paravirt MSRs
+	unsigned long msr_vcpu_struct;
+	unsigned long msr_supervisor_rsp;
+	unsigned long msr_supervisor_redzone;
+	unsigned long msr_event_entry;
+	unsigned long msr_retu_rip_plus2;
+	unsigned long msr_rets_rip_plus2;
+	unsigned long msr_switch_cr3;
+	unsigned long msr_linear_address_range;
+
+	struct kvm_segment segments[NR_VCPU_SREG];
+	struct desc_ptr idt_ptr;
+	struct desc_ptr gdt_ptr;
 };
 
 struct kvm_pvm {
-- 
2.19.1.6.gb485710b


