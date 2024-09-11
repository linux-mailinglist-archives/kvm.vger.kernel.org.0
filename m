Return-Path: <kvm+bounces-26576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D56A5975BE6
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 22:43:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05A001C22353
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 20:43:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7978F1BBBC3;
	Wed, 11 Sep 2024 20:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="np2kG8BW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901071BAEDE
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 20:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087347; cv=none; b=HXvikkOHcUxoWyCbGznU0ReJtMd5nXEM5rjzs9bBbkYG99SFK3TNfXLaIFih2lzmhU4juVc6NwSoRzfjiu83kiD9AwitHRZeovlZqipCIZANS2ruF1Ug1f8A+lvp76BUGutiMFMW4E6FKASgXxx1yNEuK8yRC2R5M/DptPDBWbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087347; c=relaxed/simple;
	bh=jeK73H/PP1sblEMd9j4W89ZKD7BTHQMCM5vJNs75NAI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aDyvRTKDJZ5KW0ZjCcmvAMDpceD1KerTOZVlCKxS45Ek+aZFnABFCsTfAJBSRQWtqlQXMttwJ9U2mOFQhh1Iiaws7VE3pIwCeAL1d6H78L9iW2S2gY79zHWIQWS6yLf7WMCURJqDMapeoxvjRPL5pW1syFhWkJOAOGh5Z5eW6IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=np2kG8BW; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2052e7836a0so6175455ad.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 13:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726087345; x=1726692145; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UOw6EgLPoyfJUTgBA+ajxytwz1pRgL90CsAH3T1VEsI=;
        b=np2kG8BWd7NnESJ4TN/sD49HRm0nZIK/WHsNeSQ6gJ8lOBtq+4O0Pl5FjoxS1WI8Dg
         07hYLzTcO/XbqgSAEyi16SjB5qJHrFg2c/PcnyxqRjT+sMPtsCrlxp55EoNvEexpOfEt
         h1Rfz1lj48XuPXyBdSdpBsu7UZ9PoN1GCUKHRvAdupSG3S/4UPB1g/KhmPHTGjKq1nvy
         r+dngxyuBghYV+qMYy7kFLOD4OZlerBbgZiVU2Eb9bQgKwocuEFzcTORwfDEtq7LmtHW
         NaKqASoQm78VgCwDly0PeB78mFpCtkkqIG48vWs6WM6d0yFHaVdWADzaCBG/OyA0riSW
         UeJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726087345; x=1726692145;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UOw6EgLPoyfJUTgBA+ajxytwz1pRgL90CsAH3T1VEsI=;
        b=VxaSeKC0LPslNSJ61vnJCo3sBq8HH6TZltmw1aSVm+Tt7t+a/PSzz+GWtbzh0Dl519
         c10zYOaNVsBqe0t++vuEdri++T2CnccE6SbYJ10xvPVpoeqRMww3iQyTDjKZ21lBxHSU
         J2PNgv98Su6bWkOF3tfXmzOzpGp/PmkAd9OZuEkC0OJYsf2UeGcwD5KTlrpvWCH8+3+d
         ViGAe8O9DXINxMZi1ksjOsF2mQHCQ5gi9RNhSdOWTWVt9SmacdnoRNAegGMP7PmHa912
         WGZ3RYonOn8b4+jrPH9VrcULFSJla6PyNr8jJTiCB7X/eB58wwU3vr2CqDd56/uYWfzu
         2wgg==
X-Forwarded-Encrypted: i=1; AJvYcCXw2Ex7Go+t0GlHoxi2lSwL2FVakI33D5xlhXz0RVvguhfxUTtq/b2jkppKt+PAk8JqTxI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIhXvg+QrTOPG1Jq5b3oHGcOupSo/GAKoCgOnJttUfNnbU/qKw
	/5Mz4z92ceUt7POaEaBkkvtnVazsFMi+9Px+dImXrJNdNvijZ2/QE4AFQBA+TiOJ4HDdI3o/wvC
	umA==
