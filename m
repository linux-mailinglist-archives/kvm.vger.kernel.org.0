Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71F204483C
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393034AbfFMRFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:05:52 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36755 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404594AbfFMREH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:04:07 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so21630778wrs.3;
        Thu, 13 Jun 2019 10:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YUvj9CYOkDmPCYkTJKVQccuozOGfPCNMrf6UMmFx91M=;
        b=Asxq1m/Jg7M2WdPQ6+ZISwVtYxl7Ue1/2w6LH5m8scN0TSukZ94SZahiW9bgHmsQfD
         nY1he6VeDP9rfIB3BWu1t8f0K5Og1ZjbyZA/EenXhQ/4XJACp7xn0cGqeb+yjd1bUniN
         tyyODIqsRKTYAALUtc8ppu/AhE/gfZFI9k3xDb1WohNVje+ntpvRiV5F1tFIabNaig+M
         TMyCsA+HMBFVnfRtv8HqaNNFKEQQoAMDszSTgsizoEuQeIn3AsYUy2Z6fzLuHwhoyFe2
         yIc65IjWL6qkWmmr+S+WwhUJljUUAQQJ4JYdJo1PKqnEkU+Zv8+Hm6zaP43QRviz0Mi3
         yX8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=YUvj9CYOkDmPCYkTJKVQccuozOGfPCNMrf6UMmFx91M=;
        b=NhmF36jp38ULrubHEVjsV9rfsP5tRi8x4VSJoIVx81ornSe+Ur/S64WdT2Xp/v2JdW
         ZQKVD+YE/ecbpZu695OnUCDZJc85z/pjl/0YhCicqppe0+c+xGxDeAo07uRLAFHuqicp
         jgZMmL3FZIKyVubb+z/X7bPpBAmlE4SED7WRxd+S3tA6lFi+Vzh4G5DlSL/SDJ3sJ3JA
         hMYgypTvVTbDY8+DvqErUt2M312rC1Nydv8fSHZHCWtDFhP/XvGnCS2OkHTDjGYdXA1+
         HgU6pEln8pwn8bWmbN5tiIfpWpYbBcMXg+kIg0SY8goQ09Co0PlaegDwEkOvBwsiO6t2
         hTmw==
X-Gm-Message-State: APjAAAXHw+cs5FIDXdgA+wfkmK+kUI9qyxnMs7f3ALpCMgDEterlAIjt
        3wxXIgmoXvX4DoZTuFju6qHE/hn/
X-Google-Smtp-Source: APXvYqyQ4a1FAr0vFk+OIRHID0TdGDXe+aflvsCJTRqqZN7VhChAck6S5ShW1oh7d/y1AOl6i6Bk9g==
X-Received: by 2002:adf:f582:: with SMTP id f2mr3124786wro.144.1560445444940;
        Thu, 13 Jun 2019 10:04:04 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.04.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:04:04 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 32/43] KVM: VMX: Add builder macros for shadowing controls
Date:   Thu, 13 Jun 2019 19:03:18 +0200
Message-Id: <1560445409-17363-33-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

... to pave the way for shadowing all (five) major VMCS control fields
without massive amounts of error prone copy+paste+modify.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.h | 100 ++++++++++++++++++-------------------------------
 1 file changed, 36 insertions(+), 64 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 136f22f2e797..0a1b37d69f13 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -85,6 +85,11 @@ struct pt_desc {
 	struct pt_ctx guest;
 };
 
