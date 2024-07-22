Return-Path: <kvm+bounces-22073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 505C0939737
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 01:59:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB92CB21862
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 23:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A70416A342;
	Mon, 22 Jul 2024 23:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h7aE2jfC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380BC17BCD
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 23:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721692767; cv=none; b=sPxRUK5vdi+LGVw2Ffb1zYTSuQVaomEHMlo6OJeWo6dtaUJOKFdImmaG+ULQZD2UUowfgU8KOrX7spzy638pp0Q4Ocw40elu+/33OCbY517VNBBbrkhB2iuv7iPhJEw/Wqg8vUCiigymyqteLsw4gXMfzsx18WdIrXp6br1KXsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721692767; c=relaxed/simple;
	bh=7DJkcqfbiIJw8y8meEfqCDF4uloJkbR/JLCUcj9GkK0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IkFp2qzXXRkDGzMIktqX3fjiKT22qpuHjdsaH4y8C59gFDM7hb39rwA2LUhLevZpad0Z+HbxYCYtMbFveGlTzbM4PmPHgAb4mLNfeodDhxIIMc70TvfHSekjkIxWwR2yM4K4BYDeYykhScQk4vktRE9guxGAnA1oZQglhCZBHzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h7aE2jfC; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e02b7adfb95so10538650276.2
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 16:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721692765; x=1722297565; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jIZbpEZ5rQHg2l2abLN3jpiDoDaWQbvMPk1rX68w1Ng=;
        b=h7aE2jfCZuewT76lJibcOTnbBYle+Lze8hmYy7Ra1gB56cr8siaH6dM2ccCvfvhp69
         RnSRVfNSmo43F8mOf9kOquuUY+v4QVFyvW7U1TS1Yd4RDzxLMHhO73WR3DoqoDamzCyq
         xb9D08F59JBwAXnuqv/cihg5sz/KFCiTQA/RTNCb1mO5VvTQoC2NxJrNIAd1/Qv2Tqqe
         kk/9sXHBZeghHbA1ic+gLn1DdlpZpwUeI2q9eiIdmx7rCKmzkcFJv6ELGiyA7ssqMZAW
         mt8+LRqU/r22uQVWFHSjB0H9XCobqDZGE5wh14ntd7H7UYmNe8uTde3B7sCjm4u4JqPf
         OTVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721692765; x=1722297565;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jIZbpEZ5rQHg2l2abLN3jpiDoDaWQbvMPk1rX68w1Ng=;
        b=NtD5lIdjagTmsWkVoUdZQthKhdebyTLtJA7POWksyDxSP/UmFoMC7jI9d6dk12Vuqi
         ZQ+mS76yGz6pTs4ZTpp2FCxq9r/0ec0v/lPZK5SxPkF4JvxIu4qhleAx6hGot4QXTi2g
         CSR/RGNqHHoM1jKZ91atMwkjqwm6980+6mOL5B+N7WI9DEDOXVEcZpXKF8BPGGE2Bqvd
         LPxdoKsd4Ec2A5oqRobJmkCfQ2wuOhSSIt4tAjmuZIqQvQskAZBAR4AUfPBLA9cfqfMx
         Kr+WrsQ5HL7a7rJBF8UfIqJ6bObxwfWdwOj36rlJNzB9UBhzC33Kl84tq9kWSMJRkQuA
         188A==
X-Gm-Message-State: AOJu0YzCKOx5OOXLf7q0/u6kTPyX60zGLSL3xvOYqcDzchyuxOy0jKig
	eRYBimBYwaXbITfr38dN3JhD0cmwdlWe16cfVz9XU3Hunv9OMtS93XSSOfAi+saQkEVEFE8pj2U
	vTQ==
X-Google-Smtp-Source: AGHT+IFcimbsqyOG/qvbE60GZOEvk25xTTC2e43d8+QS/h1am29TATI9J8tkk0GYefunh8u/rNyHUKceoAs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:804e:0:b0:e03:53a4:1a7 with SMTP id
 3f1490d57ef6-e087046cademr40372276.10.1721692765078; Mon, 22 Jul 2024
 16:59:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 22 Jul 2024 16:59:22 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240722235922.3351122-1-seanjc@google.com>
Subject: [PATCH] KVM: nVMX: Honor userspace MSR filter lists for nested VM-Enter/VM-Exit
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Synthesize a consistency check VM-Exit (VM-Enter) or VM-Abort (VM-Exit) if
L1 attempts to load/store an MSR via the VMCS MSR lists that userspace has
disallowed access to via an MSR filter.  Intel already disallows including
a handful of "special" MSRs in the VMCS lists, so denying access isn't
completely without precedent.

More importantly, the behavior is well-defined _and_ can be communicated
the end user, e.g. to the customer that owns a VM running as L1 on top of
KVM.  On the other hand, ignoring userspace MSR filters is all but
guaranteed to result in unexpected behavior as the access will hit KVM's
internal state, which is likely not up-to-date.

Unlike KVM-internal accesses, instruction emulation, and dedicated VMCS
fields, the MSRs in the VMCS load/store lists are 100% guest controlled,
thus making it all but impossible to reason about the correctness of
ignoring the MSR filter.  And if userspace *really* wants to deny access
to MSRs via the aforementioned scenarios, userspace can hide the
associated feature from the guest, e.g. by disabling the PMU to prevent
accessing PERF_GLOBAL_CTRL via its VMCS field.  But for the MSR lists, KVM
is blindly processing MSRs; the  MSR filters are the _only_ way for
userspace to deny access.

