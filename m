Return-Path: <kvm+bounces-55255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 41DCAB2ED01
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 06:37:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10E625C003E
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 04:35:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A651D2EBB86;
	Thu, 21 Aug 2025 04:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xuET/TSC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DFE2EBBB1
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 04:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755750594; cv=none; b=gx5mlj3wWdh8Gtk/Q9KOCRd3IpnLLsJxYJy4ZwzZ9Iw7YfzqgHmohbZCvnu0+i6Ui0s0LOB4IDoTPsrL7sM8nnxw6bJsbybGCFJ06x00YDaCTlCRwCpL2LUITFVIHBCfHGReRnA90i3UT+UmtWsXkZPD/CEp+5HDEcVx2P+Jkoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755750594; c=relaxed/simple;
	bh=SCj5vpqbGdcyeL9WchYjYHXxlh3Syca50DvMtgJYdEE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jxPfBsPkSB1TukR4/20pP4O8pY25V6d6WMFQ0BSvtwrdeUT4brQkOcAF8Lwz7Unk0gwRa3wcaD3xPzaeAawxzq30tLxdel3FeCo+uZUMd9FP2V2csJRo80JS7xKFeJnOrxUQ6y/zd4c/FrFHPeSOwoXWvzVeHVsY07OnQayO/7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xuET/TSC; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b471757d82fso463109a12.3
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 21:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755750592; x=1756355392; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3ni6/1QBXYyjIXVNXrHE6sKBQ7BBSjz5QhIiIQ0TLw0=;
        b=xuET/TSCt6PFuCOdPi5Z5y/dEg4sD+i1qImMcL8xRCpzIteliZY7RHdmsP2bqQU+lc
         u21EwRPxhc+sztMv88mB1xQ4UjxULkCX3tAxGel/FGYMfbauo6W+875bYXLNLnfSPbdx
         rc0P+CBxcDFrMmlhjoTSYv5UmoIN+nQCyXTI8NdQ9BD1+dfLcm8yLvtVEGuxiaSYnTLZ
         vmPPJiHQ6DywPtdHHhbRvnYjst/RafYe+SzK3hzPWLkjw2cRpfzsaxz0FfkWs3/A3nXN
         T6M4XgPm1IONtDJJy61IRzQwlSoKpauwlkK3ceTf3ANG148w/IyzXpeqg1z7dI1R+9j1
         vB+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755750592; x=1756355392;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3ni6/1QBXYyjIXVNXrHE6sKBQ7BBSjz5QhIiIQ0TLw0=;
        b=DXUvDL6vy3YOGjYJtnjV1SCQMnoZze7uFY4CqLIiOM6vQmWislkhAyShk57Nin+Xzt
         H6lpGXpnZJ+VcIbYUGkZAKq5D8R2KGqk2YKaQecOOv9jcIgazELeYbz6kUUybBH4upKj
         gv4SJLEkZK3wd1yl2IjHmt161jwpMjbi2dUEOzAFXY10dnHTjbkasfXBuNL1p/mwMrMu
         g0YO0cKwrqnLTivkHTFQJqPXIRzoc2dDf53dQVsYYZ+tUmB/VEQRcuLZSAVVF4CD+J4S
         oPxWxiWmjAgKMl5g/IfI1KktTqQAG1noQhi6AZ1KR/3EHXqmPiB3Fv04QAIxyQ5+gYLf
         BWWg==
X-Forwarded-Encrypted: i=1; AJvYcCUJ9a1FbH5oUoFUQ5NMODXDrLCrRIH/Z4s6kUa/ujA8lvCXW09lgXZvWONPcLcFGWmaUgw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/fE0tfbJ3b3CQkYfhaa2m009R35ZaXKS+FcDCEcZnFK3US9lS
	kReam5bdIdjG8xK6qSFHDN5IhFjVVCwMNmfaN2qVWBg02dIGifcz6YIqfnlQGdWMd36YA9hfeff
	C8g==
X-Google-Smtp-Source: AGHT+IF47pIKGfWNf380vL880YXdNEf+FWPdQExp1mJvaZsLgHJ8I4ZDENH3hqy/aqETue6DuLS1LEQ09w==
X-Received: from pgbdp6.prod.google.com ([2002:a05:6a02:f06:b0:b47:61f6:dd10])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:734a:b0:240:30c:276a
 with SMTP id adf61e73a8af0-24330aa5c52mr1472690637.39.1755750592600; Wed, 20
 Aug 2025 21:29:52 -0700 (PDT)
Date: Wed, 20 Aug 2025 21:29:12 -0700
In-Reply-To: <20250821042915.3712925-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250821042915.3712925-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.rc1.193.gad69d77794-goog
Message-ID: <20250821042915.3712925-20-sagis@google.com>
Subject: [PATCH v9 19/19] KVM: selftests: Add TDX lifecycle test
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
index 8d1aaebd746e..86c101fbe1a0 100644
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
index 4024587ed3c2..8b18f1a8da62 100644
--- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
@@ -371,3 +371,21 @@ void vm_tdx_finalize(struct kvm_vm *vm)
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
2.51.0.rc1.193.gad69d77794-goog


