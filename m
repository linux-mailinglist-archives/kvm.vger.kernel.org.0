Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D03031E376
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 01:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhBRAXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 19:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbhBRAXE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 19:23:04 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F28BC061788
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 16:22:24 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 6so630694ybq.7
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 16:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=rxD7Cfx1GqsmSmL2P7darQKc+AFaLsyrpkiIH6lHspA=;
        b=LQNnOingSAg+AL3Sigaum//AnfCSGXUZGSCViO/WKWbJaEQn1/FXZOJYAqX8K0PAIa
         XqnluSAId3sOouUwP/Kc/Zve4M7SZaVkLH5TCyni4pK9FGGKx9Lj8D/IiPZEf9ryiNWA
         Qdb7K0LEFBm4j9C6L1zBtyBwxpWqSEz0QbQqvdccmxE6y5J/kNs3rvLl4B65/jMzprkY
         VzGTzIDV9iSJySz34f4oWk+XDV0A88Mjy+9yeUDlNMSszosFaGkWZ6UFWc/gX+LX7F8N
         OBs4uANZHqMp5p6I5OA1LKQymV+BECdyC4zqkm26OfT5XrJaD04WVsKtCjmywkYjvyrr
         o5aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=rxD7Cfx1GqsmSmL2P7darQKc+AFaLsyrpkiIH6lHspA=;
        b=XqMpJs/0IopmNo4H/fHMcCld6P25dIb2/CU4WS7rq61XAZbh3Q1OgDQ1Yz35rjnPCy
         jzg6KWo3VvBlhj5cX26rwhSzVx2YHQRgbiz941tk6MeCPzK9PFeOT5tKJk0WEuPR9QIt
         5s0tgVTHbd9ipZkR1A7OJgPMuKD6Q8RE8S1LIqQ+HSocKAsG61Dad/nuvMS8F0bCdIg7
         pitITh8HNfu4mxUdUm06AuiklTyp2/08n5Fn8nGRn55IA2VGuQpsaX/OXKEZ85QfNfXY
         yKfXS7NbqeZt2pb9K+0IllPc/B4PHBpuahfiwEE27UYZ84rq73zZEDv5lmC4lkP4LFRI
         Ky6g==
X-Gm-Message-State: AOAM531+dWZ4kATHwTp4Ob/xZfGY2kGyF3RcKEx+WIUh2wZ6y0hB47lR
        Dm1FZlq+aRh5uIWFzuBDYAFYvpcBthA=
X-Google-Smtp-Source: ABdhPJzb7URA3rw3seV6AMppbxWPBjCEcaCUGtBdb1JkdC5tXnIBWrqtEy/1i2a9S2ora8/iDrCPZ4v/LvE=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:dc76:757f:9e9e:647c])
 (user=seanjc job=sendgmr) by 2002:a25:abce:: with SMTP id v72mr3310906ybi.152.1613607743713;
 Wed, 17 Feb 2021 16:22:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 17 Feb 2021 16:22:09 -0800
In-Reply-To: <20210218002212.2904647-1-seanjc@google.com>
Message-Id: <20210218002212.2904647-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210218002212.2904647-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [kvm-unit-tests PATCH 3/6] x86: nVMX: Improve report messages for
 segment selector tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tweak the segment selector tests to clarify if they are testing a valid
versus invalid condition, display the actual condition, and stringify
the name of the field instead of copy-pasting the field name into a
string.

Opportunistically wrap the complex macro in a do-while.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 57 ++++++++++++++++++++++---------------------------
 1 file changed, 26 insertions(+), 31 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 35463b6..4ea2624 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7985,10 +7985,19 @@ static void test_load_guest_bndcfgs(void)
 
 #define	GUEST_SEG_UNUSABLE_MASK	(1u << 16)
 #define	GUEST_SEG_SEL_TI_MASK	(1u << 2)
