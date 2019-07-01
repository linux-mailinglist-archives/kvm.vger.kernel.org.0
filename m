Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D45E1392CB
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 19:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731162AbfFGRI1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 13:08:27 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52320 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728989AbfFGRI1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 13:08:27 -0400
Received: by mail-wm1-f66.google.com with SMTP id s3so2792856wms.2;
        Fri, 07 Jun 2019 10:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id;
        bh=Kf2pIGv2sXT3CNxXXKgq4n9y6sE8jdMJqh+yWRb/bBo=;
        b=DP5RcjkbcYvdXZrV9yY1ELaLT1mHBbNAclvQAZo/4WZQKxMw4ndPR/tPkCxFOO1Ew/
         3cUPz3lEDjvboJle7pYBgSRHakAq20Az7o3iwByvOP2GmFG1YoRgAjuJJhaNItsz/q0K
         GPg4HeNPHpIEioPDabuukJ5grGBdycrZO12T2pXlUnA4Y2qr8teWpj+H+gDz4cRRPXIn
         zARBIfgsa6CuyfHbaUrZ8W/NhjnirXZRQM+HoXHt8nOT/NwGl9vvAjq4w+9EDlERdGxJ
         8MrwDPqsAHUtq08mSksquYFqVRKy288Ttaov2C8ctbkT2nlzJNn449mTe2RtdUV6x0pQ
         mmtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id;
        bh=Kf2pIGv2sXT3CNxXXKgq4n9y6sE8jdMJqh+yWRb/bBo=;
        b=XZ4kvoxVDf32cWRFCuA1jQjAwfUIDEqW/cPgEm/FYmpgdkqkzqA8yTzyRu5TxFb0HG
         n12YY1/id/5aq0snaAn8sKmmkIyJ1jS2C4KxsFi4jAo79oLce+iGh0ocQovSBP8OUJx1
         UbT8ce7IJ451swyOcgbQieR5Psiq0rZJ4gUaCc1tuRkS/8z0wUGC7JHOY2q1RtNjaL+K
         xm4yzIJ6iCQrD7ZAF0itLGciasgEd3FYTucgXyH63cfwjSWBvKZIhUw2XzNXNPt7OSW3
         JTdZUK6vumqZSiRsoO9A8r9sm4dC9YKs5frLaYNX92wp/SxGgc+LZY0sDmKb87Wnzhwn
         rUWQ==
X-Gm-Message-State: APjAAAXHXwAU7Zu/YogXaNATB9L6HENbB3sqWXGMzLp+V7BBc+Xqpts/
        ub9f1QxdK++uiFQEbTbw81Z2anDW
X-Google-Smtp-Source: APXvYqy1GY0+C82YxENCmT18D1xSDnV175sXtvMoscashzRQS32QIfmsTVGeFsi5m60uKjQtyk6vIw==
X-Received: by 2002:a7b:c5d1:: with SMTP id n17mr4482277wmk.84.1559927303972;
        Fri, 07 Jun 2019 10:08:23 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b14sm2449980wro.5.2019.06.07.10.08.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 10:08:23 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: VMX: simplify vmx_prepare_switch_to_{guest,host}
Date:   Fri,  7 Jun 2019 19:08:21 +0200
Message-Id: <1559927301-8124-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmx->loaded_cpu_state can only be NULL or equal to vmx->loaded_vmcs,
so change it to a bool.  Because the direction of the bool is
now the opposite of vmx->guest_msrs_dirty, change the direction of
vmx->guest_msrs_dirty so that they match.

Finally, do not imply that MSRs have to be reloaded when
vmx->guest_sregs_loaded is false; instead, set vmx->guest_msrs_loaded
to false explicitly in vmx_prepare_switch_to_host.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	Still untested.

 arch/x86/kvm/vmx/vmx.c | 26 +++++++++++++-------------
 arch/x86/kvm/vmx/vmx.h | 18 ++++++++++++------
 2 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 091610684d28..f1a58e35fa5f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1057,20 +1057,18 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	 * when guest state is loaded. This happens when guest transitions
 	 * to/from long-mode by setting MSR_EFER.LMA.
 	 */