X-Google-Smtp-Source: AGHT+IEZGtAU0bUNEk/tylsuAd4LYyub94XGm0zHyVQv83+sLJBZ6OnLGgwMZXW1CAOziwxFBjhrpLIi6Vs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d502:b0:201:f9c7:632d with SMTP id
 d9443c01a7336-2076d909eacmr447285ad.0.1726087344679; Wed, 11 Sep 2024
 13:42:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Sep 2024 13:41:47 -0700
In-Reply-To: <20240911204158.2034295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911204158.2034295-3-seanjc@google.com>
Subject: [PATCH v2 02/13] KVM: selftests: Return a value from vcpu_get_reg()
 instead of using an out-param
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Return a uint64_t from vcpu_get_reg() instead of having the caller provide
a pointer to storage, as none of the KVM_GET_ONE_REG usage in KVM selftests
accesses a register larger than 64 bits, and vcpu_set_reg() only accepts a
64-bit value.  If a use case comes along that needs to get a register that
is larger than 64 bits, then a utility can be added to assert success and
take a void pointer, but until then, forcing an out param yields ugly code
and prevents feeding the output of vcpu_get_reg() into vcpu_set_reg().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/aarch32_id_regs.c   | 10 +--
 .../selftests/kvm/aarch64/debug-exceptions.c  |  4 +-
 .../selftests/kvm/aarch64/hypercalls.c        |  6 +-
 .../testing/selftests/kvm/aarch64/psci_test.c |  6 +-
 .../selftests/kvm/aarch64/set_id_regs.c       | 18 ++---
 .../kvm/aarch64/vpmu_counter_access.c         | 19 +++---
 .../testing/selftests/kvm/include/kvm_util.h  |  6 +-
 .../selftests/kvm/lib/aarch64/processor.c     |  8 +--
 .../selftests/kvm/lib/riscv/processor.c       | 66 +++++++++----------
 .../testing/selftests/kvm/riscv/arch_timer.c  |  2 +-
 .../testing/selftests/kvm/riscv/ebreak_test.c |  2 +-
 .../selftests/kvm/riscv/sbi_pmu_test.c        |  2 +-
 tools/testing/selftests/kvm/s390x/resets.c    |  2 +-
 tools/testing/selftests/kvm/steal_time.c      |  3 +-
 14 files changed, 77 insertions(+), 77 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c b/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
index 8e5bd07a3727..447d61cae4db 100644
--- a/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
@@ -97,7 +97,7 @@ static void test_user_raz_wi(struct kvm_vcpu *vcpu)
 		uint64_t reg_id = raz_wi_reg_ids[i];
 		uint64_t val;
 
-		vcpu_get_reg(vcpu, reg_id, &val);
+		val = vcpu_get_reg(vcpu, reg_id);
 		TEST_ASSERT_EQ(val, 0);
 
 		/*
@@ -106,7 +106,7 @@ static void test_user_raz_wi(struct kvm_vcpu *vcpu)
 		 */
 		vcpu_set_reg(vcpu, reg_id, BAD_ID_REG_VAL);
 
-		vcpu_get_reg(vcpu, reg_id, &val);
+		val = vcpu_get_reg(vcpu, reg_id);
 		TEST_ASSERT_EQ(val, 0);
 	}
 }
@@ -126,14 +126,14 @@ static void test_user_raz_invariant(struct kvm_vcpu *vcpu)
 		uint64_t reg_id = raz_invariant_reg_ids[i];
 		uint64_t val;
 
-		vcpu_get_reg(vcpu, reg_id, &val);
+		val = vcpu_get_reg(vcpu, reg_id);
 		TEST_ASSERT_EQ(val, 0);
 
 		r = __vcpu_set_reg(vcpu, reg_id, BAD_ID_REG_VAL);
 		TEST_ASSERT(r < 0 && errno == EINVAL,
 			    "unexpected KVM_SET_ONE_REG error: r=%d, errno=%d", r, errno);
 
