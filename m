Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C730859F1BE
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbiHXDE2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234392AbiHXDDm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:42 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF65F7E020
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:16 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id n26-20020a056a000d5a00b0053644e1c026so4305021pfv.20
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=870G/abC2OEkKeqIlsoa/Qt7kfknON9uCl+tLdu8iW4=;
        b=CLjoaqpJjWx94TB1liL0QV3la2TwK1c4rbLVlwmIkD6gLEDcEQRnydl+Vl1rtb43ta
         YL4P7/95n+hN28ifGB/NztCqJDObh/g1k3ikmVipGQ6J8bR3Lj6jFnF0AT0H+AfSKX2p
         LQ8McZwUNnqFxXHYCcSfJQaPC2ryP8z7NlY2Ua8WGLj2LM2kmuAKwgJLNmf7APs7SSjk
         iIoGQfVOXM1ZPJqGFsJSp/WBQumDxrkAFAAPUdwM8p6JG78wZhn47v6/JKCHUcNp34QC
         QWrDnGoSgSjY6jChi/Sy4ysuBbhjT4YN5zL0WVSI9rMc+TiwX0sistZlcduH0AatMc8e
         73aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=870G/abC2OEkKeqIlsoa/Qt7kfknON9uCl+tLdu8iW4=;
        b=MoRCDtjFt6MeA6hqm201a6SQAd3/njSXUT6nsrd8dCeIDw83UbFkSbVMeEfNxtKBV/
         8YY5yCbhyslvhmeUWlLh7MWzQUQO2qx3XSASCzqrmMG+HREBvq4MVq49Ixbc2YEbqrlJ
         5AlJr2wq3lAqam3tIJUuo78RH4Jq9UrCGuEIUKDoKFlaGZVPhsW1rfPxylCM2uqtGvXo
         nik9qEHiDoVwuEPDUd/8W9WNjSmesnXlHUzzS2llxl+uBKFdInK03sitOHILektXmQ9s
         K/9xL5lwE8FzcD48a/IeBB0pXguObtPNojtcKrQ+RgDdeuMiW7EzY6Xq6Ytmk3tImj1Q
         Zm7g==
X-Gm-Message-State: ACgBeo25dLvIsqCmM9YH+mlNhywlWbnI76zc4vrTwzzAMHMR70OdIUiH
        b+zIqunBu7tsi77nRopybkERoPet3q0=
X-Google-Smtp-Source: AA6agR5sF1sOoAGqr2i0iLl4i0hDOVYtvtIi7OYSrqrDD7AayTn3w/wEGzV6Kgtj2gAYqSU3SJT8zpmhB1I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1251:b0:536:b942:35c7 with SMTP id
 u17-20020a056a00125100b00536b94235c7mr10517246pfi.72.1661310136490; Tue, 23
 Aug 2022 20:02:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:23 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-22-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 21/36] KVM: nVMX: Always emulate PERF_GLOBAL_CTRL
 VM-Entry/VM-Exit controls
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

Advertise VM_{ENTRY,EXIT}_LOAD_IA32_PERF_GLOBAL_CTRL as being supported
for nested VMs irrespective of hardware support.  KVM fully emulates
the controls, i.e. manually emulates MSR writes on entry/exit, and never
propagates the guest settings directly to vmcs02.

In addition to allowing L1 VMMs to use the controls on older hardware,
unconditionally advertising the controls will also allow KVM to use its
vmcs01 configuration as the basis for the nested VMX configuration
without causing a regression (due the errata which causes KVM to "hide"
the control from vmcs01 but not vmcs12).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index eed7551dd63c..6e9b32744e0d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6611,11 +6611,12 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
 #endif
 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
-		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+		VM_EXIT_CLEAR_BNDCFGS;
 	msrs->exit_ctls_high |=
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
-		VM_EXIT_SAVE_VMX_PREEMPTION_TIMER | VM_EXIT_ACK_INTR_ON_EXIT;
+		VM_EXIT_SAVE_VMX_PREEMPTION_TIMER | VM_EXIT_ACK_INTR_ON_EXIT |
+		VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
 
 	/* We support free control of debug control saving. */
 	msrs->exit_ctls_low &= ~VM_EXIT_SAVE_DEBUG_CONTROLS;
@@ -6630,10 +6631,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 #ifdef CONFIG_X86_64
 		VM_ENTRY_IA32E_MODE |
 #endif
-		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
-		VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
 	msrs->entry_ctls_high |=
-		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER);
+		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
+		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
 
 	/* We support free control of debug control loading. */
 	msrs->entry_ctls_low &= ~VM_ENTRY_LOAD_DEBUG_CONTROLS;
-- 
2.37.1.595.g718a3a8f04-goog

