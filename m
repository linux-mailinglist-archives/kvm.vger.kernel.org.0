Return-Path: <kvm+bounces-17278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7A8B8C39C7
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 03:12:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 873481F2123F
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 01:12:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BED8CDDBD;
	Mon, 13 May 2024 01:12:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4BFFAD31;
	Mon, 13 May 2024 01:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715562767; cv=none; b=PLOMY2vN4s1JSBhYDGaz7DMQgpg/hINMhfx5djZ/99Te+V1MMFdUwXFF+lWfCpG8tcDuQC83o6JnZ4yIuRLGW7ZK6iRaeiNg6kV841vXsPQMkOK9zxSnn7c8BQRnuI0X3mGIX7lHDRqajaFE5ZyVNbui0qt15n4abguqFu8ILx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715562767; c=relaxed/simple;
	bh=ph6pyDJp1Q8793pUOXTnM343FcWHbxA0ThxDlcB6iz0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Eg+gkIsaG+OQbVu4A4agAiQ+4oBPjSEiOuZewpbj9w2t4+GmVdjgvupvX+eF9EBhSZBafYboP8DWGfYP14M3KpODKqgNWGaKNh6uBQd3QwthJZBr6tIBjR6RKtXECHEJWiqaAt75QJrBuixSPc8Y/6aQwmllEzCshRYjuK9OQ4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxV_AFaUFmjv0LAA--.29710S3;
	Mon, 13 May 2024 09:12:37 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Ax690DaUFmV1gcAA--.51334S4;
	Mon, 13 May 2024 09:12:36 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] LoongArch: KVM: Add LBT feature detection with cpucfg
Date: Mon, 13 May 2024 09:12:34 +0800
Message-Id: <20240513011235.3233776-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240513011235.3233776-1-maobibo@loongson.cn>
References: <20240513011235.3233776-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Ax690DaUFmV1gcAA--.51334S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Loongson Binary Translation (LBT) feature is defined in register
cpucfg2. Here LBT capability detection for VM is added.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index d93ec21269da..b2856539368a 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -532,6 +532,12 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
 			*v |= CPUCFG2_LSX;
 		if (cpu_has_lasx)
 			*v |= CPUCFG2_LASX;
+		if (cpu_has_lbt_x86)
+			*v |= CPUCFG2_X86BT;
+		if (cpu_has_lbt_arm)
+			*v |= CPUCFG2_ARMBT;
+		if (cpu_has_lbt_mips)
+			*v |= CPUCFG2_MIPSBT;
 
 		return 0;
 	case LOONGARCH_CPUCFG3:
-- 
2.39.3


