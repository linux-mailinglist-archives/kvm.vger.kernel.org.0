Return-Path: <kvm+bounces-54299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9589DB1DE26
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 22:23:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2801E7B5203
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 20:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45B3C283FDF;
	Thu,  7 Aug 2025 20:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nJF/OeIM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71AE283145
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 20:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754597843; cv=none; b=IBMGykHkHimqwT3Py2Y8adV5wFlE3d1X532yKKcnxyIzNPoq0O2fYDkB6j20+3wYKIdYJrn3/p7pGMz0dXGeWKf85esEx5f/J4LkQhHR7dMxgaUZU9UvMT0dddHVyTGPNmwS6FjaSn/ZlG8Qt+O2bEr1OUDAk8TyEttw1EuTBPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754597843; c=relaxed/simple;
	bh=5V/Uk/vrVxWs5cFs9pwQXAjz5rbj0AkSbLRxLJRhUfE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jf/tcX5ARDZtxhe9xaeAgaw377XSrMyN++OF/J+Iw3kV3KAFZXxpf+kkVMwxqJVGX50BAtpWaQQPOIauyyDaApkbMVSEm/UJiaPdMscJYHMlOeqEAKyYGaVaxJwCq6OrsePhlBcmCWRcfs9hp+3tljEPP5pMXo8jHi6Tmh0ilTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nJF/OeIM; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31f74a64da9so1615598a91.2
        for <kvm@vger.kernel.org>; Thu, 07 Aug 2025 13:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754597840; x=1755202640; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jI2thjxokBvAd3Gvlvl4ty+/7Jc/pmQTHuyW99Exciw=;
        b=nJF/OeIMhoFcNt0keoPG2fQ/HGzaO5oGZkf7hBZj6nG9W77Rn9zyyvVc5i8JP/9iBu
         foKGJFT/BapC86Mg9bs9kU29LwMOcvUNOeedxo+x/y1+AZdQg2DAKLZKwlC4KipikX34
         X2rwvo74GYTY9bv9AMIKJH84Dg2nKS6NdVm9idfa0UpeIOMd9n/bx5RILeSbPqp+Uf8U
         Dlkmxsrc3EKAFQkG32RPcPHcBwEWnPlO4bbalHLYgAsgmX4ClZ5o7xImb5fqTvDeB45K
         RRGW6jDGJmw6YcjASg9QagSyRegkqIok0uJEZHvRROOP2+u7DkdHU0CxBgAr+hwZNrAe
         ow8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754597840; x=1755202640;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jI2thjxokBvAd3Gvlvl4ty+/7Jc/pmQTHuyW99Exciw=;
        b=gO1bG9mDDSoRKlM7qiwrdjeBgv0ql1v+ObEqCrvanKzIdHec1UgfnB3JdeUlsjzdgr
         IAAZWbnglSICoS8FEWcKvr5y4UEZ566xe+Hn3qS5eZgw9uSVRs6NyqJbwniw2VfGpwsd
         lXWRVUT4/86p7iIWkOPmxfxk622u/ondjs0v6kjigy4vuC6TkmH9FZg3HMFN32axZxlv
         1J7Spp8z9uwhpAyEG+pA6zi781IPhaGQJ97pjXuo3Ri3xy1JRqEMI0B3cO1nL6+MaOQH
         ce3WM6O5Eyxm1/pwpqb6jGZMvrVi6QkgBIS7DjchLdxGim4EKK1IF86yUxjCd3NppGxO
         j/jQ==
X-Forwarded-Encrypted: i=1; AJvYcCWi77aweDX6/L5afOULKsUgq9l7ZGkDHWagVKJRhPPBj2nHaIGJu8xLacF5MAMNdU9c/qI=@vger.kernel.org
X-Gm-Message-State: AOJu0YydsVYSBMUpZ+VClQbBIq0tYCa0wK2ZWPKx+vzxafYbDuR01I8c
	sKCfMs6ewP8c4idVVGKQP7PulrICCWpWaBkzA+rYPDNji67H8OBNL3/9vU2S3VsxVJlz7IYChu3
	uPQ==
