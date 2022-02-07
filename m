Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457CD4AC512
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 17:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389324AbiBGQEG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 11:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345530AbiBGP7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 10:59:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19F48C0401CF
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 07:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644249580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MrKkOBVSy/FtXXgDcr9UR7sqO5t4KzWH4q1ibusmu34=;
        b=ANyMyKzYJ5y/ormvnOJTV0mK1+ZW0LeEVEUecftUNlWESDx0/jVMR0qUBVHMv75YG+hGtz
        wp3rCzNC9kQ/t8Ys6BN5zyGQJSgmDzkWXxw31I4W6IvmCThfEPj7bJnbaPV3AvypRzzcuO
        xNIkbU10CWNU0bvipw9IMIFYCFEjG/I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10--fg2iXI_MC6_5NetEWXWmA-1; Mon, 07 Feb 2022 10:59:37 -0500
X-MC-Unique: -fg2iXI_MC6_5NetEWXWmA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5927C81433E;
        Mon,  7 Feb 2022 15:59:34 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A2097DE5C;
        Mon,  7 Feb 2022 15:59:27 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Tony Luck <tony.luck@intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        David Airlie <airlied@linux.ie>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH RESEND 23/30] KVM: x86: nSVM: implement nested LBR virtualization
Date:   Mon,  7 Feb 2022 17:54:40 +0200
Message-Id: <20220207155447.840194-24-mlevitsk@redhat.com>
In-Reply-To: <20220207155447.840194-1-mlevitsk@redhat.com>
References: <20220207155447.840194-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This was tested with kvm-unit-test that was developed
for this purpose.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 21 +++++++++++++++++++--
 arch/x86/kvm/svm/svm.c    |  8 ++++++++
 arch/x86/kvm/svm/svm.h    |  1 +
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 9f7bc7db08dd3..4a228a76b27d7 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -536,8 +536,19 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 		vmcb_mark_dirty(svm->vmcb, VMCB_DR);
 	}
 
-	if (unlikely(svm->vmcb01.ptr->control.virt_ext & LBR_CTL_ENABLE_MASK))
+	if (unlikely(svm->lbrv_enabled && (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
+
+		/* Copy LBR related registers from vmcb12,
+		 * but make sure that we only pick LBR enable bit from the guest.
+		 */
+
+		svm_copy_lbrs(vmcb12, svm->vmcb);
+		svm->vmcb->save.dbgctl &= LBR_CTL_ENABLE_MASK;
+		svm_update_lbrv(&svm->vcpu);
+
+	} else if (unlikely(svm->vmcb01.ptr->control.virt_ext & LBR_CTL_ENABLE_MASK)) {
 		svm_copy_lbrs(svm->vmcb01.ptr, svm->vmcb);
+	}
 }
 
 static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
@@ -592,6 +603,9 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 
 	svm->vmcb->control.virt_ext            = svm->vmcb01.ptr->control.virt_ext &
 						 LBR_CTL_ENABLE_MASK;
+	if (svm->lbrv_enabled)
+		svm->vmcb->control.virt_ext  |=
+			(svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK);
 
 	nested_svm_transition_tlb_flush(vcpu);
 
@@ -858,7 +872,10 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
-	if (unlikely(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK)) {
+	if (unlikely(svm->lbrv_enabled && (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
+		svm_copy_lbrs(svm->nested.vmcb02.ptr, vmcb12);
+		svm_update_lbrv(vcpu);
+	} else if (unlikely(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK)) {
 		svm_copy_lbrs(svm->nested.vmcb02.ptr, svm->vmcb);
 		svm_update_lbrv(vcpu);
 	}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 294e016f575a8..76aa6054d9db2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -890,6 +890,10 @@ void svm_update_lbrv(struct kvm_vcpu *vcpu)
 	bool current_enable_lbrv = !!(svm->vmcb->control.virt_ext &
 				      LBR_CTL_ENABLE_MASK);
 
+	if (unlikely(is_guest_mode(vcpu) && svm->lbrv_enabled))
+		if (unlikely(svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))
+			enable_lbrv = true;
+
 	if (enable_lbrv == current_enable_lbrv)
 		return;
 
@@ -3987,6 +3991,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 			     guest_cpuid_has(vcpu, X86_FEATURE_NRIPS);
 
 	svm->tsc_scaling_enabled = tsc_scaling && guest_cpuid_has(vcpu, X86_FEATURE_TSCRATEMSR);
+	svm->lbrv_enabled = lbrv && guest_cpuid_has(vcpu, X86_FEATURE_LBRV);
 
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
@@ -4791,6 +4796,9 @@ static __init void svm_set_cpu_caps(void)
 		if (tsc_scaling)
 			kvm_cpu_cap_set(X86_FEATURE_TSCRATEMSR);
 
+		if (lbrv)
+			kvm_cpu_cap_set(X86_FEATURE_LBRV);
+
 		/* Nested VM can receive #VMEXIT instead of triggering #GP */
 		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index b83e06d5d942a..0012ba5affcba 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -220,6 +220,7 @@ struct vcpu_svm {
 	/* cached guest cpuid flags for faster access */
 	bool nrips_enabled                : 1;
 	bool tsc_scaling_enabled          : 1;
+	bool lbrv_enabled                 : 1;
 
 	u32 ldr_reg;
 	u32 dfr_reg;
-- 
2.26.3

