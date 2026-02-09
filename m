Return-Path: <kvm+bounces-70657-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YPoCG6Zjiml6JwAAu9opvQ
	(envelope-from <kvm+bounces-70657-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 23:45:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C4B1D115347
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 23:45:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6F18C3067062
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 22:41:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F2F2326D44;
	Mon,  9 Feb 2026 22:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NnzDkZsd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983D13191A2
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 22:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770676857; cv=none; b=BfLJGNXuwdTKUvHdFZGD9iKeVbA5LSU9KBxDEVwGf0t41GyubHuTY72bH38z8oK8hxizmKPPUdN07sq1IAq1UqUVS8Zz+ttfjSe5fGp8Me9pyVwVMPp23dmaI359i+39na88H7qxNxOhRuQGN5+4HD4TckV3gLTvwnm5lP/wwGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770676857; c=relaxed/simple;
	bh=B9HZV/XvGCtJKEIzSCyXAxqSnw0EEFic83RP1XipC3Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mvv81VnUSt5V0i0xDx+xD97kf0qx6L3H1rB4pnMKQWH6mFDD4f7sD2ltvKzot/G32kqjNm/ph3v/61CrrGcFL3UHTkQX69JVED6LfP9eElCpQ8rPVkD+FHNq0GV67CeQxzkVhoWjzc07sJbjXP0GPdLeC2lR91Aa/2b0X2A6ei8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NnzDkZsd; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-66ae8dc8e36so13653339eaf.1
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 14:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770676852; x=1771281652; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nily0rEh3mmY4uvAeTjqDVW7kEcYRK1QYtsSJT+aPhk=;
        b=NnzDkZsdRLMTlHa1swP5Z/JorSQFqooN1864sOw2+uAjnPSBEswKJaMg8TA+qw52ye
         MpOnat3IAmj/gBBsPdM1dBaEvdKS32+Dm80ECCaL1tcby+2ksjylQ9XIAXYbIiDbBu5X
         7JzB+lgSgl4NPkMD+Qj3odeKBGp6FjqhzJ8hYlOhnwUbeUNoVZ/k+AbYveWeMCOlkcqF
         KprLqhMyPqQt9DAr7O8cZod1P0vLamAuVywNZyX958GK0fVU8U0igL4u9uVFjl+wcQrI
         eS1mZ159iT2LPJXOKSJhbYP9d+giiwI4/IrgteNWXIC8OF13nOLeA0VgDm1fFZ5A2Bwa
         dUeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770676852; x=1771281652;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nily0rEh3mmY4uvAeTjqDVW7kEcYRK1QYtsSJT+aPhk=;
        b=YJhNqdjgPikTFYe3QmQZ25a/xB9oJD7TAUD6PH8Yyn8egfsYy5T6fPmQ1XlbomeD8l
         dVo9v3NP0312pr+rGeyDIowT2/EBFrbAKGQ7lRjTvBocyn+FdvuBDWQU3KstJpFJYPch
         Z9CGLRpZmlyTdgQceTB4KMeC4YWTeNXf0ym1wa0AlToKD4sTdCb9SNJbQBcXnQ467zBq
         ZX8627fx98MUU5uo2xsWEXquAj9PlebKkXREutsy4e7upHLIBqg7yorrMtQQ+Z541LRA
         aIlIcdKjz14WoR1jlhIOlaz7WFnehL2kE7SERdD3iOcEYWZyJNvi2kJNjuBB6eWLtttY
         kIvw==
X-Gm-Message-State: AOJu0Yy36tQL3jGdyexpvNoYzF5XGQ4b5y+x7zHqVoEJA9Wo+P8mROVk
	aDz7unsU6pGckG3u37VzYlzy8j8cqbq0c29zi3X7iWmy/NprcKxa8KYyiXWmRBzCsAojqlMRsNM
	8l4g5TAcVmlLLbNPClcGkPoczZ7jhM4eERVzBCfJZqooEdgwWdGwqwdK+PVVp2X7KDCGy5x7ikR
	Ojz4V+/iA+8C5CukbKm/htzNUN5vPwdsTCTqqWqdbOQdkt0mV8JTH6JgQPwkw=
X-Received: from iobbx7.prod.google.com ([2002:a05:6602:4187:b0:957:50e1:3858])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a4a:e902:0:b0:66f:6d5e:76c3 with SMTP id 006d021491bc7-672fff0af95mr60439eaf.42.1770676852384;
 Mon, 09 Feb 2026 14:40:52 -0800 (PST)
Date: Mon,  9 Feb 2026 22:14:03 +0000
In-Reply-To: <20260209221414.2169465-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260209221414.2169465-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260209221414.2169465-9-coltonlewis@google.com>
Subject: [PATCH v6 08/19] KVM: arm64: Define access helpers for PMUSERENR and PMSELR
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[23];
	TAGGED_FROM(0.00)[bounces-70657-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[coltonlewis@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C4B1D115347
X-Rspamd-Action: no action

In order to ensure register permission checks will have consistent
results whether or not the PMU is partitioned, define some access
helpers for PMUSERENR and PMSELR that always return the canonical
value for those registers, whether it lives in a physical or virtual
register.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu.c      | 16 ++++++++++++++++
 arch/arm64/kvm/sys_regs.c |  6 +++---
 include/kvm/arm_pmu.h     | 12 ++++++++++++
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 74a5d35edb244..344ed9d8329a6 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -885,3 +885,19 @@ u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 
 	return u64_replace_bits(pmcr, n, ARMV8_PMU_PMCR_N);
 }
+
+u64 kvm_vcpu_read_pmselr(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vcpu_pmu_is_partitioned(vcpu))
+		return read_sysreg(pmselr_el0);
+	else
+		return __vcpu_sys_reg(vcpu, PMSELR_EL0);
+}
+
+u64 kvm_vcpu_read_pmuserenr(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vcpu_pmu_is_partitioned(vcpu))
+		return read_sysreg(pmuserenr_el0);
+	else
+		return __vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a460e93b1ad0a..9e893859a41c9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -987,7 +987,7 @@ static u64 reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 
 static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags)
 {
-	u64 reg = __vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+	u64 reg = kvm_vcpu_read_pmuserenr(vcpu);
 	bool enabled = (reg & flags) || vcpu_mode_priv(vcpu);
 
 	if (!enabled)
@@ -1141,7 +1141,7 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 				return false;
 
 			idx = SYS_FIELD_GET(PMSELR_EL0, SEL,
-					    __vcpu_sys_reg(vcpu, PMSELR_EL0));
+					    kvm_vcpu_read_pmselr(vcpu));
 		} else if (r->Op2 == 0) {
 			/* PMCCNTR_EL0 */
 			if (pmu_access_cycle_counter_el0_disabled(vcpu))
@@ -1191,7 +1191,7 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 	if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 1) {
 		/* PMXEVTYPER_EL0 */
-		idx = SYS_FIELD_GET(PMSELR_EL0, SEL, __vcpu_sys_reg(vcpu, PMSELR_EL0));
+		idx = SYS_FIELD_GET(PMSELR_EL0, SEL, kvm_vcpu_read_pmselr(vcpu));
 		reg = PMEVTYPER0_EL0 + idx;
 	} else if (r->CRn == 14 && (r->CRm & 12) == 12) {
 		idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 50983cdbec045..f21439000129b 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -130,6 +130,8 @@ int kvm_arm_set_default_pmu(struct kvm *kvm);
 u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm);
 
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu);
+u64 kvm_vcpu_read_pmselr(struct kvm_vcpu *vcpu);
+u64 kvm_vcpu_read_pmuserenr(struct kvm_vcpu *vcpu);
 bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int idx);
 void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu);
 #else
@@ -250,6 +252,16 @@ static inline u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static inline u64 kvm_vcpu_read_pmselr(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
+static u64 kvm_vcpu_read_pmuserenr(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
 static inline bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	return false;
-- 
2.53.0.rc2.204.g2597b5adb4-goog


