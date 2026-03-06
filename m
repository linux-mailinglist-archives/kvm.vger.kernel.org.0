Return-Path: <kvm+bounces-72994-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SNOECneEqmnRSwEAu9opvQ
	(envelope-from <kvm+bounces-72994-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 08:38:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 87B4421C8B1
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 08:38:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BAD67300D740
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 07:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 450E43750BB;
	Fri,  6 Mar 2026 07:38:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E98375F6D;
	Fri,  6 Mar 2026 07:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772782691; cv=none; b=LS9AmSk2ZrO+8AX1xYeAlHP5VryRNFXOwjn0mTnLkG2aJ/+y76byz0rUnq1ar86B/CrxX2njZglN4gsOsxuiy1ZyQwetmtU/7X1p/pXF8lY8nV9XDrLBSM6qsytshTJubBaYC5GyhH3YBvQIY5nyLcy/ZFs8ReKWbmCyyeZU0Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772782691; c=relaxed/simple;
	bh=fzg++KsgVr1ZMcQc2GYBomHZ7Tljflo24TGzZiJpFD0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GrmEMhXXeOBNxQN/qoNystevBeynOEP0fGUDCcHBZDW5e6AJSjvUXfAcbLxltJHHKtKkUgFn5wX4KKUHZDrZy/nSpiG1MWotoGTBNLQ/xp6PuB1sClenuZfzB9ADR1BQcvON/2HYM54t1xHFroHvZY5r1oZnkyvzljsF9NInakk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from fric.. (unknown [210.73.43.101])
	by APP-05 (Coremail) with SMTP id zQCowAAXpglFhKppgcC9CQ--.1822S3;
	Fri, 06 Mar 2026 15:37:43 +0800 (CST)
From: Jiakai Xu <xujiakai2025@iscas.ac.cn>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Andrew Jones <ajones@ventanamicro.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Atish Patra <atish.patra@linux.dev>,
	Anup Patel <anup@brainfault.org>,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>,
	Jiakai Xu <jiakaiPeanut@gmail.com>
Subject: [PATCH 1/2] RISC-V: KVM: Fix array out-of-bounds in pmu_ctr_read()
Date: Fri,  6 Mar 2026 07:37:38 +0000
Message-Id: <20260306073739.3441292-2-xujiakai2025@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260306073739.3441292-1-xujiakai2025@iscas.ac.cn>
References: <20260306073739.3441292-1-xujiakai2025@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAAXpglFhKppgcC9CQ--.1822S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw43uw45GF1xXw43Ar1fJFb_yoW8Ar15pr
	sFkr9a93s5trs29w1Yyw1Duw4jyw4kGan8CrWDGF18Ar4a9r97JF1v93srJr1fAFZFqa4x
	ta1Fka4xCFW5Xa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	c4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S
	6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxw
	ACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
	vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IY
	x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26c
	xKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAF
	wI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUn18PUUUUU=
X-CM-SenderInfo: 50xmxthndljiysv6x2xfdvhtffof0/1tbiBgwSCWmqYdd74wAAs8
X-Rspamd-Queue-Id: 87B4421C8B1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72994-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[13];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[iscas.ac.cn];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[ventanamicro.com,ghiti.fr,eecs.berkeley.edu,dabbelt.com,kernel.org,linux.dev,brainfault.org,iscas.ac.cn,gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xujiakai2025@iscas.ac.cn,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

When a guest invokes SBI_EXT_PMU_COUNTER_FW_READ on a firmware counter
that has not been configured via SBI_EXT_PMU_COUNTER_CFG_MATCH, the
pmc->event_idx remains SBI_PMU_EVENT_IDX_INVALID (0xFFFFFFFF).
get_event_code() extracts the lower 16 bits, yielding 0xFFFF (65535),
which is then used to index into kvpmu->fw_event[]. Since fw_event is
only RISCV_KVM_MAX_FW_CTRS (32) entries, this triggers an
array-index-out-of-bounds:

  UBSAN: array-index-out-of-bounds in arch/riscv/kvm/vcpu_pmu.c:255:37
  index 65535 is out of range for type 'kvm_fw_event [32]'

Add a bounds check on fevent_code before accessing the fw_event array,
returning -EINVAL for invalid event codes.

Fixes: badc386869e2c ("RISC-V: KVM: Support firmware events")
Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
---
 arch/riscv/kvm/vcpu_pmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index e873430e596b..c6d42459c2a1 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -252,6 +252,10 @@ static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 
 	if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW) {
 		fevent_code = get_event_code(pmc->event_idx);
+		if (fevent_code >= SBI_PMU_FW_MAX) {
+			pr_warn("Invalid firmware event code [%d] for counter [%ld]\n", fevent_code, cidx);
+			return -EINVAL;
+		}
 		pmc->counter_val = kvpmu->fw_event[fevent_code].value;
 	} else if (pmc->perf_event) {
 		pmc->counter_val += perf_event_read_value(pmc->perf_event, &enabled, &running);
-- 
2.34.1


