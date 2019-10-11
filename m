Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0A1D4898
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2019 21:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbfJKTlL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Oct 2019 15:41:11 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:35699 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729014AbfJKTlL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Oct 2019 15:41:11 -0400
Received: by mail-pg1-f202.google.com with SMTP id s1so7667041pgm.2
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2019 12:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WBZQuUCDQHNl1l1bGWNs/9RUHosUT5fVUoCeqs6NXeU=;
        b=nLsiobK7toiL0tMAZXKCM1qFRtLPxSTfoj/qE/UTRLVQRuWan3v8eGF73Sgx58Jphl
         WOEs1kOjviwRoZFhV7kX2k4QrzuyoZqK13v0TSlZqTKu/FN64Gh2xiT5u68HNP9K6ydM
         thU551rToDNNg9sJxgbynIuPQCI0w8qFx/DbAhZxlAxzK4MLp6QPSgpWM/FYauPZu1ev
         vbyNTQql6/J+VE/aQEQQAAM77ENhfd2JAJAl9+IA9DZIXOHUmXP8/CEDjAE/roiP05nu
         Bn6sqy9XKPG80Gjg1LVWlq7aRcMLZyCn6M45v7Yg/XLrWE+LNExFQCWbveJ+65t+BHHW
         my/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WBZQuUCDQHNl1l1bGWNs/9RUHosUT5fVUoCeqs6NXeU=;
        b=rAwdQSeHBnnuZJNCHniafw/N04G/lMNagl2GsClva37bZpua+JWRE9GjRCf6ugR9JI
         2A1U7gSjPuS5YPRc8mFApWPeGWfqza3aw0eGStwxdntjdGkIfj6WWTBdLLL//HSlYTTb
         mGvlhs8PBTGQbpBRg82eO9bf2sJ+znx9Q0vfVR/FDBvCfut7qLdkCbySSgnEpAAdeoPU
         NpxmWkxSTGqyqsbp39Y2jzkGcYp82PLXu3Lr1ruVHIgKpnEdPFDCogWvOscxb+LYtCO1
         INkmhx+PjElcZNhaPjqu1a9n24ofzjpAjERJkTaYMYyfDP0UrDr/Go+oJ8GmxI8pfPHP
         xjWw==
X-Gm-Message-State: APjAAAVrNaD3SZU8MskxtyQkAjD/3u2SF33AGDWW4kbZbopE6pITGkZa
        j3xbZnj/5neQUuhg/xtFR9o0LGXQMPguYSfL
X-Google-Smtp-Source: APXvYqzePMsEtzf0mOV1afpqsOBDPe2zZKsh3WkM5xBc7EgmtzQ6pZkFJ66dkvg2MfmQqfhPAN/k+HTNXANDm31T
X-Received: by 2002:a65:66d1:: with SMTP id c17mr18364033pgw.169.1570822870397;
 Fri, 11 Oct 2019 12:41:10 -0700 (PDT)
Date:   Fri, 11 Oct 2019 12:40:31 -0700
In-Reply-To: <20191011194032.240572-1-aaronlewis@google.com>
Message-Id: <20191011194032.240572-5-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191011194032.240572-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH v2 4/5] kvm: x86: Add IA32_XSS to the emulated_msrs list
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

Add IA32_XSS to the list of emulated MSRs if it is supported in the
guest.  At the moment, the guest IA32_XSS must be zero, but this change
prepares for expanded support in the future.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/svm.c     | 12 +++++++-----
 arch/x86/kvm/vmx/vmx.c |  2 ++
 arch/x86/kvm/x86.c     |  1 +
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1953898e37ce..e23a5013c812 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -498,6 +498,11 @@ static inline bool avic_vcpu_is_running(struct kvm_vcpu *vcpu)
 	return (READ_ONCE(*entry) & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 }
 
+static bool svm_xsaves_supported(void)
+{
+	return boot_cpu_has(X86_FEATURE_XSAVES);
+}
+
 static void recalc_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *c, *h;
@@ -5871,6 +5876,8 @@ static bool svm_has_emulated_msr(int index)
 	case MSR_IA32_MCG_EXT_CTL:
 	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
 		return false;
+	case MSR_IA32_XSS:
+		return svm_xsaves_supported();
 	default:
 		break;
 	}
@@ -5963,11 +5970,6 @@ static bool svm_mpx_supported(void)
 	return false;
 }
 
-static bool svm_xsaves_supported(void)
-{
-	return boot_cpu_has(X86_FEATURE_XSAVES);
-}
-
 static bool svm_umip_emulated(void)
 {
 	return false;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 18bea844fffc..4ba62ebd8703 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6272,6 +6272,8 @@ static bool vmx_has_emulated_msr(int index)
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		/* This is AMD only.  */
 		return false;
+	case MSR_IA32_XSS:
+		return vmx_xsaves_supported();
 	default:
 		return true;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2104e21855fc..e3b7dbb8be8f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1227,6 +1227,7 @@ static u32 emulated_msrs[] = {
 	MSR_MISC_FEATURES_ENABLES,
 	MSR_AMD64_VIRT_SPEC_CTRL,
 	MSR_IA32_POWER_CTL,
+	MSR_IA32_XSS,
 
 	/*
 	 * The following list leaves out MSRs whose values are determined
-- 
2.23.0.700.g56cf767bdb-goog

