Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DEF369E0C
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244318AbhDXAvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244388AbhDXAtm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:49:42 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D34DC061362
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:40 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id d8-20020a25eb080000b02904e6f038cad5so26111140ybs.4
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=NZdv+AGbcKGuCnoG8O16om5C2kLzm+MyJDxYqgfhwLA=;
        b=mf8daJbNL2+OfvIgSL+41PtaksanbJRRqTdAYgYF/QdSjD42oJvxk44BDMRtD1W37p
         HcrJChZUXCNY4kJ94XHe+ZcoL4C/IRyDvUpZCcOhRJkdzQWEhfKRcmYJHDLtzc9AH1DM
         mr+SDmg4+cRDOFfsJq01xVEVATH1UMRq5WgW3de58q+dQwdP5A5+oPZNiDtUoPY0vQ6W
         CxeqLA6hODY9xdGQJJmOvQw/I4mT2oY97Sy8oPky6wTmUvsDayPmW6Hf/2jPSv3r9FcX
         oQMEMVYg+3givAO8GRo8clPvE0RstBCsB4TEMg2P7o/pw3XdI4LujyiHdF3w0IQU4RyY
         WhlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=NZdv+AGbcKGuCnoG8O16om5C2kLzm+MyJDxYqgfhwLA=;
        b=klw7eA46OaInRZsWUcSKhhPhoN73ncinJY5/wGfVEhjD88kc5amI3oM5k4krgspDc5
         eGQWDi8Hsf1tM9J39zNjc+zOPg/SgLXtbhwlo6nmY0UnmJjCk/YR3TpjasNhANTd1uq2
         vpFuPhgSVEyyT7zKzPlixc8E1RS3/TQtK4VXoJVoH//IK0/5FLbpvc6jcAFCL4XOjK7N
         pJKNgkA1rnCnLWvz+Z/zI+1e98x8Jlw/1fnh8hsyAFHE5zjUoXtvnLvnxQEH0Y+ojsBL
         fm0NTfQfNtdLQRVG/6HS3y1rPxVk8WZPGT9KLsCLy9LlfBXWqVVc4p9q/XH4rsGiOpYk
         3Uqw==
X-Gm-Message-State: AOAM5310eCBlmCLgFrAP0DqkzuUbZ7SKapxwF0ZFIhKyNuCF86fRGGrJ
        Cwtazli2PSJNmLUJQGLEch8MVxmBRac=
X-Google-Smtp-Source: ABdhPJz2bRSOk/4gUqVZJXXQC3kpzYyE7rhGX85o1M51Ow03HS+MoK2fqNFfOt4irkPUD8x65HXfiKE6EFw=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:9ac7:: with SMTP id t7mr9678756ybo.58.1619225259641;
 Fri, 23 Apr 2021 17:47:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:20 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-19-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 18/43] KVM: x86: Consolidate APIC base RESET initialization code
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Consolidate the APIC base RESET logic, which is currently spread out
across both x86 and vendor code.  For an in-kernel APIC, the vendor code
is redundant.  But for a userspace APIC, KVM relies on the vendor code
to initialize vcpu->arch.apic_base.  Hoist the vcpu->arch.apic_base
initialization above the !apic check so that it applies to both flavors
of APIC emulation, and delete the vendor code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c   | 14 ++++++++------
 arch/x86/kvm/svm/svm.c |  6 ------
 arch/x86/kvm/vmx/vmx.c |  7 -------
 3 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index b1366df46d1d..07cfa4d181da 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2307,18 +2307,20 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	int i;
 
-	if (!apic)
-		return;
-
-	/* Stop the timer in case it's a reset to an active apic */
-	hrtimer_cancel(&apic->lapic_timer.timer);
-
 	if (!init_event) {
 		vcpu->arch.apic_base = APIC_DEFAULT_PHYS_BASE |
 				       MSR_IA32_APICBASE_ENABLE;
 		if (kvm_vcpu_is_reset_bsp(vcpu))
 			vcpu->arch.apic_base |= MSR_IA32_APICBASE_BSP;
+	}
 
+	if (!apic)
+		return;
+
+	/* Stop the timer in case it's a reset to an active apic */
+	hrtimer_cancel(&apic->lapic_timer.timer);
+
+	if (!init_event) {
 		apic->base_address = MSR_IA32_APICBASE_ENABLE;
 
 		kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6c73ea3d20c6..271b6def087f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1289,12 +1289,6 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	svm->spec_ctrl = 0;
 	svm->virt_spec_ctrl = 0;
 
-	if (!init_event) {
-		vcpu->arch.apic_base = APIC_DEFAULT_PHYS_BASE |
-				       MSR_IA32_APICBASE_ENABLE;
-		if (kvm_vcpu_is_reset_bsp(vcpu))
-			vcpu->arch.apic_base |= MSR_IA32_APICBASE_BSP;
-	}
 	init_vmcb(vcpu);
 
 	/*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fa14e9a74b96..40a4ac23d54f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4509,13 +4509,6 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx->hv_deadline_tsc = -1;
 	kvm_set_cr8(vcpu, 0);
 
-	if (!init_event) {
-		vcpu->arch.apic_base = APIC_DEFAULT_PHYS_BASE |
-				       MSR_IA32_APICBASE_ENABLE;
-		if (kvm_vcpu_is_reset_bsp(vcpu))
-			vcpu->arch.apic_base |= MSR_IA32_APICBASE_BSP;
-	}
-
 	vmx_segment_cache_clear(vmx);
 
 	seg_setup(VCPU_SREG_CS);
-- 
2.31.1.498.g6c1eba8ee3d-goog

