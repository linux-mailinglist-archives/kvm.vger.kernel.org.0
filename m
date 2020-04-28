Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF081BB67C
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 08:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgD1GYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 02:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726545AbgD1GX7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 02:23:59 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B559C03C1A9;
        Mon, 27 Apr 2020 23:23:59 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y25so10190490pfn.5;
        Mon, 27 Apr 2020 23:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R8HPAyGqQD6jSi5KIg2alMZG6asgvoHzeT449ZMc+4o=;
        b=YH7nqxE1vb+ew04V4qQwG7m9DKgHwiXOjL11fNRLi7t3iEo1A1Cfdn4hoGn+79v9Iu
         kSolvU1zIRhhmhslXZ5jGryUhE5kOcZb2pImIH13HqWCNtSKyJ+OOBU0VQum4sYJc403
         3ytnmnOV6AqhB2Cf6Ml6HbbaMWw2EbdVc6ODMBjdY33d/P9O6lb2sEnA3GGTakNoc6BL
         6d6yWIKWLaudaYxZK7e6YgAyCN5+7v1dRX1A2OCI9h1PLg8JPLWRF+M8Ji6cXMbgCD/W
         hEd3SbDTeKNgrKp9fVm2g+PwZMXXmSpPgX8KDwrGbHoWaLh+Jux6lIrje/DWKvlLF68y
         99jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R8HPAyGqQD6jSi5KIg2alMZG6asgvoHzeT449ZMc+4o=;
        b=PfF9OlS3PtpyP9PpFFC1Uw5eAqV1c8GcT87AU8KGvEdZp8+XigL9TXI6JKEeg6SV2c
         T0r7XPyg9imy3YUun3y9e/F7ODlNJxGYL1p+58a33h6lsQsmjxB9KbQaM75MmCygqhbY
         REZ1ng3jpktRrdxciMRXucBmBViAVe7Ilsg0r3QRsCt181EJcrXFXvNGTYk4AESKZ4g3
         DPlgoyQevi+Sfx4VuuyOrgdWCPxcpsXAuHx0RjooO7KLV/Nyy3uMlb2ET1v7ab1N00hv
         /+uy+2ySqO9vxBfjskYB6+3WHgU/GiJjomGLB92agGrJTmFEo53xp5f9CNOu2Dv0CENe
         pRiw==
X-Gm-Message-State: AGi0PubC/olQkV5cCQeVrb1g0tXZ92EDdHxiLwqnm/WiJpQ0F41N3u1H
        KYEOrHd8r91RPyXxx10AcnkaCq0q
X-Google-Smtp-Source: APiQypK+aStJd2TrI3rBfVtB8W+7HTndD9+ZYTPuTAOznY/9PLTEH7pYXQILNl0yj+iQF4rgGR4EVw==
X-Received: by 2002:a65:62ce:: with SMTP id m14mr26427472pgv.174.1588055038933;
        Mon, 27 Apr 2020 23:23:58 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id u188sm14183071pfu.33.2020.04.27.23.23.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 23:23:58 -0700 (PDT)
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
Subject: [PATCH v4 7/7] KVM: VMX: Handle preemption timer fastpath
Date:   Tue, 28 Apr 2020 14:23:29 +0800
Message-Id: <1588055009-12677-8-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588055009-12677-1-git-send-email-wanpengli@tencent.com>
References: <1588055009-12677-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

This patch implements handle preemption timer fastpath, after timer fire
due to VMX-preemption timer counts down to zero, handle it as soon as
possible and vmentry immediately without checking various kvm stuff when
possible.

Testing on SKX Server.

cyclictest in guest(w/o mwait exposed, adaptive advance lapic timer is default -1):

5540.5ns -> 4602ns       17%

kvm-unit-test/vmexit.flat:

w/o avanced timer:
tscdeadline_immed: 3028.5  -> 2494.75  17.6%
tscdeadline:       5765.7  -> 5285      8.3%

w/ adaptive advance timer default -1:
tscdeadline_immed: 3123.75 -> 2583     17.3%
tscdeadline:       4663.75 -> 4537      2.7%

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bb5c4f1..7dcc99f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5556,17 +5556,34 @@ static int handle_pml_full(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static int handle_preemption_timer(struct kvm_vcpu *vcpu)
+static int __handle_preemption_timer(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	if (!vmx->req_immediate_exit &&
-	    !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled))
+	    !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
 		kvm_lapic_expired_hv_timer(vcpu);
+		return 1;
+	}
 
+	return 0;
+}
+
+static int handle_preemption_timer(struct kvm_vcpu *vcpu)
+{
+	__handle_preemption_timer(vcpu);
 	return 1;
 }
 
+static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
+{
+	if (__handle_preemption_timer(vcpu)) {
+		trace_kvm_exit(EXIT_REASON_PREEMPTION_TIMER, vcpu, KVM_ISA_VMX);
+		return EXIT_FASTPATH_REENTER_GUEST;
+	}
+	return EXIT_FASTPATH_NONE;
+}
+
 /*
  * When nested=0, all VMX instruction VM Exits filter here.  The handlers
  * are overwritten by nested_vmx_setup() when nested=1.
@@ -6590,6 +6607,8 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 		switch (to_vmx(vcpu)->exit_reason) {
 		case EXIT_REASON_MSR_WRITE:
 			return handle_fastpath_set_msr_irqoff(vcpu);
+		case EXIT_REASON_PREEMPTION_TIMER:
+			return handle_fastpath_preemption_timer(vcpu);
 		default:
 			return EXIT_FASTPATH_NONE;
 		}
-- 
2.7.4

