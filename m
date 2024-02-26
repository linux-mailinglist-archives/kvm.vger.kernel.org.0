Return-Path: <kvm+bounces-9886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 789F28678E0
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:44:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E343296752
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D779A132C2C;
	Mon, 26 Feb 2024 14:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X4xF3pKa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2C21332A7;
	Mon, 26 Feb 2024 14:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958156; cv=none; b=ZD0LEtp3qWJ3LSJdEb54Rbf1SyZgxF1omT/NkGHHwQ/RkAA2Z5QdVSdElEyvHcrktOyyPofpsaGj8LnovblkETH6leCTlfS/ebyviOGcZBMvhkokX4khAWOH3//aPkbSyKaTVMp+uNTZKGhsjlkIfeVSf7E0NujnmlJ+sHI7N+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958156; c=relaxed/simple;
	bh=9aG0oEAda+9fcYOpzWdcAOx4WxIAEu+MaKCQRMdSxNo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JdMdsSk06omHL61p6oAF+j/Bv0o6NTCHSoFROLAPuE+GS922oFv0UnmGxLvRoaxOGIjOn2ARlkdcvXq2UuhLm1hJTkcXsK+++Vwe3xLhbEkMlmfTkl/vYuT8/DRlt2J0GZkYe9FJL5a4RyVDCgI89UN7YDXKpIUiudUhMc/cmNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X4xF3pKa; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e4c359e48aso1842629b3a.1;
        Mon, 26 Feb 2024 06:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958153; x=1709562953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MSMVlWy0KU4egESPyBq9idmlDCEcQCFrMSnFvIksvNM=;
        b=X4xF3pKalRSFaOWUZ5cXitBnfkz+uFG5SC4675fR2dA/bXf4wymCHW90a1WjY9MwEO
         pbXR8ZY54J+NR+ij3Hm4ctgzf1X7LDVtKgH103O+Z6yXG0NKPBh/dB9UD+ABxg6FsiVQ
         JK6CKRZdSDA6N2jPB0N6XVs3by3z4vWc4jrafYhETthY09tdhmevtjHwNkc1gVGrSG8H
         55+y4UA6m8jdSJONb/B3BQCJWXn83yorp3BGnW7sS1gUpTXXo4utpLe1SSgI0bx0pnVf
         JBCVPoyI82sLtQMlrrovILPTUacy1Am8jBFbwnnRoahsPzO7bp5HDJpvAe4UqnmI3EjL
         ZJDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958153; x=1709562953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MSMVlWy0KU4egESPyBq9idmlDCEcQCFrMSnFvIksvNM=;
        b=VnKgojeCcKkrmpPZYb4TyvZv0UaGnxfBySnNDwRuOxSNg/MgGgC3piHk5ohR03OY1N
         GI5yXLPaspVJOYyGyAt8Ysxz2ctG9QAb86dJk92yEagj+b2//Yy/h8kCHY4o/5+dalxT
         2fqikUwwOdqmqIZdJi1u4V85gdsN9OnYLJnUAkcXc0yc5V8y+qVNMEznIuDjzGNZTiT8
         d8k2uyNL+EALQWPAa2kAZxm+hM687n4sj8tTXy0mWdQz8dn2ry5TI1rTvWlbQtfpYOxV
         XgTgAxTUEQqoyDB/TUJA1VJZGfUTEeo+rTAdBgLhmKeIX3BJnPQOwpSq8kf3620RV6Zo
         uAGw==
X-Forwarded-Encrypted: i=1; AJvYcCWDn1Ae3IVqv9vNT/oCyehBakOiQgKnTzx4XngajNPuRpdWFXXREyh853Kx/1BFOtu7PQ/1kaZgnSdnx8aEJrx0OhtX
X-Gm-Message-State: AOJu0YyRdepaFN/LOrBv+bhJ0ryph6183IeojQytb61rGoWIBLL3Uuhz
	1EfuJ3BvVvBdqSCJijgDK4gbK1/qdGc/KZcZ9uU3OSLtINeGi/T6xpKU0K88
X-Google-Smtp-Source: AGHT+IGfErTmpaFA2eYvcZFrMIpLzD4mTN8y9z8Ngw++N10rufjVVfzsKy/Kc0ONU+UwZK+9HN/8yg==
X-Received: by 2002:a05:6a21:3a81:b0:1a0:f5e6:1115 with SMTP id zv1-20020a056a213a8100b001a0f5e61115mr7515293pzb.2.1708958153458;
        Mon, 26 Feb 2024 06:35:53 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id e2-20020a170902f1c200b001d9a40f50c4sm4046718plc.301.2024.02.26.06.35.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:35:53 -0800 (PST)
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
Subject: [RFC PATCH 23/73] KVM: x86/PVM: Handle event handling related MSR read/write operation
Date: Mon, 26 Feb 2024 22:35:40 +0800
Message-Id: <20240226143630.33643-24-jiangshanlai@gmail.com>
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

