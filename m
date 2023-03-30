Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188556D0145
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 12:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjC3Kcr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 06:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjC3Kcn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 06:32:43 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C430FC
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 03:32:42 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n14so1782484plc.8
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 03:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680172362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mIc+w6RBCuEkRBD/i6pcyb62xLvR8dwUGSTUtaSxH7w=;
        b=cqLl6halZSG9WXCERASQge5izK99zDa4rNioeDNySWQC2ClaqXwcHU0Q1YxNj+tWhX
         ++Lu7Nw8L0eaFKiWvx2VIsvXZ/icD2aNZ61Si3f5Z3fJvnwzI4enxObA/EBrDOdkk9DT
         PMFISn6eXALMunYdIqIPzOutRyjb/oLRURGXVDRz+fHzDfmoougRLpVDpOcbC5OO3gbr
         PlItIS3nadQXfvB9shYiQE3oObvD98AuYKKSReVB1kdUIULRmpAoZFr8MoTwjd7VhSoC
         ElzhPjNlSGH61T1VaTYKOLlUSL46U6rNmTNXTPoY02Go3mKTPxsT+bCxgaKJ/jgKA1SF
         gBQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680172362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mIc+w6RBCuEkRBD/i6pcyb62xLvR8dwUGSTUtaSxH7w=;
        b=RbJBocZ9DKRUwjvzsbH7JHZ+46VZk/FUvw76+ByKgD3vlGXKMYiX1mEcT9nnKF0Fv6
         gi2JuGKB7brLWkEU82gIL2lNnQMk6TErfDoOAeO/P73hftm9AeqKJdJ2HYf/Gj7LMr+X
         R0bkC7JfhFXpVLwZjycEKh6/VHamuDVdKpNJtDt17Bcwc5sGL3ley2LSHOMzRBsm3AED
         2A9UmdHq37B5HaZReL1fYu+2OKss487PNyR71CurkbYp7tyxRRi18VcuUlsgeVZenpVc
         MbcmrNyvY2kKSLtGM4qgsYalG01YpGBZ1g6jrkfM3AtRcOhng1RDrg3C5EEJpFL1yC3l
         mQSw==
X-Gm-Message-State: AAQBX9cJXuvFBUArr1gwJYCENCpJbhY69cMmzz/NeZxzLPHzjkYOAH/9
        f9uPk44gLnhv3HqooruWPiV/ZE0JWiY=
X-Google-Smtp-Source: AKy350Y/iwmxcVOrID+xf/ON8LaylCuMPMgYHR3HLDdeSZtv3Ffq4IGinukuF05XvY9E2oBbRrQV9A==
X-Received: by 2002:a17:90a:1a17:b0:23b:45be:a15a with SMTP id 23-20020a17090a1a1700b0023b45bea15amr23702960pjk.25.1680172361734;
        Thu, 30 Mar 2023 03:32:41 -0700 (PDT)
Received: from bobo.ibm.com ([203.220.177.81])
        by smtp.gmail.com with ESMTPSA id 6-20020a17090a08c600b0023440af7aafsm2895219pjn.9.2023.03.30.03.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 03:32:41 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org,
        "Paul Mackerras" <paulus@ozlabs.org>,
        "Michael Neuling" <mikey@neuling.org>
