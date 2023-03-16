Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B416BDBAD
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 23:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjCPWaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 18:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjCPW35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 18:29:57 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75063E617
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 15:29:24 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e20-20020a25d314000000b00b33355abd3dso3289511ybf.14
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 15:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679005756;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rdMMJ4C/XDxool2imnI+1/FM88Mvl6LyVHBQdwZLFjc=;
        b=Nr9/rj8K9NXyEOF6USXfyRXILdxpBNc3vPuP7W1PWRzLPDze5c7vxo1tPfCmbX2yCm
         3gvJo1GtxNdD6KlZpD0OQKuFfWS7da4+sVRhUMhz01R+2sdUIT7Ai9yzg4l0HC5NCy8l
         q8btITsXWQUUx9Rb/SlfSxb+NQZ3t9hvfTS5seDfip13AR/QLPjEocQsRaDGhSwVNaOa
         8Vz57xqzK8IiaAD51abRDZ5B7KNhwOcxF/NG21ek4tlGigfx9yyCMGRnUvBMtLA5Dj6U
         b9SLzh5g8CG2JBzODH6jBvtjDcg1W6+kCBMK15cpOJvM9j++AI4mHf/lrs0GIG2lf9a9
         2Ndg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679005756;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rdMMJ4C/XDxool2imnI+1/FM88Mvl6LyVHBQdwZLFjc=;
        b=GebO7jRGSeZKHFOIJNl7SVwHHPsl6Kmb/FYhJw8h8W0l4B9ipbKkvcY+gAz1O+2y2a
         mgROH5SFxL/Sijhhr6AriDkw3M1OVRZMnyiHiP6O/hlI+Es/8JPnPWOUfZhk6SYK4J0R
         E3mJNwych3IS4pUlAPMx9YJg1g5xmHfAur4uQdibz5hhSvsp4mcha6FZNdFHZTrgq56k
         +iE6dWgFpxSKIiJ2sB0hm8+5LCZqCNyQG8xpz8ip7lmMkX/XQCfhT35C3dQe+PquJ27k
         oa4XF2U+85SIlcf/+FzX41sDV5tWWzi1n747RRSooj6DWDTNaaXHaXUUNEZsZFRn5bp7
         w6iw==
X-Gm-Message-State: AO0yUKUoqCBNtTlK3fg8S0dGlcML2ccVUiIUg2tl56CuMrdGu0GWEuf2
        bWvnIIdLc4ojBWyNTZxxWnVcX/MPirXWxJjplA==
X-Google-Smtp-Source: AK7set/pLRS9lhx8sjb4QPPRwDUcv8VtMBfD3NVrjr6iDl2U74Vas3hBmUAFY8FLF3NGv4BHZ+ZdYDJ4vXG9oXSiow==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:208:b0:9fe:195a:ce0d with
 SMTP id j8-20020a056902020800b009fe195ace0dmr24248060ybs.10.1679005755986;
 Thu, 16 Mar 2023 15:29:15 -0700 (PDT)
Date:   Thu, 16 Mar 2023 22:27:51 +0000
In-Reply-To: <20230316222752.1911001-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20230316222752.1911001-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230316222752.1911001-2-coltonlewis@google.com>
Subject: [PATCH v2 1/2] KVM: selftests: Provide generic way to read system counter
From:   Colton Lewis <coltonlewis@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Colton Lewis <coltonlewis@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Marc Zyngier <maz@kernel.org>, Ben Gardon <bgardon@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide a generic function to read the system counter from the guest
for timing purposes. A common and important way to measure guest
performance is to measure the amount of time different actions take in
the guest. Provide also a mathematical conversion from cycles to
nanoseconds and a macro for timing individual statements.

Substitute the previous custom implementation of a similar function in
system_counter_offset_test with this new implementation.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  | 15 ++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 30 +++++++++++++++++++
 .../kvm/system_counter_offset_test.c          | 10 ++-----
 3 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index c9286811a4cb..8b478eabee4c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -10,4 +10,19 @@
 #include "kvm_util_base.h"
 #include "ucall_common.h"

+#if defined(__aarch64__) || defined(__x86_64__)
+
+uint64_t cycles_read(void);
+double cycles_to_ns(struct kvm_vcpu *vcpu, double cycles);
+
+#define MEASURE_CYCLES(x)			\
+	({					\
+		uint64_t start;			\
+		start = cycles_read();		\
+		x;				\
+		cycles_read() - start;		\
+	})
+
+#endif
+
 #endif /* SELFTEST_KVM_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 3ea24a5f4c43..780481a92efe 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2135,3 +2135,34 @@ void __attribute((constructor)) kvm_selftest_init(void)

 	kvm_selftest_arch_init();
 }
+
+#if defined(__aarch64__)
+
+#include "arch_timer.h"
+
+uint64_t cycles_read(void)
+{
+	return timer_get_cntct(VIRTUAL);
+}
+
+double cycles_to_ns(struct kvm_vcpu *vcpu, double cycles)
+{
+	return cycles * (1e9 / timer_get_cntfrq());
+}
+
+#elif defined(__x86_64__)
+
+#include "processor.h"
+
+uint64_t cycles_read(void)
+{
+	return rdtsc();
+}
+
+double cycles_to_ns(struct kvm_vcpu *vcpu, double cycles)
+{
+	uint64_t tsc_khz = __vcpu_ioctl(vcpu, KVM_GET_TSC_KHZ, NULL);
+
+	return cycles * (1e9 / (tsc_khz * 1000));
+}
+#endif
diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
index 7f5b330b6a1b..44101d0fcb48 100644
--- a/tools/testing/selftests/kvm/system_counter_offset_test.c
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -39,14 +39,9 @@ static void setup_system_counter(struct kvm_vcpu *vcpu, struct test_case *test)
 			     &test->tsc_offset);
 }

-static uint64_t guest_read_system_counter(struct test_case *test)
-{
-	return rdtsc();
-}
-
 static uint64_t host_read_guest_system_counter(struct test_case *test)
 {
-	return rdtsc() + test->tsc_offset;
+	return cycles_read() + test->tsc_offset;
 }

 #else /* __x86_64__ */
@@ -63,9 +58,8 @@ static void guest_main(void)
 	int i;

 	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
-		struct test_case *test = &test_cases[i];

-		GUEST_SYNC_CLOCK(i, guest_read_system_counter(test));
+		GUEST_SYNC_CLOCK(i, cycles_read());
 	}
 }

--
2.40.0.rc1.284.g88254d51c5-goog
