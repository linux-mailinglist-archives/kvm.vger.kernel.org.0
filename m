Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7743F0B35
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 20:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbhHRSoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 14:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233143AbhHRSoL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 14:44:11 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9155CC061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 11:43:35 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j21-20020a25d2150000b029057ac4b4e78fso3846283ybg.4
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 11:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wYh8smn48aXYYcSZU2IfL26LMTAImxlTzaqpMoQB+vI=;
        b=kzUtgAJSv2qNhZclEaU8FzKPyTqyxNgL+/U6RRB7b/NCQvhO63nxSBfOCqe12j8twA
         V8F00bR+TZr69FrMgpIK4CoQ8ff3s8YPi1NA8tAGh3pWBM06lyx8YqVDHz2q92fvYh5N
         y6wv2XfKViL8d/TWDzK/8sFitI87sqi/58D1pYUD28q6+DTljmvediyoPFKtwWW8RKjm
         3pzeW/ksT/t5d7qHd4TPWHzFcTbuM7GglokZagJpfoL31QtWyWrNWJjaVzbJkJvr1bYZ
         +HxHwmee1VbX2GCtDvvr/xClS/kuLfWemGLXjahHSybYUj//STJlfyTym+shoKWSdV6G
         jsxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wYh8smn48aXYYcSZU2IfL26LMTAImxlTzaqpMoQB+vI=;
        b=URKFglaCwWfmeEs+CdUGQb4GH1QoT5aJtfhT18ahVQ2CfILXunv+2tDDFjevIHVEVd
         VP4R+xnc8IDQjBpB3SimSjwUDHKsPWyo97OmcX8TOAenPod3SBgCeY5IKW8TCZo+NOz6
         P0iSCe0NlWw/NfyWvpKy/m//r8FMvrcfUz/KPQmeJD0HoT5ooq/GwHZ2I4hrXWYr0wFW
         Axq+KRZptijc+taLsUaXkfrfuRtc2kond9hBEXxUkboQMPwk83WnQDvQIgl7FZi3gxMm
         7AlksJVnX4lNEB9ISbFlcwcQNtD8WqjHcFNZvaTfPtyh980fDqtyZeh+SWMGefUKF1L8
         Z8SA==
X-Gm-Message-State: AOAM532ctaBDgEs9rIO73FVG8BRVBvG5gD53H7wiROzX+s5hIO06ldWt
        0KMwGM0PBAL/ffpbA5htCv/p856BF+3k
X-Google-Smtp-Source: ABdhPJxOmEaD7HVk4G/6lY+hgeTQktgQhg/NyAhOupYESQ8XGpcFBIq2fwUiPCq1kOf6U13VsKLCyVSfEXxd
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:4216:: with SMTP id
 p22mr12570656yba.397.1629312214825; Wed, 18 Aug 2021 11:43:34 -0700 (PDT)
Date:   Wed, 18 Aug 2021 18:43:09 +0000
In-Reply-To: <20210818184311.517295-1-rananta@google.com>
Message-Id: <20210818184311.517295-9-rananta@google.com>
Mime-Version: 1.0
References: <20210818184311.517295-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 08/10] KVM: arm64: selftests: Add light-weight spinlock support
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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
index 5832f510a16c..8f6d82b570bd 100644
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
2.33.0.rc1.237.g0d66db33f3-goog

