Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4416859F1C6
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbiHXDEr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234488AbiHXDD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:57 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C966F82D35
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:30 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 15-20020a63020f000000b0041b578f43f9so6997756pgc.11
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=BLJ6ZsILtEBEyxTqOigaifXfE5wzfQ74sl94FxyUmME=;
        b=Ehs1ZhN0mnGracrz+S9C72FjKvpOawIZsYJvmq2zYPSsp16SOf9lB2glGDi7H1O7Yi
         mpWWRWM2FsPElzs/2OMwyJqlt5cmEz6tiNh1kpyvFnA+PIwXa+UTwAXipdud3YZjjaNs
         XQrt1lMSu7hE7uX2IjbJRGZnFJ1CJ0fhDZiIL6kL1KI05H/+66cB67OnitdJMETpBpPX
         Gj7d85ZbXKNUbJBEbj8KjCNbG2mKJC5tPVdGu0AzUQKLWGh05MdTycnyoeV3JSZSI+kx
         4Dg+vusOtaxSNcZ2VqIez/B1UPGFJqfwo1GXjmydaQ0u/ur5girxZ+Tlj02TFDqouGCR
         xSRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=BLJ6ZsILtEBEyxTqOigaifXfE5wzfQ74sl94FxyUmME=;
        b=5/i+dsWdHRsJYcwZjDv+1F9GQoV+UZfvUE3Ct7uvhX/HM7xJgmvIN6R0ghgTnX0Y5f
         Lhef/iNk388BUZjIn9Hhheapi/gk778xoktLhSn87KHMpK1be93ans6nZVRLo9sXgNXW
         bJWgUfIxwNyVywPWpHKrMmIFFdWLptSpSjIKGqt8S+YiITWYnSIwJdaqgW6fA0DG8brA
         0xUMXLanpehhpWNywRB+BEXDpLKxk0lZUKc23LoozB/FLB7LUeAv8XVtAJMMcZ5OcLqv
         8bhWqAyT3hP4VDiwGuEem8CKN/AeSqbcnXhf8mhI1bb5X3FmLAYf1HnijAb2zsFaUSj5
         h9MQ==
X-Gm-Message-State: ACgBeo2DysSfEVUeyBWIknjjT4EZ1ix+K+mj6imW91CfWUsucPcbXnnw
        mdit16H+bglPOwQLIbaMlE1c98fzAas=
X-Google-Smtp-Source: AA6agR4qI9Ndl4APY48UTKzbPFuANNgnyRFV/CmnnXC6XxozgyUp/LhYt5tL/Q6dYhuiysTijByvz7HueV4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8055:0:b0:536:df46:c567 with SMTP id
 y21-20020aa78055000000b00536df46c567mr7945611pfm.1.1661310149111; Tue, 23 Aug
 2022 20:02:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:31 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-30-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 29/36] KVM: VMX: Add missing CPU based VM execution
 controls to vmcs_config
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

As a preparation to reusing the result of setup_vmcs_config() in
nested VMX MSR setup, add the CPU based VM execution controls which KVM
doesn't use but supports for nVMX to KVM_OPT_VMX_CPU_BASED_VM_EXEC_CONTROL
and filter them out in vmx_exec_control().

No functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 9 +++++++++
 arch/x86/kvm/vmx/vmx.h | 6 +++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 079cc4835248..11e75f2b832f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4322,6 +4322,15 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
 {
 	u32 exec_control = vmcs_config.cpu_based_exec_ctrl;
 
+	/*
+	 * Not used by KVM, but fully supported for nesting, i.e. are allowed in
+	 * vmcs12 and propagated to vmcs02 when set in vmcs12.
+	 */
+	exec_control &= ~(CPU_BASED_RDTSC_EXITING |
+			  CPU_BASED_USE_IO_BITMAPS |
+			  CPU_BASED_MONITOR_TRAP_FLAG |
+			  CPU_BASED_PAUSE_EXITING);
+
 	/* INTR_WINDOW_EXITING and NMI_WINDOW_EXITING are toggled dynamically */
 	exec_control &= ~(CPU_BASED_INTR_WINDOW_EXITING |
 			  CPU_BASED_NMI_WINDOW_EXITING);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index ce99704a37b7..8a05d24f4167 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -551,9 +551,13 @@ static inline u8 vmx_get_rvi(void)
 #endif
 
 #define KVM_OPTIONAL_VMX_CPU_BASED_VM_EXEC_CONTROL			\
-	(CPU_BASED_TPR_SHADOW |						\
+	(CPU_BASED_RDTSC_EXITING |					\
+	 CPU_BASED_TPR_SHADOW |						\
+	 CPU_BASED_USE_IO_BITMAPS |					\
+	 CPU_BASED_MONITOR_TRAP_FLAG |					\
 	 CPU_BASED_USE_MSR_BITMAPS |					\
 	 CPU_BASED_NMI_WINDOW_EXITING |					\
+	 CPU_BASED_PAUSE_EXITING |					\
 	 CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |			\
 	 CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
 
-- 
2.37.1.595.g718a3a8f04-goog