This partially reverts commit ac8d6cad3c7b ("KVM: x86: Only do MSR
filtering when access MSR by rdmsr/wrmsr").

Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

I found this by inspection when backporting Hou's change to an internal kernel.
I don't love piggybacking Intel's "you can't touch these special MSRs" behavior,
but ignoring the userspace MSR filters is far worse IMO.  E.g. if userspace is
denying access to an MSR in order to reduce KVM's attack surface, letting L1
sneak in reads/writes through VM-Enter/VM-Exit completely circumvents the
filters.

 Documentation/virt/kvm/api.rst  | 19 ++++++++++++++++---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/vmx/nested.c       | 12 ++++++------
 arch/x86/kvm/x86.c              |  6 ++++--
 4 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 8e5dad80b337..e6b1e42186f3 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4226,9 +4226,22 @@ filtering. In that mode, ``KVM_MSR_FILTER_DEFAULT_DENY`` is invalid and causes
 an error.
 
 .. warning::
-   MSR accesses as part of nested VM-Enter/VM-Exit are not filtered.
-   This includes both writes to individual VMCS fields and reads/writes
-   through the MSR lists pointed to by the VMCS.
+   MSR accesses that are side effects of instruction execution (emulated or
+   native) are not filtered as hardware does not honor MSR bitmaps outside of
+   RDMSR and WRMSR, and KVM mimics that behavior when emulating instructions
+   to avoid pointless divergence from hardware.  E.g. RDPID reads MSR_TSC_AUX,
+   SYSENTER reads the SYSENTER MSRs, etc.
+
+   MSRs that are loaded/stored via dedicated VMCS fields are not filtered as
+   part of VM-Enter/VM-Exit emulation.
+
+   MSRs that are loaded/store via VMX's load/store lists _are_ filtered as part
+   of VM-Enter/VM-Exit emulation.  If an MSR access is denied on VM-Enter, KVM
+   synthesizes a consistency check VM-Exit(EXIT_REASON_MSR_LOAD_FAIL).  If an
+   MSR access is denied on VM-Exit, KVM synthesizes a VM-Abort.  In short, KVM
+   extends Intel's architectural list of MSRs that cannot be loaded/saved via
+   the VM-Enter/VM-Exit MSR list.  It is platform owner's responsibility to
+   to communicate any such restrictions to their end users.
 
    x2APIC MSR accesses cannot be filtered (KVM silently ignores filters that
    cover any x2APIC MSRs).
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 950a03e0181e..94d0bedc42ee 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2059,6 +2059,8 @@ void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu);
 
 void kvm_enable_efer_bits(u64);
 bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
+int kvm_get_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 *data);
+int kvm_set_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 data);
 int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data, bool host_initiated);
 int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data);
 int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2392a7ef254d..674f7089cc44 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -981,7 +981,7 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 				__func__, i, e.index, e.reserved);
 			goto fail;
 		}
-		if (kvm_set_msr(vcpu, e.index, e.value)) {
+		if (kvm_set_msr_with_filter(vcpu, e.index, e.value)) {
 			pr_debug_ratelimited(
 				"%s cannot write MSR (%u, 0x%x, 0x%llx)\n",
 				__func__, i, e.index, e.value);
@@ -1017,7 +1017,7 @@ static bool nested_vmx_get_vmexit_msr_value(struct kvm_vcpu *vcpu,
 		}
 	}
 
-	if (kvm_get_msr(vcpu, msr_index, data)) {
+	if (kvm_get_msr_with_filter(vcpu, msr_index, data)) {
 		pr_debug_ratelimited("%s cannot read MSR (0x%x)\n", __func__,
 			msr_index);
 		return false;
@@ -1112,9 +1112,9 @@ static void prepare_vmx_msr_autostore_list(struct kvm_vcpu *vcpu,
 			/*
 			 * Emulated VMEntry does not fail here.  Instead a less
 			 * accurate value will be returned by
-			 * nested_vmx_get_vmexit_msr_value() using kvm_get_msr()
-			 * instead of reading the value from the vmcs02 VMExit
-			 * MSR-store area.
+			 * nested_vmx_get_vmexit_msr_value() by reading KVM's
+			 * internal MSR state instead of reading the value from
+			 * the vmcs02 VMExit MSR-store area.
 			 */
 			pr_warn_ratelimited(
 				"Not enough msr entries in msr_autostore.  Can't add msr %x\n",
@@ -4806,7 +4806,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 				goto vmabort;
 			}
 
-			if (kvm_set_msr(vcpu, h.index, h.value)) {
+			if (kvm_set_msr_with_filter(vcpu, h.index, h.value)) {
 				pr_debug_ratelimited(
 					"%s WRMSR failed (%u, 0x%x, 0x%llx)\n",
 					__func__, j, h.index, h.value);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index af6c8cf6a37a..7b3659a05c27 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1942,19 +1942,21 @@ static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
-static int kvm_get_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 *data)
+int kvm_get_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 *data)
 {
 	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ))
 		return KVM_MSR_RET_FILTERED;
 	return kvm_get_msr_ignored_check(vcpu, index, data, false);
 }
+EXPORT_SYMBOL_GPL(kvm_get_msr_with_filter);
 
-static int kvm_set_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 data)
+int kvm_set_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 data)
 {
 	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_WRITE))
 		return KVM_MSR_RET_FILTERED;
 	return kvm_set_msr_ignored_check(vcpu, index, data, false);
 }
+EXPORT_SYMBOL_GPL(kvm_set_msr_with_filter);
 
 int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data)
 {

base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.45.2.1089.g2a221341d9-goog


