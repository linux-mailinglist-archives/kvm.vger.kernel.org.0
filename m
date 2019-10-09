Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62FF9D04DA
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 02:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbfJIAmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 20:42:11 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:55708 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729881AbfJIAmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 20:42:11 -0400
Received: by mail-pl1-f202.google.com with SMTP id g11so405830plm.22
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 17:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8WBSkdbrHuvvunaAsJ6aBKGfXNeqDL3KyyVDtgZdvuI=;
        b=YcHIgZjO25rlhO80x/5vYyOkJj879nxCPpjqq/4UAI5uYydzdhaIY7y6w/MZEINj7+
         v8XHsqiZT51NYLocAwQWPaNh+vk1G1A5ZAakkpUKBq6nxQStg6pdr/UzqQxglJPhMNQJ
         AGlVMSpbhZlfzCR3G9c5Lh26tRcqepsvLhEjANsmGxv/xl7uIasIW5Eos1tPfHNlVV5+
         Fd3eHZt2zjYULxNVW30mEqdv+oZ0HAsASeBKpogiAFwoZPGlGBaTY3zkK5WBTF7z8Z7P
         /9T6wl1H5oYFSdMXgic0+h9S1ALyUaOVww/HUHwq3lMNuoLOIuGKoC6p/r/wg3Nb0e4d
         xR0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8WBSkdbrHuvvunaAsJ6aBKGfXNeqDL3KyyVDtgZdvuI=;
        b=Cnr01JsPFQudLa1kUUR7gksThYpWOGoe9T+btEi9l3DyaPDpJN9MdeADcu/oMYeo+u
         RBymCMf2f3Tsisaf7UxisfLsyvU1O/mcHgkgwq4djOmtdSUzxW8/DFgD4jeFy+Dgj3OE
         S+zk21JWmtrxSArBwqB2CEGchn7GjJX7KROzawbCPCKDehWEk4Fv801OvrexwHa70C15
         j13hliZwwqd/hoPgH6FLgySgxZY5RZ2ySXJYugPYT4RS5fh6dHyH6OxwH4VOQyKG0FT8
         U+fvjcz3pZxoAETWMAWan5IPTX+8iejQdtO80tRyeblo8t7S8xMsYAeK5Tuplb1sRSCh
         PAng==
X-Gm-Message-State: APjAAAVn+dvcf5o+NXc6OynOQG+gFYugdMElQTWzKZVCc3U4w2xTcdzB
        /Q36w0dN078cTCEP6ahmAXooUCLQjbcwS6So
X-Google-Smtp-Source: APXvYqz74DjqW4pZ3KjJgs8zH+E1YdyF9CpP4gvxdUxv//sC05oq+oCaY2VZr4hcX3ZNTAZw2+9lD1A67aulri65
X-Received: by 2002:a63:5949:: with SMTP id j9mr1301064pgm.371.1570581729460;
 Tue, 08 Oct 2019 17:42:09 -0700 (PDT)
Date:   Tue,  8 Oct 2019 17:41:41 -0700
In-Reply-To: <20191009004142.225377-1-aaronlewis@google.com>
Message-Id: <20191009004142.225377-5-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191009004142.225377-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [Patch 5/6] kvm: x86: Add IA32_XSS to the emulated_msrs list
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

Add IA32_XSS to the list of emulated MSRs if it is supported in the
guest.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/svm.c     | 12 +++++++-----
 arch/x86/kvm/vmx/vmx.c |  2 ++
 arch/x86/kvm/x86.c     |  1 +
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2522a467bbc0..8de6705ac30d 100644
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
@@ -5964,11 +5971,6 @@ static bool svm_mpx_supported(void)
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
index bd4ce33bd52f..c28461385c2b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6270,6 +6270,8 @@ static bool vmx_has_emulated_msr(int index)
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		/* This is AMD only.  */
 		return false;
+	case MSR_IA32_XSS:
+		return vmx_xsaves_supported();
 	default:
 		return true;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 77f2e8c05047..243c6df12d81 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1229,6 +1229,7 @@ static u32 emulated_msrs[] = {
 	MSR_MISC_FEATURES_ENABLES,
 	MSR_AMD64_VIRT_SPEC_CTRL,
 	MSR_IA32_POWER_CTL,
+	MSR_IA32_XSS,
 
 	/*
 	 * The following list leaves out MSRs whose values are determined
-- 
2.23.0.581.g78d2f28ef7-goog

