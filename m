Return-Path: <kvm+bounces-55905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F277B3878A
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 18:12:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D90B89827B9
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 16:12:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8EF835CEB5;
	Wed, 27 Aug 2025 16:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NCqSp+Gq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE9935AABD;
	Wed, 27 Aug 2025 16:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756311051; cv=none; b=FIaH1aGM+b4nb77jc53g7fF1mxHi5PrXxYPINTHVKTyFc+x6E2vgMDcuGTDcM+oRsrPsdBxh/clwfkF7wRUuQaFNFh0B4SjKaa3aJ9qojdbF/cmgI3lAUIEr1Y68xy3KaPSDPjQECKPzEP+XX5172duVAXFwduzrwmm3/P0TMhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756311051; c=relaxed/simple;
	bh=6B5+c9uUTaPo5ss1f0hbG+yJAYTqzC9v9VAjf7G/RI4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JEmfqQZcCht2wNm9O4NYizKJ4DuLu7CRshlZUbZst6nAYTOgGEVC0BJHnvuK+2SOMHmPNSix2x0vQgVpZQayW8N6biTkwyE+UFtGEwA1QQbFcoXDKtbQyC1bayjK+d1BeOvg9wlKP93tXNrGN6bdi0v+X+Sng0WAAQ3qbepP7pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NCqSp+Gq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67341C4CEF0;
	Wed, 27 Aug 2025 16:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756311051;
	bh=6B5+c9uUTaPo5ss1f0hbG+yJAYTqzC9v9VAjf7G/RI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NCqSp+GqTJaKBpAXOLPp1bp3aMnxsgIOjbmPBZy+aojxDqBDuiPIRxpV8FJx3h0Lt
	 hb+i6Owfa4cWKCWhN8FoeNXuCePrj5SmympTKeSI/UN6LAfOCdITp+MWlPy2vDxoIO
	 2YUTZ8EbR5VpkmlZvibsI6w6yjaRgJWlIORqkdpmqalnDEwp9A3+D8PJOQ8W4Qp7CT
	 drqWLoPdAplHZCAICJ1wIcVqv778Fx4bH2FhekL1kaondH5kFZmd3X6/NIvg1Y+XXK
	 98yAX0oKNyjNXGNIo1rV2pGSn3HJyX+npUL6LOIl02SlybgbhcLzR193Gn6koPYCcI
	 Cw1013wF/rU5A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1urIjZ-00000000yGc-2paM;
	Wed, 27 Aug 2025 16:10:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 16/16] KVM: arm64: selftest: Expand external_aborts test to look for TTW levels
Date: Wed, 27 Aug 2025 17:10:38 +0100
Message-Id: <20250827161039.938958-17-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250827161039.938958-1-maz@kernel.org>
References: <20250827161039.938958-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add a basic test corrupting a level-2 table entry to check that
the resulting abort is a SEA on a PTW at level-3.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 .../selftests/kvm/arm64/external_aborts.c     | 43 +++++++++++++++++++
 .../selftests/kvm/include/arm64/processor.h   |  1 +
 .../selftests/kvm/lib/arm64/processor.c       | 13 +++++-
 3 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/external_aborts.c b/tools/testing/selftests/kvm/arm64/external_aborts.c
index 062bf84cced13..acb32d0f27bbe 100644
--- a/tools/testing/selftests/kvm/arm64/external_aborts.c
+++ b/tools/testing/selftests/kvm/arm64/external_aborts.c
@@ -250,6 +250,48 @@ static void test_serror(void)
 	kvm_vm_free(vm);
 }
 
+static void expect_sea_s1ptw_handler(struct ex_regs *regs)
+{
+	u64 esr = read_sysreg(esr_el1);
+
+
+	GUEST_ASSERT_EQ(regs->pc, expected_abort_pc);
+	GUEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_DABT_CUR);
+	GUEST_ASSERT_EQ((esr & ESR_ELx_FSC), ESR_ELx_FSC_SEA_TTW(3));
+
+	GUEST_DONE();
+}
+
+static noinline void test_s1ptw_abort_guest(void)
+{
+	extern char test_s1ptw_abort_insn;
+
+	WRITE_ONCE(expected_abort_pc, (u64)&test_s1ptw_abort_insn);
+
+	asm volatile("test_s1ptw_abort_insn:\n\t"
+		     "ldr x0, [%0]\n\t"
+		     : : "r" (MMIO_ADDR) : "x0", "memory");
+
+	GUEST_FAIL("Load on S1PTW abort should not retire");
+}
+
+static void test_s1ptw_abort(void)
+{
+	struct kvm_vcpu *vcpu;
+	u64 *ptep, bad_pa;
+	struct kvm_vm *vm = vm_create_with_dabt_handler(&vcpu, test_s1ptw_abort_guest,
+							expect_sea_s1ptw_handler);
+
+	ptep = virt_get_pte_hva_at_level(vm, MMIO_ADDR, 2);
+	bad_pa = BIT(vm->pa_bits) - vm->page_size;
+
+	*ptep &= ~GENMASK(47, 12);
+	*ptep |= bad_pa;
+
+	vcpu_run_expect_done(vcpu);
+	kvm_vm_free(vm);
+}
+
 static void test_serror_emulated_guest(void)
 {
 	GUEST_ASSERT(!(read_sysreg(isr_el1) & ISR_EL1_A));
@@ -327,4 +369,5 @@ int main(void)
 	test_serror_masked();
 	test_serror_emulated();
 	test_mmio_ease();
+	test_s1ptw_abort();
 }
diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index 255fed769a8a5..e3e916b1d9c4e 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -175,6 +175,7 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
 
+uint64_t *virt_get_pte_hva_at_level(struct kvm_vm *vm, vm_vaddr_t gva, int level);
 uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva);
 
 static inline void cpu_relax(void)
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 9d69904cb6084..5c459862f6325 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -185,7 +185,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	_virt_pg_map(vm, vaddr, paddr, attr_idx);
 }
 
-uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva)
+uint64_t *virt_get_pte_hva_at_level(struct kvm_vm *vm, vm_vaddr_t gva, int level)
 {
 	uint64_t *ptep;
 
@@ -195,17 +195,23 @@ uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva)
 	ptep = addr_gpa2hva(vm, vm->pgd) + pgd_index(vm, gva) * 8;
 	if (!ptep)
 		goto unmapped_gva;
+	if (level == 0)
+		return ptep;
 
 	switch (vm->pgtable_levels) {
 	case 4:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pud_index(vm, gva) * 8;
 		if (!ptep)
 			goto unmapped_gva;
+		if (level == 1)
+			break;
 		/* fall through */
 	case 3:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pmd_index(vm, gva) * 8;
 		if (!ptep)
 			goto unmapped_gva;
+		if (level == 2)
+			break;
 		/* fall through */
 	case 2:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pte_index(vm, gva) * 8;
@@ -223,6 +229,11 @@ uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva)
 	exit(EXIT_FAILURE);
 }
 
+uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva)
+{
+	return virt_get_pte_hva_at_level(vm, gva, 3);
+}
+
 vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	uint64_t *ptep = virt_get_pte_hva(vm, gva);
-- 
2.39.2


