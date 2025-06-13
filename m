Return-Path: <kvm+bounces-49492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3775AD9538
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 21:18:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 302843BEDDD
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 19:17:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D89B2C08D8;
	Fri, 13 Jun 2025 19:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vv/e7TKX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E39424676D
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 19:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749842076; cv=none; b=qTT8HGVrZIm6SUiLIFKNfpes69etGNcE1gjUJutShJ1WAw2sQJ2xiDtqN4lGJNrbnFUiuA9QJz02PxPS8k+/QjNI1haM4T4ObBxA8TSk5g/CsGbuR2x9VCcR0eh4mljbWueIBUFzS3R3dxzyGIMS6XzVjVXECGyoG5Sm/VuRoDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749842076; c=relaxed/simple;
	bh=hswF6lmctPlGxMh6V3bWjkRNpWdm2SovJLGcWUYrYwM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l+BNOH48TYu1Al+5C0+HLv7NX5XH+h5MlcaqfaVLqwNj+bZkRZZJmXNXDEgpF7XouX7bvAlixmOrvWQa/WbfTFlf1b44l/dPhjxeUu+zdz8kFNlwf94mA/AdT6O+e6pb73BcwD702pTik2uvq2vdO4EEeA6QkzSDoA+OqeTv1bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vv/e7TKX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31171a736b2so3568674a91.1
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 12:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749842074; x=1750446874; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AnbSP+D7ZiPpVcXvLT2g1gRVnFtqWS+6/xDCQbiW3Bc=;
        b=vv/e7TKXltNaUwRf2DwfOS3/6pnJuxFx8OVF/Ud1BqM7lDzYvdJM0DTMCj/oX3iYkR
         nR3DFoVlyRRaMGRUhzCaa5MWeKy8CHjlugjyiFzg4mjhdeyAdj+UTLfOld6ADJ3AeB8S
         bfqNu6o7+v+1Jm1Xya2LYSd2s0MW+zt+7SDiXef0vcLyzjKIzgbTGDjZcIk2BUYTKexm
         HSHLDLuJ0FM1rpb1HxfyHpV+nBcdM6Oqlv3utZQmsPE7h1+PabDa72c1MPBJjwG3CRdk
         8o9pE66ZXdhL7zq7B7KWEtWCTbJ7ltMyeQRdnb+frWHsvILvDsazBI+wa3ecV08jpPIg
         M0tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749842074; x=1750446874;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AnbSP+D7ZiPpVcXvLT2g1gRVnFtqWS+6/xDCQbiW3Bc=;
        b=MVGV2rLtz+xQAC/EK6GUf5/Wj9A9rzdLrFm21D+jbPtUnI2KTNx+8XLwHGY8TQUREF
         ypKJT8jp+5UcqtU3GgJyTbRy+ItLjaetzWFc0l2TnXD07QBWvflWUXNWUVc/TpqqKbBA
         znX/NIX7Kw1ibWJQO4GDkTA7irAoxJ/PtzL1UYES4X9VATNcEJSFjaewPlcgUBMHmh4q
         m8CM7kxUxrJpZMwG7QJGsC2iFqkr7c9uhGM+W1SFmribVnvM/kTiouMR4AzF1W2gL8K8
         oHPOO3y5BIIA6j57tUSEm01Yfu4X2ZI2BMa/pGHI41vQ+kKhMlrxa3f4Xm5Cln5tGdDW
         Xnmg==
X-Forwarded-Encrypted: i=1; AJvYcCVrb82QdB33XvofV5Er/xn7iAo6njcTMbbqc5/ChFzCbTVHjxql00NRZsbozF57j9475uY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw64DW9tYEQ7xvxurbyjctTHUBwB+E0LAuIY1oz++1yRGWqFV1+
	F5V2rkt13XjO8j3tUpNqSej4yIqoVKI+vFtG+qHs78IMavLk8ROd6Eku5tiJidi28EPvGMbDzDq
	etg==
X-Google-Smtp-Source: AGHT+IHNH+3GY1JmOkm3+m7YtkR8+qb0XFiWbuv0avYIFVynX/fnoqVeMBVFhzkODxo7JHLUatWXvw6MmA==
X-Received: from pjbqn11.prod.google.com ([2002:a17:90b:3d4b:b0:311:4aa8:2179])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:582f:b0:313:bf67:b354
 with SMTP id 98e67ed59e1d1-313f1b87a40mr1426294a91.0.1749842073850; Fri, 13
 Jun 2025 12:14:33 -0700 (PDT)
Date: Fri, 13 Jun 2025 12:13:41 -0700
In-Reply-To: <20250613191359.35078-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613191359.35078-1-sagis@google.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613191359.35078-15-sagis@google.com>
Subject: [PATCH v7 14/30] KVM: selftests: TDX: Add TDX IO writes test
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

The test verifies IO writes of various sizes from the guest to the host.

Signed-off-by: Sagi Shahar <sagis@google.com>
---
 .../selftests/kvm/include/x86/tdx/tdcall.h    |  3 +
 tools/testing/selftests/kvm/x86/tdx_vm_test.c | 79 ++++++++++++++++++-
 2 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86/tdx/tdcall.h b/tools/testing/selftests/kvm/include/x86/tdx/tdcall.h
