Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDA9369DE9
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244139AbhDXArs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236084AbhDXArn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:47:43 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11245C06138B
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:05 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id g76-20020a379d4f0000b02902e40532d832so9461156qke.20
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=qhJeA9fQsblztcKyPyMtaBD+iwF8KjnP8LQXx6xVt+Y=;
        b=b3hY/U1WaneYQzBX9CN0ubCT32hE7hloWZQl65LI4eOUrh2+bCCLjcGsK2HvWOnJpg
         sBdJcC9mDoOMsLXUUS9kQD/3X5H/CcZLA/Eu6/ssiSu2KlTk+u2hrcofJqqKfoCqCauZ
         u+SI3MhCXDJOhIOavHtb6eda4e+B49L6lq5e/0STCZqREnb3SRT7HHjzTfdatDkVET+/
         0vOobWHTBwTP6Q37Za+FXkozTubZLUJjxuivp2cf6iN2odnT/Uu+Zgij495RzNj/le8U
         R53bGc1k9EXAJf562dRE4GHwbMY6+Cr1bCcZWozxeuEU20vhS16WbFUKio0F/9kLuZfV
         v0nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=qhJeA9fQsblztcKyPyMtaBD+iwF8KjnP8LQXx6xVt+Y=;
        b=CXtJoAFc2FzaPM1zYOqGZ13c6DnTDI+kuXCv6Or9qntUERM0mIhk/XZc01i5UjS3eF
         FVGtEmvThzMYIUEJDjPMDxH/1lJEFU4sIxm3jD46rVW2cBaT9NCFHejVCjN8ksA8L+e2
         bMoWgc6BlfAJ8/I7hSX/bu0tpxby44Qxo+iOX19hHNTGPaMCtzcX6VJUM5yiu9oAsmPr
         0A2I8sFxiIAhkdBmM9AXsSsNWDkr+gFUMeMIvAaEVrUHaY+dT8+2Kn0lrpLlz7mV5vLO
         03py9vMGmNkzj76G/I36+iZK6CEBxFOWjibCeUb8RbrDxaqZLz+1Ed0VNi2Up8RQDa6j
         1BJg==
X-Gm-Message-State: AOAM531YiBoYg/x24goRL2NUeSfP27yOcNOAiVU3QH8ug3wTdMa2zfCt
        +yclUT2YH6+zjX2fP3+RQOLT1GqW9no=
X-Google-Smtp-Source: ABdhPJyDQMKu2bPxJQfGop/kTOzjGyE4dTxY0BImHfkaNpq+Ou8R2DmlzmPCu2WWxy1hBBcaH1nOFkenA/M=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a0c:e950:: with SMTP id n16mr7445105qvo.43.1619225224151;
 Fri, 23 Apr 2021 17:47:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:04 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 02/43] KVM: VMX: Set EDX at INIT with CPUID.0x1, Family-Model-Stepping
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set EDX at RESET/INIT based on the userspace-defined CPUID model when
possible, i.e. when CPUID.0x1.EAX is defined by userspace.  At
RESET/INIT, all CPUs that support CPUID set EDX to the FMS enumerated in
CPUID.0x1.EAX.  If no CPUID match is found, fall back to KVM's default
of 0x600 (Family '6'), which is the least awful approximation of KVM's
virtual CPU model.

Fixes: 6aa8b732ca01 ("[PATCH] kvm: userspace interface")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a182cae71044..9c00d013af59 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4497,6 +4497,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct msr_data apic_base_msr;
+	u32 eax, dummy;
 	u64 cr0;
 
 	vmx->rmode.vm86_active = 0;
@@ -4504,7 +4505,11 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vmx->msr_ia32_umwait_control = 0;
 
-	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
+	eax = 1;
+	if (!kvm_cpuid(vcpu, &eax, &dummy, &dummy, &dummy, true))
+		eax = get_rdx_init_val();
+	kvm_rdx_write(vcpu, eax);
+
 	vmx->hv_deadline_tsc = -1;
 	kvm_set_cr8(vcpu, 0);
 
-- 
2.31.1.498.g6c1eba8ee3d-goog

