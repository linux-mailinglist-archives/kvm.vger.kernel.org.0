Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A720A205A26
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 20:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733201AbgFWSGt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 14:06:49 -0400
Received: from 9.mo6.mail-out.ovh.net ([87.98.171.146]:54655 "EHLO
        9.mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733085AbgFWSGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 14:06:49 -0400
X-Greylist: delayed 3598 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jun 2020 14:06:48 EDT
Received: from player693.ha.ovh.net (unknown [10.110.208.89])
        by mo6.mail-out.ovh.net (Postfix) with ESMTP id 6C60A21AD9C
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 18:50:36 +0200 (CEST)
Received: from kaod.org (lfbn-tou-1-921-245.w86-210.abo.wanadoo.fr [86.210.152.245])
        (Authenticated sender: clg@kaod.org)
        by player693.ha.ovh.net (Postfix) with ESMTPSA id D386013A38801;
        Tue, 23 Jun 2020 16:50:28 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-101G0046a9a02d6-4de9-4819-8928-acddee862ae7,EED1DA90FC9B795DFFB5AB62ED4F19E3D36D96F8) smtp.auth=clg@kaod.org
From:   =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [PATCH] KVM: PPC: Book3S HV: Use feature flag CPU_FTR_P9_TIDR when accessing TIDR
Date:   Tue, 23 Jun 2020 18:50:27 +0200
Message-Id: <20200623165027.271215-1-clg@kaod.org>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 3664804199253838769
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedgjeelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvffufffkofggtgfgsehtkeertdertdejnecuhfhrohhmpeevrogurhhitgcunfgvucfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhephfdvfeeguedthedvleffgeekveeiiedvveegvefhudfhffdtieekueelfeeiheeunecuffhomhgrihhnpehrmhhhrghnughlvghrshdrshgsnecukfhppedtrddtrddtrddtpdekiedrvddutddrudehvddrvdegheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrheileefrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The TIDR register is only available on POWER9 systems and code
accessing this register is not always protected by the CPU_FTR_P9_TIDR
flag. Fix that to make sure POWER10 systems won't use it as TIDR has
been removed.

Signed-off-by: Cédric Le Goater <clg@kaod.org>
---
 arch/powerpc/kvm/book3s_hv.c            | 23 +++++++++++++++++------
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 16 ++++++++++++----
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index d64a2dc1ccca..3e5410f27a2a 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1755,7 +1755,10 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		*val = get_reg_val(id, vcpu->arch.wort);
 		break;
 	case KVM_REG_PPC_TIDR:
-		*val = get_reg_val(id, vcpu->arch.tid);
+		if (cpu_has_feature(CPU_FTR_P9_TIDR))
+			*val = get_reg_val(id, vcpu->arch.tid);
+		else
+			r = -ENXIO;
 		break;
 	case KVM_REG_PPC_PSSCR:
 		*val = get_reg_val(id, vcpu->arch.psscr);
@@ -1972,7 +1975,10 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		vcpu->arch.wort = set_reg_val(id, *val);
 		break;
 	case KVM_REG_PPC_TIDR:
-		vcpu->arch.tid = set_reg_val(id, *val);
+		if (cpu_has_feature(CPU_FTR_P9_TIDR))
+			vcpu->arch.tid = set_reg_val(id, *val);
+		else
+			r = -ENXIO;
 		break;
 	case KVM_REG_PPC_PSSCR:
 		vcpu->arch.psscr = set_reg_val(id, *val) & PSSCR_GUEST_VIS;
@@ -3526,13 +3532,15 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	unsigned long host_dscr = mfspr(SPRN_DSCR);
-	unsigned long host_tidr = mfspr(SPRN_TIDR);
+	unsigned long host_tidr;
 	unsigned long host_iamr = mfspr(SPRN_IAMR);
 	unsigned long host_amr = mfspr(SPRN_AMR);
 	s64 dec;
 	u64 tb;
 	int trap, save_pmu;
 
+	if (cpu_has_feature(CPU_FTR_P9_TIDR))
+		host_tidr = mfspr(SPRN_TIDR);
 	dec = mfspr(SPRN_DEC);
 	tb = mftb();
 	if (dec < 512)
@@ -3579,7 +3587,8 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	mtspr(SPRN_EBBRR, vcpu->arch.ebbrr);
 	mtspr(SPRN_BESCR, vcpu->arch.bescr);
 	mtspr(SPRN_WORT, vcpu->arch.wort);
-	mtspr(SPRN_TIDR, vcpu->arch.tid);
+	if (cpu_has_feature(CPU_FTR_P9_TIDR))
+		mtspr(SPRN_TIDR, vcpu->arch.tid);
 	mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
 	mtspr(SPRN_DSISR, vcpu->arch.shregs.dsisr);
 	mtspr(SPRN_AMR, vcpu->arch.amr);