-#define	TEST_SEGMENT_SEL(xfail, sel, sel_name, val)			\
+
+
+#define	TEST_SEGMENT_SEL(test, xfail, sel, val)				\
+do {									\
 	vmcs_write(sel, val);						\
-	test_guest_state("Test Guest Segment Selector",	xfail, val,	\
-			 sel_name);
+	test_guest_state(test " segment", xfail, val, xstr(sel));	\
+} while (0)
+
+#define	TEST_INVALID_SEG_SEL(sel, val) \
+	TEST_SEGMENT_SEL("Invalid: " xstr(val), true, sel, val);
+
+#define	TEST_VALID_SEG_SEL(sel, val) \
+	TEST_SEGMENT_SEL("Valid: " xstr(val), false, sel, val);
 
 /*
  * The following checks are done on the Selector field of the Guest Segment
@@ -8013,8 +8022,7 @@ static void test_guest_segment_sel_fields(void)
 	 * Test for GUEST_SEL_TR
 	 */
 	sel_saved = vmcs_read(GUEST_SEL_TR);
-	TEST_SEGMENT_SEL(true, GUEST_SEL_TR, "GUEST_SEL_TR",
-			 sel_saved | GUEST_SEG_SEL_TI_MASK);
+	TEST_INVALID_SEG_SEL(GUEST_SEL_TR, sel_saved | GUEST_SEG_SEL_TI_MASK);
 	vmcs_write(GUEST_SEL_TR, sel_saved);
 
 	/*
@@ -8024,17 +8032,13 @@ static void test_guest_segment_sel_fields(void)
 	ar_saved = vmcs_read(GUEST_AR_LDTR);
 	/* LDTR is set unusable */
 	vmcs_write(GUEST_AR_LDTR, ar_saved | GUEST_SEG_UNUSABLE_MASK);
-	TEST_SEGMENT_SEL(false, GUEST_SEL_LDTR, "GUEST_SEL_LDTR",
-			 sel_saved | GUEST_SEG_SEL_TI_MASK);
-	TEST_SEGMENT_SEL(false, GUEST_SEL_LDTR, "GUEST_SEL_LDTR",
-			 sel_saved & ~GUEST_SEG_SEL_TI_MASK);
+	TEST_VALID_SEG_SEL(GUEST_SEL_LDTR, sel_saved | GUEST_SEG_SEL_TI_MASK);
+	TEST_VALID_SEG_SEL(GUEST_SEL_LDTR, sel_saved & ~GUEST_SEG_SEL_TI_MASK);
 	/* LDTR is set usable */
 	vmcs_write(GUEST_AR_LDTR, ar_saved & ~GUEST_SEG_UNUSABLE_MASK);
-	TEST_SEGMENT_SEL(true, GUEST_SEL_LDTR, "GUEST_SEL_LDTR",
-			 sel_saved | GUEST_SEG_SEL_TI_MASK);
+	TEST_INVALID_SEG_SEL(GUEST_SEL_LDTR, sel_saved | GUEST_SEG_SEL_TI_MASK);
 
-	TEST_SEGMENT_SEL(false, GUEST_SEL_LDTR, "GUEST_SEL_LDTR",
-			 sel_saved & ~GUEST_SEG_SEL_TI_MASK);
+	TEST_VALID_SEG_SEL(GUEST_SEL_LDTR, sel_saved & ~GUEST_SEG_SEL_TI_MASK);
 
 	vmcs_write(GUEST_AR_LDTR, ar_saved);
 	vmcs_write(GUEST_SEL_LDTR, sel_saved);
@@ -8049,39 +8053,30 @@ static void test_guest_segment_sel_fields(void)
 	vmcs_write(CPU_EXEC_CTRL1, cpu_ctrl1_saved & ~CPU_URG);
 	cs_rpl_bits = vmcs_read(GUEST_SEL_CS) & 0x3;
 	sel_saved = vmcs_read(GUEST_SEL_SS);
