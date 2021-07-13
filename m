Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7003C74E6
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235544AbhGMQig (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235546AbhGMQiZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:38:25 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2A8C05BD26
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:44 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v184-20020a257ac10000b02904f84a5c5297so27715593ybc.16
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=9wqr9l9rn3Fb1zwRgcq5bBwnS7s/+k7U1KQtXn6qui4=;
        b=nHyxyZ6RG/ToM4hIEqA3tiRylNSegnO7fPS5sd0Ve+8Qw880sTF7kgOUiU9kNgQ29G
         wUevBqSs4gBv5jWgJHhBNmyh4Jz3mWRMqMm1Ahsi5Qnxm1K3ktrIAr+dLUnZqf4Q9Bcl
         abrHmLYx+HE0RSb/IF5nhllPhH2vQWWxWgwQ6ySsajYq6COWqsenGs8KK4IcGKngjKWi
         0NB8m1B4JxYNBieaOiskZvdxGIx37GjtMinJNliqxcaj8tpJv1qdAJHNvs1Eq3pjM5kc
         9aVQTDvJDJkfPmG6LvljWeXAafy9URMevKsJCaSTkHSoEiuBEn6MwpPetpILrrLJ5KDF
         j41g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=9wqr9l9rn3Fb1zwRgcq5bBwnS7s/+k7U1KQtXn6qui4=;
        b=Vl/fW6gzFcEXArpl4jgFlZ64B85goHS12iqb4eemefnyRVQYeoyVQ1VnhHTC8Jm2cm
         EF9ZNutNImbmNXRbtnK3pOL7wRpP26rt7K55CTS2nd7U1sZ2uycPmD9+MjbGDT1bvutA
         KP4HeI+2U2YwlUZiPQOAcUGyCyadD2kp9mM1NWzMXFH1b11lqdjpn4JGH2GqXjpo7d86
         pFfxqaBHjMfpEjKMal8ORTSdaaetcBIJU70SDlAHCV7v2AbKYC68QqeMhoIi/D+Wogmx
         +zioCnMmnS2TgXtD5AhwaIzYGwLBv25lXQ3fcFvrSlPrbWrpFKcnDi00ujoGTM8mkpEY
         r4NA==
X-Gm-Message-State: AOAM531njrxkywe8UsBP6mpt9Rf202iVTJm369f66bnHjLa2mVTyn8Ep
        1uTziAOaQwYuQxCl5HGNy/QzpbUUdeA=
X-Google-Smtp-Source: ABdhPJwHQ3cIvB9bZHdex56kIWqYaWWDxiTGgWCm1Wsv9meh0YHUlKRQSZ7WuApnem728OAC+fdJysOnh+8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:abcc:: with SMTP id v70mr6892084ybi.216.1626194083200;
 Tue, 13 Jul 2021 09:34:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:33:14 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-37-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 36/46] KVM: x86: Move setting of sregs during vCPU
 RESET/INIT to common x86
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

Move the setting of CR0, CR4, EFER, RFLAGS, and RIP from vendor code to
common x86.  VMX and SVM now have near-identical sequences, the only
difference being that VMX updates the exception bitmap.  Updating the
bitmap on SVM is unnecessary, but benign.  Unfortunately it can't be left
behind in VMX due to the need to update exception intercepts after the
control registers are set.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 6 ------
 arch/x86/kvm/vmx/vmx.c | 9 ---------
 arch/x86/kvm/x86.c     | 8 ++++++++
 3 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 251b230b2fef..ea4bea428078 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1262,12 +1262,6 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	init_sys_seg(&save->ldtr, SEG_TYPE_LDT);
 	init_sys_seg(&save->tr, SEG_TYPE_BUSY_TSS16);
 
-	svm_set_cr0(vcpu, X86_CR0_NW | X86_CR0_CD | X86_CR0_ET);
-	svm_set_cr4(vcpu, 0);
-	svm_set_efer(vcpu, 0);
-	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
-	vcpu->arch.regs[VCPU_REGS_RIP] = 0x0000fff0;
-
 	if (npt_enabled) {
 		/* Setup VMCB for Nested Paging */
 		control->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 555235d6c17e..ef92ec40d3d9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4454,9 +4454,6 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
 	}
 
-	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
-	kvm_rip_write(vcpu, 0xfff0);
-
 	vmcs_writel(GUEST_GDTR_BASE, 0);
 	vmcs_write32(GUEST_GDTR_LIMIT, 0xffff);
 
@@ -4484,12 +4481,6 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 
-	vmx_set_cr0(vcpu, X86_CR0_NW | X86_CR0_CD | X86_CR0_ET);
-	vmx_set_cr4(vcpu, 0);
-	vmx_set_efer(vcpu, 0);
-
-	vmx_update_exception_bitmap(vcpu);
-
 	vpid_sync_context(vmx->vpid);
 	if (init_event)
 		vmx_clear_hlt(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6a11ec5d38ac..3aa952edd5f4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10870,6 +10870,14 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	static_call(kvm_x86_vcpu_reset)(vcpu, init_event);
 
+	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
+	kvm_rip_write(vcpu, 0xfff0);
+
+	static_call(kvm_x86_set_cr0)(vcpu, X86_CR0_NW | X86_CR0_CD | X86_CR0_ET);
+	static_call(kvm_x86_set_cr4)(vcpu, 0);
+	static_call(kvm_x86_set_efer)(vcpu, 0);
+	static_call(kvm_x86_update_exception_bitmap)(vcpu);
+
 	/*
 	 * Reset the MMU context if paging was enabled prior to INIT (which is
 	 * implied if CR0.PG=1 as CR0 will be '0' prior to RESET).  Unlike the
-- 
2.32.0.93.g670b81a890-goog

