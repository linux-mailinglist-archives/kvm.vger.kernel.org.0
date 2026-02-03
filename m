Return-Path: <kvm+bounces-69967-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IIcnLNFsgWmwGAMAu9opvQ
	(envelope-from <kvm+bounces-69967-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 04:34:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 17D82D42A0
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 04:34:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1257E309B504
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 03:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11464325727;
	Tue,  3 Feb 2026 03:31:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ABBF1509AB;
	Tue,  3 Feb 2026 03:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770089501; cv=none; b=PS85UhsrL9yK2brsTKJo8v6KlAqgNcjR00jtqf+w0sLcJMXLhRgYvIGDNSbkAwc4DW0AQP7C9RwhZfbwW3U4qFZ+RZfYYJPETmcz8pBVGHTWirVN2sWauASTNbGdlvo4RdwQeiy1o1lNQlbm+3WkCY0lgsXc8aWi7yPOOgxJ3fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770089501; c=relaxed/simple;
	bh=xC/mBpkw8yThP6c9unSLcf5AI5sUC6VB5UXkswDOcx4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Z2vDtvRGGbF0L2NNw0KSCmOB6pz0y3TJuUfVncsirOEgL3ktzBB9Nbm3fJcK7m7QRcV2Gkknx8iT4lHay2ADM+h5MQ45klSWHeX1xyai7ya/Pt2aGVsuu5/DRAA4uX7YThcjP8w4ZyKIybZbf/tSzSMQlvuqd0635I5hIWz29MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxecIWbIFp2zwPAA--.49004S3;
	Tue, 03 Feb 2026 11:31:34 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJAxGMEVbIFpbtk+AA--.37628S2;
	Tue, 03 Feb 2026 11:31:34 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v3 0/4] LoongArch: KVM: Add FPU delay load support
Date: Tue,  3 Feb 2026 11:31:27 +0800
Message-Id: <20260203033131.3372834-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxGMEVbIFpbtk+AA--.37628S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	DMARC_NA(0.00)[loongson.cn];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-69967-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[loongson.cn:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 17D82D42A0
X-Rspamd-Action: no action

FPU is lazy enabled in KVM hypervisor. After FPU is enabled and loaded,
vCPU can be preempted and FPU will be lost, there will be FPU exception
and FPU load again.

Here FPU is delay load until guest enter entry.

---
v2 ... v3:
  1. Add LBT delay load support also.

v1 ... v2:
  1. Keep funtion trace_kvm_aux() with FPU restore called still, only
     remove preempt disable/enable API call.
  2. Use one KVM_REQ_FPU_LOAD request bit and add fpu_load_type int
     type, remove KVM_REQ_LSX_LOAD/KVM_REQ_LASX_LOAD request bit
---
Bibo Mao (4):
  LoongArch: KVM: Move LSX capability check in LSX exception handler
  LoongArch: KVM: Move LASX capability check in LASX exception handler
  LoongArch: KVM: Move LBT capability checking in LBT exception handler
  LoongArch: KVM: Add FPU delay load support

 arch/loongarch/include/asm/kvm_host.h |  2 ++
 arch/loongarch/kvm/exit.c             | 21 +++++++++---
 arch/loongarch/kvm/vcpu.c             | 46 +++++++++++++++------------
 3 files changed, 44 insertions(+), 25 deletions(-)


base-commit: dee65f79364c18033cabdf0728c7e7025405cf40
-- 
2.39.3


