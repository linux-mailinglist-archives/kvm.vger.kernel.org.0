Return-Path: <kvm+bounces-73130-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4APZHwAOq2nmZgEAu9opvQ
	(envelope-from <kvm+bounces-73130-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:25:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 811CF2260EF
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:25:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CBD203026068
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 17:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29D4C47F2CB;
	Fri,  6 Mar 2026 17:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lwLFFjDN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD8141325D;
	Fri,  6 Mar 2026 17:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772817089; cv=none; b=fvPS/+IfO9r1D1Q4scVlQsxGg6AJL1tKYhCFXGhverhJIOrrjna4ApfBbBd2bumy4fqZmxYHCqh058uzrU0PnHTmzC7in/KO4Ur2mzF5ZqnAelRyAjEwmoHMJ8Zo3oPlJ7thmcXNMC1IJnEn+MyR8y5hUDwy9np1UqPPmCUKS7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772817089; c=relaxed/simple;
	bh=48J6vOELlRnKwnvRZfyB0150FtcIqOvT0BA0oxdO4r8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=khuRLrif4fV6BhShxwrfgNaC/PQKXryWK23LkVWwKswns0DboF6E0XIfSRlhm84cMlN1E44N9kT5rMCxNgVoYe9/Txj2UBuOYTCng7+HESSLbCc/HnJ/yET/I09p5Sfqu/vx8QO01HE2+PaLyQ5UORtxzb2IZbid/hIZgpqXG0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lwLFFjDN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A94C2BC86;
	Fri,  6 Mar 2026 17:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817089;
	bh=48J6vOELlRnKwnvRZfyB0150FtcIqOvT0BA0oxdO4r8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=lwLFFjDNOuu1sfuYaweC0SyZJ9rrIiPS40Z2CtQ9ba4apRuHWnJiSsXWef7e5OQBu
	 tiU1Dl6vTgZATqWG6M1Gv94S0lXT4GCD8LiKW2uxB/x0SbufAVwUcZi4uuowhAMYKV
	 bKeeZee9ec+5nQKzpAFyU4DcRGGZBV4CBukzvZM7Orx15lF4lo2ONAixI7Q3lrV3q4
	 0fV6X2ETisCHyfWTfPG56TiATOOC3cQqJouFdbbsA/Fj5ccEAcnzzvmdR1FKF4m1mk
	 J6vVA2RBFTuDq9VFWQ7W54diTrayAkKV1KuOzEsh7Tza7vaDz3KGnJ+UVX3acQL+GO
	 rJj6/f/yprLWw==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 06 Mar 2026 17:01:20 +0000
Subject: [PATCH v10 28/30] KVM: arm64: selftests: Skip impossible invalid
 value tests
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kvm-arm64-sme-v10-28-43f7683a0fb7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3787; i=broonie@kernel.org;
 h=from:subject:message-id; bh=48J6vOELlRnKwnvRZfyB0150FtcIqOvT0BA0oxdO4r8=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpqwo+wHKzAuHcwdnrh2mF3OuVoFygnzjy+m5WJ
 1ySn5i4AduJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaasKPgAKCRAk1otyXVSH
 0FWcB/95h8TYFaJLtY9Mig1aiCYlIxNxOjNvHHu24TrccFxyTJ06ypfmagGF+VP5x9Pbj8n6KnU
 hdBNCUXSjBt5seAx22tcbMzTRoVaurCnYiCMWjL1+5ze7yQ4D3geNWPduq1D8OHfIrDlNjVCrEj
 FQY8J1EOeYVXQDqE9HN+oEwZ/k80twTLdA/pZP/iOYTq8ApNKmpuo3paT2MzkKUNFulB6dQuPNN
 eKjm9xweYdVRvCf4E/fA5sgqxWen6AVTuA+IuGjwdm0zsw8HSP2rdK3XYxVRsvUiMj+CsWGGofP
 h3ItgX/Qu1x/b9e4qrGcczWSkDFV1SNEQWmn/eIM5tGtZcOv
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Queue-Id: 811CF2260EF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73130-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.913];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

