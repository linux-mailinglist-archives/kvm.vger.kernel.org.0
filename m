Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4A93C74EE
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235571AbhGMQin (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235052AbhGMQie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:38:34 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A878C0612E9
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:54 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id l4-20020a0ce0840000b02902cec39ab618so17785519qvk.5
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+rqcgnm7H23kDtzI+NHHhjYq+hDDRi5POz7LV9x1q80=;
        b=EUJbXsjQJoA5ET64LXIKu5IwjyTv2OWjBqPQfKNl2ofUWNM0hNyDZH5Ne3c9P89XsG
         6oSPkScJ1YGYbjScYTuHIfTGFWtPqSyAADXT662JDTvVUnz6RyTkTDWuYvgE/G4sZ7t2
         FWXnX0XyxBe4Qfb+XxY0AfGU8pOpLbIZho0UE48yoGm4MNJijRm3yuEudWA5VGc4HFZh
         OxElfscJXYpk7c+b5m044mL6z041YBXvHwhE4hGHHEM+uwaX5geQF5G1QhTXn3QPQCKt
         mZllRrXhxZZ0qCds7XN9/LtRHF4xjMRfFzH5Wzdwdb/h5KmM03LV+VUADPwvuSM+5b2b
         j1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+rqcgnm7H23kDtzI+NHHhjYq+hDDRi5POz7LV9x1q80=;
        b=hdpU3bfeEagloqIDghUuTOOoXw5+oCAWNw+t5HGkl5M179wW9vRY5QKYzacpYqsJjp
         XiTL4pFOcRHrVLoH5JStXBcChtHHj66X9d8G4ND93mX4Ty2ioAFFMynIOJDgoLcv+Pi3
         w5Q8rvmYsVjnZaPPimT6ovfeVi6MZq8A3TMsKTSXdJkNex4mIqDV5j8+LwTr+Cd8hyOF
         Lkn1IxpBPP0EQ31i2cQlaOFu3OXEvCwMSX1VukW5Sq4y317MC5IYTb4+3H96Y2kSl4YY
         xjKlz2Ko5Gj6n4T65kp3GpnHtq9mPOpTfy5bB1ziLpIu7HikKYyDhJIv1p5GFN3tbTmM
         Ztpg==
X-Gm-Message-State: AOAM530pOuSXIRTtF1nuvZGgo7Bbp9Rx9h5ontMsTfIlQrt6uTckEmO9
        DXtVmK+C3NHCIDrOe8S8Tciby5wmXHI=
X-Google-Smtp-Source: ABdhPJyX1XTDODijjpMeMU63KSmlqP/qOCjPFipPO8vYTD0ueg0PSQRQ+Wdp0FIJdWendLKxStrwihyhN/o=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a05:6214:1021:: with SMTP id
 k1mr5843936qvr.4.1626194093657; Tue, 13 Jul 2021 09:34:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:33:19 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-42-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 41/46] KVM: VMX: Smush x2APIC MSR bitmap adjustments into
 single function
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Consolidate all of the dynamic MSR bitmap adjustments into
vmx_update_msr_bitmap_x2apic(), and rename the mode tracker to reflect
that it is x2APIC specific.  If KVM gains more cases of dynamic MSR
pass-through, odds are very good that those new cases will be better off
with their own logic, e.g. see Intel PT MSRs and MSR_IA32_SPEC_CTRL.

Attempting to handle all updates in a common helper did more harm than
good, as KVM ended up collecting a large number of useless "updates".

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 55 ++++++++++++++++--------------------------
 arch/x86/kvm/vmx/vmx.h |  2 +-
 2 files changed, 22 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bc09a2f7cb5f..cdde1dfaa574 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3812,21 +3812,6 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 		vmx_set_msr_bitmap_write(msr_bitmap, msr);
 }
 
-static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
-{
-	u8 mode = 0;
-
-	if (cpu_has_secondary_exec_ctrls() &&
-	    (secondary_exec_controls_get(to_vmx(vcpu)) &
-	     SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE)) {
-		mode |= MSR_BITMAP_MODE_X2APIC;
-		if (enable_apicv && kvm_vcpu_apicv_active(vcpu))
-			mode |= MSR_BITMAP_MODE_X2APIC_APICV;
-	}
-
-	return mode;
-}
-
 static void vmx_reset_x2apic_msrs(struct kvm_vcpu *vcpu, u8 mode)
 {
 	unsigned long *msr_bitmap = to_vmx(vcpu)->vmcs01.msr_bitmap;
@@ -3844,11 +3829,29 @@ static void vmx_reset_x2apic_msrs(struct kvm_vcpu *vcpu, u8 mode)
 	}
 }
 
-static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu, u8 mode)
+static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u8 mode;
+
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
+	if (cpu_has_secondary_exec_ctrls() &&
+	    (secondary_exec_controls_get(vmx) &
+	     SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE)) {
+		mode = MSR_BITMAP_MODE_X2APIC;
+		if (enable_apicv && kvm_vcpu_apicv_active(vcpu))
+			mode |= MSR_BITMAP_MODE_X2APIC_APICV;
+	} else {
+		mode = 0;
+	}
+
+	if (!(mode ^ vmx->x2apic_msr_bitmap_mode))
+		return;
+
+	vmx->x2apic_msr_bitmap_mode = mode;
+
 	vmx_reset_x2apic_msrs(vcpu, mode);
 
 	/*
@@ -3865,21 +3868,6 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu, u8 mode)
 	}
 }
 
-static void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u8 mode = vmx_msr_bitmap_mode(vcpu);
-	u8 changed = mode ^ vmx->msr_bitmap_mode;
-
-	if (!changed)
-		return;
-
-	if (changed & (MSR_BITMAP_MODE_X2APIC | MSR_BITMAP_MODE_X2APIC_APICV))
-		vmx_update_msr_bitmap_x2apic(vcpu, mode);
-
-	vmx->msr_bitmap_mode = mode;
-}
-
 void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -4139,8 +4127,7 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 					SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
 	}
 
-	if (cpu_has_vmx_msr_bitmap())
-		vmx_update_msr_bitmap(vcpu);
+	vmx_update_msr_bitmap_x2apic(vcpu);
 }
 
 u32 vmx_exec_control(struct vcpu_vmx *vmx)
@@ -6186,7 +6173,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 	}
 	secondary_exec_controls_set(vmx, sec_exec_control);
 
-	vmx_update_msr_bitmap(vcpu);
+	vmx_update_msr_bitmap_x2apic(vcpu);
 }
 
 static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 1b3dd5ddf235..e370091d57c6 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -229,7 +229,7 @@ struct nested_vmx {
 struct vcpu_vmx {
 	struct kvm_vcpu       vcpu;
 	u8                    fail;
-	u8		      msr_bitmap_mode;
+	u8		      x2apic_msr_bitmap_mode;
 
 	/*
 	 * If true, host state has been stored in vmx->loaded_vmcs for
-- 
2.32.0.93.g670b81a890-goog