@@ -3653,7 +3662,8 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vcpu->arch.ebbrr = mfspr(SPRN_EBBRR);
 	vcpu->arch.bescr = mfspr(SPRN_BESCR);
 	vcpu->arch.wort = mfspr(SPRN_WORT);
-	vcpu->arch.tid = mfspr(SPRN_TIDR);
+	if (cpu_has_feature(CPU_FTR_P9_TIDR))
+		vcpu->arch.tid = mfspr(SPRN_TIDR);
 	vcpu->arch.amr = mfspr(SPRN_AMR);
 	vcpu->arch.uamor = mfspr(SPRN_UAMOR);
 	vcpu->arch.dscr = mfspr(SPRN_DSCR);
@@ -3662,7 +3672,8 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	mtspr(SPRN_WORT, 0);
 	mtspr(SPRN_UAMOR, 0);
 	mtspr(SPRN_DSCR, host_dscr);
-	mtspr(SPRN_TIDR, host_tidr);
+	if (cpu_has_feature(CPU_FTR_P9_TIDR))
+		mtspr(SPRN_TIDR, host_tidr);
 	mtspr(SPRN_IAMR, host_iamr);
 	mtspr(SPRN_PSPB, 0);
 
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 71943892c81c..64e454656749 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -697,9 +697,11 @@ kvmppc_got_guest:
 	/* Save host values of some registers */
 BEGIN_FTR_SECTION
 	mfspr	r5, SPRN_TIDR
+	std	r5, STACK_SLOT_TID(r1)
+END_FTR_SECTION_IFSET(CPU_FTR_P9_TIDR)
+BEGIN_FTR_SECTION
 	mfspr	r6, SPRN_PSSCR
 	mfspr	r7, SPRN_PID
-	std	r5, STACK_SLOT_TID(r1)
 	std	r6, STACK_SLOT_PSSCR(r1)
 	std	r7, STACK_SLOT_PID(r1)
 	mfspr	r5, SPRN_HFSCR
@@ -835,13 +837,15 @@ BEGIN_FTR_SECTION
 	nop
 FTR_SECTION_ELSE
 	/* POWER9-only registers */
+BEGIN_FTR_SECTION_NESTED(96);
 	ld	r5, VCPU_TID(r4)
+	mtspr	SPRN_TIDR, r5
+END_FTR_SECTION_NESTED_IFSET(CPU_FTR_P9_TIDR, 96)
 	ld	r6, VCPU_PSSCR(r4)
 	lbz	r8, HSTATE_FAKE_SUSPEND(r13)
 	oris	r6, r6, PSSCR_EC@h	/* This makes stop trap to HV */
 	rldimi	r6, r8, PSSCR_FAKE_SUSPEND_LG, 63 - PSSCR_FAKE_SUSPEND_LG
 	ld	r7, VCPU_HFSCR(r4)
-	mtspr	SPRN_TIDR, r5
 	mtspr	SPRN_PSSCR, r6
 	mtspr	SPRN_HFSCR, r7
 ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_300)
@@ -1637,9 +1641,11 @@ BEGIN_FTR_SECTION
 	std	r7, VCPU_CSIGR(r9)
 	std	r8, VCPU_TACR(r9)
 FTR_SECTION_ELSE
+BEGIN_FTR_SECTION_NESTED(96);
 	mfspr	r5, SPRN_TIDR
-	mfspr	r6, SPRN_PSSCR
 	std	r5, VCPU_TID(r9)
+END_FTR_SECTION_NESTED_IFSET(CPU_FTR_P9_TIDR, 96)
+	mfspr	r6, SPRN_PSSCR
 	rldicl	r6, r6, 4, 50		/* r6 &= PSSCR_GUEST_VIS */
 	rotldi	r6, r6, 60
 	std	r6, VCPU_PSSCR(r9)
@@ -1771,9 +1777,11 @@ BEGIN_FTR_SECTION
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
 BEGIN_FTR_SECTION
 	ld	r5, STACK_SLOT_TID(r1)
+	mtspr	SPRN_TIDR, r5
+END_FTR_SECTION_IFSET(CPU_FTR_P9_TIDR)
+BEGIN_FTR_SECTION
 	ld	r6, STACK_SLOT_PSSCR(r1)
 	ld	r7, STACK_SLOT_PID(r1)
-	mtspr	SPRN_TIDR, r5
 	mtspr	SPRN_PSSCR, r6
 	mtspr	SPRN_PID, r7
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
-- 
2.25.4

