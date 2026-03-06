Return-Path: <kvm+bounces-73106-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uO75J2oLq2k/ZgEAu9opvQ
	(envelope-from <kvm+bounces-73106-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:14:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F291B225C0D
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:14:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 41144314C834
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 17:09:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DFDE40FDB7;
	Fri,  6 Mar 2026 17:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y2Z2u0cf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE053ED5A7;
	Fri,  6 Mar 2026 17:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772816983; cv=none; b=CApIAIGaWlbKZhIPjlARmHFYqVVdVWhsXR0o4j66yQEjFXzU7eNT8e+JrJab43S7wPjJypUlQxWKR0YQkV0yzPzr3oHpjcyQQMeOHyOBgfJZrCZl6ajexytcWGRQHG3ipSLbCt9TljxiDMK8l6pAoQwpgaQI8b8JnuDoH1FYt+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772816983; c=relaxed/simple;
	bh=sxGE8ds7O7e2xiqhxdLSPHlYvj4uo9nY+mVtuvgP/7Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aDBlIxD6DMCpZQNvJl45NQagCxXr7WiHHd29PU9WE1y8V8NyU/FhjkWdxT3dSU+Ui+JBCYbN2+M+jz7+7q+GFyfBQNBJ+LRi+rmp94E4cwPhpHp+QlIIMul4WwFA433oAUvppX4UdRBOUi21ELphrvMIzMItieoj5UfTP7D4JJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y2Z2u0cf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDF6C2BCB3;
	Fri,  6 Mar 2026 17:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772816982;
	bh=sxGE8ds7O7e2xiqhxdLSPHlYvj4uo9nY+mVtuvgP/7Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Y2Z2u0cfWixgxUHkakeXFpwx2rRQQ060MUQV/HtgY0/WPCC8pAIr9c831ZLfYfTkR
	 dsFmYToYkUZdwBugz3YJufa/tu4u0uNNQrOIiYZRj+bEpV6DBWmb7zOWtiwJ4/vfmj
	 n/cRNtCJapIa8Ni3tHJRYh5utp8FD+wdVz8G4S1pmc72vFu4STp4Hv7AyJ3120D7S8
	 0LIxxMOVKgG1PUyILsHovKvbHT8Oyz3/0RBuIHmb0GDh2+gIaOsQlMXpdofIP+Eop8
	 eZe0YyhNzNFCFnXFaQ1xYLvWEp5IKhY6v0zZcuHcpOieggeKCXiC51UUta+Pmair7p
	 2jHlsD/CeYYFA==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 06 Mar 2026 17:00:56 +0000
Subject: [PATCH v10 04/30] arm64/fpsimd: Determine maximum virtualisable
 SME vector length
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kvm-arm64-sme-v10-4-43f7683a0fb7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2807; i=broonie@kernel.org;
 h=from:subject:message-id; bh=sxGE8ds7O7e2xiqhxdLSPHlYvj4uo9nY+mVtuvgP/7Y=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpqwor0zNBUzB9WNxy4RgcdBBPLU7P1PPQxFqYF
 6wVUbMPFnuJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaasKKwAKCRAk1otyXVSH
 0CXWB/oDaxzGIoAF7C6ZU1ssTeUidjJB1twTqQ6/6Wm38rt2CX4D5G5FP217toFJybD2sadvy/u
 M8akLGgOI95eUfOA5nluGwDGRB4Ry+2rzGJCxgidUmPzeExMkls9UFU+OlCp2333wy24399YDtD
 ProNtda5Ahobw7kErxQ5PKZXn9wOm+R3d0+M4EeioNzMO/NzPn51OXetLA/hstwBBy0caMB9LDD
 eq4BFlZFTmnfNrhMytwIqliDuDpBFm6lBprrKPqsnWTTPoguOli53Lxx4iWFNDfnil277UQlvuB
 ZlCVXWklzMQzPh1oBiblUjyUqFmEqvJN8nBoMWam7kAfw5iI
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Queue-Id: F291B225C0D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73106-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[broonie@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.914];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

As with SVE we can only virtualise SME vector lengths that are supported by
all CPUs in the system, implement similar checks to those for SVE. Since
unlike SVE there are no specific vector lengths that are architecturally
required the handling is subtly different, we report a system where this
happens with a maximum vector length of SME_VQ_INVALID.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h |  2 ++
 arch/arm64/kernel/fpsimd.c      | 21 ++++++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index e97729aa3b2f..0cd8a866e844 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -69,6 +69,8 @@ static inline void cpacr_restore(unsigned long cpacr)
 #define ARCH_SVE_VQ_MAX ((ZCR_ELx_LEN_MASK >> ZCR_ELx_LEN_SHIFT) + 1)
 #define SME_VQ_MAX	((SMCR_ELx_LEN_MASK >> SMCR_ELx_LEN_SHIFT) + 1)
 
+#define SME_VQ_INVALID	(SME_VQ_MAX + 1)
+
 struct task_struct;
 
 extern void fpsimd_save_state(struct user_fpsimd_state *state);
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 2af0e0c5b9f4..49c050ef6db9 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1218,7 +1218,8 @@ void cpu_enable_sme(const struct arm64_cpu_capabilities *__always_unused p)
 void __init sme_setup(void)
 {
 	struct vl_info *info = &vl_info[ARM64_VEC_SME];
-	int min_bit, max_bit;
+	DECLARE_BITMAP(tmp_map, SVE_VQ_MAX);
+	int min_bit, max_bit, b;
 
 	if (!system_supports_sme())
 		return;
@@ -1249,12 +1250,30 @@ void __init sme_setup(void)
 	 */
 	set_sme_default_vl(find_supported_vector_length(ARM64_VEC_SME, 32));
 
+	bitmap_andnot(tmp_map, info->vq_partial_map, info->vq_map,
+		      SVE_VQ_MAX);
+
+	b = find_last_bit(tmp_map, SVE_VQ_MAX);
+	if (b >= SVE_VQ_MAX)
+		/* All VLs virtualisable */
+		info->max_virtualisable_vl = sve_vl_from_vq(ARCH_SVE_VQ_MAX);
+	else if (b == SVE_VQ_MAX - 1)
+		/* No virtualisable VLs */
+		info->max_virtualisable_vl = sve_vl_from_vq(SME_VQ_INVALID);
+	else
+		info->max_virtualisable_vl = sve_vl_from_vq(__bit_to_vq(b +  1));
+
 	pr_info("SME: minimum available vector length %u bytes per vector\n",
 		info->min_vl);
 	pr_info("SME: maximum available vector length %u bytes per vector\n",
 		info->max_vl);
 	pr_info("SME: default vector length %u bytes per vector\n",
 		get_sme_default_vl());
+
+	/* KVM decides whether to support mismatched systems. Just warn here: */
+	if (info->max_virtualisable_vl < info->max_vl ||
+	    info->max_virtualisable_vl == sve_vl_from_vq(SME_VQ_INVALID))
+		pr_warn("SME: unvirtualisable vector lengths present\n");
 }
 
 void sme_suspend_exit(void)

-- 
2.47.3


