Return-Path: <kvm+bounces-60152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C7898BE4B50
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 18:57:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D1D1C341374
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 16:57:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EAF4345729;
	Thu, 16 Oct 2025 16:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="AajyLOgv"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster1-host8-snip4-5.eps.apple.com [57.103.76.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34AF32AAC6
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 16:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760633831; cv=none; b=Ifr4B5dW5m889Kb//xCr8tCqpTyN0EQWoDoJF1930TVXKlkm6wK59yLTEpwXQVS1gC+AONMRTGS/5r8rZ2pIWsSrczVVD7Mahp88c2xexLeeFWoE8idzoCD9cSceTn2VyEXjRcoTTG2UFjYgTZxrOOpEB8vTesMDZrr5Y4yYN5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760633831; c=relaxed/simple;
	bh=21sx+TAfQ8xo2rH+86D9JV3hyn4bmXrS9c3DCVti0dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gY93AnyG3LZfGE7gQuKjoLuRzabbXtqgtZfm6WO9uDaj6qkkGJ4t6gHPO9lkbFHI/Bhxb88C3y54bDEWqeUuVfXD9QeWvznn+lZcdwrk1po3Aip/QDsKngzBu+w3Dr0GTbfMFjwkeBgkYf/Hd+iBU/+hgU8D9bPNkO9wxsm+FlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=AajyLOgv; arc=none smtp.client-ip=57.103.76.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPS id C19DC18011C6;
	Thu, 16 Oct 2025 16:57:01 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=/6NY7U3Atkanr4qfTcQ0H73EJM7+21eqXZpVtymAXL0=; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=AajyLOgvL9vXcLc4zHr44Tsie+0WlXrijFDniaGACSDFgiiJzEUbIwvy3YKRjm/14uxkEkevnmyk9TAkieBct5lqD9MQTqy1As1IaqCusQxvVOauGL9NwjPTW+aPODLswFJYIr0BJ/1kiWK5baAwgraIVFK0v9FNgFuUpcS17ydQuJZ0HjE9JePoasmmA1aBog+Z00ugimnVGkMJYavcbIwxcP8MO6qHih9IrTZO3n1K5s84aUDDASsxYdw+7G250HwDpYVVIMdpfHQ+zpfviJmyF0CTEEGxXRv7HUY8knLLnBbCGmvBEIrlw1mz18OZ0Vz0wbLBej+Hr3hQgK8G7w==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPSA id 700411802068;
	Thu, 16 Oct 2025 16:55:43 +0000 (UTC)
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
Subject: [PATCH v7 06/24] whpx: Move around files before introducing AArch64 support
Date: Thu, 16 Oct 2025 18:55:02 +0200
Message-ID: <20251016165520.62532-7-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251016165520.62532-1-mohamed@unpredictable.fr>
References: <20251016165520.62532-1-mohamed@unpredictable.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: eCo1qW8yWyKNraS0tWGp1550vZvQvHuR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyMyBTYWx0ZWRfXyOvqButbu5Mb
 sLDsawSOaSPwzLiQk402eww4I9dryx/sQiW3PmCxaaQJIbyTlMm4l3chg1A1tjw1hEqzW+64rcN
 icm0wx0rQv1zQUvrJ0OTsOGBLLIljaMfvVndXpiZ0C+pu+lHk4FKz6nzeJI9uyEn5ecamuaHOMV
 E3Qvsl+Z5kGi02DTJyJ8ISJ3BWkIphJI3FrNW3RpNHJvSLWpN0pBhoty5KJuIrWN0mZOwAS4caI
 VSjqQmaVbcmcmRdzJA1axh8Uii8Op3h5oeRK79F5nLsU3bvvfScOQ1oa18cuZSqBrTSnaO//w=
X-Proofpoint-ORIG-GUID: eCo1qW8yWyKNraS0tWGp1550vZvQvHuR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 clxscore=1030 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2510160123
X-JNJ: AAAAAAABNBqfheA+b+2oDVQBbPvmUHHH6t6ey/TBCRG/ZZ6eoZs2BIG0FPtIC+WGsTZRm3rRc6wGWY/Te0/olzIxOsVEm1evK4QU/n+vIGYXjD5rynxIbFlqDwSN77RbfWNmGqIHWYeK9NZN+4Zd9Xaied4LgY6LFehQX0Xpuy2Ld1cJZg4DKWBt7JcUOr8IKB6NgzcgVQWkMKFjhqxO+HQWFos0bYOLh+TwbFnv8JllI70cIu0koRbmUypR19iBePi+t2zj0STlbMwBrV+TPWTma06NO3OYCVFjWFm0326bU6+qhw2escxcSJ7e5YhXFuo5LqAB5gd2TpMaTViGEvpWodk4Z0KhC0ahC4wZF2RVuDBLvJWy/PlqUEP6gl4Wv6zuqashvdIC7clDqzjb44xPEf4yhYiWNTBFXYrFASbP5xmhl9rUEE7tRynlpdkwdJ3hMV46rpRxBDtntSpEEXiZuenTf3zEeke6G53Qe/OmDyayVRaXjj1e2Gvi3jehKCMCWS+XDhkZQl6+WWHUgIJiLFxuc15yG1FwvAUO5uC/PBjpbQBdr98klaWZmw3Yjz37ocn6qYvg/OpvtdNRUiApR3GpG/jKH4eOxhqIpDiNYnGhDFeNmBn9HTOT5LzBAbSTmWVCyXfduzJtb3MWFaZfY8EXT3J/QKQFVlAT+cFMdgRzGYT2ix+2f9+Vk7U8cA9eCFTIfiwQyYePvF2B6RtLEmNxYHZLYzpF8duqOmQAVD+Qs01Xj5lgY1TAS8+PjjZ04MsD5856VG6Xj+1hjsqymTpMm3xEXbJ5JNNXPvU+e0Fo9VVkhDTj1+nuOYXckcx5Xd6Iwt3foeGszRluxC5fjBdjbAs4UMc2xKZaLTTqeY732sJ50505aKoHsvjMgIAR1xQbeHk/H6BL7tiPtEqBHk2BOK1WnGnxYuyntzAW

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
index 0c766961f3..c25e22ffdb 100644
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
 
 MSHV
 M: Magnus Kulke <magnus.kulke@linux.microsoft.com>
diff --git a/accel/meson.build b/accel/meson.build
index 983dfd0bd5..289b7420ff 100644
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
index 256761834c..106a352980 100644
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


