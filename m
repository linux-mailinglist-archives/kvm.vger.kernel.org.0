Return-Path: <kvm+bounces-58290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37FF7B8C9A9
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 16:02:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D576917C7B9
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 14:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B62E2F5A19;
	Sat, 20 Sep 2025 14:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="Rqy03qhd"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster3-host10-snip4-1.eps.apple.com [57.103.86.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858E41FBE83
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 14:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.86.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758376926; cv=none; b=b+sQKt1GCCRjUfix/etOw17pnELwFq5zckLmXlkIYuVPyYNBcrFgLGVQbqi4/raub1wa6WRj2GAnScC+K7XUtI+krL1KdMXiU8ryG7gqiW+3DIduvr563uLJ2jErxz+DSgjcLGUi3Nw3ja3lI8qsi8vvaW1IH9KNiBrMEPSlR6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758376926; c=relaxed/simple;
	bh=fGUqRFfTpncamoaZwur917HUi1iyUMc4Rq1RtRHJvsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlJwfSGJxZ21XToGg0NO4RF9L4Sb6kDHznRbtDMPJ7hJFfUhQ+KNP7lYvY25drqTlB3PD07vwE1QKtD2qZ/GOBRRSkZT1ap9excA5DGFFun4SoRkkT446lP6WQyKczRwI5uhyku6/lCVll/ST4Hnfp0AGEjxb4/cZAG60ijfX2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=Rqy03qhd; arc=none smtp.client-ip=57.103.86.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPS id 79B1118172B1;
	Sat, 20 Sep 2025 14:01:56 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=eeT/YbFgYShwKXnEHJa6J4507nsTPfKIv6b6mtMjEHg=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=Rqy03qhdIs1EFS/ZyY2jw9hca5NzQJQMwiRfEPs4SukbOgZu28khrT4nPdFFqF7+d9PgyBfSNi5lzATPw6CZlzvtLyrWKxsrmR4rNoj2VgxuU3gDj+7eA4OG4IYG6Koc+qYsH8TdmQ8P6aSRF3w4nuFvlMTsUhWdlJKICMUI/30pKSSWTbP52XOicD06CUwrwfKyy7EYN6oAvbr3AYoMYdklte5goHbV0e7T8+54/R+VPdwJDEy2rNyrKtcTqxzcQeDo8TGgXWPtWqLkkkoMJAv/apdu443F8VBeWA58oW3OCsdR5pIF7H0ZskeLkpPqEuMekGhj72thnQeS1jrPUw==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (qs-asmtp-me-k8s.p00.prod.me.com [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPSA id A2A421817266;
	Sat, 20 Sep 2025 14:01:30 +0000 (UTC)
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
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v6 01/23] target/arm/kvm: add constants for new PSCI versions
Date: Sat, 20 Sep 2025 16:01:02 +0200
Message-ID: <20250920140124.63046-2-mohamed@unpredictable.fr>
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
X-Proofpoint-ORIG-GUID: k17n26mTSa35KUYEk3o98Riozrr78qOD
X-Proofpoint-GUID: k17n26mTSa35KUYEk3o98Riozrr78qOD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDEzNiBTYWx0ZWRfX/M8qCra4MTV9
 tUoHmZoHGOZToQVCcajsy/PcwBgiOnOOfz3C/AsjVN911z3u2aNthe/vx/sBoYsNbiBY6iN4UYe
 dsknwkIV1kDTdj1cTYgWgMg1hKdiYbFL54e2hcCMxMX9EZsTwnLBhb4nccU8yvsxEgNkYnAI2NJ
 TCquC7MSzBbFNV3ebIl9CuvE02CNt/lOjDkUIAuHSQl23CvWdGy3eELTac8GIh9AFLcbi913bN9
 5wSBTnveXheV7uW0UWM0U3qtpn16wDm8KPso5BKMDqtj9ayAlHaZBdiqafbTpwzis11RHAFi4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-20_05,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=968 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 clxscore=1030 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2509200136
X-JNJ: AAAAAAABapcCK+84cQiSwPl35THzvb/5uGdOoidliYK+ZB43ySAvKcpCSLPFEXQRclcXzme+q93A8S/GyNkK63pAIoGGhnmgNDfZrhhsVo5GERBdfldyA4DMA8e0Zpu2R7bRMUjXbwk6PKDKyHmEnGsZDe6fpZt/7k+wlxLaD2SCBjCsJHjMUHKwLcyjUVXWFxzx/3UtKoHXtdwcUVkFwBVp1d34HozbCS6sUzUxell4kPFzXpW5Zcp/MuLUyntcY+GFqNKE7DYpIeNd9nYCw6S6an7/S4Vqsc5mvB/yK3hRzGVOEDCVf9AZ1brYdf1aYmkvPooOqGZEPktO8ua1yhDIlrqdB2e9kSGoKcRQR/+4Sz1gyazlcImALceFLJt7qAMWrB2pbN/V9k4kTDc/aadxWBs/qbcuiPBTWH/ObRy5DuNCzHveS7+DPN5feVrvUywP+XZQ2XNVSRXAkVGXaxzMYd2gzCS8P26W+Z/1wWQERyKJDzIJBd/kUWzamv1PMii5xTVh4iRQRRD1wC2fbPstv7b59BaXrkDXd9zGJgvCr8f7GJsIVJBNHSIKXRQL/9Zb+sRqqUB+Vl2laVGxTU2J+9sQYx7s4MKRBEK0pXRq7So4efV6/JZXPLqIJcFAYlZzr/wd/h/zeTV9fpclAd/QHDWSpKeyGKTFjfqkBmqyZIxDH2erfhufqiBIfJgyc4v8tEnqCjV5fXwPyyJy/RDbbjdXKh2Kzvzvqn9R/Vql9dETW8BJNopUzpqJzjmKRFz5knQWy8T+Rq+6R96nqk+DDhUfTV819hlZCa2N0+AMHr0iZfiwzalQDNkznU6jN6mqLPrBZqP+kzsCcD3H+G2K3vyTV9xAKMw5+AB8xPG6KJicgM7CTTuMlP4=

From: Sebastian Ott <sebott@redhat.com>

Add constants for PSCI version 1_2 and 1_3.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 target/arm/kvm-consts.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/arm/kvm-consts.h b/target/arm/kvm-consts.h
index c44d23dbe7..239a8801df 100644
--- a/target/arm/kvm-consts.h
+++ b/target/arm/kvm-consts.h
@@ -97,6 +97,8 @@ MISMATCH_CHECK(QEMU_PSCI_1_0_FN_PSCI_FEATURES, PSCI_1_0_FN_PSCI_FEATURES);
 #define QEMU_PSCI_VERSION_0_2                     0x00002
 #define QEMU_PSCI_VERSION_1_0                     0x10000
 #define QEMU_PSCI_VERSION_1_1                     0x10001
+#define QEMU_PSCI_VERSION_1_2                     0x10002
+#define QEMU_PSCI_VERSION_1_3                     0x10003
 
 MISMATCH_CHECK(QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED, PSCI_0_2_TOS_MP);
 /* We don't bother to check every possible version value */
-- 
2.50.1 (Apple Git-155)


