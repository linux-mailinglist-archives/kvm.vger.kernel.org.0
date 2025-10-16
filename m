Return-Path: <kvm+bounces-60153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 67042BE4B53
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 18:58:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BBF113595A1
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 16:58:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07B8F34575F;
	Thu, 16 Oct 2025 16:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="P1YybNG4"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster1-host11-snip4-1.eps.apple.com [57.103.76.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1487534574A
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 16:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760633835; cv=none; b=hJ313PeLo4OTo2I8nGHPZZBaKeSY4qglE8Fj0dwp300KejEOfRsrOi2TVv5fqUq9Kwf2cFg2+7eZPE2jGqCLFBbDge7PU5Xlrx4F4kbjn5F3w42CtsySxDGNV13ZRHTOjqHia3/xEVNaXBdg0b8GQy//wN1c9yG3FisfQKCQ/Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760633835; c=relaxed/simple;
	bh=iZ9om1cy0Cu0T6rmQLpy9xj1/MvSqkepj4AOOKDcg+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qu1/cgdZF5apfKUQRH+ZJFbfGjjLJWkJ4mXp/0QagzwLEqgZ8kkE7eNHUDROwJtiER9FZVp22sLtDXDV3uNA488EoKx6Na/bRSV51luHL0AcpCbS1hyzrazmk2gIlcX81+hk2xhNu3kqGayd20TqwVQlLgwK51xW2zsDrZ7LB6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=P1YybNG4; arc=none smtp.client-ip=57.103.76.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPS id 835F3180009C;
	Thu, 16 Oct 2025 16:57:06 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=hP9mipJJlzEp8BAG964JLQLLOKiV7YupjQ0pPg2yZ4w=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=P1YybNG4h/afzc31t5JKrk+Ro30CCIRUcIs9btvVmE8ZR1c5y32KZpiILT459adniFeouKiYH7dXd8YYjfIPIi/XIiR3OuzJESBKQhc6AVgzkjHY/sA0NKmfceZWUyDGrGIEWBuCE+YHfG7FNnBcFAOLcplXXCtx0VwoK/om+NIlyhms7s/T5v6Gya9MOzM5b+/i1eSYR/YiQROYCujRY3UF1yjbtZGybXl9KLvsYXJuLSnTm/BFRfqGqI09VCszNhxv6lCDqrkb3MNELJf3vaRNv9LCllR/5rDGjQukK0knDasaZGaaHeZAgbZnzIpwk8NaXAyxe9ttMnYrbs1SwA==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPSA id 5220C1800326;
	Thu, 16 Oct 2025 16:55:50 +0000 (UTC)
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
Subject: [PATCH v7 08/24] whpx: ifdef out winhvemulation on non-x86_64
Date: Thu, 16 Oct 2025 18:55:04 +0200
Message-ID: <20251016165520.62532-9-mohamed@unpredictable.fr>
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
X-Proofpoint-ORIG-GUID: BIBHmbkbIcoNOF3xP2060srcDzIfcEwg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyMiBTYWx0ZWRfX+L7V6sM0ly+w
 0JVy2IliT9nDKb5ST+tMU8irr4TkOiwZGqlR7SRrXjEQPwXz+ZrCIhPh7HLp6rMknnQiEDbs8Sn
 OFNHqBwk0Y2ulNThG64aErKieb6iyutzM0GZ55d6HG77sf/NtK2DkmDJ0BIlMI+vlr0KaI12fsD
 M1kuSTJ3PDHUjEPPCx410R5p7tZp/ZvS0zcrEJty/rLoGXHnTMzhFRxTdS30BFYs2PPH+PSMJKq
 PhZ38OJj1bgWRa0Tj4pW3ag9BbMW85NlH12AEfdpQH2sxngWd1J4Xq0eeFsIyqT3O7D0OeNUs=
X-Proofpoint-GUID: BIBHmbkbIcoNOF3xP2060srcDzIfcEwg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1030
 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=766 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2510160122
X-JNJ: AAAAAAABxmB7T2oLXTufbol1toOlvGlC9GSprD2ZN0jDB/s5IZC4wz1mhFk8RlixS4r49vz1l0ZdrcPjD32GZGVsvptHG4t1eqr+HeHxNefqi+REcXV9gzvsqwvmQtjxPZDeHyQh012OjhZwDraQZ96fhHIR0X6TEEze3JxWKB1D1AxyCO2qJB2VBC0h1kbUsYOW3TVDya+gE96lmlzxvnxyBz5UQcGddTDfk59eEPITZVxpBVyXqxEFxQYuBF+fqURCmgCtOzeNgDfHdO9f5ayVruvTjYfUh15YC8JuPHKpHJTOMbiJnorGzsPuwYZynW0rMLfJHLHsyMeVw2ae+jt45ty0/CIpwwn4SZxfwnZq42gEdbjDMee8WBvIlh2fQm6KkhNOXVRjuc3Qu3NtbQ2cTQHu93aQCzEEF6QSUcucF+f6MnQg34rFC05qf+afnjQxBdFfV/4ZC2MOJg8WhM90NC5iv/zFdX6AGotiY2KoFiDkj+TFgnHp6VbgLNOOc++mEukSsJq2WWFoSZbQ3+lEu/V9yszAAmdzs0HejmqDF3OiSuE0tLj/9kQ5/LimXN2v5GZrVU1x7WrToTQk9eQHr819kGMRtXcFNDczfOsUBKT/Kv1ARmpuwQq/yNSuAodYbx8I+tLzc69AzhZ466vGEVl1D3gOkbwW8e/66D22+Wow2pkMTMXC4flbq4tRuFNAAYlOPECSxqYGyxOFnXIkJp1nRu848H3hWeAVnQoBcSNG1/bpnQxA7cnnAhO6IPkQCzNox2FILqwJokXDOWu5KaOvCn2KeTWh57/7p86cuFWD9psdE3XnUgsPBFr80ysVwYCmFFkBIoTASF5VTGTGDv7ckEQoh6c32JpacmKAdNY1Mdzfxr7hFtaoqBQkye7gwqziDm11aqJFnV5H8mB+TMy+ug==

winhvemulation is x86_64 only.

In the future, we might want to get rid of winhvemulation usage
entirely.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 accel/whpx/whpx-common.c       | 14 ++++++++++++--
 include/system/whpx-common.h   |  2 ++
 include/system/whpx-internal.h |  7 ++++++-
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/accel/whpx/whpx-common.c b/accel/whpx/whpx-common.c
index 66c9238586..95664a1df7 100644
--- a/accel/whpx/whpx-common.c
+++ b/accel/whpx/whpx-common.c
@@ -41,7 +41,9 @@
 bool whpx_allowed;
 static bool whp_dispatch_initialized;
 static HMODULE hWinHvPlatform;
+#ifdef __x86_64__
 static HMODULE hWinHvEmulation;
+#endif
 
 struct whpx_state whpx_global;
 struct WHPDispatch whp_dispatch;
@@ -236,8 +238,10 @@ void whpx_destroy_vcpu(CPUState *cpu)
     struct whpx_state *whpx = &whpx_global;
 
     whp_dispatch.WHvDeleteVirtualProcessor(whpx->partition, cpu->cpu_index);
+#ifdef __x86_64__
     AccelCPUState *vcpu = cpu->accel;
     whp_dispatch.WHvEmulatorDestroyEmulator(vcpu->emulator);
+#endif
     g_free(cpu->accel);
 }
 
