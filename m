Return-Path: <kvm+bounces-43313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C3CFCA88E88
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 23:57:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D4C34189A40B
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 21:57:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16FD223817A;
	Mon, 14 Apr 2025 21:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RLxdKTY8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA9B237709
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 21:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744667367; cv=none; b=F4DarduT/MdkLn9t5x4gfd7HsdLkHIal6y4KHs1YZWA7p3GKIutnLMYaulNWeFGPikrB0Q59D9/f8QtWO3cWdIVmvPi+9E5zaraREDlXtplPGLTZ+Napq5O8nSKW5WSmcv7s6U/CZDvBLREcQO2LLeidQYwY62CI3j2bd7OynTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744667367; c=relaxed/simple;
	bh=0s0eRAzp79ZyqJlag/s9T0KZQwLlfgI5CTpQtvOBf1o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gr01X9bq2xqLkENlk86WRbaon21t3N5RxxFUxIlxjelFb0knQpR+2g2BVcxv+IDpqU50W+G5WHK/p6wgwJs1/Z9joWuROZVqBtvlc//ZVSAHLnd4y5ijoCy5hkFHHGYT3l11B21S55gtAQ6585oGhzZ2Ya9Z1aWX1rWq5AlEdoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RLxdKTY8; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7377139d8b1so3536977b3a.0
        for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 14:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744667364; x=1745272164; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PBSumKkK0GopQQbf4kIGENs+zTxb+YbX4N+rBsmVgUU=;
        b=RLxdKTY8Kax25vuWCeEG7w9NP835NfPOog24dW4r0CUYdEQ8k8HYWsp9mj2Wulb1Xy
         UfOu8nDE1BRZCvc8rTRVNlHoRrhIzxu3S619npXswMfnDVfK/2woTnLBT7qJdShxYP0s
         hwD9PkN4IsgJLoB6MpoE1gm+hqd5Z75SZf1msf7UdjQdly4VPyRKJpnTwC5dUXaeExG8
         IqA+/KLQBR7Rq0O0ZlESYtAJHgAhJtgfrIsXBBO0xxu/uedkYKdyROJDhxHtuAjyW4Uc
         oY5gDtBiXk4H+IIyjPrj8UawxI1nyptQCSnLhsLoGTo8S+TNS8+IDRUkjIF9NN3BzYNX
         s94w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744667364; x=1745272164;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PBSumKkK0GopQQbf4kIGENs+zTxb+YbX4N+rBsmVgUU=;
        b=B1Dl7YEIdj3C5xTC4xcDWJOabU7HPPQ95Z6uB13av+I9n8BQFFqsPKx4rIGJQ7jV6G
         7uZiQ+hHWuzt2PhaMEsGArXn7OlSkTcfJhSYS0LOnEP4nK1nFaJyW+VsVpH9gm1q8STr
         Gw0PmxYEBQdMXOjl6Aqy8e/cpQXiicncJ0FxcZVoS9km3HgkQM9wBdbU0KXM5txSGqqU
         V3pzg+ILi7/G5Aj2Ca4tPcjYhbpETX/+4SypPWw/S+oCU+gm8QA9b6J1uQp2sdAsiTCF
         SlB8YAqBtVFLrf11pUvTut1OanNV/PfO0kHoE5EZg1UsaMmn26VZDpm4Dk9EXjF9y7+4
         lj3w==
X-Forwarded-Encrypted: i=1; AJvYcCX3i7EZonBxb0+2MV/+cpNyN1I8q+xBBPJxJNNnqJDTqRmF4T0yr76VcsVf9+m2OZ2c96Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yywb3rfO7r9BUqOW8HJhd6EY1RsAuidnVSPSOnu/wdx1XDq99wB
	enkwPdDZmKuM7k6iBB00YUt6RzLKOIcmftVGGoPa4ju7CWmw98040hSqaf6szTOX1L58rkIdSg=
	=
X-Google-Smtp-Source: AGHT+IGAf9r8FGSlKp+K/4EeU8L9n+YGVWZYWn0f4xUb+jtnHNJ+DjWrf/1g8NbljgvPb7hNXCk6l26e0g==
X-Received: from pfbha18.prod.google.com ([2002:a05:6a00:8512:b0:736:59f0:d272])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2286:b0:736:4110:5579
 with SMTP id d2e1a72fcca58-73bd119d755mr17279180b3a.2.1744667364222; Mon, 14
 Apr 2025 14:49:24 -0700 (PDT)
