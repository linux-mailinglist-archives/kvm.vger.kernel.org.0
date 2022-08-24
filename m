Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2D659F1C4
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbiHXDEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234284AbiHXDDs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:48 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2468287D
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:26 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id k1-20020a17090a658100b001fb35f86ccdso151997pjj.9
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=mYfNse3wDv58sLXK/09guTsOeI3IccjdPVlMQiwUdEc=;
        b=WZCNFqpbpChPslSPtBMs7tSyXYiMvo53nXBWfSjx4orAc3p2Y5y7uaWjGvpRH5EQiR
         0DdWm5VWDqHUw+6c3TKFBg5F9t4ptNLrqll6NM+qgI+LLittKyFkeFkvPSaOLOW6lHYX
         0uvyKB8MGvn4tXZaVd5Elifaxq8nh13QfrWPZ+AijPTJwHxbv2y4JAO6BnLSySxm0lQ6
         a/yOi+kNC+0ZUaViykmIkA/yULhJKvnUEZ+Co757HR5i8Jdd59Zuh7iXfkkQN92CvXjs
         Jjk62icidoxuKtRSXVxbchjRTlkAjnwkjS/zkQoKHiDyCormo7rmeN3Dsvgr7kXfUx86
         pOLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=mYfNse3wDv58sLXK/09guTsOeI3IccjdPVlMQiwUdEc=;
        b=hpDxZW3U33vqoyoolNSuLo/bkmQ2rzbQZgCC5Jrq8GlZQgC3MMfLmxyuR/ApdapaA6
         jPzLQyqVXMT7LOPTXfFqq7Wekn3M06raj59sS27klJ2NjuTBpNri+Sb4FrZF5ekLz5iD
         6vjCWK26KoXdqsyxxZDPzXSG9Wa02yd057uzhzYejphAH/bk7rOKYI37ZGtqPnNAsnpz
         OG+PrB44o0O6yTNV9VzRiPjWDVEzqedTm6XbAHzHKF5MKqND0+jlA9lhHNsb88IzNlM8
         rhXWurAjp8zZBsobexrFs3lTDZEwT6trWPdNNXvJn1ihBDpFafQ9vSKJiV2dJw6RaQpl
         pQPg==
X-Gm-Message-State: ACgBeo0V8xz7wsYETgkjkt337Ix+qN6dLl2ErUrUb3HRCJouejoGgpjr
        luxUVRFw0azvD1OmwC/Y1BQz93R/CYQ=
X-Google-Smtp-Source: AA6agR4af2dqJVzoWFhHHXzxj+EOaQIJnrNIr28GU2xcXd/BJ8dbYKT3hMUAdlg82o2nbVphaTFnAkAxVjA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:3086:0:b0:52b:fd6c:a49d with SMTP id
 w128-20020a623086000000b0052bfd6ca49dmr27530149pfw.26.1661310145862; Tue, 23
 Aug 2022 20:02:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:29 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-28-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 27/36] KVM: VMX: Move CPU_BASED_CR8_{LOAD,STORE}_EXITING
 filtering out of setup_vmcs_config()
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
nested VMX MSR setup, move CPU_BASED_CR8_{LOAD,STORE}_EXITING filtering
to vmx_exec_control().

No functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5f5e48d0dbcb..23e237ad3956 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2552,11 +2552,6 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 				MSR_IA32_VMX_PROCBASED_CTLS,
 				&_cpu_based_exec_control))
 		return -EIO;
-#ifdef CONFIG_X86_64
-	if (_cpu_based_exec_control & CPU_BASED_TPR_SHADOW)
-		_cpu_based_exec_control &= ~CPU_BASED_CR8_LOAD_EXITING &
-					   ~CPU_BASED_CR8_STORE_EXITING;
-#endif
 	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) {
 		if (adjust_vmx_controls(KVM_REQUIRED_VMX_SECONDARY_VM_EXEC_CONTROL,
 					KVM_OPTIONAL_VMX_SECONDARY_VM_EXEC_CONTROL,
@@ -4327,13 +4322,17 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
 	if (vmx->vcpu.arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)
 		exec_control &= ~CPU_BASED_MOV_DR_EXITING;
 
-	if (!cpu_need_tpr_shadow(&vmx->vcpu)) {
+	if (!cpu_need_tpr_shadow(&vmx->vcpu))
 		exec_control &= ~CPU_BASED_TPR_SHADOW;
+
 #ifdef CONFIG_X86_64
+	if (exec_control & CPU_BASED_TPR_SHADOW)
+		exec_control &= ~(CPU_BASED_CR8_LOAD_EXITING |
+				  CPU_BASED_CR8_STORE_EXITING);
+	else
 		exec_control |= CPU_BASED_CR8_STORE_EXITING |
 				CPU_BASED_CR8_LOAD_EXITING;
 #endif
-	}
 	if (!enable_ept)
 		exec_control |= CPU_BASED_CR3_STORE_EXITING |
 				CPU_BASED_CR3_LOAD_EXITING  |
-- 
2.37.1.595.g718a3a8f04-goog

