Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5536D4092BA
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 16:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344510AbhIMOPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 10:15:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32633 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344686AbhIMOLw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Sep 2021 10:11:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631542231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lk/zZdd0Y1C1Ug1wnLlgsJMYCiBNV9mqGkl1sFTVUB0=;
        b=CG7+UvtsnjmnK+SvXxKwlPdwb2RyVYwouNwoIppjL9tDaasF152W/3wSZNHSvOrJoeAFCi
        vPBVnBlgBi7tuc1MOx7TYl4UKBwYaEPy3HvLz+lWY04WVDurEJk3WL/sVABg1JrByXOiG9
        +2QkFcwsUnzlMsEJSweQlFu/0WE4d44=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-m33kouAhOOGJ8k0PRAgRDQ-1; Mon, 13 Sep 2021 10:10:30 -0400
X-MC-Unique: m33kouAhOOGJ8k0PRAgRDQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E7901006AA2;
        Mon, 13 Sep 2021 14:10:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF52E19724;
        Mon, 13 Sep 2021 14:10:25 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v3 7/7] KVM: x86: nVMX: re-evaluate emulation_required on nested VM exit
Date:   Mon, 13 Sep 2021 17:09:54 +0300
Message-Id: <20210913140954.165665-8-mlevitsk@redhat.com>
In-Reply-To: <20210913140954.165665-1-mlevitsk@redhat.com>
References: <20210913140954.165665-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If L1 had invalid state on VM entry (can happen on SMM transactions
when we enter from real mode, straight to nested guest),

then after we load 'host' state from VMCS12, the state has to become
valid again, but since we load the segment registers with
__vmx_set_segment we weren't always updating emulation_required.

Update emulation_required explicitly at end of load_vmcs12_host_state.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 2 ++
 arch/x86/kvm/vmx/vmx.c    | 8 ++++----
 arch/x86/kvm/vmx/vmx.h    | 1 +
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1a05ae83dae5..f915e1ac589c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4319,6 +4319,8 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	if (nested_vmx_load_msr(vcpu, vmcs12->vm_exit_msr_load_addr,
 				vmcs12->vm_exit_msr_load_count))
 		nested_vmx_abort(vcpu, VMX_ABORT_LOAD_HOST_MSR_FAIL);
+
+	to_vmx(vcpu)->emulation_required = vmx_emulation_required(vcpu);
 }
 
 static inline u64 nested_vmx_get_vmcs01_guest_efer(struct vcpu_vmx *vmx)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c3b3c406f4f1..7f0a768050db 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1323,7 +1323,7 @@ static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 	vmx_prepare_switch_to_host(to_vmx(vcpu));
 }
 
-static bool emulation_required(struct kvm_vcpu *vcpu)
+bool vmx_emulation_required(struct kvm_vcpu *vcpu)
 {
 	return emulate_invalid_guest_state && !vmx_guest_state_valid(vcpu);
 }
@@ -1367,7 +1367,7 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 	vmcs_writel(GUEST_RFLAGS, rflags);
 
 	if ((old_rflags ^ vmx->rflags) & X86_EFLAGS_VM)
-		vmx->emulation_required = emulation_required(vcpu);
+		vmx->emulation_required = vmx_emulation_required(vcpu);
 }
 
 u32 vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu)
@@ -3077,7 +3077,7 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	}
 
 	/* depends on vcpu->arch.cr0 to be set to a new value */
-	vmx->emulation_required = emulation_required(vcpu);
+	vmx->emulation_required = vmx_emulation_required(vcpu);
 }
 
 static int vmx_get_max_tdp_level(void)
@@ -3330,7 +3330,7 @@ static void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int
 {
 	__vmx_set_segment(vcpu, var, seg);
 
-	to_vmx(vcpu)->emulation_required = emulation_required(vcpu);
+	to_vmx(vcpu)->emulation_required = vmx_emulation_required(vcpu);
 }
 
 static void vmx_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 4858c5fd95f2..3a587c51a8d1 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -359,6 +359,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
 			unsigned long fs_base, unsigned long gs_base);
 int vmx_get_cpl(struct kvm_vcpu *vcpu);
+bool vmx_emulation_required(struct kvm_vcpu *vcpu);
 unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu);
 void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 u32 vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu);
-- 
2.26.3

