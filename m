Return-Path: <kvm+bounces-38253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0029A36B03
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:31:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A99A6170AE5
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A65AD157A46;
	Sat, 15 Feb 2025 01:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3GPe21Il"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581F2151985
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583032; cv=none; b=ZcyznAtUid6NBn3LCN+ESHsbfsRMqNgJRGYHpywIuv8KHXkR+sNH2Vs7aPfqJ1EbwiygDrt3K/wsCu84zgMq4SO8HyyzaapjTaETy3rIW1IpTva2BPFfFa3o2UWl4DHLoUZRQpk0rHhvooS2Rs71V2XlZY1cUEEcCBBflwtFMKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583032; c=relaxed/simple;
	bh=tuhGABPm7VtLbrad1GqHFCF4cq/RQ1jRy8bcAfPZkS8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Lhweej7gLJQlJtc7Ibk2u74qDGxpljklfeyEN3nn3XRdRsFED5BEnsuZ9gamExRAu79+LCMoW8pF87pbBvqNvOn97vkHe9K1H6O1D1DJhFQXOVFmgtzWWdYqlFtgZPHNpOD5wLINB8sDBjJRl+Sd7L+Gw2mps38RViveAonC0OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3GPe21Il; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc1a4c150bso5372764a91.2
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583030; x=1740187830; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WYeAkqtk80nvZ8OWOyCMTgMj5r0POJdH1xD2gcl0+QU=;
        b=3GPe21IlMnV8q7grNhg03uSnm99Jc8npI58a9GmdTrYMmygmRnppyC4qsiHpzEroBQ
         HCaXw6sjy1jxMw0KHxvQ09M3g60/xfJ5ETl93bjK1U3mOAZq0Y29c4o4VTh19rSuwosr
         kkmSs3onnqANxlhd65aLqg5z0MbPLPqFOMns0nuNh+oAQGT86tD+sx1/+BUGUcGVfyIx
         jv30j07svg5qr1faFnhKIVYoUgGLXCwsTjDgWwRbbR1gcfc3yzbyGl/BbLOiWmYQBH3l
         ESCOzr0gTzsyEAxGKNVvXniX1EMue33bjMCGiqkEUZ4YAl/LmfwEQKvPYfHKGA07LQ3a
         pUAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583030; x=1740187830;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WYeAkqtk80nvZ8OWOyCMTgMj5r0POJdH1xD2gcl0+QU=;
        b=Cz3DBegXGje6StaYHWOzVval1Eb9rVnt1HTDdGZXMO7C3uj1/soJj8NtWMG5oSyXV/
         tW/KAGaaMugcinp01uhD0MR6Y975i7wm+k1JUB0PKt/92syy4F1lFmlfKmhgzDNQGQsR
         cqT+nxk8egUs8Ps62oBCMDLo98Go1G07ftk5UOtBznywEkxvuIFnnuq3EgUebxC4m93L
         3aVN/CCGItU3z1jjp6m51ueUwrcSCs3xFASxQpsM4ly9q4tnXfrZDAwmVrkvrBUAOndv
         SwSa4YJBWqDAST/ae3gORHr55XYmdF7qjhJLnS7m1OCFX9j0II5O8AGd7pTK1PgCBA2H
         Rxdw==
X-Gm-Message-State: AOJu0YwmwyFUi3iZPRIuKki+fOws8k7xYXpKcOuuLPJExw1jcJfxcAGK
	RMzjjp7W83pCYSme1hLKSO3DuDpFTtWrUvMtBxWCAIGHIlQnAwBKMsFVFY3MGnRiSAM119WJLJW
	qpw==
X-Google-Smtp-Source: AGHT+IEIu2e5eN41nnBgprJR6+VxA5+J0XkX2HhVT/apooQ+SWt4g2IXBOjDQ3ARnQmBgSH4qdQsEKjZ16Y=
X-Received: from pjh12.prod.google.com ([2002:a17:90b:3f8c:b0:2ea:aa56:49c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2248:b0:2f7:7680:51a6
 with SMTP id 98e67ed59e1d1-2fc40d12e63mr1846074a91.6.1739583030563; Fri, 14
 Feb 2025 17:30:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:30:18 -0800
In-Reply-To: <20250215013018.1210432-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013018.1210432-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013018.1210432-7-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 6/6] nVMX: add a test for canonical checks
 of various host state vmcs12 fields.
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Maxim Levitsky <mlevitsk@redhat.com>

This test tests canonical VM entry checks of various host state fields
(mostly segment bases) in vmcs12.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20240907005440.500075-6-mlevitsk@redhat.com
[sean: print expected vs. actual in reports, use descriptive value names]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 167 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 167 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index ffe7064c..d9058b8c 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -10754,6 +10754,172 @@ static void vmx_exception_test(void)
 	test_set_guest_finished();
 }
 
