Return-Path: <kvm+bounces-37775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E71AA30146
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:02:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 726D53A5F49
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08F5C1D8A0B;
	Tue, 11 Feb 2025 02:01:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90D501D6199;
	Tue, 11 Feb 2025 02:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739239293; cv=none; b=erfgOjMW7l1nM4xi+zjkbqkW6eY0wEVVVCsOYZh9HUY2Pwc6TyMRySLu2EJ35m+pa0ymHGLJux5qU9UDsT08ic5XTtKyQX3CayMqW2+2PFUBqIdfSOKKEHTYHh0aYngfVfi0ZU+pWI6b9tI2knrUG7rlEvK8Fw3TIFJ3AJrRkb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739239293; c=relaxed/simple;
	bh=1h68JMmBoy5cvlpnj86PtrxlMUHaYCTQ/z8/Ye8D/dA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HQsA7thU2R13Y1rlHl3pLiGfR5EjwL7LJoeiqx3vtLVtHF6QEdK1+lIZ78aTk5ENowfaWEKW/jz/MIJt1rhYiLRmoXxs6wpgmh0UbM/XSzB+ne2aMniUl2Io1twVM6P1T9vhNfXwylhA8F/c7nKbHEAerVnFWWj5v1fz8plx++8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxfWtxr6pntM5xAA--.1560S3;
	Tue, 11 Feb 2025 10:01:21 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMBxLsdur6pnLz8LAA--.44545S5;
	Tue, 11 Feb 2025 10:01:20 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] LoongArch: KVM: Set host with kernel mode when switch to VM mode
Date: Tue, 11 Feb 2025 10:01:18 +0800
Message-Id: <20250211020118.3275874-4-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250211020118.3275874-1-maobibo@loongson.cn>
References: <20250211020118.3275874-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxLsdur6pnLz8LAA--.44545S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

PRMD register is only meaningful on the beginning stage of exception
entry, and it is overwritten with nested irq or exception.

When CPU runs in VM mode, interrupt need be enabled on host. And the
mode for host had better be kernel mode rather than random or user
mode.

When VM is running, running mode with top command comes from CRMD
register, and running mode should be kernel mode since kernel function
is executing with perf command. It needs be consistent with both top and
perf command.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/switch.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
index 0c292f818492..1be185e94807 100644
--- a/arch/loongarch/kvm/switch.S
+++ b/arch/loongarch/kvm/switch.S
@@ -85,7 +85,7 @@
 	 * Guest CRMD comes from separate GCSR_CRMD register
 	 */
 	ori	t0, zero, CSR_PRMD_PIE
-	csrxchg	t0, t0,   LOONGARCH_CSR_PRMD
+	csrwr	t0, LOONGARCH_CSR_PRMD
 
 	/* Set PVM bit to setup ertn to guest context */
 	ori	t0, zero, CSR_GSTAT_PVM
-- 
2.39.3


