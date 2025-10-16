Return-Path: <kvm+bounces-60158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id EEEF1BE4B6E
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 18:58:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DE7CE4E11C0
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 16:58:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D22C2350D4A;
	Thu, 16 Oct 2025 16:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="LJxk1oU/"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster1-host12-snip4-3.eps.apple.com [57.103.76.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2F2341AA8
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 16:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760633844; cv=none; b=jgWq5yaRIcjQlil9Pj592OxmTSgixIpMCPfjVxLxBmVeLxfLpOLLvzm+UrmWBriyeZJ3yOLIpz+Z0Mea9Rt7oSXYagaUc0cX8R/C15Y+Nxt5I8Rvu5hVvtIx8nD62/nxG9HGGin2wkzIeISDnwYt1dn0HN/fDt4N5t560AiO5Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760633844; c=relaxed/simple;
	bh=3gcneoOvoamUNVLlnstLrT8PNyiRXhVi6wFOzTfFeJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twhOTsXfN1wRkndBT/XjYRdZfzYQ1sF4tzO8Fp8eVkdCuOJWPyd4uENN/A0pDDrnufVP6Oom+7MvW+t7ZXA5v8QFtoDhbWPo9n9OYgq56CUzH0MbQ6JPysTPuBL9n42mUl8rn02CshM4QpWr1y6GZk4KAdCktABFPU72U02pI6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=LJxk1oU/; arc=none smtp.client-ip=57.103.76.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPS id EF672180075F;
	Thu, 16 Oct 2025 16:57:17 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=AZVyyBW9yXgsaeulA1YXhH/G5izca99gWRDYt1AsjCw=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=LJxk1oU/PhdViyEgTOpI+H6Q6yhgQvte58YjngC0iV9JGb3b9f3KoBf4UtITIn8kJIkqoT7r3M2HKfq6qLHty8OvyG4eofaTnUY/4FXQx+vb8LsCZ4Rdm0c9Bq6WTtgDjTTng+hYzd3Wfah4NdlQX9Un5yKD0ja5loqkaUbGg0v7USVGg4CuR8PkiLiDCvjHhexhWOGqzDLmhSaZjZdNts2ftXs52q4ZnqBVMWnjh1KVWIBB/u+65qwXShfeWE5qDlmJJ08rF/VvoJPh43AwLiRnL5VqpprOdXXowQZyxxdiApIRLs1iVca81VpScTfneF1a2y1c/Z2kcSAtf18ymQ==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPSA id 02D7118000A3;
	Thu, 16 Oct 2025 16:56:10 +0000 (UTC)
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
Subject: [PATCH v7 14/24] target/arm: cpu: mark WHPX as supporting PSCI 1.3
Date: Thu, 16 Oct 2025 18:55:10 +0200
Message-ID: <20251016165520.62532-15-mohamed@unpredictable.fr>
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
X-Proofpoint-ORIG-GUID: JsCEOPQOJ2dsSIDOxlHrsbL5OsLuv_dQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyMiBTYWx0ZWRfX92gxmSv9O7po
 C31ioFjC667O407rDAP+I7esduqWKOQeqt4r/HF1vflt5nnHtAha1jNxXz8zux2fqzkt3Ns338Z
 Ij3oZV1di3pfaBXOqCLreV/sTAsK/ft4QW+HBg4Thzo5iDP7Gu5nZ3n+kaOe520JwiYhf42SA+9
 9Ipr5n48NSu5gESRATmkDFudtl6ToFJ0afQhHMrgNZ30j2931jzSg1LU7sfDjbetvrZxT7Jr46C
 wCzmig9EXFd7sA2y1ufVLu3IxbTpMPLydSBDADnWX+z4vFZzKHdmo4rlh9DeVsRW6Cour6n1g=
X-Proofpoint-GUID: JsCEOPQOJ2dsSIDOxlHrsbL5OsLuv_dQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1030
 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=906 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2510160122
X-JNJ: AAAAAAABiyYFN1ylLz9x2kQJNEPRbUP3xlqwEVogXRXR2ZOOevjA+VJdwIaZ9iGcCDVM5Vc2oHYBKP+ZFCLIEMpbmtDSPhtW5ml/A/715zWSn1yLhgvg2vWw67NhoDXOuWeHdSd8CzSyqearBtLfqxeX/VpHSQwQI8CvTT4/sSAtcZZCyUARmProdzfBj5iq51c8uVCz7ugM/nzlLNNPORH6CH/TBwI06KA+syC0D6D9phEsVNpH8uV9acqg+FOQYrNewslELwyprxF+370b4odbLc1To8piL9ppJS7fHBBccT7mxpj2+qNFyCRpoudFaMtOQ9jRfMgLRbzgeivuotc7kvVnerjgd/D8J7B8TLMx5RAmQAUqOvQZkCKXjSpMHZrm0PU3H91/jf5ek7uSgOZVAujRQ2lAieMh6TULbwZrG1KguYI2l0KcpVaKwJuNNwFSsPZHomXub2R8yu2Pe7ambQ+zkOf86f/c6vHGwnNMqZwPlYsZ7suy0NWJh2sF2Y+e19CyK0vXzgMojU7xN5Mwj38ZLbgOsFOGstZaozB9qyc7j2epK6ijJwL7qunQWjR6LIhhwfrgu95lFoR+/aJjolZSkr3QHHlxU4YLx8NxQhOAr/NwnO0Bft4dXic1MQ7H8CnduPme1FFXlGR7TRKfTbGK6LjFahqZCZsCko7Ib5XdcR+3wzXfKm4ikUJw3c8Az2v+dBa4CDY+TPpQB4VC5E1dZDDl5uQKPZ5IS5ndv2kqCGgMmKLk4z1eW4syWB9S52H9kJlxJbD48HDYux31b8QA+T7tprYxmeRnA6d8mxeHFWKETH01icXv6hNeE+yFfwl85K5BhBavLa/kpLw8SRAyAGyjpC9U4OjDqOqb04k9RmeuXIpoeseRDaxvMAlNp25psLqXjXcdnXTArcARzPR0ud6rsLB/EXMdkA3VYsXGHinUaZW9gRY/8Vc=

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


