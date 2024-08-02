Return-Path: <kvm+bounces-23115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53311946379
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:58:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09EEF280C3E
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 18:58:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 069EF1A7065;
	Fri,  2 Aug 2024 18:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TXD/xPgz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F871A34CC
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 18:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722624935; cv=none; b=Q7mTwU/2iytZHfITFKqXgTHKxmw8kctClz8Mvvee7q0duobdoMz1KEL36/UfQAN40NzIe8LUFv0hwFyKyk8swK2Zw42bqZXWIE7TFgfm9Ozf/wXkqlz53vBvZHqexujxcLjsV8fHeKD/lKqrgtie+h6YsmNO1A/XJRnXjANFSWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722624935; c=relaxed/simple;
	bh=nN94EdUS9XdoLYGq4cV5S9KQKM8sOq6fMUYOehoYu+A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c4WdTaGllijiYwJ8M3CMTDulJdC/pEAyoB7CuU/N3nu8a9OGabTnP6ei1ns7tr4JnWU4nTTQKnHMT95h6Odn+30/syk03o4rY4c8KS/iDHpW32btlSE4czJx/sfs2UJhUycMRLO/+eGodQAHgW8VMdiItyRhMpDmTnIqDI6dxDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TXD/xPgz; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7a28f78c67aso7511323a12.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 11:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722624933; x=1723229733; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=P1dllkuPBdFGoq66LwoZDW3BVSVl+pHV+qHFjbtP1CA=;
        b=TXD/xPgzLq2m2Cs4KDTvsnf+9qtIdMRIL5kWCehGUlosKkjnfAejwhswLaz8lCxa/O
         +0c0P7KYKW0uCom+XHA2b5N/coOGv5PlN0In+EVsLQDA0NdntVz1dfDXaEbMefuW/efU
         BbVvsyG5TGaSYtCod4HPr4vHPVyLvKpFMCUuxEclGGpTxlNbnt+UZelfDALg3ERqhiBU
         qSIu8TiWCpUoMI7yyshZH66lrQQlnaV4BC/tHGknWwtYoODYxa/Sr0Pa4OimnZdMmRL2
         N+mwWTQIRIX1xbjA7YDu46rN6S5mKUF7mGhZCDuIpIxQx6RBceGkiXMtFCuJ3H2w4tq2
         dlRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722624933; x=1723229733;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P1dllkuPBdFGoq66LwoZDW3BVSVl+pHV+qHFjbtP1CA=;
        b=Zrs4aMDEq8kCPVE11w08AKIal8uSwaRULF7Cbwc8whhmrYTzaKPodI1SIF2klYa2UH
         Kt2fI5l38r33gsJTQM3//vuB5qGpOfFvyV2KVyP0rrRDPHzyfSSCQntSk0DlkYy0JGFc
         9U1NVXFFJ6+glZwd3Khp/XhJInY9dDchVsc4zQUjQV+6BIsUSgHlbKjvRrpzzUG0usIE
         72uuHBHxaypUrJcT+corPZhfVzO6mfZewNM5M2e0Uubl9pumQggcKUwTRd0Rrn6p4iCQ
         bnlwKdRwyJ4SnsAk7AWLb6ugnW80x++SvNm5JCr+BrpYs4yEsq1BiIBfz60J/1A5/6Y4
         NSAQ==
X-Gm-Message-State: AOJu0YywB1CdE6fGq+m5YgRR/eZ++TtzkKRCnW/p1/XvVs0Rakc2yAUE
	9cR8OPoTkItZFcyLBp77gRoUvAx3SQNiQswZ531/kg+5ar/HaqZe0jrqdKUugKj0L1Hd/+11y9O
	+IA==
X-Google-Smtp-Source: AGHT+IGF/Uer4uQKdi8nVuIRV33BvnYIkl97WidqrB2j7Q/ZBCuCCKyt5W5hQi9b4thjF+o+u5mrrq8akfQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3f41:0:b0:7a1:2fb5:3ff7 with SMTP id
 41be03b00d2f7-7b7438b1dc8mr8680a12.0.1722624932740; Fri, 02 Aug 2024 11:55:32
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 11:55:11 -0700
In-Reply-To: <20240802185511.305849-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802185511.305849-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802185511.305849-10-seanjc@google.com>
Subject: [PATCH 9/9] KVM: selftests: Add a testcase for disabling feature MSRs
 init quirk
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Expand and rename the feature MSRs test to verify KVM's ABI and quirk
for initializing feature MSRs.

Exempt VM_CR{0,4}_FIXED1 from most tests as KVM intentionally takes full
control of the MSRs, e.g. to prevent L1 from running L2 with bogus CR0
and/or CR4 values.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   2 +-
 .../selftests/kvm/x86_64/feature_msrs_test.c  | 113 ++++++++++++++++++
 .../kvm/x86_64/get_msr_index_features.c       |  35 ------
 3 files changed, 114 insertions(+), 36 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/feature_msrs_test.c
 delete mode 100644 tools/testing/selftests/kvm/x86_64/get_msr_index_features.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index b084ba2262a0..827b523a18fa 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -67,7 +67,7 @@ TEST_PROGS_x86_64 += x86_64/nx_huge_pages_test.sh
 TEST_GEN_PROGS_x86_64 = x86_64/cpuid_test
 TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/dirty_log_page_splitting_test
-TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
+TEST_GEN_PROGS_x86_64 += x86_64/feature_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/exit_on_emulation_failure_test
 TEST_GEN_PROGS_x86_64 += x86_64/fix_hypercall_test
 TEST_GEN_PROGS_x86_64 += x86_64/hwcr_msr_test
