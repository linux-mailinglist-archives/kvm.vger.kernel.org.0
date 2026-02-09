Return-Path: <kvm+bounces-70658-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id COdaGshjiml6JwAAu9opvQ
	(envelope-from <kvm+bounces-70658-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 23:46:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C8E1C115357
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 23:46:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EC512301CFBC
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 22:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18F85324B1D;
	Mon,  9 Feb 2026 22:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lxmy9cH5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E969231DD96
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 22:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770676858; cv=none; b=dk5ri9SSEBhiAdYY/RAaiFxlXZg/mhET3sjyRT+zwowFuh4P00KVpLp5CqJk8IwR7ktSF2CXE1y7BQ3iCE+kIjVQMuFrgss0qNdTPY9Mk/vq2l7CjdlfKy6SghEIsta6s6rtGhk9FcEes88MEuXqUpDBUnrUjOEtgA6M4huC5Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770676858; c=relaxed/simple;
	bh=VlntSjT33zFT4cwsmNUlK5lpAzJYXAv17KA7vHnYPW8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tmJ41FjFG2tW86QLoG24vXOMRuFStcClkJBtjIQOC/yPfmoSPBxjoLnCzEOnJqlyf16YndX6Q0w9moOMZQdIZ0iDmZLvqMk3VXslOeUf46gCNiw+nUvbZGsicu//Kc1qeVGX48MITIgLyY6iFbpd176nOxCEhTt/eYxqKrr0ASw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lxmy9cH5; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-66308f16e13so9035146eaf.0
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 14:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770676854; x=1771281654; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1q4WN7z/SL7quCNEFM+ItoBlF4yxyRczz8LessGfPao=;
        b=Lxmy9cH5s438x/aSg/jAP0vd9MbnfNzRWx9myX25dDHvy6auC0aXnRWWtXozqqWev2
         8V9BedJCp/q/02BROvUxW48VBaJHjVorxbPGvwC19PnZk1r+TTR535Zl887f23ik24Ug
         y1zV8asGsRqGlNyrk5X0o4pZQGRF4pSTg4gGCYvZcthBfJeR7DogXt0wVul60kEY3bcs
         DlwQbCkavaNLUHukzq3GCc9BBSjrlUquHTPs5cFIBoSVNJglnDaFXP9Qlr9TBOmsaqqG
         YK+sZAHgPk1UDlUXHh21J/qIgHgmcZICfO7NHo+fE74Fststvo0UXlZgB8SimHVEFm4b
         fblQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770676854; x=1771281654;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1q4WN7z/SL7quCNEFM+ItoBlF4yxyRczz8LessGfPao=;
        b=DXkg4sK3aLSVGqCfJEpS0RKrTbQIPFIUD1H8z6k9vJy8ltmjdrM62Uk+XeboT5tFrs
         B7je7AqrvCr8qdsr4x6uLOsgi9cPnXZYrXO/mBSyvWdYrIOlL/7V2sqfB9VxItLOoZ11
         zXoCqPNrfspNXXkCOLh5oDTewBjdvgdRvb2fIRYwZ7aHn6lGGW4Vho5O18ONweBAjKDc
         rgqHpnEx1R21k+IXaBzbQ6lFMW1jB6OlDDltpp0mPJI75YuZfIMTNcNjxgFSUucEuNaz
         LZWKHGqP+q5LgNVvrbW386D/O7xIsstc7Ujddd8ckgp6efgGPd6KmpgbXDVj+QZuinyO
         sZgw==
X-Gm-Message-State: AOJu0YzeImc+66uL2jlqZF06dvLKnfOfAzwmunvre+7L14ubMcN5KFmK
	1QnPDATLpUm1WZHcL69MVPJ+O5FUrYNufoVHAR01cDXy43+Apz20Bv5Q3BfRDM99xzi372ejx1C
	ui9AEutG3osG0hWs5t5boPUuCcFfXgb2+VEqmJQrqTBpzvAaCO+3dUq8lhRWz0PLT01diz63u2J
	q1WwTQGslA2m+W08iZMmRrLYp7MqTPkfQM3trKO9SNroxWtWrHRs3BxxOoUvM=
X-Received: from iong8.prod.google.com ([2002:a5d:8c88:0:b0:957:4b76:541e])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:6aca:b0:663:9b9:9297 with SMTP id 006d021491bc7-66d0c6685ccmr6026920eaf.64.1770676853645;
 Mon, 09 Feb 2026 14:40:53 -0800 (PST)
Date: Mon,  9 Feb 2026 22:14:04 +0000
In-Reply-To: <20260209221414.2169465-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260209221414.2169465-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260209221414.2169465-10-coltonlewis@google.com>
Subject: [PATCH v6 09/19] KVM: arm64: Write fast path PMU register handlers
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
	TAGGED_FROM(0.00)[bounces-70658-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[coltonlewis@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C8E1C115357
X-Rspamd-Action: no action

We may want a partitioned PMU but not have FEAT_FGT to untrap the
specific registers that would normally be untrapped. Add a handler for
those registers in the fast path so we can still get a performance
boost from partitioning.

The idea is to handle traps for all the PMU registers quickly by
writing directly to the hardware when possible instead of hooking into
the emulated vPMU as the standard handlers in sys_regs.c do.

For registers that can't be written to hardware because they require
special handling (PMEVTYPER and PMOVS), write to the virtual
register. A later patch will ensure these are handled correctly at
vcpu_load time.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 238 ++++++++++++++++++++++++++++++++
 1 file changed, 238 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 9db3f11a4754d..154da70146d98 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -28,6 +28,8 @@
 #include <asm/thread_info.h>
 #include <asm/vectors.h>
 
+#include <../../sys_regs.h>
+
 /* VHE specific context */
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
@@ -482,6 +484,239 @@ static bool kvm_hyp_handle_zcr_el2(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return false;
 }
 
+/**
+ * kvm_hyp_handle_pmu_regs() - Fast handler for PMU registers
+ * @vcpu: Pointer to vcpu struct
+ *
+ * This handler immediately writes through certain PMU registers when
+ * we have a partitioned PMU (that is, MDCR_EL2.HPMN is set to reserve
+ * a range of counters for the guest) but the machine does not have
+ * FEAT_FGT to selectively untrap the registers we want.
+ *
+ * Return: True if the exception was successfully handled, false otherwise
+ */
+static bool kvm_hyp_handle_pmu_regs(struct kvm_vcpu *vcpu)
+{
+	struct sys_reg_params p;
+	u64 pmuser;
+	u64 pmselr;
+	u64 esr;
+	u64 val;
+	u64 mask;
+	u32 sysreg;
+	u8 nr_cnt;
+	u8 rt;
+	u8 idx;
+	bool ret;
+
+	if (!kvm_vcpu_pmu_is_partitioned(vcpu))
+		return false;
+
+	pmuser = kvm_vcpu_read_pmuserenr(vcpu);
+
+	if (!(pmuser & ARMV8_PMU_USERENR_EN))
+		return false;
+
+	esr = kvm_vcpu_get_esr(vcpu);
+	p = esr_sys64_to_params(esr);
+	sysreg = esr_sys64_to_sysreg(esr);
+	rt = kvm_vcpu_sys_get_rt(vcpu);
+	val = vcpu_get_reg(vcpu, rt);
+	nr_cnt = vcpu->kvm->arch.nr_pmu_counters;
+
+	switch (sysreg) {
+	case SYS_PMCR_EL0:
+		mask = ARMV8_PMU_PMCR_MASK;
+
+		if (p.is_write) {
+			write_sysreg(val & mask, pmcr_el0);
+		} else {
+			mask |= ARMV8_PMU_PMCR_N;
+			val = u64_replace_bits(
+				read_sysreg(pmcr_el0),
+				nr_cnt,
+				ARMV8_PMU_PMCR_N);
+			vcpu_set_reg(vcpu, rt, val & mask);
+		}
+
+		ret = true;
+		break;
+	case SYS_PMUSERENR_EL0:
+		mask = ARMV8_PMU_USERENR_MASK;
+
+		if (p.is_write) {
+			write_sysreg(val & mask, pmuserenr_el0);
+		} else {
+			val = read_sysreg(pmuserenr_el0);
+			vcpu_set_reg(vcpu, rt, val & mask);
+		}
+
+		ret = true;
+		break;
+	case SYS_PMSELR_EL0:
+		mask = PMSELR_EL0_SEL_MASK;
+		val &= mask;
+
+		if (p.is_write) {
+			write_sysreg(val & mask, pmselr_el0);
+		} else {
+			val = read_sysreg(pmselr_el0);
+			vcpu_set_reg(vcpu, rt, val & mask);
+		}
+		ret = true;
+		break;
+	case SYS_PMINTENCLR_EL1:
+		mask = kvm_pmu_accessible_counter_mask(vcpu);
+
+		if (p.is_write) {
+			write_sysreg(val & mask, pmintenclr_el1);
+		} else {
+			val = read_sysreg(pmintenclr_el1);
+			vcpu_set_reg(vcpu, rt, val & mask);
+		}
+		ret = true;
+
+		break;
+	case SYS_PMINTENSET_EL1:
+		mask = kvm_pmu_accessible_counter_mask(vcpu);
+
+		if (p.is_write) {
+			write_sysreg(val & mask, pmintenset_el1);
+		} else {
+			val = read_sysreg(pmintenset_el1);
+			vcpu_set_reg(vcpu, rt, val & mask);
+		}
+
+		ret = true;
+		break;
+	case SYS_PMCNTENCLR_EL0:
+		mask = kvm_pmu_accessible_counter_mask(vcpu);
+
+		if (p.is_write) {
+			write_sysreg(val & mask, pmcntenclr_el0);
+		} else {
+			val = read_sysreg(pmcntenclr_el0);
+			vcpu_set_reg(vcpu, rt, val & mask);
+		}
+
+		ret = true;
+		break;
+	case SYS_PMCNTENSET_EL0:
+		mask = kvm_pmu_accessible_counter_mask(vcpu);
+
+		if (p.is_write) {
+			write_sysreg(val & mask, pmcntenset_el0);
+		} else {
+			val = read_sysreg(pmcntenset_el0);
+			vcpu_set_reg(vcpu, rt, val & mask);
+		}
+
+		ret = true;
+		break;
+	case SYS_PMOVSCLR_EL0:
+		mask = kvm_pmu_accessible_counter_mask(vcpu);
+
+		if (p.is_write) {
+			__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, &=, ~(val & mask));
+		} else {
+			val = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
+			vcpu_set_reg(vcpu, rt, val & mask);
+		}
+
+		ret = true;
+		break;
+	case SYS_PMOVSSET_EL0:
+		mask = kvm_pmu_accessible_counter_mask(vcpu);
+
+		if (p.is_write) {
+			__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, val & mask);
+		} else {
+			val = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
+			vcpu_set_reg(vcpu, rt, val & mask);
+		}
+
+		ret = true;
+		break;
+	case SYS_PMCCNTR_EL0:
+	case SYS_PMXEVCNTR_EL0:
+	case SYS_PMEVCNTRn_EL0(0) ... SYS_PMEVCNTRn_EL0(30):
+		if (sysreg == SYS_PMCCNTR_EL0)
+			idx = ARMV8_PMU_CYCLE_IDX;
+		else if (sysreg == SYS_PMXEVCNTR_EL0)
+			idx = FIELD_GET(PMSELR_EL0_SEL, kvm_vcpu_read_pmselr(vcpu));
+		else
+			idx = ((p.CRm & 3) << 3) | (p.Op2 & 7);
+
+		if (idx == ARMV8_PMU_CYCLE_IDX &&
+		    !(pmuser & ARMV8_PMU_USERENR_CR)) {
+			ret = false;
+			break;
+		} else if (!(pmuser & ARMV8_PMU_USERENR_ER)) {
+			ret = false;
+			break;
+		}
+
+		if (idx >= nr_cnt && idx < ARMV8_PMU_CYCLE_IDX) {
+			ret = false;
+			break;
+		}
+
+		pmselr = read_sysreg(pmselr_el0);
+		write_sysreg(idx, pmselr_el0);
+
+		if (p.is_write) {
+			write_sysreg(val, pmxevcntr_el0);
+		} else {
+			val = read_sysreg(pmxevcntr_el0);
+			vcpu_set_reg(vcpu, rt, val);
+		}
+
+		write_sysreg(pmselr, pmselr_el0);
+		ret = true;
+		break;
+	case SYS_PMCCFILTR_EL0:
+	case SYS_PMXEVTYPER_EL0:
+	case SYS_PMEVTYPERn_EL0(0) ... SYS_PMEVTYPERn_EL0(30):
+		if (sysreg == SYS_PMCCFILTR_EL0)
+			idx = ARMV8_PMU_CYCLE_IDX;
+		else if (sysreg == SYS_PMXEVTYPER_EL0)
+			idx = FIELD_GET(PMSELR_EL0_SEL, kvm_vcpu_read_pmselr(vcpu));
+		else
+			idx = ((p.CRm & 3) << 3) | (p.Op2 & 7);
+
+		if (idx == ARMV8_PMU_CYCLE_IDX &&
+		    !(pmuser & ARMV8_PMU_USERENR_CR)) {
+			ret = false;
+			break;
+		} else if (!(pmuser & ARMV8_PMU_USERENR_ER)) {
+			ret = false;
+			break;
+		}
+
+		if (idx >= nr_cnt && idx < ARMV8_PMU_CYCLE_IDX) {
+			ret = false;
+			break;
+		}
+
+		if (p.is_write) {
+			__vcpu_assign_sys_reg(vcpu, PMEVTYPER0_EL0 + idx, val);
+		} else {
+			val = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + idx);
+			vcpu_set_reg(vcpu, rt, val);
+		}
+
+		ret = true;
+		break;
+	default:
+		ret = false;
+	}
+
+	if (ret)
+		__kvm_skip_instr(vcpu);
+
+	return ret;
+}
+
 static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (kvm_hyp_handle_tlbi_el2(vcpu, exit_code))
@@ -496,6 +731,9 @@ static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (kvm_hyp_handle_zcr_el2(vcpu, exit_code))
 		return true;
 
+	if (kvm_hyp_handle_pmu_regs(vcpu))
+		return true;
+
 	return kvm_hyp_handle_sysreg(vcpu, exit_code);
 }
 
-- 
2.53.0.rc2.204.g2597b5adb4-goog


