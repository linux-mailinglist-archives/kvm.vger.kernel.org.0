Return-Path: <kvm+bounces-71769-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aHgHJ+B0nmnCVQQAu9opvQ
	(envelope-from <kvm+bounces-71769-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:04:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 45C87191730
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:04:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 08E1130692C4
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D32671E834B;
	Wed, 25 Feb 2026 04:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="iJbwssON"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45BA155C82;
	Wed, 25 Feb 2026 04:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771992269; cv=none; b=hhL9GIKg8moVcxvOcu+r1A0ZR1cYXY70THIAfnxnZK26pjiHYGA9zZgkicvMVd2kmXK1NZvG1Umbvpb6Tx1X82deCw/FHqStpgW+DBZkk6f2TgHubC/SaNb3+F1NwuMYh5CdBvQy2fhZp+UROwJ3dP2YAapIiuL2lRTqVIBO1D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771992269; c=relaxed/simple;
	bh=ENenO/cy/T/hJWbdFyRSqVxSeHMgdjnk3MQXCRXpHX0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mYsx7Xo917Di91C0w9Cs/laXOzS5hOUEbtBepGmlgB1M5nTVJpelgskbpLw8A8vfK6G+uAYK2N0oumT4I7AcV6L3QunD5lbZA9lP1KjjjCiPASz9yBl5/1ZgQZlHaFF4D9bxsFTSRZKEVeWtdKDoamRFE+s4p8rDULSRFuSchKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=iJbwssON; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lvq/O+R+y6qCmOEUVjR2PUgdD2ilp/5PaX6r9kRJGgc=;
	b=iJbwssONMnPTRBgo5fw1t6+rLsbPEMOcqvZPDl2ktV9XH7Kf26BtkeotL5os9jUmfXVD/ezk5
	YwA7byABP7pxRQ9yfdlnqIAlzDD9ze6AwIYfP09dDFKaLIhN6ZECjyvQWl0RtgMlbKV8AhdTkhs
	CtMZYK070yqV7n0l4XDFoV4=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4fLLSn6sNVzRhRJ;
	Wed, 25 Feb 2026 11:59:37 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 021D640569;
	Wed, 25 Feb 2026 12:04:24 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 25 Feb
 2026 12:04:23 +0800
From: Tian Zheng <zhengtian10@huawei.com>
To: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<corbet@lwn.net>, <pbonzini@redhat.com>, <will@kernel.org>,
	<zhengtian10@huawei.com>
CC: <yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>,
	<liuyonglong@huawei.com>, <Jonathan.Cameron@huawei.com>,
	<yezhenyu2@huawei.com>, <linuxarm@huawei.com>, <joey.gouly@arm.com>,
	<kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <skhan@linuxfoundation.org>,
	<suzuki.poulose@arm.com>, <leo.bras@arm.com>
Subject: [PATCH v3 1/5] arm64/sysreg: Add HDBSS related register information
Date: Wed, 25 Feb 2026 12:04:17 +0800
Message-ID: <20260225040421.2683931-2-zhengtian10@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260225040421.2683931-1-zhengtian10@huawei.com>
References: <20260225040421.2683931-1-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100010.china.huawei.com (7.202.195.125)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[huawei.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[huawei.com:s=dkim];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71769-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zhengtian10@huawei.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[huawei.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[22];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,huawei.com:mid,huawei.com:dkim,huawei.com:email]
X-Rspamd-Queue-Id: 45C87191730
X-Rspamd-Action: no action

From: eillon <yezhenyu2@huawei.com>

The ARM architecture added the HDBSS feature and descriptions of
related registers (HDBSSBR/HDBSSPROD) in the DDI0601(ID121123) version,
add them to Linux.

Signed-off-by: eillon <yezhenyu2@huawei.com>
Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
---
 arch/arm64/include/asm/esr.h |  2 ++
 arch/arm64/tools/sysreg      | 29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 7e86d400864e..81c17320a588 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -160,6 +160,8 @@
 #define ESR_ELx_CM 		(UL(1) << ESR_ELx_CM_SHIFT)

 /* ISS2 field definitions for Data Aborts */
+#define ESR_ELx_HDBSSF_SHIFT	(11)
+#define ESR_ELx_HDBSSF		(UL(1) << ESR_ELx_HDBSSF_SHIFT)
 #define ESR_ELx_TnD_SHIFT	(10)
 #define ESR_ELx_TnD 		(UL(1) << ESR_ELx_TnD_SHIFT)
 #define ESR_ELx_TagAccess_SHIFT	(9)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 9d1c21108057..e166ab322de2 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4528,6 +4528,35 @@ Sysreg	GCSPR_EL2	3	4	2	5	1
 Fields	GCSPR_ELx
 EndSysreg

+Sysreg	HDBSSBR_EL2	3	4	2	3	2
+Res0	63:56
+Field	55:12	BADDR
+Res0	11:4
+Enum	3:0	SZ
+	0b0000	4KB
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


