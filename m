Return-Path: <kvm+bounces-17723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BC7A8C8EC5
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 02:06:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA6CA1F2246A
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 00:06:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1F1F2A1BF;
	Sat, 18 May 2024 00:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F9/Y6jJF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52D52F3E
	for <kvm@vger.kernel.org>; Sat, 18 May 2024 00:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715990690; cv=none; b=gVi2WWk82laXsC7PJSybw9XRRgRZNcJLsjaWSpgz8ApLv91nlQO1Njr8cThyVavDcfw+P5I/oRHtROk6o/1B1kvbfjfpGfXdgnO1ce6paXesL5PfRMeAkIEF5XW+4S6VMVS+4CkrMokotkFdofePJlpiryHQgL0VulAEthCTFBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715990690; c=relaxed/simple;
	bh=G0H1ZribibIRAeIPrcFsCyVZimPoXaBX2C7zZ9WKf10=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s5r9wYF34XMMmX6BtRej6oZwIz+WRO90x6H7ljQ5QbNSxUJlf4++MRiF7BltoeCEY7pArgwqEiA8QSUmXfUw3FyRWNzvCdY9yeUhCpXTSV6LeMCzjgBxFYlyVspH2iw+tOgY0hUlc6LuCvcUd4zZ2SGWZsNipaj8FeEULu3pHqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F9/Y6jJF; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2b58c1d014bso7991361a91.1
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715990688; x=1716595488; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=F6tFR9z1vs8c6u2WtnRiVVbIp33RqmLFmChD3Ch8F40=;
        b=F9/Y6jJFhzewat4Cg4F+eQuIev0srhsroVkR8wbo1PmWIPhlRju6kAQkd2PzSkbUBz
         L3gYIcwPIFifCEn+9BgkbCv9ZHKKd/Qa6suXuu22bOWt/2Ev0MxEqzq6FUXnz/2mnlCq
         ZZD2z+xqNZ0xjnBWi7J7vK9lK611m6jtwKdNr0h3anFylsax9XOYwq8pMdq7osHyKzoZ
         gQbxapf4HX9Fp0AM+01Z1EmaVd76TN0QvN/Q53M/bFIktm1dCn4HrsGm1RTBMI4rwN9v
         SMSQzQXvsMm6YqD7Mm1RXT+pmAZ2oxp4SNJechiyHd/PoHdvlNu/kzTk5A7mI3x7tlR4
         wLGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715990688; x=1716595488;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F6tFR9z1vs8c6u2WtnRiVVbIp33RqmLFmChD3Ch8F40=;
        b=JVKc+NKYSHxv5hi4Aeusd2hUpb3U83fidaa/kbz83TaPeEVlbKjzCu+dxk2JvKU1Ty
         xal5ZxU30cZR5b0PyGP4zBjzD6hNg+fea7HMjukDo0veCdTbzteB6NmxZm8Fau8mOA7Q
         ZI3PkB/IbyeleVDGaMnotZgH0k1wFW9hqymhmiDSk6Zk4QijhQgtK1aL30+gP0ucFanj
         qZexPz2s5usk9zd+VMMyed6E89iuklL3e/RjFvX61pNTpjlln8C0nAIlYIix0oCMxow+
         zIE2dI5jOhxYTk0HOkm9sG3axjaRco4XNsGc8nRIUOrD65QSzuOR4tbCL1vWMKvvgm/Q
         pVmQ==
X-Gm-Message-State: AOJu0YzK/iWnjY2QSixRyRZ0jQBtZXlOd3t6dTKWAH6ffHvqxInkEo8l
	0QlytNa+AnsyawthkLGrVEZylbKeEzMxScf8tcmKu9LVakvp95hAXWHJj9XFpOXAn9KjNS5lp6G
	JGQ==
