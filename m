Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42275A71A4
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbiH3XS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbiH3XSJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:18:09 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE0BA2A94
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:51 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id dc10-20020a056a0035ca00b0053870674be9so2350461pfb.12
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=yHBXyjuddZA0FtZxUuLwswfl5TgUYOyURvfnTVyRG1I=;
        b=g3u3SzNGQyYsW/HvOKTnjTobfUSMtxKIIwXr4GOoPY9xa5lrtiZ7K8mV2OnLnGeFtq
         +WcD60MaanYsLmteb7PWxw7jQ1VbLvPyDlOTBpyth6nRg1lL1mMeUdIyb2LZKS37TkjN
         qqhzPmmJYmkpuCyje8Tx8vx2WRmqLBs44Qc/0iVcJKpg5p/Gg70XdvyOvVyU7Ep4kAfE
         xiV22ilsA3TtmvUImdSXl6lQHMYJlAXIgn4Rm92lLVSnYhGJH3xIjwcEsL02S2MZeLa7
         KzCMxzWfPTwRWCdEc+rsuCvMuYy3iWp0D3FF8S8JaNGZ07+stOdbrt3B1MODUGPsKb7I
         IkBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=yHBXyjuddZA0FtZxUuLwswfl5TgUYOyURvfnTVyRG1I=;
        b=eaXZ/uEegOuTOlDQYmKMfC6ofhltZmthhKuysX2LLG1sQDC066il7UtXS/WRaGDOir
         4Dwccss6B2NBotyl13AcT2hdC9vj3XBonfa+lyLRPhuIHk2GmwdkHmY0NSDaxl5WHMlz
         Nv2xDeuaWQaDF+ctosNVbS73zkogv7K35INJ49DimEJIw9Fu9WstecGuPUe4LMQR7JjM
         58nNsuMl+gGcAgw71vXOS6k2fV6dcCyy8D3FF5FcV96DIBmuKdDC0eBppMm8vZh2m4Ok
         sopppLmhfsqeKGh9vBE+I3JJN4cG1IIBBBWpPmViAWm+lktclugsLUcBbRqxsGPBZgzl
         zJeg==
X-Gm-Message-State: ACgBeo3eRinbBCljIF1/XxLZ14ALzVmjgNiQh+gnCXF1SClUh2i8RThd
        Aq5Khkmgb95isZ/jo1WokvALP7D+/nc=
X-Google-Smtp-Source: AA6agR7d6N9CT5D77KX6PME7R5fE0PdmC0Ng3N1TKCPTVk5cGRVHpLA1hZRdYgOLiiP8HGL7h7b+lq6GKfo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1c86:b0:538:b52:b494 with SMTP id
 y6-20020a056a001c8600b005380b52b494mr15505950pfw.49.1661901398839; Tue, 30
 Aug 2022 16:16:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:16:00 +0000
In-Reply-To: <20220830231614.3580124-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830231614.3580124-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830231614.3580124-14-seanjc@google.com>
Subject: [PATCH v5 13/27] KVM: x86: Rename kvm_x86_ops.queue_exception to inject_exception
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename the kvm_x86_ops hook for exception injection to better reflect
reality, and to align with pretty much every other related function name
in KVM.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 2 +-
 arch/x86/include/asm/kvm_host.h    | 2 +-
 arch/x86/kvm/svm/svm.c             | 4 ++--
 arch/x86/kvm/vmx/vmx.c             | 4 ++--
 arch/x86/kvm/x86.c                 | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 51f777071584..82ba4a564e58 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -67,7 +67,7 @@ KVM_X86_OP(get_interrupt_shadow)
 KVM_X86_OP(patch_hypercall)
 KVM_X86_OP(inject_irq)
 KVM_X86_OP(inject_nmi)
-KVM_X86_OP(queue_exception)
+KVM_X86_OP(inject_exception)
 KVM_X86_OP(cancel_injection)
 KVM_X86_OP(interrupt_allowed)
 KVM_X86_OP(nmi_allowed)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c96c43c313a..71b65b8bb8cc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1523,7 +1523,7 @@ struct kvm_x86_ops {
 				unsigned char *hypercall_addr);
 	void (*inject_irq)(struct kvm_vcpu *vcpu, bool reinjected);
 	void (*inject_nmi)(struct kvm_vcpu *vcpu);
-	void (*queue_exception)(struct kvm_vcpu *vcpu);
+	void (*inject_exception)(struct kvm_vcpu *vcpu);
 	void (*cancel_injection)(struct kvm_vcpu *vcpu);
 	int (*interrupt_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
 	int (*nmi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f3813dbacb9f..a9d3d5a5137f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -461,7 +461,7 @@ static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static void svm_queue_exception(struct kvm_vcpu *vcpu)
+static void svm_inject_exception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned nr = vcpu->arch.exception.nr;
@@ -4798,7 +4798,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.patch_hypercall = svm_patch_hypercall,
 	.inject_irq = svm_inject_irq,
 	.inject_nmi = svm_inject_nmi,
-	.queue_exception = svm_queue_exception,
+	.inject_exception = svm_inject_exception,
 	.cancel_injection = svm_cancel_injection,
 	.interrupt_allowed = svm_interrupt_allowed,
 	.nmi_allowed = svm_nmi_allowed,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7f3581960eb5..be4348fa176c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1684,7 +1684,7 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
 		vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
 }
 
-static void vmx_queue_exception(struct kvm_vcpu *vcpu)
+static void vmx_inject_exception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned nr = vcpu->arch.exception.nr;
@@ -8080,7 +8080,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.patch_hypercall = vmx_patch_hypercall,
 	.inject_irq = vmx_inject_irq,
 	.inject_nmi = vmx_inject_nmi,
-	.queue_exception = vmx_queue_exception,
+	.inject_exception = vmx_inject_exception,
 	.cancel_injection = vmx_cancel_injection,
 	.interrupt_allowed = vmx_interrupt_allowed,
 	.nmi_allowed = vmx_nmi_allowed,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 39d3eadc43a2..24b538b8b0ee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9713,7 +9713,7 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 
 	if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
 		vcpu->arch.exception.error_code = false;
-	static_call(kvm_x86_queue_exception)(vcpu);
+	static_call(kvm_x86_inject_exception)(vcpu);
 }
 
 static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
-- 
2.37.2.672.g94769d06f0-goog

