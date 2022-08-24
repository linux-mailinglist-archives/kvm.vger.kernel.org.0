Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA4159F1BF
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbiHXDEc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbiHXDDm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:42 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B65F7E32F
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:18 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id b9-20020a170902d50900b0016f0342a417so10271364plg.21
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=f5f8FSR/HmHFegkgMcIzrghSE3Avu0AoYrXLQ04YVGw=;
        b=Kdpx0QTmut9LLAdmzMj73fvRMdhDic6vcsnPPzQWpwjluHqnfcXzeUFZFwUwQ0z8RQ
         C8wAueyy/AsOMqf7PzrfcNL1xixPn4yER1d4pmBBJPuFPT5cnNcFMhCfHEv5XTh00trb
         RTel48HptfDdV+OVtm7W4TKH0U6eK0NmeRxwCkKhoKkY7ylqUNKKkuLZ9HT7+I7hULrV
         8ZHU4/enIwGMCfIHgmDl3iyG93KkhiwhDBPq/Vv6tQmlPquV8/BjHHNrqVz+vk33nSQa
         MrnWK1bjWjVWz0zHL1vBSTiPWaLjpLojRubBOYCeJZXUwEQIootWeY9hf1JUPnt+p/qS
         vjaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=f5f8FSR/HmHFegkgMcIzrghSE3Avu0AoYrXLQ04YVGw=;
        b=BMcY2IsUBiXzwSH0cZ5cUjn6p9ktWXMlsENR+0MDIJgdkWHxvoYIb+habCM7CQH9DB
         mhqONXx5eq5ndjknomQALyaZwFTTo3fudVgxcaQLbGXldlNhccMto1SMv98v8zZNL/C1
         WXE9VKw2q+shBjTycOsSTlykMRycnjNAvCk1D9XQ72JQXIMHyRe33PP9UKCG3UN/5HuA
         T/XewSjAXQCwS3RoBl40MvsQcT9G6kXIUfgnVqxZEWXw0ra8Y23IlndmKjEDouEhyQqJ
         uroDmG/v9MPL2m244MHW72/qLlO81Fwgi2Xy9Rb4lqYKs8W3PVy+SViMo3zGqKk06Ttz
         1KjA==
X-Gm-Message-State: ACgBeo3YD3U5Nax5Djm4a3ZB6gSXrdKh69XcbZ8kJKUuP4fXiL0+UbZD
        GrSJJUub2/aD/oR/h8lFLyZTegate1Q=
X-Google-Smtp-Source: AA6agR7sTcja/gbLHy4g7Z15Cijg2XhpBKOP3TKr1shmMGoNVqPNGuQqMBB7xMUyRXGqGK74o1+hI6cJ/io=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4c4f:b0:1fb:1c32:8e52 with SMTP id
 np15-20020a17090b4c4f00b001fb1c328e52mr6153810pjb.233.1661310138179; Tue, 23
 Aug 2022 20:02:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:24 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-23-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 22/36] KVM: VMX: Check VM_ENTRY_IA32E_MODE in setup_vmcs_config()
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

VM_ENTRY_IA32E_MODE control is toggled dynamically by vmx_set_efer()
and setup_vmcs_config() doesn't check its existence. On the contrary,
nested_vmx_setup_ctls_msrs() doesn set it on x86_64. Add the missing
check and filter the bit out in vmx_vmentry_ctrl().

No (real) functional change intended as all existing CPUs supporting
long mode and VMX are supposed to have it.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6b702c0085ff..eff38cbe6d35 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2683,6 +2683,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		_pin_based_exec_control &= ~PIN_BASED_POSTED_INTR;
 
 	min = VM_ENTRY_LOAD_DEBUG_CONTROLS;
+#ifdef CONFIG_X86_64
+	min |= VM_ENTRY_IA32E_MODE;
+#endif
 	opt = VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |
 	      VM_ENTRY_LOAD_IA32_PAT |
 	      VM_ENTRY_LOAD_IA32_EFER |
@@ -4317,9 +4320,14 @@ static u32 vmx_vmentry_ctrl(void)
 	if (vmx_pt_mode_is_system())
 		vmentry_ctrl &= ~(VM_ENTRY_PT_CONCEAL_PIP |
 				  VM_ENTRY_LOAD_IA32_RTIT_CTL);
-	/* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
-	return vmentry_ctrl &
-		~(VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL | VM_ENTRY_LOAD_IA32_EFER);
+	/*
+	 * IA32e mode, and loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically.
+	 */
+	vmentry_ctrl &= ~(VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |
+			  VM_ENTRY_LOAD_IA32_EFER |
+			  VM_ENTRY_IA32E_MODE);
+
+	return vmentry_ctrl;
 }
 
 static u32 vmx_vmexit_ctrl(void)
-- 
2.37.1.595.g718a3a8f04-goog