The set_id_regs test currently assumes that there will always be invalid
values available in bitfields for it to generate but this may not be the
case if the architecture has defined meanings for every possible value for
the bitfield. An assert added in commit bf09ee918053e ("KVM: arm64:
selftests: Remove ARM64_FEATURE_FIELD_BITS and its last user") refuses to
run for single bit fields which will show the issue most readily but there
is no reason wider ones can't show the same issue.

Rework the tests for invalid value to check if an invalid value can be
generated and skip the test if not, removing the assert.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 63 +++++++++++++++++++++----
 1 file changed, 53 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index bfca7be3e766..928e7d9e5ab7 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -317,11 +317,12 @@ uint64_t get_safe_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
 }
 
 /* Return an invalid value to a given ftr_bits an ftr value */
-uint64_t get_invalid_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
+uint64_t get_invalid_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr,
+			   bool *skip)
 {
 	uint64_t ftr_max = ftr_bits->mask >> ftr_bits->shift;
 
-	TEST_ASSERT(ftr_max > 1, "This test doesn't support single bit features");
+	*skip = false;
 
 	if (ftr_bits->sign == FTR_UNSIGNED) {
 		switch (ftr_bits->type) {
@@ -329,42 +330,81 @@ uint64_t get_invalid_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
 			ftr = max((uint64_t)ftr_bits->safe_val + 1, ftr + 1);
 			break;
 		case FTR_LOWER_SAFE:
+			if (ftr == ftr_max)
+				*skip = true;
 			ftr++;
 			break;
 		case FTR_HIGHER_SAFE:
+			if (ftr == 0)
+				*skip = true;
 			ftr--;
 			break;
 		case FTR_HIGHER_OR_ZERO_SAFE:
-			if (ftr == 0)
+			switch (ftr) {
+			case 0:
 				ftr = ftr_max;
-			else
+				break;
+			case 1:
+				*skip = true;
+				break;
+			default:
 				ftr--;
+				break;
+			}
 			break;
 		default:
+			*skip = true;
 			break;
 		}
 	} else if (ftr != ftr_max) {
 		switch (ftr_bits->type) {
 		case FTR_EXACT:
 			ftr = max((uint64_t)ftr_bits->safe_val + 1, ftr + 1);
+			if (ftr >= ftr_max)
+				*skip = true;
 			break;
 		case FTR_LOWER_SAFE:
 			ftr++;
 			break;
 		case FTR_HIGHER_SAFE:
-			ftr--;
+			/* FIXME: "need to check for the actual highest." */
+			if (ftr == ftr_max)
+				*skip = true;
+			else
+				ftr--;
 			break;
 		case FTR_HIGHER_OR_ZERO_SAFE:
-			if (ftr == 0)
-				ftr = ftr_max - 1;
-			else
+			switch (ftr) {
+			case 0:
+				if (ftr_max > 1)
+					ftr = ftr_max - 1;
+				else
+					*skip = true;
+				break;
+			case 1:
+				*skip = true;
+				break;
+			default:
 				ftr--;
+				break;
+			}
 			break;
 		default:
+			*skip = true;
 			break;
 		}
 	} else {
-		ftr = 0;
+		switch (ftr_bits->type) {
+		case FTR_LOWER_SAFE:
+			if (ftr == 0)
+				*skip = true;
+			else
+				ftr = 0;
+			break;
+		default:
+			*skip = true;
+			break;
+		}
 	}
 
 	return ftr;
@@ -399,12 +439,15 @@ static void test_reg_set_fail(struct kvm_vcpu *vcpu, uint64_t reg,
 	uint8_t shift = ftr_bits->shift;
 	uint64_t mask = ftr_bits->mask;
 	uint64_t val, old_val, ftr;
+	bool skip;
 	int r;
 
 	val = vcpu_get_reg(vcpu, reg);
 	ftr = (val & mask) >> shift;
 
-	ftr = get_invalid_value(ftr_bits, ftr);
+	ftr = get_invalid_value(ftr_bits, ftr, &skip);
+	if (skip)
+		return;
 
 	old_val = val;
 	ftr <<= shift;

-- 
2.47.3


