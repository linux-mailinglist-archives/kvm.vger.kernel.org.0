Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C357435BE
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 09:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbjF3H1b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 03:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjF3H13 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 03:27:29 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227A51719
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 00:27:03 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b7fb02edfaso12208525ad.3
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 00:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1688110022; x=1690702022;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8mEELwdQindlf7xg/IMqwTyqbfz0eVgKGIMBcG08iKg=;
        b=eE+DJAwbkGlJCVYEPNu+LmqM/n/NItRhcXq11ZxsYe+B4dOMkgkvUE5O7pl6EOHwln
         quWLhOiabuxIN/5RdFHO0JDVyU3EpWnEG+RPnxF7a2oge/r5+iwYgTbJMYUfOKmLtcVy
         X21eHwDkA6sGo9JxsZP9UXmZjbDPDTuretgzjiNYk4V/iJjEVaF2+HHvpaCEoTQ4WxM8
         DGH7pZUs+rNQHQYIKwL77fxqLLeVZnkzg07JVXOPrhaqCXv3nXLUhydEfU5SXR7okfZe
         dVEh4C8BFdbSUQxT3Dw/p/JOzzZ2Z3/IUMZwcf9CyjMVOru/I7utKDLMTVc4mVYzUtPa
         F4aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688110022; x=1690702022;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8mEELwdQindlf7xg/IMqwTyqbfz0eVgKGIMBcG08iKg=;
        b=ZtvAcks9ChgJ/xqaG31vg8PKmkuE8JATHN4ZtaIKv2FUL9IZqbSEjzafTy63jfwcGv
         hGpYevQjyi1rji0s7Kup5K4ppj0yZojOhQ17s8LlzBO8Uwg9oW1op0oesrwivnI6VxiB
         GEjyMwskkXw3stMWWNTPdD0d8+39O1bVGPLMQOJnS2IxUenV4eY7dRUaEF3kcTbWKirG
         oWDCzNMrl4Y7g6b+GCQwKM6TrFSIXmUz85ef5B/6H+HvBhwW6pIgSr6COxKIl9nB9O2t
         ruQK3JQp0ATl/jzrOeLwVK2rYKAoFsxN8huWVGGTNV0J6gm2ms1kKRHURQBhMSZdgfT+
         Dd3A==
X-Gm-Message-State: ABy/qLY81E3kceq3ubNUflQ2hidYUtxnZLS9v6Qv9kYArHsgKYJOPR5X
        mR15VXUXJPRogL7xywb1i9wsf3nZViG7qWrOXrFRThE5
X-Google-Smtp-Source: APBJJlFijXjSJm728y7ZAACSO65NVZ0wV+LEifXJ6iVRuOVHmRX61HnTyxpcDFBJFm0OD9p8QM/J2A==
X-Received: by 2002:a17:902:b714:b0:1b7:fd82:973c with SMTP id d20-20020a170902b71400b001b7fd82973cmr1323130pls.39.1688110022649;
        Fri, 30 Jun 2023 00:27:02 -0700 (PDT)
Received: from n157-102-137.byted.org ([240e:b1:e401:3::d4])
        by smtp.gmail.com with ESMTPSA id jo16-20020a170903055000b001993a1fce7bsm10158392plb.196.2023.06.30.00.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jun 2023 00:27:02 -0700 (PDT)
From:   Qi Ai <aiqi.i7@bytedance.com>
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, kvm@vger.kernel.org
Cc:     fengzhimin@bytedance.com, cenjiahui@bytedance.com,
        fangying.tommy@bytedance.com, dengqiao.joey@bytedance.com,
        Qi Ai <aiqi.i7@bytedance.com>
Subject: [PATCH] kvm/x86: clear hlt for intel cpu when resetting vcpu
Date:   Fri, 30 Jun 2023 15:26:12 +0800
Message-Id: <20230630072612.1106705-1-aiqi.i7@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

when cpu-pm=on is set in qemu, if a crash occurs within the guest,
after kdump has collected the vmcore, the system will be reset.
the ActivityState in the VMCS is set to HLT, because the guest executed
the halt instruction. however, ActivityState is not set to Active
before the restart, resulting in the cpu being in an inactive state
where it doesn't execute instructions.

in the __set_regs function, check whether a reset will occurs.
if it is, set the ActivityState to Active, which ensures that the cpu will
be executing instructions normally.

Signed-off-by: Qi Ai <aiqi.i7@bytedance.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/vmx/vmx.c          | 2 ++
 arch/x86/kvm/x86.c              | 6 ++++++
 3 files changed, 10 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fb9d1f2d6136..db5a47500b08 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1731,6 +1731,8 @@ struct kvm_x86_ops {
 	 * Returns vCPU specific APICv inhibit reasons
 	 */
 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
+
+	void (*clear_hlt)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44fb619803b8..11c2fde1ad98 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8266,6 +8266,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+
+	.clear_hlt = vmx_clear_hlt,
 };
 
 static unsigned int vmx_handle_intel_pt_intr(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7f70207e8689..21360f5ed006 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11258,6 +11258,12 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	vcpu->arch.exception_vmexit.pending = false;
 
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
+
+	if (kvm_x86_ops.clear_hlt) {
+		if (kvm_vcpu_is_bsp(vcpu) && regs->rip == 0xfff0 &&
+				!is_protmode(vcpu))
+			kvm_x86_ops.clear_hlt(vcpu);
+	}
 }
 
 int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
-- 
2.20.1

