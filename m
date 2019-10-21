Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B390ADF8B3
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 01:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730305AbfJUXd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 19:33:58 -0400
Received: from mail-vk1-f201.google.com ([209.85.221.201]:56693 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730298AbfJUXd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 19:33:57 -0400
Received: by mail-vk1-f201.google.com with SMTP id 63so6799772vkr.23
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 16:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5g73sYJEArJfZS9LAgkoj8Q/oruLKaSU2iQtc79zP4Q=;
        b=E3JC4Gkyo0jdg3Oa6Mja5fIVze+oYkcn5iBWopHxEjQ30Tg+tA0b5ysTRPrYcinY9f
         Y3FYwYv94DmjVFhCXcjFykc4JC/S9KbjPjke0vq7JPaGtKsI7U0LsIPIIvicMjokOGVv
         I4AXa9QgIS+cG0pYUcNW2tno3f0RZJG8wAA6/JLylgUL4CT1j55Qj/NzLiw9c8uzj3Iy
         QwaKE4AGnfcp7cqxmxMvzuL3p4e13PfiD+lZTiONsTZBiXeCezivu9WEALBFA5jHNWXr
         x9Ni/Uvpyft3Cd+Gl6k8fkQb1KrAQjwdy0A2nRSi6wO598u4MIuCxLnHFOYzTJrAOTFN
         9Ivg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5g73sYJEArJfZS9LAgkoj8Q/oruLKaSU2iQtc79zP4Q=;
        b=QghcQaYnQr3RbmpN3lp+mLLWx9ty1XmtSUcgfd8P1JSPcSepmjvIGm3XgeskI6KH70
         xZOXmBGTAqFR8jYBi7toXaKZdi+nw6s00QYFMl9ZcsxQGWPzG6l8MtipWs/jZt2qMHt/
         C9lziU+FeH4UNG38WofTJ2lGogn+II5xTZ+ID7CEd1FOQNrZEkIhzAcld4xnGq3062TF
         OmgNq+yUEZXzD1G9yJTDBCTWTfMIchBVvIvHUWcSpLbbLEKNPt/M7FvCw/7zBJ5/F+0Q
         BaRX8BD/POwGImS/SRT3XXMv8JlUyOO9jmhlxqyRTrq8EXep6LJqlS6onDTMiSxs7K//
         hJXA==
X-Gm-Message-State: APjAAAVTTr+RnpSmt0dYf3PvYgzYXqazEjvOYVKT7H1YWSOS6AuiA+Tt
        JvbVQmoVQoj/upfg3KlOd6fsiOnl4gxoUGow
X-Google-Smtp-Source: APXvYqzggWpSnVreBg6JTR4GvWBsFZBhNa6EoUd+3kIyr9hHbFGmTiaOdnuvmLTE8MiS6/XqtLSRZnd7CkyqZbsl
X-Received: by 2002:a1f:1d15:: with SMTP id d21mr338713vkd.55.1571700836236;
 Mon, 21 Oct 2019 16:33:56 -0700 (PDT)
Date:   Mon, 21 Oct 2019 16:30:26 -0700
In-Reply-To: <20191021233027.21566-1-aaronlewis@google.com>
Message-Id: <20191021233027.21566-8-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191021233027.21566-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH v3 7/9] kvm: x86: Move IA32_XSS to kvm_{get,set}_msr_common
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
that it can be used for svm as well.

Right now, kvm only allows the guest IA32_XSS to be zero,
so the guest's usage of XSAVES will be exactly the same as XSAVEC.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Change-Id: Ie4b0f777d71e428fbee6e82071ac2d7618e9bb40
---
 arch/x86/kvm/vmx/vmx.c | 18 ------------------
 arch/x86/kvm/x86.c     | 20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f7d292ac9921..b29511d63971 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1818,12 +1818,6 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		return vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
 				       &msr_info->data);
-	case MSR_IA32_XSS:
-		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
-			return 1;
-		msr_info->data = vcpu->arch.ia32_xss;
-		break;
 	case MSR_IA32_RTIT_CTL:
 		if (pt_mode != PT_MODE_HOST_GUEST)
 			return 1;
@@ -2059,18 +2053,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!nested_vmx_allowed(vcpu))
 			return 1;
 		return vmx_set_vmx_msr(vcpu, msr_index, data);
-	case MSR_IA32_XSS:
-		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
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
index 259a30e4d3a9..cbbf792a04c1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2697,6 +2697,20 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_TSC:
 		kvm_write_tsc(vcpu, msr_info);
 		break;
+	case MSR_IA32_XSS:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
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
@@ -3027,6 +3041,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
 		return get_msr_mce(vcpu, msr_info->index, &msr_info->data,
 				   msr_info->host_initiated);
+	case MSR_IA32_XSS:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
+			return 1;
+		msr_info->data = vcpu->arch.ia32_xss;
+		break;
 	case MSR_K7_CLK_CTL:
 		/*
 		 * Provide expected ramp-up count for K7. All other
-- 
2.23.0.866.gb869b98d4c-goog

