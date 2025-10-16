Return-Path: <kvm+bounces-60201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 47C66BE4E00
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:38:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A75A41A6191C
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFE13217648;
	Thu, 16 Oct 2025 17:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="V9mQM6Jw"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster2-host9-snip4-5.eps.apple.com [57.103.78.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE0A207A38
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.78.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760636317; cv=none; b=Wvq59y5OmC1czQYShSmUCF7wemKdz6fe2u0YPllZHWCIxezaIv7vlQXfFUyB+VEPK8hUf55f6LipKG08U3WlzzrG/KGToVfHXXAJqlq5UqvENxh4XCFGNYXNLgb0wdqgSRD5g1aYAPGC1Fg8HWedBEqIsNWu7wP9V52YtTODcAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760636317; c=relaxed/simple;
	bh=cXwk9itEqd3jfSfptY6DOE0t5Qk61NJ0u9pm0DFJ9mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1BeZf353sD+WwC9INK1iMp0oTsRT/20f2GdDOg4E4vjMMzHyPNUvUGqaFIxnbUGSaKu+f6lGtEaGc/rM8W+n1yFC/uQPwmwYTn28bb7gCrlUp8XY0Queb9PIrkpWEqPbKvf6JgGVc5AfrnPwWxauF1/KwX492lIzPvFKq23fFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=V9mQM6Jw; arc=none smtp.client-ip=57.103.78.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPS id D9FE9180012A;
	Thu, 16 Oct 2025 17:38:22 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=JHEgQXI56zcvBQsz6pNUn1flvTbXYsGowZgT2ZZujDg=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=V9mQM6JwJVaUwhz9JtlYax+JRvz3+ayVAUDqFkAPnRFlp2C8F31/fLYGt9Vm0fI/TfffSmZ0sS3+ar+Qdhs+S5shqwkSuWfWX21kEIGv8CYwPVdNMXuB/TXIuNAUmGrywptwwZysI60/PpBEbAj1N86fX2ZMKLcAQvusi2ZER+Xf7wH5UrRg752PqokpfWC9gzCIKvigoI1hF0PqaCveXCvLQUY4HlRRg7yn4P7LUwlZlWZx+p7T8LO/s4b9YWk9tT9IlUSEi+eKidV8GxKJmp/Jv+a1YAGBVgX1IY+JR53LmApUjPvUAbPqql3WUNX/StmKOZAhb/fhUsyClqi1TA==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPSA id 1E2CA1800123;
	Thu, 16 Oct 2025 17:38:19 +0000 (UTC)
From: Mohamed Mediouni <mohamed@unpredictable.fr>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Igor Mammedov <imammedo@redhat.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Ani Sinha <anisinha@redhat.com>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Cameron Esfahani <dirty@apple.com>,
	Mads Ynddal <mads@ynddal.dk>,
	Zhao Liu <zhao1.liu@intel.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Pedro Barbuda <pbarbuda@microsoft.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 04/24] hw/arm: virt: add GICv2m for the case when ITS is not available
Date: Thu, 16 Oct 2025 19:37:43 +0200
Message-ID: <20251016173803.65764-5-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251016173803.65764-1-mohamed@unpredictable.fr>
References: <20251016173803.65764-1-mohamed@unpredictable.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyOCBTYWx0ZWRfX+BH7A0xBWr0q
 b/LSx/AiZ0Y2J7Bg7rVDxIdc9nn5md/hReXNjZ8T3BUHXCd+w6gHniGNsq5TrUjdW8IJQ/vsj07
 xQ3kuqzO8cR90eJHNCCCQEK+EqsanKFIgDCAYrpUGnQvga/lA5BuUPIoKibeHO/7yHsSgX+7y+Z
 XXOYxTw6EUdXVar66xHIy/taI5ZYr/svD5JHHUXHeqdKDOId6fcwBGSsdb5H3JBMOyqSIFtp5Ko
 44XDdswY8GVksfOAyLUOoOo3f9us91EDJG4J+qghrn9G/IdZ97pulktwuUP7kx3mUlEIIgIvw=
X-Proofpoint-GUID: YViZzSivYqNXRJJk5bB5gwnzC_E7S2PL
X-Proofpoint-ORIG-GUID: YViZzSivYqNXRJJk5bB5gwnzC_E7S2PL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1030 spamscore=0
 malwarescore=0 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2510160128
