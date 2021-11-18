Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCF44559B2
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 12:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343763AbhKRLMe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 06:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343635AbhKRLL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 06:11:29 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C193CC061766;
        Thu, 18 Nov 2021 03:08:29 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id p17so5040390pgj.2;
        Thu, 18 Nov 2021 03:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aaIPbPlZcX/+q0XyI84hSF4E3MWCnT4/ujYqpXHxVPo=;
        b=QY9eQPzc/SkgroFXdkdF3M+1x7ypzEd+TYs78bOckRExNeL5y2R8ggbH21rwJhKFJ0
         mj8IvJMzwx1ju/RO/+GhEMAfmGqmoa7lNJaiO0+cMKX19CEejMgD8lLiVJovYTUHS8iD
         4XDQo19aeY1xPLw514icmvE03g8A3R0uBoKHxGPHbR7NNHHgiEnkkJOUHdk1+XcGo7IC
         4mrLJPq0GXWtKfh5dgyclVYlW9edARYJMs+VqaeqkwX6BlJK0KmMn0E1GuqxKXu7tRge
         NvvdQitxFuoz2E8bGCBb8w5MRBPhVYIZ0YZZvG6H46FfFrtTeyHytCe4Hclf2ygABwik
         1sRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aaIPbPlZcX/+q0XyI84hSF4E3MWCnT4/ujYqpXHxVPo=;
        b=Ucd77rqsAaXb3DzrOmH2qdTBlVb9tGH29BPoD2LGrspN1P14QGqPvo2sWYLA8Sp1HQ
         I+ElM7tJaGF88plG+vi/WQ8+wVK4tOEXBgIX41m2Nv32aPUyeGO0eqyzqlvNkEWmlPw5
         1et2A+nNPWLoCeM+yemewCiL6gAoKC2K4VXF7xJlF0ursLbL2WYjgCmpploaxmE70hgh
         9eL7+OwJiDPfDcAzAk+p/UelylBrZr3k6XHhGLqbNuPL8plEjbgL+JcxfVXOaNVpud6r
         g+rvSoMopdr9PdlOGkZQ1Wd/P6WodzhSZiO+XRMtbz++n7PkzYai1jHXCGm3hLtLG9lD
         G2wA==
X-Gm-Message-State: AOAM533URf//bLeoxMgA1ZH5C0H2T4WwmeEkNa+Mmfci6phbVYLG8q2m
        l+dQ/7ytJ1+GZIfvAst1HXloGoNyGdc=
X-Google-Smtp-Source: ABdhPJzXMerScPVSdDHzA5OTRXv7ueO0CF4DfGKG8Dd2Id1jBMK/LUndTqUVkJoUipsRWau5fsah+g==
X-Received: by 2002:a63:9141:: with SMTP id l62mr10732330pge.30.1637233709192;
        Thu, 18 Nov 2021 03:08:29 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id h21sm2061347pgk.74.2021.11.18.03.08.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 03:08:28 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 04/15] KVM: VMX: Save HOST_CR3 in vmx_prepare_switch_to_guest()
Date:   Thu, 18 Nov 2021 19:08:03 +0800
Message-Id: <20211118110814.2568-5-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211118110814.2568-1-jiangshanlai@gmail.com>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

The host CR3 in the vcpu thread can only be changed when scheduling.
Moving the code in vmx_prepare_switch_to_guest() makes the code
simpler.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/vmx/nested.c |  8 +-------
 arch/x86/kvm/vmx/vmx.c    | 17 ++++++++++-------
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2d9565b37fe0..d8d0dbc4fc18 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3028,7 +3028,7 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long cr3, cr4;
+	unsigned long cr4;
 	bool vm_fail;
 
 	if (!nested_early_check)
@@ -3051,12 +3051,6 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 	 */
 	vmcs_writel(GUEST_RFLAGS, 0);
 
-	cr3 = __get_current_cr3_fast();
-	if (unlikely(cr3 != vmx->loaded_vmcs->host_state.cr3)) {
-		vmcs_writel(HOST_CR3, cr3);
-		vmx->loaded_vmcs->host_state.cr3 = cr3;
-	}
-
 	cr4 = cr4_read_shadow();
 	if (unlikely(cr4 != vmx->loaded_vmcs->host_state.cr4)) {
 		vmcs_writel(HOST_CR4, cr4);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fc7aa7f30ad5..e8a41fdc3c4d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1103,6 +1103,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 #ifdef CONFIG_X86_64
 	int cpu = raw_smp_processor_id();
 #endif
+	unsigned long cr3;
 	unsigned long fs_base, gs_base;
 	u16 fs_sel, gs_sel;
 	int i;
@@ -1167,6 +1168,14 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 #endif
 
 	vmx_set_host_fs_gs(host_state, fs_sel, gs_sel, fs_base, gs_base);
+
+	/* Host CR3 including its PCID is stable when guest state is loaded. */
+	cr3 = __get_current_cr3_fast();
+	if (unlikely(cr3 != host_state->cr3)) {
+		vmcs_writel(HOST_CR3, cr3);
+		host_state->cr3 = cr3;
+	}
+
 	vmx->guest_state_loaded = true;
 }
 
@@ -6590,7 +6599,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long cr3, cr4;
+	unsigned long cr4;
 
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!enable_vnmi &&
@@ -6634,12 +6643,6 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RIP))
 		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
 
-	cr3 = __get_current_cr3_fast();
-	if (unlikely(cr3 != vmx->loaded_vmcs->host_state.cr3)) {
-		vmcs_writel(HOST_CR3, cr3);
-		vmx->loaded_vmcs->host_state.cr3 = cr3;
-	}
-
 	cr4 = cr4_read_shadow();
 	if (unlikely(cr4 != vmx->loaded_vmcs->host_state.cr4)) {
 		vmcs_writel(HOST_CR4, cr4);
-- 
2.19.1.6.gb485710b

