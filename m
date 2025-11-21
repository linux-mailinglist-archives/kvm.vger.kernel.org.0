Return-Path: <kvm+bounces-64088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 855F8C7825B
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 10:27:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1DE703661D7
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 09:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5CB7342145;
	Fri, 21 Nov 2025 09:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="5adxCFnY"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CC433F8A4;
	Fri, 21 Nov 2025 09:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763717029; cv=none; b=AsgRu0J4vuiqZ14LXvnD/59yi9XHsnk9tz0yY87dGO2pBWXDvVdYUhQ/bhR1QBURUceHfKYy+PKXy1D0kAaaOy7GaYNsOjVWtCgoSyYtvlWxerWIVWm/c2wS8evSB9Vl62hOfibDBlQXuHYp88euDSIzHFOG2KEtJ1BOWq66IcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763717029; c=relaxed/simple;
	bh=Bt2Hwt9sCR5WG2aRUAwBi8UUiftFYTbEFxblcAUpPr0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r9qRo/hzmYA/eYhe3g34odi7cMXWsjre6oW0UlLWoo5RY+x78L0MzK11rtzNkHP6uC8cjIZjMq2+PcVtqL1FfnAR9vypwhTx9H6z9YXMQu5Bpa+ezKgTUfVPZiG1wur8B+PE+JH7Dfr0pmriahp0wtMEjHt7q6ei/Px5FpqUbqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=5adxCFnY; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=HP4T9Ux78gNIlOGmGsvDsFgk5odPVemp6LKwfalw7UY=;
	b=5adxCFnYtZP2WE1LbfvuKRRXT1JiztDVoW03rbWUI/v5H9cGRx+kWCpAgaUfizgE9Y6O2HdUE
	TpGdLfyM9yjlcDiwechxX0z6rWUmBv/yUFhVPOQh75CmwUzlgaQTVHp3gSmbuKwQkJ1SVDidL9w
	y23dAw0NO6DZhA4Gwb18TsU=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dCV916Swqz1prkV;
	Fri, 21 Nov 2025 17:21:57 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id B0F5018048D;
	Fri, 21 Nov 2025 17:23:43 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 21 Nov
 2025 17:23:43 +0800
From: Tian Zheng <zhengtian10@huawei.com>
To: <maz@kernel.org>, <oliver.upton@linux.dev>, <catalin.marinas@arm.com>,
	<corbet@lwn.net>, <pbonzini@redhat.com>, <will@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <zhengtian10@huawei.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <yezhenyu2@huawei.com>,
	<xiexiangyou@huawei.com>, <zhengchuan@huawei.com>, <linuxarm@huawei.com>,
	<joey.gouly@arm.com>, <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<suzuki.poulose@arm.com>
Subject: [PATCH v2 1/5] arm64/sysreg: Add HDBSS related register information
Date: Fri, 21 Nov 2025 17:23:38 +0800
Message-ID: <20251121092342.3393318-2-zhengtian10@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251121092342.3393318-1-zhengtian10@huawei.com>
References: <20251121092342.3393318-1-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100010.china.huawei.com (7.202.195.125)

From: eillon <yezhenyu2@huawei.com>

The ARM architecture added the HDBSS feature and descriptions of
related registers (HDBSSBR/HDBSSPROD) in the DDI0601(ID121123) version,
add them to Linux.

Signed-off-by: eillon <yezhenyu2@huawei.com>
Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
---
 arch/arm64/include/asm/esr.h     |  2 ++
 arch/arm64/include/asm/kvm_arm.h |  1 +
 arch/arm64/tools/sysreg          | 28 ++++++++++++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index e1deed824464..a6f3cf0b9b86 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -159,6 +159,8 @@
 #define ESR_ELx_CM 		(UL(1) << ESR_ELx_CM_SHIFT)

 /* ISS2 field definitions for Data Aborts */
+#define ESR_ELx_HDBSSF_SHIFT	(11)
+#define ESR_ELx_HDBSSF		(UL(1) << ESR_ELx_HDBSSF_SHIFT)
 #define ESR_ELx_TnD_SHIFT	(10)
 #define ESR_ELx_TnD 		(UL(1) << ESR_ELx_TnD_SHIFT)
 #define ESR_ELx_TagAccess_SHIFT	(9)
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 1da290aeedce..b71122680a03 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -124,6 +124,7 @@
 			 TCR_EL2_ORGN0_MASK | TCR_EL2_IRGN0_MASK)

 /* VTCR_EL2 Registers bits */
+#define VTCR_EL2_HDBSS		(1UL << 45)
 #define VTCR_EL2_DS		TCR_EL2_DS
 #define VTCR_EL2_RES1		(1U << 31)
 #define VTCR_EL2_HD		(1 << 22)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 1c6cdf9d54bb..f489703338b5 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4408,6 +4408,34 @@ Sysreg	GCSPR_EL2	3	4	2	5	1
 Fields	GCSPR_ELx
 EndSysreg

+Sysreg	HDBSSBR_EL2	3	4	2	3	2
+Res0	63:56
+Field	55:12	BADDR
+Res0	11:4
+Enum	3:0	SZ
+	0b0001	8KB
+	0b0010	16KB
+	0b0011	32KB
+	0b0100	64KB
+	0b0101	128KB
+	0b0110	256KB
+	0b0111	512KB
+	0b1000	1MB
+	0b1001	2MB
+EndEnum
+EndSysreg
+
+Sysreg	HDBSSPROD_EL2	3	4	2	3	3
+Res0	63:32
+Enum	31:26	FSC
+	0b000000	OK
+	0b010000	ExternalAbort
+	0b101000	GPF
+EndEnum
+Res0	25:19
+Field	18:0	INDEX
+EndSysreg
+
 Sysreg	DACR32_EL2	3	4	3	0	0
 Res0	63:32
 Field	31:30	D15
--
2.33.0


