Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8A4274AE0
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 23:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgIVVLB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 17:11:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56012 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726753AbgIVVLA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Sep 2020 17:11:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600809059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/+oNahUyc1L8+SVW2454azJwTs5I30pVB67+1TYtBy0=;
        b=YW2XPwDz/hpccHQFFEDqgEv7TcQcGfTGdaS8WfQLVA2S/WixxoubvZJn98OFgqdhYCSJte
        K+cOWpPBpaylxxvSuWdSUjp/DahtQRphiRCym91wlsfG4xUph2MEcGUEFxR1nci0sliCBm
        4YC2G8Q98XirYD3iMNAc/YgESizryws=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-4c3pJygNMGOxjtxY3k4UlQ-1; Tue, 22 Sep 2020 17:10:57 -0400
X-MC-Unique: 4c3pJygNMGOxjtxY3k4UlQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DAB81188C122;
        Tue, 22 Sep 2020 21:10:55 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ADDA755789;
        Tue, 22 Sep 2020 21:10:42 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v6 3/4] KVM: x86: allow kvm_x86_ops.set_efer to return an error value
Date:   Wed, 23 Sep 2020 00:10:24 +0300
Message-Id: <20200922211025.175547-4-mlevitsk@redhat.com>
In-Reply-To: <20200922211025.175547-1-mlevitsk@redhat.com>
References: <20200922211025.175547-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will be used to signal an error to the userspace, in case
the vendor code failed during handling of this msr. (e.g -ENOMEM)

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/svm/svm.c          | 3 ++-
 arch/x86/kvm/svm/svm.h          | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 6 ++++--
 arch/x86/kvm/x86.c              | 8 +++++++-
 5 files changed, 15 insertions(+), 6 deletions(-)

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
index 3da5b2f1b4a19..18f8af55e970a 100644
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
index 45496775f0db2..1e1842de0efe7 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -338,7 +338,7 @@ static inline bool gif_set(struct vcpu_svm *svm)
 #define MSR_INVALID				0xffffffffU
 
 u32 svm_msrpm_offset(u32 msr);
-void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
+int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 void svm_flush_tlb(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6f9a0c6d5dc59..7f7451ff80ffc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2835,13 +2835,14 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 	kvm_mmu_reset_context(vcpu);
 }
 
-void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
+int vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct shared_msr_entry *msr = find_msr_entry(vmx, MSR_EFER);
 
+	/* Nothing to do if hardware doesn't support EFER. */
 	if (!msr)
-		return;
+		return 0;
 
 	vcpu->arch.efer = efer;
 	if (efer & EFER_LMA) {
@@ -2853,6 +2854,7 @@ void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 		msr->data = efer & ~EFER_LME;
 	}
 	setup_msrs(vmx);
+	return 0;
 }
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e4b07be450d4e..df53baa0059fe 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1456,6 +1456,7 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	u64 old_efer = vcpu->arch.efer;
 	u64 efer = msr_info->data;
+	int r;
 
 	if (efer & efer_reserved_bits)
 		return 1;
@@ -1472,7 +1473,12 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	efer &= ~EFER_LMA;
 	efer |= vcpu->arch.efer & EFER_LMA;
 
-	kvm_x86_ops.set_efer(vcpu, efer);
+	r = kvm_x86_ops.set_efer(vcpu, efer);
+
+	if (r) {
+		WARN_ON(r > 0);
+		return r;
+	}
 
 	/* Update reserved bits */
 	if ((efer ^ old_efer) & EFER_NX)
-- 
2.26.2

