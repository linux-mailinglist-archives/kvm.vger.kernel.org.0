Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0AAC40A14F
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 01:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348745AbhIMXMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 19:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349389AbhIMXL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 19:11:56 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649F6C0613F0
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 16:10:24 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 41-20020a17090a0fac00b00195a5a61ab8so923199pjz.3
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 16:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ap1ftYDLPyFEEpyKZVnsUXcIKPkxVpyeCr5WbufecSE=;
        b=ssjNVmoMGdge4aNZpOYbeI0oUi+009PhXeXa75hu1y8lPL3R26TsgLEqfmCeWlIAP8
         fqlq4IDVE0eA+cNmlfa4U3qreR4pIPOykXhz2tGmpoKT8asC5C5mUwCz7wL7LC3GR/i9
         Ze6XeR/ajw0MQuKP8PEb8tr/ETD79PHTz9vBMbwY/7clL4doNqUZ6QiWM2HIw2F6fvsB
         xytM+teq/xTM3uY7Wl7YfdfoelJ8lbE5FVbanCByb8cp+ysRXYQgjtfLyZwjgxag7Q++
         CzLUmImPhE3ltUN5VjHMHreSCdG98OGJMIGSU/jI5pqKxDsXp1RcIyYftA61QxUwq/o+
         nY6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ap1ftYDLPyFEEpyKZVnsUXcIKPkxVpyeCr5WbufecSE=;
        b=ZsOdVXaZQzqFgRFlUx/0rXAJkzhljxjbffw3JmZBRrdQtL6axxaGl8sBeG6kgTN1GN
         2h+CC4Qsz2cLbPlvzql+6McS2dkXt+M6d2FOjf+dUH5NwLam9aJft0DoXYwuyfs1x7ID
         lfYdDehBAit8diVP7MBCzSViE+QgOswdUmhbdhGfXOyEyDkMkxEWuPSelvVFoaAHTLWb
         FfIdaArkRlnD8hTdBoxdaWsv/MZYpW3/Zr7yymQLmjN5x2G8vKkFG/J6UCgQHR3vF31k
         0/7K4mHTiBuNISD7IIRDUshxmD0AELoeldSditrh1DThxPu2KIC64wOf1VezPCWAb1AP
         SjEA==
X-Gm-Message-State: AOAM530LseL2KDKofw0vPrjsCOQwP4NKKhUZjQT71pBpzpy1Y82EcjDL
        uWCm41BPOoLzFC5hBOCMqeJToeTFFChM
X-Google-Smtp-Source: ABdhPJwowof7JmGlLUaojEhUxiCkqJ7/yqMYpKrv4YiqOIEJIo6bF59zD2/Q3LarPrhkAZ8/kj5vKTMAewl3
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:aa7:9626:0:b0:3ff:6d8d:1d25 with SMTP id
 r6-20020aa79626000000b003ff6d8d1d25mr1700676pfg.80.1631574623767; Mon, 13 Sep
 2021 16:10:23 -0700 (PDT)
Date:   Mon, 13 Sep 2021 23:09:51 +0000
In-Reply-To: <20210913230955.156323-1-rananta@google.com>
Message-Id: <20210913230955.156323-11-rananta@google.com>
Mime-Version: 1.0
References: <20210913230955.156323-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v6 10/14] KVM: arm64: selftests: Add light-weight spinlock support
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
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
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
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
index 000000000000..a076e780be5d
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
+	int val, res;
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
2.33.0.309.g3052b89438-goog

