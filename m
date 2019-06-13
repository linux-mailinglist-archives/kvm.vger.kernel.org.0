Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 084A14483B
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393406AbfFMRFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:05:47 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46182 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731895AbfFMREH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:04:07 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so21537235wrw.13;
        Thu, 13 Jun 2019 10:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=h/ch4oiulZtlDeR1eBUPOfagcxgYvlYrQowAhXtcCUY=;
        b=Xd0Iof4/FKGVv1Tij28DY+YsaBAWDwCPIgrb6HCUVu00kHOpGLG2BagPtN/6mGfZJ8
         Ti1LqdakP0RGZ0LJkhauzL1LMMv/xJYTtwp6urVu8G8zwcirC4N4yxbrQKbWFDA1Bytw
         PYiukYRMICNv0nhVHiUtZCg09hZX/oezlvOYFuj+HU/gQHUs/Z6EL46KXf8dGrttXIoA
         rTl2sqLw2ZQD3fWEqb24I1Oe99gtDR3RVgxIKyS6HLQp9s6o3ZxcG72/HiK6GIoqNm0a
         CbXNKEZ95ZYCZdIX+aX3wZ2s6ySgerJBeM6b/VWYPU8tRxNnaCwg6COOYLhha5VgK3SH
         8MZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=h/ch4oiulZtlDeR1eBUPOfagcxgYvlYrQowAhXtcCUY=;
        b=bkIS3exNSqGr6LhhNM1BjiMB0CpB/35bhgO6jmI6cfU6qDX6vI8+r4P8bTWfdRgyJ3
         Q6Uo7CG1wDZyOqtCnau2x+CgbmjXPFuoxlKJeiAi5hvLOOv4YR2zG/nVGeKkz5fyHzFw
         CbonZVgzVc+hcIuVtQro52xQqa69jrqUK4PvFcJq7/b5JhzDVD6uZaTB+5eIyUuIH9F7
         Dy1CLh4Y4lxzS77Ox5umF7LjopjOjBp7aBHRHoxTK6Vgrc1CI9nhnlFHzE1onvMMndR2
         2jCUlX6EyE/n1Z1Dw7A+Z+R94NcepGhcVmoPLWoMQaJigw3RA5yvQqKxT0iQdcVF5/wp
         l7Fg==
X-Gm-Message-State: APjAAAVMW3YBLtfAeNqmqxCgNQi2X8mqFH9UXiLic1HPaKIhrHkmtT4v
        OnRQonyQauMx1pTl3PTuokl3wg5w
X-Google-Smtp-Source: APXvYqw2Lr3ERjkkChj33ZFK9lLjn4Zoouhr1lXy9W648XwjYQI7FdcWG8sdj9lG+Bg4YOd5QC+7mQ==
X-Received: by 2002:adf:f946:: with SMTP id q6mr8634649wrr.109.1560445445771;
        Thu, 13 Jun 2019 10:04:05 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.04.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:04:05 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 33/43] KVM: VMX: Shadow VMCS pin controls
Date:   Thu, 13 Jun 2019 19:03:19 +0200
Message-Id: <1560445409-17363-34-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Prepare to shadow all major control fields on a per-VMCS basis, which
allows KVM to avoid costly VMWRITEs when switching between vmcs01 and
vmcs02.

Shadowing pin controls also allows a future patch to remove the per-VMCS
'hv_timer_armed' flag, as the shadow copy is a superset of said flag.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c |  3 ++-
 arch/x86/kvm/vmx/vmx.c    | 10 ++++------
 arch/x86/kvm/vmx/vmx.h    |  2 ++
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f5612b475393..0179ac083dd1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -285,6 +285,7 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 
 	vm_entry_controls_reset_shadow(vmx);
 	vm_exit_controls_reset_shadow(vmx);
+	pin_controls_reset_shadow(vmx);
 	vmx_segment_cache_clear(vmx);
 }
 
@@ -2026,7 +2027,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	} else {
 		exec_control &= ~PIN_BASED_POSTED_INTR;
 	}
-	vmcs_write32(PIN_BASED_VM_EXEC_CONTROL, exec_control);
+	pin_controls_init(vmx, exec_control);
 
 	/*
 	 * EXEC CONTROLS
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 91e43c03144d..6eb4063d98fc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3844,7 +3844,7 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	vmcs_write32(PIN_BASED_VM_EXEC_CONTROL, vmx_pin_based_exec_ctrl(vmx));
+	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
 	if (cpu_has_secondary_exec_ctrls()) {
 		if (kvm_vcpu_apicv_active(vcpu))
 			vmcs_set_bits(SECONDARY_VM_EXEC_CONTROL,
@@ -4042,7 +4042,7 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	vmcs_write64(VMCS_LINK_POINTER, -1ull); /* 22.3.1.5 */
 
 	/* Control */
-	vmcs_write32(PIN_BASED_VM_EXEC_CONTROL, vmx_pin_based_exec_ctrl(vmx));
+	pin_controls_init(vmx, vmx_pin_based_exec_ctrl(vmx));
 	vmx->hv_deadline_tsc = -1;
 
 	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, vmx_exec_control(vmx));
@@ -6366,8 +6366,7 @@ static void vmx_arm_hv_timer(struct vcpu_vmx *vmx, u32 val)
 {
 	vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, val);
 	if (!vmx->loaded_vmcs->hv_timer_armed)
-		vmcs_set_bits(PIN_BASED_VM_EXEC_CONTROL,
-			      PIN_BASED_VMX_PREEMPTION_TIMER);
+		pin_controls_setbit(vmx, PIN_BASED_VMX_PREEMPTION_TIMER);
 	vmx->loaded_vmcs->hv_timer_armed = true;
 }
 
@@ -6396,8 +6395,7 @@ static void vmx_update_hv_timer(struct kvm_vcpu *vcpu)
 	}
 
 	if (vmx->loaded_vmcs->hv_timer_armed)
-		vmcs_clear_bits(PIN_BASED_VM_EXEC_CONTROL,
-				PIN_BASED_VMX_PREEMPTION_TIMER);
+		pin_controls_clearbit(vmx, PIN_BASED_VMX_PREEMPTION_TIMER);
 	vmx->loaded_vmcs->hv_timer_armed = false;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 0a1b37d69f13..3c0a8b01f1f0 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -88,6 +88,7 @@ struct pt_desc {
 struct vmx_controls_shadow {
 	u32 vm_entry;
 	u32 vm_exit;
+	u32 pin;
 };
 
 /*
@@ -423,6 +424,7 @@ static inline u8 vmx_get_rvi(void)
 }
 BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS)
 BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS)
+BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL)
 
 static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 {
-- 
1.8.3.1


