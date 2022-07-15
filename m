Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE530576777
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 21:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbiGOTbJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 15:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbiGOTak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 15:30:40 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B01E78DD3
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 12:30:23 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31dfe25bd47so13751107b3.18
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 12:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=COdHMadNTPd2b3B+OvLKM9tybkT/K06T/ka5jk6HYjE=;
        b=tko02Rt0sYWe4bCjb5TsQAnEbLcyG/sBmfh1BygatkSMv8t6eZvOoL1s1Q6ICHtPRx
         Z13OzScGR/rr8aOX94mRafW+BxlTM15aXntiYp8La4TvcjuiKJqKMK4TrztZQmTELly8
         xwB70SjBr7gCjHDCKc41cDsCBxi/WVy2NtclvRPGSWQ0ny1iQKkAf//HQJfMvB0ioNmF
         vH25vWD/RUzTl97uWO7M6d9zuls2XL5v741H+Wvw94xri0usW8Yguf3VzrwckSBbG16C
         7sPdT5tw5pORU6FfWmHG/Ls5viXpNYSOoe4nM/AwEIACiQ0DWAL3mEfk7zXmcOLDs2zk
         keuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=COdHMadNTPd2b3B+OvLKM9tybkT/K06T/ka5jk6HYjE=;
        b=Yvk0YGZ0rdwASR3l0dckm2QPFPf6W917hbOVEQCM4yimbCWMm7JMDjubx0TY45B1B7
         sl9lKOFcThq3H1tRH8ORmK8R4GXEby7eQ8Jg45shuWNfyJ41icNzb+ALD7sTqkGNCEPP
         oGQTc5Oq5cqSnaADWPsaC37qreDUuZr19yGKcBe1kejfcNSERD3QNCHq0t75DsjpzIhd
         kgibLXDO9gVkSywNzNulIWGZByhTdODkRLn5DwoL3v27rrfJPjQFfgyckLAATipJl8Gi
         9V51YbsiIfRwG316w/fxtRDAHZqEPef9l83PJ4gZwFZ2lqKg7odVCmwBUEugp9BngFNs
         0Muw==
X-Gm-Message-State: AJIora/Poy9cmc5b9j2uQ343yI6NDwHzsoTEXfkbPRd3IVMQMWMYiu7/
        XUlrPkOBNU1sWDRTX1xK1LPcBgNu6mHbp/Xl0VCocXPkPzUN3Xl4XUsJbHzX3DjA0ijSg+vJfZJ
        yAWtHD/lzcsMR8zcPbPaElULQgdwE8VFcTXFjyhHTxoYyhIJaD4zOxMxvLg==
X-Google-Smtp-Source: AGRyM1uhd3d4RndtFJv7njRJsv3SC5wyIxRYzSXAgsbLE1MBtigrcjbpjpHCiU9hNjAq2OzrCZ6hCYUlFWw=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:bd4e:b81d:4780:497d])
 (user=pgonda job=sendgmr) by 2002:a81:289:0:b0:31c:8b10:fa84 with SMTP id
 131-20020a810289000000b0031c8b10fa84mr17244335ywc.8.1657913422541; Fri, 15
 Jul 2022 12:30:22 -0700 (PDT)
Date:   Fri, 15 Jul 2022 12:29:54 -0700
In-Reply-To: <20220715192956.1873315-1-pgonda@google.com>
Message-Id: <20220715192956.1873315-10-pgonda@google.com>
Mime-Version: 1.0
References: <20220715192956.1873315-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [RFC V1 08/10] KVM: selftests: Make ucall work with encrypted guests
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for encrypted, SEV, guests in the ucall framework. If
encryption is enabled set up a pool of ucall structs in the guests'
shared memory region. This was suggested in the thread on "[RFC PATCH
00/10] KVM: selftests: Add support for test-selectable ucall
implementations". Using a listed as suggested there doesn't work well
because the list is setup using HVAs not GVAs so use a bitmap + array
solution instead to get the same pool result.

Suggested-by:Sean Christopherson <seanjc@google.com>
Signed-off-by: Peter Gonda <pgonda@google.com>

---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/kvm_util_base.h     |  30 +++--
 .../selftests/kvm/include/ucall_common.h      |  14 +--
 .../testing/selftests/kvm/lib/ucall_common.c  | 115 ++++++++++++++++--
 .../testing/selftests/kvm/lib/x86_64/ucall.c  |   2 +-
 5 files changed, 134 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 61e85892dd9b..3d9f2a017389 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -47,6 +47,7 @@ LIBKVM += lib/rbtree.c
 LIBKVM += lib/sparsebit.c
 LIBKVM += lib/test_util.c
 LIBKVM += lib/ucall_common.c