-	TEST_SEGMENT_SEL(true, GUEST_SEL_SS, "GUEST_SEL_SS",
-				 ((sel_saved & ~0x3) | (~cs_rpl_bits & 0x3)));
-	TEST_SEGMENT_SEL(false, GUEST_SEL_SS, "GUEST_SEL_SS",
-				 ((sel_saved & ~0x3) | (cs_rpl_bits & 0x3)));
+	TEST_INVALID_SEG_SEL(GUEST_SEL_SS, ((sel_saved & ~0x3) | (~cs_rpl_bits & 0x3)));
+	TEST_VALID_SEG_SEL(GUEST_SEL_SS, ((sel_saved & ~0x3) | (cs_rpl_bits & 0x3)));
 	/* Make SS usable if it's unusable or vice-versa */
 	if (ar_saved & GUEST_SEG_UNUSABLE_MASK)
 		vmcs_write(GUEST_AR_SS, ar_saved & ~GUEST_SEG_UNUSABLE_MASK);
 	else
 		vmcs_write(GUEST_AR_SS, ar_saved | GUEST_SEG_UNUSABLE_MASK);
-	TEST_SEGMENT_SEL(true, GUEST_SEL_SS, "GUEST_SEL_SS",
-				 ((sel_saved & ~0x3) | (~cs_rpl_bits & 0x3)));
-	TEST_SEGMENT_SEL(false, GUEST_SEL_SS, "GUEST_SEL_SS",
-				 ((sel_saved & ~0x3) | (cs_rpl_bits & 0x3)));
-	vmcs_write(CPU_EXEC_CTRL0, cpu_ctrl0_saved);
-	vmcs_write(CPU_EXEC_CTRL1, cpu_ctrl1_saved);
+	TEST_INVALID_SEG_SEL(GUEST_SEL_SS, ((sel_saved & ~0x3) | (~cs_rpl_bits & 0x3)));
+	TEST_VALID_SEG_SEL(GUEST_SEL_SS, ((sel_saved & ~0x3) | (cs_rpl_bits & 0x3)));
 
 	/* Need a valid EPTP as the passing case fully enters the guest. */
 	if (enable_unrestricted_guest(true))
 		goto skip_ss_tests;
 
-	TEST_SEGMENT_SEL(false, GUEST_SEL_SS, "GUEST_SEL_SS",
-				 ((sel_saved & ~0x3) | (~cs_rpl_bits & 0x3)));
-	TEST_SEGMENT_SEL(false, GUEST_SEL_SS, "GUEST_SEL_SS",
-				 ((sel_saved & ~0x3) | (cs_rpl_bits & 0x3)));
+	TEST_VALID_SEG_SEL(GUEST_SEL_SS, ((sel_saved & ~0x3) | (~cs_rpl_bits & 0x3)));
+	TEST_VALID_SEG_SEL(GUEST_SEL_SS, ((sel_saved & ~0x3) | (cs_rpl_bits & 0x3)));
+
 	/* Make SS usable if it's unusable or vice-versa */
 	if (vmcs_read(GUEST_AR_SS) & GUEST_SEG_UNUSABLE_MASK)
 		vmcs_write(GUEST_AR_SS, ar_saved & ~GUEST_SEG_UNUSABLE_MASK);
 	else
 		vmcs_write(GUEST_AR_SS, ar_saved | GUEST_SEG_UNUSABLE_MASK);
-	TEST_SEGMENT_SEL(false, GUEST_SEL_SS, "GUEST_SEL_SS",
-				 ((sel_saved & ~0x3) | (~cs_rpl_bits & 0x3)));
-	TEST_SEGMENT_SEL(false, GUEST_SEL_SS, "GUEST_SEL_SS",
-				 ((sel_saved & ~0x3) | (cs_rpl_bits & 0x3)));
+	TEST_VALID_SEG_SEL(GUEST_SEL_SS, ((sel_saved & ~0x3) | (~cs_rpl_bits & 0x3)));
+	TEST_VALID_SEG_SEL(GUEST_SEL_SS, ((sel_saved & ~0x3) | (cs_rpl_bits & 0x3)));
 skip_ss_tests:
 
 	vmcs_write(GUEST_AR_SS, ar_saved);
-- 
2.30.0.478.g8a0d178c01-goog

