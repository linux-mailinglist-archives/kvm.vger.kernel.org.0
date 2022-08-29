Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3A25A52D8
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 19:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbiH2RLf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 13:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbiH2RL0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 13:11:26 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BF361DB3
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 10:11:02 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id h12-20020a170902f54c00b0016f8858ce9bso6467088plf.9
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 10:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=qYBu9gvtSH25gzhu9AMMMrhFUrc6l+KYBGnqODMY8CI=;
        b=VQ/GS+WrbwpQxbs7uP6/1uuMKIc8Qp7pagAU63kllL+2+jGmpPYU0tO5ogwGOPfrHm
         vDgXW3vMtbWgrzSzPlj3qKA2pJba7bFL+cCmPx7jwKT8kh468FHjO8lo9NnHkwRAehy5
         Gn09ia2P7x4qjIRMNX86MyqBE7JEzHKuo73sfk9LzpPjzTlgNz0Qprp6tAcS8MRNdw1A
         J2NVgCKx1aWrPIPWBD/g/46y3eRPCz5J/zvgcyDRj0suGWiedUZLv09rzsxFXJS4/TOj
         MDt9sLgR85Jc3PfuleG58xhMIgEPurZbAsqMjhFYc0iI8ntbW08plqjDPbCwIL2F8qZJ
         EJSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=qYBu9gvtSH25gzhu9AMMMrhFUrc6l+KYBGnqODMY8CI=;
        b=xIoLluqmuq1LRGOKdTruaqIrQksuk8pbLFjqH7ojQR173ZjKKbVZXYDq0kI1E5qDbk
         lzrBwr/bv/2XllA+c06KWCOtRJ9Vu/H96zTDBhSikQ7rvL3qeF3frX977T8a/mW/Q7u+
         e31pQhrFn9LzhA17GlwPO71yHOJf58GZubX0pT///tZL+LYK0vRvs8Jm1zw7Iq4EQF8f
         Ff8zgdeMvMrnvkn79pSV4A3J7Ebs06FTGcGNhu4HZox/nr1eLBNrDZA95Ca3k4GD945j
         gN3xnm8GsAe5nhNEiEcZJ952nhQ1VzLLeB63sIuNcQJ7BYELx/JyxqOU6vkAT2AQZeEb
         QL2A==
X-Gm-Message-State: ACgBeo3IipzPP1PQr15Hw+K+MtLGQrrD/LvqwKhT2VTXH9dHDIi8kpSo
        POsvyzlrMAnvUZtZpDBKzgmLVxkVq4MaeAbn0ptZuHAVFpS4k68USWq7M1IK0vRkqhnwfAzJmh7
        pWpC9qMV3oh1LM5MEQhgDLoSGZEejzZcYAbACOngpyT0umb7+lptagyMkeA==
X-Google-Smtp-Source: AA6agR7GBGZ5S1BuVQpRcvhwV3Zq/amjMJEM/KN6XPoeQKwtvyCOh5BKqVStNRP9yUi0i3hZOjPsANV5J3k=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:cddb:77a7:c55e:a7a2])
 (user=pgonda job=sendgmr) by 2002:a17:902:be02:b0:172:d409:e057 with SMTP id
 r2-20020a170902be0200b00172d409e057mr17472215pls.90.1661793061692; Mon, 29
 Aug 2022 10:11:01 -0700 (PDT)
Date:   Mon, 29 Aug 2022 10:10:19 -0700
In-Reply-To: <20220829171021.701198-1-pgonda@google.com>
Message-Id: <20220829171021.701198-7-pgonda@google.com>
Mime-Version: 1.0
References: <20220829171021.701198-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Subject: [V4 6/8] KVM: selftests: add library for creating/interacting with
 SEV guests
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add interfaces to allow tests to create/manage SEV guests. The
additional state associated with these guests is encapsulated in a new
struct sev_vm, which is a light wrapper around struct kvm_vm. These
VMs will use vm_set_memory_encryption() and vm_get_encrypted_phy_pages()
under the covers to configure and sync up with the core kvm_util
library on what should/shouldn't be treated as encrypted memory.

