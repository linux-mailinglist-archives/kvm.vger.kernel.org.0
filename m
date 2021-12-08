Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9C046CA91
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 02:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243485AbhLHB7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 20:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243484AbhLHB6s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 20:58:48 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E570C061D60
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 17:55:17 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id j9-20020a17090a31c900b001abe663b508so2760429pjf.1
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 17:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=iR5gsD/RoTX7Ab+ckhbUw8O3OI7/VYiJinLA00sLWPI=;
        b=WNsSNhrKWtiZPTt79yrGjP2QXJ/zO4dHXmq3vDHqWoxkLtAw17Zd8KscsmjJ5oexGb
         kAliVyZsQqhQdPrNDF3PQfsQUXNjABbMqKTfY/BVR8fXS8Rneja+8reFa1F4jOY/pcwE
         ciNn2DfNsN5BCZfZNfVggHMXqCUKq8favBTGeLtEPSZW/WIq7X2hNEVmhRguMWaIdO9s
         syVWjmq8jby34MQJXy+NvG7hmIQPQQK0w5i4VP2C4a8r84Dfz7Xux7plAzDVBCSdKRWp
         IY0wZ1LxRDp71LCRqLSV6xYBQgPTInG/LmrBIv48mELobkYVfcjaB7HqC1PidJ96oxdN
         9/2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=iR5gsD/RoTX7Ab+ckhbUw8O3OI7/VYiJinLA00sLWPI=;
        b=mzNcx2UwUtiPJk2abVw/SNOJB2GaqO1ZS95V+39KB56BAXrOWKeMquNKv7dUP32tRM
         WpJm9SwPwKDgmWUqwXyw9mkbVrtoPejgibG4DQ+7WS5cG5ybHh9UqmIJAXwnM8V1xSI0
         U+5/aTi8n0aOk5qeO0Y8564A4v2Xkx1W8DVS/z2sKgLuFs95NrM3B2o4xguLjkmSNx4G
         aLLri8tGFaKzP+m7MjpZ2KDAy+QRLL9t6HVJjR+vaiCmKRmSY0Ay8OqI3S6l+BYieL6T
         oUCRiMVMh8ORPalfiQmmvsm1lm0Ur+148qpEpLdOttyqyeIzoGqauoYLnLvJq72pK1Jf
         ntPA==
X-Gm-Message-State: AOAM5307wX3YMRN0k7Q7sn0UESpt54UYVlvnZg3flKAfe5D/6OBGwRIv
        cin+qyb8x1Yi5SFV6ATcUkq6maaGHz8=
X-Google-Smtp-Source: ABdhPJwcoBXXZdmSOghfbE08/EmszWpxoDmbsXidfNKiYXB2oVUXH7tNkAdX5obuN8xCpGSVDdPKRG2yOvc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:1913:: with SMTP id
 19mr3513966pjg.174.1638928516567; Tue, 07 Dec 2021 17:55:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Dec 2021 01:52:28 +0000
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Message-Id: <20211208015236.1616697-19-seanjc@google.com>
Mime-Version: 1.0
References: <20211208015236.1616697-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 18/26] KVM: VMX: Pass desired vector instead of bool for
 triggering posted IRQ
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

Refactor the posted interrupt helper to take the desired notification
vector instead of a bool so that the callers are self-documenting.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0eac98589472..ff309ebe9f2c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3890,11 +3890,9 @@ static void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
 }
 
 static inline bool kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
-						     bool nested)
+						     int pi_vec)
 {
 #ifdef CONFIG_SMP
-	int pi_vec = nested ? POSTED_INTR_NESTED_VECTOR : POSTED_INTR_VECTOR;
-
 	if (vcpu->mode == IN_GUEST_MODE) {
 		/*
 		 * The vector of interrupt to be delivered to vcpu had
@@ -3955,7 +3953,7 @@ static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
 		smp_mb__after_atomic();
 
 		/* the PIR and ON have been set by L1. */
-		if (!kvm_vcpu_trigger_posted_interrupt(vcpu, true))
+		if (!kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_NESTED_VECTOR))
 			kvm_vcpu_wake_up(vcpu);
 		return 0;
 	}
@@ -3993,7 +3991,7 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 	 * guaranteed to see PID.ON=1 and sync the PIR to IRR if triggering a
 	 * posted interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
 	 */
-	if (!kvm_vcpu_trigger_posted_interrupt(vcpu, false))
+	if (!kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_VECTOR))
 		kvm_vcpu_wake_up(vcpu);
 
 	return 0;
-- 
2.34.1.400.ga245620fadb-goog

