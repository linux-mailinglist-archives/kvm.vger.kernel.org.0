Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 960CFAC1CC
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 23:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389254AbfIFVDY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 17:03:24 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:55779 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbfIFVDY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 17:03:24 -0400
Received: by mail-pf1-f201.google.com with SMTP id w126so4233465pfd.22
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2019 14:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CNdrlb0ULLVdEI+amDkztM5kVgEihq12ic/7nJruJWA=;
        b=eQfLtdvRyr1zcRwiuY/gGorUEG/JtUGoXsYHtT760bxrpeVvhvwIZpAiedupv8u9eg
         Rpt+Du45VehsyyTfohyp4Mi+qgArouJaudAkf7maOixuKTwqfW8EJZoRWSY958De95sI
         wzCyzmtG5S6F7IDZRnViUQojSMhvN7J0KkZrHxPKb6fshTEbkhVwrsZeTbhIjiNi1wYB
         amHtYP3/Len52v57QMfYA+msg8c157rIVhlYcpFDlXyCwhXRqni+3gux0rcSFJkx8Nq9
         wFWBLgtlORbvAIIFaXde/xgflOUREqGP7ddW5wFL9wfZy2XpxABtNmoglZaWthi59BSi
         cLSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CNdrlb0ULLVdEI+amDkztM5kVgEihq12ic/7nJruJWA=;
        b=HS6WsDn1IlVnz5JWMoWUjXnBXFIvo2+maDswhQSK8fWmzUVsqhKlSfE+vuWWd70Vli
         GNqaEe6wvkrGjoG8lgFEhaBPcraXwue5fHGlVxVz9gMa6e5qM2XmZKLBjJRbDMrYcZt/
         xH5pJFVMOr5KkmHM7/dGZ1OKLqZhBNv8vGwkz+HuteZBO3mhGsxXjcSbDmUa3E2/UsaV
         6HGRlDsPWFnqEv9/xp7NNRZOL1q6xRQf/Gp+KIrSfutR2jUzz6lxk9gBj8AYutEV5T+r
         /r5rjVECuVRBPiKyB8y+h//LvbZjWcK1X2XrchVkHoauV98t06qA2/4osKNL3kXBIVdK
         CJKg==
X-Gm-Message-State: APjAAAW04Q3K8KEyYzAV1Xae/uNjS9JVCpyObn6HSpTvPuzbLuhw9vfg
        NDgNxD+oSRb82uKOT/YtP3kDWczHerMzq7Pl6kKoOsgv73aBGVycmprUst5lenx9cgFXu0Ljn/X
        mpGOvr+KmjWwyAAggVgEv/q9wW2CCuc8Dm5MKoZCxUxAfFGT8e8V8he8FIA==
X-Google-Smtp-Source: APXvYqxal6kWb12vc5ZYGfvikIizmgLlOf/F6n8mtymbjl8QQRHHARbD3za9szERunWq135iI4LNGp0Ygrc=
X-Received: by 2002:a63:b919:: with SMTP id z25mr9563029pge.201.1567803803148;
 Fri, 06 Sep 2019 14:03:23 -0700 (PDT)
Date:   Fri,  6 Sep 2019 14:03:05 -0700
In-Reply-To: <20190906210313.128316-1-oupton@google.com>
Message-Id: <20190906210313.128316-2-oupton@google.com>
Mime-Version: 1.0
References: <20190906210313.128316-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v4 1/9] KVM: nVMX: Use kvm_set_msr to load IA32_PERF_GLOBAL_CTRL
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
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
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