Subject: [PATCH v2 2/2] KVM: PPC: Book3S HV: Set SRR1[PREFIX] bit on injected interrupts
Date:   Thu, 30 Mar 2023 20:32:24 +1000
Message-Id: <20230330103224.3589928-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230330103224.3589928-1-npiggin@gmail.com>
References: <20230330103224.3589928-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass the hypervisor (H)SRR1[PREFIX] indication through to synchronous
interrupts injected into the guest.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 13 +++++++++----
 arch/powerpc/kvm/book3s_hv.c           | 27 +++++++++++++++++---------
 arch/powerpc/kvm/book3s_hv_nested.c    |  9 ++++++---
 arch/powerpc/kvm/emulate_loadstore.c   |  6 +++---
 arch/powerpc/kvm/powerpc.c             |  3 ++-
 5 files changed, 38 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 215a6b5ba104..461307b89c3a 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -954,7 +954,9 @@ int kvmppc_book3s_radix_page_fault(struct kvm_vcpu *vcpu,
 	if (dsisr & DSISR_BADACCESS) {
 		/* Reflect to the guest as DSI */
 		pr_err("KVM: Got radix HV page fault with DSISR=%lx\n", dsisr);
-		kvmppc_core_queue_data_storage(vcpu, 0, ea, dsisr);
+		kvmppc_core_queue_data_storage(vcpu,
+				kvmppc_get_msr(vcpu) & SRR1_PREFIXED,
+				ea, dsisr);
 		return RESUME_GUEST;
 	}
 
@@ -979,7 +981,9 @@ int kvmppc_book3s_radix_page_fault(struct kvm_vcpu *vcpu,
 			 * Bad address in guest page table tree, or other
 			 * unusual error - reflect it to the guest as DSI.
 			 */
-			kvmppc_core_queue_data_storage(vcpu, 0, ea, dsisr);
+			kvmppc_core_queue_data_storage(vcpu,
+					kvmppc_get_msr(vcpu) & SRR1_PREFIXED,
+					ea, dsisr);
 			return RESUME_GUEST;
 		}
 		return kvmppc_hv_emulate_mmio(vcpu, gpa, ea, writing);
@@ -988,8 +992,9 @@ int kvmppc_book3s_radix_page_fault(struct kvm_vcpu *vcpu,
 	if (memslot->flags & KVM_MEM_READONLY) {
 		if (writing) {
 			/* give the guest a DSI */
-			kvmppc_core_queue_data_storage(vcpu, 0, ea,
-					DSISR_ISSTORE | DSISR_PROTFAULT);
+			kvmppc_core_queue_data_storage(vcpu,
+					kvmppc_get_msr(vcpu) & SRR1_PREFIXED,
+					ea, DSISR_ISSTORE | DSISR_PROTFAULT);
 			return RESUME_GUEST;
 		}
 		kvm_ro = true;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 16ea0ffb7976..c973bf556fb3 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1428,7 +1428,8 @@ static int kvmppc_emulate_debug_inst(struct kvm_vcpu *vcpu)
 		vcpu->run->debug.arch.address = kvmppc_get_pc(vcpu);
 		return RESUME_HOST;
 	} else {
-		kvmppc_core_queue_program(vcpu, SRR1_PROGILL);
+		kvmppc_core_queue_program(vcpu, SRR1_PROGILL |
+				(kvmppc_get_msr(vcpu) & SRR1_PREFIXED));
 		return RESUME_GUEST;
 	}
 }
@@ -1632,7 +1633,8 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 		 * so that it knows that the machine check occurred.
 		 */
 		if (!vcpu->kvm->arch.fwnmi_enabled) {
-			ulong flags = vcpu->arch.shregs.msr & 0x083c0000;
+			ulong flags = (vcpu->arch.shregs.msr & 0x083c0000) |
+					(kvmppc_get_msr(vcpu) & SRR1_PREFIXED);
 			kvmppc_core_queue_machine_check(vcpu, flags);
 			r = RESUME_GUEST;
 			break;
@@ -1661,7 +1663,8 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 		 * as a result of a hypervisor emulation interrupt
 		 * (e40) getting turned into a 700 by BML RTAS.
 		 */
-		flags = vcpu->arch.shregs.msr & 0x1f0000ull;
+		flags = (vcpu->arch.shregs.msr & 0x1f0000ull) |
+			(kvmppc_get_msr(vcpu) & SRR1_PREFIXED);
 		kvmppc_core_queue_program(vcpu, flags);
 		r = RESUME_GUEST;
 		break;
@@ -1741,7 +1744,8 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 		}
 
 		if (!(vcpu->arch.fault_dsisr & (DSISR_NOHPTE | DSISR_PROTFAULT))) {
-			kvmppc_core_queue_data_storage(vcpu, 0,
+			kvmppc_core_queue_data_storage(vcpu,
+				kvmppc_get_msr(vcpu) & SRR1_PREFIXED,
 				vcpu->arch.fault_dar, vcpu->arch.fault_dsisr);
 			r = RESUME_GUEST;
 			break;
@@ -1759,7 +1763,8 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 		} else if (err == -1 || err == -2) {
 			r = RESUME_PAGE_FAULT;
 		} else {
-			kvmppc_core_queue_data_storage(vcpu, 0,
+			kvmppc_core_queue_data_storage(vcpu,
+				kvmppc_get_msr(vcpu) & SRR1_PREFIXED,
 				vcpu->arch.fault_dar, err);
 			r = RESUME_GUEST;
 		}
@@ -1787,7 +1792,8 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 
 		if (!(vcpu->arch.fault_dsisr & SRR1_ISI_NOPT)) {
 			kvmppc_core_queue_inst_storage(vcpu,
-				vcpu->arch.fault_dsisr);
+				vcpu->arch.fault_dsisr |
+				(kvmppc_get_msr(vcpu) & SRR1_PREFIXED));
 			r = RESUME_GUEST;
 			break;
 		}
@@ -1804,7 +1810,8 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 		} else if (err == -1) {
 			r = RESUME_PAGE_FAULT;
 		} else {
-			kvmppc_core_queue_inst_storage(vcpu, err);
+			kvmppc_core_queue_inst_storage(vcpu,
+				err | (kvmppc_get_msr(vcpu) & SRR1_PREFIXED));
 			r = RESUME_GUEST;
 		}
 		break;
@@ -1825,7 +1832,8 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 		if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP) {
 			r = kvmppc_emulate_debug_inst(vcpu);
 		} else {
-			kvmppc_core_queue_program(vcpu, SRR1_PROGILL);
+			kvmppc_core_queue_program(vcpu, SRR1_PROGILL |
+				(kvmppc_get_msr(vcpu) & SRR1_PREFIXED));
 			r = RESUME_GUEST;
 		}
 		break;
