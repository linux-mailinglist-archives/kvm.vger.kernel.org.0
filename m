Return-Path: <kvm+bounces-58304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FDF8B8C9D4
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 16:03:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 324287B5C87
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 14:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F902FD7B3;
	Sat, 20 Sep 2025 14:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="ZJcA+8Lg"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster6-host1-snip4-10.eps.apple.com [57.103.85.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0BD2FFF86
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 14:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.85.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758376972; cv=none; b=lT2untdMbbR/rjcnVNDoLBUnvCUhSj48mk2N+TOpawlRKpMg9FeAXIpKvUoGvBX/LUzbtvA2EYcpM8fdeKSzKlEbn2wqxBpUowGixrnibNwZZXSBsso1ck/c6s9mac7nmg1K2UAZPcwTmdJa88leIxlI4vbMb5f1EpES+8H7llg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758376972; c=relaxed/simple;
	bh=crQ/brqXQjr3u/QYy6K4OgD0017aiUtgqdQ6lhamjmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGOVOwHEwn0mp2cO5ejKGRY3DwYLT+F3q9fyEuSgoJJxOG+EeA/hJnOlamD35AHXQFXxxlQ7EY8+QV/oDby7y2C3cbbcGToDwjtrDz3oxXRf0aZpqGSKQmGBFArfq7VfOqtUZtmxld9MPeenMU111pSTmaDWFUfFot/HUWygIBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=ZJcA+8Lg; arc=none smtp.client-ip=57.103.85.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPS id 3D8E718172C9;
	Sat, 20 Sep 2025 14:02:47 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=VWdaIrTS3rA6MaAGjHiPziAM5NkAPbLH4LWPZrX8SGE=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=ZJcA+8Lg/eOCwIYwjh+Z922GMwgliU/hldnp42UUlS/HWPTlSCgD3+wS+6SDJhi1VUCmnxwyv0EWgMhwEqD8HPpAAvewYvZCBHoun8nfZdQOTVoSJ2GfIbwiFDWhmXjBI2bc7GIRWjrYwEPRM328Me8YfyqyeD9XvKpYn1ErfLsk/zkby12WnKtOzpmuaRrmcMWbOn/l/AISt4da9KXDRFTkL0jup2UBmG+sdpKe2ptBVz7f164IeV0DMzfUY4+ACneMGuWrg6nc4InUrAwT1k3dJXHIc3o6Yiwb8Loo2OJYPI69O125jPS24I9cMIC2c/9jaPRhY7zUBTXiFw6thQ==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (qs-asmtp-me-k8s.p00.prod.me.com [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPSA id 097FB1817243;
	Sat, 20 Sep 2025 14:02:11 +0000 (UTC)
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
Subject: [PATCH v6 15/23] whpx: arm64: clamp down IPA size
Date: Sat, 20 Sep 2025 16:01:16 +0200
Message-ID: <20250920140124.63046-16-mohamed@unpredictable.fr>
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
X-Proofpoint-ORIG-GUID: 7dfxDvRo-6p8p8XfwE-ie0WGKjsf6pMw
X-Proofpoint-GUID: 7dfxDvRo-6p8p8XfwE-ie0WGKjsf6pMw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDEzNiBTYWx0ZWRfX6HifwqN1ztEp
 Aci07880yyN7EezGirPBBBectugxRfglW/p6T4zGY2qoNKDeSBsuWmvh/EJUJAlWIb8ARjVBi1w
 HsgcC9cShiEUXDY3SI3gXyY9l/oJbhEDcwMpY9+ZsMORgdSDlRRMSM7a3LGVcPsKeUHE6dKnLk2
 IclVyh5M6R3M3D3q4cbvKwxpSvHcsY6riTeSNeWUiSj1nfFl2mR6NFk+RQKcJjU90ytCtpSduhc
 1UZ4cr9FxIA+Ik8o4aBMCHGq6E1qZrirnXlLcDE6hpOd/P3uxzGI1m9nNVThRQdUCrN88l450=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-20_05,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxlogscore=999 mlxscore=0 clxscore=1030 malwarescore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2509200136
X-JNJ: AAAAAAABIS7BRK7Aj+gqsuLnhMHnkMu2qzjhr9P7E9ZYsBZKLDV2wvP7GSh+9uUyFLJdHeN0qYRDoHYsah/RStmSx8rmusx8AtyL8XUhs8hz1L0tGuHU4IF3GWvv1HQTQKrnY6mhqYiJe8EodbQQDJM/iQ65/Pny236rRrYvyw3k1WNf8XEWytdQUt2rzlLOy8PcHSxdH6Jw5IiQWqRRcTRLTNyscWT4cKzJD6RxMIqJ8y7YvyYPli+92i0ntO523MPaOI72nhbnbS2U0DE6/bzrlmMKXpyScXbBpeu6mn4ps3yCumMjnOkT3t0E7ZVNG6gJ7OuXwERZJftTKWlWoCFg+3E3lEdYHrZ8L+st+alGIOcmWLTsufcK5NWYYio5TNheWKGtqygnQtmHzv3Xz9Xi8+iMSNCrdT+pr7kRBDDqZpEO4UkBxOT201scu6f/z2+iNBFgDVKrC4J4R06Gw1oaejNQ4yZ1W1/JvUox8cbYG1vp1IkdPBFlCltFgvqFr3HAEjrVpgf+oskwKJlEnjIeD0Rrgyc2NaQwpZRf8WtDAAjePrW8W2m7IVj959Duu01nNf3sYnLZrpHoHQ8M5in7MeSYjWJoagjco4lIjboetQvp01u+smm4LRlkVtnM+h8uhGSjA2gFCFTO5/bDecR/dPYii9bZKIJUFnssBCHQkd/xBzMkUTWoM8H8W/c3C5kJM169F8jSXagq85ruTWY8o3yPRf73vjSGz1t1y9BaR2ZM96uGpIr2KKQtfYpMEkv9WyIUjB3r8fCdikkscXXD3PYZwF0eWH1an0da+UTWlTIemEU+jGnR6S9m33PQXssoD4wugB0ZwXoADyi2H8vxEDA+MWYv2RR6gNfOEU22leCiPZlsfV41

Code taken from HVF and adapted for WHPX use. Note that WHPX doesn't
have a default vs maximum IPA distinction.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/arm/virt.c               | 32 ++++++++++++++++++++++++++
 include/hw/boards.h         |  1 +
 target/arm/whpx/meson.build |  2 ++
 target/arm/whpx/whpx-all.c  | 45 +++++++++++++++++++++++++++++++++++++
 target/arm/whpx/whpx-stub.c | 15 +++++++++++++
 target/arm/whpx_arm.h       | 16 +++++++++++++
 6 files changed, 111 insertions(+)
 create mode 100644 target/arm/whpx/whpx-stub.c
 create mode 100644 target/arm/whpx_arm.h

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index c8eca368c9..1583902305 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -70,6 +70,7 @@
 #include "hw/irq.h"
 #include "kvm_arm.h"
 #include "hvf_arm.h"
+#include "whpx_arm.h"
 #include "hw/firmware/smbios.h"
 #include "qapi/visitor.h"
 #include "qapi/qapi-visit-common.h"
@@ -3236,6 +3237,36 @@ static int virt_kvm_type(MachineState *ms, const char *type_str)
     return fixed_ipa ? 0 : requested_pa_size;
 }
 
+static int virt_whpx_get_physical_address_range(MachineState *ms)
+{
+    VirtMachineState *vms = VIRT_MACHINE(ms);
+
+    int max_ipa_size = whpx_arm_get_ipa_bit_size();
+
+    /* We freeze the memory map to compute the highest gpa */
+    virt_set_memmap(vms, max_ipa_size);
+
+    int requested_ipa_size = 64 - clz64(vms->highest_gpa);
+
+    /*
+     * If we're <= the default IPA size just use the default.
+     * If we're above the default but below the maximum, round up to
+     * the maximum. hvf_arm_get_max_ipa_bit_size() conveniently only
+     * returns values that are valid ARM PARange values.
+     */
+    if (requested_ipa_size <= max_ipa_size) {
+        requested_ipa_size = max_ipa_size;
+    } else {
+        error_report("-m and ,maxmem option values "
+                     "require an IPA range (%d bits) larger than "
+                     "the one supported by the host (%d bits)",
+                     requested_ipa_size, max_ipa_size);
+        return -1;
+    }
+
+    return requested_ipa_size;
+}
+
 static int virt_hvf_get_physical_address_range(MachineState *ms)
 {
     VirtMachineState *vms = VIRT_MACHINE(ms);
@@ -3328,6 +3359,7 @@ static void virt_machine_class_init(ObjectClass *oc, const void *data)
     mc->get_default_cpu_node_id = virt_get_default_cpu_node_id;
     mc->kvm_type = virt_kvm_type;
     mc->hvf_get_physical_address_range = virt_hvf_get_physical_address_range;
+    mc->whpx_get_physical_address_range = virt_whpx_get_physical_address_range;
     assert(!mc->get_hotplug_handler);
     mc->get_hotplug_handler = virt_machine_get_hotplug_handler;
     hc->pre_plug = virt_machine_device_pre_plug_cb;
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 665b620121..3d01fb8cc9 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -276,6 +276,7 @@ struct MachineClass {
     void (*wakeup)(MachineState *state);
     int (*kvm_type)(MachineState *machine, const char *arg);
     int (*hvf_get_physical_address_range)(MachineState *machine);
+    int (*whpx_get_physical_address_range)(MachineState *machine);
 
     BlockInterfaceType block_default_type;
     int units_per_default_bus;
diff --git a/target/arm/whpx/meson.build b/target/arm/whpx/meson.build
index 1de2ef0283..3df632c9d3 100644
--- a/target/arm/whpx/meson.build
+++ b/target/arm/whpx/meson.build
@@ -1,3 +1,5 @@
 arm_system_ss.add(when: 'CONFIG_WHPX', if_true: files(
   'whpx-all.c',
 ))
+
+arm_common_system_ss.add(when: 'CONFIG_WHPX', if_false: files('whpx-stub.c'))
diff --git a/target/arm/whpx/whpx-all.c b/target/arm/whpx/whpx-all.c
index 7ef900a5ca..62fd6c230a 100644
--- a/target/arm/whpx/whpx-all.c
+++ b/target/arm/whpx/whpx-all.c
@@ -35,6 +35,7 @@
 #include "system/whpx-accel-ops.h"
 #include "system/whpx-all.h"
 #include "system/whpx-common.h"
+#include "whpx_arm.h"
 #include "hw/arm/bsa.h"
 #include "arm-powerctl.h"
 
@@ -660,6 +661,40 @@ static void whpx_cpu_update_state(void *opaque, bool running, RunState state)
 {
 }
 
+uint32_t whpx_arm_get_ipa_bit_size(void)
+{
+    WHV_CAPABILITY whpx_cap;
+    UINT32 whpx_cap_size;
+    HRESULT hr;
+    hr = whp_dispatch.WHvGetCapability(
+        WHvCapabilityCodePhysicalAddressWidth, &whpx_cap,
+        sizeof(whpx_cap), &whpx_cap_size);
+    if (FAILED(hr)) {
+        error_report("WHPX: failed to get supported"
+             "physical address width, hr=%08lx", hr);
+    }
+
+    /*
+     * We clamp any IPA size we want to back the VM with to a valid PARange
+     * value so the guest doesn't try and map memory outside of the valid range.
+     * This logic just clamps the passed in IPA bit size to the first valid
+     * PARange value <= to it.
+     */
+    return round_down_to_parange_bit_size(whpx_cap.PhysicalAddressWidth);
+}
+
+static void clamp_id_aa64mmfr0_parange_to_ipa_size(ARMISARegisters *isar)
+{
+    uint32_t ipa_size = whpx_arm_get_ipa_bit_size();
+    uint64_t id_aa64mmfr0;
+
+    /* Clamp down the PARange to the IPA size the kernel supports. */
+    uint8_t index = round_down_to_parange_index(ipa_size);
+    id_aa64mmfr0 = GET_IDREG(isar, ID_AA64MMFR0);
+    id_aa64mmfr0 = (id_aa64mmfr0 & ~R_ID_AA64MMFR0_PARANGE_MASK) | index;
+    SET_IDREG(isar, ID_AA64MMFR0, id_aa64mmfr0);
+}
+
 int whpx_init_vcpu(CPUState *cpu)
 {
     HRESULT hr;
@@ -738,6 +773,7 @@ int whpx_init_vcpu(CPUState *cpu)
     val.Reg64 = deposit64(arm_cpu->mp_affinity, 31, 1, 1 /* RES1 */);
     whpx_set_reg(cpu, WHvArm64RegisterMpidrEl1, val);
 
+    clamp_id_aa64mmfr0_parange_to_ipa_size(&arm_cpu->isar);
     return 0;
 
 error:
@@ -760,6 +796,8 @@ int whpx_accel_init(AccelState *as, MachineState *ms)
     UINT32 whpx_cap_size;
     WHV_PARTITION_PROPERTY prop;
     WHV_CAPABILITY_FEATURES features = {0};
+    MachineClass *mc = MACHINE_GET_CLASS(ms);
+    int pa_range = 0;
 
     whpx = &whpx_global;
     /* on arm64 Windows Hypervisor Platform, vGICv3 always used */
@@ -770,6 +808,13 @@ int whpx_accel_init(AccelState *as, MachineState *ms)
         goto error;
     }
 
+    if (mc->whpx_get_physical_address_range) {
+        pa_range = mc->whpx_get_physical_address_range(ms);
+        if (pa_range < 0) {
+            return -EINVAL;
+        }
+    }
+
     whpx->mem_quota = ms->ram_size;
 
     hr = whp_dispatch.WHvGetCapability(
diff --git a/target/arm/whpx/whpx-stub.c b/target/arm/whpx/whpx-stub.c
new file mode 100644
index 0000000000..32e434a5f6
--- /dev/null
+++ b/target/arm/whpx/whpx-stub.c
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * WHPX stubs for ARM
+ *
+ *  Copyright (c) 2025 Mohamed Mediouni
+ *
+ */
+
+#include "qemu/osdep.h"
+#include "whpx_arm.h"
+
+uint32_t whpx_arm_get_ipa_bit_size(void)
+{
+    g_assert_not_reached();
+}
diff --git a/target/arm/whpx_arm.h b/target/arm/whpx_arm.h
new file mode 100644
index 0000000000..de7406b66f
--- /dev/null
+++ b/target/arm/whpx_arm.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * WHPX support -- ARM specifics
+ *
+ * Copyright (c) 2025 Mohamed Mediouni
+ *
+ */
+
+#ifndef QEMU_WHPX_ARM_H
+#define QEMU_WHPX_ARM_H
+
+#include "target/arm/cpu-qom.h"
+
+uint32_t whpx_arm_get_ipa_bit_size(void);
+
+#endif
-- 
2.50.1 (Apple Git-155)


