Return-Path: <kvm+bounces-72001-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GDY1O9VZoGlPigQAu9opvQ
	(envelope-from <kvm+bounces-72001-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:33:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7411E1A79F7
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:33:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 98116320423C
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFE393D4105;
	Thu, 26 Feb 2026 14:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=cispa.de header.i=@cispa.de header.b="kFRAjPxJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx-2023-1.gwdg.de (mx-2023-1.gwdg.de [134.76.10.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223163D3490;
	Thu, 26 Feb 2026 14:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.76.10.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772115603; cv=none; b=BW+d10DsLvbS1Gf698o4GAFJM/j8VspLms9C4HodkXhWrjRr/V8fn7gpsBaJPP5yBadVAsvJHTNwVURVu2K1eCvX+WHzE1UFmh9+MPrMFFwZvQ5xN3M+rB43666ib5pTx9o56usifei7xE/epJ50SXwlUs5R6GXzSAit8/k2vl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772115603; c=relaxed/simple;
	bh=YZqp1yUGYjA7iib6n3620o4zfE8Rd3Vv7AqvASBWfHE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=U55wzPc3KGN1XiHHJMFlwb/vwbFi8RmAHQmFmYDIyMJcg1HpOMf2UGwTERgBC23/KXevHji/bFojkLeOCoQRgyE6qm+QtwQD1bUk5Kpkz2M7XTYTIZGNd1LFPwP79jJYtVEmlnBi8EZL8Wk2YpXW2lIATxuqhS0KXNIpMiZavdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de; spf=pass smtp.mailfrom=cispa.de; dkim=pass (2048-bit key) header.d=cispa.de header.i=@cispa.de header.b=kFRAjPxJ; arc=none smtp.client-ip=134.76.10.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cispa.de
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cispa.de;
	s=2023-rsa; h=CC:To:In-Reply-To:References:Message-ID:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Xs8FqUyiDcrl0oz5B+yrANDPYmzquqmYyOAUxwBeuIY=; b=kFRAjPxJwJjd0qXf13kaowAQKz
	HiQEUqbA0ZYt14X0+5udRC0jEXqFp/RzBHKYyVT/dBe12a/BhyLM5sBvyYFOeG8QZHJdIgAVub6MZ
	22W1dhDLHaphiQjf5c7qD3ZaryOWIIJovDSUYFUTMDPsNYFqVBuZ8PFX4H4yXyyN3YLf6LulPlcKJ
	jMzVjGEiqc6YTi9w6H6IwQBsRKksNpxmauAyl3XQvLDyhpvDIMq8hfWfnHO8+sKKnu9MvKPBxxH+U
	kdEtlqe/JYaFj9qK5KClSqWauMfkhpxV49GFlYNIcielf6w70Pr2CRYcCRBoc8hUEhUO8DhmuZyhV
	Ijv76jeA==;
Received: from mailer.gwdg.de ([134.76.10.26]:47859)
	by mailer.gwdg.de with esmtp (GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vvcDe-006EHW-1b;
	Thu, 26 Feb 2026 15:19:59 +0100
Received: from mbx19-sub-05.um.gwdg.de ([10.108.142.70] helo=email.gwdg.de)
	by mailer.gwdg.de with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
	(GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vvcDf-000AAd-09;
	Thu, 26 Feb 2026 15:19:59 +0100
Received: from
 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa
 (10.250.9.200) by MBX19-SUB-05.um.gwdg.de (10.108.142.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.37; Thu, 26 Feb 2026 15:19:58 +0100
From: Lukas Gerlach <lukas.gerlach@cispa.de>
Date: Thu, 26 Feb 2026 15:19:01 +0100
Subject: [PATCH 4/4] KVM: riscv: Fix Spectre-v1 in PMU counter access
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260226-kvm-riscv-spectre-v1-v1-4-5f930ea16691@cispa.de>
References: <20260226-kvm-riscv-spectre-v1-v1-0-5f930ea16691@cispa.de>
In-Reply-To: <20260226-kvm-riscv-spectre-v1-v1-0-5f930ea16691@cispa.de>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert
 Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones
	<ajones@ventanamicro.com>
CC: <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
	<linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>, Daniel
 Weber <daniel.weber@cispa.de>, Michael Schwarz <michael.schwarz@cispa.de>,
	Marton Bognar <marton.bognar@kuleuven.be>, Jo Van Bulck
	<jo.vanbulck@kuleuven.be>, Lukas Gerlach <lukas.gerlach@cispa.de>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1687;
 i=lukas.gerlach@cispa.de; h=from:subject:message-id;
 bh=YZqp1yUGYjA7iib6n3620o4zfE8Rd3Vv7AqvASBWfHE=;
 b=owGbwMvMwCGWoTIjqP/42kTG02pJDJkLwuLnTzq5/x/L7easB2G+e5TrrqjMOON1av0iPe6DY
 n0fwnwNO0pZGMQ4GGTFFFmmCr5m7NvjwJOUefgczBxWJpAhDFycAjCRIlVGhv7fGxdd2smhEvNV
 al/AxIDu0CQOgTx+uSNia61n6Src52b477nhm07Xu5lrvjLaB8asNu69tMX9wf5P515qtO19sl5
 7GysA
X-Developer-Key: i=lukas.gerlach@cispa.de; a=openpgp;
 fpr=9511EB018EBC400C6269C3CE682498528FC7AD61
X-ClientProxiedBy: mbx19-sub-02.um.gwdg.de (10.108.142.55) To
 MBX19-SUB-05.um.gwdg.de (10.108.142.70)
X-Virus-Scanned: (clean) by clamav
X-Spam-Level: -
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_REJECT(1.00)[cispa.de:s=2023-rsa];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[cispa.de : SPF not aligned (relaxed),none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72001-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[cispa.de:-];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lukas.gerlach@cispa.de,kvm@vger.kernel.org];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[cispa.de:mid,cispa.de:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7411E1A79F7
X-Rspamd-Action: no action

Guest-controlled counter indices received via SBI ecalls are used to
index into the PMC array. Sanitize them with array_index_nospec()
to prevent speculative out-of-bounds access.

Similar to x86 commit 13c5183a4e64 ("KVM: x86: Protect MSR-based
index computations in pmu.h from Spectre-v1/L1TF attacks").

Fixes: 8f0153ecd3bf ("RISC-V: KVM: Add skeleton support for perf")
Signed-off-by: Lukas Gerlach <lukas.gerlach@cispa.de>
---
 arch/riscv/kvm/vcpu_pmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 4d8d5e9aa53d..fd891750c31f 100644
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
@@ -218,6 +219,7 @@ static int pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned long cidx,
 		return -EINVAL;
 	}
 
+	cidx = array_index_nospec(cidx, RISCV_KVM_MAX_COUNTERS);
 	pmc = &kvpmu->pmc[cidx];
 
 	if (pmc->cinfo.type != SBI_PMU_CTR_TYPE_FW)
@@ -244,6 +246,7 @@ static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 		return -EINVAL;
 	}
 
+	cidx = array_index_nospec(cidx, RISCV_KVM_MAX_COUNTERS);
 	pmc = &kvpmu->pmc[cidx];
 
 	if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW) {
@@ -525,6 +528,7 @@ int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
 		return 0;
 	}
 
+	cidx = array_index_nospec(cidx, RISCV_KVM_MAX_COUNTERS);
 	retdata->out_val = kvpmu->pmc[cidx].cinfo.value;
 
 	return 0;

-- 
2.51.0


