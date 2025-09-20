Return-Path: <kvm+bounces-58310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 65072B8C9F4
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 16:04:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A558584357
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 14:04:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF14B301716;
	Sat, 20 Sep 2025 14:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="MPprHi67"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster2-host9-snip4-4.eps.apple.com [57.103.87.215])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4472F5A19
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 14:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.87.215
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758376997; cv=none; b=NWR0eKGlE2YVJSeoAru+Jmlmw7vxYMT4Rd++8xout4KDVdUZSQuix4GrCLy2pjDlydXMDHSg9rEd2NHdccPkPNw8zzszeMlYPvCd6GmIM7QgV3HAALKUzQ3dyhCnAiQtGs1RBrsM3CeOOdiTlM9mp+l/136gZgyRxoIgSY1F1ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758376997; c=relaxed/simple;
	bh=HiSu1elAGfUw6kIKxwZTf612rmqWGvJZ72lVukmsNOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqzrzJ3RWeUWTG2MobU8tKHw+io/QRlSaDbbDiEfuKDpc784El8a3Ij1QGNyOQpsQ5aIa6/UlVBc/Te133iMOu8xiteadBEX1pud7140Cj7SA73msU5dbIcT+lgzJVWjF8v2PSJFFxYtOcVUc9tdBGcjcCs1aGQW8wahFat2V54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=MPprHi67; arc=none smtp.client-ip=57.103.87.215
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPS id 8BCB11817345;
	Sat, 20 Sep 2025 14:03:10 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=IHjqdFZlYtMJa8HRC4VnZhdX5Q0ePonZlOFVwjjZYxU=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=MPprHi67MiijYc3XhExjP2RuAVq+X9gmjes6ynzZaqHt+RY91GaILhgMrTQpZZaUnUe5mBkHvsngN3eXX4A9IQeVuKx/NBQFjzyras/latoD/9UBnWe5QOSGBGe0GmO+L82Yc6EWRrMf4NqVBCJ2bCYfiDlDs+2nlsQBzBb98yiGZsa3IJjmo3/Ov7FM6mRuFlLrC3La+BRCYJ/i2pRaxEw0DHEQzeee2aJghYoRNKO/7wqkXKBupao8XW5nafJbwI7I+OpZ25XNz6C9mMkrasUb62PxYii/PzRSA64KN06/7uRzkbMHCAot7wO5ZTmYlNLVgafCu9CSD0xfSJjhsA==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (qs-asmtp-me-k8s.p00.prod.me.com [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPSA id 896521817098;
	Sat, 20 Sep 2025 14:02:29 +0000 (UTC)
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
Subject: [PATCH v6 21/23] MAINTAINERS: update maintainers for WHPX
Date: Sat, 20 Sep 2025 16:01:22 +0200
Message-ID: <20250920140124.63046-22-mohamed@unpredictable.fr>
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
X-Proofpoint-ORIG-GUID: 4_XIPZW8Gs1LJTl1yb4x8Cmj5FvYJ9kW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDEzNiBTYWx0ZWRfXzNkOaFQADvwR
 Itqd7fri4VQJfZtSL+sWesK/+mgrlylaJ0L+47HqotwgRZRsYcSDF74yXqJPydM+UTG8Y60qNwj
 z1IaocwzSe2SpZuAK4pGzQ/9Pw2zKVK9zwttgw/yBuyBYIPXi7pyoOc6NsfyBu9Xx0rHt4ZsRyw
 hu//JcmjSXvDZWBpzyJaMi0CtLjc3l5Azqn8XWEP6+K+8JalTldlLwdeCXTvPYp0Odlz/n0J1xQ
 tKu5Ho9FlgSWsgF2/Zg++/eNX/Y+lYcAH1UC7ac7HJy/YiC8RRutiYWQxem6DwLG7ud7+A+i0=
X-Proofpoint-GUID: 4_XIPZW8Gs1LJTl1yb4x8Cmj5FvYJ9kW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-20_05,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 adultscore=0 clxscore=1030 phishscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=886 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2509200136
X-JNJ: AAAAAAAB8FHS6JMIfcy7qo0KxEd26QpUFCC230Xv14XNDw4qRsHHjR8zhMv5KhP/v1+ENOuP41Z7k4OMyonbHQOGwlqjxDXss4hXe3rFz+ooGOlHO/Of/wjJlj5OADsO/R4qX+8zSU4VTAGc5Be1rTiETKLlcoFM7GiB1ZCYAurnbe+I/piujsLm1hpsmhmds/B0S1BHA8K8l9WPxporxSO26B4FvLhYZJgTmKdC8cQEHhGVEx8V/ubT2tBmjEnuqLGEvS5ZKeRUZYDDLPXm0gJ2uL9vKWdB/3uND6oMfN0DSbS5gG3/6Nom8/4B6jGFoK4e/KwzbINxbWhGn4LiPcNbpUnsvS3fSN9OwMom42HZDhTGRbBG/o4pN2fry7NNHqTfr+wFMZnehGhJ4nLp1NxFQxtNLBtNoKegQ3jn0ZbhEzQiNam+58DG/hrRauki7oTNTEGvaTgSH+hYgj1fCTS84CsiIzy9vxP7LqfzjjPzaTj9BGZH6dzQSRxdybMqkI3aINFHNqBBSASeFDZNFlp0qmJ6CFnM5bmCrK9Um6niOFxidBasCXn/VppbNf+OqIlYw2wsP+HabUi2OYd2F9hE0eXl2wHHFKEY7rc953ep8kIKg1XML0z0GheC4eR/G0uTW1vRfbnNOV+1DSF9Pqx4Dh73msS0UAxLiIKedhT+KJu6XV/verI2eLEZdKBbWqV6EI1pHgbfQ2CXmt3AkYh+ktAExt6Xgy6c6b63k4LMndAR10IM/5se2u7lyN6sNC5+LXr/Pv89PjFBHUl6xXy7BE7TSls8gMO4Bwh1PeE2E7hYcZI+250iYMlx/lAQM6ysJs4+FZ45FY9J01Wjd43T9mYyQMrQ6/TkN7M6BV+W8CT8vZZeB7HZrw==

And add arm64 files.

From Pedro Barbuda (on Teams):

> we meant to have that switched a while back. you can add me as the maintainer. Pedro Barbuda (pbarbuda@microsoft.com)

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
---
 MAINTAINERS | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 466ebe703a..e123abcfd6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -544,11 +544,14 @@ F: accel/stubs/hvf-stub.c
 F: include/system/hvf.h
 F: include/system/hvf_int.h
 
-WHPX CPUs
-M: Sunil Muthuswamy <sunilmut@microsoft.com>
+WHPX
+M: Pedro Barbuda <pbarbuda@microsoft.com>
+M: Mohamed Mediouni <mohamed@unpredictable.fr>
 S: Supported
 F: accel/whpx/
 F: target/i386/whpx/
+F: target/arm/whpx_arm.h
+F: target/arm/whpx/
 F: accel/stubs/whpx-stub.c
 F: include/system/whpx.h
 F: include/system/whpx-accel-ops.h
-- 
2.50.1 (Apple Git-155)


