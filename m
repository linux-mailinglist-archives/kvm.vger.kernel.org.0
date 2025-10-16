Return-Path: <kvm+bounces-60167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id F367DBE4BA9
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:00:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7830E359AA8
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64555393DD5;
	Thu, 16 Oct 2025 16:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="G5fbOyvH"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster1-host8-snip4-8.eps.apple.com [57.103.76.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72D0393DC5
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 16:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760633866; cv=none; b=QXzZ6kgBik03Ms0rVuhvHWxkY+C21w66l/x2Q6Y2rayM9L34cG5tzyh5Bs2u8G6qejJBie+YScOyxv25PQmZKs5eyKm1wm7AO5o0f9KLSAYtuFAmaSzf8WipfRkmSOpw60HbtWgRyP/ctI4RxfxcxQF5hR7gVBo0TnllaF5emqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760633866; c=relaxed/simple;
	bh=lldKFL6T36zAxLV6jFKCjM94yaEYRULJC/1BRT3nBcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxBhbX149kot01QF2pwySOcgnyFKeJW1y7HgzQO5YqnaVUpSga6AuLt94c5xmIhC976RgfuGKn7ZGX0wBsTEJAc7KqVROx595GHW1cronLbrixc3vUShjuNTL5qSnDCT+zoN39Qt6EnoMJoYuAG0uX2myzW10Tc+JCCkNFenx98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=G5fbOyvH; arc=none smtp.client-ip=57.103.76.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPS id 31CF318004AF;
	Thu, 16 Oct 2025 16:57:32 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=XY0aRLNzrnTUVd3ei9jMIMiM8ijXecVFkp2kgf3sj3c=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=G5fbOyvHJVvgmn47PEMp7WVDlwecLoNfGzreo6Ra1tG5G9dXBpnH+HBzlIIoE2Q3h4mlwGsBzbCs+TJ28RVpf/wtI1FxhP6nWXJehu897bNb8rQPJfVEFZm/aILvM47OQWa9XGV1dBoHZhj1vHEmsrDPj/wzcNu9E4uEkjZh5WJt6GhgwV0kz3wtut+BdvMpulXBO4fW2cj+qn/Ew96tJtb8mnboZiUyJpo3RaEbXNa+Jl9JKFpQz9I8QLk2GjkWpQiHlOHVhxwKZkw4k92+bxjAJbYeXgN/Lh2KCs367PvXaBEfBTrETXLJEt+8y0LIbfeq5vqbRzey+m5WqssPsg==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPSA id 4E7CC18015F9;
	Thu, 16 Oct 2025 16:56:31 +0000 (UTC)
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
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 20/24] target/arm: whpx: instantiate GIC early
Date: Thu, 16 Oct 2025 18:55:16 +0200
Message-ID: <20251016165520.62532-21-mohamed@unpredictable.fr>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyMyBTYWx0ZWRfX5RPg22SuOdaV
 ZtTU4QVzU7686asx7bCXjsWGnA7izvNqLIwCdj/7CqqAxyL7JE/2PatujnSg5x5YMQBNLmddTzf
 54acd03G9sAO6QwtiYwOR9GBwBN3vHaOZzJdefLudxb9q4ISDOXv4pTVvAbZWSVZh4enlOEewOl
 l3ooDrDSb+RPU06eAkd/JeHEvFGQoth1+YTpdKa7qb/C1X6ulBgilRLxsbzq+Iu4atTFG4yO0Jc
 Utr/y6SQr+iLLmX9JymHamL2+4b11WRnsl1vNwc8MAtsgKDZEEpC3JRaqdTFSC42YLXt1Wj7A=
X-Proofpoint-GUID: lPwsSiVTqUh4yKtd54TOrkzbe0fpD3CF
X-Proofpoint-ORIG-GUID: lPwsSiVTqUh4yKtd54TOrkzbe0fpD3CF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=700
 clxscore=1030 phishscore=0 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.22.0-2506270000 definitions=main-2510160123
