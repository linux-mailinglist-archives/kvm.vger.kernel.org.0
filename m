Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7A86170E0
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbiKBWvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiKBWvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:51:18 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39513BC3E
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:18 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id n12-20020a170902e54c00b00188515e81a6so150209plf.23
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4UuFeK7ZuzlAbWszFPHCqZNN8a1tHo5FOVtIZXoUWgU=;
        b=pNaYqtDhha9ETxoBUkPpBPVgkCLjH+IFu8ZwiF0RP6FhExmzs0S2acrzDQPTGuY3MD
         OwjqHS+cA1HRMhexLP8h8XqXAiUrnU7oDN+y41cbckhSUwhBD/O5aInwrmPHEWenDo8F
         lO52+155jiGW4oM0ujMP6TaKl2CHB6D8hOAAB6f7k05QpWn0rL4vFrkbhw5GYgeIWrwC
         IsQbT9hL41YM2Jk4MUassiSGXeuUbIXlXyHI3c7EFsTQcdH8sxGFIWgvknR0bm20lASl
         kS7CJcR/I9DEa77LwaXONSANtFcCCF4gQD8UlNBE953SK9riO8yyKI4VCcc8szDXCWx3
         Dzhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4UuFeK7ZuzlAbWszFPHCqZNN8a1tHo5FOVtIZXoUWgU=;
        b=YOjo5rgphsnNk8uEhr2W569TYJGH1stZ4w5qqK+NTP8GWE6DtfUcVjbtxznRkRmHRS
         1cUEcDT2DkGMt7q7AmNxDFtb8DiNUU2jHeLL7qYZKOp4Weqw1HNBNQ2xg6quvwNzrFKP
         MwY/FR+gr+YVrC8J1fF7cfw8O+76Lf24WoGcAhKVqOOTKZW3g+ebElDL0lm69Bx6rB+l
         GG0nCqnS8NtnSyC++AsyaKEWH7+bSLExNCykgxCK+tkqQEfXF+TXrgHHMzs5XuOo9l7C
         s9Q3Qpr+MDSeV3ulv1S7qVekcS+xXQtdFa5YtWyrfgZAvRDRWHdKp5k94Li1Q75/5Spk
         tF8A==
X-Gm-Message-State: ACrzQf3jfpG5y9SrT8o7L+9vXJNfggQWdn2WEt4WTrfjFsgyXr3xMROp
        Kt06eUZNcpUyyRJF6Cfh3V0nwKcFR7c=
X-Google-Smtp-Source: AMsMyM5vpQhgImqdJmnApP1JY1GM0X8zbe6G/bKr46ljwyhZtiRQzUG4SJaFEbHmDFN6yqbFAEwUVBA/2oc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e902:b0:186:9c03:5f27 with SMTP id
 k2-20020a170902e90200b001869c035f27mr26953277pld.16.1667429477790; Wed, 02
 Nov 2022 15:51:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:50:45 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 02/27] x86/pmu: Test emulation instructions
 on full-width counters
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Like Xu <likexu@tencent.com>,
        Sandipan Das <sandipan.das@amd.com>
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

From: Like Xu <likexu@tencent.com>

Move check_emulated_instr() into check_counters() so that full-width
counters could be tested with ease by the same test case.

Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 1a3e5a54..308a0ce0 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -520,6 +520,9 @@ static void check_emulated_instr(void)
 
 static void check_counters(void)
 {
+	if (is_fep_available())
+		check_emulated_instr();
+
 	check_gp_counters();
 	check_fixed_counters();
 	check_rdpmc();
@@ -655,9 +658,6 @@ int main(int ac, char **av)
 
 	apic_write(APIC_LVTPC, PC_VECTOR);
 
-	if (is_fep_available())
-		check_emulated_instr();
-
 	check_counters();
 
 	if (this_cpu_perf_capabilities() & PMU_CAP_FW_WRITES) {
-- 
2.38.1.431.g37b22c650d-goog

