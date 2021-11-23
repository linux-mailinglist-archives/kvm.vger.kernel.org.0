Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864BC45ADC8
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 22:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbhKWVEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 16:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbhKWVEb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 16:04:31 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFEB0C061574
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 13:01:22 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id a3-20020a92c543000000b0029e6ba13881so220217ilj.11
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 13:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QovEQZReWLCATlIewYReLSWnyKrpm0FAX1JqfLYj0ZU=;
        b=GvxugeqPapYQXmol2OKna0PSxEK0dRKHL03g/3jvj+NM5Zo7aVD2DG0NvLay0HO677
         u37OJrSwS3hYQkPMeG9OPNDK3f5YlepZsarr5VR5FXJ3GzdgcA1WLud2TXRThVIwB3O3
         uFBaAR9z5ybAU8wVwhudaNSob5oTY6HD3FYTLzAkAA2v/HWOLuQIbQ00MfSI5rHIwb4U
         EQj3zNf2Yu9oKJfDoHW9KOcpcgKFoky0D6I8y/cOXeR9TlfzGc8dOAO6BTNHDfvAobT6
         S3wQ5KluJYABG0zyuDuLXmdYh2Zph6J0bzlLmR0vuXQ70MJkP1SXgy8ttvxpcqa7sHwQ
         8IkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QovEQZReWLCATlIewYReLSWnyKrpm0FAX1JqfLYj0ZU=;
        b=WHAsOQX7S7EkNZACFG+fGaeSNZrl631nHwgvuD1bvg1KHFm0cCea1IO/ZrKmCRfZdp
         SnzuDdspRYUd9sKKdVZiMsPGO+gWAyvFsOTNkKUNQqGJOJXO6d/AVdaePNP4jbdQ3NII
         dhkb0RjdbKcyTnux5MO7zbCnuARlTGTqoA0r3xu6BCwy9eJluvCLiMEwdp+Cwxt+bGoN
         ENAI2bMVuNZU+uGpVcGq+IiSeCs9h3cgpsrMlWyb30sZGBWgXtFsP/OrgSghHpXkBaqH
         ImVMYD/QdNox3IBigUtmEQR8aMvQVpEx56sZLtJgOooDPxOx4CMnUGhTDYPxbDRTtsZ/
         dkmA==
X-Gm-Message-State: AOAM530LP+aUjuzd5MWJ3WsTGnLIKSUaTDxrV2QqbYuViZv9dreCnhFN
        3cqL4Iy7tZQngFgVg0QZ/Gb/tt//rgQ=
X-Google-Smtp-Source: ABdhPJwTgu9XjIzS0u9PqlLGX0GOMfjHnkXYfd2F5tiYZIseel2tjBlN9HerYxahKvrn7lMiFo9d0WYzcmE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:ba8b:: with SMTP id g11mr9410034jao.128.1637701282229;
 Tue, 23 Nov 2021 13:01:22 -0800 (PST)
Date:   Tue, 23 Nov 2021 21:01:09 +0000
In-Reply-To: <20211123210109.1605642-1-oupton@google.com>
Message-Id: <20211123210109.1605642-7-oupton@google.com>
Mime-Version: 1.0
References: <20211123210109.1605642-1-oupton@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 6/6] selftests: KVM: Test OS lock behavior
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM now correctly handles the OS Lock for its guests. When set, KVM
blocks all debug exceptions originating from the guest. Add test cases
to the debug-exceptions test to assert that software breakpoint,
hardware breakpoint, watchpoint, and single-step exceptions are in fact
blocked.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 58 ++++++++++++++++++-
 1 file changed, 56 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index ea189d83abf7..63b2178210c4 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -23,7 +23,7 @@
 #define SPSR_D		(1 << 9)
 #define SPSR_SS		(1 << 21)
 
-extern unsigned char sw_bp, hw_bp, bp_svc, bp_brk, hw_wp, ss_start;
+extern unsigned char sw_bp, sw_bp2, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start;
 static volatile uint64_t sw_bp_addr, hw_bp_addr;
 static volatile uint64_t wp_addr, wp_data_addr;
 static volatile uint64_t svc_addr;
@@ -47,6 +47,14 @@ static void reset_debug_state(void)
 	isb();
 }
 
+static void enable_os_lock(void)
+{
+	write_sysreg(1, oslar_el1);
+	isb();
+
+	GUEST_ASSERT(read_sysreg(oslsr_el1) & 2);
+}
+
 static void install_wp(uint64_t addr)
 {
 	uint32_t wcr;
@@ -99,6 +107,7 @@ static void guest_code(void)
 	GUEST_SYNC(0);
 
 	/* Software-breakpoint */
+	reset_debug_state();
 	asm volatile("sw_bp: brk #0");
 	GUEST_ASSERT_EQ(sw_bp_addr, PC(sw_bp));
 
@@ -152,6 +161,51 @@ static void guest_code(void)
 	GUEST_ASSERT_EQ(ss_addr[1], PC(ss_start) + 4);
 	GUEST_ASSERT_EQ(ss_addr[2], PC(ss_start) + 8);
 
+	GUEST_SYNC(6);
+
+	/* OS Lock does not block software-breakpoint */
+	reset_debug_state();
+	enable_os_lock();
+	sw_bp_addr = 0;
+	asm volatile("sw_bp2: brk #0");
+	GUEST_ASSERT_EQ(sw_bp_addr, PC(sw_bp2));
+
+	GUEST_SYNC(7);
+
+	/* OS Lock blocking hardware-breakpoint */
+	reset_debug_state();
+	enable_os_lock();
+	install_hw_bp(PC(hw_bp2));
+	hw_bp_addr = 0;
+	asm volatile("hw_bp2: nop");
+	GUEST_ASSERT_EQ(hw_bp_addr, 0);
+
+	GUEST_SYNC(8);
+
+	/* OS Lock blocking watchpoint */
+	reset_debug_state();
+	enable_os_lock();
+	write_data = '\0';
+	wp_data_addr = 0;
+	install_wp(PC(write_data));
+	write_data = 'x';
+	GUEST_ASSERT_EQ(write_data, 'x');
+	GUEST_ASSERT_EQ(wp_data_addr, 0);
+
+	GUEST_SYNC(9);
+
+	/* OS Lock blocking single-step */
+	reset_debug_state();
+	enable_os_lock();
+	ss_addr[0] = 0;
+	install_ss();
+	ss_idx = 0;
+	asm volatile("mrs x0, esr_el1\n\t"
+		     "add x0, x0, #1\n\t"
+		     "msr daifset, #8\n\t"
+		     : : : "x0");
+	GUEST_ASSERT_EQ(ss_addr[0], 0);
+
 	GUEST_DONE();
 }
 
@@ -223,7 +277,7 @@ int main(int argc, char *argv[])
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_SVC64, guest_svc_handler);
 
-	for (stage = 0; stage < 7; stage++) {
+	for (stage = 0; stage < 11; stage++) {
 		vcpu_run(vm, VCPU_ID);
 
 		switch (get_ucall(vm, VCPU_ID, &uc)) {
-- 
2.34.0.rc2.393.gf8c9666880-goog

