Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D7F6056EC
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 07:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiJTFnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 01:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJTFnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 01:43:24 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170AE19C20B
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 22:43:23 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-360b9418f64so189022677b3.7
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 22:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sqtie0nDjMeT2v2Cqd738nkIEQS32Gq8MxuRjr1xwVc=;
        b=PtyaiWR4WGo4SesPD4NhgOaa8i/QN8S5fPQK2di+xNIZlE93h/OJC7MOpeng7dh/dP
         2S6hIhiV16OlKK4bYhadwIYORTNSEwjTF6GlWdeYK5v8KeGgItAMuUXnOUErgzCXNR7K
         YX/mcwhTneKQfRM/Rz9yKqgqvgjCJSGZMeIUXQPs8ZsAUCb0foNXOLmSwVN7pj5pfemw
         aMEoIZHxbLXPrbWr9F9zj+3dOCexZpmrDWCQJUCKBuljkl5TBbp6u6oej73BlteSsRar
         BytFebUf2GqbMatnT88RXuvvqwUh+W1RlU4PQa/maA3ZDUfAcDR3O47hli6qzCQ/+ho5
         ZDXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sqtie0nDjMeT2v2Cqd738nkIEQS32Gq8MxuRjr1xwVc=;
        b=YUrLxnRUYcHIrXXEogHum/O2sQW2sE2esaAQe7b00wSfbhG/KQWxY5fGj/jWV5Bn3z
         Sz6CAYFi51qHqtlzo6oAp75AiqNJX+sAMOTlcJmkTWYpIQCi7u2eONgBatEdiXMcDW5p
         9cq0uNL1OSlqqbWEH4J0vZIiCvki2j6SrcGXiVb00f4+JIlxcjOeSFNcVf5o+6XHuzzp
         cwVGmPxbtXKFeT2bySwI+eg9NVF4r26aa9n5NASglHwphRUcD1XRNcMuLXDKc9kNPcrw
         DqZWgN3qhpO/prtB9hMwbt/cVOvL9A0CnByRfDUmE1GKWl8oEFUawd/6dBmBGGLhJGJp
         QR9g==
X-Gm-Message-State: ACrzQf1TEM31jhmK1NHPGQy7V2e63fs01N0TCb6YCY0jwghYLHnBD3pr
        FbDyIn7dRXXKSAvyPB+FcHUniTokdQI=
X-Google-Smtp-Source: AMsMyM4Fqo7ndlNYZ4mVtqdSOrn1nGG2kziWEsfTG2Zq//6tftpIR+zQz7Zzf03dgoXXhtbMT8qgEgXk3M0=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:2845:0:b0:6c3:b4c4:9cef with SMTP id
 o66-20020a252845000000b006c3b4c49cefmr9654314ybo.443.1666244602382; Wed, 19
 Oct 2022 22:43:22 -0700 (PDT)
