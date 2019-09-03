Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55A87A7633
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 23:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbfICVbI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 17:31:08 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:57197 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfICVbI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 17:31:08 -0400
Received: by mail-qk1-f202.google.com with SMTP id n135so20598627qke.23
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 14:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NRnaqKGOMM6Gjnc7Eddxq9QW9f6iAXK8LuOyj+cE24g=;
        b=iFpNFe0/QrFAClgy2Fpt5ofOL4DpAh7cS5HOoXoV1GrZ2Bzsy1pB7NaKvnaURtWpk0
         zeGmNNxNOsQw0PihdfqaMz9q6+mMtLBb7LKHO/hcwLuGERkLasSe84R1lszca1M1zvRV
         lfGIg+OhPFRpDgkpypEdWy6+3ec21iG2HlPLbzDxxTItR6V7uU/S+oDIrQTrWb/sOq/2
         2QjYaxWftu5BZMFxZPSW0hFgXIcH+ovAQ+vIWs6v/IDz+3pYFK+FY0L7Koaf/r5lTPNw
         ZaVgtOxcy4kUroRLbn0zS3oFVch3PKcEhiNa2GLoavn7nByUtqUelkeGMxZmcUma6mp+
         /LTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NRnaqKGOMM6Gjnc7Eddxq9QW9f6iAXK8LuOyj+cE24g=;
        b=tFO1x4Uw7bSaoNA7Fdjy2+y70lqVhLYMN9DwtF2PtOsWaqBn7kKTVW/O97ppZSyUiC
         +LbJyt8Xf88Ijpu61dl5rM2HzhyP0PfTGlxHyEqs09sPCFuiT1tdihaXxqQmtJBKXYEi
         pNmlRUS7suCiZZNTffdYPH9bygYILyh/RWpwvLQ3H3iI+d1oKaWBBTtXh8UILCpJNxI9
         nIQvG2phcEchDuaHGm21OvRReCwVIeuOfzI7aBpy2lQFAhtarR6SSi00WndsA4RUl5v1
         kXx6I19Qj7eTP/Szwmp/3Xd7ORusgLBaFhrq/95FQE3hjLqheEuHgtehp40vJBryLwfS
         7YKg==
X-Gm-Message-State: APjAAAU6RgXbIZzhrARjNEeZNB3vnBU7gCwAX6Q8IqvvxYjcwuwsRTN4
        /qY3qQ8Pues7XPrwDXAJMz1E07xmb9ZP5BG32PJOJA6QNNBZsH3qLT7LR7nZctyo2acx0Sniksm
        hpoqL9FVdlTWuNJrpy974COZXmDWr3xjDypAJ3Yony2C+cVnqZ6iWOeRT8w==
X-Google-Smtp-Source: APXvYqxgbQZS2MbUUPNTuxqFAf4qvyoRF1gTqErEugb+J4ZKRP3OlYyRkKrfroK2nU/Y+m0hX97jj76LFWQ=
X-Received: by 2002:a05:620a:103a:: with SMTP id a26mr33828226qkk.332.1567546266792;
 Tue, 03 Sep 2019 14:31:06 -0700 (PDT)
Date:   Tue,  3 Sep 2019 14:30:37 -0700
In-Reply-To: <20190903213044.168494-1-oupton@google.com>
Message-Id: <20190903213044.168494-2-oupton@google.com>
Mime-Version: 1.0
References: <20190903213044.168494-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v2 1/8] KVM: nVMX: Use kvm_set_msr to load IA32_PERF_GLOBAL_CTRL
 on vmexit
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The existing implementation for loading the IA32_PERF_GLOBAL_CTRL MSR
on VM-exit was incorrect, as the next call to atomic_switch_perf_msrs()
could cause this value to be overwritten. Instead, call kvm_set_msr()
which will allow atomic_switch_perf_msrs() to correctly set the values.

Suggested-by: Jim Mattson <jmattson@google.com>
Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ced9fba32598..b0ca34bf4d21 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3724,6 +3724,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 				   struct vmcs12 *vmcs12)
 {
 	struct kvm_segment seg;
+	struct msr_data msr_info;
 	u32 entry_failure_code;
 
 	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_EFER)
@@ -3800,9 +3801,15 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
 		vcpu->arch.pat = vmcs12->host_ia32_pat;
 	}
-	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
-		vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL,
-			vmcs12->host_ia32_perf_global_ctrl);
+	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) {
+		msr_info.host_initiated = false;
+		msr_info.index = MSR_CORE_PERF_GLOBAL_CTRL;
+		msr_info.data = vmcs12->host_ia32_perf_global_ctrl;
+		if (kvm_set_msr(vcpu, &msr_info))
+			pr_debug_ratelimited(
+				"%s cannot write MSR (0x%x, 0x%llx)\n",
+				__func__, msr_info.index, msr_info.data);
+	}
 
 	/* Set L1 segment info according to Intel SDM
 	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
-- 
2.23.0.187.g17f5b7556c-goog

