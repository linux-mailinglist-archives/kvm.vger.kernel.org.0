Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89A47C2FFC
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 11:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733170AbfJAJVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 05:21:11 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:46788 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731358AbfJAJVL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Oct 2019 05:21:11 -0400
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iFEL6-00019A-Fq; Tue, 01 Oct 2019 11:21:00 +0200
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 2/4] arm64: KVM: Replace hyp_alternate_select with has_vhe()
Date:   Tue,  1 Oct 2019 10:20:36 +0100
Message-Id: <20191001092038.17097-3-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001092038.17097-1-maz@kernel.org>
References: <20191001092038.17097-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com, christoffer.dall@arm.com, yamada.masahiro@socionext.com, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Given that the TLB invalidation path is pretty rarely used, there
was never any advantage to using hyp_alternate_select() here.
has_vhe(), being a glorified static key, is the right tool for
the job.

Off you go.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/hyp/tlb.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index c466060b76d6..eb0efc5557f3 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -67,10 +67,14 @@ static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm *kvm,
 	isb();
 }
 
-static hyp_alternate_select(__tlb_switch_to_guest,
-			    __tlb_switch_to_guest_nvhe,
-			    __tlb_switch_to_guest_vhe,
-			    ARM64_HAS_VIRT_HOST_EXTN);
+static void __hyp_text __tlb_switch_to_guest(struct kvm *kvm,
+					     struct tlb_inv_context *cxt)
+{
+	if (has_vhe())
+		__tlb_switch_to_guest_vhe(kvm, cxt);
+	else
+		__tlb_switch_to_guest_nvhe(kvm, cxt);
+}
 
 static void __hyp_text __tlb_switch_to_host_vhe(struct kvm *kvm,
 						struct tlb_inv_context *cxt)
@@ -98,10 +102,14 @@ static void __hyp_text __tlb_switch_to_host_nvhe(struct kvm *kvm,
 	write_sysreg(0, vttbr_el2);
 }
 
-static hyp_alternate_select(__tlb_switch_to_host,
-			    __tlb_switch_to_host_nvhe,
-			    __tlb_switch_to_host_vhe,
-			    ARM64_HAS_VIRT_HOST_EXTN);
+static void __hyp_text __tlb_switch_to_host(struct kvm *kvm,
+					    struct tlb_inv_context *cxt)
+{
+	if (has_vhe())
+		__tlb_switch_to_host_vhe(kvm, cxt);
+	else
+		__tlb_switch_to_host_nvhe(kvm, cxt);
+}
 
 void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 {
@@ -111,7 +119,7 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 
 	/* Switch to requested VMID */
 	kvm = kern_hyp_va(kvm);
-	__tlb_switch_to_guest()(kvm, &cxt);
+	__tlb_switch_to_guest(kvm, &cxt);
 
 	/*
 	 * We could do so much better if we had the VA as well.
@@ -154,7 +162,7 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 	if (!has_vhe() && icache_is_vpipt())
 		__flush_icache_all();
 
-	__tlb_switch_to_host()(kvm, &cxt);
+	__tlb_switch_to_host(kvm, &cxt);
 }
 
 void __hyp_text __kvm_tlb_flush_vmid(struct kvm *kvm)
@@ -165,13 +173,13 @@ void __hyp_text __kvm_tlb_flush_vmid(struct kvm *kvm)
 
 	/* Switch to requested VMID */
 	kvm = kern_hyp_va(kvm);
-	__tlb_switch_to_guest()(kvm, &cxt);
+	__tlb_switch_to_guest(kvm, &cxt);
 
 	__tlbi(vmalls12e1is);
 	dsb(ish);
 	isb();
 
-	__tlb_switch_to_host()(kvm, &cxt);
+	__tlb_switch_to_host(kvm, &cxt);
 }
 
 void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
@@ -180,13 +188,13 @@ void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
 	struct tlb_inv_context cxt;
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest()(kvm, &cxt);
+	__tlb_switch_to_guest(kvm, &cxt);
 
 	__tlbi(vmalle1);
 	dsb(nsh);
 	isb();
 
-	__tlb_switch_to_host()(kvm, &cxt);
+	__tlb_switch_to_host(kvm, &cxt);
 }
 
 void __hyp_text __kvm_flush_vm_context(void)
-- 
2.20.1

