Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241E66CB5BD
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 07:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbjC1FCl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 01:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjC1FCi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 01:02:38 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EAE2109
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 22:02:37 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id e5-20020a17090301c500b001a1aa687e4bso7011580plh.17
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 22:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679979757;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=l30Bo4sseYT6mdSxEgWgPg1yNO2MfcdkDz2rkKS2SdU=;
        b=Wt78TPeZEgCHyu4d9zdIHXMOvryEqnRpb+HwloZGVwrDHTuKu7FunZSd7kmis8wVZv
         R97eJEhkSVHS/Lp2XQa5HqRnchMc35BXh4oggpCzXy13t9zTDYX4KGTwyqIa6C3/jf07
         vsgSYGO4hH0+sNdq8MRvhLqvCh3kl5SRkXMd/N8FfoNe8WY8kkGsSTdLkgT42U2yP2wj
         z9lQWcE6hGtlX/+YCgUq6osTP9FrpzasqXYeVYkt6fH81V3iXBPzssDk0UZa1TIA1yK9
         /MA8Yz/5aQafBUaoSbB256kHPyq6lxShXthn4jvG4LaKasiAce9DSZitctm4jUcb9plp
         kfbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679979757;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l30Bo4sseYT6mdSxEgWgPg1yNO2MfcdkDz2rkKS2SdU=;
        b=27XGl/RimqtcmAe5JwONu0D9gXQmq5VSrzpsgOOmsCwvK8ukZH2bHqn+ENEhwROf1U
         PMBCMIfLrzAndpolN5iz6Co9AC1h3eUxH2EU4cxaPh0ZQKhHhNQjA5mtZGN8Ql1KIw5r
         uS0v6u7qwLqgWFeLKXGF2+aP2xqE5ddbWKIpxXwFvGkXFxp4TVdeha3rTaS2iPcsw2V5
         Bhqx7p/IMdEC3VtKjTZywWDGd0/JUAQT5KadEd7jaTFJO7IWflYhvMgTowwx1kFA5EhI
         0Rtat9BJkWqgLSObQMukTNk+ydZs/xb8PVcH0hFQE8H7M446e6YpPJw1sGjDS2xOl1/x
         1T7Q==
X-Gm-Message-State: AAQBX9ePPfSNes9UmuRlnjtkXMGU1L2g5xPcUcPTR+XWJzGn63q862BQ
        txzRYtLl1g3F50aVlMdVig4eM9aW88o=
X-Google-Smtp-Source: AKy350aUdlrw4Pqu3hIjszPfWKHk80X8kwubH9Jjb7FGKp2I4b+whAllYWbumT4A4n7pLja32O0hpbp0cTw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:d958:0:b0:513:3030:10be with SMTP id
 e24-20020a63d958000000b00513303010bemr3230987pgj.3.1679979756945; Mon, 27 Mar
 2023 22:02:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 27 Mar 2023 22:02:30 -0700
In-Reply-To: <20230328050231.3008531-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230328050231.3008531-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230328050231.3008531-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 2/3] x86/msr: Add testcases for
 MSR_IA32_PRED_CMD and its IBPB command
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add test coverage to verify MSR_IA32_PRED_CMD is write-only, that it can
be written with '0' (nop command) and '1' (IBPB command) when IBPB is
supported by the CPU (SPEC_CTRL on Intel, IBPB on AMD), and that writing
any other bit (1-63) triggers a #GP due to the bits/commands being
reserved.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/msr.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/x86/msr.c b/x86/msr.c
index 97cf5987..13cb6391 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -85,6 +85,15 @@ static void test_msr_rw(u32 msr, const char *name, unsigned long long val)
 	__test_msr_rw(msr, name, val, 0);
 }
 
+static void test_wrmsr(u32 msr, const char *name, unsigned long long val)
+{
+	unsigned char vector = wrmsr_safe(msr, val);
+
+	report(!vector,
+	       "Expected success on WRSMR(%s, 0x%llx), got vector %d",
+	       name, val, vector);
+}
+
 static void test_wrmsr_fault(u32 msr, const char *name, unsigned long long val)
 {
 	unsigned char vector = wrmsr_safe(msr, val);
@@ -271,6 +280,23 @@ static void test_x2apic_msrs(void)
 	__test_x2apic_msrs(true);
 }
 
+static void test_cmd_msrs(void)
+{
+	int i;
+
+	test_rdmsr_fault(MSR_IA32_PRED_CMD, "PRED_CMD");
+	if (this_cpu_has(X86_FEATURE_SPEC_CTRL) ||
+	    this_cpu_has(X86_FEATURE_AMD_IBPB)) {
+		test_wrmsr(MSR_IA32_PRED_CMD, "PRED_CMD", 0);
+		test_wrmsr(MSR_IA32_PRED_CMD, "PRED_CMD", PRED_CMD_IBPB);
+	} else {
+		test_wrmsr_fault(MSR_IA32_PRED_CMD, "PRED_CMD", 0);
+		test_wrmsr_fault(MSR_IA32_PRED_CMD, "PRED_CMD", PRED_CMD_IBPB);
+	}
+	for (i = 1; i < 64; i++)
+		test_wrmsr_fault(MSR_IA32_PRED_CMD, "PRED_CMD", BIT_ULL(i));
+}
+
 int main(int ac, char **av)
 {
 	/*
@@ -283,6 +309,7 @@ int main(int ac, char **av)
 		test_misc_msrs();
 		test_mce_msrs();
 		test_x2apic_msrs();
+		test_cmd_msrs();
 	}
 
 	return report_summary();
-- 
2.40.0.348.gf938b09366-goog

