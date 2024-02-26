Return-Path: <kvm+bounces-9887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E7438678E2
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:45:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9311028F73F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3C7012C7F1;
	Mon, 26 Feb 2024 14:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jvkIeBEr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D9013342D;
	Mon, 26 Feb 2024 14:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958159; cv=none; b=S3mKSmwfjWwR5aYVmhQcOda+Jo7mdonH0rmbEOqSGBX9vox7V3Yl+fGgIu+opeySSxOWEilCQkRIuUteutPUbfRNzDC5ByL4TdMKRfofyHxX2d2VrqXy4ixPRvpDXGdmoLr6wpOaoPBzQxObZ6eFsDnjqsP21wBLzWDaBfq1Fk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958159; c=relaxed/simple;
	bh=5FZhE8CGaf4oOsLW99jFiL2V8DpwR94pz9xSUE+tHww=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Dp1m2g2MlmTalvjyKf+t3seOlBCfO6TPpz9vC+bTKrTJiPhv4pzfAxwg/03QL4JDOxxdQEAqxlNB2Ydx054H5gjnnBwO6ZTC376NW9OBDTs/6tXxO/7HlNBzMWetm/7zbEPYXldYvAlkACfFFEhXQ/DddDx0jLSSJUgQh3ragHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jvkIeBEr; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-5dbf7b74402so2528975a12.0;
        Mon, 26 Feb 2024 06:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958156; x=1709562956; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=avwD90nSI2LniFVSuZE7YLTIgz6R6zy0cQM3FsoXclk=;
        b=jvkIeBErSOe1/pmH3+2vtnYLAjE3iCOVvj5jkG2iz15gNUevOPhvY2wazm6HSAo2X0
         RumEkss1W1WDN1eII/HDnqdhJH9QzsiqUGuok/yrNsOpLOq9IqJcH69OzXE6AigobeAg
         dmH+Soy1nsK4OxGQmOaE6f8W/lDQti+fu3qeeZIYMpPlES9TkDcLxfBhoWhfjFRpMvGI
         1wCGRjeqAaDMzM+U7JapvTXCcauhI2WeaYiFlAQdb/uLpjHCtUQm5j5eQdvPwIsV61XY
         E+QKZhXPXqa7RwhQoR0EYmtcLbK2IqEUHYwl9zYFtuWtT63fE3XV90JYXBSRt72ltA2F
         xJPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958156; x=1709562956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=avwD90nSI2LniFVSuZE7YLTIgz6R6zy0cQM3FsoXclk=;
        b=sefkZJFUlurtGfPKe8rSNiHRjZJjNMQ/pUeTFK++ulU8SCWq8w4cjdzhf7NOmW9wAL
         xba3yO5s6c1heaMsYBbeLEb9qXvQHBRVxySMhS7vsP6AK21AvwVyJHq/0uSafun1v/y3
         J+Qn8qrHjsGhzcu6QmVVXhCYZRllKK9Mujq06e8wg8zv+G7ytht9bmXPmyQZtwg/7qWf
         u1oCwV1LHznwGjega0NT2bBr/2ZlvGIjXjF+aaXwTogE8Hko/xpHJdvIjplo6ZVargfL
         pTx7sl8+N91AgYouPso/sXWs9ikQz6WRyjxNmjQoneMX7zmh7KGKEZF3Tt7PkSC7x3d3
         rbLg==
X-Forwarded-Encrypted: i=1; AJvYcCVXSekHDZssgjO5dIvGj0LvOaofW9tvWcmyzDcjXtlQ85lmnftxdBZxXmxv54QSEMJJOmVvhQAF1xJBbCXO6Ag/Q07e
X-Gm-Message-State: AOJu0Ywr08SFxqkc/Vlllmcc0Q9Wit6joxD9Ox3MJbWYgGPmQYvhP8ZC
	w/Tf8AQ4gatOSZh3uAN9h+Lc7NFyrj7MgtIapyzNlGUCqny3EVFsKn0SHqh+
X-Google-Smtp-Source: AGHT+IF9t94J1P3gFjC3w94X7z6mLYPJMKdgH0qJsWfw2n4K1ZzGIEBhrooZGx76fRCQIDy0RbezwA==
X-Received: by 2002:a17:90a:8c0b:b0:29a:be15:9c90 with SMTP id a11-20020a17090a8c0b00b0029abe159c90mr2457111pjo.34.1708958156679;
        Mon, 26 Feb 2024 06:35:56 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id x19-20020a17090ab01300b002990d91d31dsm6443295pjq.15.2024.02.26.06.35.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:35:56 -0800 (PST)
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
Subject: [RFC PATCH 24/73] KVM: x86/PVM: Introduce PVM mode switching
Date: Mon, 26 Feb 2024 22:35:41 +0800
Message-Id: <20240226143630.33643-25-jiangshanlai@gmail.com>
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