-		vcpu_get_reg(vcpu, reg_id, &val);
+		val = vcpu_get_reg(vcpu, reg_id);
 		TEST_ASSERT_EQ(val, 0);
 	}
 }
@@ -144,7 +144,7 @@ static bool vcpu_aarch64_only(struct kvm_vcpu *vcpu)
 {
 	uint64_t val, el0;
 
-	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), &val);
+	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1));
 
 	el0 = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0), val);
 	return el0 == ID_AA64PFR0_EL1_ELx_64BIT_ONLY;
diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 2582c49e525a..b3f3025d2f02 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -501,7 +501,7 @@ void test_single_step_from_userspace(int test_cnt)
 		TEST_ASSERT(ss_enable, "Unexpected KVM_EXIT_DEBUG");
 
 		/* Check if the current pc is expected. */
-		vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pc), &pc);
+		pc = vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pc));
 		TEST_ASSERT(!test_pc || pc == test_pc,
 			    "Unexpected pc 0x%lx (expected 0x%lx)",
 			    pc, test_pc);
@@ -583,7 +583,7 @@ int main(int argc, char *argv[])
 	uint64_t aa64dfr0;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &aa64dfr0);
+	aa64dfr0 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1));
 	__TEST_REQUIRE(debug_version(aa64dfr0) >= 6,
 		       "Armv8 debug architecture not supported.");
 	kvm_vm_free(vm);
diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
index 9d192ce0078d..ec54ec7726e9 100644
--- a/tools/testing/selftests/kvm/aarch64/hypercalls.c
+++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
@@ -173,7 +173,7 @@ static void test_fw_regs_before_vm_start(struct kvm_vcpu *vcpu)
 		const struct kvm_fw_reg_info *reg_info = &fw_reg_info[i];
 
 		/* First 'read' should be an upper limit of the features supported */
-		vcpu_get_reg(vcpu, reg_info->reg, &val);
+		val = vcpu_get_reg(vcpu, reg_info->reg);
 		TEST_ASSERT(val == FW_REG_ULIMIT_VAL(reg_info->max_feat_bit),
 			"Expected all the features to be set for reg: 0x%lx; expected: 0x%lx; read: 0x%lx",
 			reg_info->reg, FW_REG_ULIMIT_VAL(reg_info->max_feat_bit), val);
@@ -184,7 +184,7 @@ static void test_fw_regs_before_vm_start(struct kvm_vcpu *vcpu)
 			"Failed to clear all the features of reg: 0x%lx; ret: %d",
 			reg_info->reg, errno);
 
-		vcpu_get_reg(vcpu, reg_info->reg, &val);
+		val = vcpu_get_reg(vcpu, reg_info->reg);
 		TEST_ASSERT(val == 0,
 			"Expected all the features to be cleared for reg: 0x%lx", reg_info->reg);
 
@@ -214,7 +214,7 @@ static void test_fw_regs_after_vm_start(struct kvm_vcpu *vcpu)
 		 * Before starting the VM, the test clears all the bits.
 		 * Check if that's still the case.
 		 */
-		vcpu_get_reg(vcpu, reg_info->reg, &val);
+		val = vcpu_get_reg(vcpu, reg_info->reg);
 		TEST_ASSERT(val == 0,
 			"Expected all the features to be cleared for reg: 0x%lx",
 			reg_info->reg);
diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index 61731a950def..544ebd2b121b 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -102,8 +102,8 @@ static void assert_vcpu_reset(struct kvm_vcpu *vcpu)
 {
 	uint64_t obs_pc, obs_x0;
 
-	vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pc), &obs_pc);
-	vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
+	obs_pc = vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pc));
+	obs_x0 = vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.regs[0]));
 
 	TEST_ASSERT(obs_pc == CPU_ON_ENTRY_ADDR,
 		    "unexpected target cpu pc: %lx (expected: %lx)",
@@ -143,7 +143,7 @@ static void host_test_cpu_on(void)
 	 */
 	vcpu_power_off(target);
 
-	vcpu_get_reg(target, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &target_mpidr);
+	target_mpidr = vcpu_get_reg(target, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1));
 	vcpu_args_set(source, 1, target_mpidr & MPIDR_HWID_BITMASK);
 	enter_guest(source);
 
diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
index d20981663831..9ed667e1f445 100644
--- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -335,7 +335,7 @@ static uint64_t test_reg_set_success(struct kvm_vcpu *vcpu, uint64_t reg,
 	uint64_t mask = ftr_bits->mask;
 	uint64_t val, new_val, ftr;
 
-	vcpu_get_reg(vcpu, reg, &val);
+	val = vcpu_get_reg(vcpu, reg);
 	ftr = (val & mask) >> shift;
 
 	ftr = get_safe_value(ftr_bits, ftr);
@@ -345,7 +345,7 @@ static uint64_t test_reg_set_success(struct kvm_vcpu *vcpu, uint64_t reg,
 	val |= ftr;
 
 	vcpu_set_reg(vcpu, reg, val);
-	vcpu_get_reg(vcpu, reg, &new_val);
+	new_val = vcpu_get_reg(vcpu, reg);
 	TEST_ASSERT_EQ(new_val, val);
 
 	return new_val;
@@ -359,7 +359,7 @@ static void test_reg_set_fail(struct kvm_vcpu *vcpu, uint64_t reg,
 	uint64_t val, old_val, ftr;
 	int r;
 
-	vcpu_get_reg(vcpu, reg, &val);
+	val = vcpu_get_reg(vcpu, reg);
 	ftr = (val & mask) >> shift;
 
 	ftr = get_invalid_value(ftr_bits, ftr);
@@ -373,7 +373,7 @@ static void test_reg_set_fail(struct kvm_vcpu *vcpu, uint64_t reg,
 	TEST_ASSERT(r < 0 && errno == EINVAL,
 		    "Unexpected KVM_SET_ONE_REG error: r=%d, errno=%d", r, errno);
 
-	vcpu_get_reg(vcpu, reg, &val);
+	val = vcpu_get_reg(vcpu, reg);
 	TEST_ASSERT_EQ(val, old_val);
 }
 
@@ -470,7 +470,7 @@ static void test_clidr(struct kvm_vcpu *vcpu)
 	uint64_t clidr;
 	int level;
 
-	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CLIDR_EL1), &clidr);
+	clidr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CLIDR_EL1));
 
 	/* find the first empty level in the cache hierarchy */
 	for (level = 1; level < 7; level++) {
@@ -495,7 +495,7 @@ static void test_ctr(struct kvm_vcpu *vcpu)
 {
 	u64 ctr;
 
-	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CTR_EL0), &ctr);
+	ctr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CTR_EL0));
 	ctr &= ~CTR_EL0_DIC_MASK;
 	if (ctr & CTR_EL0_IminLine_MASK)
 		ctr--;
@@ -511,7 +511,7 @@ static void test_vcpu_ftr_id_regs(struct kvm_vcpu *vcpu)
 	test_clidr(vcpu);
 	test_ctr(vcpu);
 
-	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &val);
+	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1));
 	val++;
 	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), val);
 
@@ -524,7 +524,7 @@ static void test_assert_id_reg_unchanged(struct kvm_vcpu *vcpu, uint32_t encodin
 	size_t idx = encoding_to_range_idx(encoding);
 	uint64_t observed;
 
-	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(encoding), &observed);
+	observed = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(encoding));
 	TEST_ASSERT_EQ(test_reg_vals[idx], observed);
 }
 
@@ -559,7 +559,7 @@ int main(void)
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
 	/* Check for AARCH64 only system */
