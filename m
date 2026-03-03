Return-Path: <kvm+bounces-72532-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2Ob9BljupmlKaQAAu9opvQ
	(envelope-from <kvm+bounces-72532-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 15:21:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 14E131F1579
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 15:21:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A1C4330299E8
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 14:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 752DA42DFF7;
	Tue,  3 Mar 2026 14:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=cispa.de header.i=@cispa.de header.b="EBVS+Nlz"
X-Original-To: kvm@vger.kernel.org
Received: from mx-2023-1.gwdg.de (mx-2023-1.gwdg.de [134.76.10.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974E93E51EB;
	Tue,  3 Mar 2026 14:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.76.10.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772547598; cv=none; b=kb0JBPrKBQlWeqoW2q+ivV1dZxvrvxUrsmHcNqrcMgLurNmsijX5eh9JPDme2lKt50D6CPDRermuejesrkzotr1RiswwL+qoKIFsUCVXmZHJJu3ndJea5RR4t9xN8HikReeRNIohOhW4rQlaQvyLnt8hOIPJihsVdilb7GPtdnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772547598; c=relaxed/simple;
	bh=KM1k/pQ3/foiyLLSfk5MnnCFsDCB/OLME+w81duj1l4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=k3UctRiyDn5aoE3HcB7qILtaCc7woknQCzkan0VUXc5uc9Xky5mOFvSIU32s8/7qpS2zb3kVgndibEoIGmT3f52ZalXzSybZGOApld8tqV9KOOv2TOofraj5KbKbE+WaILB3ch68YJFdA4YTOauzTkrgEMZM0sjom6otQtzvoww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de; spf=pass smtp.mailfrom=cispa.de; dkim=pass (2048-bit key) header.d=cispa.de header.i=@cispa.de header.b=EBVS+Nlz; arc=none smtp.client-ip=134.76.10.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cispa.de
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cispa.de;
	s=2023-rsa; h=CC:To:In-Reply-To:References:Message-ID:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=+0uYMpZbsgaMKEIZnZgI88fnqM5GbA0UO9KY1vw0gjA=; b=EBVS+NlzRtcZ4E+eQClFKUQtX8
	1t+c+PlLot5fCoWxRwUO7nyYWyf51x90+R5uF12XcDXeRq2pM6xvFcy2AP1fd41K2HUeya14IvhCM
	Rvk9c6bSu5KjHYwDAuOGan9H0IGndWO5Y5qAGnCFoKUGMB08yTA1KftI8qQuKftNzyzp1ONMz3q/r
	ccANOmndKUSkX7zvjfYCitHc6T4V39UP4j/6ux+19NvAqcJxh93y1M8YxfBz/MhQnEAbuCSBdzjtH
	aJniGVA01jhnRSBdFxmCPhxbLY0a9ZV0L+yybSt5NGPUvd4qYVYOC3S/LWS4pF29chI0rCoKckl1Y
	7gLDMDpQ==;
Received: from mailer.gwdg.de ([134.76.10.26]:36952)
	by mailer.gwdg.de with esmtp (GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vxQb9-00850c-1k;
	Tue, 03 Mar 2026 15:19:44 +0100
Received: from mbx19-sub-05.um.gwdg.de ([10.108.142.70] helo=email.gwdg.de)
	by mailer.gwdg.de with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
	(GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vxQbA-0006kx-0w;
	Tue, 03 Mar 2026 15:19:44 +0100
Received: from lukass-mbp-7.lan (10.250.9.200) by MBX19-SUB-05.um.gwdg.de
 (10.108.142.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.37; Tue, 3 Mar
 2026 15:19:43 +0100
From: Lukas Gerlach <lukas.gerlach@cispa.de>
Date: Tue, 3 Mar 2026 15:19:44 +0100
Subject: [PATCH v2 4/4] KVM: riscv: Fix Spectre-v1 in PMU counter access
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-ID: <20260303-kvm-riscv-spectre-v1-v2-4-192caab8e0dc@cispa.de>
References: <20260303-kvm-riscv-spectre-v1-v2-0-192caab8e0dc@cispa.de>
In-Reply-To: <20260303-kvm-riscv-spectre-v1-v2-0-192caab8e0dc@cispa.de>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert
 Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones
	<ajones@ventanamicro.com>
CC: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <radim.krcmar@oss.qualcomm.com>,
	<kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
	<linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>, Daniel
 Weber <daniel.weber@cispa.de>, Michael Schwarz <michael.schwarz@cispa.de>,
	Marton Bognar <marton.bognar@kuleuven.be>, Jo Van Bulck
	<jo.vanbulck@kuleuven.be>, Lukas Gerlach <lukas.gerlach@cispa.de>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3343;
 i=lukas.gerlach@cispa.de; h=from:subject:message-id;
 bh=KM1k/pQ3/foiyLLSfk5MnnCFsDCB/OLME+w81duj1l4=;
 b=owGbwMvMwCGWoTIjqP/42kTG02pJDJnL3v5LFkybm1cn++/BAa0/yy6plymyz2XsiHav9FCs7
 F00VV+no5SFQYyDQVZMkWWq4GvGvj0OPEmZh8/BzGFlAhnCwMUpABPpVGP4K3bE+fdtt5DF//PS
 FCKMdr14WR1mWraSv2Lzx/O/Y7sOFjL891YXFWVRiuje7OpjffjZfD8OH76yFT8uBJya9/Xeibf
 JPAA=
X-Developer-Key: i=lukas.gerlach@cispa.de; a=openpgp;
 fpr=9511EB018EBC400C6269C3CE682498528FC7AD61
X-ClientProxiedBy: MBX19-SUB-05.um.gwdg.de (10.108.142.70) To
 MBX19-SUB-05.um.gwdg.de (10.108.142.70)
X-Virus-Scanned: (clean) by clamav
X-Spam-Level: -
X-Rspamd-Queue-Id: 14E131F1579
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_REJECT(1.00)[cispa.de:s=2023-rsa];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[cispa.de : SPF not aligned (relaxed),none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lukas.gerlach@cispa.de,kvm@vger.kernel.org];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.976];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72532-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[cispa.de:-]
X-Rspamd-Action: no action

Guest-controlled counter indices received via SBI ecalls are used to
index into the PMC array. Sanitize them with array_index_nospec()
to prevent speculative out-of-bounds access.

Similar to x86 commit 13c5183a4e64 ("KVM: x86: Protect MSR-based
index computations in pmu.h from Spectre-v1/L1TF attacks").

Fixes: 8f0153ecd3bf ("RISC-V: KVM: Add skeleton support for perf")
Reviewed-by: Radim Krčmář <radim.krcmar@oss.qualcomm.com>
Signed-off-by: Lukas Gerlach <lukas.gerlach@cispa.de>
---
 arch/riscv/kvm/vcpu_pmu.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 4d8d5e9aa53d..0d626f67d08f 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -10,6 +10,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/kvm_host.h>
+#include <linux/nospec.h>
 #include <linux/perf/riscv_pmu.h>
 #include <asm/csr.h>
 #include <asm/kvm_vcpu_sbi.h>
@@ -87,7 +88,8 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
 
 static u64 kvm_pmu_get_perf_event_hw_config(u32 sbi_event_code)
 {
-	return hw_event_perf_map[sbi_event_code];
+	return hw_event_perf_map[array_index_nospec(sbi_event_code,
+						    SBI_PMU_HW_GENERAL_MAX)];
 }
 
 static u64 kvm_pmu_get_perf_event_cache_config(u32 sbi_event_code)
@@ -218,6 +220,7 @@ static int pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned long cidx,
 		return -EINVAL;
 	}
 
+	cidx = array_index_nospec(cidx, RISCV_KVM_MAX_COUNTERS);
 	pmc = &kvpmu->pmc[cidx];
 
 	if (pmc->cinfo.type != SBI_PMU_CTR_TYPE_FW)
@@ -244,6 +247,7 @@ static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 		return -EINVAL;
 	}
 
+	cidx = array_index_nospec(cidx, RISCV_KVM_MAX_COUNTERS);
 	pmc = &kvpmu->pmc[cidx];
 
 	if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW) {
@@ -525,6 +529,7 @@ int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
 		return 0;
 	}
 
+	cidx = array_index_nospec(cidx, RISCV_KVM_MAX_COUNTERS);
 	retdata->out_val = kvpmu->pmc[cidx].cinfo.value;
 
 	return 0;
@@ -559,7 +564,8 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 	}
 	/* Start the counters that have been configured and requested by the guest */
 	for_each_set_bit(i, &ctr_mask, RISCV_MAX_COUNTERS) {
-		pmc_index = i + ctr_base;
+		pmc_index = array_index_nospec(i + ctr_base,
+					       RISCV_KVM_MAX_COUNTERS);
 		if (!test_bit(pmc_index, kvpmu->pmc_in_use))
 			continue;
 		/* The guest started the counter again. Reset the overflow status */
@@ -630,7 +636,8 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 
 	/* Stop the counters that have been configured and requested by the guest */
 	for_each_set_bit(i, &ctr_mask, RISCV_MAX_COUNTERS) {
-		pmc_index = i + ctr_base;
+		pmc_index = array_index_nospec(i + ctr_base,
+					       RISCV_KVM_MAX_COUNTERS);
 		if (!test_bit(pmc_index, kvpmu->pmc_in_use))
 			continue;
 		pmc = &kvpmu->pmc[pmc_index];
@@ -761,6 +768,7 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 		}
 	}
 
+	ctr_idx = array_index_nospec(ctr_idx, RISCV_KVM_MAX_COUNTERS);
 	pmc = &kvpmu->pmc[ctr_idx];
 	pmc->idx = ctr_idx;
 

-- 
2.51.0


