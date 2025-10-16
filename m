Return-Path: <kvm+bounces-60209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CA21BBE4E20
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:39:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDEC01A61BB5
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B035221FA0;
	Thu, 16 Oct 2025 17:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="Cpuhjmku"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster1-host1-snip4-9.eps.apple.com [57.103.76.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E601EED8
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760636366; cv=none; b=lc4W1hQiFJAHuomX66EJGYuSxBcnXEM0mjNUvv6b+jyhfXHNYIQYtQVCAQWTr/f3JOqYF4dDm9ANpkqLgoWEDqLS5HcBeXhK5Xb3/PtOkanVsAz3Kpq9yXCYXQOP0r8KnuAof6y6/9v3wMQHjjl7MIpBZqTcae6UwGt0Re6EM6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760636366; c=relaxed/simple;
	bh=3gcneoOvoamUNVLlnstLrT8PNyiRXhVi6wFOzTfFeJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5UETMGug2lQxqJwtKHGGJkn1HZdtYaaeD3lFL3cpqQUug4GE//EXVx7tpPoYMf5NTyzmYJk64TnGfsfOxvycaXa+KelHlYLj6Jb7kt0yG4hfLvwR93UugFnMpxjntcJ9jC+d0Isx1uWZoF1siwiXYpC3rsbUUOdx4gvEYx21nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=Cpuhjmku; arc=none smtp.client-ip=57.103.76.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPS id 384401800123;
	Thu, 16 Oct 2025 17:38:59 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=AZVyyBW9yXgsaeulA1YXhH/G5izca99gWRDYt1AsjCw=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=Cpuhjmku4d2ceQ80ChsagXV14Mk6eP6F4WBUSUkxcyPjjE1jpK5nZAYgmf02TwkjWzCZqEIFrtDp/wWT3xi4gTmCTIwY+4nkHinHlw5kDJ3DIuvWWASf5YCBwYscrPi0khE6HX3yl+ENrDtLGtMbSQNRiWcS+Y8KnkhPVIYBuv/270lW3uJFG7VPzf36gDBoLVtZgTGLMODazkk4YXziUOcrGuYGDFTGL0c/PupfP63Y+1wHYI+X26Ib0f+nb+LGJfHkPUUW25IjJu5JXX8PXvgKnGm0vOSLB5F0VHIv++9y1G92vYYkkzeuMmt+IDkQygYbFbZNAi/k6Yt9uvtWeg==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPSA id DFE99180013D;
	Thu, 16 Oct 2025 17:38:52 +0000 (UTC)
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
Subject: [PATCH v8 14/24] target/arm: cpu: mark WHPX as supporting PSCI 1.3
Date: Thu, 16 Oct 2025 19:37:53 +0200
Message-ID: <20251016173803.65764-15-mohamed@unpredictable.fr>
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
X-Proofpoint-GUID: YNK3D3ZMU2McfWiKpE9jPwVige6xlmmj
X-Proofpoint-ORIG-GUID: YNK3D3ZMU2McfWiKpE9jPwVige6xlmmj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyOCBTYWx0ZWRfX5JMq3QodC8CX
 SSCGmIQt/Hxr5M27KkGtM3tF/7dDZ/Pvd1PsMPFaXGjaiGYp+PHebGthCDfGoiHNka6IEWAfrHN
 oUe+0YzoK2JM/Oawv+bSql2ZG1m6Q1aSJamFa89nGBLDrJtGA4OixkNgmoq9UShBYunQzEVgZyn
 nljTfgGtZwK6BPYwsWfnPWLAbX2M1gRQbY7/C/rJFgIRhd0ll9RrRr4kohaGVYoQ5PWXejKmpZ0
 Xm0Ten7TGMcLyTRFZYtwRR1FPlICde4xOsmTR+V61CsjGeETxx74Qupu/hD1PjI8O4NFhYJaM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 clxscore=1030 suspectscore=0
 mlxscore=0 mlxlogscore=906 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2510160128
X-JNJ: AAAAAAABhG60gSdudW0A3koar0/yqyNUrwvEHNsUBZQR9qmiWlX5Sq+mFmWAJzl0oWQZFafEzwFjZ5clFoeTAjOsiRPp/mZdtSv7Ieqyx57u+Z4I2vaFXdCAK0REKGriY9YheXP+Qg7by5+TxNk2zhLZ2H/t7QMt4BuRcaiuI3pjRYlvIsDYsV5/E1D/KUHvkTyZi5H+uYp04id68uODP6pRoBrFVp+3XysUFyhlMlSeQAifWDPWBky//p/Xmez446o3L6uYq3YKGKGpmWX2NL4lfkAx5uZX0oUJYhs0aOlXE4z9959TD4evGoMBm7m+Bxp+yqzDzO6TIj70aORx9y8Sgm+38Dbh8Zz6RMikt1RSfeXsFDA/xNhNTyMTZJhFnkwVt+bu9WIw5kOoDX1pUU+Ky4UMJ7CbsEgT9/RqUV3MqFeTTzsHOwF3HP6IXrti4VFsGs6zoRmEZFVjOgSjR3hnMBZNMyfAKxGRdY2oGdfWJzbpxfDF+Dj8tMFcdwnkw8P3wA9WNT4JI3YtzDZNkPm1Q9FHeZf+7eZSr+ilzOa5wVVCRk1K2ihd2PjaYFEzb6b+l8wQLnfoubzipzFGYThb4WCm7fHgIHCn4T3OW2ACG8VnqwABXIEgosxUVAaFPIDR3FM3oBUFtvMSJbjQ2GqJJFNxbCCaNuT84ObhUDESCbnG4/aok2KvLbjPIFj/u5Y6Y2Eu5MdhEXTDgv/V1qzYZdX7i4HnoiV6bQFIckj8h+PfxZDAXdJeiE9KbkV6oKyN3TzEplyZp4CxqOdiY09vhCfiHKfxjTowO5TfkGixhPCXHdryNRr/gKO7oJzB16X/tZsMkcNSicDMGU2kLmzcEsoL/xQYTgV7wue9Kw8VyuPe13ZTxg0uX9sr7ouetuMIjv1n01Cp+5AOlOgw9OkkdxK/nhL6CEITR2eG9NcMdc69Q78NIVtHLMO3f2k=

Hyper-V supports PSCI 1.3, and that implementation is exposed through
WHPX.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 3b556f1404..bf25b3580e 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -23,6 +23,7 @@
 #include "qemu/timer.h"
 #include "qemu/log.h"
 #include "exec/page-vary.h"
+#include "system/whpx.h"
 #include "target/arm/idau.h"
 #include "qemu/module.h"
 #include "qapi/error.h"
@@ -1140,6 +1141,8 @@ static void arm_cpu_initfn(Object *obj)
     if (tcg_enabled() || hvf_enabled()) {
         /* TCG and HVF implement PSCI 1.1 */
         cpu->psci_version = QEMU_PSCI_VERSION_1_1;
+    } else if (whpx_enabled()) {
+        cpu->psci_version = QEMU_PSCI_VERSION_1_3;
     }
 }
 
-- 
2.50.1 (Apple Git-155)


