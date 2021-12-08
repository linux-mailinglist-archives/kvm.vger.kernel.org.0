Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BC446CA97
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 02:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239171AbhLHB7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 20:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243525AbhLHB6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 20:58:53 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4473C0698D4
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 17:55:18 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id g10-20020a63520a000000b003316b108e1aso444423pgb.6
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 17:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=rsEyQZ3DP35HLKbmnGk57dHMCfFGAuWmWI/6PgsECHs=;
        b=hmKYUrxitUrLwoogjptnDL/ItRNyBWfvVS9Wu829MCVieaIX/69uvnMqZoWgsv4/Sq
         KDhuHw01hnhIklE4ptBeKj3ufvxBQ4lnCrnn/qi7szxPYTTl/+WMp4gsAqmSl7HbeSxr
         Kl6Is8rRCv9pnDzLHe10jdOzymQ3C1BE7AFq3WOgNf+2dcRyiY/PMBzZLplZqf2+K1qU
         5gLqaGdirXNOKlVwItpG5Ngw09mQMVdBqSDxbAWy2O1xsdMfl4U4QGuMeO5gOJfLjjm6
         ImLq1x3TtdSq8N5XABQHSr/HqN4q3QwMqB4vnhIkvHlX932XlxC+PfHF6L36lUGb4pqn
         L2+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=rsEyQZ3DP35HLKbmnGk57dHMCfFGAuWmWI/6PgsECHs=;
        b=1OH/7OXkmwtWW9B/r0/NTy8eQ2k4PguMF6GB41CSxNinaczxxOBZQgyO2FQ86Qksq3
         M3LC4xJDbPTXzwQeUI+18Cp1qx2ANYPv9XvcP+WSh0x+HlFElgpYnzcj27l8wJJJK1FI
         ym3sdYg1LJW/0D/CshybQHIAm6BYewSq2M3xEuJinYHjUK4WN1Yk5791f/5WwLU8QvO2
         KQ/A1LLJmwX3oNTPbOeQUMWxM4yOmi6A9HgcQ0dQ4k2gNh6FlCIbe1topFgiAxYrtTiQ
         kB6qHQXf8nDa3QJy8NueXirLlwGN7oAGtj5deWkxccr/LJBl6ke1BARIhNkw71D9lPTl
         n7eA==
X-Gm-Message-State: AOAM532omiBPSmBli6hegnCRJZJMH924DqzqyYJOHPNcWCwnedlVO/1A
        PXJqN0cwsGu2rzpb/ixDJkdK8xgqNtc=
X-Google-Smtp-Source: ABdhPJxc6ZNvK2ni0NY4zn1pqNTbfF6S4S3QCEyDwLu/l6woBMqErCmjW6iRbSGR/2Al2p3yHA0CHhwy/Z0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:e810:b0:141:d8e9:a8b0 with SMTP id
 u16-20020a170902e81000b00141d8e9a8b0mr55667312plg.9.1638928518234; Tue, 07
 Dec 2021 17:55:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Dec 2021 01:52:29 +0000
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Message-Id: <20211208015236.1616697-20-seanjc@google.com>
Mime-Version: 1.0
References: <20211208015236.1616697-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 19/26] KVM: VMX: Fold fallback path into triggering posted
 IRQ helper
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

Move the fallback "wake_up" path into the helper to trigger posted
interrupt helper now that the nested and non-nested paths are identical.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ff309ebe9f2c..9153f5f5d424 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3889,7 +3889,7 @@ static void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
 	pt_update_intercept_for_msr(vcpu);
 }
 
-static inline bool kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
+static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
 						     int pi_vec)
 {
 #ifdef CONFIG_SMP
@@ -3920,10 +3920,15 @@ static inline bool kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
 		 */
 
 		apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
-		return true;
+		return;
 	}
 #endif
-	return false;
+	/*
+	 * The vCPU isn't in the guest; wake the vCPU in case it is blocking,
+	 * otherwise do nothing as KVM will grab the highest priority pending
+	 * IRQ via ->sync_pir_to_irr() in vcpu_enter_guest().
+	 */
+	kvm_vcpu_wake_up(vcpu);
 }
 
 static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
@@ -3953,8 +3958,7 @@ static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
 		smp_mb__after_atomic();
 
 		/* the PIR and ON have been set by L1. */
-		if (!kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_NESTED_VECTOR))
-			kvm_vcpu_wake_up(vcpu);
+		kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_NESTED_VECTOR);
 		return 0;
 	}
 	return -1;
@@ -3991,9 +3995,7 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 	 * guaranteed to see PID.ON=1 and sync the PIR to IRR if triggering a
 	 * posted interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
 	 */
-	if (!kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_VECTOR))
-		kvm_vcpu_wake_up(vcpu);
-
+	kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_VECTOR);
 	return 0;
 }
 
-- 
2.34.1.400.ga245620fadb-goog

