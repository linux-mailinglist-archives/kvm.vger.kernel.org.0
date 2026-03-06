Return-Path: <kvm+bounces-73128-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gCdlFgkNq2k/ZgEAu9opvQ
	(envelope-from <kvm+bounces-73128-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:21:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ED530225ECA
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:21:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 93C9731C0A08
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 17:13:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5728C47DD7F;
	Fri,  6 Mar 2026 17:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kkx9QrV/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843D5407598;
	Fri,  6 Mar 2026 17:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772817080; cv=none; b=e+9VxGo/bIM4dtacO0i9AYYD52itJNmwFG8Pm321z/o5edK6PgKsXKHe1OHigtiZ5GIQ6p3HdJJ8v0AxWA/GgMzTRXcH0pJVp1O90wW9IF5G+bDnUJedWcuL09J9dLVYrtP4uTH6vYKqmMopruDo0cjcdXgLERpdRQGhfXUTWQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772817080; c=relaxed/simple;
	bh=6m0sKJbA/KvxO4vsamJcMuexvM6p6QuYEsrhuWbCs1o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XxUsrnip/hfKLfI9UQ+Mxud3vuJDCWPYHoQ/FrYkB1kuIdM+NbIkNBf346OSQ9AnK4kRAdgH5i1vP6WU3Be/R96LQFYorlCjfdepZFVnJKSs4dYWAXzq88l5hrG78juKOIW5nKZ3ggP/skElmVvNkYMPGam9ecLO6GixLiqknU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kkx9QrV/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412B6C4CEF7;
	Fri,  6 Mar 2026 17:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817080;
	bh=6m0sKJbA/KvxO4vsamJcMuexvM6p6QuYEsrhuWbCs1o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kkx9QrV/GY4V34fTo0HxLDz/g6XLe91Md43t8uw/oWXXV8ny8qFUwCxsLfdvxW9Xv
	 CkC9IkFPzVnQu4g1De1QdRj78ZPme3Me2+9NLNABo6NzWF1qoYGoE+mVQkqHqanCpr
	 hXfvslEaFqyFON+GXuzkVNtf9EDzG1Ss5i68aMmQ2xBGWHqSfTkkOI4Ry5QQlIfhZj
	 4yq7mFbyBHKRMysG6yTmuYZWpH9sC+gGeuxBSSPAk3gBp36hT/LHKrs63oPRqyRJY6
	 56i8+SjsHhev6fo2vCFBE90NhmYS4l1bMD/QwqtNdAq4u4VWj+XtrC9iJUqfwemUzO
	 CCkOxefOitI5Q==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 06 Mar 2026 17:01:18 +0000
Subject: [PATCH v10 26/30] KVM: arm64: Provide interface for configuring
 and enabling SME for guests
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kvm-arm64-sme-v10-26-43f7683a0fb7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=17368; i=broonie@kernel.org;
 h=from:subject:message-id; bh=6m0sKJbA/KvxO4vsamJcMuexvM6p6QuYEsrhuWbCs1o=;
 b=owGbwMvMwMWocq27KDak/QLjabUkhszVXDZPZr9S3p+zNvR4ZoCYxLJFv7PvWnouWskeGLSMO
 1jcyLymk9GYhYGRi0FWTJFl7bOMVenhElvnP5r/CmYQKxPIFAYuTgGYyNzd7P+TWMLOG/29+0Ff
 P1u3RFP1is5if9/Zqi5R9j3zwtaJ38ja+OqKVXJZrOIHx9k+W76+9zjBXr24Qrgh3rO0ZrNr+Tb
 9w8kaNacl9SuTDOxj+3icnms5uf+WXrF4U3Q0e+E0/c81lonfPJJdJf/+6w465CCe+PV5m/Ja/d
 Nvt5bJ87E9it/9K9G0TU391e/PObMe5vrNuC4ZZfntkZxCmHoCi/SWpBVO7JMark/OftM0mXXyg
 wMeZw49++agzJAWlyHu82ONWXhvdvLS0C+HZnIKcrwtC5vGoPt78s2TrvXukvfkG2w1f4b0Twg8
 wXp1mqHGIvtHHclqM6ZfTrsi7vQgc7nnrp7S+TXcqeYGAA==
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Queue-Id: ED530225ECA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73128-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[broonie@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.909];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Since SME requires configuration of a vector length in order to know the
size of both the streaming mode SVE state and ZA array we implement a
capability for it and require that it be enabled and finalized before
the SME specific state can be accessed, similarly to SVE.

Due to the overlap with sizing the SVE state we finalise both SVE and
SME with a single finalization, preventing any further changes to the
SVE and SME configuration once KVM_ARM_VCPU_VEC (an alias for _VCPU_SVE)
has been finalised. This is not a thing of great elegance but it ensures
that we never have a state where one of SVE or SME is finalised and the
other not, avoiding complexity.

Since unlike SVE there is no architecturally manadated vector length
which must be supported by all PEs we detect the case where the feature
is supported but there is no shared VL and hide the feature.

SME is supported for normal and protected guests.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h    |   2 +-
 arch/arm64/include/asm/kvm_host.h  |  18 +++++-
 arch/arm64/include/uapi/asm/kvm.h  |   1 +
 arch/arm64/kvm/arm.c               |  10 ++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c     |  79 ++++++++++++++++++++-----
 arch/arm64/kvm/hyp/nvhe/sys_regs.c |   6 ++
 arch/arm64/kvm/reset.c             | 116 +++++++++++++++++++++++++++++++------
 include/uapi/linux/kvm.h           |   1 +
 8 files changed, 197 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index f891261a5c91..409f621685ee 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -470,7 +470,7 @@ static inline void sme_alloc(struct task_struct *task, bool flush) { }
 static inline void sme_setup(void) { }
 static inline unsigned int sme_get_vl(void) { return 0; }
 static inline int sme_max_vl(void) { return 0; }
-static inline int sme_max_virtualisable_vl(void) { return 0; }
+static inline int sme_max_virtualisable_vl(void) { return SME_VQ_INVALID; }
 static inline int sme_set_current_vl(unsigned long arg) { return -EINVAL; }
 static inline int sme_get_current_vl(void) { return -EINVAL; }
 static inline void sme_suspend_exit(void) { }
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f804cf160b1e..28de788ba4d9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -39,7 +39,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 9
+#define KVM_VCPU_MAX_FEATURES 10
 #define KVM_VCPU_VALID_FEATURES	(BIT(KVM_VCPU_MAX_FEATURES) - 1)
 
 #define KVM_REQ_SLEEP \
@@ -82,6 +82,7 @@ extern unsigned int __ro_after_init kvm_host_max_vl[ARM64_VEC_MAX];
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
 int __init kvm_arm_init_sve(void);
+int __init kvm_arm_init_sme(void);
 
 u32 __attribute_const__ kvm_target_cpu(void);
 void kvm_reset_vcpu(struct kvm_vcpu *vcpu);
@@ -1174,7 +1175,14 @@ struct kvm_vcpu_arch {
 	__size_ret;							\
 })
 
