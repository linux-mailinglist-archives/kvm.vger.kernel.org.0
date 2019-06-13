Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1761544849
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389878AbfFMRGv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:06:51 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33759 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393316AbfFMRDz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:03:55 -0400
Received: by mail-wm1-f65.google.com with SMTP id h19so7052519wme.0;
        Thu, 13 Jun 2019 10:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sM2ZDkDfc3xVP5TcHCFlN3z7lS3W3JNmK/SqPBvRIsI=;
        b=J7xLoEG4HWt3EIWfizh/5r9KHYIPfLMEYBhszYwJ9ZcBNNt3eQJw8kXvV3XbCqd34Z
         fJutT4mdL9q5zPq6d92jBfGT/EOYj9bX1HPSB9s6nPKN1jjEmO80Uwnq4+o2z4Z5Ca9+
         2PdM+CSffUgHzziWOMxgb6Fz02dg8ihmGOgVOAcPfDma68EwX/djDH2iCb7SgBJHRhNK
         hLWYvQThAhT1mSUqcorxBGxfTaoZW7lAdsOSd5gaVS3cw2Lwv4pePBiz31T0GeD4LRlZ
         seEVLGGAbM4hzTrkfPjyNju0KbkBHsUB0bsr0e/yv1Bzr2BC8x41pHhVRh2dBBkOHqKX
         TvsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=sM2ZDkDfc3xVP5TcHCFlN3z7lS3W3JNmK/SqPBvRIsI=;
        b=N55vEh8lIgR/IaoaRkBgc5733zu53V3IbmnbIV0/agvxfQavWJQPWcYfmKEt0nNEaz
         0u4Z6c27X284Z25BVqJjiPpF5Wf6qkLUB9ZOtrDT5DH9HDuSe2v9eUzgXl8H8lXXtNPE
         gJPtZMABvBEjNfY67FQ7fIqRy4YDGyJgLLFPNTfOxzH9lLcelte3sskyR7Q/6oAY7Hyx
         QCvXQFJ0jT50h60alwSYLtvugeCLF/xpCjpkymfxj1onsABe1Qb3nkXsk3/qAi5tXxYU
         IQa95iYH49D8aK8PMpkwM0Jjg+hrnT+CBf1CVHbDyI7dh+crpAs3isHMEQxZDeDzjKhS
         AXHA==
X-Gm-Message-State: APjAAAWqYgjEpTKs6t4X8faIABCvW6uaCHMUOMqTFodHPpUWLoJq66Rc
        t17r3y/io5nl6HE5RykrvqNj4g3l
X-Google-Smtp-Source: APXvYqwAIMsGIp2RKXA/w2NyTAHhr/JxU5wypRdO3LmYEmuok3SNbRndZukqGM8YaMPaOiUoyC0uRw==
X-Received: by 2002:a1c:4054:: with SMTP id n81mr4664548wma.78.1560445433261;
        Thu, 13 Jun 2019 10:03:53 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:52 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 19/43] KVM: VMX: simplify vmx_prepare_switch_to_{guest,host}
Date:   Thu, 13 Jun 2019 19:03:05 +0200
Message-Id: <1560445409-17363-20-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmx->loaded_cpu_state can only be NULL or equal to vmx->loaded_vmcs,
so change it to a bool.  Because the direction of the bool is
now the opposite of vmx->guest_msrs_dirty, change the direction of
vmx->guest_msrs_dirty so that they match.

Finally, do not imply that MSRs have to be reloaded when
vmx->guest_state_loaded is false; instead, set vmx->guest_msrs_ready
to false explicitly in vmx_prepare_switch_to_host.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 26 +++++++++++++-------------
 arch/x86/kvm/vmx/vmx.h | 18 ++++++++++++------
 2 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 091610684d28..40a6235bc4d8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1057,20 +1057,18 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	 * when guest state is loaded. This happens when guest transitions
 	 * to/from long-mode by setting MSR_EFER.LMA.
 	 */
-	if (!vmx->loaded_cpu_state || vmx->guest_msrs_dirty) {
-		vmx->guest_msrs_dirty = false;
+	if (!vmx->guest_msrs_ready) {
+		vmx->guest_msrs_ready = true;
 		for (i = 0; i < vmx->save_nmsrs; ++i)
 			kvm_set_shared_msr(vmx->guest_msrs[i].index,
 					   vmx->guest_msrs[i].data,
 					   vmx->guest_msrs[i].mask);
 
 	}
-
-	if (vmx->loaded_cpu_state)
+	if (vmx->guest_state_loaded)
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
+	vmx->guest_state_loaded = true;
 }
 
 static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
 {
 	struct vmcs_host_state *host_state;
 
-	if (!vmx->loaded_cpu_state)
+	if (!vmx->guest_state_loaded)
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
+	vmx->guest_state_loaded = false;
+	vmx->guest_msrs_ready = false;
 }
 
 #ifdef CONFIG_X86_64
 static u64 vmx_read_guest_kernel_gs_base(struct vcpu_vmx *vmx)
 {
 	preempt_disable();
-	if (vmx->loaded_cpu_state)
+	if (vmx->guest_state_loaded)
 		rdmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
 	preempt_enable();
 	return vmx->msr_guest_kernel_gs_base;
@@ -1180,7 +1180,7 @@ static u64 vmx_read_guest_kernel_gs_base(struct vcpu_vmx *vmx)
 static void vmx_write_guest_kernel_gs_base(struct vcpu_vmx *vmx, u64 data)
 {
 	preempt_disable();
-	if (vmx->loaded_cpu_state)
+	if (vmx->guest_state_loaded)
 		wrmsrl(MSR_KERNEL_GS_BASE, data);
 	preempt_enable();
 	vmx->msr_guest_kernel_gs_base = data;
@@ -1583,7 +1583,7 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 		move_msr_up(vmx, index, save_nmsrs++);
 
 	vmx->save_nmsrs = save_nmsrs;
-	vmx->guest_msrs_dirty = true;
+	vmx->guest_msrs_ready = false;
 
 	if (cpu_has_vmx_msr_bitmap())
 		vmx_update_msr_bitmap(&vmx->vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index ed65999b07a8..f35442093397 100644
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
+	bool		      guest_state_loaded;
+
 	u32                   exit_intr_info;
 	u32                   idt_vectoring_info;
 	ulong                 rflags;
 	struct shared_msr_entry *guest_msrs;
 	int                   nmsrs;
 	int                   save_nmsrs;
-	bool                  guest_msrs_dirty;
+	bool                  guest_msrs_ready;
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