+LIBKVM += $(top_srcdir)/tools/lib/find_bit.c
 
 LIBKVM_x86_64 += lib/x86_64/apic.c
 LIBKVM_x86_64 += lib/x86_64/handlers.S
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 60b604ac9fa9..77aff2356d64 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -65,6 +65,7 @@ struct userspace_mem_regions {
 /* Memory encryption policy/configuration. */
 struct vm_memcrypt {
 	bool enabled;
+	bool encrypted;
 	int8_t enc_by_default;
 	bool has_enc_bit;
 	int8_t enc_bit;
@@ -99,6 +100,8 @@ struct kvm_vm {
 	int stats_fd;
 	struct kvm_stats_header stats_header;
 	struct kvm_stats_desc *stats_desc;
+
+	struct list_head ucall_list;
 };
 
 
@@ -141,21 +144,21 @@ enum vm_guest_mode {
 
 extern enum vm_guest_mode vm_mode_default;
 
-#define VM_MODE_DEFAULT			vm_mode_default
-#define MIN_PAGE_SHIFT			12U
-#define ptes_per_page(page_size)	((page_size) / 8)
+#define VM_MODE_DEFAULT            vm_mode_default
+#define MIN_PAGE_SHIFT            12U
+#define ptes_per_page(page_size)    ((page_size) / 8)
 
 #elif defined(__x86_64__)
 
-#define VM_MODE_DEFAULT			VM_MODE_PXXV48_4K
-#define MIN_PAGE_SHIFT			12U
-#define ptes_per_page(page_size)	((page_size) / 8)
+#define VM_MODE_DEFAULT            VM_MODE_PXXV48_4K
+#define MIN_PAGE_SHIFT            12U
+#define ptes_per_page(page_size)    ((page_size) / 8)
 
 #elif defined(__s390x__)
 
-#define VM_MODE_DEFAULT			VM_MODE_P44V64_4K
-#define MIN_PAGE_SHIFT			12U
-#define ptes_per_page(page_size)	((page_size) / 16)
+#define VM_MODE_DEFAULT            VM_MODE_P44V64_4K
+#define MIN_PAGE_SHIFT            12U
+#define ptes_per_page(page_size)    ((page_size) / 16)
 
 #elif defined(__riscv)
 
@@ -163,9 +166,9 @@ extern enum vm_guest_mode vm_mode_default;
 #error "RISC-V 32-bit kvm selftests not supported"
 #endif
 
-#define VM_MODE_DEFAULT			VM_MODE_P40V48_4K
-#define MIN_PAGE_SHIFT			12U
-#define ptes_per_page(page_size)	((page_size) / 8)
+#define VM_MODE_DEFAULT            VM_MODE_P40V48_4K
+#define MIN_PAGE_SHIFT            12U
+#define ptes_per_page(page_size)    ((page_size) / 8)
 
 #endif
 
@@ -802,6 +805,9 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva);
 
 static inline vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
+	TEST_ASSERT(
+		!vm->memcrypt.encrypted,
+		"Encrypted guests have their page tables encrypted so gva2* conversions are not possible.");
 	return addr_arch_gva2gpa(vm, gva);
 }
 
diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index cb9b37282701..d8ac16a68c0a 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -21,6 +21,10 @@ enum {
 struct ucall {
 	uint64_t cmd;
 	uint64_t args[UCALL_MAX_ARGS];
+
+	/* For encrypted guests. */
+	uint64_t idx;
+	struct ucall *hva;
 };
 
 void ucall_arch_init(struct kvm_vm *vm, void *arg);
@@ -31,15 +35,9 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 void ucall(uint64_t cmd, int nargs, ...);
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
 
-static inline void ucall_init(struct kvm_vm *vm, void *arg)
-{
-	ucall_arch_init(vm, arg);
-}
+void ucall_init(struct kvm_vm *vm, void *arg);
 
-static inline void ucall_uninit(struct kvm_vm *vm)
-{
-	ucall_arch_uninit(vm);
-}
+void ucall_uninit(struct kvm_vm *vm);
 
 #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
 				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index c488ed23d0dd..8e660b10f9b2 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -1,22 +1,123 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include "kvm_util.h"
+#include "linux/types.h"
+#include "linux/bitmap.h"
+#include "linux/bitops.h"
+#include "linux/atomic.h"
+
+struct ucall_header {
+	DECLARE_BITMAP(in_use, KVM_MAX_VCPUS);
+	struct ucall ucalls[KVM_MAX_VCPUS];
+};
+
+static bool encrypted_guest;
+static struct ucall_header *ucall_hdr;
+
+void ucall_init(struct kvm_vm *vm, void *arg)
+{
+	struct ucall *uc;
+	struct ucall_header *hdr;
+	vm_vaddr_t vaddr;
+	int i;
+
+	encrypted_guest = vm->memcrypt.enabled;
+	sync_global_to_guest(vm, encrypted_guest);
+	if (!encrypted_guest)
+		goto out;
+
+	TEST_ASSERT(!ucall_hdr,
+		    "Only a single encrypted guest at a time for ucalls.");
+	vaddr = vm_vaddr_alloc_shared(vm, sizeof(*hdr), vm->page_size);
+	hdr = (struct ucall_header *)addr_gva2hva(vm, vaddr);
+	memset(hdr, 0, sizeof(*hdr));
+
+	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+		uc = &hdr->ucalls[i];
+		uc->hva = uc;
+		uc->idx = i;
+	}
+
+	ucall_hdr = (struct ucall_header *)vaddr;
+	sync_global_to_guest(vm, ucall_hdr);
+
+out:
+	ucall_arch_init(vm, arg);
+}
+
+void ucall_uninit(struct kvm_vm *vm)
+{
+	encrypted_guest = false;
+	ucall_hdr = NULL;
+
+	ucall_arch_uninit(vm);
+}
+
+static struct ucall *ucall_alloc(void)
+{
+	struct ucall *uc = NULL;
+	int i;
+
+	if (!encrypted_guest)
+		goto out;
+
+	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+		if (atomic_test_and_set_bit(i, ucall_hdr->in_use))
+			continue;
+
+		uc = &ucall_hdr->ucalls[i];
+	}
+
+out:
+	return uc;
+}
+
+static void ucall_free(struct ucall *uc)
+{
+	if (!encrypted_guest)
+		return;
+
+	clear_bit(uc->idx, ucall_hdr->in_use);
+}
+
+static vm_vaddr_t get_ucall_addr(struct ucall *uc)
+{
+	if (encrypted_guest)
+		return (vm_vaddr_t)uc->hva;
+
+	return (vm_vaddr_t)uc;
+}
 
 void ucall(uint64_t cmd, int nargs, ...)
 {
-	struct ucall uc = {
-		.cmd = cmd,
-	};
+	struct ucall *uc;
+	struct ucall tmp;
 	va_list va;
 	int i;
 
+	uc = ucall_alloc();
+	if (!uc)
+		uc = &tmp;
+
+	uc->cmd = cmd;
+
 	nargs = min(nargs, UCALL_MAX_ARGS);
 
 	va_start(va, nargs);
 	for (i = 0; i < nargs; ++i)
-		uc.args[i] = va_arg(va, uint64_t);
+		uc->args[i] = va_arg(va, uint64_t);
 	va_end(va);
 
-	ucall_arch_do_ucall((vm_vaddr_t)&uc);
+	ucall_arch_do_ucall(get_ucall_addr(uc));
+
+	ucall_free(uc);
+}
+
+void *get_ucall_hva(struct kvm_vm *vm, void *uc)
+{
+	if (encrypted_guest)
+		return uc;
+
+	return addr_gva2hva(vm, (vm_vaddr_t)uc);
 }
 
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
@@ -27,9 +128,9 @@ uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
 	if (!uc)
 		uc = &ucall;
 
-	addr = ucall_arch_get_ucall(vcpu);
+	addr = get_ucall_hva(vcpu->vm, ucall_arch_get_ucall(vcpu));
 	if (addr) {
-		memcpy(uc, addr, sizeof(*uc));
+		memcpy(uc, addr, sizeof(struct ucall));
 		vcpu_run_complete_io(vcpu);
 	} else {
 		memset(uc, 0, sizeof(*uc));
diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
index ec53a406f689..ea6b2e3a8e39 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
@@ -30,7 +30,7 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 		struct kvm_regs regs;
 
 		vcpu_regs_get(vcpu, &regs);
-		return addr_gva2hva(vcpu->vm, (vm_vaddr_t)regs.rdi);
+		return (void *)regs.rdi;
 	}
 	return NULL;
 }
-- 
2.37.0.170.g444d1eabd0-goog

