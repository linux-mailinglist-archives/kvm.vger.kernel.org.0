Return-Path: <kvm+bounces-58307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A4227B8C9E5
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 16:03:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60586583F7F
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 14:03:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EAAF2FDC57;
	Sat, 20 Sep 2025 14:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="OHWza0wW"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster7-host2-snip4-8.eps.apple.com [57.103.84.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0461127F4D5
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 14:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.84.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758376983; cv=none; b=Pnd7vtWtQOp333r73e0MbYtci0mlnOiIsfTJLxKrAPLndQzta7c2gDItmIOY9YI4JHTMPDUpTLdchIyS3mpnYRjn5qTQ3qCUMd4e/kvURzKQDDtlEbUxfcklcBwQ5OoBlQXqmvGh5gPKwG8Dmgm+nqqCTqenaNMZPxwOVglCX/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758376983; c=relaxed/simple;
	bh=lldKFL6T36zAxLV6jFKCjM94yaEYRULJC/1BRT3nBcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J5pcAT8Z2Ll872WsAdAg7HWy07icLhiraY070AuILlyjF0gxnmWBjDzu3cZTZNBVhCCghcN4cS4VVRsvyJhTxmtbha0dJBuhsm78p05Akj2p8nDcphKJy/wK0CfbFmt5SEm8sr4MH2IZUCcTB9XlrHKKMFzg6Jp9LNeJO7DiB/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=OHWza0wW; arc=none smtp.client-ip=57.103.84.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPS id 4096E181728B;
	Sat, 20 Sep 2025 14:02:59 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=XY0aRLNzrnTUVd3ei9jMIMiM8ijXecVFkp2kgf3sj3c=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=OHWza0wWHPN30Qtil7dIADzp4dI4xpGPyVb2b1Y+MLtWLZ5B/HJP75CVBMhQPOGy62SbXSpsNrsfaSZqfn7E6/vRJ+/voXe8LbDImLm78dB53AvxTTVlmYSRvkRCAcfROu+blo0L0xKyyO+FlzATC/9ijcOliRCL3NoJFaIZR8a1tI83tdC2tfmCJwaG52zlUwHxC2yRcpUohbQY/03DwIKYS5AgcqoG71HbQIKW8Sd/QzVVGAa+scbJRfsgjk0nvilu2HZPdwlQTx0Wy9hS9fxen97tlzJAk1NV2gH+WETRLUHmWEFYiU+Zo7PhvAnznQfbWUgH3Rk6DUJDn5KAdw==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (qs-asmtp-me-k8s.p00.prod.me.com [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPSA id D2F561817259;
	Sat, 20 Sep 2025 14:02:20 +0000 (UTC)
From: Mohamed Mediouni <mohamed@unpredictable.fr>
To: qemu-devel@nongnu.org
Cc: Shannon Zhao <shannon.zhaosl@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Mads Ynddal <mads@ynddal.dk>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	kvm@vger.kernel.org,
	Igor Mammedov <imammedo@redhat.com>,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Pedro Barbuda <pbarbuda@microsoft.com>,
	Alexander Graf <agraf@csgraf.de>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Ani Sinha <anisinha@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Peter Maydell <peter.maydell@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 18/23] target/arm: whpx: instantiate GIC early
Date: Sat, 20 Sep 2025 16:01:19 +0200
Message-ID: <20250920140124.63046-19-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250920140124.63046-1-mohamed@unpredictable.fr>
References: <20250920140124.63046-1-mohamed@unpredictable.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDEzNiBTYWx0ZWRfXxQE5hbPt32T1
 9DYVTZC+XyB5R6ztg0GaHbir5PTenhacAIcoRR+jU9Fb2+C4fwdusDinhjoMper1kEGZ8B7zC58
 Yj0ZeP2ha2UF7Lveg1zsuAgoo12bVVL5GjjPn7KQNb6rwIKBluu9lWAV56GfMBGZ/QJl1v3LSG9
 GiL0ILaBHbIN5U8wF6ypsr6Kkqyyxcv9FhqQ98a63Tpf5iN63jOAlnA9ETjRiJHWVKBSgxuvy4P
 zX9xOUtTl96uWnxJRQMmfmq0LIaUHCBopURn+1Bz4M6HGarg8lwiU7tRcIr9zXhYCCNiNFR5k=
X-Proofpoint-GUID: glISlhaAf-JTEsHPh9NP4d3NmfnhD0Ya
X-Proofpoint-ORIG-GUID: glISlhaAf-JTEsHPh9NP4d3NmfnhD0Ya
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-20_05,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=685
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0
 phishscore=0 clxscore=1030 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.22.0-2506270000 definitions=main-2509200136
X-JNJ: AAAAAAABfoo6CgdnrX60Q7q/eqA+O7e+kWLHOL1YXUA1abD6Ku6DluC3vq9rxUhQ0AKD8IuWb4jZE6W0WFdtNJvIl+ZX2vgaHHbS3B7won4eoaixv/k/rwjpbn8q+M/cF4cBFBwoQV1mPcEIrSskS+xu7cS4Gr+KiQNCtY2vmDAw8nPvy5CeTpwpDnjEEmT0C5e7NO+yYxTjq7MYWCxE2hdKzLjYT42ooUVDfDFor1oHGY4fNezZ+5lNWfH4egSNx2gQjLNPlrg5SRrR2Opsm77610pWJBDUYOQsiYBnRWd2xlstua5VALB8kRMSidcOwNMUgG/qwqhL0GV0ZtBt40m4an9XpBHVGLxbVZGi3TTd8bKOGhcs7I0JtDHpTGPnTxLZLGidQGBgI1xnxqYF7xOIkqcxzpqoq2TBx+kjD9Myk62+ExdeC13fVYaUzqC5mrwJA59WPAXsUtM3pvn8o/izscyILFYttOhAkBcLUDfzV0QhqPdjmnEYahw/NmB5FIKOZqI6VV7XAKTt/CtSi4s39pH+dWTgX6Xsu9aVcRJy0WVg+jKEZ5BGqVjNhEpq+qJi0oknCXt3f7Yth2Kr1GonOn/3N9U0JZAevh81LMP5ZdcNaFSMJPnhDdvpJluUn9UyOhAoNIFfUqtj56SWkyGnTf9iu0ug8aVeG3TPx+brtne18LmYrdbjEEuqHgtJ6blpt4dXfz5SlK31NkuFzqod2zQ79kfBhgZPbUKujI6hDlH6X5ktGAgbi2xSOLcOMiptmH4E+7Wm4H5E4vJ4s75NOroMRhsrKWNFvaH+5yoC8U33mUZ+hvt2DkPqv+hYmX6repSXH5R/sWOfQ2u6hDKCa6mdKkwAmW0JgLabUhrfNorJkSgIutf2jDtB

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


