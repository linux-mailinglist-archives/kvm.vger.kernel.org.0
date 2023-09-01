Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7807903C0
	for <lists+kvm@lfdr.de>; Sat,  2 Sep 2023 00:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351080AbjIAWuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 18:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238767AbjIAWuU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 18:50:20 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF840A1
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 15:50:14 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58ee4df08fbso30066187b3.3
        for <kvm@vger.kernel.org>; Fri, 01 Sep 2023 15:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693608614; x=1694213414; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=X6Ky/entugkcfAjWdG0T7nJj5LP7KXIUD3vZ96Cirg0=;
        b=IWFKEDMXYf08/1PcjWUQW5vqsojB5de8JzWHXkfa7SW58AukqfU45dOIx3XcdnAdG4
         fmKItymGqjugGhYxIShToUNImXk8Hf1XnCbnG1/+EuNmprcV5RUibsuSUeI4an0/ZkH+
         jhIzgMXXNpCGedPE3yKmV7LoOE72XHFBUufxEuPz5qzryL1QpSnfZhfOykqNzwVMopjI
         GvYsLjpmWQRtR3pKjE+gmA+lFqcMKkeA4KuApzKtF1Vfvndzx92ER9S5cGSTc8Yqa14w
         w+0GGMvW7g36BvgXUidxiBaOoTopquVbhIGpbwA86xTm6hJGqizSmfwwCa7ajpDTYmNY
         zcNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693608614; x=1694213414;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X6Ky/entugkcfAjWdG0T7nJj5LP7KXIUD3vZ96Cirg0=;
        b=lsDbmYhGmn97t/lnuVv7ePHxq9poZcP06WSZ+1VGtF0+QKGoxw0DXAfyPBNxTIWyTC
         L6r7tcG33iw3iei3GGQobHIWlpn3jNhJgoCLBkJVadf44qIKBQqK1U54O33VdLOTKZvZ
         axDjClCJpmVBLzAVMNgKnKI/4zhH9OEuzCCmbh218xHqcSmHOmk2K2ERwT1Ao2BvbyMg
         O+MMoxOY3evyi+VEdMiDio4zfuMAd/a/XzoidKDJJfBzzIR4ZxVcjHBVaEpbmITk1Aah
         WXM/yPDc9jcGzCGdLFpnMS0Hotwt8bNE4LedqQglixUXw/DD8adOgjf0Pg1XfGGr5/D3
         iCOw==
X-Gm-Message-State: AOJu0Yxz2mdham6m5CZP4c7fF9XNHeWCNtQlMBoIAZG0aEmEZdccF3Yo
        rSDcGVOWC++pkINASDzWWP5DuQ9liXc=
X-Google-Smtp-Source: AGHT+IFFmHbOYZ6KbcI8Na1UGzTAMmfHdeC+gQiS1JnUkviCDhYSgbk0nYGqaQlc/sSaIMiLpiD0kXfyy7o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:72c:b0:58c:9371:685e with SMTP id
 bt12-20020a05690c072c00b0058c9371685emr110005ywb.5.1693608614163; Fri, 01 Sep
 2023 15:50:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  1 Sep 2023 15:49:59 -0700
In-Reply-To: <20230901225004.3604702-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230901225004.3604702-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230901225004.3604702-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 3/7] nVMX: Assert that the test is configured
 for 64-bit mode
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The nVMX tests are 64-bit only, assert as much to reduce the probability
of the tests not actually running due to some funky bug.  It's easy to
re-add an if-statement if the nVMX tests ever gain 32-bit support, whereas
most developers lack the psychic powers necessary to detect that a test
isn't doing anything useful.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 69 ++++++++++++++++++++++++-------------------------
 1 file changed, 34 insertions(+), 35 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 9ec0f512..03da5307 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7619,49 +7619,48 @@ static void test_host_addr_size(void)
 	int i;
 	u64 tmp;
 
