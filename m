Return-Path: <kvm+bounces-60146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B453BE4B3B
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 18:57:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4BD93B4C21
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 16:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F09A633436F;
	Thu, 16 Oct 2025 16:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="aNJT16tk"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster3-host10-snip4-10.eps.apple.com [57.103.77.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903D2262A6
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 16:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.77.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760633819; cv=none; b=MLIf70EeuOY3NqZQl+poADreGnfTZh6ZnsfJ54oG50CdcjrNhqtUrk0lc68tuIFNgzBt+pRZTwjKTV8BfRqO3oAQmmQeDKdg3MpcHI1C6pjkqWe6/IjBEddsjopANlcHJsxA9s7NurIqC8R0ZgqBeiPQx1H5OiiAk8wkNCnvn0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760633819; c=relaxed/simple;
	bh=mKOOQdRDvxI9Uojdj/BgnmMk2A8ZYpleMygPMrBuf9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eO06U+zgqkJ+XV359xOExIWHEzFoxpppil0b3Dssxf9nFvtxX/GAMdWSyUT7JL7vdVwuF0Ck1IPjyGPGCJ/uurc/hIdpFJyTvd9ei7eygoReV6krchcwpOIQ5hvyFlLesBrQLYdFLUIvjCWyIxt3bF9VEZJFhxupsbWe/GUTkqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=aNJT16tk; arc=none smtp.client-ip=57.103.77.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPS id A43D418004B8;
	Thu, 16 Oct 2025 16:56:52 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=nGiC4vvLFeGAkADkjW8ilOYUekcixIQky++Ch/YLq1E=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=aNJT16tkt+vUVMUOid7yxBIV7Hv2XqidUy/lyY9mQ7ekLGWclZ5Po/kkaS0aDANnlubOYwfazWHXuXUwzt44+ZbE8TMl3fL0A1GTjqbhLZdot0m3d9sRpQ7i5vPH11tN/8BN/QcLPZk+93LpBWKQCJhDUIYWJrWC6wNe95h3Pnl+9LWJDXGW+GFURJu00fiQ0wTfva2O1X533ESUSTq1HOJ6WwCWrpL7+5FOOCr+ZCumlGJwgIzGmbONME6Wj2jMWddzo65+HliOhPsehKQ9OFbZ6jiN+wI2wQuiXeQvEyN5NIyHXEA2LlCFpBswjsE3qmX0nMjf2ZJqfDBalbwJYg==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPSA id AC18818015CB;
	Thu, 16 Oct 2025 16:55:26 +0000 (UTC)
From: Mohamed Mediouni <mohamed@unpredictable.fr>
To: qemu-devel@nongnu.org
Cc: Alexander Graf <agraf@csgraf.de>,
	Richard Henderson <richard.henderson@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Mads Ynddal <mads@ynddal.dk>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Eduardo Habkost <eduardo@habkost.net>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Pedro Barbuda <pbarbuda@microsoft.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v7 01/24] target/arm/kvm: add constants for new PSCI versions
Date: Thu, 16 Oct 2025 18:54:57 +0200
Message-ID: <20251016165520.62532-2-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251016165520.62532-1-mohamed@unpredictable.fr>
References: <20251016165520.62532-1-mohamed@unpredictable.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 2P6_nQ2K_PRuQ02V8I4qDASI7ROqXait
X-Proofpoint-GUID: 2P6_nQ2K_PRuQ02V8I4qDASI7ROqXait
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyMiBTYWx0ZWRfXxB5pnUHnDdsi
 mz6YyRcCSi5qjr9uWadFnzELq2h1KKKtv8X/17mjYVwfWsQhUgOlpN+lmtx3ehV/8xOgGWc7GxT
 RE8I2frzn/+FgwNThJi3u1+QTTI1y+nGGYi94a/RWVvDVszbesxzbltq6luc4XDtLjFevTHVPNp
 mwX7JwZIMwjUGyZ5axUIq0ZJ8GPmjOtwESJm5SlToKFlBO5+3WxlcPA88loJKcdSDmmY6D8hOd8
 mz45lvciM9JjeU3y2INUA4/QVOe+R5fH2UB+lgJKfeerF/gtWndpmZMvm+baPfNoPSlZ3Tsws=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 phishscore=0 mlxlogscore=989 mlxscore=0 clxscore=1030 bulkscore=0
 malwarescore=0 adultscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2506270000 definitions=main-2510160122