In PVM ABI, CPL is not used directly. Instead, supervisor mode and user
mode are used to represent the original CPL0/CPL3 concept. It is assumed
that the kernel runs in supervisor mode and userspace runs in user mode.
From the x86 operating modes perspective, the PVM supervisor mode is a
modified 64-bit long mode. Therefore, 32-bit compatibility mode is not
allowed for the supervisor mode, and its hardware CS must be __USER_CS.

When switching to user mode, the stack and GS base of supervisor mode
are saved into the associated MSRs. When switching back from user mode,
the stack and GS base of supervisor mode are automatically restored from
the MSRs. Therefore, in PVM ABI, the value of MSR_KERNEL_GS_BASE in
supervisor mode is the same as the value of MSR_GS_BASE in supervisor
mode, which does not follow the x86 ABI.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 129 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/pvm/pvm.h |   1 +
 2 files changed, 130 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index 69f8fbbb6176..3735baee1d5f 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -31,6 +31,22 @@ static bool __read_mostly is_intel;
 
 static unsigned long host_idt_base;
 
+static inline bool is_smod(struct vcpu_pvm *pvm)
+{
+	unsigned long switch_flags = pvm->switch_flags;
+
+	if ((switch_flags & SWITCH_FLAGS_MOD_TOGGLE) == SWITCH_FLAGS_SMOD)
+		return true;
+
+	WARN_ON_ONCE((switch_flags & SWITCH_FLAGS_MOD_TOGGLE) != SWITCH_FLAGS_UMOD);
+	return false;
+}
+
+static inline void pvm_switch_flags_toggle_mod(struct vcpu_pvm *pvm)
+{
+	pvm->switch_flags ^= SWITCH_FLAGS_MOD_TOGGLE;
+}
+
 static inline u16 kernel_cs_by_msr(u64 msr_star)
 {
 	// [47..32]
@@ -80,6 +96,82 @@ static inline void __load_fs_base(struct vcpu_pvm *pvm)
 	wrmsrl(MSR_FS_BASE, pvm->segments[VCPU_SREG_FS].base);
 }
 