X-Google-Smtp-Source: AGHT+IHcIhWQz88cxjQfIWr9QqPrvA4yvrV/FRAF27BDNzjGzBtgW0NQ5/zWEknFAvdFH63hTP7V0CPnMDs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:9309:b0:2b2:ad92:da6d with SMTP id
 98e67ed59e1d1-2b6ccc73bbemr63870a91.4.1715990688132; Fri, 17 May 2024
 17:04:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 17:04:27 -0700
In-Reply-To: <20240518000430.1118488-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240518000430.1118488-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240518000430.1118488-7-seanjc@google.com>
Subject: [PATCH 6/9] KVM: x86/mmu: Print SPTEs on unexpected #VE
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Print the SPTEs that correspond to the faulting GPA on an unexpected EPT
Violation #VE to help the user debug failures, e.g. to pinpoint which SPTE
didn't have SUPPRESS_VE set.

Opportunistically assert that the underlying exit reason was indeed an EPT
Violation, as the CPU has *really* gone off the rails if a #VE occurs due
to a completely unexpected exit reason.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu/mmu.c          | 42 ++++++++++++++++++++++++++-------
 arch/x86/kvm/vmx/vmx.c          |  5 ++++
 3 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index aabf1648a56a..9bb2e164c523 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2159,6 +2159,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len);
+void kvm_mmu_print_sptes(struct kvm_vcpu *vcpu, gpa_t gpa, const char *msg);
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			     u64 addr, unsigned long roots);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d2af077d8b34..f2c9580d9588 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4124,6 +4124,22 @@ static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level
 	return leaf;
 }
 
+static int get_sptes_lockless(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+			      int *root_level)
+{
+	int leaf;
+
+	walk_shadow_page_lockless_begin(vcpu);
+
+	if (is_tdp_mmu_active(vcpu))
+		leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes, root_level);
+	else
+		leaf = get_walk(vcpu, addr, sptes, root_level);
+
+	walk_shadow_page_lockless_end(vcpu);
+	return leaf;
+}
+
 /* return true if reserved bit(s) are detected on a valid, non-MMIO SPTE. */
 static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 {
@@ -4132,15 +4148,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 	int root, leaf, level;
 	bool reserved = false;
 
-	walk_shadow_page_lockless_begin(vcpu);
-
-	if (is_tdp_mmu_active(vcpu))
-		leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes, &root);
-	else
-		leaf = get_walk(vcpu, addr, sptes, &root);
-
-	walk_shadow_page_lockless_end(vcpu);
-
+	leaf = get_sptes_lockless(vcpu, addr, sptes, &root);
 	if (unlikely(leaf < 0)) {
 		*sptep = 0ull;
 		return reserved;
@@ -5963,6 +5971,22 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
 
+void kvm_mmu_print_sptes(struct kvm_vcpu *vcpu, gpa_t gpa, const char *msg)
+{
+	u64 sptes[PT64_ROOT_MAX_LEVEL + 1];
+	int root_level, leaf, level;
+
+	leaf = get_sptes_lockless(vcpu, gpa, sptes, &root_level);
+	if (unlikely(leaf < 0))
+		return;
+
+	pr_err("%s %llx", msg, gpa);
+	for (level = root_level; level >= leaf; level--)
+		pr_cont(", spte[%d] = 0x%llx", level, sptes[level]);
+	pr_cont("\n");
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_print_sptes);
+
 static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 				      u64 addr, hpa_t root_hpa)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0c68643d982b..2a3fce61c785 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5218,7 +5218,12 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		return handle_ud(vcpu);
 
 	if (KVM_BUG_ON(is_ve_fault(intr_info), vcpu->kvm)) {
+		struct vmx_ve_information *ve_info = vmx->ve_info;
+
+		WARN_ONCE(ve_info->exit_reason != EXIT_REASON_EPT_VIOLATION,
+			  "Unexpected #VE on VM-Exit reason 0x%x", ve_info->exit_reason);
 		dump_vmcs(vcpu);
+		kvm_mmu_print_sptes(vcpu, ve_info->guest_physical_address, "#VE");
 		return -EIO;
 	}
 
-- 
2.45.0.215.g3402c0e53f-goog