In the PVM event handling specification, the guest needs to register the
event entry into the associated MSRs before delivering the event.
Therefore, handling them in the get_msr()/set_msr() callbacks is
necessary to prepare for event delivery later. Additionally, the user
mode syscall event still uses the original syscall event entry, but only
MSR_LSTAR is used; other MSRs are ignored.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 188 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/pvm/pvm.h |   7 ++
 2 files changed, 195 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index 29c6d8da7c19..69f8fbbb6176 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -31,6 +31,33 @@ static bool __read_mostly is_intel;
 
 static unsigned long host_idt_base;
 
+static inline u16 kernel_cs_by_msr(u64 msr_star)
+{
+	// [47..32]
+	// and force rpl=0
+	return ((msr_star >> 32) & ~0x3);
+}
+
+static inline u16 kernel_ds_by_msr(u64 msr_star)
+{
+	// [47..32] + 8
+	// and force rpl=0
+	return ((msr_star >> 32) & ~0x3) + 8;
+}
+
+static inline u16 user_cs32_by_msr(u64 msr_star)
+{
+	// [63..48] is user_cs32 and force rpl=3
+	return ((msr_star >> 48) | 0x3);
+}
+
+static inline u16 user_cs_by_msr(u64 msr_star)
+{
+	// [63..48] is user_cs32, and [63..48] + 16 is user_cs
+	// and force rpl=3
+	return ((msr_star >> 48) | 0x3) + 16;
+}
+
 static inline void __save_gs_base(struct vcpu_pvm *pvm)
 {
 	// switcher will do a real hw swapgs, so use hw MSR_KERNEL_GS_BASE
@@ -261,6 +288,161 @@ static void pvm_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
 }
 
+static int pvm_get_msr_feature(struct kvm_msr_entry *msr)
+{
+	return 1;
+}
+
+static void pvm_msr_filter_changed(struct kvm_vcpu *vcpu)
+{
+	/* Accesses to MSRs are emulated in hypervisor, nothing to do here. */
+}
+
+/*
+ * Reads an msr value (of 'msr_index') into 'msr_info'.
+ * Returns 0 on success, non-0 otherwise.
+ * Assumes vcpu_load() was already called.
+ */
+static int pvm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	int ret = 0;
+
+	switch (msr_info->index) {
+	case MSR_STAR:
+		msr_info->data = pvm->msr_star;
+		break;
+	case MSR_LSTAR:
+		msr_info->data = pvm->msr_lstar;
+		break;
+	case MSR_SYSCALL_MASK:
+		msr_info->data = pvm->msr_syscall_mask;
+		break;
+	case MSR_CSTAR:
+		msr_info->data = pvm->unused_MSR_CSTAR;
+		break;
+	/*
+	 * Since SYSENTER is not supported for the guest, we return a bad
+	 * segment to the emulator when emulating the instruction for #GP.
+	 */
+	case MSR_IA32_SYSENTER_CS:
+		msr_info->data = GDT_ENTRY_INVALID_SEG;
+		break;
+	case MSR_IA32_SYSENTER_EIP:
+		msr_info->data = pvm->unused_MSR_IA32_SYSENTER_EIP;
+		break;
+	case MSR_IA32_SYSENTER_ESP:
+		msr_info->data = pvm->unused_MSR_IA32_SYSENTER_ESP;
+		break;
+	case MSR_PVM_VCPU_STRUCT:
+		msr_info->data = pvm->msr_vcpu_struct;
+		break;
+	case MSR_PVM_SUPERVISOR_RSP:
+		msr_info->data = pvm->msr_supervisor_rsp;
+		break;
+	case MSR_PVM_SUPERVISOR_REDZONE:
+		msr_info->data = pvm->msr_supervisor_redzone;
+		break;
+	case MSR_PVM_EVENT_ENTRY:
+		msr_info->data = pvm->msr_event_entry;
+		break;
+	case MSR_PVM_RETU_RIP:
+		msr_info->data = pvm->msr_retu_rip_plus2 - 2;
+		break;
+	case MSR_PVM_RETS_RIP:
+		msr_info->data = pvm->msr_rets_rip_plus2 - 2;
+		break;
+	default:
+		ret = kvm_get_msr_common(vcpu, msr_info);
+	}
+
+	return ret;
+}
+
+/*
+ * Writes msr value into the appropriate "register".
+ * Returns 0 on success, non-0 otherwise.
+ * Assumes vcpu_load() was already called.
+ */
+static int pvm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	int ret = 0;
+	u32 msr_index = msr_info->index;
+	u64 data = msr_info->data;
+
+	switch (msr_index) {
+	case MSR_STAR:
+		/*
+		 * Guest KERNEL_CS/DS shouldn't be NULL and guest USER_CS/DS
+		 * must be the same as the host USER_CS/DS.
+		 */
+		if (!msr_info->host_initiated) {
+			if (!kernel_cs_by_msr(data))
+				return 1;
+			if (user_cs_by_msr(data) != __USER_CS)
+				return 1;
+		}
+		pvm->msr_star = data;
+		break;
+	case MSR_LSTAR:
+		if (is_noncanonical_address(msr_info->data, vcpu))
+			return 1;
+		pvm->msr_lstar = data;
+		break;
+	case MSR_SYSCALL_MASK:
+		pvm->msr_syscall_mask = data;
+		break;
+	case MSR_CSTAR:
+		pvm->unused_MSR_CSTAR = data;
+		break;
+	case MSR_IA32_SYSENTER_CS:
+		pvm->unused_MSR_IA32_SYSENTER_CS = data;
+		break;
+	case MSR_IA32_SYSENTER_EIP:
+		pvm->unused_MSR_IA32_SYSENTER_EIP = data;
+		break;
+	case MSR_IA32_SYSENTER_ESP:
+		pvm->unused_MSR_IA32_SYSENTER_ESP = data;
+		break;
+	case MSR_PVM_VCPU_STRUCT:
+		if (!PAGE_ALIGNED(data))
+			return 1;
+		if (!data)
+			kvm_gpc_deactivate(&pvm->pvcs_gpc);
+		else if (kvm_gpc_activate(&pvm->pvcs_gpc, data, PAGE_SIZE))
+			return 1;
+
+		pvm->msr_vcpu_struct = data;
+		break;
+	case MSR_PVM_SUPERVISOR_RSP:
+		pvm->msr_supervisor_rsp = msr_info->data;
+		break;
+	case MSR_PVM_SUPERVISOR_REDZONE:
+		pvm->msr_supervisor_redzone = msr_info->data;
+		break;
+	case MSR_PVM_EVENT_ENTRY:
+		if (is_noncanonical_address(data, vcpu) ||
+		    is_noncanonical_address(data + 256, vcpu) ||
+		    is_noncanonical_address(data + 512, vcpu)) {
+			kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+			return 1;
+		}
+		pvm->msr_event_entry = msr_info->data;
+		break;
+	case MSR_PVM_RETU_RIP:
+		pvm->msr_retu_rip_plus2 = msr_info->data + 2;
+		break;
+	case MSR_PVM_RETS_RIP:
+		pvm->msr_rets_rip_plus2 = msr_info->data + 2;
+		break;
+	default:
+		ret = kvm_set_msr_common(vcpu, msr_info);
+	}
+
+	return ret;
+}
+
 static void pvm_setup_mce(struct kvm_vcpu *vcpu)
 {
 }
