Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1D3EA4C35
	for <lists+kvm@lfdr.de>; Sun,  1 Sep 2019 23:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729152AbfIAVNA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Sep 2019 17:13:00 -0400
Received: from foss.arm.com ([217.140.110.172]:46432 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728891AbfIAVNA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Sep 2019 17:13:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 682191576;
        Sun,  1 Sep 2019 14:12:59 -0700 (PDT)
Received: from why.lan (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3CAF73F718;
        Sun,  1 Sep 2019 14:12:58 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 2/3] arm64: KVM: Replace hyp_alternate_select with has_vhe()
Date:   Sun,  1 Sep 2019 22:12:36 +0100
Message-Id: <20190901211237.11673-3-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190901211237.11673-1-maz@kernel.org>
References: <20190901211237.11673-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
---
 arch/arm64/kvm/hyp/tlb.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index d49a14497715..f61db7f07619 100644
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

