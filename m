Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A53F46CA5D
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 02:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234060AbhLHB6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 20:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243239AbhLHB6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 20:58:22 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216E9C061746
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 17:54:51 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id m129-20020a632687000000b00324df4ad6c7so420160pgm.19
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 17:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=dJfQR7SNrodeHl+1uM4QnaH90bN7dxbb2nVm/KO0Fr0=;
        b=E6q7ZoNKap3puayKpMyApx5aMM7cpIA29jNBAm9RU9qZ2GsBRZJfo9m90cE5YibjKS
         /Oqgenvs55WfnwkYUvBoCk+My3oUfiaTjkyMxYFWO3kk1h8G8HtGhEo6Irx/isGI39P8
         YAupJ+v5JJALrli/83tKDSLpVhDiUSKDU/wVs7ag7lbqCuykiVB1elNOTh55hiyT8D9v
         jmnX+mcFaHf8KkrFeSKV3qxr2kd4tBBqfQlKRW6eshGxdpztNEqJsQJh8QwW4i9TNc0q
         rlqaM09jieisbicgfB7o9jhF24ra4lV3zdBRr9IhEOVwZ6sT5TUz2j1F46A73P/S5cS7
         l4RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=dJfQR7SNrodeHl+1uM4QnaH90bN7dxbb2nVm/KO0Fr0=;
        b=k6fHzs5BiGJxuY4VLottpPDy1pAc9AvBg9BkpbNg/q0qzZT7l5dbHdPGcsDJMrvIZ1
         WJ4qufSkEVUgEk05IGm0lBmzclOPDzedX+ANsdoSM8pMa0ll04RbtjHrrxZS6eCUuJ58
         7moWK3KunL7F3eeLT9Lf1sPXwb6wGPN5LWZn0EIhCiv5pmLSVcTRh7o9fjIsPV7Xw87a
         iiD6m+IFrX9hhd31J5mmY4tbTVwZsNAuGy65rkyTKxBiWyr95ebmziClLJFAF1JDEog9
         81fsQYRzaosmbiN87V1pu6HaaKvSoui6+ZOJlsMiGnftklc6HabUinn29/znCM2FJjvw
         NPhg==
X-Gm-Message-State: AOAM530TCV5bupKPuN97SvgzNbgnFcgH7YmqpA0NeCtfUHfEApCN3gtH
        VH0n9u0fA0niLHEXnGerTT7a5+pHkIM=
X-Google-Smtp-Source: ABdhPJzRAo1jT1w67ssZL5EULvdAsrstbRdTXsE4od1JORZJT4BANLfRDFxRIq1Nz+VdNTWiu5B+Wyay4gI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:300d:b0:142:744f:c74d with SMTP id
 o13-20020a170903300d00b00142744fc74dmr56964166pla.26.1638928490614; Tue, 07
 Dec 2021 17:54:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Dec 2021 01:52:12 +0000
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Message-Id: <20211208015236.1616697-3-seanjc@google.com>
Mime-Version: 1.0
References: <20211208015236.1616697-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 02/26] KVM: nVMX: Ensure vCPU honors event request if
 posting nested IRQ fails
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a memory barrier between writing vcpu->requests and reading
vcpu->guest_mode to ensure the read is ordered after the write when
(potentially) delivering an IRQ to L2 via nested posted interrupt.  If
the request were to be completed after reading vcpu->mode, it would be
possible for the target vCPU to enter the guest without posting the
interrupt and without handling the event request.

Note, the barrier is only for documentation since atomic operations are
serializing on x86.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Fixes: 6b6977117f50 ("KVM: nVMX: Fix races when sending nested PI while dest enters/leaves L2")
Fixes: 705699a13994 ("KVM: nVMX: Enable nested posted interrupt processing")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index efcc5a58abbc..a94f0fb80fd4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3941,6 +3941,19 @@ static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
 		 */
 		vmx->nested.pi_pending = true;
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
+
+		/*
+		 * This pairs with the smp_mb_*() after setting vcpu->mode in
+		 * vcpu_enter_guest() to guarantee the vCPU sees the event
+		 * request if triggering a posted interrupt "fails" because
+		 * vcpu->mode != IN_GUEST_MODE.  The extra barrier is needed as
+		 * the smb_wmb() in kvm_make_request() only ensures everything
+		 * done before making the request is visible when the request
+		 * is visible, it doesn't ensure ordering between the store to
+		 * vcpu->requests and the load from vcpu->mode.
+		 */
+		smp_mb__after_atomic();
+
 		/* the PIR and ON have been set by L1. */
 		if (!kvm_vcpu_trigger_posted_interrupt(vcpu, true))
 			kvm_vcpu_kick(vcpu);
@@ -3974,6 +3987,12 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 	if (pi_test_and_set_on(&vmx->pi_desc))
 		return 0;
 
+	/*
+	 * The implied barrier in pi_test_and_set_on() pairs with the smp_mb_*()
+	 * after setting vcpu->mode in vcpu_enter_guest(), thus the vCPU is
+	 * guaranteed to see PID.ON=1 and sync the PIR to IRR if triggering a
+	 * posted interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
+	 */
 	if (vcpu != kvm_get_running_vcpu() &&
 	    !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
 		kvm_vcpu_kick(vcpu);
-- 
2.34.1.400.ga245620fadb-goog

