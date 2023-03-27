Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B51E6CB0A4
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 23:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbjC0V0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 17:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbjC0V0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 17:26:47 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBB5199C
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 14:26:46 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id i17-20020a056e020d9100b00325a80f683cso6905481ilj.22
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 14:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679952405;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Th/1W7rF87CYX/NucA6RvNcKlZSu6fxFybJoFD4HlH8=;
        b=TLuC9YlUVcXWftRvlrROvzHPuIw1JbCjPaE4Z7VhAPFN2MZnaJnbZbTK7dePNX/34p
         R4kiKz9z+xxrxffPNtaYLY7M/oKUJlwb0jC8ejqbyHyAjC+TJUoG1Iv4a7Jpo+0B2LBR
         Cecec6sBNFSwAsra+AZwM5wlTuJs7eMUbkU74+jBJ3kX8kmjBlHBjZEh8xEZKg4MepFs
         WUVs0nfb8sa681OGXsQ2fif6tWnuxAZJI8CUM4zT7m7fE16vdJC7ZUVCI+ZC9q1CDja6
         zzpSeEvoMi+CEixFmdVpd63NTiws1/21yb+VIvIFL2f1LeWNQ2JeZT6iLLEZ4HOcoiDf
         wOxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679952405;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Th/1W7rF87CYX/NucA6RvNcKlZSu6fxFybJoFD4HlH8=;
        b=Q51k/X+LgkzambgR8jOgcKCqH5MXo5mxx1ixwHbadnSsHL96127iR8f5M43fFpaDzC
         2n1/um1ZNtXWZ33oit1U/t49Prdw6WVtRYERMM6yAPdCjye8xNiIXbuYAGaoTkEU2jrx
         tfQHDpkIyfB4zVirXxcXSNA2HuW5oQwNIa0PscuF5VdUHq11/xnMUuiw4ssmxcvJl2Oq
         5rahFH/E3Sf2fztylsWR2Kr0j4wfTGcQRxfuJ1hMvS8WebMpHLbuTNuNHjzE0odSmRxm
         o+9nzyPqdRuHFwYWlibqhmesxdZqZ5y0yeFQCNpn5OiT1CfMIAO37Un925t1btbHQUEL
         DJpw==
X-Gm-Message-State: AO0yUKUTjkHj9yosVcOCJa9nnYYWhj+6MKZONl+kYLTc7RjpuzLeRil0
        sycfqYfjfXnVdFhzvCg/U7mkJ//z8euypYvoLw==
X-Google-Smtp-Source: AK7set8/Fpok2rExDH52ywAlkRyHmg2+SpuQiTDARRmrZvEl8oo+LdxyRW60Dj/u1FpjjkIafY4+edCM+n/U7mTcow==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a02:85c5:0:b0:406:29c8:2d7c with SMTP
 id d63-20020a0285c5000000b0040629c82d7cmr4966142jai.5.1679952405360; Mon, 27
 Mar 2023 14:26:45 -0700 (PDT)
Date:   Mon, 27 Mar 2023 21:26:34 +0000
In-Reply-To: <20230327212635.1684716-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20230327212635.1684716-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230327212635.1684716-2-coltonlewis@google.com>
Subject: [PATCH v3 1/2] KVM: selftests: Provide generic way to read system counter
From:   Colton Lewis <coltonlewis@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Marc Zyngier <maz@kernel.org>, Ben Gardon <bgardon@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide a generic function cycles_read to read the system counter from
the guest for timing purposes and a helper cycles_to_ns to convert to
nanoseconds. cycles_to_ns may overflow if the cycles argument goes
above 10 billion, but that is far outside the intended use of these
functions and different timing instruments should be
used. clocks_calc_mult_shift could be used to solve this problem, but
importing clocksource code here was annoying.

Substitute the previous custom implementation of a similar function in
system_counter_offset_test with this new implementation.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h       |  3 +++
 .../selftests/kvm/include/x86_64/processor.h        |  3 +++
 tools/testing/selftests/kvm/lib/aarch64/processor.c | 12 ++++++++++++
 tools/testing/selftests/kvm/lib/x86_64/processor.c  | 13 +++++++++++++
 .../selftests/kvm/system_counter_offset_test.c      | 10 ++--------
 5 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 5f977528e09c..f65e491763e0 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -216,4 +216,7 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,

 uint32_t guest_get_vcpuid(void);

+uint64_t cycles_read(void);
+uint64_t cycles_to_ns(struct kvm_vcpu *vcpu, uint64_t cycles);
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 53ffa43c90db..5d977f95d5f5 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1134,4 +1134,7 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 #define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
 #define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)

+uint64_t cycles_read(void);
+uint64_t cycles_to_ns(struct kvm_vcpu *vcpu, uint64_t cycles);
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 5972a23b2765..5475a7e98d41 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -8,6 +8,7 @@
 #include <linux/compiler.h>
 #include <assert.h>

+#include "arch_timer.h"
 #include "guest_modes.h"
 #include "kvm_util.h"
 #include "processor.h"
@@ -551,3 +552,14 @@ void vm_vaddr_populate_bitmap(struct kvm_vm *vm)
 	sparsebit_set_num(vm->vpages_valid, 0,
 			  (1ULL << vm->va_bits) >> vm->page_shift);
 }
+
+uint64_t cycles_read(void)
+{
+	return timer_get_cntct(VIRTUAL);
+}
+
+uint64_t cycles_to_ns(struct kvm_vcpu *vcpu, uint64_t cycles)
+{
+	TEST_ASSERT(cycles < 10000000000, "Conversion to ns may overflow");
+	return cycles * NSEC_PER_SEC / timer_get_cntfrq();
+}
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index ae1e573d94ce..adef76bebff3 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1270,3 +1270,16 @@ void kvm_selftest_arch_init(void)
 	host_cpu_is_intel = this_cpu_is_intel();
 	host_cpu_is_amd = this_cpu_is_amd();
 }
+
+uint64_t cycles_read(void)
+{
+	return rdtsc();
+}
+
+uint64_t cycles_to_ns(struct kvm_vcpu *vcpu, uint64_t cycles)
+{
+	uint64_t tsc_khz = __vcpu_ioctl(vcpu, KVM_GET_TSC_KHZ, NULL);
+
+	TEST_ASSERT(cycles < 10000000000, "Conversion to ns may overflow");
+	return cycles * NSEC_PER_SEC / (tsc_khz * 1000);
+}
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
2.40.0.348.gf938b09366-goog
