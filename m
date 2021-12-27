Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2314347FCBC
	for <lists+kvm@lfdr.de>; Mon, 27 Dec 2021 13:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236731AbhL0MtA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Dec 2021 07:49:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41048 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbhL0Ms7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Dec 2021 07:48:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1066960FE4
        for <kvm@vger.kernel.org>; Mon, 27 Dec 2021 12:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730C1C36AED;
        Mon, 27 Dec 2021 12:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640609338;
        bh=cu2kAi8SL5jXi3CUYa/kgsOf3drXtvwoWe36i/xx+7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDMZfBRmvlbEo66NZckcvXG6QYwg3YGeYwvhCY6PFpuBVszEaozV5waHDOD39eUXD
         dzJ1YFJDsdlnBqAE1copg15IKs8SWLw5L0VSkeT7l8cWtmpC1JXYUAun3yq1JYKFVo
         Y6Wwbd2slfxZ6j4UAlN1raah43i7lYHoYYiwb3TuhCcau2Kon3T705pIDJFK0zJwKn
         fgn2ALdFbqrK2wuNl2MZ7nonFH4QPSBw880rnOLTxSAN5EGDXcxA6xCyfvzxrWYsc4
         1a2RPkQgphV06HvoRDRG3EQV0IngUYYCkJIs7V1PpCKs73S60/4ZXyVZ1BVALTyxUH
         +Y0KXqQQWa0hg==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1n1pQu-00EYBY-HV; Mon, 27 Dec 2021 12:48:56 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: [PATCH v2 3/6] KVM: selftests: arm64: Check for supported page sizes
Date:   Mon, 27 Dec 2021 12:48:06 +0000
Message-Id: <20211227124809.1335409-4-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211227124809.1335409-1-maz@kernel.org>
References: <20211227124809.1335409-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just as arm64 implemenations don't necessary support all IPA
ranges, they don't  all support the same page sizes either. Fun.

Create a dummy VM to snapshot the page sizes supported by the
host, and filter the supported modes.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 .../selftests/kvm/include/aarch64/processor.h |  3 ++
 .../selftests/kvm/lib/aarch64/processor.c     | 36 +++++++++++++++++++
 tools/testing/selftests/kvm/lib/guest_modes.c | 17 +++++----
 3 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 27d8e1bb5b36..8f9f46979a00 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -113,6 +113,9 @@ enum {
 #define ESR_EC_WP_CURRENT	0x35
 #define ESR_EC_BRK_INS		0x3c
 
+void aarch64_get_supported_page_sizes(uint32_t ipa,
+				      bool *ps4k, bool *ps16k, bool *ps64k);
+
 void vm_init_descriptor_tables(struct kvm_vm *vm);
 void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid);
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index b509341b8411..49fcfe9768e0 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -8,6 +8,7 @@
 #include <linux/compiler.h>
 #include <assert.h>
 
+#include "guest_modes.h"
 #include "kvm_util.h"
 #include "../kvm_util_internal.h"
 #include "processor.h"
@@ -433,6 +434,41 @@ uint32_t guest_get_vcpuid(void)
 	return read_sysreg(tpidr_el1);
 }
 
+void aarch64_get_supported_page_sizes(uint32_t ipa,
+				      bool *ps4k, bool *ps16k, bool *ps64k)
+{
+	struct kvm_vcpu_init preferred_init;
+	int kvm_fd, vm_fd, vcpu_fd, err;
+	uint64_t val;
+	struct kvm_one_reg reg = {
+		.id	= KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR0_EL1),
+		.addr	= (uint64_t)&val,
+	};
+
+	kvm_fd = open_kvm_dev_path_or_exit();
+	vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, ipa);
+	TEST_ASSERT(vm_fd >= 0, "Can't create VM");
+
+	vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
+	TEST_ASSERT(vcpu_fd >= 0, "Can't create vcpu");
+
+	err = ioctl(vm_fd, KVM_ARM_PREFERRED_TARGET, &preferred_init);
+	TEST_ASSERT(err == 0, "Can't get target");
+	err = ioctl(vcpu_fd, KVM_ARM_VCPU_INIT, &preferred_init);
+	TEST_ASSERT(err == 0, "Can't get init vcpu");
+
+	err = ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
+	TEST_ASSERT(err == 0, "Can't get MMFR0");
+
+	*ps4k = ((val >> 28) & 0xf) != 0xf;
+	*ps64k = ((val >> 24) & 0xf) == 0;
+	*ps16k = ((val >> 20) & 0xf) != 0;
+
+	close(vcpu_fd);
+	close(vm_fd);
+	close(kvm_fd);
+}
+
 /*
  * arm64 doesn't have a true default mode, so start by computing the
  * available IPA space and page sizes early.
diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
index 5e3fdbd992fd..67144fdac433 100644
--- a/tools/testing/selftests/kvm/lib/guest_modes.c
+++ b/tools/testing/selftests/kvm/lib/guest_modes.c
@@ -5,6 +5,7 @@
 #include "guest_modes.h"
 
 #ifdef __aarch64__
+#include "processor.h"
 enum vm_guest_mode vm_mode_default;
 #endif
 
@@ -17,20 +18,24 @@ void guest_modes_append_default(void)
 #else
 	{
 		unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
+		bool ps4k, ps16k, ps64k;
 		int i;
 
+		aarch64_get_supported_page_sizes(limit, &ps4k, &ps16k, &ps64k);
+
 		vm_mode_default = NUM_VM_MODES;
 
 		if (limit >= 52)
-			guest_mode_append(VM_MODE_P52V48_64K, true, true);
+			guest_mode_append(VM_MODE_P52V48_64K, ps64k, ps64k);
 		if (limit >= 48) {
-			guest_mode_append(VM_MODE_P48V48_4K, true, true);
-			guest_mode_append(VM_MODE_P48V48_64K, true, true);
+			guest_mode_append(VM_MODE_P48V48_4K, ps4k, ps4k);
+			guest_mode_append(VM_MODE_P48V48_64K, ps64k, ps64k);
 		}
 		if (limit >= 40) {
-			guest_mode_append(VM_MODE_P40V48_4K, true, true);
-			guest_mode_append(VM_MODE_P40V48_64K, true, true);
-			vm_mode_default = VM_MODE_P40V48_4K;
+			guest_mode_append(VM_MODE_P40V48_4K, ps4k, ps4k);
+			guest_mode_append(VM_MODE_P40V48_64K, ps64k, ps64k);
+			if (ps4k)
+				vm_mode_default = VM_MODE_P40V48_4K;
 		}
 
 		/*
-- 
2.30.2

