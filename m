Return-Path: <kvm+bounces-26055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28DDE96FEC7
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 02:55:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 479931C21DCE
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 00:55:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 252F517571;
	Sat,  7 Sep 2024 00:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GleRFjFi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE70ADF53
	for <kvm@vger.kernel.org>; Sat,  7 Sep 2024 00:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725670492; cv=none; b=d3uwgvDbAom3PnfBagUBKTu5kn+UIMifSj51LmXBaQNH2udYlfkb/e0e3MukkELKc1e1JFcR0YMqXL1gcYdbMAiMVLobGB13on0um2IVziS5qLe3XoXwOC5r/cqkxmynhswvUnAIxOsnpvbq87EPkCEEDMsc0qa1dW9SLVjKOo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725670492; c=relaxed/simple;
	bh=F4ePPmI3gDH5O+DwY0vdY9lSgrLAMbdGPLLfp7ZeH4s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mtETk0ju6A9fXfq4DNeUeQPdJRgsGbgWdnjDN9DqMlzRlTFE7S9rY8FdvvQ6kSUQSx+51+h9s6VX4MipVnM/ZgZKfjPKZTnqWPiER3bcqTHadFhR4HVlrURs1u8tNA3I6C8XIJSNghimmyUzlaj5FylZV8lqB2+VbSVLqmSG4Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GleRFjFi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725670489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y4kLuQDMZmBfnp63eJmV4ivAZwFMoB3pkf7oqhzqTE8=;
	b=GleRFjFieJUPDiqXk+AA9uRMTw0xZ++WCSZ9mODzqVu1rkacQsvCCtmco8Zhxg7icOP8XF
	je8/2vjvjHFHNFGuDUb/uAKrA9U483+a5n5Osr59olyBWtHSRwles5oq9Dm5nt8/lD7L0P
	3N3DzdvExCkrg+p68GkMKjh7PxYNN1k=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-231--q0IpI-hPI6-Xs_KICb8bA-1; Fri,
 06 Sep 2024 20:54:48 -0400
X-MC-Unique: -q0IpI-hPI6-Xs_KICb8bA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5ED8D195608C
	for <kvm@vger.kernel.org>; Sat,  7 Sep 2024 00:54:47 +0000 (UTC)
Received: from starship.lan (unknown [10.22.65.51])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7BE1F19560AA;
	Sat,  7 Sep 2024 00:54:46 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [kvm-unit-tests PATCH 5/5] nVMX: add a test for canonical checks of various host state vmcs12 fields.
Date: Fri,  6 Sep 2024 20:54:40 -0400
Message-Id: <20240907005440.500075-6-mlevitsk@redhat.com>
In-Reply-To: <20240907005440.500075-1-mlevitsk@redhat.com>
References: <20240907005440.500075-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

This test tests canonical VM entry checks of various host state fields
(mostly segment bases) in vmcs12.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/vmx_tests.c | 183 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 183 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index ffe7064c9..b6f3d634d 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -10732,6 +10732,7 @@ static void handle_exception_in_l1(u32 vector)
 	vmcs_write(EXC_BITMAP, old_eb);
 }
 
+
 static void vmx_exception_test(void)
 {
 	struct vmx_exception_test *t;
@@ -10754,6 +10755,187 @@ static void vmx_exception_test(void)
 	test_set_guest_finished();
 }
 
+
+#define TEST_VALUE1  0xff45454545000000
+#define TEST_VALUE2  0xff55555555000000
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
+static void test_host_value_natively(const char *field_name, u64 vmcs_field, u64 value)
+{
+	int vector;
+	u64 actual_value;
+
+	/*
+	 * Set the register via host native interface (e.g lgdt) and check
+	 * that we got no exception
+	 */
+	vector = set_host_value(vmcs_field, value);
+	if (vector) {
+		report(false,
+		       "Exception %d when setting %s to 0x%lx via host",
+		       vector, field_name, value);
+		return;
+	}
+
+	/*
+	 * Now check that the host value matches what we expect for fields
+	 * that can be read back (these that we can't we assume that are correct)
+	 */
+
+	if (get_host_value(vmcs_field, &actual_value))
+		actual_value = value;
+
+	report(actual_value == value,
+	       "%s: HOST value is set to test value 0x%lx directly",
+	       field_name, value);
+}
+
+static void test_host_value_via_guest(const char *field_name, u64 vmcs_field, u64 value)
+{
+	u64 actual_value;
+
+	/* Set host state field in the vmcs and do the VM entry
+	 * Success of VM entry already shows that L0 accepted the value
+	 */
+	vmcs_write(vmcs_field, TEST_VALUE2);
+	enter_guest();
+	skip_exit_vmcall();
+
+	/*
+	 * Now check that the host value matches what we expect for fields
+	 * that can be read back (these that we can't we assume that are correct)
+	 */
+
+	if (get_host_value(vmcs_field, &actual_value))
+		actual_value = value;
+
+	/* Check that now the msr value is the same as the field value */
+	report(actual_value == TEST_VALUE2,
+	       "%s: HOST value is set to test value 0x%lx via VMLAUNCH/VMRESUME",
+	       field_name, value);
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
+	/*
+	 * Write TEST_VALUE1 57-canonical value on the host
+	 * and check that it was written correctly
+	 */
+	test_host_value_natively(field_name, field, TEST_VALUE1);
+
+	/*
+	 * Write TEST_VALUE2 57-canonical value on the host
+	 * via VM entry/exit and check that it was written correctly
+	 */
+	test_host_value_via_guest(field_name, field, TEST_VALUE2);
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
@@ -11262,5 +11444,6 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_pf_invvpid_test),
 	TEST(vmx_pf_vpid_test),
 	TEST(vmx_exception_test),
+	TEST(vmx_canonical_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
-- 
2.26.3


