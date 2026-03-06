Return-Path: <kvm+bounces-73107-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WDzNEZALq2k/ZgEAu9opvQ
	(envelope-from <kvm+bounces-73107-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:14:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A2B3225C2F
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:14:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 94A653167056
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 17:09:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FEE8401484;
	Fri,  6 Mar 2026 17:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KLSmqjF3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69B2301016;
	Fri,  6 Mar 2026 17:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772816987; cv=none; b=liIkWL0ecgIwgZEvtyPsYVD806ChLoNpvet5C/BRWgSH4aw28abpE1Iitp1sD9GHNJDZCzIVRwvEqGYyf+cM3LaJ67LuhICCPI2bbNJqSxhD6KvjpfQaFg1+2Ze5Uu8icPxcxUO1gqlmBjSVE+auxtJNin0dFXFxcnXgWNoHkbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772816987; c=relaxed/simple;
	bh=G+7uwco+cJxxYiPrDD2VSLQyEnMR+uK7i7CR96riimI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gntxQy6iScaRTth9PBbA4tyx8lJwqug9zCvT1MHz2mGZyFaWSEJdBzViEKL2Uv9aQDrul2MykXVhuFd6dNe8dP5BiJ0jAytiiBdWgn01YkVRbcy/BjteaWTqNjtJjkcYRVS3mCaM5LBn0Am5EAgJwL6/4jmNdDKgqKSNw5attNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KLSmqjF3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F587C2BC86;
	Fri,  6 Mar 2026 17:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772816987;
	bh=G+7uwco+cJxxYiPrDD2VSLQyEnMR+uK7i7CR96riimI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KLSmqjF3zu/Hq+cmUv/6o3saOiwTxdRmNIX5mEX0yS+E8nQem2rqUvQjUFcRRo4Dc
	 /c3Fl12ugWO0CrUDJFBT1uCHOCZu36EEGSUtfJVqH41hmBq/pkTgYEKLbxhZDCVEVQ
	 Ni0ZNACJpPsYUpDaWjeuJXyMk2fDrUff8Wv4JxmYMLxSkrgVEEW50P7T8gmUo26BDb
	 HWBcQMLaLbs26PboNYY+hcDQ7wT0JNJ0u+pMlCPP0OmCs3FQkxkWpKZajoha9HwD6X
	 wBT1dnVV3lL3NoAmrcWqbmWigzaENpGSCxzaWpoZsIEyLgoUBVAn6Wwa/huY72dR7Z
	 x2m4Y0riGtK1Q==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 06 Mar 2026 17:00:57 +0000
Subject: [PATCH v10 05/30] KVM: arm64: Pay attention to FFR parameter in
 SVE save and load
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kvm-arm64-sme-v10-5-43f7683a0fb7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1072; i=broonie@kernel.org;
 h=from:subject:message-id; bh=G+7uwco+cJxxYiPrDD2VSLQyEnMR+uK7i7CR96riimI=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpqwosR2hPZbMXVk/Ddq+Vv8nfNrmuk16HWkT3n
 gdWq0P4Cz2JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaasKLAAKCRAk1otyXVSH
 0HcMB/4qfwyGeSaC48mPdYWl/NRMAL9TBWIkgLGfmprEZMugcBQr/IZzXfSgjje6tzteESpv2xZ
 5rb6hifu0/CSMQSY55uyRk+qSxThb/mAkfYdY9WwtTLrB6dCF0x7loc+8Htr7setZEy6ffMeiX9
 KvcEhG/CKZOJlobmuKPq0rwDKA8zQ7y2IFxlxB5GqWDvwZZvTpdrNuWYo3E5ytMXjjy8fnA2daJ
 CJ/hJpLidcZHZCxrI8EkxSfX6y6HwAMwf1akh2ljY/G6AY1E+pRNAAjHMEs3beyBn76/rvMJx/+
 JEgC8hzcC8U0AUHiGXBPwQEBWI/xSv9AlucE3qDGJ624i02l
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Queue-Id: 8A2B3225C2F
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
	TAGGED_FROM(0.00)[bounces-73107-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.917];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

The hypervisor copies of the SVE save and load functions are prototyped
with third arguments specifying FFR should be accessed but the assembly
functions overwrite whatever is supplied to unconditionally access FFR.
Remove this and use the supplied parameter.

This has no effect currently since FFR is always present for SVE but will
be important for SME.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/hyp/fpsimd.S | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
index e950875e31ce..6e16cbfc5df2 100644
--- a/arch/arm64/kvm/hyp/fpsimd.S
+++ b/arch/arm64/kvm/hyp/fpsimd.S
@@ -21,13 +21,11 @@ SYM_FUNC_START(__fpsimd_restore_state)
 SYM_FUNC_END(__fpsimd_restore_state)
 
 SYM_FUNC_START(__sve_restore_state)
-	mov	x2, #1
 	sve_load 0, x1, x2, 3
 	ret
 SYM_FUNC_END(__sve_restore_state)
 
 SYM_FUNC_START(__sve_save_state)
-	mov	x2, #1
 	sve_save 0, x1, x2, 3
 	ret
 SYM_FUNC_END(__sve_save_state)

-- 
2.47.3


