Return-Path: <kvm+bounces-49493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 20D82AD9535
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 21:18:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F8391BC2DA1
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 19:18:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5A372D9EE4;
	Fri, 13 Jun 2025 19:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vICYqu6+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B342D5C7C
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 19:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749842078; cv=none; b=kcIks+VJz6PsIrQ8P2B/pIpyMd8HQ1fzLYstqqWqq8AsQV4QHtJlzAetbiIkEk0gNHvNu8fyLn2CTcFqvnZLav5LALLDSCCnaphhbBnWv2kD08V3O/w4SgfqiUBGLfnyPpRUvLkIA3C0CU/nwx5RBuxyiKhF4oW5Ifvr7M1yHB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749842078; c=relaxed/simple;
	bh=XiUCLbM31t3A1Ia7PvUtd8HccsiSwrLOChGJmM4U9ME=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K3KzlGJmTznQ0KZLodK0c46p4nZ/32HPfdM01UpI3/9SIUJA6+mJZB5mXFbLvZZUllrmugj1R5gXWHWWvGrK/U8S/l1JLy+plMJq1meqQxfv8yoFeiJ5nH8pdcMBgNUoKwuW7DlDYrhyZ1BOo358K6jBB2nrj9etp26Ig87knyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vICYqu6+; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313d6d671ffso1421756a91.2
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 12:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749842076; x=1750446876; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SP57h7voyy8pTBZCNH4MEMrCXCzzIc1ZMbh9qeY2Ibg=;
        b=vICYqu6+M6+2t3YdF/M1am1DaC8J2LrFFbnm+qpeyaTwU6YMwjPlTJ3Wbi8o8/4jZl
         yOFNDBxtpkB/4rmTJAOyK5jRrGMfp114AQavRcOpPbEZP1CgCh3WyW42Y3UhvFiA0rN1
         ohLJ0ZxTPlgjxKJYKr5lwlkUeznmBPwqNrCGv9gJPjAOmPQN0U0zzF9kt1m4z7JoXyV7
         bfxyqk1xs/KM9oslN4eH7/rxj/cbMXosuwIiMs/bfxEByq2Bl2BslvimYrZcWDdTCOGG
         cB/VQty5+ybBX5px9R+6vDPPMb9KV4OWMT9I8eUqd6mPzs1sN/ArwIUDH3LFHs9Wj7aG
         jP9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749842076; x=1750446876;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SP57h7voyy8pTBZCNH4MEMrCXCzzIc1ZMbh9qeY2Ibg=;
        b=kj5MlGMJDQ5uFxRBYU0t9XDRUBdIa9t/umrLhcJ4UBUO6IwqwXJ+TlArpzWzcbCgKG
         5d5TMC6MYs3cLKbPByvoJcLqffqRuSdVyeV8Ngyb8Z6+rX/LHKRZlDlAu1x62TW1ysvp
         4/0hun/t2BlBft92YigvHbJpBHoSy3MhBEXGTlQGcCjuI9wDI35ULmcuDbX5ZaEPVng9
         DGyLhwg4JoFr/LkVlz53GYK6mEGDYBtaneUUo+IhSqiSo0vCUX3IS+9ONb2ntqm/S+Sf
         4odYHaUtDC2o0W242Ef9jrz6XqQSXnm6r3yeCKUYsYc+Ygb18fZgQPmxVH9vzouK14wC
         KLpg==
X-Forwarded-Encrypted: i=1; AJvYcCUZTd1mbIo0ykJUwn2YS6YXI/AH5J5nwA/8dDpBnScN8r/oeBbIMvT7rixQ7jZ6ot4YVLs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTffi1v4x5BbX3C2zK3D1Fvp1fzATeb8ifl3raZU2w9L46bJ2a
	2m+6E19u1HUzJsjstnPATCRK9Ldi0D7WWba0GO1tc9Wkn3q7Crtl7t4QkCqZNZ0E3rz6YI7M1dU
	isQ==
X-Google-Smtp-Source: AGHT+IELUXbtKEDjBs5GY4fdlAQg/ZPL5N4QXKAYA2nCb54Nuv3VGNUPELE6Q2Lncwpw2i1IMtNM9J4b3g==
X-Received: from pjf7.prod.google.com ([2002:a17:90b:3f07:b0:311:ea2a:3919])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e7c6:b0:313:2f45:2fc8
 with SMTP id 98e67ed59e1d1-313f1d5872amr1337825a91.18.1749842075331; Fri, 13
 Jun 2025 12:14:35 -0700 (PDT)