-	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), &val);
+	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1));
 	el0 = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0), val);
 	aarch64_only = (el0 == ID_AA64PFR0_EL1_ELx_64BIT_ONLY);
 
diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
index d31b9f64ba14..30d9c9e7ae35 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -440,8 +440,7 @@ static void create_vpmu_vm(void *guest_code)
 		       "Failed to create vgic-v3, skipping");
 
 	/* Make sure that PMUv3 support is indicated in the ID register */
-	vcpu_get_reg(vpmu_vm.vcpu,
-		     KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &dfr0);
+	dfr0 = vcpu_get_reg(vpmu_vm.vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1));
 	pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), dfr0);
 	TEST_ASSERT(pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF &&
 		    pmuver >= ID_AA64DFR0_EL1_PMUVer_IMP,
@@ -484,7 +483,7 @@ static void test_create_vpmu_vm_with_pmcr_n(uint64_t pmcr_n, bool expect_fail)
 	create_vpmu_vm(guest_code);
 	vcpu = vpmu_vm.vcpu;
 
-	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr_orig);
+	pmcr_orig = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0));
 	pmcr = pmcr_orig;
 
 	/*
@@ -493,7 +492,7 @@ static void test_create_vpmu_vm_with_pmcr_n(uint64_t pmcr_n, bool expect_fail)
 	 */
 	set_pmcr_n(&pmcr, pmcr_n);
 	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
-	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
+	pmcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0));
 
 	if (expect_fail)
 		TEST_ASSERT(pmcr_orig == pmcr,
@@ -521,7 +520,7 @@ static void run_access_test(uint64_t pmcr_n)
 	vcpu = vpmu_vm.vcpu;
 
 	/* Save the initial sp to restore them later to run the guest again */
-	vcpu_get_reg(vcpu, ARM64_CORE_REG(sp_el1), &sp);
+	sp = vcpu_get_reg(vcpu, ARM64_CORE_REG(sp_el1));
 
 	run_vcpu(vcpu, pmcr_n);
 
@@ -572,12 +571,12 @@ static void run_pmregs_validity_test(uint64_t pmcr_n)
 		 * Test if the 'set' and 'clr' variants of the registers
 		 * are initialized based on the number of valid counters.
 		 */
-		vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(set_reg_id), &reg_val);
+		reg_val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(set_reg_id));
 		TEST_ASSERT((reg_val & (~valid_counters_mask)) == 0,
 			    "Initial read of set_reg: 0x%llx has unimplemented counters enabled: 0x%lx",
 			    KVM_ARM64_SYS_REG(set_reg_id), reg_val);
 
-		vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(clr_reg_id), &reg_val);
+		reg_val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(clr_reg_id));
 		TEST_ASSERT((reg_val & (~valid_counters_mask)) == 0,
 			    "Initial read of clr_reg: 0x%llx has unimplemented counters enabled: 0x%lx",
 			    KVM_ARM64_SYS_REG(clr_reg_id), reg_val);
@@ -589,12 +588,12 @@ static void run_pmregs_validity_test(uint64_t pmcr_n)
 		 */
 		vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(set_reg_id), max_counters_mask);
 
-		vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(set_reg_id), &reg_val);
+		reg_val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(set_reg_id));
 		TEST_ASSERT((reg_val & (~valid_counters_mask)) == 0,
 			    "Read of set_reg: 0x%llx has unimplemented counters enabled: 0x%lx",
 			    KVM_ARM64_SYS_REG(set_reg_id), reg_val);
 
-		vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(clr_reg_id), &reg_val);
+		reg_val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(clr_reg_id));
 		TEST_ASSERT((reg_val & (~valid_counters_mask)) == 0,
 			    "Read of clr_reg: 0x%llx has unimplemented counters enabled: 0x%lx",
 			    KVM_ARM64_SYS_REG(clr_reg_id), reg_val);
@@ -625,7 +624,7 @@ static uint64_t get_pmcr_n_limit(void)
 	uint64_t pmcr;
 
 	create_vpmu_vm(guest_code);