-#define vcpu_sve_state_size(vcpu) sve_state_size_from_vl((vcpu)->arch.max_vl[ARM64_VEC_SVE])
+#define vcpu_sve_state_size(vcpu) ({					\
+	unsigned int __max_vl;						\
+									\
+	__max_vl = max((vcpu)->arch.max_vl[ARM64_VEC_SVE],		\
+		       (vcpu)->arch.max_vl[ARM64_VEC_SME]);		\
+									\
+	sve_state_size_from_vl(__max_vl);				\
+})
 
 #define vcpu_sme_state(vcpu) (kern_hyp_va((vcpu)->arch.sme_state))
 
@@ -1774,4 +1782,10 @@ static __always_inline enum fgt_group_id __fgt_reg_to_group_id(enum vcpu_sysreg
 
 long kvm_get_cap_for_kvm_ioctl(unsigned int ioctl, long *ext);
 
+static inline bool system_supports_sme_virt(void)
+{
+	return system_supports_sme() &&
+		sme_max_virtualisable_vl() != sve_vl_from_vq(SME_VQ_INVALID);
+}
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index f68061680f9a..af89a5cc860f 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -106,6 +106,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
 #define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
 #define KVM_ARM_VCPU_HAS_EL2_E2H0	8 /* Limit NV support to E2H RES0 */
+#define KVM_ARM_VCPU_SME		9 /* enable SME for this CPU */
 
 /*
  * An alias for _SVE since we finalize VL configuration for both SVE and SME
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 410ffd41fd73..aa9f334ae10e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -447,6 +447,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SVE:
 		r = system_supports_sve();
 		break;
+	case KVM_CAP_ARM_SME:
+		r = system_supports_sme_virt();
+		break;
 	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
 		r = kvm_has_full_ptr_auth();
@@ -1502,6 +1505,9 @@ static unsigned long system_supported_vcpu_features(void)
 	if (!system_supports_sve())
 		clear_bit(KVM_ARM_VCPU_SVE, &features);
 
+	if (!system_supports_sme_virt())
+		clear_bit(KVM_ARM_VCPU_SME, &features);
+
 	if (!kvm_has_full_ptr_auth()) {
 		clear_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, &features);
 		clear_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, &features);
@@ -2933,6 +2939,10 @@ static __init int kvm_arm_init(void)
 	if (err)
 		return err;
 
+	err = kvm_arm_init_sme();
+	if (err)
+		return err;
+
 	err = kvm_arm_vmid_alloc_init();
 	if (err) {
 		kvm_err("Failed to initialize VMID allocator.\n");
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 2757833c4396..70f271aa48da 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -148,10 +148,6 @@ static int pkvm_check_pvm_cpu_features(struct kvm_vcpu *vcpu)
 	    !kvm_has_feat(kvm, ID_AA64PFR0_EL1, AdvSIMD, IMP))
 		return -EINVAL;
 
-	/* No SME support in KVM right now. Check to catch if it changes. */
-	if (kvm_has_feat(kvm, ID_AA64PFR1_EL1, SME, IMP))
-		return -EINVAL;
-
 	return 0;
 }
 
