Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F3024B1E4
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 11:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgHTJPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 05:15:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39531 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726772AbgHTJOY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 05:14:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597914862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RKnLQhTu+aSzcK2uUxgPf7M4GOvsqYW4Ht9dOT+N7Rk=;
        b=dGh0Gy0BI1SB4g9Xqzt3zLbMuug+akbb76kTyjkVpJ5k42XOz1BkJrk/ImB6ddIdfJt+/3
        HG8DAd8VRGoaArnf0WhEKexQh875N/URG1bqL8HYeZ0TSK1YxSwUobLll8FYfI4yg8g4VT
        4aU4YdDGM904SnzV87aobFhiFWH/S+Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-oCujtFq_PImT4NyE74UQAg-1; Thu, 20 Aug 2020 05:14:05 -0400
X-MC-Unique: oCujtFq_PImT4NyE74UQAg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE7C4425D5;
        Thu, 20 Aug 2020 09:14:03 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B9C87E309;
        Thu, 20 Aug 2020 09:14:00 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)),
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 8/8] KVM: nSVM: read only changed fields of the nested guest data area
Date:   Thu, 20 Aug 2020 12:13:27 +0300
Message-Id: <20200820091327.197807-9-mlevitsk@redhat.com>
In-Reply-To: <20200820091327.197807-1-mlevitsk@redhat.com>
References: <20200820091327.197807-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows us to only read fields that are marked as dirty by the nested
guest on vmentry.

I doubt that this has any perf impact but this way it is a bit closer
to real hardware.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 58 +++++++++++++++++++++++++--------------
 arch/x86/kvm/svm/svm.c    |  2 +-
 arch/x86/kvm/svm/svm.h    |  5 ++++
 3 files changed, 44 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index acc4b26fcfcc..f3eef48caee6 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -266,40 +266,57 @@ static void load_nested_vmcb_control(struct vcpu_svm *svm,
 }
 
 static void load_nested_vmcb_save(struct vcpu_svm *svm,
-				  struct vmcb_save_area *save)
+				  struct vmcb_save_area *save,
+				  u32 clean)
 {
 	svm->nested.vmcb->save.rflags = save->rflags;
 	svm->nested.vmcb->save.rax    = save->rax;
 	svm->nested.vmcb->save.rsp    = save->rsp;
 	svm->nested.vmcb->save.rip    = save->rip;
 
-	svm->nested.vmcb->save.es  = save->es;
-	svm->nested.vmcb->save.cs  = save->cs;
-	svm->nested.vmcb->save.ss  = save->ss;
-	svm->nested.vmcb->save.ds  = save->ds;
-	svm->nested.vmcb->save.cpl = save->cpl;
+	if (is_dirty(clean, VMCB_SEG)) {
+		svm->nested.vmcb->save.es  = save->es;
+		svm->nested.vmcb->save.cs  = save->cs;
+		svm->nested.vmcb->save.ss  = save->ss;
+		svm->nested.vmcb->save.ds  = save->ds;
+		svm->nested.vmcb->save.cpl = save->cpl;
+	}
 
-	svm->nested.vmcb->save.gdtr = save->gdtr;
-	svm->nested.vmcb->save.idtr = save->idtr;
+	if (is_dirty(clean, VMCB_DT)) {
+		svm->nested.vmcb->save.gdtr = save->gdtr;
+		svm->nested.vmcb->save.idtr = save->idtr;
+	}
 
-	svm->nested.vmcb->save.efer = save->efer;
-	svm->nested.vmcb->save.cr3 = save->cr3;
-	svm->nested.vmcb->save.cr4 = save->cr4;
-	svm->nested.vmcb->save.cr0 = save->cr0;
+	if (is_dirty(clean, VMCB_CR)) {
+		svm->nested.vmcb->save.efer = save->efer;
+		svm->nested.vmcb->save.cr3 = save->cr3;
+		svm->nested.vmcb->save.cr4 = save->cr4;
+		svm->nested.vmcb->save.cr0 = save->cr0;
+	}
 
-	svm->nested.vmcb->save.cr2 = save->cr2;
+	if (is_dirty(clean, VMCB_CR2))
+		svm->nested.vmcb->save.cr2 = save->cr2;
 
-	svm->nested.vmcb->save.dr7 = save->dr7;
-	svm->nested.vmcb->save.dr6 = save->dr6;
+	if (is_dirty(clean, VMCB_DR)) {
+		svm->nested.vmcb->save.dr7 = save->dr7;
+		svm->nested.vmcb->save.dr6 = save->dr6;
+	}
 
-	svm->nested.vmcb->save.g_pat = save->g_pat;
+	if ((clean & VMCB_NPT) == 0)
+		svm->nested.vmcb->save.g_pat = save->g_pat;
 }
 
 void load_nested_vmcb(struct vcpu_svm *svm, struct vmcb *nested_vmcb, u64 vmcb_gpa)
 {
-	svm->nested.vmcb_gpa = vmcb_gpa;
+	u32 clean = nested_vmcb->control.clean;
+
+	if (svm->nested.vmcb_gpa != vmcb_gpa) {
+		svm->nested.vmcb_gpa = vmcb_gpa;
+		clean = 0;
+	}
+
 	load_nested_vmcb_control(svm, &nested_vmcb->control);
-	load_nested_vmcb_save(svm, &nested_vmcb->save);
+	load_nested_vmcb_save(svm, &nested_vmcb->save, clean);
 }
 
 /*
@@ -619,7 +636,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	/* Exit Guest-Mode */
 	leave_guest_mode(&svm->vcpu);
-	svm->nested.vmcb_gpa = 0;
 	WARN_ON_ONCE(svm->nested.nested_run_pending);
 
 	/* in case we halted in L2 */
@@ -676,7 +692,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	 * Note: since CPU might have changed the values we can't
 	 * trust clean bits
 	 */
-	load_nested_vmcb_save(svm, &nested_vmcb->save);
+	load_nested_vmcb_save(svm, &nested_vmcb->save, 0);
 
 	/* Restore the original control entries */
 	copy_vmcb_control_area(&vmcb->control, &hsave->control);
@@ -759,6 +775,7 @@ int svm_allocate_nested(struct vcpu_svm *svm)
 		goto free_page3;
 
 	svm->nested.vmcb = page_address(vmcb_page);
+	svm->nested.vmcb_gpa = U64_MAX;
 	clear_page(svm->nested.vmcb);
 
 	svm->nested.initialized = true;
@@ -785,6 +802,7 @@ void svm_free_nested(struct vcpu_svm *svm)
 
 	__free_page(virt_to_page(svm->nested.vmcb));
 	svm->nested.vmcb = NULL;
+	svm->nested.vmcb_gpa = U64_MAX;
 
 	svm->nested.initialized = false;
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 06668e0f93e7..f0bb7f622dca 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3924,7 +3924,7 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 		if (kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map) == -EINVAL)
 			return 1;
 
-		load_nested_vmcb(svm, map.hva, vmcb);
+		load_nested_vmcb(svm, map.hva, vmcb_gpa);
 		ret = enter_svm_guest_mode(svm);
 
 		kvm_vcpu_unmap(&svm->vcpu, &map, true);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 80231ef8de6f..4a383c519fdf 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -204,6 +204,11 @@ static inline void vmcb_mark_dirty(struct vmcb *vmcb, int bit)
 	vmcb->control.clean &= ~(1 << bit);
 }
 
+static inline bool is_dirty(u32 clean, int bit)
+{
+	return (clean & (1 << bit)) == 0;
+}
+
 static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 {
 	return container_of(vcpu, struct vcpu_svm, vcpu);
-- 
2.26.2

