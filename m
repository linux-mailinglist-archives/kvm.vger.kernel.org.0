Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699396308D1
	for <lists+kvm@lfdr.de>; Sat, 19 Nov 2022 02:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiKSBxa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 20:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbiKSBwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 20:52:45 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26476C4C12
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 17:34:58 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id g193-20020a636bca000000b00476a2298bd1so3968224pgc.12
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 17:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=e+ywn9anGlzmBRZYQfNE5JqRUvrYYtM9CuRcHhcOat8=;
        b=bUEChsSWxywmbXEODMnhpTArgpDXm8MaKA/SqgTjg5p+/RcYNX7S04/3xpu9J/Qvhd
         4bdagwUbiSdDxnx3tS0KF820eXh2iqkgSCqZDfRbzZHyloQR7cNnkjyTKyEuT6f4pI10
         8tKIXR4fa/bt7sTnMlIgnfjppTnjmh2lzOejjH/eCf9LxOD5caHM7jQPu+J7kwCDF9RB
         ooOOGe2F+sB/yW0Iak7LoRDXFnao07e5dDaQ6BfVTWKYFz8nLtcfxAGPgcnrQw6Wy4Sa
         aeVwQDjy46i3XYIrO35DtjIYTHDet8LPXqZ4MaG6IOPG/C9jabUyQMOrTAnz/MWzY9l1
         R0QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e+ywn9anGlzmBRZYQfNE5JqRUvrYYtM9CuRcHhcOat8=;
        b=qbDlCEr0mElixwFDij1/iCLeFZPmUdbINcNosB5NTfoDptEBuO9EhmVD3snqqbPr8x
         U+BVETpk5NuroMf+lj8Qr/59hCVjakXltH9JpZoNbhLzqWuzeo27xW2BdgUnKPs4JNkP
         OntSzUxgOC4nb1l7JmX1sub7zhUlNuARrBiHpFSTPtGG9i3rgk78fYRBhxYzKkD16c70
         rvG+U/O2/h2aKrNVZdNiry8AIuREoT0hEAj7Zmqqr3+uuwd8J8uZCr6lqelSWwc+p7oT
         n2ykZUILZRf3udrOzpDpkFra9FXj5lpgrXzYNZ0l2ugXFBlgxyUrLPqVJPiev4p+VMvB
         YbEQ==
X-Gm-Message-State: ANoB5pnETh1voK/eT47iGXqybHADLxHThC/8z1WNJOHcUT06G02/zQTT
        JyIuDEWSdN2FXOELPVOsovCHt2XNCYg=
X-Google-Smtp-Source: AA0mqf7PcgvXvqdOghYQniN0zB4c61iyewtOMCoU0bUVvjXFRgEWaXWMy7aEAP06rfFe12MZOAkzfOPPmU4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:bd18:0:b0:562:3aed:e40c with SMTP id
 a24-20020a62bd18000000b005623aede40cmr10612946pff.2.1668821698375; Fri, 18
 Nov 2022 17:34:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 19 Nov 2022 01:34:44 +0000
In-Reply-To: <20221119013450.2643007-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221119013450.2643007-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221119013450.2643007-4-seanjc@google.com>
Subject: [PATCH 3/9] KVM: arm64: selftests: Enable single-step without a
 "full" ucall()
From:   Sean Christopherson <seanjc@google.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
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

Add a new ucall hook, GUEST_UCALL_NONE(), to allow tests to make ucalls
without allocating a ucall struct, and use it to enable single-step
in ARM's debug-exceptions test.  Like the disable single-step path, the
enabling path also needs to ensure that no exclusive access sequences are
attempted after enabling single-step, as the exclusive monitor is cleared
on ERET from the debug exception taken to EL2.

The test currently "works" because clear_bit() isn't actually an atomic
operation... yet.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 21 ++++++++++---------
 .../selftests/kvm/include/ucall_common.h      |  8 +++++++
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index d86c4e4d1c82..c62ec4d7f6a3 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -239,10 +239,6 @@ static void guest_svc_handler(struct ex_regs *regs)
 	svc_addr = regs->pc;
 }
 
-enum single_step_op {
-	SINGLE_STEP_ENABLE = 0,
-};
-
 static void guest_code_ss(int test_cnt)
 {
 	uint64_t i;
@@ -253,8 +249,16 @@ static void guest_code_ss(int test_cnt)
 		w_bvr = i << 2;
 		w_wvr = i << 2;
 
-		/* Enable Single Step execution */
-		GUEST_SYNC(SINGLE_STEP_ENABLE);
+		/*
+		 * Enable Single Step execution.  Note!  This _must_ be a bare
+		 * ucall as the ucall() path uses atomic operations to manage
+		 * the ucall structures, and the built-in "atomics" are usually
+		 * implemented via exclusive access instructions.  The exlusive
+		 * monitor is cleared on ERET, and so taking debug exceptions
+		 * during a LDREX=>STREX sequence will prevent forward progress
+		 * and hang the guest/test.
+		 */
+		GUEST_UCALL_NONE();
 
 		/*
 		 * The userspace will verify that the pc is as expected during
@@ -356,12 +360,9 @@ void test_single_step_from_userspace(int test_cnt)
 				break;
 			}
 
-			TEST_ASSERT(cmd == UCALL_SYNC,
+			TEST_ASSERT(cmd == UCALL_NONE,
 				    "Unexpected ucall cmd 0x%lx", cmd);
 
-			TEST_ASSERT(uc.args[1] == SINGLE_STEP_ENABLE,
-				    "Unexpected ucall action 0x%lx", uc.args[1]);
-
 			debug.control = KVM_GUESTDBG_ENABLE |
 					KVM_GUESTDBG_SINGLESTEP;
 			ss_enable = true;
diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index bdd373189a77..1a6aaef5ccae 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -35,6 +35,14 @@ void ucall(uint64_t cmd, int nargs, ...);
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
 void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
 
+/*
+ * Perform userspace call without any associated data.  This bare call avoids
+ * allocating a ucall struct, which can be useful if the atomic operations in
+ * the full ucall() are problematic and/or unwanted.  Note, this will come out
+ * as UCALL_NONE on the backend.
+ */
+#define GUEST_UCALL_NONE()	ucall_arch_do_ucall((vm_vaddr_t)NULL)
+
 #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
 				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
 #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
-- 
2.38.1.584.g0f3c55d4c2-goog

