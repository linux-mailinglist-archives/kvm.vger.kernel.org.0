Return-Path: <kvm+bounces-58309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BF90B8C9EE
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 16:03:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31B4E58408E
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 14:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEEB42FDC50;
	Sat, 20 Sep 2025 14:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="MtzGnu+k"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster5-host4-snip4-10.eps.apple.com [57.103.86.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B56A2AD22
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 14:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.86.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758376993; cv=none; b=V9TEZpdAosB4pDVXpyY93i2/nFNrJywdmMZRXgOtYfvmWrR8qBPht4qtu4YlKyDIqSvsAoL35AeaF5akkypiNTpHgOwF1dPbYcNFjsFzQIAFtu/a7Dpq20ONZiAY7ymXv7a6JEOlqR+Yh4dCd3teyB/iVczIPND889KGc5mlKyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758376993; c=relaxed/simple;
	bh=4a6GTR5Lxc1XBnnx4v25FUrVjCJe2qwlUz7nOhOmI6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcsjHEjQ9vZy3jx9pKwrDlmJTYghSV4+V11hQsFNETDGZrCGTO4xDzn04TFkjmvdMDpq/DEzWzKh91JXwJIXk66FUmEAv6kj6apYzaX/xwWFxGFJdTSYYcfhtf30vKuyV+ho9hSb1QgFk4D577qZRuhNR3St72Aj2vobdbDVkOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=MtzGnu+k; arc=none smtp.client-ip=57.103.86.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPS id EBC0E181722C;
	Sat, 20 Sep 2025 14:03:06 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=qHgEAm0T48qcnuuyvEGL0jYZIN/Qj9qDonPyqKnSW5o=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=MtzGnu+kCzFJnQ47hOLw+4LWUtk2XOfmPEEejEPpXr8EzdEEMVWYj7y0BUfEB/PQ4YZVioAr22u8Pp3BXdWGInXRnH+ja0dvrpRDoXGSFZZD/ZFjAgBVNJBwLI3FqFyP1u0IJDakZiva7hiecPIevaXpolOhm15tbylGJVgMRxbnNo4myjrNYkCW0sA+a62bJ9X8w2UotyDWEnnhF1qIB1t5w7xXOZgUpUVSYuvEqJgY8ehVAWZV5TQmLWl0btSq3+etIpNNtYcPi8EpyGSMxQy6LfRxEmQa+Y/5ckSK0wy8k4ISyowNhr4sCBgJkVW4xVRAm8icelSiJNm8bt714Q==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (qs-asmtp-me-k8s.p00.prod.me.com [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPSA id AB17A18170B6;
	Sat, 20 Sep 2025 14:02:26 +0000 (UTC)
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
Subject: [PATCH v6 20/23] whpx: enable arm64 builds
Date: Sat, 20 Sep 2025 16:01:21 +0200
Message-ID: <20250920140124.63046-21-mohamed@unpredictable.fr>
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
X-Proofpoint-ORIG-GUID: fHfNnrj4DjiPpriNYLihesMCbT9QAhYs
X-Proofpoint-GUID: fHfNnrj4DjiPpriNYLihesMCbT9QAhYs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDEzNiBTYWx0ZWRfXzCvWheqLsfm2
 H4weXvftQEBpsctey7OgoqA1CLUZDFT1abME1rB5dnYmfNiCLgFgjfiAfKB2uUF6jwclPL/TC3P
 rJnRM8XZwSkc2mIWz9221p+217zUK4uYG0roDjP9GlzSagIZexA0WGKurXCemuhPLuGkZ5SGQfL
 GU/lsTa2Bo/b8Lgwho12JVhlv34HAKviPfYCA5thTQRASyBrpf5ZwHtGCdDo/iAE226YdZYhZYp
 JY5FHHlsaucY2stmf7gLReKKS+bYw1D3FxngTZZSsmsr1+FSG6VRMpQ7eBwi2PZuML5vqK2z0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-20_05,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=797 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 clxscore=1030 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2509200136
X-JNJ: AAAAAAAB79Z/XZi5MOK8TKrJWDv2jh5CCZ34gC0VTOC8jxc6nuOGCkHtBdTgcHPlPasYSHQkvLBRS7pVPJpjulLNx1qwqUBTstBAhsUXGD/tgNBWVp6NCVi9rhS/ijud6jg90fhNpB8dSDVfHdTWalmG0CJ2wBqRf2PYKcp5Oe3Al+VTRKrXSzU4amucvk2NldN3+4TCWrZW1ep9UxkM3MaDVcnhm0akzt389gzeS/UQBz4Dl8j0Y5+KYhLxccbvvBlnSadoIYWjmrubrMBKlR8qc8etRK17MlMUbzHflzI3mX4Rgd3oqJX+cG+zxhTFR8idFw6Y9nknC7BKD93lX38vImKQqgpzN03L1YDQ45FfelSgu4u0TRK6U4yeug6wCvXP6Uk/Aa54EtaatZewxc5ZPORPJGPfLCcXPNwsyCRt9yPkRbYv+1eHp1yZTfZaXdeVIo1F2lp7T/zj8Dx6FE5C2u295JL99AYEnpjuMCGp6dYZ0szJkIrcxbHauTHWmqKIIjC04rhVPVO9RcxgMg9gSSXD3IAfiwEqADZRjnhFqELpipH8/qBZKz1Mij3y9W8Gx6rULVieUtFhWav+SnDE6rcUvamST5tFZHc4a99Qh2tvMWDk2o9gV6VWEGWNBO88IwZFKzerl1a4/3TdXAogdwKEm0Z4PDZtPAJMYxDN69X9TVLKeUrpKtS40tTUPPOjXugpPlMDn5y77WthxEBSrfuUYMENTywGGWiEE9f1UPt1o3uoABoL1V6KUqeJj7/uafIuf/FBEms8R2UUquDK3P+Kr9UWGlaiDZr7EMAt8L4MLoU52iRuqEtjkGqIsvDRabwNQyBNebMHWOs6U199m7Xg8e3G

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
---
 meson.build | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/meson.build b/meson.build
index 72da97829a..ca333a35e4 100644
--- a/meson.build
+++ b/meson.build
@@ -327,7 +327,8 @@ accelerator_targets += { 'CONFIG_XEN': xen_targets }
 
 if cpu == 'aarch64'
   accelerator_targets += {
-    'CONFIG_HVF': ['aarch64-softmmu']
+    'CONFIG_HVF': ['aarch64-softmmu'],
+    'CONFIG_WHPX': ['aarch64-softmmu']
   }
 elif cpu == 'x86_64'
   accelerator_targets += {
@@ -880,14 +881,20 @@ accelerators = []
 if get_option('kvm').allowed() and host_os == 'linux'
   accelerators += 'CONFIG_KVM'
 endif
+
 if get_option('whpx').allowed() and host_os == 'windows'
-  if get_option('whpx').enabled() and host_machine.cpu() != 'x86_64'
-    error('WHPX requires 64-bit host')
-  elif cc.has_header('winhvplatform.h', required: get_option('whpx')) and \
-       cc.has_header('winhvemulation.h', required: get_option('whpx'))
-    accelerators += 'CONFIG_WHPX'
+  if cpu == 'i386'
+    if get_option('whpx').enabled()
+     error('WHPX requires 64-bit host')
+    endif
+   # Leave CONFIG_WHPX disabled
+  else
+    if cc.has_header('winhvplatform.h', required: get_option('whpx')) and \
+      cc.has_header('winhvemulation.h', required: get_option('whpx'))
+      accelerators += 'CONFIG_WHPX'
+    endif
   endif
-endif
+ endif
 
 hvf = not_found
 if get_option('hvf').allowed()
-- 
2.50.1 (Apple Git-155)