Originally-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/kvm_util_base.h     |   3 +
 .../selftests/kvm/include/x86_64/sev.h        |  47 ++++
 tools/testing/selftests/kvm/lib/x86_64/sev.c  | 232 ++++++++++++++++++
 4 files changed, 283 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/sev.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/sev.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 23649c5d42fc..0a70e50f0498 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -56,6 +56,7 @@ LIBKVM_x86_64 += lib/x86_64/processor.c
 LIBKVM_x86_64 += lib/x86_64/svm.c
 LIBKVM_x86_64 += lib/x86_64/ucall.c
 LIBKVM_x86_64 += lib/x86_64/vmx.c
+LIBKVM_x86_64 += lib/x86_64/sev.c
 
 LIBKVM_aarch64 += lib/aarch64/gic.c
 LIBKVM_aarch64 += lib/aarch64/gic_v3.c
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 489e8c833e5f..0927e262623d 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -69,6 +69,7 @@ struct userspace_mem_regions {
 /* Memory encryption policy/configuration. */
 struct vm_memcrypt {
 	bool enabled;
+	bool encrypted;
 	int8_t enc_by_default;
 	bool has_enc_bit;
 	int8_t enc_bit;
@@ -831,6 +832,8 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva);
 
 static inline vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
+	TEST_ASSERT(!vm->memcrypt.encrypted,
+		    "Encrypted guests have their page tables encrypted so gva2gpa conversions are not possible.");
 	return addr_arch_gva2gpa(vm, gva);
 }
 
