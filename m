Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C977776A1DF
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 22:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjGaUaf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 16:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjGaUad (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 16:30:33 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D86E52
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 13:30:32 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58473c4f629so51482907b3.1
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 13:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690835431; x=1691440231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5U+ePjx5uvIPbOFZvIPuPHJZ5mQDJ+KWLfp0+392RLI=;
        b=j+LTBrLYE45KvHh8yvAoteE2ggn6Qwq9y+k3kwsvbhuMIRZxzeC/Hkjnp1PzL4jKz6
         0SP7Y2Gyw3r8NONVoC4Os2TY22A/s+xUaYg8F+e67r3OuSq/79zEB/FJpE7SxNxQgu/Y
         gZOPprNIVKzVSAqxaZyd5xLl/r38weSLqHNqGEwiYrcDFt55ycppOXKngWWznZHV691M
         7Pgo+NJgXx2OqWMQ+bAElTC2/b6oHmyW5u0ibv3o7mfpTTpROKZbq6DYkG+21bO/Jl6+
         gma6G0gTU6JJ1sDlUZTklxSaDSY69hwMHE+D2+qOXCtqK6dc1gf2rR/85GyHtr0hKZyr
         mZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690835431; x=1691440231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5U+ePjx5uvIPbOFZvIPuPHJZ5mQDJ+KWLfp0+392RLI=;
        b=kDvpk7Zd1065JUdyyZ+xSWmPAMFii9mCuBMFClDb/oXc98yQQuvn22nlqj2SQY8tnS
         QTMSGFUTAZBs2nAqiE/NKjDWrjkk6zkLq23VooPkP1P6/BfakpIcf2fJDXPRpcKoucqq
         dAV9KsFdbm9anr0Avq9tuZVjpHZP0UIYQ93kT2AQ+yuWW5eREKP6zRYlTkXIJrCOdC3k
         CAwPnEkxZbEEGoodnIC6UcEXCxtZ/vNQ5GAIVFQhLvTn7rvTjxxCIghJ/4fZX2pAHNIN
         UzL+Jrdw/so6g1+c/I2+K5IxxVLP4Zu6E9xu6Q0W6ePZ+9QomVURqmj0KvlHs3ClwSMH
         FYlg==
X-Gm-Message-State: ABy/qLZD8fY5P4NoMQm1G5P1yEoLe7DzK5ImAUYlMjvHYic5qzzhOhbe
        0fUSjFNBn4c/xCwLMOktuBAjN9hmf4g=
X-Google-Smtp-Source: APBJJlHsVu0gs/pIFQ5XNCO1CEWhZmz2TqbrIDwiZ84JP4lQkpQZDXLalyai8ajrI0RoXSI338A/z0leqG8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:30b:0:b0:cea:ef04:1c61 with SMTP id
 11-20020a25030b000000b00ceaef041c61mr69191ybd.1.1690835431546; Mon, 31 Jul
 2023 13:30:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 31 Jul 2023 13:30:24 -0700
In-Reply-To: <20230731203026.1192091-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230731203026.1192091-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230731203026.1192091-2-seanjc@google.com>
Subject: [PATCH v4.1 1/3] KVM: selftests: Add arch ucall.h and inline simple
 arch hooks
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an architecture specific ucall.h and inline the simple arch hooks,
e.g. the init hook for everything except ARM, and the actual "do ucall"
hook for everything except x86 (which should be simple, but temporarily
isn't due to carrying a workaround).

Having a per-arch ucall header will allow adding a #define for the
expected KVM exit reason for a ucall that is colocated (for everything
except x86) with the ucall itself.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/aarch64/ucall.h      | 18 ++++++++++++++++++
 .../selftests/kvm/include/riscv/ucall.h        | 18 ++++++++++++++++++
 .../selftests/kvm/include/s390x/ucall.h        | 17 +++++++++++++++++
 .../selftests/kvm/include/ucall_common.h       |  1 +
 .../selftests/kvm/include/x86_64/ucall.h       | 11 +++++++++++
 .../testing/selftests/kvm/lib/aarch64/ucall.c  | 11 +----------
 tools/testing/selftests/kvm/lib/riscv/ucall.c  | 11 -----------
 tools/testing/selftests/kvm/lib/s390x/ucall.c  | 10 ----------
 tools/testing/selftests/kvm/lib/x86_64/ucall.c |  4 ----
 9 files changed, 66 insertions(+), 35 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/ucall.h
 create mode 100644 tools/testing/selftests/kvm/include/riscv/ucall.h
 create mode 100644 tools/testing/selftests/kvm/include/s390x/ucall.h
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/ucall.h

diff --git a/tools/testing/selftests/kvm/include/aarch64/ucall.h b/tools/testing/selftests/kvm/include/aarch64/ucall.h
new file mode 100644
index 000000000000..fe65fdf4f0d3
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/aarch64/ucall.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTEST_KVM_UCALL_H
+#define SELFTEST_KVM_UCALL_H
+
+#include "kvm_util_base.h"
+
+/*
+ * ucall_exit_mmio_addr holds per-VM values (global data is duplicated by each
+ * VM), it must not be accessed from host code.
+ */
+extern vm_vaddr_t *ucall_exit_mmio_addr;
+
+static inline void ucall_arch_do_ucall(vm_vaddr_t uc)
+{
+	WRITE_ONCE(*ucall_exit_mmio_addr, uc);
+}
+
+#endif
diff --git a/tools/testing/selftests/kvm/include/riscv/ucall.h b/tools/testing/selftests/kvm/include/riscv/ucall.h
new file mode 100644
index 000000000000..86ed0500972b
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/riscv/ucall.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTEST_KVM_UCALL_H
+#define SELFTEST_KVM_UCALL_H
+
+#include "processor.h"
+
+static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+{
+}
+
+static inline void ucall_arch_do_ucall(vm_vaddr_t uc)
+{
+	sbi_ecall(KVM_RISCV_SELFTESTS_SBI_EXT,
+		  KVM_RISCV_SELFTESTS_SBI_UCALL,
+		  uc, 0, 0, 0, 0, 0);
+}
+
+#endif
diff --git a/tools/testing/selftests/kvm/include/s390x/ucall.h b/tools/testing/selftests/kvm/include/s390x/ucall.h
new file mode 100644
index 000000000000..47ad4b1fbccb
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/s390x/ucall.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTEST_KVM_UCALL_H
+#define SELFTEST_KVM_UCALL_H
+
+#include "kvm_util_base.h"
+
+static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+{
+}
+
+static inline void ucall_arch_do_ucall(vm_vaddr_t uc)
+{
+	/* Exit via DIAGNOSE 0x501 (normally used for breakpoints) */
+	asm volatile ("diag 0,%0,0x501" : : "a"(uc) : "memory");
+}
+
+#endif
diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 4ce11c15285a..9e5948dab030 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -7,6 +7,7 @@
 #ifndef SELFTEST_KVM_UCALL_COMMON_H
 #define SELFTEST_KVM_UCALL_COMMON_H
 #include "test_util.h"
+#include "ucall.h"
 
 /* Common ucalls */
 enum {
diff --git a/tools/testing/selftests/kvm/include/x86_64/ucall.h b/tools/testing/selftests/kvm/include/x86_64/ucall.h
new file mode 100644
index 000000000000..05cc69b0d550
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86_64/ucall.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTEST_KVM_UCALL_H
+#define SELFTEST_KVM_UCALL_H
+
+#include "kvm_util_base.h"
+
+static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+{
+}
+
+#endif
diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
index f212bd8ab93d..ddab0ce89d4d 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -6,11 +6,7 @@
  */
 #include "kvm_util.h"
 
-/*
- * ucall_exit_mmio_addr holds per-VM values (global data is duplicated by each
- * VM), it must not be accessed from host code.
- */
-static vm_vaddr_t *ucall_exit_mmio_addr;
+vm_vaddr_t *ucall_exit_mmio_addr;
 
 void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
@@ -23,11 +19,6 @@ void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 	write_guest_global(vm, ucall_exit_mmio_addr, (vm_vaddr_t *)mmio_gva);
 }
 
-void ucall_arch_do_ucall(vm_vaddr_t uc)
-{
-	WRITE_ONCE(*ucall_exit_mmio_addr, uc);
-}
-
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testing/selftests/kvm/lib/riscv/ucall.c
index 9a3476a2dfca..fe6d1004f018 100644
--- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
+++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
@@ -10,10 +10,6 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
-{
-}
-
 struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 			unsigned long arg1, unsigned long arg2,
 			unsigned long arg3, unsigned long arg4,
@@ -40,13 +36,6 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 	return ret;
 }
 
-void ucall_arch_do_ucall(vm_vaddr_t uc)
-{
-	sbi_ecall(KVM_RISCV_SELFTESTS_SBI_EXT,
-		  KVM_RISCV_SELFTESTS_SBI_UCALL,
-		  uc, 0, 0, 0, 0, 0);
-}
-
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
index a7f02dc372cf..cca98734653d 100644
--- a/tools/testing/selftests/kvm/lib/s390x/ucall.c
+++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
@@ -6,16 +6,6 @@
  */
 #include "kvm_util.h"
 
-void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
-{
-}
-
-void ucall_arch_do_ucall(vm_vaddr_t uc)
-{
-	/* Exit via DIAGNOSE 0x501 (normally used for breakpoints) */
-	asm volatile ("diag 0,%0,0x501" : : "a"(uc) : "memory");
-}
-
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
index a53df3ece2f8..1265cecc7dd1 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
@@ -8,10 +8,6 @@
 
 #define UCALL_PIO_PORT ((uint16_t)0x1000)
 
-void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
-{
-}
-
 void ucall_arch_do_ucall(vm_vaddr_t uc)
 {
 	/*
-- 
2.41.0.585.gd2178a4bd4-goog

