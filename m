Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCF8248FF7
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 23:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbgHRVQ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 17:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbgHRVQZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 17:16:25 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFD2C061342
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:25 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id x15so12820672pgx.17
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HrScsnWLiikVbmrdrVpFUjt5CmEvjeWGGXLmlB6OhN8=;
        b=PBPseKbc7ngtWYEi4OAJPFqEBiHUllQQiKRZtnNDN3vuNfOwZ34KBtAv9itM0ZVQY/
         LD1q4Blzz31thY4x9eWqIPJ6zA9zJk4g8YJRicBVnI4LRgVF+Ufyhx9c8fMZa2muvnRf
         fR3/DR4TNrcoFf6Szp1hm4NOR10I5XWwojqt0TWkTL4vImCVD4FVhNvQICIgmtmNeFAX
         ykNef35LEslhzTDGeESuX9Dy4+lNA9WUMK1t5dM9aE4VcCT9nQADWINi1Jzg3Elh9MwH
         HkUa3S26XsVNvQLIL+VbJppaJdIs6VgsGoEgPTQPocYhI6/tZwNAOfacTV9SP50Pwozv
         mw8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HrScsnWLiikVbmrdrVpFUjt5CmEvjeWGGXLmlB6OhN8=;
        b=QQOL+70RA35uROPsfTdJl2Cxp0F8Su97pn1w/LMs/9YqXMGjdoobaChtKvcZhMrcXd
         5/sukEFJ0QD1M4YkckKM8qc2tMUiakMKPlGMesBhVKtigVfpbfeTteDkFeDdnzSsws8t
         J0NPg299ut71yu6bshW8koIQZ0nIRiLJ0TXHrbiIw59UM3GxNZlsdPUBraIETN9lVtxM
         ufWWzQ/AHksHLMMXsc/tapxJsuOVfP0eqVOHcOv75P1mx7LrjJBg/KKr2YtrVEJ809UY
         WnoK80uuuIl2TstiIzvBrFu3KyidUh9X6xEli6x4o9CDHOMGnmdAxWPCRcE03BYIrlqS
         tcLA==
X-Gm-Message-State: AOAM533IzL91qyPOScbGaahP+TQo7n8DpPqJJl7NRg203uiPg08n7WDp
        kLYJOp33UkpCqMYUZXO/lTTJyCjvPx6q5m7u
X-Google-Smtp-Source: ABdhPJwXn1yz+8TYV4wY5VZ3gwv8S8ARbKta8E9R7w5z/iM4gOgPdra1Xqq8vnLoMEamQMI2KH0gg+VFM+H+z+sk
X-Received: by 2002:a62:4e07:: with SMTP id c7mr15956053pfb.10.1597785383235;
 Tue, 18 Aug 2020 14:16:23 -0700 (PDT)
Date:   Tue, 18 Aug 2020 14:15:25 -0700
In-Reply-To: <20200818211533.849501-1-aaronlewis@google.com>
Message-Id: <20200818211533.849501-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20200818211533.849501-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v3 03/12] KVM: selftests: Add test for user space MSR handling
From:   Aaron Lewis <aaronlewis@google.com>
To:     jmattson@google.com, graf@amazon.com
Cc:     pshier@google.com, oupton@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we have the ability to handle MSRs from user space and also to
select which ones we do want to prevent in-kernel KVM code from handling,
let's add a selftest to show case and verify the API.

Signed-off-by: Alexander Graf <graf@amazon.com>

---

v2 -> v3:

  - s/KVM_CAP_ADD_MSR_ALLOWLIST/KVM_CAP_X86_MSR_ALLOWLIST/g
  - Add test to clear whitelist
  - Adjust to reply-less API
  - Fix asserts
  - Actually trap on MSR_IA32_POWER_CTL writes

---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/user_msr_test.c      | 221 ++++++++++++++++++
 2 files changed, 222 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/user_msr_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 4a166588d99f..80d5c348354c 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -55,6 +55,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
 TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
