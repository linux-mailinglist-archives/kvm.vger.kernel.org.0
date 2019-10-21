Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD5A6DF8AD
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 01:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730146AbfJUXdi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 19:33:38 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:37916 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730065AbfJUXdi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 19:33:38 -0400
Received: by mail-pl1-f201.google.com with SMTP id g7so9527722plo.5
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 16:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+euOV+yQbmygdL/W9Lq4YFTr9VDNdGBFe2FjPsUWIWc=;
        b=YtcwnjEivmvZNe0dDfSoZWj8bmip+CvuCRC1d4/ME4+WVxSBV2ZCmVWk5EICFQBVfi
         OKs2Zu6a9NfkgAbAfw3ffhJo9CVBt+ODG6J1ERE9uvTQYezxQyDLB0jpYSJrI2tdM6ST
         XG3Nmx0SxvhsSPinY/LEbgaDuLAeAVCGTjdm/P2v+kxj2olNPN0v0m5o7UHn6apETCsd
         nliTKNWNVr1rjd8YUqpdnBgMGa+y47eyz3ruTkwd715PdH6sNv4TqtTYIPY49MhuH/rz
         bOZU888ZnFlsV5zFeUCgNDNxO8vykuzr4TSmxzLNMO2NDHt9V/febEIrCizy9c2gm8uR
         EHfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+euOV+yQbmygdL/W9Lq4YFTr9VDNdGBFe2FjPsUWIWc=;
        b=DKPZZo2be6qH0t6qenYvehKRDetSBk8tSQhRBacPsLgnIMsXkIfWFAIu1XWWPhTo6E
         /Vda5w7UvwiTew/L8jya7dCwqOQwKD+GKiiWbh9jRt1GxCMLH4m6Ad3fMjnqPxSORTXI
         Uigv22coDVL1Jgj/qUGRUB27tEPS2rcLBRjpjQNd8/Dtp37W+MPxpjoa9veV3vCYbvQm
         b9q/g4Cjoj/ZrAjSaWboDZnFJSM0Om2WOR5O+e0+UCZ/WbjXwzTfe5N+/JXC+UPsvV9W
         D1w2IAF0d023p4GK6BT9hUzJl8X0eM63ZVddW1PT/YgxFGpKC6WKzC04DgQVkHC766O/
         gJEQ==
X-Gm-Message-State: APjAAAWNImPXeF7tcXx27ri+KeZ5r8okaga6S7kLrmQETpYVfChBzUe4
        MzcAuQwAEiO5u/dGEGHYBYqntaUpKNQENIr7
X-Google-Smtp-Source: APXvYqxr/gqupRBLF/T+tPJ5F8+gjZju2AvPHzL9mJbzcnKjlP24+bHeQqdOsvLOz6J3ZM5eDU7k7+Wj+H6rT4yP
X-Received: by 2002:a63:1f25:: with SMTP id f37mr488748pgf.50.1571700815926;
 Mon, 21 Oct 2019 16:33:35 -0700 (PDT)
Date:   Mon, 21 Oct 2019 16:30:20 -0700
In-Reply-To: <20191021233027.21566-1-aaronlewis@google.com>
Message-Id: <20191021233027.21566-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191021233027.21566-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH v3 1/9] KVM: x86: Introduce vcpu->arch.xsaves_enabled
From:   Aaron Lewis <aaronlewis@google.com>
To:     Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cache whether XSAVES is enabled in the guest by adding xsaves_enabled to
vcpu->arch.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Change-Id: If4638e0901c28a4494dad2e103e2c075e8ab5d68
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm.c              | 3 +++
 arch/x86/kvm/vmx/vmx.c          | 5 +++++
 3 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 50eb430b0ad8..634c2598e389 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -562,6 +562,7 @@ struct kvm_vcpu_arch {
 	u64 smbase;
 	u64 smi_count;
 	bool tpr_access_reporting;
+	bool xsaves_enabled;
 	u64 ia32_xss;
 	u64 microcode_version;
 	u64 arch_capabilities;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f8ecb6df5106..f64041368594 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5887,6 +5887,9 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	vcpu->arch.xsaves_enabled = guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
+				    boot_cpu_has(X86_FEATURE_XSAVES);
+
 	/* Update nrips enabled cache */
 	svm->nrips_enabled = !!guest_cpuid_has(&svm->vcpu, X86_FEATURE_NRIPS);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e7970a2e8eae..34525af44353 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4040,6 +4040,8 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 			guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
 			guest_cpuid_has(vcpu, X86_FEATURE_XSAVES);
 
+		vcpu->arch.xsaves_enabled = xsaves_enabled;
+
 		if (!xsaves_enabled)
 			exec_control &= ~SECONDARY_EXEC_XSAVES;
 
@@ -7093,6 +7095,9 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	/* xsaves_enabled is recomputed in vmx_compute_secondary_exec_control(). */
+	vcpu->arch.xsaves_enabled = false;
+
 	if (cpu_has_secondary_exec_ctrls()) {
 		vmx_compute_secondary_exec_control(vmx);
 		vmcs_set_secondary_exec_control(vmx);
-- 
2.23.0.866.gb869b98d4c-goog

