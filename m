Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFE3391F6C
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 20:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235623AbhEZSrL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 14:47:11 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:22678 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235617AbhEZSrK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 14:47:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622054740; x=1653590740;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=sW6q6a1qkX3PL1z996fWyaWYV5ymVTiEkWEeojNa364=;
  b=qeAFtX4DN15USMWpbJvdHfzy7OIw65iwedgGldbpWMJ5gwYhUgC9U8ui
   2adzRQszxskQbz4ubsYWg58Vp5FQ9chbJOecyVywlQjVVLHFcLzGpLs4Z
   P/m/lz8T4NgyWnTbzE79D+zMCzCrILB2p5lgpdCfXuT2uyRdkuxmR1aAJ
   8=;
X-IronPort-AV: E=Sophos;i="5.82,331,1613433600"; 
   d="scan'208";a="114842626"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 26 May 2021 18:45:32 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id 8F5EDA1808;
        Wed, 26 May 2021 18:45:30 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 18:45:30 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 18:45:29 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.82.24) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Wed, 26 May 2021 18:45:28 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v4 01/11] math64.h: Add mul_s64_u64_shr()
Date:   Wed, 26 May 2021 19:44:08 +0100
Message-ID: <20210526184418.28881-2-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210526184418.28881-1-ilstam@amazon.com>
References: <20210526184418.28881-1-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function is needed for KVM's nested virtualization. The nested TSC
scaling implementation requires multiplying the signed TSC offset with
the unsigned TSC multiplier.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
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