+TEST_GEN_PROGS_x86_64 += x86_64/user_msr_test
 TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/x86_64/user_msr_test.c b/tools/testing/selftests/kvm/x86_64/user_msr_test.c
new file mode 100644
index 000000000000..999544c674be
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/user_msr_test.c
@@ -0,0 +1,221 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * tests for KVM_CAP_X86_USER_SPACE_MSR and KVM_X86_ADD_MSR_ALLOWLIST
+ *
+ * Copyright (C) 2020, Amazon Inc.
+ *
+ * This is a functional test to verify that we can deflect MSR events
+ * into user space.
+ */
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+
+#include "kvm_util.h"
+#include "processor.h"
+
+#define VCPU_ID                  5
+
+u32 msr_reads, msr_writes;
+
+struct range_desc {
+       struct kvm_msr_allowlist allow;
+       void (*populate)(struct kvm_msr_allowlist *range);
+};
+
+static void populate_c0000000_read(struct kvm_msr_allowlist *range)
+{
+       u8 *bitmap = range->bitmap;
+       u32 idx = MSR_SYSCALL_MASK & (KVM_MSR_ALLOWLIST_MAX_LEN - 1);
+
+       bitmap[idx / 8] &= ~(1 << (idx % 8));
+}
+
+static void populate_00000000_write(struct kvm_msr_allowlist *range)
+{
+       u8 *bitmap = range->bitmap;
+       u32 idx = MSR_IA32_POWER_CTL & (KVM_MSR_ALLOWLIST_MAX_LEN - 1);
+
+       bitmap[idx / 8] &= ~(1 << (idx % 8));
+}
+
+struct range_desc ranges[] = {
+       {
+               .allow = {
+                       .flags = KVM_MSR_ALLOW_READ,
+                       .base = 0x00000000,
+                       .nmsrs = KVM_MSR_ALLOWLIST_MAX_LEN * BITS_PER_BYTE,
+               },
+       }, {
+               .allow = {
+                       .flags = KVM_MSR_ALLOW_WRITE,
+                       .base = 0x00000000,
+                       .nmsrs = KVM_MSR_ALLOWLIST_MAX_LEN * BITS_PER_BYTE,
+               },
+               .populate = populate_00000000_write,
+       }, {
+               .allow = {
+                       .flags = KVM_MSR_ALLOW_READ | KVM_MSR_ALLOW_WRITE,
+                       .base = 0x40000000,
+                       .nmsrs = KVM_MSR_ALLOWLIST_MAX_LEN * BITS_PER_BYTE,
+               },
+       }, {
+               .allow = {
+                       .flags = KVM_MSR_ALLOW_READ,
+                       .base = 0xc0000000,
+                       .nmsrs = KVM_MSR_ALLOWLIST_MAX_LEN * BITS_PER_BYTE,
+               },
+               .populate = populate_c0000000_read,
+       }, {
+               .allow = {
+                       .flags = KVM_MSR_ALLOW_WRITE,
+                       .base = 0xc0000000,
+                       .nmsrs = KVM_MSR_ALLOWLIST_MAX_LEN * BITS_PER_BYTE,
+               },
+       },
+};
+
+static void guest_msr_calls(bool trapped)
+{
+       /* This goes into the in-kernel emulation */
+       wrmsr(MSR_SYSCALL_MASK, 0);
+
+       if (trapped) {
+               /* This goes into user space emulation */
+               GUEST_ASSERT(rdmsr(MSR_SYSCALL_MASK) == MSR_SYSCALL_MASK);
+       } else {
+               GUEST_ASSERT(rdmsr(MSR_SYSCALL_MASK) != MSR_SYSCALL_MASK);
+       }
+
+       /* If trapped == true, this goes into user space emulation */
+       wrmsr(MSR_IA32_POWER_CTL, 0x1234);
+
+       /* This goes into the in-kernel emulation */
+       rdmsr(MSR_IA32_POWER_CTL);
+}
+
+static void guest_code(void)
+{
+       guest_msr_calls(true);
+
+       /*
+        * Disable allow listing, so that the kernel
+        * handles everything in the next round
+        */
+       GUEST_SYNC(0);
+
+       guest_msr_calls(false);
+
+       GUEST_DONE();
+}
+
+static int handle_ucall(struct kvm_vm *vm)
+{
+       struct ucall uc;
+
+       switch (get_ucall(vm, VCPU_ID, &uc)) {
+       case UCALL_ABORT:
+               TEST_FAIL("Guest assertion not met");
+               break;
+       case UCALL_SYNC:
+               vm_ioctl(vm, KVM_X86_CLEAR_MSR_ALLOWLIST, NULL);
+               break;
+       case UCALL_DONE:
+               return 1;
+       default:
+               TEST_FAIL("Unknown ucall %lu", uc.cmd);
+       }
+
+       return 0;
+}
+
+static void handle_rdmsr(struct kvm_run *run)
+{
+       run->msr.data = run->msr.index;
+       msr_reads++;
+}
+
+static void handle_wrmsr(struct kvm_run *run)
+{
+       /* ignore */
+       msr_writes++;
+}
+
+int main(int argc, char *argv[])
+{
+       struct kvm_enable_cap cap = {
+               .cap = KVM_CAP_X86_USER_SPACE_MSR,
+               .args[0] = 1,
+       };
+       struct kvm_vm *vm;
+       struct kvm_run *run;
+       int rc;
+       int i;
+
+       /* Tell stdout not to buffer its content */
+       setbuf(stdout, NULL);
+
+       /* Create VM */
+       vm = vm_create_default(VCPU_ID, 0, guest_code);
+       vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+       run = vcpu_state(vm, VCPU_ID);
+
+       rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
+       TEST_ASSERT(rc, "KVM_CAP_X86_USER_SPACE_MSR is available");
+       vm_enable_cap(vm, &cap);
+
+       rc = kvm_check_cap(KVM_CAP_X86_MSR_ALLOWLIST);
+       TEST_ASSERT(rc, "KVM_CAP_X86_MSR_ALLOWLIST is available");
+
+       /* Set up MSR allowlist */
+       for (i = 0; i < ARRAY_SIZE(ranges); i++) {
+               struct kvm_msr_allowlist *a = &ranges[i].allow;
+               u32 bitmap_size = a->nmsrs / BITS_PER_BYTE;
+               struct kvm_msr_allowlist *range = malloc(sizeof(*a) + bitmap_size);
+
+               TEST_ASSERT(range, "range alloc failed (%ld bytes)\n", sizeof(*a) + bitmap_size);
+
+               *range = *a;
+
+               /* Allow everything by default */
+               memset(range->bitmap, 0xff, bitmap_size);
+
+               if (ranges[i].populate)
+                       ranges[i].populate(range);
+
+               vm_ioctl(vm, KVM_X86_ADD_MSR_ALLOWLIST, range);
+       }
+
+       while (1) {
+               rc = _vcpu_run(vm, VCPU_ID);
+
+               TEST_ASSERT(rc == 0, "vcpu_run failed: %d\n", rc);
+
+               switch (run->exit_reason) {
+               case KVM_EXIT_X86_RDMSR:
+                       handle_rdmsr(run);
+                       break;
+               case KVM_EXIT_X86_WRMSR:
+                       handle_wrmsr(run);
+                       break;
+               case KVM_EXIT_IO:
+                       if (handle_ucall(vm))
+                               goto done;
+                       break;
+               }
+
+       }
+
+done:
+       TEST_ASSERT(msr_reads == 1, "Handled 1 rdmsr in user space");
+       TEST_ASSERT(msr_writes == 1, "Handled 1 wrmsr in user space");
+
+       kvm_vm_free(vm);
+
+       return 0;
+}
-- 
2.28.0.220.ged08abb693-goog

