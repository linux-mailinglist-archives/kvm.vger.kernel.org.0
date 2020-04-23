Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581D41B57A5
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 11:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgDWJCH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 05:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbgDWJCG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 05:02:06 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E12BC03C1AF;
        Thu, 23 Apr 2020 02:02:06 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mq3so2207251pjb.1;
        Thu, 23 Apr 2020 02:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3yBuzk85/z9zDCE6ag3SE6uEFCV0Yt5L+/cdor7rxKw=;
        b=ja0rElO78jBR/j/CN/aCpQxEo3HBI0RS6iCOfo+o89vWmlwzSwvG2MXQr/bazJ5O4a
         QAGAoBf6p1ce8sU0lp5JYV5hmnBNPuiO2rlPc3xKsru9eoPt5fHFcAChR3pziqdc7dRI
         YrpLEnSqGpfV0n52NiRtzp/kpWmYk5IZwRE3FOnAFSaHRBwrJVN4qIGGVqOfLD7lOqz/
         rsjhHCfupHYBni5OSMkt1u9BuTsu+sspc9Xj1RObaqITdm4jphowyG/5hxVZMSXjyHIH
         yfcJI9Rszwl/T5kNRuDl4rBr42uSYAh8xKE9JiTOg55germPPyoV87AZR0U/z1M18Tfd
         VCPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3yBuzk85/z9zDCE6ag3SE6uEFCV0Yt5L+/cdor7rxKw=;
        b=TWKv/FObvEbcn4Js4jUum6821+t6kZuln1Owywe4/kxCUqCPrTH8X+N9XT+LI7Jy/J
         JLPmocd7+Dc8iXvZr6ncJAO/hyhcnFHJ2ZbDV/ZApZ4t1ZhpL235cUhKewJhtk4TsPcv
         /kHnriB1MNZXkEwawEEoX5r7w4akrbgOkXgGtnNIK8x4OCNtAYkw6hFu36DHNmKm8YP0
         9cF1hclsvURaSwfyvfbhpNX/XXXQ5c1wd9z4yi/r9J5IzNX14a2zDfKguw4Yd3Gns7Ld
         afklsZhzQ3wK9H7P2pxE+5QuYlnCGKdbPIJGP1MeS5J9DyKSYL7xLdjBJPs/F8nS36M7
         09hg==
X-Gm-Message-State: AGi0PuaeVNP03x5WZ28hsFuil5XYZycLsoo7Mh0hus2uzKpH6SOEUNGg
        Gad1Xh3z5kC1Eih2dX/lYNGm17tw
X-Google-Smtp-Source: APiQypJjEKCllb12xS4bqOTu0AkwdEnA6iyBbHZhd4aYE1PfT7hv+ZsVJ+8IPnz5XurCQ0NwVx9OGw==
X-Received: by 2002:a17:90a:315:: with SMTP id 21mr3048994pje.96.1587632525579;
        Thu, 23 Apr 2020 02:02:05 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id w28sm1574204pgc.26.2020.04.23.02.02.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 02:02:05 -0700 (PDT)
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
Subject: [PATCH v2 3/5] KVM: VMX: Introduce generic fastpath handler
Date:   Thu, 23 Apr 2020 17:01:45 +0800
Message-Id: <1587632507-18997-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587632507-18997-1-git-send-email-wanpengli@tencent.com>
References: <1587632507-18997-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Introduce generic fastpath handler to handle MSR fastpath, VMX-preemption 
timer fastpath etc.

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/vmx.c          | 24 +++++++++++++++++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f809763..bcddf93 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -188,6 +188,7 @@ enum {
 enum exit_fastpath_completion {
 	EXIT_FASTPATH_NONE,
 	EXIT_FASTPATH_SKIP_EMUL_INS,
+	EXIT_FASTPATH_CONT_RUN,
 };
 
 struct x86_emulate_ctxt;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fd20cb3..2613e58 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6569,6 +6569,20 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 	}
 }
 
+static enum exit_fastpath_completion vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
+{
+	if (!is_guest_mode(vcpu)) {
+		switch (to_vmx(vcpu)->exit_reason) {
+		case EXIT_REASON_MSR_WRITE:
+			return handle_fastpath_set_msr_irqoff(vcpu);
+		default:
+			return EXIT_FASTPATH_NONE;
+		}
+	}
+
+	return EXIT_FASTPATH_NONE;
+}
+
 bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
 
 static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
@@ -6577,6 +6591,7 @@ static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4;
 
+cont_run:
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!enable_vnmi &&
 		     vmx->loaded_vmcs->soft_vnmi_blocked))
@@ -6743,17 +6758,16 @@ static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
 		return EXIT_FASTPATH_NONE;
 
-	if (!is_guest_mode(vcpu) && vmx->exit_reason == EXIT_REASON_MSR_WRITE)
-		exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
-	else
-		exit_fastpath = EXIT_FASTPATH_NONE;
-
 	vmx->loaded_vmcs->launched = 1;
 	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 
 	vmx_recover_nmi_blocking(vmx);
 	vmx_complete_interrupts(vmx);
 
+	exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
+	if (exit_fastpath == EXIT_FASTPATH_CONT_RUN)
+		goto cont_run;
+
 	return exit_fastpath;
 }
 
-- 
2.7.4