diff --git a/tools/testing/selftests/kvm/x86_64/feature_msrs_test.c b/tools/testing/selftests/kvm/x86_64/feature_msrs_test.c
new file mode 100644
index 000000000000..a72f13ae2edb
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/feature_msrs_test.c
@@ -0,0 +1,113 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020, Red Hat, Inc.
+ */
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+static bool is_kvm_controlled_msr(uint32_t msr)
+{
+	return msr == MSR_IA32_VMX_CR0_FIXED1 || msr == MSR_IA32_VMX_CR4_FIXED1;
+}
+
+/*
+ * For VMX MSRs with a "true" variant, KVM requires userspace to set the "true"
+ * MSR, and doesn't allow setting the hidden version.
+ */
+static bool is_hidden_vmx_msr(uint32_t msr)
+{
+	switch (msr) {
+	case MSR_IA32_VMX_PINBASED_CTLS:
+	case MSR_IA32_VMX_PROCBASED_CTLS:
+	case MSR_IA32_VMX_EXIT_CTLS:
+	case MSR_IA32_VMX_ENTRY_CTLS:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool is_quirked_msr(uint32_t msr)
+{
+	return msr != MSR_AMD64_DE_CFG;
+}
+
+static void test_feature_msr(uint32_t msr)
+{
+	const uint64_t supported_mask = kvm_get_feature_msr(msr);
+	uint64_t reset_value = is_quirked_msr(msr) ? supported_mask : 0;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	/*
+	 * Don't bother testing KVM-controlled MSRs beyond verifying that the
+	 * MSR can be read from userspace.  Any value is effectively legal, as
+	 * KVM is bound by x86 architecture, not by ABI.
+	 */
+	if (is_kvm_controlled_msr(msr))
+		return;
+
+	/*
+	 * More goofy behavior.  KVM reports the host CPU's actual revision ID,
+	 * but initializes the vCPU's revision ID to an arbitrary value.
+	 */
+	if (msr == MSR_IA32_UCODE_REV)
+		reset_value = host_cpu_is_intel ? 0x100000000ULL : 0x01000065;
+
+	/*
+	 * For quirked MSRs, KVM's ABI is to initialize the vCPU's value to the
+	 * full set of features supported by KVM.  For non-quirked MSRs, and
+	 * when the quirk is disabled, KVM must zero-initialize the MSR and let
+	 * userspace do the configuration.
+	 */
+	vm = vm_create_with_one_vcpu(&vcpu, NULL);
+	TEST_ASSERT(vcpu_get_msr(vcpu, msr) == reset_value,
+		    "Wanted 0x%lx for %squirked MSR 0x%x, got 0x%lx",
+		    reset_value, is_quirked_msr(msr) ? "" : "non-", msr,
+		    vcpu_get_msr(vcpu, msr));
+	if (!is_hidden_vmx_msr(msr))
+		vcpu_set_msr(vcpu, msr, supported_mask);
+	kvm_vm_free(vm);
+
+	if (is_hidden_vmx_msr(msr))
+		return;
+
+	if (!kvm_has_cap(KVM_CAP_DISABLE_QUIRKS2) ||
+	    !(kvm_check_cap(KVM_CAP_DISABLE_QUIRKS2) & KVM_X86_QUIRK_STUFF_FEATURE_MSRS))
+		return;
+
+	vm = vm_create(1);
+	vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2, KVM_X86_QUIRK_STUFF_FEATURE_MSRS);
+
+	vcpu = vm_vcpu_add(vm, 0, NULL);
+	TEST_ASSERT(!vcpu_get_msr(vcpu, msr),
+		    "Quirk disabled, wanted '0' for MSR 0x%x, got 0x%lx",
+		    msr, vcpu_get_msr(vcpu, msr));
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	const struct kvm_msr_list *feature_list;
+	int i;
+
+	/*
+	 * Skip the entire test if MSR_FEATURES isn't supported, other tests
+	 * will cover the "regular" list of MSRs, the coverage here is purely
+	 * opportunistic and not interesting on its own.
+	 */
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GET_MSR_FEATURES));
+
+	(void)kvm_get_msr_index_list();
+
+	feature_list = kvm_get_feature_msr_index_list();
+	for (i = 0; i < feature_list->nmsrs; i++)
+		test_feature_msr(feature_list->indices[i]);
+}
diff --git a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
deleted file mode 100644
index d09b3cbcadc6..000000000000
--- a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
+++ /dev/null
@@ -1,35 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Test that KVM_GET_MSR_INDEX_LIST and
- * KVM_GET_MSR_FEATURE_INDEX_LIST work as intended
- *
- * Copyright (C) 2020, Red Hat, Inc.
- */
-#include <fcntl.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <sys/ioctl.h>
-
-#include "test_util.h"
-#include "kvm_util.h"
-#include "processor.h"
-
-int main(int argc, char *argv[])
-{
-	const struct kvm_msr_list *feature_list;
-	int i;
-
-	/*
-	 * Skip the entire test if MSR_FEATURES isn't supported, other tests
-	 * will cover the "regular" list of MSRs, the coverage here is purely
-	 * opportunistic and not interesting on its own.
-	 */
-	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GET_MSR_FEATURES));
-
-	(void)kvm_get_msr_index_list();
-
-	feature_list = kvm_get_feature_msr_index_list();
-	for (i = 0; i < feature_list->nmsrs; i++)
-		kvm_get_feature_msr(feature_list->indices[i]);
-}
-- 
2.46.0.rc2.264.g509ed76dc8-goog


