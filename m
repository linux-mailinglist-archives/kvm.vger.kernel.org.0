Return-Path: <kvm+bounces-73129-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ULVNORUNq2nCZgEAu9opvQ
	(envelope-from <kvm+bounces-73129-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:21:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 56240225EE2
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:21:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 389E53142CA8
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 17:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 989E747ECC9;
	Fri,  6 Mar 2026 17:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gghwR0a7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C856341C2F7;
	Fri,  6 Mar 2026 17:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772817084; cv=none; b=Ky9JtJQOk9PhSTmgU19gpjkN5Twbw0GNsa+tUB8kuwQ4QJBKUuXn4N3ybz57hpZgYMtQm4gqem3ywMpCOLBzfz8QTAukpRaOnRu6eMNOXgpPSiEakoWBGgpcnosUPNA7zqzklt+fm88LWRH/GB1jaExKdzaQ2IcXhFlmT3UHCdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772817084; c=relaxed/simple;
	bh=RwM0lvASFFISwO7mYlHziW2rJGO2q+5K2S9ANJKi+qk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ag/kDQK8WtYoYWzva0AKjb7qdkQAR+0aqO+gvzQzQ5zSs+3I5ER5DLbpofmL4SHlzmpDtwONv3JER1bcgZDYl9/Ly5gYeibseOveeHDLDmd4MXaxdeUW1fsJv92HbIXdpTIbAibz3UrhGmvAdIiWT5e14ocO2l4be2krxsvlc50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gghwR0a7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C13C4CEF7;
	Fri,  6 Mar 2026 17:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817084;
	bh=RwM0lvASFFISwO7mYlHziW2rJGO2q+5K2S9ANJKi+qk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=gghwR0a71jnooATMBX5TocY5duhVClWj7zPggZHjAaCF9uD8eCRsCrOQAJlx+x/OT
	 uHanDt7NRGLoKkO+KfOu0nyqwdlm4MDxs37uVWkg2LU3uuF0sdoFnqWbEHvAhgQx1p
	 6vBq5t1oqEKubYFosSdVNmUuOdOABEuN6cvPaMYpBtqvF9Rl9xrCUHNRNdEN/9ULKI
	 gjJaV54ad0W5IiG2Zz8wYBleVVNJmDNrDox+4phWDR26vRLR/omreN1J0uXx4xDT+O
	 ist0zJH3f8lZRe+oeIk8tzxjZEvMnAtM++KDHMggpBX/e+LrmoWsUyn0w0dtz3rIUn
	 +UQJlqcONXeAw==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 06 Mar 2026 17:01:19 +0000
Subject: [PATCH v10 27/30] KVM: arm64: selftests: Remove spurious check for
 single bit safe values
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kvm-arm64-sme-v10-27-43f7683a0fb7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1215; i=broonie@kernel.org;
 h=from:subject:message-id; bh=RwM0lvASFFISwO7mYlHziW2rJGO2q+5K2S9ANJKi+qk=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpqwo9khSGDEm4RKpWoYkjMo875PXE5ezoRFH8g
 p77Xmqp8JeJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaasKPQAKCRAk1otyXVSH
 0Dc6B/4+xlyIn14vonZiqCu0iFWQPdpktw/K1mXbtG5oUfy1UaOU9VoAgvFwbAmJCJZ6DiB3nm3
 uqcfCqwuig8fEMuQcNEvik2VEoSahN2ujQaT2mu5t4y0A3d+sLzNxIayT2d65CAsRnO6NpYNcit
 gLf5qkvYsJcpi6AYMoyv6IW4GHeS5eZtZQTLD9MiTYDkz4b5VKJ8I8nlDZEETr3ejG+EiLyc4u9
 L2c/msSkXv4kQh7PKbP84zA77Rvg1GKyYRW6KSXbx+G28Qp6SXigjf+wlM88FIEw7PtmWgdsaHl
 4+5wobzSg4n0fNJdyDKFlvLAUV2KdmOCz7BfQ3VBc8kVyh7n
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Queue-Id: 56240225EE2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73129-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.908];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

get_safe_value() currently asserts that bitfields it is generating a safe
value for must be more than one bit wide but in actual fact it should
always be possible to generate a safe value to write to a bitfield even if
it is just the current value and the function correctly handles that.
Remove the assert.

Fixes: bf09ee918053e ("KVM: arm64: selftests: Remove ARM64_FEATURE_FIELD_BITS and its last user")
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 73de5be58bab..bfca7be3e766 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -269,8 +269,6 @@ uint64_t get_safe_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
 {
 	uint64_t ftr_max = ftr_bits->mask >> ftr_bits->shift;
 
-	TEST_ASSERT(ftr_max > 1, "This test doesn't support single bit features");
-
 	if (ftr_bits->sign == FTR_UNSIGNED) {
 		switch (ftr_bits->type) {
 		case FTR_EXACT:

-- 
2.47.3


