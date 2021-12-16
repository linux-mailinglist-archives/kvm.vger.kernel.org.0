Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD4B4767CE
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 03:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbhLPCTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 21:19:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbhLPCTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 21:19:30 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1504C06173E;
        Wed, 15 Dec 2021 18:19:29 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id x1-20020a17090a2b0100b001b103e48cfaso1007652pjc.0;
        Wed, 15 Dec 2021 18:19:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3zlEE86FcAx6r0dZXJsCvgarwdcik5/I5BPIqtrkrAo=;
        b=QlCYncsP5gdmeUCiKHKeTsFvcyvAqok5CbopbK9Ial/jmXmwj4xG6x5PbpNRPOGGEy
         cZZ2qwJMwjv6iXriYVGUM2FX8V6joZHh6uqiHXzE9FuaoY8xsgNwUI+QXL2Z36hT3mfc
         P0WLiJD1LAk18rw9y3deRhBbhEuUC/CTkslwWjiDoBFky5krfxRU+xnWGyIBvjpMN5Yx
         jAr8q61ukTaQgTLMfiwJqCWV+0XhMQIOnx4ongEeie4GGjnvu8nrYgnl7gvGs3S97fZB
         x3W7eMQuM3UWvekBiUpmiCLT6NDPhMvhcBjjm4nD6h7ld7eBs6GBSJSAOmj6gy31DteY
         vGBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3zlEE86FcAx6r0dZXJsCvgarwdcik5/I5BPIqtrkrAo=;
        b=sXcupMHWQqww1/gW7Gc/eyYdqfsFd2t/zoi+n90VIyMWNNvrjpV1ACq1a/FD2teb56
         wJh22p7YM3GMAd3qYyeYkeiFEHDxISlBFGqvmeB5Efg4imt1IJKNsnJI5BYO5j02SUt/
         0wPUJ7vIjVR5egr/NyXkwGPEwcjb6fP7O4DjCnWZVmsoZBYjCc+tCP+ORV3APTlOV0y1
         tAkIiJorai1FDMSYBQeT7Nm++2wa3Ma4HjDWH49OgOc2epSxa04wpRxd62X9FClHsvWM
         hZ0ktW9mVk/Ypb9gg44Yp4vrZEW28d0rXZ5xCY+5IBR8KXcSXltAYwv+09i2rokvhwMe
         YVYg==
X-Gm-Message-State: AOAM5307jpSTR15QMR44sDFxUpBUgHjxMkwaYMKQRdRQt6p8lpmjGnUZ
        nvz3HU3WBqtkeAldlv4zR/xYAPN8om10GA==
X-Google-Smtp-Source: ABdhPJxqV2uZE0ptJj0rlZsugLlIFlf3oOgOiS4UGT2D259WGgXXKIT36UBB37Qbr35LIJw5MQKUDQ==
X-Received: by 2002:a17:902:c410:b0:142:2506:cb5b with SMTP id k16-20020a170902c41000b001422506cb5bmr14384413plk.36.1639621169341;
        Wed, 15 Dec 2021 18:19:29 -0800 (PST)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id z3sm4259814pfe.174.2021.12.15.18.19.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Dec 2021 18:19:29 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH V2 1/3] KVM: VMX: Save HOST_CR3 in vmx_prepare_switch_to_guest()
Date:   Thu, 16 Dec 2021 10:19:36 +0800
Message-Id: <20211216021938.11752-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211216021938.11752-1-jiangshanlai@gmail.com>
References: <20211216021938.11752-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

The host CR3 in the vcpu thread can only be changed when scheduling.

So HOST_CR3 can be saved only in vmx_prepare_switch_to_guest() and be
synced in vmx_sync_vmcs_host_state() when switching VMCS.

vmx_set_host_fs_gs() is called in both places, so it is renamed to
vmx_set_vmcs_host_state() and it also updates the HOST_CR3.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/vmx/nested.c | 11 +++--------
 arch/x86/kvm/vmx/vmx.c    | 21 +++++++++++----------
 arch/x86/kvm/vmx/vmx.h    |  5 +++--
 3 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 26b236187850..d07a7fa75783 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -245,7 +245,8 @@ static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
 	src = &prev->host_state;
 	dest = &vmx->loaded_vmcs->host_state;
 
-	vmx_set_host_fs_gs(dest, src->fs_sel, src->gs_sel, src->fs_base, src->gs_base);
+	vmx_set_vmcs_host_state(dest, src->cr3, src->fs_sel, src->gs_sel,
+				src->fs_base, src->gs_base);
 	dest->ldt_sel = src->ldt_sel;
 #ifdef CONFIG_X86_64
 	dest->ds_sel = src->ds_sel;
@@ -3054,7 +3055,7 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long cr3, cr4;
+	unsigned long cr4;
 	bool vm_fail;
 
 	if (!nested_early_check)
@@ -3077,12 +3078,6 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
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
index 7826556b2a47..5f281f5ee961 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1069,9 +1069,14 @@ static void pt_guest_exit(struct vcpu_vmx *vmx)
 		wrmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
 }
 
-void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
-			unsigned long fs_base, unsigned long gs_base)
+void vmx_set_vmcs_host_state(struct vmcs_host_state *host, unsigned long cr3,
+			     u16 fs_sel, u16 gs_sel,
+			     unsigned long fs_base, unsigned long gs_base)
 {
+	if (unlikely(cr3 != host->cr3)) {
+		vmcs_writel(HOST_CR3, cr3);
+		host->cr3 = cr3;
+	}
 	if (unlikely(fs_sel != host->fs_sel)) {
 		if (!(fs_sel & 7))
 			vmcs_write16(HOST_FS_SELECTOR, fs_sel);
@@ -1166,7 +1171,9 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	gs_base = segment_base(gs_sel);
 #endif
 
-	vmx_set_host_fs_gs(host_state, fs_sel, gs_sel, fs_base, gs_base);
+	vmx_set_vmcs_host_state(host_state, __get_current_cr3_fast(),
+				fs_sel, gs_sel, fs_base, gs_base);
+
 	vmx->guest_state_loaded = true;
 }
 
@@ -6629,7 +6636,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long cr3, cr4;
+	unsigned long cr4;
 
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!enable_vnmi &&
@@ -6674,12 +6681,6 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
 	vcpu->arch.regs_dirty = 0;
 
-	cr3 = __get_current_cr3_fast();
-	if (unlikely(cr3 != vmx->loaded_vmcs->host_state.cr3)) {
-		vmcs_writel(HOST_CR3, cr3);
-		vmx->loaded_vmcs->host_state.cr3 = cr3;
-	}
-
 	cr4 = cr4_read_shadow();
 	if (unlikely(cr4 != vmx->loaded_vmcs->host_state.cr4)) {
 		vmcs_writel(HOST_CR4, cr4);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 99588aa8474b..acb874db02da 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -374,8 +374,9 @@ int allocate_vpid(void);
 void free_vpid(int vpid);
 void vmx_set_constant_host_state(struct vcpu_vmx *vmx);
 void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
-void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
-			unsigned long fs_base, unsigned long gs_base);
+void vmx_set_vmcs_host_state(struct vmcs_host_state *host, unsigned long cr3,
+			     u16 fs_sel, u16 gs_sel,
+			     unsigned long fs_base, unsigned long gs_base);
 int vmx_get_cpl(struct kvm_vcpu *vcpu);
 bool vmx_emulation_required(struct kvm_vcpu *vcpu);
 unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu);
-- 
2.19.1.6.gb485710b

