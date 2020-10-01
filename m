Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C2227FE6B
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 13:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732067AbgJALaa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 07:30:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32419 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732028AbgJALa2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 07:30:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601551826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1txBtZ/HorvKOSsIVwiQiF/RnfiVIoCQrC/a5ZwkDyg=;
        b=fBcwnbv498AYEdYA/na3rU/P9Pg4DgV/3YyD7fvQzaroiMPibjqHIHlzopeBiF6UMRTVZ/
        GYDYkdkZgs+isI12AedbcmmylS1Ef9iaL0+txChz7s/B6W1RXHNdwPUB9u6WEg+p/TlhTz
        jQnopEKb8HVYzH1sf7yIMLEYxhhNeUI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-C67tslfWPKGDKVBka4wx3w-1; Thu, 01 Oct 2020 07:30:23 -0400
X-MC-Unique: C67tslfWPKGDKVBka4wx3w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D6B9873116;
        Thu,  1 Oct 2020 11:30:21 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00F2F5579C;
        Thu,  1 Oct 2020 11:30:17 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v7 3/4] KVM: x86: allow kvm_x86_ops.set_efer to return an error value
Date:   Thu,  1 Oct 2020 14:29:53 +0300
Message-Id: <20201001112954.6258-4-mlevitsk@redhat.com>
In-Reply-To: <20201001112954.6258-1-mlevitsk@redhat.com>
References: <20201001112954.6258-1-mlevitsk@redhat.com>
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
 arch/x86/kvm/x86.c              | 7 ++++++-
 5 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d0f77235da923..99657051ee8a0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1086,7 +1086,7 @@ struct kvm_x86_ops {
 	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
 	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
 	int (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
-	void (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
+	int (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
 	void (*get_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*get_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4f401fc6a05d9..57e0f27ff7d20 100644
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
index a7f997459b870..e7af21e6fe1e0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -350,7 +350,7 @@ static inline bool gif_set(struct vcpu_svm *svm)
 #define MSR_INVALID				0xffffffffU
 
 u32 svm_msrpm_offset(u32 msr);
-void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
+int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 void svm_flush_tlb(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4551a7e80ebc3..2115d35094bc5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2815,13 +2815,14 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 	kvm_mmu_reset_context(vcpu);
 }
 
-void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
+int vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmx_uret_msr *msr = vmx_find_uret_msr(vmx, MSR_EFER);
 
+	/* Nothing to do if hardware doesn't support EFER. */
 	if (!msr)
-		return;
+		return 0;
 
 	vcpu->arch.efer = efer;
 	if (efer & EFER_LMA) {
@@ -2833,6 +2834,7 @@ void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 		msr->data = efer & ~EFER_LME;
 	}
 	setup_msrs(vmx);
+	return 0;
 }
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7af04f9e20b48..80e3dcd542382 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1457,6 +1457,7 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	u64 old_efer = vcpu->arch.efer;
 	u64 efer = msr_info->data;
+	int r;
 
 	if (efer & efer_reserved_bits)
 		return 1;
@@ -1473,7 +1474,11 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	efer &= ~EFER_LMA;
 	efer |= vcpu->arch.efer & EFER_LMA;
 
-	kvm_x86_ops.set_efer(vcpu, efer);
+	r = kvm_x86_ops.set_efer(vcpu, efer);
+	if (r) {
+		WARN_ON(r > 0);
+		return r;
+	}
 
 	/* Update reserved bits */
 	if ((efer ^ old_efer) & EFER_NX)
-- 
2.26.2

