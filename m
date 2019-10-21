Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E617ADF8B0
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 01:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbfJUXdt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 19:33:49 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:44510 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728353AbfJUXdt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 19:33:49 -0400
Received: by mail-pl1-f202.google.com with SMTP id h11so9504783plt.11
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 16:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=s5vJ7UGPY/mcaRZH3A5l4PqpaJseZnIDH3GVwPsw+Qo=;
        b=u6PjkJhmMnpjtpf8Q0KqztQBKRNvZDASHH6PPeNGd4OLbJrcZRv+hK53dbbwAQefqu
         P09lwmq3yyqfr8WIvkCLy0qD3igVkVRW93Pleeo61VIcXtUGqKJ7I/iH/x9gOocAD2kx
         hfJwY8SSdXFjPfsxJaGMW6bDsK1A4EFwnzr3evGQ9wimHmwrdxTzsLhRA3FsyvI+gWfp
         FQUerB9zyeQNbeyq71lQUBSodSoTBXIfIvX4v0t1EH9TiWttzVxdqDYjCJualQxSL70f
         gpI4E38+aE3kDd64DFnr4gIN8V2Tmtn5s0fwNy6zNh3Lp8uoATYDxwUyEdsHkd5RcKQk
         cAqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=s5vJ7UGPY/mcaRZH3A5l4PqpaJseZnIDH3GVwPsw+Qo=;
        b=UG8KRzmzVXYBoh0Yck/Y9+3QAskTTgUrEsdEfUbIeLZLGDKONZrdpgGz6TzJJGy++P
         4tuZVkx/zHQXcyiJpbq3DHcnSD/UjcCCbV+IWj6q7uYogMy3OxQgimIr2J4ITrvCV+/T
         6YiRtQb08tAAr6mjOduYGyQbHJ59oZCfRWkED8OqEwY4PQEIBK/QUVBVRNtYBIjVs9qL
         PFOfhtpclv5LZLlKnwK4WT7XaabPVNaLK4YLjDCJ7sFoCf0DhyjbO6WGlgWPhhfEsrwf
         PRRUko07aqY2VLKjXdBOCHlYS9h6RrZV/MTvxo0GKHdl2iz6zP9Zf9Q2uSZqbYLCOQIf
         biXg==
X-Gm-Message-State: APjAAAXAa4q0M35jLwzpGBBFusWJw/mFDgN8r6meUWJ6ocAZSvlBvoyh
        mFg50KoQlayuZmDa8Kul9klGXJY7XddLrqNf
X-Google-Smtp-Source: APXvYqxg4Q//kXBcLbAbbm4uHFl9xhD8LU+s/1mLOFuv3CbmjbD0pG1nrE4a5zSo1+gIhe/PByg5jaKmJLrsvEcJ
X-Received: by 2002:a63:1b59:: with SMTP id b25mr426957pgm.267.1571700826081;
 Mon, 21 Oct 2019 16:33:46 -0700 (PDT)
Date:   Mon, 21 Oct 2019 16:30:23 -0700
In-Reply-To: <20191021233027.21566-1-aaronlewis@google.com>
Message-Id: <20191021233027.21566-5-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191021233027.21566-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH v3 4/9] KVM: SVM: Use wrmsr for switching between guest and
 host IA32_XSS on AMD
From:   Aaron Lewis <aaronlewis@google.com>
To:     Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the guest can execute the XSAVES/XRSTORS instructions, set the
hardware IA32_XSS MSR to guest/host values on VM-entry/VM-exit.

Note that vcpu->arch.ia32_xss is currently guaranteed to be 0 on AMD,
since there is no way to change it.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Change-Id: Id51a782462086e6d7a3ab621838e200f1c005afd
---
 arch/x86/kvm/svm.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f64041368594..2702ebba24ba 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -115,6 +115,8 @@ MODULE_DEVICE_TABLE(x86cpu, svm_cpu_id);
 
 static bool erratum_383_found __read_mostly;
 
+static u64 __read_mostly host_xss;
+
 static const u32 host_save_user_msrs[] = {
 #ifdef CONFIG_X86_64
 	MSR_STAR, MSR_LSTAR, MSR_CSTAR, MSR_SYSCALL_MASK, MSR_KERNEL_GS_BASE,
@@ -1400,6 +1402,9 @@ static __init int svm_hardware_setup(void)
 			pr_info("Virtual GIF supported\n");
 	}
 
+	if (boot_cpu_has(X86_FEATURE_XSAVES))
+		rdmsrl(MSR_IA32_XSS, host_xss);
+
 	return 0;
 
 err:
@@ -5590,6 +5595,22 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 	svm_complete_interrupts(svm);
 }
 
+static void svm_load_guest_xss(struct kvm_vcpu *vcpu)
+{
+	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE) &&
+	    vcpu->arch.xsaves_enabled &&
+	    vcpu->arch.ia32_xss != host_xss)
+		wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
+}
+
+static void svm_load_host_xss(struct kvm_vcpu *vcpu)
+{
+	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE) &&
+	    vcpu->arch.xsaves_enabled &&
+	    vcpu->arch.ia32_xss != host_xss)
+		wrmsrl(MSR_IA32_XSS, host_xss);
+}
+
 static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -5629,6 +5650,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	clgi();
 	kvm_load_guest_xcr0(vcpu);
+	svm_load_guest_xss(vcpu);
 
 	if (lapic_in_kernel(vcpu) &&
 		vcpu->arch.apic->lapic_timer.timer_advance_ns)
@@ -5778,6 +5800,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_before_interrupt(&svm->vcpu);
 
+	svm_load_host_xss(vcpu);
 	kvm_put_guest_xcr0(vcpu);
 	stgi();
 
-- 
2.23.0.866.gb869b98d4c-goog

