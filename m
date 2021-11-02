Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4BC442AAF
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 10:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhKBJtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 05:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbhKBJtk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 05:49:40 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E36C061764
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 02:47:06 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id h14-20020a056e021d8e00b002691dcecdbaso4200513ila.23
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 02:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=USRcUlx130z7l5DHjEbTqn2FW1uy9zzoAmm3OXXaQBk=;
        b=PQLfk3CFu1uKl92twaW6wnU35UbAHgLOFn7zYoU4COpmRQifsFd/zeIm5FCi0v4o0x
         /v+0h1A/ULEUdztocwTSe0oiqESiYPZ/hpeXLA64lpfwIpqqp3XUJM4CuRE952oFQWKu
         fLsSf++kgTReC9IHoLJuRBY8v8C14jwONDDLb5Mrm+gyaSe1TgfI6eHqcwEEOTofSHTN
         wS8Q0W7bHGRZ1baATKX5JSPRjxdR+oHD9mhS6xgGZ/jA4t+A0uFxy4S4x4p3lceEFZuM
         UJ1ALejVWJAhv1+rtYQZldacua675hfSzOOsdxq9odNYyfkD74lpUoSqCivx93Z0wd+e
         JySg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=USRcUlx130z7l5DHjEbTqn2FW1uy9zzoAmm3OXXaQBk=;
        b=whewEHRC7iezsPb3Saq9zHO2jDK/p1GkmRVYkwHlC2uFmOCSXGmtiMfXUhGMGPw9Gb
         thgFUDJMUYsScrDc3hyTR59kp2Xf8JFcnB8R2JgBCHypD2H+9bESRW3M/5PpXjKahQOt
         pobuVDx0WkGqyUaUqLRAMrImDf2GR0rOhdvpO/pKUNdPEwckyKBwrEXOdmuKAOWTnV6s
         ReZTPLTQl6JB8QHFx754LoyFVLqIpZqruz8L9gSTrpX4DtMfSZz2tYD77384ENXZ8sxn
         +aLWq/TgKc4YcCpPJrxuBO7edvwJA+Re/nnf0NGbqvT+FryIGc+fSoNUYRyjxl1KEIPs
         y6NA==
X-Gm-Message-State: AOAM530PzHedF9LAy/HkcGeDxS3haoEoNtRaGhWDE7IqUQZNSpWLYonZ
        zQzkJAra/4kbRsjH/Buzg5ftmJM2ZPM=
X-Google-Smtp-Source: ABdhPJy6wt5RMowO8zj/XK0tDxqF5oCDvoTx8hC/w3ofvmgfuVtqYfu0icCviFdBDTxdv6AyYpCRfHOVcWc=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:1502:: with SMTP id
 b2mr27109379jat.131.1635846425861; Tue, 02 Nov 2021 02:47:05 -0700 (PDT)
Date:   Tue,  2 Nov 2021 09:46:51 +0000
In-Reply-To: <20211102094651.2071532-1-oupton@google.com>
Message-Id: <20211102094651.2071532-7-oupton@google.com>
Mime-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v2 6/6] selftests: KVM: Test OS lock behavior
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
index e5e6c92b60da..6b6ff81cdd23 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -23,7 +23,7 @@
 #define SPSR_D		(1 << 9)
 #define SPSR_SS		(1 << 21)
 
-extern unsigned char sw_bp, hw_bp, bp_svc, bp_brk, hw_wp, ss_start;
+extern unsigned char sw_bp, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start;
 static volatile uint64_t sw_bp_addr, hw_bp_addr;
 static volatile uint64_t wp_addr, wp_data_addr;
 static volatile uint64_t svc_addr;
@@ -47,6 +47,14 @@ static void reset_debug_state(void)
 	isb();
 }
 
+static void enable_os_lock(void)
+{
+	write_sysreg(oslar_el1, 1);
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
+	/* OS Lock blocking software-breakpoint */
+	reset_debug_state();
+	enable_os_lock();
+	sw_bp_addr = 0;
+	asm volatile("brk #0");
+	GUEST_ASSERT_EQ(sw_bp_addr, 0);
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
2.33.1.1089.g2158813163f-goog

