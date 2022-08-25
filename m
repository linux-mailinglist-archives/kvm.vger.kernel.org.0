Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3E525A1D20
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 01:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244537AbiHYXZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 19:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244526AbiHYXZo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 19:25:44 -0400
Received: from mail-oo1-xc4a.google.com (mail-oo1-xc4a.google.com [IPv6:2607:f8b0:4864:20::c4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BDD58515
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 16:25:37 -0700 (PDT)
Received: by mail-oo1-xc4a.google.com with SMTP id g24-20020a4a6b18000000b0042886f34138so60871ooc.19
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 16:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=P2RgcF+gBHFPYTEvaTfo6AUsgguGiX9tPlCot3RYgGs=;
        b=SQlk6JoM9pPHFnCVZCc0ePWkuMHGeijaVL83mtpLkCr48WVn0+0gDXr/NuYB1zXSVO
         GPRiPy85aSM+mIC3yV0GAUcA/pDxT4NHPXYB+k8l/pDyY0rcK6NFayKYt+lmzF4+YMLK
         txAL8zPFasMqUjJqK1GnvSpPbY5DfVcxLT3ZUUYd8NRiael/0olsW4RcRdZBwGGB8x21
         L/R24+VZiiccgoc/C5RvauNC9ujJknNlbnB+rtYvuJrj6wYuk/wD6iCQWgJ0FMpLLkdK
         HG8TrVwe7K0xOMjVu9uiaeNiHKTm3rTfJGVakSCdj8sRZn7o4jm3P8cc3mUCDNSs8gWr
         UdKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=P2RgcF+gBHFPYTEvaTfo6AUsgguGiX9tPlCot3RYgGs=;
        b=Gmvsaym1mMHCncSGgDLchiuDioyrHidhzGcUlHHFyIpZJXwcrgbUNqLJf04V8ijKMR
         riQlASLera21j6gqm8/Hoyopvl58Zx5OmB8KhJ88HooeB9JgWA/y+d+MievfTBgk2jOz
         0onJVy2cwmI/VS+eK7sOVH2rUxuSln/ZspkKxyVdd1CBVqousDsfwMuk85DBPthoT1JM
         bidLz1NnqENHuGa3oJ5aACt91W1R/5pfJzMaQP6215Ih0q2PkTYj+k0nrYWFb2B58FS+
         F8BtLd6cKbq3lp+497IwTNgLF443ryLZA9rKhGp/pnVk+hvLkoopgt2cqmVe/DDUd6rh
         fs3g==
X-Gm-Message-State: ACgBeo1j7kEEI+/zVQRrHg7XU0S98BE7+2AUdbd2X+M/S7AJOZobA6BY
        YErxNfQ2Tjop6c031oPBRY33E9K9g9Q=
X-Google-Smtp-Source: AA6agR6pzAdCDgmgO0oso/HoE5WH7WCkL3PKyA8KRrEe2RCrD5ZThqMcZM2sOfAjsU0cXCoGFEqZmqOEaDw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6870:a90f:b0:11e:5773:84c5 with SMTP id
 eq15-20020a056870a90f00b0011e577384c5mr448463oab.75.1661469936767; Thu, 25
 Aug 2022 16:25:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Aug 2022 23:25:22 +0000
In-Reply-To: <20220825232522.3997340-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220825232522.3997340-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220825232522.3997340-8-seanjc@google.com>
Subject: [PATCH v5 7/7] KVM: selftests: Add ucall pool based implementation
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>,
        Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Colton Lewis <coltonlewis@google.com>,
        Peter Gonda <pgonda@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Sean Christopherson <seanjc@google.com>
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

From: Peter Gonda <pgonda@google.com>

To play nice with guests whose stack memory is encrypted, e.g. AMD SEV,
introduce a new "ucall pool" implementation that passes the ucall struct
via dedicated memory (which can be mapped shared, a.k.a. as plain text).

Because not all architectures have access to the vCPU index in the guest,
use a bitmap with atomic accesses to track which entries in the pool are
free/used.  A list+lock could also work in theory, but synchronizing the
individual pointers to the guest would be a mess.

Note, there's no need to rewalk the bitmap to ensure success.  If all
vCPUs are simply allocating, success is guaranteed because there are
enough entries for all vCPUs.  If one or more vCPUs are freeing and then
reallocating, success is guaranteed because vCPUs _always_ walk the
bitmap from 0=>N; if vCPU frees an entry and then wins a race to
re-allocate, then either it will consume the entry it just freed (bit is
the first free bit), or the losing vCPU is guaranteed to see the freed
bit (winner consumes an earlier bit, which the loser hasn't yet visited).

Signed-off-by: Peter Gonda <pgonda@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/ucall_common.h      |  9 ++-
 .../testing/selftests/kvm/lib/aarch64/ucall.c |  7 +-
 tools/testing/selftests/kvm/lib/riscv/ucall.c |  2 +-
 tools/testing/selftests/kvm/lib/s390x/ucall.c |  2 +-
 .../testing/selftests/kvm/lib/ucall_common.c  | 71 +++++++++++++++++--
 .../testing/selftests/kvm/lib/x86_64/ucall.c  |  2 +-
 6 files changed, 76 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 2662a4352a8c..bdd373189a77 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -22,6 +22,9 @@ enum {
 struct ucall {
 	uint64_t cmd;
 	uint64_t args[UCALL_MAX_ARGS];
+
+	/* Host virtual address of this struct. */
+	struct ucall *hva;
 };
 
 void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
@@ -30,11 +33,7 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 
 void ucall(uint64_t cmd, int nargs, ...);
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
-
-static inline void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
-{
-	ucall_arch_init(vm, mmio_gpa);
-}
+void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
 
 #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
 				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
index 21d73afcb14f..562c16dfbb00 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -32,12 +32,9 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 
 	if (run->exit_reason == KVM_EXIT_MMIO &&
 	    run->mmio.phys_addr == vcpu->vm->ucall_mmio_addr) {
-		vm_vaddr_t gva;
-
-		TEST_ASSERT(run->mmio.is_write && run->mmio.len == 8,
+		TEST_ASSERT(run->mmio.is_write && run->mmio.len == sizeof(uint64_t),
 			    "Unexpected ucall exit mmio address access");
-		memcpy(&gva, run->mmio.data, sizeof(gva));
-		return addr_gva2hva(vcpu->vm, gva);
+		return (void *)(*((uint64_t *)run->mmio.data));
 	}
 
 	return NULL;
diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testing/selftests/kvm/lib/riscv/ucall.c
index 78acdb084ab0..9a3476a2dfca 100644
--- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
+++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
@@ -55,7 +55,7 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 	    run->riscv_sbi.extension_id == KVM_RISCV_SELFTESTS_SBI_EXT) {
 		switch (run->riscv_sbi.function_id) {
 		case KVM_RISCV_SELFTESTS_SBI_UCALL:
-			return addr_gva2hva(vcpu->vm, run->riscv_sbi.args[0]);
+			return (void *)run->riscv_sbi.args[0];
 		case KVM_RISCV_SELFTESTS_SBI_UNEXP:
 			vcpu_dump(stderr, vcpu, 2);
 			TEST_ASSERT(0, "Unexpected trap taken by guest");
diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
index cbee520a26f2..a7f02dc372cf 100644
--- a/tools/testing/selftests/kvm/lib/s390x/ucall.c
+++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
@@ -26,7 +26,7 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 	    (run->s390_sieic.ipb >> 16) == 0x501) {
 		int reg = run->s390_sieic.ipa & 0xf;
 
-		return addr_gva2hva(vcpu->vm, run->s.regs.gprs[reg]);
+		return (void *)run->s.regs.gprs[reg];
 	}
 	return NULL;
 }
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index ced480860746..cc79d497b6b4 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -1,22 +1,85 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include "kvm_util.h"
+#include "linux/types.h"
+#include "linux/bitmap.h"
+#include "linux/atomic.h"
+
+struct ucall_header {
+	DECLARE_BITMAP(in_use, KVM_MAX_VCPUS);
+	struct ucall ucalls[KVM_MAX_VCPUS];
+};
+
+/*
+ * ucall_pool holds per-VM values (global data is duplicated by each VM), it
+ * must not be accessed from host code.
+ */
+static struct ucall_header *ucall_pool;
+
+void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+{
+	struct ucall_header *hdr;
+	struct ucall *uc;
+	vm_vaddr_t vaddr;
+	int i;
+
+	vaddr = vm_vaddr_alloc(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR);
+	hdr = (struct ucall_header *)addr_gva2hva(vm, vaddr);
+	memset(hdr, 0, sizeof(*hdr));
+
+	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+		uc = &hdr->ucalls[i];
+		uc->hva = uc;
+	}
+
+	write_guest_global(vm, ucall_pool, (struct ucall_header *)vaddr);
+
+	ucall_arch_init(vm, mmio_gpa);
+}
+
+static struct ucall *ucall_alloc(void)
+{
+	struct ucall *uc;
+	int i;
+
+	GUEST_ASSERT(ucall_pool && ucall_pool->in_use);
+
+	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+		if (!atomic_test_and_set_bit(i, ucall_pool->in_use)) {
+			uc = &ucall_pool->ucalls[i];
+			memset(uc->args, 0, sizeof(uc->args));
+			return uc;
+		}
+	}
+	GUEST_ASSERT(0);
+	return NULL;
+}
+
+static void ucall_free(struct ucall *uc)
+{
+	/* Beware, here be pointer arithmetic.  */
+	clear_bit(uc - ucall_pool->ucalls, ucall_pool->in_use);
+}
 
 void ucall(uint64_t cmd, int nargs, ...)
 {
-	struct ucall uc = {};
+	struct ucall *uc;
 	va_list va;
 	int i;
 
-	WRITE_ONCE(uc.cmd, cmd);
+	uc = ucall_alloc();
+
+	WRITE_ONCE(uc->cmd, cmd);
 
 	nargs = min(nargs, UCALL_MAX_ARGS);
 
 	va_start(va, nargs);
 	for (i = 0; i < nargs; ++i)
-		WRITE_ONCE(uc.args[i], va_arg(va, uint64_t));
+		WRITE_ONCE(uc->args[i], va_arg(va, uint64_t));
 	va_end(va);
 
-	ucall_arch_do_ucall((vm_vaddr_t)&uc);
+	ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
+
+	ucall_free(uc);
 }
 
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
index eb8bf55b359a..4d41dc63cc9e 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
@@ -26,7 +26,7 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 		struct kvm_regs regs;
 
 		vcpu_regs_get(vcpu, &regs);
-		return addr_gva2hva(vcpu->vm, regs.rdi);
+		return (void *)regs.rdi;
 	}
 	return NULL;
 }
-- 
2.37.2.672.g94769d06f0-goog