+/*
+ * Arbitrary canonical values for validating direct writes in the host, e.g. to
+ * an MSR, and for indirect writes via loads from VMCS fields on VM-Exit.
+ */
+#define TEST_DIRECT_VALUE 	0xff45454545000000
+#define TEST_VMCS_VALUE		0xff55555555000000
+
+static void vmx_canonical_test_guest(void)
+{
+	while (true)
+		vmcall();
+}
+
+static int get_host_value(u64 vmcs_field, u64 *value)
+{
+	struct descriptor_table_ptr dt_ptr;
+
+	switch (vmcs_field) {
+	case HOST_SYSENTER_ESP:
+		*value = rdmsr(MSR_IA32_SYSENTER_ESP);
+		break;
+	case HOST_SYSENTER_EIP:
+		*value =  rdmsr(MSR_IA32_SYSENTER_EIP);
+		break;
+	case HOST_BASE_FS:
+		*value =  rdmsr(MSR_FS_BASE);
+		break;
+	case HOST_BASE_GS:
+		*value =  rdmsr(MSR_GS_BASE);
+		break;
+	case HOST_BASE_GDTR:
+		sgdt(&dt_ptr);
+		*value =  dt_ptr.base;
+		break;
+	case HOST_BASE_IDTR:
+		sidt(&dt_ptr);
+		*value =  dt_ptr.base;
+		break;
+	case HOST_BASE_TR:
+		*value = get_gdt_entry_base(get_tss_descr());
+		/* value might not reflect the actual base if changed by VMX */
+		return 1;
+	default:
+		assert(0);
+		return 1;
+	}
+	return 0;
+}
+
+static int set_host_value(u64 vmcs_field, u64 value)
+{
+	struct descriptor_table_ptr dt_ptr;
+
+	switch (vmcs_field) {
+	case HOST_SYSENTER_ESP:
+		return wrmsr_safe(MSR_IA32_SYSENTER_ESP, value);
+	case HOST_SYSENTER_EIP:
+		return wrmsr_safe(MSR_IA32_SYSENTER_EIP, value);
+	case HOST_BASE_FS:
+		return wrmsr_safe(MSR_FS_BASE, value);
+	case HOST_BASE_GS:
+		/* TODO: _safe variants assume per-cpu gs base*/
+		wrmsr(MSR_GS_BASE, value);
+		return 0;
+	case HOST_BASE_GDTR:
+		sgdt(&dt_ptr);
+		dt_ptr.base = value;
+		lgdt(&dt_ptr);
+		return lgdt_fep_safe(&dt_ptr);
+	case HOST_BASE_IDTR:
+		sidt(&dt_ptr);
+		dt_ptr.base = value;
+		return lidt_fep_safe(&dt_ptr);
+	case HOST_BASE_TR:
+		/* Set the base and clear the busy bit */
+		set_gdt_entry(FIRST_SPARE_SEL, value, 0x200, 0x89, 0);
+		return ltr_safe(FIRST_SPARE_SEL);
+	default:
+		assert(0);
+	}
+}
+
+static void test_host_value_direct(const char *field_name, u64 vmcs_field)
+{
+	u64 value = 0;
+	int vector;
+
+	/*
+	 * Set the directly register via host ISA (e.g lgdt) and check that we
+	 * got no exception.
+	 */
+	vector = set_host_value(vmcs_field, TEST_DIRECT_VALUE);
+	if (vector) {
+		report_fail("Exception %d when setting %s to 0x%lx via direct write",
+			    vector, field_name, TEST_DIRECT_VALUE);
+		return;
+	}
+
+	/*
+	 * Now check that the host value matches what we expect for fields
+	 * that can be read back (these that we can't we assume that are correct)
+	 */
+	report(get_host_value(vmcs_field, &value) || value == TEST_DIRECT_VALUE,
+	       "%s: HOST value set to 0x%lx (wanted 0x%lx) via direct write",
+	       field_name, value, TEST_DIRECT_VALUE);
+}
+
+static void test_host_value_vmcs(const char *field_name, u64 vmcs_field)
+{
+	u64 value = 0;
+
+	/* Set host state field in the vmcs and do the VM entry
+	 * Success of VM entry already shows that L0 accepted the value
+	 */
+	vmcs_write(vmcs_field, TEST_VMCS_VALUE);
+	enter_guest();
+	skip_exit_vmcall();
+
+	/*
+	 * Now check that the host value matches what we expect for fields
+	 * that can be read back (these that we can't we assume that are correct)
+	 */
+	report(get_host_value(vmcs_field, &value) || value == TEST_VMCS_VALUE,
+	       "%s: HOST value set to 0x%lx (wanted 0x%lx) via VMLAUNCH/VMRESUME",
+	       field_name, value, TEST_VMCS_VALUE);
+}
+
+static void do_vmx_canonical_test_one_field(const char *field_name, u64 field)
+{
+	u64 host_org_value, field_org_value;
+
+	/* Backup the current host value and vmcs field value values */
+	get_host_value(field, &host_org_value);
+	field_org_value = vmcs_read(field);
+
+	test_host_value_direct(field_name, field);
+	test_host_value_vmcs(field_name, field);
+
+	/* Restore original values */
+	vmcs_write(field, field_org_value);
+	set_host_value(field, host_org_value);
+}
+
+#define vmx_canonical_test_one_field(field) \
+	do_vmx_canonical_test_one_field(#field, field)
+
+static void vmx_canonical_test(void)
+{
+	report(!(read_cr4() & X86_CR4_LA57), "4 level paging");
+
+	if (!this_cpu_has(X86_FEATURE_LA57))
+		test_skip("5 level paging not supported");
+
+	test_set_guest(vmx_canonical_test_guest);
+
+	vmx_canonical_test_one_field(HOST_SYSENTER_ESP);
+	vmx_canonical_test_one_field(HOST_SYSENTER_EIP);
+	vmx_canonical_test_one_field(HOST_BASE_FS);
+	vmx_canonical_test_one_field(HOST_BASE_GS);
+	vmx_canonical_test_one_field(HOST_BASE_GDTR);
+	vmx_canonical_test_one_field(HOST_BASE_IDTR);
+	vmx_canonical_test_one_field(HOST_BASE_TR);
+
+	test_set_guest_finished();
+}
+
 enum Vid_op {
 	VID_OP_SET_ISR,
 	VID_OP_NOP,
@@ -11262,5 +11428,6 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_pf_invvpid_test),
 	TEST(vmx_pf_vpid_test),
 	TEST(vmx_exception_test),
+	TEST(vmx_canonical_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
-- 
2.48.1.601.g30ceb7b040-goog