Date: Mon, 14 Apr 2025 14:47:59 -0700
In-Reply-To: <20250414214801.2693294-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250414214801.2693294-1-sagis@google.com>
X-Mailer: git-send-email 2.49.0.777.g153de2bbd5-goog
Message-ID: <20250414214801.2693294-31-sagis@google.com>
Subject: [PATCH v6 30/30] KVM: selftests: TDX: Test LOG_DIRTY_PAGES flag to a
 non-GUEST_MEMFD memslot
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Yan Zhao <yan.y.zhao@intel.com>

Add a selftest to verify that adding flag KVM_MEM_LOG_DIRTY_PAGES to a
!KVM_MEM_GUEST_MEMFD memslot does not produce host errors in TDX.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/x86/tdx_vm_test.c | 45 ++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86/tdx_vm_test.c b/tools/testing/selftests/kvm/x86/tdx_vm_test.c
index 82acc17a66ab..410d814dd39a 100644
--- a/tools/testing/selftests/kvm/x86/tdx_vm_test.c
+++ b/tools/testing/selftests/kvm/x86/tdx_vm_test.c
@@ -1167,6 +1167,47 @@ void verify_tdcall_vp_info(void)
 	printf("\t ... PASSED\n");
 }
 
+#define TDX_LOG_DIRTY_PAGES_FLAG_TEST_GPA (0xc0000000)
+#define TDX_LOG_DIRTY_PAGES_FLAG_TEST_GVA_SHARED (0x90000000)
+#define TDX_LOG_DIRTY_PAGES_FLAG_REGION_SLOT 10
+#define TDX_LOG_DIRTY_PAGES_FLAG_REGION_NR_PAGES (0x1000 / getpagesize())
+
+void guest_code_log_dirty_flag(void)
+{
+	memset((void *)TDX_LOG_DIRTY_PAGES_FLAG_TEST_GVA_SHARED, 1, 8);
+	tdx_test_success();
+}
+
+/*
+ * Verify adding flag KVM_MEM_LOG_DIRTY_PAGES to a !KVM_MEM_GUEST_MEMFD memslot
+ * in a TD does not produce host errors.
+ */
+void verify_log_dirty_pages_flag_on_non_gmemfd_slot(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = td_create();
+	td_initialize(vm, VM_MEM_SRC_ANONYMOUS, 0);
+	vcpu = td_vcpu_add(vm, 0, guest_code_log_dirty_flag);
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    TDX_LOG_DIRTY_PAGES_FLAG_TEST_GPA,
+				    TDX_LOG_DIRTY_PAGES_FLAG_REGION_SLOT,
+				    TDX_LOG_DIRTY_PAGES_FLAG_REGION_NR_PAGES,
+				    KVM_MEM_LOG_DIRTY_PAGES);
+	virt_map_shared(vm, TDX_LOG_DIRTY_PAGES_FLAG_TEST_GVA_SHARED,
+			(uint64_t)TDX_LOG_DIRTY_PAGES_FLAG_TEST_GPA,
+			TDX_LOG_DIRTY_PAGES_FLAG_REGION_NR_PAGES);
+	td_finalize(vm);
+
+	printf("Verifying Log dirty flag:\n");
+	vcpu_run(vcpu);
+	tdx_test_assert_success(vcpu);
+	kvm_vm_free(vm);
+	printf("\t ... PASSED\n");
+}
+
 int main(int argc, char **argv)
 {
 	ksft_print_header();
@@ -1174,7 +1215,7 @@ int main(int argc, char **argv)
 	if (!is_tdx_enabled())
 		ksft_exit_skip("TDX is not supported by the KVM. Exiting.\n");
 
-	ksft_set_plan(15);
+	ksft_set_plan(16);
 	ksft_test_result(!run_in_new_process(&verify_td_lifecycle),
 			 "verify_td_lifecycle\n");
 	ksft_test_result(!run_in_new_process(&verify_report_fatal_error),
@@ -1205,6 +1246,8 @@ int main(int argc, char **argv)
 			 "verify_host_reading_private_mem\n");
 	ksft_test_result(!run_in_new_process(&verify_tdcall_vp_info),
 			 "verify_tdcall_vp_info\n");
+	ksft_test_result(!run_in_new_process(&verify_log_dirty_pages_flag_on_non_gmemfd_slot),
+			 "verify_log_dirty_pages_flag_on_non_gmemfd_slot\n");
 
 	ksft_finished();
 	return 0;
-- 
2.49.0.504.g3bcea36a83-goog