@@ -412,8 +416,12 @@ static bool load_whp_dispatch_fns(HMODULE *handle,
         LIST_WINHVPLATFORM_FUNCTIONS(WHP_LOAD_FIELD)
         break;
     case WINHV_EMULATION_FNS_DEFAULT:
+#ifdef __x86_64__
         WHP_LOAD_LIB(WINHV_EMULATION_DLL, hLib)
         LIST_WINHVEMULATION_FUNCTIONS(WHP_LOAD_FIELD)
+#else
+        g_assert_not_reached();
+#endif
         break;
     case WINHV_PLATFORM_FNS_SUPPLEMENTAL:
         WHP_LOAD_LIB(WINHV_PLATFORM_DLL, hLib)
@@ -539,11 +547,11 @@ bool init_whp_dispatch(void)
     if (!load_whp_dispatch_fns(&hWinHvPlatform, WINHV_PLATFORM_FNS_DEFAULT)) {
         goto error;
     }
-
+#ifdef __x86_64__
     if (!load_whp_dispatch_fns(&hWinHvEmulation, WINHV_EMULATION_FNS_DEFAULT)) {
         goto error;
     }
-
+#endif
     assert(load_whp_dispatch_fns(&hWinHvPlatform,
         WINHV_PLATFORM_FNS_SUPPLEMENTAL));
     whp_dispatch_initialized = true;
@@ -553,9 +561,11 @@ error:
     if (hWinHvPlatform) {
         FreeLibrary(hWinHvPlatform);
     }
+#ifdef __x86_64__
     if (hWinHvEmulation) {
         FreeLibrary(hWinHvEmulation);
     }
+#endif
     return false;
 }
 
diff --git a/include/system/whpx-common.h b/include/system/whpx-common.h
index e549c7539c..7a7c607e0a 100644
--- a/include/system/whpx-common.h
+++ b/include/system/whpx-common.h
@@ -3,7 +3,9 @@
 #define SYSTEM_WHPX_COMMON_H
 
 struct AccelCPUState {
+#ifdef __x86_64__
     WHV_EMULATOR_HANDLE emulator;
+#endif
     bool window_registered;
     bool interruptable;
     bool ready_for_pic_interrupt;
diff --git a/include/system/whpx-internal.h b/include/system/whpx-internal.h
index e61375d554..e57d2c8526 100644
--- a/include/system/whpx-internal.h
+++ b/include/system/whpx-internal.h
@@ -4,8 +4,9 @@
 
 #include <windows.h>
 #include <winhvplatform.h>
+#ifdef __x86_64__
 #include <winhvemulation.h>
-
+#endif
 typedef enum WhpxBreakpointState {
     WHPX_BP_CLEARED = 0,
     WHPX_BP_SET_PENDING,
@@ -98,12 +99,16 @@ void whpx_apic_get(DeviceState *s);
 
 /* Define function typedef */
 LIST_WINHVPLATFORM_FUNCTIONS(WHP_DEFINE_TYPE)
+#ifdef __x86_64__
 LIST_WINHVEMULATION_FUNCTIONS(WHP_DEFINE_TYPE)
+#endif
 LIST_WINHVPLATFORM_FUNCTIONS_SUPPLEMENTAL(WHP_DEFINE_TYPE)
 
 struct WHPDispatch {
     LIST_WINHVPLATFORM_FUNCTIONS(WHP_DECLARE_MEMBER)
+#ifdef __x86_64__
     LIST_WINHVEMULATION_FUNCTIONS(WHP_DECLARE_MEMBER)
+#endif
     LIST_WINHVPLATFORM_FUNCTIONS_SUPPLEMENTAL(WHP_DECLARE_MEMBER)
 };
 
-- 
2.50.1 (Apple Git-155)