X-JNJ: AAAAAAABkCWw6M/cYeJxyG2UvLWpSQfjv6SZlHZxhFOSCGacZNIRMnkXjJYZkS1gcMQoqN/850NsK07Hk1q4lsaDao+KOsfbubyhssISkI71/r7pjM7VGCzR2jCefke3h4R2kDQkHn8lgQbAkUaPshjCBtye7OMaktRojgDpVdARBifMWe8raTFmS3j4A5aFyYagm27qWytOPf0PQwRlyf2mx8jIdc5gxWxoZ1KZZSA0SvbCSUFE0Lvjksc0RgGmPbAs3W//9RFoxRUeG7ZSAWMGtosoa2sN87xgCE9n+guAqCpuPayQIKvEmtg6Tm7uxY1Jr/ua/AzWnOYUV8rKMKQMyoYWutcCqoow8ecZr2jBEC7P7b1aeKTmou6YNBlQxuhuEznvzhPp/einBlnS+faam9SHSg+4NvZABUYDXRaYdS7nHVb1oCDjAYwjgECUk6uGPxi1ewCjF009AjfAlK/uTHc0lfCGAALMjLMknZjlGYB+8Qw4OBwN7qRBkjlxr3cYXLypcaNjXE1WzRz6XVi3BCClyP8zdJsYsrhVM92mxUvEKffhRu8wgyBivtuNLLD9YIJ0OlF2JgRYsTRpiXggJBRWNvjo8BwKFNGqmuUQdOaxDomNthCUc1UXWNuHgjUNwKN/KG0M+E1YW8VeGFq1cjWxyhsKLoCPcsuQBZOaEEaOfP3HHzrY+TuYIA0Fp+D1/e9XTj+47tXyW+Pif/WrOGOjuZBbLPY4EqgmZnVD/Q0O375eR70MN0aSQbTeok0kV0FQtUMzQ0hGKpwwlNpgXPCf1rlJRhxwGYTcwaGjR6FuggFlGPz4v0NbxlJw4S9GpjFULcnV6rvsaPTi86ZQIaM9vpbWpWZfQV5mdC2HGrZjeq9UoPlm9LEk4lKd9QujU0l9Tqa+iI7Acy6GntXOGs3xoHy8UkOHDTXJCphG3A==

On Hypervisor.framework for macOS and WHPX for Windows, the provided environment is a GICv3 without ITS.

As such, support a GICv3 w/ GICv2m for that scenario.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/arm/virt-acpi-build.c | 4 +++-
 hw/arm/virt.c            | 8 ++++++++
 include/hw/arm/virt.h    | 2 ++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
index 8bb6b60515..0a6ec74aa0 100644
--- a/hw/arm/virt-acpi-build.c
+++ b/hw/arm/virt-acpi-build.c
@@ -959,7 +959,9 @@ build_madt(GArray *table_data, BIOSLinker *linker, VirtMachineState *vms)
             build_append_int_noprefix(table_data, memmap[VIRT_GIC_ITS].base, 8);
             build_append_int_noprefix(table_data, 0, 4);    /* Reserved */
         }
-    } else {
+    }
+
+    if (!(vms->gic_version != VIRT_GIC_VERSION_2 && vms->its) && !vms->no_gicv3_with_gicv2m) {
         const uint16_t spi_base = vms->irqmap[VIRT_GIC_V2M] + ARM_SPI_BASE;
 
         /* 5.2.12.16 GIC MSI Frame Structure */
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 175023897a..61d7bab803 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -956,6 +956,8 @@ static void create_gic(VirtMachineState *vms, MemoryRegion *mem)
 
     if (vms->gic_version != VIRT_GIC_VERSION_2 && vms->its) {
         create_its(vms);
+    } else if (vms->gic_version != VIRT_GIC_VERSION_2 && !vms->no_gicv3_with_gicv2m) {
+        create_v2m(vms);
     } else if (vms->gic_version == VIRT_GIC_VERSION_2) {
         create_v2m(vms);
     }
@@ -2447,6 +2449,8 @@ static void machvirt_init(MachineState *machine)
     vms->ns_el2_virt_timer_irq = ns_el2_virt_timer_present() &&
         !vmc->no_ns_el2_virt_timer_irq;
 
+    vms->no_gicv3_with_gicv2m = vmc->no_gicv3_with_gicv2m;
+
     fdt_add_timer_nodes(vms);
     fdt_add_cpu_nodes(vms);
 
@@ -3484,6 +3488,7 @@ static void virt_instance_init(Object *obj)
     vms->its = true;
     /* Allow ITS emulation if the machine version supports it */
     vms->tcg_its = !vmc->no_tcg_its;
+    vms->no_gicv3_with_gicv2m = false;
 
     /* Default disallows iommu instantiation */
     vms->iommu = VIRT_IOMMU_NONE;
@@ -3536,9 +3541,12 @@ DEFINE_VIRT_MACHINE_AS_LATEST(10, 2)
 
 static void virt_machine_10_1_options(MachineClass *mc)
 {
+    VirtMachineClass *vmc = VIRT_MACHINE_CLASS(OBJECT_CLASS(mc));
+
     virt_machine_10_2_options(mc);
     mc->smbios_memory_device_size = 2047 * TiB;
     compat_props_add(mc->compat_props, hw_compat_10_1, hw_compat_10_1_len);
+    vmc->no_gicv3_with_gicv2m = true;
 }
 DEFINE_VIRT_MACHINE(10, 1)
 
diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
index 04a09af354..d31348dd61 100644
--- a/include/hw/arm/virt.h
+++ b/include/hw/arm/virt.h
@@ -132,6 +132,7 @@ struct VirtMachineClass {
     bool no_cpu_topology;
     bool no_tcg_lpa2;
     bool no_ns_el2_virt_timer_irq;
+    bool no_gicv3_with_gicv2m;
     bool no_nested_smmu;
 };
 
@@ -180,6 +181,7 @@ struct VirtMachineState {
     char *oem_id;
     char *oem_table_id;
     bool ns_el2_virt_timer_irq;
+    bool no_gicv3_with_gicv2m;
     CXLState cxl_devices_state;
     bool legacy_smmuv3_present;
 };
-- 
2.50.1 (Apple Git-155)


