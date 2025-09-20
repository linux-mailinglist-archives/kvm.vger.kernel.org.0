Return-Path: <kvm+bounces-58295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 215C3B8C9B8
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 16:02:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1334625658
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 14:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9196C2FBDF7;
	Sat, 20 Sep 2025 14:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="Ws5cbD1w"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster7-host1-snip4-1.eps.apple.com [57.103.84.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470AA1FBE83
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 14:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.84.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758376946; cv=none; b=tpg4iWYiyHnIS5CDcSyWtmCiG7zXrYa8zWXCr9m+T7xSAvNZ5OAC99oZ4gl2btluLCmC+IFLgqtx83MXE1o0Jj7VZFhYGQof34H4UjKVc4TbFNUgldiIT4vPyIU74giDRH0zZx55Xzkrz/EZnpd2Fq/R+4KAkc7AKL3JNYuYg0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758376946; c=relaxed/simple;
	bh=iZ9om1cy0Cu0T6rmQLpy9xj1/MvSqkepj4AOOKDcg+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1pGeCFh0O9jcvZjGmJyeJNHJZefYXpMVC18Yzeg/HKTtd7UkPIzll/lbCwbXDiWJewdvqqGGzPMpCkV4zV6NtCZIL/j05vr82uk+6Mr9L7DYRWRT9aULExw9boMFg1ojlGSEzzchfDkgxvu5Jr0KgtmeWLqtWi8hP5SB+0rBac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=Ws5cbD1w; arc=none smtp.client-ip=57.103.84.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPS id 886AA181729C;
	Sat, 20 Sep 2025 14:02:20 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=hP9mipJJlzEp8BAG964JLQLLOKiV7YupjQ0pPg2yZ4w=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=Ws5cbD1wz7FlXnbUWuligi79VaovQgL2FIdZRy6XhM153XEY5+DWNJwzrE7UQ1htb+vPlIY0KFgqvY8o/NRwQ0HoLmCfWnFVgYH4LLR7l0Dbrvct6KQGsxT6RS1CHRStugO6pb075RQljqJiDKjRYz/Z5h+6Oygdla4f3TBpakM46IJYAaV12qGjlwh2er2xIiLhJEJ3HvcxZBLMkymnm5kF9hVokVeMCde8l8To18Dm9JIxGAjbf26Vy2YqlMvlWW4to1Mr2gMu54iZPU835qGXRxFYE/D2w7crseg6O+BwBDwhn+wVwuhN3+ZYL63MGLR9fwy01N48Ib6shrPiUA==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (qs-asmtp-me-k8s.p00.prod.me.com [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPSA id 5C6E01817298;
	Sat, 20 Sep 2025 14:01:48 +0000 (UTC)
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
Subject: [PATCH v6 07/23] whpx: ifdef out winhvemulation on non-x86_64
Date: Sat, 20 Sep 2025 16:01:08 +0200
Message-ID: <20250920140124.63046-8-mohamed@unpredictable.fr>
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
X-Proofpoint-ORIG-GUID: n0fRiewL-iFFFd9MCdRCn7T6LCJp5mWf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDEzNiBTYWx0ZWRfX6ZQOjtCYRcA8
 ORGjNsbejEDE/TlUDO6fa9QvBJWSBa9KYXlGJhp9N91kPRimSCdoOkSqclMLhgZqUUPI0jIDYk3
 CP9rA2LWlgkgmQVtNr6dR04G0GvJd3DRebrIrf48NwfwgIZMle8ofWQbFvI/bGCOC4OYa24715W
 +wcYZ77d8jVpxakhOCjp85LZLl5JlBqugbtVl/tIT8XZr9SPNbJUv77oczmR/9Sw0E+bX0WS08e
 7lJ9IhC5P03PlH9mV9zdR1miXKNL8rc0DoBvMlK+Ey8VZhltFQx4hYn7APmVXj6GY+eGD2Enw=
X-Proofpoint-GUID: n0fRiewL-iFFFd9MCdRCn7T6LCJp5mWf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-20_05,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 bulkscore=0 mlxlogscore=755
 spamscore=0 phishscore=0 clxscore=1030 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2509200136
X-JNJ: AAAAAAAB/EWDKdnaT6hNpcaey9axI9KFWUjPdO+3DMXIm7JMkZcYSycbrtXYvKWsCBsX+v/ZCf6fuG4vHn10tYzW/3fNIyRvQbybffjgT3pr6+ZEbjfIlqMoFN2hMWTe5W1R4ZOrajuCLY1sX+muAXBOn9JFEwx1/3nMx232im++RkfeNSaif7iSim/23goOOxK8dwDekZPnIPCLcqpPGZjykFd10tJZRHZaKYwHQbb0doGGijrMfuNNt6iTjKfkLba6iDsjZeZRLYw+eNSfdBhrVtgfYJ2p9LXCrjjU2sdezohfUsz0Fb/iw0uOfNTlqKbBFHlvb4ReqnFA0ZglpuUUqGMHKN2VOpVNRc3GQhj4oGgdp8VcwpEhIKePW6dlFltH8S4birQCuNAA3MjVvIldKpuhgQzYNyfiiTDfQTXZ8tpq6B08zdpTol6T9LzBtv4fm0VqHotAy8WH2CYat/vWiET75iTvfgz/P5HO70VXTZN6DM+qmf4LVVFHViuDAO1VOdA2MaXQVSMLL2AkekKXb1W1zRrVHSUyrYiQIuizQ7dx4k6P/w9CYk4E5Kil8Ptn8fQ8D6udH8auSB7EzalstE1wTqZEVx4y6+r/cHty6miW/ZiXomGR6o5cYnOM7uiPc85HUafh+5ssJ9VSDgOX+pEN70qQFNjrM/sfWAd4tBjrQ46hYrqAe8dNUmin9xA6pYb/CJRXqFhdhlDcTkqwv0S2rbw+noaA0/Yz7p7V9mloSsAGmET6uu0w5huno0TVeGTXmXmhu6g33s2ts22OPH/PQXx4zbSMytHBQtAf4SWrNDWuXSd6WalLtyQgn4VsAl3Qa8RuXd1VOrNZCpA5xOXzqbxceOdYUqAiKIRGJoVv4OaPX+m0d0A8hlvidSvXPWRAWOI=

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


