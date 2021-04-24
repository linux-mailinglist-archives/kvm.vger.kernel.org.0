Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD63369E18
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244408AbhDXAwg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244270AbhDXAu4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:50:56 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB1BC061343
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:51 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v3-20020a05690204c3b02904e65b70792dso26595841ybs.1
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=qXb6vjQTd1xwjeGuxgHWs2f2nyIxbCEgG3y42oAowog=;
        b=hJ5QM1I+GcatYOsJAhrQYWxqOelYqAAqZTUaiWa8J4truULZy53P1vLI1c8k5c+GhF
         zSayk6J4HVR89e04/E5spls47PevdzuGhhz1JhwcqWim4Aa8Lw6t3b77+PEU6hFBxkdN
         EHqYsU+6eKPUgT323rnDunkjJva93ZP5iP7HjjvdITSOTQd7S5wEG98DmsnHHM00zVCg
         r2T11xOgWHAOxcBWNgL16pWiGyWLlQTcXd4hFcZFzcVr8gbTgvUL/iFjpfAuBfIqkkoA
         9tJUeCetGo5mtLMg3LYvI1KrYOx3oQfA+oQppLM7MnQo60EV5vdV5l99FQJIEJsKhvxJ
         vmPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=qXb6vjQTd1xwjeGuxgHWs2f2nyIxbCEgG3y42oAowog=;
        b=UvhID1Cm1JOKk/Iptl7U5MP4Cn04FSj8jzwaujxlwNU1QRcaWAX341ITxrgbcl0Qcd
         2BOwN/lbMAPELAPCjSASPjZi/s/6RMm0AUnvn5yDxFbhMOV/ofGnI9L5DM2H64JWha8f
         ZXnTcaZ5s9SOo6dtHTyLh6MURrq1ndCzNhEm/1JPYLQ5E5COMFlhVbJHsob2gbUu2Iyc
         wQmm6gPdrfaZNYVMzJyUBwX/tZR2/BJYn6PisojERLNakXo/0rd5+VBi2hCDOg3XpO39
         jMFm7SCbeynWQs611rwGOFmuCDaMe59KX66uQlRGppoeuovmjfpE5Pw+8BuTRsvGWDa3
         HX7g==
X-Gm-Message-State: AOAM533LUEyuXMKZaa+wi42RyV9xmyEDH/QjSHGDqPEQWEvpeWq0yUKz
        fuUAlrycnq6G97QaYlkeQ1aNh6cbXF8=
X-Google-Smtp-Source: ABdhPJzeIovgiSTBW+DtE984HaOO03yXgGvjqkVLAuHDvQwHCGKM2Rw5CiEOH9VQIx2ntBf/EtpQB2dY0WU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:3447:: with SMTP id b68mr6804966yba.180.1619225270603;
 Fri, 23 Apr 2021 17:47:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:25 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-24-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 23/43] KVM: VMX: Fold ept_update_paging_mode_cr0() back into vmx_set_cr0()
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

Move the CR0/CR3/CR4 shenanigans for EPT without unrestricted guest back
into vmx_set_cr0().  This will allow a future patch to eliminate the
rather gross stuffing of vcpu->arch.cr0 in the paging transition cases
by snapshotting the old CR0.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 40 +++++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5795de909609..c9322cd55390 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3102,27 +3102,6 @@ void ept_save_pdptrs(struct kvm_vcpu *vcpu)
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
 }
 
-static void ept_update_paging_mode_cr0(unsigned long cr0, struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
-	if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
-		vmx_cache_reg(vcpu, VCPU_EXREG_CR3);
-	if (!(cr0 & X86_CR0_PG)) {
-		/* From paging/starting to nonpaging */
-		exec_controls_setbit(vmx, CPU_BASED_CR3_LOAD_EXITING |
-					  CPU_BASED_CR3_STORE_EXITING);
-		vcpu->arch.cr0 = cr0;
-		vmx_set_cr4(vcpu, kvm_read_cr4(vcpu));
-	} else if (!is_paging(vcpu)) {
-		/* From nonpaging to paging */
-		exec_controls_clearbit(vmx, CPU_BASED_CR3_LOAD_EXITING |
-					    CPU_BASED_CR3_STORE_EXITING);
-		vcpu->arch.cr0 = cr0;
-		vmx_set_cr4(vcpu, kvm_read_cr4(vcpu));
-	}
-}
-
 void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -3152,8 +3131,23 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	}
 #endif
 
-	if (enable_ept && !is_unrestricted_guest(vcpu))
-		ept_update_paging_mode_cr0(cr0, vcpu);
+	if (enable_ept && !is_unrestricted_guest(vcpu)) {
+		if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
+			vmx_cache_reg(vcpu, VCPU_EXREG_CR3);
+		if (!(cr0 & X86_CR0_PG)) {
+			/* From paging/starting to nonpaging */
+			exec_controls_setbit(vmx, CPU_BASED_CR3_LOAD_EXITING |
+						  CPU_BASED_CR3_STORE_EXITING);
+			vcpu->arch.cr0 = cr0;
+			vmx_set_cr4(vcpu, kvm_read_cr4(vcpu));
+		} else if (!is_paging(vcpu)) {
+			/* From nonpaging to paging */
+			exec_controls_clearbit(vmx, CPU_BASED_CR3_LOAD_EXITING |
+						    CPU_BASED_CR3_STORE_EXITING);
+			vcpu->arch.cr0 = cr0;
+			vmx_set_cr4(vcpu, kvm_read_cr4(vcpu));
+		}
+	}
 
 	vmcs_writel(CR0_READ_SHADOW, cr0);
 	vmcs_writel(GUEST_CR0, hw_cr0);
-- 
2.31.1.498.g6c1eba8ee3d-goog

