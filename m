Return-Path: <kvm+bounces-73122-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0CcADeQMq2k/ZgEAu9opvQ
	(envelope-from <kvm+bounces-73122-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:20:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EE7B225E82
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:20:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 77B5F302247A
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 17:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA61F43CECD;
	Fri,  6 Mar 2026 17:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P+t6cMfr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EE841B34E;
	Fri,  6 Mar 2026 17:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772817054; cv=none; b=WSASsXoVY4EDFqDkNC6ROpLyzdcJFrwA4N9zvBp1XKFKgoqMolgk0wAJDYjLssoevfD6UXV0VzjfI/ABX+3yYTDLPcy1uVHz+D5/1BhnYZZprDLDXyPInKkHJaWoWPkpoPVQDhH4mXo0hjV6IfDve+3sCG7bCLBcy+qVjHOXsrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772817054; c=relaxed/simple;
	bh=adTxBFGRwQgcoDahtmqxTjtuGOAKvsxDnqc+RXBB7TE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Z0vAE0USfSLee6PKPIedeFho2Ze3vHxEUDEtwjbsphsWPjdf3u7IQLeDRSx6WJV9Y8svi6XKTVZH7OgiWb9gnJwbKgFtiEhSg2EtswQqn6uB+S3b16dzxoIjsUrAft9eftkk9FCyBE3jBFpoqgGVYAsLJMeyFbelyb88G59aUJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P+t6cMfr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08D8C4CEF7;
	Fri,  6 Mar 2026 17:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817053;
	bh=adTxBFGRwQgcoDahtmqxTjtuGOAKvsxDnqc+RXBB7TE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=P+t6cMfruA3noVoGA+fw/wB+mk2enpMDLfvQ8j8XARair3vL0IwqYBhen0Fv3+H9E
	 NlWNDNYjnzwsxnaE3ZwbR+Ce1tQ2Rjh/cok5oE9yH9dbcjM/y7hDWE+5o+7eyd02oi
	 l2tqCb6/f3llO7K8x2mzTO9Mm8w5r5UKX66QFmxd1EnKDpXe968/HnGDNm/4Mk325h
	 p6Z+dx5NdqfzQFzhi3Io1cbkTLLv5cCjFig0O2waxMswjetXxMKtim8p3Esz0bV+6D
	 s4sC3uinbkWgPLpX4SNyVn1G0ml/SQxEqtwQmortAaTN63MZLRMK0laVRjvy7ln6Dd
	 nkDTE3DbaAAQA==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 06 Mar 2026 17:01:12 +0000
Subject: [PATCH v10 20/30] KVM: arm64: Support userspace access to
 streaming mode Z and P registers
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kvm-arm64-sme-v10-20-43f7683a0fb7@kernel.org>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
In-Reply-To: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-6ac23
X-Developer-Signature: v=1; a=openpgp-sha256; l=5535; i=broonie@kernel.org;
 h=from:subject:message-id; bh=adTxBFGRwQgcoDahtmqxTjtuGOAKvsxDnqc+RXBB7TE=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpqwo4vuM/qvToJ/erMef+mTT8+E2MOiB02B8xK
 rUCsyw4o/6JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaasKOAAKCRAk1otyXVSH
 0H/EB/9WbvOJbemHDY5M9t8n5SLcw2NQ6dV+b4W/ALqCyPneVNWB7Qj1lVutSczk7wkC2W10E2h
 hm4u0UURF0Zh5RnHC3/9u9WGgQAm+p5nQH9KjETJOTVvb8yWZStMCFxEPwE7AgWXmLL1yJ/z42I
 R1bOvV4+1fIAUzCzWJhvh/OLVd7zuUKuDJKme+IdtEwOXtmzxbwrUt+nfUbaqUIOPmErVOKCXuy
 7PB7sdZgZ9npHPaQDddBJdKJfz75vU3Wpq1Gvl0rE+kg/gZBqnibf6vj9lJD+2BUWRNCrxEaCwq
 5dNy3LhUHtlmaInaBRQmubYJPPDv/Vgpbc5oTydIBWeg7ItY
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Queue-Id: 6EE7B225E82
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73122-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[broonie@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.916];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

SME introduces a mode called streaming mode where the Z, P and optionally
FFR registers can be accessed using the SVE instructions but with the SME
vector length. Reflect this in the ABI for accessing the guest registers by
making the vector length for the vcpu reflect the vector length that would
be seen by the guest were it running, using the SME vector length when the
guest is configured for streaming mode.

Since SME may be present without SVE we also update the existing checks for
access to the Z, P and V registers to check for either SVE or streaming
mode. When not in streaming mode the guest floating point state may be
accessed via the V registers.

Any VMM that supports SME must be aware of the need to configure streaming
mode prior to writing the floating point registers that this creates.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/guest.c | 67 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 58 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 9276054b5bdd..20e06047d4bf 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -73,6 +73,19 @@ static u64 core_reg_offset_from_id(u64 id)
 	return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
 }
 
