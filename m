Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B44A1B6E15
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 08:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgDXGXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 02:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725889AbgDXGXD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 02:23:03 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA185C09B045;
        Thu, 23 Apr 2020 23:23:02 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o10so4160699pgb.6;
        Thu, 23 Apr 2020 23:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ViOwz5HrCB25jkfYhffFx9rLlViHm455phEHkJXKIN4=;
        b=iD9AF3OBaONzspPWNY0pchF6vRr8q4e5zkrRpUrCRKJYzZQeZ1zPkiWUxoLV6P/htr
         jrQ9hnwBPlF++tQYZ8Nqb4fh9kPS4n1Rbvyu3BJ8xqqV1y/c6fFiIDU0eAsuE+9XGG0F
         6i3wSH77/ToEurtsNarwBP20GttXP+SmbEMIM6uJzZhDApTiG+RvXQXCOJoLTeXy2ctl
         ejSd5FrMVT+rGI6np574ejgW6AN7FSvUUmOtqLOB0MAZG02SgOlDMgHOn/YxsWyauN9K
         ZNzKHF5+59S5QbLVCBU6pYPi+5UXiBAOk+A4ejS9T9FGEPYOY/qdJLNmSqr6PMPxOY2G
         yySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ViOwz5HrCB25jkfYhffFx9rLlViHm455phEHkJXKIN4=;
        b=CuhySjMjqyibCR9k9qNiRKdPmI5/gDUEMxbm3wS3SyCyW0iDFz5UTXFTbHE5eskATA
         gXkJpHQ/3xlERY1P5B2vPOOdkPlSUOifkmn3dcAM4RMkWkne0IRsFJPipcHnxMyK2BAs
         Wku9bvsA6yjmq739Tt5hW10QzreX3rSe+3FdmVZBqndDe6s1jWNz3AjDa3WNCBInKEhN
         /GcFAeDqDdFQtDFKrwdJwPowlR4FPmo9gpwwoLR5toMrTagDI8ITD/cGyXlmk60gqfC/
         ZQ7WTBXvXlmL3fFe7l25v1FrXTwF3rABUI+mrCO2ai/dGTttsXlTE0XQw3HcZ/Q1LOBP
         orGQ==
X-Gm-Message-State: AGi0PuYr489Raoj2wr9kQlByRlNkHAwnkrTcwkB2t1w6K4dDQ7OgJEHy
        t0hxLnmjzXHvgU02mGxmAk4g9CBI
X-Google-Smtp-Source: APiQypLVdC9f0/O/QQJ4vta+2X9cuV9mYMffkIeANatQWpdlP5SeJ6CvlEcEX/fbQVqplVpOpyqfJQ==
X-Received: by 2002:a62:2b05:: with SMTP id r5mr7418621pfr.120.1587709382043;
        Thu, 23 Apr 2020 23:23:02 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id l30sm3920674pgu.29.2020.04.23.23.22.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 23:23:01 -0700 (PDT)
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
Subject: [PATCH v3 2/5] KVM: X86: Introduce need_cancel_enter_guest helper
Date:   Fri, 24 Apr 2020 14:22:41 +0800
Message-Id: <1587709364-19090-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587709364-19090-1-git-send-email-wanpengli@tencent.com>
References: <1587709364-19090-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Introduce need_cancel_enter_guest() helper, we need to check some 
conditions before doing CONT_RUN, in addition, it can also catch 
the case vmexit occurred while another event was being delivered 
to guest software since vmx_complete_interrupts() adds the request 
bit.

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 12 +++++++-----
 arch/x86/kvm/x86.c     | 10 ++++++++--
 arch/x86/kvm/x86.h     |  1 +
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f1f6638..5c21027 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6577,7 +6577,7 @@ bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
 
 static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
-	enum exit_fastpath_completion exit_fastpath;
+	enum exit_fastpath_completion exit_fastpath = EXIT_FASTPATH_NONE;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4;
 
@@ -6754,10 +6754,12 @@ static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx_recover_nmi_blocking(vmx);
 	vmx_complete_interrupts(vmx);
 
-	exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
-	/* static call is better with retpolines */
-	if (exit_fastpath == EXIT_FASTPATH_CONT_RUN)
-		goto cont_run;
+	if (!kvm_need_cancel_enter_guest(vcpu)) {
+		exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
+		/* static call is better with retpolines */
+		if (exit_fastpath == EXIT_FASTPATH_CONT_RUN)
+			goto cont_run;
+	}
 
 	return exit_fastpath;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 59958ce..4561104 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1581,6 +1581,13 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
 
+bool kvm_need_cancel_enter_guest(struct kvm_vcpu *vcpu)
+{
+	return (vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu)
+	    || need_resched() || signal_pending(current));
+}
+EXPORT_SYMBOL_GPL(kvm_need_cancel_enter_guest);
+
 /*
  * The fast path for frequent and performance sensitive wrmsr emulation,
  * i.e. the sending of IPI, sending IPI early in the VM-Exit flow reduces
@@ -8373,8 +8380,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
 		kvm_x86_ops.sync_pir_to_irr(vcpu);
 
-	if (vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu)
-	    || need_resched() || signal_pending(current)) {
+	if (kvm_need_cancel_enter_guest(vcpu)) {
 		vcpu->mode = OUTSIDE_GUEST_MODE;
 		smp_wmb();
 		local_irq_enable();
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 7b5ed8e..1906e7e 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -364,5 +364,6 @@ static inline bool kvm_dr7_valid(u64 data)
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
+bool kvm_need_cancel_enter_guest(struct kvm_vcpu *vcpu);
 
 #endif
-- 
2.7.4