X-JNJ: AAAAAAABBBnjGaA5gXCJrkVbwP6mm1FeJgj5gK6PMGMlGeibz3Uy+7iaEd48txmnGkRtl7V8kvn0bFrp55QwD6iQWn/NwDhwh+koz6t5763lUHtRjBYrHR9Uy7xs83ks16Yldg4SLSis0kW1XXWO2otvtJUbDdDFp1uVKQsemOHttSDWXqkbrVyB58pH9snscfBXh9izk9ItSvDo2OkSSr7Ft4c+JMeeCfYnUX7iC0BBUkEQnNClCtIxRcNplf7rkEMh+7qYYROmd5Giz2diWmm9Y7ypRhKnBwx90NTIXDYG1pbinPxvXAo108TXvDG1rpeT7cXYmFa3AiA97Qt6qBWFn+fLyY0TZ0rJRoQ16i7cV3IGc4FWVBfEb46gaMaVt9jI9yD9UnhsPp0W4t+SonQZRI5bXH6kxF4Vvl75Bpt/lBCYHoEsWYLVLxcVhH6i0L2ZRPqpqDDBfWeuRzAXjpznnuG2Xqljvs1PwsQESxVLGb+IiaZjWdHkDUWoJevjJQ4CdkG6XncDOvqVNFMWh2iKoW32VBPhzaBRr0Nsgrtf+8P5sa0EpBirgjC5Ii8TwOJr9L7tKSNiozKJDO//HMLZJ9aWFeeeyF0HiRd3WH+/ZspR31klc6wXyMH8ezBqZioyoM3LXGr/oK1LB7ogCzLo4tcWv8ffIdJl95NAeVEfKFsUHHvkSouFvbi69PGqwgE1Mq9fvbH3n+mXUgyLGMzgXE7bGwM8BhRmKSRphzTeVw6sray1OTZh8Giu3VRNtilHu1piiT5z/A6EW4KuzpUWl4MWz6sFczpKrMVxDbezsi9LuJuKCnI5zvju1QccpkHi6ro7mJ1swjQNhRhZImAcvpN6YNuruuqOBMj+vw4bPh6tSeKdRF9dcFTAVfH3Bdy6IBIAWSk09bTaO80Gim5+

From: Sebastian Ott <sebott@redhat.com>

Add constants for PSCI version 1_2 and 1_3.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 target/arm/kvm-consts.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/arm/kvm-consts.h b/target/arm/kvm-consts.h
index 54ae5da7ce..9fba3e886d 100644
--- a/target/arm/kvm-consts.h
+++ b/target/arm/kvm-consts.h
@@ -97,6 +97,8 @@ MISMATCH_CHECK(QEMU_PSCI_1_0_FN_PSCI_FEATURES, PSCI_1_0_FN_PSCI_FEATURES);
 #define QEMU_PSCI_VERSION_0_2                     0x00002
 #define QEMU_PSCI_VERSION_1_0                     0x10000
 #define QEMU_PSCI_VERSION_1_1                     0x10001
+#define QEMU_PSCI_VERSION_1_2                     0x10002
+#define QEMU_PSCI_VERSION_1_3                     0x10003
 
 MISMATCH_CHECK(QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED, PSCI_0_2_TOS_MP);
 /* We don't bother to check every possible version value */
-- 
2.50.1 (Apple Git-155)


