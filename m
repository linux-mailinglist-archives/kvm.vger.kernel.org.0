Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977F5369E3C
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244717AbhDXAzw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244694AbhDXAyZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:54:25 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBDBC0612AC
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:29 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 7-20020a5b01070000b02904ed6442e5f6so3085175ybx.23
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+Lg1qMt4LiK9E6pFHFmoygD2uVA+jxYyMvXAcTg1YjI=;
        b=ol3vBedZlUOiXLMeWSQueWzfhA1I86+zrk74vxi0p/x6/cDCEFT+WIWcj3svtmBKCE
         cy7J7VLH4YnnfcaLJffk+Jj68mx53LWZc28CGxUUmAPizMAeoL531mu5zjGAoS7o1XHR
         J+13RzhV8MB1ySyxzcNmgDaBBhxGQiACZjBd4/1UtJR8wANr0OkjMd5qiYpCYhMXHhXH
         Gg1ltRfv9uWgJw7/h61TiqnhopWbBIxE7XeHjLRPEeCJJUWZAyNjBZJxQSqYaXdnqbs4
         dUHMX1pQ1wqwzauXI4UY/GG7GbpGVrLE+nYWe010QUBnnWZwcwQPj91XzdAL46Yy4RT8
         f1mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+Lg1qMt4LiK9E6pFHFmoygD2uVA+jxYyMvXAcTg1YjI=;
        b=kLUYdWIIKxf3AfjHJuHadldkFnDa4oHoMN10XygBp6tklG43GUTsfXE55l6wcH71Hj
         c8rfMdc1KcUva3x30KlMKxqWsX/Erqa4iw60tBo2Deac4VxajwG8UjD7JrzSg6dodS9a
         jwRpwsj04gLjAJN+D4/CeBFbfEjuB8KfGm/lRtEDKqpLi+GJRvgFIPzJCDH3UmDYaKor
         z5Bm1QEaxwRsWFaDdlLDXCi/IUXYR0wQ2pjrrwLyBrtwfZQbQ3Dl31YzziWybqphAoKd
         IlxJ8HAhar767O33EgpUvn/x72iM9XFMsyJsP4XjUS27S4r9OhWuCYF1i1JKUVYnJNl7
         Q7nA==
X-Gm-Message-State: AOAM531AvRMu9SJUhEz0B6saDoolAxo3vagMB7xi1y3NZchZOVKX2N35
        MeborJzuy4pPOYoYt9b/WmL09awUJok=
X-Google-Smtp-Source: ABdhPJyZdkyyiJXWKBXuNajpdy4djv2ChoL9WWVdCG5+m/m4TEr9b0ozloXGpMlLFOs8Ts9tXz0YPB0yyQU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:f311:: with SMTP id c17mr8630747ybs.189.1619225308794;
 Fri, 23 Apr 2021 17:48:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:42 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-41-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 40/43] KVM: VMX: Smush x2APIC MSR bitmap adjustments into
 single function
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
index cfd986aae7b7..dcef189b0108 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3931,21 +3931,6 @@ void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
 		vmx_disable_intercept_for_msr(vcpu, msr, type);
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
@@ -3963,11 +3948,29 @@ static void vmx_reset_x2apic_msrs(struct kvm_vcpu *vcpu, u8 mode)
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
@@ -3984,21 +3987,6 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu, u8 mode)
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
@@ -4258,8 +4246,7 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 					SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
 	}
 
-	if (cpu_has_vmx_msr_bitmap())
-		vmx_update_msr_bitmap(vcpu);
+	vmx_update_msr_bitmap_x2apic(vcpu);
 }
 
 u32 vmx_exec_control(struct vcpu_vmx *vmx)
@@ -6287,7 +6274,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 	}
 	secondary_exec_controls_set(vmx, sec_exec_control);
 
-	vmx_update_msr_bitmap(vcpu);
+	vmx_update_msr_bitmap_x2apic(vcpu);
 }
 
 static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e46df3253a21..5d2f047dafdf 100644
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
2.31.1.498.g6c1eba8ee3d-goog

