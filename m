Return-Path: <kvm+bounces-56766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E1E4B43331
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 09:02:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E42A189B64F
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 07:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 072C42BF3F4;
	Thu,  4 Sep 2025 06:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rANUoKlk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A716E287517
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 06:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756968938; cv=none; b=kxs+3IeAzyNJPX1AWVpIEWUIcuG+F5sybThrXlCKiklsT+6gqWkH0xEYew/gyng5RHU4Tnl/+/4WQlKQ0A2JX1qYEFu41o+/xFNYA9wGGAs7j7zsjMXmx1uxKEXjqocXGJ+vcCDcau7Z/WquYJysJsb3dIK0BH5D5L9Q15MeKoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756968938; c=relaxed/simple;
	bh=n5R2ZA5nD4duw34bOYSLZZY4wDHfqasy7+07P7hy0UE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Lu1NvJ2QHtdVj9dV0fvzvejpTbKH53EhuSU4Rk6XcTz9yBjhkkG94S8HExcSbsfyKeP3UL3S05X8gmj3A1WiYKOQCCiYCIF48KGder5+W/c69Xe/DZXK7jURPRPbQePfJMlgJQcwOGQdxkY4hqAmwcGN+mQrGf8uPNuWd9ONRJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rANUoKlk; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-324e41e946eso1116263a91.0
        for <kvm@vger.kernel.org>; Wed, 03 Sep 2025 23:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756968936; x=1757573736; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4yB9yOXY7Gz8M5J2AkG68rpmry/ggMKSfTcUt8sHdGE=;
        b=rANUoKlkTFC+7ZCLkXXP5D3TyL9h5WlvPXjPPmtVH8qMNJ86OY2fEOsVzXb+jL4J3e
         bwjfGLkHpp8HhhmVA/4Yt+m/9MaCXic4UQhe5qS3ffIM1jIEdoXDPJjYTKGBCsfuzjfV
         lsc/GOlvUqz8+Z9z3jkavGRvoY4N7/bszxabQMYZXEPVSc2YANY2yl52nE0dI9BPWDgt
         kQhchUCdYR4Zl/DCH0k9AAQr7Td0IVvbdXq0dLon3bxC3s8k29a+drhElWAXHQ5uhHye
         8o8UgA03QFIYPTjj9u/4wwtJsKzMci4szygzX6TKqlHiLFbyv/fftHLBAoPHSDLL7anF
         Yp3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756968936; x=1757573736;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4yB9yOXY7Gz8M5J2AkG68rpmry/ggMKSfTcUt8sHdGE=;
        b=YgDO6OUk1xUHM080WqB2ubxzyAyD167zQNw1KwpBZzau4aj+UbhP9vNroC4xjukS6O
         Dcx5e3iWG4oIquYjSAHOb7yukD/Zu7bdvGgTH5+FMXisjxekT8Pq66qFSYFME6wLlI0U
         rfDIoJQt2UdKQyya54fe1vRi7epLG2qn6U3ddxj+84U93o/M9qtNN9KsaEEHzybdNuWx
         GjmEjO/Eqr8YayeMEy0MGnJ3zJrOQhR1QIo1OUrZZJvZKVsUUrUb6+MJumUcbagz5cVT
         +nkuzyOF6isNsacxwp5Xuv+FCNDwcXAYYFjXLdszwxjzNSd5LGGPR9oiB51wmRN3uM9T
         l3Hg==
X-Forwarded-Encrypted: i=1; AJvYcCV5iEDphqQX6AXVWrmNGhoDnUEH5KbXtV18ua8MQVKstm8T8SeqM5UjgBi7N65AfYCL3xk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcHMQuCcMvtcAuQeY2skIw5+p4u5iv65N9NbdEV3pGad3l6VpJ
	gMjqUyui04WzLaAjFe1TxW1h8Bb0jXy0+wxDiDl0Dx49ddAHfl2icz+F4wHgt5XrCor4fh0oKi9
	faA==
X-Google-Smtp-Source: AGHT+IFpJtOTBtEH30kjlV9qshasFJ6VZRx9xb8RK+RSnnYf1AYHxgBz5mEyM5mVxSvYniQwjkKBo72C8w==
X-Received: from pjh5.prod.google.com ([2002:a17:90b:3f85:b0:325:7c49:9cce])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2ecc:b0:329:e3dc:db6c
 with SMTP id 98e67ed59e1d1-329e3dcdc0bmr11848843a91.23.1756968935487; Wed, 03
 Sep 2025 23:55:35 -0700 (PDT)