X-JNJ: AAAAAAABRqlvR0HOYZmVSAMe64xMp24ydQMh0BLfmwizl1Z6qWJPTXy29Ke4PBngEdTirCepez5QG64/oUzy3Up3ADBkfnYlOWIZwadRqErq76oeLLIXYjKCCH4OXqgGH2Ve5QLQuwUCBtRro6Gxji6lEdiDFjxM19uNyrro7K8AgTvYIjSB18dIJhqRcSbohJIsKf3jZDsDsdSPr6Qo4NMwxSbsusL3B8rlEbia8dqWBoiURngsrBrLfbe6QCmMbP7mWboKRiMwJ+LqwkDDSTAMqgSJWbeFpOfqjxY6Vt8tUg1781WPVLgwSZkxrYGdkugkeAbKLUE25cfLXI7Rooizu7Pcl2pgHuYmP9S0R5vN2y1tmUG92gZbVSEX3JcQpUzltRDX/BBqB8TyvaxFN5w96FXuC6ddtHHYdbDKCXo+zmpAQYkjrfbqJnM6wjFc3Y+ChUsBQA6tTYp/xQDtRrfCDbhVFUsUxi4YZgLL29GoAa0Pt2dAWJe1krh0XqPnmc1bdhBUHvjd4hjuNCO0lagp6GjKgj6432zRJOUqV/kaQGeCAQyHwrJBvGlkccIw/l/5jr5xL6ZzVAciJPdu+XJoO+afX5VvtkHx/CSxgl9pP3nK2LCKyJtUawjWGaCSy8H22FqT59vb4RNvwNAii8sIVqEmWeBenlWqVxBVO1bbBhvy5aCehHqxMlDmnLbVrnaQXEPZi4OwaFYH15P1kvQr/BDpoiyiC7uloHUJPOF9DzQn5QxEBI/Zi1oVkjADUxCtiJmVTmZ/q1xT/nV99IMvWiTQNzYcPr2iyXWOGjSxss2a1LcgrwnKQLfUIXMIXe2+b39jFlrByb07NRDNNxCYPuo/4J2WPVgATItp9K+TaeRwjyIcdC8RrKGxDS+o/KXMhQdiB/KP3AsxxtUDs2Y=

While figuring out a better spot for it, put it in whpx_accel_init.

Needs to be done before WHvSetupPartition.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/whpx/whpx-all.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/target/arm/whpx/whpx-all.c b/target/arm/whpx/whpx-all.c
index 680954f4b5..12d397f35e 100644
--- a/target/arm/whpx/whpx-all.c
+++ b/target/arm/whpx/whpx-all.c
@@ -976,6 +976,29 @@ int whpx_accel_init(AccelState *as, MachineState *ms)
 
     memset(&prop, 0, sizeof(WHV_PARTITION_PROPERTY));
 
+    WHV_ARM64_IC_PARAMETERS ic_params = {
+        .EmulationMode = WHvArm64IcEmulationModeGicV3,
+        .GicV3Parameters = {
+            .GicdBaseAddress = 0x08000000,
+            .GitsTranslaterBaseAddress = 0x08080000,
+            .GicLpiIntIdBits = 0,
+            .GicPpiPerformanceMonitorsInterrupt = VIRTUAL_PMU_IRQ,
+            .GicPpiOverflowInterruptFromCntv = ARCH_TIMER_VIRT_IRQ
+        }
+    };
+    prop.Arm64IcParameters = ic_params;
+
+    hr = whp_dispatch.WHvSetPartitionProperty(
+            whpx->partition,
+            WHvPartitionPropertyCodeArm64IcParameters,
+            &prop,
+            sizeof(WHV_PARTITION_PROPERTY));
+    if (FAILED(hr)) {
+        error_report("WHPX: Failed to enable GICv3 interrupt controller, hr=%08lx", hr);
+        ret = -EINVAL;
+        goto error;
+    }
+
     hr = whp_dispatch.WHvSetupPartition(whpx->partition);
     if (FAILED(hr)) {
         error_report("WHPX: Failed to setup partition, hr=%08lx", hr);
-- 
2.50.1 (Apple Git-155)