@@ -764,6 +946,9 @@ static struct kvm_x86_ops pvm_x86_ops __initdata = {
 	.vcpu_load = pvm_vcpu_load,
 	.vcpu_put = pvm_vcpu_put,
 
+	.get_msr_feature = pvm_get_msr_feature,
+	.get_msr = pvm_get_msr,
+	.set_msr = pvm_set_msr,
 	.load_mmu_pgd = pvm_load_mmu_pgd,
 
 	.vcpu_pre_run = pvm_vcpu_pre_run,
@@ -779,6 +964,9 @@ static struct kvm_x86_ops pvm_x86_ops __initdata = {
 	.nested_ops = &pvm_nested_ops,
 
 	.setup_mce = pvm_setup_mce,
+
+	.msr_filter_changed = pvm_msr_filter_changed,
+	.complete_emulated_msr = kvm_complete_insn_gp,
 };
 
 static struct kvm_x86_init_ops pvm_init_ops __initdata = {
diff --git a/arch/x86/kvm/pvm/pvm.h b/arch/x86/kvm/pvm/pvm.h
index 123cfe1c3c6a..57ca2e901e0d 100644
--- a/arch/x86/kvm/pvm/pvm.h
+++ b/arch/x86/kvm/pvm/pvm.h
@@ -54,6 +54,13 @@ struct vcpu_pvm {
 	struct gfn_to_pfn_cache pvcs_gpc;
 
 	// emulated x86 msrs
+	u64 msr_lstar;
+	u64 msr_syscall_mask;
+	u64 msr_star;
+	u64 unused_MSR_CSTAR;
+	u64 unused_MSR_IA32_SYSENTER_CS;
+	u64 unused_MSR_IA32_SYSENTER_EIP;
+	u64 unused_MSR_IA32_SYSENTER_ESP;
 	u64 msr_tsc_aux;
 	/*
 	 * Only bits masked by msr_ia32_feature_control_valid_bits can be set in
-- 
2.19.1.6.gb485710b


