Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1617331DBCD
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 16:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbhBQO7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 09:59:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33798 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233671AbhBQO7D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 09:59:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613573857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ozt+M2IQLovu++En5b4wIhldhTSUP+BsafHMlS5LCBs=;
        b=EnPRsulpyHQyuGea4KlWEF1cJ3AUGx5QUg9FYjq6AbMbd1y42IPw2SQgmgD8lAFmPgUQeT
        Qgw6S+R3zIjsU8Gz3WVOwuU+mEOzp2xYKSh2kYrQeSrAff9crAjTNvWmIt1n1oaRK1ukTc
        ig6pQ0XY0kJhu7PAHGHYgnkupMygtpE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-EtTZlzq0NrCm1xywI23tKA-1; Wed, 17 Feb 2021 09:57:35 -0500
X-MC-Unique: EtTZlzq0NrCm1xywI23tKA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0E8A84E246;
        Wed, 17 Feb 2021 14:57:33 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F99810023AF;
        Wed, 17 Feb 2021 14:57:30 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 3/7] KVM: x86: add .complete_mmu_init arch callback
Date:   Wed, 17 Feb 2021 16:57:14 +0200
Message-Id: <20210217145718.1217358-4-mlevitsk@redhat.com>
In-Reply-To: <20210217145718.1217358-1-mlevitsk@redhat.com>
References: <20210217145718.1217358-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This callback will be used to tweak the mmu context
in arch specific code after it was reset.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 1 +
 arch/x86/include/asm/kvm_host.h    | 2 ++
 arch/x86/kvm/mmu/mmu.c             | 2 ++
 arch/x86/kvm/svm/svm.c             | 6 ++++++
 arch/x86/kvm/vmx/vmx.c             | 6 ++++++
 5 files changed, 17 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 355a2ab8fc09..041e5765dc67 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -86,6 +86,7 @@ KVM_X86_OP(set_tss_addr)
 KVM_X86_OP(set_identity_map_addr)
 KVM_X86_OP(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
+KVM_X86_OP(complete_mmu_init)
 KVM_X86_OP_NULL(has_wbinvd_exit)
 KVM_X86_OP(write_l1_tsc_offset)
 KVM_X86_OP(get_exit_info)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a8e1b57b1532..01a08f936781 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1251,6 +1251,8 @@ struct kvm_x86_ops {
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, unsigned long pgd,
 			     int pgd_level);
 
+	void (*complete_mmu_init) (struct kvm_vcpu *vcpu);
+
 	bool (*has_wbinvd_exit)(void);
 
 	/* Returns actual tsc_offset set in active VMCS */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e507568cd55d..00bf9ff2e469 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4774,6 +4774,8 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots)
 		init_kvm_tdp_mmu(vcpu);
 	else
 		init_kvm_softmmu(vcpu);
+
+	static_call(kvm_x86_complete_mmu_init)(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_init_mmu);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 754e07538b4a..74a334c9902a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3913,6 +3913,11 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root,
 	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
 }
 
+static void svm_complete_mmu_init(struct kvm_vcpu *vcpu)
+{
+
+}
+
 static int is_disabled(void)
 {
 	u64 vm_cr;
@@ -4522,6 +4527,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.write_l1_tsc_offset = svm_write_l1_tsc_offset,
 
 	.load_mmu_pgd = svm_load_mmu_pgd,
+	.complete_mmu_init = svm_complete_mmu_init,
 
 	.check_intercept = svm_check_intercept,
 	.handle_exit_irqoff = svm_handle_exit_irqoff,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e428d69e21c0..bf6ef674d688 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3252,6 +3252,11 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
 		vmcs_writel(GUEST_CR3, guest_cr3);
 }
 
+static void vmx_complete_mmu_init(struct kvm_vcpu *vcpu)
+{
+
+}
+
 static bool vmx_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	/*
@@ -7849,6 +7854,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.write_l1_tsc_offset = vmx_write_l1_tsc_offset,
 
 	.load_mmu_pgd = vmx_load_mmu_pgd,
+	.complete_mmu_init = vmx_complete_mmu_init,
 
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
-- 
2.26.2

