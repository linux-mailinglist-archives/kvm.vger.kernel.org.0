Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC8F3B6CD8
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 05:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbhF2DNt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 23:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbhF2DNt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 23:13:49 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14916C061574;
        Mon, 28 Jun 2021 20:11:23 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id b1so3608109pls.5;
        Mon, 28 Jun 2021 20:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CrRfjlffFTsErYpyxRU8qsAnfz33rhUg5wGpylT7ibU=;
        b=Px3WCVFBTtBJ58YYng2zaDvLYyFK8jNjPzLmPztobD/ogV6koyfjdzqWonDUQXrg+V
         H87SNvbz6iCahm8x+izb2bKXKGQrH2HHabUfLE+t9h6sGL91L/uVBdlt3NbSeHcEe3Hm
         6fBpk0HmN6jK3PXvGgeQscHOgOB0/sUI8OJFbG/WKGyDa1rJjohbkHgsbnrmekfBurKP
         jDlOmNc2fHGlHibewQPQleRonn4rJR6bAQmT8ssqJnXXIvvd4Gktb59wqGQl7mF44itv
         WkZ5S+m4o/cH1FR8BS+bRdzejGukCuSidsh8sxixFcWP3URo3csUKKqWfPbRaDMZ7LRO
         E8Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CrRfjlffFTsErYpyxRU8qsAnfz33rhUg5wGpylT7ibU=;
        b=XiMAuRZ4usRu3B45d+OdG2tFjjfw40OD35lhSUn8Q8as0GYgPWgMk3ln6tgtL20P1g
         66+/0l4FRnlXNLP0bKlBpJqY3OAHw9CdCj2oaY7gBguNxrzyNlD7h+6oHENzMo5Umbrv
         zpIhWy2Z2z9U7jkiIin1QK7myPMEXynwsGf9+vNSg3Y5BGxBM4jTlmOKIqiqXmPgeV7U
         UOpVmPeoam+K8lwQpyxAUelUUfpDUNC/vaPHPp9EV3QB4GeC0L/oK2EQSZUbmI9P45Xt
         XGiwHKVbA8bbPnxEhTjsnEsiBbEPhd6UmbHqvb8ImJ7ooGUaBzQfBBr7TlnnIs87UyuV
         NhoA==
X-Gm-Message-State: AOAM530Spdh6xP3/YRdDW/1LSj/7STbtlkeK9HeBqwGDX8khrv7CETTy
        77ksiKcddhlgVwetofpY7JahYOxgVyc=
X-Google-Smtp-Source: ABdhPJyMfjaNe7KKQQx2C/XWHqq8R9M5Cx3D2fMYaRDOJSzPCH4mP40rEGAgYsIMlugTXaCldZTN0g==
X-Received: by 2002:a17:90a:10c8:: with SMTP id b8mr40953510pje.147.1624936282502;
        Mon, 28 Jun 2021 20:11:22 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id pj4sm964048pjb.18.2021.06.28.20.11.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Jun 2021 20:11:22 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH] KVM: X86: Also reload the debug registers before kvm_x86->run() when the host is using them
Date:   Tue, 29 Jun 2021 01:26:32 +0800
Message-Id: <20210628172632.81029-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

When the host is using debug registers but the guest is not using them
nor is the guest in guest-debug state, the kvm code does not reset
the host debug registers before kvm_x86->run().  Rather, it relies on
the hardware vmentry instruction to automatically reset the dr7 registers
which ensures that the host breakpoints do not affect the guest.

But there are still problems:
	o The addresses of the host breakpoints can leak into the guest
	  and the guest may use these information to attack the host.

	o It violates the non-instrumentable nature around VM entry and
	  exit.  For example, when a host breakpoint is set on
	  vcpu->arch.cr2, #DB will hit aftr kvm_guest_enter_irqoff().

Beside the problems, the logic is not consistent either. When the guest
debug registers are active, the host breakpoints are reset before
kvm_x86->run(). But when the guest debug registers are inactive, the
host breakpoints are delayed to be disabled.  The host tracing tools may
see different results depending on there is any guest running or not.

To fix the problems, we also reload the debug registers before
kvm_x86->run() when the host is using them whenever the guest is using
them or not.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b594275d49b5..cce316655d3c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9320,7 +9320,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
 		switch_fpu_return();
 
-	if (unlikely(vcpu->arch.switch_db_regs)) {
+	if (unlikely(vcpu->arch.switch_db_regs || hw_breakpoint_active())) {
 		set_debugreg(0, 7);
 		set_debugreg(vcpu->arch.eff_db[0], 0);
 		set_debugreg(vcpu->arch.eff_db[1], 1);
-- 
2.19.1.6.gb485710b

