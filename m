Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 483EF48E216
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 02:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238624AbiANBVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 20:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236016AbiANBVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 20:21:22 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADBAC061574
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 17:21:21 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id k1-20020a63d841000000b003417384b156so921225pgj.13
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 17:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=O3Bf0TTbwWiK+pN1VS9A5BXaFCdd2HLfv9RV2PRcws0=;
        b=IP3Low5hfp6PpzyxwuoklMkKSQJPGJHOMSaZBevgcEfCr3yFF2j6HUUOIlIsbTDLDx
         tBs65GZ21f3ZqMg9d4DeBSrXCHAn4NRq0T6jdVhE45TcsSWlH0Poe/4FC10kF+x5Uck4
         e+2y+zY4XTA8k5RrjZmXMoB9Mgt5es5YQTY5YZOPjZJzbvXvDmMCbqTTCii4/FFW3fBQ
         hHKN4Xd08y8TAFtP9ujHnbU1ElBgyHNnjTtri+L9qBB7SVJncwHdHh57UaXiXcftGso8
         Z+7OkQbV6bMjq4qwZW9J7fRY//LgAsgaUXIqZdN1zlHXqXhEdt9UMP31mPL2Nw4iD0rX
         aluQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=O3Bf0TTbwWiK+pN1VS9A5BXaFCdd2HLfv9RV2PRcws0=;
        b=KlJF1E2dxG948FlBYDP+X9PemWSgBmZYF2e9ddIdEdhqRNv1rjBrZxYlUwcr3FQEsH
         EX7NBdUuHuGtiLGEDCDNrjLwtnJP83JQaTJn5p0yOg67qLDbuNz4YgD/Lq2r/4R5d8EF
         GBJYW5i+qd3SLRF14ldsAOyr6tmPqBPKolw8ilAvQi1a5KC4CwQIB5S2COJr721OX7wY
         FPwNThYIPOV9xHhWnaH5jDYOtMrTmfdy7L5/OgZ3iEV+gm93M4yhkPgPaZAJ5AxKGH4P
         MvFW1OdouJ9UfDuV+5YbOZ48j8JUBeCAC3dFranwCZorgFygG9smO7bFo/zWTqXQOAmO
         i0qQ==
X-Gm-Message-State: AOAM532Whgiaf5QL5SPqw1XrMlyr1L8NEdPwG7G+X9LRWh51h7yWH3Nt
        quyBrMbBaa1DMxpL46cz8v9lPKbzRlrkjT8FJF39MjALEVbFbfAPEkLINj3W6FAR1ZpE78j66EP
        maVytm3HOFSyV5hMyga8hSnkYcTYM/BllfSd491MUQMWnsDuVHWlv5k83mpmaePM=
X-Google-Smtp-Source: ABdhPJzLA5lkCdFZ1WxRqJCgb+doO+TIGy4alJYMRTqXWq6Vqi/Vyr8X9EYrz8001RcMniMqa0ygmq67rUTohQ==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:902:6bc1:b0:149:7c61:ad31 with SMTP
 id m1-20020a1709026bc100b001497c61ad31mr7383908plt.93.1642123281065; Thu, 13
 Jan 2022 17:21:21 -0800 (PST)
Date:   Thu, 13 Jan 2022 17:21:05 -0800
In-Reply-To: <20220114012109.153448-1-jmattson@google.com>
Message-Id: <20220114012109.153448-3-jmattson@google.com>
Mime-Version: 1.0
References: <20220114012109.153448-1-jmattson@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 2/6] selftests: kvm/x86: Parameterize the CPUID vendor
 string check
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        daviddunn@google.com, cloudliang@tencent.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor is_intel_cpu() to make it easier to reuse the bulk of the
code for other vendors in the future.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index eef7b34756d5..355a3f6f1970 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1198,10 +1198,10 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
 	}
 }
 
-bool is_intel_cpu(void)
+static bool cpu_vendor_string_is(const char *vendor)
 {
+	const uint32_t *chunk = (const uint32_t *)vendor;
 	int eax, ebx, ecx, edx;
-	const uint32_t *chunk;
 	const int leaf = 0;
 
 	__asm__ __volatile__(
@@ -1210,10 +1210,14 @@ bool is_intel_cpu(void)
 		  "=c"(ecx), "=d"(edx)
 		: /* input */ "0"(leaf), "2"(0));
 
-	chunk = (const uint32_t *)("GenuineIntel");
 	return (ebx == chunk[0] && edx == chunk[1] && ecx == chunk[2]);
 }
 
+bool is_intel_cpu(void)
+{
+	return cpu_vendor_string_is("GenuineIntel");
+}
+
 uint32_t kvm_get_cpuid_max_basic(void)
 {
 	return kvm_get_supported_cpuid_entry(0)->eax;
-- 
2.34.1.703.g22d0c6ccf7-goog

