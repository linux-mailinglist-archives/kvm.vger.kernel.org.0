Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794DA48F4EE
	for <lists+kvm@lfdr.de>; Sat, 15 Jan 2022 06:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiAOFYq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Jan 2022 00:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbiAOFYq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Jan 2022 00:24:46 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34C4C061574
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 21:24:45 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id b136-20020a621b8e000000b004bfc3cd755cso3096556pfb.4
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 21:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=O3Bf0TTbwWiK+pN1VS9A5BXaFCdd2HLfv9RV2PRcws0=;
        b=TWhHGe829cA6ubBmdnC7sRVWiX9cPSFSSEtwE4GrHwD1T6na5+OrfoVvllJtqmg04N
         YtNyNt4Bv6HzZTRPlZKGqoqPN60KwgDqrr83yWebQFHk2FDo/g6If/ygybNFyO6atkxo
         YoI/ogQz5bBUx5nHGYSmVKi4nlnRxoHp5TYN0glCuN5apvroo30kCsC3l58zIba8KDCQ
         Bd4sjkge0TZ2uECW2Oh7Oh7n1NSQMKiPXdGWbQ7+/3+eOpJiOEt3K8uIYg2Ls/W6JB4V
         uq5ZkkcKaR/FFME83Wn46UpzleNtoLyZ5eKItXUfGeUaOTBqbTFjC6rDjPGsUUyDP7Ol
         hWbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=O3Bf0TTbwWiK+pN1VS9A5BXaFCdd2HLfv9RV2PRcws0=;
        b=FBZERsvLKkpjFfxtwQ1aDLonwyZFluCUMtvtrLH+hjWvZRATZzzGdTL6c6BuYTeLwk
         8Xu7hKSpsMIsN3k42D4WjxshSYbO5uqL6gp3PwM3qpLiUzLNRNn3ZIDdffgcZlWdu7rB
         QaXYIzTeIQzX0T+AtDNo+SKafCz9pMf1XGgWoTuP99ifTkx7xm1NhXBMjsL7aVRttzCH
         ndlFLE3NY30AZ0m+N5GW1KPFVzmOpCX8v7Aoe4UwnCSbTYMh69fk1vz49nditXifFLuv
         ZLi/h3HdzI5lwxrAXeYJYU/xO/rkd629ljOZtXQIcbZ0GdEve1yI8yIa1EaXGhH7Kv1l
         tJdw==
X-Gm-Message-State: AOAM530pl6rg6pjLNu4SpNm7hNKUUPaSlURQvxDfvK53/mv8n3XnWUIz
        J0XAIuKdjc5vXu7N4cOaWr/X56KUn8oHKGZjzdI3b5oLdgRAsubUUUx+PmdALuTnO/wvzKR+BS8
        xIkiOFArwDWMjZttx29Fj+tVfuuycom2AEqXa9CeKfJZZL0SZrMyFdhD4QKVef4g=
X-Google-Smtp-Source: ABdhPJzEjTb8X1v8BYcj8h8TPk5EZ0xn5Li5wo26DsjKJV/hAbZpXotuUm1F57n2OeerkmWukOR8cBF9WLDZ4g==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a05:6a00:2306:b0:4c2:83c6:8b8d with SMTP
 id h6-20020a056a00230600b004c283c68b8dmr6190072pfh.65.1642224285353; Fri, 14
 Jan 2022 21:24:45 -0800 (PST)
Date:   Fri, 14 Jan 2022 21:24:27 -0800
In-Reply-To: <20220115052431.447232-1-jmattson@google.com>
Message-Id: <20220115052431.447232-3-jmattson@google.com>
Mime-Version: 1.0
References: <20220115052431.447232-1-jmattson@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v3 2/6] selftests: kvm/x86: Parameterize the CPUID vendor
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

