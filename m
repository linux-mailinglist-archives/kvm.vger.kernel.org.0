Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F366056E9
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 07:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiJTFnA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 01:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiJTFm6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 01:42:58 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A604A1B76C6
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 22:42:56 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-36810cfa61fso15237767b3.6
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 22:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qGPUfNXbDXq8tVpmh3iXBlsoXoLe+lb9ybKX9Ouotxs=;
        b=fam3UQuvRDuo6oBP8SRNcDAciBNKVKz4/fFVWts2VwMESRtauKi37VbcrTWOZjxpGX
         y7vkWeI+JuaZLGgSBbADMD95DBSHeTN8COMYJiR/JhGqRr/MXCjI0hjQ40V7f+Rss4+6
         9tW2Q4X356WVRbUSKNmnn/gKdvrjK8u4NayWOu6nxedkz+nOLfQuQw2BoLc7VFHeqUbA
         p7G0sZvOlyDxYS+wuQ34OcckGjJ3znkGxxbKkwsLtQZ3tnuucwKFNOoobWeGXU3bbygt
         w7JZ17Gzdc/dm6BDfZqiCnl+njnMkRCaMoqali1iPAqMPQMdCZsZXDbe7jy8E4gUGxVc
         qkjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qGPUfNXbDXq8tVpmh3iXBlsoXoLe+lb9ybKX9Ouotxs=;
        b=ebswGGH+3CJ5Flya7rEIkh2+SxH0MElsxqErHH1Y8XmlKvQeqZ2ll+VfKdHz2cIS2h
         te105QeosZsis+wOplHMfRItsKXBcyCjyMjnO/fYQPdUmOdX+YkklFL+6JvnEhCNOLFK
         nuo9lgsOZhDOoDoOVp9MolrBgsIHJ6lCiYhg3kkNX/N0YsRnvUFwnzb9RUHlUVg03GJU
         btqsE4BPqlaBUYTJOk+U73rOIHCTv+joSr43qYzWTxykvpHaxL/mOHNLyLJiUcDdr4sz
         h5GDUK9RrKF9F2tLOExZzsrdS+efPBOFdzxB8r9ulcaulGVCFggDc2lFPVQ97xD/s72W
         K3jQ==
X-Gm-Message-State: ACrzQf0fhQjiF1WJXPlAWwpu07zyVMiRLEZqOgEvRHStPEWVdc3Cs3p9
        TTgpqzo0c+xcdnsM4w/XHoPEnOtjk0w=
X-Google-Smtp-Source: AMsMyM75m4E9sVLnRu9y7rmR0yLBR2tNjSIyrcpolvmnOh5DeGKR1WpAeFmXIgNIxR/XfGes3CkkIHTtWDs=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:5f45:0:b0:6c4:46b3:6f6d with SMTP id
 h5-20020a255f45000000b006c446b36f6dmr9081488ybm.62.1666244575457; Wed, 19 Oct
 2022 22:42:55 -0700 (PDT)
Date:   Wed, 19 Oct 2022 22:41:56 -0700
In-Reply-To: <20221020054202.2119018-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221020054202.2119018-1-reijiw@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221020054202.2119018-4-reijiw@google.com>
Subject: [PATCH v2 3/9] KVM: arm64: selftests: Remove the hard-coded {b,w}pn#0
 from debug-exceptions
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

Remove the hard-coded {break,watch}point #0 from the guest_code() in
debug-exceptions to allow {break,watch}point number to be specified.
Change reset_debug_state() to zeroing all dbg{b,w}{c,v}r_el0 registers
so that guest_code() can use the function to reset those registers
even when non-zero {break,watch}points are specified for guest_code().
Subsequent patches will add test cases for non-zero {break,watch}points.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>

---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 50 ++++++++++++-------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index d9884907fe87..608a6c8db9a2 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -95,6 +95,9 @@ GEN_DEBUG_WRITE_REG(dbgwvr)
 
 static void reset_debug_state(void)
 {
+	uint8_t brps, wrps, i;
+	uint64_t dfr0;
+
 	asm volatile("msr daifset, #8");
 
 	write_sysreg(0, osdlr_el1);
@@ -102,11 +105,20 @@ static void reset_debug_state(void)
 	isb();
 
 	write_sysreg(0, mdscr_el1);
-	/* This test only uses the first bp and wp slot. */
-	write_sysreg(0, dbgbvr0_el1);
-	write_sysreg(0, dbgbcr0_el1);
-	write_sysreg(0, dbgwcr0_el1);
-	write_sysreg(0, dbgwvr0_el1);
+
+	/* Reset all bcr/bvr/wcr/wvr registers */
+	dfr0 = read_sysreg(id_aa64dfr0_el1);
+	brps = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_BRPS), dfr0);
+	for (i = 0; i <= brps; i++) {
+		write_dbgbcr(i, 0);
+		write_dbgbvr(i, 0);
+	}
+	wrps = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_WRPS), dfr0);
+	for (i = 0; i <= wrps; i++) {
+		write_dbgwcr(i, 0);
+		write_dbgwvr(i, 0);
+	}
+
 	isb();
 }
 
