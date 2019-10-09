Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF76D04D8
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 02:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729960AbfJIAmC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 20:42:02 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:52886 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729860AbfJIAmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 20:42:02 -0400
Received: by mail-vk1-f202.google.com with SMTP id o66so172047vka.19
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 17:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SHgnXwsYJGxEstaZQfN+ECm7++y1Dz+ct07e3lnRp5c=;
        b=M/351PRcFXvI7Z3nQt3g8F70z+hYnDrjpdMvG1Xrv2+i81SNfBg/I95bB5Gf77q0U8
         8yGI0UO5hHAE/j6Uxwk81pOn9LSvB+O5dkYKuR31CmbvaVtL8d5k1JN+F2sHpgDZ3ZFS
         etMvv7YAWxM/RZKZ2uWxwloC408Zka57ZFxF4fvnRWorNSoo5T3MzcozykyMsIopS4r0
         9xTJSI74+NKBQt+Z+ErtJyY4a/Tk8bahGqvtyL3h5GXyUXBL5PcFmzO8ihDtjtHlO2L2
         tixpl0OrwtN2wgTiDJloRpSiJt0ZjOc0qNrFH7JcWrrhQF63cycei7T72DGK4xF9BA+s
         9QmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SHgnXwsYJGxEstaZQfN+ECm7++y1Dz+ct07e3lnRp5c=;
        b=Y09dELZwZx0mn8a2uz5DBOXhhKriJ1/P+FdLcCK1Jm9Negcp5BkLuz/b8P7g32Si0f
         KZqSKaHsV1XIvVF0i/eNmrYVnHmdLq9lk10Ez3ufVTyQk+8EuoOcq+9sCFhTd+7Ltu7S
         u7VP9sWIwv7iPLBEuo9vZEbK9LzatOHJMAnobtrepK9vvo6tFP1o5CRNpt7khlVEaPke
         /+ufAihknQFo6XXRyVZ2iGVqGVVi2BRlWEA95WLChCWB68zUkxN+TO6OnYmFvBf7jicl
         jEL3phtf2+cKrj5qa0/5vnton4QxNClVL/tKBBPtXWRnvQ6+hPi+WdchheVIdbcE6wGg
         XeJA==
X-Gm-Message-State: APjAAAUXO2kjyKJnZwIJmWQTQ50Mq6tT5TYB6H93ATjYNRULxmaGRk3x
        MtJJRam/NW/YUZYG+gPIMyEGBjylmXZrOGzf
X-Google-Smtp-Source: APXvYqyyq0oMV/8PNr4hTpOPz8WvQQgOUcYU7BCci8lGo3FkHQtXN6VoTjiUpWuuAhGzRLrWfTfwBPgN0q4kpPpI
X-Received: by 2002:a05:6122:2bb:: with SMTP id 27mr687032vkq.66.1570581720834;
 Tue, 08 Oct 2019 17:42:00 -0700 (PDT)
Date:   Tue,  8 Oct 2019 17:41:39 -0700
In-Reply-To: <20191009004142.225377-1-aaronlewis@google.com>
Message-Id: <20191009004142.225377-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191009004142.225377-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [Patch 3/6] kvm: svm: Add support for XSAVES on AMD
From:   Aaron Lewis <aaronlewis@google.com>
To:     Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hoist support for IA32_XSS so it can be used for both AMD and Intel,
instead of for just Intel.

AMD has no equivalent of Intel's "Enable XSAVES/XRSTORS" VM-execution
control. Instead, XSAVES is always available to the guest when supported
on the host.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/svm.c     |  2 +-
 arch/x86/kvm/vmx/vmx.c | 20 --------------------
 arch/x86/kvm/x86.c     | 16 ++++++++++++++++
 3 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e2d7a7738c76..65223827c675 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5962,7 +5962,7 @@ static bool svm_mpx_supported(void)
 
 static bool svm_xsaves_supported(void)
 {
-	return false;
+	return boot_cpu_has(X86_FEATURE_XSAVES);
 }
 
 static bool svm_umip_emulated(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ff5ba28abecb..bd4ce33bd52f 100644
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
index e90e658fd8a9..77f2e8c05047 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2702,6 +2702,15 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_TSC:
 		kvm_write_tsc(vcpu, msr_info);
 		break;
+	case MSR_IA32_XSS:
+		if (!kvm_x86_ops->xsaves_supported() ||
+		    (!msr_info->host_initiated &&
+		     !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES)))
+			return 1;
+		if (data != 0)
+			return 1;
+		vcpu->arch.ia32_xss = data;
+		break;
 	case MSR_SMI_COUNT:
 		if (!msr_info->host_initiated)
 			return 1;
@@ -3032,6 +3041,13 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
2.23.0.581.g78d2f28ef7-goog

