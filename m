Return-Path: <kvm+bounces-60199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3729BE4DFD
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:38:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AB8D5E1232
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 745A221D3D9;
	Thu, 16 Oct 2025 17:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="C0jbpw7I"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster2-host6-snip4-6.eps.apple.com [57.103.78.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D765921CC5B
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.78.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760636311; cv=none; b=TQK3LaZPJlMu1zHaCzDPGBAcoIIvFquvb5GryNCRN7OTa/4FjCsNztq36POGRJBB13WTfUXQFiYJqJVxyQagDu7nQQVK58cKB9lvWJtNcEnu5T3UYFI9R2Kw1Ea4DZC6fD1CESEl4K30wYO91OvUKOt7bn94/cv314ihGj7ClQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760636311; c=relaxed/simple;
	bh=nhjB5Hu1AS9tYUQfEzDUVbx9Yn18WhgYPCbptQJPYl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qx7W7ushx2mLRLHLd3/XPM+ZiNKW08YkjB+32aYe6ySw4+u/XZna+D9d4LiU6AOvykfpUN/5dyO5UUOjuqWQTGp5dH+gaD1/RiU9dvnHQiJ/itDr1ux7lTrVI23CnPEa2lF9cc233+a3AYRMvpAafFwpou+/6SnTW5TKU1kvfa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=C0jbpw7I; arc=none smtp.client-ip=57.103.78.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPS id 1A54718002D4;
	Thu, 16 Oct 2025 17:38:25 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=9vYko/DI2RK+OqhuWK0dyFWYB5OCgm45PuZW5dC4nJ8=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=C0jbpw7IwCr8AyIlvSXaBo7hdHNJXmFGv9xpdhp3YYBtRPTCNicSVUzD7Gos2zptDlfGqjfjPck4Lf39/s2SNxDXEg2bzC1ZLME6KEjrQLV8trBMRZRbpVtZpgYMjE+iW37H4LBjrNLpZ6IjL3slAtULlo7sJ3LHuneUewKNRommhESpUX/8sshaZxhgGjarKj8+xowZuq+WX1xUzmfAzZx1mtdQJg0QSqctf1SMM0aDa+OD0EACQAFwhimItBZnp6lZ7h6VO38VBMCCrA4J29U2/gdQzEk+BBGzmog9sozsvw2F/DwwLMIl/Lx+tPEf7LpCEzuoijgwIU/PjhrQYQ==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPSA id 7C70B1800155;
	Thu, 16 Oct 2025 17:38:22 +0000 (UTC)
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
	Pedro Barbuda <pbarbuda@microsoft.com>
Subject: [PATCH v8 05/24] tests: data: update AArch64 ACPI tables
Date: Thu, 16 Oct 2025 19:37:44 +0200
Message-ID: <20251016173803.65764-6-mohamed@unpredictable.fr>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyOCBTYWx0ZWRfX6GdROmTpds6P
 i90Dyw68606tCqXH1PFpC1Jyc0CEaRZIGwpZXNhMehyVxxhfNabGNPZtgcfslFvbMP+sKNDw/rI
 3t4xIZNMxxgxgpX4fE4gkxaBjGUCgUSSXDcT0G0G5iZvwq3uB+z3t0nQIGmiY/qmpJDaOk5x8p1
 2qtOxn5vW9OrpcyWH4upq8Jz72VF7NXUA5Sf57UwDoxFVjtL+ok7GJB32xYZqlh43f12XZYjLCT
 ArzDIkjdDRqmtuKEwOJD29D/KMp+dMRVTKvXBrMOhZnJPR/+hsUbgnMOnR4nLzjxkBmY1PmXY=
X-Proofpoint-GUID: iTAcvuZeL5un4Sml6QXsiwRkb8b9IaBP
X-Proofpoint-ORIG-GUID: iTAcvuZeL5un4Sml6QXsiwRkb8b9IaBP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 clxscore=1030 phishscore=0
 suspectscore=0 adultscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2506270000 definitions=main-2510160128
X-JNJ: AAAAAAABl1P07TQrPn51v/3GM3yGdxAuKJrhM5B6RuIFfV6Tpm1lXjrmJjd4Lx/cfqGxwgrAgoS9qv0A5XanJ3xQodRaRm0gbYyLgol6mwYlw3vpyQsouKyCp6ODTKXr2PFKN5qiUXoo85a8gl/PhpdZdcKT9YReX0q65ROEasaBzvX5ZnmRjtD1lrrxE4oVD4bHdl1E0GXksj/uOgZQdISj2qQtjWBZCT/n8Mq/FqL3GnN2ST51xre1OOhAdn0zmblab0gD/Xl1betnpqKQWr6i7QTXYG3wMoFLPDp7aaiomQpheFiFM3FGYgLXSTXZeTqIQSf+N/27yx1287wGj2y65TGQB1vG5gE6hLjkl5jsp1eDtK3VPWeGsBKjSQRRV4YJU8GJG9hLbw2Dudjsc4hg7vflD6PAd/WWf6XedHNLKMUIPvmhK2oSUbSgLAm7rwd3m33TKZRFgM23pSRZGz725rNH0nW9QCCivmmJbMXTnryJ4Wx6rhUJI7qKewdZA7bh4qIsAs4vurIBZJ5CxhhR3Zeh61IeMxQ/LgMxqjQuYYJs5WKC0YqgmQnRFOXDT6k5IvM4NBlRwjzFgW/oDqIovPTmuWLNWtCdbNfdRTzwBKcl6UbxhTAKqcU0MDns1eCUCib6ANPxDAdaoCfeV5A4h22aJEMJT5f4jz/MSpLa9D/b6HvYc0ykqpIbslGa0Fm1kUcQYmVzx+TOnFDVo/0lZmZNsHLeZkK+sENmYNLQW2MJzT8aXtjSHvpcEdFRSMGh/3oGbxTwBe0jdYmmIW82yrkDI75paapaKNTyMOqA26sxbFExMRIvCfRL5ftQ0j7YXsP76qxJ5xJQjWnz/7tlK91f+Fn3hQ8Mkc7tlA3+EK1/6PBvorZTb63gJEjlqJi2Y56zrK/2pLFIAHSZlRNMuAmFshJh

After the previous commit introducing GICv3 + GICv2m configurations,
update the AArch64 ACPI table for the its=off case.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
---
 tests/data/acpi/aarch64/virt/APIC.its_off   | Bin 164 -> 188 bytes
 tests/qtest/bios-tables-test-allowed-diff.h |   1 -
 2 files changed, 1 deletion(-)

diff --git a/tests/data/acpi/aarch64/virt/APIC.its_off b/tests/data/acpi/aarch64/virt/APIC.its_off
index 6130cb7d07103b326feb4dcd7034f85808bebadf..16a01a17c0af605daf64f3cd2de3572be9e60cab 100644
GIT binary patch
delta 43
qcmZ3&xQCI;F~HM#4+8@Oi@`*$SrWVwKqeS4aeydBAa-B~U;qHCpaq8j

delta 18
ZcmdnPxP+0*F~HM#2?GNI3&%vRSpY3v1aANU

diff --git a/tests/qtest/bios-tables-test-allowed-diff.h b/tests/qtest/bios-tables-test-allowed-diff.h
index bfc4d60124..dfb8523c8b 100644
--- a/tests/qtest/bios-tables-test-allowed-diff.h
+++ b/tests/qtest/bios-tables-test-allowed-diff.h
@@ -1,2 +1 @@
 /* List of comma-separated changed AML files to ignore */
-"tests/data/acpi/aarch64/virt/APIC.its_off",
-- 
2.50.1 (Apple Git-155)


