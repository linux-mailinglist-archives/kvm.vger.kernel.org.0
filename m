Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEB159F1C0
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbiHXDEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234372AbiHXDDo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:44 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138A682856
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:20 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id p47-20020a056a0026ef00b005360f6163bcso5428694pfw.10
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=uRd7R7pLzjjdZjW8Dyqy1bvANP+JYwMiuQ0F7wNsDhs=;
        b=Bn6pY2X+mNhutKjw0WJ4Z0rCGfykuTPTqiod60A/wDGyowMjItziPTDmUt7ounASKO
         EBTmgh9tuCiEhtAFEogGLKDZbWKmysX4e/x3ow6HLMt6tnjddmRkXqlpq2TH7R7O7x4l
         1Z6SODsxZK3g+84luLzD0iQmMPeiyl7PEceLlhPM6FfJBV+/1Mt5bMZ5z7YhbDzQjxWG
         3t8YgYHUhy9hjF/LqiVj0s4bRsHWmz9x4nqM5WH54NpeWxmOLBKoFQ1JG0yuuI5glRy1
         aOLfbz1dKCqOO8Pz+tvIRvJw+zcn5QvvhZHwjgp4utnE3mezaoDmgAd6grmoGme9pWK0
         fcxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=uRd7R7pLzjjdZjW8Dyqy1bvANP+JYwMiuQ0F7wNsDhs=;
        b=tV737zAiT320tbtbFsP6Nwa0fcQDG0ngATXDKzCCDuzr+bLYOGw0cSLneyvApECrjc
         wBDWbK4OsyZ18Aejc7vKOR0PbAxV//l0AT+ERHrTapnmURfFV0vq5jxV6tTJSCb++5M3
         Ze3O0VB2ohj8b7mEs2jkW+xYnHKFsYMuMquVTQ4GKCcetGgWb3lLn+JwhAZmDd7DDCpT
         Bk0CMf3ImzdtnwsuozT5ArjlernYY4bnb1HDbk3LTiJ7CoX9mT/xPdmFPYkkvoN6+WZl
         wD19sGyl6pxZb2FOmc82rRa/V7SGLGC+c51ASbfDQxZNaMb1S9Jsr8G7atjb0y0Aw2eP
         yxCQ==
X-Gm-Message-State: ACgBeo2IGmoo1tsKh2r0pV8c4nf4XKZpTjhnsuqcrSrbIVMEph4beg+J
        qJZHyu0mBspzIPew1fTNLbycY69JhtI=
X-Google-Smtp-Source: AA6agR7HbknG7E6mJGXBd6mD7ITvU67NQ2fCBY81Rg6k1JhanbZ5C2rsOA093HzI3RNysDz4SWWeZOaM8e0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:41c5:b0:172:fc8b:d186 with SMTP id
 u5-20020a17090341c500b00172fc8bd186mr6870843ple.90.1661310139643; Tue, 23 Aug
 2022 20:02:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:25 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-24-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 23/36] KVM: VMX: Check CPU_BASED_{INTR,NMI}_WINDOW_EXITING
 in setup_vmcs_config()
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

CPU_BASED_{INTR,NMI}_WINDOW_EXITING controls are toggled dynamically by
vmx_enable_{irq,nmi}_window, handle_interrupt_window(), handle_nmi_window()
but setup_vmcs_config() doesn't check their existence. Add the check and
filter the controls out in vmx_exec_control().

Note: KVM explicitly supports CPUs without VIRTUAL_NMIS and all these CPUs
are supposedly lacking NMI_WINDOW_EXITING too. Adjust cpu_has_virtual_nmis()
accordingly.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/capabilities.h | 3 ++-
 arch/x86/kvm/vmx/vmx.c          | 8 +++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index c5e5dfef69c7..faee1db8b0e0 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -82,7 +82,8 @@ static inline bool cpu_has_vmx_basic_inout(void)
 
 static inline bool cpu_has_virtual_nmis(void)
 {
-	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS;
+	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS &&
+	       vmcs_config.cpu_based_exec_ctrl & CPU_BASED_NMI_WINDOW_EXITING;
 }
 
 static inline bool cpu_has_vmx_preemption_timer(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index eff38cbe6d35..7acbe43030e4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2560,10 +2560,12 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      CPU_BASED_MWAIT_EXITING |
 	      CPU_BASED_MONITOR_EXITING |
 	      CPU_BASED_INVLPG_EXITING |
-	      CPU_BASED_RDPMC_EXITING;
+	      CPU_BASED_RDPMC_EXITING |
+	      CPU_BASED_INTR_WINDOW_EXITING;
 
 	opt = CPU_BASED_TPR_SHADOW |
 	      CPU_BASED_USE_MSR_BITMAPS |
+	      CPU_BASED_NMI_WINDOW_EXITING |
 	      CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |
 	      CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PROCBASED_CTLS,
@@ -4374,6 +4376,10 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
 {
 	u32 exec_control = vmcs_config.cpu_based_exec_ctrl;
 
+	/* INTR_WINDOW_EXITING and NMI_WINDOW_EXITING are toggled dynamically */
+	exec_control &= ~(CPU_BASED_INTR_WINDOW_EXITING |
+			  CPU_BASED_NMI_WINDOW_EXITING);
+
 	if (vmx->vcpu.arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)
 		exec_control &= ~CPU_BASED_MOV_DR_EXITING;
 
-- 
2.37.1.595.g718a3a8f04-goog

