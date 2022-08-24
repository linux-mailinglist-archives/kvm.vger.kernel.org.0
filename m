Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349E259F1C7
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbiHXDEu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbiHXDD6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:58 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DC082D3D
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:31 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l3-20020a170902f68300b00172e52e5297so5162637plg.2
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=ZFA9BQBbSreRJQ6NcAxchYId+6hDTQ6wtwQ6cIL8kBg=;
        b=nSazQP3H1qPdLCwX13F691Ckwzz5swtc0sYOsUe/MEHQD4WzVpMMaftP6i5CJunUty
         ktAj5uRPkNIiWmYm+cpyZZy6jFg9KJ4/JsoKbJ43LdARMagxX/MZJeR+3EZv9bMWQ1mH
         6u2WG1wQ92gwrnyZz9AG0bRFfFh2zNeRVk72JkBNvFsPEeWL0Q7DuurLJ9TJ68QU/UoJ
         AlaeCoBvwbKvnKlZmPwvWzZ3TO7DnaMCsU719ifUhtec497kR/+ZkDRBb9stVfUF24iB
         Mmo8iG9dlyQOeA4bdSO7+t6U0WYvt90gy/wIqYJ/drRMyyFJ36GwulfvlQ85qMZ7FnM8
         o3Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=ZFA9BQBbSreRJQ6NcAxchYId+6hDTQ6wtwQ6cIL8kBg=;
        b=V9CSE/klRM0/6ZXG+pfUFNzSl2u9NAa80z+mv0LKC7QmSkYkzcJcIlonxt11nDvYYv
         OtQqpcA/WpjuhRZERRLHK+BOQW4SweHohSgAcRfq+gMK31PLiT+BMROkpyfP1aqyfxNi
         gkJDmcQ/ykRNYOn0ul1MnCnkAqtF/J98Ar7NRP54UkhYMGPAKJhVj0AuQ48QweRvP5Pa
         VOxypk3PdTJL0MFku1sbt5GlM9bbYE32hEDO7X19GJmawOT2gDLydbu2QCGIVICJi7U4
         BTxFDsmfXIGfdZysMQzYw3KP9lnAxt3vwKsqOKCk+yu54DqwBS34rLR02O74M1RWtI/c
         ttfg==
X-Gm-Message-State: ACgBeo2rDKp9jqt3s7OV1a1SMNbmj2Kxwe30LfXnGMAvW4ZEo30Z9mJR
        iUKtKAxbMcP7XnA8MbSyCXnwmOm0iFs=
X-Google-Smtp-Source: AA6agR4jx/f7Shr+tzpQfFSQsXvdj2O2sOJ6F652zs+xPuNoaWSqz27JnN/vQYMWVPRRhJ04R2RPGVP1B80=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr151422pje.0.1661310150693; Tue, 23 Aug
 2022 20:02:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:32 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-31-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 30/36] KVM: VMX: Adjust CR3/INVPLG interception for
 EPT=y at runtime, not setup
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

Clear the CR3 and INVLPG interception controls at runtime based on
whether or not EPT is being _used_, as opposed to clearing the bits at
setup if EPT is _supported_ in hardware, and then restoring them when EPT
is not used.  Not mucking with the base config will allow using the base
config as the starting point for emulating the VMX capability MSRs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 11e75f2b832f..5dcec85db093 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2574,13 +2574,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	rdmsr_safe(MSR_IA32_VMX_EPT_VPID_CAP,
 		&vmx_cap->ept, &vmx_cap->vpid);
 
-	if (_cpu_based_2nd_exec_control & SECONDARY_EXEC_ENABLE_EPT) {
-		/* CR3 accesses and invlpg don't need to cause VM Exits when EPT
-		   enabled */
-		_cpu_based_exec_control &= ~(CPU_BASED_CR3_LOAD_EXITING |
-					     CPU_BASED_CR3_STORE_EXITING |
-					     CPU_BASED_INVLPG_EXITING);
-	} else if (vmx_cap->ept) {
+	if (!(_cpu_based_2nd_exec_control & SECONDARY_EXEC_ENABLE_EPT) &&
+	    vmx_cap->ept) {
 		pr_warn_once("EPT CAP should not exist if not support "
 				"1-setting enable EPT VM-execution control\n");
 
@@ -4349,10 +4344,11 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
 		exec_control |= CPU_BASED_CR8_STORE_EXITING |
 				CPU_BASED_CR8_LOAD_EXITING;
 #endif
-	if (!enable_ept)
-		exec_control |= CPU_BASED_CR3_STORE_EXITING |
-				CPU_BASED_CR3_LOAD_EXITING  |
-				CPU_BASED_INVLPG_EXITING;
+	/* No need to intercept CR3 access or INVPLG when using EPT. */
+	if (enable_ept)
+		exec_control &= ~(CPU_BASED_CR3_LOAD_EXITING |
+				  CPU_BASED_CR3_STORE_EXITING |
+				  CPU_BASED_INVLPG_EXITING);
 	if (kvm_mwait_in_guest(vmx->vcpu.kvm))
 		exec_control &= ~(CPU_BASED_MWAIT_EXITING |
 				CPU_BASED_MONITOR_EXITING);
-- 
2.37.1.595.g718a3a8f04-goog

