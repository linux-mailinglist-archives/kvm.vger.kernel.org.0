Return-Path: <kvm+bounces-60169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC8B0BE4BF5
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:01:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A6C9188DFBD
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:01:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EF4F32FF5F;
	Thu, 16 Oct 2025 16:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="Qx2WAH2l"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster1-host10-snip4-5.eps.apple.com [57.103.76.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD85343D7A
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 16:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760633873; cv=none; b=Q1dgianz3hRD0Lzjej8W9DE9iwYZNNt4rE/qh1kZ7mc4Cy2qewyPdE/4Kv/jaVMXCoSoEUPnjak4mIZlVlZu8QVoK/y4Xxfx/ualLyM5ihPGAplW8ZIhdXD8sLogf0sn2Vs2ZFEuUMbiiGUJKJPOgH5sT9xIWvwQk/dxanS5GHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760633873; c=relaxed/simple;
	bh=Tq5oT/7lJ7fbEbEaKEBzQ0nPDynLLXkeqa6sBcGH/4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+4RpyQZXd2WKZp8fmxBTeEXeXYzDm/JOr1l2E112tm0NXeWz2PeKnJiDUoXpo0hX93fGDtZBNJAPleioeMmdRyWuSEvEKEj1nrM6pRFhhpNBpf4AsAttCjoLL3FSIhh2NgJrzywrTzjoEWEDbwIket7Cpw+adt9ujJZYU/9Va4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=Qx2WAH2l; arc=none smtp.client-ip=57.103.76.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPS id A6A4D180017F;
	Thu, 16 Oct 2025 16:57:45 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=c/5rsUrStdeRorYSqBu3+Q8xyENsD0DokCuHFqMkrGk=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=Qx2WAH2lDvnTPqu2Ezpway7CAh7U/kHiAa0myPfLiHvnT5JzbCU/Ozxql8vTWLU1uHZXDPFNovGSgfPLdh3FjMS1Q6Mcv/yB9RX3Uq8bh8UaqlD0dLmcpukI09uy68zUG/VFSkEdmzU341tNoAzhlHfucpE913sENz34yvIMi+OtNTa3mZFm9Wk0L7WdTsx0YP5uY/4aYWK6DysBMOuf9CAm+NW8qwxmViwYmLZgye7QsB0WXzEqHP3WV2Ku8DoWyW6+l875mrE64TMz7BsD+qu0i0b+59sT0UO6T4ngowZ4wHldGKPUlPtRLxh1WPYjvribVZr6jfudXpWDMxDSlg==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPSA id B3362180074D;
	Thu, 16 Oct 2025 16:56:44 +0000 (UTC)
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
	Roman Bolshakov <rbolshakov@ddn.com>
Subject: [PATCH v7 24/24] whpx: apic: use non-deprecated APIs to control interrupt controller state
Date: Thu, 16 Oct 2025 18:55:20 +0200
Message-ID: <20251016165520.62532-25-mohamed@unpredictable.fr>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyMiBTYWx0ZWRfX3i591J451V0o
 sUr0Fl3iXpQwy/Fl4zdiWLFiMpXCSfVPkj64i2rGs4UIzKhvNch4ARxEuJ7d3V9UM+LlzeWvYiP
 CwiG54MjcbPEiIH9JB05aIfno0GN3YhuvFQT6jmSNZanRe0M3bYaDtlmhT2ptdLSU/QIjB14sEv
 Vw+njagl+uYv4sVOoEPu76T34W2l7r7fHWpXMjGViTX6wRD0Nj50QwooFH0g9aDqKVY8VLImich
 O5ekCNCxPInhMy6eMRcvIGRoGtM8Et4yD5CPzHTDVYxlKCZswSRI9MtGKRrlm9f7ebn+Vt80A=
X-Proofpoint-ORIG-GUID: LFF1_aj_2RXFysquanP2u9LYbbvtgC-y
X-Proofpoint-GUID: LFF1_aj_2RXFysquanP2u9LYbbvtgC-y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 mlxlogscore=824 mlxscore=0 bulkscore=0 phishscore=0
 suspectscore=0 adultscore=0 clxscore=1030 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2510160122
X-JNJ: AAAAAAABCDIHi3Oq+7eUfU6kQVtln5bsGab5D20obzhGx/RBwT3+UnCVMabBxb0dMK01J2HgwJ46Ww/4ugDyIy4pWrM9aJgR5Ic5avONZXpjWKzw4dSjkzeg9pKKVeoeiXLXV47Q5fv+c9MMPP+ltky/OJ81LqzITocrn4Ssnk47d66KC/iBUaAsW+73JI/Rd/EdvFNanjHdRj/uT3rr/lYsshaeLsvzBS5aUWYDcwH6Gg6GrbuFGuKrKA4XEpOiDJ1qnjKnYDxZUuzLjc8WoYIqdwyGF9P0FsWjCHN7gvSveEv69ZDybTPlmE7O6121UR6WS7+DpeOAOHrScyG1WAyH50iEbVhXlthWY66jLDUAfgwtG62RZEJKPJFP30MANYW3ZNqIDsxKdX/0K+9jv75271g/chZmpeQuZGH5qn4waXrO2U3GAj32rXkT60JGX9T+vPspdNHQUMbs0wLBzTIz00jGmj2fvovUvGnqUwE9RSzAlhN5e01hlqV3g8n8Yxc0SAu71D/StJlQgVSxiUKBfjORcInbFBDloXgvSKtT0rn+3pyCFt8IeUWUiZO4BNv0tvztVQgumWlsplFgLR3ypIqBqzEGR21HBRbXyCPIisP88hl6qRVYjC5yrn6n3u0MPVIHHL9uHph36Icm8UeQc6fYpEriWwKE6S5nRMFvMm9845X73TpiM/Zuhj6hCUtgXkSOYV61ryHBwTRomlO9ALuAw5R7yAw7DiWZXmkempImhGf0OaVtbSG7GVPkpsjKQzz4sKNWn/iB22pXaj+l2M3fmz0tWzbJyEswFSUHLNa8suzsktqNQHoUklpSE69DblaHahW/XxLGE5QRpXJp0oC1GB+29vqp+O1z8WgPxh7TTCCcEAw/xXFxnzQ2kVr2N24Eo4xTnZu13Pb7/AevUVx1hJFABKfq

WHvGetVirtualProcessorInterruptControllerState2 and
WHvSetVirtualProcessorInterruptControllerState2 are
deprecated since Windows 10 version 2004.

Use the non-deprecated WHvGetVirtualProcessorState and
WHvSetVirtualProcessorState when available.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
---
 include/system/whpx-internal.h |  9 +++++++
 target/i386/whpx/whpx-apic.c   | 46 +++++++++++++++++++++++++---------
 2 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/include/system/whpx-internal.h b/include/system/whpx-internal.h
index 366bc525a3..b87d35cf1b 100644
--- a/include/system/whpx-internal.h
+++ b/include/system/whpx-internal.h
@@ -84,6 +84,15 @@ void whpx_apic_get(DeviceState *s);
   X(HRESULT, WHvSetVirtualProcessorInterruptControllerState2, \
         (WHV_PARTITION_HANDLE Partition, UINT32 VpIndex, PVOID State, \
          UINT32 StateSize)) \
+  X(HRESULT, WHvGetVirtualProcessorState, \
+        (WHV_PARTITION_HANDLE Partition, UINT32 VpIndex, \
+        WHV_VIRTUAL_PROCESSOR_STATE_TYPE StateType, PVOID Buffer, \
+        UINT32 BufferSizeInBytes, UINT32 *BytesWritten)) \
+  X(HRESULT, WHvSetVirtualProcessorState, \
+        (WHV_PARTITION_HANDLE Partition, UINT32 VpIndex, \
+        WHV_VIRTUAL_PROCESSOR_STATE_TYPE StateType, PVOID Buffer, \
+        UINT32 BufferSizeInBytes)) \
+
 
 #define LIST_WINHVEMULATION_FUNCTIONS(X) \
   X(HRESULT, WHvEmulatorCreateEmulator, (const WHV_EMULATOR_CALLBACKS* Callbacks, WHV_EMULATOR_HANDLE* Emulator)) \
diff --git a/target/i386/whpx/whpx-apic.c b/target/i386/whpx/whpx-apic.c
index badb404b63..285ca28ba2 100644
--- a/target/i386/whpx/whpx-apic.c
+++ b/target/i386/whpx/whpx-apic.c
@@ -137,11 +137,21 @@ static void whpx_apic_put(CPUState *cs, run_on_cpu_data data)
     whpx_put_apic_base(CPU(s->cpu), s->apicbase);
     whpx_put_apic_state(s, &kapic);
 
-    hr = whp_dispatch.WHvSetVirtualProcessorInterruptControllerState2(
-        whpx_global.partition,
-        cs->cpu_index,
-        &kapic,
-        sizeof(kapic));
+    if (whp_dispatch.WHvSetVirtualProcessorState) {
+        hr = whp_dispatch.WHvSetVirtualProcessorState(
+            whpx_global.partition,
+            cs->cpu_index,
+            WHvVirtualProcessorStateTypeInterruptControllerState2,
+            &kapic,
+            sizeof(kapic));
+    } else {
+        hr = whp_dispatch.WHvSetVirtualProcessorInterruptControllerState2(
+            whpx_global.partition,
+            cs->cpu_index,
+            &kapic,
+            sizeof(kapic));
+    }
+
     if (FAILED(hr)) {
         fprintf(stderr,
             "WHvSetVirtualProcessorInterruptControllerState failed: %08lx\n",
@@ -156,16 +166,28 @@ void whpx_apic_get(DeviceState *dev)
     APICCommonState *s = APIC_COMMON(dev);
     CPUState *cpu = CPU(s->cpu);
     struct whpx_lapic_state kapic;
+    HRESULT hr;
+
+    if (whp_dispatch.WHvGetVirtualProcessorState) {
+        hr = whp_dispatch.WHvGetVirtualProcessorState(
+            whpx_global.partition,
+            cpu->cpu_index,
+            WHvVirtualProcessorStateTypeInterruptControllerState2,
+            &kapic,
+            sizeof(kapic),
+            NULL);
+    } else {
+        hr = whp_dispatch.WHvGetVirtualProcessorInterruptControllerState2(
+            whpx_global.partition,
+            cpu->cpu_index,
+            &kapic,
+            sizeof(kapic),
+            NULL);
+    }
 
-    HRESULT hr = whp_dispatch.WHvGetVirtualProcessorInterruptControllerState2(
-        whpx_global.partition,
-        cpu->cpu_index,
-        &kapic,
-        sizeof(kapic),
-        NULL);
     if (FAILED(hr)) {
         fprintf(stderr,
-            "WHvSetVirtualProcessorInterruptControllerState failed: %08lx\n",
+            "WHvGetVirtualProcessorInterruptControllerState failed: %08lx\n",
             hr);
 
         abort();
-- 
2.50.1 (Apple Git-155)


