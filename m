Return-Path: <kvm+bounces-60168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C9C37BE4BD1
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:00:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FD1D3ACD21
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1F6B32B993;
	Thu, 16 Oct 2025 16:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="GB7hwzHK"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster1-host12-snip4-1.eps.apple.com [57.103.76.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C4F393DD4
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 16:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760633868; cv=none; b=DceTIodJuZlfgZbzYQYderoInmTRlhmy4GhY1W7mWKbklflxLH6WFahHQjsQQg7vRHb0e2cftqM5252+iUq83C8waiRcnOa48QWiFIRDHe5aOHCkccDP/UvCxPlmTR2IPzh9f/tBdY+5ezMoaHDYOInpG9rdBVp/bl+Y+snbPAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760633868; c=relaxed/simple;
	bh=+WUB0WTyX+QKsfmxtNev79PL5T/bi2gKf/3znDLZW9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMBbHB6ECfgbmNgiB8SYRI0hJuZ1HSuL49iGcVMiC7zTr6w9aQKNqMZYmXTVghuxjf+NNT7jksLobrKp6FciVmqxNdFsorC6hudsL4GSm0IYZP8Bjl8nHHwhlepAk0AjhTTHn6TuPyiBxkmJ5iXblvDfjNxKntChLMhXW2NEQSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=GB7hwzHK; arc=none smtp.client-ip=57.103.76.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPS id B9FC81801850;
	Thu, 16 Oct 2025 16:57:41 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=XXxmCGrw3A7yoY22VdhSWP2DZy3nPyJTDepFV431JiU=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=GB7hwzHKFmN/hEulG5ra+neIontyGtqIBFYeaRTdwZz8UxCvIi9MNlu9ssEMub4fVMwQ+2ddVjoEiDeGDxmpcnmZhSVInr5360GW6dXcWtDpmDqQMmPzZJFVtH86CAIDm60FPBw6Nat0KPZfbah+DidrETXDkPy8GBbBgRaJsOVPZd/G41hBcoVWhLLLxnQ0Swx+zdloMEvoeRyIffO4/Cb7fdyk1Fc+pf7kiXdD2/YKqksiscqpP1OwdtjN+lEfEApWmxGNsNgyf+nLmL0cvw9S5B2i0u0K1ZXnQT7XuKR0+Ojq2lPMo1ilZnxZ5ouoP+dFsR02eER0sG5vQNuduA==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPSA id 6100018011DC;
	Thu, 16 Oct 2025 16:56:41 +0000 (UTC)
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
Subject: [PATCH v7 23/24] MAINTAINERS: update maintainers for WHPX
Date: Thu, 16 Oct 2025 18:55:19 +0200
Message-ID: <20251016165520.62532-24-mohamed@unpredictable.fr>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyMiBTYWx0ZWRfXxVvW6wWaENS+
 2A3l3E2Virp5V14DLevwsSjjyHn9uN/EQ+TIcgB0XjAxrHwAFDpd0PtM82CkbmUiPq6oMTy1gvg
 f7CAAXDCGZLPGVBcaVd1q3gGJbJrkfJlA22/CA+I2toVIsLT2XSE1Wo09tl9yd5q7SYLkDGuxcH
 JH4M49aC7Wcz05r5QpfZeNK+wtSwPyva+5cjp11OKQA5twzd9n7D08qCx2MdcQzt0WLPJGlNzR9
 QzxgiuVfopKi3rfugfwqiX9EY8mO3CtJw52S8dlh5LK0dZIg5PpxpecUVnCjl9xmg4qx+5JLg=
X-Proofpoint-GUID: wJNaRMLLJzLK6FHYFfpP3tbniwg0bIlp
X-Proofpoint-ORIG-GUID: wJNaRMLLJzLK6FHYFfpP3tbniwg0bIlp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=900 bulkscore=0 phishscore=0 adultscore=0 mlxscore=0
 clxscore=1030 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2510160122
X-JNJ: AAAAAAABBFeBE2oOJopGBuIMoX+iRngQjjVB2BEL7RjgOojp2rWGSIeRpyN2yUjJSd+DxsgU52nfeb6448yILSWcKR4KSpvpqsNw99oj04kXpWolG6nAtVMu8KYjRv9KcybJkRJq7cGo6y1vliJcw+v5p2qKpZ4VXAq3MOJmDetcMES1EBWaKAFkC1FE0VgF+eyZM6tUeiNApCB3FopG5sYyYlgh/fwiLeUec0QeNb+hp9A8UnpSsRPgtLPsEgZzNDV1xl4qNnl/t+Q5pu1qLpxgWqc6JxkBvPFyApOezVoLQ+371QheCsDoE+f7A/gffS1QY98PB5/jOAZ4yubOIUC4rzZNP9qbDpyTRZ2vod5DGk6qdyL+/S0s2pjdDwO+SfhKJ2JgONXiydGzITXktbiyQqPdForCQIOqd6nAIeTbCxUhiBLeCKTxw28UCezhvOzpFGxLAOrMZOdcIlfuJ8n+HboH2OYWiGr7a8rLi6kg9+hLVKISyoA7QI6HKHoR/PInOSRaPq7eRQP6NiKPGwgdUeJTpg0PoOMd9t1LA5AG62viX4nb+vp27lP/wEHR89frPHNKOM2IEWbdbapbCNxzjWvRTrs8gtYAs4QAKdse8oevZVKxWCplIVKjApvcjWt5oXRhnf8HJ5yA5w/FPjzm7NoJJqYNrSGOdVPrDdBKKLef+1nQKoa+zyVOOkwoJjSOp8879AJEQxIPkFBQ4qh36xINAE+a5sMS9WJ5Llo066+MCyP4M+/nnUAIEeUIk+Q3BYD6Uuvihc5F3L6/PwB5poNZbls3pA0mGcTU3CmXl44v7VGsQrQKjdUWWu+pwv+N6lfs8OIkRQ9sFPoU4NF0bx/8A1Kr6G4TfOX9En9UnwwBDMawj59/iXn6+v4R7IM9Zk+qetevD6T9WEa6SkUp

And add arm64 files.

From Pedro Barbuda (on Teams):

> we meant to have that switched a while back. you can add me as the maintainer. Pedro Barbuda (pbarbuda@microsoft.com)

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
---
 MAINTAINERS | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a516e66642..5faa4a2fb6 100644
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


