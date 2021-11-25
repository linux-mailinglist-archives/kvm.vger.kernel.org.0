Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E9B45D2C5
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240405AbhKYCDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353056AbhKYCBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:01:11 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D106C0619E5
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:49 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 31-20020a630a1f000000b00324b8186ef0so1129514pgk.23
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=8lG4HI+hLMQ//Jep40KzKTe7/NdyFsho496CwO4KKis=;
        b=KIbXaYg1OzAdCXZPOHME716F5ey1yDdmynL7A8yC2kLicubuGeQzybSMM3HeMh5I0v
         2KjzqXmWl3C7HzCH0k2bCrZYNQsiJOpdrUzOuFcej78fOTRRoPW8B6GDQwu7Q5FJW/09
         qT9n7ZUzSQ3am1Y2vm30M9W9/CzcNE/MMp5ttzxub00HUlXX18GvSZsSIwQueAFNotc7
         6c8ayDxGpkqIzRI+o4sUCgomfOmD1MCKBZQQYbCa9ET+mHR1KkEfmBHf9Z0NFHTmQsts
         3A2sluS6PSfJoftrB5r5xkPcHI1XCoiW9RwxKPClSSjNAh/b7MsXh16vBWogudnn3C1p
         ejFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=8lG4HI+hLMQ//Jep40KzKTe7/NdyFsho496CwO4KKis=;
        b=enEGki4fFG0OH1ebn32WAwY9vwYtudymkvnj5O50dyI1BfvKXYmJlLLBqnf7w8wJUf
         nRDYWRfM3TK5Zw3q5lKbTmWiQRGn0J9QpEmOOBfUpjFTbPc1PriFB0cM1snhlRtsfP31
         IlCPYyfKImXkjxUDJuzlCJiutRjXdDc2Fu0hRnvoxeIfCOHtoAsJcsYZj05hz02ITj+D
         N3/iFey9tVlLea19924pqc3U1VwLYWmFLeDFn8lZowdPaO4bIL+GYzdtzBg5UP+ZC+5J
         lKzF4IswuwgmtNMXEW/JkUdbGzFgNeGzVabOrGsGd2iWX/SmHHYXWiMvNgRx/KVCUMfz
         GZzw==
X-Gm-Message-State: AOAM532BecfdCp9exTCUU0oJnyY1UMgBWX1Xyc1ngWWnDvk7SEZoeNL2
        Z2/4KGpddUASCGi0W+YqziP7mz0ongE=
X-Google-Smtp-Source: ABdhPJx/2eZbRdKp8iNWjW35nuTR2oUFr1cfupZqV64Tt/OmjYRJYLpvS14TrG0WDg07p8t8IiKZGyO80TM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1486:: with SMTP id
 js6mr626314pjb.0.1637803788623; Wed, 24 Nov 2021 17:29:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:48 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-31-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 30/39] nVMX: Add helper to check if INVVPID is supported
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper to check for basic INVVPID, it will gain more users in the
future.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.h       | 5 +++++
 x86/vmx_tests.c | 5 +----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/x86/vmx.h b/x86/vmx.h
index 289f175..9f91602 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -823,6 +823,11 @@ static inline bool is_invept_type_supported(u64 type)
 	return ept_vpid.val & (EPT_CAP_INVEPT_SINGLE << (type - INVEPT_SINGLE));
 }
 
+static inline bool is_invvpid_supported(void)
+{
+	return ept_vpid.val & VPID_CAP_INVVPID;
+}
+
 static inline bool is_invvpid_type_supported(unsigned long type)
 {
 	if (type < INVVPID_ADDR || type > INVVPID_CONTEXT_LOCAL)
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 950f527..66f374a 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -3300,7 +3300,6 @@ static void invvpid_test_not_in_vmx_operation(void)
  */
 static void invvpid_test(void)
 {
-	u64 msr;
 	int i;
 	unsigned types = 0;
 	unsigned type;
@@ -3309,9 +3308,7 @@ static void invvpid_test(void)
 	    !(ctrl_cpu_rev[1].clr & CPU_VPID))
 		test_skip("VPID not supported");
 
-	msr = rdmsr(MSR_IA32_VMX_EPT_VPID_CAP);
-
-	if (!(msr & VPID_CAP_INVVPID))
+	if (!is_invvpid_supported())
 		test_skip("INVVPID not supported.\n");
 
 	if (is_invvpid_type_supported(INVVPID_ADDR))
-- 
2.34.0.rc2.393.gf8c9666880-goog

