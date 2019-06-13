Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2A5244836
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389994AbfFMRFa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:05:30 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37344 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729910AbfFMREL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:04:11 -0400
Received: by mail-wr1-f67.google.com with SMTP id v14so21573518wrr.4;
        Thu, 13 Jun 2019 10:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jMvavtK7Y3WHw/x1/jskV5yKSrFIX1h2kxifc8uHyUk=;
        b=Jso9040Uw0kwPhoVZivuj+ZR4eO8Jv/WsrWKsCrAcQHbaLdpkdSzecWpom3LeypBm3
         /foa7FVyOAyfkVyKEeGUhDgG6WL6GDBJhUOihzz+7Mop+ifggPQ5W5qooHYZOydCXCK2
         6oLhKPhAftT7fSNY2mFul/SRKMDx8/zre96dJ62l71xafHQF+VOpnBEcCRHb6Ydj9WKl
         FfDCt/EcjGiRIbPFvu4DHgIHKRSAoE/SgFnD/srl+QRjIn2Swg8NDUxic3CGvJofPwz8
         sHgEpj/4TyOjqIRyeNYKgTqWa89DpiIOK1nv9k3Omo+umHfFbo/+nU/MKTb5+byhNrkt
         k1qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=jMvavtK7Y3WHw/x1/jskV5yKSrFIX1h2kxifc8uHyUk=;
        b=YUl5Bj5gdBwFeaLMPEA/hPUUL7UFtRVe/Zoro/qnaC/SbJllIoKmbz+FlSS03NVbik
         FAY4LbFGt5iZsjra59/Q91j24Q7ZRYUf5P1f0H6pZoihMsSZuT/i/694vqTZbguRC3eH
         I62Vo7Td1y2Xd9O7dUOGMyNyAQGZ78cGuY8cWDq3JrQBMGQEzz2XPQS6vE522/n8WWW6
         uAVwd0L4ViWDzQrILOKQ0CPS6ybtGulX4sujRQvOhgPrxO3lyqywB4/GEorzR3O9uYaG
         /D2uog4t/Z5cSksadtVOq4X9vC3GQeb7zz4S5u1PAnOkGUXeNISpj2iSUlNFJ7Peldfr
         VzyQ==
X-Gm-Message-State: APjAAAVqH6u8ImH5aBWeY3iLrcvaesdIP/xhTVLmqST78Hum9601hCpB
        Yl7DWrw3Ynt99ghma2ca9JFZEvwg
X-Google-Smtp-Source: APXvYqyHKCLf1JiG5xZvuHpP60czySjQZk42ezo40gY+zwCJKLFbmXXAtqZw64lgcsYtmKscb1qwQg==
X-Received: by 2002:a5d:4311:: with SMTP id h17mr62622157wrq.9.1560445448602;
        Thu, 13 Jun 2019 10:04:08 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.04.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:04:07 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 36/43] KVM: nVMX: Shadow VMCS controls on a per-VMCS basis
Date:   Thu, 13 Jun 2019 19:03:22 +0200
Message-Id: <1560445409-17363-37-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

... to pave the way for not preserving the shadow copies across switches
between vmcs01 and vmcs02, and eventually to avoid VMWRITEs to vmcs02
when the desired value is unchanged across nested VM-Enters.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmcs.h |  9 +++++++++
 arch/x86/kvm/vmx/vmx.h  | 22 +++++++---------------
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 971a46c69df4..52f12d78e4fa 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -42,6 +42,14 @@ struct vmcs_host_state {
 #endif
 };
 
+struct vmcs_controls_shadow {
+	u32 vm_entry;
+	u32 vm_exit;
+	u32 pin;
+	u32 exec;
+	u32 secondary_exec;
+};
+
 /*
  * Track a VMCS that may be loaded on a certain CPU. If it is (cpu!=-1), also
  * remember whether it was VMLAUNCHed, and maintain a linked list of all VMCSs
@@ -61,6 +69,7 @@ struct loaded_vmcs {
 	unsigned long *msr_bitmap;
 	struct list_head loaded_vmcss_on_cpu_link;
 	struct vmcs_host_state host_state;
+	struct vmcs_controls_shadow controls_shadow;
 };
 
 static inline bool is_exception_n(u32 intr_info, u8 vector)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index b4d5684b0be9..7616f2a455d2 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -85,14 +85,6 @@ struct pt_desc {
 	struct pt_ctx guest;
 };
 
-struct vmx_controls_shadow {
-	u32 vm_entry;
-	u32 vm_exit;
-	u32 pin;
-	u32 exec;
-	u32 secondary_exec;
-};
-
 /*
  * The nested_vmx structure is part of vcpu_vmx, and holds information we need
  * for correct emulation of VMX (i.e., nested VMX) on this vcpu.
@@ -209,8 +201,6 @@ struct vcpu_vmx {
 	u32                   idt_vectoring_info;
 	ulong                 rflags;
 
-	struct vmx_controls_shadow	controls_shadow;
-
 	struct shared_msr_entry *guest_msrs;
 	int                   nmsrs;
 	int                   save_nmsrs;
@@ -400,21 +390,23 @@ static inline u8 vmx_get_rvi(void)
 #define BUILD_CONTROLS_SHADOW(lname, uname)				    \
 static inline void lname##_controls_reset_shadow(struct vcpu_vmx *vmx)	    \
 {									    \
-	vmx->controls_shadow.lname = vmcs_read32(uname);		    \
+	vmx->loaded_vmcs->controls_shadow.lname = vmcs_read32(uname);	    \
 }									    \
 static inline void lname##_controls_init(struct vcpu_vmx *vmx, u32 val)	    \
 {									    \
 	vmcs_write32(uname, val);					    \
-	vmx->controls_shadow.lname = val;				    \
+	vmx->loaded_vmcs->controls_shadow.lname = val;			    \
 }									    \
 static inline void lname##_controls_set(struct vcpu_vmx *vmx, u32 val)	    \
 {									    \
-	if (vmx->controls_shadow.lname != val)				    \
-		lname##_controls_init(vmx, val);			    \
+	if (vmx->loaded_vmcs->controls_shadow.lname != val) {		    \
+		vmcs_write32(uname, val);				    \
+		vmx->loaded_vmcs->controls_shadow.lname = val;		    \
+	}								    \
 }									    \
 static inline u32 lname##_controls_get(struct vcpu_vmx *vmx)		    \
 {									    \
-	return vmx->controls_shadow.lname;				    \
+	return vmx->loaded_vmcs->controls_shadow.lname;			    \
 }									    \
 static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u32 val)   \
 {									    \
-- 
1.8.3.1


