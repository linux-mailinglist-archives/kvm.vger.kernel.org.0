Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6846DDF8B1
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 01:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730275AbfJUXdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 19:33:52 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:51308 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728353AbfJUXdw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 19:33:52 -0400
Received: by mail-pg1-f202.google.com with SMTP id w22so3254319pgj.18
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 16:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kBviJpi54mEWd4hIdX6Nap4GHAX+mDvVyfWIrS6aW2g=;
        b=Xbj3mO4LVR04Wrff2eYpjbUI/CD5BY/2mBRDooJ17WSN6xqAw1ZsyaMWPB+itb1WZ3
         5H+i44AhIIqom/I4ViJzhUGWX7NzBTIwPc7yjHjN9GyAO1hMj/bLEwhYAnyEne+f6Evw
         CdQQDkODYi2xDMApupEmI1UfljND98ulw9D08wXQuWUNHifWIjQwGkJ0NLdHipcYfNNu
         92s4iSFOyTfdYRisQp9rG9PewNmpljsIalY5ZB46XRteQJ2cK8IlMdURAN99finyvrKz
         kEeo9yEE0qFqec3BlPhNs/XNPpH85CUlGy6IO23UFuNpU59d+WeNjWzX7w2HlyREHCag
         gCqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kBviJpi54mEWd4hIdX6Nap4GHAX+mDvVyfWIrS6aW2g=;
        b=C32/C1Yt30QrRqJABvUtyvNFl/EjgtW0rrKPbI3fJcKAXd/BjEoNS5WsBsJbV+g0td
         pmshXnuFJY01aUcQkMXVdivAFES58WARegp/TIGrZJGfMM6vXgh6iLe4yFkh5mBIhjSH
         6n5+l0V/+6dXQZBoBamZZuvhWcW2kB+PsZNAcEOww5+vtB0mMPMSAcb963CwN5xXdc/R
         bnu+D20VizazNwhFejIQSD1AE5bLtmh4rNTvdq0jNyb1Jq10Q705/+5RPopdsKy+8GH4
         CyL5gR4ko5hfLakcYvCnHr0vPxJUkWAfOISBwZuidM69Yg+dkUxmXZy57fo7cydIIcB6
         LxbA==
X-Gm-Message-State: APjAAAWESAijKyLWm4niXERD4H5QATwfNvsx9wORDoSq3Vf1vfKzt27r
        kJksXUk2rg5nHl2nEB3eG4TrcFmBjtzpVwc7
X-Google-Smtp-Source: APXvYqxZgI8L7w7iACZwg6psGwq5ccwq51ezmT0dC5G51p3FOnOMk2Cbp9A2eArefEBV/5L5oImQqebLu4UMeGtc
X-Received: by 2002:a63:e249:: with SMTP id y9mr410115pgj.383.1571700829301;
 Mon, 21 Oct 2019 16:33:49 -0700 (PDT)
Date:   Mon, 21 Oct 2019 16:30:24 -0700
In-Reply-To: <20191021233027.21566-1-aaronlewis@google.com>
Message-Id: <20191021233027.21566-6-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191021233027.21566-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH v3 5/9] KVM: VMX: Use wrmsr for switching between guest and
 host IA32_XSS on Intel
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

When the guest can execute the XSAVES/XRSTORS instructions, use wrmsr to
set the hardware IA32_XSS MSR to guest/host values on VM-entry/VM-exit,
rather than the MSR-load areas. By using the same approach as AMD, we
will be able to use a common implementation for both (in the next
patch).

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Change-Id: I9447d104b2615c04e39e4af0c911e1e7309bf464
---
 arch/x86/kvm/vmx/vmx.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a9b070001c3e..f3cd2e372c4a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2072,13 +2072,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data != 0)
 			return 1;
 		vcpu->arch.ia32_xss = data;
-		if (vcpu->arch.xsaves_enabled) {
-			if (vcpu->arch.ia32_xss != host_xss)
-				add_atomic_switch_msr(vmx, MSR_IA32_XSS,
-					vcpu->arch.ia32_xss, host_xss, false);
-			else
-				clear_atomic_switch_msr(vmx, MSR_IA32_XSS);
-		}
 		break;
 	case MSR_IA32_RTIT_CTL:
 		if ((pt_mode != PT_MODE_HOST_GUEST) ||
@@ -6492,6 +6485,22 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 	}
 }
 
+static void vmx_load_guest_xss(struct kvm_vcpu *vcpu)
+{
+	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE) &&
+	    vcpu->arch.xsaves_enabled &&
+	    vcpu->arch.ia32_xss != host_xss)
+		wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
+}
+
+static void vmx_load_host_xss(struct kvm_vcpu *vcpu)
+{
+	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE) &&
+	    vcpu->arch.xsaves_enabled &&
+	    vcpu->arch.ia32_xss != host_xss)
+		wrmsrl(MSR_IA32_XSS, host_xss);
+}
+
 bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
 
 static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
@@ -6543,6 +6552,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		vmx_set_interrupt_shadow(vcpu, 0);
 
 	kvm_load_guest_xcr0(vcpu);
+	vmx_load_guest_xss(vcpu);
 
 	if (static_cpu_has(X86_FEATURE_PKU) &&
 	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE) &&
@@ -6649,6 +6659,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 			__write_pkru(vmx->host_pkru);
 	}
 
+	vmx_load_host_xss(vcpu);
 	kvm_put_guest_xcr0(vcpu);
 
 	vmx->nested.nested_run_pending = 0;
-- 
2.23.0.866.gb869b98d4c-goog

