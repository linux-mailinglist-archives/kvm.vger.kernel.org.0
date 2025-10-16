Return-Path: <kvm+bounces-60156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 28A15BE4B5C
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 18:58:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4DA619C497A
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 16:58:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB228340D9E;
	Thu, 16 Oct 2025 16:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="ZQgpSanV"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster1-host12-snip4-9.eps.apple.com [57.103.76.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFBA34AB09
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 16:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.62
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760633839; cv=none; b=HU1la2JmZtNK9/H41uo6q3WqN1k1YpP1w0oAUtwOB5+RwDtak7I23PRBHAOM6NKCGh87Uv/Pn0gu/argDhpOwSVZisJzKz18cDKEIwtReiUSpAA+BrSS+qBT5q5yMIUM3k+s2LnpYrJvgKvrIdXAHcMWjoGNnVuGK+JKcY7SLlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760633839; c=relaxed/simple;
	bh=LOv5uv3I6bEe7jBfgcFmIq4LvLfgwviJOIBpGxteuko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=joKWJVpDI8MFP2CnEbP8R+QONaPQsffh6yHU43IcfpzAGwWtf+MYHpDZDw7p6eKJwafjNc+WoCg1IZKlhyC8f7TyMIjNbTbq/JvRh1GKnjSw4LFZ+aG3h0WQGVZE9fJ41o6vSIrwH6WFjXoTV8XbsF+11rX25+Vtoug26SAq0ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=ZQgpSanV; arc=none smtp.client-ip=57.103.76.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPS id AD8A518015F6;
	Thu, 16 Oct 2025 16:57:13 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=I++1d+tqsPfpQdrBGx3UoHa+IsdjRGU/5ScycBGZiZY=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=ZQgpSanVOVqQV477JwKbUzpswipansjqad40mOskQCl3e/jRkBMS6r5wK2xKykwQ1JsMkAGKGJfn+nj4UVrkb1jSh2alldoJ8D2jWQal3nkis7DagNVbn5UD4sIvXrX2Tf79DfFSWh1ziA77f0G8IfVIKknKJyKnUl0J1CiadCP9gu4Ll1Z6YZiME69K/VEHEjjhQBMoROYGrRhXyXvr7r91olEu/ap9iquSMZvqbGX/0bA8OmEJk3Tg+2D7U/elDXwP3dmCx3HHMwisIu1PVwEjR5NeGrHM7z8/yQGIvXRXisW8WV/tDbXIfhNzYWnknEH4ma1gia2XqizN0FPgUQ==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPSA id 150F11800158;
	Thu, 16 Oct 2025 16:56:03 +0000 (UTC)
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
Subject: [PATCH v7 12/24] whpx: add arm64 support
Date: Thu, 16 Oct 2025 18:55:08 +0200
Message-ID: <20251016165520.62532-13-mohamed@unpredictable.fr>
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
X-Proofpoint-ORIG-GUID: 9wzqUY6_eFCCNOD7KM1k2zffaeYKVY0A
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyMiBTYWx0ZWRfX07voP47Z9LH+
 AgMmBZUy5ycRh5/s4pfqwlaGJp905sfC++6KU2J5PCu0tU9qWP4HeAEYGAPaFL4ld1UIjFuZp/n
 tspU6a5OhDK2v5TOJTvbvcL1Ld/gOpsauP5C/laaxP/FgyvhDCgaj0JJsRs9TF7GAwl5lkm2RLn
 Ig8F7qQgFd+fWu6tmxEJFyBcPZkiNV7KJ4D5gkVrWXNWehubzeIPhHyb1UEsIDZxFVc+G/PJZHI
 +/AUdq1VHm8j8d5FnBcA531D3y4VUyOy7UVCbHNFSyZ7UlXcJG9ZyszuHnd6Rap/G2AhslLLQ=
X-Proofpoint-GUID: 9wzqUY6_eFCCNOD7KM1k2zffaeYKVY0A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1030
 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2510160122
X-JNJ: AAAAAAABE99irHTSyDIgfFWNL/6VYOuUnRlHmaVe8wMMmxMhArpyVG8IahzQDPSzqJw/jn+iqXl+33T4IfqJk+HOWGI13rUcyJrRZjI49f7QiOzq2GF9FnTtY6G6kqVDAzuJ3TUyuBwIml0RLKwgxYsVsSKhjAyFp0IcirUlXqI5KcBUmDSyit2c1kfy6oR9b82SM30y9QsXE2E23K5RKpZmjvqejmiFcjZg2q46xlgmNh/xClP3LItP5PGLcfBu8XJO2v7fHkYDoUq3hVW3yfSLJZum4zV+y4Jcfejb06KTyYcizkOtbpxdBm10B0ynu2V5NilSKx1W4+sCsF8f5L0X2j6C9A16SBiKGx/11jrbHsqWA9Vzu3/TE/FfBYJiB4WLBWvSOceQHOiJdWe7xhi12kJAGmU6Tn516pLmQ95m5ndjfBW2OxIa/GKGOuIRj1W6wXsyCcPu0B78ukMBGTmiJYmkn95pEndeSnX78B5LrRLC8Y7WU6LqANXmp/jNG4NR1zw8ynp61Po6DwtiN03kPpLFKQnNRxnp2hqMGBseZ4t8IKhUTFYdvUuTbU4U/5TVfFOIoaZ1yHcTEb46vSDyRY2d68J1lWH0rVur1H0PhfqJ3a/Q6FbGFVo1m8pGlwYrWDVk6wM0xw+sfkzV6t9qlU2+J5YkHYfS4m5GWOQYakSfoncwbK90y5Fl0ppzfk2GSy0YnTpVLXVWY9Xuwj6vEK2nH0N7X/e1NPqar0guasHAg8fFxSx7Dll1IB28buwvWNuXD8Ev6gbJk5TdsIX3tZQf97Sh0d9t7WB+aPTr5j8WMwIwYEwIImtXkq726yMsgGoqw9uuwd7hmQdDXRNwiqmMOARr4WGfnPEuGQA6FYWRE9vzlS6UK5/H5pBfIprNw2bl3Yoeu0SwR3IST7punVoOQXTTGPdT788=

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 accel/whpx/whpx-common.c    |   1 +
 target/arm/meson.build      |   1 +
 target/arm/whpx/meson.build |   3 +
 target/arm/whpx/whpx-all.c  | 848 ++++++++++++++++++++++++++++++++++++
 4 files changed, 853 insertions(+)
 create mode 100644 target/arm/whpx/meson.build
 create mode 100644 target/arm/whpx/whpx-all.c

diff --git a/accel/whpx/whpx-common.c b/accel/whpx/whpx-common.c
index 18d93225c1..c69792e638 100644
--- a/accel/whpx/whpx-common.c
+++ b/accel/whpx/whpx-common.c
@@ -16,6 +16,7 @@
 #include "gdbstub/helpers.h"
 #include "qemu/accel.h"
 #include "accel/accel-ops.h"
+#include "system/memory.h"
 #include "system/whpx.h"
 #include "system/cpus.h"
 #include "system/runstate.h"
diff --git a/target/arm/meson.build b/target/arm/meson.build
index 3df7e03654..61277a627c 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -59,6 +59,7 @@ arm_common_system_ss.add(files(
 ))
 
 subdir('hvf')
+subdir('whpx')
 
 if 'CONFIG_TCG' in config_all_accel
    subdir('tcg')
diff --git a/target/arm/whpx/meson.build b/target/arm/whpx/meson.build
new file mode 100644
index 0000000000..1de2ef0283
--- /dev/null
+++ b/target/arm/whpx/meson.build
@@ -0,0 +1,3 @@
+arm_system_ss.add(when: 'CONFIG_WHPX', if_true: files(
+  'whpx-all.c',
+))
diff --git a/target/arm/whpx/whpx-all.c b/target/arm/whpx/whpx-all.c
new file mode 100644
index 0000000000..7ef900a5ca
--- /dev/null
+++ b/target/arm/whpx/whpx-all.c
@@ -0,0 +1,848 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * QEMU Windows Hypervisor Platform accelerator (WHPX)
+ *
+ * Copyright (c) 2025 Mohamed Mediouni
+ *
+ */
+
+#include "qemu/osdep.h"
+#include "cpu.h"
+#include "system/address-spaces.h"
+#include "system/ioport.h"
+#include "gdbstub/helpers.h"
+#include "qemu/accel.h"
+#include "accel/accel-ops.h"
+#include "system/whpx.h"
+#include "system/cpus.h"
+#include "system/runstate.h"
+#include "qemu/main-loop.h"
+#include "hw/boards.h"
+#include "qemu/error-report.h"
+#include "qapi/error.h"
+#include "qapi/qapi-types-common.h"
+#include "qapi/qapi-visit-common.h"
+#include "migration/blocker.h"
+#include "accel/accel-cpu-target.h"
+#include <winerror.h>
+
+#include "syndrome.h"
+#include "cpu.h"
+#include "cpregs.h"
+#include "internals.h"
+
+#include "system/whpx-internal.h"
+#include "system/whpx-accel-ops.h"
+#include "system/whpx-all.h"
+#include "system/whpx-common.h"
+#include "hw/arm/bsa.h"
+#include "arm-powerctl.h"
+
+#include <winhvplatform.h>
+#include <winhvplatformdefs.h>
+
+struct whpx_reg_match {
+    WHV_REGISTER_NAME reg;
+    uint64_t offset;
+};
+
+static const struct whpx_reg_match whpx_reg_match[] = {
+    { WHvArm64RegisterX0,   offsetof(CPUARMState, xregs[0]) },
+    { WHvArm64RegisterX1,   offsetof(CPUARMState, xregs[1]) },
+    { WHvArm64RegisterX2,   offsetof(CPUARMState, xregs[2]) },
+    { WHvArm64RegisterX3,   offsetof(CPUARMState, xregs[3]) },
+    { WHvArm64RegisterX4,   offsetof(CPUARMState, xregs[4]) },
+    { WHvArm64RegisterX5,   offsetof(CPUARMState, xregs[5]) },
+    { WHvArm64RegisterX6,   offsetof(CPUARMState, xregs[6]) },
+    { WHvArm64RegisterX7,   offsetof(CPUARMState, xregs[7]) },
+    { WHvArm64RegisterX8,   offsetof(CPUARMState, xregs[8]) },
+    { WHvArm64RegisterX9,   offsetof(CPUARMState, xregs[9]) },
+    { WHvArm64RegisterX10,  offsetof(CPUARMState, xregs[10]) },
+    { WHvArm64RegisterX11,  offsetof(CPUARMState, xregs[11]) },
+    { WHvArm64RegisterX12,  offsetof(CPUARMState, xregs[12]) },
+    { WHvArm64RegisterX13,  offsetof(CPUARMState, xregs[13]) },
+    { WHvArm64RegisterX14,  offsetof(CPUARMState, xregs[14]) },
+    { WHvArm64RegisterX15,  offsetof(CPUARMState, xregs[15]) },
+    { WHvArm64RegisterX16,  offsetof(CPUARMState, xregs[16]) },
+    { WHvArm64RegisterX17,  offsetof(CPUARMState, xregs[17]) },
+    { WHvArm64RegisterX18,  offsetof(CPUARMState, xregs[18]) },
+    { WHvArm64RegisterX19,  offsetof(CPUARMState, xregs[19]) },
+    { WHvArm64RegisterX20,  offsetof(CPUARMState, xregs[20]) },
+    { WHvArm64RegisterX21,  offsetof(CPUARMState, xregs[21]) },
+    { WHvArm64RegisterX22,  offsetof(CPUARMState, xregs[22]) },
+    { WHvArm64RegisterX23,  offsetof(CPUARMState, xregs[23]) },
+    { WHvArm64RegisterX24,  offsetof(CPUARMState, xregs[24]) },
+    { WHvArm64RegisterX25,  offsetof(CPUARMState, xregs[25]) },
+    { WHvArm64RegisterX26,  offsetof(CPUARMState, xregs[26]) },
+    { WHvArm64RegisterX27,  offsetof(CPUARMState, xregs[27]) },
+    { WHvArm64RegisterX28,  offsetof(CPUARMState, xregs[28]) },
+    { WHvArm64RegisterFp,  offsetof(CPUARMState, xregs[29]) },
+    { WHvArm64RegisterLr,  offsetof(CPUARMState, xregs[30]) },
+    { WHvArm64RegisterPc,   offsetof(CPUARMState, pc) },
+};
+
+static const struct whpx_reg_match whpx_fpreg_match[] = {
+    { WHvArm64RegisterQ0,  offsetof(CPUARMState, vfp.zregs[0]) },
+    { WHvArm64RegisterQ1,  offsetof(CPUARMState, vfp.zregs[1]) },
+    { WHvArm64RegisterQ2,  offsetof(CPUARMState, vfp.zregs[2]) },
+    { WHvArm64RegisterQ3,  offsetof(CPUARMState, vfp.zregs[3]) },
+    { WHvArm64RegisterQ4,  offsetof(CPUARMState, vfp.zregs[4]) },
+    { WHvArm64RegisterQ5,  offsetof(CPUARMState, vfp.zregs[5]) },
+    { WHvArm64RegisterQ6,  offsetof(CPUARMState, vfp.zregs[6]) },
+    { WHvArm64RegisterQ7,  offsetof(CPUARMState, vfp.zregs[7]) },
+    { WHvArm64RegisterQ8,  offsetof(CPUARMState, vfp.zregs[8]) },
+    { WHvArm64RegisterQ9,  offsetof(CPUARMState, vfp.zregs[9]) },
+    { WHvArm64RegisterQ10, offsetof(CPUARMState, vfp.zregs[10]) },
+    { WHvArm64RegisterQ11, offsetof(CPUARMState, vfp.zregs[11]) },
+    { WHvArm64RegisterQ12, offsetof(CPUARMState, vfp.zregs[12]) },
+    { WHvArm64RegisterQ13, offsetof(CPUARMState, vfp.zregs[13]) },
+    { WHvArm64RegisterQ14, offsetof(CPUARMState, vfp.zregs[14]) },
+    { WHvArm64RegisterQ15, offsetof(CPUARMState, vfp.zregs[15]) },
+    { WHvArm64RegisterQ16, offsetof(CPUARMState, vfp.zregs[16]) },
+    { WHvArm64RegisterQ17, offsetof(CPUARMState, vfp.zregs[17]) },
+    { WHvArm64RegisterQ18, offsetof(CPUARMState, vfp.zregs[18]) },
+    { WHvArm64RegisterQ19, offsetof(CPUARMState, vfp.zregs[19]) },
+    { WHvArm64RegisterQ20, offsetof(CPUARMState, vfp.zregs[20]) },
+    { WHvArm64RegisterQ21, offsetof(CPUARMState, vfp.zregs[21]) },
+    { WHvArm64RegisterQ22, offsetof(CPUARMState, vfp.zregs[22]) },
+    { WHvArm64RegisterQ23, offsetof(CPUARMState, vfp.zregs[23]) },
+    { WHvArm64RegisterQ24, offsetof(CPUARMState, vfp.zregs[24]) },
+    { WHvArm64RegisterQ25, offsetof(CPUARMState, vfp.zregs[25]) },
+    { WHvArm64RegisterQ26, offsetof(CPUARMState, vfp.zregs[26]) },
+    { WHvArm64RegisterQ27, offsetof(CPUARMState, vfp.zregs[27]) },
+    { WHvArm64RegisterQ28, offsetof(CPUARMState, vfp.zregs[28]) },
+    { WHvArm64RegisterQ29, offsetof(CPUARMState, vfp.zregs[29]) },
+    { WHvArm64RegisterQ30, offsetof(CPUARMState, vfp.zregs[30]) },
+    { WHvArm64RegisterQ31, offsetof(CPUARMState, vfp.zregs[31]) },
+};
+
+#define WHPX_SYSREG(crn, crm, op0, op1, op2) \
+        ENCODE_AA64_CP_REG(CP_REG_ARM64_SYSREG_CP, crn, crm, op0, op1, op2)
+
+struct whpx_sreg_match {
+    WHV_REGISTER_NAME reg;
+    uint32_t key;
+    bool global;
+    uint32_t cp_idx;
+};
+
+static struct whpx_sreg_match whpx_sreg_match[] = {
+    { WHvArm64RegisterDbgbvr0El1, WHPX_SYSREG(0, 0, 2, 0, 4) },
+    { WHvArm64RegisterDbgbcr0El1, WHPX_SYSREG(0, 0, 2, 0, 5) },
+    { WHvArm64RegisterDbgwvr0El1, WHPX_SYSREG(0, 0, 2, 0, 6) },
+    { WHvArm64RegisterDbgwcr0El1, WHPX_SYSREG(0, 0, 2, 0, 7) },
+
+    { WHvArm64RegisterDbgbvr0El1, WHPX_SYSREG(0, 1, 2, 0, 4) },
+    { WHvArm64RegisterDbgbcr0El1, WHPX_SYSREG(0, 1, 2, 0, 5) },
+    { WHvArm64RegisterDbgwvr0El1, WHPX_SYSREG(0, 1, 2, 0, 6) },
+    { WHvArm64RegisterDbgwcr0El1, WHPX_SYSREG(0, 1, 2, 0, 7) },
+
+    { WHvArm64RegisterDbgbvr2El1, WHPX_SYSREG(0, 2, 2, 0, 4) },
+    { WHvArm64RegisterDbgbcr2El1, WHPX_SYSREG(0, 2, 2, 0, 5) },
+    { WHvArm64RegisterDbgwvr2El1, WHPX_SYSREG(0, 2, 2, 0, 6) },
+    { WHvArm64RegisterDbgwcr2El1, WHPX_SYSREG(0, 2, 2, 0, 7) },
+
+    { WHvArm64RegisterDbgbvr3El1, WHPX_SYSREG(0, 3, 2, 0, 4) },
+    { WHvArm64RegisterDbgbcr3El1, WHPX_SYSREG(0, 3, 2, 0, 5) },
+    { WHvArm64RegisterDbgwvr3El1, WHPX_SYSREG(0, 3, 2, 0, 6) },
+    { WHvArm64RegisterDbgwcr3El1, WHPX_SYSREG(0, 3, 2, 0, 7) },
+
+    { WHvArm64RegisterDbgbvr4El1, WHPX_SYSREG(0, 4, 2, 0, 4) },
+    { WHvArm64RegisterDbgbcr4El1, WHPX_SYSREG(0, 4, 2, 0, 5) },
+    { WHvArm64RegisterDbgwvr4El1, WHPX_SYSREG(0, 4, 2, 0, 6) },
+    { WHvArm64RegisterDbgwcr4El1, WHPX_SYSREG(0, 4, 2, 0, 7) },
+
+    { WHvArm64RegisterDbgbvr5El1, WHPX_SYSREG(0, 5, 2, 0, 4) },
+    { WHvArm64RegisterDbgbcr5El1, WHPX_SYSREG(0, 5, 2, 0, 5) },
+    { WHvArm64RegisterDbgwvr5El1, WHPX_SYSREG(0, 5, 2, 0, 6) },
+    { WHvArm64RegisterDbgwcr5El1, WHPX_SYSREG(0, 5, 2, 0, 7) },
+
+    { WHvArm64RegisterDbgbvr6El1, WHPX_SYSREG(0, 6, 2, 0, 4) },
+    { WHvArm64RegisterDbgbcr6El1, WHPX_SYSREG(0, 6, 2, 0, 5) },
+    { WHvArm64RegisterDbgwvr6El1, WHPX_SYSREG(0, 6, 2, 0, 6) },
+    { WHvArm64RegisterDbgwcr6El1, WHPX_SYSREG(0, 6, 2, 0, 7) },
+
+    { WHvArm64RegisterDbgbvr7El1, WHPX_SYSREG(0, 7, 2, 0, 4) },
+    { WHvArm64RegisterDbgbcr7El1, WHPX_SYSREG(0, 7, 2, 0, 5) },
+    { WHvArm64RegisterDbgwvr7El1, WHPX_SYSREG(0, 7, 2, 0, 6) },
+    { WHvArm64RegisterDbgwcr7El1, WHPX_SYSREG(0, 7, 2, 0, 7) },
+
+    { WHvArm64RegisterDbgbvr8El1, WHPX_SYSREG(0, 8, 2, 0, 4) },
+    { WHvArm64RegisterDbgbcr8El1, WHPX_SYSREG(0, 8, 2, 0, 5) },
+    { WHvArm64RegisterDbgwvr8El1, WHPX_SYSREG(0, 8, 2, 0, 6) },
+    { WHvArm64RegisterDbgwcr8El1, WHPX_SYSREG(0, 8, 2, 0, 7) },
+
+    { WHvArm64RegisterDbgbvr9El1, WHPX_SYSREG(0, 9, 2, 0, 4) },
+    { WHvArm64RegisterDbgbcr9El1, WHPX_SYSREG(0, 9, 2, 0, 5) },
+    { WHvArm64RegisterDbgwvr9El1, WHPX_SYSREG(0, 9, 2, 0, 6) },
+    { WHvArm64RegisterDbgwcr9El1, WHPX_SYSREG(0, 9, 2, 0, 7) },
+
+    { WHvArm64RegisterDbgbvr10El1, WHPX_SYSREG(0, 10, 2, 0, 4) },
+    { WHvArm64RegisterDbgbcr10El1, WHPX_SYSREG(0, 10, 2, 0, 5) },
+    { WHvArm64RegisterDbgwvr10El1, WHPX_SYSREG(0, 10, 2, 0, 6) },
+    { WHvArm64RegisterDbgwcr10El1, WHPX_SYSREG(0, 10, 2, 0, 7) },
+
+    { WHvArm64RegisterDbgbvr11El1, WHPX_SYSREG(0, 11, 2, 0, 4) },
+    { WHvArm64RegisterDbgbcr11El1, WHPX_SYSREG(0, 11, 2, 0, 5) },
+    { WHvArm64RegisterDbgwvr11El1, WHPX_SYSREG(0, 11, 2, 0, 6) },
+    { WHvArm64RegisterDbgwcr11El1, WHPX_SYSREG(0, 11, 2, 0, 7) },
+
+    { WHvArm64RegisterDbgbvr12El1, WHPX_SYSREG(0, 12, 2, 0, 4) },
+    { WHvArm64RegisterDbgbcr12El1, WHPX_SYSREG(0, 12, 2, 0, 5) },
+    { WHvArm64RegisterDbgwvr12El1, WHPX_SYSREG(0, 12, 2, 0, 6) },
+    { WHvArm64RegisterDbgwcr12El1, WHPX_SYSREG(0, 12, 2, 0, 7) },
+
+    { WHvArm64RegisterDbgbvr13El1, WHPX_SYSREG(0, 13, 2, 0, 4) },
+    { WHvArm64RegisterDbgbcr13El1, WHPX_SYSREG(0, 13, 2, 0, 5) },
+    { WHvArm64RegisterDbgwvr13El1, WHPX_SYSREG(0, 13, 2, 0, 6) },
+    { WHvArm64RegisterDbgwcr13El1, WHPX_SYSREG(0, 13, 2, 0, 7) },
+
+    { WHvArm64RegisterDbgbvr14El1, WHPX_SYSREG(0, 14, 2, 0, 4) },
+    { WHvArm64RegisterDbgbcr14El1, WHPX_SYSREG(0, 14, 2, 0, 5) },
+    { WHvArm64RegisterDbgwvr14El1, WHPX_SYSREG(0, 14, 2, 0, 6) },
+    { WHvArm64RegisterDbgwcr14El1, WHPX_SYSREG(0, 14, 2, 0, 7) },
+
+    { WHvArm64RegisterDbgbvr15El1, WHPX_SYSREG(0, 15, 2, 0, 4) },
+    { WHvArm64RegisterDbgbcr15El1, WHPX_SYSREG(0, 15, 2, 0, 5) },
+    { WHvArm64RegisterDbgwvr15El1, WHPX_SYSREG(0, 15, 2, 0, 6) },
+    { WHvArm64RegisterDbgwcr15El1, WHPX_SYSREG(0, 15, 2, 0, 7) },
+#ifdef SYNC_NO_RAW_REGS
+    /*
+     * The registers below are manually synced on init because they are
+     * marked as NO_RAW. We still list them to make number space sync easier.
+     */
+    { WHvArm64RegisterMidrEl1, WHPX_SYSREG(0, 0, 3, 0, 0) },
+    { WHvArm64RegisterMpidrEl1, WHPX_SYSREG(0, 0, 3, 0, 5) },
+    { WHvArm64RegisterIdPfr0El1, WHPX_SYSREG(0, 4, 3, 0, 0) },
+#endif
+    { WHvArm64RegisterIdAa64Pfr1El1, WHPX_SYSREG(0, 4, 3, 0, 1), true },
+    { WHvArm64RegisterIdAa64Dfr0El1, WHPX_SYSREG(0, 5, 3, 0, 0), true },
+    { WHvArm64RegisterIdAa64Dfr1El1, WHPX_SYSREG(0, 5, 3, 0, 1), true },
+    { WHvArm64RegisterIdAa64Isar0El1, WHPX_SYSREG(0, 6, 3, 0, 0), true },
+    { WHvArm64RegisterIdAa64Isar1El1, WHPX_SYSREG(0, 6, 3, 0, 1), true },
+#ifdef SYNC_NO_MMFR0
+    /* We keep the hardware MMFR0 around. HW limits are there anyway */
+    { WHvArm64RegisterIdAa64Mmfr0El1, WHPX_SYSREG(0, 7, 3, 0, 0) },
+#endif
+    { WHvArm64RegisterIdAa64Mmfr1El1, WHPX_SYSREG(0, 7, 3, 0, 1), true },
+    { WHvArm64RegisterIdAa64Mmfr2El1, WHPX_SYSREG(0, 7, 3, 0, 2), true },
+    { WHvArm64RegisterIdAa64Mmfr3El1, WHPX_SYSREG(0, 7, 3, 0, 3), true },
+
+    { WHvArm64RegisterMdscrEl1, WHPX_SYSREG(0, 2, 2, 0, 2) },
+    { WHvArm64RegisterSctlrEl1, WHPX_SYSREG(1, 0, 3, 0, 0) },
+    { WHvArm64RegisterCpacrEl1, WHPX_SYSREG(1, 0, 3, 0, 2) },
+    { WHvArm64RegisterTtbr0El1, WHPX_SYSREG(2, 0, 3, 0, 0) },
+    { WHvArm64RegisterTtbr1El1, WHPX_SYSREG(2, 0, 3, 0, 1) },
+    { WHvArm64RegisterTcrEl1, WHPX_SYSREG(2, 0, 3, 0, 2) },
+
+    { WHvArm64RegisterApiAKeyLoEl1, WHPX_SYSREG(2, 1, 3, 0, 0) },
+    { WHvArm64RegisterApiAKeyHiEl1, WHPX_SYSREG(2, 1, 3, 0, 1) },
+    { WHvArm64RegisterApiBKeyLoEl1, WHPX_SYSREG(2, 1, 3, 0, 2) },
+    { WHvArm64RegisterApiBKeyHiEl1, WHPX_SYSREG(2, 1, 3, 0, 3) },
+    { WHvArm64RegisterApdAKeyLoEl1, WHPX_SYSREG(2, 2, 3, 0, 0) },
+    { WHvArm64RegisterApdAKeyHiEl1, WHPX_SYSREG(2, 2, 3, 0, 1) },
+    { WHvArm64RegisterApdBKeyLoEl1, WHPX_SYSREG(2, 2, 3, 0, 2) },
+    { WHvArm64RegisterApdBKeyHiEl1, WHPX_SYSREG(2, 2, 3, 0, 3) },
+    { WHvArm64RegisterApgAKeyLoEl1, WHPX_SYSREG(2, 3, 3, 0, 0) },
+    { WHvArm64RegisterApgAKeyHiEl1, WHPX_SYSREG(2, 3, 3, 0, 1) },
+
+    { WHvArm64RegisterSpsrEl1, WHPX_SYSREG(4, 0, 3, 0, 0) },
+    { WHvArm64RegisterElrEl1, WHPX_SYSREG(4, 0, 3, 0, 1) },
+    { WHvArm64RegisterSpEl1, WHPX_SYSREG(4, 1, 3, 0, 0) },
+    { WHvArm64RegisterEsrEl1, WHPX_SYSREG(5, 2, 3, 0, 0) },
+    { WHvArm64RegisterFarEl1, WHPX_SYSREG(6, 0, 3, 0, 0) },
+    { WHvArm64RegisterParEl1, WHPX_SYSREG(7, 4, 3, 0, 0) },
+    { WHvArm64RegisterMairEl1, WHPX_SYSREG(10, 2, 3, 0, 0) },
+    { WHvArm64RegisterVbarEl1, WHPX_SYSREG(12, 0, 3, 0, 0) },
+    { WHvArm64RegisterContextidrEl1, WHPX_SYSREG(13, 0, 3, 0, 1) },
+    { WHvArm64RegisterTpidrEl1, WHPX_SYSREG(13, 0, 3, 0, 4) },
+    { WHvArm64RegisterCntkctlEl1, WHPX_SYSREG(14, 1, 3, 0, 0) },
+    { WHvArm64RegisterCsselrEl1, WHPX_SYSREG(0, 0, 3, 2, 0) },
+    { WHvArm64RegisterTpidrEl0, WHPX_SYSREG(13, 0, 3, 3, 2) },
+    { WHvArm64RegisterTpidrroEl0, WHPX_SYSREG(13, 0, 3, 3, 3) },
+    { WHvArm64RegisterCntvCtlEl0, WHPX_SYSREG(14, 3, 3, 3, 1) },
+    { WHvArm64RegisterCntvCvalEl0, WHPX_SYSREG(14, 3, 3, 3, 2) },
+    { WHvArm64RegisterSpEl1, WHPX_SYSREG(4, 1, 3, 4, 0) },
+};
+
+static void flush_cpu_state(CPUState *cpu)
+{
+    if (cpu->vcpu_dirty) {
+        whpx_set_registers(cpu, WHPX_SET_RUNTIME_STATE);
+        cpu->vcpu_dirty = false;
+    }
+}
+
+HRESULT whpx_set_exception_exit_bitmap(UINT64 exceptions)
+{
+    if (exceptions != 0) {
+        return E_NOTIMPL;
+    }
+    return ERROR_SUCCESS;
+}
+void whpx_apply_breakpoints(
+struct whpx_breakpoint_collection *breakpoints,
+    CPUState *cpu,
+    bool resuming)
+{
+
+}
+void whpx_translate_cpu_breakpoints(
+    struct whpx_breakpoints *breakpoints,
+    CPUState *cpu,
+    int cpu_breakpoint_count)
+{
+
+}
+
+static void whpx_get_reg(CPUState *cpu, WHV_REGISTER_NAME reg, WHV_REGISTER_VALUE* val)
+{
+    struct whpx_state *whpx = &whpx_global;
+    HRESULT hr;
+
+    flush_cpu_state(cpu);
+
+    hr = whp_dispatch.WHvGetVirtualProcessorRegisters(whpx->partition, cpu->cpu_index,
+         &reg, 1, val);
+
+    if (FAILED(hr)) {
+        error_report("WHPX: Failed to get register %08x, hr=%08lx", reg, hr);
+    }
+}
+
+static void whpx_set_reg(CPUState *cpu, WHV_REGISTER_NAME reg, WHV_REGISTER_VALUE val)
+{
+    struct whpx_state *whpx = &whpx_global;
+    HRESULT hr;
+    hr = whp_dispatch.WHvSetVirtualProcessorRegisters(whpx->partition, cpu->cpu_index,
+         &reg, 1, &val);
+
+    if (FAILED(hr)) {
+        error_report("WHPX: Failed to set register %08x, hr=%08lx", reg, hr);
+    }
+}
+
+static void whpx_get_global_reg(WHV_REGISTER_NAME reg, WHV_REGISTER_VALUE *val)
+{
+    struct whpx_state *whpx = &whpx_global;
+    HRESULT hr;
+
+    hr = whp_dispatch.WHvGetVirtualProcessorRegisters(whpx->partition, WHV_ANY_VP,
+         &reg, 1, val);
+
+    if (FAILED(hr)) {
+        error_report("WHPX: Failed to get register %08x, hr=%08lx", reg, hr);
+    }
+}
+
+static void whpx_set_global_reg(WHV_REGISTER_NAME reg, WHV_REGISTER_VALUE val)
+{
+    struct whpx_state *whpx = &whpx_global;
+    HRESULT hr;
+    hr = whp_dispatch.WHvSetVirtualProcessorRegisters(whpx->partition, WHV_ANY_VP,
+         &reg, 1, &val);
+
+    if (FAILED(hr)) {
+        error_report("WHPX: Failed to set register %08x, hr=%08lx", reg, hr);
+    }
+}
+
+static uint64_t whpx_get_gp_reg(CPUState *cpu, int rt)
+{
+    assert(rt <= 31);
+    if (rt == 31) {
+        return 0;
+    }
+    WHV_REGISTER_NAME reg = WHvArm64RegisterX0 + rt;
+    WHV_REGISTER_VALUE val;
+    whpx_get_reg(cpu, reg, &val);
+
+    return val.Reg64;
+}
+
+static void whpx_set_gp_reg(CPUState *cpu, int rt, uint64_t val)
+{
+    assert(rt < 31);
+    WHV_REGISTER_NAME reg = WHvArm64RegisterX0 + rt;
+    WHV_REGISTER_VALUE reg_val = {.Reg64 = val};
+
+    whpx_set_reg(cpu, reg, reg_val);
+}
+
+static int whpx_handle_mmio(CPUState *cpu, WHV_MEMORY_ACCESS_CONTEXT *ctx)
+{
+    uint64_t syndrome = ctx->Syndrome;
+
+    bool isv = syndrome & ARM_EL_ISV;
+    bool iswrite = (syndrome >> 6) & 1;
+    bool sse = (syndrome >> 21) & 1;
+    uint32_t sas = (syndrome >> 22) & 3;
+    uint32_t len = 1 << sas;
+    uint32_t srt = (syndrome >> 16) & 0x1f;
+    uint32_t cm = (syndrome >> 8) & 0x1;
+    uint64_t val = 0;
+
+    assert(!cm);
+    assert(isv);
+
+    if (iswrite) {
+        val = whpx_get_gp_reg(cpu, srt);
+        address_space_write(&address_space_memory,
+                            ctx->Gpa,
+                            MEMTXATTRS_UNSPECIFIED, &val, len);
+    } else {
+        address_space_read(&address_space_memory,
+                           ctx->Gpa,
+                           MEMTXATTRS_UNSPECIFIED, &val, len);
+        if (sse) {
+            val = sextract64(val, 0, len * 8);
+        }
+        whpx_set_gp_reg(cpu, srt, val);
+    }
+
+    return 0;
+}
+
+static void whpx_psci_cpu_off(ARMCPU *arm_cpu)
+{
+    int32_t ret = arm_set_cpu_off(arm_cpu_mp_affinity(arm_cpu));
+    assert(ret == QEMU_ARM_POWERCTL_RET_SUCCESS);
+}
+
+int whpx_vcpu_run(CPUState *cpu)
+{
+    HRESULT hr;
+    struct whpx_state *whpx = &whpx_global;
+    ARMCPU *arm_cpu = ARM_CPU(cpu);
+    AccelCPUState *vcpu = cpu->accel;
+    int ret;
+
+
+    g_assert(bql_locked());
+
+    if (whpx->running_cpus++ == 0) {
+        ret = whpx_first_vcpu_starting(cpu);
+        if (ret != 0) {
+            return ret;
+        }
+    }
+
+    bql_unlock();
+
+
+    cpu_exec_start(cpu);
+    do {
+        bool advance_pc = false;
+        if (cpu->vcpu_dirty) {
+            whpx_set_registers(cpu, WHPX_SET_RUNTIME_STATE);
+            cpu->vcpu_dirty = false;
+        }
+
+        if (qatomic_read(&cpu->exit_request)) {
+            whpx_vcpu_kick(cpu);
+        }
+
+        hr = whp_dispatch.WHvRunVirtualProcessor(
+            whpx->partition, cpu->cpu_index,
+            &vcpu->exit_ctx, sizeof(vcpu->exit_ctx));
+
+        if (FAILED(hr)) {
+            error_report("WHPX: Failed to exec a virtual processor,"
+                         " hr=%08lx", hr);
+            ret = -1;
+            break;
+        }
+
+        switch (vcpu->exit_ctx.ExitReason) {
+        case WHvRunVpExitReasonGpaIntercept:
+        case WHvRunVpExitReasonUnmappedGpa:
+            advance_pc = true;
+
+            if (vcpu->exit_ctx.MemoryAccess.Syndrome >> 8 & 0x1) {
+                error_report("WHPX: cached access to unmapped memory"
+                "Pc = 0x%llx Gva = 0x%llx Gpa = 0x%llx",
+                vcpu->exit_ctx.MemoryAccess.Header.Pc,
+                vcpu->exit_ctx.MemoryAccess.Gpa,
+                vcpu->exit_ctx.MemoryAccess.Gva);
+                break;
+            }
+
+            ret = whpx_handle_mmio(cpu, &vcpu->exit_ctx.MemoryAccess);
+            break;
+        case WHvRunVpExitReasonCanceled:
+            cpu->exception_index = EXCP_INTERRUPT;
+            ret = 1;
+            break;
+        case WHvRunVpExitReasonArm64Reset:
+            switch (vcpu->exit_ctx.Arm64Reset.ResetType) {
+            case WHvArm64ResetTypePowerOff:
+                qemu_system_shutdown_request(SHUTDOWN_CAUSE_GUEST_SHUTDOWN);
+                break;
+            case WHvArm64ResetTypeReboot:
+                qemu_system_reset_request(SHUTDOWN_CAUSE_GUEST_RESET);
+                break;
+            default:
+                g_assert_not_reached();
+            }
+            bql_lock();
+            if (arm_cpu->power_state != PSCI_OFF) {
+                whpx_psci_cpu_off(arm_cpu);
+            }
+            bql_unlock();
+            break;
+        case WHvRunVpExitReasonNone:
+        case WHvRunVpExitReasonUnrecoverableException:
+        case WHvRunVpExitReasonInvalidVpRegisterValue:
+        case WHvRunVpExitReasonUnsupportedFeature:
+        default:
+            error_report("WHPX: Unexpected VP exit code 0x%08x",
+                         vcpu->exit_ctx.ExitReason);
+            whpx_get_registers(cpu);
+            bql_lock();
+            qemu_system_guest_panicked(cpu_get_crash_info(cpu));
+            bql_unlock();
+            break;
+        }
+        if (advance_pc) {
+            WHV_REGISTER_VALUE pc;
+
+            flush_cpu_state(cpu);
+            pc.Reg64 = vcpu->exit_ctx.MemoryAccess.Header.Pc + 4;
+            whpx_set_reg(cpu, WHvArm64RegisterPc, pc);
+        }
+    } while (!ret);
+
+    cpu_exec_end(cpu);
+
+    bql_lock();
+    current_cpu = cpu;
+
+    if (--whpx->running_cpus == 0) {
+        whpx_last_vcpu_stopping(cpu);
+    }
+
+    qatomic_set(&cpu->exit_request, false);
+
+    return ret < 0;
+}
+
+static void clean_whv_register_value(WHV_REGISTER_VALUE *val)
+{
+    memset(val, 0, sizeof(WHV_REGISTER_VALUE));
+}
+
+void whpx_get_registers(CPUState *cpu)
+{
+    ARMCPU *arm_cpu = ARM_CPU(cpu);
+    CPUARMState *env = &arm_cpu->env;
+    WHV_REGISTER_VALUE val;
+    int i;
+
+    for (i = 0; i < ARRAY_SIZE(whpx_reg_match); i++) {
+        whpx_get_reg(cpu, whpx_reg_match[i].reg, &val);
+        *(uint64_t *)((void *)env + whpx_reg_match[i].offset) = val.Reg64;
+    }
+
+    for (i = 0; i < ARRAY_SIZE(whpx_fpreg_match); i++) {
+        whpx_get_reg(cpu, whpx_reg_match[i].reg, &val);
+        memcpy((void *)env + whpx_fpreg_match[i].offset, &val, sizeof(val.Reg128));
+    }
+
+    whpx_get_reg(cpu, WHvArm64RegisterPc, &val);
+    env->pc = val.Reg64;
+
+    whpx_get_reg(cpu, WHvArm64RegisterFpcr, &val);
+    vfp_set_fpcr(env, val.Reg32);
+
+    whpx_get_reg(cpu, WHvArm64RegisterFpsr, &val);
+    vfp_set_fpsr(env, val.Reg32);
+
+    whpx_get_reg(cpu, WHvArm64RegisterPstate, &val);
+    pstate_write(env, val.Reg32);
+
+    for (i = 0; i < ARRAY_SIZE(whpx_sreg_match); i++) {
+        if (whpx_sreg_match[i].global == true) {
+            continue;
+        }
+        if (whpx_sreg_match[i].cp_idx == -1) {
+            continue;
+        }
+
+        whpx_get_reg(cpu, whpx_sreg_match[i].reg, &val);
+
+        arm_cpu->cpreg_values[whpx_sreg_match[i].cp_idx] = val.Reg64;
+    }
+
+    /* WHP disallows us from reading global regs as a vCPU */
+    for (i = 0; i < ARRAY_SIZE(whpx_sreg_match); i++) {
+        if (whpx_sreg_match[i].global == false) {
+            continue;
+        }
+        if (whpx_sreg_match[i].cp_idx == -1) {
+            continue;
+        }
+
+        whpx_get_global_reg(whpx_sreg_match[i].reg, &val);
+
+        arm_cpu->cpreg_values[whpx_sreg_match[i].cp_idx] = val.Reg64;
+    }
+    assert(write_list_to_cpustate(arm_cpu));
+
+    aarch64_restore_sp(env, arm_current_el(env));
+}
+
+void whpx_set_registers(CPUState *cpu, int level)
+{
+    ARMCPU *arm_cpu = ARM_CPU(cpu);
+    CPUARMState *env = &arm_cpu->env;
+    WHV_REGISTER_VALUE val;
+    clean_whv_register_value(&val);
+    int i;
+
+    assert(cpu_is_stopped(cpu) || qemu_cpu_is_self(cpu));
+
+    for (i = 0; i < ARRAY_SIZE(whpx_reg_match); i++) {
+        val.Reg64 = *(uint64_t *)((void *)env + whpx_reg_match[i].offset);
+        whpx_set_reg(cpu, whpx_reg_match[i].reg, val);
+    }
+
+    for (i = 0; i < ARRAY_SIZE(whpx_fpreg_match); i++) {
+        memcpy(&val.Reg128, (void *)env + whpx_fpreg_match[i].offset, sizeof(val.Reg128));
+        whpx_set_reg(cpu, whpx_reg_match[i].reg, val);
+    }
+
+    clean_whv_register_value(&val);
+    val.Reg64 = env->pc;
+    whpx_set_reg(cpu, WHvArm64RegisterPc, val);
+
+    clean_whv_register_value(&val);
+    val.Reg32 = vfp_get_fpcr(env);
+    whpx_set_reg(cpu, WHvArm64RegisterFpcr, val);
+    val.Reg32 = vfp_get_fpsr(env);
+    whpx_set_reg(cpu, WHvArm64RegisterFpsr, val);
+    val.Reg32 = pstate_read(env);
+    whpx_set_reg(cpu, WHvArm64RegisterPstate, val);
+
+    aarch64_save_sp(env, arm_current_el(env));
+
+    assert(write_cpustate_to_list(arm_cpu, false));
+    for (i = 0; i < ARRAY_SIZE(whpx_sreg_match); i++) {
+        if (whpx_sreg_match[i].global == true) {
+            continue;
+        }
+
+        if (whpx_sreg_match[i].cp_idx == -1) {
+            continue;
+        }
+        clean_whv_register_value(&val);
+        val.Reg64 = arm_cpu->cpreg_values[whpx_sreg_match[i].cp_idx];
+        whpx_set_reg(cpu, whpx_sreg_match[i].reg, val);
+    }
+
+    /* Currently set global regs every time. */
+    for (i = 0; i < ARRAY_SIZE(whpx_sreg_match); i++) {
+        if (whpx_sreg_match[i].global == false) {
+            continue;
+        }
+
+        if (whpx_sreg_match[i].cp_idx == -1) {
+            continue;
+        }
+        clean_whv_register_value(&val);
+        val.Reg64 = arm_cpu->cpreg_values[whpx_sreg_match[i].cp_idx];
+        whpx_set_global_reg(whpx_sreg_match[i].reg, val);
+    }
+}
+
+static uint32_t max_vcpu_index;
+
+static void whpx_cpu_update_state(void *opaque, bool running, RunState state)
+{
+}
+
+int whpx_init_vcpu(CPUState *cpu)
+{
+    HRESULT hr;
+    struct whpx_state *whpx = &whpx_global;
+    AccelCPUState *vcpu = NULL;
+    ARMCPU *arm_cpu = ARM_CPU(cpu);
+    CPUARMState *env = &arm_cpu->env;
+    int ret;
+
+    uint32_t sregs_match_len = ARRAY_SIZE(whpx_sreg_match);
+    uint32_t sregs_cnt = 0;
+    WHV_REGISTER_VALUE val;
+    int i;
+
+    vcpu = g_new0(AccelCPUState, 1);
+
+    hr = whp_dispatch.WHvCreateVirtualProcessor(
+        whpx->partition, cpu->cpu_index, 0);
+    if (FAILED(hr)) {
+        error_report("WHPX: Failed to create a virtual processor,"
+                     " hr=%08lx", hr);
+        ret = -EINVAL;
+        goto error;
+    }
+
+    /* Assumption that CNTFRQ_EL0 is the same between the VMM and the partition. */
+    asm volatile("mrs %0, cntfrq_el0" : "=r"(arm_cpu->gt_cntfrq_hz));
+
+    cpu->vcpu_dirty = true;
+    cpu->accel = vcpu;
+    max_vcpu_index = max(max_vcpu_index, cpu->cpu_index);
+    qemu_add_vm_change_state_handler(whpx_cpu_update_state, env);
+
+    env->aarch64 = true;
+
+    /* Allocate enough space for our sysreg sync */
+    arm_cpu->cpreg_indexes = g_renew(uint64_t, arm_cpu->cpreg_indexes,
+                                     sregs_match_len);
+    arm_cpu->cpreg_values = g_renew(uint64_t, arm_cpu->cpreg_values,
+                                    sregs_match_len);
+    arm_cpu->cpreg_vmstate_indexes = g_renew(uint64_t,
+                                             arm_cpu->cpreg_vmstate_indexes,
+                                             sregs_match_len);
+    arm_cpu->cpreg_vmstate_values = g_renew(uint64_t,
+                                            arm_cpu->cpreg_vmstate_values,
+                                            sregs_match_len);
+
+    memset(arm_cpu->cpreg_values, 0, sregs_match_len * sizeof(uint64_t));
+
+    /* Populate cp list for all known sysregs */
+    for (i = 0; i < sregs_match_len; i++) {
+        const ARMCPRegInfo *ri;
+        uint32_t key = whpx_sreg_match[i].key;
+
+        ri = get_arm_cp_reginfo(arm_cpu->cp_regs, key);
+        if (ri) {
+            assert(!(ri->type & ARM_CP_NO_RAW));
+            whpx_sreg_match[i].cp_idx = sregs_cnt;
+            arm_cpu->cpreg_indexes[sregs_cnt++] = cpreg_to_kvm_id(key);
+        } else {
+            whpx_sreg_match[i].cp_idx = -1;
+        }
+    }
+    arm_cpu->cpreg_array_len = sregs_cnt;
+    arm_cpu->cpreg_vmstate_array_len = sregs_cnt;
+
+    assert(write_cpustate_to_list(arm_cpu, false));
+
+    /* Set CP_NO_RAW system registers on init */
+    val.Reg64 = arm_cpu->midr;
+    whpx_set_reg(cpu, WHvArm64RegisterMidrEl1,
+                              val);
+
+    clean_whv_register_value(&val);
+
+    val.Reg64 = deposit64(arm_cpu->mp_affinity, 31, 1, 1 /* RES1 */);
+    whpx_set_reg(cpu, WHvArm64RegisterMpidrEl1, val);
+
+    return 0;
+
+error:
+    g_free(vcpu);
+
+    return ret;
+
+}
+
+void whpx_cpu_instance_init(CPUState *cs)
+{
+}
+
+int whpx_accel_init(AccelState *as, MachineState *ms)
+{
+    struct whpx_state *whpx;
+    int ret;
+    HRESULT hr;
+    WHV_CAPABILITY whpx_cap;
+    UINT32 whpx_cap_size;
+    WHV_PARTITION_PROPERTY prop;
+    WHV_CAPABILITY_FEATURES features = {0};
+
+    whpx = &whpx_global;
+    /* on arm64 Windows Hypervisor Platform, vGICv3 always used */
+    whpx->kernel_irqchip = true;
+
+    if (!init_whp_dispatch()) {
+        ret = -ENOSYS;
+        goto error;
+    }
+
+    whpx->mem_quota = ms->ram_size;
+
+    hr = whp_dispatch.WHvGetCapability(
+        WHvCapabilityCodeHypervisorPresent, &whpx_cap,
+        sizeof(whpx_cap), &whpx_cap_size);
+    if (FAILED(hr) || !whpx_cap.HypervisorPresent) {
+        error_report("WHPX: No accelerator found, hr=%08lx", hr);
+        ret = -ENOSPC;
+        goto error;
+    }
+
+    hr = whp_dispatch.WHvGetCapability(
+        WHvCapabilityCodeFeatures, &features, sizeof(features), NULL);
+    if (FAILED(hr)) {
+        error_report("WHPX: Failed to query capabilities, hr=%08lx", hr);
+        ret = -EINVAL;
+        goto error;
+    }
+
+    if (!features.Arm64Support) {
+        error_report("WHPX: host OS exposing pre-release WHPX implementation. "
+            "Please update your operating system to at least build 26100.3915");
+        ret = -EINVAL;
+        goto error;
+    }
+
+    hr = whp_dispatch.WHvCreatePartition(&whpx->partition);
+    if (FAILED(hr)) {
+        error_report("WHPX: Failed to create partition, hr=%08lx", hr);
+        ret = -EINVAL;
+        goto error;
+    }
+
+    memset(&prop, 0, sizeof(WHV_PARTITION_PROPERTY));
+    prop.ProcessorCount = ms->smp.cpus;
+    hr = whp_dispatch.WHvSetPartitionProperty(
+        whpx->partition,
+        WHvPartitionPropertyCodeProcessorCount,
+        &prop,
+        sizeof(WHV_PARTITION_PROPERTY));
+
+    if (FAILED(hr)) {
+        error_report("WHPX: Failed to set partition processor count to %u,"
+                     " hr=%08lx", prop.ProcessorCount, hr);
+        ret = -EINVAL;
+        goto error;
+    }
+
+    if (!whpx->kernel_irqchip_allowed) {
+        error_report("WHPX: on Arm, only kernel-irqchip=on is currently supported");
+        ret = -EINVAL;
+        goto error;
+    }
+
+    memset(&prop, 0, sizeof(WHV_PARTITION_PROPERTY));
+
+    hr = whp_dispatch.WHvSetupPartition(whpx->partition);
+    if (FAILED(hr)) {
+        error_report("WHPX: Failed to setup partition, hr=%08lx", hr);
+        ret = -EINVAL;
+        goto error;
+    }
+
+    whpx_memory_init();
+
+    return 0;
+
+error:
+
+    if (NULL != whpx->partition) {
+        whp_dispatch.WHvDeletePartition(whpx->partition);
+        whpx->partition = NULL;
+    }
+
+    return ret;
+}
-- 
2.50.1 (Apple Git-155)


