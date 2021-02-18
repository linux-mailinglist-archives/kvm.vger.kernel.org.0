Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19F331E379
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 01:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhBRAXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 19:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbhBRAXA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 19:23:00 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5117C0613D6
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 16:22:19 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id j4so569624ybt.23
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 16:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=PRyE4DuvxmKcKdm5ROiIEhCflgy/4d0H0JxsOnzUrZk=;
        b=aKznqUyu3qCbvyr9Jjmwnij/oFYrNnrZjcqBVtget+UuMDTnH52TPhLLszKagVon1w
         b3U7RMelO28y5X0QEUmYnqlzNl2E7/YUmBeXNWu3WMnGcK13dAmc3afYWDILLPsJYU84
         LTqW3EkOV6LN/SmX/2PTxoW36BTCbsqBsEdN0kIJgRiY6LNxWIrWKXwgjDe7aa3117ET
         ROmR2upAvSlV6RG2iDjKjLzNv06m3LwHUxk7bYKYKBOmndIO1jOGcdTrezclQsllcUEU
         rHIfy6mZij/Di8nqw9KpsrhMUXvJtFv6Z82/rnErz5c0WUKjVUO6lRHPeI2SdLb6ESkw
         j9AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=PRyE4DuvxmKcKdm5ROiIEhCflgy/4d0H0JxsOnzUrZk=;
        b=RdjndschXnOF3xw44Q54TTh7NbFwD5CMLVR5sKXy0gyxpIM1JHmOMtptg8M4OtCj/d
         qe6916ZoPwQ8sWPhA92zhWOc7znMZ16wJRtJATv9YAxSyff572QAI3x6VZ5k9jnUBW3a
         iNYy6asi8cAN33+hYZSJdKMeZ1Xg7pYoNB88uElDo0KEF2wAeIlyB+6gD8laOeyzGlmv
         o9mQrfLSQQC3w39Bo0OHtEOAFA1xvVuwZ2WIrOwd33k4iakT2imeVfonhRNgYg19QWVx
         vWWwbzCApv+P7lwQmE4G/n5RbCqNbICXBP6pn/FmeeyenM2au8KRTpL1uVjHxrQGWx0D
         Tetg==
X-Gm-Message-State: AOAM530OotMmCBc3WdOiC1aOd1cUzarSjkPHmRMSY2TTs176f5DmX5Dl
        gyfKgc/9GuyZXlwu9hpl+YwdxNJDZaM=
X-Google-Smtp-Source: ABdhPJyflWiTey/5gO0p/MU+xC5QuBxKNa5CJ3MQS718L2AxRFywQOTJgp42z3w4+6dHbgJgaGoN612yVRw=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:dc76:757f:9e9e:647c])
 (user=seanjc job=sendgmr) by 2002:a25:6e02:: with SMTP id j2mr2847972ybc.247.1613607739007;
 Wed, 17 Feb 2021 16:22:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 17 Feb 2021 16:22:07 -0800
In-Reply-To: <20210218002212.2904647-1-seanjc@google.com>
Message-Id: <20210218002212.2904647-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210218002212.2904647-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [kvm-unit-tests PATCH 1/6] x86: nVMX: Verify unrestricted guest is
 supported in segment tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enhance enable_unrestricted_guest() to allow configuring a fully valid
EPT tree, and use the updated helper to verify unrestricted guest can be
enabled before testing SS segment properties that are specific to
unrestricted guest.

Fixes: 7820ac5 ("nVMX: Test Selector and Base Address fields of Guest Segment Registers on vmentry of nested guests")
Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index da17b51..cf42619 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1101,14 +1101,17 @@ static void setup_dummy_ept(void)
 		report_abort("EPT setup unexpectedly failed");
 }
 
-static int enable_unrestricted_guest(void)
+static int enable_unrestricted_guest(bool need_valid_ept)
 {
 	if (!(ctrl_cpu_rev[0].clr & CPU_SECONDARY) ||
 	    !(ctrl_cpu_rev[1].clr & CPU_URG) ||
 	    !(ctrl_cpu_rev[1].clr & CPU_EPT))
 		return 1;
 
-	setup_dummy_ept();
+	if (need_valid_ept)
+		setup_ept(false);
+	else
+		setup_dummy_ept();
 
 	vmcs_write(CPU_EXEC_CTRL0, vmcs_read(CPU_EXEC_CTRL0) | CPU_SECONDARY);
 	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) | CPU_URG);
@@ -4347,7 +4350,7 @@ static void test_invalid_event_injection(void)
 	test_vmx_valid_controls();
 	report_prefix_pop();
 
-	if (enable_unrestricted_guest())
+	if (enable_unrestricted_guest(false))
 		goto skip_unrestricted_guest;
 
 	ent_intr_info = ent_intr_info_base | INTR_INFO_DELIVER_CODE_MASK |
@@ -8059,12 +8062,13 @@ static void test_guest_segment_sel_fields(void)
 				 ((sel_saved & ~0x3) | (~cs_rpl_bits & 0x3)));
 	TEST_SEGMENT_SEL(false, GUEST_SEL_SS, "GUEST_SEL_SS",
 				 ((sel_saved & ~0x3) | (cs_rpl_bits & 0x3)));
+	vmcs_write(CPU_EXEC_CTRL0, cpu_ctrl0_saved);
+	vmcs_write(CPU_EXEC_CTRL1, cpu_ctrl1_saved);
+
+	/* Need a valid EPTP as the passing case fully enters the guest. */
+	if (enable_unrestricted_guest(true))
+		goto skip_ss_tests;
 
-	/* Turn on "unrestricted guest" vm-execution control */
-	vmcs_write(CPU_EXEC_CTRL0, cpu_ctrl0_saved | CPU_SECONDARY);
-	vmcs_write(CPU_EXEC_CTRL1, cpu_ctrl1_saved | CPU_URG);
-	/* EPT and EPTP must be setup when "unrestricted guest" is on */
-	setup_ept(false);
 	TEST_SEGMENT_SEL(false, GUEST_SEL_SS, "GUEST_SEL_SS",
 				 ((sel_saved & ~0x3) | (~cs_rpl_bits & 0x3)));
 	TEST_SEGMENT_SEL(false, GUEST_SEL_SS, "GUEST_SEL_SS",
@@ -8078,6 +8082,7 @@ static void test_guest_segment_sel_fields(void)
 				 ((sel_saved & ~0x3) | (~cs_rpl_bits & 0x3)));
 	TEST_SEGMENT_SEL(false, GUEST_SEL_SS, "GUEST_SEL_SS",
 				 ((sel_saved & ~0x3) | (cs_rpl_bits & 0x3)));
+skip_ss_tests:
 
 	vmcs_write(GUEST_AR_SS, ar_saved);
 	vmcs_write(GUEST_SEL_SS, sel_saved);
-- 
2.30.0.478.g8a0d178c01-goog

