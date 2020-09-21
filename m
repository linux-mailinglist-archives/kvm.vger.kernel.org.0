Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253A9272547
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 15:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgIUNTu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 09:19:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45447 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727171AbgIUNTt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 09:19:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600694388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4a2Kzu2wf209dCzypghFHtLbVPNhvRdqLJHC/dif83A=;
        b=FnDT/6QIT2eGRHrqan1STmgahwtxq3mYfLRvdidm6PMOF/68Jkb7xaVx08fNvNIoeY2Vqb
        Ytx3+7hGmO8m47odfmdf4+jtmzC+58hvDAIRBqME30vtSeFmE9UXJj4HgSswBTpn8SRx/0
        Wx1mNMlrdKNws3NSNv1xPM0S0WSOwyM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458--JL_w8m7OwG9w5wz7Ix8IA-1; Mon, 21 Sep 2020 09:19:46 -0400
X-MC-Unique: -JL_w8m7OwG9w5wz7Ix8IA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F295D18C89C5;
        Mon, 21 Sep 2020 13:19:44 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 512D555765;
        Mon, 21 Sep 2020 13:19:40 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v5 3/4] KVM: x86: allow kvm_x86_ops.set_efer to return a value
Date:   Mon, 21 Sep 2020 16:19:22 +0300
Message-Id: <20200921131923.120833-4-mlevitsk@redhat.com>
In-Reply-To: <20200921131923.120833-1-mlevitsk@redhat.com>
References: <20200921131923.120833-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
 arch/x86/kvm/x86.c              | 8 +++++++-
 5 files changed, 17 insertions(+), 7 deletions(-)

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
index 6f9a0c6d5dc59..8aef1926e26be 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2835,13 +2835,15 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
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
@@ -2853,6 +2855,7 @@ void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 		msr->data = efer & ~EFER_LME;
 	}
 	setup_msrs(vmx);
+	return 0;
 }
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b6c67ab7c4f34..cab189a71cbb7 100644
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
+	if (r && !msr_info->host_initiated) {
+		WARN_ON(r > 0);
+		return r;
+	}
 
 	/* Update reserved bits */
 	if ((efer ^ old_efer) & EFER_NX)
-- 
2.26.2