+struct vmx_controls_shadow {
+	u32 vm_entry;
+	u32 vm_exit;
+};
+
 /*
  * The nested_vmx structure is part of vcpu_vmx, and holds information we need
  * for correct emulation of VMX (i.e., nested VMX) on this vcpu.
@@ -200,6 +205,9 @@ struct vcpu_vmx {
 	u32                   exit_intr_info;
 	u32                   idt_vectoring_info;
 	ulong                 rflags;
+
+	struct vmx_controls_shadow	controls_shadow;
+
 	struct shared_msr_entry *guest_msrs;
 	int                   nmsrs;
 	int                   save_nmsrs;
@@ -211,8 +219,6 @@ struct vcpu_vmx {
 
 	u64		      spec_ctrl;
 
-	u32 vm_entry_controls_shadow;
-	u32 vm_exit_controls_shadow;
 	u32 secondary_exec_control;
 
 	/*
@@ -388,69 +394,35 @@ static inline u8 vmx_get_rvi(void)
 	return vmcs_read16(GUEST_INTR_STATUS) & 0xff;
 }
 
-static inline void vm_entry_controls_reset_shadow(struct vcpu_vmx *vmx)
-{
-	vmx->vm_entry_controls_shadow = vmcs_read32(VM_ENTRY_CONTROLS);
-}
-
-static inline void vm_entry_controls_init(struct vcpu_vmx *vmx, u32 val)
-{
-	vmcs_write32(VM_ENTRY_CONTROLS, val);
-	vmx->vm_entry_controls_shadow = val;
-}
-
-static inline void vm_entry_controls_set(struct vcpu_vmx *vmx, u32 val)
-{
-	if (vmx->vm_entry_controls_shadow != val)
-		vm_entry_controls_init(vmx, val);
-}
-
-static inline u32 vm_entry_controls_get(struct vcpu_vmx *vmx)
-{
-	return vmx->vm_entry_controls_shadow;
-}
-
-static inline void vm_entry_controls_setbit(struct vcpu_vmx *vmx, u32 val)
-{
-	vm_entry_controls_set(vmx, vm_entry_controls_get(vmx) | val);
-}
-
-static inline void vm_entry_controls_clearbit(struct vcpu_vmx *vmx, u32 val)
-{
-	vm_entry_controls_set(vmx, vm_entry_controls_get(vmx) & ~val);
-}
-
-static inline void vm_exit_controls_reset_shadow(struct vcpu_vmx *vmx)
-{
-	vmx->vm_exit_controls_shadow = vmcs_read32(VM_EXIT_CONTROLS);
-}
-
-static inline void vm_exit_controls_init(struct vcpu_vmx *vmx, u32 val)
-{
-	vmcs_write32(VM_EXIT_CONTROLS, val);
-	vmx->vm_exit_controls_shadow = val;
-}
-
-static inline void vm_exit_controls_set(struct vcpu_vmx *vmx, u32 val)
-{
-	if (vmx->vm_exit_controls_shadow != val)
-		vm_exit_controls_init(vmx, val);
-}
-
-static inline u32 vm_exit_controls_get(struct vcpu_vmx *vmx)
-{
-	return vmx->vm_exit_controls_shadow;
-}
-
-static inline void vm_exit_controls_setbit(struct vcpu_vmx *vmx, u32 val)
-{
-	vm_exit_controls_set(vmx, vm_exit_controls_get(vmx) | val);
-}
-
-static inline void vm_exit_controls_clearbit(struct vcpu_vmx *vmx, u32 val)
-{
-	vm_exit_controls_set(vmx, vm_exit_controls_get(vmx) & ~val);
+#define BUILD_CONTROLS_SHADOW(lname, uname)				    \
+static inline void lname##_controls_reset_shadow(struct vcpu_vmx *vmx)	    \
+{									    \
+	vmx->controls_shadow.lname = vmcs_read32(uname);		    \
+}									    \
+static inline void lname##_controls_init(struct vcpu_vmx *vmx, u32 val)	    \
+{									    \
+	vmcs_write32(uname, val);					    \
+	vmx->controls_shadow.lname = val;				    \
+}									    \
+static inline void lname##_controls_set(struct vcpu_vmx *vmx, u32 val)	    \
+{									    \
+	if (vmx->controls_shadow.lname != val)				    \
+		lname##_controls_init(vmx, val);			    \
+}									    \
+static inline u32 lname##_controls_get(struct vcpu_vmx *vmx)		    \
+{									    \
+	return vmx->controls_shadow.lname;				    \
+}									    \
+static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u32 val)   \
+{									    \
+	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);	    \
+}									    \
+static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u32 val) \
+{									    \
+	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);	    \
 }
+BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS)
+BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS)
 
 static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 {
-- 
1.8.3.1


