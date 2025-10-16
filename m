Return-Path: <kvm+bounces-60204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4281FBE4E0F
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:39:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 477AF5E018F
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B5F0221714;
	Thu, 16 Oct 2025 17:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="Yyh9tf1/"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster4-host8-snip4-10.eps.apple.com [57.103.78.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82EB22068F
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.78.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760636326; cv=none; b=Zoii/ZB64cCDafJSrsYS8peWJXrCCNL9gDllefJLbCHVAYYREJ0d34FpVDMSwxtrLztjv5dt6ZGA529/hUvMjNtnPoFd6jR8WCMtzMxkh8xa5oVZ+03bo4qOMCzSc1xoyzBuWBnX+vsFd1NzdMMvcfqPVGpe19mJn471H04oW6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760636326; c=relaxed/simple;
	bh=u7CsTxyki6oLbPAGqZUYiKJguUA7f7OUPajKHDOKbQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TvROpPNCMZroTI34T+d8PJmrC7Yese8LP0LW0StYK+PSjZ4TynHEBh3jX2lXy7BX+IVLCRKqyhOquOrvxfBCVpN/bC7eJToNvUxTqYW4k09fJMbt2gmSpdPe0i69XZ+y8o1rc5X4S8twO334GeY48EiXy3n2Hmk/xgD/K7dEHT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=Yyh9tf1/; arc=none smtp.client-ip=57.103.78.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPS id E0FDB180012D;
	Thu, 16 Oct 2025 17:38:39 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=zNv66cYWOjcoM4iD8mPZ0d3N5D4+2q07Wwy2NtrQNPs=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=Yyh9tf1/m8Z5QpQbWeVRwi27/+eu7f3Ljy1FVHRHKx+Ri35IH3mk00UTYqc0OhcHYV+HrkcvwX53a/jAdd0kLhULKpxqxjY0lm+30ITUmR4KruLj1XmjMAE4+/nNm6LuzY1y4XY9xEuUOLxZwOwEApEuQ0QYYZdQLE+EAt7PX5tde5KxEGXiBN7lUHfuB4Gy0r9lnFs3KOIGjJRZY+hmw3VcFlyg+IaaAxEHNQeiFWnkOlKBK/TVAg91uNZIXpgXIplbQPq6LLr74o7SdkAerzzTvkm1HX13WCP6L1K71ISP+fFet27dZMgB+52aHPyNmgMEdpk0v8PMy1UsRgPOcQ==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPSA id 07D541800155;
	Thu, 16 Oct 2025 17:38:35 +0000 (UTC)
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
	Pedro Barbuda <pbarbuda@microsoft.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 09/24] whpx: common: add WHPX_INTERCEPT_DEBUG_TRAPS define
Date: Thu, 16 Oct 2025 19:37:48 +0200
Message-ID: <20251016173803.65764-10-mohamed@unpredictable.fr>
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
X-Proofpoint-ORIG-GUID: UCCIHf5tKeN5wa-1OjFUKoiKpIX7YiqF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyOCBTYWx0ZWRfX5uBomq7Ui9M6
 U9cL/NpdHEziYw3FKwc4hUfvUadvGoetBu5Tck3glPKobv48eEb6meV8aa/YkJ8saF80E1rCqNi
 NV/cLDBFnDxoQafzeP6uw1wjsp9J0O6oEvFN6HaWWajmCkTFJO6n9HCpIo9Il4jRtIpPXSaKhpB
 WMRRdw2yeCuuren9Agi9zgWegM++5Zrj8J6+5/dAkHbhmepZTXKuWtXBc5cIb6eJcl29gr8/OgO
 T8AfbFTKDM+qVxjwg3yHC3N2x39tzFDRCFH6bhvWfRCvOgQBRrIuxrnXb+LNOhsV3VUdiCqZg=
X-Proofpoint-GUID: UCCIHf5tKeN5wa-1OjFUKoiKpIX7YiqF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 clxscore=1030 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2510160128
X-JNJ: AAAAAAABZvmWqyV66dGcPV1/nPVdzd6cABkqkNxFVOkuPkBAATvd720SbWTzwDMUT3ZUbEUe7yrckklOJwXhmQImZblhRO15LwuWykpf8Y/uqWZow4NWwIWIlydDAn7+DFYQ9vpuBHEB6iuE/zznNgwIWmmfFwDhgj472sZb8FiN+Yo6GvVz0LPhkIjV1WMVw02D8if3hON+aAJBLT3E3EEC6Fp2SebwmiRUi5a+0w4YQqIlAG2J4/kuv6kIsUrSQVATEgua9yNNAyMHR00XJkKMtNakeA0M7G3MVxXsm/HGn1hnJwyJGBFrrpdY7KL61kC3fTFlhBqM+/xJdNpLMO6XOManQaDE0Qd7t77G+RY37RUolM/T/3AJbe7YUIVcwv+fVzHBLp+wtGBi3CFJBd0iNf9W6hsLCnbh6AOteCkrJWXqxhwXMoGtOl/3ypfJKr2zqAOEYtXlNa38li+bHIJaWx24W7mcA3aDtakYEbeb0XZFmpp53EIccFVC6QTdnURHLZxZ2TxsooURFskoJ63jP7i/fb0CVtskidmkDSYq0/KjeZTpG5+jQsLTmENbAy/nHmHm7n0wpcB2AtR8XI4gj14Ds3FTv45zAoetYr5J/3nJ4KZlSuHIToLTsnoGnoron5Bk6ofmFZOD2tmRNxbK6SZozhiqSxlKwrZB/1kQMT9+tsS+GpYpHY8EOA0QJ4JN8tIG+ev9GZGICo3DnrS3Cc/Ultrfm3xsoJrTbXYoT2LL4iVdTm+IruVJ4RI5//JaFH0H1ylDEeGbMy18T+/fAzpUlCAPmXbV0rFZWysgs/TeHVDx34x7CvFn+I/n/aWSvxgaUeFrPqPS15sF1i+JHLRtiYqXh/oYM+yG04ENGXThlnS7R0n7UVEDotwSnj+qpra5c0rU+s7QgGZJFFG41w1BnrhFPVebvG/uX80r

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