@@ -377,6 +373,11 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 		kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_GUEST_HAS_SVE);
 	}
 
+	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_SME)) {
+		set_bit(KVM_ARM_VCPU_SME, allowed_features);
+		kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_GUEST_HAS_SME);
+	}
+
 	bitmap_and(kvm->arch.vcpu_features, host_kvm->arch.vcpu_features,
 		   allowed_features, KVM_VCPU_MAX_FEATURES);
 }
@@ -391,7 +392,8 @@ static void unpin_host_sve_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	void *sve_state;
 
-	if (!vcpu_has_feature(&hyp_vcpu->vcpu, KVM_ARM_VCPU_SVE))
+	if (!vcpu_has_feature(&hyp_vcpu->vcpu, KVM_ARM_VCPU_SVE) &&
+	    !vcpu_has_feature(&hyp_vcpu->vcpu, KVM_ARM_VCPU_SME))
 		return;
 
 	sve_state = hyp_vcpu->vcpu.arch.sve_state;
@@ -399,6 +401,18 @@ static void unpin_host_sve_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 			     sve_state + vcpu_sve_state_size(&hyp_vcpu->vcpu));
 }
 
+static void unpin_host_sme_state(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	void *sme_state;
+
+	if (!vcpu_has_feature(&hyp_vcpu->vcpu, KVM_ARM_VCPU_SME))
+		return;
+
+	sme_state = kern_hyp_va(hyp_vcpu->vcpu.arch.sme_state);
+	hyp_unpin_shared_mem(sme_state,
+			     sme_state + vcpu_sme_state_size(&hyp_vcpu->vcpu));
+}
+
 static void unpin_host_vcpus(struct pkvm_hyp_vcpu *hyp_vcpus[],
 			     unsigned int nr_vcpus)
 {
@@ -412,6 +426,7 @@ static void unpin_host_vcpus(struct pkvm_hyp_vcpu *hyp_vcpus[],
 
 		unpin_host_vcpu(hyp_vcpu->host_vcpu);
 		unpin_host_sve_state(hyp_vcpu);
+		unpin_host_sme_state(hyp_vcpu);
 	}
 }
 
