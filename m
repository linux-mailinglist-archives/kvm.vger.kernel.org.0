Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071AC37C30F
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 17:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbhELPRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 11:17:11 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:49139 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233423AbhELPNY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 11:13:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1620832336; x=1652368336;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=dd+cfBA8UFfC6dBFQo/XyrQ8fEmJ+IwhldFGtGJFtIU=;
  b=m8EqzTjxxfM+pZFyDTOxUJKnkFgbKCb3k8KJCFLWynWhIABS1mkQVP4b
   XnHqRUdMV8+sAVWuvmgcLoKUm9ycYxFOv/nKSoarasVINBpSgAJAU9Upl
   vINoNlli4mnx6ke2u0Bhan0TWG/UBcKJ+4Q6qZ+CR1LXvW7Jd+dFxhuxk
   c=;
X-IronPort-AV: E=Sophos;i="5.82,293,1613433600"; 
   d="scan'208";a="1007669"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 12 May 2021 15:12:04 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id AE104A24EF;
        Wed, 12 May 2021 15:12:00 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 May 2021 15:11:45 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 May 2021 15:11:45 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.82.24) by
 mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 12 May 2021 15:11:43 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v2 01/10] math64.h: Add mul_s64_u64_shr()
Date:   Wed, 12 May 2021 16:09:36 +0100
Message-ID: <20210512150945.4591-2-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210512150945.4591-1-ilstam@amazon.com>
References: <20210512150945.4591-1-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function is needed for the nested TSC scaling code where we need to
multiply the signed TSC offset with the unsigned TSC multiplier.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 include/linux/math64.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/linux/math64.h b/include/linux/math64.h
index 66deb1fdc2ef..2928f03d6d46 100644
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -3,6 +3,7 @@
 #define _LINUX_MATH64_H
 
 #include <linux/types.h>
+#include <linux/math.h>
 #include <vdso/math64.h>
 #include <asm/div64.h>
 
@@ -234,6 +235,24 @@ static inline u64 mul_u64_u64_shr(u64 a, u64 b, unsigned int shift)
 
 #endif
 
+#ifndef mul_s64_u64_shr
+static inline u64 mul_s64_u64_shr(s64 a, u64 b, unsigned int shift)
+{
+	u64 ret;
+
+	/*
+	 * Extract the sign before the multiplication and put it back
+	 * afterwards if needed.
+	 */
+	ret = mul_u64_u64_shr(abs(a), b, shift);
+
+	if (a < 0)
+		ret = -((s64) ret);
+
+	return ret;
+}
+#endif /* mul_s64_u64_shr */
+
 #ifndef mul_u64_u32_div
 static inline u64 mul_u64_u32_div(u64 a, u32 mul, u32 divisor)
 {
-- 
2.17.1

