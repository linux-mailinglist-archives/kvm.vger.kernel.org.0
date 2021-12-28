Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B830D480DE4
	for <lists+kvm@lfdr.de>; Wed, 29 Dec 2021 00:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237782AbhL1XYq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Dec 2021 18:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237774AbhL1XYo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Dec 2021 18:24:44 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAC9C061574
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 15:24:44 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id u37-20020a632365000000b0033b4665d66cso10053468pgm.18
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 15:24:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=CsFax13aN3w5jVa5kYXR5b4+1yckp+HjPm+0ljFIyEI=;
        b=H4oG2FF/36t4k9XmWPcGPeAyYW180NoJyDcnM3ni9w1QBoxA7appMcRo4NhOBTt1Ug
         pniZvQdGUTxueyLsfhx2KH+1RjhFRd6NaPH9dY3nao57O2GxPWSQQrVEBzILTTlnvN79
         4VSEgGqBhwKt6XqZgftQK2NQOLXy3aga9cBAhxvWMG/Vg5v0pqGILrBl/iDGBLP5yZ5i
         uNW+cDCy3GR62yIrN5Rp4LnVuWBmf9wJzK1kDEBBu8LqFA+3TL0UR5Yp6uvcycvslPAQ
         iDLforAd5G1hIWrC0JyG6IJ4vtpnUUp51j9PUpjWOtrd5HKgDzzeveA2oKdKaMmCsPNj
         EBmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=CsFax13aN3w5jVa5kYXR5b4+1yckp+HjPm+0ljFIyEI=;
        b=CmRSX00qajao0yZXbViHlFXLwBgdOWyWKdQThR+dyUKiLRYALZq9RNQH16PbolbjFe
         1UflMLPuVCaw23t0al6HMnAPlW0O7K/H4mp/jeEiOHwj7+SAWr+8vYNcs63bBDeb01Ro
         bI5JNf8nOtA3bKA6Vwma4yQ1xseON5FsjbESZdoFdmU70KbAFL41zOKTfqHXnVkIuvLB
         9oPOnB2AbpXwcVDT/Fgn6llGP0CoF/ZBMiNf76fSzSEgG0L3/A1k/r1Zbg0R+gMOrLa8
         YkVXKX9zuw1iES2Eh2w//ZtNQyWtxjn1PmAHKx1S65Hcye3ktUW9387XdzaMGf+xalgq
         IAxw==
X-Gm-Message-State: AOAM530AEGICkfztoZ0Oxuo828ESJjmYMPBeteM2s2Q94GuiqWmVu2P5
        Q8q5BcaHoxRxQrFbYcju2xPioTe3pRM=
X-Google-Smtp-Source: ABdhPJzq4gwlG4P0/3rRyMeAVdVBSLEJpZIE10ShEk+KtiJ6X9cY3ZaWEWpGvQwGtDdlaPpB/UyCiuv1rmA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:1ca:b0:149:2125:9a13 with SMTP id
 e10-20020a17090301ca00b0014921259a13mr24163900plh.73.1640733884079; Tue, 28
 Dec 2021 15:24:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 28 Dec 2021 23:24:37 +0000
In-Reply-To: <20211228232437.1875318-1-seanjc@google.com>
Message-Id: <20211228232437.1875318-3-seanjc@google.com>
Mime-Version: 1.0
References: <20211228232437.1875318-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH 2/2] KVM: selftests: Add a test to force emulation with a
 pending exception
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+82112403ace4cbd780d8@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a VMX specific test to verify that KVM doesn't explode if userspace
attempts KVM_RUN when emulation is required with a pending exception.
KVM VMX's emulation support for !unrestricted_guest punts exceptions to
userspace instead of attempting to synthesize the exception with all the
correct state (and stack switching, etc...).

Punting is acceptable as there's never been a request to support
injecting exceptions when emulating due to invalid state, but KVM has
historically assumed that userspace will do the right thing and either
clear the exception or kill the guest.  Deliberately do the opposite and
attempt to re-enter the guest with a pending exception and emulation
required to verify KVM continues to punt the combination to userspace,
e.g. doesn't explode, WARN, etc...

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../vmx_exception_with_invalid_guest_state.c  | 139 ++++++++++++++++++
 3 files changed, 141 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 3cb5ac5da087..68bb1e72038a 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -35,6 +35,7 @@
 /x86_64/vmx_apic_access_test
 /x86_64/vmx_close_while_nested_test
 /x86_64/vmx_dirty_log_test
