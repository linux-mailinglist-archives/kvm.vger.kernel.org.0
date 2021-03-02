Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB2432B5AC
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382697AbhCCHTU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43935 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1835993AbhCBTfg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:35:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k2tAxTOM3le04nLES9bO5umweVJR0tmM+PhCQruIT4c=;
        b=bRQ46CNhuggWAR+d2HR6m6UcHfHlyHy6U+dIKHN92LkOAbD5gFhGNA6By+QPDVPZAnAN2H
        N73bGW2oFeW+bBEpg4GmJ4pqDCQfT8bKpnHUYiuTU25cvg8xRCjqAaRSf6XgyhdXh366CB
        IzPLczcgc4NOIV+CULfXl/hvxfnePkI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-onwqXGNnNJSXq5Pm0X9_Mg-1; Tue, 02 Mar 2021 14:33:54 -0500
X-MC-Unique: onwqXGNnNJSXq5Pm0X9_Mg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 117EA107ACC7;
        Tue,  2 Mar 2021 19:33:53 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B014760CC5;
        Tue,  2 Mar 2021 19:33:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 15/23] KVM: x86: Move XSETBV emulation to common code
Date:   Tue,  2 Mar 2021 14:33:35 -0500
Message-Id: <20210302193343.313318-16-pbonzini@redhat.com>
In-Reply-To: <20210302193343.313318-1-pbonzini@redhat.com>
References: <20210302193343.313318-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Move the entirety of XSETBV emulation to x86.c, and assign the
function directly to both VMX's and SVM's exit handlers, i.e. drop the
unnecessary trampolines.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210205005750.3841462-6-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm/svm.c          | 11 +----------
 arch/x86/kvm/vmx/vmx.c          | 11 +----------
 arch/x86/kvm/x86.c              | 13 ++++++++-----
 4 files changed, 11 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 85ccbd4b7c52..b396e854c7db 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1542,7 +1542,7 @@ void kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val);
 unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
 void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l);
-int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr);
+int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu);
 
 int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr);
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5815fedf978e..fcea45f40d76 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2346,15 +2346,6 @@ static int wbinvd_interception(struct kvm_vcpu *vcpu)
 	return kvm_emulate_wbinvd(vcpu);
 }
 
-static int xsetbv_interception(struct kvm_vcpu *vcpu)
-{
-	u64 new_bv = kvm_read_edx_eax(vcpu);
-	u32 index = kvm_rcx_read(vcpu);
-
-	int err = kvm_set_xcr(vcpu, index, new_bv);
-	return kvm_complete_insn_gp(vcpu, err);
-}
-
 static int rdpru_interception(struct kvm_vcpu *vcpu)
 {
 	kvm_queue_exception(vcpu, UD_VECTOR);
@@ -3156,7 +3147,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_WBINVD]                       = wbinvd_interception,
 	[SVM_EXIT_MONITOR]			= monitor_interception,
 	[SVM_EXIT_MWAIT]			= mwait_interception,
-	[SVM_EXIT_XSETBV]			= xsetbv_interception,
+	[SVM_EXIT_XSETBV]			= kvm_emulate_xsetbv,
 	[SVM_EXIT_RDPRU]			= rdpru_interception,
 	[SVM_EXIT_EFER_WRITE_TRAP]		= efer_trap,
 	[SVM_EXIT_CR0_WRITE_TRAP]		= cr_trap,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 50810d471462..0df836897447 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5216,15 +5216,6 @@ static int handle_wbinvd(struct kvm_vcpu *vcpu)
 	return kvm_emulate_wbinvd(vcpu);
 }
 
-static int handle_xsetbv(struct kvm_vcpu *vcpu)
-{
-	u64 new_bv = kvm_read_edx_eax(vcpu);
-	u32 index = kvm_rcx_read(vcpu);
-
-	int err = kvm_set_xcr(vcpu, index, new_bv);
-	return kvm_complete_insn_gp(vcpu, err);
-}
-
 static int handle_apic_access(struct kvm_vcpu *vcpu)
 {
 	if (likely(fasteoi)) {
@@ -5686,7 +5677,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_APIC_WRITE]              = handle_apic_write,
 	[EXIT_REASON_EOI_INDUCED]             = handle_apic_eoi_induced,
 	[EXIT_REASON_WBINVD]                  = handle_wbinvd,
-	[EXIT_REASON_XSETBV]                  = handle_xsetbv,
+	[EXIT_REASON_XSETBV]                  = kvm_emulate_xsetbv,
 	[EXIT_REASON_TASK_SWITCH]             = handle_task_switch,
 	[EXIT_REASON_MCE_DURING_VMENTRY]      = handle_machine_check,
 	[EXIT_REASON_GDTR_IDTR]		      = handle_desc,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1d2bc89431a2..8dc69ff3d205 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -984,14 +984,17 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 	return 0;
 }
 
-int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
+int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
 {
-	if (static_call(kvm_x86_get_cpl)(vcpu) == 0)
-		return __kvm_set_xcr(vcpu, index, xcr);
+	if (static_call(kvm_x86_get_cpl)(vcpu) != 0 ||
+	    __kvm_set_xcr(vcpu, kvm_rcx_read(vcpu), kvm_read_edx_eax(vcpu))) {
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
 
-	return 1;
+	return kvm_skip_emulated_instruction(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_set_xcr);
+EXPORT_SYMBOL_GPL(kvm_emulate_xsetbv);
 
 bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
-- 
2.26.2


