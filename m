Return-Path: <kvm+bounces-10731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3801586F037
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 12:20:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E26642848BE
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 11:20:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26CE31799C;
	Sat,  2 Mar 2024 11:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PbLARC0o"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381F41755F;
	Sat,  2 Mar 2024 11:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709378399; cv=none; b=tl9t5w6CaFx6y769UW6l8QbMKSbX1e3KoXbSxb+GgUfphhHkIX2Kc/5bKWF0b1Xx5ifyNUs0Z8OTOk4KiHL1ygRK/pAYyU7TJCYbCbIuvD1s9oiU3zdA67LQmo7+hIlfqI+EcuVVJgYiK9DXbi7W6t1h0LT44kc67Pg1zAFR+z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709378399; c=relaxed/simple;
	bh=zwMd5mdm+Slc2cpk0eRQsF8VUmhj9pxSnuBqS0UeyEA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BbowL/X/W2FppdT+PF6FMcX7kM5K36JsA06/n3R+/o7IwAGPG2OYjJ1JG9bxLN37EkZvpW5oyn/wLBVhQWrHRiUq7lpl7dPMnKq1wLdj8v8h5Fevnii0mXy+LzWd0fh911+0U0DE7KctfGLk17rb675vV6IN2eJHd4CPkKt3tgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PbLARC0o; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F857C43390;
	Sat,  2 Mar 2024 11:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709378399;
	bh=zwMd5mdm+Slc2cpk0eRQsF8VUmhj9pxSnuBqS0UeyEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbLARC0orHu4fJGehNVuFuSWLrYW/Ku56PGY2zJyp3CvmpZGdXR1Wym7mUXvuNYD1
	 Vl/6/0Zrd65NolhOWbYvM7o6SrTKEkU5iC/SxCaAxZDR0WB4bSjr9hUQBFv4lsRXNU
	 Qtma6AQOx+ghmCZJQF3XTTNQufOUtkXLpzNUAGWCr1DVwBz4xmaw/8klfCXLc4W+Jv
	 q8UQiu8S9lKIa8UWUeu/VLzo9o4p/0E7T0m/dtkeB3bA9TeRsmSTjQNs5WLFaxfZdU
	 U0shDt20wv9OPI0s4IbpgmSzgN6INWcHb6hc/XiFdrTOd5LvGJMwpQSnfzIjmQtNPK
	 WxEiYZS59BySQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rgNPI-008lLw-Q0;
	Sat, 02 Mar 2024 11:19:56 +0000
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
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 4/5] KVM: arm64: Exclude host_fpsimd_state pointer from kvm_vcpu_arch
Date: Sat,  2 Mar 2024 11:19:34 +0000
Message-Id: <20240302111935.129994-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240302111935.129994-1-maz@kernel.org>
References: <20240302111935.129994-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, james.clark@arm.com, anshuman.khandual@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As the name of the field indicates, host_fpsimd_state is strictly
a host piece of data, and we reset this pointer on each PID change.

So let's move it where it belongs, and set it at load-time. Although
this is slightly more often, it is a well defined life-cycle which
matches other pieces of data.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h       | 2 +-
 arch/arm64/kvm/fpsimd.c                 | 3 +--
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 1 -
 4 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a3718f441e12..39b39da3e61b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -505,6 +505,7 @@ struct kvm_cpu_context {
  */
 struct kvm_host_data {
 	struct kvm_cpu_context host_ctxt;
+	struct user_fpsimd_state *fpsimd_state;	/* hyp VA */
 
 	/*
 	 * host_debug_state contains the host registers which are
@@ -622,7 +623,6 @@ struct kvm_vcpu_arch {
 	struct kvm_guest_debug_arch vcpu_debug_state;
 	struct kvm_guest_debug_arch external_debug_state;
 
-	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
 	struct task_struct *parent_task;
 
 	/* VGIC state */
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 8c1d0d4853df..f650e46d4bea 100644
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
index 8ae81301083f..f67d8eafc245 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -370,7 +370,7 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 
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


