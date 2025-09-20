Return-Path: <kvm+bounces-58308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 78902B8C9EB
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 16:03:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F67F1B27DF7
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 14:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E562F546E;
	Sat, 20 Sep 2025 14:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="VK9FdgUj"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster5-host2-snip4-4.eps.apple.com [57.103.86.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B731D23FC4C
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 14:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.86.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758376988; cv=none; b=WnU4PdMn2Gj2xEKy08C/pL4Ebb3sTymLoHFi14ajBMm6Mw0s38d6B9jgI7gWh/vWdBo+OtrtQ839TkLAe8e+vZZWqUG2Sbv0Ukeqa1YBXZGY7y1XxcvU2x69SCKZtYnuZ5aWdSL6c2xdZ58Q7tqzL2ToQdAV87Elz5sNKu7rnr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758376988; c=relaxed/simple;
	bh=YQ+c/mH2usyvJIPANVSR7O+M1VexlFPUZKC68mKQaTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTbHYm2dR5/8ByEVvbcFZE+ztHl1+opmn62cyJUQ63XqNJN2UYYW6HUEB4GUppqsWdqi91ieHRqo+YzZIXQXqNnU0g5a2eUnKdA471dVN7+ib8lHzcYcKZtF16+0qBbVnG47Ql7V8dpqYDFIMOwTeqPdTtqS+9KNUSXowBlpfGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=VK9FdgUj; arc=none smtp.client-ip=57.103.86.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPS id 23E5F181724E;
	Sat, 20 Sep 2025 14:03:02 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=nzWfz+yWdE38Km+dQsZKqvSOWpOIi0Tms+2rrM0SehM=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=VK9FdgUjFd3smwcY3QErpU6MvjivH3HabNJ6SaRk1Ya4SQmSwvwBhOt9vvT83YGjcVs1zLrfl73QUYNTXCyEjLJDw0VxMvPjCHcKEfVKNuvTbGVIRKpxfbxTgG5rKh0Sy5/e376NBWCgdU3Z1Nf4QslBVfhSTgtcFPMYbEkj/mu3TKP4zKbIxxKDvsilvvhadI9+lCd2y1KOp46emEOhv+nLe7m8oGQiw89cc3oneA6szLSsMPmyrhaFPEgUNi1q0L5OGRPYxRyNsV+FFq39mouh5MO2LnXiYPv2XE+Ujl8NnA7gWkw5Le19xjgMQGGnkvzo0hY4SDtbAHiXse+zjA==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (qs-asmtp-me-k8s.p00.prod.me.com [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPSA id CB74C1817262;
	Sat, 20 Sep 2025 14:02:23 +0000 (UTC)
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
Subject: [PATCH v6 19/23] whpx: arm64: gicv3: add migration blocker
Date: Sat, 20 Sep 2025 16:01:20 +0200
Message-ID: <20250920140124.63046-20-mohamed@unpredictable.fr>
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
X-Proofpoint-ORIG-GUID: ei8rLP-wJkFXibj2gQOtkn3cfl2_KHDC
X-Proofpoint-GUID: ei8rLP-wJkFXibj2gQOtkn3cfl2_KHDC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDEzNiBTYWx0ZWRfXxm55KNV+0r8u
 fGTPHiqgXfh9egDyWOWW0veXJGc2NdBfai1JG5WQo+kiu0Mbd37p/was85ahZW/+yyQ/C5MMG4k
 78luTBRmHS66y7M/tW7rHmow6664b8OPgpUspGSkKzu7IQm+zMSXB7SQaQLEsKWjB49N7bT1PPr
 LjZ0flABxxQUv/KMH6z/J555UzqQyZCmUSyj3an9qF8TAGrR/ScYwzfgoxqkOdmxdyxzVOaZrpv
 VKlueATVl2UaNhwg13ZWZzE9l03BP2e8H2k1bqwm5sq3eThaJ7/tuKSOZH9PnXQGkhaMQWH+A=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-20_05,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=948
 malwarescore=0 adultscore=0 clxscore=1030 suspectscore=0 bulkscore=0
 mlxscore=0 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2509200136
X-JNJ: AAAAAAAB2UXFWF2CpFrsCC8fx2zzk9xIBIFhyt2EYGYs8bVFB4IP9RVk4ffZFChdeXgdQAKMq0hxtuk8JYFsC6/oFL4QGhvsuT69WM8PVUY80SfZz9fXo7e8CX+v8D1rfuTSsP1qVCkEFedzLLDTtnGWoT//Kz5LAEEn6tNu6BizqufJK+U6sgLWcFqzwXGuB7ETGYvPn4D8Z7r+VZwgd9q28K3N8s66iD+QBeRCyzDtrWzLJwJGpJZS0N0NngkoDc3Udw9JDS9TRJotc6KXl9IauOHvi5Ao+XCOxW/xwE7ajPks1VnsuUPI5fnvRcCavMOZw0wbiH1XvQ4x2KkcLYCgc0Cqkrvnx4grpFZ3N3aUo0Euhah8gGZvzC5kmR0QJarc6Yj5uGwl2b5W3ekIYKkDNjXICtvbmkEUnSFdKGDYQAmMcGXsJb/oxL8BhwWqnaDRf/QOAtcpoX3LzN7rmaH2jSQc0N6QCoOY+2qdQ2fG0pUhlsmeYDOarUYAkL2VOAFP+z4wPZDDFfISdQ34yvGQNTWR3MtAqqHbkMFGYn1db3Ig8AmlljtDMwoX7keA+DyL7U+P6FzCyd4JNCaotvpvngcw+93Q+fs3VF8hi+eppmQuCDQFCgoBVD7B/dnHjs4G0FFqTDZp8eGUfCtyNkcJOjIHnvJ2YY1evHbLG7s1DLmxQfK/EBIALo+NtTyLzi3UI5fOyCy73rxWd+J0lgNK1yMKy08+iZDo/z+ErP34xeFXp/u8kCbZ6yoonxSvs/5C6y2I2W2SawfOAQEihiVXlfRcSd96N7m++gRV4fnvkR/CFchN8xQEyHV9ivYEP7nv421MSoqQ79wwUO7huwTML60R21ZBusWtr8xtL73SY37W9UQFsdIZiORcOCdQ0oLRZo5uua8=

GICv3 state save-restore is currently not implemented yet.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
---
 hw/intc/arm_gicv3_whpx.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/hw/intc/arm_gicv3_whpx.c b/hw/intc/arm_gicv3_whpx.c
index 88a05e5901..6ceae78483 100644
--- a/hw/intc/arm_gicv3_whpx.c
+++ b/hw/intc/arm_gicv3_whpx.c
@@ -17,6 +17,7 @@
 #include "system/whpx-internal.h"
 #include "gicv3_internal.h"
 #include "vgic_common.h"
+#include "migration/blocker.h"
 #include "qom/object.h"
 #include "target/arm/cpregs.h"
 
@@ -205,6 +206,15 @@ static void whpx_gicv3_realize(DeviceState *dev, Error **errp)
         error_setg(errp, "Nested virtualisation not currently supported by WHPX.");
         return;
     }
+
+    Error *whpx_migration_blocker = NULL;
+
+    error_setg(&whpx_migration_blocker,
+        "Live migration disabled because GIC state save/restore not supported on WHPX");
+    if (migrate_add_blocker(&whpx_migration_blocker, errp)) {
+        error_free(whpx_migration_blocker);
+        return;
+    }
 }
 
 static void whpx_gicv3_class_init(ObjectClass *klass, const void *data)
-- 
2.50.1 (Apple Git-155)


