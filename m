Return-Path: <kvm+bounces-58810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28427BA0E5D
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 19:36:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEB164C1D83
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 17:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07DB2322A1A;
	Thu, 25 Sep 2025 17:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N2y8yFwm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539AC3218B5
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 17:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758821375; cv=none; b=ApCSUWR0cKt6TBE6kzwqgOxFX/lW5fuzI9nessznNz2wdnY76/o6JCP+3RIkArM3bTMmLf2e2Llpq0GvKLFtLeaLHtHOtV0Skd8u52vaIykSzYBkk4tOAIQDE5hp6qM3t0HUHDPhb6hb3aXHt8RvYlNzfcQIIR0BumzDnxHQbnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758821375; c=relaxed/simple;
	bh=agNHzizJ+pu2GHvDilj4v+Sz4qwxNdK8ZAynRol9myI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SaZrtwwObVndig5HMpt8zRr5uLCsKDvuQoGdts4M8pxKBfVHgix7fNJomnfSe75ILbh2iA3SbQJazg1PY/gTghlfAVkQmVKvzhL3dFEt2OvR5CRm3Ks9zEY1dTiak2lIPDOxozaCvrTW/gOB8CltBpEjISquH04R63cgE20O2u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N2y8yFwm; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b4f93fe3831so1597536a12.0
        for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758821373; x=1759426173; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1xPKp0CWKeH6BVksYl8nT4cVmvOfs6P2rPR25K+k3iU=;
        b=N2y8yFwmZz5GX2ct89JU0BRXZNUgmOl21lR2lhRLY1yA3pCygw/gnkzBPodr5MapEQ
         OvwnUe4VhvnBqs5skVhuv7qojuq21Vbyqp3HqtqdXXtrTwb7hB1o94dPuur3PHGmYFYN
         hkfB7rdqlgVEDaduG0poh6VZEndPy0j3AEJK5/IF0RGIJ+5UXnPMyg2oxsGSB7qVtisH
         ubNrhQLpfDPCrtdPY38XHSUmhT/Sz5aQiK6+p8eUaDXTk71d2OSftWykpEpuMngawrbX
         fX/JsLeyx2rXsr0o0rlWNCtift1R464RwYxgOq3gOSnsUAV6wc2wI06hictsL88BSEv+
         UY1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758821373; x=1759426173;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1xPKp0CWKeH6BVksYl8nT4cVmvOfs6P2rPR25K+k3iU=;
        b=TZz1N21ceuYQa9ou5mFUcDufTKMoOCaK6mOgp3TZ5RH/yXLenX+m9mIMbcPHPqzabS
         2nEnHaDtGQPku9iO0tDWnQraT6uiLY1QThY5sCiZyNIn/WIqF45Pzn1Uj8vbD0zowyKH
         dcVFf3L8q5vGxY4KqptylyeEQsd7gXBgM/g3bDyyRUbJ6p+Kqnq2NAnNCnh540XsvXqW
         xKdptNqOt9KJQjvM1uuw0C+DvTrqR8y7j9sbXJrLwJQjuFwNH+Akc+nZZBpkmujAAjWN
         l1iIzcFQnThvOuyJ6MrZeDO0Tv9LABoCEfPXpx9MC3gHWj4BnbMa9L/VS8k9quxuGo/v
         UTlA==
X-Forwarded-Encrypted: i=1; AJvYcCVJm+weAUZ+bIi8GGWRch3GAIyjHKs4vEwjx2rlGqMrsUALmiApQ7p0gXsqeonwgbsmhKM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVDeMju7Wo1po2d03qAexYfpLVv9VVPMLSnd9gi40Ohw24pnQc
	cnkQzmFfTNRMgjw7YHGxeUfojVvdoMDrUAIj9C9IZdpFtEInsaisUMDHGWG/1gG60UjnPdzy52I
	0EQ==
X-Google-Smtp-Source: AGHT+IFabB5ZJxkse1FxMHYo+VsnYSqWzdJfcXGK5NpuSl7voX2cKYO5R6GfWwQO7rPrUoSbZvlO3/cyHw==
X-Received: from pjbcz15.prod.google.com ([2002:a17:90a:d44f:b0:32b:8eda:24e8])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b07:b0:335:2824:aab4
 with SMTP id 98e67ed59e1d1-3352824ac26mr337614a91.24.1758821372692; Thu, 25
 Sep 2025 10:29:32 -0700 (PDT)
Date: Thu, 25 Sep 2025 10:28:49 -0700
In-Reply-To: <20250925172851.606193-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250925172851.606193-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <20250925172851.606193-22-sagis@google.com>
Subject: [PATCH v11 21/21] KVM: selftests: Add TDX lifecycle test
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
index 53cfadeff8de..714413e062fd 100644
--- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
@@ -328,3 +328,21 @@ void vm_tdx_finalize(struct kvm_vm *vm)
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
2.51.0.536.g15c5d4f767-goog


