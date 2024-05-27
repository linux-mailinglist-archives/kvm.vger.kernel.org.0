Return-Path: <kvm+bounces-18168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12C638CFA60
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 09:47:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A91951F218E2
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 07:47:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D36813B295;
	Mon, 27 May 2024 07:46:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 582802207A;
	Mon, 27 May 2024 07:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716796015; cv=none; b=RAKKG9aYdi2d00WREqXP4U4k4+qCGX15mixyCJy+CHgjei0Fa+/69I512Dy5zjRIqx/+4e+b+k3OsqFIR4+X45jkxI4HEcDyH1Pe3Ps65oOftCh9B59GjtqFlEP9q11GZ45FgnqJgqO2zpZJPoLf5HhhCx6oyWeLHLYKB19/qnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716796015; c=relaxed/simple;
	bh=EBDVXOmgMgfl8zYiYQw+LxzSeEjy1MIY+uBc1KG6b70=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kUIYoa0reDNOcUqLZSTX7DJDQFL9TjcnSLoP2CVcwjalg4e60woDVX7B/7Hn0FdJ190C2FX0sQTXyI6ZkWCdRATn9OqUKMlx6+7ie6NbB4oiIQtBo/0iuOuIyAkJQHfrnYu+gPYqZprZD/wfG4jyeGBh9FvwPaUWirudTbFF6KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxX+tmOlRmtB4AAA--.492S3;
	Mon, 27 May 2024 15:46:46 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxTcdlOlRmHuIKAA--.28594S4;
	Mon, 27 May 2024 15:46:45 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/4] LoongArch: KVM: Add LBT feature detection with cpucfg
Date: Mon, 27 May 2024 15:46:42 +0800
Message-Id: <20240527074644.836699-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240527074644.836699-1-maobibo@loongson.cn>
References: <20240527074644.836699-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxTcdlOlRmHuIKAA--.28594S4
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
index 8f80d1a2dcbb..c32aff8e261e 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -537,6 +537,12 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
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


