Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D564E3A2100
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 01:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhFIXqP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 19:46:15 -0400
Received: from mail-yb1-f202.google.com ([209.85.219.202]:41720 "EHLO
        mail-yb1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbhFIXqI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 19:46:08 -0400
Received: by mail-yb1-f202.google.com with SMTP id j7-20020a258b870000b029052360b1e3e2so33425455ybl.8
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 16:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=nHEr3fDpE6Im0i88yYJ1tQIvyNGCyZi5EB4ETLvhbfY=;
        b=ea22XXYvukJm5qYdUPMhFg2EwDHUYSLhllnrvu6LWOdE4ige4l3f5SSF7zSTUtjFZ0
         k7V92WLCSNLDNx4JiPgFUIYt6oq3lorgTCYxAU7INZZv0Q7UO7o0r8eyI3WXESUulGyA
         JMRa8YmO6EUqcxlp5sDD4ejzd836NR1zRmC60Q8bmKx7cH61K330+GujZHcXCPobaqZ3
         S4BWkCbgItpkoT/xDTKrR+va7IZVWsr8l6YKXj4f7Do85enlEGckmVfgWscxr34tiCYc
         UwY5M/SPB2uZwhYpZgAZXDUfk333JhV24AFJ6a8yg4CLmTaR4gdarmffZ2Wpu9BAnAnR
         0Kag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=nHEr3fDpE6Im0i88yYJ1tQIvyNGCyZi5EB4ETLvhbfY=;
        b=GFnvgJr+IVcfviR60yfpspZE8E/giuWFMC3D4JHXV+HqVOMENZGe/xssouhJKQJ9KD
         Q6na/xpNI0rVszSdDqk8qO+XCfFYwWjv2mezeuq8ldqblY71JfmadLhC41Cl6Tk47PAS
         E+z9vYW/XqG30pLp0m3rw0XmkbMYpnbW4eO4QZJPAAflUM2QOkfrJZL/Su8Rol32LF++
         XnSfPC1oV0xVQ8z2Z66IP7WqnjHhH7bb1xd6IkIju8KGfrxUlTSt0LGXhpC13mKDzuf/
         wpCK8WtcyVTCrgPLsKLzj6E1pp6f6jzwEm9ddzGnIRBts1ge6MBWLkOvsB5TQ75BhY+g
         /JIQ==
X-Gm-Message-State: AOAM533XLMJLgfciDdrjSbgAiffKJHimm0tBeEm5/aEGcIj7N7AKdqkP
        jDuPsP4A27pby4HgWXgt3EMPg/LhB8g=
X-Google-Smtp-Source: ABdhPJysM8J+3gM4vv0/ZiTCwqxEs/+tlef/R/iat1CDlz/ELLXR0cKWvayn0RNoduTPVcuYXNlNvduHaNQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:8daf:e5e:ae50:4f28])
 (user=seanjc job=sendgmr) by 2002:a5b:d0e:: with SMTP id y14mr3691106ybp.207.1623282192818;
 Wed, 09 Jun 2021 16:43:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  9 Jun 2021 16:42:33 -0700
In-Reply-To: <20210609234235.1244004-1-seanjc@google.com>
Message-Id: <20210609234235.1244004-14-seanjc@google.com>
Mime-Version: 1.0
References: <20210609234235.1244004-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 13/15] KVM: x86: Drop pointless @reset_roots from kvm_init_mmu()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junaid Shahid <junaids@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the @reset_roots param from kvm_init_mmu(), the one user,
kvm_mmu_reset_context() has already unloaded the MMU and thus freed and
invalidated all roots.  This also happens to be why the reset_roots=true
paths doesn't leak roots; they're already invalid.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu.h        |  2 +-
 arch/x86/kvm/mmu/mmu.c    | 13 ++-----------
 arch/x86/kvm/svm/nested.c |  2 +-
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/x86.c        |  2 +-
 5 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 88d0ed5225a4..63b49725fb24 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -65,7 +65,7 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
 void
 reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
 
-void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots);
+void kvm_init_mmu(struct kvm_vcpu *vcpu);
 void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer,
 			     gpa_t nested_cr3);
 void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f987f2ea4a01..b4fa8ec8afce 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4817,17 +4817,8 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 	update_last_nonleaf_level(vcpu, g_context);
 }
 
-void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots)
+void kvm_init_mmu(struct kvm_vcpu *vcpu)
 {
-	if (reset_roots) {
-		uint i;
-
-		vcpu->arch.mmu->root_hpa = INVALID_PAGE;
-
-		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
-			vcpu->arch.mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
-	}
-
 	if (mmu_is_nested(vcpu))
 		init_kvm_nested_mmu(vcpu);
 	else if (tdp_enabled)
@@ -4853,7 +4844,7 @@ kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu)
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_unload(vcpu);
-	kvm_init_mmu(vcpu, true);
+	kvm_init_mmu(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_reset_context);
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ccd90ea93acd..8a4276d8753d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -421,7 +421,7 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
 
-	kvm_init_mmu(vcpu, false);
+	kvm_init_mmu(vcpu);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4b8f5dca49ac..f686618d9ede 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1094,7 +1094,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
 
-	kvm_init_mmu(vcpu, false);
+	kvm_init_mmu(vcpu);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d3a2a3375541..32e93492273f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10409,7 +10409,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kvm_vcpu_mtrr_init(vcpu);
 	vcpu_load(vcpu);
 	kvm_vcpu_reset(vcpu, false);
-	kvm_init_mmu(vcpu, false);
+	kvm_init_mmu(vcpu);
 	vcpu_put(vcpu);
 	return 0;
 
-- 
2.32.0.rc1.229.g3e70b5a671-goog

