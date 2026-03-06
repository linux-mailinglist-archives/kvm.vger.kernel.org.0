Return-Path: <kvm+bounces-73124-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WHGRHS4Nq2nCZgEAu9opvQ
	(envelope-from <kvm+bounces-73124-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:21:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E66C225F02
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:21:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BEA50303B610
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 17:12:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B2BF45BD6B;
	Fri,  6 Mar 2026 17:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fZgVuzwf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D37401484;
	Fri,  6 Mar 2026 17:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772817062; cv=none; b=mFjSbAVt9KbhOlgxeMnLmqEYKc7wAjZWsrYPdR8uiRh/Uu0POJaFUDA2hdTjCfyQeWq7OeBe1pnxBJGHwveY4d/WhXCr2SmyA/aglaoX94H4Z0WUh9fn1MdiFqK6DKkOWKL6oed5s2AVs9YMClVXZWSTqvP8uEtoc8d6e3iKxfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772817062; c=relaxed/simple;
	bh=8cslAwJ6i6zMbxfjdRzBzF+cW4InDSsHIAphFArm1rY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jgaXAUoFWrhtdnwfF5Bt9VyCt8r3wU9NtHUm1PgJY/JO1QoHxUPLpQ4/DTJNSTVfT/3gppqwX5JwcMuqowDM1XHBMeLBCXDBViKBWKXAY13uBTJRlUEPd9qFce21YEZy+oOmhrdSKYoG6x759aUDXXTCXMBtKr0Ikuo6ZAN9j5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fZgVuzwf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B617C4CEF7;
	Fri,  6 Mar 2026 17:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817062;
	bh=8cslAwJ6i6zMbxfjdRzBzF+cW4InDSsHIAphFArm1rY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fZgVuzwfkN1dJnujTK6ts3keru/YW/PGPiIgHZMRmonr29KcySQsSBpsdxWENBblF
	 YyBb9IP1M7af20C8NNFzQ7mf4UKvetIYfYHU7IFpmaV2/fbLICVQiPWihxFwYB94O4
	 i6kKnpnbm8MShQHY9YR/qsCFOiEmPiSKCZV9BjPzTw2g/M2Ov3pHbIRwf7ZUYe3Ufk
	 F3+Uy2nuGkF1WJQXZ5lOt6wbqvkoEl4H0wK6CUBOTiQxLcym9fsYQ+se15H/CVDs42
	 OCUvpJsA2PxNE5/JzNEYEsUqWQqqIRqME6AmTTQWCnq4/shTpM4RwV/mpOglD3iCGY
	 LURnYDYKC+kSA==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 06 Mar 2026 17:01:14 +0000
Subject: [PATCH v10 22/30] KVM: arm64: Expose SME specific state to
 userspace
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kvm-arm64-sme-v10-22-43f7683a0fb7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8956; i=broonie@kernel.org;
 h=from:subject:message-id; bh=8cslAwJ6i6zMbxfjdRzBzF+cW4InDSsHIAphFArm1rY=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpqwo5RbOzKDT/89tBGwP/aLROnesc5kxEi84tX
 j1cZXuay2WJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaasKOQAKCRAk1otyXVSH
 0KNtB/9fOJsPMBHYGZ02D8X6IM1CVd0zufqgwE1w2hx+XzAZQ7KeXU0EuFGfBV3z5JMzMDhzY5m
 Mro8SO4kRHlx5rWomvODODXFstZTQVgp8sJqKwRpJ1xABNC0q6QFQmC9yjZqtBDdPfWfXMwisWC
 qnik4n3YxefCZdjgoIX5pEijv97jjLyukxQMUByce2K2sxl3fRRRkmSqKxyPEUJwtr8z6MSgOcB
 KHbplxFOBoahX+j1eNWrIwp0Y3guonKJOVXTlSiifBsrA5PUzflto3FBbPd4Q3wiMWATkmXmoD0
 +jFtKTdronitedM9kC3J8OlAXRZG7KkSD/orsyL8pY1s36PT
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Queue-Id: 5E66C225F02
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73124-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[broonie@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.917];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

SME introduces two new registers, the ZA matrix register and the ZT0 LUT
register.  Both of these registers are only accessible when PSTATE.ZA is
set and ZT0 is only present if SME2 is enabled for the guest. Provide
support for configuring these from VMMs.

The ZA matrix is a single SVL*SVL register which is available when
PSTATE.ZA is set. We follow the pattern established by the architecture
itself and expose this to userspace as a series of horizontal SVE vectors
with the streaming mode vector length, using the format already established
for the SVE vectors themselves.

ZT0 is a single register with a refreshingly fixed size 512 bit register
which is like ZA accessible only when PSTATE.ZA is set. Add support for it
to the userspace API.

As is done in the architecture for both ZA and ZT0 the value will be
reset to 0 whenever PSTATE.ZA changes from 0 to 1 and the registers are
inaccessible when PSTATE.ZA is 0.

While there is currently only one ZT register the naming as ZT0 and the
instruction encoding clearly leave room for future extensions adding more
ZT registers. This encoding can readily support such an extension if one is
introduced.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/uapi/asm/kvm.h |  20 +++++
 arch/arm64/kvm/guest.c            | 168 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 186 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 498a49a61487..f68061680f9a 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -357,6 +357,26 @@ struct kvm_arm_counter_offset {
 /* SME registers */
 #define KVM_REG_ARM64_SME		(0x17 << KVM_REG_ARM_COPROC_SHIFT)
 
+#define KVM_ARM64_SME_VQ_MIN __SVE_VQ_MIN
+#define KVM_ARM64_SME_VQ_MAX __SVE_VQ_MAX
+
+/* ZA and ZTn occupy blocks at the following offsets within this range: */
+#define KVM_REG_ARM64_SME_ZA_BASE	0
+#define KVM_REG_ARM64_SME_ZT_BASE	0x600
+
+#define KVM_ARM64_SME_MAX_ZAHREG	(__SVE_VQ_BYTES * KVM_ARM64_SME_VQ_MAX)
+
+#define KVM_REG_ARM64_SME_ZAHREG(n, i)					\
+	(KVM_REG_ARM64 | KVM_REG_ARM64_SME | KVM_REG_ARM64_SME_ZA_BASE | \
+	 KVM_REG_SIZE_U2048 |						\
+	 (((n) & (KVM_ARM64_SME_MAX_ZAHREG - 1)) << 5) |		\
+	 ((i) & (KVM_ARM64_SVE_MAX_SLICES - 1)))
+
+#define KVM_REG_ARM64_SME_ZTREG_SIZE	(512 / 8)
+#define KVM_REG_ARM64_SME_ZTREG(n) \
+	(KVM_REG_ARM64 | KVM_REG_ARM64_SME | KVM_REG_ARM64_SME_ZT_BASE | \
+	 KVM_REG_SIZE_U512)
+
 /* Vector lengths pseudo-register: */
 #define KVM_REG_ARM64_SME_VLS		(KVM_REG_ARM64 | KVM_REG_ARM64_SME | \
 					 KVM_REG_SIZE_U512 | 0xfffe)
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 20e06047d4bf..b78944a76da8 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -604,23 +604,124 @@ static int set_sme_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return set_vec_vls(ARM64_VEC_SME, vcpu, reg);
 }
 