index a6c966e93486..e7440f7fe259 100644
--- a/tools/testing/selftests/kvm/include/x86/tdx/tdcall.h
+++ b/tools/testing/selftests/kvm/include/x86/tdx/tdcall.h
@@ -7,6 +7,9 @@
 #include <linux/bits.h>
 #include <linux/types.h>
 
+#define TDG_VP_VMCALL_SUCCESS 0x0000000000000000
+#define TDG_VP_VMCALL_INVALID_OPERAND 0x8000000000000000
+
 #define TDX_HCALL_HAS_OUTPUT BIT(0)
 
 #define TDX_HYPERCALL_STANDARD 0
diff --git a/tools/testing/selftests/kvm/x86/tdx_vm_test.c b/tools/testing/selftests/kvm/x86/tdx_vm_test.c
index 22143d16e0d1..f646da032004 100644
--- a/tools/testing/selftests/kvm/x86/tdx_vm_test.c
+++ b/tools/testing/selftests/kvm/x86/tdx_vm_test.c
@@ -308,6 +308,81 @@ void verify_get_td_vmcall_info(void)
 	printf("\t ... PASSED\n");
 }
 
+#define TDX_IO_WRITES_TEST_PORT 0x51
+
+/*
+ * Verifies IO functionality by writing values of different sizes
+ * to the host.
+ */
+void guest_io_writes(void)
+{
+	uint64_t byte_4 = 0xFFABCDEF;
+	uint64_t byte_2 = 0xABCD;
+	uint64_t byte_1 = 0xAB;
+	uint64_t ret;
+
+	ret = tdg_vp_vmcall_instruction_io(TDX_IO_WRITES_TEST_PORT, 1,
+					   PORT_WRITE, &byte_1);
+	tdx_assert_error(ret);
+
+	ret = tdg_vp_vmcall_instruction_io(TDX_IO_WRITES_TEST_PORT, 2,
+					   PORT_WRITE, &byte_2);
+	tdx_assert_error(ret);
+
+	ret = tdg_vp_vmcall_instruction_io(TDX_IO_WRITES_TEST_PORT, 4,
+					   PORT_WRITE, &byte_4);
+	tdx_assert_error(ret);
+
+	/* Write an invalid number of bytes. */
+	ret = tdg_vp_vmcall_instruction_io(TDX_IO_WRITES_TEST_PORT, 5,
+					   PORT_WRITE, &byte_4);
+	tdx_assert_error(ret);
+
+	tdx_test_success();
+}
+
+void verify_guest_writes(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	uint32_t byte_4;
+	uint16_t byte_2;
+	uint8_t byte_1;
+
+	vm = td_create();
+	td_initialize(vm, VM_MEM_SRC_ANONYMOUS, 0);
+	vcpu = td_vcpu_add(vm, 0, guest_io_writes);
+	td_finalize(vm);
+
+	printf("Verifying guest writes:\n");
+
+	tdx_run(vcpu);
+	tdx_test_assert_io(vcpu, TDX_IO_WRITES_TEST_PORT, 1, PORT_WRITE);
+	byte_1 = *(uint8_t *)((void *)vcpu->run + vcpu->run->io.data_offset);
+
+	tdx_run(vcpu);
+	tdx_test_assert_io(vcpu, TDX_IO_WRITES_TEST_PORT, 2, PORT_WRITE);
+	byte_2 = *(uint16_t *)((void *)vcpu->run + vcpu->run->io.data_offset);
+
+	tdx_run(vcpu);
+	tdx_test_assert_io(vcpu, TDX_IO_WRITES_TEST_PORT, 4, PORT_WRITE);
+	byte_4 = *(uint32_t *)((void *)vcpu->run + vcpu->run->io.data_offset);
+
+	TEST_ASSERT_EQ(byte_1, 0xAB);
+	TEST_ASSERT_EQ(byte_2, 0xABCD);
+	TEST_ASSERT_EQ(byte_4, 0xFFABCDEF);
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
@@ -315,7 +390,7 @@ int main(int argc, char **argv)
 	if (!is_tdx_enabled())
 		ksft_exit_skip("TDX is not supported by the KVM. Exiting.\n");
 
-	ksft_set_plan(5);
+	ksft_set_plan(6);
 	ksft_test_result(!run_in_new_process(&verify_td_lifecycle),
 			 "verify_td_lifecycle\n");
 	ksft_test_result(!run_in_new_process(&verify_report_fatal_error),
@@ -326,6 +401,8 @@ int main(int argc, char **argv)
 			 "verify_td_cpuid\n");
 	ksft_test_result(!run_in_new_process(&verify_get_td_vmcall_info),
 			 "verify_get_td_vmcall_info\n");
+	ksft_test_result(!run_in_new_process(&verify_guest_writes),
+			 "verify_guest_writes\n");
 
 	ksft_finished();
 	return 0;
-- 
2.50.0.rc2.692.g299adb8693-goog