-	if (!vmx->loaded_cpu_state || vmx->guest_msrs_dirty) {
-		vmx->guest_msrs_dirty = false;
+	if (!vmx->guest_msrs_loaded) {
+		vmx->guest_msrs_loaded = true;
 		for (i = 0; i < vmx->save_nmsrs; ++i)
 			kvm_set_shared_msr(vmx->guest_msrs[i].index,
 					   vmx->guest_msrs[i].data,
 					   vmx->guest_msrs[i].mask);
 
 	}
-
-	if (vmx->loaded_cpu_state)
+	if (vmx->guest_sregs_loaded)
 		return;
 
-	vmx->loaded_cpu_state = vmx->loaded_vmcs;
-	host_state = &vmx->loaded_cpu_state->host_state;
+	host_state = &vmx->loaded_vmcs->host_state;
 
 	/*
 	 * Set host fs and gs selectors.  Unfortunately, 22.2.3 does not
@@ -1126,20 +1124,20 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 		vmcs_writel(HOST_GS_BASE, gs_base);
 		host_state->gs_base = gs_base;
 	}
+
+	vmx->guest_sregs_loaded = true;
 }
 
 static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
 {
 	struct vmcs_host_state *host_state;
 
-	if (!vmx->loaded_cpu_state)
+	if (!vmx->guest_sregs_loaded)
 		return;
 
-	WARN_ON_ONCE(vmx->loaded_cpu_state != vmx->loaded_vmcs);
-	host_state = &vmx->loaded_cpu_state->host_state;
+	host_state = &vmx->loaded_vmcs->host_state;
 
 	++vmx->vcpu.stat.host_state_reload;
-	vmx->loaded_cpu_state = NULL;
 
 #ifdef CONFIG_X86_64
 	rdmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
@@ -1165,13 +1163,15 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
 	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
 #endif
 	load_fixmap_gdt(raw_smp_processor_id());
+	vmx->guest_sregs_loaded = false;
+	vmx->guest_msrs_loaded = false;
 }
 
 #ifdef CONFIG_X86_64
 static u64 vmx_read_guest_kernel_gs_base(struct vcpu_vmx *vmx)
 {
 	preempt_disable();
-	if (vmx->loaded_cpu_state)
+	if (vmx->guest_sregs_loaded)
 		rdmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
 	preempt_enable();
 	return vmx->msr_guest_kernel_gs_base;
@@ -1180,7 +1180,7 @@ static u64 vmx_read_guest_kernel_gs_base(struct vcpu_vmx *vmx)
 static void vmx_write_guest_kernel_gs_base(struct vcpu_vmx *vmx, u64 data)
 {
 	preempt_disable();
-	if (vmx->loaded_cpu_state)
+	if (vmx->guest_sregs_loaded)
 		wrmsrl(MSR_KERNEL_GS_BASE, data);
 	preempt_enable();
 	vmx->msr_guest_kernel_gs_base = data;
@@ -1583,7 +1583,7 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 		move_msr_up(vmx, index, save_nmsrs++);
 
 	vmx->save_nmsrs = save_nmsrs;
-	vmx->guest_msrs_dirty = true;
+	vmx->guest_msrs_loaded = false;
 
 	if (cpu_has_vmx_msr_bitmap())
 		vmx_update_msr_bitmap(&vmx->vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index ed65999b07a8..fc369473f9df 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -187,13 +187,23 @@ struct vcpu_vmx {
 	struct kvm_vcpu       vcpu;
 	u8                    fail;
 	u8		      msr_bitmap_mode;
+
+	/*
+	 * If true, host state has been stored in vmx->loaded_vmcs for
+	 * the CPU registers that only need to be switched when transitioning
+	 * to/from the kernel, and the registers have been loaded with guest
+	 * values.  If false, host state is loaded in the CPU registers
+	 * and vmx->loaded_vmcs->host_state is invalid.
+	 */
+	bool		      guest_sregs_loaded;
+
 	u32                   exit_intr_info;
 	u32                   idt_vectoring_info;
 	ulong                 rflags;
 	struct shared_msr_entry *guest_msrs;
 	int                   nmsrs;
 	int                   save_nmsrs;
-	bool                  guest_msrs_dirty;
+	bool                  guest_msrs_loaded;
 #ifdef CONFIG_X86_64
 	u64		      msr_host_kernel_gs_base;
 	u64		      msr_guest_kernel_gs_base;
@@ -208,14 +218,10 @@ struct vcpu_vmx {
 	/*
 	 * loaded_vmcs points to the VMCS currently used in this vcpu. For a
 	 * non-nested (L1) guest, it always points to vmcs01. For a nested
-	 * guest (L2), it points to a different VMCS.  loaded_cpu_state points
-	 * to the VMCS whose state is loaded into the CPU registers that only
-	 * need to be switched when transitioning to/from the kernel; a NULL
-	 * value indicates that host state is loaded.
+	 * guest (L2), it points to a different VMCS.
 	 */
 	struct loaded_vmcs    vmcs01;
 	struct loaded_vmcs   *loaded_vmcs;
-	struct loaded_vmcs   *loaded_cpu_state;
 
 	struct msr_autoload {
 		struct vmx_msrs guest;
-- 
1.8.3.1