+static bool vcpu_has_sve_regs(const struct kvm_vcpu *vcpu)
+{
+	return vcpu_has_sve(vcpu) || vcpu_in_streaming_mode(vcpu);
+}
+
+static bool vcpu_has_ffr(const struct kvm_vcpu *vcpu)
+{
+	if (vcpu_in_streaming_mode(vcpu))
+		return vcpu_has_fa64(vcpu);
+	else
+		return vcpu_has_sve(vcpu);
+}
+
 static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
 {
 	int size;
@@ -110,9 +123,10 @@ static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
 	/*
 	 * The KVM_REG_ARM64_SVE regs must be used instead of
 	 * KVM_REG_ARM_CORE for accessing the FPSIMD V-registers on
-	 * SVE-enabled vcpus:
+	 * SVE-enabled vcpus or when a SME enabled vcpu is in
+	 * streaming mode:
 	 */
-	if (vcpu_has_sve(vcpu) && core_reg_offset_is_vreg(off))
+	if (vcpu_has_sve_regs(vcpu) && core_reg_offset_is_vreg(off))
 		return -EINVAL;
 
 	return size;
@@ -423,6 +437,24 @@ struct vec_state_reg_region {
 	unsigned int upad;	/* extra trailing padding in user memory */
 };
 
+/*
+ * We represent the Z and P registers to userspace using either the
+ * SVE or SME vector length, depending on which features the guest has
+ * and if the guest is in streaming mode.
+ */
+static unsigned int vcpu_sve_cur_vq(struct kvm_vcpu *vcpu)
+{
+	unsigned int vq = 0;
+
+	if (vcpu_has_sve(vcpu))
+		vq = vcpu_sve_max_vq(vcpu);
+
+	if (vcpu_in_streaming_mode(vcpu))
+		vq = vcpu_sme_max_vq(vcpu);
+
+	return vq;
+}
+
 /*
  * Validate SVE register ID and get sanitised bounds for user/kernel SVE
  * register copy
@@ -460,20 +492,25 @@ static int sve_reg_to_region(struct vec_state_reg_region *region,
 	reg_num = (reg->id & SVE_REG_ID_MASK) >> SVE_REG_ID_SHIFT;
 
 	if (reg->id >= zreg_id_min && reg->id <= zreg_id_max) {
-		if (!vcpu_has_sve(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)
+		if (!vcpu_has_sve_regs(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)
 			return -ENOENT;
 
-		vq = vcpu_sve_max_vq(vcpu);
+		vq = vcpu_sve_cur_vq(vcpu);
 
 		reqoffset = SVE_SIG_ZREG_OFFSET(vq, reg_num) -
 				SVE_SIG_REGS_OFFSET;
 		reqlen = KVM_SVE_ZREG_SIZE;
 		maxlen = SVE_SIG_ZREG_SIZE(vq);
 	} else if (reg->id >= preg_id_min && reg->id <= preg_id_max) {
-		if (!vcpu_has_sve(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)
+		if (!vcpu_has_sve_regs(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)
 			return -ENOENT;
 
-		vq = vcpu_sve_max_vq(vcpu);
+		if (!vcpu_has_ffr(vcpu) &&
+		    (reg->id >= KVM_REG_ARM64_SVE_FFR(0)) &&
+		    (reg->id <= KVM_REG_ARM64_SVE_FFR(SVE_NUM_SLICES - 1)))
+			return -ENOENT;
+
+		vq = vcpu_sve_cur_vq(vcpu);
 
 		reqoffset = SVE_SIG_PREG_OFFSET(vq, reg_num) -
 				SVE_SIG_REGS_OFFSET;
@@ -512,6 +549,9 @@ static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if (!kvm_arm_vcpu_vec_finalized(vcpu))
 		return -EPERM;
 
+	if (!vcpu_has_sve_regs(vcpu))
+		return -EBUSY;
+
 	if (copy_to_user(uptr, vcpu->arch.sve_state + region.koffset,
 			 region.klen) ||
 	    clear_user(uptr + region.klen, region.upad))
@@ -538,6 +578,9 @@ static int set_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if (!kvm_arm_vcpu_vec_finalized(vcpu))
 		return -EPERM;
 
+	if (!vcpu_has_sve_regs(vcpu))
+		return -EBUSY;
+
 	if (copy_from_user(vcpu->arch.sve_state + region.koffset, uptr,
 			   region.klen))
 		return -EFAULT;
@@ -639,15 +682,21 @@ static unsigned long num_core_regs(const struct kvm_vcpu *vcpu)
 static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
 {
 	const unsigned int slices = vcpu_sve_slices(vcpu);
+	int regs, ret;
 
-	if (!vcpu_has_sve(vcpu))
+	if (!vcpu_has_sve(vcpu) && !vcpu_in_streaming_mode(vcpu))
 		return 0;
 
 	/* Policed by KVM_GET_REG_LIST: */
 	WARN_ON(!kvm_arm_vcpu_vec_finalized(vcpu));
 
-	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */)
-		+ 1; /* KVM_REG_ARM64_SVE_VLS */
+	regs = SVE_NUM_PREGS + SVE_NUM_ZREGS;
+	if (vcpu_has_sve(vcpu) || vcpu_has_fa64(vcpu))
+		regs++;  /* FFR */
+	ret = regs * slices;
+	if (vcpu_has_sve(vcpu))
+		ret++; /* KVM_REG_ARM64_SVE_VLS */
+	return ret;
 }
 
 static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,

-- 
2.47.3


