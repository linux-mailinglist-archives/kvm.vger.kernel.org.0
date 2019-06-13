Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB614481A
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404675AbfFMREO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:04:14 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36992 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404637AbfFMREN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:04:13 -0400
Received: by mail-wm1-f67.google.com with SMTP id 22so10899993wmg.2;
        Thu, 13 Jun 2019 10:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PauhBnwIydTV1dpSLJWkvku0SUxCuSsze031CqD8fkc=;
        b=MQGrcahyhWeckWrUhfIO/5guXoUkQD30B3O3qgQym0WzPHqZXNaCFgs7WR6v0B4hMy
         a4j5jBB2mQSpSMmTWt2QI5UdzzPfm5iC2d4MvZfAK/bv/lh67X2/1j2/WGDAQAmvFatB
         legqnDUI4//bWtr+/KrJta2FKkFIG9FlkUmbqxXmUAaAWE8SP54etIh/xUp4PJQozWLv
         nFXDKXjG8a0PHR5lJTMHZo/3in1fLYTbq78ZZcLiDeWHvsfMXxSM0l149z1PUgXOmjo2
         z2VCUZNo+WtCaLxmwk4GmptM6a1oI0IK/B9Iy22Iq54/grmoBNhVrB2km46p0Pq+qZmS
         gaug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=PauhBnwIydTV1dpSLJWkvku0SUxCuSsze031CqD8fkc=;
        b=eMdW7ypNMrYEKjZ+Yb2bBc/uDDIDX1qYGONjaR6T5VpxIxNcsQn3/FsvcVZDyG2GV+
         TXsXPgjy/vG/3giNgR8jBJxqsVkwyhEHxqDnSepnJM1PAeKx008sEqqzhcWvaM4vEeNX
         +7PfvViM5g4MLL0SF8yWcbZrvLTBH+C7exSsfV+3tpiMXajDJeoDkqMj0g8LKPN2loNM
         ukZSZxreVmhiKZUX9r6ly0GTgE6sWBLe1LJ8x/KJMtBU69yaMOqoqNRM1Gvwxuf/vmlx
         f3GBBA9TaKTACOX+0nrwneaLs9AYGfRIqivi3VJ/dI23Mal8mCUBTfgrMtnHqPlEVdeD
         nDYw==
X-Gm-Message-State: APjAAAVjmcmGpjIu+N/1fP9xKBb5OAS4nM1+LOtGWl8oiCthyWWsekGu
        rYyUFl4b/BBMg4U7GcYlLgAnSQqS
X-Google-Smtp-Source: APXvYqwN2Wowzw2jGvmve+26R/smJ+CkKjLYTBhGqshRM6i6eZcXd+ty7keD02QZnxB/UVDFBFWhMA==
X-Received: by 2002:a1c:7310:: with SMTP id d16mr4449701wmb.107.1560445450427;
        Thu, 13 Jun 2019 10:04:10 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.04.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:04:09 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 38/43] KVM: VMX: Explicitly initialize controls shadow at VMCS allocation
Date:   Thu, 13 Jun 2019 19:03:24 +0200
Message-Id: <1560445409-17363-39-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Or: Don't re-initialize vmcs02's controls on every nested VM-Entry.

VMWRITEs to the major VMCS controls are deceptively expensive.  Intel
CPUs with VMCS caching (Westmere and later) also optimize away
consistency checks on VM-Entry, i.e. skip consistency checks if the
relevant fields have not changed since the last successful VM-Entry (of
the cached VMCS).  Because uops are a precious commodity, uCode's dirty
VMCS field tracking isn't as precise as software would prefer.  Notably,
writing any of the major VMCS fields effectively marks the entire VMCS
dirty, i.e. causes the next VM-Entry to perform all consistency checks,
which consumes several hundred cycles.

Zero out the controls' shadow copies during VMCS allocation and use the
optimized setter when "initializing" controls.  While this technically
affects both non-nested and nested virtualization, nested virtualization
is the primary beneficiary as avoid VMWRITEs when prepare vmcs02 allows
hardware to optimizie away consistency checks.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 10 +++++-----
 arch/x86/kvm/vmx/vmx.c    | 12 +++++++-----
 arch/x86/kvm/vmx/vmx.h    |  5 -----
 3 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 47adafa42fbf..32bcf777576c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2024,7 +2024,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	} else {
 		exec_control &= ~PIN_BASED_POSTED_INTR;
 	}
