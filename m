Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351DE4CDD99
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 20:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiCDT7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 14:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbiCDT7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 14:59:10 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DD115A17;
        Fri,  4 Mar 2022 11:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423438; x=1677959438;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YYPKNoJQCgXRw/mHCPaNlQiEwwMw0C671GpkOvOa2T4=;
  b=mtd9HUTSC5ql5yrS5/kWic9mtWTJIXxgGPiEgJxARYnZbtWbNv9Otaeq
   Rz/6ot2X4xbYfKK39Kqr79REI+5rIHOB6+57P7n2UEBZzmf39Wb4j0WkC
   JB9+BoMFDazluMvB7/GXUyOvPBxZdomZWpmWfNTD50FslBCDHL6a2muMp
   HC/oCt60VTNOCMsovjoCzWjxIV+k8LJbiHOy397B5sxkP61y0L6/7R5cu
   zPVEGbwoZXrJninDl5UIOYAeZlJUj2HF6wm6XWMY6Mi1djzyMcEp2s/NE
   37+egFtLvtazwo/HhZBq3c+UWzZHwOiCpsfmeihbpp4bsI1jgpb4SPGbp
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253779628"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253779628"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:37 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344496"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:37 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 076/104] KVM: x86: Add option to force LAPIC expiration wait
Date:   Fri,  4 Mar 2022 11:49:32 -0800
Message-Id: <52b0451a4ffba54455acf710b443715ac16effd4.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add an option to skip the IRR check-in kvm_wait_lapic_expire().  This
will be used by TDX to wait if there is an outstanding notification for
a TD, i.e. a virtual interrupt is being triggered via posted interrupt
processing.  KVM TDX doesn't emulate PI processing, i.e. there will
never be a bit set in IRR/ISR, so the default behavior for APICv of
querying the IRR doesn't work as intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/lapic.c   | 4 ++--
 arch/x86/kvm/lapic.h   | 2 +-
 arch/x86/kvm/svm/svm.c | 2 +-
 arch/x86/kvm/vmx/vmx.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9322e6340a74..d49f029ef0e3 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1620,12 +1620,12 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
 }
 
-void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
+void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu, bool force_wait)
 {
 	if (lapic_in_kernel(vcpu) &&
 	    vcpu->arch.apic->lapic_timer.expired_tscdeadline &&
 	    vcpu->arch.apic->lapic_timer.timer_advance_ns &&
-	    lapic_timer_int_injected(vcpu))
+	    (force_wait || lapic_timer_int_injected(vcpu)))
 		__kvm_wait_lapic_expire(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_wait_lapic_expire);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 2b44e533fc8d..2a0119ef9e96 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -233,7 +233,7 @@ static inline int kvm_lapic_latched_init(struct kvm_vcpu *vcpu)
 
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
 
-void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
+void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu, bool force_wait);
 
 void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			      unsigned long *vcpu_bitmap);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c7eec23e9ebe..a46415845f48 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3766,7 +3766,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	clgi();
 	kvm_load_guest_xsave_state(vcpu);
 
-	kvm_wait_lapic_expire(vcpu);
+	kvm_wait_lapic_expire(vcpu, false);
 
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 00f88aa25047..9b7bd52d19a9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6838,7 +6838,7 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (enable_preemption_timer)
 		vmx_update_hv_timer(vcpu);
 
-	kvm_wait_lapic_expire(vcpu);
+	kvm_wait_lapic_expire(vcpu, false);
 
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
-- 
2.25.1

