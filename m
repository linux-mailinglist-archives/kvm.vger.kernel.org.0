Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C253FB699
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 14:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236697AbhH3M6I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 08:58:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54982 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236541AbhH3M6H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Aug 2021 08:58:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630328233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a6qS2d/6RiUSU4ihtDvVBGe9b2rTAhknJqG0vhx2QIQ=;
        b=bltdKawiXrd1USsUox9Uu7idf7YYPwpHzNpqhx62V/z9PZOYpnl8sIdShxXy+O6LccDNMU
        3ZU2stsnl6h6hnrUub1aDD+eIm/mcl2ZJOShYpgydymRi4UT32JDhCafG81iFaivzL7Ic1
        BPljux05G32jIF3s6gN7QAsYnSnYupE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-rKAMZJkePCSn8XLQbP7WXw-1; Mon, 30 Aug 2021 08:56:08 -0400
X-MC-Unique: rKAMZJkePCSn8XLQbP7WXw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A347C7402;
        Mon, 30 Aug 2021 12:56:06 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5513F60854;
        Mon, 30 Aug 2021 12:56:03 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH v2 6/6] KVM: nVMX: re-evaluate emulation_required on nested VM exit
Date:   Mon, 30 Aug 2021 15:55:39 +0300
Message-Id: <20210830125539.1768833-7-mlevitsk@redhat.com>
In-Reply-To: <20210830125539.1768833-1-mlevitsk@redhat.com>
References: <20210830125539.1768833-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
index 02d061f5956a..7ff1e1daeb0a 100644
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