Date: Fri, 13 Jun 2025 12:13:42 -0700
In-Reply-To: <20250613191359.35078-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613191359.35078-1-sagis@google.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613191359.35078-16-sagis@google.com>
Subject: [PATCH v7 15/30] KVM: selftests: TDX: Add TDX IO reads test
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The test verifies IO reads of various sizes from the host to the guest.

Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/x86/tdx_vm_test.c | 76 ++++++++++++++++++-
 1 file changed, 75 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86/tdx_vm_test.c b/tools/testing/selftests/kvm/x86/tdx_vm_test.c
index f646da032004..ae5749e5c605 100644
--- a/tools/testing/selftests/kvm/x86/tdx_vm_test.c
+++ b/tools/testing/selftests/kvm/x86/tdx_vm_test.c
@@ -383,6 +383,78 @@ void verify_guest_writes(void)
 	printf("\t ... PASSED\n");
 }
 
+#define TDX_IO_READS_TEST_PORT 0x52
+
+/*
+ * Verifies IO functionality by reading values of different sizes
+ * from the host.
+ */
+void guest_io_reads(void)
+{
+	uint64_t data;
+	uint64_t ret;
+
+	ret = tdg_vp_vmcall_instruction_io(TDX_IO_READS_TEST_PORT, 1,
+					   PORT_READ, &data);
+	tdx_assert_error(ret);
+	if (data != 0xAB)
+		tdx_test_fatal(1);
+
+	ret = tdg_vp_vmcall_instruction_io(TDX_IO_READS_TEST_PORT, 2,
+					   PORT_READ, &data);
+	tdx_assert_error(ret);
+	if (data != 0xABCD)
+		tdx_test_fatal(2);
+
+	ret = tdg_vp_vmcall_instruction_io(TDX_IO_READS_TEST_PORT, 4,
+					   PORT_READ, &data);
+	tdx_assert_error(ret);
+	if (data != 0xFFABCDEF)
+		tdx_test_fatal(4);
+
+	/* Read an invalid number of bytes. */
+	ret = tdg_vp_vmcall_instruction_io(TDX_IO_READS_TEST_PORT, 5,
+					   PORT_READ, &data);
+	tdx_assert_error(ret);
+
+	tdx_test_success();
+}
+
+void verify_guest_reads(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = td_create();
+	td_initialize(vm, VM_MEM_SRC_ANONYMOUS, 0);
+	vcpu = td_vcpu_add(vm, 0, guest_io_reads);
+	td_finalize(vm);
+
+	printf("Verifying guest reads:\n");
+
+	tdx_run(vcpu);
+	tdx_test_assert_io(vcpu, TDX_IO_READS_TEST_PORT, 1, PORT_READ);
+	*(uint8_t *)((void *)vcpu->run + vcpu->run->io.data_offset) = 0xAB;
+
+	tdx_run(vcpu);
+	tdx_test_assert_io(vcpu, TDX_IO_READS_TEST_PORT, 2, PORT_READ);
+	*(uint16_t *)((void *)vcpu->run + vcpu->run->io.data_offset) = 0xABCD;
+
+	tdx_run(vcpu);
+	tdx_test_assert_io(vcpu, TDX_IO_READS_TEST_PORT, 4, PORT_READ);
+	*(uint32_t *)((void *)vcpu->run + vcpu->run->io.data_offset) = 0xFFABCDEF;
+
+	td_vcpu_run(vcpu);
+	TEST_ASSERT_EQ(vcpu->run->exit_reason, KVM_EXIT_SYSTEM_EVENT);
+	TEST_ASSERT_EQ(vcpu->run->system_event.data[12], TDG_VP_VMCALL_INVALID_OPERAND);
+
+	tdx_run(vcpu);
+	tdx_test_assert_success(vcpu);
+
+	kvm_vm_free(vm);
+	printf("\t ... PASSED\n");
+}
+
 int main(int argc, char **argv)
 {
 	ksft_print_header();
@@ -390,7 +462,7 @@ int main(int argc, char **argv)
 	if (!is_tdx_enabled())
 		ksft_exit_skip("TDX is not supported by the KVM. Exiting.\n");
 
-	ksft_set_plan(6);
+	ksft_set_plan(7);
 	ksft_test_result(!run_in_new_process(&verify_td_lifecycle),
 			 "verify_td_lifecycle\n");
 	ksft_test_result(!run_in_new_process(&verify_report_fatal_error),
@@ -403,6 +475,8 @@ int main(int argc, char **argv)
 			 "verify_get_td_vmcall_info\n");
 	ksft_test_result(!run_in_new_process(&verify_guest_writes),
 			 "verify_guest_writes\n");
+	ksft_test_result(!run_in_new_process(&verify_guest_reads),
+			 "verify_guest_reads\n");
 
 	ksft_finished();
 	return 0;
-- 
2.50.0.rc2.692.g299adb8693-goog


