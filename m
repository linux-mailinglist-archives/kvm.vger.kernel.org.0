Return-Path: <kvm+bounces-70654-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AHs/OzRjiml6JwAAu9opvQ
	(envelope-from <kvm+bounces-70654-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 23:44:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 91E311152BA
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 23:44:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C6E0230500C3
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 22:41:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03C81319857;
	Mon,  9 Feb 2026 22:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VXRB4Z5B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4289D319617
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 22:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770676853; cv=none; b=CIP8E2cJAq+Nfg2j6Z8MXVUDbCC3YYGLTLAlHqyg4WDfE31wzbNkjRHtndyE8qzvZosHCHV3Ea+6H4q7nrb6LyHNisDJfQSsxNaYq7cS2wrfGRJTSbHYbmrofUA14GbaQdlQI6ZX3zX3RAoGOcQaUQ0MwnD5UvTMpM/FxFxVduQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770676853; c=relaxed/simple;
	bh=dXTvn4qocYHpwQDXijQpcg4yhTZjehQMfz5QbgqWF8w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IIn7pJdzLWbuva4fer99qktcQPdO9jKV4+YLilINm9SwGpOJqSZd7yRpTyjNIa+75E3f8aG1n7WlTsJawm8DYje7Ok4vMNcx3ji/ofow/Z+T1DJPedCN4e2grTpz0SUmv4KGcKEfTcObShHBpAk4B8AGGSR04Yzx53d5Q+xMSCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VXRB4Z5B; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7d1902109a9so943348a34.2
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 14:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770676849; x=1771281649; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=imeQaLzXrnVqs2xwe1B4fumETENHcf/y9Tb2xZBjKCc=;
        b=VXRB4Z5BPWZUplDuhiKWgqT0op4G6BioUYx53Cw8Y+8LUxjNK4sb9M1TdUvC0mynvZ
         Q+K54u2Wa675nkRHkzh+z834mzpB3sU3zQ+yG3DDe7xEJD+HL0SCI7CmHjLm02TexLhZ
         2bxAF09MlXkbiGQ4U6eVMyCUuGP6++9Kw0jGFHyLkSxzGZ2I1pdRExF37MZNkD0VErHN
         VGrZB9P/tczRtyLwsVYGhWjqtPGtjEmz9ZWGabehT/FSifXdJNUH/F8YQvyVliumawk4
         9Zfp6Z9mjXhnZj/azjxm6ROeJrobsIRCcfHsa7TaY3gfGrvDNaz7L6RYyt77GODfNgaQ
         cf+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770676849; x=1771281649;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=imeQaLzXrnVqs2xwe1B4fumETENHcf/y9Tb2xZBjKCc=;
        b=WvusLgt4RbWkC999qLJE2u9j+0QL0rvypsaj8a81p0AnhAP+alnFVvLhm4KQEY3nF5
         exHoY4ycTS61/u9ZMntpvJtwWknQqnRVphE6NaEwpvm531TYMAqrfE1+z49S+iDI73Ep
         9fuHXX8bDKY8r5pyMqp/nANM+YdjtDM1gbFYFK7zxN1CGeDTo9MnYyP+o5gyhXNLl5Fg
         q+EQKnUEZPxMx3FWez1X8PeheX6BG575nYu4XjHf1CQrY0WCh5T0CINbaw+korBeOJpa
         1QJsoIPeA5Z5kbuwjLb0xI8tpKP8+HgJ7AfZAodsWFyxJrBF3FMgZgm+Tw4SfA5E2/Ht
         7xUw==
X-Gm-Message-State: AOJu0YzzXleOBbfGOQ53MkVHr1DOXBm7jEsZKP5TvEv0hoONX9T8LsAs
	AKi7aV5jRagBoZsEoEoM51lRt2FhX8bqM4Zg2z2R4YWxeiOiFmBXacvK6xFhZ6EEexF3i7fZKDn
	2g5VUQqVUrC6Gtl94ZcPC5aRyRbV0X+H5K95HPTwityYAdms2CX3dRTxqXX1wEF0chzEYRfrF6C
	gnMHwx/KRcssnL+RVX67WsNOqivtdP8whncX4nX+yYVCFhQRY69ZRmuANEjfs=
X-Received: from jabfq6.prod.google.com ([2002:a05:6638:6506:b0:5ce:3e9c:22c9])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:3088:b0:662:f61e:759d with SMTP id 006d021491bc7-66d0c666b89mr6055036eaf.62.1770676849224;
 Mon, 09 Feb 2026 14:40:49 -0800 (PST)
Date: Mon,  9 Feb 2026 22:14:00 +0000
In-Reply-To: <20260209221414.2169465-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260209221414.2169465-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260209221414.2169465-6-coltonlewis@google.com>
Subject: [PATCH v6 05/19] perf: arm_pmuv3: Generalize counter bitmasks
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
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
	TAGGED_FROM(0.00)[bounces-70654-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[coltonlewis@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 91E311152BA
X-Rspamd-Action: no action

The OVSR bitmasks are valid for enable and interrupt registers as well as
overflow registers. Generalize the names.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 drivers/perf/arm_pmuv3.c       |  4 ++--
 include/linux/perf/arm_pmuv3.h | 14 +++++++-------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 798c93678e97c..b37908fad3249 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -546,7 +546,7 @@ static u64 armv8pmu_pmcr_n_read(void)
 
 static int armv8pmu_has_overflowed(u64 pmovsr)
 {
-	return !!(pmovsr & ARMV8_PMU_OVERFLOWED_MASK);
+	return !!(pmovsr & ARMV8_PMU_CNT_MASK_ALL);
 }
 
 static int armv8pmu_counter_has_overflowed(u64 pmnc, int idx)
@@ -782,7 +782,7 @@ static u64 armv8pmu_getreset_flags(void)
 	value = read_pmovsclr();
 
 	/* Write to clear flags */
-	value &= ARMV8_PMU_OVERFLOWED_MASK;
+	value &= ARMV8_PMU_CNT_MASK_ALL;
 	write_pmovsclr(value);
 
 	return value;
diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
index d698efba28a27..fd2a34b4a64d1 100644
--- a/include/linux/perf/arm_pmuv3.h
+++ b/include/linux/perf/arm_pmuv3.h
@@ -224,14 +224,14 @@
 				 ARMV8_PMU_PMCR_LC | ARMV8_PMU_PMCR_LP)
 
 /*
- * PMOVSR: counters overflow flag status reg
+ * Counter bitmask layouts for overflow, enable, and interrupts
  */
-#define ARMV8_PMU_OVSR_P		GENMASK(30, 0)
-#define ARMV8_PMU_OVSR_C		BIT(31)
-#define ARMV8_PMU_OVSR_F		BIT_ULL(32) /* arm64 only */
-/* Mask for writable bits is both P and C fields */
-#define ARMV8_PMU_OVERFLOWED_MASK	(ARMV8_PMU_OVSR_P | ARMV8_PMU_OVSR_C | \
-					ARMV8_PMU_OVSR_F)
+#define ARMV8_PMU_CNT_MASK_P		GENMASK(30, 0)
+#define ARMV8_PMU_CNT_MASK_C		BIT(31)
+#define ARMV8_PMU_CNT_MASK_F		BIT_ULL(32) /* arm64 only */
+#define ARMV8_PMU_CNT_MASK_ALL		(ARMV8_PMU_CNT_MASK_P | \
+					 ARMV8_PMU_CNT_MASK_C | \
+					 ARMV8_PMU_CNT_MASK_F)
 
 /*
  * PMXEVTYPER: Event selection reg
-- 
2.53.0.rc2.204.g2597b5adb4-goog


