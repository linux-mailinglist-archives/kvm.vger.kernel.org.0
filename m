Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F203B1B6E14
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 08:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgDXGXA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 02:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726008AbgDXGW7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 02:22:59 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5FB5C09B045;
        Thu, 23 Apr 2020 23:22:59 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x2so612902pfx.7;
        Thu, 23 Apr 2020 23:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UFT0hKfL7iS8UZisqhI7Q6xNbcamwNw/NX1yQQKe78k=;
        b=r9EXwphqugPnCRsU9hun3rEjYYMPFF5n3SJRgkB06t8M1LLomn2v/KHS7FYZ8QsaTF
         OZhrIsF24j2K9W3BvcBzWpkJtNptx2ECz0VvKoqPNqW571yWQ2gxidDiGKd90GltpbT3
         I/EZLu/35Vf74VFUQ3hWOw2BggmuQXaNuV7nNg+7nghNldbyuqGqm3JkFx93pMoOBnRG
         kVg3X6koFKGnLYCClKcFJFLoSBpP78pbnKyeOLI+MrkWrs1NCcaQekDcQM35UBP89ncS
         Zn7IO01wHLBh3q46+r/kwkxK56XEoejS7l+C5IEM6p5L8LqZ2dUOwcii/oAsRVwv0dvS
         s3Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UFT0hKfL7iS8UZisqhI7Q6xNbcamwNw/NX1yQQKe78k=;
        b=hzrja8lhh1APcRERjiMLdVltbQ1waWo8pxW+YeKNvPBJqKXnwvzqut8EIrcukj4sFJ
         EIgIeJx4h4VKXdk/BTwWl6YqVl6zNpPhFNLqZS8X2TFuJY5iFCJ/61KQwdrM+gtdKbQ8
         sa2iIwcUqAAJlhTvPbdYolBdJbQJjM4Svol7O9uYakisblVZDQm6YPQoT05uNdvIYezj
         QKk+OzFEE0/VY9/Lil88D7WCJ5UjA5Ozs/tpUUWHL2K7Z7QjVX3j2OEJSwVW0q1Bww/K
         d44UNgz8l1aUq90rENueYbWmEHIs9G2T3lOO5jpOrzlDtOonqGD8VM6a5BbVjwLi4Li8
         SPSg==
X-Gm-Message-State: AGi0PubhdLFATJwf6eZo7uXZwkn2cFM9ztB1bAD5f7q7Vo5TnCplzDCF
        y2LfON2OTRX8dUy71YnXF88DqRrH
X-Google-Smtp-Source: APiQypJxuwuvFp5xaaFdP2nRbicoYJCzqR9KIgDJ6O55/vXmZ012YMWjjUMzMCASJnAKzYj6mBRriw==
X-Received: by 2002:a62:7656:: with SMTP id r83mr7763612pfc.71.1587709378973;
        Thu, 23 Apr 2020 23:22:58 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id l30sm3920674pgu.29.2020.04.23.23.22.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 23:22:58 -0700 (PDT)
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
Subject: [PATCH v3 1/5] KVM: VMX: Introduce generic fastpath handler
Date:   Fri, 24 Apr 2020 14:22:40 +0800
Message-Id: <1587709364-19090-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587709364-19090-1-git-send-email-wanpengli@tencent.com>
References: <1587709364-19090-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Introduce generic fastpath handler to handle MSR fastpath, VMX-preemption 
timer fastpath etc. In addition, we can't observe benefit from single 
target IPI fastpath when APICv is disabled, let's just enable IPI and 
Timer fastpath when APICv is enabled for now.

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/vmx.c          | 25 ++++++++++++++++++++-----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f26df2c..6397723 100644
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
index 766303b..f1f6638 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6559,6 +6559,20 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 	}
 }
 
+static enum exit_fastpath_completion vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
+{
+	if (!is_guest_mode(vcpu) && vcpu->arch.apicv_active) {
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
@@ -6567,6 +6581,7 @@ static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4;
 
+cont_run:
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!enable_vnmi &&
 		     vmx->loaded_vmcs->soft_vnmi_blocked))
@@ -6733,17 +6748,17 @@ static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
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
+	/* static call is better with retpolines */
+	if (exit_fastpath == EXIT_FASTPATH_CONT_RUN)
+		goto cont_run;
+
 	return exit_fastpath;
 }
 
-- 
2.7.4