Date: Wed,  3 Sep 2025 23:54:51 -0700
In-Reply-To: <20250904065453.639610-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250904065453.639610-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.338.gd7d06c2dae-goog
Message-ID: <20250904065453.639610-22-sagis@google.com>
Subject: [PATCH v10 21/21] KVM: selftests: Add TDX lifecycle test
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Adding a test to verify TDX lifecycle by creating a simple TD.

Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../selftests/kvm/include/x86/tdx/tdx_util.h  | 10 ++++++
 .../selftests/kvm/lib/x86/tdx/tdx_util.c      | 18 +++++++++++
 tools/testing/selftests/kvm/x86/tdx_vm_test.c | 31 +++++++++++++++++++
 4 files changed, 60 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/tdx_vm_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 1a73e08c8437..1a76e9fa45d6 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -155,6 +155,7 @@ TEST_GEN_PROGS_x86 += rseq_test
 TEST_GEN_PROGS_x86 += steal_time
 TEST_GEN_PROGS_x86 += system_counter_offset_test
 TEST_GEN_PROGS_x86 += pre_fault_memory_test
+TEST_GEN_PROGS_x86 += x86/tdx_vm_test
 
 # Compiled outputs used by test targets
 TEST_GEN_PROGS_EXTENDED_x86 += x86/nx_huge_pages_test
diff --git a/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h b/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
index 2467b6c35557..775ca249f74d 100644
--- a/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
+++ b/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
@@ -11,6 +11,14 @@ static inline bool is_tdx_vm(struct kvm_vm *vm)
 	return vm->type == KVM_X86_TDX_VM;
 }
 
+/*
+ * Verify that TDX is supported by KVM.
+ */
+static inline bool is_tdx_enabled(void)
+{
+	return !!(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_TDX_VM));
+}
+
 /*
  * TDX ioctls
  */
@@ -72,5 +80,7 @@ void vm_tdx_load_vcpu_boot_parameters(struct kvm_vm *vm, struct kvm_vcpu *vcpu);
 void vm_tdx_set_vcpu_entry_point(struct kvm_vcpu *vcpu, void *guest_code);
 
 void vm_tdx_finalize(struct kvm_vm *vm);
+struct kvm_vm *vm_tdx_create_with_one_vcpu(void *guest_code,
+					   struct kvm_vcpu **vcpu);
 
 #endif // SELFTESTS_TDX_TDX_UTIL_H
diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
index d5df2de81a75..a2764f5d687c 100644
--- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
@@ -334,3 +334,21 @@ void vm_tdx_finalize(struct kvm_vm *vm)
 	load_td_private_memory(vm);
 	vm_tdx_vm_ioctl(vm, KVM_TDX_FINALIZE_VM, 0, NULL);
 }
+
+struct kvm_vm *vm_tdx_create_with_one_vcpu(void *guest_code,
+					   struct kvm_vcpu **vcpu)
+{
+	struct vm_shape shape = {
+		.mode = VM_MODE_DEFAULT,
+		.type = KVM_X86_TDX_VM,
+	};
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpus[1];
+
+	vm = __vm_create_with_vcpus(shape, 1, 0, guest_code, vcpus);
+	*vcpu = vcpus[0];
+
+	vm_tdx_finalize(vm);
+
+	return vm;
+}
diff --git a/tools/testing/selftests/kvm/x86/tdx_vm_test.c b/tools/testing/selftests/kvm/x86/tdx_vm_test.c
new file mode 100644
index 000000000000..a9ee489eea1a
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/tdx_vm_test.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "kvm_util.h"
+#include "tdx/tdx_util.h"
+#include "ucall_common.h"
+#include "kselftest_harness.h"
+
+static void guest_code_lifecycle(void)
+{
+	GUEST_DONE();
+}
+
+TEST(verify_td_lifecycle)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	vm = vm_tdx_create_with_one_vcpu(guest_code_lifecycle, &vcpu);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_DONE);
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char **argv)
+{
+	TEST_REQUIRE(is_tdx_enabled());
+	return test_harness_run(argc, argv);
+}
-- 
2.51.0.338.gd7d06c2dae-goog


