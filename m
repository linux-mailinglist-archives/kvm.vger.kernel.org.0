Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 163EA37435
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 14:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbfFFMdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 08:33:42 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51837 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbfFFMdm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 08:33:42 -0400
Received: by mail-wm1-f66.google.com with SMTP id f10so2273074wmb.1;
        Thu, 06 Jun 2019 05:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=ra3Xho30Wjmv4m0oReKdeu7rziVs8VyTn6f+lFdrBlQ=;
        b=pEZgynvolhWehHrYPEM8QqDKB93Cf55oNHqxgIuBjSJmeY3241MlHIz/FWUJxXIjUl
         mxJxukfmweeAYutmJCtEydExkef/4VYnNW4R9gOrj7z/WTPQTKLoLWaJ+SS2KKCeqKsl
         rHzNIcum+Yk5jHcAWYiP3QaVA2DCuOWow3Mf4QVoQeR8YMgPzRCA1P4wQbL6ghkbcjwT
         DPukMKt7sHhCwDbznefhvTmlEIs6/6P0X5F+X15r5e69c/tApyXBs8gVcL5tckQ0YGsA
         WG6fhAdfj4y+3Px5sc1kK0fkzuGifru/HmnTkGXUqLjDGPbTr7KLvv7ukRE/J+BPfeTf
         yyuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=ra3Xho30Wjmv4m0oReKdeu7rziVs8VyTn6f+lFdrBlQ=;
        b=d4IE2ZX1qkcq7oV1poYMWMqCTTt40xPgbzMPkyWkNIBX4dxkLokzwEVft/C+b1esXO
         sA9i0/TyhJYDZkZs50o6Jm1oz4GxndgNirt1iSNN7XUBzyRGWpZUzBkIrx4mCNzTxHgP
         aKfjLDXKJgdodB+vG8VjNycG7GT+lFY6WFHZNDBx2wQz9yk3/38gVm0o4Ggkv84+8HnU
         1PpjaEKbGL996n9g2tlFbt74CPs4hfRRd52R+NWWWkjse1+aKpxYIiUW5ggbzDKCceqn
         7vbAx+GaGAPEftT261QMMo8Zj15xB6wkNPiZgz5YhLYPti9xSVG186DezN9hsIBV13a2
         Yqpg==
X-Gm-Message-State: APjAAAVFJjQmiwfadGePQHsqauAPCb1iS795+0w2afjwwo/2xDH9fnAs
        Z6jwnF29JyqO/NQyGvdwUhhFLO6p
X-Google-Smtp-Source: APXvYqy/aRp8Vq8zpcMhwPihHsawePuwDj1fycmmyt2YI8ywa9/kxiGwJSflFngPY6tKwJFjEwGlwA==
X-Received: by 2002:a1c:f012:: with SMTP id a18mr15548304wmb.168.1559824419272;
        Thu, 06 Jun 2019 05:33:39 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id l190sm1250292wml.16.2019.06.06.05.33.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 05:33:38 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, liran.alon@oracle.com
Subject: [PATCH] KVM: x86: move MSR_IA32_POWER_CTL handling to common code
Date:   Thu,  6 Jun 2019 14:33:37 +0200
Message-Id: <1559824417-74835-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make it available to AMD hosts as well, just in case someone is trying
to use an Intel processor's CPUID setup.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/vmx/vmx.c          | 6 ------
 arch/x86/kvm/vmx/vmx.h          | 2 --
 arch/x86/kvm/x86.c              | 6 ++++++
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a86026969b19..35e7937cc9ac 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -689,6 +689,7 @@ struct kvm_vcpu_arch {
 	u32 virtual_tsc_mult;
 	u32 virtual_tsc_khz;
 	s64 ia32_tsc_adjust_msr;
+	u64 msr_ia32_power_ctl;
 	u64 tsc_scaling_ratio;
 
 	atomic_t nmi_queued;  /* unprocessed asynchronous NMIs */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cccf73a91e88..5d903f8909d1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1695,9 +1695,6 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_SYSENTER_ESP:
 		msr_info->data = vmcs_readl(GUEST_SYSENTER_ESP);
 		break;
-	case MSR_IA32_POWER_CTL:
-		msr_info->data = vmx->msr_ia32_power_ctl;
-		break;
 	case MSR_IA32_BNDCFGS:
 		if (!kvm_mpx_supported() ||
 		    (!msr_info->host_initiated &&
@@ -1828,9 +1825,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_SYSENTER_ESP:
 		vmcs_writel(GUEST_SYSENTER_ESP, data);
 		break;
-	case MSR_IA32_POWER_CTL:
-		vmx->msr_ia32_power_ctl = data;
-		break;
 	case MSR_IA32_BNDCFGS:
 		if (!kvm_mpx_supported() ||
 		    (!msr_info->host_initiated &&
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 61128b48c503..1cdaa5af8245 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -260,8 +260,6 @@ struct vcpu_vmx {
 
 	unsigned long host_debugctlmsr;
 
-	u64 msr_ia32_power_ctl;
-
 	/*
 	 * Only bits masked by msr_ia32_feature_control_valid_bits can be set in
 	 * msr_ia32_feature_control. FEATURE_CONTROL_LOCKED is always included
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 145df9778ed0..5ec87ded17db 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2563,6 +2563,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		vcpu->arch.smbase = data;
 		break;
+	case MSR_IA32_POWER_CTL:
+		vcpu->arch.msr_ia32_power_ctl = data;
+		break;
 	case MSR_IA32_TSC:
 		kvm_write_tsc(vcpu, msr_info);
 		break;
@@ -2822,6 +2825,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		msr_info->data = vcpu->arch.arch_capabilities;
 		break;
+	case MSR_IA32_POWER_CTL:
+		msr_info->data = vcpu->arch.msr_ia32_power_ctl;
+		break;
 	case MSR_IA32_TSC:
 		msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) + vcpu->arch.tsc_offset;
 		break;
-- 
1.8.3.1