-	if (vmcs_read(EXI_CONTROLS) & EXI_HOST_64) {
-		assert(cr4_saved & X86_CR4_PAE);
+	assert(vmcs_read(EXI_CONTROLS) & EXI_HOST_64);
+	assert(cr4_saved & X86_CR4_PAE);
 
-		vmcs_write(ENT_CONTROLS, entry_ctrl_saved | ENT_GUEST_64);
-		report_prefix_pushf("\"IA-32e mode guest\" enabled");
+	vmcs_write(ENT_CONTROLS, entry_ctrl_saved | ENT_GUEST_64);
+	report_prefix_pushf("\"IA-32e mode guest\" enabled");
+	test_vmx_vmlaunch(0);
+	report_prefix_pop();
+
+	if (this_cpu_has(X86_FEATURE_PCID)) {
+		vmcs_write(HOST_CR4, cr4_saved | X86_CR4_PCIDE);
+		report_prefix_pushf("\"CR4.PCIDE\" set");
 		test_vmx_vmlaunch(0);
 		report_prefix_pop();
+	}
 
-		if (this_cpu_has(X86_FEATURE_PCID)) {
-			vmcs_write(HOST_CR4, cr4_saved | X86_CR4_PCIDE);
-			report_prefix_pushf("\"CR4.PCIDE\" set");
-			test_vmx_vmlaunch(0);
-			report_prefix_pop();
-		}
-
-		for (i = 32; i <= 63; i = i + 4) {
-			tmp = rip_saved | 1ull << i;
-			vmcs_write(HOST_RIP, tmp);
-			report_prefix_pushf("HOST_RIP %lx", tmp);
-			test_vmx_vmlaunch(0);
-			report_prefix_pop();
-		}
-
-		vmcs_write(HOST_CR4, cr4_saved  & ~X86_CR4_PAE);
-		report_prefix_pushf("\"CR4.PAE\" unset");
-		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
-		vmcs_write(HOST_CR4, cr4_saved);
+	for (i = 32; i <= 63; i = i + 4) {
+		tmp = rip_saved | 1ull << i;
+		vmcs_write(HOST_RIP, tmp);
+		report_prefix_pushf("HOST_RIP %lx", tmp);
+		test_vmx_vmlaunch(0);
 		report_prefix_pop();
+	}
 
-		vmcs_write(HOST_RIP, NONCANONICAL);
-		report_prefix_pushf("HOST_RIP %llx", NONCANONICAL);
-		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
-		report_prefix_pop();
+	vmcs_write(HOST_CR4, cr4_saved  & ~X86_CR4_PAE);
+	report_prefix_pushf("\"CR4.PAE\" unset");
+	test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+	vmcs_write(HOST_CR4, cr4_saved);
+	report_prefix_pop();
 
-		vmcs_write(ENT_CONTROLS, entry_ctrl_saved | ENT_GUEST_64);
-		vmcs_write(HOST_RIP, rip_saved);
-		vmcs_write(HOST_CR4, cr4_saved);
+	vmcs_write(HOST_RIP, NONCANONICAL);
+	report_prefix_pushf("HOST_RIP %llx", NONCANONICAL);
+	test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+	report_prefix_pop();
 
-		/* Restore host's active RIP and CR4 values. */
-		report_prefix_pushf("restore host state");
-		test_vmx_vmlaunch(0);
-		report_prefix_pop();
-	}
+	vmcs_write(ENT_CONTROLS, entry_ctrl_saved | ENT_GUEST_64);
+	vmcs_write(HOST_RIP, rip_saved);
+	vmcs_write(HOST_CR4, cr4_saved);
+
+	/* Restore host's active RIP and CR4 values. */
+	report_prefix_pushf("restore host state");
+	test_vmx_vmlaunch(0);
+	report_prefix_pop();
 }
 
 /*
-- 
2.42.0.283.g2d96d420d3-goog

