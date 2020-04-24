Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0AF1B6E17
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 08:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgDXGXG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 02:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726665AbgDXGXG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 02:23:06 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAFAFC09B047;
        Thu, 23 Apr 2020 23:23:05 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 18so3104325pfv.8;
        Thu, 23 Apr 2020 23:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zsPf//Pz+Ikh6+DsYPyUBP5glvQEMcSomDR2Wz5ze9I=;
        b=mSBtBjduNX75Q8OPv0HvHykSL62EEwkpC7HS/ITEACsut+AYwVLLBPMn0lKKb6YjVk
         b0w4uYU1Mi3+aX76+Yldo98XKTAYA/8//z/hk53fOkn6I1fYaLEK3/FKsG25ZzPAwQjB
         o1aqF3s56c+2xx7kpSXXtpHbJ7bF7uZ39ff7ABCleS+Gycqz5D1INBJxz+yUwRHva7Dg
         PkN2XR2r8a2SLfAQVIfKdE+6VKwYo9lnGoSwSA19O8nbT6s2TIXM6z1tXnUg/5ERfsX1
         Yt973ARfSZDV89nTe8wPdROMoBBTVTIB039HvOmYHpOOpOTkhmC/dflxB6fMeMByKgWY
         Q84w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zsPf//Pz+Ikh6+DsYPyUBP5glvQEMcSomDR2Wz5ze9I=;
        b=bvgNIdGE0Whfgto5Uh9paCCO6/udGxHjvsCp/HOG46LffyVy7Yq3etSaUeGu1pl3kw
         lgP/DYB7qWDVzwOuqd2rk/a7LGz9cHoA/QNslZZYt+sbjK3Ep8PwM3aFM9qEerqG9m13
         58sJyI4TjRD4ZRGWOthWWHNodrP+/HP76g9wtOopAbiPWyguM8wbtnSbu20SchkGEPYc
         OH/b2jLHXgRS7tTc3jrfJD+a/4jCcZrW9sKvSTSJaoKhLI2pIU+YFJHWbmwJTBp0uBpx
         fAVMaG2EUxTMbzs/Tfl/6e9LbLsFyicrT+fcN/HBFbMG7EuTm0jdxlZcOUmBmLAp7h9k
         g7sQ==
X-Gm-Message-State: AGi0PuZru2ASqSw8Ze+BrlSnuCbFsyRpy9nY0EBZ1YeEDGE/JTfFgUYg
        MOpmVvmynoM0Ejc2aLz51UigKYY4
X-Google-Smtp-Source: APiQypJ1ixZkeAqhQDfMzttF2Fw3E7k+vFcjhPVtqlT3SLiCtjcXny5qyc20qxRsSEd27zZLt9KPlQ==
X-Received: by 2002:a62:34c1:: with SMTP id b184mr7844399pfa.73.1587709385259;
        Thu, 23 Apr 2020 23:23:05 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id l30sm3920674pgu.29.2020.04.23.23.23.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 23:23:04 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH v3 3/5] KVM: VMX: Optimize posted-interrupt delivery for timer fastpath
Date:   Fri, 24 Apr 2020 14:22:42 +0800
Message-Id: <1587709364-19090-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587709364-19090-1-git-send-email-wanpengli@tencent.com>
References: <1587709364-19090-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Optimizing posted-interrupt delivery especially for the timer fastpath 
scenario, I observe kvm_x86_ops.deliver_posted_interrupt() has more latency 
then vmx_sync_pir_to_irr() in the case of timer fastpath scenario, since 
it needs to wait vmentry, after that it can handle external interrupt, ack 
the notification vector, read posted-interrupt descriptor etc, it is slower 
than evaluate and delivery during vmentry immediately approach. Let's skip 
sending interrupt to notify target pCPU and replace by vmx_sync_pir_to_irr() 
before each cont_run.

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 9 ++++++---
 virt/kvm/kvm_main.c    | 1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5c21027..d21b66b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3909,8 +3909,9 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 	if (pi_test_and_set_on(&vmx->pi_desc))
 		return 0;
 
-	if (!kvm_vcpu_trigger_posted_interrupt(vcpu, false))
-		kvm_vcpu_kick(vcpu);
+	if (vcpu != kvm_get_running_vcpu() &&
+		!kvm_vcpu_trigger_posted_interrupt(vcpu, false))
+		kvm_vcpu_kick(vcpu);
 
 	return 0;
 }
@@ -6757,8 +6758,10 @@ static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (!kvm_need_cancel_enter_guest(vcpu)) {
 		exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
 		/* static call is better with retpolines */
-		if (exit_fastpath == EXIT_FASTPATH_CONT_RUN)
+		if (exit_fastpath == EXIT_FASTPATH_CONT_RUN) {
+			vmx_sync_pir_to_irr(vcpu);
 			goto cont_run;
+		}
 	}
 
 	return exit_fastpath;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e7436d0..6a289d1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4633,6 +4633,7 @@ struct kvm_vcpu *kvm_get_running_vcpu(void)
 
 	return vcpu;
 }
+EXPORT_SYMBOL_GPL(kvm_get_running_vcpu);
 
 /**
  * kvm_get_running_vcpus - get the per-CPU array of currently running vcpus.
-- 
2.7.4

