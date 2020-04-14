Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E251D1A6FED
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 02:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbgDNAJx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 20:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727878AbgDNAJw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Apr 2020 20:09:52 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C24C0A3BDC
        for <kvm@vger.kernel.org>; Mon, 13 Apr 2020 17:09:51 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id nk12so11486957pjb.0
        for <kvm@vger.kernel.org>; Mon, 13 Apr 2020 17:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=YMAMGjofNrizjMQg7853fdoEDjx8XPUx997J+0sDJxw=;
        b=cnPYGmeR+Wv3TAO/DK3N42nMq5aREZ/RY/NPt0TKXw1z77l7AHmPaMmTNwSer3g9Tq
         Rja+k8BVsALShQ8C/KXja75W/eUEVzUlA9l6Y5Dooh/HOHh42oAgcVxMtXQtW6VeREK5
         5RaXUZtPGI3ZSkxx3ZJWHWDlZDCcTTcJ7Dz15eEZd/lL8UYdmMWMvczSMHbek70ejLPb
         TUpJFYHSfPdCzVrh9n/WGJQEFMfWfZUb2YJao+s8cJ0q2GQ/uGUz66fNtpBE+hF/9ecO
         eOpOjRLsPaPc67hPnEuw19KSFrXhi9gAqWrMvChyrCu1pLKZFuZejYU2RoPzhRwJiOm/
         mweA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=YMAMGjofNrizjMQg7853fdoEDjx8XPUx997J+0sDJxw=;
        b=bsmhoa5G65xu928yvE+iX+JDWH7DuEgUqOm7LXg+UxUAnC2eekIZQpKVi0AxPztBm9
         CWBYIFoP2PPaPGVjRRU4y4aSxnedutbfdkHrQ5/4G1d9W/mQc1Wq22TDJo9PuUBtQ5kG
         yGlVZ+1VG1YPsRzBzkX4nTk1/kXA7FBMT8PriIQJDv5/majLuO6zWV1gXi7tLPpLhw6o
         SJIfmjdBrV2Kss7MJwumRNiX1b0kbjxhaYxrTCZuW7yoc7I6Rz4H5l5KDowApzgeEaNU
         iWG8Ml2FRzmJXBNbkJYx0dNybB3/HyS1IEkQHi20utrZ5H+G9mzXyrHyDjQwwK29sgUn
         uVwA==
X-Gm-Message-State: AGi0PuZAGBrwoc1yd9nqX6UCgew8rR5U3FPOLBAGBWyZ7SkY8rzLrCsc
        rXT6QrfAXeG2US+ZahNA8V+yPPDAtGph2XMEaM7tGdDVOol9NHdUK8htIEZwBATOpYHB0SzEEJE
        EsMi/NC3qjcxiNBB7ZhwG85V8qErCSJ8BmGShtJapoA+IQPrZgH6iaT5uMiZfIgM=
X-Google-Smtp-Source: APiQypKJitwlyTtBXJfhQXPBfulHK50aZiXWH/9tfItCw3vHHP7Ax6RbvcjpRDiLrC9ysvsNNYpH/QDZVjIQKg==
X-Received: by 2002:a17:90a:fa01:: with SMTP id cm1mr22776943pjb.113.1586822991264;
 Mon, 13 Apr 2020 17:09:51 -0700 (PDT)
Date:   Mon, 13 Apr 2020 17:09:45 -0700
Message-Id: <20200414000946.47396-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [PATCH 1/2] kvm: nVMX: Pending debug exceptions trump expired
 VMX-preemption timer
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Previously, if L1 launched vmcs12 with both pending debug exceptions
and an already-expired VMX-preemption timer, the pending debug
exceptions were lost due to a priority inversion between a pending #DB
exception and a "VMX-preemption timer expired" VM-exit from L2 to L1.

In this scenario, L0 constructs a vmcs02 that has both a zero-valued
VMX-preemption timer (assuming enable_preemption_timer is set) and
pending debug exceptions. When the vmcs02 is launched/resumed, the
hardware correctly prioritizes the pending debug exceptions. At this
point, L0 intercepts the resulting #DB trap and queues it up for
redelivery. However, when checking for nested events in software, L0
incorrectly prioritizes the "VMX-preemption timer expired" VM-exit
from L2 to L1.

Technically, nested events should probably be blocked at this
point. Hardware has already determined that the #DB trap is the next
event that should happen. L0 just got in the way because it was
concerned about infinite IDT vectoring loops.

Logically, the enqueued #DB trap is quite similar to a "reinjected"
event resulting from interrupted IDT-vectoring. Treating it as such
fixes the problem, since nested events are blocked when a reinjected
event is present. However, there are some ways in which the enqueued
interrupted IDT-vectoring. In particular, it should not be recorded in
the IDT-vectoring information field of the vmcs12 in the event of a
synthesized VM-exit from L2 to L1. I don't believe that path should
ever be taken, since the #DB trap should take priority over any
synthesized VM-exit from L2 to L1.

Recategorize both the reinjected #DB and #AC exceptions as
"reinjected" exceptions. For consistency, do the same thing for SVM,
even though it doesn't have a VMX-preemption timer equivalent.

Fixes: f4124500c2c13 ("KVM: nVMX: Fully emulate preemption timer")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/svm/svm.c | 4 ++--
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2be5bbae3a40..26b30099c4e4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1739,7 +1739,7 @@ static int db_interception(struct vcpu_svm *svm)
 	if (!(svm->vcpu.guest_debug &
 	      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)) &&
 		!svm->nmi_singlestep) {
-		kvm_queue_exception(&svm->vcpu, DB_VECTOR);
+		kvm_requeue_exception(&svm->vcpu, DB_VECTOR);
 		return 1;
 	}
 
@@ -1778,7 +1778,7 @@ static int ud_interception(struct vcpu_svm *svm)
 
 static int ac_interception(struct vcpu_svm *svm)
 {
-	kvm_queue_exception_e(&svm->vcpu, AC_VECTOR, 0);
+	kvm_requeue_exception_e(&svm->vcpu, AC_VECTOR, 0);
 	return 1;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 83050977490c..aae01253bfba 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4682,7 +4682,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 			if (is_icebp(intr_info))
 				WARN_ON(!skip_emulated_instruction(vcpu));
 
-			kvm_queue_exception(vcpu, DB_VECTOR);
+			kvm_requeue_exception(vcpu, DB_VECTOR);
 			return 1;
 		}
 		kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1;
@@ -4703,7 +4703,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		break;
 	case AC_VECTOR:
 		if (guest_inject_ac(vcpu)) {
-			kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
+			kvm_requeue_exception_e(vcpu, AC_VECTOR, error_code);
 			return 1;
 		}
 
-- 
2.26.0.110.g2183baf09c-goog