X-Google-Smtp-Source: AGHT+IFaB+pyCuHTXjDHbvkPqVXu5AmJ2aDF7FkIoYXp/+CIgX0dTDSXECySrq5zcnyOQPtob99t0LTOEg==
X-Received: from pjro15.prod.google.com ([2002:a17:90a:b88f:b0:31f:1dad:d0a4])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e703:b0:31f:6d95:8f76
 with SMTP id 98e67ed59e1d1-32183c41d91mr500446a91.29.1754597840197; Thu, 07
 Aug 2025 13:17:20 -0700 (PDT)
Date: Thu,  7 Aug 2025 13:16:24 -0700
In-Reply-To: <20250807201628.1185915-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250807201628.1185915-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250807201628.1185915-29-sagis@google.com>
Subject: [PATCH v8 28/30] KVM: selftests: TDX: Add TDX UPM selftest
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

This tests the use of guest memory with explicit TDG.VP.VMCALL<MapGPA>
calls.

Provide a 2MB memory region to the TDX guest with a 40KB focus area at
offset 1MB intended to be shared between host and guest. The entire 2MB
region starts out as private with the guest filling it with a pattern and
a check from the host to ensure the host is not able to see the pattern.
The guest then requests via TDG.VP.VMCALL<MapGPA> that the 40KB focus area
be shared with checks that the host and guest has the same view of the
memory. Finally the guest requests the 40KB memory to be private again
with checks to confirm this is the case.

Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/x86/tdx_upm_test.c  | 397 ++++++++++++++++++
 2 files changed, 398 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/tdx_upm_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index bdeb40a258e1..191fc5dad854 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -153,6 +153,7 @@ TEST_GEN_PROGS_x86 += system_counter_offset_test
 TEST_GEN_PROGS_x86 += pre_fault_memory_test
 TEST_GEN_PROGS_x86 += x86/tdx_vm_test
 TEST_GEN_PROGS_x86 += x86/tdx_shared_mem_test
+TEST_GEN_PROGS_x86 += x86/tdx_upm_test
 
 # Compiled outputs used by test targets
 TEST_GEN_PROGS_EXTENDED_x86 += x86/nx_huge_pages_test
