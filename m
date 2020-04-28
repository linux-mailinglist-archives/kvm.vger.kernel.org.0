Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6FC1BB678
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 08:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgD1GXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 02:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726355AbgD1GXz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 02:23:55 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E713DC03C1AA;
        Mon, 27 Apr 2020 23:23:54 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d24so7940090pll.8;
        Mon, 27 Apr 2020 23:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dASjRXsAg6WzAae5CXACCO5RVvFv8dsS43RJHmTgzTs=;
        b=V4vrhTp+G2YuztWgbTcOG0kzgrR8Rjq27TRZj4WM+JH7ENf17cEXehRD3QYP8/7Io9
         TRzTzUTcGwsFd8wED53Al5Lf1e9d6fEci2seRTv/bsTzredAB3ZKNrNTPkD1jkw6TRwg
         Pj9e5lD/VwwVjGqPTWTa+6FvuJ8NZC2vT/DQW8Sp6NPERTXP8XtybizKH9Jh5sIxGy7I
         mj0Gak2SH8YCpk3XP2AeT6W606c8NNb5UgBZpLOj+uCk7r2eTebi8COcq2ybxhTvX5GR
         nMvZdgTkhKo64RckR88JvNc6mkMCmOywxBrDdTARontdbMxvHjbNWblRrPkMYdOTgq0U
         GH0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dASjRXsAg6WzAae5CXACCO5RVvFv8dsS43RJHmTgzTs=;
        b=ZqMtS/8E8KHXDwr9xGPiD+kpmCWK2riqIhbhOWrBsPPkCZlMDvZW+g1SllLRhM/vLz
         XoMTDEg9opTYcPwIUzdVevDtYGVJhI6kfzsQz+vg3qNjCzTiFsyZmz9vxRHH+tZ/y/Rt
         4KumQUOkLZq3lfP/MXjj9wRx3GxdAy4j4/STWZk8sbapr9XB6XV09IQ/sQkvGLoFFPOC
         a3safBPn7TsyG35CiC+AezmbriiwHnOB3ccdBs6R6B2XrihFd9qqDHXXNO7M/soXfp34
         4D2c4Kxd1A+CR41IKZJ/tVdfZ35eVSBUyNz/E5sRfKx91X93Sla1Dpx578TrP2wghq4a
         e9Jw==
X-Gm-Message-State: AGi0PuYFTAU36ZegTlSLiVkgjKz3WqkfGjrv/TAcl06uqLbuFpL57R8F
        bVf4/tBnyh4Fo1xbE9G06hz3DVFp
X-Google-Smtp-Source: APiQypJ2dyHcYY2mJa3PGa2d76ad4Tri/9ZR7Ip0tE6jflFVGWTKZMBwmKayZxw5sbVUvfCPgkM9ng==
X-Received: by 2002:a17:90a:b293:: with SMTP id c19mr3093890pjr.22.1588055030740;
        Mon, 27 Apr 2020 23:23:50 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id u188sm14183071pfu.33.2020.04.27.23.23.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 23:23:50 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH v4 4/7] KVM: X86: Introduce kvm_vcpu_exit_request() helper
Date:   Tue, 28 Apr 2020 14:23:26 +0800
Message-Id: <1588055009-12677-5-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588055009-12677-1-git-send-email-wanpengli@tencent.com>
References: <1588055009-12677-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Introduce kvm_vcpu_exit_request() helper, we need to check some conditions
before enter guest again immediately, we skip invoking the exit handler and
go through full run loop if complete fastpath but there is stuff preventing
we enter guest again immediately.

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c |  3 +++
 arch/x86/kvm/x86.c     | 10 ++++++++--
 arch/x86/kvm/x86.h     |  1 +
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e12a42e..24cadf4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6777,6 +6777,9 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx_complete_interrupts(vmx);
 
 	exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
+	if (exit_fastpath == EXIT_FASTPATH_REENTER_GUEST &&
+	    kvm_vcpu_exit_request(vcpu))
+		exit_fastpath = EXIT_FASTPATH_NOP;
 
 	return exit_fastpath;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index df38b40..afe052c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1581,6 +1581,13 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
 
+bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
+{
+	return vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu) ||
+		need_resched() || signal_pending(current);
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_exit_request);
+
 /*
  * The fast path for frequent and performance sensitive wrmsr emulation,
  * i.e. the sending of IPI, sending IPI early in the VM-Exit flow reduces
@@ -8366,8 +8373,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
 		kvm_x86_ops.sync_pir_to_irr(vcpu);
 
-	if (vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu)
-	    || need_resched() || signal_pending(current)) {
+	if (kvm_vcpu_exit_request(vcpu)) {
 		vcpu->mode = OUTSIDE_GUEST_MODE;
 		smp_wmb();
 		local_irq_enable();
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 2f02dc0..6eb62e9 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -364,5 +364,6 @@ static inline bool kvm_dr7_valid(u64 data)
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
+bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu);
 
 #endif
-- 
2.7.4

