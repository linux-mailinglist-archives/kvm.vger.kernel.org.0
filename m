Return-Path: <kvm+bounces-58293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08614B8C9B2
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 16:02:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2E70625657
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 14:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1A1227F4D5;
	Sat, 20 Sep 2025 14:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="XbUVz4bv"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster4-host2-snip4-1.eps.apple.com [57.103.84.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDD02AD22
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 14:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.84.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758376932; cv=none; b=gEyqpz66JNzoDIDhAQF/71sCYxYMA6SLjahOSYnDeKx1sCkcrSL+1t/pxPR5WTQJV72aRy4zZ+gIXzMyLknnKGtnO1eifEiNN/W4ws/EQFtFDcku8qS8w+KDRZlcAi66944zHiAfJhPVl9Xu2pO/aFizhIbtD29B2udpI57lQ/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758376932; c=relaxed/simple;
	bh=hy/hj2TIHLJGARf1osXbzvJZagUZXLdNzU/yzMgozIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkN39NMgHQM4FXJres4OANJzVThKeLYYB3KcU1Euh0PI7sRM+8BctGcHYwsHUfB+4sVzS3ukm30V1WV6uMnx8JMQjmhcYQeoiLcuUCoAh179wxvlwn1WOtR4Q3WD/YZCUYPq2hRsmOEdMHtkHg0eHRjokZKf+WpQpjJE5/YUZBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=XbUVz4bv; arc=none smtp.client-ip=57.103.84.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPS id 0BDA0181708E;
	Sat, 20 Sep 2025 14:02:07 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=ZmarROfccVXE3MoqDaCGs6A/zz89R52aHcMDgziuwlw=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=XbUVz4bvnYK8BHXa7LjQa5l/3ZYevhiUthHlrxgA/mc+7y2zy+t+4d/5fhQG2MsnTOcaxp33jix9omRxRk5saJtQcQIO7oEPmJR0KeLmuAUCYU6Spk5jmhz3MlRMsa4tvj4gTlT2cq3DYax31TqUkkAOggZ4VOWUwkELX1zaiC2wbeRMIxMBgGofwn3zLy4uWA0oAlN6XC+VbI8sR4zJKjraKjq3nMTYkEe0t18lUYXjoQWQ1Va0+Hzq3vdZE+O/G9LOTC4Ou+k04NOLTVPYTQyZ069ggpNjcb7BsqB4dICsQud4hTEU2oUcui6FNKwlbWhqol44AtLpfR4peW8Jtg==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (qs-asmtp-me-k8s.p00.prod.me.com [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPSA id 886DB18170AB;
	Sat, 20 Sep 2025 14:01:39 +0000 (UTC)
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
Subject: [PATCH v6 04/23] tests: data: update AArch64 ACPI tables
Date: Sat, 20 Sep 2025 16:01:05 +0200
Message-ID: <20250920140124.63046-5-mohamed@unpredictable.fr>
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
X-Proofpoint-GUID: djF-JSZCK828MqRTo6EAoXqSZirY_e9j
X-Proofpoint-ORIG-GUID: djF-JSZCK828MqRTo6EAoXqSZirY_e9j
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDEzNiBTYWx0ZWRfX6/ioemKx+qSZ
 SUXlW6MYez2m87J3lr2XDcF+/nnneQPqLI5O/DwQYAgugDhVL/G+fRSUuS/EbpeYY+8VoWo+upy
 x67/xiuareZ1nhIwZ0pAN5V3zSW4/0XmgUNsHCQvOq98zH4fOuZRG1oeTRKvg9FW/frBrwCl01Y
 sAo+NqLvDPZc9k6bc6FwhLn6AhLvn2VR/pgWZrdqzXDSVlvlN3F46Eq4wwArBPrAxaBB1klpbg6
 0RrmR8mtTOCYTh3WXQ7vAT6TA93M8NVgxmpzoLBIUW23Cx28rQf0+kb+a4DhXYtfGB78Nw41g=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-20_05,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=995 phishscore=0 malwarescore=0 mlxscore=0 clxscore=1030
 adultscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2509200136
X-JNJ: AAAAAAABci34xKK3lGTzxryQ8lO9fPG5/erK1+LboxL0XxPCzONyIe1Qnc8/ib3mNp/XklIWXo/U/GK/AKyodF5OGIItmoZllFRBYa/YKyWimYKYV9pi6jLEHh+bowOO90OmzmkuGlgygp3X0TMeA5tDWCi/8McBkAe2bkaxhyEuSBca+f1BULpxDXw9kNcyXtC3k+0PoQSHFLJ6n2XkcuiuPPkbO51zcpvzyvFTqB5lT26jVfIrBWYTfvB45JomKrBCP8MslBACSuB+a5PH/mWoB9A9PlF2t/9H5H72LksFz+sSzOaka1uJtQSjeEici8Boqnu+pEeMLC82AKcaSzG0LPViXY02ZLx8UGrEPGh0D1AuSR0aQmzK7DQwXxao+LVQMVtuc+cCqSdPmn0T+pSdR/60A2YjO8SmcVHk7f15W5owS3e1ldfLkt3NbUlnlzj3q+hhnksIgaAetpQT46JKdIScTnSPWq/mv/Gf63P8LSEY6j/26FXDsD7XwzsdgksljPyjzR2w4J2nJTvLpE9g2Dvl63U6A+w0gU5H3Pes2OmRji0V20XqT05HDjZR48B6g3q2VRf/SXPdg6qDPsEmbupFB2eiVG0m5P+eaOT5v/SqJnw5cRnHk/2NYI1WDGEFwwHYInrKPWtUirkz/K9IhsYYyce1qoFHRZNvBLtx/eqAoyWICQxm79euVVeLUVLlqGtMBgnKA+OWo67e2W+XHbdgRWMDSYlX6jjNHHGPYX33wbERWqWiOXH6HuxQGMZTZ2AN0PC7+xPUJlTuF+tMN+KwgSu9a+T4OYCy6J9Q4jM/li8dXwLoPvCNuM7L/MYu56zfpUh5TIXuRdVVo5zdM+pOqYKotxlhzTYQQI5eEL/sxfj8ZlJ0qZNzUD9n

After the previous commit introducing GICv3 + GICv2m configurations,
update the AArch64 ACPI tables.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
---
 tests/data/acpi/aarch64/virt/APIC              | Bin 172 -> 148 bytes
 tests/data/acpi/aarch64/virt/APIC.acpihmatvirt | Bin 412 -> 388 bytes
 tests/data/acpi/aarch64/virt/APIC.its_off      | Bin 164 -> 188 bytes
 tests/data/acpi/aarch64/virt/APIC.topology     | Bin 732 -> 708 bytes
 4 files changed, 0 insertions(+), 0 deletions(-)

diff --git a/tests/data/acpi/aarch64/virt/APIC b/tests/data/acpi/aarch64/virt/APIC
index 179d274770a23209b949c90a929525e22368568b..f9b1f98ce7b7712b40bfbd87c355e009a84d97f8 100644
GIT binary patch
delta 18
ZcmZ3(IE9hRF~HM#3IhWJi~K~cE&wX|1V#V=

delta 43
qcmbQjxQ3C-F~HM#4FdxMi~B^bE(u-<AQKFjI6xF55IZmgFaQ9hI|W_<

diff --git a/tests/data/acpi/aarch64/virt/APIC.acpihmatvirt b/tests/data/acpi/aarch64/virt/APIC.acpihmatvirt
index 68200204c6f8f2706c9896dbbccc5ecbec130d26..67f9d26285623a7862eb4e3ed78f1d8652673a81 100644
GIT binary patch
delta 19
acmbQk+``P|7~tvL!pOkDlDv_tiV*-VVFYjh

delta 44
qcmZo+p2N)L7~ttVhmnDSrF$b+6{7^N1OpT>aex>=83qT200sc8{RM~s

diff --git a/tests/data/acpi/aarch64/virt/APIC.its_off b/tests/data/acpi/aarch64/virt/APIC.its_off
index 6130cb7d07103b326feb4dcd7034f85808bebadf..16a01a17c0af605daf64f3cd2de3572be9e60cab 100644
GIT binary patch
delta 43
qcmZ3&xQCI;F~HM#4+8@Oi@`*$SrWVwKqeS4aeydBAa-B~U;qHCpaq8j

delta 18
ZcmdnPxP+0*F~HM#2?GNI3&%vRSpY3v1aANU

diff --git a/tests/data/acpi/aarch64/virt/APIC.topology b/tests/data/acpi/aarch64/virt/APIC.topology
index 3a6ac525e7faeaec025fa6b3fc01dc67110e1296..f8593abc9002e21cad80af4320a7f74968fa724a 100644
GIT binary patch
delta 19
acmcb^dW4nBF~HOL2onPX%an~=yO;nwqy?t{

delta 44
qcmX@YdWV(EF~HOL4if_d%btx~yO<<+B^aQ9i37x71Y!q<00scqp9a4G

-- 
2.50.1 (Apple Git-155)