diff --git a/tools/testing/selftests/kvm/include/x86_64/sev.h b/tools/testing/selftests/kvm/include/x86_64/sev.h
new file mode 100644
index 000000000000..810d36377e8c
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86_64/sev.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Helpers used for SEV guests
+ *
+ * Copyright (C) 2021 Advanced Micro Devices
+ */
+#ifndef SELFTEST_KVM_SEV_H
+#define SELFTEST_KVM_SEV_H
+
+#include <stdint.h>
+#include <stdbool.h>
+#include "kvm_util.h"
+
+/* Makefile might set this separately for user-overrides */
+#ifndef SEV_DEV_PATH
+#define SEV_DEV_PATH		"/dev/sev"
+#endif
+
+#define SEV_FW_REQ_VER_MAJOR	0
+#define SEV_FW_REQ_VER_MINOR	17
+
+#define SEV_POLICY_NO_DBG	(1UL << 0)
+#define SEV_POLICY_ES		(1UL << 2)
+
+enum sev_guest_state {
+	SEV_GSTATE_UNINIT = 0,
+	SEV_GSTATE_LUPDATE,
+	SEV_GSTATE_LSECRET,
+	SEV_GSTATE_RUNNING,
+};
+
+struct sev_vm {
+	struct kvm_vm *vm;
+	int fd;
+	int enc_bit;
+	uint32_t sev_policy;
+};
+
+void kvm_sev_ioctl(struct sev_vm *sev, int cmd, void *data);
+
+struct sev_vm *sev_vm_create(uint32_t policy, uint64_t npages);
+void sev_vm_free(struct sev_vm *sev);
+void sev_vm_launch(struct sev_vm *sev);
+void sev_vm_launch_measure(struct sev_vm *sev, uint8_t *measurement);
+void sev_vm_launch_finish(struct sev_vm *sev);
+
+#endif /* SELFTEST_KVM_SEV_H */
diff --git a/tools/testing/selftests/kvm/lib/x86_64/sev.c b/tools/testing/selftests/kvm/lib/x86_64/sev.c
new file mode 100644
index 000000000000..dd8d708fd01a
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/x86_64/sev.c
@@ -0,0 +1,232 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Helpers used for SEV guests
+ *
+ * Copyright (C) 2021 Advanced Micro Devices
+ */
+
+#include <stdint.h>
+#include <stdbool.h>
+#include "kvm_util.h"
+#include "linux/psp-sev.h"
+#include "processor.h"
+#include "sev.h"
+
+#define CPUID_MEM_ENC_LEAF 0x8000001f
+#define CPUID_EBX_CBIT_MASK 0x3f
+
+/* Common SEV helpers/accessors. */
+
+void sev_ioctl(int sev_fd, int cmd, void *data)
+{
+	int ret;
+	struct sev_issue_cmd arg;
+
+	arg.cmd = cmd;
+	arg.data = (unsigned long)data;
+	ret = ioctl(sev_fd, SEV_ISSUE_CMD, &arg);
+	TEST_ASSERT(ret == 0,
+		    "SEV ioctl %d failed, error: %d, fw_error: %d",
+		    cmd, ret, arg.error);
+}
+
+void kvm_sev_ioctl(struct sev_vm *sev, int cmd, void *data)
+{
+	struct kvm_sev_cmd arg = {0};
+	int ret;
+
+	arg.id = cmd;
+	arg.sev_fd = sev->fd;
+	arg.data = (__u64)data;
+
+	ret = ioctl(sev->vm->fd, KVM_MEMORY_ENCRYPT_OP, &arg);
+	TEST_ASSERT(ret == 0,
+		    "SEV KVM ioctl %d failed, rc: %i errno: %i (%s), fw_error: %d",
+		    cmd, ret, errno, strerror(errno), arg.error);
+}
+
+/* Local helpers. */
+
+static void sev_register_user_region(struct sev_vm *sev, void *hva, uint64_t size)
+{
+	struct kvm_enc_region range = {0};
+	int ret;
+
+	pr_debug("%s: hva: %p, size: %lu\n", __func__, hva, size);
+
+	range.addr = (__u64)hva;
+	range.size = size;
+
+	ret = ioctl(sev->vm->fd, KVM_MEMORY_ENCRYPT_REG_REGION, &range);
+	TEST_ASSERT(ret == 0, "failed to register user range, errno: %i\n", errno);
+}
+
+static void sev_encrypt_phy_range(struct sev_vm *sev, vm_paddr_t gpa, uint64_t size)
+{
+	struct kvm_sev_launch_update_data ksev_update_data = {0};
+
+	pr_debug("%s: addr: 0x%lx, size: %lu\n", __func__, gpa, size);
+
+	ksev_update_data.uaddr = (__u64)addr_gpa2hva(sev->vm, gpa);
+	ksev_update_data.len = size;
+
+	kvm_sev_ioctl(sev, KVM_SEV_LAUNCH_UPDATE_DATA, &ksev_update_data);
+}
+
+static void sev_encrypt(struct sev_vm *sev)
+{
+	const struct sparsebit *enc_phy_pages;
+	struct kvm_vm *vm = sev->vm;
+	sparsebit_idx_t pg = 0;
+	vm_paddr_t gpa_start;
+	uint64_t memory_size;
+	int ctr;
+	struct userspace_mem_region *region;
+
+	hash_for_each(vm->regions.slot_hash, ctr, region, slot_node) {
+		enc_phy_pages = vm_get_encrypted_phy_pages(
+			sev->vm, region->region.slot, &gpa_start, &memory_size);
+		TEST_ASSERT(enc_phy_pages,
+			    "Unable to retrieve encrypted pages bitmap");
+		while (pg < (memory_size / vm->page_size)) {
+			sparsebit_idx_t pg_cnt;
+
+			if (sparsebit_is_clear(enc_phy_pages, pg)) {
+				pg = sparsebit_next_set(enc_phy_pages, pg);
+				if (!pg)
+					break;
+			}
+
+			pg_cnt = sparsebit_next_clear(enc_phy_pages, pg) - pg;
+			if (pg_cnt <= 0)
+				pg_cnt = 1;
+
+			sev_encrypt_phy_range(sev,
+					      gpa_start + pg * vm->page_size,
+					      pg_cnt * vm->page_size);
+			pg += pg_cnt;
+		}
+	}
+
+	sev->vm->memcrypt.encrypted = true;
+}
+
+/* SEV VM implementation. */
+
+static struct sev_vm *sev_vm_alloc(struct kvm_vm *vm)
+{
+	struct sev_user_data_status sev_status;
+	uint32_t eax, ebx, ecx, edx;
+	struct sev_vm *sev;
+	int sev_fd;
+
+	sev_fd = open(SEV_DEV_PATH, O_RDWR);
+	if (sev_fd < 0) {
+		pr_info("Failed to open SEV device, path: %s, error: %d, skipping test.\n",
+			SEV_DEV_PATH, sev_fd);
+		return NULL;
+	}
+
+	sev_ioctl(sev_fd, SEV_PLATFORM_STATUS, &sev_status);
+
+	if (!(sev_status.api_major > SEV_FW_REQ_VER_MAJOR ||
+	      (sev_status.api_major == SEV_FW_REQ_VER_MAJOR &&
+	       sev_status.api_minor >= SEV_FW_REQ_VER_MINOR))) {
+		pr_info("SEV FW version too old. Have API %d.%d (build: %d), need %d.%d, skipping test.\n",
+			sev_status.api_major, sev_status.api_minor, sev_status.build,
+			SEV_FW_REQ_VER_MAJOR, SEV_FW_REQ_VER_MINOR);
+		return NULL;
+	}
+
+	sev = calloc(1, sizeof(*sev));
+	sev->fd = sev_fd;
+	sev->vm = vm;
+
+	/* Get encryption bit via CPUID. */
+	cpuid(CPUID_MEM_ENC_LEAF, &eax, &ebx, &ecx, &edx);
+	sev->enc_bit = ebx & CPUID_EBX_CBIT_MASK;
+
+	return sev;
+}
+
+void sev_vm_free(struct sev_vm *sev)
+{
+	kvm_vm_free(sev->vm);
+	close(sev->fd);
+	free(sev);
+}
+
+struct sev_vm *sev_vm_create(uint32_t policy, uint64_t npages)
+{
+	struct sev_vm *sev;
+	struct kvm_vm *vm;
+
+	/* Need to handle memslots after init, and after setting memcrypt. */
+	vm = vm_create_barebones();
+	sev = sev_vm_alloc(vm);
+	if (!sev)
+		return NULL;
+	sev->sev_policy = policy;
+
+	kvm_sev_ioctl(sev, KVM_SEV_INIT, NULL);
+
+	vm->vpages_mapped = sparsebit_alloc();
+	vm_set_memory_encryption(vm, true, true, sev->enc_bit);
+	pr_info("SEV cbit: %d\n", sev->enc_bit);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, npages, 0);
+	sev_register_user_region(sev, addr_gpa2hva(vm, 0),
+				 npages * vm->page_size);
+
+	pr_info("SEV guest created, policy: 0x%x, size: %lu KB\n",
+		sev->sev_policy, npages * vm->page_size / 1024);
+
+	return sev;
+}
+
+void sev_vm_launch(struct sev_vm *sev)
+{
+	struct kvm_sev_launch_start ksev_launch_start = {0};
+	struct kvm_sev_guest_status ksev_status;
+
+	ksev_launch_start.policy = sev->sev_policy;
+	kvm_sev_ioctl(sev, KVM_SEV_LAUNCH_START, &ksev_launch_start);
+	kvm_sev_ioctl(sev, KVM_SEV_GUEST_STATUS, &ksev_status);
+	TEST_ASSERT(ksev_status.policy == sev->sev_policy, "Incorrect guest policy.");
+	TEST_ASSERT(ksev_status.state == SEV_GSTATE_LUPDATE,
+		    "Unexpected guest state: %d", ksev_status.state);
+
+	ucall_init(sev->vm, 0);
+
+	sev_encrypt(sev);
+}
+
+void sev_vm_launch_measure(struct sev_vm *sev, uint8_t *measurement)
+{
+	struct kvm_sev_launch_measure ksev_launch_measure;
+	struct kvm_sev_guest_status ksev_guest_status;
+
+	ksev_launch_measure.len = 256;
+	ksev_launch_measure.uaddr = (__u64)measurement;
+	kvm_sev_ioctl(sev, KVM_SEV_LAUNCH_MEASURE, &ksev_launch_measure);
+
+	/* Measurement causes a state transition, check that. */
+	kvm_sev_ioctl(sev, KVM_SEV_GUEST_STATUS, &ksev_guest_status);
+	TEST_ASSERT(ksev_guest_status.state == SEV_GSTATE_LSECRET,
+		    "Unexpected guest state: %d", ksev_guest_status.state);
+}
+
+void sev_vm_launch_finish(struct sev_vm *sev)
+{
+	struct kvm_sev_guest_status ksev_status;
+
+	kvm_sev_ioctl(sev, KVM_SEV_GUEST_STATUS, &ksev_status);
+	TEST_ASSERT(ksev_status.state == SEV_GSTATE_LUPDATE ||
+		    ksev_status.state == SEV_GSTATE_LSECRET,
+		    "Unexpected guest state: %d", ksev_status.state);
+
+	kvm_sev_ioctl(sev, KVM_SEV_LAUNCH_FINISH, NULL);
+
+	kvm_sev_ioctl(sev, KVM_SEV_GUEST_STATUS, &ksev_status);
+	TEST_ASSERT(ksev_status.state == SEV_GSTATE_RUNNING,
+		    "Unexpected guest state: %d", ksev_status.state);
+}
-- 
2.37.2.672.g94769d06f0-goog