diff --git a/tools/testing/selftests/kvm/x86/tdx_upm_test.c b/tools/testing/selftests/kvm/x86/tdx_upm_test.c
new file mode 100644
index 000000000000..387258ab1a62
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/tdx_upm_test.c
@@ -0,0 +1,397 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <asm/kvm.h>
+#include <asm/vmx.h>
+#include <linux/kvm.h>
+#include <linux/sizes.h>
+#include <stdbool.h>
+#include <stdint.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "tdx/tdcall.h"
+#include "tdx/tdx.h"
+#include "tdx/tdx_util.h"
+#include "tdx/test_util.h"
+#include "test_util.h"
+
+/* TDX UPM test patterns */
+#define PATTERN_CONFIDENCE_CHECK (0x11)
+#define PATTERN_HOST_FOCUS (0x22)
+#define PATTERN_GUEST_GENERAL (0x33)
+#define PATTERN_GUEST_FOCUS (0x44)
+
+/*
+ * 0x80000000 is arbitrarily selected. The selected address need not be the same
+ * as TDX_UPM_TEST_AREA_GVA_PRIVATE, but it should not overlap with selftest
+ * code or boot page.
+ */
+#define TDX_UPM_TEST_AREA_GPA (0x80000000)
+/* Test area GPA is arbitrarily selected */
+#define TDX_UPM_TEST_AREA_GVA_PRIVATE (0x90000000)
+/* Select any bit that can be used as a flag */
+#define TDX_UPM_TEST_AREA_GVA_SHARED_BIT (32)
+/*
+ * TDX_UPM_TEST_AREA_GVA_SHARED is used to map the same GPA twice into the
+ * guest, once as shared and once as private
+ */
+#define TDX_UPM_TEST_AREA_GVA_SHARED				\
+	(TDX_UPM_TEST_AREA_GVA_PRIVATE |			\
+		BIT_ULL(TDX_UPM_TEST_AREA_GVA_SHARED_BIT))
+
+/* The test area is 2MB in size */
+#define TDX_UPM_TEST_AREA_SIZE SZ_2M
+/* 0th general area is 1MB in size */
+#define TDX_UPM_GENERAL_AREA_0_SIZE SZ_1M
+/* Focus area is 40KB in size */
+#define TDX_UPM_FOCUS_AREA_SIZE (SZ_32K + SZ_8K)
+/* 1st general area is the rest of the space in the test area */
+#define TDX_UPM_GENERAL_AREA_1_SIZE				\
+	(TDX_UPM_TEST_AREA_SIZE - TDX_UPM_GENERAL_AREA_0_SIZE -	\
+		TDX_UPM_FOCUS_AREA_SIZE)
+
+/*
+ * The test memory area is set up as two general areas, sandwiching a focus
+ * area.  The general areas act as control areas. After they are filled, they
+ * are not expected to change throughout the tests. The focus area is memory
+ * permissions change from private to shared and vice-versa.
+ *
+ * The focus area is intentionally small, and sandwiched to test that when the
+ * focus area's permissions change, the other areas' permissions are not
+ * affected.
+ */
+struct __packed tdx_upm_test_area {
+	uint8_t general_area_0[TDX_UPM_GENERAL_AREA_0_SIZE];
+	uint8_t focus_area[TDX_UPM_FOCUS_AREA_SIZE];
+	uint8_t general_area_1[TDX_UPM_GENERAL_AREA_1_SIZE];
+};
+
+static void fill_test_area(struct tdx_upm_test_area *test_area_base,
+			   uint8_t pattern)
+{
+	memset(test_area_base, pattern, sizeof(*test_area_base));
+}
+
+static void fill_focus_area(struct tdx_upm_test_area *test_area_base,
+			    uint8_t pattern)
+{
+	memset(test_area_base->focus_area, pattern,
+	       sizeof(test_area_base->focus_area));
+}
+
+static bool check_area(uint8_t *base, uint64_t size, uint8_t expected_pattern)
+{
+	size_t i;
+
+	for (i = 0; i < size; i++) {
+		if (base[i] != expected_pattern)
+			return false;
+	}
+
+	return true;
+}
+
+static bool check_general_areas(struct tdx_upm_test_area *test_area_base,
+				uint8_t expected_pattern)
+{
+	return (check_area(test_area_base->general_area_0,
+			   sizeof(test_area_base->general_area_0),
+			   expected_pattern) &&
+		check_area(test_area_base->general_area_1,
+			   sizeof(test_area_base->general_area_1),
+			   expected_pattern));
+}
+
+static bool check_focus_area(struct tdx_upm_test_area *test_area_base,
+			     uint8_t expected_pattern)
+{
+	return check_area(test_area_base->focus_area,
+			  sizeof(test_area_base->focus_area), expected_pattern);
+}
+
+static bool check_test_area(struct tdx_upm_test_area *test_area_base,
+			    uint8_t expected_pattern)
+{
+	return (check_general_areas(test_area_base, expected_pattern) &&
+		check_focus_area(test_area_base, expected_pattern));
+}
+
+static bool fill_and_check(struct tdx_upm_test_area *test_area_base, uint8_t pattern)
+{
+	fill_test_area(test_area_base, pattern);
+
+	return check_test_area(test_area_base, pattern);
+}
+
+#define TDX_UPM_TEST_ASSERT(x)				\
+	do {						\
+		if (!(x))				\
+			tdx_test_fatal(__LINE__);	\
+	} while (0)
+
+/*
+ * Shared variables between guest and host
+ */
+static struct tdx_upm_test_area *test_area_gpa_private;
+static struct tdx_upm_test_area *test_area_gpa_shared;
+
+/*
+ * Test stages for syncing with host
+ */
+enum {
+	SYNC_CHECK_READ_PRIVATE_MEMORY_FROM_HOST = 1,
+	SYNC_CHECK_READ_SHARED_MEMORY_FROM_HOST,
+	SYNC_CHECK_READ_PRIVATE_MEMORY_FROM_HOST_AGAIN,
+};
+
+#define TDX_UPM_TEST_ACCEPT_PRINT_PORT 0x87
+
+/*
+ * Does vcpu_run, and also manages memory conversions if requested by the TD.
+ */
+void vcpu_run_and_manage_memory_conversions(struct kvm_vm *vm,
+					    struct kvm_vcpu *vcpu)
+{
+	for (;;) {
+		vcpu_run(vcpu);
+		if (vcpu->run->exit_reason == KVM_EXIT_HYPERCALL &&
+		    vcpu->run->hypercall.nr == KVM_HC_MAP_GPA_RANGE) {
+			uint64_t gpa = vcpu->run->hypercall.args[0];
+
+			handle_memory_conversion(vm, vcpu->id, gpa,
+						 vcpu->run->hypercall.args[1] << 12,
+						 vcpu->run->hypercall.args[2] &
+						  KVM_MAP_GPA_RANGE_ENCRYPTED);
+			vcpu->run->hypercall.ret = 0;
+			continue;
+		} else if (vcpu->run->exit_reason == KVM_EXIT_IO &&
+			   vcpu->run->io.port == TDX_UPM_TEST_ACCEPT_PRINT_PORT) {
+			uint64_t gpa = tdx_test_read_64bit(vcpu,
+							   TDX_UPM_TEST_ACCEPT_PRINT_PORT);
+
+			printf("\t ... guest accepting 1 page at GPA: 0x%lx\n",
+			       gpa);
+			continue;
+		} else if (vcpu->run->exit_reason == KVM_EXIT_SYSTEM_EVENT) {
+			TEST_FAIL("Guest reported error. error code: %lld (0x%llx)\n",
+				  vcpu->run->system_event.data[12],
+				  vcpu->run->system_event.data[13]);
+		}
+		break;
+	}
+}
+
+static void guest_upm_explicit(void)
+{
+	struct tdx_upm_test_area *test_area_gva_private =
+		(struct tdx_upm_test_area *)TDX_UPM_TEST_AREA_GVA_PRIVATE;
+	struct tdx_upm_test_area *test_area_gva_shared =
+		(struct tdx_upm_test_area *)TDX_UPM_TEST_AREA_GVA_SHARED;
+	uint64_t failed_gpa;
+	uint64_t ret = 0;
+
+	/* Check: host reading private memory does not modify guest's view */
+	fill_test_area(test_area_gva_private, PATTERN_GUEST_GENERAL);
+
+	tdx_test_report_to_user_space(SYNC_CHECK_READ_PRIVATE_MEMORY_FROM_HOST);
+
+	TDX_UPM_TEST_ASSERT(check_test_area(test_area_gva_private, PATTERN_GUEST_GENERAL));
+
+	/* Remap focus area as shared */
+	ret = tdg_vp_vmcall_map_gpa((uint64_t)test_area_gpa_shared->focus_area,
+				    sizeof(test_area_gpa_shared->focus_area),
+				    &failed_gpa);
+	TDX_UPM_TEST_ASSERT(!ret);
+
+	/* General areas should be unaffected by remapping */
+	TDX_UPM_TEST_ASSERT(check_general_areas(test_area_gva_private, PATTERN_GUEST_GENERAL));
+
+	/*
+	 * Use memory contents to confirm that the memory allocated using mmap
+	 * is used as backing memory for shared memory - PATTERN_CONFIDENCE_CHECK
+	 * was written by the VMM at the beginning of this test.
+	 */
+	TDX_UPM_TEST_ASSERT(check_focus_area(test_area_gva_shared, PATTERN_CONFIDENCE_CHECK));
+
+	/* Guest can use focus area after remapping as shared */
+	fill_focus_area(test_area_gva_shared, PATTERN_GUEST_FOCUS);
+
+	tdx_test_report_to_user_space(SYNC_CHECK_READ_SHARED_MEMORY_FROM_HOST);
+
+	/* Check that guest has the same view of shared memory */
+	TDX_UPM_TEST_ASSERT(check_focus_area(test_area_gva_shared, PATTERN_HOST_FOCUS));
+
+	/* Remap focus area back to private */
+	ret = tdg_vp_vmcall_map_gpa((uint64_t)test_area_gpa_private->focus_area,
+				    sizeof(test_area_gpa_private->focus_area),
+				    &failed_gpa);
+	TDX_UPM_TEST_ASSERT(!ret);
+
+	/* General areas should be unaffected by remapping */
+	TDX_UPM_TEST_ASSERT(check_general_areas(test_area_gva_private, PATTERN_GUEST_GENERAL));
+
+	/* Focus area should be zeroed after remapping */
+	TDX_UPM_TEST_ASSERT(check_focus_area(test_area_gva_private, 0));
+
+	tdx_test_report_to_user_space(SYNC_CHECK_READ_PRIVATE_MEMORY_FROM_HOST_AGAIN);
+
+	/* Check that guest can use private memory after focus area is remapped as private */
+	TDX_UPM_TEST_ASSERT(fill_and_check(test_area_gva_private, PATTERN_GUEST_GENERAL));
+
+	tdx_test_success();
+}
+
+static void run_selftest(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
+			 struct tdx_upm_test_area *test_area_base_hva)
+{
+	tdx_run(vcpu);
+	tdx_test_assert_io(vcpu, TDX_TEST_REPORT_PORT, TDX_TEST_REPORT_SIZE,
+			   PORT_WRITE);
+	TEST_ASSERT_EQ(*(uint32_t *)((void *)vcpu->run + vcpu->run->io.data_offset),
+		       SYNC_CHECK_READ_PRIVATE_MEMORY_FROM_HOST);
+
+	/*
+	 * Check that host sees PATTERN_CONFIDENCE_CHECK when trying to read guest
+	 * private memory. This confirms that regular memory (userspace_addr in
+	 * struct kvm_userspace_memory_region) is used to back the host's view
+	 * of private memory, since PATTERN_CONFIDENCE_CHECK was written to that
+	 * memory before starting the guest.
+	 */
+	TEST_ASSERT(check_test_area(test_area_base_hva, PATTERN_CONFIDENCE_CHECK),
+		    "Host should read PATTERN_CONFIDENCE_CHECK from guest's private memory.");
+
+	vcpu_run_and_manage_memory_conversions(vm, vcpu);
+	tdx_test_assert_io(vcpu, TDX_TEST_REPORT_PORT, TDX_TEST_REPORT_SIZE,
+			   PORT_WRITE);
+	TEST_ASSERT_EQ(*(uint32_t *)((void *)vcpu->run + vcpu->run->io.data_offset),
+		       SYNC_CHECK_READ_SHARED_MEMORY_FROM_HOST);
+
+	TEST_ASSERT(check_focus_area(test_area_base_hva, PATTERN_GUEST_FOCUS),
+		    "Host should have the same view of shared memory as guest.");
+	TEST_ASSERT(check_general_areas(test_area_base_hva, PATTERN_CONFIDENCE_CHECK),
+		    "Host's view of private memory should still be backed by regular memory.");
+
+	/* Check that host can use shared memory */
+	fill_focus_area(test_area_base_hva, PATTERN_HOST_FOCUS);
+	TEST_ASSERT(check_focus_area(test_area_base_hva, PATTERN_HOST_FOCUS),
+		    "Host should be able to use shared memory.");
+
+	vcpu_run_and_manage_memory_conversions(vm, vcpu);
+	tdx_test_assert_io(vcpu, TDX_TEST_REPORT_PORT, TDX_TEST_REPORT_SIZE,
+			   PORT_WRITE);
+	TEST_ASSERT_EQ(*(uint32_t *)((void *)vcpu->run + vcpu->run->io.data_offset),
+		       SYNC_CHECK_READ_PRIVATE_MEMORY_FROM_HOST_AGAIN);
+
+	TEST_ASSERT(check_general_areas(test_area_base_hva, PATTERN_CONFIDENCE_CHECK),
+		    "Host's view of private memory should be backed by regular memory.");
+	TEST_ASSERT(check_focus_area(test_area_base_hva, PATTERN_HOST_FOCUS),
+		    "Host's view of private memory should be backed by regular memory.");
+
+	tdx_run(vcpu);
+	tdx_test_assert_success(vcpu);
+
+	printf("\t ... PASSED\n");
+}
+
+static bool address_between(uint64_t addr, void *lo, void *hi)
+{
+	return (uint64_t)lo <= addr && addr < (uint64_t)hi;
+}
+
+static void guest_ve_handler(struct ex_regs *regs)
+{
+	struct ve_info ve;
+	uint64_t ret;
+
+	ret = tdg_vp_veinfo_get(&ve);
+	TDX_UPM_TEST_ASSERT(!ret);
+
+	/* For this test, we will only handle EXIT_REASON_EPT_VIOLATION */
+	TDX_UPM_TEST_ASSERT(ve.exit_reason == EXIT_REASON_EPT_VIOLATION);
+
+	/* Validate GPA in fault */
+	TDX_UPM_TEST_ASSERT(address_between(ve.gpa,
+					    test_area_gpa_private->focus_area,
+					    test_area_gpa_private->general_area_1));
+
+	tdx_test_send_64bit(TDX_UPM_TEST_ACCEPT_PRINT_PORT, ve.gpa);
+
+#define MEM_PAGE_ACCEPT_LEVEL_4K 0
+#define MEM_PAGE_ACCEPT_LEVEL_2M 1
+	ret = tdg_mem_page_accept(ve.gpa & PAGE_MASK, MEM_PAGE_ACCEPT_LEVEL_4K);
+	TDX_UPM_TEST_ASSERT(!ret);
+}
+
+static void verify_upm_test(void)
+{
+	struct tdx_upm_test_area *test_area_base_hva;
+	vm_vaddr_t test_area_gva_private;
+	uint64_t test_area_npages;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = td_create();
+	td_initialize(vm, VM_MEM_SRC_ANONYMOUS, 0);
+	vcpu = td_vcpu_add(vm, 0, guest_upm_explicit);
+
+	vm_install_exception_handler(vm, VE_VECTOR, guest_ve_handler);
+
+	/*
+	 * Set up shared memory page for testing by first allocating as private
+	 * and then mapping the same GPA again as shared. This way, the TD does
+	 * not have to remap its page tables at runtime.
+	 */
+	test_area_npages = TDX_UPM_TEST_AREA_SIZE / vm->page_size;
+	vm_userspace_mem_region_add(vm,
+				    VM_MEM_SRC_ANONYMOUS, TDX_UPM_TEST_AREA_GPA,
+				    3, test_area_npages, KVM_MEM_GUEST_MEMFD);
+	vm->memslots[MEM_REGION_TEST_DATA] = 3;
+
+	test_area_gva_private = vm_vaddr_alloc_private(vm, TDX_UPM_TEST_AREA_SIZE,
+						       TDX_UPM_TEST_AREA_GVA_PRIVATE,
+						       TDX_UPM_TEST_AREA_GPA,
+						       MEM_REGION_TEST_DATA);
+	TEST_ASSERT_EQ(test_area_gva_private, TDX_UPM_TEST_AREA_GVA_PRIVATE);
+
+	test_area_gpa_private = (struct tdx_upm_test_area *)
+		addr_gva2gpa(vm, test_area_gva_private);
+	virt_map_shared(vm, TDX_UPM_TEST_AREA_GVA_SHARED,
+			(uint64_t)test_area_gpa_private,
+			test_area_npages);
+	TEST_ASSERT_EQ(addr_gva2gpa(vm, TDX_UPM_TEST_AREA_GVA_SHARED),
+		       (vm_paddr_t)test_area_gpa_private);
+
+	test_area_base_hva = addr_gva2hva(vm, TDX_UPM_TEST_AREA_GVA_PRIVATE);
+
+	TEST_ASSERT(fill_and_check(test_area_base_hva, PATTERN_CONFIDENCE_CHECK),
+		    "Failed to mark memory intended as backing memory for TD shared memory");
+
+	sync_global_to_guest(vm, test_area_gpa_private);
+	test_area_gpa_shared = (struct tdx_upm_test_area *)
+		((uint64_t)test_area_gpa_private | vm->arch.s_bit);
+	sync_global_to_guest(vm, test_area_gpa_shared);
+
+	td_finalize(vm);
+
+	printf("Verifying UPM functionality: explicit MapGPA\n");
+
+	vm_enable_cap(vm, KVM_CAP_EXIT_HYPERCALL, BIT_ULL(KVM_HC_MAP_GPA_RANGE));
+
+	run_selftest(vm, vcpu, test_area_base_hva);
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char **argv)
+{
+	ksft_print_header();
+
+	if (!is_tdx_enabled())
+		ksft_exit_skip("TDX is not supported by the KVM. Exiting.\n");
+
+	ksft_set_plan(1);
+	ksft_test_result(!run_in_new_process(&verify_upm_test),
+			 "verify_upm_test\n");
+
+	ksft_finished();
+}
-- 
2.51.0.rc0.155.g4a0f42376b-goog