Date:   Wed, 19 Oct 2022 22:41:58 -0700
In-Reply-To: <20221020054202.2119018-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221020054202.2119018-1-reijiw@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221020054202.2119018-6-reijiw@google.com>
Subject: [PATCH v2 5/9] KVM: arm64: selftests: Stop unnecessary test stage
 tracking of debug-exceptions
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, debug-exceptions test unnecessarily tracks some test stages
using GUEST_SYNC().  The code for it needs to be updated as test cases
are added or removed.  Stop doing the unnecessary stage tracking,
as they are not so useful and are a bit pain to maintain.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 46 ++++---------------
 1 file changed, 9 insertions(+), 37 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 0c237022f4d3..040e4d7f8755 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -181,23 +181,17 @@ static volatile char write_data;
 
 static void guest_code(uint8_t bpn, uint8_t wpn)
 {
-	GUEST_SYNC(0);
-
 	/* Software-breakpoint */
 	reset_debug_state();
 	asm volatile("sw_bp: brk #0");
 	GUEST_ASSERT_EQ(sw_bp_addr, PC(sw_bp));
 
-	GUEST_SYNC(1);
-
 	/* Hardware-breakpoint */
 	reset_debug_state();
 	install_hw_bp(bpn, PC(hw_bp));
 	asm volatile("hw_bp: nop");
 	GUEST_ASSERT_EQ(hw_bp_addr, PC(hw_bp));
 
-	GUEST_SYNC(2);
-
 	/* Hardware-breakpoint + svc */
 	reset_debug_state();
 	install_hw_bp(bpn, PC(bp_svc));
@@ -205,8 +199,6 @@ static void guest_code(uint8_t bpn, uint8_t wpn)
 	GUEST_ASSERT_EQ(hw_bp_addr, PC(bp_svc));
 	GUEST_ASSERT_EQ(svc_addr, PC(bp_svc) + 4);
 
-	GUEST_SYNC(3);
-
 	/* Hardware-breakpoint + software-breakpoint */
 	reset_debug_state();
 	install_hw_bp(bpn, PC(bp_brk));
@@ -214,8 +206,6 @@ static void guest_code(uint8_t bpn, uint8_t wpn)
 	GUEST_ASSERT_EQ(sw_bp_addr, PC(bp_brk));
 	GUEST_ASSERT_EQ(hw_bp_addr, PC(bp_brk));
 
-	GUEST_SYNC(4);
-
 	/* Watchpoint */
 	reset_debug_state();
 	install_wp(wpn, PC(write_data));
@@ -223,8 +213,6 @@ static void guest_code(uint8_t bpn, uint8_t wpn)
 	GUEST_ASSERT_EQ(write_data, 'x');
 	GUEST_ASSERT_EQ(wp_data_addr, PC(write_data));
 
-	GUEST_SYNC(5);
-
 	/* Single-step */
 	reset_debug_state();
 	install_ss();
@@ -238,8 +226,6 @@ static void guest_code(uint8_t bpn, uint8_t wpn)
 	GUEST_ASSERT_EQ(ss_addr[1], PC(ss_start) + 4);
 	GUEST_ASSERT_EQ(ss_addr[2], PC(ss_start) + 8);
 
-	GUEST_SYNC(6);
-
 	/* OS Lock does not block software-breakpoint */
 	reset_debug_state();
 	enable_os_lock();
@@ -247,8 +233,6 @@ static void guest_code(uint8_t bpn, uint8_t wpn)
 	asm volatile("sw_bp2: brk #0");
 	GUEST_ASSERT_EQ(sw_bp_addr, PC(sw_bp2));
 
-	GUEST_SYNC(7);
-
 	/* OS Lock blocking hardware-breakpoint */
 	reset_debug_state();
 	enable_os_lock();
@@ -257,8 +241,6 @@ static void guest_code(uint8_t bpn, uint8_t wpn)
 	asm volatile("hw_bp2: nop");
 	GUEST_ASSERT_EQ(hw_bp_addr, 0);
 
-	GUEST_SYNC(8);
-
 	/* OS Lock blocking watchpoint */
 	reset_debug_state();
 	enable_os_lock();
@@ -269,8 +251,6 @@ static void guest_code(uint8_t bpn, uint8_t wpn)
 	GUEST_ASSERT_EQ(write_data, 'x');
 	GUEST_ASSERT_EQ(wp_data_addr, 0);
 
-	GUEST_SYNC(9);
-
 	/* OS Lock blocking single-step */
 	reset_debug_state();
 	enable_os_lock();
@@ -370,7 +350,6 @@ static void test_guest_debug_exceptions(void)
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
-	int stage;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	ucall_init(vm, NULL);
@@ -391,23 +370,16 @@ static void test_guest_debug_exceptions(void)
 
 	/* Run tests with breakpoint#0 and watchpoint#0. */
 	vcpu_args_set(vcpu, 2, 0, 0);
-	for (stage = 0; stage < 11; stage++) {
-		vcpu_run(vcpu);
 
-		switch (get_ucall(vcpu, &uc)) {
-		case UCALL_SYNC:
-			TEST_ASSERT(uc.args[1] == stage,
-				"Stage %d: Unexpected sync ucall, got %lx",
-				stage, (ulong)uc.args[1]);
-			break;
-		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT_2(uc, "values: %#lx, %#lx");
-			break;
-		case UCALL_DONE:
-			goto done;
-		default:
-			TEST_FAIL("Unknown ucall %lu", uc.cmd);
-		}
+	vcpu_run(vcpu);
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT_2(uc, "values: %#lx, %#lx");
+		break;
+	case UCALL_DONE:
+		goto done;
+	default:
+		TEST_FAIL("Unknown ucall %lu", uc.cmd);
 	}
 
 done:
-- 
2.38.0.413.g74048e4d9e-goog

