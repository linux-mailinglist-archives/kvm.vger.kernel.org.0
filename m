Return-Path: <kvm+bounces-60161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 02255BE4B92
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 18:59:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6321819C70D9
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 16:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86770369985;
	Thu, 16 Oct 2025 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="DwBnAmoZ"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster1-host10-snip4-10.eps.apple.com [57.103.76.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D793570A2
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 16:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760633851; cv=none; b=WuzaDYqshR8r38s0Xv5XCvA2nQ4f6DK0CXWAwrl0N0cuLUoA9eXPqIYcvo/zXiQA9bM26KY9z4DOO5XZ5sARNFjgvRW8ywT80rodJ2GmEKcFFAHNWqYzGDksJl9J8eSbfFi5FDXUnPJvSpykuvCeE18dkyGXS6VuuA6BlfhQ4ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760633851; c=relaxed/simple;
	bh=6ZaNiIwiQUIZ7j9JsDb98c7LB17UaCXZZO63e3L0rdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IzojV8xDZE5mdbyWO6tOGYw7535lm23rP/bgkk+g6U9QfmBNEjASBpZcg5Am8jCrMEEX2I/XSNAA5/BM9cdCfXQwgpbqIj8xlSoJ8KunrRg4e9rdxGF4TVHWqKihMdjKe/9PKXeQMOFvBZm/HQINg1pECG1RDQn3Km1E7/F/IGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=DwBnAmoZ; arc=none smtp.client-ip=57.103.76.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPS id 6EE9218011EE;
	Thu, 16 Oct 2025 16:57:23 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=6QHLe7sI/ta/TpnlofGbhZSXfY72nxkqv2tu61id1Xw=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=DwBnAmoZpheRLuk8rQ+itPmRpEjS6uw8/08j0r+hgPNjG3mUcpMPfvr2i2VW9SLT3RZAcqwlCmmrXe4BBcq9GRLVPnUJ9SoOaa5gdMWtabgMFq4votqca2Q7BW62jodcE2HrQEh7FrIBAqkyXq2/zc04xy6W+Ef27sMyL8IU1Jl/i2WYwyRYILmfqFscZUaRG4HpVO5WcuFNZj0ac7WEme/Tz7UR4jhEW7x9MgkEV8xjsPstRWSMDm2ygwDRYM17osn7EBnekCVH9LgA/6RDjnxPFkp74kvBda8y6UIShaYnX0+CfJLRkahKTmza3SnZSx28rxrHUpfM6DOsCWuVwA==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPSA id C2E7918000B1;
	Thu, 16 Oct 2025 16:56:17 +0000 (UTC)
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
Subject: [PATCH v7 16/24] docs: arm: update virt machine model description
Date: Thu, 16 Oct 2025 18:55:12 +0200
Message-ID: <20251016165520.62532-17-mohamed@unpredictable.fr>
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
X-Proofpoint-ORIG-GUID: 2VXZH75XKZT9jAzttdmyyJwzeEHNfDHa
X-Proofpoint-GUID: 2VXZH75XKZT9jAzttdmyyJwzeEHNfDHa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyMiBTYWx0ZWRfXzpYjYO8p3ePJ
 K0/rRlNsQEkZrAgp+DFHF7BvmhTCCAHZ0dz/F7+RXskkXz3QVfRx/dQLgty+PlL+u82aMtHCCQz
 0vGh3oDovb42Ux0qxZWD3xesKIEbeC2ufRIZ3KM68bdj/nJRiOpxg9kpyPlKMpgHT0wZFUTUaMy
 k0ENtmyOJP/ouoSKV+hzLmgcJT22LB1eRz7ZgxggiZPtbvXlJKnYB369Rg8wiaduS7XLaE40NAU
 55D/OLzaDvAMo8HA7PaAPW8OQdhxTWGQE1pLagPudS7/ppSpnqgBzP9Inb1G5GtgaCWKahRVM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 clxscore=1030 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2510160122
X-JNJ: AAAAAAABa9U4fBV+CjKowirirDzCSK5ju6pVXYXq7M+2rbuc+mmuhAP/AVBJnh0wq26he1tnSxZYmyvI/jKe7Jz4w9tpvW2DDld2y7xzrzasXEA9Jh09xBayCyOveaaDDPflsEiMIkffaq6W8aO1MrgwcSIv9doGXXoCxRdH6uFaee1hLlG7IgHcjMiPyOGXSKO9JHr/nyMfBptqpR/6S0rLFwQC/rV+6cub5DKWkEC4r4hBztRIwrHBZczl206Ka+pfPa0gx3r/VMdfQ1RKVXUnxGKsZSFP+0xC36HLI3lMN019sPj0vkOlKQtPzxH2u79jHs5zfciKPbSb9rTKUjTgzR9qprqd7TjOBfc6XO/vra+zWTnwahFF6qs5zMQ2I40rFPx8VZkYmd4qYvZQwtTS+YekIeHeIzR1lW6o/wpx1ypLsEH4umNV+uTvsNzImmAU+HnoP7/O0jcle3Ir3kCZXjLXmluCoEFtIewG12WUv87Oh+pD/M6MPcJjTjkIT2Ap7qLffe/kP2Vr6vLEEx4mYhQFkuzkjq3KpuaGqmu7F85XOsHIXJs8mnZ8j3/W34WoUvvObea0173qbq/GrYiZbmpZcIzX2ZoeCZ7FjigkpLrJdeCurLLrrwMJm0RgkQ2EQ/OUH1tE62YnYE7OJ4DhRFvF1LvMKcDcommhh2vRy5t6dErzZKgauXia2XUwr9T80yvdzoMwQUIWIcUyMDTnxsJgPl97zS23PVcvEjU79pAYi/FVAiKhCBHgOdjCVMbqFoaG2dIyFZu+dTVN/rFTJH1t+qU1U+axosqNXKzte9dWNS4/45lpQuJtCg6OoX8BMShjcW+ZbeusUZsgUYGQ26E1ylLQJEfnA0ZOm96y4T1VfqphhCSvYVaqnyOl35JqBWa994TIpJhcZ0RrzYNHJQ==

Update the documentation to match current QEMU.

Remove the mention of pre-2.7 machine models as those aren't provided
anymore.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
---
 docs/system/arm/virt.rst | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/docs/system/arm/virt.rst b/docs/system/arm/virt.rst
index 10cbffc8a7..fe95be991e 100644
--- a/docs/system/arm/virt.rst
+++ b/docs/system/arm/virt.rst
@@ -40,9 +40,10 @@ The virt board supports:
 - An optional SMMUv3 IOMMU
 - hotpluggable DIMMs
 - hotpluggable NVDIMMs
-- An MSI controller (GICv2M or ITS). GICv2M is selected by default along
-  with GICv2. ITS is selected by default with GICv3 (>= virt-2.7). Note
-  that ITS is not modeled in TCG mode.
+- An MSI controller (GICv2m or ITS).
+  - When using a GICv3, ITS is selected by default when available on the platform.
+  - If using a GICv2 or when ITS is not available, a GICv2m is provided by default instead.
+  - Before virt-10.2, a GICv2m is not provided when the ITS is disabled.
 - 32 virtio-mmio transport devices
 - running guests using the KVM accelerator on aarch64 hardware
 - large amounts of RAM (at least 255GB, and more if using highmem)
@@ -167,8 +168,7 @@ gic-version
     ``4`` if ``virtualization`` is ``on``, but this may change in future)
 
 its
-  Set ``on``/``off`` to enable/disable ITS instantiation. The default is ``on``
-  for machine types later than ``virt-2.7``.
+  Set ``on``/``off``/``auto`` to control ITS instantiation. The default is ``auto``.
 
 iommu
   Set the IOMMU type to create for the guest. Valid values are:
-- 
2.50.1 (Apple Git-155)