+/*
+ * Validate SVE register ID and get sanitised bounds for user/kernel SVE
+ * register copy
+ */
+static int sme_reg_to_region(struct vec_state_reg_region *region,
+			     struct kvm_vcpu *vcpu,
+			     const struct kvm_one_reg *reg)
+{
+	/* reg ID ranges for ZA.H[n] registers */
+	unsigned int vq = vcpu_sme_max_vq(vcpu);
+	const u64 za_h_max = vq * __SVE_VQ_BYTES;
+	const u64 zah_id_min = KVM_REG_ARM64_SME_ZAHREG(0, 0);
+	const u64 zah_id_max = KVM_REG_ARM64_SME_ZAHREG(za_h_max - 1,
+						       SVE_NUM_SLICES - 1);
+	unsigned int reg_num;
+
+	unsigned int reqoffset, reqlen; /* User-requested offset and length */
+	unsigned int maxlen; /* Maximum permitted length */
+
+	size_t sme_state_size;
+
+	reg_num = (reg->id & SVE_REG_ID_MASK) >> SVE_REG_ID_SHIFT;
+
+	if (reg->id >= zah_id_min && reg->id <= zah_id_max) {
+		if (!vcpu_has_sme(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)
+			return -ENOENT;
+
+		if (!vcpu_za_enabled(vcpu))
+			return -EBUSY;
+
+		/* ZA is exposed as SVE vectors ZA.H[n] */
+		reqoffset = ZA_SIG_ZAV_OFFSET(vq, reg_num) -
+			ZA_SIG_REGS_OFFSET;
+		reqlen = KVM_SVE_ZREG_SIZE;
+		maxlen = SVE_SIG_ZREG_SIZE(vq);
+	} else if (reg->id == KVM_REG_ARM64_SME_ZTREG(0)) {
+		if (!kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, SME, SME2))
+			return -ENOENT;
+
+		if (!vcpu_za_enabled(vcpu))
+			return -EBUSY;
+
+		/* ZT0 is stored after ZA */
+		reqoffset = ZA_SIG_REGS_SIZE(vq);
+		reqlen = KVM_REG_ARM64_SME_ZTREG_SIZE;
+		maxlen = KVM_REG_ARM64_SME_ZTREG_SIZE;
+	} else {
+		return -EINVAL;
+	}
+
+	sme_state_size = vcpu_sme_state_size(vcpu);
+	if (WARN_ON(!sme_state_size))
+		return -EINVAL;
+
+	region->koffset = array_index_nospec(reqoffset, sme_state_size);
+	region->klen = min(maxlen, reqlen);
+	region->upad = reqlen - region->klen;
+
+	return 0;
+}
+
+/*
+ * ZA is exposed as an array of horizontal vectors with the same
+ * format as SVE, mirroring the architecture's LDR ZA[Wv, offs], [Xn]
+ * instruction.
+ */
+
 static int get_sme_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
