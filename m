Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF4D4C8DEB
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 15:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235373AbiCAOiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 09:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235380AbiCAOiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 09:38:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7BEF5DEED
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 06:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646145453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UZn/J3TgQqi6vfLbBiqFIurfxYweQrbX0o9nRE/h1uI=;
        b=Lrkfd4syN58ns0JjpEm3KYII9c7FQAMKml6O+j4Dj2zBunpbdIwrf8WLhvkblfhArKnltG
        SHCTIZ06JKfRiG6ykxVTvQHIgj42qORAu1FIbK2ZbPmnSywWKo7hRrqArmOH8cZL3S3MPl
        TQ+Upba1v3M72jPr30JFc0ZUVIfJjag=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-lr4WI3LIOHWZyR_RUaH1CA-1; Tue, 01 Mar 2022 09:37:30 -0500
X-MC-Unique: lr4WI3LIOHWZyR_RUaH1CA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2AC41854E27;
        Tue,  1 Mar 2022 14:37:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E37EE842C9;
        Tue,  1 Mar 2022 14:37:23 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 4/7] KVM: x86: nSVM: support PAUSE filter threshold and count when cpu_pm=on
Date:   Tue,  1 Mar 2022 16:36:47 +0200
Message-Id: <20220301143650.143749-5-mlevitsk@redhat.com>
In-Reply-To: <20220301143650.143749-1-mlevitsk@redhat.com>
References: <20220301143650.143749-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow L1 to use these settings if L0 disables PAUSE interception
(AKA cpu_pm=on)

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c |  6 ++++++
 arch/x86/kvm/svm/svm.c    | 17 +++++++++++++++++
 arch/x86/kvm/svm/svm.h    |  2 ++
 3 files changed, 25 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 37510cb206190..4cb0bc49986d5 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -664,6 +664,12 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 	if (!nested_vmcb_needs_vls_intercept(svm))
 		svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 
+	if (svm->pause_filter_enabled)
+		svm->vmcb->control.pause_filter_count = svm->nested.ctl.pause_filter_count;
+
+	if (svm->pause_threshold_enabled)
+		svm->vmcb->control.pause_filter_thresh = svm->nested.ctl.pause_filter_thresh;
+
 	nested_svm_transition_tlb_flush(vcpu);
 
 	/* Enter Guest-Mode */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6a571eed32ef4..52198e63c5fc4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4008,6 +4008,17 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	svm->v_vmload_vmsave_enabled = vls && guest_cpuid_has(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
 
+	if (kvm_pause_in_guest(vcpu->kvm)) {
+		svm->pause_filter_enabled = pause_filter_count > 0 &&
+					    guest_cpuid_has(vcpu, X86_FEATURE_PAUSEFILTER);
+
+		svm->pause_threshold_enabled = pause_filter_thresh > 0 &&
+					    guest_cpuid_has(vcpu, X86_FEATURE_PFTHRESHOLD);
+	} else {
+		svm->pause_filter_enabled = false;
+		svm->pause_threshold_enabled = false;
+	}
+
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
 	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
@@ -4763,6 +4774,12 @@ static __init void svm_set_cpu_caps(void)
 		if (vls)
 			kvm_cpu_cap_set(X86_FEATURE_V_VMSAVE_VMLOAD);
 
+		if (pause_filter_count)
+			kvm_cpu_cap_set(X86_FEATURE_PAUSEFILTER);
+
+		if (pause_filter_thresh)
+			kvm_cpu_cap_set(X86_FEATURE_PFTHRESHOLD);
+
 		/* Nested VM can receive #VMEXIT instead of triggering #GP */
 		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a3c93f9c02847..6fa81eb3ffb78 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -234,6 +234,8 @@ struct vcpu_svm {
 	bool tsc_scaling_enabled          : 1;
 	bool lbrv_enabled                 : 1;
 	bool v_vmload_vmsave_enabled      : 1;
+	bool pause_filter_enabled         : 1;
+	bool pause_threshold_enabled      : 1;
 
 	u32 ldr_reg;
 	u32 dfr_reg;
-- 
2.26.3