-	vcpu_get_reg(vpmu_vm.vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
+	pmcr = vcpu_get_reg(vpmu_vm.vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0));
 	destroy_vpmu_vm();
 	return get_pmcr_n(pmcr);
 }
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 63c2aaae51f3..429a7f003fe3 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -678,11 +678,13 @@ static inline int __vcpu_set_reg(struct kvm_vcpu *vcpu, uint64_t id, uint64_t va
 
 	return __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
 }
-static inline void vcpu_get_reg(struct kvm_vcpu *vcpu, uint64_t id, void *addr)
+static inline uint64_t vcpu_get_reg(struct kvm_vcpu *vcpu, uint64_t id)
 {
-	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)addr };
+	uint64_t val;
+	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
 
 	vcpu_ioctl(vcpu, KVM_GET_ONE_REG, &reg);
+	return val;
 }
 static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, uint64_t id, uint64_t val)
 {
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 0ac7cc89f38c..d068afee3327 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -281,8 +281,8 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 	 */
 	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CPACR_EL1), 3 << 20);
 
-	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1), &sctlr_el1);
-	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TCR_EL1), &tcr_el1);
+	sctlr_el1 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1));
+	tcr_el1 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TCR_EL1));
 
 	/* Configure base granule size */
 	switch (vm->mode) {
@@ -360,8 +360,8 @@ void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
 {
 	uint64_t pstate, pc;
 
-	vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pstate), &pstate);
-	vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pc), &pc);
+	pstate = vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pstate));
+	pc = vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pc));
 
 	fprintf(stream, "%*spstate: 0x%.16lx pc: 0x%.16lx\n",
 		indent, "", pstate, pc);
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index 6ae47b3d6b25..dd663bcf0cc0 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -221,39 +221,39 @@ void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
 {
 	struct kvm_riscv_core core;
 
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(mode), &core.mode);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.pc), &core.regs.pc);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.ra), &core.regs.ra);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.sp), &core.regs.sp);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.gp), &core.regs.gp);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.tp), &core.regs.tp);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t0), &core.regs.t0);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t1), &core.regs.t1);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t2), &core.regs.t2);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s0), &core.regs.s0);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s1), &core.regs.s1);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a0), &core.regs.a0);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a1), &core.regs.a1);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a2), &core.regs.a2);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a3), &core.regs.a3);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a4), &core.regs.a4);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a5), &core.regs.a5);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a6), &core.regs.a6);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a7), &core.regs.a7);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s2), &core.regs.s2);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s3), &core.regs.s3);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s4), &core.regs.s4);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s5), &core.regs.s5);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s6), &core.regs.s6);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s7), &core.regs.s7);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s8), &core.regs.s8);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s9), &core.regs.s9);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s10), &core.regs.s10);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s11), &core.regs.s11);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t3), &core.regs.t3);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t4), &core.regs.t4);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t5), &core.regs.t5);
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t6), &core.regs.t6);
+	core.mode = vcpu_get_reg(vcpu, RISCV_CORE_REG(mode));
+	core.regs.pc = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.pc));
+	core.regs.ra = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.ra));
+	core.regs.sp = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.sp));
+	core.regs.gp = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.gp));
+	core.regs.tp = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.tp));
+	core.regs.t0 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t0));
+	core.regs.t1 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t1));
+	core.regs.t2 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t2));
+	core.regs.s0 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s0));
+	core.regs.s1 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s1));
+	core.regs.a0 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a0));
+	core.regs.a1 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a1));
+	core.regs.a2 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a2));
+	core.regs.a3 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a3));
+	core.regs.a4 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a4));
+	core.regs.a5 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a5));
+	core.regs.a6 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a6));
+	core.regs.a7 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a7));
+	core.regs.s2 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s2));
+	core.regs.s3 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s3));
+	core.regs.s4 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s4));
+	core.regs.s5 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s5));
+	core.regs.s6 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s6));
+	core.regs.s7 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s7));
+	core.regs.s8 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s8));
+	core.regs.s9 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s9));
+	core.regs.s10 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s10));
+	core.regs.s11 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s11));
+	core.regs.t3 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t3));
+	core.regs.t4 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t4));
+	core.regs.t5 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t5));
+	core.regs.t6 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t6));
 
 	fprintf(stream,
 		" MODE:  0x%lx\n", core.mode);