@@ -1866,7 +1874,8 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 				r = kvmppc_tm_unavailable(vcpu);
 		}
 		if (r == EMULATE_FAIL) {
-			kvmppc_core_queue_program(vcpu, SRR1_PROGILL);
+			kvmppc_core_queue_program(vcpu, SRR1_PROGILL |
+				(kvmppc_get_msr(vcpu) & SRR1_PREFIXED));
 			r = RESUME_GUEST;
 		}
 		break;
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 2c9db6119d89..377d0b4a05ee 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -1560,7 +1560,9 @@ static long int __kvmhv_nested_page_fault(struct kvm_vcpu *vcpu,
 	if (!memslot || (memslot->flags & KVM_MEMSLOT_INVALID)) {
 		if (dsisr & (DSISR_PRTABLE_FAULT | DSISR_BADACCESS)) {
 			/* unusual error -> reflect to the guest as a DSI */
-			kvmppc_core_queue_data_storage(vcpu, 0, ea, dsisr);
+			kvmppc_core_queue_data_storage(vcpu,
+					kvmppc_get_msr(vcpu) & SRR1_PREFIXED,
+					ea, dsisr);
 			return RESUME_GUEST;
 		}
 
@@ -1570,8 +1572,9 @@ static long int __kvmhv_nested_page_fault(struct kvm_vcpu *vcpu,
 	if (memslot->flags & KVM_MEM_READONLY) {
 		if (writing) {
 			/* Give the guest a DSI */
-			kvmppc_core_queue_data_storage(vcpu, 0, ea,
-					DSISR_ISSTORE | DSISR_PROTFAULT);
+			kvmppc_core_queue_data_storage(vcpu,
+					kvmppc_get_msr(vcpu) & SRR1_PREFIXED,
+					ea, DSISR_ISSTORE | DSISR_PROTFAULT);
 			return RESUME_GUEST;
 		}
 		kvm_ro = true;
diff --git a/arch/powerpc/kvm/emulate_loadstore.c b/arch/powerpc/kvm/emulate_loadstore.c
index 5666d69e202a..059c08ae0340 100644
--- a/arch/powerpc/kvm/emulate_loadstore.c
+++ b/arch/powerpc/kvm/emulate_loadstore.c
@@ -28,7 +28,7 @@
 static bool kvmppc_check_fp_disabled(struct kvm_vcpu *vcpu)
 {
 	if (!(kvmppc_get_msr(vcpu) & MSR_FP)) {
-		kvmppc_core_queue_fpunavail(vcpu, 0);
+		kvmppc_core_queue_fpunavail(vcpu, kvmppc_get_msr(vcpu) & SRR1_PREFIXED);
 		return true;
 	}
 
@@ -40,7 +40,7 @@ static bool kvmppc_check_fp_disabled(struct kvm_vcpu *vcpu)
 static bool kvmppc_check_vsx_disabled(struct kvm_vcpu *vcpu)
 {
 	if (!(kvmppc_get_msr(vcpu) & MSR_VSX)) {
-		kvmppc_core_queue_vsx_unavail(vcpu, 0);
+		kvmppc_core_queue_vsx_unavail(vcpu, kvmppc_get_msr(vcpu) & SRR1_PREFIXED);
 		return true;
 	}
 
@@ -52,7 +52,7 @@ static bool kvmppc_check_vsx_disabled(struct kvm_vcpu *vcpu)
 static bool kvmppc_check_altivec_disabled(struct kvm_vcpu *vcpu)
 {
 	if (!(kvmppc_get_msr(vcpu) & MSR_VEC)) {
-		kvmppc_core_queue_vec_unavail(vcpu, 0);
+		kvmppc_core_queue_vec_unavail(vcpu, kvmppc_get_msr(vcpu) & SRR1_PREFIXED);
 		return true;
 	}
 
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 9478bbd873c6..339267c33636 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -321,7 +321,8 @@ int kvmppc_emulate_mmio(struct kvm_vcpu *vcpu)
 			if (vcpu->mmio_is_write)
 				dsisr |= DSISR_ISSTORE;
 
-			kvmppc_core_queue_data_storage(vcpu, 0,
+			kvmppc_core_queue_data_storage(vcpu,
+					kvmppc_get_msr(vcpu) & SRR1_PREFIXED,
 					vcpu->arch.vaddr_accessed, dsisr);
 		} else {
 			/*
-- 
2.37.2

