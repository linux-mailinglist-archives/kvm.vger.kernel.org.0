Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CCE254BC1
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 19:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgH0RMr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 13:12:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31572 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727946AbgH0RMm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Aug 2020 13:12:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598548360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0eSuGan0/UkqgTX87tH1fFC/jOPqKwkNi+GUUV3aL8Q=;
        b=B22SE1oKY/Ih8fEe7l69tzDVAOD04IgDqnipauyPXGbdBwek4NYK9/AFk+5p43erqI80Ew
        LxZ5tptg+DtRa6dSav/Tj2Bi+oBSkDmdybpSby+8SHHFDoJlEuEM354U//Kpba0RjOHdN3
        95mmadsbOXI1kOfcuz+fEzQd55HqcQ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-p6cjgNmOOxyq1kUYVED_GQ-1; Thu, 27 Aug 2020 13:12:37 -0400
X-MC-Unique: p6cjgNmOOxyq1kUYVED_GQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56EA710ABDBF;
        Thu, 27 Aug 2020 17:12:35 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 149485D9E8;
        Thu, 27 Aug 2020 17:12:24 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 6/8] KVM: x86: allow kvm_x86_ops.set_efer to return a value
Date:   Thu, 27 Aug 2020 20:11:43 +0300
Message-Id: <20200827171145.374620-7-mlevitsk@redhat.com>
In-Reply-To: <20200827171145.374620-1-mlevitsk@redhat.com>
References: <20200827171145.374620-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will be used later to return an error when setting this msr fails.

Note that we ignore this return value for qemu initiated writes to
avoid breaking backward compatibility.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/svm/svm.c          | 3 ++-
 arch/x86/kvm/svm/svm.h          | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 9 ++++++---
 arch/x86/kvm/x86.c              | 3 ++-
 5 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5303dbc5c9bce..b273c199b9a55 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1069,7 +1069,7 @@ struct kvm_x86_ops {
 	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
 	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
 	int (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
-	void (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
+	int (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
 	void (*get_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*get_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b617579095277..4c92432e33e27 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -263,7 +263,7 @@ static int get_max_npt_level(void)
 #endif
 }
 
-void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
+int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	vcpu->arch.efer = efer;
@@ -283,6 +283,7 @@ void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 
 	svm->vmcb->save.efer = efer | EFER_SVME;
 	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
+	return 0;
 }
 
 static int is_external_interrupt(u32 info)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ab913468f9cbe..468c58a915347 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -349,7 +349,7 @@ static inline bool gif_set(struct vcpu_svm *svm)
 #define MSR_INVALID				0xffffffffU
 
 u32 svm_msrpm_offset(u32 msr);
-void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
+int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 void svm_flush_tlb(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 46ba2e03a8926..c2b60d242c2bd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2862,13 +2862,15 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 	kvm_mmu_reset_context(vcpu);
 }
 
-void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
+int vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct shared_msr_entry *msr = find_msr_entry(vmx, MSR_EFER);
 
-	if (!msr)
-		return;
+	if (!msr) {
+		/* Host doen't support EFER, nothing to do */
+		return 0;
+	}
 
 	vcpu->arch.efer = efer;
 	if (efer & EFER_LMA) {
@@ -2880,6 +2882,7 @@ void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 		msr->data = efer & ~EFER_LME;
 	}
 	setup_msrs(vmx);
+	return 0;
 }
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 539ea1cd6020c..3fed4e4367b24 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1471,7 +1471,8 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	efer &= ~EFER_LMA;
 	efer |= vcpu->arch.efer & EFER_LMA;
 
-	kvm_x86_ops.set_efer(vcpu, efer);
+	if (kvm_x86_ops.set_efer(vcpu, efer) && !msr_info->host_initiated)
+		return 1;
 
 	/* Update reserved bits */
 	if ((efer ^ old_efer) & EFER_NX)
-- 
2.26.2

