Return-Path: <kvm+bounces-58312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03726B8CA00
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 16:04:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AED3E1B289E5
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 14:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B10B62FF64E;
	Sat, 20 Sep 2025 14:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="B64izZL1"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster7-host3-snip4-10.eps.apple.com [57.103.84.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A902FB97B
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 14:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.84.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758377007; cv=none; b=GGSGFRCT7NULWexHTdJg6+SaQ9HubjtIgwMc2VUMFGiu6EbOjKO5bRWMwt589IPmUmeK4e5PWHCAUxYe2f6KxhQ8S8DwNp42qMmTJuqp/orBG+v3egJmBfOtnj6udnEb76T5sUkhPsqcXn2Gkq2heysiLLJ7l/MIEqmfyiB084c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758377007; c=relaxed/simple;
	bh=Tq5oT/7lJ7fbEbEaKEBzQ0nPDynLLXkeqa6sBcGH/4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jcM0gye0nMDGFlPCCzUEQl82EPIkyOWAUMv0lJVrmOnCJhAkSMSMk4PC7Pr9xNe9lShEXHDlUL1ymYF25wyydM9E/mBp8ZdGafbOAjtFEZfDBpewbged7Cy5+sphyrjuorl8zarLdHi0qFPPRw0eSbmBE9xCQ3VKjYi2mYUrro4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=B64izZL1; arc=none smtp.client-ip=57.103.84.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPS id 51D041817344;
	Sat, 20 Sep 2025 14:03:19 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=c/5rsUrStdeRorYSqBu3+Q8xyENsD0DokCuHFqMkrGk=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=B64izZL1vTxTRxZdn12k8FBC3jD9Eu5bv9kzu+z9fxmEjgO+8zzKPtDuMebzIY/2JrgiV/FKVbNlihiSDDc2t0sxrja3m9mRAvkfrSD2/QttuNVqimylam5rcdUBZMvwo7dB+D0McyDYH8sI3Z+UpEQYhCpVc6MutWygV2ZsDJUH4OCQx7utswBC4fWkDSFEtaz39triYg0a3XEx1RwqpVMbWSmIFSMm8ny1RZ0xkg5DphIdS+REyg+jhG8Rmnzk+idvdQ8k3JPe5Y8+yrPhI4an/aeIKoPURifIuxrier2hYcmXtK8087Q0qxcF5A9A6ksz4plv8/R6tPrihB8mUA==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (qs-asmtp-me-k8s.p00.prod.me.com [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPSA id 4746018172C7;
	Sat, 20 Sep 2025 14:02:35 +0000 (UTC)
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
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH v6 23/23] whpx: apic: use non-deprecated APIs to control interrupt controller state
Date: Sat, 20 Sep 2025 16:01:24 +0200
Message-ID: <20250920140124.63046-24-mohamed@unpredictable.fr>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDEzNiBTYWx0ZWRfX9z6N3cyeSVux
 +RrFvjrsbkKKcWyfTpBMoj/2bnC//IYiCJxi/U5ewhwymsheKn+sqk5LxwfMyxL4inO9XnYJuKP
 4eXhjyw46jwHKhhR6EM/1YROvB5Fu2xmt0JflCpiAJETk+Ra3CCMhnXW2PGieGDcRC6kU+3XQ+4
 9cILwuLeWBTQsevw5C2ziSJizQk/f6kazF4YPGvkcD5Tg5IFshQ2pLJJgXCGLwuZ5TA7QIIyvKN
 8ksbpcyC1VWOegRd55ZvjxJ15FPr6dCwu3suXwGSyhzZsvRKUdFCKsxnN8oqHX1sK7eFS3qIY=
X-Proofpoint-GUID: c83yXiQoG0AGIGpW8wmiFxYHfBhemJTi
X-Proofpoint-ORIG-GUID: c83yXiQoG0AGIGpW8wmiFxYHfBhemJTi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-20_05,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=818 clxscore=1030 suspectscore=0 adultscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2509200136
X-JNJ: AAAAAAABmrj6QRYIKNB2jjK68fLx1j8Ye4m2/dogagyZ06LY5SdiO0gKY3szkKLV6wZbdP6RmoPxsv/pQmJqRVLNkmGCPeLH7eW5KBSvwdZ73lbaDbHyGc64iPkGbWLcdMkkjCM0eE1uFnkK+uwAraaw91y4pUueOCX4MGrRjAIxd9/QecvttWiApxr1dIIpHLcy2HJqkG5Cx66zN2l+xKkPoErE24iXBaIXjJDgIQCeP0YfcwbhFmlG4qAI7ZYeoZy0Y6lrNLDcGqm2PT3RiHjUuzRtVzCoePpCz7TMsavb3TFMN+6Ima69FpY0i4cbj8cVyZHPV9yOvhpO5WEUsiocs1G0ymOO0+r/aCX477x+X1L88XXYsgTyBwimk77hnN4qKIy0Weo6d+p3WzbnhhRcY3r4qF3iQYPRCCears/rw19Fv5+mupNMrgvxT8TtKX7gBe5tQh/uMjnzw2nF5kwGTUpjC1chgIUcT/T3vQM7vBvf14znv78dOYdh3yY5AoU44O3AYR6GsMRUftetGF11KUOO9UroMORpW1bcQR569yPrwI7E0DEvwbEsSQc8ZEmcP66Qe6ysQcwDC2/3INBqFEqrEfQp3Qs1Ni8J//M0JGCbO86JRlWOnOrqMTEIw7OJzixq9KgeNeTyeMBQUx8F+ZxV0FPs99kZ8btYAHpqEc3s1mGjWF/nC+5SEqHK7g5G02Sk+bacw8VWKnrDZp4+IJqol4FGkOtFviymSWzPwbMFnrpnXBoMRdIQdz/zRXdJBtvdZhLV3U45NF3WFN15+Y1B3BlakJSUQ6XPR+4qvljaluwLz/YAwnl8ryCsQowHNHbLuDp9RIWVImxSnrfuEU6fcdR/zpRViefMeOhkhzQKT8ms/y8EvWP/I1q+qQ==

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