-	pin_controls_init(vmx, exec_control);
+	pin_controls_set(vmx, exec_control);
 
 	/*
 	 * EXEC CONTROLS
@@ -2049,7 +2049,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	 */
 	exec_control &= ~CPU_BASED_USE_IO_BITMAPS;
 	exec_control |= CPU_BASED_UNCOND_IO_EXITING;
-	exec_controls_init(vmx, exec_control);
+	exec_controls_set(vmx, exec_control);
 
 	/*
 	 * SECONDARY EXEC CONTROLS
@@ -2079,7 +2079,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 			vmcs_write16(GUEST_INTR_STATUS,
 				vmcs12->guest_intr_status);
 
-		secondary_exec_controls_init(vmx, exec_control);
+		secondary_exec_controls_set(vmx, exec_control);
 	}
 
 	/*
@@ -2098,7 +2098,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		if (guest_efer != host_efer)
 			exec_control |= VM_ENTRY_LOAD_IA32_EFER;
 	}
-	vm_entry_controls_init(vmx, exec_control);
+	vm_entry_controls_set(vmx, exec_control);
 
 	/*
 	 * EXIT CONTROLS
@@ -2110,7 +2110,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	exec_control = vmx_vmexit_ctrl();
 	if (cpu_has_load_ia32_efer() && guest_efer != host_efer)
 		exec_control |= VM_EXIT_LOAD_IA32_EFER;
-	vm_exit_controls_init(vmx, exec_control);
+	vm_exit_controls_set(vmx, exec_control);
 
 	/*
 	 * Interrupt/Exception Fields
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1104f52d281c..6afb2bc3d0ab 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2485,6 +2485,8 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 	}
 
 	memset(&loaded_vmcs->host_state, 0, sizeof(struct vmcs_host_state));
+	memset(&loaded_vmcs->controls_shadow, 0,
+		sizeof(struct vmcs_controls_shadow));
 
 	return 0;
 
@@ -4040,14 +4042,14 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	vmcs_write64(VMCS_LINK_POINTER, -1ull); /* 22.3.1.5 */
 
 	/* Control */
-	pin_controls_init(vmx, vmx_pin_based_exec_ctrl(vmx));
+	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
 	vmx->hv_deadline_tsc = -1;
 
-	exec_controls_init(vmx, vmx_exec_control(vmx));
+	exec_controls_set(vmx, vmx_exec_control(vmx));
 
 	if (cpu_has_secondary_exec_ctrls()) {
 		vmx_compute_secondary_exec_control(vmx);
-		secondary_exec_controls_init(vmx, vmx->secondary_exec_control);
+		secondary_exec_controls_set(vmx, vmx->secondary_exec_control);
 	}
 
 	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
@@ -4105,10 +4107,10 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
 		++vmx->nmsrs;
 	}
 
-	vm_exit_controls_init(vmx, vmx_vmexit_ctrl());
+	vm_exit_controls_set(vmx, vmx_vmexit_ctrl());
 
 	/* 22.2.1, 20.8.1 */
-	vm_entry_controls_init(vmx, vmx_vmentry_ctrl());
+	vm_entry_controls_set(vmx, vmx_vmentry_ctrl());
 
 	vmx->vcpu.arch.cr0_guest_owned_bits = X86_CR0_TS;
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~X86_CR0_TS);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 6f26f3c10805..dddd36cf7c62 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -388,11 +388,6 @@ static inline u8 vmx_get_rvi(void)
 }
 
 #define BUILD_CONTROLS_SHADOW(lname, uname)				    \
-static inline void lname##_controls_init(struct vcpu_vmx *vmx, u32 val)	    \
-{									    \
-	vmcs_write32(uname, val);					    \
-	vmx->loaded_vmcs->controls_shadow.lname = val;			    \
-}									    \
 static inline void lname##_controls_set(struct vcpu_vmx *vmx, u32 val)	    \
 {									    \
 	if (vmx->loaded_vmcs->controls_shadow.lname != val) {		    \
-- 
1.8.3.1