+/x86_64/vmx_exception_with_invalid_guest_state
 /x86_64/vmx_invalid_nested_guest_state
 /x86_64/vmx_preemption_timer_test
 /x86_64/vmx_set_nested_state_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 17342b575e85..af98b0503eff 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -64,6 +64,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/userspace_msr_exit_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_apic_access_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_exception_with_invalid_guest_state
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_invalid_nested_guest_state
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c b/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c
new file mode 100644
index 000000000000..27a850f3d7ce
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c
@@ -0,0 +1,139 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+#include <signal.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/time.h>
+
+#include "kselftest.h"
+
+#define VCPU_ID	0
+
+static struct kvm_vm *vm;
+
+static void guest_ud_handler(struct ex_regs *regs)
+{
+	/* Loop on the ud2 until guest state is made invalid. */
+}
+
+static void guest_code(void)
+{
+	asm volatile("ud2");
+}
+
+static void __run_vcpu_with_invalid_state(void)
+{
+	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+
+	vcpu_run(vm, VCPU_ID);
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_INTERNAL_ERROR,
+		    "Expected KVM_EXIT_INTERNAL_ERROR, got %d (%s)\n",
+		    run->exit_reason, exit_reason_str(run->exit_reason));
+	TEST_ASSERT(run->emulation_failure.suberror == KVM_INTERNAL_ERROR_EMULATION,
+		    "Expected emulation failure, got %d\n",
+		    run->emulation_failure.suberror);
+}
+
+static void run_vcpu_with_invalid_state(void)
+{
+	/*
+	 * Always run twice to verify KVM handles the case where _KVM_ queues
+	 * an exception with invalid state and then exits to userspace, i.e.
+	 * that KVM doesn't explode if userspace ignores the initial error.
+	 */
+	__run_vcpu_with_invalid_state();
+	__run_vcpu_with_invalid_state();
+}
+
+static void set_timer(void)
+{
+	struct itimerval timer;
+
+	timer.it_value.tv_sec  = 0;
+	timer.it_value.tv_usec = 200;
+	timer.it_interval = timer.it_value;
+	ASSERT_EQ(setitimer(ITIMER_REAL, &timer, NULL), 0);
+}
+
+static void set_or_clear_invalid_guest_state(bool set)
+{
+	static struct kvm_sregs sregs;
+
+	if (!sregs.cr0)
+		vcpu_sregs_get(vm, VCPU_ID, &sregs);
+	sregs.tr.unusable = !!set;
+	vcpu_sregs_set(vm, VCPU_ID, &sregs);
+}
+
+static void set_invalid_guest_state(void)
+{
+	set_or_clear_invalid_guest_state(true);
+}
+
+static void clear_invalid_guest_state(void)
+{
+	set_or_clear_invalid_guest_state(false);
+}
+
+static void sigalrm_handler(int sig)
+{
+	struct kvm_vcpu_events events;
+
+	TEST_ASSERT(sig == SIGALRM, "Unexpected signal = %d", sig);
+
+	vcpu_events_get(vm, VCPU_ID, &events);
+
+	/*
+	 * If an exception is pending, attempt KVM_RUN with invalid guest,
+	 * otherwise rearm the timer and keep doing so until the timer fires
+	 * between KVM queueing an exception and re-entering the guest.
+	 */
+	if (events.exception.pending) {
+		set_invalid_guest_state();
+		run_vcpu_with_invalid_state();
+	} else {
+		set_timer();
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	if (!is_intel_cpu() || vm_is_unrestricted_guest(NULL)) {
+		print_skip("Must be run with kvm_intel.unrestricted_guest=0");
+		exit(KSFT_SKIP);
+	}
+
+	vm = vm_create_default(VCPU_ID, 0, (void *)guest_code);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+
+	vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
+
+	/*
+	 * Stuff invalid guest state for L2 by making TR unusuable.  The next
+	 * KVM_RUN should induce a TRIPLE_FAULT in L2 as KVM doesn't support
+	 * emulating invalid guest state for L2.
+	 */
+	set_invalid_guest_state();
+	run_vcpu_with_invalid_state();
+
+	/*
+	 * Verify KVM also handles the case where userspace gains control while
+	 * an exception is pending and stuffs invalid state.  Run with valid
+	 * guest state and a timer firing every 200us, and attempt to enter the
+	 * guest with invalid state when the handler interrupts KVM with an
+	 * exception pending.
+	 */
+	clear_invalid_guest_state();
+	TEST_ASSERT(signal(SIGALRM, sigalrm_handler) != SIG_ERR,
+		    "Failed to register SIGALRM handler, errno = %d (%s)",
+		    errno, strerror(errno));
+
+	set_timer();
+	run_vcpu_with_invalid_state();
+}
-- 
2.34.1.448.ga2b2bfdf31-goog

