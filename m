Return-Path: <kvm+bounces-60166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B317BE4BA7
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:00:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 89E4D4F7409
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E78C393DCB;
	Thu, 16 Oct 2025 16:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="KGg3sgIO"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster1-host1-snip4-2.eps.apple.com [57.103.76.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC19536CE1F
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 16:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760633864; cv=none; b=d1PggTgsCwlFZVEnhrdfv6BZYF3Wd8h8m8BJnuskNfb9wFZdygbbbHM0Yf253Ckb1H9UddO3xf6f+B48t4cW6jdW3M03/IZjkpZVUzyc7wP7fDoTLCbj7pAI48DFrgCSYeulZLAlEWsPn40aMSlqHzG+2Z56Uz9mTDCc2GfxfRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760633864; c=relaxed/simple;
	bh=YQ+c/mH2usyvJIPANVSR7O+M1VexlFPUZKC68mKQaTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtjF0h3yPvKp+yUAxRKTETxbKGYhbrAs6p83lYADBc4M4XCguMSAY7paQji/ML7lqsLHGk3ZUiWO1JYzDENxSz945kVpT6A7iOxaUvv5Ftr2avY2j0GeZ2Mziucih63/8F87VrS3Tf2ijT3BG7LFmpoudnuQZJxtaAxJim7UIY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=KGg3sgIO; arc=none smtp.client-ip=57.103.76.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPS id 3066918015FE;
	Thu, 16 Oct 2025 16:57:39 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=nzWfz+yWdE38Km+dQsZKqvSOWpOIi0Tms+2rrM0SehM=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=KGg3sgIOKcnQqiLDH2kAbjPth2rJxYcfhocZDr/O2uJWt+38QFuRoJ2Z97btAPo29Q+zzxC7eBMkT+EAi1g4K1JZgb2Xlv2g7huRMRbE4VxYJf/t7LCaYyL+bMR+HQ4TA/4Xsox2Cc5iCt6+x4SwE/d4Ro5bPvUWq5O4OXhJVt4+mXQHtEMlO/bnd+3uaQqcLjVMfut/He67wfEs+V8pRQMSuyXWzFiw3krcABCk6ACFyb7cluLQ065wADNZtBGXMm5Xf4Gqj7HWdoWYK8PPMJP5O/mdcZUOElt94TwJR+pffVXFLMh6a05z/oZJxLRsbav8IIn6IlGW1EyGmcH0yA==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPSA id B98511800760;
	Thu, 16 Oct 2025 16:56:34 +0000 (UTC)
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
	Roman Bolshakov <rbolshakov@ddn.com>
Subject: [PATCH v7 21/24] whpx: arm64: gicv3: add migration blocker
Date: Thu, 16 Oct 2025 18:55:17 +0200
Message-ID: <20251016165520.62532-22-mohamed@unpredictable.fr>
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
X-Proofpoint-ORIG-GUID: t8Aq89xlJQFujfMgbbyJbEK71dJavbvS
X-Proofpoint-GUID: t8Aq89xlJQFujfMgbbyJbEK71dJavbvS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyMiBTYWx0ZWRfX9bS4A67yelyI
 RPZX5eVoHpWWSdYypK3vWXGTViKzcX2/4idbfxJDkfAdGArRs6vyiQpr36nEs4CG2JSrlRe7Q6D
 YumVBJGNknG2eCK4aO+TI86SV85hJnGakdBTkt1Eu+EeSirI2mj3QaM6f1S7Vh4WIg8S4eGCKGI
 NWsoOhS3iq8tdrO1BEzyv3dOdiSfgoGk4aUx3evNaAVaGFX+UfhoBjBtE7I6eIlIxz5OWZg/ejV
 4T1IljcI877fYcQDHlgN6iZgnAufUReVSO5ZVUdNgEQqu7RGe+fvKmSkOc618w3KoZ8SjLa60=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=970 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 clxscore=1030 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2510160122
X-JNJ: AAAAAAAB3vmBivw56P7Bq+mQdi6xqqxbZvPE6oYdlUtVh1HgBTGJ57lyY0GfbMa3g1KH7pCQ2RRoGbFUgraxGJxWjqRjDdkRourh9MFoo1iClsIFC3g6DAfGUrYhWW1RCp3X1bHeoqSqD0ORZYRTYXDqDoXk98EO13O4tOsSRlVH3zKwk3ISzBmwqT3IaFSDMaC+1f6kc4ja3lmqIKvZtDWk/RBu6M+QCshJswkctHBL3cBDl89scKxPkqoHSioxUy48MTwgW4KPjsSJ25hR/RyL4ipa7iREgyoyJ+cBWsopHllvMMZgdR4FWLB76U5fzZ83PzvHDOAzH+ttL0JxyRi3zfMWXCJTJSHSuumiNxHTr/kK7bOlQ3U4GikwDBSye5bGUAc0KrtPVNc/05sy6e0BSi9ocE61a65CivNSE5Th340ovOI9lcobB4lYNVHj6NE4XshUlQOKzT0x7apL6WoDB+e+cr+CtGKax/RkES1ORM01jrE4SSbvv73UwgvhBbdOwBAp9jv2ZF0O2Jraefj25y6kbCO1/nXSd8xIJLXd5eXXpIgfH4439cLk6GPy1OEoe8nfF42J3pjTDifzZQMivtkRy3j6wcaed8xDWMnykA8w3qC0H3MOMgowshEtYmR9gUae2kDEhk+BHhGUC392eph+rhTilAYmWeT1DDzlw8Ys71mcQpr2EQ12R4i1VE/7OHCTRnebf5//MtgFkpkUDozFwEW8eGOyGeQFGEH+mIbm0lDgOFHe06xXCeqoZJKDGixjd249y0X6GmVB/wqTzPeo3lEFRsscqsWfbEowzfP6HJr8oEh5O0rTBd0zHU/r0uufw62XbMCs/KTqhy3FJ/Uyic8rIbDWVPgY65hEcf45JLd4qIJR4F1mgK/qL/X4t4VmsJqNib+DDECcj+mJqKK7

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


