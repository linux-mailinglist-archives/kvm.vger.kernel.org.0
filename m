Return-Path: <kvm+bounces-73121-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UJl8K78Mq2k/ZgEAu9opvQ
	(envelope-from <kvm+bounces-73121-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:19:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id AE44F225E4F
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:19:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9D03A3010686
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 17:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 770EB438FE5;
	Fri,  6 Mar 2026 17:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ur84VoZD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CB5411632;
	Fri,  6 Mar 2026 17:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772817049; cv=none; b=KJc5Jv7drh1GR+5Lc2W/8zFadMFu3GR0tKah3YFmEGzcIv108/w+GHFKXXvJVUS3UAE7E/YvM8DG8ld6z3oN1x93xHXcz95b2SGkJYwSdQyi5F4FEeIClw7+mhHgIWXZRXwsZO8QTM81fmdiPvbzjPyd3mYHQVh8A6qciMXIsOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772817049; c=relaxed/simple;
	bh=FRT5fvZBAIjhBya7YWT00dc/V832oYejWRmRw40AVzI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jmDzboijrbdUg5/deGp2HS3mu/7wMJb1bgn77mH6jCqKdSeB2EY+1eX19bNnYGqjzZR3pssqAeASIFScK4RFEO1JQEFHsIkllY7oKC6sXqJu7yFrOorQBghGQGw2owqb/hgOkuWqEIKcm7nT1Iu25sWc/eKDdly38krJqPdeMs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ur84VoZD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A08C2BC86;
	Fri,  6 Mar 2026 17:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817049;
	bh=FRT5fvZBAIjhBya7YWT00dc/V832oYejWRmRw40AVzI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Ur84VoZDL/fO63PzSYfda/mG6D0R5ZDsnoNC2C9NQ5WzePtWOzgSLqbZXUnWChUD+
	 BR4CZipry7nSHfZ3gjPzLXwMeCFkuaozJ1H+Js4v/GOqifoWmeQjQwK/86c3enOyL3
	 Y+wm9xMgOJi3K/8R7Dtlygt4699GcO9rWNAHv6vmu7SDYmkegudPSXtzfUOiIeu0o/
	 GdCL3ANPzvYhj/+OVxFNlCgYSwrq9CIgoBf1ZXy/zLhkDy0Lq4wmt9KXFK0mX/Vpuw
	 aVZe95boI/eA5KqOtWzOJHdegAdKrIPFhvqRB8OOS5RrkAaVp/Exj/ZcePtud6ucnU
	 qc+DgFQazSYJg==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 06 Mar 2026 17:01:11 +0000
Subject: [PATCH v10 19/30] KVM: arm64: Provide assembly for SME register
 access
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kvm-arm64-sme-v10-19-43f7683a0fb7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1838; i=broonie@kernel.org;
 h=from:subject:message-id; bh=FRT5fvZBAIjhBya7YWT00dc/V832oYejWRmRw40AVzI=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpqwo3M4fBMa89wgAteKP42mDicIN04q1U64tmn
 W/8erSVjL+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaasKNwAKCRAk1otyXVSH
 0DUlB/sGo724WMwO3Na+9JbUGzTipVpyGlj5U0MlKsI71IC0IicVW7UL0M+cgKnxRHbhm5Wl0C+
 2e0A4I/aGK9tDVOAeoC6E9V0lVAnStY5fKeh1MFNJMJbwtoj4GrnqvCnwWbUd4Sh0ZNsmwryXq2
 M9oPODPl4I4EF9AKnOZ4kUZe98wYJwhlrTkn40wtgovae6Gfhhazz0UULOJDn1ViaFAlT3oKQ45
 qDfwhb2Ypd7zyJznPNyFJ5yfdjRFbInqX03T3Ihr3RM/sdtZqGkd5VPLUAo3coZF98leTkkwqQo
 zvWL/HLwAz7M/Nt5qinv/vbvZZ3eovGqftUWamBmLU9tcA0q
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Queue-Id: AE44F225E4F
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
	TAGGED_FROM(0.00)[bounces-73121-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.908];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

Provide versions of the SME state save and restore functions for the
hypervisor to allow it to restore ZA and ZT for guests.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h |  2 ++
 arch/arm64/kvm/hyp/fpsimd.S      | 23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 0317790dd3b7..9b1354d1122c 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -116,6 +116,8 @@ void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
 void __sve_save_state(void *sve_pffr, u32 *fpsr, int save_ffr);
 void __sve_restore_state(void *sve_pffr, u32 *fpsr, int restore_ffr);
+void __sme_save_state(void const *state, bool save_zt);
+void __sme_restore_state(void const *state, bool restore_zt);
 
 u64 __guest_enter(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
index 6e16cbfc5df2..18b7a666016c 100644
--- a/arch/arm64/kvm/hyp/fpsimd.S
+++ b/arch/arm64/kvm/hyp/fpsimd.S
@@ -29,3 +29,26 @@ SYM_FUNC_START(__sve_save_state)
 	sve_save 0, x1, x2, 3
 	ret
 SYM_FUNC_END(__sve_save_state)
+
+SYM_FUNC_START(__sme_save_state)
+	// Caller needs to ensure SMCR updates are visible
+	_sme_rdsvl	2, 1		// x2 = VL/8
+	sme_save_za 0, x2, 12		// Leaves x0 pointing to the end of ZA
+
+	cbz	x1, 1f
+	_str_zt 0
+1:
+	ret
+SYM_FUNC_END(__sme_save_state)
+
+SYM_FUNC_START(__sme_restore_state)
+	// Caller needs to ensure SMCR updates are visible
+	_sme_rdsvl	2, 1		// x2 = VL/8
+	sme_load_za	0, x2, 12	// Leaves x0 pointing to end of ZA
+
+	cbz	x1, 1f
+	_ldr_zt 0
+
+1:
+	ret
+SYM_FUNC_END(__sme_restore_state)

-- 
2.47.3