@@ -438,23 +453,35 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
 	mmu->pgt = &hyp_vm->pgt;
 }
 
-static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *host_vcpu)
+static int pkvm_vcpu_init_vec(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *host_vcpu)
 {
 	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
-	unsigned int sve_max_vl;
-	size_t sve_state_size;
-	void *sve_state;
+	unsigned int sve_max_vl, sme_max_vl;
+	size_t sve_state_size, sme_state_size;
+	void *sve_state, *sme_state;
 	int ret = 0;
 
-	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE)) {
+	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE) &&
+	    !vcpu_has_feature(vcpu, KVM_ARM_VCPU_SME)) {
 		vcpu_clear_flag(vcpu, VCPU_VEC_FINALIZED);
 		return 0;
 	}
 
 	/* Limit guest vector length to the maximum supported by the host. */
-	sve_max_vl = min(READ_ONCE(host_vcpu->arch.max_vl[ARM64_VEC_SVE]),
-			 kvm_host_max_vl[ARM64_VEC_SVE]);
-	sve_state_size = sve_state_size_from_vl(sve_max_vl);
+	if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE))
+		sve_max_vl = min(READ_ONCE(host_vcpu->arch.max_vl[ARM64_VEC_SVE]),
+				 kvm_host_max_vl[ARM64_VEC_SVE]);
+	else
+		sve_max_vl = 0;
+
+	if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_SME))
+		sme_max_vl = min(READ_ONCE(host_vcpu->arch.max_vl[ARM64_VEC_SME]),
+				 kvm_host_max_vl[ARM64_VEC_SME]);
+	else
+		sme_max_vl = 0;
+
+	/* We need SVE storage for the larger of normal or streaming mode */
+	sve_state_size = sve_state_size_from_vl(max(sve_max_vl, sme_max_vl));
 	sve_state = kern_hyp_va(READ_ONCE(host_vcpu->arch.sve_state));
 
 	if (!sve_state || !sve_state_size) {
@@ -466,12 +493,36 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
 	if (ret)
 		goto err;
 
+	if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_SME)) {
+		sme_state_size = sme_state_size_from_vl(sme_max_vl,
+							vcpu_has_sme2(vcpu));
+		sme_state = kern_hyp_va(READ_ONCE(host_vcpu->arch.sme_state));
+
+		if (!sme_state || !sme_state_size) {
+			ret = -EINVAL;
+			goto err_sve_mapped;
+		}
+
+		ret = hyp_pin_shared_mem(sme_state, sme_state + sme_state_size);
+		if (ret)
+			goto err_sve_mapped;
+	} else {
+		sme_state = NULL;
+	}
+
 	vcpu->arch.sve_state = sve_state;
 	vcpu->arch.max_vl[ARM64_VEC_SVE] = sve_max_vl;
 
+	vcpu->arch.sme_state = sme_state;
+	vcpu->arch.max_vl[ARM64_VEC_SME] = sme_max_vl;
+
 	return 0;
+
+err_sve_mapped:
+	hyp_unpin_shared_mem(sve_state, sve_state + sve_state_size);
 err:
 	clear_bit(KVM_ARM_VCPU_SVE, vcpu->kvm->arch.vcpu_features);
+	clear_bit(KVM_ARM_VCPU_SME, vcpu->kvm->arch.vcpu_features);
 	return ret;
 }
 
@@ -531,7 +582,7 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 	if (ret)
 		goto done;
 
-	ret = pkvm_vcpu_init_sve(hyp_vcpu, host_vcpu);
+	ret = pkvm_vcpu_init_vec(hyp_vcpu, host_vcpu);
 done:
 	if (ret)
 		unpin_host_vcpu(host_vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 06d28621722e..f21a6be65842 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -66,6 +66,11 @@ static bool vm_has_ptrauth(const struct kvm *kvm)
 		kvm_vcpu_has_feature(kvm, KVM_ARM_VCPU_PTRAUTH_GENERIC);
 }
 
