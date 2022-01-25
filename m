Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D63649B37E
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 13:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391989AbiAYMEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 07:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382757AbiAYMAo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 07:00:44 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DBB3C06173B;
        Tue, 25 Jan 2022 04:00:30 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id w12-20020a17090a528c00b001b276aa3aabso1911538pjh.0;
        Tue, 25 Jan 2022 04:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=Z2eSIKO2hPoT+F0EzCBQkbD8++MWEeeyBWhA5iN+68Y=;
        b=ALI7ZgAa3oPCEuVPuONBKC63VKdQnQJeEy7qFRK699JkPvR7gWOFbzGjLsglzuYD52
         2yHA3r92N2bIK0ZksZD8njL5BAlHHcNCheGp1PHn+D1fVjO76qBpFlTNfLnUv/DlR7DW
         AO2VFW08Twc34e8cqgQS/gaYEmzYtu2iaW6IVT/QEfqVPibZoSv/2zt8U8wwCsqJuEAH
         1M2Vl5l55ywHvBrjbwXyTAM1idFUjbWRv+K5t5Tz/yk+mObHo5H3zy6OG02HLn9MUZsS
         T7MCeAg5A30xSfp9RtGu0u+EoShs6bZ6VVL7rvBi6YfpwnJ7BGb+qeovwbebc1cVJICc
         vE2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Z2eSIKO2hPoT+F0EzCBQkbD8++MWEeeyBWhA5iN+68Y=;
        b=sfFITQCQSJDzN0Sq3ap2cHgQGRfVa1SXUSIB9o26LwUsDPGE1f81dRli186yl3jtU7
         E/tg3kx9rZo48Q+pELESi+WplbsRK5AmnjOtF7IE7TVGoQuQNOYdbLZQ02Wav1iYCFND
         qy9HXsZh8F5HeQkDZg+dcAE/stGR6qIC4OdSwFEBnYYCcfW6/j7SRWXX6Swa2m4rNBsi
         hDF2hXux+QwIcltL36eu0t5BpsN1JVKFQshdaaPLagCFx4iirFmYHaw3ofBDoj1y33SD
         mnGi6BcoeXQw0e6MxMNU8GkNbs2L9LWCECR1kZMRW5kx5XHhztMjoLSYaUfeQYBfRgYi
         9gzQ==
X-Gm-Message-State: AOAM531ZIVAp1gjlCBeSEHd6gAazQ3KIHWB5BVIgawcHNEiV+HDnLl0s
        ypRGLMm0ma8R2RWLnzdlgODJ+VhPlwoAsQ==
X-Google-Smtp-Source: ABdhPJxboyPEW0uwim9wsTVOxgUlkUtCTkh+LyP78FY20vNjpwPE1Uw/P3LJf5XOzjr/65Rvwj6LJQ==
X-Received: by 2002:a17:90a:de08:: with SMTP id m8mr3209326pjv.102.1643112029424;
        Tue, 25 Jan 2022 04:00:29 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.110])
        by smtp.googlemail.com with ESMTPSA id ga21sm2566108pjb.2.2022.01.25.04.00.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 04:00:29 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH RESEND v2] KVM: VMX: Dont' send posted IRQ if vCPU == this vCPU and vCPU is IN_GUEST_MODE
Date:   Tue, 25 Jan 2022 03:59:39 -0800
Message-Id: <1643111979-36447-1-git-send-email-wanpengli@tencent.com>
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