+	int ret;
+	struct vec_state_reg_region region;
+	char __user *uptr = (char __user *)reg->addr;
+
 	/* Handle the KVM_REG_ARM64_SME_VLS pseudo-reg as a special case: */
 	if (reg->id == KVM_REG_ARM64_SME_VLS)
 		return get_sme_vls(vcpu, reg);
 
-	return -EINVAL;
+	/* Try to interpret reg ID as an architectural SME register... */
+	ret = sme_reg_to_region(&region, vcpu, reg);
+	if (ret)
+		return ret;
+
+	if (!kvm_arm_vcpu_vec_finalized(vcpu))
+		return -EPERM;
+
+	if (copy_to_user(uptr, vcpu->arch.sme_state + region.koffset,
+			 region.klen) ||
+	    clear_user(uptr + region.klen, region.upad))
+		return -EFAULT;
+
+	return 0;
 }
 
 static int set_sme_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
+	int ret;
+	struct vec_state_reg_region region;
+	char __user *uptr = (char __user *)reg->addr;
+
 	/* Handle the KVM_REG_ARM64_SME_VLS pseudo-reg as a special case: */
 	if (reg->id == KVM_REG_ARM64_SME_VLS)
 		return set_sme_vls(vcpu, reg);
 
-	return -EINVAL;
+	/* Try to interpret reg ID as an architectural SME register... */
+	ret = sme_reg_to_region(&region, vcpu, reg);
+	if (ret)
+		return ret;
+
+	if (!kvm_arm_vcpu_vec_finalized(vcpu))
+		return -EPERM;
+
+	if (copy_from_user(vcpu->arch.sme_state + region.koffset, uptr,
+			   region.klen))
+		return -EFAULT;
+
+	return 0;
 }
+
 int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
 	return -EINVAL;
@@ -699,6 +800,20 @@ static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static unsigned long num_sme_regs(const struct kvm_vcpu *vcpu)
+{
+	const unsigned int slices = vcpu_sve_slices(vcpu);
+
+	if (!vcpu_has_sme(vcpu))
+		return 0;
+
+	/* Policed by KVM_GET_REG_LIST: */
+	WARN_ON(!kvm_arm_vcpu_vec_finalized(vcpu));
+
+	/* KVM_REG_ARM64_SME_VLS, ZA, and ZT0 if SME2 */
+	return 1 + (slices * vcpu_sme_max_vl(vcpu)) + vcpu_has_sme2(vcpu);
+}
+
 static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 				u64 __user *uindices)
 {
@@ -746,6 +861,49 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 	return num_regs;
 }
 
+static int copy_sme_reg_indices(const struct kvm_vcpu *vcpu,
+				u64 __user *uindices)
+{
+	const unsigned int slices = vcpu_sve_slices(vcpu);
+	u64 reg;
+	unsigned int i, n;
+	int num_regs = 0;
+
+	if (!vcpu_has_sme(vcpu))
+		return 0;
+
+	/* Policed by KVM_GET_REG_LIST: */
+	WARN_ON(!kvm_arm_vcpu_vec_finalized(vcpu));
+
+	/*
+	 * Enumerate this first, so that userspace can save/restore in
+	 * the order reported by KVM_GET_REG_LIST:
+	 */
+	reg = KVM_REG_ARM64_SME_VLS;
+	if (put_user(reg, uindices++))
+		return -EFAULT;
+	++num_regs;
+
+	for (i = 0; i < slices; i++) {
+		for (n = 0; n < vcpu_sme_max_vl(vcpu); n++) {
+			reg = KVM_REG_ARM64_SME_ZAHREG(n, i);
+			if (put_user(reg, uindices++))
+				return -EFAULT;
+			num_regs++;
+		}
+	}
+
+	if (vcpu_has_sme2(vcpu)) {
+		reg = KVM_REG_ARM64_SME_ZTREG(0);
+		if (put_user(reg, uindices++))
+			return -EFAULT;
+		num_regs++;
+	}
+
+	return num_regs;
+}
+
+
 /**
  * kvm_arm_num_regs - how many registers do we present via KVM_GET_ONE_REG
  * @vcpu: the vCPU pointer
@@ -758,6 +916,7 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
 
 	res += num_core_regs(vcpu);
 	res += num_sve_regs(vcpu);
+	res += num_sme_regs(vcpu);
 	res += kvm_arm_num_sys_reg_descs(vcpu);
 	res += kvm_arm_get_fw_num_regs(vcpu);
 
@@ -785,6 +944,11 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 		return ret;
 	uindices += ret;
 
+	ret = copy_sme_reg_indices(vcpu, uindices);
+	if (ret < 0)
+		return ret;
+	uindices += ret;
+
 	ret = kvm_arm_copy_fw_reg_indices(vcpu, uindices);
 	if (ret < 0)
 		return ret;

-- 
2.47.3


