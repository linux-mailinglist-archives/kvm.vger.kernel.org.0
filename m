Return-Path: <kvm+bounces-57086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 04C42B4A8A0
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:48:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F20D1B20703
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:46:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 376722D0C9B;
	Tue,  9 Sep 2025 09:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W7s1gpEo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D0F30F93D;
	Tue,  9 Sep 2025 09:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757410813; cv=none; b=UNZOHjYzPtO45mYPJXFeuyZyd4Z9M4xeeX558qdqToHGOSXz21XauYSeYCgcHCdZg+UbhQjtViauAW3rbFZYzAmVJAFH+Q1GBTla+x9wYkPHR2BZWRGGNosvYsWg/d5b/xgaRjHyEdDs8gSTvyLFqb92IHZe1v1jQpOpC4+wGRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757410813; c=relaxed/simple;
	bh=C9Z/c4AV0RFEEypMIxy3Os2G0EmIpfbOJH2XRkzjquw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9MoUzIErfqxICOaW5DPt7YvNHkQtRDfmQpaDmtAIqf/DWRrJpuz7gLXuIULBOL0pjELnKcnSnQwcLOoHS1D0poeTYDkxPefm//zehodGxoEnGk6/xFzAWnCoWKqIurQvap9qKYODax01CFm8xhhOqpIG8jPMgffr1ELJW29VaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W7s1gpEo; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757410811; x=1788946811;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C9Z/c4AV0RFEEypMIxy3Os2G0EmIpfbOJH2XRkzjquw=;
  b=W7s1gpEoJjb5chzGPOKjhaC3U0YrrVLBvIr+x6AuHGy18frxYe++FJuz
   897+h0cGaSumXO5kYDcyXd5EV1tiTRS4JjuyCNG6aBs9Vm1Clt9A8KuPl
   YgXs3Aj186Q7Gfwgsvnx5sg6fq+KDM+LHAVo3WJ1e77DlwVKAbsRZxSU7
   3b1qP1T63mXFg1G0ISaa1MpVfMOmqpVGbSzCG/eSNktww4zdCHaLGG/rZ
   3Ftv6Ry3IoisaNcUTeTgj65mOAGM7ipoEljDbh5iCuxGLHQh9ZpyO0pFn
   HXR2c6kqD6I4S0y79eYARWaUQl/PzFPE8NEz0ONEn5sSdYiV29CnYlp23
   w==;
X-CSE-ConnectionGUID: QhPHuvbpQa+EO2ezsp/ndA==
X-CSE-MsgGUID: 8gsnMi3ZTk+EftPM8HOX4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="70307373"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="70307373"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:58 -0700
X-CSE-ConnectionGUID: VpM5hPgBTQyIZMHKzcnnJw==
X-CSE-MsgGUID: XE3ouerFThOfWh7chFL/rA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="172207451"
Received: from unknown (HELO CannotLeaveINTEL.jf.intel.com) ([10.165.54.94])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:58 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: acme@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@kernel.org,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	namhyung@kernel.org,
	pbonzini@redhat.com,
	prsampat@amd.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	shuah@kernel.org,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com,
	xiaoyao.li@intel.com
Subject: [PATCH v14 22/22] KVM: selftest: Add tests for KVM_{GET,SET}_ONE_REG
Date: Tue,  9 Sep 2025 02:39:53 -0700
Message-ID: <20250909093953.202028-23-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250909093953.202028-1-chao.gao@intel.com>
References: <20250909093953.202028-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add tests for newly added KVM_{GET,SET}_ONE_REG support for x86. Verify the
new ioctls can read and write real MSRs and synthetic MSRs.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 tools/arch/x86/include/uapi/asm/kvm.h         | 29 ++++++++++++++++++
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../selftests/kvm/x86/get_set_one_reg.c       | 30 +++++++++++++++++++
 3 files changed, 60 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/get_set_one_reg.c

diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 6f3499507c5e..59ac0b46ebcc 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -411,6 +411,35 @@ struct kvm_xcrs {
 	__u64 padding[16];
 };
 
+#define KVM_X86_REG_TYPE_MSR		2
+#define KVM_X86_REG_TYPE_KVM		3
+
+#define KVM_X86_KVM_REG_SIZE(reg)						\
+({										\
+	reg == KVM_REG_GUEST_SSP ? KVM_REG_SIZE_U64 : 0;			\
+})
+
+#define KVM_X86_REG_TYPE_SIZE(type, reg)					\
+({										\
+	__u64 type_size = (__u64)type << 32;					\
+										\
+	type_size |= type == KVM_X86_REG_TYPE_MSR ? KVM_REG_SIZE_U64 :		\
+		     type == KVM_X86_REG_TYPE_KVM ? KVM_X86_KVM_REG_SIZE(reg) :	\
+		     0;								\
+	type_size;								\
+})
+
+#define KVM_X86_REG_ENCODE(type, index)				\
+	(KVM_REG_X86 | KVM_X86_REG_TYPE_SIZE(type, index) | index)
+
+#define KVM_X86_REG_MSR(index)					\
+	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_MSR, index)
+#define KVM_X86_REG_KVM(index)					\
+	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_KVM, index)
+
+/* KVM-defined registers starting from 0 */
+#define KVM_REG_GUEST_SSP	0
+
 #define KVM_SYNC_X86_REGS      (1UL << 0)
 #define KVM_SYNC_X86_SREGS     (1UL << 1)
 #define KVM_SYNC_X86_EVENTS    (1UL << 2)
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index f6fe7a07a0a2..9a375d5faf1c 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -136,6 +136,7 @@ TEST_GEN_PROGS_x86 += x86/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86 += x86/triple_fault_event_test
 TEST_GEN_PROGS_x86 += x86/recalc_apic_map_test
 TEST_GEN_PROGS_x86 += x86/aperfmperf_test
+TEST_GEN_PROGS_x86 += x86/get_set_one_reg
 TEST_GEN_PROGS_x86 += access_tracking_perf_test
 TEST_GEN_PROGS_x86 += coalesced_io_test
 TEST_GEN_PROGS_x86 += dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/x86/get_set_one_reg.c b/tools/testing/selftests/kvm/x86/get_set_one_reg.c
new file mode 100644
index 000000000000..8a4dbc812214
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/get_set_one_reg.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <fcntl.h>
+#include <stdint.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	u64 data;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ONE_REG));
+
+	vm = vm_create_with_one_vcpu(&vcpu, NULL);
+
+	TEST_ASSERT_EQ(__vcpu_get_reg(vcpu, KVM_X86_REG_MSR(MSR_EFER), &data), 0);
+	TEST_ASSERT_EQ(__vcpu_set_reg(vcpu, KVM_X86_REG_MSR(MSR_EFER), data), 0);
+
+	if (kvm_cpu_has(X86_FEATURE_SHSTK)) {
+		TEST_ASSERT_EQ(__vcpu_get_reg(vcpu, KVM_X86_REG_KVM(KVM_REG_GUEST_SSP), &data), 0);
+		TEST_ASSERT_EQ(__vcpu_set_reg(vcpu, KVM_X86_REG_KVM(KVM_REG_GUEST_SSP), data), 0);
+	}
+
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.47.3