+static bool vm_has_sme(const struct kvm *kvm)
+{
+	return system_supports_sme() && kvm_vcpu_has_feature(kvm, KVM_ARM_VCPU_SME);
+}
+
 static bool vm_has_sve(const struct kvm *kvm)
 {
 	return system_supports_sve() && kvm_vcpu_has_feature(kvm, KVM_ARM_VCPU_SVE);
@@ -102,6 +107,7 @@ static const struct pvm_ftr_bits pvmid_aa64pfr0[] = {
 };
 
 static const struct pvm_ftr_bits pvmid_aa64pfr1[] = {
+	MAX_FEAT_FUNC(ID_AA64PFR1_EL1, SME, SME2, vm_has_sme),
 	MAX_FEAT(ID_AA64PFR1_EL1, BT, IMP),
 	MAX_FEAT(ID_AA64PFR1_EL1, SSBS, SSBS2),
 	MAX_FEAT_ENUM(ID_AA64PFR1_EL1, MTE_frac, NI),
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index a8684a1346ec..59a6cb71ffef 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -76,6 +76,28 @@ int __init kvm_arm_init_sve(void)
 	return 0;
 }
 
+int __init kvm_arm_init_sme(void)
+{
+	if (system_supports_sme()) {
+		kvm_host_max_vl[ARM64_VEC_SME] = sme_max_vl();
+		kvm_nvhe_sym(kvm_host_max_vl[ARM64_VEC_SME]) = kvm_host_max_vl[ARM64_VEC_SME];
+	}
+
+	if (system_supports_sme_virt()) {
+		kvm_max_vl[ARM64_VEC_SME] = sme_max_virtualisable_vl();
+
+		/*
+		 * Don't even try to make use of vector lengths that
+		 * aren't available on all CPUs, for now:
+		 */
+		if (kvm_max_vl[ARM64_VEC_SME] < sme_max_vl())
+			pr_warn("KVM: SME vector length for guests limited to %u bytes\n",
+				kvm_max_vl[ARM64_VEC_SME]);
+	}
+
+	return 0;
+}
+
 static void kvm_vcpu_enable_sve(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.max_vl[ARM64_VEC_SVE] = kvm_max_vl[ARM64_VEC_SVE];
@@ -88,42 +110,90 @@ static void kvm_vcpu_enable_sve(struct kvm_vcpu *vcpu)
 	set_bit(KVM_ARCH_FLAG_GUEST_HAS_SVE, &vcpu->kvm->arch.flags);
 }
 
+static void kvm_vcpu_enable_sme(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.max_vl[ARM64_VEC_SME] = kvm_max_vl[ARM64_VEC_SME];
+
+	/*
+	 * Userspace can still customize the vector lengths by writing
+	 * KVM_REG_ARM64_SME_VLS.  Allocation is deferred until
+	 * kvm_arm_vcpu_finalize(), which freezes the configuration.
+	 */
+	set_bit(KVM_ARCH_FLAG_GUEST_HAS_SME, &vcpu->kvm->arch.flags);
+}
+
 /*
- * Finalize vcpu's maximum SVE vector length, allocating
- * vcpu->arch.sve_state as necessary.
+ * Finalize vcpu's maximum vector lengths, allocating
+ * vcpu->arch.sve_state and vcpu->arch.sme_state as necessary.
  */
 static int kvm_vcpu_finalize_vec(struct kvm_vcpu *vcpu)
 {
-	void *buf;
+	void *sve_state, *sme_state;
 	unsigned int vl;
-	size_t reg_sz;
 	int ret;
 
-	vl = vcpu->arch.max_vl[ARM64_VEC_SVE];
-
 	/*
 	 * Responsibility for these properties is shared between
 	 * kvm_arm_init_sve(), kvm_vcpu_enable_sve() and
 	 * set_sve_vls().  Double-check here just to be sure:
 	 */
-	if (WARN_ON(!sve_vl_valid(vl) || vl > sve_max_virtualisable_vl() ||
-		    vl > VL_ARCH_MAX))
-		return -EIO;
+	if (vcpu_has_sve(vcpu)) {
+		vl = vcpu->arch.max_vl[ARM64_VEC_SVE];
+		if (WARN_ON(!sve_vl_valid(vl) ||
+			    vl > sve_max_virtualisable_vl() ||
+			    vl > VL_ARCH_MAX))
+			return -EIO;
+	} else {
+		vcpu->arch.max_vl[ARM64_VEC_SVE] = 0;
+	}
 
-	reg_sz = vcpu_sve_state_size(vcpu);
-	buf = kzalloc(reg_sz, GFP_KERNEL_ACCOUNT);
-	if (!buf)
+	/* Similarly for SME */
+	if (vcpu_has_sme(vcpu)) {
+		vl = vcpu->arch.max_vl[ARM64_VEC_SME];
+		if (WARN_ON(!sve_vl_valid(vl) ||
+			    vl > sme_max_virtualisable_vl() ||
+			    vl > VL_ARCH_MAX))
+			return -EIO;
+	} else {
+		vcpu->arch.max_vl[ARM64_VEC_SME] = 0;
+	}
+
+	sve_state = kzalloc(vcpu_sve_state_size(vcpu), GFP_KERNEL_ACCOUNT);
+	if (!sve_state)
 		return -ENOMEM;
 
-	ret = kvm_share_hyp(buf, buf + reg_sz);
-	if (ret) {
-		kfree(buf);
-		return ret;
+	ret = kvm_share_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
+	if (ret)
+		goto err_sve_alloc;
+
+	if (vcpu_has_sme(vcpu)) {
+		sme_state = kzalloc(vcpu_sme_state_size(vcpu),
+				    GFP_KERNEL_ACCOUNT);
+		if (!sme_state) {
+			ret = -ENOMEM;
+			goto err_sve_map;
+		}
+
+		ret = kvm_share_hyp(sme_state,
+				    sme_state + vcpu_sme_state_size(vcpu));
+		if (ret)
+			goto err_sme_alloc;
+	} else {
+		sme_state = NULL;
 	}
-	
-	vcpu->arch.sve_state = buf;
+
+	vcpu->arch.sve_state = sve_state;
+	vcpu->arch.sme_state = sme_state;
 	vcpu_set_flag(vcpu, VCPU_VEC_FINALIZED);
 	return 0;
+
+err_sme_alloc:
+	kfree(sme_state);
+err_sve_map:
+	kvm_unshare_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
+err_sve_alloc:
+	kfree(sve_state);
+	return ret;
 }
 
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature)
@@ -153,20 +223,26 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
 void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	void *sve_state = vcpu->arch.sve_state;
+	void *sme_state = vcpu->arch.sme_state;
 
 	kvm_unshare_hyp(vcpu, vcpu + 1);
 	if (sve_state)
 		kvm_unshare_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
 	kfree(sve_state);
 	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
+	if (sme_state)
+		kvm_unshare_hyp(sme_state, sme_state + vcpu_sme_state_size(vcpu));
+	kfree(sme_state);
 	kfree(vcpu->arch.vncr_tlb);
 	kfree(vcpu->arch.ccsidr);
 }
 
 static void kvm_vcpu_reset_vec(struct kvm_vcpu *vcpu)
 {
-	if (vcpu_has_sve(vcpu))
+	if (vcpu_has_sve(vcpu) || vcpu_has_sme(vcpu))
 		memset(vcpu->arch.sve_state, 0, vcpu_sve_state_size(vcpu));
+	if (vcpu_has_sme(vcpu))
+		memset(vcpu->arch.sme_state, 0, vcpu_sme_state_size(vcpu));
 }
 
 /**
@@ -206,6 +282,8 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	if (!kvm_arm_vcpu_vec_finalized(vcpu)) {
 		if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE))
 			kvm_vcpu_enable_sve(vcpu);
+		if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_SME))
+			kvm_vcpu_enable_sme(vcpu);
 	} else {
 		kvm_vcpu_reset_vec(vcpu);
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 65500f5db379..5b502fd2bfec 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -985,6 +985,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_SEA_TO_USER 245
 #define KVM_CAP_S390_USER_OPEREXEC 246
 #define KVM_CAP_S390_KEYOP 247
+#define KVM_CAP_ARM_SME 248
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;

-- 
2.47.3