@@ -118,14 +130,14 @@ static void enable_os_lock(void)
 	GUEST_ASSERT(read_sysreg(oslsr_el1) & 2);
 }
 
-static void install_wp(uint64_t addr)
+static void install_wp(uint8_t wpn, uint64_t addr)
 {
 	uint32_t wcr;
 	uint32_t mdscr;
 
 	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E;
-	write_dbgwcr(0, wcr);
-	write_dbgwvr(0, addr);
+	write_dbgwcr(wpn, wcr);
+	write_dbgwvr(wpn, addr);
 
 	isb();
 
@@ -136,14 +148,14 @@ static void install_wp(uint64_t addr)
 	isb();
 }
 
-static void install_hw_bp(uint64_t addr)
+static void install_hw_bp(uint8_t bpn, uint64_t addr)
 {
 	uint32_t bcr;
 	uint32_t mdscr;
 
 	bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E;
-	write_dbgbcr(0, bcr);
-	write_dbgbvr(0, addr);
+	write_dbgbcr(bpn, bcr);
+	write_dbgbvr(bpn, addr);
 	isb();
 
 	asm volatile("msr daifclr, #8");
@@ -166,7 +178,7 @@ static void install_ss(void)
 
 static volatile char write_data;
 
-static void guest_code(void)
+static void guest_code(uint8_t bpn, uint8_t wpn)
 {
 	GUEST_SYNC(0);
 
@@ -179,7 +191,7 @@ static void guest_code(void)
 
 	/* Hardware-breakpoint */
 	reset_debug_state();
-	install_hw_bp(PC(hw_bp));
+	install_hw_bp(bpn, PC(hw_bp));
 	asm volatile("hw_bp: nop");
 	GUEST_ASSERT_EQ(hw_bp_addr, PC(hw_bp));
 
@@ -187,7 +199,7 @@ static void guest_code(void)
 
 	/* Hardware-breakpoint + svc */
 	reset_debug_state();
-	install_hw_bp(PC(bp_svc));
+	install_hw_bp(bpn, PC(bp_svc));
 	asm volatile("bp_svc: svc #0");
 	GUEST_ASSERT_EQ(hw_bp_addr, PC(bp_svc));
 	GUEST_ASSERT_EQ(svc_addr, PC(bp_svc) + 4);
@@ -196,7 +208,7 @@ static void guest_code(void)
 
 	/* Hardware-breakpoint + software-breakpoint */
 	reset_debug_state();
-	install_hw_bp(PC(bp_brk));
+	install_hw_bp(bpn, PC(bp_brk));
 	asm volatile("bp_brk: brk #0");
 	GUEST_ASSERT_EQ(sw_bp_addr, PC(bp_brk));
 	GUEST_ASSERT_EQ(hw_bp_addr, PC(bp_brk));
@@ -205,7 +217,7 @@ static void guest_code(void)
 
 	/* Watchpoint */
 	reset_debug_state();
-	install_wp(PC(write_data));
+	install_wp(wpn, PC(write_data));
 	write_data = 'x';
 	GUEST_ASSERT_EQ(write_data, 'x');
 	GUEST_ASSERT_EQ(wp_data_addr, PC(write_data));
@@ -239,7 +251,7 @@ static void guest_code(void)
 	/* OS Lock blocking hardware-breakpoint */
 	reset_debug_state();
 	enable_os_lock();
-	install_hw_bp(PC(hw_bp2));
+	install_hw_bp(bpn, PC(hw_bp2));
 	hw_bp_addr = 0;
 	asm volatile("hw_bp2: nop");
 	GUEST_ASSERT_EQ(hw_bp_addr, 0);
@@ -251,7 +263,7 @@ static void guest_code(void)
 	enable_os_lock();
 	write_data = '\0';
 	wp_data_addr = 0;
-	install_wp(PC(write_data));
+	install_wp(wpn, PC(write_data));
 	write_data = 'x';
 	GUEST_ASSERT_EQ(write_data, 'x');
 	GUEST_ASSERT_EQ(wp_data_addr, 0);
@@ -376,6 +388,8 @@ static void test_guest_debug_exceptions(void)
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_SVC64, guest_svc_handler);
 
+	/* Run tests with breakpoint#0 and watchpoint#0. */
+	vcpu_args_set(vcpu, 2, 0, 0);
 	for (stage = 0; stage < 11; stage++) {
 		vcpu_run(vcpu);
 
-- 
2.38.0.413.g74048e4d9e-goog

