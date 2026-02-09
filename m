Return-Path: <kvm+bounces-70651-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +BtqDppiimleJwAAu9opvQ
	(envelope-from <kvm+bounces-70651-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 23:41:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B51A11151BA
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 23:41:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 375343037D43
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 22:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EF2A314A94;
	Mon,  9 Feb 2026 22:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="omAswZb5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E034E317708
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 22:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770676847; cv=none; b=M3AZosabvKbeWegj6C0jD9JNVfOwR0WX67A/ZsNm9pME2619C7OK9pl8ms2LnxGZ5AUGGuhCKIL96LCuLpOpxDS9q5SxSyl01Y89LPi6apV78q6CYl/0WfzFShOp7Gx8CzfegFUyOlB3BvlDNJ5H6s8GU381xD55Ln/TZhnuYtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770676847; c=relaxed/simple;
	bh=6+/AAsrIcJ/tlip7YRHDsjoPFsDxdedlbrM0lqMPkcI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KX8rnpJIiQ73wjfSDn2bGGpg0ZAk88ZUIDL9ndv1WFeerq5cAmbLr5rgDsK+W24Uxdam9U/yQ1hZiYgbhjxDbDBT2lMsuvxt1duH6U6nmrDpjqYFJCFipVLJPKIOYEMM1/bx5Pbr3IMhfWDvqz0QcPDobbBICJq2euKSbk+ZIHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=omAswZb5; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-45ee72d15f7so877552b6e.2
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 14:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770676845; x=1771281645; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iRE+uiZ0XUNzFGmxnXVrfreBhjJPUlvjb1s52PGeIK4=;
        b=omAswZb566EMnpAmqCd+XqybWKN04qDDUrYy76S7aZy77qMqpscdVzb/Vz7F8lmUft
         3UVkv2E8jnXFgitrE5Jsr3Y/Px++T9H1wBsRTbiyNFfUuVjSNKE3/B8I+C4dDHux2aob
         ASGUEguW8TbH6qcs065+ciu2mW/OR5mTxqDr3oTe+VGBSkYshszX0V0ydbwSQW4dwTM+
         iCM3KQOg9kfRAiQpnZv1ittXdoo0PI3KHhIFkCQyeZhdHALRZy+FWQIMs0CJ92KtSMEL
         S+S0r2nkA3AyZ0kaHy9ueGxkIX3IM2feyIONtaEQeN2owvKrrbm2OQvoScSo/RFfrFUN
         0e0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770676845; x=1771281645;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iRE+uiZ0XUNzFGmxnXVrfreBhjJPUlvjb1s52PGeIK4=;
        b=pHGWMS8IsH69rQ0n805mrmxVEt7cVYgyCV60dqipvsg8+GDuDgGodw0csLqYsJZEla
         BzXkoHhlO1+NAOrR3df3XVGyIxpA/3CWGMZC+46GqFU0q1wnY+OzND89T6NRW32Gndhq
         Q1DZGL+nUt4gNJfLXn87Sc46pT48IHrBgU+GXppKhYTB0+FO4ftyOJVdH87cGGZoQoot
         Yclio+QrOaw3WVawWL//+LA4qy1gTFzlkRWEBl/kr+DSqevZ9xYjVLw5tYCeEFuvSYHx
         6D4uc9O1ZE2bltUrN6Pcrwtu/VlPLgZQWHf094LNo7GP2yJhITCB451x7f7nH+rlnjjF
         GWCA==
X-Gm-Message-State: AOJu0Yy4+YmTttc4kYWY31nNA/Bd4rvYwoiwrPBB2oangVHFFMwuP9LL
	pxT4FoR9XxLH+XM9wxpczzTnKNltvzsgnis803VgJkKCrvp/ccj2DJZibX317ncBDlc3Rc6HAbG
	0OapmLSDXY+6YXP/0ayNOco7Ubtv45B6I7c+VAkePQQg//hnaJO74jsSvK7BkDCdZgxwuZFJHcn
	6ekCiFKcorzZXdsz2Cn4ulKhrdYg0vatckwpRRVriIHIiqUPAXjgDMdfoopMU=
X-Received: from jamu20.prod.google.com ([2002:a02:c054:0:b0:5ca:f895:d041])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:4b17:b0:663:93:5146 with SMTP id 006d021491bc7-66d0bdae77emr5791796eaf.43.1770676844869;
 Mon, 09 Feb 2026 14:40:44 -0800 (PST)
Date: Mon,  9 Feb 2026 22:13:56 +0000
In-Reply-To: <20260209221414.2169465-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260209221414.2169465-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260209221414.2169465-2-coltonlewis@google.com>
Subject: [PATCH v6 01/19] arm64: cpufeature: Add cpucap for HPMN0
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
	TAGGED_FROM(0.00)[bounces-70651-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[coltonlewis@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B51A11151BA
X-Rspamd-Action: no action

Add a capability for FEAT_HPMN0, whether MDCR_EL2.HPMN can specify 0
counters reserved for the guest.

This required changing HPMN0 to an UnsignedEnum in tools/sysreg
because otherwise not all the appropriate macros are generated to add
it to arm64_cpu_capabilities_arm64_features.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kernel/cpufeature.c | 8 ++++++++
 arch/arm64/kvm/sys_regs.c      | 3 ++-
 arch/arm64/tools/cpucaps       | 1 +
 arch/arm64/tools/sysreg        | 6 +++---
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c840a93b9ef95..e6a8373d8625b 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -555,6 +555,7 @@ static const struct arm64_ftr_bits ftr_id_mmfr0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_HPMN0_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_DoubleLock_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_PMSVer_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_CTX_CMPs_SHIFT, 4, 0),
@@ -2950,6 +2951,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, FGT, FGT2)
 	},
+	{
+		.desc = "HPMN0",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HAS_HPMN0,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64DFR0_EL1, HPMN0, IMP)
+	},
 #ifdef CONFIG_ARM64_SME
 	{
 		.desc = "Scalable Matrix Extension",
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 88a57ca36d96c..a460e93b1ad0a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3229,7 +3229,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		    ID_AA64DFR0_EL1_DoubleLock_MASK |
 		    ID_AA64DFR0_EL1_WRPs_MASK |
 		    ID_AA64DFR0_EL1_PMUVer_MASK |
-		    ID_AA64DFR0_EL1_DebugVer_MASK),
+		    ID_AA64DFR0_EL1_DebugVer_MASK |
+		    ID_AA64DFR0_EL1_HPMN0_MASK),
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 0fac75f015343..1e3f6e9cc2c86 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -42,6 +42,7 @@ HAS_GIC_PRIO_MASKING
 HAS_GIC_PRIO_RELAXED_SYNC
 HAS_ICH_HCR_EL2_TDIR
 HAS_HCR_NV1
+HAS_HPMN0
 HAS_HCX
 HAS_LDAPR
 HAS_LPA2
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 8921b51866d64..c9cf3d139c2da 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1666,9 +1666,9 @@ EndEnum
 EndSysreg
 
 Sysreg	ID_AA64DFR0_EL1	3	0	0	5	0
-Enum	63:60	HPMN0
-	0b0000	UNPREDICTABLE
-	0b0001	DEF
+UnsignedEnum	63:60	HPMN0
+	0b0000	NI
+	0b0001	IMP
 EndEnum
 UnsignedEnum	59:56	ExtTrcBuff
 	0b0000	NI
-- 
2.53.0.rc2.204.g2597b5adb4-goog


