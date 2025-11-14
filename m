Return-Path: <kvm+bounces-63135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 064B1C5ABBA
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:14:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1BF1A353A43
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:13:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7007C23183F;
	Fri, 14 Nov 2025 00:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="neaPAnkt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078DF2236F2
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079198; cv=none; b=Yjx2/Ebv4Srgq93k8bNyNLGIhrQKn+Ty4YV5h8LsRntMca651ZMlU4fug3cfwYHfhXxDCi/EuSgfXogKKVma4YS+CxC9sfCIrDDR+jl7aEwhQTTEG98qUU+bUZRgnwPfzh2fOQHkH/8R8FAqmYemZRHd9hofgVL2EaJ0T08LnMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079198; c=relaxed/simple;
	bh=vu67tuzPHLCFy0YzOpBEGrZxZJC+urVHfDf2+jP2UvQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DjumyfcKpoDBxqq71abAnY0h+s9+0dv8rxZXmSlkB/aBMZP2uBRicIV28lJHp3K/Lqqq0qCAfq0lD3v4LR2b1zKVZmiV7E/C0Thxmk2MmK6yjKH04cflxOgTCCsQdVrgRv2HsWWWFHrdsgLTOpv1FsitzzL8OLPYDxwt0h0hRiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=neaPAnkt; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-297dabf9fd0so18063175ad.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763079196; x=1763683996; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eNHtxgD+fgfG9mdNyD5148hwePcaMPNtkpA5K8DFl9I=;
        b=neaPAnktaxJAC8ljrpPpDhLcPW00nUV450+qHAoP55QYpcr2stzHngpnhmmTUyyR6L
         7vj5y95AO7B/ms3IGAfqoBXxMo58qMhPtK0dl1abeVMJ3Kp8EvuvR/dL+hlH14o+8XqN
         3zs5HJ8+1II9e5rJsA68ou/oIuuJZhWmFrf3qYKlZKSFE5nR104hqMYNhfzuAxorudE7
         xHPO/7lq0crPGviM0HmFg3BrsthuCaIKAyEwgt2/i69puzEt9gyugp2qdk4kIO7UOl7d
         dzfervRNgu2+V7p9mwksvaY+soRohrUpF0Uthyv6scyJoQyzGVsnMbmxk32ioBJhyz3Y
         //bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763079196; x=1763683996;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eNHtxgD+fgfG9mdNyD5148hwePcaMPNtkpA5K8DFl9I=;
        b=QslG2wYVmWanSZFOnICaAk0bbLqh4PnvkMNivfmpn9qODtSIwwFVdg7B4Va5PTfvOh
         IrneICONyIkhe1SZO4tDcV2PP2tIjwsqS2JEXN7B1qL5NIpkLavHvlrP80a20YSsdF7+
         nJE68lNY1LsvIhUIIBWzUYYeKp2Ynk6Sx0IWfgFqd0VyFWfArhv0A/DhD3knbCwycPlx
         oFB2azOv08OYlGaYkipnYdEjWq6SDcs9kHUCyeoZRWSU4JNplH85LIjL3/Be41N61NKQ
         rxN23qta5iqC+8YdGcDZa+/QT9funERCAumB6yhmcLpTEssAXa2cy2KuzKfjfn50H1SB
         x+SQ==
X-Gm-Message-State: AOJu0YyrgLridAPR0JVi9Nm0Se9X8bOUMmnAirJU0zgIrvaFyNc72NN8
	beoVjZHR0rlzAWeyvevriepPNWgaVa5d0HBUGTrEC501tJFOBC56tKUolOuKsTi1FW8Czsq6syw
	fS77IvQ==
X-Google-Smtp-Source: AGHT+IGyAI0lHmW9NZ2XVoiytv6tX9r5nMsipd1x8yrxJLDKDW1L3gZPq8CvVUSs9La3K7NuOfMASE3SEj0=
X-Received: from ple5.prod.google.com ([2002:a17:903:3585:b0:294:b1c4:8426])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f603:b0:295:7453:b580
 with SMTP id d9443c01a7336-2986a76a1e2mr8576325ad.58.1763079196271; Thu, 13
 Nov 2025 16:13:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 16:12:50 -0800
In-Reply-To: <20251114001258.1717007-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114001258.1717007-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114001258.1717007-10-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 09/17] x86: cet: Validate CET states during
 VMX transitions
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"

From: Chao Gao <chao.gao@intel.com>

Add tests to verify that CET states are correctly handled during VMX
transitions.

The following behaviors are verified:

1. Host states are loaded from VMCS iff "Load CET" VM-exit control is set
2. Guest states are loaded from VMCS iff "Load CET" VM-entry control is set
3. Guest states are saved to VMCS during VM exits unconditionally
4. Invalid guest or host CET states leads to VM entry failures.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/msr.h     |  1 +
 x86/unittests.cfg |  7 ++++
 x86/vmx.h         |  8 +++--
 x86/vmx_tests.c   | 81 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index cc4cb855..df6d3049 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -296,6 +296,7 @@
 #define MSR_IA32_FEATURE_CONTROL        0x0000003a
 #define MSR_IA32_TSC_ADJUST		0x0000003b
 #define MSR_IA32_U_CET                  0x000006a0
+#define MSR_IA32_S_CET                  0x000006a2
 #define MSR_IA32_PL3_SSP                0x000006a7
 #define MSR_IA32_PKRS			0x000006e1
 
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index acb8a8ba..ec07d26b 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -453,6 +453,13 @@ arch = x86_64
 groups = vmx nested_exception
 check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
 
