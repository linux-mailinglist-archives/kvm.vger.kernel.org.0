Return-Path: <kvm+bounces-73127-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eKThBn4Mq2k/ZgEAu9opvQ
	(envelope-from <kvm+bounces-73127-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:18:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A34D0225D5D
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:18:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4C30B3132D35
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 17:13:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC2B247D925;
	Fri,  6 Mar 2026 17:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U9eXInAq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE00410D3A;
	Fri,  6 Mar 2026 17:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772817076; cv=none; b=AhZ93k9jSqfYZKqMosys8ul7NlAykW9vVwwixqngEKcPcU8kTr2iKcp9s6P6rVmrR+cxpCb5D8ZkCvYtJKyMTYCQlObcgx2V2FxV686/Wf4eEHDcueOcrIMq8IPyZa9X68bL0wQefwZtdIrdguVyAkcSeb5gQDxKWJlJ5aQ2AoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772817076; c=relaxed/simple;
	bh=9AoDP1H4yvRJIEhTi6n9tn6RUHS9VgzCYqCyyE7TlDQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Cs9oGRA/mLHhICwngUTpSgsY3/COoOGYG5lbZ4zCBvlJdkEQjnQJJKMLaaKuQAlO9Nw4I0IBuC/HenAZoWwQYcPmA0C/hPL1h18i9+fw/0ksZHng+MIa+uV2fOUfiKDQBikV/YimZjT77f+nuQRINpxrWSOokY02D24VNsVRnVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U9eXInAq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE467C4CEF7;
	Fri,  6 Mar 2026 17:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817075;
	bh=9AoDP1H4yvRJIEhTi6n9tn6RUHS9VgzCYqCyyE7TlDQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=U9eXInAq6PsnJKF4xNWxt6HMYo7q/Ik/qmUHsWJc5gdGs5DmM2lDRmBzFbKU+97LK
	 PYmTWkZzqMPW6rHVeYbOwOV4yonZzgBKZBOxz6wi+nUL2EKnle4L7P4/mg1AhsMx25
	 xIvpDRdjtZ4xWTOMIiFqCyygM0KXBeQJLo84NbvJ4IFrqxTRW76bT/SPyg6P+s2MT1
	 BwA+tY/0PBQqWiikpb7WZRM7pFbwg8BsD3WQHOEEz0IIgIeI8BiYcgj8SmU8jm+FLF
	 AI5xAz8ix1CnhxZHCbjxC1Dk4XEjHM7h/d+0tWXjrCqHXUqcp1pN1cYTU6S/9Yz3zY
	 xrI6L67qRsE+w==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 06 Mar 2026 17:01:17 +0000
Subject: [PATCH v10 25/30] KVM: arm64: Expose SME to nested guests
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kvm-arm64-sme-v10-25-43f7683a0fb7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1452; i=broonie@kernel.org;
 h=from:subject:message-id; bh=9AoDP1H4yvRJIEhTi6n9tn6RUHS9VgzCYqCyyE7TlDQ=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpqwo8SGPszNhvztYIvDOCtpWiaiaB+98YQbEDr
 eOW1XPeuIiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaasKPAAKCRAk1otyXVSH
 0GWxB/9Cu9zVjHVSP0M7G5dJXH/040q4ZjiItij2oocAWBOf4nwWUab+WPXOw32G6SHWIOX8Bkx
 elPX0VunIxTX2TMNP15U5YU+GNdWbG9x9t/hjnQ75Z1jJCOqxc/uixUjGipKDOkrVV7gFAeATv3
 T07TBZRm+SCJs9uUt4HC6DyQ3jZE0CXGBhBf96xL+TAdO5FRTkw+ZSvT0diWnYc32y0DLPciKGG
 nMN10SjIlTd292CD3GLuAEsPdyiGNjzQ4+fc8Rqct/JQL/bFF6mPRPhW/zXZcLwYSNH/EIfd6hL
 /8cBWedrr9rAa7eRWv12ECW5wdSfZ+67R0HqU5MKPCvO77HS
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Queue-Id: A34D0225D5D
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
	TAGGED_FROM(0.00)[bounces-73127-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.920];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

With support for context switching SME state in place allow access to SME
in nested guests.

The SME floating point state is handled along with all the other floating
point state, SME specific floating point exceptions are directed into the
same handlers as other floating point exceptions with NV specific handling
for the vector lengths already in place.

TPIDR2_EL0 is context switched along with the other TPIDRs as part of the
main guest register context switch.

SME priority support is currently masked from all guests including nested
ones.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/nested.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 12c9f6e8dfda..a46002004988 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1540,14 +1540,13 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		break;
 
 	case SYS_ID_AA64PFR1_EL1:
-		/* Only support BTI, SSBS, CSV2_frac */
+		/* Only support BTI, SME, SSBS, CSV2_frac */
 		val &= ~(ID_AA64PFR1_EL1_PFAR		|
 			 ID_AA64PFR1_EL1_MTEX		|
 			 ID_AA64PFR1_EL1_THE		|
 			 ID_AA64PFR1_EL1_GCS		|
 			 ID_AA64PFR1_EL1_MTE_frac	|
 			 ID_AA64PFR1_EL1_NMI		|
-			 ID_AA64PFR1_EL1_SME		|
 			 ID_AA64PFR1_EL1_RES0		|
 			 ID_AA64PFR1_EL1_MPAM_frac	|
 			 ID_AA64PFR1_EL1_MTE);

-- 
2.47.3


