Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFCE63C8AF
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 20:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236278AbiK2TmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 14:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236955AbiK2TlS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 14:41:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F955EFAC
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 11:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669750699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zbNm6u7VwMLnnR5d0F1qjMdQ/5J2+Ysx2Y9gYe/zZwQ=;
        b=X0JnGBW7aYkVjciKNKX1OlDqKuO+9sn3mygQypANNhSkdvb/nwZs3XC6dH4qLxEk00U3oa
        v67MQnbvBnXis/gy9xtMFBdR4JIBgjD7TcT6EempLooYMDKvmtg9H/wit7IfOjYfJf6b7h
        9xs+jJXwSFnIuAgpp5SxgC0rbTKiQrY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-UxmNabJBMqKYQKTIqYI29A-1; Tue, 29 Nov 2022 14:38:10 -0500
X-MC-Unique: UxmNabJBMqKYQKTIqYI29A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF1CB3C0F22F;
        Tue, 29 Nov 2022 19:38:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80E782027061;
        Tue, 29 Nov 2022 19:38:05 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Santosh Shukla <santosh.shukla@amd.com>
Subject: [PATCH v2 11/11] KVM: nSVM: implement support for nested VNMI
Date:   Tue, 29 Nov 2022 21:37:17 +0200
Message-Id: <20221129193717.513824-12-mlevitsk@redhat.com>
In-Reply-To: <20221129193717.513824-1-mlevitsk@redhat.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch allows L1 to use vNMI to accelerate its injection
of NMIs to L2 by passing through vNMI int_ctl bits from vmcb12
to/from vmcb02.

While L2 runs, L1's vNMI is inhibited, and L1's NMIs are injected
normally.

In order to support nested VNMI requires saving and restoring the VNMI
bits during nested entry and exit.
In case of L1 and L2 both using VNMI- Copy VNMI bits from vmcb12 to
vmcb02 during entry and vice-versa during exit.
And in case of L1 uses VNMI and L2 doesn't- Copy VNMI bits from vmcb01 to
vmcb02 during entry and vice-versa during exit.

Tested with the KVM-unit-test and Nested Guest scenario.


Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 13 ++++++++++++-
 arch/x86/kvm/svm/svm.c    |  5 +++++
 arch/x86/kvm/svm/svm.h    |  6 ++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5bea672bf8b12d..81346665058e26 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -278,6 +278,11 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 	if (CC(!nested_svm_check_tlb_ctl(vcpu, control->tlb_ctl)))
 		return false;
 
+	if (CC((control->int_ctl & V_NMI_ENABLE) &&
+		!vmcb12_is_intercept(control, INTERCEPT_NMI))) {
+		return false;
+	}
+
 	return true;
 }
 
@@ -427,6 +432,9 @@ void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
 	if (nested_vgif_enabled(svm))
 		mask |= V_GIF_MASK;
 
+	if (nested_vnmi_enabled(svm))
+		mask |= V_NMI_MASK | V_NMI_PENDING;
+
 	svm->nested.ctl.int_ctl        &= ~mask;
 	svm->nested.ctl.int_ctl        |= svm->vmcb->control.int_ctl & mask;
 }
@@ -682,8 +690,11 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	else
 		int_ctl_vmcb01_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
 
-	if (vnmi)
+	if (vnmi) {
 		nested_svm_save_vnmi(svm);
+		if (nested_vnmi_enabled(svm))
+			int_ctl_vmcb12_bits |= (V_NMI_PENDING | V_NMI_ENABLE | V_NMI_MASK);
+	}
 
 	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
 	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index bf10adcf3170a8..fb203f536d2f9b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4214,6 +4214,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	svm->vgif_enabled = vgif && guest_cpuid_has(vcpu, X86_FEATURE_VGIF);
 
+	svm->vnmi_enabled = vnmi && guest_cpuid_has(vcpu, X86_FEATURE_AMD_VNMI);
+
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
 	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
@@ -4967,6 +4969,9 @@ static __init void svm_set_cpu_caps(void)
 		if (vgif)
 			kvm_cpu_cap_set(X86_FEATURE_VGIF);
 
+		if (vnmi)
+			kvm_cpu_cap_set(X86_FEATURE_AMD_VNMI);
+
 		/* Nested VM can receive #VMEXIT instead of triggering #GP */
 		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0b7e1790fadde1..8fb2085188c5ac 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -271,6 +271,7 @@ struct vcpu_svm {
 	bool pause_filter_enabled         : 1;
 	bool pause_threshold_enabled      : 1;
 	bool vgif_enabled                 : 1;
+	bool vnmi_enabled                 : 1;
 
 	u32 ldr_reg;
 	u32 dfr_reg;
@@ -545,6 +546,11 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
 }
 
+static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
+{
+	return svm->vnmi_enabled && (svm->nested.ctl.int_ctl & V_NMI_ENABLE);
+}
+
 static inline bool is_x2apic_msrpm_offset(u32 offset)
 {
 	/* 4 msrs per u8, and 4 u8 in u32 */
-- 
2.26.3

