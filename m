Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B16C62DE57
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 15:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240535AbiKQOfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 09:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240359AbiKQOeg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 09:34:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12ED2A94C
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 06:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668695614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BRiRehiIas3vv9np5G0BO4HtZHrN+zn3ozCBnxST56A=;
        b=RGQl1/N66KURl0zVQN3WuLTyYbp5/1Zi5ofdIafG4D3MlIvuLAid0Ox/u5s6KYHP80B8fe
        zqPYN+DsHZ0GRK8rm4DAPyacvMgccxq0Lfc5FwQ9knDU8kiK8V1PWaywqu+JIFk1MbYToA
        XtcNri+OkflzdbBvHNCkEpdm+UycXyc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-RDKMU4pKPg6Zok40QL3vbw-1; Thu, 17 Nov 2022 09:33:29 -0500
X-MC-Unique: RDKMU4pKPg6Zok40QL3vbw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C2A5381494E;
        Thu, 17 Nov 2022 14:33:28 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2EF42166B29;
        Thu, 17 Nov 2022 14:33:24 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jing Liu <jing2.liu@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Babu Moger <babu.moger@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Santosh Shukla <santosh.shukla@amd.com>
Subject: [PATCH 11/13] KVM: nSVM: implement nested VNMI
Date:   Thu, 17 Nov 2022 16:32:40 +0200
Message-Id: <20221117143242.102721-12-mlevitsk@redhat.com>
In-Reply-To: <20221117143242.102721-1-mlevitsk@redhat.com>
References: <20221117143242.102721-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Santosh Shukla <santosh.shukla@amd.com>

In order to support nested VNMI requires saving and restoring the VNMI
bits during nested entry and exit.
In case of L1 and L2 both using VNMI- Copy VNMI bits from vmcb12 to
vmcb02 during entry and vice-versa during exit.
And in case of L1 uses VNMI and L2 doesn't- Copy VNMI bits from vmcb01 to
vmcb02 during entry and vice-versa during exit.

Tested with the KVM-unit-test and Nested Guest scenario.

Maxim:
   - moved the vNMI bits copying to nested_sync_int_ctl_from_vmcb02

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 13 +++++++++++++
 arch/x86/kvm/svm/svm.c    |  5 +++++
 arch/x86/kvm/svm/svm.h    |  6 ++++++
 3 files changed, 24 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 1f2b8492c8782f..c9fcdd691bb5a1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -442,6 +442,14 @@ static void nested_sync_int_ctl_from_vmcb02(struct vcpu_svm *svm,
 		 */
 		;
 
+	if (vnmi) {
+		/* copy back the vNMI fields which can be modified by the CPU */
+		if (nested_vnmi_enabled(svm))
+			l2_to_l1_mask |= V_NMI_MASK | V_NMI_PENDING;
+		else
+			l2_to_l0_mask |= V_NMI_MASK | V_NMI_PENDING;
+	}
+
 	vmcb12->control.int_ctl =
 		(svm->nested.ctl.int_ctl & ~l2_to_l1_mask) |
 		(vmcb02->control.int_ctl & l2_to_l1_mask);
@@ -657,6 +665,11 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	else
 		int_ctl_vmcb01_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
 
+	if (nested_vnmi_enabled(svm))
+		int_ctl_vmcb12_bits |= (V_NMI_PENDING | V_NMI_ENABLE | V_NMI_MASK);
+	else
+		int_ctl_vmcb01_bits |= (V_NMI_PENDING | V_NMI_ENABLE | V_NMI_MASK);
+
 	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
 	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9ebfbd0d4b467e..c9190a8ee03273 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4188,6 +4188,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	svm->vgif_enabled = vgif && guest_cpuid_has(vcpu, X86_FEATURE_VGIF);
 
+	svm->vnmi_enabled = vnmi && guest_cpuid_has(vcpu, X86_FEATURE_AMD_VNMI);
+
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
 	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
@@ -4939,6 +4941,9 @@ static __init void svm_set_cpu_caps(void)
 		if (vgif)
 			kvm_cpu_cap_set(X86_FEATURE_VGIF);
 
+		if (vnmi)
+			kvm_cpu_cap_set(X86_FEATURE_AMD_VNMI);
+
 		/* Nested VM can receive #VMEXIT instead of triggering #GP */
 		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5f2ee72c6e3125..d39e937a2c8391 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -252,6 +252,7 @@ struct vcpu_svm {
 	bool pause_filter_enabled         : 1;
 	bool pause_threshold_enabled      : 1;
 	bool vgif_enabled                 : 1;
+	bool vnmi_enabled                 : 1;
 
 	u32 ldr_reg;
 	u32 dfr_reg;
@@ -532,6 +533,11 @@ static inline bool is_x2apic_msrpm_offset(u32 offset)
 	       (msr < (APIC_BASE_MSR + 0x100));
 }
 
+static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
+{
+	return svm->vnmi_enabled && (svm->nested.ctl.int_ctl & V_NMI_ENABLE);
+}
+
 static inline struct vmcb *get_vnmi_vmcb(struct vcpu_svm *svm)
 {
 	if (!vnmi)
-- 
2.34.3