diff --git a/tools/testing/selftests/kvm/riscv/arch_timer.c b/tools/testing/selftests/kvm/riscv/arch_timer.c
index 2c792228ac0b..9e370800a6a2 100644
--- a/tools/testing/selftests/kvm/riscv/arch_timer.c
+++ b/tools/testing/selftests/kvm/riscv/arch_timer.c
@@ -93,7 +93,7 @@ struct kvm_vm *test_vm_create(void)
 		vcpu_init_vector_tables(vcpus[i]);
 
 	/* Initialize guest timer frequency. */
-	vcpu_get_reg(vcpus[0], RISCV_TIMER_REG(frequency), &timer_freq);
+	timer_freq = vcpu_get_reg(vcpus[0], RISCV_TIMER_REG(frequency));
 	sync_global_to_guest(vm, timer_freq);
 	pr_debug("timer_freq: %lu\n", timer_freq);
 
diff --git a/tools/testing/selftests/kvm/riscv/ebreak_test.c b/tools/testing/selftests/kvm/riscv/ebreak_test.c
index 0e0712854953..cfed6c727bfc 100644
--- a/tools/testing/selftests/kvm/riscv/ebreak_test.c
+++ b/tools/testing/selftests/kvm/riscv/ebreak_test.c
@@ -60,7 +60,7 @@ int main(void)
 
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_DEBUG);
 
-	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.pc), &pc);
+	pc = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.pc));
 	TEST_ASSERT_EQ(pc, LABEL_ADDRESS(sw_bp_1));
 
 	/* skip sw_bp_1 */
diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
index f299cbfd23ca..f45c0ecc902d 100644
--- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
+++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
@@ -608,7 +608,7 @@ static void test_vm_events_overflow(void *guest_code)
 
 	vcpu_init_vector_tables(vcpu);
 	/* Initialize guest timer frequency. */
-	vcpu_get_reg(vcpu, RISCV_TIMER_REG(frequency), &timer_freq);
+	timer_freq = vcpu_get_reg(vcpu, RISCV_TIMER_REG(frequency));
 	sync_global_to_guest(vm, timer_freq);
 
 	run_vcpu(vcpu);
diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
index 357943f2bea8..b58f75b381e5 100644
--- a/tools/testing/selftests/kvm/s390x/resets.c
+++ b/tools/testing/selftests/kvm/s390x/resets.c
@@ -61,7 +61,7 @@ static void test_one_reg(struct kvm_vcpu *vcpu, uint64_t id, uint64_t value)
 {
 	uint64_t eval_reg;
 
-	vcpu_get_reg(vcpu, id, &eval_reg);
+	eval_reg = vcpu_get_reg(vcpu, id);
 	TEST_ASSERT(eval_reg == value, "value == 0x%lx", value);
 }
 
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index a8d3afa0b86b..cce2520af720 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -269,9 +269,8 @@ static void guest_code(int cpu)
 static bool is_steal_time_supported(struct kvm_vcpu *vcpu)
 {
 	uint64_t id = RISCV_SBI_EXT_REG(KVM_RISCV_SBI_EXT_STA);
-	unsigned long enabled;
+	unsigned long enabled = vcpu_get_reg(vcpu, id);
 
-	vcpu_get_reg(vcpu, id, &enabled);
 	TEST_ASSERT(enabled == 0 || enabled == 1, "Expected boolean result");
 
 	return enabled;
-- 
2.46.0.598.g6f2099f65c-goog


