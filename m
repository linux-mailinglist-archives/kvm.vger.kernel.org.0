Return-Path: <kvm+bounces-60147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 955C0BE4B3E
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 18:57:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6577219C363A
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 16:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B179E341650;
	Thu, 16 Oct 2025 16:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="Z4TrpHlZ"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster3-host5-snip4-10.eps.apple.com [57.103.77.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43FD2E54DA
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 16:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.77.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760633820; cv=none; b=Ih2UVpBlYr6YAqLUWb0LamJTpe+9yvooAPCqk8bi9kBMPDWGTih74bqNGVsgTN0KjtVPibEd4fo6oEkIReXJPxJ0VDIPg8K/hQh+b7GfufIj9aJoinCGQoi0mJflK1ElHUXO+9RG0cqmrFTU/WLv7M8i/FUf+fgpdN5RDqz1o54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760633820; c=relaxed/simple;
	bh=zYLQVDbjH6U/5wVrDJdcy4U1ETlPIZJW7JCyPKEFi7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k3qHm0r/vzX1xN/IfS2/a3VZGH1jzBsCvEJNAlmCRwf9ThRP4ilyt1nKpFvTdGC8kmMVmJp8veHsE3ndvDYtp7RgLf2pSH8CUtae4JGTzETPKGbIJC4e0sMVLCBcyYr2f8XIHey8jCGcFovaWMI3jfGzw2I5lociQmv9n+Pkg8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=Z4TrpHlZ; arc=none smtp.client-ip=57.103.77.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPS id CF92318015CB;
	Thu, 16 Oct 2025 16:56:53 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=aRq3YU5535mG5uSPAFBSlmsbBJkL1R5+IAqIsTf/zZw=; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=Z4TrpHlZmLiaLR6Sg1KrtcVpRUdNZUOOVtXdn76Gguh7R0omitbqSciTYNm9CSSTxCLroGH5Oq3BhJkRv78WG/dYtVViwBn9Y/GOzhsNa6Qyr5IeGZ0M7sJYpzy1EObnXCMQ9DpThz/cYBnay7OS/17h1yaweIfgFi8TJL701+T+5saL7iGKWS+dM844t4cKj9gVAzRnLMHTNRNX87ytVF8Jdo9/4rINXtjuxUY13zlMXhJv/pooqU0fjvL6Q7/xPNMb1wIUpiHboUrZ4H0fVnjVNeNvfJ8d+NNY/ds4mZnHRIoJeGzL4aAwjXx4RaKL/sWo30mijvIPSswvS6I0vQ==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPSA id 2184A18015DD;
	Thu, 16 Oct 2025 16:55:30 +0000 (UTC)
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
Subject: [PATCH v7 02/24] accel/system: Introduce hwaccel_enabled() helper
Date: Thu, 16 Oct 2025 18:54:58 +0200
Message-ID: <20251016165520.62532-3-mohamed@unpredictable.fr>
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
X-Proofpoint-GUID: vD5EzDsWCJz4Z4lDlJyrb8NHhGphDKRR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyMiBTYWx0ZWRfX4c29NuAP62vx
 lTfiBTU/UN9satvFymRaGrJr+ozALLeyWBy+kK6mX6ktyoo8AIsD/AAHG8DLFEoZw7faBXmPOGs
 K5oZfSRefZs/vTcpT5bP9qajfO/pWalQADviaqFCYcREcFv/JUfysmARbjJanmXXgRtWXDgvM2Z
 oTwS4z44x7T1+w/giJD4Mlnz+mqE0iN017gd51os/sWXnFLDttORgJV85TUYk6S824qjHHmMmjs
 BHFAQNN6nsBfBlnqspd74B1bXf5Gt9VCvBSEO4oCjg4L+PonFupkhzWkiQH3UZiwj3in0gE7Y=
X-Proofpoint-ORIG-GUID: vD5EzDsWCJz4Z4lDlJyrb8NHhGphDKRR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 bulkscore=0 clxscore=1030 mlxlogscore=999 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2510160122
X-JNJ: AAAAAAABsmOASnny4X2CRFISDUbWAtSRsuUB/eYQp2Tlz+REZhLD17j/M+mLXozH6hRgFS7TfkM5HBZvre8qOLBNaiHviMRILOC/thqjPRB751ZbBaWVN3DKsrEdOd8m2nJdl/3jMLmKg08975dRcRT/psDQSdiUrr8CdNvcSFvc1ff99ag4eMME+Sc5/Pe6GSKxFACpOxnXw3Wd8j4x1+4lgYS5aW2RztNm7oZeoXCpG/MppSc5+t3B5Ww6oxAf+CUQXGNi9+kIIHnVwmtv87c6R+1OpAk1y1g8aJO+CSHKyC3/k7J5zxOdn6I4TAsxPA+yXdjzPDUdKIKT1UJe55YU1VAl2odOGvoUrw1NP0KgHRduBZA+FlXt1LRKtssKXfiwsAk5pdml46GfoEx0+AuzFJdCYIYnJnLLQEvqyeyt2XQbh/SbH6yG31tm1n1VSIeyaM+PSDy/812uQ6uFrr3o50F6hfphuv9SXVGQ+8WNQM3Koe4VskBZI5RoPTTLy/0pSfuNbYEJ9ORBnWB238baSQLBwzjIeOZ3hs5vV0thMvTu44JHmFNYGvCLXl3PRDbqBwv1p1SIXvFtKg3hl2QfAkoNf7+EHjVFNZMsMw4DcEtryy+X0Dg1oaNBTvobxlFX/UgM7ZTYZjqWlCjmrI2fVlMKXZU7q/xvixkxXpqtftJyDkS8RUe09HRGUiIC1rmXFIDcQix/i5HP9koFZIM8owDzS7ybt8cNg0P9mZgX3M9LlObJpWuy5EpMC3olZ0FCHuLTtuyLKIrMlN4pDY3qmxtT4hAC9r+/CB25d+dgpWlTXqb1o/+8yS9HubErahJlZkqAZGtU3Os7EVya1eXFefIweSIGeGycCZnE51Jj5z/gAt9Uh8SZGPbs+Lc9srHCngyTLzNsRuBJbwrHZ6akjHrmyMITUg==

From: Philippe Mathieu-Daudé <philmd@linaro.org>

hwaccel_enabled() return whether any hardware accelerator
is enabled.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/hw_accel.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/system/hw_accel.h b/include/system/hw_accel.h
index 55497edc29..628a50e066 100644
--- a/include/system/hw_accel.h
+++ b/include/system/hw_accel.h
@@ -40,4 +40,17 @@ void cpu_synchronize_pre_loadvm(CPUState *cpu);
 void cpu_synchronize_post_reset(CPUState *cpu);
 void cpu_synchronize_post_init(CPUState *cpu);
 
+/**
+ * hwaccel_enabled:
+ *
+ * Returns: %true if a hardware accelerator is enabled, %false otherwise.
+ */
+static inline bool hwaccel_enabled(void)
+{
+    return hvf_enabled()
+        || kvm_enabled()
+        || nvmm_enabled()
+        || whpx_enabled();
+}
+
 #endif /* QEMU_HW_ACCEL_H */
-- 
2.50.1 (Apple Git-155)


