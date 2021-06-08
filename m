Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12AB83A0666
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 23:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234742AbhFHVu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 17:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234749AbhFHVur (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 17:50:47 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EC1C061787
        for <kvm@vger.kernel.org>; Tue,  8 Jun 2021 14:48:42 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id w1-20020ac87a610000b02902433332a0easo10224826qtt.0
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 14:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=67DO9q/Kcpbvyzcr1mvzFYjXWQVENF8Dem27uU+5fps=;
        b=QRW0mdlazXmqwpTtBWy7gVO2Vsqzm0otOCoz8nuttjFrKwU3ub0Iu5e1zlq3zfhm47
         kr/+jX+ynlTMJpj9DSXjzfaGXc1LPOGlTQo9pGayczFTLEFXJIhXNukAq9GRVvrtuPGo
         AfSqLIZMes0c/emJ+lFgjrAdAqb+4+9OKXMHn7gpXK3/gnJQRjCRb+7ysIivX6tx64jN
         IN2WmWEXpAQs9SpbLHd4Yqdey4MDGBMRiXtWAZZciVWk9YrRMhk8PZjlnBWeCQnxoeZi
         tJq6j6DbTuOySOcAvcOcgyGFruy5fiBQtOu8l7qfv4mg3UgD+JEz1yeJ6oyHfCsa1eyR
         uHWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=67DO9q/Kcpbvyzcr1mvzFYjXWQVENF8Dem27uU+5fps=;
        b=ZiDizrYGsKrOavl2x/uv+XrnAxoU9I+L2mi6LaZZ6CbZ4iI4tutBVZa+31hEUkrJ62
         DNa+lYXgTXqJbzucxc1n3dGXLTw6wCZXw6iCj2rMPVl12SnmshSv64L/SYz/6DUY/gkn
         c40wkMWxW7jneB0l607C2cPbaCrlCxYWmfkXjN3AVDrbI4pFgTNXKpRPg58sE6cLuK2M
         G84UOK1MOkN6F5lSlNnS71rmX1tdF+lOJLycuwX5Qs4krwTHMFNF26v9bYi2WwwzB31w
         4cW9rz/hEpuDT99QpkSZKfkbaGyQNuWmG4vdxs4vuqbG+Jh18+h8k8Q0Qv3E2SuSztdU
         nVIA==
X-Gm-Message-State: AOAM533rjepCWhO9l6nE1THhTq1HDW/iqKndCCBPwjMsSBXUmIYFv4s9
        gx9lSu612KxwtA5qj4zxutDyUZoiIIAwOCm3vn8ebgQOKN5je2DC7VOGMdItw06ZpzuYtAqq4kw
        jb3IS/0c5hlP6VTGcoZOXwSKRkXn5ZysosL5Exqu6cX3Uy/qcjQo2GM6eRg==
X-Google-Smtp-Source: ABdhPJyg1Wey+rmDumCpN1DSiKtE3tz1DCSq/H8NM9+D8wklMqy8ucTb5VDFwusjuwissOIoFQe/WoKO0aI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:10:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:ad4:4863:: with SMTP id u3mr2132928qvy.7.1623188921468;
 Tue, 08 Jun 2021 14:48:41 -0700 (PDT)
Date:   Tue,  8 Jun 2021 21:47:41 +0000
In-Reply-To: <20210608214742.1897483-1-oupton@google.com>
Message-Id: <20210608214742.1897483-10-oupton@google.com>
Mime-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 09/10] selftests: KVM: Add support for x86 to system_counter_state_test
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test that userspace manipulation of the tsc offset (via
KVM_{GET,SET}_SYSTEM_COUNTER_STATE) results in the expected guest view
of the TSC.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/system_counter_state_test.c | 32 +++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c2e5a7d877b1..28207474c79c 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -76,6 +76,7 @@ TEST_GEN_PROGS_x86_64 += kvm_page_table_test
 TEST_GEN_PROGS_x86_64 += memslot_modification_stress_test
 TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
+TEST_GEN_PROGS_x86_64 += system_counter_state_test
 
 TEST_GEN_PROGS_aarch64 += aarch64/counter_emulation_benchmark
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
diff --git a/tools/testing/selftests/kvm/system_counter_state_test.c b/tools/testing/selftests/kvm/system_counter_state_test.c
index f537eb7b928c..9dcbc95bba3f 100644
--- a/tools/testing/selftests/kvm/system_counter_state_test.c
+++ b/tools/testing/selftests/kvm/system_counter_state_test.c
@@ -138,6 +138,38 @@ static uint64_t host_read_guest_counter(struct system_counter_state_test *test)
 	return r;
 }
 
+#elif __x86_64__
+
+/* no additional information required beyond the counter state. */
+#define system_counter_state_test kvm_system_counter_state
+
+static struct system_counter_state_test test_cases[] = {
+	{ .tsc_offset = 0 },
+	{ .tsc_offset = 1000000 },
+	{ .tsc_offset = -1 },
+};
+
+static void pr_test(struct system_counter_state_test *test)
+{
+	printf("tsc_offset: %lld\n", test->tsc_offset);
+}
+
+static struct kvm_system_counter_state *
+get_system_counter_state(struct system_counter_state_test *test)
+{
+	return test;
+}
+
+static uint64_t guest_read_counter(struct system_counter_state_test *test)
+{
+	return rdtsc();
+}
+
+static uint64_t host_read_guest_counter(struct system_counter_state_test *test)
+{
+	return rdtsc() + test->tsc_offset;
+}
+
 #else
 #error test not implemented for architecture being built!
 #endif
-- 
2.32.0.rc1.229.g3e70b5a671-goog

