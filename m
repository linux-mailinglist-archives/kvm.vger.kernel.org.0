Return-Path: <kvm+bounces-12513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D88D8871BA
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 18:10:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59023282F63
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 17:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 634B7604B0;
	Fri, 22 Mar 2024 17:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eugTRHl3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525FF60250;
	Fri, 22 Mar 2024 17:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711127410; cv=none; b=f1oSYa4Mjhosf644PKLKJ3sdZAo/VawCD1pOAZYy17JBm742MhOAVEdrECQJGDPRSt2N3PH10Kybk6gLNQjIArtyW02xpFKmBoBqlLAWkUo+KZovEtMqA0ibf7aiuF1pGspQ3ZdTS7Bg3BKJ6yKjXGM9Tv1XpoLFF82/4rnhSac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711127410; c=relaxed/simple;
	bh=c5ov7MoopiyIqC/Sc9KFDMUQ3B5zqwvzsPpFo/WFKSg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m60RbaQXBRKe6vliYwQcdDI1M+IMnXVK2yXYBcoznnJtGSyNV6K0sMrTK4G7n7eA1p9XwKm42T+6FK7smDnQkBDKl7xz3rtLZrIUf2U9nlRpNgEXko7uEm8FBEKuvu8iLi8fHAVZ6ofQLp4Ha8H5pZ4JTT85kl5npeDmoZn/EI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eugTRHl3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FCFC43330;
	Fri, 22 Mar 2024 17:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711127409;
	bh=c5ov7MoopiyIqC/Sc9KFDMUQ3B5zqwvzsPpFo/WFKSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eugTRHl3LHxH7QyUk4Bz2ehrVrj7KUufZcSdZjke5AkYoYxavXp7P+EGlAOj3l6h1
	 kry5zquEwXzjHQ65WDW4KtFjjFAHEpO7BakM02qGxUhwgBVmFe8YCIWCyDB9ULdxm4
	 PSczeyXQS/sFuSAymW6+AFL3BSj/an2SF/FowxwzrTAH9WXxFThXzAtE9zQve96RSW
	 mi8/iuBgsI2lB3JrzXgdmu7g7A6v/q8uBnQ4ZrMPhfEXC6p1x/HFo24/tq2whEHN+I
	 Q8AdRRqWXFxO+oK+N7sQuJ1FJHconMH0vOPqKQ6h62SmbVfJxeygJ64a8MIhkWfcmt
	 OVq06Ef6Ipg4g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rniP9-00EZPz-PG;
	Fri, 22 Mar 2024 17:10:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Dongli Zhang <dongli.zhang@oracle.com>
Subject: [PATCH v2 4/5] KVM: arm64: Exclude host_fpsimd_state pointer from kvm_vcpu_arch
Date: Fri, 22 Mar 2024 17:09:44 +0000
Message-Id: <20240322170945.3292593-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240322170945.3292593-1-maz@kernel.org>
References: <20240322170945.3292593-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, james.clark@arm.com, anshuman.khandual@arm.com, broonie@kernel.org, dongli.zhang@oracle.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As the name of the field indicates, host_fpsimd_state is strictly
a host piece of data, and we reset this pointer on each PID change.

So let's move it where it belongs, and set it at load-time. Although
this is slightly more often, it is a well defined life-cycle which
matches other pieces of data.

Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h       | 2 +-
 arch/arm64/kvm/fpsimd.c                 | 3 +--
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 1 -
 4 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 590e8767b720..838cdee2ecf7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -543,6 +543,7 @@ struct kvm_cpu_context {
  */
 struct kvm_host_data {
 	struct kvm_cpu_context host_ctxt;
+	struct user_fpsimd_state *fpsimd_state;	/* hyp VA */
 
 	/*
 	 * host_debug_state contains the host registers which are
@@ -661,7 +662,6 @@ struct kvm_vcpu_arch {
 	struct kvm_guest_debug_arch vcpu_debug_state;
 	struct kvm_guest_debug_arch external_debug_state;
 
-	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
 	struct task_struct *parent_task;
 
 	/* VGIC state */
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 571cf6eef1e1..e6bd99358615 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -49,8 +49,6 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
-	vcpu->arch.host_fpsimd_state = kern_hyp_va(fpsimd);
-
 	/*
 	 * We need to keep current's task_struct pinned until its data has been
 	 * unshared with the hypervisor to make sure it is not re-used by the
@@ -87,6 +85,7 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	 * FP_STATE_FREE if the flag set.
 	 */
 	vcpu->arch.fp_state = FP_STATE_HOST_OWNED;
+	*host_data_ptr(fpsimd_state) = kern_hyp_va(&current->thread.uw.fpsimd_state);
 
 	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);
 	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 7d7de0245ed0..6def6ad8dd48 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -377,7 +377,7 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 	/* Write out the host state if it's in the registers */
 	if (vcpu->arch.fp_state == FP_STATE_HOST_OWNED)
-		__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
+		__fpsimd_save_state(*host_data_ptr(fpsimd_state));
 
 	/* Restore the guest state */
 	if (sve_guest)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2385fd03ed87..c5f625dc1f07 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -42,7 +42,6 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	hyp_vcpu->vcpu.arch.fp_state	= host_vcpu->arch.fp_state;
 
 	hyp_vcpu->vcpu.arch.debug_ptr	= kern_hyp_va(host_vcpu->arch.debug_ptr);
-	hyp_vcpu->vcpu.arch.host_fpsimd_state = host_vcpu->arch.host_fpsimd_state;
 
 	hyp_vcpu->vcpu.arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;
 
-- 
2.39.2


