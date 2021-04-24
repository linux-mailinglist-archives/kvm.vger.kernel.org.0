Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D2E369E04
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244520AbhDXAuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236937AbhDXAsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:48:35 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C1AC06135A
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:33 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id d89-20020a25a3620000b02904dc8d0450c6so26111291ybi.2
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=1D0TlyZZx7JwVOxkgqn3lnDpgF3MCu1QmI2F6hIBoT4=;
        b=lJHyP2rRzUH35KcQlgXnydQwYs0SMuzctWrf1uue9kHOp9MJrRXHtC5IpS9bUmg5B/
         A0Q62gvdYDqZ3MbhDcdCt2n4G9uugT2Ala6NsNZ1yR/8b9BTCNMSopmxcVmTV3mZHHz3
         OH7EpGIBqx8kcnN9000YhwJa0v+t2TObsImK0uRlzEIfTDwY2yIk9O6ZUAQe5nsIbx7R
         bGKT2k5BRJPrbEGodj/Lr5M/gKBDBEwh75aq7eELmv0Dvl9UduuuCBtRyMAyBQiO4uiP
         Mr8AgekMCAryuK0bBxqiaQ+xyniOnc0wvV7dQNDLMIRyk9jEbrIABGpyQ3bBRtNXUcyE
         g8Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=1D0TlyZZx7JwVOxkgqn3lnDpgF3MCu1QmI2F6hIBoT4=;
        b=hl+itUlUSyWCZP9puOfT/HYDOuGxHM3prLF4rf/X920Oc9JYkZf6VjY9q6qjgAjLCu
         O76BqwFgW+qqo+mtJnLs3VekBblyI3OJrphcmBpGOfaKxf/gm1iylHY0mAs57twNvKV+
         JcXx/vRrnL+v72pPxdz/4A/vzMMHSwswllhdMSEqyVn1+5ZaHoHG40I+K9uX+GXCgCnz
         23fUjipIud/78ZbprCTtvh5iQQBmY6UruLNvrBs+dFbvyOiRL5aRYCnUFDq7cCcIV60V
         k3TW/OMtAH6az4/lnX7cBmfyRtrqEn2lwJXDIGrqIRRjUkk7mFcNczr3+RItrEKtLQ/J
         46Uw==
X-Gm-Message-State: AOAM532ClwF0QGGPTIr3Hs/5UjCeqm2AnbZfeG2AzgPR5tKRwHfea2ke
        k0VaSj5GoKS6aPnAboTagIBJzbj8vIY=
X-Google-Smtp-Source: ABdhPJzngNfTzw5UGaEBP1JekalwRdxRyeo6Y8YRa47F+7ha9DtFE7ZwHKUXAcSGSvl3cmIn87UxZ5ggIHo=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:2a16:: with SMTP id q22mr6068085ybq.379.1619225253134;
 Fri, 23 Apr 2021 17:47:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:17 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-16-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 15/43] KVM: x86: Set BSP bit in reset BSP vCPU's APIC base by default
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

Set the BSP bit appropriately during local APIC "reset" instead of
relying on vendor code to clean up at a later point.  This is a step
towards consolidating the local APIC, VMX, and SVM xAPIC initialization
code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index c11f23753a5b..b088f6984b37 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2305,6 +2305,7 @@ EXPORT_SYMBOL_GPL(kvm_apic_update_apicv);
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
+	u64 msr_val;
 	int i;
 
 	if (!apic)
@@ -2314,8 +2315,10 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	hrtimer_cancel(&apic->lapic_timer.timer);
 
 	if (!init_event) {
-		kvm_lapic_set_base(vcpu, APIC_DEFAULT_PHYS_BASE |
-		                         MSR_IA32_APICBASE_ENABLE);
+		msr_val = APIC_DEFAULT_PHYS_BASE | MSR_IA32_APICBASE_ENABLE;
+		if (kvm_vcpu_is_reset_bsp(vcpu))
+			msr_val |= MSR_IA32_APICBASE_BSP;
+		kvm_lapic_set_base(vcpu, msr_val);
 		kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
 	}
 	kvm_apic_set_version(apic->vcpu);
-- 
2.31.1.498.g6c1eba8ee3d-goog

