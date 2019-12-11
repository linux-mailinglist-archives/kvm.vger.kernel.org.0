Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D72E911BE76
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 21:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfLKUtZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 15:49:25 -0500
Received: from mail-ua1-f73.google.com ([209.85.222.73]:37496 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727376AbfLKUtI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 15:49:08 -0500
Received: by mail-ua1-f73.google.com with SMTP id q23so6575648uar.4
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 12:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dcdfpo/SN401J0ADf28PICm6rQuV1bm1m38AbFi1Sng=;
        b=v3TMDN4qBJP3ynZ8Qz07hxFn0g7CmdhMrFlr6NODGSx4qxZOgw/U1dSWChJLsNoBFU
         7o8pV4BMWbpBqjD6gu4Gdmv0xE/OBK1gccVoJ0bnS3ZRZnWGPo5T2Px1Q6YSdeaaL4Zb
         Am8YnUqJMTkV0PHCV/SkNcfObE9Rzx04NJNKADv8xjkDDtIr6nG6BQUEUNgcAx2S0btH
         ozH1FeW6BVukSfrh2iRl1Qgt8SyV5gxfnZDQdMSMZKXnJiDbXITVNibsl0Li6HSAkLlm
         boO17LswojP4waDI6My0MeA5ulsFh2uTc/I7tVczPcIGjUicNyH4KSSJs3JrD2/CqNVR
         GYeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dcdfpo/SN401J0ADf28PICm6rQuV1bm1m38AbFi1Sng=;
        b=ByZwKfe6Jj5S6xXQz+t8NYbU2FmJZkbacONeKNWPG5+Hfa4kI0ANmlde0ebX82S05j
         GwOkuwSWObL0puyQm1D5ghoK1lrCLgtJv6gmKZkfBI8Xc5n+66rQbhCviyB/kHqDTJ9q
         +oMfWgImNyxxDj3KbKigaq4C9RJvOv4LQch6kS4862XRFsd0yN2Xt3joIY2YvvLayuus
         JOgISw15NfZVwHseNzim5SLFk6Ny95utaOKEWLHxf7Y6t3er/8KnP8Mlf6SDNaMS+zjr
         9MLlt6bx7gsdoL3BT/ejW/MGvkXVmg+4pMBX9O/0xGnAJtd7caP7tSYHviBCVfnhjudw
         dLWg==
X-Gm-Message-State: APjAAAXrtYr8JLHzsox8/9k4jwDafw7lsD9z2kjUW5MLBF+MDISeZnsW
        jJfYORCMkB+N0cgyFwO5QjyDDqQDtjBH
X-Google-Smtp-Source: APXvYqzjD7iLTfwDWn+XE1jFSwfRs9TIrn3KfDXaYEgjRYFqoUbAWMKL38XdPFyOM/7T7xlp2u+Dzp5GDaUe
X-Received: by 2002:a67:bd13:: with SMTP id y19mr4440913vsq.143.1576097346928;
 Wed, 11 Dec 2019 12:49:06 -0800 (PST)
Date:   Wed, 11 Dec 2019 12:47:51 -0800
In-Reply-To: <20191211204753.242298-1-pomonis@google.com>
Message-Id: <20191211204753.242298-12-pomonis@google.com>
Mime-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com>
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae-goog
Subject: [PATCH v2 11/13] KVM: x86: Protect exit_reason from being used in
 Spectre-v1/L1TF attacks
From:   Marios Pomonis <pomonis@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Finco <nifi@google.com>, Andrew Honig <ahonig@google.com>,
        Marios Pomonis <pomonis@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This fixes a Spectre-v1/L1TF vulnerability in vmx_handle_exit().
While exit_reason is set by the hardware and therefore should not be
attacker-influenced, an unknown exit_reason could potentially be used to
perform such an attack.

Fixes: commit 55d2375e58a6 ("KVM: nVMX: Move nested code to dedicated files")

Signed-off-by: Marios Pomonis <pomonis@google.com>
Signed-off-by: Nick Finco <nifi@google.com>
Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kvm/vmx/vmx.c | 55 +++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 82b25f1812aa..78f2fef97d93 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5918,34 +5918,39 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	if (exit_reason < kvm_vmx_max_exit_handlers
-	    && kvm_vmx_exit_handlers[exit_reason]) {
+	if (exit_reason >= kvm_vmx_max_exit_handlers)
+		goto unexpected_vmexit;
 #ifdef CONFIG_RETPOLINE
-		if (exit_reason == EXIT_REASON_MSR_WRITE)
-			return kvm_emulate_wrmsr(vcpu);
-		else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
-			return handle_preemption_timer(vcpu);
-		else if (exit_reason == EXIT_REASON_PENDING_INTERRUPT)
-			return handle_interrupt_window(vcpu);
-		else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
-			return handle_external_interrupt(vcpu);
-		else if (exit_reason == EXIT_REASON_HLT)
-			return kvm_emulate_halt(vcpu);
-		else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
-			return handle_ept_misconfig(vcpu);
+	if (exit_reason == EXIT_REASON_MSR_WRITE)
+		return kvm_emulate_wrmsr(vcpu);
+	else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
+		return handle_preemption_timer(vcpu);
+	else if (exit_reason == EXIT_REASON_PENDING_INTERRUPT)
+		return handle_interrupt_window(vcpu);
+	else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
+		return handle_external_interrupt(vcpu);
+	else if (exit_reason == EXIT_REASON_HLT)
+		return kvm_emulate_halt(vcpu);
+	else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
+		return handle_ept_misconfig(vcpu);
 #endif
-		return kvm_vmx_exit_handlers[exit_reason](vcpu);
-	} else {
-		vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
-				exit_reason);
-		dump_vmcs();
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror =
+
+	exit_reason = array_index_nospec(exit_reason,
+					 kvm_vmx_max_exit_handlers);
+	if (!kvm_vmx_exit_handlers[exit_reason])
+		goto unexpected_vmexit;
+
+	return kvm_vmx_exit_handlers[exit_reason](vcpu);
+
+unexpected_vmexit:
+	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n", exit_reason);
+	dump_vmcs();
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror =
 			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
-		vcpu->run->internal.ndata = 1;
-		vcpu->run->internal.data[0] = exit_reason;
-		return 0;
-	}
+	vcpu->run->internal.ndata = 1;
+	vcpu->run->internal.data[0] = exit_reason;
+	return 0;
 }
 
 /*
-- 
2.24.0.525.g8f36a354ae-goog

