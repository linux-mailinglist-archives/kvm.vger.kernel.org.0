Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2864E3FE4B7
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 23:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344806AbhIAVPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 17:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344553AbhIAVPh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 17:15:37 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2C5C0613CF
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 14:14:40 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f64-20020a2538430000b0290593bfc4b046so868259yba.9
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 14:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=t7NNB2BCpuNWh/XMf0nVZVQzgKyb0MYTWR38OjCe0DI=;
        b=RWvQJmyYn0Jc4F66ttkKnWfu9o5Mo839rMCWSY9KEp6t6JNR/c1LhzARwF8ECrdYQ+
         Jgpuag7dE6V6xfv0mNoiBfmr5CfIwg3bnLMOi/kVPgO9b4Sx1uQQrXwGWulTCcHnsJXa
         7kY9CEYBCFDoCaF6NkgCK/ysta5QCdEq3hlM5vk4FcY4Bg59Q8L2Zr1dncSYKknlKWRy
         axnnpB75TCpBhEmUlt58SkJLhF54rHO9ZNlg3x8BOuo0eegq2CNUtGSUmjh1Q0/bQZBM
         Q0rcDyDXNUI6jmaABWMbDal5nQr8lITAiTc61Ru+0R3YnZdWW2H1Av45jvttlpdyqnm+
         IoPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=t7NNB2BCpuNWh/XMf0nVZVQzgKyb0MYTWR38OjCe0DI=;
        b=LkWVU6l6MEr+duAVRk+rBIE5uChWd8DqEjSf4/goyYv30WCQy2Dd2MebkTt8CtTMj2
         ojN51caZW15D7BD3RxJ7prUODzp2xDemJHzFUerJCCKls/FtbhEsQ3Ydcz5PJEHdXCl9
         fkZcpruWqQzfEulBeVCjSSbwuOtbxqwfXEdqYpIsg5plN2Vlle7bdsZ9M0KN9dcgy7Hb
         hVnaL0lw7eA6ePr7622isM61/ory+ynRvtENEgMhJiPPpNxg0dAHFvFb+upZHoCGaxzF
         HvOcWtH5Iy5OZdd/CFg7rqIPz/IPLjLp1b6dJeJxIIViCDhXA2+HwD7MXlcrZbqH4EdB
         e90g==
X-Gm-Message-State: AOAM5338rw0l8oCrLDMvK7WzesHvCxKtotOp+NH4Rrtseqspuj+A0bBn
        eM9pxjhKCppxf+Zv5oEQpWrs7kLGT+/J
X-Google-Smtp-Source: ABdhPJyboGzjAq0Phk0Nu1VckjuEu5bnn6Jc8JwvdaDpj2LuhQgZyWBrwtdodmniMHA614Zpp52RkQQ8oFjN
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a5b:84a:: with SMTP id v10mr2121594ybq.75.1630530879620;
 Wed, 01 Sep 2021 14:14:39 -0700 (PDT)
Date:   Wed,  1 Sep 2021 21:14:08 +0000
In-Reply-To: <20210901211412.4171835-1-rananta@google.com>
Message-Id: <20210901211412.4171835-9-rananta@google.com>
Mime-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v3 08/12] KVM: arm64: selftests: Add light-weight spinlock support
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a simpler version of spinlock support for ARM64 for
the guests to use.

The implementation is loosely based on the spinlock
implementation in kvm-unit-tests.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  2 +-
 .../selftests/kvm/include/aarch64/spinlock.h  | 13 +++++++++
 .../selftests/kvm/lib/aarch64/spinlock.c      | 27 +++++++++++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/spinlock.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/spinlock.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 5d05801ab816..61f0d376af99 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -35,7 +35,7 @@ endif
 
 LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
 LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
-LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S
+LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c
 LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
 
 TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
diff --git a/tools/testing/selftests/kvm/include/aarch64/spinlock.h b/tools/testing/selftests/kvm/include/aarch64/spinlock.h
new file mode 100644
index 000000000000..cf0984106d14
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/aarch64/spinlock.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef SELFTEST_KVM_ARM64_SPINLOCK_H
+#define SELFTEST_KVM_ARM64_SPINLOCK_H
+
+struct spinlock {
+	int v;
+};
+
+extern void spin_lock(struct spinlock *lock);
+extern void spin_unlock(struct spinlock *lock);
+
+#endif /* SELFTEST_KVM_ARM64_SPINLOCK_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/spinlock.c b/tools/testing/selftests/kvm/lib/aarch64/spinlock.c
new file mode 100644
index 000000000000..6d66a3dac237
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/aarch64/spinlock.c
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ARM64 Spinlock support
+ */
+#include <stdint.h>
+
+#include "spinlock.h"
+
+void spin_lock(struct spinlock *lock)
+{
+	uint32_t val, res;
+
+	asm volatile(
+	"1:	ldaxr	%w0, [%2]\n"
+	"	cbnz	%w0, 1b\n"
+	"	mov	%w0, #1\n"
+	"	stxr	%w1, %w0, [%2]\n"
+	"	cbnz	%w1, 1b\n"
+	: "=&r" (val), "=&r" (res)
+	: "r" (&lock->v)
+	: "memory");
+}
+
+void spin_unlock(struct spinlock *lock)
+{
+	asm volatile("stlr wzr, [%0]\n"	: : "r" (&lock->v) : "memory");
+}
-- 
2.33.0.153.gba50c8fa24-goog

