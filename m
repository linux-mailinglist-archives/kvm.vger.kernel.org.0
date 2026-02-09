Return-Path: <kvm+bounces-70661-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id INkTNApjiml6JwAAu9opvQ
	(envelope-from <kvm+bounces-70661-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 23:43:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7416F11528D
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 23:43:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C512F304F228
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 22:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20190329E6C;
	Mon,  9 Feb 2026 22:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dYTxExwp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFF9324B26
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 22:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770676860; cv=none; b=fQgmhnlNk1SYcAw0J18u+mJI4aUMaXRiVYCciHRTEvXQlOwa1lSHSahs8lZzOa+YOSmi6AGhZ/FPFpQH+A04QASRI58sUSqiznMClhz3DNWBVcFvAu5eWFn3wsmfp/NusRkB1TFTm8qUANL8iRt9QEZKvNqub8ScLLDyKjhEpck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770676860; c=relaxed/simple;
	bh=0yHFaL4kFduvDWHMbB5SGQV3aeiI1+OaatDNUsMBH/E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rhPSx57GSR7CEgeLYHtUuZwdyy11VbRsyzWTrApKOGeELyugswA2Pu5MdnqZOHtV4RPRX3ovkCNLJKQT7P/vkSc61zvlEq6jkSxUQ8H5EThN2mKEvYwxWHqM14z8eETS3b6jRtuUZyHlgEdspELgrfdmrGg0I2YbX68cEW4bbTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dYTxExwp; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-66304fd6389so9169629eaf.1
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 14:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770676857; x=1771281657; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EEaHOE5nznf9+zz/kBeN5l5G1L0iV5xIIbwKx1lv3GQ=;
        b=dYTxExwpT1SQQn4JiSw9L5+rKy3MULJFWO8bsWMy5bss2uf0w3GLkrbQsSY4ePkhQq
         unQDd/fMmR/7zoeku2Be8tMtwIRVTOjRNS6r6KicbzDEc0v1lQnvCiYzvSRB6dntuQoT
         sTu0wxRSPUJGvenUo5cGM6Nk1PE3vchhige7wltSVqwukdvzRjx1pTuFCYRUiIMm9lhs
         Lx6ezjDt//fct4Yb6oIitCXmeaHEi/XYPJbZ+iICEX5+sXB5wy293SWOU4iME3SBerwu
         Xe9rwRio7V4S60pYEp4yPhDsKY0G3P0kUKnPZrzEqdVyWyyfW5/PCjMY6Zc6OzQp+rda
         EQqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770676857; x=1771281657;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EEaHOE5nznf9+zz/kBeN5l5G1L0iV5xIIbwKx1lv3GQ=;
        b=kSeRDEzEeXJV97ls77sl3sj1gX4jHYuqtjTxn80hN9ZBkvhMoOofzSd9rQkwSoJ03c
         W5kE97O7Z+QsTCNScnokFVFCJ15rZ8sZop6dq1cTkniDPO7L5zBNmxeFafjoYUTrE8sY
         4qcK9Q0KUsCzuL2SrkddekEdgtI5e6qwuZf4u/lIiUlcxLzwSbT5b/M5nX34cORIPLFe
         aYaoJ/sszISY2H5lpBV+mZWGY083nB9YmMLF6rNNBz74IsEYXkoVrN+hUyQonI855Uq0
         0lKgO5RS32Tio8UkrL0dna2SUhSaTCPifF/lMv8V9T8ffk7ksWsUac3ktv1LYuG5PcXd
         dW3w==
X-Gm-Message-State: AOJu0Yx8QXQtpqg/GJ5R5Ro6Z1W57DuICmTJJZpapNQzQF0FrHSuGscy
	cL1mZZBla7dQFEf6ZVsVnsJ63r56fdAhsv3I4lEHblZr5Mcw7PnZEkjmq0XIrsMr9jz+ZsaVV5X
	lwzsHsLNVmdUIWHVhsRIBrnECy7SXyvNWQoMDXxcD0rubg5/aQTtCQI0+kwdFbpP648q42gG2pt
	fKOSe6PkmWGbg81/RDGn1vdKujbSY9D2p7Ai7hDHsfSW8oS/B7UGB4TWwRdUU=
X-Received: from iojv23.prod.google.com ([2002:a5d:9497:0:b0:95a:608d:8cf9])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:6ec6:b0:66e:10ca:fcd5 with SMTP id 006d021491bc7-66e10cafdcfmr3750272eaf.12.1770676856769;
 Mon, 09 Feb 2026 14:40:56 -0800 (PST)
Date: Mon,  9 Feb 2026 22:14:07 +0000
In-Reply-To: <20260209221414.2169465-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260209221414.2169465-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260209221414.2169465-13-coltonlewis@google.com>
Subject: [PATCH v6 12/19] KVM: arm64: Enforce PMU event filter at vcpu_load()
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
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
	TAGGED_FROM(0.00)[bounces-70661-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[coltonlewis@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7416F11528D
X-Rspamd-Action: no action

The KVM API for event filtering says that counters do not count when
blocked by the event filter. To enforce that, the event filter must be
rechecked on every load since it might have changed since the last
time the guest wrote a value. If the event is filtered, exclude
counting at all exception levels before writing the hardware.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu-direct.c | 48 +++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index b07b521543478..4bcacc55c507f 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -165,6 +165,53 @@ u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
 	return *host_data_ptr(nr_event_counters);
 }
 
+/**
+ * kvm_pmu_apply_event_filter()
+ * @vcpu: Pointer to vcpu struct
+ *
+ * To uphold the guarantee of the KVM PMU event filter, we must ensure
+ * no counter counts if the event is filtered. Accomplish this by
+ * filtering all exception levels if the event is filtered.
+ */
+static void kvm_pmu_apply_event_filter(struct kvm_vcpu *vcpu)
+{
+	struct arm_pmu *pmu = vcpu->kvm->arch.arm_pmu;
+	unsigned long guest_counters = kvm_pmu_guest_counter_mask(pmu);
+	u64 evtyper_set = ARMV8_PMU_EXCLUDE_EL0 |
+		ARMV8_PMU_EXCLUDE_EL1;
+	u64 evtyper_clr = ARMV8_PMU_INCLUDE_EL2;
+	bool guest_include_el2;
+	u8 i;
+	u64 val;
+	u64 evsel;
+
+	if (!pmu)
+		return;
+
+	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
+		if (i == ARMV8_PMU_CYCLE_IDX) {
+			val = __vcpu_sys_reg(vcpu, PMCCFILTR_EL0);
+			evsel = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
+		} else {
+			val = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
+			evsel = val & kvm_pmu_event_mask(vcpu->kvm);
+		}
+
+		guest_include_el2 = (val & ARMV8_PMU_INCLUDE_EL2);
+		val &= ~evtyper_clr;
+
+		if (unlikely(is_hyp_ctxt(vcpu)) && guest_include_el2)
+			val &= ~ARMV8_PMU_EXCLUDE_EL1;
+
+		if (vcpu->kvm->arch.pmu_filter &&
+		    !test_bit(evsel, vcpu->kvm->arch.pmu_filter))
+			val |= evtyper_set;
+
+		write_sysreg(i, pmselr_el0);
+		write_sysreg(val, pmxevtyper_el0);
+	}
+}
+
 /**
  * kvm_pmu_load() - Load untrapped PMU registers
  * @vcpu: Pointer to struct kvm_vcpu
@@ -192,6 +239,7 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
 
 	pmu = vcpu->kvm->arch.arm_pmu;
 	guest_counters = kvm_pmu_guest_counter_mask(pmu);
+	kvm_pmu_apply_event_filter(vcpu);
 
 	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
 		val = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i);
-- 
2.53.0.rc2.204.g2597b5adb4-goog


