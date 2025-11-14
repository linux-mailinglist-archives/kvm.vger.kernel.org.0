Return-Path: <kvm+bounces-63264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F19A0C5F48B
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:52:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7BCB34E6EF2
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 798BC2FE56B;
	Fri, 14 Nov 2025 20:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P1PgK/Nj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F2E2FC871
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763153481; cv=none; b=N20uqlUWQ8kRho9kdHQ/5LbY70BIXnxqVySTJU8Z36X1uggImLxXKYhZBP1+T6SM8l4pIChqLoMWkvdoK0JwmghIIXRgNjjai7WD0V8h2UZiZurlCvVVnAYc5cJa1xIYjdPKVibLZpP4c/LS8CltuGQD8oWUjheZeEYFbwRASzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763153481; c=relaxed/simple;
	bh=V1sB4MSiiZ0FTayoRn+54+UJ3Sc/4gYMTadDILH/xug=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S1sq/8v8PrZgE60QiHmuaWHAiTnJaLMYEtG0dn8VTpUPZKV7bTZbVwlY5MoB68bX4dV7dQjhFX3OGxbnsjrhJirg5l/cuRojC29xT3ObBBX2fUiqKQAB5cavJBFUzfEV+irh9LCIe0AmUZfpm0lkDV1nJOkTXPsbBNg09Dc5+bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P1PgK/Nj; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b90740249dso5076153b3a.0
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763153479; x=1763758279; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wRoimUhbuqlPy4q0DzGEvUZK4Je319xyfSwM/VwOamU=;
        b=P1PgK/Nj267yiLV7KVS5fjVWrBxFSWukOPPuVnASQHa2lDX/IMiP1DcePvPsKz47rn
         aCU++u4qNXzIcQ86avOgkUng0/oSoIrYvW9iFtFqR5ArvDGmxbzSgcso7WIREm9z0moE
         31EPZeXZpDM8ceoxgFL4XG8x9O+PmnqDamcjTnJu8Iud05W2Abxp1NFWWfdqyVJ/2FgY
         2b2vLFr55IgWszZxmy21It9HPcYvxGpWGrGHcwDqnCTcHYTpzOygv3/ng7WeTxxfSP/3
         lWIMY4FfAEKcOY/JPZQjn0L1eRGNZ68BvDA8+g69Q6c+wKIe3tGM6CE3JwWkEO58uotf
         SVGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763153479; x=1763758279;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wRoimUhbuqlPy4q0DzGEvUZK4Je319xyfSwM/VwOamU=;
        b=qS3gjwzAYNmAZbRZ5DuJRlyOcT08Jk1JZIQsflgZlV9M55VsAF1ttQYfH9eFP4qBDC
         bxMSSY+RASpIWoTp5T+F/qIV5GEsPPxBEV2LKKngzfMinO/GIy6l1b0FoDyjZxkLAupu
         rOVQsqbdsck0BVuSg1iNuaPe6tQom27+hdhVrZGNjTbzghb+B5gnctXScIdshmO1XDJZ
         cTS50gkwU6Z0J9hmrY5tQozp8zbQGgVqzgX0IBDsnuAPxsGybO7W8aJ8teDG6zZowcp9
         i9N8TTvEkv+e3q1MXf18Ck37cgPw+T3NFAQOV2Z4m2H/HYRdmZahmqTyCSkfv35cdg4O
         LHuQ==
X-Gm-Message-State: AOJu0Yxn8WezexbEHYuTJJQtRVaP5TMMbg2TaaoYpw9N6Jy3IOcZe3qD
	qU/gSelfgpFfwrEnU6/2m1NTzCnQqo9mrE2eVNuXKmoMGLs5em+RJhUUBSHTA8qMp4pKwKc/jHC
	Jjm2DGw==
X-Google-Smtp-Source: AGHT+IFyWeT4Rd4dq5spTSyEP2cCoEsg7NtP1Z95Uz/SY9JjwjO6YxR448JWUKvBLu/5PDN1W2iZom6y91Q=
X-Received: from pgbdo13.prod.google.com ([2002:a05:6a02:e8d:b0:b89:ec91:c4dc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:958e:b0:34e:63bd:81b4
 with SMTP id adf61e73a8af0-35b9f985803mr5179838637.7.1763153479333; Fri, 14
 Nov 2025 12:51:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Nov 2025 12:50:50 -0800
In-Reply-To: <20251114205100.1873640-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114205100.1873640-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114205100.1873640-9-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 08/18] x86: cet: Validate CET states during
 VMX transitions
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>, Sean Christopherson <seanjc@google.com>
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
[sean: drop "_test" from config name]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/msr.h     |  1 +
 x86/unittests.cfg |  8 +++++
 x86/vmx.h         |  8 +++--
 x86/vmx_tests.c   | 81 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 96 insertions(+), 2 deletions(-)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index e586a8e9..7397809c 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -300,6 +300,7 @@
 #define MSR_IA32_FEATURE_CONTROL        0x0000003a
 #define MSR_IA32_TSC_ADJUST		0x0000003b
 #define MSR_IA32_U_CET                  0x000006a0
+#define MSR_IA32_S_CET                  0x000006a2
 #define MSR_IA32_PL3_SSP                0x000006a7
 #define MSR_IA32_PKRS			0x000006e1
 
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index acb8a8ba..ff537d3f 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -453,6 +453,14 @@ arch = x86_64
 groups = vmx nested_exception
 check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
 
+[vmx_cet]
+file = vmx.flat
+test_args = "vmx_cet_test"
+qemu_params = -cpu max,+vmx
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
index 5c8c9f31..5ffb80a3 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -11382,6 +11382,85 @@ static void vmx_posted_interrupts_test(void)
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
@@ -11495,5 +11574,7 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_pf_vpid_test),
 	TEST(vmx_exception_test),
 	TEST(vmx_canonical_test),
+	/* "Load CET" VM-entry/exit controls tests. */
+	TEST(vmx_cet_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
-- 
2.52.0.rc1.455.g30608eb744-goog


