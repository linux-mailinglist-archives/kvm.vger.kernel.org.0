Return-Path: <kvm+bounces-58311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B60A8B8C9F7
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 16:04:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BACE628B08
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 14:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48BF22FB975;
	Sat, 20 Sep 2025 14:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="Yal54Mo2"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster2-host2-snip4-6.eps.apple.com [57.103.87.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FF52FF65A
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 14:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.87.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758377001; cv=none; b=OyBqVxwG9xAoJLBUZ3HwLjqcQXlPOy59MxIQDnNgur8iQS9koRE8HL3FOLdqckJXj/IheyLAKDiH4yZNxNVUNwJ422QDoyqhgUqMafo7w0uzbKQMVs43FlRyEDO+bMgrtSv/sGzkOExjA7CV8pUXlSPx3KGu36o08/wBJlrVxdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758377001; c=relaxed/simple;
	bh=6ZaNiIwiQUIZ7j9JsDb98c7LB17UaCXZZO63e3L0rdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHlDkdKWiD2Ti1ZmRIi47VjjoNZ1gHWmKjeFSLS5dFhXLCB2LT2ih3aImCPgV4KVpb3IbDs5U3CsnLyQgWcpO6wFvszTPxI2bslOnzBSf3LxnN9YnvKhss0ZiqPD6cImSImdCMKKXAlx3tY2YkYeR1KA4yTod/N9qwQeAdkYihI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=Yal54Mo2; arc=none smtp.client-ip=57.103.87.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPS id DEA2918170A5;
	Sat, 20 Sep 2025 14:03:14 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=6QHLe7sI/ta/TpnlofGbhZSXfY72nxkqv2tu61id1Xw=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=Yal54Mo2j/1B9TAxD6hgWtXOuoivd6GsUp5UlECkI1Ozv6iPJNFfADPRumTtZ4CvlZlpNBa1DET98Z1YPij8W9En4/7tLwoyzKm/3oZgMqL2AHz9jkzox23eECMKGJ7F2UmKfV5mdLG3MdyxwpilYwdXGGL76A7iGv/TI2fYzQ0RPBUyRFKwNfHW4PMmuhR7xOIEAkNSXIy0x2NJHaL2zuR7sC3cacvEv4TTrSDy4grI6U15t6zqxGi03uS/EkAu8biN+MrQv5SOtAUoopjT8gGqB8UEupvRPilCp5lLwaqG52/EXMSknMJM05sROdNcbH1z0NrXh3JIAyMzwCYEoA==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (qs-asmtp-me-k8s.p00.prod.me.com [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPSA id 691F71817268;
	Sat, 20 Sep 2025 14:02:32 +0000 (UTC)
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
Subject: [PATCH v6 22/23] docs: arm: update virt machine model description
Date: Sat, 20 Sep 2025 16:01:23 +0200
Message-ID: <20250920140124.63046-23-mohamed@unpredictable.fr>
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
X-Proofpoint-ORIG-GUID: ojLL6QodVQ17wDK9HHqj0FwWgh6Q8daA
X-Proofpoint-GUID: ojLL6QodVQ17wDK9HHqj0FwWgh6Q8daA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDEzNiBTYWx0ZWRfX25h+Oy3H7yiS
 yt9rk8Wty6XF48La1pCM3v9VeSEHWEXpAp6eHstyw2qPEoBHEJWJkJukxeJ8RL5rzBtm4jhgvlb
 mNFsLe3F15Y1SHee+YZhYBzAGp37q+yIthkM8R07Swf+Z4Lsm/Dx35pGEOB4whFhYaErp3ALYR2
 0rFLvXXIBAipso3jrQO7F/k2CmaZj616P0JfpjfWjl/vq9ecLKt0YXw/EpNK+4hxByYZ83HLpch
 mC2gS7VlTQE8LW+fqcWJn2M0ayboU33aZwYE7vlKQohTjNFUYYIY8TZrQsEyEA6jgv0tcdQWQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-20_05,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 adultscore=0 phishscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 clxscore=1030 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2506270000 definitions=main-2509200136
X-JNJ: AAAAAAABzBXNo6aD0xhHNo9zDDLKtbsGIdEu9Jzv0TkCWRLkBC7HbJwcYHwcB7cJdKBi6rFM4zCP286YCrzFBoQDYCRGYSCIS5FuHpcLeFsu5aLATorotIsTuv3e3aDWeuoKokRJw1AZ7e2Ae/8eBbp2YMJE5De1oidpSO3aB4DtyXUGcfsiUaB2ULR1DJ1d94E2ieHzNeTYJW1/KtsA/aaPRTJS8ifZewz+Q5i+WZaw1qHmGsWumTQVWwkR/lNJSX8O6nPrkZWW4M5R0fUJXUshLJ7sFwRjaI4KhrkfrFtLIovtPJG0VoKb7xXFHX2xS0ylGm1pk0zXQ2YeJ0q2qiCq0SFIeivSn6Sti3KnXDXj6igcFy9iirRMe4j1AChxwd5MqXVxsRHnd9rvteZft2kZk0NzFH5WpRsY6/Z7+X4/htMXkaTgi73+/B6pHZZacyS8cEj4fUO5strUtRYL9Ldz6PGyAxYWHUAZSVC8yuCQO/KXEs/dZ0kPF4uLq+0bCXxLFkOy7NDFOp2Xd4+IaVF1fLz4OP77W9BEumjILfNkIehV3b0pbqiZr0i+4D+MTVagYA1Jnd/2loyQsx/b4CmNvpZbvx0vGxTbqc0ztFwDDRlExj2hjlMyoWVeTS6M7BbJxuJHbtXJ2WlPajKEEaBt6vQUIaLeJbX3QiTmThqyH3QkpdWP5/rSDmHeH9RBL9I8flt8Z+zubrVh6s6ZhB7TQ50bk08XEYDig3+zjUd5g5zSlODKPUIkVzWEnhM7ETyf8ye9/YM1A01hWlJok4LiJYicG2jYZi/xJShXP0jJkkV4DSKoZTSDfap3iqUkY8Waf7p6vJSfJiGq6PVGGBB6OvMovwfCJvlq/VYNt/hn72/tAvzzb8oDBcprBl1ESg==

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


