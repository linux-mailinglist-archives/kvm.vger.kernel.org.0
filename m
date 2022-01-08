Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D0F4880F3
	for <lists+kvm@lfdr.de>; Sat,  8 Jan 2022 03:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbiAHCne (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 21:43:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiAHCnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 21:43:33 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E85EC061574;
        Fri,  7 Jan 2022 18:43:33 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso8556802pjb.1;
        Fri, 07 Jan 2022 18:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=Z2eSIKO2hPoT+F0EzCBQkbD8++MWEeeyBWhA5iN+68Y=;
        b=glfc7fN0TWPpbZ+AVWEc/w6+06Iuf0L3kedFBlWLaOikOcNjAnKCc1RLxuUPJGYoPx
         kRI3Bty9geKEQbfp4wfI6AkRFC3/ZpUdxPQdNMfxD8Zky/MR8nmXioXB2Lu1XGtuzqzR
         D9GaQdYY9JPNMob1ODQJNFe2u65KSdxJ9aGHcm88hCX0STJCN0nl/znYbAbK8YIpOZ23
         XCVlM3iBOI1HIBcGhK+JDg7JGyMzDC3XWcIZ08mblXXPkIIbKany7SpiBo+ZvJJMcqML
         alrXGSKHHWemJFQ8LZP0yYTtYzCJWw498T3TYilKLDbOF5hMMruhS0M/lepKqNYVbYX9
         XVgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Z2eSIKO2hPoT+F0EzCBQkbD8++MWEeeyBWhA5iN+68Y=;
        b=lQ3mMvsC8WJt0YBLbGT0eof0Yx7DlNMSHvpwMI+rl+qlv0kcvnbj4ChJJS0h2+z47X
         fdZG1xXsrLIu945QOl9DRd3waNLZZ97RgYq1ikWFlMtw19G4AlhXvwvOiybuI4w6ZBjG
         jUka2uTzmHf0IIy/7LKpuptRe43BF01uCiJajcUrMqe+lnaGfuGPEBAt07qlic0W9GtK
         mymKmGvsDVCJhrQV/or3P9mX+ZBIFHL3cf3Htn6Ny9khUqhys2Yql/qmnQlTP1niqHTf
         +CBzoKcgPIy2jarDdbubx7k42irXSxiq4hx8z+wM9RmitOGr57yAJTyk0BUbJQD1Wbd0
         /XLA==
X-Gm-Message-State: AOAM5313TKYL9b8ttMycBHxWpT937igqAMAkvf/o7yNkZmtFiDre6Lq8
        x9rmNHGt9PSR4Os8ZGKttEuiL1o8hu2Dcw==
X-Google-Smtp-Source: ABdhPJwDPz958rqpbQg7VFAdWApy6Jg0jxDxj+Vx1RjRcmmJVR6qZoGUUb6M6atUfFhwXtJoswZqKw==
X-Received: by 2002:a17:902:b696:b0:149:9e52:eda1 with SMTP id c22-20020a170902b69600b001499e52eda1mr41304901pls.174.1641609812983;
        Fri, 07 Jan 2022 18:43:32 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.116])
        by smtp.googlemail.com with ESMTPSA id f12sm226250pfe.127.2022.01.07.18.43.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jan 2022 18:43:32 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2] KVM: VMX: Dont' send posted IRQ if vCPU == this vCPU and vCPU is IN_GUEST_MODE
Date:   Fri,  7 Jan 2022 18:42:42 -0800
Message-Id: <1641609762-39471-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

When delivering a virtual interrupt, don't actually send a posted interrupt
if the target vCPU is also the currently running vCPU and is IN_GUEST_MODE,
in which case the interrupt is being sent from a VM-Exit fastpath and the
core run loop in vcpu_enter_guest() will manually move the interrupt from
the PIR to vmcs.GUEST_RVI.  IRQs are disabled while IN_GUEST_MODE, thus
there's no possibility of the virtual interrupt being sent from anything
other than KVM, i.e. KVM won't suppress a wake event from an IRQ handler
(see commit fdba608f15e2, "KVM: VMX: Wake vCPU when delivering posted IRQ
even if vCPU == this vCPU").

Eliding the posted interrupt restores the performance provided by the
combination of commits 379a3c8ee444 ("KVM: VMX: Optimize posted-interrupt
delivery for timer fastpath") and 26efe2fd92e5 ("KVM: VMX: Handle
preemption timer fastpath").

Thanks Sean for better comments.

Suggested-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fe06b02994e6..e06377c9a4cf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3908,31 +3908,33 @@ static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
 #ifdef CONFIG_SMP
 	if (vcpu->mode == IN_GUEST_MODE) {
 		/*
-		 * The vector of interrupt to be delivered to vcpu had
-		 * been set in PIR before this function.
+		 * The vector of the virtual has already been set in the PIR.
+		 * Send a notification event to deliver the virtual interrupt
+		 * unless the vCPU is the currently running vCPU, i.e. the
+		 * event is being sent from a fastpath VM-Exit handler, in
+		 * which case the PIR will be synced to the vIRR before
+		 * re-entering the guest.
 		 *
-		 * Following cases will be reached in this block, and
-		 * we always send a notification event in all cases as
-		 * explained below.
+		 * When the target is not the running vCPU, the following
+		 * possibilities emerge:
 		 *
-		 * Case 1: vcpu keeps in non-root mode. Sending a
-		 * notification event posts the interrupt to vcpu.
+		 * Case 1: vCPU stays in non-root mode. Sending a notification
+		 * event posts the interrupt to the vCPU.
 		 *
-		 * Case 2: vcpu exits to root mode and is still
-		 * runnable. PIR will be synced to vIRR before the
-		 * next vcpu entry. Sending a notification event in
-		 * this case has no effect, as vcpu is not in root
-		 * mode.
+		 * Case 2: vCPU exits to root mode and is still runnable. The
+		 * PIR will be synced to the vIRR before re-entering the guest.
+		 * Sending a notification event is ok as the host IRQ handler
+		 * will ignore the spurious event.
 		 *
-		 * Case 3: vcpu exits to root mode and is blocked.
-		 * vcpu_block() has already synced PIR to vIRR and
-		 * never blocks vcpu if vIRR is not cleared. Therefore,
-		 * a blocked vcpu here does not wait for any requested
-		 * interrupts in PIR, and sending a notification event
-		 * which has no effect is safe here.
+		 * Case 3: vCPU exits to root mode and is blocked. vcpu_block()
+		 * has already synced PIR to vIRR and never blocks the vCPU if
+		 * the vIRR is not empty. Therefore, a blocked vCPU here does
+		 * not wait for any requested interrupts in PIR, and sending a
+		 * notification event also results in a benign, spurious event.
 		 */
 
-		apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
+		if (vcpu != kvm_get_running_vcpu())
+			apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
 		return;
 	}
 #endif
-- 
2.25.1

