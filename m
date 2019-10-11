Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C20BDD4897
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2019 21:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbfJKTlK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Oct 2019 15:41:10 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:56314 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729014AbfJKTlK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Oct 2019 15:41:10 -0400
Received: by mail-vk1-f202.google.com with SMTP id n79so3808907vkf.22
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2019 12:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ON/0K3CYe4fzFmLLTzBkiEEMt0N/ljXg9UJFmSda9AA=;
        b=QbSuIu//nhva29h/Kq00Eq91V8nEPt/Yx76aazGFKY2mb7tPhGZk5L/eBFGMmX8WVV
         4d77ZQ4bYjzJ4NJfr2bI7inlRudtlW8/IAhBtoW/kFEyp+oR8qOE81rjeih8oS7FymWd
         mdPtAg//D/XKiVt2q9e4RIQ8g4lwjedRwAS08nfGPR5zM5ZfY8s4vmVEq+x7zFr3F5gQ
         41KcuRhqgtDnbvMy3pfId6wEbI5etaK+//Yu5rpU0+2u0kteyxRQ8sGLPN6gdHduzdda
         7sh1ATE+H/zcczifpX5XQaA0D1+nTPR4oiVil9wM2Jn6zyol+pPD2/fOnRugAat3bBso
         zuhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ON/0K3CYe4fzFmLLTzBkiEEMt0N/ljXg9UJFmSda9AA=;
        b=CxezMqAoLj/Weuh126mdWSyJ1w9N35/gN50LCLSSmSnR9lm9ITUg3tTGpZ4mjRihED
         HNteFIV9Qyaq7iodi8taWh4AYZaP64NPRTevBMC9Ff+SnDdFWSJoImj7vg9GplvS7Cqi
         VyiC35+7HMCbo6d+fdKYvcHS3ViCSuQcEre5m3c/W116HSXzyXKyO+ZFxc3wdCW3wANO
         Istw9wQvuKXccw0YSVDSW8h1n3WXTUupZcIdvgHxHJak+k4sSjL0mEvZnYiHABIcSnZT
         oy65b+8FuH5j5oLUZxoV4agOhTaiPLxT6ir4CL5wRqrBFgdzUvLQmk7ZeESGpv3XhSUQ
         U5Mw==
X-Gm-Message-State: APjAAAUkJGtlvEPZ2IB0xDzZaJHyejLdvVBRMOuQpevJSiXah+FFFqfe
        FTzUUDh058eygOZL5ONrDiL7Iq9vZj/nxrzh
X-Google-Smtp-Source: APXvYqz3g59DaEpRZ9PIrFku/yxegH2bBPveigBehSSPq4e/c9Y4HpsDDjPkTH8cQgW3N73hXzJ7vggIUofckxiB
X-Received: by 2002:ac5:c84c:: with SMTP id g12mr9886010vkm.23.1570822867364;
 Fri, 11 Oct 2019 12:41:07 -0700 (PDT)
Date:   Fri, 11 Oct 2019 12:40:30 -0700
In-Reply-To: <20191011194032.240572-1-aaronlewis@google.com>
Message-Id: <20191011194032.240572-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191011194032.240572-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH v2 3/5] kvm: svm: Add support for XSAVES on AMD
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

Hoist support for RDMSR/WRMSR of IA32_XSS from vmx into common code so
that it can be used for AMD as well.

AMD has no equivalent of Intel's "Enable XSAVES/XRSTORS" VM-execution
control. Instead, XSAVES is always available to the guest when supported
on the host.

Unfortunately, right now, kvm only allows the guest IA32_XSS to be zero,
so the guest's usage of XSAVES will be exactly the same as XSAVEC.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/svm.c     |  2 +-
 arch/x86/kvm/vmx/vmx.c | 20 --------------------
 arch/x86/kvm/x86.c     | 22 ++++++++++++++++++++++
 3 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index da69e95beb4d..1953898e37ce 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5965,7 +5965,7 @@ static bool svm_mpx_supported(void)
 
 static bool svm_xsaves_supported(void)
 {
-	return false;
+	return boot_cpu_has(X86_FEATURE_XSAVES);
 }
 
 static bool svm_umip_emulated(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ce3020914c69..18bea844fffc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1818,13 +1818,6 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		return vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
 				       &msr_info->data);
-	case MSR_IA32_XSS:
-		if (!vmx_xsaves_supported() ||
-		    (!msr_info->host_initiated &&
-		     !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES)))
-			return 1;
-		msr_info->data = vcpu->arch.ia32_xss;
-		break;
 	case MSR_IA32_RTIT_CTL:
 		if (pt_mode != PT_MODE_HOST_GUEST)
 			return 1;
@@ -2060,19 +2053,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!nested_vmx_allowed(vcpu))
 			return 1;
 		return vmx_set_vmx_msr(vcpu, msr_index, data);
-	case MSR_IA32_XSS:
-		if (!vmx_xsaves_supported() ||
-		    (!msr_info->host_initiated &&
-		     !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES)))
-			return 1;
-		/*
-		 * The only supported bit as of Skylake is bit 8, but
-		 * it is not supported on KVM.
-		 */
-		if (data != 0)
-			return 1;
-		vcpu->arch.ia32_xss = data;
-		break;
 	case MSR_IA32_RTIT_CTL:
 		if ((pt_mode != PT_MODE_HOST_GUEST) ||
 			vmx_rtit_ctl_check(vcpu, data) ||
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a61570d7034b..2104e21855fc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2700,6 +2700,21 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_TSC:
 		kvm_write_tsc(vcpu, msr_info);
 		break;
+	case MSR_IA32_XSS:
+		if (!kvm_x86_ops->xsaves_supported() ||
+		    (!msr_info->host_initiated &&
+		     !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES)))
+			return 1;
+		/*
+		 * We do support PT if kvm_x86_ops->pt_supported(), but we do
+		 * not support IA32_XSS[bit 8]. Guests will have to use
+		 * RDMSR/WRMSR rather than XSAVES/XRSTORS to save/restore PT
+		 * MSRs.
+		 */
+		if (data != 0)
+			return 1;
+		vcpu->arch.ia32_xss = data;
+		break;
 	case MSR_SMI_COUNT:
 		if (!msr_info->host_initiated)
 			return 1;
@@ -3030,6 +3045,13 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
 		return get_msr_mce(vcpu, msr_info->index, &msr_info->data,
 				   msr_info->host_initiated);
+	case MSR_IA32_XSS:
+		if (!kvm_x86_ops->xsaves_supported() ||
+		    (!msr_info->host_initiated &&
+		     !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES)))
+			return 1;
+		msr_info->data = vcpu->arch.ia32_xss;
+		break;
 	case MSR_K7_CLK_CTL:
 		/*
 		 * Provide expected ramp-up count for K7. All other
-- 
2.23.0.700.g56cf767bdb-goog

