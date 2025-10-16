Return-Path: <kvm+bounces-60163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A0710BE4B9B
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:00:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2564F359AC9
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECE4E3570A9;
	Thu, 16 Oct 2025 16:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="Hd3sta3G"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster1-host12-snip4-1.eps.apple.com [57.103.76.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8D536999F
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 16:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760633856; cv=none; b=UWiFxwTUNXsb3VKf/vNcVVazSCi+FdmFfGRiYiXXIOrH13+5hy+NhS4hoV0UKr/3s9Rgz9CYvRs45UktTM5uTjz3PeAws/dOcoL8s1UgIXJvm+nbMdrTHmtxErf0xuS8aYjl27couH1PUb8n8BugQwETdv1RcrUXOTQfKWc0ao4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760633856; c=relaxed/simple;
	bh=u7CsTxyki6oLbPAGqZUYiKJguUA7f7OUPajKHDOKbQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5Kti7Pm3gUK/FBIlC3pt+1InzPBBTNFLcXkXvmCIocVweJ4bGDV0EDJxrFhzFgTXurhzx5kxt3LPoBPJvIYmvIbR1mEnuUX9UqecsTD+LVLdzEhjsYF2soHcEpJoNpiszywmuIcXp+6Dx+BM50PNQSEwPsVKzgV8gFH/7EDDFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=Hd3sta3G; arc=none smtp.client-ip=57.103.76.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPS id 1262618004AB;
	Thu, 16 Oct 2025 16:57:08 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=zNv66cYWOjcoM4iD8mPZ0d3N5D4+2q07Wwy2NtrQNPs=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=Hd3sta3GaVRNz92RcL4nm9rqJ7Ho/uokvK2HVmFI7XrQ+i+twA2Shvatl7OHG3r3hSCulm82tsbpUgzNf0k3XrCVI74zyE+3LGg5v6ZP/aX7cgmg19jh35aYmNNGo8hcF5ZHGnpGH1ZkcKHRJiqm6BBg8rwsZbsmpxH+g6BJM/sapn7qKxTttxzzkdG3sKg9hemOHJ6mWgQSBI4rLe6WGyJemIzPz5oywseV1+3slQcDMRZJwefe7HPAPQZ1z7OPgee1BLmLG7foTw91r/f84GZKLMRvItJjBLbpCwFOlce0e7WcHTR0FsVNp9cPmSZLNDoQhXjqxmAs47dYGu8Hig==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPSA id BB51318024C4;
	Thu, 16 Oct 2025 16:55:53 +0000 (UTC)
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
Subject: [PATCH v7 09/24] whpx: common: add WHPX_INTERCEPT_DEBUG_TRAPS define
Date: Thu, 16 Oct 2025 18:55:05 +0200
Message-ID: <20251016165520.62532-10-mohamed@unpredictable.fr>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyMiBTYWx0ZWRfX/Se7HJt5ynqq
 roJse5cXmIDGwIRZMaWA6H1I5UTUJqK+cKTCvbOJGuujitBOmO+06nJXJRBTtJ/GPuX3o8VSY0I
 o1QhBe1fQMrTUSoJ95DOq7V8kGvVITsd+wpV287dm2aTTKjdp/zwYz/kYWe5Bwv/KG8YZJFdXdL
 n7M0XiF8UL6PNIknHnlRqQWWQvt5Ii6cMk1UEELm43EorttynVXy7PtcmKJTCJrBusi3pfUKnlH
 ma6xq+181+P77RAzK729cfyK1jCZYw/8z/FDUJHxs8Od8/FZWM4V2Qkm9q/pQkK51G0ozdk4g=
X-Proofpoint-GUID: IhWrKx3FAqHIMTyMmBewRi40WIQl1-Xm
X-Proofpoint-ORIG-GUID: IhWrKx3FAqHIMTyMmBewRi40WIQl1-Xm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 adultscore=0 clxscore=1030 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.22.0-2506270000 definitions=main-2510160122
X-JNJ: AAAAAAABKQbKhGNJsKWtHaM0uPJhTwSnS1oTiWx3YNJODY4fPbxw6apQMVH9n6rgjIZYhRnDazA9zfU0QuI7MvErSkMGrX4AHqmAipWgO4R4KIoC/D8OIPWD8OGAaMmElA0pK9Jo0Y+LLxYCu67FV5xpToXLT65oO3GMCZvLhJGF4MOehOPqRJgV18RmyAW8vQkx6MKMSqZfDfVWHrRJcL22VCTtPFOcxIuLNJGfQ9kHBQJTqCay1ISlMgSDJz+OJveXzNQmmO94XV47yDocXtPmg9yMCf8mQ9dyvFJsuNzGDhUT+3LCENHQbwvBIQiVbCn6NHq7L7S3BgajNKbHXJv366j2irUA4cddJ9f0eyxsG/DMd+CEE3sbCRr9DXpqUwaBNklT42IHI/2WwxEUhYUklzLj9gzt1VnwKPLGKS/5HZwgHplfbD1N8r344/R2v351zRSxraQ3m+9ZHVeWGTaKA309Lh+FcwYJUvcbrc4dO+9HDsRHU4crxTWW9t2/UZ/f8AH5zPZUwvTMicfRw0+gwG2d8wNrNr30dn54hEhOG+Hzjhs03uVFekIjtAB4pLgfJ/QNjcg9xBPYBfT0+hlt6qx1GBzFUjHOnYk7MBfTTrGWSDW+pwXgP+Wdt8pAjF1t7OO2P0JICIoYJuIrGQN2awX6w4xxZ+fWRMHqgSYmmLvZlXL25634Aglv8dAzN6mefl9xnqOxoohX30P4rc9X2ZMCgQAdBjZSdGKvYlgG2LFtjj3UJWt2VTbA1zoVJ7o1Q/aXFE45C1eXoyEzANGCrzMF6jOCByHPZo8fMzKMv7+XsXUeP2/+SUnohPJpFFzTwmnd/xCJ9PoejLIMt6JI/oUUsH/yZ44vJwB/btZULfN6a8jw/hQ7d6ZTcvzJt28OCukPIASSKpWl61jcLF2uZs5fnPXqSsISg5FGwyhj

As of why: WHPX on arm64 doesn't have debug trap support as of today.

Keep the exception bitmap interface for now - despite that being entirely unavailable on arm64 too.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 accel/whpx/whpx-common.c     | 2 +-
 include/system/whpx-common.h | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/accel/whpx/whpx-common.c b/accel/whpx/whpx-common.c
index 95664a1df7..c0ff6cacb8 100644
--- a/accel/whpx/whpx-common.c
+++ b/accel/whpx/whpx-common.c
@@ -123,7 +123,7 @@ int whpx_first_vcpu_starting(CPUState *cpu)
          * have one or more breakpoints enabled. Both require intercepting
          * the WHvX64ExceptionTypeBreakpointTrap exception.
          */
-        exception_mask = 1UL << WHvX64ExceptionTypeDebugTrapOrFault;
+        exception_mask = 1UL << WHPX_INTERCEPT_DEBUG_TRAPS;
     } else {
         /* Let the guest handle all exceptions. */
         exception_mask = 0;
diff --git a/include/system/whpx-common.h b/include/system/whpx-common.h
index 7a7c607e0a..73b9f7c119 100644
--- a/include/system/whpx-common.h
+++ b/include/system/whpx-common.h
@@ -20,4 +20,7 @@ int whpx_first_vcpu_starting(CPUState *cpu);
 int whpx_last_vcpu_stopping(CPUState *cpu);
 void whpx_memory_init(void);
 struct whpx_breakpoint *whpx_lookup_breakpoint_by_addr(uint64_t address);
+
+/* On x64: same as WHvX64ExceptionTypeDebugTrapOrFault */
+#define WHPX_INTERCEPT_DEBUG_TRAPS 1
 #endif
-- 
2.50.1 (Apple Git-155)


