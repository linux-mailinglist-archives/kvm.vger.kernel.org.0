Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1E731E377
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 01:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhBRAXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 19:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhBRAXK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 19:23:10 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE60DC06178A
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 16:22:26 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id v6so623024ybk.9
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 16:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=N5u+tYaA6jheO+s3TAYApGNDG7kt8AjvjeXnlM3gIWM=;
        b=qtyX3O2CMgZmUaDOiNhk1mGOb/MPylrnIyF/boq3B2Pd16GZPOhcUM8QnfEnCLdkLH
         M0kAuC1OWSHLd9chonD8xejblgRPETL2oHTXAwZKi9GqJOIZLndSPyQIS7gaJHdifTqc
         NLtt5sQa+OiRGVuDq01d3k68F9TtTL7uisHmM5m30CniTjp2/MGKqTLfXq4PdYAwrLLT
         hVdondAKS0BZYnSKjX7imuqYdPqtWSSRG7Jz4qy1bRagGBQuicU7h64+Vb8VaVh48Jlo
         v5vguKwyGCGa1LP6StdnxEG5bMVGG7nNwanQMtMAX3NqqXvGNsY6UaXivutc9BHceEGN
         v3Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=N5u+tYaA6jheO+s3TAYApGNDG7kt8AjvjeXnlM3gIWM=;
        b=H9Q0fsf12S+1zvcBk1Y9vD4/6IzshXayGWSd4CIKZTNOUpt6x4daKj0J2r7C4PASqz
         pLQXWndX32cKHyoLUrpvz//hAa4HKCjz45bdVfIEF+u1z7VBmOMQzrkbx3X/tk1HfKLV
         1o9WqTMrf2YEjCqBfvDuBaQZhtbR5tcls0Eot//A7WKdR1bLIbfAfSJL5+1BQ0J1GDaT
         ygLToM1YHdeAU6EiJcvh+oeqNYyVijuF1OZdXxMXJrbAByvVkKDRu0nYUcQVqAz1UDjq
         Vy4VBqS+JkChdQ97DQfLvyLbvF2+htpyhFkDvWCgnbaSQ28ZczRVBciBynAuPg6/jKSF
         wU/Q==
X-Gm-Message-State: AOAM533P4yyPzRTrF/PCbuMMhHZ7Q9784UduQgjmq532j+tDDQpkldRk
        FRzMS7mBxdGwsPA74pJxhE2cM6s66qM=
X-Google-Smtp-Source: ABdhPJz/aoTxw95aEuVUHG09L+tENFh2lidZIeh4/kTigJZPsy/SgMR8unS42hU020VTwA92qZ4J4pMxKKY=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:dc76:757f:9e9e:647c])
 (user=seanjc job=sendgmr) by 2002:a25:1fc5:: with SMTP id f188mr2904496ybf.389.1613607746050;
 Wed, 17 Feb 2021 16:22:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 17 Feb 2021 16:22:10 -0800
In-Reply-To: <20210218002212.2904647-1-seanjc@google.com>
Message-Id: <20210218002212.2904647-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210218002212.2904647-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [kvm-unit-tests PATCH 4/6] x86: nVMX: Improve report messages for
 segment base tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tweak the segment base tests to state exactly what's being tested, note
whether or not the segment is usable, and stringify the name of the field
instead of copy-pasting the field name into a string.

Opportunistically wrap the complex macros in do-while.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 67 +++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 36 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 4ea2624..94ab499 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8085,22 +8085,26 @@ skip_ss_tests:
 	vmcs_write(CPU_EXEC_CTRL1, cpu_ctrl1_saved);
 }
 
-#define	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(xfail, seg_base, seg_base_name)\
-	addr_saved = vmcs_read(seg_base);				\
-	for (i = 32; i < 63; i = i + 4) {				\
-		addr = addr_saved | 1ull << i;				\
-		vmcs_write(seg_base, addr);				\
-		test_guest_state(seg_base_name,	xfail, addr,		\
-				seg_base_name);				\
-	}								\
-	vmcs_write(seg_base, addr_saved);
+#define	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(xfail, seg_base)			\
+do {										\
+	addr_saved = vmcs_read(seg_base);					\
+	for (i = 32; i < 63; i = i + 4) {					\
+		addr = addr_saved | 1ull << i;					\
+		vmcs_write(seg_base, addr);					\
+		test_guest_state("seg.BASE[63:32] != 0, usable = " xstr(xfail),	\
+				 xfail, addr, xstr(seg_base));			\
+	}									\
+	vmcs_write(seg_base, addr_saved);					\
+} while (0)
 
