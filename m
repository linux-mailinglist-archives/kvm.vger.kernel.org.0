Return-Path: <kvm+bounces-58292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08F8FB8C9AF
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 16:02:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38A02567591
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 14:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C6062FB97B;
	Sat, 20 Sep 2025 14:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="A3xndNqO"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster3-host12-snip4-5.eps.apple.com [57.103.86.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5A82AD22
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 14:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.86.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758376927; cv=none; b=YzQp5MEOw9E1Tx+TiX3NI/Ft5t6UoFUAvVaTMrYTWrUqM9buDJ5Mre9SAlhRwErTPD6MndEzqh8NTnuoub7n69MujhYW0KsRSSZz8/jPsheow2dnL83ZssZ3OCgUQ6xiQcKZjBI4Rbo0U9O/8k9apG74BQqqZcCm4Cezje1R/Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758376927; c=relaxed/simple;
	bh=eu04EjURMZXtl0FR3z3isWz4s2mmNrOviE9TcTbbY1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsT0+WJRZJQmib3m1NibnjHx8ll9FMsZD52I6Nr1s7BogryDgNTtVxI7+KujjuRCNuwN64zu1h0CmU242BC2arP9SwxYI0D1V2Wz9zbCreNnlM2hYF/lqaMvQpszadIHTOqAf88JSV8eXPntBSK/aEsB4bjpkYTqYH5GPabppq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=A3xndNqO; arc=none smtp.client-ip=57.103.86.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPS id 5FCC018172C6;
	Sat, 20 Sep 2025 14:02:03 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=Dd6SbfhuNBk34fWK2+hdiPZ7ix95XwKfJ2aHHWwGTnY=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=A3xndNqOGRGj7PcCrihMdXpro7ZQDNVoQ1e/NgEeG2aJyMqJR4mBasjn06T4ueWdgIp4FWfI8qLXdtKv/XcHHBJ1yGmkD41e1AcNqCcDq8r68pBobbFZFSwDi8dtr9VsoVeMpWTFNcSQlIPZyOCrbUQS4NHjNVJyz4DCnrS91wYNB6g20zQzSTJY56m95k1eZcztHsKIoxSh7ifAIiL3Tqt623rHVAo7vGyJh6FP/peQwkLIv98URdUOOHSJH+IRYO5Z7+y8TZxT/3uCwZhhfDyAW8H473JAGg1sqBIZExjzRDv1mBIwoTfD7OmOkwJoc8xz7ACM6oWIlbTWxwkNwQ==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (qs-asmtp-me-k8s.p00.prod.me.com [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPSA id 7C3BC181726E;
	Sat, 20 Sep 2025 14:01:36 +0000 (UTC)
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
Subject: [PATCH v6 03/23] hw/arm: virt: add GICv2m for the case when ITS is not available
Date: Sat, 20 Sep 2025 16:01:04 +0200
Message-ID: <20250920140124.63046-4-mohamed@unpredictable.fr>
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
X-Proofpoint-GUID: OgemViRJvTP77DdQ0xAf8VBpVPayVeei
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDEzNiBTYWx0ZWRfX0GP9fe2PrVt0
 BQyM2h18h6Dj9p+XIZngel3MDXUKYdJIt4TgUct8uQjg/uu9Jh5MchQ/Pe5OHCJyO6GgIlLsVud
 A1pmuSO3XsKQ2g+Bmgz027H5i3K/wwlboQbuZr0sPlBI9ebaKgP3+gYlckbGmc/TRvw63KODK3B
 7tN8MyammaIwTjkXDWX/97ssFL/N6xbx7ffMS2XRMX1olChoYGp2U7ZUM1Xq3MgkiJPhg/rduiA
 wPUPgV5Bp6G5TltTKAH4iakKSCeaqWLq8+87MWXK0gvGYuEmzeYojafgPyIc1ksd8PbhL91z4=
X-Proofpoint-ORIG-GUID: OgemViRJvTP77DdQ0xAf8VBpVPayVeei
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-20_05,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 clxscore=1030 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2509200136
X-JNJ: AAAAAAABNcovwDyH2h9g8qcMdwkLTUTCoxdis40lsmYQKWlwFxFTwM6lzs7EHYWao2rPnrqjWwi+D/saB0FwWJMqG8XzJ9x9UQ87t5jokRYNQbQa/lrl0PpXJAqv2m/daGmot7evBwMyw7Dri+VDoT3iS84W85pibQc3QX4MgsCJq006HzxTf92gZR5V5hgM6yruZEl15EJjk1vBmjLKBK/eal6SiqUp5qIB/17kiIwHYTNAPSBJkvfUnwHAc4sDSQHdnPA3joDS1F74CLa1pnzH9y1MYmOokHLR7IwDwVz5mdAWrxVtOL0SHHBVo8Fh6g8UELFtFWOiRbz/yY9L6tjkYI7rlaEkmeNbTnINVnDHzELN/vgLC6AMB/sSOruwjU4/D9+UffAPkHv0p8lPsc+7kDELLt3d7RzL+wH1zurL1ZWi19RpiOEVDRR3uRiMCPbGPn4AqCgBPBkfSerXxJ9Yhe+R7bVsCr/EUlYR0qqpEZnyEvDzk/OeI6/5edxTaIqpwPwSyrk3EJJc6kV+3MZRyY54puaI5+uMMzAh7LBF0m6skZDTqPEyz4CNJCZgSdC5ZcZXzYQlV2lNFlD69bZfimkOJSU0I+s0vX/GobWZdNZNGIsnx5wS0Qe179vWNOjKs9SW53nKwonWFhYFIlIKRIuEe7Qm5BY56xS5PzE9xP0JGDKgaA1QrtDAKwoRbBiYfyYsGlke7SOa7a/UVbeQjB0EP2/nq/lJ1RA4yTbOLw6zh2MIXWQuHr0IGhJOYYlnOvtxCtd3GEHZdeREACIhvwXtC4l5+Sn+ESyaBF025P4GlNCYs7uArSFuk/UupmJCFTzafstyazek+guq2xDFKC1XpbAuErogJGsz2ujq4zZ+7aPXlJS7pnuZfc23msO70YuXAv7N59Xx/F+VuL4=

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
index 96830f7c4e..7a049b8328 100644
--- a/hw/arm/virt-acpi-build.c
+++ b/hw/arm/virt-acpi-build.c
@@ -959,7 +959,9 @@ build_madt(GArray *table_data, BIOSLinker *linker, VirtMachineState *vms)
             build_append_int_noprefix(table_data, memmap[VIRT_GIC_ITS].base, 8);
             build_append_int_noprefix(table_data, 0, 4);    /* Reserved */
         }
-    } else {
+    }
+
+    if (!vms->its && !vms->no_gicv3_with_gicv2m) {
         const uint16_t spi_base = vms->irqmap[VIRT_GIC_V2M] + ARM_SPI_BASE;
 
         /* 5.2.12.16 GIC MSI Frame Structure */
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 02209fadcf..01274ec804 100644
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
@@ -2433,6 +2435,8 @@ static void machvirt_init(MachineState *machine)
     vms->ns_el2_virt_timer_irq = ns_el2_virt_timer_present() &&
         !vmc->no_ns_el2_virt_timer_irq;
 
+    vms->no_gicv3_with_gicv2m = vmc->no_gicv3_with_gicv2m;
+
     fdt_add_timer_nodes(vms);
     fdt_add_cpu_nodes(vms);
 
@@ -3467,6 +3471,7 @@ static void virt_instance_init(Object *obj)
     vms->its = true;
     /* Allow ITS emulation if the machine version supports it */
     vms->tcg_its = !vmc->no_tcg_its;
+    vms->no_gicv3_with_gicv2m = false;
 
     /* Default disallows iommu instantiation */
     vms->iommu = VIRT_IOMMU_NONE;
@@ -3519,8 +3524,11 @@ DEFINE_VIRT_MACHINE_AS_LATEST(10, 2)
 
 static void virt_machine_10_1_options(MachineClass *mc)
 {
+    VirtMachineClass *vmc = VIRT_MACHINE_CLASS(OBJECT_CLASS(mc));
+
     virt_machine_10_2_options(mc);
     compat_props_add(mc->compat_props, hw_compat_10_1, hw_compat_10_1_len);
+    vmc->no_gicv3_with_gicv2m = true;
 }
 DEFINE_VIRT_MACHINE(10, 1)
 
diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
index ea2cff05b0..3c030f4b5d 100644
--- a/include/hw/arm/virt.h
+++ b/include/hw/arm/virt.h
@@ -131,6 +131,7 @@ struct VirtMachineClass {
     bool no_cpu_topology;
     bool no_tcg_lpa2;
     bool no_ns_el2_virt_timer_irq;
+    bool no_gicv3_with_gicv2m;
     bool no_nested_smmu;
 };
 
@@ -178,6 +179,7 @@ struct VirtMachineState {
     char *oem_id;
     char *oem_table_id;
     bool ns_el2_virt_timer_irq;
+    bool no_gicv3_with_gicv2m;
     CXLState cxl_devices_state;
     bool legacy_smmuv3_present;
 };
-- 
2.50.1 (Apple Git-155)


