Return-Path: <kvm+bounces-58294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A3881B8C9B5
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 16:02:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E8065836F4
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 14:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7379E2F3C1C;
	Sat, 20 Sep 2025 14:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="dpE4vlOU"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster7-host6-snip4-5.eps.apple.com [57.103.84.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7992AD22
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 14:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.84.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758376939; cv=none; b=QoQ/6ZOj5tYVNHb0zTIM2M4WdV2xmya+zIjlc9e7cIswPzHZ1supM4hn0WGBtAtm8my8Ojg6XsCm0bUFbWLSpEoN9SiI2RO/s+iYaZ6JdOss4HVgkHRGTAdwMC8jqhTJL+umdc1awSfXkm3+0V8uxI6tkxao4ssxg56w27Z7bQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758376939; c=relaxed/simple;
	bh=1YOEuSzxoCE2Ab5EE+odcP0XisOP2aXQfkahm/ZGAmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s6CwhJmEtCl2GT98fSJNWbg9VKhc0Bp3JxTI0X2XoCyaDDkogv03oUK4B7LvTzXDlhrQXgf0gozRHaI64z0hyHIABKdi3iru5swnOo9Myzei5Gmta/+S1wCNDHZP5gwvBUUZhamym41O9qJORnjRzA/90+i/y0Q4U3OIpEhlV30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=dpE4vlOU; arc=none smtp.client-ip=57.103.84.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPS id C5A97181722D;
	Sat, 20 Sep 2025 14:02:12 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=CvmnW1OpLHKn7WmsjT9vn5VCOm6azYsPocjSGcwmaMo=; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=dpE4vlOUFhdGuSxksOL1x0yqeWSAg9PGkzBxU+af3hzdqzXMYwVlUn2R7ri7WMhiu1qnIwfiinmMfpxbuOEV+/nKNg39kOibYgniyUTslrhdl3IIRU2eVpdddxQHT9qAlOkCBd+fMxNLlDiv8otFRbWF+VNiGrc6tn0zxMCm99JImMPjlSfeha5LQq1pyEpGB38yGUBDVQneEvPmXQGzhCZqq2Hm1sBMWVhCrJsZDtVr4SZRFQ1kl1Du24UKIqmeJVCk+ExL+A3keqCGqZ5+s0ku+XxxAjN0VI6DyFB5qFLpcKDQsvg4cNccror8DGJWgeSnADUNaDMZMnyiLEg20A==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (qs-asmtp-me-k8s.p00.prod.me.com [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPSA id 68E60181709D;
	Sat, 20 Sep 2025 14:01:42 +0000 (UTC)
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
Subject: [PATCH v6 05/23] whpx: Move around files before introducing AArch64 support
Date: Sat, 20 Sep 2025 16:01:06 +0200
Message-ID: <20250920140124.63046-6-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250920140124.63046-1-mohamed@unpredictable.fr>
References: <20250920140124.63046-1-mohamed@unpredictable.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: d1FmGNQ6dpsRi23sgBusxOQMQpSHvJGJ
X-Proofpoint-GUID: d1FmGNQ6dpsRi23sgBusxOQMQpSHvJGJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDEzNiBTYWx0ZWRfXwhomEL5BPpzE
 9puH3Wskrsa1mBzd1/+myYRUVAHdijFFXDui7fFWpqWhj2/SbM+fIohbcaSYEZDLMYfkYyjyvA2
 b7qBPONxbQoMJnjrAAo8JVJHwZGNz1XEEUxCCjBmdCGJdDY53lurXMejio4ylLzX6EeU6ZH0z2h
 DONUIASK/LnQ8ieRFgNNs9BmXmdl/haQI+kJ4WKwP0zeGHmbtISIvF3fhcIzqjKU8KxvSWRSb0r
 KWE8bC+Z/aI254VaAa9T/vdsNhkQNufqJPbssbIwWemp9MHMziX0wsLW5HM0pZFseUJCikEig=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-20_05,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1030
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2506270000 definitions=main-2509200136
X-JNJ: AAAAAAABKYmXLvx2GBMU3wOcl+T/HnhMmB9fw7qcKu40UaYjM3iAyjr0qImnP7xFnteyfwhlgSTaVvsA4iDMjdKhOQ68MQm6yHnHdaI68winHxGdEGyuAklRCQjj+4/NWdHVD2LX/Ell8FU0UzwP/hV//l0ZpwdstdL0AJ1PbQUisllD5D01TgcwkzUJUGk6zYPm6P5fIZ0pV2L6fTI1fbnddoTND+XwUASciHQOfK1dgLNxTHKlYDH0tehS0NYeTXj+9fgyk55MrX5JCKlZC27Y6ZNBgFdy3Au/4EAMnEsKCzF8kAHXayytESKCKSS2rXA+qyYwZOYhbW8F+XHUTKagrmxKf/oFY4TPyey9SgfNCSHXs2ivHGVHI6gHTczV2+vXT6jMdafF+eWuPKFWAK1zaqorXYUb1jkKT2rptaZfoWkM+RCfXozXm9X/2lOzOPO9577kNVw3cSloNKCR7vF22KtxjWYSKS3Q7lcOi1CkmIrT+sVeyopODrqHWjOtGmiBCrNY1Xw+SaYgaoMXz1P26JS+tGX77+BihzWgUN+Kriy7lXLZ0PYEf8h3RRSamhPYXL2oSrQ9kUUy/KMmghBx4s0u89pvszU5Nxp4dTmDfYfrXQBZiKQoyiuft02wNofbnjcq0D5yvMKI6Z15Hb8K0NtLfvcpUiTkKn/Sp5jYNnVPu7MZbP6V4NHimbLg3NQdeq0Ec8/62fJwdtSYLwvu0hYY2rOUPdXI7uZL5xTGcT3K37wfpuco7JVGxYnQKnz0P5ziETvAA0ztcJBMgHwlHon/retQ6mCPud1UERybmCU9s4CvfblYsqwlz+sO6JxBxz20388x3ADPHxzbVnBPJayK5QyJ0M+phyGl9pPumdEVKDUPECioVKNp1QzqV5ikk5uxm68XlauVyzm55fIq6V5MHnU=

Switch to a design where we can share whpx code between x86 and AArch64 when it makes sense to do so.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 MAINTAINERS                                           | 2 ++
 accel/meson.build                                     | 1 +
 accel/whpx/meson.build                                | 6 ++++++
 {target/i386 => accel}/whpx/whpx-accel-ops.c          | 4 ++--
 {target/i386/whpx => include/system}/whpx-accel-ops.h | 4 ++--
 {target/i386/whpx => include/system}/whpx-internal.h  | 5 +++--
 target/i386/whpx/meson.build                          | 1 -
 target/i386/whpx/whpx-all.c                           | 4 ++--
 target/i386/whpx/whpx-apic.c                          | 2 +-
 9 files changed, 19 insertions(+), 10 deletions(-)
 create mode 100644 accel/whpx/meson.build
 rename {target/i386 => accel}/whpx/whpx-accel-ops.c (97%)
 rename {target/i386/whpx => include/system}/whpx-accel-ops.h (92%)
 rename {target/i386/whpx => include/system}/whpx-internal.h (98%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 70eb0241d3..486e4d61c7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -547,9 +547,11 @@ F: include/system/hvf_int.h
 WHPX CPUs
 M: Sunil Muthuswamy <sunilmut@microsoft.com>
 S: Supported
+F: accel/whpx/
 F: target/i386/whpx/
 F: accel/stubs/whpx-stub.c
 F: include/system/whpx.h
+F: include/system/whpx-accel-ops.h
 
 X86 Instruction Emulator
 M: Cameron Esfahani <dirty@apple.com>
diff --git a/accel/meson.build b/accel/meson.build
index 25b0f100b5..de927a3b37 100644
--- a/accel/meson.build
+++ b/accel/meson.build
@@ -6,6 +6,7 @@ user_ss.add(files('accel-user.c'))
 subdir('tcg')
 if have_system
   subdir('hvf')
+  subdir('whpx')
   subdir('qtest')
   subdir('kvm')
   subdir('xen')
diff --git a/accel/whpx/meson.build b/accel/whpx/meson.build
new file mode 100644
index 0000000000..7b3d6f1c1c
--- /dev/null
+++ b/accel/whpx/meson.build
@@ -0,0 +1,6 @@
+whpx_ss = ss.source_set()
+whpx_ss.add(files(
+  'whpx-accel-ops.c',
+))
+
+specific_ss.add_all(when: 'CONFIG_WHPX', if_true: whpx_ss)
diff --git a/target/i386/whpx/whpx-accel-ops.c b/accel/whpx/whpx-accel-ops.c
similarity index 97%
rename from target/i386/whpx/whpx-accel-ops.c
rename to accel/whpx/whpx-accel-ops.c
index f75886128d..c84a25c273 100644
--- a/target/i386/whpx/whpx-accel-ops.c
+++ b/accel/whpx/whpx-accel-ops.c
@@ -16,8 +16,8 @@
 #include "qemu/guest-random.h"
 
 #include "system/whpx.h"
-#include "whpx-internal.h"
-#include "whpx-accel-ops.h"
+#include "system/whpx-internal.h"
+#include "system/whpx-accel-ops.h"
 
 static void *whpx_cpu_thread_fn(void *arg)
 {
diff --git a/target/i386/whpx/whpx-accel-ops.h b/include/system/whpx-accel-ops.h
similarity index 92%
rename from target/i386/whpx/whpx-accel-ops.h
rename to include/system/whpx-accel-ops.h
index 54cfc25a14..ed9d4c49f4 100644
--- a/target/i386/whpx/whpx-accel-ops.h
+++ b/include/system/whpx-accel-ops.h
@@ -7,8 +7,8 @@
  * See the COPYING file in the top-level directory.
  */
 
-#ifndef TARGET_I386_WHPX_ACCEL_OPS_H
-#define TARGET_I386_WHPX_ACCEL_OPS_H
+#ifndef SYSTEM_WHPX_ACCEL_OPS_H
+#define SYSTEM_WHPX_ACCEL_OPS_H
 
 #include "system/cpus.h"
 
diff --git a/target/i386/whpx/whpx-internal.h b/include/system/whpx-internal.h
similarity index 98%
rename from target/i386/whpx/whpx-internal.h
rename to include/system/whpx-internal.h
index 6633e9c4ca..e61375d554 100644
--- a/target/i386/whpx/whpx-internal.h
+++ b/include/system/whpx-internal.h
@@ -1,5 +1,6 @@
-#ifndef TARGET_I386_WHPX_INTERNAL_H
-#define TARGET_I386_WHPX_INTERNAL_H
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef SYSTEM_WHPX_INTERNAL_H
+#define SYSTEM_WHPX_INTERNAL_H
 
 #include <windows.h>
 #include <winhvplatform.h>
diff --git a/target/i386/whpx/meson.build b/target/i386/whpx/meson.build
index 9c54aaad39..c3aaaff9fd 100644
--- a/target/i386/whpx/meson.build
+++ b/target/i386/whpx/meson.build
@@ -1,5 +1,4 @@
 i386_system_ss.add(when: 'CONFIG_WHPX', if_true: files(
   'whpx-all.c',
   'whpx-apic.c',
-  'whpx-accel-ops.c',
 ))
diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index 2a85168ed5..13542b8a50 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -31,8 +31,8 @@
 #include "accel/accel-cpu-target.h"
 #include <winerror.h>
 
-#include "whpx-internal.h"
-#include "whpx-accel-ops.h"
+#include "system/whpx-internal.h"
+#include "system/whpx-accel-ops.h"
 
 #include <winhvplatform.h>
 #include <winhvemulation.h>
diff --git a/target/i386/whpx/whpx-apic.c b/target/i386/whpx/whpx-apic.c
index e1ef6d4e6d..badb404b63 100644
--- a/target/i386/whpx/whpx-apic.c
+++ b/target/i386/whpx/whpx-apic.c
@@ -18,7 +18,7 @@
 #include "hw/pci/msi.h"
 #include "system/hw_accel.h"
 #include "system/whpx.h"
-#include "whpx-internal.h"
+#include "system/whpx-internal.h"
 
 struct whpx_lapic_state {
     struct {
-- 
2.50.1 (Apple Git-155)