-#define	TEST_SEGMENT_BASE_ADDR_CANONICAL(xfail, seg_base, seg_base_name)\
-	addr_saved = vmcs_read(seg_base);				\
-	vmcs_write(seg_base, NONCANONICAL);				\
-	test_guest_state(seg_base_name,	xfail, NONCANONICAL,		\
-			seg_base_name);					\
-	vmcs_write(seg_base, addr_saved);
+#define	TEST_SEGMENT_BASE_ADDR_CANONICAL(xfail, seg_base)		  \
+do {									  \
+	addr_saved = vmcs_read(seg_base);				  \
+	vmcs_write(seg_base, NONCANONICAL);				  \
+	test_guest_state("seg.BASE non-canonical, usable = " xstr(xfail), \
+			 xfail, NONCANONICAL, xstr(seg_base));		  \
+	vmcs_write(seg_base, addr_saved);				  \
+} while (0)
 
 /*
  * The following checks are done on the Base Address field of the Guest
@@ -8123,57 +8127,48 @@ static void test_guest_segment_base_addr_fields(void)
 	/*
 	 * The address of TR, FS, GS and LDTR must be canonical.
 	 */
-	TEST_SEGMENT_BASE_ADDR_CANONICAL(true, GUEST_BASE_TR, "GUEST_BASE_TR");
-	TEST_SEGMENT_BASE_ADDR_CANONICAL(true, GUEST_BASE_FS, "GUEST_BASE_FS");
-	TEST_SEGMENT_BASE_ADDR_CANONICAL(true, GUEST_BASE_GS, "GUEST_BASE_GS");
+	TEST_SEGMENT_BASE_ADDR_CANONICAL(true, GUEST_BASE_TR);
+	TEST_SEGMENT_BASE_ADDR_CANONICAL(true, GUEST_BASE_FS);
+	TEST_SEGMENT_BASE_ADDR_CANONICAL(true, GUEST_BASE_GS);
 	ar_saved = vmcs_read(GUEST_AR_LDTR);
 	/* Make LDTR unusable */
 	vmcs_write(GUEST_AR_LDTR, ar_saved | GUEST_SEG_UNUSABLE_MASK);
-	TEST_SEGMENT_BASE_ADDR_CANONICAL(false, GUEST_BASE_LDTR,
-					"GUEST_BASE_LDTR");
+	TEST_SEGMENT_BASE_ADDR_CANONICAL(false, GUEST_BASE_LDTR);
 	/* Make LDTR usable */
 	vmcs_write(GUEST_AR_LDTR, ar_saved & ~GUEST_SEG_UNUSABLE_MASK);
-	TEST_SEGMENT_BASE_ADDR_CANONICAL(true, GUEST_BASE_LDTR,
-					"GUEST_BASE_LDTR");
+	TEST_SEGMENT_BASE_ADDR_CANONICAL(true, GUEST_BASE_LDTR);
 
 	vmcs_write(GUEST_AR_LDTR, ar_saved);
 
 	/*
 	 * Bits 63:32 in CS, SS, DS and ES base address must be zero
 	 */
-	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(true, GUEST_BASE_CS,
-					 "GUEST_BASE_CS");
+	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(true, GUEST_BASE_CS);
 	ar_saved = vmcs_read(GUEST_AR_SS);
 	/* Make SS unusable */
 	vmcs_write(GUEST_AR_SS, ar_saved | GUEST_SEG_UNUSABLE_MASK);
-	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(false, GUEST_BASE_SS,
-					 "GUEST_BASE_SS");
+	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(false, GUEST_BASE_SS);
 	/* Make SS usable */
 	vmcs_write(GUEST_AR_SS, ar_saved & ~GUEST_SEG_UNUSABLE_MASK);
-	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(true, GUEST_BASE_SS,
-					 "GUEST_BASE_SS");
+	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(true, GUEST_BASE_SS);
 	vmcs_write(GUEST_AR_SS, ar_saved);
 
 	ar_saved = vmcs_read(GUEST_AR_DS);
 	/* Make DS unusable */
 	vmcs_write(GUEST_AR_DS, ar_saved | GUEST_SEG_UNUSABLE_MASK);
-	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(false, GUEST_BASE_DS,
-					 "GUEST_BASE_DS");
+	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(false, GUEST_BASE_DS);
 	/* Make DS usable */
 	vmcs_write(GUEST_AR_DS, ar_saved & ~GUEST_SEG_UNUSABLE_MASK);
-	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(true, GUEST_BASE_DS,
-					 "GUEST_BASE_DS");
+	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(true, GUEST_BASE_DS);
 	vmcs_write(GUEST_AR_DS, ar_saved);
 
 	ar_saved = vmcs_read(GUEST_AR_ES);
 	/* Make ES unusable */
 	vmcs_write(GUEST_AR_ES, ar_saved | GUEST_SEG_UNUSABLE_MASK);
-	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(false, GUEST_BASE_ES,
-					 "GUEST_BASE_ES");
+	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(false, GUEST_BASE_ES);
 	/* Make ES usable */
 	vmcs_write(GUEST_AR_ES, ar_saved & ~GUEST_SEG_UNUSABLE_MASK);
-	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(true, GUEST_BASE_ES,
-					 "GUEST_BASE_ES");
+	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(true, GUEST_BASE_ES);
 	vmcs_write(GUEST_AR_ES, ar_saved);
 }
 
-- 
2.30.0.478.g8a0d178c01-goog