+static u64 pvm_read_guest_gs_base(struct vcpu_pvm *pvm)
+{
+	preempt_disable();
+	if (pvm->loaded_cpu_state)
+		__save_gs_base(pvm);
+	preempt_enable();
+
+	return pvm->segments[VCPU_SREG_GS].base;
+}
+
+static u64 pvm_read_guest_fs_base(struct vcpu_pvm *pvm)
+{
+	preempt_disable();
+	if (pvm->loaded_cpu_state)
+		__save_fs_base(pvm);
+	preempt_enable();
+
+	return pvm->segments[VCPU_SREG_FS].base;
+}
+
+static u64 pvm_read_guest_kernel_gs_base(struct vcpu_pvm *pvm)
+{
+	return pvm->msr_kernel_gs_base;
+}
+
+static void pvm_write_guest_gs_base(struct vcpu_pvm *pvm, u64 data)
+{
+	preempt_disable();
+	pvm->segments[VCPU_SREG_GS].base = data;
+	if (pvm->loaded_cpu_state)
+		__load_gs_base(pvm);
+	preempt_enable();
+}
+
+static void pvm_write_guest_fs_base(struct vcpu_pvm *pvm, u64 data)
+{
+	preempt_disable();
+	pvm->segments[VCPU_SREG_FS].base = data;
+	if (pvm->loaded_cpu_state)
+		__load_fs_base(pvm);
+	preempt_enable();
+}
+
+static void pvm_write_guest_kernel_gs_base(struct vcpu_pvm *pvm, u64 data)
+{
+	pvm->msr_kernel_gs_base = data;
+}
+
+// switch_to_smod() and switch_to_umod() switch the mode (smod/umod) and
+// the CR3.  No vTLB flushing when switching the CR3 per PVM Spec.
+static inline void switch_to_smod(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+
+	pvm_switch_flags_toggle_mod(pvm);
+	kvm_mmu_new_pgd(vcpu, pvm->msr_switch_cr3);
+	swap(pvm->msr_switch_cr3, vcpu->arch.cr3);
+
+	pvm_write_guest_gs_base(pvm, pvm->msr_kernel_gs_base);
+	kvm_rsp_write(vcpu, pvm->msr_supervisor_rsp);
+
+	pvm->hw_cs = __USER_CS;
+	pvm->hw_ss = __USER_DS;
+}
+
+static inline void switch_to_umod(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+
+	pvm->msr_supervisor_rsp = kvm_rsp_read(vcpu);
+
+	pvm_switch_flags_toggle_mod(pvm);
+	kvm_mmu_new_pgd(vcpu, pvm->msr_switch_cr3);
+	swap(pvm->msr_switch_cr3, vcpu->arch.cr3);
+}
+
 /*
  * Test whether DS, ES, FS and GS need to be reloaded.
  *
@@ -309,6 +401,15 @@ static int pvm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	int ret = 0;
 
 	switch (msr_info->index) {
+	case MSR_FS_BASE:
+		msr_info->data = pvm_read_guest_fs_base(pvm);
+		break;
+	case MSR_GS_BASE:
+		msr_info->data = pvm_read_guest_gs_base(pvm);
+		break;
+	case MSR_KERNEL_GS_BASE:
+		msr_info->data = pvm_read_guest_kernel_gs_base(pvm);
+		break;
 	case MSR_STAR:
 		msr_info->data = pvm->msr_star;
 		break;
@@ -352,6 +453,9 @@ static int pvm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_PVM_RETS_RIP:
 		msr_info->data = pvm->msr_rets_rip_plus2 - 2;
 		break;
+	case MSR_PVM_SWITCH_CR3:
+		msr_info->data = pvm->msr_switch_cr3;
+		break;
 	default:
 		ret = kvm_get_msr_common(vcpu, msr_info);
 	}
@@ -372,6 +476,15 @@ static int pvm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	u64 data = msr_info->data;
 
 	switch (msr_index) {
+	case MSR_FS_BASE:
+		pvm_write_guest_fs_base(pvm, data);
+		break;
+	case MSR_GS_BASE:
+		pvm_write_guest_gs_base(pvm, data);
+		break;
+	case MSR_KERNEL_GS_BASE:
+		pvm_write_guest_kernel_gs_base(pvm, data);
+		break;
 	case MSR_STAR:
 		/*
 		 * Guest KERNEL_CS/DS shouldn't be NULL and guest USER_CS/DS
@@ -436,6 +549,9 @@ static int pvm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_PVM_RETS_RIP:
 		pvm->msr_rets_rip_plus2 = msr_info->data + 2;
 		break;
+	case MSR_PVM_SWITCH_CR3:
+		pvm->msr_switch_cr3 = msr_info->data;
+		break;
 	default:
 		ret = kvm_set_msr_common(vcpu, msr_info);
 	}
@@ -443,6 +559,13 @@ static int pvm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return ret;
 }
 
+static int pvm_get_cpl(struct kvm_vcpu *vcpu)
+{
+	if (is_smod(to_pvm(vcpu)))
+		return 0;
+	return 3;
+}
+
 static void pvm_setup_mce(struct kvm_vcpu *vcpu)
 {
 }
@@ -683,6 +806,11 @@ static fastpath_t pvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	pvm_vcpu_run_noinstr(vcpu);
 
+	if (is_smod(pvm)) {
+		if (pvm->hw_cs != __USER_CS || pvm->hw_ss != __USER_DS)
+			kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+	}
+
 	pvm_load_host_xsave_state(vcpu);
 
 	return EXIT_FASTPATH_NONE;
@@ -949,6 +1077,7 @@ static struct kvm_x86_ops pvm_x86_ops __initdata = {
 	.get_msr_feature = pvm_get_msr_feature,
 	.get_msr = pvm_get_msr,
 	.set_msr = pvm_set_msr,
+	.get_cpl = pvm_get_cpl,
 	.load_mmu_pgd = pvm_load_mmu_pgd,
 
 	.vcpu_pre_run = pvm_vcpu_pre_run,
diff --git a/arch/x86/kvm/pvm/pvm.h b/arch/x86/kvm/pvm/pvm.h
index 57ca2e901e0d..b0c633ce2987 100644
--- a/arch/x86/kvm/pvm/pvm.h
+++ b/arch/x86/kvm/pvm/pvm.h
@@ -61,6 +61,7 @@ struct vcpu_pvm {
 	u64 unused_MSR_IA32_SYSENTER_CS;
 	u64 unused_MSR_IA32_SYSENTER_EIP;
 	u64 unused_MSR_IA32_SYSENTER_ESP;
+	u64 msr_kernel_gs_base;
 	u64 msr_tsc_aux;
 	/*
 	 * Only bits masked by msr_ia32_feature_control_valid_bits can be set in
-- 
2.19.1.6.gb485710b