+[vmx_cet_test]
+file = vmx.flat
+extra_params = -cpu max,+vmx -append "vmx_cet_test"
+arch = x86_64
+groups = vmx
+timeout = 240
+
 [debug]
 file = debug.flat
 arch = x86_64
diff --git a/x86/vmx.h b/x86/vmx.h
index 9cd90488..33373bd1 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -356,6 +356,7 @@ enum Encoding {
 	GUEST_PENDING_DEBUG	= 0x6822ul,
 	GUEST_SYSENTER_ESP	= 0x6824ul,
 	GUEST_SYSENTER_EIP	= 0x6826ul,
+	GUEST_S_CET		= 0x6828ul,
 
 	/* Natural-Width Host State Fields */
 	HOST_CR0		= 0x6c00ul,
@@ -369,7 +370,8 @@ enum Encoding {
 	HOST_SYSENTER_ESP	= 0x6c10ul,
 	HOST_SYSENTER_EIP	= 0x6c12ul,
 	HOST_RSP		= 0x6c14ul,
-	HOST_RIP		= 0x6c16ul
+	HOST_RIP		= 0x6c16ul,
+	HOST_S_CET		= 0x6c18ul,
 };
 
 #define VMX_ENTRY_FAILURE	(1ul << 31)
@@ -449,6 +451,7 @@ enum Ctrl_exi {
 	EXI_SAVE_EFER		= 1UL << 20,
 	EXI_LOAD_EFER		= 1UL << 21,
 	EXI_SAVE_PREEMPT	= 1UL << 22,
+	EXI_LOAD_CET		= 1UL << 28,
 };
 
 enum Ctrl_ent {
@@ -457,7 +460,8 @@ enum Ctrl_ent {
 	ENT_LOAD_PERF		= 1UL << 13,
 	ENT_LOAD_PAT		= 1UL << 14,
 	ENT_LOAD_EFER		= 1UL << 15,
-	ENT_LOAD_BNDCFGS	= 1UL << 16
+	ENT_LOAD_BNDCFGS	= 1UL << 16,
+	ENT_LOAD_CET		= 1UL << 20,
 };
 
 enum Ctrl_pin {
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 0b3cfe50..6383bc83 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -11377,6 +11377,85 @@ static void vmx_posted_interrupts_test(void)
 	enter_guest();
 }
 
+static u64 guest_s_cet = -1;
+
+static void vmx_cet_test_guest(void)
+{
+	guest_s_cet = rdmsr(MSR_IA32_S_CET);
+	vmcall();
+}
+
+static void vmx_cet_test(void)
+{
+	struct vmcs *curr;
+	u64 val;
+
+	if (!(ctrl_exit_rev.clr & EXI_LOAD_CET)) {
+		report_skip("Load CET state exit control is not available");
+		return;
+	}
+
+	if (!(ctrl_enter_rev.clr & ENT_LOAD_CET)) {
+		report_skip("Load CET state entry control is not available");
+		return;
+	}
+
+	/* Allow the guest to read GUEST_S_CET directly */
+	msr_bmp_init();
+
+	/*
+	 * Check whether VMCS transitions load host and guest values
+	 * according to the settings of the relevant VM-entry and exit
+	 * controls.
+	 */
+	vmcs_write(HOST_S_CET, 2);
+	vmcs_write(GUEST_S_CET, 2);
+	test_set_guest(vmx_cet_test_guest);
+
+	enter_guest();
+	val = rdmsr(MSR_IA32_S_CET);
+
+	/* Validate both guest/host S_CET MSR have the default values */
+	report(val == 0 && guest_s_cet == 0, "Load CET state disabled");
+
+	/*
+	 * CPU supports the 1-setting of the 'load CET' VM-entry control,
+	 * the contents of the IA32_S_CET and IA32_INTERRUPT_SSP_TABLE_ADDR
+	 * MSRs are saved into the corresponding fields
+	 */
+	report(vmcs_read(GUEST_S_CET) == 0, "S_CET is unconditionally saved");
+
+	/* Enable load CET state entry/exit controls and retest */
+	vmcs_set_bits(EXI_CONTROLS, EXI_LOAD_CET);
+	vmcs_set_bits(ENT_CONTROLS, ENT_LOAD_CET);
+	vmcs_write(GUEST_S_CET, 2);
+	test_override_guest(vmx_cet_test_guest);
+
+	enter_guest();
+	val = rdmsr(MSR_IA32_S_CET);
+
+	/* Validate both guest/host S_CET MSR are loaded from VMCS */
+	report(val == 2 && guest_s_cet == 2, "Load CET state enabled");
+
+	/*
+	 * Validate that bit 10 (SUPPRESS) and Bit 11 (TRACKER) cannot be
+	 * both set
+	 */
+	val = BIT(10) | BIT(11);
+	vmcs_write(GUEST_S_CET, val);
+	test_guest_state("Load invalid guest CET state", true, val, "GUEST_S_CET");
+
+	/* Following test_vmx_vmlaunch() needs a "not launched" VMCS */
+	vmcs_save(&curr);
+	vmcs_clear(curr);
+	make_vmcs_current(curr);
+
+	vmcs_write(HOST_S_CET, val);
+	test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+
+	test_set_guest_finished();
+}
+
 #define TEST(name) { #name, .v2 = name }
 
 /* name/init/guest_main/exit_handler/syscall_handler/guest_regs */
@@ -11490,5 +11569,7 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_pf_vpid_test),
 	TEST(vmx_exception_test),
 	TEST(vmx_canonical_test),
+	/* "Load CET" VM-entry/exit controls tests. */
+	TEST(vmx_cet_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
-- 
2.52.0.rc1.455.g30608eb744-goog


