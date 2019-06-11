Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 662FB3C532
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 09:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404337AbfFKHe3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 03:34:29 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46477 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404276AbfFKHe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 03:34:28 -0400
Received: by mail-pf1-f193.google.com with SMTP id 81so6846676pfy.13;
        Tue, 11 Jun 2019 00:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nkR2CGLhyvHwMw1SHqXyTIaVd8ya3H+LSY4Ah0z2vFw=;
        b=HolacF8+aWi/c2mW5fFH3k2zm0ZhV9gAVHvPJCwLnkh0OQY1tOHbTZC1WkHcaBJbc6
         fzUJX6lnIZT9bmJCQHQ+rg6OqeANyWZUmRCnpSLMwrZIqDw6O7nm6zf0ZBQ19oel8WAW
         dpPaoLDsgBHjU0pHerFyNLgkj08SHbVn8XdgOhzmK3QF9EvQK1t6kdY2plmgAsd703KA
         nk5FrQ3VkEEJAG/X5vQ/QZ2H60aDITLOfAiQL4QjC9BG4LmKZzete5lnqWEQiE3Y64Nk
         ApD+ePC75PYKnLbk3OF2PuNY/R578NLEDfNQawS3ULhHd3Kiz7wWakrqLq2R9Ls1mlK2
         SUaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nkR2CGLhyvHwMw1SHqXyTIaVd8ya3H+LSY4Ah0z2vFw=;
        b=cAg0DxqH4ji23qu+5biK4rP4JzxkgKAV6oDQrd/uP4r1qjXkd3NdXZZMFJha+b+mpk
         ZNU9Q78FYij5+slBOGH5hwmMrT8m2WAWGSUl3+Ci3Rf+VB0RgnCEplmao4ZGuSsy62Dd
         KsbjNL/Jk4e6ZSRnNlW+kZFV/FOkrb7ShIKAdZYfuwBRc0UUZ27xdEioOZ//7N+ksxWP
         pXsBncdSBf6DlMKCwugO9A1fTnqbq2nISOvme1vay2rOENiIV5akGjOC4Gvvc25QnG8M
         mXZavWJAnKkL+CopZm+O++8PKYP3RI2BCMENNCpBVIz6jaYdo+7zgSQ5EL/BLTqBE8c8
         Lozg==
X-Gm-Message-State: APjAAAUeyFiWHeHqoXlzCd7YU04bBi4tQnxDtjMHO/JRysiIohu2CN3D
        zyNZfvIe93PmdRXcYHJi0X4+10S8
X-Google-Smtp-Source: APXvYqwvFiG1DTuESxZ7KpM5wcg/He8219TzmlFZ/vrU0uwYMsYekV+CPwzGXhazqWtR8BrCOdWVGQ==
X-Received: by 2002:a17:90a:a593:: with SMTP id b19mr5736300pjq.31.1560238467579;
        Tue, 11 Jun 2019 00:34:27 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 14sm6860800pfj.36.2019.06.11.00.34.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 11 Jun 2019 00:34:27 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2 3/5] KVM: X86: setup residency msrs during vCPU creation
Date:   Tue, 11 Jun 2019 15:34:09 +0800
Message-Id: <1560238451-19495-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560238451-19495-1-git-send-email-wanpengli@tencent.com>
References: <1560238451-19495-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

To setup core residency msrs during vCPU creation. Allowing guest reads 
CORE cstate when exposing host CPU power management capabilities to the 
guest. PKG cstate is restricted currently to avoid a guest to get the 
whole package information in multi-tenant scenario.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c |  2 ++
 arch/x86/kvm/x86.c     | 21 +++++++++++++++++++++
 arch/x86/kvm/x86.h     |  5 +++++
 3 files changed, 28 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4dc2459..2ebaa90 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6663,6 +6663,8 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	if (!vmx->vcpu.arch.core_cstate_msrs)
 		goto free_vmcs;
 
+	kvm_core_residency_setup(&vmx->vcpu);
+
 	if (nested)
 		nested_vmx_setup_ctls_msrs(&vmx->nested.msrs,
 					   vmx_capability.ept,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 841a794..36905cd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1376,6 +1376,16 @@ void kvm_residency_write(struct kvm_vcpu *vcpu,
 }
 EXPORT_SYMBOL_GPL(kvm_residency_write);
 
+static void kvm_residency_setup(struct kvm_vcpu *vcpu, struct kvm_residency_msr *msr,
+		u16 index, bool count_with_host)
+{
+	/* Preserve value on calls after the first */
+	u64 value = msr->index ? kvm_residency_read(vcpu, msr->index) : 0;
+	msr->delta_from_host = msr->count_with_host = count_with_host;
+	msr->index = index;
+	kvm_residency_write(vcpu, msr->index, value);
+}
+
 /*
  * Writes msr value into into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -3311,6 +3321,17 @@ static bool need_emulate_wbinvd(struct kvm_vcpu *vcpu)
 	return kvm_arch_has_noncoherent_dma(vcpu->kvm);
 }
 
+void kvm_core_residency_setup(struct kvm_vcpu *vcpu)
+{
+	kvm_residency_setup(vcpu, &vcpu->arch.core_cstate_msrs[0],
+		MSR_CORE_C3_RESIDENCY, kvm_mwait_in_guest(vcpu->kvm));
+	kvm_residency_setup(vcpu, &vcpu->arch.core_cstate_msrs[1],
+		MSR_CORE_C6_RESIDENCY, kvm_mwait_in_guest(vcpu->kvm));
+	kvm_residency_setup(vcpu, &vcpu->arch.core_cstate_msrs[2],
+		MSR_CORE_C7_RESIDENCY, kvm_mwait_in_guest(vcpu->kvm));
+}
+EXPORT_SYMBOL_GPL(kvm_core_residency_setup);
+
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	/* Address WBINVD may be executed by guest */
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index dc61dbd..123fc8d 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -284,6 +284,11 @@ bool kvm_vector_hashing_enabled(void);
 int x86_emulate_instruction(struct kvm_vcpu *vcpu, unsigned long cr2,
 			    int emulation_type, void *insn, int insn_len);
 
+u64 kvm_residency_read(struct kvm_vcpu *vcpu, u32 msr_index);
+void kvm_residency_write(struct kvm_vcpu *vcpu,
+				u32 msr_index, u64 value);
+void kvm_core_residency_setup(struct kvm_vcpu *vcpu);
+
 #define KVM_SUPPORTED_XCR0     (XFEATURE_MASK_FP | XFEATURE_MASK_SSE \
 				| XFEATURE_MASK_YMM | XFEATURE_MASK_BNDREGS \
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
-- 
2.7.4

